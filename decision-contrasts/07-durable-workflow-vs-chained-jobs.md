# Contrast 07 - Durable Workflow vs Chained Jobs

## Tension

Os dois quebram um processo em passos, mas so um trata estado, retomada e compensacao como protagonistas.

## Use Chained Jobs When

- o fluxo e curto
- cada passo e razoavelmente independente
- recomecar ou repetir nao e caro

## Use Durable Workflow When

- timers, retries e timeouts mudam por etapa
- estado precisa sobreviver a crash
- compensacao e retomada viram requisito

## Trap

- `Resposta ruim`: "mais passos significa workflow engine".
- `Troque por isto`: o gatilho nao e quantidade de passos, e sim o peso da orquestracao persistente.

## 15-Second Distinction

Job encadeado move etapas. Workflow duravel lembra onde o processo esta.

## Pull Chapters

- [Chapter 05](../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
