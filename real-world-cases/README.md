# Real-World Cases

Casos reais de system design selecionados por dois criterios:
- cobrem temas da ementa
- tem utilidade pratica para quem trabalha com Ruby on Rails, Elixir e Go

## Como Usar

A ordem oficial do curso fica em [Chapter 01 ate Chapter 14](../chapters/README.md) e e definida por [curriculum.yml](../curriculum.yml).

Esta pasta e uma biblioteca `case-first`: use para revisar por empresa, comparar stacks ou aprofundar um caso depois de encontrar o link dentro de um chapter.

Nos casos que receberam `depth pass`, procure por estas secoes:
- `Strong Anchor`: a frase que fixa o por que arquitetural do caso
- `Architecture Spine`: os blocos que realmente carregam a decisao
- `Failure Mode to Remember`: o jeito mais caro de errar naquele design
- `3-Minute Drill`: o treino curto para testar transferencia
- `Linked Chapters`: onde aquele caso reaparece na trilha canonica

## Casos Uteis Por Stack

Mais alinhados ao seu stack:
- [Shopify - Pods and Modular Monolith](./01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- [GitHub - Rails and MySQL at Scale](./01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- [Discord - Elixir Realtime Scale](./01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- [Uber - Cadence Workflows](./03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- [Stripe - Idempotent Payments](./03-async-workflows-and-payments/stripe-idempotent-payments/README.md)

Mais alinhados a topicos classicos de entrevista:
- [Uber - H3 Geospatial Marketplace](./02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
- [LinkedIn - Kafka Backbone](./03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
- [Cloudflare - Edge Platform](./04-edge-and-delivery/cloudflare-edge-platform/README.md)
- [Netflix - Open Connect CDN](./04-edge-and-delivery/netflix-open-connect-cdn/README.md)
- [Twitter - Snowflake IDs](./02-data-storage-and-search/twitter-snowflake-ids/README.md)

## Roadmap

- [Roadmap case-first alternativo](./ROADMAP.md)
- [Chapters por decisao arquitetural](../chapters/README.md)

## Estrutura

- `01-platforms-and-apps/`: monolitos, runtime e apps em escala
- `02-data-storage-and-search/`: geospatial, blob store, busca e IDs
- `03-async-workflows-and-payments/`: filas, workflows, idempotencia e pagamentos
- `04-edge-and-delivery/`: CDN, load balancing, streaming e protecoes de borda
- `05-product-scenarios/`: casos de produto que aparecem muito em entrevistas

## Como usar

Para cada caso:
1. leia as fontes primarias
2. mapeie o caso para os topicos da ementa
3. anote o que voce reimplementaria em Rails, Elixir ou Go
4. registre os trade-offs, gargalos e limites
5. rode o `3-Minute Drill` antes de voltar ao chapter correspondente
