# 10 — Déploiement, exploitation et lancement

## Environnements
- **Local** : développeur / Codex avec DB locale ou d'essai.
- **Staging / Preview** : domaine privé, données fictives, secrets et base séparés, accès staff de test.
- **Production** : domaine officiel, compte propriétaire, variables d'env spécifiques, logs redigés, sauvegardes testées.

## Configuration / DNS
- Valider la propriété du domaine, les coordonnées officielles du shop, politique de confidentialité, adresse et horaires.
- Configurer DNS/HTTPS, paramètres Supabase, URLs de redirection Auth, domaines Storage et protections preview.
- Ne pas indexer staging ; configurer metadata, sitemap/robots adéquats uniquement pour pages publiques en prod.

## Checklist avant ouverture
- [ ] Orthographe du nom/logo et photos publiables validées.
- [ ] 17 produits et éventuels suppléments revus, prix réels approuvés.
- [ ] Adresse, téléphone, horaires et informations légales exacts.
- [ ] Créneaux et lead time paramétrés ; fermer commande par défaut en cas de config manquante.
- [ ] Politique de gestion des commandes validée (qui surveille, quand, délai d'acceptation).
- [ ] Personnel authentifié, rôles vérifiés, comptes inactifs révoqués.
- [ ] Tests QA-01 à QA-15 passés en staging.
- [ ] RLS et permissions vérifiées ; aucun secret dans dépôt ou navigateur.
- [ ] Conformité données personnelles revue (CNDP/loi 09-08, hébergement/transfert, mentions).
- [ ] Sauvegarde/restauration et rollback testés.
- [ ] Parcours commande complet testé sur téléphone réel avec une commande fictive puis purge test contrôlée.
- [ ] Règle « ordering_enabled » basculée volontairement par gérant au lancement.

## Runbook quotidien (gérant)
**Avant service** : ouvrir le dashboard, vérifier connexion/son (si prévu), horaires, prix, disponibilité, créneaux, équipe responsable. Activer prise de commandes lorsque le personnel est prêt.

**Pendant service** : surveiller `pending`, accepter/refuser, modifier disponibilités, utiliser « pause » en cas de surcharge. Vérifier les commandes avec créneau proche.

**Après service** : solder ou traiter explicitement commandes restantes, noter incidents, fermer commande en cas d'horaires exceptionnels.

## Incidents
- **DB/API indisponible** : désactiver prise de commandes (si possible), afficher message public, conserver catalogue statique, accepter ventes physiques seulement.
- **Commande doublée** : investiguer idempotence / audit ; ne pas supprimer sans traçabilité.
- **Compte compromis** : désactiver accès, révoquer sessions et secrets concernés, analyser audit.
- **Mauvais prix** : désactiver produit, corriger, examiner commandes déjà acceptées et contacter clients selon politique métier.

## Évolutions futures
Paiement en ligne : comparer prestataires marocains (dont CMI) sur contrat, commission, API/webhooks, remboursement, homologation et environnement test. Livraison : seulement après validation zone, logistique, coût, créneaux et charge opérationnelle. Statistiques agrégées, fidélité ensuite.
