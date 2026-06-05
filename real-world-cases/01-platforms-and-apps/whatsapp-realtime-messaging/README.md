# WhatsApp - Realtime Messaging

## Why this case matters

Caso util para estudar realtime, delivery semantics, presence, fanout, dispositivos multiplos e custo de manter conexoes vivas.

## Course topics

- realtime messaging
- delivery semantics
- presence
- workload isolation
- Erlang/BEAM style concurrency

## Stack relevance

- Rails: medium
- Elixir: high
- Go: medium

## Primary sources

- [WhatsApp Erlang](https://www.erlang-solutions.com/blog/whatsapp-erlang/)
- [WhatsApp Engineering - Facebook Engineering archive](https://engineering.fb.com/)

## What to extract

- separar mensagem duravel de presence efemera
- modelar ack, retry e offline delivery
- explicar quando runtime concorrente ensina mais que framework web
- traduzir para chat interno de SaaS menor

