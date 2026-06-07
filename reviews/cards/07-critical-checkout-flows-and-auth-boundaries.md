# Review Card 07 - Critical Checkout Flows and Auth Boundaries

## Linked Material

- [Chapter 07](../../chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)
- [Lab 07](../../labs/chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)

## Anchor

- `Problema`: sessao, risco e pagamento se encostam no mesmo ponto onde dinheiro entra.
- `Decisao`: criar um boundary de checkout que decide a mutacao critica, protege idempotencia e devolve a proxima acao do fluxo.

## Cue Signal

- `Sinal`: uma mutacao critica depende de identidade, risco, pagamento e confirmacao consistente no mesmo caminho.

## Case Anchor

- `Caso real`: [Uber - Unified Checkout](../../real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- `Lembrete`: checkout nao responde so "quem e voce?"; responde "esta mutacao financeira pode acontecer agora sem divergencia?".

## QDSAA Recall

- `Requirement corrigido`: o dono aqui nao e "mais auth"; e a transicao critica de estado.
- `Delete`: logica duplicada de checkout, reauth e payment method espalhada por produtos.
- `Forma simples`: um boundary claro para estado critico antes de varios servicos laterais.

## Trade-off to Remember

- `Custo`: mais centralizacao, mais disciplina de estado e mais ownership explicito.
- `Failure mode`: conversao cai ou a mutacao fica ambigua justamente porque cada canal decidiu checkout de um jeito.

## Trap

- `Resposta ruim`: "login e gateway ja cobrem checkout".
- `Troque por isto`: checkout centraliza auth sensivel, idempotencia, estado de pagamento e proxima acao recuperavel.

## 1-Minute Answer

Quando auth, risco e pagamento se encostam, checkout precisa virar fronteira propria. A principio isso pode viver dentro do monolito Rails, com service claro e contrato explicito de estado.
