# Contrast 04 - Search Index vs Relational Querying

## Tension

Os dois respondem leitura, mas um foi desenhado para recuperar texto e relevancia, e o outro para manter o write correto.

## Use Search Index When

- a pergunta do produto pede texto livre, recall, ranking ou autocomplete
- o corpus cresce rapido
- o usuario quer achar, nao navegar

## Use Relational Querying When

- a busca ainda e filtragem estruturada
- o volume cabe
- permissao e joins continuam mais importantes que relevancia textual

## Trap

- `Resposta ruim`: "coloca um `LIKE` e ve depois".
- `Troque por isto`: isso funciona ate a pergunta do produto mudar de filtro para busca de verdade.

## 15-Second Distinction

SQL filtra estado estruturado. Search index recupera texto com recall e ranking.

## Pull Chapters

- [Chapter 09](../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
