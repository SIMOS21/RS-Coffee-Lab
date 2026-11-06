# 11 — Questions ouvertes et registre des décisions

> Ce registre est la **source de vérité des décisions métier**. Une hypothèse n'est pas une décision. Compléter « validé par » et la date avant d'activer la fonctionnalité correspondante.

## Inconnues à résoudre **avant production**
| ID | Question | Hypothèse de travail sans validation | Statut |
|---|---|---|---|
| D-01 | Nom légal et logo exact : « COFFE » ou « COFFEE » ? | « RS Coffee Lab » utilisé provisoirement | À confirmer |
| D-02 | Adresse exacte / lien Maps ? | Aucun affichage factice | À confirmer |
| D-03 | Téléphone / WhatsApp officiel ? | Aucune valeur inventée | À confirmer |
| D-04 | Horaires hebdo et fermetures ? | Commande OFF tant qu'inconnu | Bloquant |
| D-05 | Délai préparation, intervalle et capacité des créneaux ? | Valeurs non activées en prod | Bloquant |
| D-06 | Tous les 17 articles et prix du menu toujours vendus ? | Catalogue de démonstration | Bloquant |
| D-07 | À quels produits appliquer miel/arômes ? | Suppléments désactivés | À confirmer |
| D-08 | Photo par produit / droit d'usage des photos du shop ? | Placeholders éditoriaux temporaires | À confirmer |
| D-09 | Commande à emporter autorisée ? Personne en charge du dashboard ? | Cible MVP, activation OFF | Bloquant |
| D-10 | Paiement sur place acceptable et moyens acceptés ? | À valider avant commandes réelles | Bloquant |
| D-11 | Livraison ? périmètre et frais ? | Hors MVP | Différé |
| D-12 | Paiement en ligne ? prestataire et contrat ? | Hors MVP | Différé |
| D-13 | Données entreprise, politique de confidentialité, durée conservation ? | Aucune mention légale inventée | Bloquant |
| D-14 | Hébergement/données à l'étranger, démarches CNDP ? | Revue conformité nécessaire | Bloquant |
| D-15 | Langues de lancement : FR seulement, AR, anglais ? | FR MVP, préparer i18n | À confirmer |
| D-16 | Acceptation/annulation des commandes et remboursements ? | Transitions restrictives MVP | À confirmer |
| D-17 | Produits en grains / machines en ligne ? | Hors MVP, non confirmés | Différé |
| D-18 | Frais, taxes, arrondis, facture/ticket ? | Aucun frais caché ; détails comptables à valider | Bloquant |
| D-19 | Domaine et détenteur de l'hébergement ? | Non choisi | À confirmer |
| D-20 | Allergènes / ingrédients et contraintes sanitaires ? | Pas d'affirmation non vérifiée | À confirmer |

## Registre de décisions (ADR métier)
| Date | ID | Décision | Rationale | Validé par |
|---|---|---|---|---|
| 2026-11-06 | P-001 | **Proposition** MVP click & collect + paiement au retrait | Moins de dépendances bancaires, mise en ligne plus rapide | EN ATTENTE |
| 2026-11-06 | T-001 | **Recommandation technique** Next.js + Supabase + Vercel | Monolithe simple, gestion moderne | EN ATTENTE |

## Processus
Quand le propriétaire valide un point : marquer `VALIDÉ`, date, responsable, détail concret. Mettre à jour les specs/tickets/seed concernés. Si le point reste non résolu, bloquer la mise en production de la fonctionnalité affectée, pas tout le travail de développement.

## Consolidation T-000 — revue du 2026-11-06

Les statuts D-01 à D-20 et les deux propositions ADR ci-dessus restent inchangés : **aucune validation métier n'a été reçue**. Le présent audit porte sur les fichiers locaux ; les photos sources et les justificatifs métier ne sont pas présents. Les références externes, la compatibilité des versions et les obligations juridiques n'ont pas été vérifiées dans ce ticket.

### Validations humaines et échéances

Cette table complète les hypothèses et statuts de la table principale. « Avant » désigne la fonctionnalité à bloquer si la validation manque, pas un blocage de T-001. Pour chaque ligne, la date et l'identité du validateur restent **EN ATTENTE** ; aucune preuve d'approbation n'est disponible.

| ID | Validation attendue / responsable pressenti | Avant / tickets concernés | Repli tant que non validé |
|---|---|---|---|
| D-01 | Propriétaire : nom commercial, nom légal et logo source | Publication identité ; T-005, T-006, T-016 | Nom de travail explicitement provisoire |
| D-02 | Propriétaire : adresse et lien Maps exacts | Publication contact ; T-006, T-016 | Masquer adresse et carte |
| D-03 | Propriétaire : téléphone officiel et autorisation WhatsApp | Publication contact ; T-006, T-016 | Aucun numéro ni lien actif |
| D-04 | Gérant : horaires hebdomadaires et exceptions | Commandes réelles ; T-009, T-014, T-016 | Commandes fermées |
| D-05 | Gérant : délai, intervalle, capacité, limites de quantité par ligne/commande | Créneaux et commandes réelles ; T-009, T-010, T-014 | Aucune valeur métier activée |
| D-06 | Gérant : validation écrite des 17 références, prix, disponibilité et noms ICE-02/ICE-03 | Catalogue réel et vente ; T-003, T-007, T-010, T-016 | Seed de démonstration isolé, checkout fermé |
| D-07 | Gérant : éligibilité, limites et arôme inclus ou facturé en supplément | Options actives ; T-003, T-007, T-010, T-013 | Suppléments désactivés |
| D-08 | Propriétaire : fichiers photo/logo et droits d'usage | Publication médias ; T-005, T-006, T-013 | Placeholders explicites |
| D-09 | Propriétaire/gérant : click & collect autorisé, responsable de surveillance et délai d'acceptation | Commandes réelles ; T-010, T-012, T-016 | Activation OFF |
| D-10 | Propriétaire/gérant : paiement au retrait et moyens acceptés, procédure de marquage payé | Encaissement réel ; T-010, T-012, T-016 | Aucun paiement simulé ni moyen annoncé |
| D-11 | Propriétaire : logistique, zone et frais de livraison | T-018 uniquement, hors MVP | Livraison absente |
| D-12 | Propriétaire : PSP, contrat et procédures | T-017 uniquement, hors MVP | Aucun paiement en ligne |
| D-13 | Responsable du commerce avec conseil qualifié : identité légale, information client, conservation et suppression | Collecte réelle de données ; T-011, T-015, T-016 | Données fictives isolées, pas de collecte réelle |
| D-14 | Responsable du commerce avec conseil qualifié : région d'hébergement, transferts et démarches applicables | Hébergement de données réelles ; T-002, T-016 | Environnements de test sans PII réelle |
| D-15 | Propriétaire : langue(s) de lancement | Publication ; T-005, T-006, T-016 | Français de travail, aucune traduction factice |
| D-16 | Gérant : annulation par rôle/statut, refus, absence au retrait, délai d'acceptation et éventuel remboursement | Flux opérationnel réel ; T-010, T-011, T-012 | Pas d'annulation client ni transition exceptionnelle non approuvée |
| D-17 | Propriétaire : vente en ligne de grains/machines | Extension hors MVP | Aucun article ajouté |
| D-18 | Propriétaire/comptable : prix TTC ou autre régime, taxes, frais, arrondis et justificatif | Totaux réels et vente ; T-010, T-011, T-016 | Aucune taxe ni règle comptable inventée |
| D-19 | Propriétaire : domaine, comptes d'hébergement, propriété et accès | Environnements distants ; T-002, T-016 | Aucun domaine ni compte choisi à sa place |
| D-20 | Gérant : ingrédients, allergènes et affirmations de composition | Publication fiches et vente ; T-007, T-013, T-016 | Aucune allégation sanitaire ou « sans alcool » non confirmée |

### Incohérences, ambiguïtés et suites techniques

| Réf. | Constat et sources | Traitement dans T-000 / suite requise |
|---|---|---|
| A-01 | Le kickoff §4 permet T-001 ; la consigne de cette exécution impose uniquement T-000 | La consigne utilisateur prévaut. T-001 reste TODO et n'est pas commencé |
| A-02 | `01-PRODUCT.md` et `06-ORDER-LIFECYCLE.md` décrivent click & collect/paiement au retrait ; P-001, D-09 et D-10 attendent validation | Cible de développement provisoire, aucune autorisation de service réel |
| A-03 | `04-ARCHITECTURE.md` fixe une stack cible ; l'ADR technique nommé T-001 est EN ATTENTE | Ne pas confondre cet ADR avec le ticket T-001. Compatibilité et versions exactes à vérifier au bootstrap ; aucun service distant créé dans T-000 |
| A-04 | Le diagramme de `06-ORDER-LIFECYCLE.md` omet les annulations présentes dans sa liste ; la politique D-16 reste ouverte | Avant T-012, aligner diagramme, matrice rôle/transition, validation serveur et tests ; ne pas activer les transitions exceptionnelles par supposition |
| A-05 | `07-API.md` prévoit `PRICE_CHANGED` sans référence au prix/catalogue vu par le client | À concevoir en T-010/T-011 : contrat de comparaison et nouvelle confirmation, sans accepter les montants client comme vérité ; tests changement de prix requis |
| A-06 | `05-DATA-MODEL.md`/`07-API.md` imposent hash seul du token et restitution du suivi après retry idempotent | À résoudre avant T-010 : mécanisme sécurisé de restitution du suivi après perte de réponse, liaison du retry au demandeur et empreinte du payload ; la clé idempotente seule ne doit pas ouvrir les commandes d'autrui. Couvrir QA-03/QA-14 sans stocker le token en clair |
| A-07 | Nom/téléphone sont requis dans `01-PRODUCT.md` et `07-API.md`, tandis que `05-DATA-MODEL.md` laisse téléphone ou email ouvert | Nom/téléphone restent l'hypothèse MVP ; aucun email ajouté. Confirmer nécessité et information client avec D-13 avant collecte réelle |
| A-08 | `03-MENU.md` contient 17 lignes et 4 suppléments ; descriptions, prix et source photographique non vérifiables localement | Démonstration uniquement ; ne pas présenter les recettes, disponibilités, allégations ou prix comme approuvés. D-06/D-07/D-08/D-20 restent ouverts |
| A-09 | `10-DEPLOYMENT.md` envisage un catalogue statique en panne DB ; le catalogue serveur reste la vérité selon AGENTS | Avant T-015/T-016, définir un éventuel cache de consultation issu du catalogue approuvé, sans prétendre à une disponibilité temps réel ; création de commande refusée si validation serveur impossible |
| A-10 | `business_settings.ordering_enabled` n'avait pas de valeur par défaut explicite dans le modèle ; l'API utilise `orderingEnabled` | Précision documentaire ajoutée : défaut DB false, configuration absente/invalide = fermé ; mapping API/DB à réaliser dans les tickets concernés |

### État réel et prérequis

- Dossier de spécifications uniquement : `AGENTS.md`, `README.md`, 12 documents `docs/`, 3 prompts, backlog, manifeste et modèle de PR. Aucun `package.json`, lockfile pnpm, code, migration, test, média source ou workflow CI.
- `git status --short` échoue : aucun dépôt Git détecté à cet emplacement. Aucun commit, branche ou PR créé. Initialiser le dépôt et son suivi avant les changements applicatifs de T-001 ; ne pas inventer de remote.
- Les exécutables Node, pnpm et Git sont détectés ; leurs versions et compatibilités ne sont pas validées ici (T-001). Les scripts applicatifs n'existent pas encore.
- Aucun besoin de compte Supabase/Vercel réel pour clore cette revue. Les accès, régions, secrets et responsabilités d'exploitation seront traités avec les environnements concernés, sans inscrire de secret dans les documents.

### Fermeture par défaut — portée de l'acceptation T-000

Le contrat de fermeture est précisé dans `04-ARCHITECTURE.md`. T-000 valide ce contrat **par revue documentaire**. Aucun service de commandes n'existe dans le dossier ; aucun comportement d'exécution n'est donc testé ou annoncé comme implémenté. Preuves attendues ensuite : défaut DB en T-003, configuration et tests horaires en T-009, rejet serveur en T-010, pause en T-014, validation manuelle de lancement en T-016. Une absence de configuration ne vaut jamais autorisation d'ouvrir.

### Plan de petites PR (proposition, aucune exécution au-delà de T-000)

Une PR par ticket, dans l'ordre T-001 fondation → T-002 CI → T-003 DB/RLS/seed démo → T-004 auth/RBAC → T-005 design/shell → T-006 pages → T-007 catalogue → T-008 panier → T-009 créneaux → T-010 transaction → T-011 checkout/suivi → T-012 dashboard/transitions → T-013 menu admin → T-014 paramètres/pause → T-015 recette → T-016 staging/lancement contrôlé. Cet ordre respecte les dépendances du backlog. Chaque PR inclura les tests et documents de son périmètre ; T-017/T-018 restent hors MVP. Les validations humaines bloquent l'activation concernée, sans empêcher la fondation avec placeholders.
