# 02 - Dados e Armazenamento

## Por que esta area existe

Boa parte dos trade-offs reais de system design nasce aqui: modelagem, leitura, escrita, consistencia, custo e escala.

## O que estudar aqui

- SQL de verdade: indexes, query plan, particionamento, leitura e escrita
- ACID, BASE, replicacao, federacao e scaling
- NoSQL e escolha por caso de uso
- Blob/object storage
- Cache como acelerador de acesso a dados

## O que foi absorvido

- "o que sao bancos de dados"
- introducoes rasas de SQL e NoSQL
- overview de opcoes que nao precisa de pasta propria

## Casos reais para estudar esta area

- [GitHub - Rails and MySQL at Scale](../../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- [Shopify - Pods and Modular Monolith](../../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- [Dropbox - Magic Pocket Blob Store](../../real-world-cases/02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)
- [Dropbox - Nautilus Search](../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)
- [Twitter - Snowflake IDs](../../real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)

## Ordem sugerida

1. GitHub
2. Shopify
3. Dropbox Magic Pocket
4. Dropbox Nautilus
5. Twitter Snowflake

## Apoios desta area

- [Notes](./notes.md)
- [Example - Smaller SaaS Read/Write and Cache](./examples/smaller-saas-read-write-and-cache.md)
- [Snippet - Rails Read/Write Split and Cache Aside](./snippets/rails-read-write-split-and-cache-aside.md)

## Regra de implementacao

- Rails primeiro
- Elixir so se houver ganho de concorrencia ou coordenacao
- Go so se houver ganho de throughput ou simplicidade operacional
