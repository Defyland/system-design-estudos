# Chapter 03 - Idempotent Writes Under Ambiguous Failure

## Slice

Como uma API mutante evita efeitos duplicados quando a rede falha no pior momento possivel: depois que o servidor ja comecou a trabalhar e antes do cliente saber se deu certo.


## Study Context

- `Study Order`: `03/14` - `Fase 1 - Base forte`
- `Caso real principal`: [Stripe - Idempotent Payments](../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- `Caso real complementar`: [Uber - Unified Checkout](../real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- `Area principal`: [03 - Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)
- `Area secundaria`: [04 - Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/README.md)
- `Notes principais`: [Filas e Consistencia](../areas/03-filas-e-consistencia/notes.md), [Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/notes.md)
- `Lab`: [Lab - Chapter 03](../labs/chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- `Review card`: [Card 03](../reviews/cards/03-idempotent-writes-under-ambiguous-failure.md)
- `Contraste sugerido`: [Contrast 05 - Idempotency Key vs Unique Index](../decision-contrasts/05-idempotency-key-vs-unique-index.md)
- `Simulation labs`: [Queue Replay / Idempotency](../simulation-labs/queue-replay-idempotency.md)
- `Operational playbook`: [Queue Lag, DLQ and Replay](../areas/11-operational-playbooks/playbooks/queue-lag-dlq-and-replay.md)
- `Bridge lab`: [Build an Idempotent Write API](../areas/13-backend-principle-labs/labs/build-an-idempotent-write-api.md)
- `Foundations`: [Two-Phase Commit](../areas/06-foundations-distribuidas/topics/two-phase-commit.md), [Deadlocks](../areas/06-foundations-distribuidas/topics/deadlocks.md)

## Historia de Produto

Seu PO nao quer ouvir a frase "foi so um retry". Ele quer saber por que o cliente tomou duas cobrancas ou por que o pedido apareceu duas vezes. E voce percebe que o bug nao esta no duplo clique. Esta na fronteira que nao sabia prometer efeito unico.

## Onde Isso Aparece Antes da Teoria

- pagamentos, pedidos, reservas, envios de webhook e qualquer write cara
- operacoes mutantes expostas a timeout, refresh, retry automatico ou reprocessamento
- produtos pequenos e grandes, porque falha ambigua nao pede escala absurda para aparecer


## First Principles Design Pass

- `Requirement Less Dumb`: o usuario precisa de resposta instantanea, ou precisa sobretudo de garantia de que o efeito nao vai acontecer duas vezes?
- `Delete`: tente remover retry cego, efeito duplicado e mutacao redundante antes de complicar o fluxo com muita orquestracao.
- `Simplify`: comece com `Idempotency-Key`, fingerprint e replay no mesmo banco da write antes de pensar em workflow engine.
- `Accelerate`: simule logo a falha chata de commit feito com resposta perdida para aprender rapido onde o contrato quebra.
- `Automate Last`: reconciliacao, replay assistido e alerta automatico entram depois que a semantica da operacao ja esta clara.

### Fixacao Relampago: Design Pass

- `Pergunta`: o que voce protege primeiro nesse tema: a request ou o efeito?
- `Resposta com as suas palavras`: eu protejo o efeito de negocio; retry bonito nao vale nada se eu ainda puder cobrar ou criar duas vezes.
- `Resposta ruim que parece boa`: "se eu der mais retry, uma hora passa".
- `Troque por isto`: primeiro eu garanto efeito unico; so depois eu melhoro experiencia de retry.

## Foco em Entrevistas

- como explicar falha ambigua com precisao
- por que exactly-once quase nunca e a resposta pratica
- como desenhar uma write API segura sob retry e efeitos externos


## Questions

- o que e uma falha ambigua?
- por que retry sem idempotencia vira bug de negocio, nao so bug de rede?
- onde a idempotencia deve morar: cliente, borda HTTP, banco, fila ou todos?

## Extract

- idempotency keys
- retry com backoff e jitter
- replay seguro de resposta
- diferenca entre deduplicar requests e deduplicar efeitos
- julgamento sobre exactly-once vs effect-once

## Rails First

Implemente o controle na borda mutante da API, persista a primeira resposta canonica e trate a chave como identificador da intencao de negocio.

## Done When

- voce consegue explicar por que uma falha ambigua existe mesmo com um unico cliente falando com uma unica API
- voce consegue desenhar um endpoint Rails que aceita retry sem duplicar pagamento, pedido ou reserva
- voce sabe quando idempotency key resolve e quando so mascara desenho ruim

## A Tensao Real

O problema nao aparece quando tudo funciona. Ele aparece quando a request cai no buraco distribuido mais chato: o servidor pode ter validado, gravado e ate chamado um provedor externo, mas a resposta nao volta para o cliente. Stripe descreve exatamente esse ponto: a conexao pode falhar no meio da operacao ou depois do sucesso, deixando o cliente sem saber se repetir e seguro ([Stripe engineering](https://stripe.com/blog/idempotency)).

Sem idempotencia, o retry vira um dado honesto com o caixa da empresa. Em pagamentos isso pode cobrar duas vezes. Em checkout isso pode criar dois pedidos. Em reservas isso pode segurar duas vagas. A rede nao esta tentando te sabotar; ela so nao te deve confirmacao perfeita.

### Fixacao Relampago 1

- `Pergunta`: quando uma write precisa de idempotency key de verdade?
- `Resposta com as suas palavras`: quando repetir a request pode cobrar, reservar, criar ou mutar de novo sem eu perceber.
- `Resposta ruim que parece boa`: "isso e so para pagamento".
- `Troque por isto`: qualquer mutacao exposta a retry ambiguo pode precisar da mesma protecao, nao so cobranca.

## Contexto E Constraints Do Caso Real

Stripe usa idempotency keys em endpoints mutantes para transformar retry em comportamento previsivel. A documentacao e bem especifica: a primeira resposta fica registrada pelo servidor com status code e body, inclusive `500`; retries com a mesma chave recebem o mesmo resultado; e o servidor compara os parametros recebidos para impedir reuso acidental da chave com outro payload ([Stripe docs](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)). Tambem ha uma janela de retencao: chaves podem ser removidas depois de pelo menos 24 horas, e reuso depois da poda volta a ser uma nova request ([Stripe docs](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)).

Stripe combina isso com modelagem de estado de pagamento. O PaymentIntent existe para acompanhar um pagamento ao longo do ciclo de vida, costuma corresponder a um carrinho ou sessao, e deve ser reutilizado quando o checkout e interrompido e retomado, em vez de criar um novo pagamento toda vez ([Stripe Payment Intents](https://docs.stripe.com/payments/payment-intents)).

Uber tinha outro sabor do mesmo inferno: cerca de 70 endpoints podiam resultar em transacao financeira, metodos de pagamento nao eram suportados de forma uniforme entre LOBs e a pressao regulatoria de SCA/3DS virou gatilho para reorganizar a arquitetura ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)). A resposta deles nao foi espalhar logica defensiva em todo canto. Eles criaram uma camada de Unified Checkout para concentrar a orquestracao, tratar cada linha de negocio como cliente externo e absorver a complexidade de fluxos assincronos, incluindo o fato de que muitos processadores respondem de forma assincrona. Nesses casos, o checkout espera o sinal de confirmacao do pagamento antes de confirmar ou cancelar o pedido ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)). O resultado nao foi so "arquitetura bonita": no experimento citado pela Uber, o checkout unificado elevou a taxa de conversao em 3% e a session recovery em 4.5% em relacao ao fluxo legado ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

Esse e o ponto arquitetural importante: Stripe ancora a seguranca na chave idempotente da write API; Uber ancora a consistencia numa fronteira de checkout unica e num fluxo orientado a estados. Os dois aceitam que a rede e ambigua. Nenhum tenta vencer a fisica com fe.

## Decisao Tomada

A decisao canonica aqui e simples de falar e chata de implementar direito:

- toda operacao mutante exposta a retry recebe uma idempotency key
- a chave representa uma unica intencao de negocio, nao uma tentativa tecnica
- o servidor persiste a primeira resposta canonica e faz replay dela nos retries
- payload diferente com a mesma chave e erro, nao "talvez"
- efeitos assincronos ficam presos a um estado de negocio, nao a repeticoes cegas do `POST`

Em Rails, o desenho minimo forte costuma ser uma tabela `idempotency_records` no mesmo banco transacional da write principal, com `scope`, `key`, `request_fingerprint`, `status_code`, `response_body`, `state` e `expires_at`, mais indice unico por escopo e chave.

```ruby
# app/services/checkout/submit_order.rb
class Checkout::SubmitOrder
  class KeyConflict < StandardError; end
  class RequestInProgress < StandardError; end

  def self.call(account:, key:, params:)
    fingerprint = Digest::SHA256.hexdigest(params.to_json)

    record = IdempotencyRecord.find_by(scope: account.id, key: key)

    if record
      raise KeyConflict if record.request_fingerprint != fingerprint
      raise RequestInProgress if record.state == "processing"

      return [record.status_code, record.response_body]
    end

    IdempotencyRecord.create!(
      scope: account.id,
      key: key,
      request_fingerprint: fingerprint,
      state: "processing",
      expires_at: 48.hours.from_now
    )

    order = nil

    Order.transaction do
      order = Order.create!(account: account, total_cents: params.fetch(:total_cents), status: "submitted")

      IdempotencyRecord.where(scope: account.id, key: key).update_all(
        state: "completed",
        status_code: 201,
        response_body: { order_id: order.id, status: order.status }
      )
    end

    [201, { order_id: order.id, status: order.status }]
  rescue ActiveRecord::RecordNotUnique
    retry
  end
end
```

O detalhe decisivo nao esta no Ruby em si. Esta no contrato:

- se a validacao falha antes da operacao comecar, nao grave replay definitivo
- se a operacao comecou, grave um registro recuperavel da primeira resposta
- se houver efeito externo, propague a mesma referencia de negocio para o downstream quando ele suportar isso

### Fixacao Relampago 2

- `Pergunta`: o que a chave idempotente representa?
- `Resposta com as suas palavras`: uma unica intencao de negocio. Nao e um ticket generico de retry sem contexto.
- `Resposta ruim que parece boa`: "qualquer request parecida pode reciclar a mesma chave".
- `Troque por isto`: mesma chave com payload diferente e conflito, porque mudou a intencao.

## Stack Translation

- `Rails first`: tabela de idempotencia no mesmo banco da write, fingerprint do payload e replay transacional da primeira resposta.
- `Quando Elixir ensina mais`: quando checkout, pagamento e retries deixam de ser so endpoint e passam a se comportar como maquina de estados.
- `Quando Go ensina mais`: quando adaptadores de PSP, borda de alta taxa ou workers de dedup/replay viram gargalo de infra.

## Production Mode

### What Breaks First

- request ficando presa em `processing` depois de timeout ou crash
- retry do cliente atravessando a borda e disparando efeito financeiro ambiguo
- reuso de chave com payload errado confundindo pedido legitimo com corrupcao

### Signals to Watch

- quantidade e idade de registros `processing`
- taxa de conflito por `Idempotency-Key`
- PSP timeout rate e diferenca entre sucesso no provedor e sucesso no app
- hit rate de replay vs create rate de operacoes novas

### Safe Rollout

- habilite idempotencia primeiro em um endpoint e escopo pequenos
- registre e audite chaves em modo observacao antes de endurecer conflitos
- mantenha contrato de payload e TTL conservadores ate ver o retry real
- use flag para novas politicas de replay, nunca para desligar a protecao inteira no susto

### Rollback Trigger

- duplicate charge risk ou divergencia entre pedido interno e PSP
- crescimento de chaves presas em `processing`
- conflito legitimo demais por fingerprint ruim ou escopo estreito

### First 15 Minutes

- pare retries agressivos do cliente e do worker
- compare estado interno com o estado no PSP antes de qualquer replay manual
- isole chaves presas e force reconciliacao, nao repeticao cega
- preserve o contrato idempotente mesmo se precisar degradar o endpoint

### Fixacao de Producao

- `Pergunta`: qual e o erro de senior fraco em incidente de idempotencia?
- `Resposta com as suas palavras`: sair repetindo operacao para ver se volta, sem saber se o dinheiro ja saiu.
- `Resposta ruim que parece boa`: "se falhou, tenta de novo mais vezes".
- `Troque por isto`: primeiro descubra se a falha foi de execucao ou de confirmacao; so depois toque no retry.

## Por Que Nao Outra Abordagem

### "So usa retry no cliente"

Retry sem idempotencia resolve conexao ruim criando bug bom de reproduzir e pessimo de explicar para financeiro. Stripe trata retry seguro como parte do contrato da API, nao como gambiarra do SDK ([Stripe engineering](https://stripe.com/blog/idempotency)).

### "So poe unique index na tabela de pedidos"

Indice unico ajuda a bloquear duplicacao local, mas nao responde tudo. Ele nao te devolve a resposta canonica anterior, nao explica payload divergente com a mesma chave e nao cobre bem efeitos externos como cobranca, fila e email.

### "So deduplica no consumer da fila"

Isso protege parte do back-end, mas a ambiguidade nasce antes: na borda HTTP, quando o cliente nao sabe se deve repetir o `POST`. Se a sua deduplicacao mora so no consumidor, o usuario ainda pode gerar duas writes validas antes de a fila sequer entrar na historia.

### "Vamos garantir exactly-once"

Quase sempre isso e jeito caro de dizer "vamos esconder os retries atras de muito estado". O alvo pragmatico e `effect-once` na fronteira que importa. O resto do sistema pode continuar vivendo com entrega pelo menos uma vez, desde que consumidores e integracoes respeitem a mesma identidade de negocio.

## Traducao Explicita Para Empresa Menor

Empresa menor nao precisa de um Unified Checkout com dezenas de microservices. Mas tambem nao pode agir como se double-submit fosse folclore.

Para um SaaS B2B menor, o desenho geralmente basta assim:

- um endpoint Rails `POST /orders` ou `POST /payments`
- uma tabela `idempotency_records` no Postgres principal
- uma chave gerada pelo cliente ou pelo front server e enviada no header `Idempotency-Key`
- um fingerprint do payload para bloquear reuso errado
- TTL simples de 24 a 72 horas, alinhado ao comportamento real de retry do produto
- a mesma referencia de negocio repassada para PSP, ERP ou broker quando possivel

Se o seu checkout e uma tela, pense como Stripe. Se o seu checkout orquestra varios sistemas e metodos de pagamento, pense como Uber. Numa empresa menor, normalmente voce comeca no modelo Stripe e so cria uma camada estilo Uber quando a quantidade de fluxos, times e metodos de pagamento torna a borda unica inevitavel.

### Fixacao Relampago 3

- `Pergunta`: qual e o ganho real de idempotencia bem feita?
- `Resposta com as suas palavras`: eu transformo retry nervoso em replay previsivel, em vez de loteria com estado financeiro.
- `Resposta ruim que parece boa`: "um indice unico no pedido ja resolve tudo".
- `Troque por isto`: indice unico evita parte da duplicacao local, mas nao devolve a resposta canonica nem protege bem integracoes externas.

## Trade-offs E Sinais De Uso Errado

### Trade-offs

- guardar chave, fingerprint e resposta custa estado e disciplina operacional
- reexecutar a mesma resposta, inclusive erro interno, pode surpreender quem esperava "retry ate passar"
- TTL curto demais reabre janela de duplicacao; TTL longo demais aumenta custo e area de suporte
- a fronteira fica mais segura, mas integracoes externas continuam exigindo correlacao e reconciliacao

### Sinais De Uso Errado

- a chave identifica a sessao inteira em vez de uma unica intencao mutante
- a equipe aceita a mesma chave com payload diferente "porque era parecido"
- o endpoint e idempotente, mas email, webhook ou enqueue continuam disparando em duplicidade
- `processing` vira estado zumbi sem timeout nem reconciliacao
- a empresa usa idempotency key para esconder falta de modelagem de estado

## Fechamento: Julgamento Arquitetural

Idempotencia nao e detalhe HTTP. E um contrato de negocio para conviver com falha ambigua sem cobrar, pedir ou reservar duas vezes. Stripe mostra a versao minima e rigorosa: mesma chave, mesmo resultado, parametros comparados, retry seguro ([Stripe docs](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)). Uber mostra a versao organizacional: quando o checkout atravessa muitos produtos, metodos e processadores assincronos, voce concentra a orquestracao numa fronteira unica ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

Se o custo de duplicar efeito e relevante, a pergunta certa nao e "sera que precisamos disso?". A pergunta certa e "qual e a menor fronteira onde conseguimos prometer effect-once com honestidade?".

## Decision Synthesis

### Use When

- a operacao cria, confirma ou altera algo que nao pode ser duplicado sem dor
- cliente, worker ou integracao pode repetir a chamada por timeout, refresh, retry automatico ou reprocessamento
- existe chance real de falha ambigua entre o inicio da write e a confirmacao para o cliente

### Why This Case Used It

- a Stripe precisava permitir retry seguro em APIs mutantes sem criar dupla cobranca
- a Uber precisava concentrar a parte financeira mais sensivel numa fronteira que sobrevivesse a varios fluxos e processadores
- os dois casos tratam a rede como ambigua e o efeito de negocio como sagrado

### Main Trade-offs

- guardar chave, fingerprint e resposta adiciona estado e custo operacional
- replay de erro ou estado intermediario exige semantica muito clara
- proteger a borda nao elimina a necessidade de correlacao e idempotencia em downstreams relevantes

### Warning Signs

- a mesma chave vale para varias intencoes de negocio
- payload diferente e aceito com a mesma chave
- o endpoint e idempotente, mas fila, email ou PSP continuam disparando em duplicidade

### Decision Checklist

- qual e exatamente a unidade de efeito que nao pode duplicar?
- o que eu devolvo no retry: recalculo ou replay da primeira resposta?
- meus efeitos externos conseguem carregar a mesma referencia de negocio?
- qual TTL cobre o comportamento real de retry do produto sem virar lixo eterno?

## Navigation

- [Prev](./chapter-02-pod-isolation-and-tenant-routing.md)
- [Index](./README.md)
- [Next](./chapter-04-event-backbone-partitions-and-consumer-scale.md)
