# 12 — Roadmap par phases et points de contrôle

Les durées ne sont **pas** contractuelles et dépendent du contenu validé, des accès et du nombre de développeurs. Ne pas donner de faux délai fixe.

## Phase 0 — Discovery et validation
**Sorties** : revue du menu, logo, actifs, attentes du shop, cas d'usage, choix MVP, blocages de `docs/11-DECISIONS.md`. L'architecture peut démarrer avec des placeholders tant que le service production reste désactivé.

## Phase 1 — Fondations
**Sorties** : repo, scripts, CI, conventions, variables exemples, schema DB/migrations, RLS, seed de démonstration, auth personnel, design tokens. **Gate** : tests DB/RLS et pipeline vert.

## Phase 2 — Site vitrine / catalogue
**Sorties** : accueil, menu, galerie, about/contact avec contenu validé ou masqué, produits accessibles depuis DB, mobile/SEO. **Gate** : QA UX, responsive, performance.

## Phase 3 — Commandes MVP
**Sorties** : panier, checkout, disponibilités, création transactionnelle, token de suivi, récap et statuts. **Gate** : scénarios de sécurité/idempotence/horaires validés.

## Phase 4 — Dashboard métier
**Sorties** : login, gestion commandes, catalogue, pause commandes, horaires, audit minimal. **Gate** : RBAC, erreurs, concurrence et test personnel.

## Phase 5 — Préproduction et lancement
**Sorties** : parcours E2E, tests mobiles réels, procédures, mentions légales validées, domaine, backups, supervision, formation. **Gate** : checklist `docs/10-DEPLOYMENT.md` complète, approbation de lancement et commandes activées volontairement.

## Phase 6 — Extensions après preuves d'usage
Paiement en ligne (contrat, webhook, sécurité), livraison si opérationnellement viable, fidélité, multi-langue AR/EN, analytics approfondis, e-mail / WhatsApp API si contractualisé.

## Critère de passage entre phases
Un livrable démontrable + tests + décision sur risques/ambiguïtés + documentation mise à jour. Pas de big-bang avec toutes les fonctionnalités à la fois.
