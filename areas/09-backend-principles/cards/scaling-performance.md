# Scaling and Performance

## When to Use

Use quando uma metrica real mostra gargalo: latencia, throughput, CPU, memoria, lock, conexao, fila, cache miss ou query plan.

## What Breaks First

Escalar antes de medir aumenta custo e complexidade. O gargalo pode estar em query, serializacao, pool, N+1, dependencia ou lock.

## Interview Trap

Responder "horizontal scaling" sem perfil. Primeiro identifique gargalo, reduza trabalho, proteja dependencia e so depois aumente capacidade.

## Practice Drill

Pegue endpoint lento e liste: p50/p95, query mais cara, tempo em dependencia externa, alocacao, cache hit, pool de conexao e primeiro corte.

## Source Anchor

- [21.1. Backend Scaling and Performance Engineering: Part-1](https://www.youtube.com/watch?v=z7kt_p44rjs)
- [21.2. Backend Scaling and Performance Engineering: Part-2](https://www.youtube.com/watch?v=sOhAopEwjH4)
