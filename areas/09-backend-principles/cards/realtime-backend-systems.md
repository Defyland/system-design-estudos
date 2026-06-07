# Realtime Backend Systems

## When to Use

Use realtime quando polling nao entrega experiencia suficiente: chat, presence, colaboracao, dashboards vivos, trading, multiplayer ou eventos operacionais.

## What Breaks First

Conexao viva aumenta custo, estado efemero se mistura com dado duravel e broadcast sem backpressure derruba clientes lentos.

## Interview Trap

Escolher WebSocket antes de separar o que e duravel, efemero, ordenado, fanout, presence e retryable.

## Practice Drill

Modele sala de chat: mensagem duravel, presence efemera, ack, reconnect, limite de fanout e metrica que indica cliente lento.

## Source Anchor

- [1. Roadmap for backend from first principles - Real-time backend systems](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1679s)
