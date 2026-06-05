# Chapter 07 - Critical Checkout Flows and Auth Boundaries

## Slice

Como desenhar a fronteira entre sessao, autorizacao, risco e pagamento sem transformar checkout no lugar onde o sistema aprende a cobrar duas vezes.


## Study Context

- `Study Order`: `07/14` - `Fase 2 - Caminhos criticos e dados especializados`
- `Caso real principal`: [Uber - Unified Checkout](../real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- `Caso real complementar`: [Stripe - Idempotent Payments](../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- `Area principal`: [04 - Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/README.md)
- `Area secundaria`: [03 - Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)
- `Notes principais`: [Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/notes.md), [Filas e Consistencia](../areas/03-filas-e-consistencia/notes.md)
- `Lab`: [Lab - Chapter 07](../labs/chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)
- `Review card`: [Card 07](../reviews/cards/07-critical-checkout-flows-and-auth-boundaries.md)
- `Contraste sugerido`: [Contrast 05 - Idempotency Key vs Unique Index](../decision-contrasts/05-idempotency-key-vs-unique-index.md)

## Historia de Produto

Seu PO quer mais conversao, menos susto com charge duplicada e um checkout que funcione igual em web, mobile e suporte interno. Parece pedido de produto. Na pratica, e uma aula de fronteira: quem autentica, quem autoriza e quem tem permissao para mutar dinheiro.

## Onde Isso Aparece Antes da Teoria

- checkouts, assinaturas, upgrades de plano e qualquer mutacao com dinheiro no meio
- produtos com mais de um canal ou fluxo de confirmacao
- sistemas em que auth forte, risco e pagamento comecam a se encostar


## First Principles Design Pass

- `Requirement Less Dumb`: o produto precisa de uma fonte unica de verdade para checkout e auth critica, ou so esta repetindo logica em varios cantos sem dono claro?
- `Delete`: apague fluxo duplicado de pagamento, autorizacao e recuperacao espalhado por cliente, BFF e servicos laterais.
- `Simplify`: um boundary explicito com estados claros vale mais que varias integracoes frouxas tentando cooperar.
- `Accelerate`: acompanhe logo abandono, recovery, timeout por etapa e rollback por metodo de pagamento para aprender rapido.
- `Automate Last`: roteamento inteligente, retries adaptativos e automacao de risco entram depois que a fronteira e os estados ja estao firmes.

### Fixacao Relampago: Design Pass

- `Pergunta`: o que merece ser centralizado primeiro em checkout critico?
- `Resposta com as suas palavras`: as transicoes de estado e as decisoes que nao podem divergir entre canais ou metodos de pagamento.
- `Resposta ruim que parece boa`: "basta mover tudo para um servico novo e chamar de checkout".
- `Troque por isto`: primeiro eu centralizo a decisao critica e o estado; o resto so entra se realmente compartilhar valor.

## Foco em Entrevistas

- como separar auth, autorizacao e mutacao critica
- quando um checkout pede boundary proprio
- como falar de step-up auth, idempotencia e recovery sem inflar a solucao


## Questions

- o que deve ficar na borda de auth e o que deve entrar na fronteira do checkout?
- quando um sistema precisa de step-up auth, idempotencia e estado explicito?
- por que centralizar o checkout ajuda mais do que espalhar regras por produto?

## Extract

- checkout orchestration
- auth boundaries
- payment lifecycle
- idempotent mutation
- recovery-first UX

## Abertura

Checkout e o lugar onde um erro de fronteira vira prejuizo real. Se a sessao expira no momento errado, o usuario parece logado mas nao consegue concluir. Se o sistema reenvia a mutacao sem disciplina, cobra duas vezes. Se cada produto implementa seu proprio 3DS, PIX ou troca de payment method, a empresa multiplica custo e falha do jeito mais caro possivel: no caminho da receita.

O detalhe importante aqui e meio cruel: checkout nao falha apenas por bug de pagamento. Ele falha porque auth, risco, estado do pedido e integracao com processador costumam se encostar exatamente no mesmo request.

### Fixacao Relampago 1

- `Pergunta`: por que checkout costuma quebrar de um jeito mais caro do que outras telas?
- `Resposta com as suas palavras`: porque auth, risco e pagamento se encostam no mesmo ponto onde o dinheiro entra.
- `Resposta ruim que parece boa`: "se a Stripe responder, o resto e detalhe".
- `Troque por isto`: PSP ajuda a cobrar; a fronteira de checkout ainda precisa decidir permissao, replay e proxima acao.

## Contexto e Constraints do Caso Real

A Uber chegou nesse problema quando pagamentos deixaram de ser detalhe do produto de rides e viraram problema transversal para varios LOBs. O post descreve que havia por volta de 70 endpoints capazes de gerar uma transacao financeira, todos falando direto com risco e pagamentos, o que explodia custo de manutencao e paridade entre fluxos ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)). Apple Pay, Google Pay, transferencias bancarias e fluxos com 2FA nao apareciam de forma uniforme entre ride imediata, agendamento, troca de payment profile e outros caminhos importantes ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

O gatilho organizacional foi regulatorio: Strong Customer Authentication exigia MFA e 3-D Secure em parte das transacoes europeias. Isso forcou a empresa a tratar autenticacao de pagamento como capacidade de plataforma, nao como detalhe local de cada servico ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)). Do lado de pagamento seguro, a Stripe reforca a razao tecnica: falhas de rede deixam o cliente em estado ambiguo, e mutacoes sem idempotencia tornam retry perigoso exatamente no tipo de operacao que nao pode duplicar ([Stripe Idempotency Blog](https://stripe.com/blog/idempotency)).

## Decisao Tomada

A decisao da Uber foi criar uma camada de checkout unificada que trata cada LOB como cliente externo. Essa camada concentra suporte a payment methods, integracao de risco, preparacao de payment profile e uma estrutura generica de `Checkout Actions` para guiar 2FA, fingerprinting, reautenticacao e recuperacao de falhas ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

Dois pontos importam mais do que o nome bonito da plataforma:

1. O checkout virou a fronteira oficial da mutacao critica.
2. O payload de acao ficou opaco para os servicos de produto, de proposito, para que a complexidade de pagamento nao vazasse para cada time ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

Em paralelo, a disciplina de pagamento seguro pede que cada mutacao seja reexecutavel sem efeito colateral extra. A Stripe documenta que sua camada de idempotencia guarda status code e body da primeira requisicao para uma chave, inclusive `500`, e responde o mesmo resultado em retries subsequentes ([Stripe Idempotent Requests](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)). Em outras palavras: o request critico precisa ter identidade propria.

O resultado nao foi so organizacional. No experimento descrito pela Uber, o checkout unificado mostrou 3% mais conversao de checkout e 4.5% mais recuperacao de sessao que a experiencia legada, sinal de que a fronteira tambem melhora recuperacao de erro, nao apenas governanca ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

### Fixacao Relampago 2

- `Pergunta`: qual e a pergunta que pertence ao boundary de checkout?
- `Resposta com as suas palavras`: "posso mutar este pedido com este risco e este metodo agora, sem cobrar duas vezes?"
- `Resposta ruim que parece boa`: "checkout e so mais um controller protegido por login".
- `Troque por isto`: login responde quem e voce; checkout responde se essa mutacao critica pode acontecer agora.

## O Julgamento Arquitetural

Sessao e borda de auth respondem "quem e voce?". Checkout responde "com este carrinho, este valor, este metodo e este risco, posso mutar estado e tentar cobrar agora?". Misturar essas duas perguntas no mesmo controller de produto normalmente produz um sistema que parece simples por duas sprints e depois vira museu de `if`.

Uma fronteira boa de checkout costuma centralizar:

- validacao final de permissao sobre o carrinho ou pedido
- step-up auth quando o contexto mudou de forma sensivel
- idempotencia da mutacao
- orquestracao do estado de pagamento
- traducao de falha em proxima acao recuperavel

Ela nao deveria centralizar:

- regra de negocio irrelevante para pagamento
- detalhes de tela de um produto especifico
- decisao de catalogo, promocao ou descoberta que pode viver fora do caminho critico

## Rails First

Em Rails, a implementacao primaria nao precisa nascer como microservico. O recorte mais valioso e criar um boundary interno claro: controller fino, service de checkout, tabela de idempotencia e resultado explicito para `completed`, `requires_customer_action` ou `failed`.

```rb
module Checkout
  class SubmitOrder
    def initialize(stripe_client: Stripe::PaymentIntent)
      @stripe_client = stripe_client
    end

    def call!(cart:, actor:, payment_method_id:, idempotency_key:)
      raise AuthError, "login required" unless actor
      raise AuthError, "cart does not belong to actor" unless cart.account_id == actor.account_id

      require_recent_reauth!(actor, cart) if risky_checkout?(actor, cart)

      IdempotentRequest.fetch_or_run!(
        scope: "checkout:cart:#{cart.id}",
        key: idempotency_key
      ) do
        intent = @stripe_client.create(
          {
            amount: cart.total_cents,
            currency: cart.currency,
            customer: actor.stripe_customer_id,
            payment_method: payment_method_id,
            confirm: true,
            metadata: { cart_id: cart.id }
          },
          { idempotency_key: idempotency_key }
        )

        case intent.status
        when "requires_action"
          CheckoutResult.requires_customer_action(
            action: "confirm_payment",
            client_secret: intent.client_secret
          )
        when "succeeded", "requires_capture"
          Order.transaction do
            order = Order.create_from_cart!(cart, actor)
            CheckoutResult.completed(order_id: order.id)
          end
        else
          CheckoutResult.failed(reason: intent.status)
        end
      end
    end

    private

    def risky_checkout?(actor, cart)
      actor.recent_payment_method_change? || cart.high_value?
    end
  end
end
```

Esse desenho conversa bem com o modelo da Stripe, em que `PaymentIntent` acompanha o pagamento da criacao ate o checkout e pode disparar autenticacao adicional quando necessario ([Stripe Payment Intents](https://docs.stripe.com/payments/payment-intents)). Tambem conversa com a ideia da Uber de devolver a proxima acao sem vazar o motor interno de pagamentos para cada fluxo de produto ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

## Stack Translation

- `Rails first`: modulo de checkout dentro do monolito, auth guard, reauth seletiva e mutacao idempotente com contrato claro.
- `Quando Elixir ensina mais`: quando risco, sessao e pagamento passam a se comportar como fluxo com estado, retry e retomada.
- `Quando Go ensina mais`: quando adaptadores de pagamento, validacao de token ou borda de checkout de alta taxa viram servicos proprios.

## Production Mode

### What Breaks First

- timeout de PSP ou risco deixando checkout em estado ambiguo
- regra nova de reauth, 3DS ou risk step-up destruindo conversao sem alertar logo
- boundary novo de checkout recebendo retry burst e prendendo pedidos em `processing`

### Signals to Watch

- checkout conversion por etapa
- latencia e timeout rate do PSP
- abandono em `requires_action`
- idade de requests idempotentes em `processing`
- erro por payment method, rota de checkout e tenant

### Safe Rollout

- canary por payment method, tenant ou percentual pequeno de trafego
- observe-only para regra de risco quando possivel
- mantenha caminho de recovery e replay antes de ligar step-up auth novo
- preserve contrato de idempotencia durante todo o rollout

### Rollback Trigger

- conversao despencando logo apos a mudanca
- duplicate charge risk ou divergencia entre pedido interno e PSP
- crescimento rapido de `requires_action` ou `processing` sem saida clara

### First 15 Minutes

- desligue a regra mais nova de risco, reauth ou payment method antes de mexer em outras camadas
- preserve checkout idempotente, mesmo que precise degradar UX
- compare estado de pedido interno contra o PSP antes de reexecutar qualquer acao
- proteja o caminho de receita bom e suspenda o caminho novo, nao o contrario

### Fixacao de Producao

- `Pergunta`: qual reflexo mata checkout mais rapido que o bug original?
- `Resposta com as suas palavras`: tentar "destravar" cobranca repetindo mutacao sem saber o estado financeiro real.
- `Resposta ruim que parece boa`: "o cliente quer comprar, entao libera retry e depois reconcilia".
- `Troque por isto`: senior primeiro segura ambiguidade e protege dinheiro; velocidade sem estado correto vira prejuizo.

## Por Que Nao Outra Abordagem

### Por que nao deixar cada produto integrar pagamento sozinho?

Porque foi exatamente isso que doeu na Uber. Quando cada LOB fala direto com risco e pagamento, a empresa perde paridade de payment method, repete trabalho regulatorio e carrega dezenas de endpoints mutantes com semantica ligeiramente diferente ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

### Por que nao resolver so com API gateway e middleware de auth?

Porque gateway autentica e protege entrada, mas nao conhece o estado semantico do checkout. Ele nao sabe se o usuario mudou o payment profile agora, se o valor exige step-up auth, se o pedido ja foi reservado, ou se o retry precisa devolver exatamente o mesmo resultado. Essa decisao mora mais perto da mutacao do dominio do que da borda de rede.

### Por que nao partir direto para microservico de checkout?

Porque empresa menor quase sempre consegue capturar 80% do valor dentro do monolito. O ganho vem primeiro da fronteira logica, nao da distribuicao fisica. Separar cedo demais adiciona RPC, tracing, deploy pipeline e ownership fragmentado antes de voce ter volume ou variedade suficiente.

## Traducao Para Empresa Menor

Imagine um marketplace menor com web e app, um time pequeno e um unico backend Rails. O erro comum e espalhar `authorize!`, criacao de pedido e chamada da Stripe em controllers diferentes. O resultado: o login funciona, mas o checkout nao tem fronteira propria.

A versao madura para empresa menor e:

- manter sessao e autenticacao na camada normal do app
- criar um modulo de checkout com estado explicito
- exigir reautenticacao recente apenas para eventos sensiveis
- usar `Idempotency-Key` do cliente e persistir replay da resposta
- tratar resposta do processador como estado do checkout, nao como detalhe de UI

Se houver um segundo produto ou um segundo canal de compra, esse boundary comeca a pagar aluguel imediatamente. Se nao houver, ainda assim ele evita que o caminho da receita vire uma colagem de callbacks.

### Fixacao Relampago 3

- `Pergunta`: quando uma empresa menor ja deveria criar fronteira propria de checkout?
- `Resposta com as suas palavras`: quando auth recente, risco e pagamento comecam a se misturar em mais de um fluxo e controller.
- `Resposta ruim que parece boa`: "so quando eu tiver um microservico de pagamentos".
- `Troque por isto`: a fronteira boa nasce primeiro como modulo logico; distribuicao fisica vem bem depois, se vier.

## Trade-offs e Sinais de Uso Errado

### Trade-offs

- centralizar checkout melhora consistencia, mas cria um time e um caminho critico com alta responsabilidade
- payload opaco protege o resto do sistema, mas dificulta debugar quando observabilidade e pobre
- step-up auth reduz fraude e falha regulatoria, mas adiciona friccao de conversao
- idempotencia simplifica retry, mas exige chave, storage e semantica clara de escopo

### Warning Signs

- seu "checkout central" tambem quer decidir preco, cupom, ranking e catalogo
- o sistema nao distingue `authenticated session` de `authorized checkout mutation`
- retries de pagamento reaproveitam outro payload com a mesma chave
- o servico de produto comeca a interpretar campos internos do payload de acao
- todo erro de pagamento retorna 500 generico, sem proxima acao recuperavel

## Fechamento

O principal julgamento arquitetural deste chapter e simples: checkout critico merece uma fronteira propria quando auth, risco e pagamento comecam a se cruzar no mesmo fluxo. A Uber centralizou porque variacao de produto e regulacao tornaram a duplicacao inviavel; a Stripe mostra por que retry seguro precisa ser contrato de mutacao, nao improviso de cliente. Para empresa menor, a traducao nao e "crie uma plataforma"; e "pare de tratar checkout como mais um controller". Quando o caminho da receita ganha estado explicito, auth guard certo e idempotencia real, o sistema fica menos heroico e mais confiavel.

## Decision Synthesis

### Use When

- o mesmo negocio atende mais de um canal, produto ou fluxo de pagamento
- parte do checkout pode exigir 2FA, 3DS, reauth ou recuperacao de sessao
- falha ambigua de rede pode gerar dupla cobranca ou pedido zumbi

### Why This Case Used It

- a Uber precisava parar de repetir logica critica de pagamento em dezenas de endpoints e LOBs ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/))
- a Stripe mostra que mutacao financeira segura precisa ser idempotente sob falha ambigua ([Stripe Idempotency Blog](https://stripe.com/blog/idempotency))

### Main Trade-offs

- mais consistencia e paridade entre fluxos
- mais disciplina de estado e observabilidade
- mais cuidado para nao transformar a fronteira em gargalo organizacional

### Warning Signs

- checkout centralizado cedo demais para um unico fluxo trivial
- step-up auth usado em toda compra, sem criterio
- time de produto dependendo de detalhes internos da orquestracao

### Decision Checklist

- o que prova identidade nesta etapa e o que prova permissao de mutar o pedido?
- qual mutacao precisa ser idempotente de ponta a ponta?
- quais falhas devem virar "tente outra vez" e quais devem virar "execute esta acao"?
- essa complexidade ja e compartilhada o bastante para merecer boundary proprio?

## Navigation

- [Prev](./chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Index](./README.md)
- [Next](./chapter-08-blob-durability-and-storage-tiers.md)
