# Uber - Unified Checkout

## Why this case matters

Bom caso de orquestracao de pagamentos e checkout em organizacao multi-produto, com autenticacao e recuperacao de sessao.

## Course topics

- pagamentos
- auth
- checkout orchestration
- microservices
- resiliencia de fluxo critico

## Stack relevance

- Rails: high
- Elixir: medium
- Go: high

## Primary sources

- [Unified Checkout: Streamlining Uber's Payment Ecosystem](https://www.uber.com/blog/unified-checkout/)

## What to extract

- centralizacao do checkout sem paralisar os times
- composicao de metodos de pagamento
- pontos de falha em fluxos criticos
- o que precisa ser consistente em pagamentos

## Strong Anchor

Checkout nao responde apenas "o usuario esta logado?". Ele responde "esta mutacao financeira pode acontecer agora, sem divergencia de estado nem dupla cobranca?".

## Architecture spine

- uma fronteira unica decide mutacao critica para varios canais e LOBs
- `Checkout Actions` devolvem a proxima acao sem vazar o motor interno de pagamentos
- risco, 2FA e payment method entram como estado explicito do fluxo
- idempotencia protege a repeticao inevitavel de requests e retries

## Failure mode to remember

Rollout de auth ou payment method parece pequeno, derruba conversao e incentiva retry manual em um caminho que nao pode cobrar duas vezes.

## 3-Minute Drill

- o que pertence ao boundary de checkout e o que ainda pertence a auth comum?
- qual mutacao precisa de identidade propria para replay seguro?
- que resposta voce devolve quando o PSP ficou ambiguo, mas o cliente quer repetir?

## Linked Chapters

- [Chapter 03 - Idempotent Writes Under Ambiguous Failure](../../../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 07 - Critical Checkout Flows and Auth Boundaries](../../../chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)
