# Stripe - Idempotent Payments

## Why this case matters

Caso essencial para pagamentos e para qualquer API mutante sob falha de rede, retries e estados ambiguos.

## Course topics

- idempotencia
- exactly-once vs at-least-once
- retries com backoff
- pagamentos
- APIs resilientes

## Stack relevance

- Rails: very high
- Elixir: high
- Go: high

## Primary sources

- [Designing robust and predictable APIs with idempotency](https://stripe.com/blog/idempotency)
- [Idempotent requests](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)
- [Payment Intents API](https://docs.stripe.com/payments/payment-intents)

## What to extract

- falha ambigua e por que ela e perigosa
- papel do idempotency key
- relacao entre retries, backoff e jitter
- modelagem de estado em pagamentos

