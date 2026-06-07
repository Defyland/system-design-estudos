# Graceful Shutdown

## When to Use

Use graceful shutdown quando deploy, scale down ou restart nao podem derrubar requests, jobs ou conexoes no meio sem encerramento controlado.

## What Breaks First

Processo recebe SIGTERM, para de aceitar tarde demais, mata job no meio, perde ack da fila ou fecha conexao antes de responder.

## Interview Trap

Pensar que shutdown e detalhe de infra. Backend precisa parar entrada, drenar trabalho, respeitar timeout e tornar efeito idempotente.

## Practice Drill

Desenhe shutdown de worker: receber sinal, parar pull da fila, terminar job atual, renovar ou devolver lock, flush de logs e limite de tempo.

## Source Anchor

- [19. Desligamento gradual](https://www.youtube.com/watch?v=6rfBgphiCWM)
