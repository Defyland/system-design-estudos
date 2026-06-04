# 05 - Arquitetura e Operacao

## Por que esta area existe

Este bloco junta as decisoes que mudam o formato do sistema e o custo operacional dele.

## O que estudar aqui

- microservicos vs monolitos
- service mesh
- resiliencia e deployment
- concorrencia e paralelismo
- IO-bound vs CPU-bound
- containers e cold start
- scaling horizontal vs vertical

## O que foi absorvido

- fragmentacao excessiva entre arquitetura, deploy e escalabilidade

## Casos reais para estudar esta area

- [Shopify - Pods and Modular Monolith](../../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- [Discord - Elixir Realtime Scale](../../real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- [Cloudflare - Edge Platform](../../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- [Uber - Cadence Workflows](../../real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)

## Chapters que puxam esta area

- [Chapter 01 - Pod Isolation and Tenant Routing](../../chapters/chapter-01-pod-isolation-and-tenant-routing.md)
- [Chapter 02 - Relational Scaling and Operational Discipline](../../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 07 - Durable Workflows, Retries and Compensation](../../chapters/chapter-07-durable-workflows-retries-and-compensation.md)
- [Chapter 09 - Realtime Concurrency and Workload Isolation](../../chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)
- [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](../../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)

## Apoios desta area

- [Notes](./notes.md)
- [Example - Smaller SaaS Architecture Evolution](./examples/smaller-saas-architecture-evolution.md)
- [Snippet - Boundary and Scaling Checklist](./snippets/architecture-boundary-and-scaling-checklist.md)

## Regra de implementacao

- Rails primeiro para boundaries e jobs
- Elixir para concorrencia
- Go para servicos simples e IO-bound
