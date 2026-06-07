# Webhooks

## When to Use

Use webhooks para avisar sistemas externos sobre eventos, sem exigir polling constante do consumidor.

## What Breaks First

Consumidor cai, evento duplica, ordem muda, assinatura nao valida, retry explode e o produtor perde visibilidade de entrega.

## Interview Trap

Webhook nao e "HTTP callback simples". Precisa de assinatura, idempotency key, retry com backoff, DLQ, replay e auditoria.

## Practice Drill

Desenhe webhook `payment.succeeded`: payload minimo, assinatura, retry policy, endpoint de replay e como consumidor evita duplicacao.

## Source Anchor

- [1. Roadmap for backend from first principles - Webhooks](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1798s)
