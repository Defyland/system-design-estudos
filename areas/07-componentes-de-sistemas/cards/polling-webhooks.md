# Polling / Webhooks

## When to Use

Use polling quando o cliente tolera atraso e simplicidade importa. Use webhook quando o produtor deve avisar mudanca.

## What Breaks First

Webhook sem idempotencia duplica efeito; polling agressivo vira ataque educado.

## Interview Trap

Webhook nao e entrega exatamente uma vez.

