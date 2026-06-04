# Ordem de Estudo

Se voce nao quer decidir nada sozinho, siga esta ordem.

## Regra simples

Para cada passo abaixo:
1. leia o `chapter`
2. abra o `caso real` principal daquele chapter
3. releia a `area` correspondente para consolidar a teoria
4. rode o `lab` em voz alta
5. no mesmo dia, rode o `review card` correspondente

A cada `2 chapters`:
- faca `1` contraste em [decision-contrasts/README.md](./decision-contrasts/README.md)

A cada `4 chapters`:
- faca `1` capstone em [capstones/README.md](./capstones/README.md)

## Antes de comecar

Leia uma vez:
1. [01 - Metodo e Entrevistas / Notes](./areas/01-metodo-e-entrevistas/notes.md)
2. [Metodo de Estudo Orientado por Casos Reais](./CASE_DRIVEN_STUDY.md)

Depois pare de abrir mapa demais. Va para a sequencia abaixo.

## Sequencia recomendada

### Fase 1 - Base forte

1. [Chapter 02 - Relational Scaling and Operational Discipline](./chapters/chapter-02-relational-scaling-and-operational-discipline.md)
   Caso real: [GitHub - Rails and MySQL at Scale](./real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
   Area: [02 - Dados e Armazenamento](./areas/02-dados-e-armazenamento/README.md)

2. [Chapter 01 - Pod Isolation and Tenant Routing](./chapters/chapter-01-pod-isolation-and-tenant-routing.md)
   Caso real: [Shopify - Pods and Modular Monolith](./real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
   Area: [05 - Arquitetura e Operacao](./areas/05-arquitetura-e-operacao/README.md)

3. [Chapter 05 - Idempotent Writes Under Ambiguous Failure](./chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
   Caso real: [Stripe - Idempotent Payments](./real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
   Area: [03 - Filas e Consistencia](./areas/03-filas-e-consistencia/README.md)

4. [Chapter 06 - Event Backbone, Partitions and Consumer Scale](./chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)
   Caso real: [LinkedIn - Kafka Backbone](./real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
   Area: [03 - Filas e Consistencia](./areas/03-filas-e-consistencia/README.md)

5. [Chapter 07 - Durable Workflows, Retries and Compensation](./chapters/chapter-07-durable-workflows-retries-and-compensation.md)
   Caso real: [Uber - Cadence Workflows](./real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
   Area: [05 - Arquitetura e Operacao](./areas/05-arquitetura-e-operacao/README.md)

6. [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](./chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
   Caso real: [Cloudflare - Edge Platform](./real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
   Area: [04 - Edge, Rede e Acesso](./areas/04-edge-rede-e-acesso/README.md)

### Fase 2 - Caminhos criticos e dados especializados

7. [Chapter 13 - Critical Checkout Flows and Auth Boundaries](./chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
   Caso real: [Uber - Unified Checkout](./real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
   Area: [04 - Edge, Rede e Acesso](./areas/04-edge-rede-e-acesso/README.md)

8. [Chapter 03 - Blob Durability and Storage Tiers](./chapters/chapter-03-blob-durability-and-storage-tiers.md)
   Caso real: [Dropbox - Magic Pocket Blob Store](./real-world-cases/02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)
   Area: [02 - Dados e Armazenamento](./areas/02-dados-e-armazenamento/README.md)

9. [Chapter 04 - Search Indexing and Permission-Aware Retrieval](./chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)
   Caso real: [Dropbox - Nautilus Search](./real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)
   Area: [02 - Dados e Armazenamento](./areas/02-dados-e-armazenamento/README.md)

10. [Chapter 11 - CDN Placement, DNS and Cache Invalidation](./chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)
    Caso real: [Netflix - Open Connect CDN](./real-world-cases/04-edge-and-delivery/netflix-open-connect-cdn/README.md)
    Area: [04 - Edge, Rede e Acesso](./areas/04-edge-rede-e-acesso/README.md)

11. [Chapter 12 - Geospatial Indexing for Marketplace Search](./chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)
    Caso real: [Uber - H3 Geospatial Marketplace](./real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
    Area: [02 - Dados e Armazenamento](./areas/02-dados-e-armazenamento/README.md)

### Fase 3 - Runtime e produto em escala

12. [Chapter 08 - Distributed IDs and Ordering Guarantees](./chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)
    Caso real: [Twitter - Snowflake IDs](./real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)
    Area: [03 - Filas e Consistencia](./areas/03-filas-e-consistencia/README.md)

13. [Chapter 09 - Realtime Concurrency and Workload Isolation](./chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)
    Caso real: [Discord - Elixir Realtime Scale](./real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
    Area: [05 - Arquitetura e Operacao](./areas/05-arquitetura-e-operacao/README.md)

14. [Chapter 14 - Feed Ranking and Fanout Trade-offs](./chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
    Caso real: [Meta - News Feed Ranking](./real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)
    Area: [01 - Metodo e Entrevistas](./areas/01-metodo-e-entrevistas/README.md)

## Quando usar os outros materiais

- [reviews/README.md](./reviews/README.md): use no mesmo dia do chapter e nos ciclos `1, 3, 7, 14, 30`
- [decision-contrasts/README.md](./decision-contrasts/README.md): use depois de cada `2 chapters`
- [capstones/README.md](./capstones/README.md): use depois de cada `4 chapters`
- [real-world-cases/ROADMAP.md](./real-world-cases/ROADMAP.md): use so se quiser entender por que essa ordem foi escolhida

## Se tiver pouco tempo

Se voce so puder estudar `7` coisas primeiro, faca:
1. Chapter 02
2. Chapter 01
3. Chapter 05
4. Chapter 06
5. Chapter 07
6. Chapter 10
7. Chapter 13

Isso te da a espinha dorsal de dados, consistencia, arquitetura e borda.
