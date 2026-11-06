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
- **Status :** TODO.

### T-003 — Base de données, RLS, migrations et seed
- **Dépendances :** T-001 ; lire `docs/03-MENU.md`, `docs/05-DATA-MODEL.md`, `docs/08-SECURITY-PRIVACY.md`.
- **Travail :** migrations, contraintes, indexes, politiques RLS, seed démo 17 références, tests SQL.
- **Critères :** DB reproductible ; refus d'accès public à orders/customer PII ; prix en centimes ; photos manquantes gérées.
- **Status :** BLOCKED (2026-11-06 ; migration/seed/tests préparés, aucune exécution PostgreSQL réussie).
- **Branch/PR :** `feat/t-003-supabase-database`, créée depuis `main` synchronisé avec `origin/main` au commit `4fbe36878bfb53abdd190d87fdf36b51565d3def`, dossier propre avant changement. Aucun changement local perdu. La PR T-002 [#1](https://github.com/SIMOS21/RS-Coffee-Lab/pull/1) est ouverte et non fusionnée ; son [run sur PR](https://github.com/SIMOS21/RS-Coffee-Lab/actions/runs/42303383948) est `success`, mais `main` reste non protégé et T-002 n'est pas déclaré validé intégralement. Branche T-003 fondée strictement sur main comme demandé, sans fusion/cherry-pick T-002 ; synchronisation à prévoir après fusion de T-002.
- **Files :** `supabase/config.toml`, `supabase/.gitignore`, `supabase/migrations/20261106000100_initial_schema.sql`, `supabase/seed.sql`, `supabase/tests/database.sql`, `scripts/test-database.mjs` créés ; `.gitignore`, `.env.example`, `package.json`, `pnpm-lock.yaml`, `README.md`, `docs/05-DATA-MODEL.md`, `tasks/TASKS.md` modifiés.
- **Migration :** transaction initiale de 14 tables (5 catalogue public, 9 privées), UUID/FK RESTRICT/index, prix centimes `integer`, timestamps `timestamptz`, statuts typés, unicité idempotence + empreinte payload, hash de suivi SHA-256 hexadécimal, snapshots/historiques append-only. Singleton commandes OFF par défaut, paramètres inconnus NULL, aucune plage horaire ou donnée de contact inventée. `validation_status` empêche de publier un produit provisoire ; photos NULL permises.
- **Sécurité :** RLS activée sur les 14 tables ; schéma `app_private` exclu de l'API. Aucun accès privé `anon`. Lectures préparées pour personnel actif via `auth.uid()` et fonction privée SECURITY DEFINER à search_path vide ; pas d'auto-attribution de rôle. Aucun INSERT/UPDATE/DELETE accordé à `anon`, `authenticated` ou `service_role` sur les tables applicatives. Pas d'API de création de commande ni de gestion admin ; autorisations handlers et transactions à traiter en T-004/T-010/T-012. Métadonnées audit objet JSON, future allowlist serveur obligatoire avant écriture. Grants automatiques désactivés dans la configuration et privilèges par défaut restreints pour le propriétaire de migration.
- **Seed :** 6 catégories, 17 SKU/prix exacts de transcription, tous provisoires/masqués/indisponibles, aucune image ou description de recette inventée. Suppléments/liens non seedés faute d'éligibilité validée. Seed automatique OFF ; garde explicite `app.environment=test`, `ON CONFLICT DO NOTHING`, aucune modification des paramètres d'ouverture. Le marqueur test ne remplace pas l'isolation des accès administrateur. Aucun compte staff/client seedé.
- **Outils :** CLI Supabase 3.0.0 figé en devDependency pour migration/test local, PostgreSQL cible 17. Aucune dépendance de production ajoutée. Stack `rs-coffee-lab-test`, aucun projet distant lié, aucun secret applicatif requis/exposé ; `.env.example` complété par des commentaires. Scripts `db:start`, `db:stop`, `db:test` ; le dernier cible le conteneur local fixé et prévoit deux resets + deux seeds par reset + assertions SQL rollback.
- **Tests (command + résultat) :**
  - `pnpm.cmd lint` : code 0, sans erreur ni avertissement.
  - `pnpm.cmd typecheck` : code 0, types générés puis TypeScript strict réussi.
  - `pnpm.cmd test` : code 0, 1 fichier et 3 tests applicatifs réussis. Les tests de protection T-002 ne sont pas sur main ; aucun résultat 12 tests revendiqué ici.
  - `pnpm.cmd build` : code 0, Next 16.4.5, compilation/TypeScript réussis, 3/3 pages générées, routes `/` et `/_not-found`.
  - `pnpm.cmd install --offline --frozen-lockfile --store-dir .pnpm-store` : code 0, lockfile cohérent et installation à jour.
  - `pnpm.cmd exec supabase --version` : 3.0.0 ; `supabase init` : code 0 en exécution autorisée. Le premier essai sandbox a échoué en créant le dossier utilisateur `.supabase`, puis l'initialisation autorisée a réussi.
  - `docker info --format '{{.ServerVersion}}'` : code 1, moteur `dockerDesktopLinuxEngine` introuvable. Le développeur a indiqué démarrer Docker Desktop ; moteur toujours indisponible aux dernières vérifications.
  - `pnpm.cmd db:start` : code 1, `DockerLifecycleInspectError`, aucun accès au moteur Linux.
  - `pnpm.cmd db:test` : code 1 dès le premier reset local (`LocalDbRunningError`), avant migration/seed/assertions. Aucune réussite DB/RLS/reproductibilité déclarée.
  - `pnpm.cmd exec supabase db lint` : code 1, `ECONNREFUSED 127.0.0.1:54322`. Aucun lint PostgreSQL réussi.
  - Contrôle Python statique : 17 SKU et prix du seed conformes aux 17 lignes Markdown converties en centimes ; TOML valide, schéma privé non exposé, seed automatique désactivé, aucun remote configuré dans Supabase. Ces contrôles ne prouvent pas la validité SQL à l'exécution.
  - `git diff --check` : code 0, avertissements de normalisation LF/CRLF Windows uniquement.
- **Couverture SQL préparée, NON EXÉCUTÉE :** contraintes prix/quantités/horaires, FK et unicité, refus publication provisoire, paramètres fermés, idempotence du seed via double application, non-écrasement historique lors changement prix, refus mutations/suppressions historiques, lecture publique d'un seul produit confirmé. Refus lecture/énumération des commandes de deux clients par anonymes/non-personnel, mutations anonymes même avec grants temporaires (RLS), suppression des grants privés, refus écriture service_role, rôles staff actif/inactif/admin et impossibilité d'auto-promotion. Tests avec données explicitement fictives en transaction rollback.
- **Critères :** prix entiers et photos manquantes couverts dans les fichiers ; DB reproductible et refus réel d'accès public NON VALIDÉS tant que les tests DB ne sont pas exécutés avec succès. Aucun déploiement/accès production ni T-004 commencé.
- **Known risks / blocages :** moteur Docker Linux inaccessible, aucun PostgreSQL/Supabase local ou de test prêt ; SQL préparé mais jamais appliqué. T-002 non fusionné et protections non validées ; sa CI n'est pas héritée par cette branche. Les limites de quantité métier, horaires après minuit, règles d'options/prix, conservation et autres décisions T-000 restent ouverts. Les checks locaux ne remplacent pas les tests de transaction/capacité/transition des tickets suivants.
- **Follow-up :** démarrer un moteur Docker Linux fonctionnel, puis `pnpm.cmd db:start` et `pnpm.cmd db:test` sur la stack jetable de ce projet ; corriger toute erreur réelle, consigner les résultats et ne passer DONE qu'après validation des critères. Finaliser/fusionner T-002 par le flux de revue puis synchroniser cette branche. Commit et PR draft à préparer, sans fusion ni déploiement ; T-004 attend une nouvelle consigne et une base validée.

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
