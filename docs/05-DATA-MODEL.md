# 05 — Modèle de données et invariants

## Entités proposées

| Table | Colonnes clés | Règles |
|---|---|---|
| `categories` | id UUID, slug unique, name_fr, sort_order, is_visible | catégories ordonnées |
| `products` | id, sku unique, category_id, name_fr, description_fr, price_minor INT, image_path, is_visible, is_available, created_at | `price_minor >= 0`; pas de hard delete de produits commandés |
| `modifier_groups` | id, name_fr, min_select, max_select, is_active | groupes d'options validés |
| `modifiers` | id, group_id, name_fr, price_delta_minor INT, is_active | surcharge serveur |
| `product_modifier_groups` | product_id, group_id | lien d'éligibilité explicite |
| `business_settings` | singleton, ordering_enabled, lead_time_min, slot_interval_min, max_orders_per_slot, timezone | config contrôlée |
| `opening_hours` | weekday, open_local, close_local, is_closed | fuseau métier ; gérer fermeture après minuit si validée |
| `opening_exceptions` | local_date, open_local, close_local, is_closed, reason | fêtes / fermeture exceptionnelle |
| `orders` | id UUID, public_number unique, tracking_token_hash unique, idempotency_key unique, customer_name, customer_phone, pickup_at_utc, status, payment_method, payment_status, subtotal_minor, total_minor, note, created_at, updated_at | aucune donnée bancaire ; état cohérent |
| `order_items` | id, order_id, product_id nullable, sku_snapshot, name_snapshot, unit_price_minor, quantity, line_total_minor | noms/prix figés |
| `order_item_modifiers` | id, order_item_id, modifier_id nullable, name_snapshot, delta_minor, quantity | options figées |
| `order_status_events` | id, order_id, from_status, to_status, actor_id nullable, reason, occurred_at | historique append-only |
| `staff_members` | auth_user_id UUID unique, role enum `admin/staff`, active, created_at | seul admin peut éditer personnel |
| `audit_events` | id, actor_id, entity_type, entity_id, action, safe_metadata, occurred_at | aucune PII sensible dans metadata |

## Invariants
1. Montants : centimes MAD **entiers** (p. ex. 6 DH = 600). Les totaux utilisent l'arithmétique entière avec contrainte DB ; prix snapshots à la validation.
2. Le client envoie `product_id`, `quantity`, IDs des modifiers éligibles ; **jamais** `unit_price` ni `total` à faire confiance.
3. Une commande est insérée avec ses lignes et le premier événement de statut dans **une seule transaction**.
4. Unique `idempotency_key` + résultat renvoyé pour les retries légitimes ; associer à une empreinte stable du payload pour refuser une réutilisation avec contenu différent.
5. Vérifier toutes quantités (1..limite métier), options autorisées, prix, disponibilité, capacité et horaires au moment de la création, sans race condition de créneau.
6. Protection des données sensibles : privilégier un schéma privé non exposé publiquement et politiques RLS/grants explicites. Aucune table `orders` accessible librement à `anon`.
7. Pour le suivi public, seul un jeton aléatoire à forte entropie donne accès à un statut minimal ; stocker idéalement son **hash** et comparer côté serveur. Ne pas exposer nom/téléphone.
8. Les changements admin contrôlent `updated_at`, acteur et audit ; ne jamais réécrire l'historique d'une commande.
9. Soft delete / désactivation des produits référencés par des commandes ; pas de cascade détruisant l'historique.
10. Index sur status + created_at, pickup_at, category + sort_order, token_hash, idempotency_key.

## Transactions à concevoir

### Création de commande
Fonction transactionnelle serveur/Postgres : lock/protection capacité créneau, calcul lignes/options, insert orders+items+modifiers+event, commit, puis **après commit** notification éventuelle hors transaction. Si événement externe échoue, commande conservée et retry contrôlé.

### Transition de statut
UPDATE conditionnel sur statut actuel + insertion événement atomique ; l'API renvoie conflit (`409`) si la commande a changé entre deux actions.

## Migrations & seed
- Migrations SQL incrémentales versionnées, jamais modifier une migration déjà appliquée en prod.
- Seed démonstration distinct des données réelles ; le fichier `docs/03-MENU.md` reste la référence des 17 lignes à valider.
- Tests SQL/RLS démontrant qu'un utilisateur anonyme ne lit ni ne modifie les commandes/PII.

## Décisions ouvertes
Téléphone obligatoire ou email ; gestion produits allergènes, politique rétention des commandes, taxes, moyen de paiement. Référence `docs/11-DECISIONS.md`.

## Fondation SQL T-003

Migration : `supabase/migrations/20261106000100_initial_schema.sql`. Les 5 tables catalogue sont dans `public`, les 9 tables sensibles dans `app_private` (non exposé par la configuration API). `products.sort_order` complète l'index de tri prévu. `products.validation_status` et `modifier_groups.validation_status` distinguent `provisional` de `confirmed` ; une entrée provisoire ne peut pas être publiée/activée. `image_path` reste nullable.

`orders.payload_hash` est obligatoire pour préparer la liaison d'idempotence au contenu. Hashs suivi/payload : SHA-256 hexadécimal, 64 caractères ; aucun token brut persistant. `currency` est contrainte à `MAD`, montants SQL `integer`, dates d'événements `timestamptz`. Les FK historiques utilisent RESTRICT ; les lignes et événements refusent UPDATE/DELETE par trigger. La fonction de rôle personnel est privée, à chemin vide, liée à `auth.uid()` et au flag `active`.

Tous les rôles API, y compris `service_role`, sont privés de mutations directes sur ces tables. Les lectures catalogue confirmé et personnel autorisé sont préparées avec grants SELECT et RLS ; la gestion serveur des rôles/mutations n'est pas livrée par ce ticket. Les contrôles transactionnels inter-tables (prix/options/totaux exacts, capacité, insertion avec événement initial), transitions et audits des futures actions restent à implémenter dans leurs tickets avant toute ouverture.

Le singleton paramètres commence fermé, délais/capacité NULL ; pas d'horaires réels ni de personnel seedés. Le seed est une démonstration explicite et idempotente, sans écrasement ; il est désactivé par défaut. Les limites quantitatives métier et les horaires après minuit restent non validés. Les tests et leur procédure réelle d'exécution locale sont décrits dans le README ; un contrôle statique ne vaut pas validation DB.
