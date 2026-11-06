# 09 — Plan qualité et critères de recette

## Pyramide des tests
- **Unitaires (Vitest)** : prix centimes, remises éventuelles (aucune MVP), options/éligibilité, quantité, statuts, calcul des créneaux, conversions horaires.
- **Intégration** : transaction création commande, RLS, RBAC, idempotence, capacité créneau, snapshot prix, changement de disponibilité, audit.
- **E2E (Playwright)** : accueil → menu → panier → checkout → confirmation → admin → prêt → terminé.
- **Visuels** : viewport mobile 320/375/768/1440, navigation clavier, contraste, états vides/erreurs.

## Scénarios de recette critiques
| Référence | Scénario | Résultat attendu |
|---|---|---|
| QA-01 | Ajout puis retrait d'un produit | Total exact, panier synchronisé |
| QA-02 | Commande invité valide | Une seule commande persistée avec ses lignes |
| QA-03 | Double clic sur « confirmer » | Une seule commande, même confirmation |
| QA-04 | Prix falsifié dans requête | Total serveur inchangé ou erreur |
| QA-05 | Produit non disponible | Rejet explicite sans commande partielle |
| QA-06 | Créneau complet ou fermé | Rejet sans surbooking |
| QA-07 | Session publique vers admin | 401/403 ; aucune donnée privée |
| QA-08 | Staff modifie paramètres gérant | 403 |
| QA-09 | Deux transitions concurrentes | Une seule réussit, l'autre 409 |
| QA-10 | Connaître `publicNumber` sans token | Impossible de lire PII ou suivi privé |
| QA-11 | Fuseau Africa/Casablanca, changement d'heure | Créneaux cohérents |
| QA-12 | Refresh page confirmation | Commande toujours consultable via lien privé |
| QA-13 | Menu modifié après commande | Anciennes lignes conservent leur prix/nom |
| QA-14 | Échec réseau client après création | Retry idempotent retrouve la commande |
| QA-15 | Pause commande admin | Nouveau checkout rejeté, consultation du menu possible |

## Objectifs qualité
- TypeScript strict, lint et build sans erreur ; tests de sécurité bloquants.
- Accessibilité WCAG 2.2 AA comme cible, audits automatiques **et manuels**.
- Lighthouse performance/accessibilité/SEO **objectif ≥ 90** sur pages publiques mesurées en conditions représentatives ; suivre LCP, CLS et INP plutôt que le score seul.
- Images compressées, `lazy` hors hero, typographie lisible, liens et CTA visibles, gestion réseau lent.
- Pas de logs PII, pas de secrets exposés.

## CI attendue
Pour chaque PR : install figée (`pnpm --frozen-lockfile`), lint, typecheck, tests unitaires, build. E2E avec base de test isolée sur branches appropriées. Exécuter suites DB/RLS séparément contre environnement dédié. Ne pas déclarer « terminé » sans preuves de commande passées.

## Definition of Done
Acceptance criteria couverts, tests pertinents, migration réversible/plan de reprise, doc à jour, erreurs et loading states, validation sécurité/RBAC, capture d'écran pour changement UI, liens de preview disponibles lorsque déployés. Mettre à jour ticket.
