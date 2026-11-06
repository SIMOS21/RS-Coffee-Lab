# RS Coffee Lab — dossier de pilotage Codex

> Statut : **fondation locale T-001 opérationnelle**. Page provisoire uniquement, commandes fermées. Dernière mise à jour : 2026-11-06.

## Objectif

Créer un site mobile-first de présentation et de commande pour RS Coffee Lab, avec une administration simple que l'équipe du coffee shop pourra utiliser sans compétences techniques.

**Lancement recommandé : commande à emporter (click & collect), paiement au retrait.** Livraison et paiement en ligne nécessitent des décisions métier et une intégration distincte.

## Comment démarrer avec Codex

1. Créer ou ouvrir un dépôt Git nommé `rs-coffee-lab`.
2. Copier **tout le contenu de ce dossier** à la racine du dépôt (notamment `AGENTS.md`, `docs/`, `tasks/`, `prompts/`).
3. Faire un commit `docs: add product and codex specifications`.
4. Ouvrir **Codex dans ce dépôt** et lui donner le contenu de `prompts/CODEX-KICKOFF.md`.
5. Valider les questions bloquantes dans `docs/11-DECISIONS.md` ; les éléments non validés doivent rester des placeholders ou être désactivés.
6. Faire traiter les tickets de `tasks/TASKS.md` **un par un**, sur des branches/PR distinctes. Un ticket n'est terminé que lorsque ses critères d'acceptation et les tests associés passent.

> `AGENTS.md` contient des règles que Codex lit automatiquement depuis le dépôt. Les autres `.md` sont des références : les prompts/tickets demandent explicitement de les consulter.

## Documents — ordre de lecture

| Document | Rôle |
|---|---|
| `AGENTS.md` | Règles permanentes de Codex |
| `docs/01-PRODUCT.md` | Vision, profils, périmètre et critères métier |
| `docs/02-BRAND-UX.md` | Identité, pages, composants et accessibilité |
| `docs/03-MENU.md` | Transcription du menu photographié, 17 références |
| `docs/04-ARCHITECTURE.md` | Stack, répertoires, conventions techniques |
| `docs/05-DATA-MODEL.md` | Entités, règles de cohérence et migrations |
| `docs/06-ORDER-LIFECYCLE.md` | Panier, checkout, statuts et erreurs |
| `docs/07-API.md` | Contrats des mutations et contrôles serveur |
| `docs/08-SECURITY-PRIVACY.md` | Autorisations, anti-abus, données personnelles |
| `docs/09-QUALITY.md` | Tests, performance, acceptation |
| `docs/10-DEPLOYMENT.md` | Préproduction, mise en ligne et exploitation |
| `docs/11-DECISIONS.md` | Hypothèses, inconnues, décisions à prendre |
| `docs/12-ROADMAP.md` | Phases et gates de sortie |
| `tasks/TASKS.md` | Backlog atomique à exécuter |
| `prompts/` | Prompts prêts à copier dans Codex |

## Règles produit

- Nom de travail : **RS Coffee Lab**. Vérifier l'orthographe exacte du logo avant publication (sur le menu « RS COFFE LAB », sur la tasse « RS COFFEE LAB »).
- Devise : **MAD**, affichage « DH » en français ; stockage en **centimes entiers**.
- Langue MVP : **français** ; architecture préparée pour arabe (RTL) plus tard.
- Fuseau métier : **Africa/Casablanca**, horodatages stockés en UTC.
- Aucune adresse, téléphone, horaires ou zone de livraison ne doit être inventé.
- Les images fournies par le client sont la référence d'ambiance. Vérifier les droits d'utilisation et obtenir des versions numériques nettes avant publication.
- Ne pas simuler un paiement, une commande reçue ou une notification réelle en production.

## Définition d'un MVP réussi

Un client peut parcourir le menu, ajouter des articles disponibles, modifier les quantités, transmettre une commande à emporter avec un contact et un créneau valide, recevoir une confirmation avec identifiant ; un membre autorisé du personnel peut voir la commande et la faire progresser de son arrivée à son retrait. Le tout fonctionne sur mobile, avec des prix calculés par le serveur et des données protégées.

## Références officielles

- Codex `AGENTS.md` : https://learn.chatgpt.com/docs/agent-configuration/agents-md
- Next.js authentification : https://nextjs.org/docs/app/guides/authentication
- Supabase RLS : https://supabase.com/docs/guides/database/postgres/row-level-security
- CNDP conformité des sites : https://www.cndp.ma/conformite-des-sites-web/
- CMI e-commerce : https://www.cmi.co.ma/fr/solutions-paiement-ecommerce

## Développement local — fondation T-001

### Prérequis techniques

- Git ; branche de travail de T-001 : `feat/t-001-foundation`.
- Node.js **24.13.0**, version de référence dans `.node-version`. Le projet accepte Node `>=24.13.0 <25` ; seule la version de référence a été testée ici.
- pnpm **9.15.9**, figé dans `package.json` (`packageManager` et `engines`). Utiliser une installation de pnpm de cette version ; ne pas mettre à jour les outils globalement pour lancer le projet.
- Accès au registre npm lors de la première installation. Aucun compte Supabase/Vercel, Docker ou secret n'est requis à ce stade.

Vérifier dans PowerShell :

```powershell
node --version
pnpm.cmd --version
git branch --show-current
```

Sous Windows, `pnpm.cmd` évite le lanceur `pnpm.ps1` bloqué par la politique PowerShell de cette machine, sans changer cette politique. Sur les autres plateformes, utiliser `pnpm` à la place de `pnpm.cmd`.

### Installation

Depuis la racine du dépôt :

```powershell
pnpm.cmd install --frozen-lockfile --store-dir .pnpm-store
```

Le store local `.pnpm-store/` est ignoré par Git. Conserver le même `--store-dir` pour les installations suivantes. Le lockfile fixe également les dépendances transitives ; les versions directes sont exactes, sans `^` ni `~`. `.npmrc` active `save-exact` et le contrôle des versions des moteurs.

Une fois le store rempli, l'installation peut être vérifiée sans réseau :

```powershell
pnpm.cmd install --offline --frozen-lockfile --store-dir .pnpm-store
```

### Variables d'environnement

`.env.example` ne contient que des commentaires : **aucune variable n'est requise** pour la fondation. Sa copie est facultative :

```powershell
Copy-Item -LiteralPath .env.example -Destination .env.local
```

Ne pas écraser un fichier local déjà configuré. Les fichiers `.env*` sont ignorés, sauf `.env.example`. Ne jamais y inscrire un secret réel destiné à être versionné, ni exposer un secret avec `NEXT_PUBLIC_`. Les variables Supabase et les environnements distants seront ajoutés dans les tickets concernés.

Aucun interrupteur d'environnement ne permet d'ouvrir les commandes à ce stade. La page affiche leur fermeture et ne fournit ni checkout ni API de commande. T-003 prépare le défaut DB `ordering_enabled=false` ; sa validation réelle et les vérifications transactionnelles T-009/T-010 restent nécessaires, conformément à `docs/04-ARCHITECTURE.md`.

### Commandes disponibles

| Commande Windows | Usage |
|---|---|
| `pnpm.cmd dev --hostname 127.0.0.1 --port 3000` | Serveur local avec rechargement, accessible sur `http://127.0.0.1:3000` |
| `pnpm.cmd lint` | ESLint sur le projet, aucun avertissement toléré |
| `pnpm.cmd typecheck` | Génération des types de routes Next.js puis TypeScript strict sans émission |
| `pnpm.cmd test` | Suite Vitest en une exécution |
| `pnpm.cmd test:watch` | Vitest en mode interactif |
| `pnpm.cmd build` | Build de production local |
| `pnpm.cmd start --hostname 127.0.0.1 --port 3000` | Sert le build déjà créé |

Arrêter le serveur avec `Ctrl+C`. Si le port est occupé, arrêter son propre serveur précédent ou choisir un autre port. Exécuter `typecheck` puis `build` séquentiellement : les deux utilisent les types générés dans `.next/`.

`test:e2e` n'existe pas encore : aucun parcours métier n'est implémenté. Playwright, les tests DB/RLS et les scénarios QA-01 à QA-15 seront ajoutés dans leurs tickets ; les trois tests actuels ne constituent pas une recette du MVP.

### Organisation actuelle

```text
src/
  app/
    layout.tsx             langue française, métadonnées noindex/nofollow
    page.tsx               page provisoire, commandes fermées
    globals.css            Tailwind et variables neutres de fondation
  components/ui/button.tsx primitive shadcn/ui adaptée
  lib/utils.ts             composition et fusion des classes Tailwind
tests/unit/
  foundation.test.tsx       fermeture affichée, non-indexation, fusion des classes
components.json            configuration shadcn/ui et alias @/
next.config.ts             configuration Next.js
tsconfig.json              TypeScript strict et alias @/* vers src/*
eslint.config.mjs          règles Next.js/TypeScript et exclusions des fichiers générés
postcss.config.mjs         intégration Tailwind CSS
vitest.config.ts           tests Node, résolution de l'alias @/
package.json               scripts, moteurs et dépendances exactes
pnpm-lock.yaml             résolution figée
.env.example               exemple sans valeur sensible
docs/                      spécifications et registre des décisions
tasks/TASKS.md             backlog et comptes rendus
prompts/                   consignes de travail et de revue
```

L'arborescence métier cible reste décrite dans `docs/04-ARCHITECTURE.md`. T-003 ajoute le schéma et le seed SQL de démonstration décrits ci-dessous. Authentification applicative, catalogue affiché et design final restent à développer. La CI T-002 est dans une PR séparée non fusionnée à la création de cette branche.

### Versions et justification des dépendances

Socle testé : Next.js **16.4.5**, React/React DOM **19.3.1**, TypeScript **5.9.3**, Tailwind et son plugin PostCSS **4.3.5**, PostCSS **8.5.32**, Vitest **5.1.0**, ESLint **9.39.5** et `eslint-config-next` **16.4.5**. Les versions exactes des types sont dans `package.json` ; l'installation figée et les quatre contrôles ont réussi avec Node 24.13.0/pnpm 9.15.9.

Next.js/React assurent le rendu App Router. Les dépendances de production supplémentaires servent la primitive shadcn/ui : Radix Slot **1.5.0** pour la composition `asChild`, `class-variance-authority` **0.7.1** pour les variantes, `clsx` **2.1.1** et `tailwind-merge` **3.7.0** pour les classes. Aucun SDK Supabase, paiement ou notification n'est installé ; Zod sera ajouté avec les premières entrées serveur qui l'utilisent.

Risque connu : ESLint 9.39.5 est signalé comme non maintenu par npm. Il est conservé car les plugins React/import/accessibilité utilisés par la configuration Next vérifiée n'annoncent pas la prise en charge d'ESLint 10. Réévaluer cette combinaison avant lancement ; aucune compatibilité avec ESLint 10 n'est revendiquée. Les contrôles réussis ne remplacent pas un audit de vulnérabilités.

### Vérification visuelle manuelle à effectuer

Le navigateur compatible n'est pas accessible à l'agent (`The browser access host is unavailable`). La précédente tentative Windows était également bloquée par l'absence de contrôle des URL dans ce navigateur. **Aucune vérification visuelle ni capture d'écran réussie n'est déclarée.** Ne contourner aucun contrôle de sécurité.

Procédure pour le développeur, après `pnpm.cmd build` :

1. Lancer `pnpm.cmd start --hostname 127.0.0.1 --port 3000` et ouvrir `http://127.0.0.1:3000` dans son navigateur habituel.
2. Vérifier le titre « RS Coffee Lab — Site en préparation », le nom explicitement provisoire, le texte français annonçant la fermeture et le bouton « Commandes fermées » désactivé. Aucun formulaire ni lien de commande ne doit être proposé.
3. Dans le mode responsive des outils développeur, vérifier les largeurs 320, 375, 768 et 1440 px : contenu lisible, aucun chevauchement ni défilement horizontal. Vérifier également un zoom de 200 %.
4. Parcourir la page au clavier : aucune action de commande ne doit être activable ; le bouton désactivé n'est pas une cible de tabulation. Vérifier dans l'inspecteur `html lang="fr"` et la métadonnée robots `noindex, nofollow`.
5. Vérifier l'absence d'erreur dans la console et le chargement des styles, puis enregistrer des captures mobile et desktop. Consigner date, navigateur/version, dimensions et anomalies éventuelles dans le compte rendu de revue avant de déclarer cette vérification réussie.
6. Arrêter le serveur avec `Ctrl+C`.

Cette procédure manuelle est le repli demandé pour T-001. Elle ne vaut pas exécution de la recette visuelle, audit d'accessibilité ou autorisation de publication.

## Base Supabase — T-003

### Base Git et réserves

La branche `feat/t-003-supabase-database` part de `main`/`origin/main` au commit `4fbe368`, récupéré depuis GitHub avec un dossier propre. La [PR T-002 #1](https://github.com/SIMOS21/RS-Coffee-Lab/pull/1) est encore ouverte ; son [run sur PR](https://github.com/SIMOS21/RS-Coffee-Lab/actions/runs/42303383948) est vert, mais elle n'est pas fusionnée et les protections restent en attente. T-002 n'est donc pas déclaré DONE. Aucun changement T-002 n'a été recopié dans cette branche ; rebaser/synchroniser la PR T-003 après sa fusion, en préservant les deux tickets séparés.

### Installation et outils locaux

Node 24.13.0 et pnpm 9.15.9 restent les versions de référence. Le CLI **Supabase 3.0.0** est une dépendance de développement exacte, justifiée par les migrations et tests locaux ; aucun SDK Supabase ni dépendance de production n'est ajouté. Docker Desktop doit être démarré en mode conteneurs Linux. Le projet local se nomme `rs-coffee-lab-test`, PostgreSQL **17** ; ports 54321 (API), 54322 (DB), 54320 (shadow). Utiliser un projet distinct si ces ports sont occupés, sans réutiliser un projet contenant des données réelles.

```powershell
pnpm.cmd install --frozen-lockfile --store-dir .pnpm-store
docker info
pnpm.cmd exec supabase --version
pnpm.cmd db:start
pnpm.cmd db:test
pnpm.cmd db:stop
```

`db:start` démarre uniquement la stack locale : Auth sans inscription publique et API sur `public`. Studio, Storage, Realtime, SMTP, analytics et edge runtime sont désactivés pour cette fondation. Aucun login Supabase, lien vers un projet distant ou jeton cloud n'est nécessaire. Les clés locales générées éventuellement affichées par le CLI ne doivent être copiées ni dans le chat, ni dans les logs/commits.

`db:test` **réinitialise la base locale de test**. Ne pas y stocker de données à conserver. Le script fixe le conteneur `supabase_db_rs-coffee-lab-test`, n'accepte aucune URL/option distante et exécute deux cycles complets : migrations depuis zéro (`supabase db reset --no-seed`), seed deux fois dans une transaction explicitement marquée `app.environment=test`, puis assertions SQL. Une erreur SQL ou de processus doit donner un code non nul. Ne jamais ajouter `--remote` à cette procédure. Le script utilise `psql` du conteneur, sans installation PostgreSQL sur Windows.

### Fichiers et règles de sécurité

| Fichier | Rôle |
|---|---|
| `supabase/config.toml` | Configuration locale, aucun projet distant, exposition API de `public` uniquement, grants automatiques désactivés |
| `supabase/migrations/20261106000100_initial_schema.sql` | Migration transactionnelle des 14 tables, types, contraintes, index, grants, RLS et protections historiques |
| `supabase/seed.sql` | 6 catégories et 17 références provisoires, idempotent, sans photos ni recettes inventées |
| `supabase/tests/database.sql` | Assertions SQL avec arrêt au premier échec et rollback des données fictives de test |
| `scripts/test-database.mjs` | Recréation locale deux fois, double seed et exécution des tests |

Les cinq tables catalogue sont dans `public`. Leur lecture publique exige visibilité et validation explicite ; les suppléments exigent aussi activation/éligibilité. Le seed ne publie aucun produit : `validation_status=provisional`, `is_visible=false`, `is_available=false`, `image_path=NULL`. Les catégories sont masquées ; aucune règle de supplément inconnue n'est créée. Les 17 prix transcrits sont stockés en centimes entiers et restent non validés par le commerce.

Les commandes, lignes/options figées, historiques, personnel, paramètres/horaires et audit sont dans `app_private`, non exposé à la Data API. RLS est activée sur toutes les tables de l'application. `anon` n'a aucun accès au schéma privé. Les utilisateurs authentifiés ordinaires ne voient aucune commande ; les lectures préparées pour le personnel dépendent d'une ligne `staff_members` active liée à `auth.uid()`, jamais d'un rôle fourni par le navigateur. Une fonction privée `SECURITY DEFINER` à `search_path` vide évite la récursion RLS ; son exécution est refusée à `anon`.

Aucune mutation directe des tables de l'application n'est accordée à `anon`, `authenticated` ou `service_role`, même si ce dernier peut contourner RLS. Les accès serveur futurs devront être étroits et validés dans leurs handlers/RPC. Aucun membre du personnel ni compte admin n'est seedé. Les snapshots de lignes et événements sont append-only, les suppressions de produits référencés sont bloquées, et toutes les dates d'événements sont en `timestamptz` (instants UTC, fuseau métier `Africa/Casablanca`).

`business_settings` est un singleton créé avec `ordering_enabled=false` et sans délai/capacité inventés. Aucune plage horaire réelle n'est insérée. Une configuration partielle ne peut pas être activée ; la validation complète des horaires/fermetures/créneaux reste T-009. Les horaires après minuit et plusieurs plages par jour ne sont pas activés sans validation métier.

La table `orders` prépare clé d'idempotence unique et empreinte du payload, hash SHA-256 de suivi, snapshots et statuts typés. **Ce ticket n'implémente pas la création transactionnelle, le calcul serveur des totaux/options, les verrous de capacité, les transitions de statut ni le marquage payé** : ces flux et leurs tests appartiennent à T-010/T-012. Ils ne sont pas accessibles par une API à ce stade. Les métadonnées d'audit devront être construites par allowlist côté serveur avant toute écriture future ; le type JSON objet seul ne retire pas les PII.

### Seed, environnements et variables

Le seed automatique est désactivé dans la configuration. `seed.sql` refuse de s'exécuter sans `app.environment=test` explicite dans la session ; seul le script local de test le fixe. Ce marqueur est un garde-fou contre un lancement accidentel, pas une barrière contre un administrateur malveillant. Ne jamais exécuter ce seed contre un projet distant ou de production. `ON CONFLICT DO NOTHING` évite doublons et écrasement des modifications existantes ; le seed ne change jamais les paramètres d'ouverture.

Aucune variable applicative ni clé Supabase n'est encore consommée par Next.js : `.env.example` reste constitué de commentaires et décrit ce contrat. Les futurs paramètres d'accès seront introduits avec l'intégration qui les utilise ; ne pas ajouter de secret ni de fausse URL maintenant. `.env*`, `supabase/.temp/` et `.branches/` sont ignorés. Les projets de test, staging et production devront être distincts ; aucun projet de production n'est lié ici.

### Validation et limites

Les assertions SQL couvrent les contraintes de prix/quantité, FK, unicité idempotente, fermeture par défaut, immutabilité des snapshots, anonymes/non-personnel/inactifs, lectures staff/admin et refus de mutation. Un test donne temporairement des grants à `anon` dans une transaction rollback pour vérifier que RLS protège encore les commandes de deux clients fictifs indépendamment des grants. Un autre vérifie la lecture d'un seul produit explicitement confirmé/publié. Le runner vérifie deux recréations et deux passages du seed par recréation.

À la préparation, `db:start` et `db:test` ont échoué avant les migrations car le moteur Docker Linux n'était pas accessible. **Les tests SQL et la reproductibilité ne sont pas déclarés validés tant que `pnpm.cmd db:test` ne termine pas réellement avec code 0.** La cohérence statique des 17 SKU/prix avec le Markdown et la syntaxe TOML ont été contrôlées séparément ; cela ne constitue pas une validation PostgreSQL/RLS. Voir le résultat final dans `tasks/TASKS.md`.

Ne pas modifier une migration appliquée en staging/production. Pour cette migration non déployée, reprise locale par reset de la stack de test ; un rollback de production devra faire l'objet d'un plan de sauvegarde/restauration approuvé. Ne pas supprimer un schéma historique pour annuler une fonctionnalité.

Références officielles : [CLI v3](https://supabase.com/docs/guides/local-development/cli/migrating-to-v3), [RLS](https://supabase.com/docs/guides/database/postgres/row-level-security), [seed](https://supabase.com/docs/guides/local-development/seeding-your-database), [sécurité API](https://supabase.com/docs/guides/api/securing-your-api).
