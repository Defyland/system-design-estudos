# Instrument Observability and Graceful Shutdown

## Objective

Adicionar sinais minimos e shutdown previsivel para um servico HTTP com workers.

## Setup

API com health check, fila local ou externa e um job que pode ficar em voo no momento do SIGTERM.

## Tasks

- escolher logs, metricas e traces minimos;
- expor readiness e liveness;
- drenar requests e jobs em shutdown;
- definir timeout de encerramento;
- provar que nao deixa trabalho zumbi ou request cortado cedo demais.

## Exit Criteria

Deploy e restart nao perdem request importante, jobs em voo tem destino claro e o time tem sinais suficientes para detectar regressao.

## Deliverable

Checklist de startup/shutdown, sinais obrigatorios e experimento de validacao.

## Linked Concepts

Observability, liveness, readiness, draining, SIGTERM.
