# Contrast 11 - Fanout-on-Write vs Fanout-on-Read

## Tension

Os dois ajudam a montar feed, mas trocam custo e frescor em lados opostos.

## Use Fanout-on-Write When

- a maioria dos produtores tem fanout moderado
- leitura precisa ser barata
- precomputar candidatos nao explode storage ou fila

## Use Fanout-on-Read When

- ha produtores gigantes
- sinais frescos importam muito
- escrever para todo mundo na hora e caro demais

## Trap

- `Resposta ruim`: "feed relevante pede push para todo mundo".
- `Troque por isto`: relevancia tambem depende de ranking e frescor perto do read path.

## 15-Second Distinction

Write fanout compra leitura barata. Read fanout protege escrita e frescor.

## Pull Chapters

- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
