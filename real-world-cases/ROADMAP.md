# Roadmap de Casos Reais

Guia de leitura priorizado para nao diluir o estudo.

## Comece por estes 7

### 1. Shopify - Pods and Modular Monolith

- Caso: [Shopify - Pods and Modular Monolith](./01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- Leia agora porque: e a referencia mais util para quem trabalha com Rails e precisa pensar escala sem fetiche por microservicos.
- Extraia para Rails:
  - modularizacao de monolito
  - boundaries entre dominios
  - isolamento por shard ou pod
  - como rotear request para o datastore certo
- Extraia para Elixir:
  - o que pode virar boundary de contexto ou umbrella
  - como reduzir blast radius sem explodir em servicos
- Extraia para Go:
  - o que justificaria sair do monolito para servicos isolados
  - contratos minimos entre componentes

### 2. GitHub - Rails and MySQL at Scale

- Caso: [GitHub - Rails and MySQL at Scale](./01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- Leia agora porque: mostra como banco relacional e monolito continuam viaveis com boa disciplina operacional.
- Extraia para Rails:
  - estrategia de upgrades pequenos e frequentes
  - limites reais do monolito Rails
  - papel do MySQL em HA e particionamento
- Extraia para Elixir:
  - quais praticas independem da linguagem e sao puramente operacionais
  - como pensar Ecto e Postgres com a mesma mentalidade
- Extraia para Go:
  - como services em Go ainda dependem de uma estrategia forte de dados
  - o que nao se resolve so com trocar de runtime

### 3. Discord - Elixir Realtime Scale

- Caso: [Discord - Elixir Realtime Scale](./01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- Leia agora porque: e o caso mais valioso para concorrencia, realtime e operacao de sistemas altamente interativos em Elixir.
- Extraia para Rails:
  - onde Rails serve e onde ele vira gargalo para realtime pesado
  - o que delegar para componentes especializados
- Extraia para Elixir:
  - modelo de processos por unidade de trabalho
  - isolamento por guild ou tenant
  - limites do BEAM e pontos de escape
- Extraia para Go:
  - onde Go pode complementar workloads CPU-bound ou hotspots
  - comparacao entre goroutines e processos leves da VM

### 4. Stripe - Idempotent Payments

- Caso: [Stripe - Idempotent Payments](./03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- Leia agora porque: pagamento, retries e falha ambigua aparecem em entrevistas e em sistemas reais o tempo todo.
- Extraia para Rails:
  - design de endpoints mutantes com idempotency key
  - modelagem de estados de pagamento
  - retries seguros em jobs e controllers
- Extraia para Elixir:
  - retries, backoff e estados intermediarios com OTP ou Oban
  - mensagens duplicadas e convergencia de estado
- Extraia para Go:
  - middleware de idempotencia
  - workers e handlers resilientes a duplicacao

### 5. LinkedIn - Kafka Backbone

- Caso: [LinkedIn - Kafka Backbone](./03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
- Leia agora porque: e a base mental certa para estudar filas, eventos, schema registry e stream processing.
- Extraia para Rails:
  - quando eventos aliviam acoplamento do monolito
  - como manter contratos claros entre produtores e consumidores
- Extraia para Elixir:
  - quando usar Kafka no lugar de PubSub local
  - como separar processamento realtime e assincrono duravel
- Extraia para Go:
  - desenho de consumers e producers de alto throughput
  - estrategias de particionamento e schema evolution

### 6. Uber - Cadence Workflows

- Caso: [Uber - Cadence Workflows](./03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- Leia agora porque: mostra quando fila nao basta e workflow engine vira a ferramenta certa.
- Extraia para Rails:
  - onde Sidekiq para de ser suficiente
  - como identificar fluxos longos e compensacoes
- Extraia para Elixir:
  - quando OTP resolve sozinho e quando um workflow duravel faz falta
  - timers, retries e state recovery em fluxos longos
- Extraia para Go:
  - modelagem de orchestrators e activities
  - isolamento multi-tenant e backpressure

### 7. Cloudflare - Edge Platform

- Caso: [Cloudflare - Edge Platform](./04-edge-and-delivery/cloudflare-edge-platform/README.md)
- Leia agora porque: concentra varios temas classicos de system design em um mesmo ambiente real de borda.
- Extraia para Rails:
  - o que deve sair do app e ir para a borda
  - autenticacao, rate limiting e cache fora do request handler
- Extraia para Elixir:
  - como aliviar carga de sistemas realtime protegendo antes da origem
  - implicacoes de cache e rate limiting para webs e APIs
- Extraia para Go:
  - desenho de proxies, gateways e contadores distribuidos
  - onde Go costuma aparecer bem nesse tipo de infraestrutura

## Segunda onda

Leia depois que os 7 acima estiverem bem entendidos:
- [Uber - H3 Geospatial Marketplace](./02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
- [Netflix - Open Connect CDN](./04-edge-and-delivery/netflix-open-connect-cdn/README.md)
- [Dropbox - Magic Pocket Blob Store](./02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)
- [Dropbox - Nautilus Search](./02-data-storage-and-search/dropbox-nautilus-search/README.md)
- [Twitter - Snowflake IDs](./02-data-storage-and-search/twitter-snowflake-ids/README.md)
- [Meta - News Feed Ranking](./05-product-scenarios/meta-news-feed-ranking/README.md)
- [Uber - Unified Checkout](./05-product-scenarios/uber-unified-checkout/README.md)
- [Meta - Video Delivery](./04-edge-and-delivery/meta-video-delivery/README.md)
- [Uber - Intelligent Load Management](./04-edge-and-delivery/uber-intelligent-load-management/README.md)

## Ordem pratica de estudo

1. Shopify
2. GitHub
3. Stripe
4. LinkedIn Kafka
5. Uber Cadence
6. Discord
7. Cloudflare

## Regra de extracao por leitura

Ao terminar cada caso, registre:
- 3 decisoes arquiteturais centrais
- 3 trade-offs
- 1 coisa que voce aplicaria em Rails
- 1 coisa que voce aplicaria em Elixir
- 1 coisa que voce aplicaria em Go
- 1 pergunta de entrevista inspirada no caso
