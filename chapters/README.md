# Chapters

Sequencia guiada de leitura por decisao arquitetural, nao por empresa inteira.

## Ordem Canonica

Comece em `Chapter 01` e siga a numeracao em ordem.

[STUDY_ORDER.md](../STUDY_ORDER.md) explica as fases e o ritmo de estudo da mesma trilha.

## Como pensar um chapter

Cada chapter pega uma fatia de um caso real:
- comeca por uma historia curta de produto ou operacao
- deixa claro onde esse conhecimento aparece antes da teoria
- passa pelo `First Principles Design Pass` antes de escolher arquitetura final
- mostra qual problema existia
- ancora isso em um caso real
- mostra como esse tema aparece em entrevista
- fecha com conceito, trade-off, codigo e sintese decisional

No fim de cada chapter voce deve sair sabendo:
- quando usar
- por que usar
- por que o caso real usou
- quais trade-offs pesar
- quais sinais indicam que a escolha esta errada

## Regra de Fixacao

Cada chapter tambem deve ter checkpoints curtos ao longo da leitura:
- pergunta rapida
- resposta curta em linguagem simples
- armadilha comum
- correcao curta

Os labs seguem a mesma ideia: drill curto, gabarito oral imediato e resposta ruim corrigida na hora.

## First Principles First

Todo chapter agora tem um `First Principles Design Pass` antes da solucao tecnica:
- `Requirement Less Dumb`
- `Delete`
- `Simplify`
- `Accelerate`
- `Automate Last`

O objetivo e impedir que a leitura comece por ferramenta. Primeiro voce limpa o requisito, o desenho e o ciclo de aprendizado. So depois entra em banco, fila, cache, edge ou runtime.

## Depois do Chapter

Quando terminar um chapter:
1. rode o card correspondente em [reviews/](../reviews/README.md)
2. escolha um contraste vizinho em [decision-contrasts/](../decision-contrasts/README.md)
3. uma vez por semana, puxe um [capstone](../capstones/README.md)

## Sequencia Principal

- [Chapter 01 - Relational Scaling and Operational Discipline](./chapter-01-relational-scaling-and-operational-discipline.md)
- [Chapter 02 - Pod Isolation and Tenant Routing](./chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 03 - Idempotent Writes Under Ambiguous Failure](./chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 04 - Event Backbone, Partitions and Consumer Scale](./chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 05 - Durable Workflows, Retries and Compensation](./chapter-05-durable-workflows-retries-and-compensation.md)
- [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](./chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 07 - Critical Checkout Flows and Auth Boundaries](./chapter-07-critical-checkout-flows-and-auth-boundaries.md)
- [Chapter 08 - Blob Durability and Storage Tiers](./chapter-08-blob-durability-and-storage-tiers.md)
- [Chapter 09 - Search Indexing and Permission-Aware Retrieval](./chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 10 - CDN Placement, DNS and Cache Invalidation](./chapter-10-cdn-placement-dns-and-cache-invalidation.md)
- [Chapter 11 - Geospatial Indexing for Marketplace Search](./chapter-11-geospatial-indexing-for-marketplace-search.md)
- [Chapter 12 - Distributed IDs and Ordering Guarantees](./chapter-12-distributed-ids-and-ordering-guarantees.md)
- [Chapter 13 - Realtime Concurrency and Workload Isolation](./chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Chapter 14 - Feed Ranking and Fanout Trade-offs](./chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Coverage Map

- SQL, indexes, query plan, partitions, scaling, federacao:
  - Chapters 01, 02
- NoSQL, search, blob store, cache, distributed IDs:
  - Chapters 08, 09, 10, 11, 12
- queues, retries, DLQ, idempotencia, CQRS/SAGA/workflows:
  - Chapters 03, 04, 05, 12
- load balancers, DNS, API gateway, WAF, rate limiting, auth, CDN:
  - Chapters 06, 07, 10, 11
- microservices vs monoliths, resiliencia, concurrency, scaling:
  - Chapters 01, 02, 05, 06, 13
- interview scenarios like payments, feed, ride-hailing, search:
  - Chapters 03, 07, 09, 11, 14

## Gaps To Handle In Area Notes

Alguns topicos do curso nao costumam aparecer isolados em um post famoso unico:
- Keycloak
- social login
- BFF
- service mesh

Para esses, use os chapters 06 e 07 como ancora e complete pela teoria nas areas.

## Implementation Rule

- Rails primeiro
- Elixir depois se a comparacao ensinar concorrencia ou tempo real
- Go depois se a comparacao ensinar throughput, workers ou infra
- cada chapter deve deixar explicito como isso aparece em Rails, quando Elixir realmente ensina algo novo e quando Go realmente ensina algo novo
