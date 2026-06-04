# Shopify - Pods and Modular Monolith

## Why this case matters

Uma das referencias mais fortes para estudar Rails em escala real sem cair no reflexo automatico de microservicos.

## Course topics

- SQL scaling
- particionamento, federacao e isolamento
- load balancers
- monolitos vs microservicos
- deploys, resiliencia e disaster recovery

## Stack relevance

- Rails: very high
- Elixir: medium
- Go: medium

## Primary sources

- [A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale/)
- [Under Deconstruction: The State of Shopify's Monolith](https://shopify.engineering/blogs/engineering/shopify-monolith)
- [Shard Balancing: Moving Shops Confidently with Zero-Downtime at Terabyte-scale](https://shopify.engineering/blogs/engineering/mysql-database-shard-balancing-terabyte-scale)

## What to extract

- como o request e roteado para o pod certo
- como o isolamento limita blast radius
- quando um monolito ainda e a melhor escolha
- como mover shards sem downtime

