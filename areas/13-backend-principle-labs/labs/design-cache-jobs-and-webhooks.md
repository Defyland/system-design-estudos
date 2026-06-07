# Design Cache, Jobs and Webhooks

## Objective

Separar request sincrono de efeitos externos usando cache, background jobs e webhook delivery com retry seguro.

## Setup

Endpoint de checkout ou onboarding que grava dado local, invalida leitura cara e dispara integracao externa.

## Tasks

- defina o que fica no request;
- mova efeitos lentos para jobs;
- escolha estrategia de cache e invalidacao;
- modele webhook com assinatura, retry e idempotencia;
- descreva o que acontece se integracao externa cair por 30 minutos.

## Exit Criteria

Request principal fecha rapido, estado local continua coerente e efeitos externos podem ser reprocessados sem duplicar impacto.

## Deliverable

Diagrama do write path, job payload, politica de retry e plano de invalidacao.

## Linked Concepts

Cache-aside, queues, retries, webhooks, eventual consistency.
