# Rails Idempotency Key For Mutating Endpoints

- [Chapter 05](../../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Related Example](../examples/smaller-b2b-idempotent-order-submission.md)

## When to Use

Use este padrao quando:

- o endpoint faz `POST`, `PATCH` ou outra write que pode gerar cobranca, pedido, reserva ou alteracao irreversivel
- o cliente pode repetir a request por timeout, refresh, retry automatico ou duplo clique
- voce precisa devolver a mesma resposta para a mesma intencao de negocio

Nao use para fingir que `GET` precisa de idempotency key. Leitura ja deveria ser idempotente por definicao.

## Rails First

Modelo minimo:

```ruby
# db/migrate/xxxx_create_idempotency_records.rb
create_table :idempotency_records do |t|
  t.string :scope, null: false
  t.string :key, null: false
  t.string :request_fingerprint, null: false
  t.string :state, null: false, default: "processing"
  t.integer :status_code
  t.jsonb :response_body
  t.datetime :expires_at, null: false
  t.timestamps
end

add_index :idempotency_records, [:scope, :key], unique: true
```

```ruby
# app/services/idempotent_request_runner.rb
class IdempotentRequestRunner
  class KeyConflict < StandardError; end
  class RequestInProgress < StandardError; end

  Result = Struct.new(:status, :body)

  def self.call(scope:, key:, params:)
    fingerprint = Digest::SHA256.hexdigest(params.to_json)
    record = IdempotencyRecord.find_by(scope:, key:)

    if record
      raise KeyConflict if record.request_fingerprint != fingerprint
      raise RequestInProgress if record.state == "processing"

      return Result.new(record.status_code, record.response_body)
    end

    IdempotencyRecord.create!(
      scope:,
      key:,
      request_fingerprint: fingerprint,
      state: "processing",
      expires_at: 48.hours.from_now
    )

    result = yield

    IdempotencyRecord.where(scope:, key:).update_all(
      state: "completed",
      status_code: result.fetch(:status),
      response_body: result.fetch(:body)
    )

    Result.new(result.fetch(:status), result.fetch(:body))
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
```

```ruby
# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  def create
    result = IdempotentRequestRunner.call(
      scope: Current.account.id.to_s,
      key: request.headers.fetch("Idempotency-Key"),
      params: order_params.to_h
    ) do
      order = Order.transaction do
        created_order = Order.create!(order_params)
        OutboxEvent.create!(topic: "order_submitted", aggregate_id: created_order.id)
        created_order
      end

      { status: 201, body: { order_id: order.id, status: order.status } }
    end

    render json: result.body, status: result.status
  rescue IdempotentRequestRunner::KeyConflict
    render json: { error: "idempotency_key_reused_with_different_payload" }, status: :conflict
  rescue IdempotentRequestRunner::RequestInProgress
    render json: { error: "request_still_processing" }, status: :accepted
  end
end
```

Notas de julgamento:

- `scope` normalmente e tenant, conta ou combinacao de dominio que evita colisao acidental
- `request_fingerprint` precisa ser derivado do payload canonico, nao do JSON cru em ordem arbitraria
- side effects externos devem receber a mesma referencia de negocio quando o provedor suportar isso
- limpe chaves expiradas por job simples; nao faca da retencao um drama filosfico

## Optional Elixir

Elixir ensina algo novo quando voce quer deixar explicito o estado de processamento e a recuperacao:

- `Ecto` continua sendo a ancora da durabilidade
- um `GenServer` ou job supervisionado pode carregar a chave enquanto a operacao esta `processing`
- a licao nao e "usar ETS no lugar do banco"; e separar memoria transitoria de estado que precisa sobreviver ao crash

Se a chave precisa sobreviver a deploy, reinicio ou failover, ela pertence a storage duravel.

## Optional Go

Go ensina algo novo quando voce quer middleware enxuto e controle mais visivel de concorrencia:

- middleware le a `Idempotency-Key`
- service usa transacao SQL e indice unico para fazer `create or replay`
- handlers pequenos deixam claro onde termina HTTP e onde comeca o contrato de negocio

Use Go aqui se o aprendizado for sobre composicao de middlewares e servicos pequenos, nao porque Ruby "nao aguenta" o conceito.

## Failure Modes

- mesma chave com payload diferente e aceita silenciosamente
- resposta e gravada antes de a operacao realmente comecar, prendendo erro de validacao desnecessariamente
- indice unico nao existe e requests concorrentes criam duas linhas
- so a tabela do pedido e protegida; fila, email ou PSP continuam recebendo duplicado
- TTL e curto demais para o comportamento de retry do cliente
- estado `processing` nao expira nem entra em reconciliacao depois de crash
