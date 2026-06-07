# Meta - News Feed Ranking

## Why this case matters

Caso importante para o cenario classico de news feed, principalmente quando a entrevista exige ranking e personalizacao, nao so fanout.

## Course topics

- news feed
- ranking
- latencia
- agregacao
- personalizacao

## Stack relevance

- Rails: medium
- Elixir: medium
- Go: medium

## Primary sources

- [News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)

## What to extract

- papel do feed aggregator
- separacao entre fetch, aggregate, rank e render
- onde entra personalizacao
- como pensar no trade-off entre relevancia e latencia

## Strong Anchor

Feed maduro nao e lista ordenada. E inventario candidato + ranking + guardrails sob budget de latencia e custo.

## Architecture spine

- candidate generation e ranking final ficam separados de proposito
- um `pass0` leve poda o universo antes do score caro
- high-fanout producers exigem estrategia diferente do usuario comum
- diversidade, frescor e relevancia competem entre si e pedem guardrails explicitos

## Failure mode to remember

Ranker melhora a metrica local errada ou fanout explode custo de escrita enquanto o produto parece "mais inteligente" no dashboard.

## 3-Minute Drill

- o que ainda justifica cronologia pura neste produto?
- que sinal precisa estar fresco no read path e qual pode ser precomputado?
- qual guardrail pode vetar um ranker mesmo quando o clique sobe?

## Linked Chapters

- [Chapter 14 - Feed Ranking and Fanout Trade-offs](../../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
