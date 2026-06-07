# Run a Progressive Rollout with Guardrails

## Objective

Planejar rollout gradual de uma feature de risco com flags, cohorts, guardrails e kill switch.

## Setup

Mudanca de checkout, billing ou ranking com potencial de afetar negocio mesmo sem erro tecnico alto.

## Tasks

- escolher cohort inicial;
- definir metricas de sucesso e guardrails;
- escrever criterio de pause/rollback;
- separar feature flag de experiment flag;
- decidir quando remover a flag.

## Exit Criteria

Rollout tem dono, guardrails impedem dano global e a estrategia de rollback nao depende de improviso.

## Deliverable

Plano de rollout por fases com gates e kill switch.

## Linked Concepts

Progressive delivery, flags, experimentation, rollback, guardrails.
