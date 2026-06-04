# Playbook de Implementacao e Experimentos

## Objetivo

Usar implementacoes pequenas para fixar conceitos que vieram dos casos reais.

## Ordem de stack

1. Ruby on Rails
2. Elixir
3. Go

## Regra de escolha

Use Rails como default quando o objetivo for:
- modelar dominio
- experimentar APIs
- testar auth, idempotencia, cache, leitura e escrita
- validar fluxos de negocio

Use Elixir quando o objetivo for:
- concorrencia
- supervision
- realtime
- filas ou workers com forte coordenacao

Use Go quando o objetivo for:
- throughput
- servicos simples e IO-bound
- proxies, gateways, consumers ou utilities de infraestrutura

## Formato recomendado de experimento

Cada experimento deve responder:
- qual conceito estou testando
- qual caso real inspirou isso
- qual area do curso isso cobre
- por que Rails basta ou por que preciso comparar com Elixir ou Go

## Ideias de experimentos bons

- cache-aside com expiracao e invalidacao
- idempotency key em endpoint mutante
- job com retry, DLQ e deduplicacao
- gerador de IDs estilo Snowflake
- upload flow para blob store
- rate limiting por tenant ou por token
- workflow de pagamento com compensacao

## Quando parar

Nao transforme estudo em produto.

O experimento deve parar quando voce conseguir responder:
- o que esse design resolve
- onde ele quebra
- quais trade-offs ele introduz

## Labs por chapter

- [Chapter 01 - Pod Isolation and Tenant Routing](./chapters/chapter-01-pod-isolation-and-tenant-routing.md)
- [Chapter 02 - Relational Scaling and Operational Discipline](./chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 03 - Blob Durability and Storage Tiers](./chapters/chapter-03-blob-durability-and-storage-tiers.md)
- [Chapter 04 - Search Indexing and Permission-Aware Retrieval](./chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 05 - Idempotent Writes Under Ambiguous Failure](./chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 06 - Event Backbone, Partitions and Consumer Scale](./chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 07 - Durable Workflows, Retries and Compensation](./chapters/chapter-07-durable-workflows-retries-and-compensation.md)
- [Chapter 08 - Distributed IDs and Ordering Guarantees](./chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)
- [Chapter 09 - Realtime Concurrency and Workload Isolation](./chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)
- [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](./chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 11 - CDN Placement, DNS and Cache Invalidation](./chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)
- [Chapter 12 - Geospatial Indexing for Marketplace Search](./chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)
- [Chapter 13 - Critical Checkout Flows and Auth Boundaries](./chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
- [Chapter 14 - Feed Ranking and Fanout Trade-offs](./chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
