# Interview Walkthrough - Marketplace Search

## Historia curta

Seu entrevistador pede: "desenhe uma busca de prestadores proximos". Nao comece por Elasticsearch, Kafka ou H3. Comece pelo que o produto quer resolver.

## Como responder bem

1. clarifique:
   - e busca instantanea ou lista que pode esperar?
   - precisa considerar permissao, disponibilidade e distancia?
   - qual o raio medio da busca?
2. estime:
   - quantos prestadores por cidade?
   - quantas buscas por segundo no pico?
   - a localizacao muda em tempo real?
3. proponha v1:
   - banco relacional com indice geoespacial simples
   - cache local para areas quentes
   - filtro por disponibilidade
4. diga quando evolui:
   - se o custo da query sobe demais, bucketizacao espacial
   - se ranking fica mais complexo, pipeline de busca dedicada

## O que impressiona de verdade

- mostrar que uma resposta simples pode ser correta no estagio certo
- nomear o trigger de evolucao, nao so a solucao de escala
- conectar geografia, disponibilidade e custo na mesma resposta

## Chapters ligados

- [Chapter 09 - Search Indexing and Permission-Aware Retrieval](../../../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 11 - Geospatial Indexing for Marketplace Search](../../../chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)
