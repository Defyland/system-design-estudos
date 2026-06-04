# Smaller Marketplace Checkout Boundary

## Cenario

Uma plataforma pequena de aluguel de equipamentos fotograficos conecta locadores e clientes. O usuario pode montar um carrinho com uma camera, lente e seguro opcional. O backend e um monolito Rails. Existe web e app, mas o time e pequeno.

## Onde o problema aparece

O time comeca com algo aparentemente inocente:

- `OrdersController#create` valida login
- `PaymentsController#create` chama Stripe
- `CartsController#update_payment_method` troca cartao

Funciona ate o dia em que um cliente troca o cartao, cai a rede na confirmacao e o suporte nao sabe se o pedido foi criado, se o valor foi reservado ou se deve pedir nova tentativa. Esse e o tipo de confusao que a Stripe tenta evitar com idempotencia e lifecycle de pagamento ([Stripe Idempotency Blog](https://stripe.com/blog/idempotency), [Stripe Payment Intents](https://docs.stripe.com/payments/payment-intents)).

## Decisao melhor

Criar um boundary unico de checkout dentro do monolito:

- entrada unica `POST /checkout`
- auth normal na sessao
- autorizacao final sobre dono do carrinho dentro do service de checkout
- step-up auth apenas se houve troca recente do metodo de pagamento ou se o valor passou do limite de risco
- `Idempotency-Key` obrigatoria por tentativa de confirmacao
- resposta estruturada para `completed`, `requires_action` e `failed`

## Por que isso e suficiente para empresa menor

Voce ainda nao precisa de plataforma de checkout nem de servico separado. Precisa impedir que o fluxo de receita fique espalhado. O ganho real aqui nao e "arquitetura moderna"; e saber exatamente onde mora:

- a ultima checagem de permissao
- a mutacao do pedido
- o retry seguro
- a proxima acao quando o processador pedir autenticacao adicional

## Onde Uber ajuda sem voce copiar Uber

A licao reutilizavel do caso Uber nao e o numero de microservicos. E a fronteira. Quando pagamento e auth sensivel comecam a se repetir entre fluxos, vale tratar checkout como capacidade compartilhada, mesmo que primeiro ela viva em uma pasta do monolito ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

## Boa regra pratica

Se dois controllers diferentes conseguem cobrar o cliente ou concluir o pedido, seu checkout ja esta vazando. Junte isso antes que a empresa precise explicar para o financeiro por que o "retry inocente" virou segunda cobranca.

## Proximo passo

- [Voltar ao Chapter 13](../../../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
- [Abrir o snippet Rails-first](../snippets/rails-checkout-boundary-and-auth-guard.md)
