# Dia 03 - Discrimination Pass

## Objetivo

Parar de lembrar so o nome da solucao e comecar a separar opcoes parecidas.

## Ordem

1. releia rapidamente os cards em pares:
   - [Card 01](./cards/01-pod-isolation-and-tenant-routing.md) + [Card 02](./cards/02-relational-scaling-and-operational-discipline.md)
   - [Card 05](./cards/05-idempotent-writes-under-ambiguous-failure.md) + [Card 07](./cards/07-durable-workflows-retries-and-compensation.md)
   - [Card 10](./cards/10-edge-rate-limiting-waf-and-gateway-boundaries.md) + [Card 13](./cards/13-critical-checkout-flows-and-auth-boundaries.md)
   - [Card 11](./cards/11-cdn-placement-dns-and-cache-invalidation.md) + [Card 03](./cards/03-blob-durability-and-storage-tiers.md)
2. depois faca os contrastes:
   - [Replica vs Cache-Aside](../decision-contrasts/01-read-replica-vs-cache-aside.md)
   - [Pod Isolation vs Microservices](../decision-contrasts/02-pod-isolation-vs-microservices.md)
   - [Idempotency Key vs Unique Index](../decision-contrasts/05-idempotency-key-vs-unique-index.md)
   - [Workflow Duravel vs Jobs Encadeados](../decision-contrasts/07-durable-workflow-vs-chained-jobs.md)

## Mixed Oral Checks

- se eu quero throughput de leitura, por que isso nao implica cache automaticamente?
- se eu quero retry seguro, por que isso nao implica workflow engine automaticamente?
- se eu tenho edge e gateway, por que isso nao elimina autorizacao semantica no app?
- se eu tenho blob store, por que isso nao elimina metadata relacional?

## Done When

- voce consegue responder `por que nao a outra abordagem?` sem abrir o chapter
- voce consegue dizer o primeiro sinal de overengineering em pelo menos 5 temas
