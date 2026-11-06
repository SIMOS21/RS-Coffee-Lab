# Backlog exécutable pour Codex

Les statuts courants figurent sous chaque ticket ; T-017/T-018 sont bloqués par décision métier. Ne pas cocher sans vérification réelle des critères (revue documentaire pour T-000). Une seule tâche active par branche, sauf dépendances techniques strictement nécessaires. `AGENTS.md` s'applique toujours.

## Format des comptes rendus
Après chaque ticket, renseigner : `Status: DONE|BLOCKED`, `Branch/PR`, `Files`, `Tests (command + résultat)`, `Known risks`, `Follow-up`. Aucun ticket ne passe DONE si critères d'acceptation non vérifiés.

## PHASE 0 — Cadrage

### T-000 — Revue du dossier et inventaire des hypothèses
- **Dépendances :** aucune.
- **Objectif :** lire les documents, identifier contradictions et questions bloquantes.
- **Critères d'acceptation :** table de décisions consolidée ; aucun fait non vérifié implémenté comme réel ; mode commandes fermé par défaut en absence de configuration.
- **Tests :** revue documentaire.
- **Status :** DONE (2026-11-06, revue documentaire uniquement).
- **Branch/PR :** aucune ; `git status --short` échoue car aucun dépôt Git n'est détecté. Aucun commit créé.
- **Files :** `docs/11-DECISIONS.md` (consolidation D-01..D-20, audit A-01..A-10, prérequis et plan de PR), `docs/04-ARCHITECTURE.md` (contrat commandes fermées par défaut), `tasks/TASKS.md` (présent compte rendu et clarification des statuts).
- **Tests (command + résultat) :** lecture UTF-8 via `Get-Content` de `AGENTS.md`, `README.md`, `tasks/TASKS.md`, `prompts/CODEX-KICKOFF.md` et des 12 fichiers `docs/` ; inventaire `rg --files --hidden` ; revue croisée du menu (17 références), des décisions et dépendances ; vérification documentaire et liens locaux par PowerShell : réussies. `Get-Command node,pnpm,git` : exécutables détectés, compatibilité non vérifiée. `pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build`, `pnpm test:e2e` non exécutés : aucun `package.json` ni script (configuration à partir de T-001, E2E ensuite).
- **Known risks :** aucune décision métier approuvée, aucun média source présent ; incohérences techniques à résoudre dans les tickets indiqués au registre. Fermeture par défaut vérifiée comme contrat documentaire uniquement : aucune application ni DB à tester. Aucun fait métier non vérifié implémenté.
- **Follow-up :** T-001 recommandé sur nouvelle consigne, avec initialisation Git et vérification des versions compatibles ; aucune initialisation applicative effectuée. Les validations D-01..D-20 restent ouvertes selon leurs statuts et doivent précéder la publication/l'activation concernée.

## PHASE 1 — Fondation

### T-001 — Initialiser Next.js et la qualité
- **Dépendances :** T-000.
- **Travail :** App Router, TypeScript strict, Tailwind, shadcn/ui, pnpm lock, ESLint, scripts lint/typecheck/test/build, `.env.example`, `.gitignore`, README dev.
- **Critères :** `pnpm lint && pnpm typecheck && pnpm test && pnpm build` réussissent ; pas de secrets committés ; versions figées compatibles.
- **Status :** DONE (2026-11-06 ; vérification visuelle non effectuée, procédure manuelle fournie selon la consigne de finalisation).
- **Branch/PR :** `feat/t-001-foundation`, conservée et vérifiée avant/après les contrôles. Dépôt initialisé lors de T-001 ; aucun commit, remote ou PR créé (`git rev-list --all --count` : 0).
- **Files :** fondation créée dans `package.json`, `pnpm-lock.yaml`, `.node-version`, `.npmrc`, `.gitignore`, `.env.example`, `tsconfig.json`, `next-env.d.ts` (généré par Next), `next.config.ts`, `postcss.config.mjs`, `eslint.config.mjs`, `vitest.config.ts`, `components.json`, `src/app/{layout.tsx,page.tsx,globals.css}`, `src/components/ui/button.tsx`, `src/lib/utils.ts`, `tests/unit/foundation.test.tsx`. Finalisation : `README.md` (prérequis, installation, environnement, commandes, arborescence, versions/justifications et procédure visuelle), `tasks/TASKS.md` (ce compte rendu). Aucun changement fonctionnel supplémentaire pendant la finalisation.
- **Choix :** page française provisoire non indexable, nom de travail explicite, bouton commandes désactivé, aucune API/collecte réelle. shadcn/ui initialisé manuellement (configuration, utilitaire et primitive Button) ; Radix Slot, CVA, clsx et tailwind-merge justifiés dans le README. Aucun SDK métier ajouté sans utilisation. Aucun workflow CI ni configuration distante (T-002 non commencé).
- **Tests (command + résultat), relancés à la finalisation :**
  - `pnpm.cmd lint` : code 0, aucun avertissement ni erreur (`eslint . --max-warnings=0`). La correction PostCSS effectuée précédemment est confirmée ; aucune correction de code supplémentaire nécessaire.
  - `pnpm.cmd typecheck` : code 0, `Types generated successfully`, puis `tsc --noEmit` réussi.
  - `pnpm.cmd test` : code 0, Vitest 5.1.0, 1 fichier et 3 tests réussis (fermeture affichée sans formulaire/lien, non-indexation, surcharge des classes Tailwind).
  - `pnpm.cmd build` : code 0, Next.js 16.4.5/Turbopack, compilation et TypeScript réussis, 3/3 pages statiques générées ; routes `/` et `/_not-found`.
  - `pnpm.cmd install --offline --frozen-lockfile --store-dir .pnpm-store` : code 0, `Lockfile is up to date, resolution step is skipped`, `Already up to date`.
  - `node --version` / `pnpm.cmd --version` : `v24.13.0` / `9.15.9`. Dépendances directes exactes, lockfile cohérent, moteurs compatibles sur cette machine.
  - `git -c core.excludesFile=.git/info/exclude check-ignore` : `.env.local`, `.env.production`, `.env.test`, `node_modules/`, `.next/`, `.pnpm-store/` ignorés ; `.env.example` non ignoré. `git ls-files` vide : aucun fichier indexé. Revue locale et contrôle ciblé PowerShell de 38 fichiers source/documentation : aucun motif de clé privée, jeton à préfixe connu ou JWT détecté ; `.env.example` ne contient que des commentaires. Ce contrôle n'est pas un audit exhaustif de secrets/vulnérabilités. Le statut Git standard signale un refus de lecture du fichier global d'exclusions ; l'essai avec `NUL` a échoué, puis les vérifications ont réussi en utilisant `.git/info/exclude` pour cette seule invocation, sans modification de configuration globale.
- **Statut des critères :** quatre scripts requis PASS ; aucun secret committé PASS (aucun commit, exemple vide et exclusions contrôlées) ; versions figées compatibles PASS (versions exactes + installation figée + contrôles réussis). Tous les éléments de travail de la fondation sont présents, README développeur compris.
- **Vérifications non effectuées :** inspection visuelle, captures, responsive/zoom, clavier et console navigateur. Inventaire navigateur compatible : `The browser access host is unavailable`. Aucun contournement de la restriction Windows précédente. Procédure manuelle détaillée dans `README.md`, en remplacement autorisé par la consigne utilisateur ; aucune réussite visuelle revendiquée. `pnpm.cmd test:e2e` non exécuté : script absent, aucun parcours métier ; pas de tests DB/RLS à ce stade. Aucun audit de vulnérabilités, déploiement ou validation de contenu métier.
- **Known risks :** ESLint 9.39.5 signalé non maintenu par npm ; conservé car les plugins React/import/accessibilité vérifiés de la configuration Next n'annoncent pas ESLint 10. Réévaluer avant lancement. La matrice de versions testée est locale (Node 24.13.0/pnpm 9.15.9) ; aucun résultat CI multi-environnement revendiqué. Commandes fermées par absence de fonctionnalité ; protection transactionnelle/DB à implémenter dans les tickets prévus. Les décisions métier ouvertes de T-000 restent inchangées.
- **Follow-up :** effectuer la procédure visuelle manuelle et consigner navigateur/dimensions/captures ; T-002 est la prochaine tâche recommandée, uniquement sur nouvelle consigne. Aucun blocage des critères techniques de T-001 ; limitation d'outillage pour le contrôle visuel toujours présente.

### T-002 — Configurer CI et environnements
- **Dépendances :** T-001.
- **Travail :** GitHub Actions install/lint/typecheck/test/build, protections staging, doc setup.
- **Critères :** pipeline vert sur PR test, variables privées non exposées.
- **Status :** BLOCKED (2026-11-06 ; configuration locale terminée, validation GitHub et protections distantes en attente).
- **Branch/PR :** `feat/t-002-ci-environments`, créée depuis `4fbe368` (`chore: record validated T-001 foundation`) après relecture de T-001 et réussite de ses quatre contrôles. Les 39 fichiers de la base auparavant non suivis ont été contrôlés puis sauvegardés dans ce commit sur `feat/t-001-foundation`, sans suppression ni perte locale. Remote `origin` ajouté sur `https://github.com/SIMOS21/RS-Coffee-Lab.git` après réception de l'URL du propriétaire ; changements T-002 sauvegardés dans un commit local distinct. Aucune PR ni publication. Les écritures `.git` ont nécessité une exécution autorisée hors sandbox ; l'exception de propriété Git a été limitée au chemin exact du dépôt et à cette invocation, sans modification globale.
- **Files :** `.github/workflows/ci.yml` (créé), `scripts/check-env.mjs` et `scripts/check-env.d.mts` (créés), `tests/unit/environment-files.test.ts` (créé), `package.json` (script `check:env`), `.env.example` (contrat local/test/CI/staging/production sans secret), `README.md` (CI, configurations séparées, contrôles et procédures de protections distantes), `tasks/TASKS.md` (présent compte rendu). Aucune dépendance ajoutée et aucun changement du lockfile ni des fonctionnalités applicatives.
- **Configurations réalisées :** workflow PR/push de branche/manuel, runner Ubuntu 24.04, Node lu dans `.node-version`, pnpm lu dans `packageManager`, actions officielles figées par SHA (références v6/v6/v4 vérifiées via `git ls-remote`). Installation `--frozen-lockfile`, contrôles séquentiels, timeout 15 min, annulation du run précédent pour la même référence. Jeton limité à `contents: read`, identifiants checkout non persistés, aucun secret/environnement de déploiement injecté, aucun artefact publié. `NODE_ENV=test` pour les tests et `production` pour le build ; pas de mode Node « staging ». Aucun service externe requis, `.env.example` reste commenté, fichiers locaux réels ignorés ; garde CI sur les noms versionnables `.env*`/clés et sur le contenu de l'exemple.
- **Tests (command + résultat) :**
  - `pnpm.cmd install --offline --frozen-lockfile --store-dir .pnpm-store` : code 0, lockfile à jour et installation déjà à jour.
  - `pnpm.cmd check:env` : code 0, `Environment files: OK (no application variables required).`
  - `pnpm.cmd lint` : code 0, aucune erreur ni avertissement.
  - `pnpm.cmd typecheck` : code 0, types de routes générés puis compilation stricte sans émission réussie.
  - `pnpm.cmd test` avec `NODE_ENV=test` : code 0, Vitest 5.1.0, 2 fichiers et 12 tests réussis (3 de fondation + 9 de protection des fichiers d'environnement).
  - `pnpm.cmd build` avec `NODE_ENV=production`, `NEXT_TELEMETRY_DISABLED=1`, `TZ=Africa/Casablanca` : code 0, compilation et TypeScript réussis, 3/3 pages statiques générées, routes `/` et `/_not-found`.
  - `actionlint -shellcheck= -pyflakes= .github/workflows/ci.yml` : code 0, aucun diagnostic, version 1.7.12 téléchargée depuis la publication officielle et archive vérifiée contre son SHA-256 officiel. ShellCheck/Pyflakes non exécutés. Outil temporaire hors dépôt, aucune dépendance applicative ajoutée.
  - Analyse YAML Python/PyYAML et assertions ciblées : code 0 ; déclencheurs, lecture seule, SHA complets, fichiers de version, ordre des contrôles, absence de référence `secrets.*`/déploiement et de contournement des échecs vérifiés.
  - `git diff --check` : code 0 (avertissements Windows de conversion LF/CRLF uniquement). Contrôle Git des exclusions : `.env.local`, `.env.test`, `.env.production`, `.env.staging`, `.env.production.local`, `.vercel/`, `.pem` et `.key` ignorés, `.env.example` non ignoré. Contrôle ciblé de 43 fichiers versionnables sans motif de clé privée/jeton à préfixe connu/JWT détecté ; aucune valeur locale ignorée lue ou affichée. Ce contrôle ne remplace pas un audit exhaustif des secrets.
- **Critères vérifiés :** configuration du pipeline et exécution locale PASS ; aucune variable privée injectée ou publiée par la configuration actuelle PASS à la revue locale ; pipeline vert sur PR GitHub NON VÉRIFIÉ. Protections staging documentées mais NON APPLIQUÉES/NON VÉRIFIÉES à distance. Le ticket ne peut pas passer DONE sur les seuls résultats locaux.
- **Validations impossibles / blocages :** l'URL fournie est désormais vérifiée via le connecteur GitHub : `SIMOS21/RS-Coffee-Lab`, dépôt public, taille 0, collection de branches vide, branche par défaut déclarée `main`. La connexion dispose de `pull: true`, `push: false`, `admin: false`, donc publication et administration impossibles avec cet accès. Aucun push tenté, aucune PR ni exécution réelle observée ; protections de branche/environnements distants non configurées. Aucun compte/projet d'hébergement staging ni responsable de validation désigné. Disponibilité des protections à vérifier selon le plan GitHub/hébergeur. Le README décrit les étapes concrètes et les commandes de publication avec un accès autorisé, y compris l'accès privé aux previews ; `noindex` n'est pas une protection d'accès.
- **Known risks :** compatibilité Linux et exécution des actions non prouvées par le runner Windows local. Aucun scan exhaustif de secrets ou de vulnérabilités. Les protections GitHub/hébergeur ne peuvent pas être activées depuis le YAML seul ; aucune activation fictive déclarée. Risque ESLint 9 hérité de T-001 inchangé. Pas de déploiement, de commande réelle ni de modification métier.
- **Follow-up :** disposer d'un accès autorisé en écriture au dépôt fourni (et d'administration pour les protections), désigner les responsables, publier la base sur `main` et la branche T-002 puis obtenir le run PR vert et vérifier les protections staging ; consigner URL du run et SHA avant DONE. T-003 non commencé : sa dépendance déclarée T-001 est satisfaite ; il nécessitera une nouvelle consigne, lecture `docs/03-MENU.md`, `docs/05-DATA-MODEL.md`, `docs/08-SECURITY-PRIVACY.md`, un environnement PostgreSQL/Supabase local ou de test isolé et des tests SQL/RLS. Conserver le seed en démonstration et les commandes fermées tant que les validations métier manquent. Résoudre la validation CI distante avant d'utiliser ses résultats comme gate de qualité.

### T-003 — Base de données, RLS, migrations et seed
- **Dépendances :** T-001 ; lire `docs/03-MENU.md`, `docs/05-DATA-MODEL.md`, `docs/08-SECURITY-PRIVACY.md`.
- **Travail :** migrations, contraintes, indexes, politiques RLS, seed démo 17 références, tests SQL.
- **Critères :** DB reproductible ; refus d'accès public à orders/customer PII ; prix en centimes ; photos manquantes gérées.
- **Status :** TODO.

### T-004 — Auth personnel et RBAC
- **Dépendances :** T-003.
- **Travail :** login/logout, staff/admin, middleware d'UX sans confiance, checks serveurs, gestion erreurs.
- **Critères :** tests 401/403 ; rôle staff ne modifie pas settings ; compte inactif bloqué.
- **Status :** TODO.

## PHASE 2 — Site public

### T-005 — Design system et shell responsive
- **Dépendances :** T-001.
- **Travail :** tokens, header/mobile nav, footer, typographies, boutons, composants réutilisables.
- **Critères :** contrastes contrôlés, responsive 320px+, focus visible, aucune donnée inventée.
- **Status :** TODO.

### T-006 — Accueil, galerie et pages informatives
- **Dépendances :** T-005.
- **Travail :** hero avec photo approuvée ou placeholder, galerie, about/contact, metadata.
- **Critères :** images optimisées, informations non validées masquées, CTA utilisables, alt et SEO de base.
- **Status :** TODO.

### T-007 — Menu alimenté par la base
- **Dépendances :** T-003, T-005.
- **Travail :** catégories, cartes produits, affichage prix MAD, indisponibilités, descriptions et recherche simple si utile.
- **Critères :** 17 références seed, prix cohérents, mobile, option inconnue désactivée.
- **Status :** TODO.

## PHASE 3 — Commandes

### T-008 — Panier robuste
- **Dépendances :** T-007.
- **Travail :** ajout/suppression/quantités, stockage local versionné, UX états et panier vide.
- **Critères :** panier responsive et accessible ; calcul indicatif cohérent ; aucune confiance serveur dans montant client.
- **Status :** TODO.

### T-009 — Configurations horaires et créneaux
- **Dépendances :** T-003.
- **Travail :** timezone Casablanca, plages et exceptions, délai, capacité, pause, validation serveur.
- **Critères :** tests horaires/DST, fermeture, créneau complet, commandes OFF si config incomplète.
- **Status :** TODO.

### T-010 — Création commande transactionnelle
- **Dépendances :** T-003, T-008, T-009.
- **Travail :** Zod, serveur prix/options/dispo, transaction+snapshots, idempotency key, jeton suivi, anti-abus.
- **Critères :** QA-02 à QA-06, QA-13 et QA-14 ; race conditions couvertes, aucune écriture directe client sensible.
- **Status :** TODO.

### T-011 — Checkout et page de suivi
- **Dépendances :** T-010.
- **Travail :** formulaire invité, validations, erreurs, changement de prix, confirmation, suivi protégé sans PII.
- **Critères :** parcours E2E client, token non devinable, no-store/noindex, clavier/mobile.
- **Status :** TODO.

## PHASE 4 — Admin

### T-012 — Tableau de commandes et transitions
- **Dépendances :** T-004, T-010.
- **Travail :** liste paginée, filtres, détails, updates conditionnels, audit, statuts.
- **Critères :** 401/403, concurrency 409, transitions autorisées, test E2E personnel.
- **Status :** TODO.

### T-013 — Administration du menu
- **Dépendances :** T-004, T-007.
- **Travail :** édition produits/prix/dispo, upload contrôlé images, refresh menu.
- **Critères :** droits admin, validation prix, commandes historiques inchangées, audits.
- **Status :** TODO.

### T-014 — Paramètres et pause commandes
- **Dépendances :** T-004, T-009, T-012.
- **Travail :** horaire/créneaux/capacité, pause commande, états d'administration explicites.
- **Critères :** refus serveur des nouvelles commandes lors pause, statut dashboard visible, changements audités.
- **Status :** TODO.

## PHASE 5 — Lancement

### T-015 — Suite qualité et sécurité de bout en bout
- **Dépendances :** T-011 à T-014.
- **Travail :** QA-01..15, test charge limité, RLS, a11y/SEO, reprise, monitoring technique sans PII.
- **Critères :** aucun test critique rouge ; corrections intégrées, objectifs documentés.
- **Status :** TODO.

### T-016 — Staging, runbook, publication contrôlée
- **Dépendances :** T-015 et décisions bloquantes validées.
- **Travail :** domaine, HTTPS, env prod, restauration, parcours réel fictif, formation gérant, checklist.
- **Critères :** `docs/10-DEPLOYMENT.md` validé par propriétaire, commandes activées manuellement, pas avant.
- **Status :** TODO.

## Phase 6 — Pas dans le MVP

### T-017 — Paiement en ligne (À NE PAS COMMENCER sans choix PSP)
- Dépendance décision D-12 : contrat et documentation provider, webhook signé, idempotence paiement, rapprochement, remboursement, tests sandbox.
- **Status :** BLOCKED (business decision).

### T-018 — Livraison (À NE PAS COMMENCER sans validation logistique)
- Dépendance D-11 : zone, tarification, coursiers, horaires, contacts et responsabilité.
- **Status :** BLOCKED (business decision).
