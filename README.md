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

Aucun interrupteur d'environnement ne permet d'ouvrir les commandes à ce stade. La page affiche leur fermeture et ne fournit ni checkout ni API de commande. Le défaut DB `ordering_enabled=false` et les vérifications transactionnelles restent à réaliser en T-003/T-009/T-010, conformément à `docs/04-ARCHITECTURE.md`.

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

L'arborescence métier cible reste décrite dans `docs/04-ARCHITECTURE.md`. Aucun schéma DB, authentification, catalogue ou design final n'est encore créé. Le workflow CI de T-002 est décrit ci-dessous.

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

## CI et environnements — T-002

### Workflow GitHub Actions

`.github/workflows/ci.yml` déclenche le workflow **CI**, job **Quality**, à chaque pull request, push de branche ou lancement manuel (ce dernier nécessite que le workflow soit présent sur la branche par défaut). Aucun filtre de nom de branche métier n'est imposé tant que la branche d'intégration n'est pas choisie.

Le runner `ubuntu-24.04` lit Node dans `.node-version` et pnpm dans le champ `packageManager` de `package.json`. Les actions `checkout` v6, `setup-node` v6 et `pnpm/action-setup` v4 sont figées sur des SHA complets vérifiés dans leurs dépôts officiels. Mettre ces SHA à jour après revue de leurs nouvelles versions.

Ordre des étapes : checkout → Node → pnpm → `pnpm check:env` → `pnpm install --frozen-lockfile` → `pnpm lint` → `pnpm typecheck` → `pnpm test` → `pnpm build`. Les contrôles sont séquentiels et toute erreur bloque les suivants. Durée maximale : 15 minutes. Un nouveau lancement pour la même PR/référence annule le précédent.

Le job dispose uniquement de `contents: read` ; le checkout ne conserve pas les identifiants Git. Il n'utilise ni `pull_request_target`, ni environnement distant, ni secret de dépôt, ni upload d'artefact ou cache de build. Le build n'est pas publié. `NEXT_TELEMETRY_DISABLED=1` désactive la télémétrie Next et `TZ=Africa/Casablanca` fixe le fuseau du processus CI, sans remplacer les validations métier du futur module de créneaux.

### Séparation des environnements

| Contexte | Configuration actuelle | Données et secrets |
|---|---|---|
| Développement | `next dev` gère `NODE_ENV=development` ; `.env.local` facultatif et ignoré | Aucun secret ni service requis |
| Tests | Vitest utilise `NODE_ENV=test`, explicitement fixé dans la CI | Aucun accès DB ; future base de test isolée |
| Build CI | `NODE_ENV=production` pour `pnpm build`, aucun fichier `.env` copié | Aucun secret injecté ; un build production ne constitue pas un déploiement |
| Staging/preview | Environnement distant non créé, accès privé à configurer avant toute preview | Données fictives et projet/identifiants séparés de production |
| Production | Hébergement non configuré, aucun déploiement autorisé par ce ticket | Aucun secret de production disponible en CI qualité |

Ne pas définir un `NODE_ENV=staging` : staging et production utilisent le mode de build production, mais leurs projets, secrets et données doivent être distincts. Aucun `.env.test` ou `.env.production` factice n'est ajouté au dépôt. Les futures variables applicatives ne seront introduites qu'au ticket qui les utilise, avec validation serveur et extension des contrôles.

### Protection des fichiers d'environnement

```powershell
pnpm.cmd check:env
```

Le script autonome `scripts/check-env.mjs` contrôle les noms des fichiers suivis ou non ignorés par Git, y compris avant l'installation des dépendances. Il refuse les fichiers `.env*` autres que l'unique `.env.example` racine et les fichiers `.pem`/`.key`. L'exemple doit rester constitué de commentaires puisqu'aucune variable n'est consommée actuellement. Les tests de ce contrôle sont dans `tests/unit/environment-files.test.ts` ; `scripts/check-env.d.mts` décrit son interface TypeScript.

Les fichiers locaux ignorés ne sont ni lus ni affichés. Le contrôle ne journalise aucune valeur et ne remplace pas un outil de détection de secrets dans tous les fichiers/historiques. Avant un commit, relire les fichiers indexés ; activer la détection et la protection contre les pushes de secrets sur GitHub si disponibles. Ne jamais publier une clé avec `NEXT_PUBLIC_` : les variables de ce préfixe peuvent être intégrées au JavaScript navigateur.

### Reproduire les contrôles localement

Dans PowerShell, exécuter les lignes dans l'ordre et s'arrêter au premier code de sortie non nul :

```powershell
pnpm.cmd check:env
pnpm.cmd install --offline --frozen-lockfile --store-dir .pnpm-store
pnpm.cmd lint
pnpm.cmd typecheck
pnpm.cmd test
pnpm.cmd build
```

Omettre `--offline` lors d'une première installation. Sous Linux/CI, utiliser `pnpm`, avec le store par défaut de la machine ; ne pas réutiliser `node_modules` de Windows.

Pour vérifier le workflow avec actionlint **1.7.12** installé depuis sa publication officielle, après contrôle du SHA-256 de l'archive avec les checksums fournis :

```powershell
actionlint -shellcheck= -pyflakes= .github/workflows/ci.yml
```

Cette commande vérifie YAML, structure GitHub Actions et expressions ; ShellCheck et Pyflakes sont désactivés dans ce contrôle local Windows. Elle n'exécute pas le workflow ni les actions GitHub. Aucun résultat Linux/GitHub vert n'est revendiqué sur la seule base des commandes locales.

### Validation distante et protections staging à réaliser

Le remote `origin` est configuré sur `https://github.com/SIMOS21/RS-Coffee-Lab.git`, URL fournie par le propriétaire. La base T-001 `4fbe368` a été publiée sur `main` et le commit T-002 `5127678` sur `feat/t-002-ci-environments`, sans push forcé, grâce à l'authentification Git locale déjà configurée. Le connecteur GitHub reste en lecture seule : la création de PR par son API est refusée (`403 Resource not accessible by integration`). Le [run CI 42302008681 sur push](https://github.com/SIMOS21/RS-Coffee-Lab/actions/runs/42302008681) a réussi sur ce commit ; il ne remplace pas le run de PR requis. La branche `main` a été vérifiée comme non protégée ; les réglages d'administration restent à réaliser.

Avec une connexion autorisée en écriture sur ce dépôt :

1. Publier la base T-001 sur `main` puis la branche T-002 ; ouvrir une PR de test vers `main`. Si le dépôt a changé depuis sa vérification, inspecter/fetcher son historique avant tout push, sans forcer. Vérifier les permissions Actions et les éventuelles approbations exigées pour les contributions externes.
2. Attendre un lancement réel **CI / Quality** réussi sur le dernier commit de la PR. Consigner son URL, le SHA, le runner et la conclusion dans `tasks/TASKS.md` avant de passer T-002 à DONE.
3. Sur la branche d'intégration choisie, configurer un ruleset ou une protection exigeant la PR, la revue et le contrôle **Quality** observé après ce premier run. Bloquer les pushes forcés et suppressions ; vérifier les contournements administrateur selon les droits disponibles.
4. Avant une première preview/staging, activer la protection d'accès de l'hébergeur et vérifier qu'un visiteur non authentifié ne peut pas ouvrir le site. Une métadonnée `noindex` n'est pas un contrôle d'accès. Utiliser uniquement des données fictives, une DB et des identifiants séparés.
5. Pour tout futur job de déploiement staging, créer un environnement GitHub `staging` avec branches explicitement autorisées et approbation d'un responsable désigné si le plan GitHub le permet. Ce job devra référencer l'environnement pour bénéficier de ses règles. Ne pas créer un job de déploiement sans ces protections ; si le plan ne les permet pas, garder le déploiement désactivé jusqu'à une solution approuvée.
6. Garder la production séparée, sans identifiants dans la CI des PR. Toute publication de production relève de T-016 et de l'accord du propriétaire.

Ces réglages ne sont **pas activés par la présence du YAML**. Leur disponibilité dépend du dépôt et du plan GitHub/hébergeur. T-002 reste BLOCKED tant que le pipeline de PR réel et les protections distantes concernées ne sont pas vérifiés.

Les deux branches sont désormais publiées. Pour publier les éventuels nouveaux commits T-002 depuis la branche courante avec une authentification Git autorisée :

```powershell
git push origin feat/t-002-ci-environments
```

Ouvrir ensuite une [PR `feat/t-002-ci-environments` vers `main`](https://github.com/SIMOS21/RS-Coffee-Lab/compare/main...feat/t-002-ci-environments?expand=1) dans GitHub, ou donner au connecteur les droits nécessaires pour la créer. Ne pas fusionner avant revue et validation des critères restants. Aucun jeton ne doit être envoyé dans le chat ou enregistré dans l'URL du remote.

Références : [setup-node](https://github.com/actions/setup-node), [pnpm/action-setup](https://github.com/pnpm/action-setup), [checkout](https://github.com/actions/checkout), [environnements et protections GitHub](https://docs.github.com/en/actions/reference/workflows-and-actions/deployments-and-environments), [publication actionlint 1.7.12](https://github.com/rhysd/actionlint/releases/tag/v1.7.12).
