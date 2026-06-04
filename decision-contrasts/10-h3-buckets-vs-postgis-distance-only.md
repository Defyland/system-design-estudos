# Contrast 10 - H3 Buckets vs PostGIS Distance Only

## Tension

Os dois ajudam em proximidade, mas um resolve busca repetida por area e o outro resolve distancia exata sem muita cerimonia.

## Use H3 Buckets When

- proximidade virou pergunta quente e repetida
- varias superficies usam a mesma nocao de area
- gerar candidatos baratos ficou tao importante quanto medir distancia

## Use PostGIS Distance Only When

- o volume ainda cabe
- a pergunta de proximidade nao domina o produto
- raio exato importa mais do que bucket operacional

## Trap

- `Resposta ruim`: "qualquer mapa merece H3".
- `Troque por isto`: bucket espacial entra quando reduz trabalho repetido real, nao quando o nome parece sofisticado.

## 15-Second Distinction

H3 corta universo por area. PostGIS mede distancia direto.

## Pull Chapters

- [Chapter 12](../chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)
