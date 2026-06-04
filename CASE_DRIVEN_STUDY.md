# Metodo de Estudo Orientado por Casos Reais

## Objetivo

Estudar system design puxando conhecimento sob demanda a partir de casos reais, sem perder cobertura da ementa.

## Regra central

O fluxo nao e:
- ler toda a teoria
- depois procurar exemplos

O fluxo passa a ser:
1. escolher uma area do curso
2. selecionar um slice de 1 ou 2 casos reais
3. extrair os conceitos daquela area
4. registrar trade-offs e limites
5. implementar algo pequeno se isso aumentar entendimento

## Politica de implementacao

Quando um conceito merecer experimento:
1. implemente primeiro em Ruby on Rails
2. reimplemente em Elixir se houver ganho claro em concorrencia, resiliencia ou tempo real
3. reimplemente em Go se houver ganho claro em throughput, controle operacional ou simplicidade de runtime

Nao reimplemente por esporte. Reimplemente apenas quando a segunda linguagem trouxer um aprendizado novo.

## Matriz de cobertura

### 01 - Metodo e Entrevistas

- Casos principais:
  - [Shopify - Pods and Modular Monolith](./real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
  - [GitHub - Rails and MySQL at Scale](./real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
  - [Meta - News Feed Ranking](./real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)
- Casos complementares:
  - [Uber - Unified Checkout](./real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
  - [Cloudflare - Edge Platform](./real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- O que extrair:
  - clarifying questions
  - requisitos, restricoes e SLOs
  - bottlenecks e evolucao da arquitetura
- Quando implementar:
  - quase nunca
  - prefira respostas escritas, diagramas e estimativas

### 02 - Dados e Armazenamento

- Casos principais:
  - [GitHub - Rails and MySQL at Scale](./real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
  - [Shopify - Pods and Modular Monolith](./real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
  - [Dropbox - Magic Pocket Blob Store](./real-world-cases/02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)
  - [Dropbox - Nautilus Search](./real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)
- Casos complementares:
  - [Uber - H3 Geospatial Marketplace](./real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
  - [Twitter - Snowflake IDs](./real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)
- O que extrair:
  - modelagem de dados
  - leitura vs escrita
  - indexes, query plan, particionamento e federacao
  - blob/object storage
  - busca, cache e IDs distribuidos
- Quando implementar:
  - Rails primeiro
  - exemplos bons: read replica simulation, cache-aside, object upload flow, id generator

### 03 - Filas e Consistencia

- Casos principais:
  - [LinkedIn - Kafka Backbone](./real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
  - [Uber - Cadence Workflows](./real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
  - [Stripe - Idempotent Payments](./real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
  - [Twitter - Snowflake IDs](./real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)
- Casos complementares:
  - [Discord - Elixir Realtime Scale](./real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
  - [Uber - Unified Checkout](./real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- O que extrair:
  - particionamento
  - semanticas de entrega
  - retries, DLQ, idempotencia
  - workflows duraveis
  - CQRS, SAGA e event-driven thinking
- Quando implementar:
  - Rails primeiro
  - reimplemente em Elixir para explorar concorrencia e supervision
  - reimplemente em Go para workers e throughput

### 04 - Edge, Rede e Acesso

- Casos principais:
  - [Cloudflare - Edge Platform](./real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
  - [Netflix - Open Connect CDN](./real-world-cases/04-edge-and-delivery/netflix-open-connect-cdn/README.md)
  - [Uber - Intelligent Load Management](./real-world-cases/04-edge-and-delivery/uber-intelligent-load-management/README.md)
- Casos complementares:
  - [Meta - Video Delivery](./real-world-cases/04-edge-and-delivery/meta-video-delivery/README.md)
  - [Uber - Unified Checkout](./real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- O que extrair:
  - load balancing
  - DNS e roteamento
  - CDN e invalidacao
  - API gateway, WAF, auth e rate limiting
- Quando implementar:
  - Rails primeiro para auth, cache e throttle
  - Go depois se quiser estudar proxying, rate limiting ou edge services

### 05 - Arquitetura e Operacao

- Casos principais:
  - [Shopify - Pods and Modular Monolith](./real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
  - [Discord - Elixir Realtime Scale](./real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
  - [Cloudflare - Edge Platform](./real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
  - [Uber - Cadence Workflows](./real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- Casos complementares:
  - [GitHub - Rails and MySQL at Scale](./real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
  - [Meta - Video Delivery](./real-world-cases/04-edge-and-delivery/meta-video-delivery/README.md)
- O que extrair:
  - monolito vs microservicos
  - concorrencia e paralelismo
  - service boundaries
  - deployment, resilience e scaling
- Quando implementar:
  - Rails primeiro para experimentar boundaries e jobs
  - Elixir para concorrencia
  - Go para runtime simples e servicos IO-bound

## Fluxo de sessao

Para cada sessao de estudo:
1. escolha uma area
2. escolha um caso base
3. escolha um slice pequeno do caso
4. registre na area:
   - conceito
   - decisao arquitetural
   - trade-off
   - risco
   - como aplicaria no seu stack
5. se restar ambiguidade tecnica, faca um experimento pequeno

## Depois Da Sessao

Depois de terminar um chapter ou slice, nao pare no entendimento imediato:
1. rode um card em [reviews/](./reviews/README.md)
2. compare a decisao com uma vizinha em [decision-contrasts/](./decision-contrasts/README.md)
3. toda semana, prove transferencia com um [capstone](./capstones/README.md)

## Exemplo de uso

Se quiser estudar [02 - Dados e Armazenamento](./areas/02-dados-e-armazenamento/README.md):
- comece por GitHub para SQL em escala
- use Shopify para shard/pod/isolation
- use Magic Pocket para blob store
- use Nautilus para busca
- implemente primeiro em Rails algo como cache-aside ou read/write split

Se quiser estudar [03 - Filas e Consistencia](./areas/03-filas-e-consistencia/README.md):
- comece por Kafka para backbone de eventos
- use Stripe para idempotencia
- use Cadence para workflows longos
- implemente primeiro em Rails com job queue e idempotency keys
- compare depois com Elixir ou Go se houver ganho claro

## Navegacao pronta

Se preferir uma sequencia guiada em vez de escolher tudo manualmente:
- abra [chapters/README.md](./chapters/README.md)
- siga um chapter por decisao arquitetural
- use os links do chapter para ir e voltar entre caso, area, notas e lab
- depois use [reviews/README.md](./reviews/README.md) para reter
- use [decision-contrasts/README.md](./decision-contrasts/README.md) para afiar julgamento
- use [capstones/README.md](./capstones/README.md) para misturar temas
