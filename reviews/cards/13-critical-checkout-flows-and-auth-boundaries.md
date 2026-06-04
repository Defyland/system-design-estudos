# Review Card 13 - Critical Checkout Flows and Auth Boundaries

## Linked Material

- [Chapter 13](../../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
- [Lab 13](../../labs/chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)

## 15-Second Recall

- `Pergunta`: o que o boundary de checkout responde que a sessao comum nao responde?
- `Resposta curta`: se esta mutacao critica pode acontecer agora, com este risco, sem cobrar duas vezes.

## Wrong Turn

- `Resposta ruim`: "login e gateway ja cobrem checkout".
- `Troque por isto`: checkout centraliza auth sensivel, idempotencia, estado de pagamento e proxima acao recuperavel.

## 1-Minute Answer

Quando auth, risco e pagamento se encostam, checkout precisa virar fronteira propria. A principio isso pode viver dentro do monolito Rails, com service claro e contrato explicito de estado.

## Transfer Check

- o ganho inicial nao e microservico; e parar de espalhar mutacao critica em controllers soltos
