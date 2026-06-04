# Rails Checkout Boundary and Auth Guard

## When to Use

Use este padrao quando login e permissao basica ja existem, mas o fluxo de checkout agora precisa decidir:

- se a identidade atual ainda basta para concluir a compra
- se o retry precisa devolver exatamente o mesmo resultado
- se a proxima resposta e `success`, `requires_action` ou `failed`

Se seu app ainda tem um unico fluxo trivial e nenhuma cobranca sensivel, isso provavelmente e cedo demais.

## Rails First

```rb
class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_cart!

  def create
    result = Checkout::SubmitOrder.new.call!(
      cart: @cart,
      actor: current_user,
      payment_method_id: params[:payment_method_id],
      idempotency_key: request.headers.fetch("Idempotency-Key")
    )

    render json: result.payload, status: result.http_status
  rescue KeyError
    render json: { error: "missing_idempotency_key" }, status: :unprocessable_entity
  rescue Checkout::ReauthRequired
    render json: { state: "requires_reauth" }, status: :conflict
  end

  private

  def load_cart!
    @cart = current_user.carts.open.find(params[:cart_id])
  end
end

module Checkout
  class SubmitOrder
    def call!(cart:, actor:, payment_method_id:, idempotency_key:)
      raise ReauthRequired if actor.recent_payment_method_change? || cart.high_value?

      IdempotentRequest.fetch_or_run!(
        scope: "checkout:#{cart.id}",
        key: idempotency_key
      ) do
        intent = Stripe::PaymentIntent.create(
          {
            amount: cart.total_cents,
            currency: cart.currency,
            customer: actor.stripe_customer_id,
            payment_method: payment_method_id,
            confirm: true
          },
          { idempotency_key: idempotency_key }
        )

        case intent.status
        when "requires_action"
          Result.new(:accepted, {
            state: "requires_action",
            client_secret: intent.client_secret
          })
        when "succeeded", "requires_capture"
          order = Order.create_from_cart!(cart, actor)
          Result.new(:created, {
            state: "completed",
            order_id: order.id
          })
        else
          Result.new(:unprocessable_entity, {
            state: "failed",
            reason: intent.status
          })
        end
      end
    end
  end
end
```

Ideia principal:

- sessao e identidade entram pelo controller
- permissao final e risco sensivel entram no boundary de checkout
- Stripe recebe a mesma `idempotency_key` da operacao local
- a UI recebe estado e proxima acao, nao detalhes arbitrarios do processador

## Optional Elixir

Use Elixir se quiser aprender algo novo sobre coordenacao de estados concorrentes ou processos de recovery mais vivos. O ganho aqui nao e reescrever o checkout inteiro, e modelar melhor:

- etapas de autenticacao adicional
- timeouts e retry supervisionados
- correlacao de tentativas em processos leves

## Optional Go

Use Go se a peca que voce quer isolar for mais infra do que dominio, por exemplo:

- adaptador pequeno de gateway
- servico de tokenizacao ou policy enforcement de alta vazao
- utilitario de replay/idempotencia em borda propria

Nao use Go so porque checkout parece "mais serio". O boundary continua sendo a decisao principal.

## Failure Modes

- reusar a mesma `Idempotency-Key` com payload diferente
- chamar Stripe fora do boundary e criar pedido em outro lugar
- exigir reauth em toda compra e destruir conversao
- devolver 500 generico quando o cliente precisa de uma acao recuperavel
- deixar a UI depender do shape interno do processador
