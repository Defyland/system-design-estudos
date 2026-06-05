# Simulation Lab - Fanout / Feed Ranking Cost

## Scenario

Um feed simples vira feed ranqueado. Produtores gigantes explodem escrita; ranking no read path explode latencia.

## Controls

- followers per producer
- posts per second
- read rate
- ranking cost

## What Changes

Fanout-on-write reduz read latency e aumenta write cost. Fanout-on-read melhora frescor e aumenta read cost.

## Failure Mode

Um producer gigante domina filas e storage.

## Cost Signal

Ranking melhor custa CPU, latencia e opacidade.

## Interview Takeaway

Feed maduro separa inventario candidato, fanout e ranking final.

## Linked Chapters

- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Linked Areas

- [Sistemas de IA](../areas/08-sistemas-ia/README.md)

## Mastery Checks

- `Pergunta`: o que fanout resolve e o que nao resolve?
- `Resposta com as suas palavras`: fanout ajuda inventario e latencia; nao decide relevancia sozinho.
- `Resposta ruim que parece boa`: feed ranqueado precisa fanout para todo mundo.
- `Troque por isto`: trate producers gigantes e ranking como problemas separados.

