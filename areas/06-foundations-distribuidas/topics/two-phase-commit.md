# Two-Phase Commit

## When to Use

Use 2PC quando atomidade entre participantes vale o custo de coordenacao e bloqueio.

## Interview Trap

2PC parece resolver tudo, mas o coordinator vira ponto sensivel. Em muitos fluxos, idempotencia e compensation sao melhores.

## Linked Chapters

- [Chapter 03](../../../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 05](../../../chapters/chapter-05-durable-workflows-retries-and-compensation.md)

