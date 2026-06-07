# Deploy Rollback and Kill Switch

## Trigger

Deploy piora erro, latencia, custo ou comportamento funcional e precisa ser revertido sem nova janela heroica.

## Signals

- regressao logo apos rollout;
- cohort nova pior que baseline;
- guardrails disparando;
- suporte ou negocio indicando comportamento incorreto antes do pager.

## Immediate Actions

- parar rollout;
- decidir entre rollback binario, feature flag ou kill switch;
- preservar comparacao entre cohort nova e antiga;
- comunicar impacto e horizonte de mitigacao.

## Stabilize

Rollback parcial, desligamento de feature, ring-by-ring halt, fail-safe default e bloqueio temporario de novos deploys ate a raiz ficar clara.

## Deep Checks

Compatibilidade de schema, dependencia compartilhada, data migration irreversivel, cobertura de smoke test e diferenca entre codigo desligado e dados persistidos.

## Exit Criteria

Rollout interrompido ou revertido, feature perigosa neutra, sistema em comportamento esperado e proximo rollout condicionado a guardrails novos.

## Practice Drill

Escreva o playbook para um rollout de checkout que piora p95 e conversao so em 10% dos usuarios. Decida ring halt, kill switch, rollback e criterio de retomada.

## Source Anchor

- [Argo Rollouts - Rollback](https://argo-rollouts.readthedocs.io/en/stable/features/rollback/).
- [LaunchDarkly - Feature flags and kill switches](https://launchdarkly.com/docs/home/flags/killswitch).
