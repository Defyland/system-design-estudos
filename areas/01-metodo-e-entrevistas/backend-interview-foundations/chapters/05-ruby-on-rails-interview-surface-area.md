# Chapter 05 - Ruby on Rails Interview Surface Area

## Slice

O conjunto pequeno de assuntos de Rails que mais separa resposta senior de resposta CRUD.

## Study Context

- `Track order`: `05/06` - perguntas laterais de stack que mais derrubam backend
- `Upstream principal`: [Rails Guides - Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
- `Upstream complementar`: [Rails Guides - Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html), [Rails Guides - Caching with Rails](https://guides.rubyonrails.org/caching_with_rails.html), [Rails Guides - Active Storage Overview](https://guides.rubyonrails.org/active_storage_overview.html), [Rails Guides - Securing Rails Applications](https://guides.rubyonrails.org/security.html)
- `Topicos locais`: [Postgres Databases](../../../09-backend-principles/cards/postgres-databases.md), [Caching](../../../09-backend-principles/cards/caching.md), [Task Queues and Background Jobs](../../../09-backend-principles/cards/task-queues-background-jobs.md), [Backend Security](../../../09-backend-principles/cards/backend-security.md), [Scaling Performance](../../../09-backend-principles/cards/scaling-performance.md)
- `Casos ponte`: [GitHub - Rails and MySQL at Scale](../../../../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md), [Stripe - Idempotent Payments](../../../../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- `Review card`: [Card 05](../reviews/cards/05-ruby-on-rails-interview-surface-area.md)

## Why This Matters In Interviews

Em vaga backend senior, resolver algoritmo nao basta.

Voce precisa mostrar que entende:
- query shape
- integridade no banco
- trabalho assincrono
- seguranca
- custo operacional de escalar Rails

## The Core Questions

### 1. Como resolver N+1?

Resposta forte:
- confirmar em log, APM ou Bullet
- usar `includes`, `preload` ou `eager_load` conforme o caso
- paginar e reduzir colunas quando necessario
- garantir indice na consulta que restou

```ruby
posts = Post.includes(:author).limit(50)
posts.each { |post| post.author.name }
```

Follow-ups:
- `joins` nao hidrata associacao
- `eager_load` pode explodir cardinalidade

### 2. includes vs preload vs eager_load?

- `preload`: queries separadas
- `eager_load`: `LEFT OUTER JOIN`
- `includes`: Rails decide, podendo virar join quando voce referencia a associacao

Boa fala:
- "eu escolho pela forma da query e pelo risco de cardinalidade, nao por supersticao"

### 3. Validacao Rails basta para integridade?

Resposta forte:
- nao
- UX e regra de dominio ficam na app
- integridade critica precisa de `NOT NULL`, `UNIQUE`, FK e `CHECK`
- validacao de unicidade sem indice unico tem race condition

### 4. Quando usar transacao e locking?

- transacao para manter fronteira atomica curta
- optimistic locking quando conflito e raro
- pessimistic locking quando perda de atualizacao e inaceitavel

Boa fala:
- "estoque, saldo e claim de recurso unico pedem conversa seria sobre lock"

### 5. Como desenhar jobs robustos?

Resposta forte:
- idempotencia primeiro
- payload pequeno
- timeout
- retry so para erro transitorio
- observabilidade

```ruby
class SendReceiptJob < ApplicationJob
  queue_as :mailers

  def perform(order_id)
    order = Order.find_by(id: order_id)
    return unless order
    return if order.receipt_sent?

    ReceiptMailer.order_receipt(order).deliver_now
    order.update!(receipt_sent: true)
  end
end
```

### 6. Como usar cache corretamente?

Resposta forte:
- cachear dado caro e relativamente estavel
- chave boa, TTL, invalidacao e fallback
- nao misturar cache sem escopo de tenant ou autorizacao

```ruby
Rails.cache.fetch("product/#{product.id}/price", expires_in: 10.minutes) do
  PricingService.fetch(product)
end
```

### 7. Como evitar SQL injection?

Resposta forte:
- nao interpolar params em SQL string
- usar binds e APIs do Active Record
- allowlist para identificador dinamico

```ruby
# ruim
User.where("email = '#{params[:email]}'")

# bom
User.where(email: params[:email])
```

### 8. Como processar muitos registros?

Resposta forte:
- `find_each` ou `in_batches`
- batches pequenos
- transacoes curtas
- medir lock, memoria e throughput

```ruby
User.active.find_each(batch_size: 1_000) do |user|
  UserMailer.weekly(user).deliver_later
end
```

### 9. Como falar de escalabilidade em Rails sem virar folclore?

Sequencia forte:
1. medir p95, SQL lento, cache hit, alloc e chamadas externas
2. melhorar query shape, indices e N+1
3. mover trabalho lento para jobs
4. ajustar cache, pool, Puma workers/threads
5. usar replica, CDN e object storage quando o perfil pedir
6. so discutir extração de servico quando houver boundary real

## The Frequent Traps

- `default_scope` que esconde query
- callback fazendo HTTP ou side effect externo
- service object para embrulhar CRUD trivial
- `update_all` usado sem entender que pula callback e validation
- pool do banco menor do que concorrencia efetiva

## Interview Compression

- `15 segundos`: Rails senior e query shape, integridade, jobs, cache e seguranca.
- `15 segundos`: N+1, transacao, lock, idempotencia e SQL injection aparecem o tempo todo.
- `1 minuto`: a melhor resposta de Rails sempre cruza app, banco e operacao; nunca fica presa no controller.

## Decision Synthesis

### Use When

- voce esta se preparando para vaga backend Ruby/Rails
- precisa de respostas curtas mas defensaveis
- quer ligar framework a corretude e escala reais

### Why This Matters

- entrevistador quer saber se voce protege a fronteira do sistema
- bugs de Rails senior normalmente moram em banco, fila, cache e auth
- docs oficiais sustentam muito bem as respostas

### Main Trade-offs

- abstrair cedo demais vira cerimonia
- empurrar tudo para callback vira fluxo invisivel
- escalar infra antes de medir query shape custa caro

### Warning Signs

- voce diz "includes resolve sempre"
- fala de transacao sem falar de lock ou constraint
- trata job como exatamente uma vez
- usa cache sem escopo ou invalidacao

## Production Recall

- `Pergunta`: quais assuntos de Rails mais se repetem em entrevista backend senior?
- `Resposta com as suas palavras`: N+1, includes/preload/eager_load, integridade no banco, transacao e locking, jobs idempotentes, cache, SQL injection e escalabilidade por medicao.
- `Resposta ruim`: Rails e so saber MVC e gems populares.
- `Troque por isto`: Rails senior e fronteira de dados, efeito colateral e operacao.

## Fixacao Relampago

- `Pergunta`: o que voce deve dizer quando pedirem "como escalar Rails"?
- `Resposta curta`: medir primeiro, corrigir query shape e hot path, mover trabalho lento para jobs, depois ajustar cache, banco e infra.
- `Armadilha`: adicionar microservico ou Redis antes de provar o gargalo.
- `Correcao`: escala forte comeca em medicao e caminho critico.
