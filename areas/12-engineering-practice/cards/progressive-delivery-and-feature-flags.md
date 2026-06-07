# Progressive Delivery and Feature Flags

## When to Use

Quando mudanca precisa chegar gradualmente, por cohort, tenant ou ambiente, com capacidade real de parar ou reverter antes do blast radius crescer.

## What Breaks First

Flag vira lixo permanente, rollout nao tem guardrail, e o time confunde toggles de operacao com experimentos de produto.

## Design Moves

Separe kill switch, release flag e experiment flag, modele dono e data de limpeza, use cohorts pequenas no inicio e ligue rollout a sinais de negocio e confiabilidade.

## Interview Trap

Tratar feature flag como if aleatorio no codigo. Sem ownership e lifecycle, vira acoplamento escondido.

## Practice Drill

Desenhe um rollout de cobranca nova por tenant. Inclua cohort, guardrail, owner, criterio de pause e momento de remover a flag.

## Source Anchor

- [LaunchDarkly - Feature flag best practices](https://launchdarkly.com/docs/guides/flags/technical-debt).
- [Argo Rollouts Documentation](https://argo-rollouts.readthedocs.io/en/stable/).
