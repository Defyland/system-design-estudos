# Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries

## Slice

Como decidir o que deve morrer na borda, o que o gateway precisa governar e o que continua sendo responsabilidade do app e das dependencias internas.


## Study Context

- `Study Order`: `06/14` - `Fase 1 - Base forte`
- `Caso real principal`: [Cloudflare - Edge Platform](../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- `Caso real complementar`: [Uber - Intelligent Load Management](../real-world-cases/04-edge-and-delivery/uber-intelligent-load-management/README.md)
- `Area principal`: [04 - Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/README.md)
- `Area secundaria`: [05 - Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)
- `Notes principais`: [Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/notes.md), [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/notes.md)
- `Lab`: [Lab - Chapter 06](../labs/chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- `Review card`: [Card 06](../reviews/cards/06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- `Contraste sugerido`: [Contrast 08 - Edge Rate Limit vs App Authorization](../decision-contrasts/08-edge-rate-limit-vs-app-authorization.md)
- `Simulation labs`: [Rate Limit vs Load Shedding](../simulation-labs/rate-limit-vs-load-shedding.md), [Noisy Neighbor / Workload Isolation](../simulation-labs/noisy-neighbor-workload-isolation.md)
- `Operational playbook`: [Incident Severity and Triage](../areas/11-operational-playbooks/playbooks/incident-severity-and-triage.md)
- `Bridge lab`: [Run a Progressive Rollout with Guardrails](../areas/14-engineering-case-study-labs/labs/run-a-progressive-rollout-with-guardrails.md)
- `Backend principle`: [Rate Limiting Algorithms and Keys](../areas/09-backend-principles/cards/rate-limiting-algorithms-and-keys.md)
- `Backend lab`: [Build a Ruby Rate Limiter](../areas/13-backend-principle-labs/labs/build-a-ruby-rate-limiter.md)
- `Snippet`: [Ruby Rate Limiter Keys and Sliding Window](../areas/04-edge-rede-e-acesso/snippets/ruby-rate-limiter-keys-and-sliding-window.md)

## Historia de Produto

Seu PO nao fala "abuse detection". Ele fala que login caiu, export travou o banco e um cliente grande derrubou o caminho de todo mundo. O trabalho arquitetural aqui nao e so botar mais um rate limiter. E desenhar a fronteira certa entre protecao, roteamento, autenticacao e sobrevivencia sob overload.

## Onde Isso Aparece Antes da Teoria

- APIs expostas a abuso, scraping, brute force ou burst imprevisivel
- plataformas com varios produtos ou varios clientes dividindo a mesma borda
- sistemas em que banco, fila ou servico caro precisam ser protegidos de vizinhos ruidosos


## First Principles Design Pass

- `Requirement Less Dumb`: qual trafego realmente precisa morrer na borda e qual ainda depende de semantica de dominio para ser julgado?
- `Delete`: remova regra duplicada entre edge, gateway e app antes de empilhar protecao que ninguem mais entende.
- `Simplify`: edge mata abuso obvio, gateway governa entrada comum e a app continua dona da autorizacao fina.
- `Accelerate`: lance regra nova em canario por rota e acompanhe 429, 403 e dano no caminho critico em minutos, nao em dias.
- `Automate Last`: bloqueio automatico e ajuste dinamico de limite so entram depois que o sinal e confiavel.

### Fixacao Relampago: Design Pass

- `Pergunta`: qual pergunta abre esse problema antes de falar em token bucket e WAF?
- `Resposta com as suas palavras`: eu preciso saber o que pode morrer barato na borda e o que so o dominio consegue decidir direito.
- `Resposta ruim que parece boa`: "o gateway resolve toda a seguranca do sistema".
- `Troque por isto`: primeiro eu separo protecao barata de semantica de negocio; so depois escolho o mecanismo.

## Foco em Entrevistas

- o que pertence ao edge, ao gateway e ao app
- por que rate limiting distribuido e fairness nao se resumem a token bucket
- como falar de overload sem confundir seguranca com logica de negocio


## A Tensao Real

Toda equipe gosta de dizer que "a app valida tudo". O problema e que, quando a validacao semantica roda tarde demais, a origem ja pagou CPU, conexao, banco e dependencia externa. Cloudflare empurra protecao para o edge exatamente porque essa e a forma mais barata de impedir que trafego abusivo sequer alcance a origem ([Cloudflare rate limiting](https://blog.cloudflare.com/counting-things-a-lot-of-different-things/)).

Mas o caso real tambem mata uma simplificacao comum: rate limit nao e so um numero. Cloudflare opera em rede anycast, com o mesmo IP servido em mais de 200 cidades, e cada conexao TCP precisa continuar chegando ao mesmo servidor que a aceitou, ou o cliente recebe `RST` ([Unimog](https://blog.cloudflare.com/unimog-cloudflares-edge-load-balancer/)). Quando voce distribui isso em escala global, contar e decidir na borda sem criar mais latencia vira parte da arquitetura, nao detalhe de middleware.

Do outro lado, a Uber mostra o problema interno: mesmo sem ataque, limite fixo ruim deixa overload quebrar banco e experiencia do usuario. O time saiu de rate limiting estatico para um load manager com filas separadas, fairness por tenant e reguladores locais, chegando a 80% mais throughput sob overload e cerca de 70% menos P99 em upserts no experimento publicado ([Uber Intelligent Load Management](https://www.uber.com/fr/en/blog/from-static-rate-limiting-to-intelligent-load-management/)).

### Fixacao Relampago 1

- `Pergunta`: qual request deveria morrer antes mesmo de tocar a app?
- `Resposta com as suas palavras`: a que ja e obviamente abusiva, invalida ou cara demais para ganhar CPU da origem.
- `Resposta ruim que parece boa`: "deixa entrar e o controller decide".
- `Troque por isto`: toda request ruim que passa da borda ja custou demais.

## Contexto e Constraints do Caso Real

Na Cloudflare, o primeiro constraint e topologico. Como o trafego anycast tende a levar um mesmo IP de cliente ao mesmo PoP, eles puderam transformar rate limiting global demais em um sistema de contagem isolado por PoP, evitando o erro de mandar todos os contadores para um ponto central de alta latencia ([Cloudflare rate limiting](https://blog.cloudflare.com/counting-things-a-lot-of-different-things/)). Mesmo dentro do PoP, cada nova conexao TCP pode cair em servidor diferente, entao a contagem ainda precisa ser compartilhada entre varios servidores. O artigo descreve o uso de memcache shardado por `Twemproxy` e consistent hashing dentro do PoP para dividir essa responsabilidade ([Cloudflare rate limiting](https://blog.cloudflare.com/counting-things-a-lot-of-different-things/)).

O segundo constraint e funcional. A Cloudflare posiciona API Gateway como a camada que governa descoberta de endpoints, schema validation, abuse detection, autenticacao e roteamento sob um unico ponto de entrada, mas sem fingir que tudo e "seguranca". Eles separam claramente seguranca, gestao/monitoramento e routing/authentication como familias de responsabilidades ([Cloudflare API Gateway](https://blog.cloudflare.com/api-gateway/)). Isso e a pista arquitetural importante: gateway bom concentra governanca compartilhada; nao deveria virar deposito de regra de negocio.

O terceiro constraint e operacional. Ate a UI de WAF denuncia isso: habilitar rulesets e uma tarefa comum e ao mesmo tempo propensa a erros perigosos se a equipe nao entende bem o que esta ligando ([Cloudflare WAF](https://blog.cloudflare.com/designing-the-new-cloudflare-waf/)). Ou seja: empurrar mais poder para a borda diminui custo na origem, mas aumenta a chance de bloquear o trafego errado.

Na Uber, o overload nao era um grafico abstrato. O time montou filas CoDel separadas para leituras, escritas e operacoes lentas, exatamente para workloads diferentes nao brigarem do mesmo jeito ([Uber Intelligent Load Management](https://www.uber.com/fr/en/blog/from-static-rate-limiting-to-intelligent-load-management/)). Depois adicionou `Scorecard` para impor limites de concorrencia por tenant e reguladores locais para write volume, hot partition keys, memoria e goroutines, porque um unico limite estatico nao enxergava a forma real do dano ([Uber Intelligent Load Management](https://www.uber.com/fr/en/blog/from-static-rate-limiting-to-intelligent-load-management/)).

## Decisao Tomada

A decisao canonica aqui e dividir a responsabilidade sem deixar zonas cinzentas:

1. edge ou WAF bloqueia o que e obviamente malicioso, invalido ou abusivo antes da origem;
2. gateway autentica, roteia e aplica politicas compartilhadas de API;
3. a app continua dona de autorizacao semantica e regra de negocio;
4. dependencias caras, como banco e servicos internos, ganham admission control e fairness perto do recurso;
5. limites deixam de ser apenas estaticos quando a carga e heterogenea ou multi-tenant.

Em outras palavras: o edge protege a borda publica, o gateway governa a entrada comum e o app ainda decide se aquela mutacao faz sentido para aquele usuario e aquele estado. Ja o overload manager existe para impedir que "request valida" vire motivo de colapso interno.

### Fixacao Relampago 2

- `Pergunta`: o que o gateway faz bem e o que ele nao deveria fazer?
- `Resposta com as suas palavras`: ele governa entrada comum, auth tecnica e roteamento; nao deveria virar juiz da regra fina de negocio.
- `Resposta ruim que parece boa`: "se tenho gateway, posso centralizar toda autorizacao nele".
- `Troque por isto`: gateway compartilha governanca; semantica do dominio continua mais perto da app.

## Rails First

Em produto menor, Rails continua sendo o lugar certo para regra de negocio e para alguns limites simples. O erro seria confundir isso com defesa suficiente para tudo. O recorte maduro e colocar o maximo possivel de bloqueio barato fora da app e deixar dentro dela so o que depende de contexto de negocio.

```rb
# config/initializers/rack_attack.rb
Rack::Attack.throttle("login/ip", limit: 10, period: 1.minute) do |req|
  req.ip if req.path == "/sessions" && req.post?
end

Rack::Attack.throttle("exports/account", limit: 30, period: 1.minute) do |req|
  req.get_header("current_account.id") if req.path.start_with?("/api/exports")
end

class Reports::SubmitExport
  def call!(account:, actor:, params:)
    raise AuthError unless actor.account_id == account.id

    gate = TenantConcurrencyGate.new(key: "exports:#{account.id}", limit: 2)
    raise TooManyRequestsError unless gate.try_acquire

    ExportJob.set(queue: queue_for(account)).perform_later(account.id, params)
  ensure
    gate.release if gate&.acquired?
  end

  private

  def queue_for(account)
    account.priority_support? ? "exports_priority" : "exports_default"
  end
end
```

O snippet e deliberadamente simples. `Rack::Attack` ajuda na borda logica da app. O `TenantConcurrencyGate` protege o recurso caro contra vizinho barulhento. Se voce precisa de WAF, JWT validation ou schema enforcement no edge, isso sai do Rails e sobe para a infraestrutura apropriada. O que permanece no Rails e o julgamento semantico.

## Escolha de Algoritmo Ainda Importa

Depois que a fronteira ficou clara, a proxima pergunta e menos cosmetica do que parece:

- `fixed window` funciona bem para brute force, quotas simples e cap bruto de endpoint publico;
- `sliding window` ou `floating window` suavizam fairness quando burst legitimo e leitura intensa convivem;
- `token bucket` deixa burst curto acontecer sem entregar media infinita;
- `concurrency gate` vence contagem por minuto quando o dano real mora em jobs em voo, conexoes ou workers ocupados.

Em Ruby, isso costuma virar uma escada honesta: `Rack::Attack` ou `INCR/EXPIRE` para o cap barato, `Redis ZSET + WATCH/MULTI` quando voce quer estudar janela mais suave sem sair da stack e, so depois, componentes mais especializados se a disputa distribuida realmente justificar. O importante e a politica nascer do recurso protegido, nao do primeiro algoritmo lembrado.

## Stack Translation

- `Rails first`: autorizacao semantica e gates por tenant continuam no app, mesmo com edge e gateway na frente.
- `Quando Elixir ensina mais`: quando admission control local e muitos reguladores concorrentes ficam mais interessantes do que o handler HTTP em si.
- `Quando Go ensina mais`: quando proxy, limiter, gateway plugin ou servico de overload control passam a ser componentes de infra separados.

## Production Mode

### What Breaks First

- regra nova de edge ou WAF bloqueando trafego legitimo no caminho critico
- limiter por IP punindo o cliente errado e deixando o tenant barulhento escapar
- shed load mal calibrado preservando export e derrubando login

### Signals to Watch

- 401, 403 e 429 por rota, tenant e regra
- origem: CPU, conexao, fila e latencia antes e depois do bloqueio
- false-positive rate em login, checkout e leitura interativa
- saturacao por recurso caro, nao so por gateway global

### Safe Rollout

- regra nova primeiro em observe-only ou log-only
- canary por rota critica, nao por API inteira
- separe politicas de login, leitura interativa e workload pesado
- mantenha um kill switch para desfazer a ultima regra sem redeploy geral

### Rollback Trigger

- auth ou login legitimo sofrendo bloqueio novo
- 429 ou 403 subindo em caminho de receita ou sessao
- origem ainda saturada apesar do limiter, sinal de politicas erradas

### First 15 Minutes

- desligue a regra nova que encostou no caminho critico
- preserve login, leitura interativa e checkout antes de salvar endpoint pesado
- segure export, scraping e burst caro mais perto da borda
- compare saturacao da origem com classificacao do bloqueio, nao confie so no 429 count

### Fixacao de Producao

- `Pergunta`: qual erro operacional deixa edge "parecendo seguro" e ao mesmo tempo machuca o produto?
- `Resposta com as suas palavras`: bloquear o trafego bom e descobrir tarde porque a origem melhorou um pouco.
- `Resposta ruim que parece boa`: "mais bloqueio sempre significa mais controle".
- `Troque por isto`: bloqueio bom mata abuso barato sem cegar login, leitura e receita legitima.

## Por Que Nao Outra Abordagem

Nao "coloca tudo no gateway" porque gateway nao deveria decidir promocao, autorizacao fina de dominio ou semantica de transacao. Se ele fizer isso, voce move complexidade para um lugar pior de versionar e debugar.

Nao "um token bucket por IP resolve" porque IP nao representa bem tenant, prioridade nem recurso protegido. Em ambiente B2B ou multi-tenant, limitar so por IP normalmente pune o cliente errado e deixa o ruidoso escapar por outro caminho.

Nao "o app segura tudo" porque isso faz a origem pagar pela request que ja deveria ter morrido no edge. Em ataque, scraping ou brute force, voce perdeu a economia principal.

Nao "WAF ligado significa seguro" porque regras erradas tambem causam incidente. A propria Cloudflare trata ativacao de ruleset como workflow propenso a erros perigosos se a configuracao for feita sem criterio ([Cloudflare WAF](https://blog.cloudflare.com/designing-the-new-cloudflare-waf/)).

## Traducao Explicita Para Empresa Menor

Empresa menor raramente precisa construir contagem distribuida por PoP. Ela precisa copiar o desenho de fronteira:

- CDN ou provedor de edge bloqueia o trafego obviamente ruim e aplica rate limit bruto em login, API publica e endpoints caros;
- gateway, load balancer ou reverse proxy centraliza JWT, mTLS, roteamento e observabilidade comum;
- Rails continua responsavel por autorizacao e regra de negocio;
- recursos internos sensiveis, como export, billing, search pesada ou integracao de terceiro, ganham limite por tenant ou por conta;
- limites mais caros entram primeiro nos caminhos com blast radius alto, nao em toda rota "porque sim".

Se o trafego ainda e pequeno, um throttle simples no app e um proxy gerenciado podem bastar. O salto para desenho mais sofisticado acontece quando varias apps compartilham a mesma borda ou quando um cliente consegue causar dano desproporcional ao resto.

### Fixacao Relampago 3

- `Pergunta`: por que um limite fixo por IP costuma ficar ruim em produto B2B ou multi-tenant?
- `Resposta com as suas palavras`: porque IP nao conta a historia certa de tenant, prioridade nem recurso caro.
- `Resposta ruim que parece boa`: "rate limit e sempre um numero por IP".
- `Troque por isto`: o limite bom nasce do dano que voce quer conter, e isso muitas vezes mora em tenant, rota ou recurso.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- contagem distribuida, fairness e consistencia na borda sao dificeis por natureza;
- regras fora da app economizam origem, mas pioram a experiencia quando erram;
- gateway centraliza governanca, mas pode virar gargalo organizacional;
- admission control interno melhora sobrevivencia, mas exige sinais de overload confiaveis.

Sinais de uso errado:

- o gateway comecou a carregar regra de negocio que deveria viver no dominio;
- o rate limit so olha IP em produto multi-tenant;
- o overload manager trata leitura interativa e batch pesado exatamente igual;
- a equipe acha que WAF substitui auth, autorizacao ou modelagem ruim do core;
- cada incidente termina com "vamos baixar mais o limite" porque nao existe sinal melhor do que medo.

## Fechamento: Julgamento Arquitetural

O julgamento arquitetural deste chapter e saber onde matar cada tipo de request. Trafego obviamente invalido deve morrer antes da origem. Trafego legitimo, mas barulhento, precisa de fairness e prioridades perto do recurso que ele pode derrubar. E o que depende de negocio continua no app. Cloudflare mostra por que essa divisao precisa existir na borda global; Uber mostra por que ela continua necessaria dentro de casa quando a ameaca vira overload interno. Rate limit bom nao e um numero. E uma politica de sobrevivencia com fronteiras honestas.

## Decision Synthesis

### Use When

- abuso, burst e vizinho ruidoso podem derrubar origem ou dependencias internas
- varias apps ou varios clientes compartilham a mesma entrada
- voce precisa distinguir claramente bloqueio barato, governanca compartilhada e decisao de dominio

### Why This Case Used It

- a Cloudflare precisava contar e bloquear no edge sem centralizar tudo nem aumentar latencia demais
- a Uber precisava impedir que sobrecarga interna e tenants ruidosos degradarem todo o sistema
- ambos os casos exigiam separar protecao compartilhada de semantica de negocio

### Main Trade-offs

- mais poder na borda aumenta risco de falso positivo e configuracao ruim
- fairness real costuma pedir mais do que limite estatico por IP
- admission control interno melhora estabilidade, mas adiciona tuning e operacao

### Warning Signs

- voce esta usando gateway para esconder modelagem ruim da app
- o time nao sabe dizer o que e auth, o que e autorizacao e o que e limitacao de carga
- o mesmo threshold vale para usuario interativo, batch e tenant premium sem diferenciacao

### Decision Checklist

- o que precisa ser bloqueado antes mesmo de tocar a app?
- qual identidade realmente importa para fairness: IP, token, tenant ou recurso?
- qual dependencia cara merece gate proprio?
- o gateway esta concentrando governanca util ou virando um segundo app pior?

## Navigation

- [Prev](./chapter-05-durable-workflows-retries-and-compensation.md)
- [Index](./README.md)
- [Next](./chapter-07-critical-checkout-flows-and-auth-boundaries.md)
