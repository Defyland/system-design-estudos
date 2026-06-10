# Plano de Estudo

A trilha canonica e os blocos abaixo sao gerados a partir de `curriculum.yml`. Quando
ordem, caso ou area mudarem no manifest, rode `rake render` (ou
`ruby scripts/render_curriculum_indexes.rb`). O validador falha se este arquivo ficar
fora de sincronia com o manifest.

## Trilha canonica (14 chapters)

Marque cada chapter quando fechar o ciclo completo: ler o chapter, fazer o lab,
preencher o review card e rodar o pre-sleep flashcard do dia.

<!-- curriculum:start:study-plan-chapters -->
### Fase 1 - Base forte

- [ ] [Chapter 01 - Relational Scaling and Operational Discipline](chapters/chapter-01-relational-scaling-and-operational-discipline.md) - Caso: [GitHub - Rails and MySQL at Scale](real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- [ ] [Chapter 02 - Pod Isolation and Tenant Routing](chapters/chapter-02-pod-isolation-and-tenant-routing.md) - Caso: [Shopify - Pods and Modular Monolith](real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- [ ] [Chapter 03 - Idempotent Writes Under Ambiguous Failure](chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md) - Caso: [Stripe - Idempotent Payments](real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- [ ] [Chapter 04 - Event Backbone, Partitions and Consumer Scale](chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md) - Caso: [LinkedIn - Kafka Backbone](real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
- [ ] [Chapter 05 - Durable Workflows, Retries and Compensation](chapters/chapter-05-durable-workflows-retries-and-compensation.md) - Caso: [Uber - Cadence Workflows](real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- [ ] [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md) - Caso: [Cloudflare - Edge Platform](real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)

### Fase 2 - Caminhos criticos e dados especializados

- [ ] [Chapter 07 - Critical Checkout Flows and Auth Boundaries](chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md) - Caso: [Uber - Unified Checkout](real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- [ ] [Chapter 08 - Blob Durability and Storage Tiers](chapters/chapter-08-blob-durability-and-storage-tiers.md) - Caso: [Dropbox - Magic Pocket Blob Store](real-world-cases/02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)
- [ ] [Chapter 09 - Search Indexing and Permission-Aware Retrieval](chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md) - Caso: [Dropbox - Nautilus Search](real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)
- [ ] [Chapter 10 - CDN Placement, DNS and Cache Invalidation](chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md) - Caso: [Netflix - Open Connect CDN](real-world-cases/04-edge-and-delivery/netflix-open-connect-cdn/README.md)
- [ ] [Chapter 11 - Geospatial Indexing for Marketplace Search](chapters/chapter-11-geospatial-indexing-for-marketplace-search.md) - Caso: [Uber - H3 Geospatial Marketplace](real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)

### Fase 3 - Runtime e produto em escala

- [ ] [Chapter 12 - Distributed IDs and Ordering Guarantees](chapters/chapter-12-distributed-ids-and-ordering-guarantees.md) - Caso: [Twitter - Snowflake IDs](real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)
- [ ] [Chapter 13 - Realtime Concurrency and Workload Isolation](chapters/chapter-13-realtime-concurrency-and-workload-isolation.md) - Caso: [Discord - Elixir Realtime Scale](real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- [ ] [Chapter 14 - Feed Ranking and Fanout Trade-offs](chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md) - Caso: [Meta - News Feed Ranking](real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)
<!-- curriculum:end:study-plan-chapters -->

## Areas de apoio

<!-- curriculum:start:study-plan-areas -->
- [ ] [01 - Metodo e Entrevistas](areas/01-metodo-e-entrevistas/README.md) (`practice_area`)
- [ ] [02 - Dados e Armazenamento](areas/02-dados-e-armazenamento/README.md) (`practice_area`)
- [ ] [03 - Filas e Consistencia](areas/03-filas-e-consistencia/README.md) (`practice_area`)
- [ ] [04 - Edge, Rede e Acesso](areas/04-edge-rede-e-acesso/README.md) (`practice_area`)
- [ ] [05 - Arquitetura e Operacao](areas/05-arquitetura-e-operacao/README.md) (`practice_area`)
- [ ] [06 - Foundations Distribuidas](areas/06-foundations-distribuidas/README.md) (`topic_catalog`)
- [ ] [07 - Componentes de Sistemas](areas/07-componentes-de-sistemas/README.md) (`component_catalog`)
- [ ] [08 - Sistemas de IA](areas/08-sistemas-ia/README.md) (`topic_catalog`)
- [ ] [09 - Backend Principles](areas/09-backend-principles/README.md) (`backend_principle_catalog`)
- [ ] [10 - Engineering Case Studies](areas/10-engineering-case-studies/README.md) (`engineering_case_study_catalog`)
- [ ] [11 - Operational Playbooks](areas/11-operational-playbooks/README.md) (`operational_playbook_catalog`)
- [ ] [12 - Engineering Practice](areas/12-engineering-practice/README.md) (`engineering_practice_catalog`)
- [ ] [13 - Backend Principle Labs](areas/13-backend-principle-labs/README.md) (`backend_lab_catalog`)
- [ ] [14 - Engineering Case Study Labs](areas/14-engineering-case-study-labs/README.md) (`engineering_case_lab_catalog`)
<!-- curriculum:end:study-plan-areas -->

## Entregaveis por area

- 1 resumo consolidado em `notes.md`
- 2 a 5 exemplos em `examples/`
- snippets ou pseudocodigo em `snippets/`
- 1 lista curta de trade-offs e riscos

## Cadencia de retencao

- D0: rodar [Dia 00 - Pre-Sleep Flashcards](./reviews/day-00-pre-sleep-flashcards.md) com o chapter do dia
- D+1: repetir `cue signal -> decisao` sem olhar e so depois revisar notas
- D+3: contrastar com `1` alternativa vizinha em [decision-contrasts/README.md](./decision-contrasts/README.md)
- D+7: explicar sem consultar
- D+14: comprimir resposta em modo entrevista
- D+30: resolver um problema pratico ou uma questao de entrevista

Para ver quais revisoes estao vencidas hoje, registre a data de inicio de cada
chapter em [progress.yml](./progress.yml) e rode `rake 'progress[YYYY-MM-DD]'`.
