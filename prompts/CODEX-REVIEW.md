# Prompt Codex — revue indépendante de PR

Agis comme reviewer exigeant de la PR courante. Lis `AGENTS.md`, `docs/05-DATA-MODEL.md`, `docs/06-ORDER-LIFECYCLE.md`, `docs/08-SECURITY-PRIVACY.md`, `docs/09-QUALITY.md`, le ticket correspondant et le diff réel.

Cherche avant tout :
- Calcul de prix piloté par le client, flottants monétaires, options indues.
- Permissions admin uniquement front-end, RLS incorrectes, fuite PII/secrets.
- Commandes en double, race conditions de stock/créneau, transitions d'état illégales.
- Bugs de fuseau Africa/Casablanca et d'horaires.
- Ruptures UX mobile/accessible, invalidation cache menu, erreurs silencieuses.
- Tests critiques manquants, doc incohérente et hypothèses métier présentées comme faits.

Classe les problèmes par gravité (`bloquant`, `majeur`, `mineur`) avec fichier/ligne, preuve et correctif recommandé. Exécute les tests possibles ; n'affirme pas qu'ils passent sans les lancer. Ne fusionne pas et ne déploie pas sans autorisation.
