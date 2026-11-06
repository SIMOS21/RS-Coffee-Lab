# Titre proposé

feat(db): ajouter la fondation Supabase avec RLS et catalogue provisoire

# Description de Pull Request

Le projet ne disposait pas de base structurée pour le catalogue et les commandes. Cette PR ajoute une migration PostgreSQL transactionnelle des 14 tables, leurs clés étrangères, index et contraintes, ainsi qu'un seed idempotent des 17 références du menu. Les prix restent en centimes MAD entiers ; les produits sont provisoires, masqués et indisponibles. Les commandes restent fermées et aucun supplément non validé n'est activé.

Les commandes, coordonnées clients, paramètres et rôles sont dans `app_private`, exclu de la Data API. Toutes les tables applicatives utilisent RLS ; aucun rôle API ne dispose de mutation directe. Les lectures personnel dépendent d'un membre actif lié à `auth.uid()`. Les snapshots et événements sont append-only. Les handlers d'authentification, création transactionnelle et transitions métier restent hors de T-003.

La PR conserve la CI et la protection des fichiers d'environnement de T-002. La PR #1 est fusionnée dans main (`ed4a6da`) ; son intégration dans T-003 a été réalisée par le merge `3538d6dad64a3cb88aab2d5b19817583080c61d4`, sans réécriture d'historique. Le conflit README a été résolu en conservant les sections CI et Supabase. Aucun fichier SQL de migration/seed ni runner DB n'a changé pendant cette intégration.

## Preuves locales après intégration

Environnement : Node 24.13.0, pnpm 9.15.9, Supabase CLI 3.0.0, Docker 29.0.1, PostgreSQL 17. Résultats du 2026-11-06 :

| Commande | Résultat |
|---|---|
| `pnpm.cmd install --offline --frozen-lockfile --store-dir .pnpm-store` | Code 0, lockfile cohérent |
| `pnpm.cmd check:env` | Code 0 |
| `pnpm.cmd lint` | Code 0, aucun avertissement |
| `pnpm.cmd typecheck` | Code 0 |
| `pnpm.cmd test` | Code 0, 2 fichiers et 12 tests réussis |
| `pnpm.cmd build` | Code 0, compilation et 3/3 pages générées |
| `pnpm.cmd db:start` | Code 0, stack locale disponible |
| `pnpm.cmd db:test` | Code 0, deux reconstructions complètes réussies |
| `pnpm.cmd exec supabase db lint` | Code 0, `No schema errors found` |
| actionlint 1.7.12, ShellCheck/Pyflakes désactivés | Code 0 |

Chaque cycle DB réapplique la migration depuis zéro, exécute le seed deux fois (6 catégories/17 produits puis 0 doublon) et les assertions SQL : contraintes, FK, unicité/idempotence, préservation historique, refus d'énumération des commandes de deux clients fictifs, refus de mutations publiques, droits staff/admin et perte d'accès du personnel inactif. Les données de test sont annulées par rollback.

Les fichiers workflow/contrôle environnement/tests T-002 ont été comparés à main et sont inchangés. Les fichiers migration/seed/tests/runner Supabase sont conservés depuis la version T-003 validée. Le compte rendu détaillé est dans `tasks/TASKS.md`.

## Limites et revue

- Les résultats DB sont locaux ; le workflow CI actuel exécute check:env, installation, lint, typecheck, Vitest et build, sans suite SQL. Aucun résultat GitHub sur cette nouvelle intégration n'est déduit des résultats locaux.
- Aucun parcours E2E, test staging/production ou déploiement distant n'a été effectué.
- Les protections staging et décisions métier ouvertes restent à valider ; les produits et prix ne deviennent pas approuvés par cette PR.
- Revoir la migration et les politiques avant toute fusion ; aucun merge automatique ni T-004 n'est inclus.
