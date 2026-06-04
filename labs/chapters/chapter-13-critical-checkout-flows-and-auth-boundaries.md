# Lab - Chapter 13

## Chapter

- [Back to Chapter 13](../../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

Explique um checkout minimo para um marketplace pequeno com:

- sessao autenticada
- reauth apenas para compra de maior risco
- `Idempotency-Key` obrigatoria
- resposta com `completed`, `requires_action` ou `failed`

Use como ponto de partida o [snippet Rails Checkout Boundary and Auth Guard](../../areas/04-edge-rede-e-acesso/snippets/rails-checkout-boundary-and-auth-guard.md).

## Gabarito Oral Imediato

- `Resposta curta`: login normal abre a sessao; reauth recente entra so quando o risco ou o valor mudam o jogo.
- `Resposta curta`: `Idempotency-Key` protege o retry da mutacao critica, nao apenas a conversa com o PSP.
- `Resposta curta`: `completed`, `requires_action` e `failed` sao estados do checkout, nao so mensagens de UI.
- `Armadilha`: "gateway e middleware de auth resolvem checkout". Nao. O boundary de checkout ainda decide mutacao, replay e proxima acao.

## Optional Elixir

- explique a mesma ideia como maquina de estados simples com retry supervisionado

## Optional Go

- explique apenas um adaptador minimo de pagamento ou replay idempotente
