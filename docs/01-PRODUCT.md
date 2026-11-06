# 01 — Product Requirements Document (PRD)

## Positionnement
RS Coffee Lab : une expérience café chaleureuse, premium mais accessible. Le site doit valoriser l'univers physique du lieu (bois, tons espresso et lumière ambrée), puis transformer cette visite en commande simple.

## Utilisateurs
- **Visiteur** : veut connaître le lieu, les produits, les tarifs, l'adresse et les horaires **après validation métier**.
- **Client** : veut choisir des articles, personnaliser si autorisé, commander sans créer de compte et savoir quand retirer.
- **Personnel** : veut voir les commandes nouvelles et les faire progresser rapidement.
- **Gérant** : veut modifier le catalogue, les prix, les ruptures, les horaires, l'ouverture des commandes et consulter un historique minimum.

## MVP — IN
1. Accueil, présentation et photos du shop, CTA « Voir le menu » / « Commander ».
2. Menu en catégories, fiches légères, prix, disponibilité, options configurées.
3. Panier persisté localement, quantité modifiable, totaux prévisionnels.
4. Checkout invité : nom, téléphone, mode à emporter, créneau valide, notes facultatives, consentement/mentions adaptés.
5. Paiement au retrait ; pas de carte bancaire saisie.
6. Confirmation + lien de suivi privé avec statut actualisable.
7. Dashboard personnel avec listes et statuts des commandes, recherche et filtres simples.
8. Administration des produits, catégories, prix, visibilité/rupture, créneaux, pause commandes.
9. Pages de contact, politique de confidentialité et mentions à compléter à partir de données vérifiées.
10. SEO local de base, accessibilité et responsive.

## Hors périmètre MVP
- Paiement bancaire, livraison à domicile, programme de fidélité, coupons, multi-shop, compte client obligatoire, caisse/POS, SMS/WhatsApp automatique, inventaire détaillé, fiscalité automatisée, application native.
- Un lien WhatsApp **manuel** peut être étudié si le numéro officiel est fourni ; ce n'est pas une confirmation serveur de commande.

## Scénarios clés
### Client
1. J'ouvre le site sur mobile et découvre le menu sans friction.
2. J'ajoute 2 cafés et un croissant, je vérifie le prix et modifie les quantités.
3. Je remplis mes coordonnées et choisis un créneau proposé par le shop.
4. Je valide une fois, reçois un numéro et accède au suivi.
5. Le personnel accepte, prépare et marque prêt ; je présente mon numéro au retrait.

### Personnel
1. Je m'authentifie et vois immédiatement les nouvelles commandes.
2. J'accepte/refuse avec motif approprié ; je passe « En préparation », « Prête », « Remise ».
3. Si un produit manque, le gérant le désactive pour les nouvelles commandes.

## Contraintes de confiance
- Une commande ne doit jamais disparaître ou être créée en double à cause d'un double clic.
- Le total confirmé doit provenir des prix serveur et être figé dans la commande.
- Aucune commande ne peut être faite dans un créneau impossible ou lorsque les commandes sont suspendues.
- Les données personnelles ne doivent pas être visibles dans des pages publiques.
- Un échec de notification facultative ne doit pas effacer la commande persistée.

## Indicateurs après lancement
Conversion visite menu → panier → commande ; commandes terminées ; délai d'acceptation/préparation ; commandes refusées ; taux d'erreurs checkout. Mesure agrégée, pas de données personnelles inutilement stockées dans les analytics.

## Non négociable
Les informations du shop non lisibles sur les photos sont inconnues. Voir `docs/11-DECISIONS.md`.
