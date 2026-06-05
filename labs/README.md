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
- por que Rails basta ou por que preciso comparar com Elixir/Go

Cada lab agora tambem comeca com um `First Pass` curto para obrigar a escolha da forma mais simples antes de desenhar o experimento.

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

## O Que Fazer Logo Depois

- rode um card em [reviews/](../reviews/README.md)
- compare com uma decisao parecida em [decision-contrasts/](../decision-contrasts/README.md)
- se o tema ja estiver firme, suba para um [capstone](../capstones/README.md)

## Labs por chapter

- [Chapter 01 - Relational Scaling and Operational Discipline](./chapters/chapter-01-relational-scaling-and-operational-discipline.md)
- [Chapter 02 - Pod Isolation and Tenant Routing](./chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 03 - Idempotent Writes Under Ambiguous Failure](./chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 04 - Event Backbone, Partitions and Consumer Scale](./chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 05 - Durable Workflows, Retries and Compensation](./chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](./chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 07 - Critical Checkout Flows and Auth Boundaries](./chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)
- [Chapter 08 - Blob Durability and Storage Tiers](./chapters/chapter-08-blob-durability-and-storage-tiers.md)
- [Chapter 09 - Search Indexing and Permission-Aware Retrieval](./chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 10 - CDN Placement, DNS and Cache Invalidation](./chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)
- [Chapter 11 - Geospatial Indexing for Marketplace Search](./chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)
- [Chapter 12 - Distributed IDs and Ordering Guarantees](./chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)
- [Chapter 13 - Realtime Concurrency and Workload Isolation](./chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Chapter 14 - Feed Ranking and Fanout Trade-offs](./chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
