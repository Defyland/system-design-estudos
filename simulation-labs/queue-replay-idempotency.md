# Simulation Lab - Queue Replay / Idempotency

## Scenario

Um consumer corrigiu um bug, mas a fila ja acumulou horas de backlog, DLQ e mutacoes que nao podem duplicar.

## Controls

- replay rate
- producer throttle
- idempotency horizon
- ordering strictness

## What Changes

Replay rapido reduz backlog, mas pode competir com trafego ao vivo e esconder consumidores ainda nao idempotentes.

## Failure Mode

Reprocessamento duplica efeito financeiro ou reabre estado antigo fora de ordem.

## Cost Signal

Replay seguro cobra retention, estado de dedupe, observabilidade por chave e capacidade extra durante a drenagem.

## Interview Takeaway

Antes de replayar, voce precisa saber qual ordem importa e onde o efeito-once realmente mora.

## Linked Chapters

- [Chapter 03](../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 04](../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 05](../chapters/chapter-05-durable-workflows-retries-and-compensation.md)

## Linked Areas

- [Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)

## Mastery Checks

- `Pergunta`: o que voce prova antes de liberar replay amplo?
- `Resposta com as suas palavras`: idempotencia, ordering e impacto no trafego ao vivo.
- `Resposta ruim que parece boa`: backlog alto pede replay no maximo o mais cedo possivel.
- `Troque por isto`: replay sem invariantes claras costuma transformar recuperacao em segundo incidente.
