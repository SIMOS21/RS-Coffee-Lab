# 04 — Architecture technique cible

## Choix
Monolithe modulaire TypeScript pour éviter la complexité microservices.
- **Next.js App Router** pour pages publiques, administration, mutations serveur.
- **Tailwind + shadcn/ui** pour composants cohérents.
- **PostgreSQL Supabase** pour données relationnelles ; migrations SQL versionnées.
- **Supabase Auth** pour salariés / gérant uniquement ; `staff_members` pour les rôles applicatifs.
- **Supabase Storage** pour images produit/galerie, dépôt par personnel autorisé.
- **Zod** pour entrées API/formulaires (le schéma TypeScript n'est pas une validation de sécurité).
- **Vitest / Testing Library / Playwright** pour vérification.
- **Vercel** pour héberger l'application ; config séparée preview/staging/prod.

## Principe de confiance
Navigateur non fiable → handler/action serveur avec validation, limitation de débit, règles métier et contrôle des droits → transaction DB. Les données publiées proviennent de vues/queries autorisées. Le `service_role` Supabase (s'il est nécessaire) reste **strictement serveur** et ne doit jamais permettre de contourner les contrôles applicatifs.

## Arborescence cible (après bootstrap)
```text
src/
  app/
    (site)/{page.tsx,menu/,about/,contact/,cart/,checkout/,order/}
    (admin)/admin/{login/,orders/,menu/,settings/}
    api/orders/                 création + suivi minimal
    api/admin/                  mutations protégées quand nécessaire
  components/{ui/,site/,menu/,cart/,admin/}
  features/{catalog/,cart/,orders/,availability/,staff/}
  lib/{supabase/,auth/,validation/,money/,time/,rate-limit/}
  styles/
supabase/{migrations/,seed.sql,tests/}
tests/{unit/,integration/,e2e/}
public/images/
docs/ tasks/ prompts/
```

## Règles de modules
- `features/catalog`: lecture produits publiés, catégories, addons éligibles.
- `features/cart`: modèle client non fiable, pure UI ; la DB recalculera tout.
- `features/orders`: création atomique, jeton de suivi, transitions, audit.
- `features/availability`: heures, exceptions, créneaux, capacité et pause.
- `features/staff`: RBAC, autorisation, gestion menu et commandes.
- `lib/money`: entiers de centimes MAD, formatage séparé.
- `lib/time`: conversion fiable UTC ↔ Africa/Casablanca ; tests DST.

## Données / rendu
- Pages éditoriales statiques ou revalidées ; menu revalidé au changement de prix/stock.
- Page de statut commande dynamique et non indexable ; `Cache-Control: no-store` pour toute PII.
- Dashboard privé, jamais mis en cache publiquement.
- Les modifications de prix n'altèrent pas les lignes de commandes historiques.

## Environnements
- `.env.example` créé au ticket T-001 ; aucun secret réel versionné.
- Supabase local ou projet test, DB de staging, production distincte.
- Toutes les migrations testées en local/staging, revues puis appliquées en production.
- Prévoir sauvegardes, logs techniques sans PII et rollback applicatif.

## Contrat de fermeture par défaut (revue T-000)

- `business_settings.ordering_enabled` aura un défaut DB `false`. Une ligne absente, une valeur manquante ou une configuration invalide ne doit jamais ouvrir les commandes.
- L'ouverture nécessite une activation explicite, une configuration complète et validée (horaires, exceptions, délai, intervalle, capacité, fuseau `Africa/Casablanca`) et, pour le service réel, les validations métier et la checklist de lancement. Aucune valeur d'exploitation n'est inventée pour satisfaire cette condition.
- Le serveur refuse toute nouvelle commande si la boutique est fermée/en pause ou si les conditions ne peuvent pas être vérifiées. Le frontend peut expliquer la fermeture, mais le handler de création doit la revérifier en transaction.
- L'exemple d'environnement de T-001 ne doit permettre aucune activation implicite. Le paramétrage de test reste explicite et isolé des données réelles ; aucun seed ne doit ouvrir automatiquement la production.
- Ce contrat est documentaire à T-000 : défaut et contraintes DB en T-003, configuration/horaires en T-009, refus transactionnel en T-010, pause en T-014. Tester configuration absente, invalide, désactivation pendant checkout et ouverture explicite avec configuration valide dans ces tickets.

## Décisions à documenter par ADR
Provider de paiement, disponibilité/livraison, choix des notifications, changement de stack. Ne pas substituer un service externe sans justification.
