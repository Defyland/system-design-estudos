# Review Card 12 - Geospatial Indexing for Marketplace Search

## Linked Material

- [Chapter 12](../../chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)
- [Lab 12](../../labs/chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)

## 15-Second Recall

- `Pergunta`: para que serve o bucket espacial?
- `Resposta curta`: para cortar o universo de busca antes da distancia exata.

## Wrong Turn

- `Resposta ruim`: "se esta na mesma celula, ja esta perto o suficiente".
- `Troque por isto`: celula gera candidato; distancia exata confirma se o candidato serve.

## 1-Minute Answer

Indice espacial entra quando proximidade vira pergunta quente e repetida. Resolucao boa nasce do raio real do produto, nao da vontade de usar a malha mais fina.

## Transfer Check

- se `ST_DWithin` ainda cabe no SLA e no volume, continue simples
