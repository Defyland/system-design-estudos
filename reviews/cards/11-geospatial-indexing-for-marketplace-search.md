# Review Card 11 - Geospatial Indexing for Marketplace Search

## Linked Material

- [Chapter 11](../../chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)
- [Lab 11](../../labs/chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)

## 15-Second Recall

- `Pergunta`: para que serve o bucket espacial?
- `Resposta curta`: para cortar o universo de busca antes da distancia exata.

## Design Pass Recall

- `Requirement`: volume de candidatos e proximidade ja justificam bucket espacial?
- `Delete`: qual precisao ou resolucao exagerada voce tiraria primeiro?
- `Forma mais simples`: bucket aproximado mais distancia exata, ou so PostGIS quando ainda basta.

## Wrong Turn

- `Resposta ruim`: "se esta na mesma celula, ja esta perto o suficiente".
- `Troque por isto`: celula gera candidato; distancia exata confirma se o candidato serve.

## 1-Minute Answer

Indice espacial entra quando proximidade vira pergunta quente e repetida. Resolucao boa nasce do raio real do produto, nao da vontade de usar a malha mais fina.

## Production Recall

- `Pergunta`: qual sintoma aparece antes de voce culpar o algoritmo?
- `Resposta curta`: ou candidatos demais derrubam latencia, ou candidatos bons somem por resolucao ou localizacao velha.

## Wrong Production Move

- `Resposta ruim`: "troca a resolucao global agora e ve no que da".
- `Troque por isto`: senior compara shadow query e isola a coorte antes de mexer na cidade inteira.

## Transfer Check

- se `ST_DWithin` ainda cabe no SLA e no volume, continue simples
