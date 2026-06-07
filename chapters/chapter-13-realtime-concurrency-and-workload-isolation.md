# Chapter 13 - Realtime Concurrency and Workload Isolation

## Slice

Como um produto descobre que "mais threads" nao resolve quando conexoes vivas, fanout e isolamento viram parte da experiencia.


## Study Context

- `Study Order`: `13/14` - `Fase 3 - Runtime e produto em escala`
- `Caso real principal`: [Discord - Elixir Realtime Scale](../real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- `Area principal`: [05 - Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)
- `Area secundaria`: [03 - Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)
- `Notes principais`: [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/notes.md), [Filas e Consistencia](../areas/03-filas-e-consistencia/notes.md)
- `Lab`: [Lab - Chapter 13](../labs/chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
- `Review card`: [Card 13](../reviews/cards/13-realtime-concurrency-and-workload-isolation.md)
- `Contraste sugerido`: [Contrast 13 - Rate Limit vs Load Shedding](../decision-contrasts/13-rate-limit-vs-load-shedding.md)
- `Simulation labs`: [Event Backbone / Consumer Lag](../simulation-labs/event-backbone-consumer-lag.md), [Noisy Neighbor / Workload Isolation](../simulation-labs/noisy-neighbor-workload-isolation.md)
- `Operational playbook`: [Incident Severity and Triage](../areas/11-operational-playbooks/playbooks/incident-severity-and-triage.md)
- `Bridge lab`: [Write an SLO, Runbook and Postmortem](../areas/14-engineering-case-study-labs/labs/write-an-slo-runbook-and-postmortem.md)

## Historia de Produto

Seu PO pede chat melhor, presence mais confiavel e notificacao que pareca instantanea. Nada disso parece uma reescrita. O problema e que, no minuto em que o usuario espera conexao viva e resposta em tempo real, o sistema deixa de ser so request/response e passa a carregar trabalho concorrente por muito mais tempo.

## Onde Isso Aparece Antes da Teoria

- chat, presenca, colaboracao e fanout quente
- produtos em que uma sala ou tenant barulhento pode estragar a experiencia dos outros
- sistemas onde manter conexao viva ja custa tanto quanto responder request curta


## First Principles Design Pass

- `Requirement Less Dumb`: o usuario precisa de estado vivo de verdade, ou polling, fanout menor ou notificacao eventual ainda entregam o produto?
- `Delete`: remova sala, evento ou atualizacao em tempo real que nao muda UX de maneira mensuravel.
- `Simplify`: isole o caminho quente e preserve o core onde ele ja funciona; nem todo produto realtime pede reescrita total.
- `Accelerate`: provoque hot room, backlog e presence storm cedo para aprender onde o runtime realmente sofre.
- `Automate Last`: autoscale e rebalancing de conexao entram depois que o comportamento do workload vivo esta entendido.

### Fixacao Relampago: Design Pass

- `Pergunta`: antes de puxar Elixir ou outro runtime, o que voce precisa provar?
- `Resposta com as suas palavras`: eu preciso provar que a pressao de conexao, fanout e estado vivo ja passou do que o desenho atual aguenta bem.
- `Resposta ruim que parece boa`: "realtime e desculpa suficiente para reescrever".
- `Troque por isto`: primeiro eu provo o gargalo de concorrencia; so depois troco runtime ou topologia.

## Foco em Entrevistas

- qual e a unidade certa de isolamento quando cada conexao continua "rodando"
- quando Rails ainda e suficiente e quando o runtime vira a principal decisao arquitetural
- por que observabilidade em sistemas concorrentes precisa de sampling, nao de ingenuidade


## A Tensao Real

Realtime nao quebra primeiro por CPU. Ele quebra quando uma unidade de estado quente passa a disputar atencao com milhares de outras ao mesmo tempo. No Discord, isso deixou de ser teoria cedo: a plataforma precisou sustentar dezenas de milhoes de usuarios concorrentes ao longo do tempo e depois empurrar um unico servidor para mais de 1 milhao de membros online no experimento do Maxjourney ([Discord on Rust and Elixir](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users), [Discord Maxjourney](https://discord.com/blog/maxjourney-pushing-discords-limits-with-a-million-plus-online-users-in-a-single-server)).

O erro comum aqui e achar que o problema e "websocket demais". Nao e. O problema e que cada mensagem, evento de presenca ou mudanca de permissao passa a ter dono, backlog, falha e ordem local. Se voce nao escolhe uma unidade de isolamento boa, um room quente vira outage distribuido.

### Fixacao Relampago 1

- `Pergunta`: quando realtime vira problema de isolamento, e nao so de WebSocket?
- `Resposta com as suas palavras`: quando um room quente ou presence barulhenta comeca a derrubar a experiencia dos outros.
- `Resposta ruim que parece boa`: "se eu abri socket, o problema ja esta resolvido".
- `Troque por isto`: socket abre canal; isolamento e outra conversa, ligada a fanout, estado efemero e fairness.

## Contexto e Constraints do Caso Real

O Discord modelou a carga realtime ao redor de unidades claras de trabalho. No Maxjourney, eles explicam que os `relays` mantem as conexoes com as sessoes e fazem o fanout com permission checks, atendendo ate 15.000 sessoes conectadas por relay ([Discord Maxjourney](https://discord.com/blog/maxjourney-pushing-discords-limits-with-a-million-plus-online-users-in-a-single-server)). Quando um `guild process` precisa mudar de maquina por deploy ou manutencao, o sistema precisa subir o novo processo, copiar estado, reconectar sessoes e depois drenar o backlog acumulado durante a troca ([Discord Maxjourney](https://discord.com/blog/maxjourney-pushing-discords-limits-with-a-million-plus-online-users-in-a-single-server)).

Isso explica por que o runtime importa: a unidade de falha nao e "o app inteiro", e sim uma entidade viva o suficiente para merecer supervisao propria. Mas o proprio Discord tambem mostra o limite do romantismo. Quando algumas estruturas de dados ficaram apertadas demais em memoria e performance, a resposta nao foi jogar fora Elixir; foi manter a logica realtime principal no runtime concorrente e empurrar hotspots especificos para Rust, lado a lado ([Discord on Rust and Elixir](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)).

A terceira restricao foi observabilidade. Em sistemas assim, tentar rastrear tudo costuma derreter o proprio sistema que voce quer entender. O time do Discord descreve explicitamente trade-offs de sampling e propagacao de trace para conseguir responder perguntas fim a fim sem transformar tracing em nova fonte de pressao ([Tracing Discord's Elixir Systems](https://discord.com/blog/tracing-discords-elixir-systems-without-melting-everything)).

## Decisao Tomada

A decisao canonica aqui nao e "use Elixir". E mais estrutural:

1. escolha uma unidade pequena de isolamento que represente o trabalho realtime relevante;
2. supervisione essa unidade como primeira classe, em vez de tratar falha como excecao exotica;
3. separe fanout quente de trabalho comum para um hotspot nao sequestrar a fila inteira;
4. aceite que observabilidade precisa ser amostrada e orientada a perguntas;
5. otimize hotspots pontuais sem abandonar o modelo inteiro cedo demais.

No caso do Discord, isso significou usar o BEAM porque ele compra isolamento barato por processo e uma semantica operacional forte para sistemas com muita coordenacao concorrente. O detalhe maduro e que eles nao trataram o runtime como religiao: onde o gargalo era estrutural, usaram Rust; onde o problema era fanout e estado vivo, mantiveram a logica principal no modelo concorrente ([Discord on Rust and Elixir](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)).

### Fixacao Relampago 2

- `Pergunta`: o que separar primeiro em um sistema realtime que esquentou?
- `Resposta com as suas palavras`: fanout pesado e estado efemero dos fluxos mais quentes, antes de desmontar tudo.
- `Resposta ruim que parece boa`: "vamos tirar tudo do monolito e pronto".
- `Troque por isto`: extraia o workload que agride os demais; nao distribua o dominio inteiro por reflexo.

## Rails First

Para produto menor, o caminho principal continua sendo Rails ate o momento em que conexao viva e fanout passam a dominar a arquitetura. O objetivo nao e imitar o Discord; e isolar cedo o room barulhento, a fila quente e o estado efemero para saber exatamente onde o monolito para de comprar simplicidade.

```rb
module Realtime
  class PublishEvent
    HOT_ROOM_THRESHOLD = 2_000

    def call!(room:, actor:, payload:)
      event = nil

      RoomEvent.transaction do
        event = room.events.create!(actor: actor, payload: payload)

        DeliveryJob.set(queue: delivery_queue_for(room)).perform_later(room.id, event.id)
        PresenceRefreshJob.set(queue: "realtime_presence").perform_later(room.id, actor.id)
      end

      event
    end

    private

    def delivery_queue_for(room)
      room.active_subscribers_count > HOT_ROOM_THRESHOLD ? "realtime_hot_rooms" : "realtime_default"
    end
  end
end

class DeliveryJob < ApplicationJob
  queue_as :realtime_default

  def perform(room_id, event_id)
    room = Room.find(room_id)
    event = room.events.find(event_id)

    ActionCable.server.broadcast(
      "rooms:#{room.id}",
      { id: event.id, body: event.payload, sent_at: event.created_at.iso8601 }
    )
  end
end
```

O ponto do codigo nao e "Action Cable resolve Discord". Ele nao resolve. O ponto e separar rooms quentes de rooms normais, persistir o que precisa sobreviver e admitir que `broadcast` e um workload diferente de `POST /messages`. Quando esse recorte ja nao segura a pressao, a extracao deixa de ser chute e vira resposta objetiva.

## Stack Translation

- `Rails first`: ActionCable, Redis e filas separadas para room quente antes de extrair um boundary novo.
- `Quando Elixir ensina mais`: quando sockets, presence e concorrencia supervisionada por room passam a ser o centro do problema.
- `Quando Go ensina mais`: quando gateway websocket, fanout e entrega em massa viram hot path de infra, nao regra de produto.

## Production Mode

### What Breaks First

- um room quente sequestrando broadcast e presence dos rooms normais
- backlog de entrega crescendo mais rapido do que o sistema consegue drenar
- degradacao silenciosa em presence ou ordering antes de erro 500 aparecer

### Signals to Watch

- p95 e p99 de broadcast
- queue depth por fila realtime
- skew de rooms por subscriber count
- taxa de dropped presence, reconnect e backlog por room

### Safe Rollout

- canary de fila ou worker para rooms quentes
- degrade presence e typing indicators antes de tocar mensagem duravel
- mantenha separacao entre fila default e fila hot-room desde o inicio
- adicione throttling por room antes de mudar runtime inteiro

### Rollback Trigger

- cross-room degradation: room normal ficando lento por causa do room quente
- reconnect storm ou broadcast p99 explodindo
- perda de entrega em fluxo que deveria ser duravel

### First 15 Minutes

- isole ou limite o room mais quente
- desligue sinais nao criticos como presence refinada ou typing
- proteja mensagem persistida antes de proteger perfume de UX
- identifique se o gargalo esta em fanout, presence, Redis ou socket gateway

### Fixacao de Producao

- `Pergunta`: qual degradacao voce aceita primeiro em realtime pesado?
- `Resposta com as suas palavras`: corto perfume antes de cortar mensagem importante.
- `Resposta ruim que parece boa`: "segura tudo igualmente, para nao piorar a experiencia".
- `Troque por isto`: senior escolhe o que morrer primeiro para manter vivo o que o produto realmente nao pode perder.

## Por Que Nao Outra Abordagem

Nao "sobe mais threads no Puma" porque thread a mais ajuda request curta; nao define ownership de estado quente, reconexao, fanout e isolamento por room.

Nao "Kafka resolve realtime" porque fila ajuda desacoplar entrega, mas nao vira automaticamente unidade de conexao viva, permission check ou presence. Ela pode entrar no desenho, mas nao substitui a modelagem da entidade concorrente.

Nao "reescreve tudo em outro runtime hoje" porque muitas empresas pequenas ainda conseguem manter write path, auth e estado duravel no Rails com websocket separado ou AnyCable. O erro e reescrever antes de medir onde a concorrencia deixou de ser detalhe do produto.

## Traducao Explicita Para Empresa Menor

Uma empresa menor normalmente devia comecar assim:

- Rails continua dono de auth, write path e estado duravel;
- Redis ou pub/sub simples carrega presence e sinalizacao efemera;
- fanout quente ganha fila separada e limite operacional claro;
- rooms grandes ou tenants ruidosos entram em degradacao controlada antes de derrubar todos os outros;
- a metrica de extracao deixa de ser "parece elegante" e vira "conexao viva e fanout consomem a maior parte da dor".

Se o seu produto tem chat interno, comentario em tempo real ou presenca leve, isso costuma ser suficiente por bastante tempo. Se ele comeca a ter milhares de conexoes simultaneas por entidade, handoff frequente de estado e necessidade real de supervisao por unidade, entao o runtime concorrente deixa de ser luxo e vira ferramenta certa.

### Fixacao Relampago 3

- `Pergunta`: quando ActionCable puro comeca a ficar pequeno?
- `Resposta com as suas palavras`: quando volume e variacao de rooms fazem presence, fanout e backlog competirem de um jeito que o app inteiro sente.
- `Resposta ruim que parece boa`: "qualquer produto com chat precisa de plataforma realtime separada".
- `Troque por isto`: plataforma dedicada entra quando workload quente pede isolamento real, nao quando o primeiro socket entra em producao.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- sistemas realtime stateful sao mais chatos de operar, drenar e debugar;
- a unidade de isolamento reduz blast radius, mas aumenta a necessidade de roteamento e ownership claros;
- tracing completo costuma ser inviavel, entao o time perde parte da intuitividade do request/response;
- misturar runtimes ou empurrar hotspots para Rust melhora teto, mas adiciona custo operacional e cognitivo.

Sinais de uso errado:

- voce escolheu runtime especializado sem ter fanout ou conexao viva como problema central;
- um room quente ainda compartilha fila, processo ou budget com todos os outros;
- presence, chat e notificacao usam o mesmo caminho da request HTTP sem qualquer isolamento;
- cada deploy mata sessoes sem estrategia de handoff ou de reconexao aceitavel;
- observabilidade so funciona quando voce liga "trace tudo", o que e outro jeito de dizer que ela nao funciona.

## Fechamento: Julgamento Arquitetural

O aprendizado util deste chapter nao e "Realtime pede Elixir". E mais preciso: realtime pede que voce escolha uma unidade de trabalho que consiga isolar, supervisionar e mover sem mentir para si mesmo sobre a natureza stateful do produto. O Discord mostra o teto dessa ideia e tambem o limite: o runtime ajuda muito, mas nao substitui desenho de fanout, observabilidade e hotspots. Para empresa menor, o julgamento maduro e ficar em Rails enquanto o problema principal ainda for produto e persistencia. Quando o problema passa a ser concorrencia viva por entidade, o ponto de extracao aparece com clareza.

## Decision Synthesis

### Use When

- conexao viva, fanout e presenca fazem parte do produto, nao so um detalhe de UX
- voce precisa isolar falhas por room, sessao, stream ou tenant quente
- backlog, handoff e reconexao sao preocupacoes permanentes do caminho critico

### Why This Case Used It

- o Discord precisava tratar salas e sessoes como unidades concorrentes de verdade
- relays, guild processes e supervisao reduziram blast radius e organizaram o trabalho realtime
- hotspots especificos foram otimizados sem abandonar o modelo principal cedo demais

### Main Trade-offs

- mais complexidade operacional em drenagem, observabilidade e ownership de estado
- hotspots continuam existindo e podem exigir estrutura de dados ou runtime auxiliar
- o ganho de isolamento cobra disciplina forte em roteamento e reconexao

### Warning Signs

- o app ainda e quase todo request/response e voce esta escolhendo stack por ansiedade
- fanout quente e workload comum dividem a mesma fila sem protecao
- o sistema nao tem entidade clara para representar o trabalho concorrente

### Decision Checklist

- qual e a menor unidade que eu consigo isolar e supervisionar?
- quando uma sala ou tenant explode, o que protege os vizinhos?
- meu tracing responde perguntas reais sem criar outra fonte de carga?
- o Rails ainda e o melhor dono do core ou ja estou escondendo um problema de runtime?

## Navigation

- [Prev](./chapter-12-distributed-ids-and-ordering-guarantees.md)
- [Index](./README.md)
- [Next](./chapter-14-feed-ranking-and-fanout-trade-offs.md)
