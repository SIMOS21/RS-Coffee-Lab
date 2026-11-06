# 02 — Brand, UX et UI

## Référence visuelle
Photos fournies : intérieur bois foncé, comptoir et machines expresso, niches hexagonales, bandeaux lumineux chauds, tasse « RS », carte sombre avec accent champagne/doré. Le résultat doit conserver cette atmosphère authentique : **ne pas remplacer les vraies photos par un décor café générique**.

## Identité de travail (tokens à ajuster à l'écran)
- `espresso-950: #17120F` — arrière-plan principal.
- `coffee-900: #241913` — surfaces foncées.
- `walnut-700: #634532` — détails bois.
- `amber-500: #CF944B` — accent, prix, liens sélectionnés.
- `cream-100: #F6EFE4` — texte clair et sections lumineuses.
- `muted-400: #B9AB9B` — texte secondaire.
- Contraste : vérifier WCAG AA ; le doré décoratif ne doit pas sacrifier la lisibilité.
- Typographie : sans serif lisible pour toute l'interface, serif éditoriale limitée aux grandes accroches.
- Ambiance premium, chaleureuse, sans animations lourdes ; micro-interactions discrètes.

## Arborescence
```text
/                         Accueil + photos + offres vedettes + CTA
/menu                     Catalogue catégorisé et filtres
/about                    Histoire et expérience (contenu à valider)
/contact                  Adresse, carte, horaires, lien de contact (après confirmation)
/cart                     Panier
/checkout                 Finalisation à emporter
/order/[trackingToken]    Statut minimal d'une commande, jeton non devinable
/admin/login              Connexion personnel
/admin/orders             Tableau des commandes
/admin/menu               Catalogue et disponibilités
/admin/settings           Horaires, créneaux, pause commande
```

## Accueil — sections prioritaires
1. Navigation claire et logo réellement vérifié.
2. Hero photo authentique, texte court et deux CTA visibles.
3. Catégories du menu avec aperçu prix en DH.
4. Pourquoi venir : lieu / savoir-faire — rester factuel, sans inventer de promesses.
5. Galerie photo responsive optimisée.
6. Infos pratiques vérifiées (horaires, adresse, contacts).
7. Footer : navigation, politique de confidentialité, mentions.

## Menu
- Carte produit : photo quand disponible, titre, prix, description courte, badge « indisponible » uniquement si réellement indisponible, bouton ajouter.
- Les catégories sont : Coffee, Milk Drinks, Cappuccino, Tea, Ice & Fresh, Bakery & Dessert.
- Si une option/arôme ne s'applique pas à un produit, ne pas l'afficher. Validation métier requise.
- Modale ou panneau rapide avec quantité et personnalisations, navigation clavier, aria labels.

## Checkout
- Résumé fixe/logique, total calculé par le serveur au submit, affichage frais s'il y en a et si confirmés.
- Champs nécessaires uniquement ; erreurs inline ; bouton désactivé pendant la soumission avec idempotency key stable.
- Si prix/disponibilité évolue depuis le panier : afficher la différence et demander une nouvelle confirmation, pas de facturation silencieuse.
- Après succès, rediriger vers suivi et afficher le numéro lisible de la commande.

## Espace admin
- Utilisable sur mobile/tablette derrière le comptoir, gros boutons de statut, feedback visible.
- Filtres « Nouvelles », « En cours », « Prêtes », « Terminées ».
- Pas de suppression silencieuse ; toutes mutations journalisées.

## Accessibilité / performance
- Navigation clavier, focus visible, contrastes AA, labels explicites, annonces de statut accessibles.
- Cibles tactiles confortables, pas d'UI accessible uniquement au survol.
- Images Next/Image ou équivalent, formats optimisés, alt utile ; pas de texte important noyé dans une image de menu.
- Réduire animations via `prefers-reduced-motion`; supports 320px → desktop.

## Livrables design à faire approuver
Moodboard, version mobile accueil/menu/checkout, maquette admin commandes, système de composants, copywriting final, photos sélectionnées. Aucun contenu factuel non validé publié.
