# 07 — Contrats API & serveur (proposition)

Les noms d'endpoints peuvent évoluer, mais les **invariants** doivent rester. Toujours utiliser Zod au périmètre serveur, appliquer rate limiting et retourner des codes d'erreur stables. Pas de messages d'erreur exposant données internes.

## API publiques

### GET `/api/catalog`
Retourne uniquement catégories et produits visibles, disponibilité, options autorisées, prix affichables. Peut être remplacé par chargement serveur de page si plus simple.

### POST `/api/orders`
**Payload conceptuel** :
```json
{
  "idempotencyKey": "uuid-generated-in-browser",
  "customer": {"name":"Exemple", "phone":"+212..."},
  "pickupAt": "ISO8601-with-timezone",
  "items": [{"productId":"uuid", "quantity":2, "modifierIds":[]}],
  "note": "optional"
}
```
Ne pas accepter de champs `price` ou `total` en source de vérité. Tous les IDs/quantités/options/horaires sont revérifiés et pricés à partir du serveur. Coordonner RLS, transaction, verrouillage capacité et clé idempotente.

**Succès** `201` ou retry équivalent : `{ publicNumber, trackingToken, status, pickupAt, totals: {subtotalMinor, totalMinor, currency:'MAD'} }`. Ne jamais exposer la clé `service_role` ; n'enregistrer que le hash du tracking token en base.

**Erreurs** : `400 INVALID_INPUT`, `409 PRICE_CHANGED`, `409 OUT_OF_STOCK`, `409 SLOT_UNAVAILABLE`, `409 ORDERING_CLOSED`, `429 RATE_LIMITED`, `503 TEMPORARY_UNAVAILABLE`.

### GET `/api/orders/track/[token]`
Retourne seulement `publicNumber`, `status`, `pickupAt`, message et éventuellement le total ; aucune PII. `no-store`, rate limit, `404` générique pour token inconnu.

## API admin (auth + autorisation dans chaque mutation)
- `GET /api/admin/orders?status=pending` : liste paginée, PII minimale pour la préparation.
- `PATCH /api/admin/orders/[id]/status` : `{expectedStatus, nextStatus, reason?}` ; transition conditionnelle transactionnelle, `409` si conflit.
- `POST/PATCH /api/admin/products` : validation nom, prix centimes, catégorie, visibilité et options.
- `PATCH /api/admin/settings` : horaires, créneaux et `orderingEnabled` ; rôle admin uniquement.
- Stockage images : upload autorisé uniquement au rôle admin, MIME/poids contrôlés, chemin sécurisé, transformation images.

## Observabilité
Journaliser request ID, type d'erreur, latence et id de commande technique lorsque nécessaire, **jamais** le corps du checkout, numéro de téléphone, tracking token, headers d'auth ou secrets.

## Tests de contrat
Payload incomplet, XSS, quantités > max, IDs invalides, options interdites, prix client falsifiés, fermeture pendant checkout, double requête simultanée, admin non autorisé, état obsolète, token suivi non devinable. Les tests doivent couvrir 401/403/404/409/429.
