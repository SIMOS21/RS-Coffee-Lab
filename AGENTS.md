# AGENTS.md — RS Coffee Lab

## Mission
Construire et maintenir un site web de coffee shop fiable, performant et accessible, avec commande à emporter et back-office. Tous les changements doivent respecter `docs/01-PRODUCT.md`, `docs/04-ARCHITECTURE.md`, `docs/06-ORDER-LIFECYCLE.md`, `docs/08-SECURITY-PRIVACY.md` et le ticket sélectionné dans `tasks/TASKS.md`.

## Ordre de travail obligatoire
1. Lire le ticket, puis les docs pertinentes ; inspecter l'état réel du dépôt avant de modifier.
2. Exposer les hypothèses ; s'il manque une donnée métier, utiliser une valeur de configuration désactivée ou un placeholder, **jamais une invention**.
3. Implémenter **une tâche à la fois** ; garder un périmètre de PR petit et cohérent.
4. Modifier tests, migrations et documentation dans la même PR que la fonctionnalité.
5. Exécuter les contrôles disponibles (`pnpm lint`, `pnpm typecheck`, `pnpm test`, `pnpm build` et, pour les parcours concernés, `pnpm test:e2e`). Si une commande manque avant son ticket de configuration, le signaler ; ne pas prétendre l'avoir exécutée.
6. Fournir en fin de tâche : fichiers modifiés, choix, tests exécutés et résultats, risques, éléments à valider, prochaine tâche recommandée. Mettre à jour `tasks/TASKS.md`.

## Stack cible
Next.js App Router + TypeScript strict, Tailwind CSS, shadcn/ui, Zod, PostgreSQL/Supabase (Auth et Storage), Vitest et Playwright, Vercel. Utiliser `pnpm`; versions exactes à figer au premier ticket après vérification de compatibilité. Ne pas ajouter de dépendance de production sans justification.

## Conventions impératives
- Français pour le contenu public initial ; composants et code en anglais descriptif.
- Configuration des horaires et dates en `Africa/Casablanca`, stockage UTC.
- Tous les prix en **centimes MAD entiers** ; **jamais** de flottants pour totaliser ou persister un prix.
- Le catalogue/prix/disponibilité côté serveur est la seule source de vérité. Ne jamais faire confiance au prix envoyé par un client.
- Faire toutes les mutations sensibles côté serveur avec authentification + autorisation vérifiée **dans chaque handler/action**.
- Ne jamais exposer `service_role`, jetons, mots de passe ou données clients dans le navigateur, les logs, la télémétrie ou les commits.
- Activer RLS, utiliser des privilèges minimaux et couvrir l'absence d'accès aux autres commandes.
- Les commandes doivent être atomiques, idempotentes et testées contre les doubles soumissions.
- Aucune intégration de paiement réel, notification tierce, livraison ou donnée de contact publique sans validation explicite dans `docs/11-DECISIONS.md`.
- Préférer des composants accessibles, responsive, avec états chargement, vide, erreur et succès.
- Ne jamais prendre une capture d'écran de menu comme unique source dynamique de produits ; les produits sont structurés en base.

## Règles de changement
Ne pas modifier les décisions métier, les prix ou le périmètre du MVP sans consigner une décision. Toute modification du flux de commande doit mettre à jour diagramme/statuts, validation côté serveur et tests. Pas de déploiement production ni d'insertion de véritables coordonnées clients sans accord du propriétaire.

## Code review rules
Bloquer les PR où : l'accès admin n'est vérifié que dans l'UI ; une mutation publique écrit directement dans des tables sensibles ; des montants côté client sont acceptés ; les statuts d'une commande peuvent sauter des transitions interdites ; un secret apparaît côté client ; une requête publique permet l'énumération des commandes ; des tests critiques sont absents.
