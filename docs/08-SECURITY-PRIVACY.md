# 08 — Sécurité, confidentialité et conformité

## Risques prioritaires
- Client malveillant modifiant prix, option, quantité, créneau ou total.
- Accès non autorisé au tableau admin ou aux données d'autres commandes.
- Duplication de commande, spam, déni de service, commandes hors horaires.
- Fuite des coordonnées clients dans logs, cache, page de suivi, analytics.
- Usurpation de paiement ou webhook non vérifié (phase future).

## Mesures obligatoires
1. **RBAC serveur** : `admin`, `staff`, `public` ; vérifier session, rôle et activité côté serveur avant chaque action sensible. Les éléments masqués dans l'UI ne constituent pas une autorisation.
2. **RLS PostgreSQL** et privilèges explicites : aucune exposition `anon` des commandes ou PII ; limiter lectures catalogue ; vérifier fonctions `SECURITY DEFINER` si utilisées.
3. **Supabase service_role** uniquement en serveur et en moindre surface, jamais avec `NEXT_PUBLIC_` ; fonctions de service contrôlées.
4. **Validation entrée** : Zod + limites de taille + nettoyage des champs de texte ; requêtes paramétrées.
5. **Protection API** : limite de débit, origine/CSRF selon auth, contrôle de méthode, cookies `secure/HttpOnly/SameSite` si utilisés, anti-bot si abus réel.
6. **Transactions et idempotence** à la création d'ordre, concurrence des créneaux et statut.
7. **Jeton suivi** cryptographiquement sûr, hash persistant, noindex, cache désactivé, retour minimal ; proscrire l'incrémentation d'IDs prédictibles comme moyen d'accès.
8. **Secrets** hors Git, environnements séparés, contrôles de configuration et rotation en cas d'incident.
9. **Uploads** limités à images autorisées avec taille/MIME/max dimensions, validation du contenu, chemins non exécutables.
10. **Audit** des actions admin, sans exposer secrets ni données supplémentaires.

## Données personnelles / Maroc
Les noms, numéros et commandes sont des données personnelles. La CNDP publie des obligations de conformité des sites à la loi 09-08, de notification préalable du traitement et, selon le cas, de formalités relatives à l'hébergement/transfert hors du Maroc. Les démarches concrètes, textes publiés et durée de conservation doivent être **validés avec le responsable du commerce et un conseil qualifié avant mise en production**.

Principes produit : minimisation (nom/téléphone nécessaires au retrait uniquement), information claire avant envoi, finalité, accès/correction/suppression selon cadre applicable, politique de conservation approuvée, pas de marketing par défaut. Consentements requis à examiner par le responsable de traitement, éviter toute case pré-cochée quand un consentement est nécessaire.

**Sources officielles** :
- https://www.cndp.ma/conformite-des-sites-web/
- https://www.cndp.ma/notifier-un-traitement/
- https://www.cndp.ma/conditions/

## Avant mise en production
- Audit RLS / RBAC ; test de chaque API comme visiteur non authentifié.
- Vérification des variables d'environnement et protection déploiement preview.
- Politique de confidentialité et mentions validées.
- Plan de gestion incidents, sauvegardes, responsable nommé et procédure de récupération.
- Ne pas traiter de données de carte bancaire via les formulaires de l'application.
