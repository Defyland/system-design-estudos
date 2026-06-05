# Smaller B2B - Idempotent Order Submission

- [Chapter 03](../../../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Rails Idempotency Snippet](../snippets/rails-idempotency-key-for-mutating-endpoints.md)

## Cenario

Uma empresa de software vende um portal B2B para distribuidores. O comprador monta um pedido de reposicao de estoque e clica em `Submit order`. O sistema precisa:

- gravar o pedido no banco principal
- publicar um evento `order_submitted`
- enviar o numero do pedido para um ERP externo

Nada aqui e do tamanho da Uber. Mas duplicar pedido segue sendo um desastre porque compra material de verdade.

## Onde A Falha Fica Ambigua

O endpoint Rails cria o pedido e confirma a transacao. Logo depois disso, a chamada ao ERP demora e a conexao HTTP com o navegador expira. O comprador nao sabe se o pedido entrou. Ele atualiza a pagina, o front reenvia o `POST`, e agora voce tem dois pedidos quase iguais.

Esse e o tipo de situacao que Stripe trata como contrato de API: mesma chave, mesmo resultado, mesmo efeito ([Stripe engineering](https://stripe.com/blog/idempotency)).

## Decisao

O portal gera uma `Idempotency-Key` por tentativa real de submissao do pedido. O back-end salva:

- `account_id`
- `idempotency_key`
- `request_fingerprint`
- `status_code`
- `response_body`
- `state`
- `expires_at`

Se o comprador repetir a request com a mesma chave e o mesmo payload, recebe o mesmo `201` com o mesmo `order_id`. Se repetir a chave com itens diferentes, recebe conflito. O evento para fila e a chamada ao ERP usam a mesma referencia de negocio do pedido para nao introduzir duplicacao no restante do fluxo.

## Rails Shape

```ruby
class OrdersController < ApplicationController
  def create
    status, body = Checkout::SubmitOrder.call(
      account: Current.account,
      key: request.headers.fetch("Idempotency-Key"),
      params: order_params.to_h
    )

    render json: body, status: status
  end
end
```

O importante aqui nao e o controller fino. E o fato de que a borda HTTP e dona da identidade da write. A fila nao inventa isso depois.

## Por Que Isso E Suficiente Para Uma Empresa Menor

- um unico Postgres ja resolve persistencia e replay
- um worker simples consegue reenviar para ERP sem criar novo pedido
- suporte consegue procurar pela chave ou pelo `order_id`
- voce nao precisa de uma plataforma de checkout; precisa de disciplina de fronteira

## O Julgamento

Se a write cria algo que o cliente pode pagar, receber ou cobrar, trate double-submit como bug de produto, nao detalhe tecnico. Empresa menor nao precisa de mais componentes. Precisa de menos ilusao.
