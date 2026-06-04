# Chapters

Sequencia guiada de leitura por decisao arquitetural, nao por empresa inteira.

## Como pensar um chapter

Cada chapter pega uma fatia de um caso real:
- comeca por uma historia curta de produto ou operacao
- deixa claro onde esse conhecimento aparece antes da teoria
- qual problema existia
- qual caso real ajuda a enxergar o problema grande
- como esse tema costuma aparecer em entrevista
- qual decisao foi tomada
- por que nao escolheram outra coisa
- quais topicos do curso explicam essa decisao
- qual experimento pequeno vale fazer

No fim de cada chapter voce deve sair sabendo:
- quando usar
- por que usar
- por que o caso real usou
- quais trade-offs pesar
- quais sinais indicam que a escolha esta errada

## Ordem didatica

Todo chapter deve seguir esta cadencia:
1. historia curta: "seu PO pediu isso, como voce pensa?"
2. onde usar: antes da teoria, onde esse problema aparece na pratica
3. caso real: quem sofreu isso em escala e o que decidiu
4. foco em entrevistas: como esse assunto costuma ser cobrado
5. material: conceito, trade-off, codigo, exemplo menor e synthesis final

## Regra de Fixacao

Cada chapter tambem deve ter checkpoints curtos ao longo da leitura:
- pergunta rapida
- resposta curta em linguagem mais simples, como se o aluno estivesse explicando com as proprias palavras
- armadilha comum
- correcao curta

Os labs tambem seguem a mesma ideia: drill curto, gabarito oral imediato e resposta ruim corrigida na hora.

O objetivo e que uma leitura de 5 a 10 minutos ensine algo real, force lembranca imediata e valide isso na hora, sem depender de exercicio escrito.

## Sequencia principal

- [Chapter 01 - Pod Isolation and Tenant Routing](./chapter-01-pod-isolation-and-tenant-routing.md)
- [Chapter 02 - Relational Scaling and Operational Discipline](./chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 03 - Blob Durability and Storage Tiers](./chapter-03-blob-durability-and-storage-tiers.md)
- [Chapter 04 - Search Indexing and Permission-Aware Retrieval](./chapter-04-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 05 - Idempotent Writes Under Ambiguous Failure](./chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 06 - Event Backbone, Partitions and Consumer Scale](./chapter-06-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 07 - Durable Workflows, Retries and Compensation](./chapter-07-durable-workflows-retries-and-compensation.md)
- [Chapter 08 - Distributed IDs and Ordering Guarantees](./chapter-08-distributed-ids-and-ordering-guarantees.md)
- [Chapter 09 - Realtime Concurrency and Workload Isolation](./chapter-09-realtime-concurrency-and-workload-isolation.md)
- [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](./chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 11 - CDN Placement, DNS and Cache Invalidation](./chapter-11-cdn-placement-dns-and-cache-invalidation.md)
- [Chapter 12 - Geospatial Indexing for Marketplace Search](./chapter-12-geospatial-indexing-for-marketplace-search.md)
- [Chapter 13 - Critical Checkout Flows and Auth Boundaries](./chapter-13-critical-checkout-flows-and-auth-boundaries.md)
- [Chapter 14 - Feed Ranking and Fanout Trade-offs](./chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Coverage Map

- SQL, indexes, query plan, partitions, scaling, federacao:
  - Chapters 01, 02
- NoSQL, search, blob store, cache, distributed IDs:
  - Chapters 03, 04, 08, 12
- queues, retries, DLQ, idempotencia, CQRS, SAGA e workflows:
  - Chapters 05, 06, 07, 08
- load balancers, DNS, API gateway, WAF, rate limiting, auth, CDN:
  - Chapters 10, 11, 13
- microservices vs monoliths, resiliencia, concurrency, scaling:
  - Chapters 01, 02, 07, 09, 10
- interview scenarios like payments, feed, ride-hailing, search:
  - Chapters 04, 05, 12, 13, 14

## Implementation Rule

- Rails primeiro
- Elixir depois se a comparacao ensinar concorrencia ou tempo real
- Go depois se a comparacao ensinar throughput, workers ou infra
- cada chapter deve deixar explicito como isso aparece em Rails, quando Elixir realmente ensina algo novo e quando Go realmente ensina algo novo
