# Review Card 11 - Geospatial Indexing for Marketplace Search

## Linked Material

- [Chapter 11](../../chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)
- [Lab 11](../../labs/chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)

## Anchor

- `Problema`: proximidade virou pergunta quente e repetida; lat/long bruto esta caro demais no caminho principal.
- `Decisao`: transformar coordenada em bucket espacial para gerar candidatos baratos e validar com distancia exata depois.

## Case Anchor

- `Caso real`: [Uber - H3 Geospatial Marketplace](../../real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
- `Lembrete`: H3 entra para cortar trabalho repetido de marketplace, nao para substituir distancia.

## QDSAA Recall

- `Requirement corrigido`: o centro do problema nao e "ter mapa"; e responder proximidade em volume quente.
- `Delete`: resolucao fina demais ou geometria sofisticada antes de provar o ganho.
- `Forma simples`: bucket aproximado mais distancia exata, ou so PostGIS quando ainda basta.

## Trade-off to Remember

- `Custo`: resolucao errada traz ou ruido demais ou candidato demais.
- `Failure mode`: candidatos bons somem na borda da celula ou candidatos demais derrubam latencia.

## Trap

- `Resposta ruim`: "se esta na mesma celula, ja esta perto o suficiente".
- `Troque por isto`: celula gera candidato; distancia exata confirma se o candidato serve.

## 1-Minute Answer

Indice espacial entra quando proximidade vira pergunta quente e repetida. Resolucao boa nasce do raio real do produto, nao da vontade de usar a malha mais fina.
