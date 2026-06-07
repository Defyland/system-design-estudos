# Task Queues and Background Jobs

## When to Use

Use jobs para tirar trabalho lento, retryable ou externo do request sincrono, mantendo idempotencia e visibilidade de falha.

## What Breaks First

Job duplica efeito, retry vira ataque a dependencia, fila cresce sem alarme e usuario recebe sucesso antes do sistema garantir o efeito principal.

## Interview Trap

Fila nao corrige regra mal definida. Ela muda tempo e confiabilidade; ainda precisa de dedupe, retry, DLQ e reconciliacao.

## Practice Drill

Transforme envio de email pos-compra em job. Defina payload minimo, idempotency key, retry policy, DLQ e metrica de atraso.

## Source Anchor

- [14. Task queues and background jobs](https://www.youtube.com/watch?v=r-nQsyguU1Y)
