# 03 — Catalogue initial d'après la photo du menu

> **SOURCE = photographie fournie par le propriétaire.** Les prix ci-dessous sont une transcription de travail, à valider. Orthographe harmonisée en français pour l'affichage ; le libellé d'origine est conservé lorsque pertinent. Aucune photo spécifique à chaque produit n'est encore fournie. **17 références**.

Les montants sont en **DH/MAD** et seront stockés en base en **centimes** (`6 DH → 600`). `available` reste administrable ; la publication nécessite une validation de ce fichier.

| Code proposé | Catégorie | Nom affiché proposé | Libellé de la carte | Prix DH | Notes de la carte |
|---|---|---|---|---:|---|
| COF-01 | Coffee | Café Spécial | Café Spécial | 6 | Riche, intense et aromatique |
| COF-02 | Coffee | Café Moka | Café Moka | 8 | Équilibré et gourmand |
| COF-03 | Coffee | Café au lait | Café au Lait | 7 | Doux et onctueux |
| COF-04 | Coffee | Café aromatisé | Café Aromatisé | 7 | Vanille, caramel ou chocolat — confirmer la variation |
| MIL-01 | Milk Drinks | Lait chocolat | Lait Chocolat | 7 | Chocolat chaud crémeux |
| MIL-02 | Milk Drinks | Lait chaud | Lait Chaud | 6 | Simple et réconfortant |
| CAP-01 | Cappuccino | Cappuccino | Cappuccino | 8 | Espresso, lait mousseux, touche de cacao |
| CAP-02 | Cappuccino | Cappuccino Royal | Cappuccino Royal | 10 | Plus de mousse, plus de plaisir |
| TEA-01 | Tea | Thé normal | Thé Normal | 6 | Fraîcheur et tradition |
| TEA-02 | Tea | Thé spécial | Thé Spécial | 8 | Composition à confirmer |
| ICE-01 | Ice & Fresh | Ice coffee | Ice coffee | 15 | Composition à confirmer |
| ICE-02 | Ice & Fresh | Ice coffee with water | Ice coffe with water (lecture à vérifier) | 13 | Nom et recette à confirmer |
| ICE-03 | Ice & Fresh | Mojito virgin | Mijoto virgin (lecture à vérifier) | 13 | Sans alcool présumé d'après le libellé « virgin », confirmer |
| ICE-04 | Ice & Fresh | Fresh cocktail Mojito | Fresh cocktail Mojito | 13 | Composition à confirmer |
| BAK-01 | Bakery & Dessert | Croissant français | Croissant français | 6 | Allergènes et poids à confirmer |
| BAK-02 | Bakery & Dessert | Croissant normal | Croisson normal (orthographe du menu) | 4 | Allergènes et poids à confirmer |
| BAK-03 | Bakery & Dessert | Tiramisu café | Tiramisu coffe (orthographe du menu) | 13 | Allergènes et composition à confirmer |

## Suppléments visibles

| Supplément | Sur la carte | Prix DH | Application |
|---|---|---:|---|
| Miel | Miel | +1 | Produits éligibles à confirmer |
| Arôme vanille | Arômes (Vanille, Caramel, Chocolat) | +1 | Éligibilité/limite à confirmer |
| Arôme caramel | Idem | +1 | Éligibilité/limite à confirmer |
| Arôme chocolat | Idem | +1 | Éligibilité/limite à confirmer |

**Important :** ne pas rendre ces suppléments actifs sur tous les produits sans confirmation du gérant. Le café aromatisé inclut peut-être déjà un arôme dans son prix de base ; éviter de facturer deux fois. Le menu affiche « +1 DH » pour les arômes, sans préciser entièrement les règles.

## Informations à faire compléter avant mise en vente
- Produits réellement vendables en commande à emporter et horaires de disponibilité.
- Variation de tailles, chaud/froid, sucre, lait végétal, ingrédients, allergènes, images individuelles.
- Possibilité de vendre du café en grains / produits en rayon (visibles dans le shop, mais **non confirmés comme vendus en ligne**).
- Prix actualisés, recettes et nom exact de ICE-02 / ICE-03.
- TVA et règles de facturation à valider avec le commerce/comptable.

## Règle d'implémentation
Seed initial avec références stables, catégories triées, prix en centimes, description facultative et `is_available`. Marquer les entrées qui nécessitent confirmation ; conserver les originaux dans la documentation, sans les présenter comme certifiés. Si validation du menu manque, activer le mode consultation et **désactiver le checkout de production**.
