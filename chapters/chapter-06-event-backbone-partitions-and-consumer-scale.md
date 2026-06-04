# Chapter 06 - Event Backbone, Partitions and Consumer Scale

## Slice

Como um backbone de eventos deixa de ser "so uma fila" e vira uma decisao sobre contratos, particoes, replay e escala de consumidores.

## Historia de Produto

Seu PO quer que uma unica mudanca de negocio alimente analytics, notificacao, antifraude, busca e backoffice. O primeiro impulso e responder "tranquilo, bota numa fila". O segundo impulso, se voce ja sofreu com isso, e perguntar: "quem vai carregar a complexidade quando esse mesmo evento precisar servir cinco times, replay e processamento em tempo real?".

## Onde Isso Aparece Antes da Teoria

- produtos em que o mesmo fato de negocio precisa alimentar varios consumidores independentes
- times que querem replay, auditoria ou reprocessamento sem recolocar carga na base transacional
- contextos em que fila ponto a ponto comeca a virar cola arquitetural demais

## Case Anchors

- [LinkedIn - Kafka Backbone](../real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)

## Foco em Entrevistas

- quando Kafka e backbone, e quando uma fila simples resolveria com menos custo
- como escolher chave de particionamento sem confundir ordenacao local com ordenacao global
- como explicar replay, consumer lag e evolucao de schema sem soar decorado

## Study Links

- [Area - Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)
- [Notes - Filas e Consistencia](../areas/03-filas-e-consistencia/notes.md)
- [Area - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/README.md)
- [Notes - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/notes.md)
- [Lab](../labs/chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)

## A Tensao Real

"Bota numa fila" e conselho bom quando existe um produtor, um consumidor e uma tarefa assincrona bem definida. Vira conselho ruim quando o mesmo evento passa a servir varios produtos ao mesmo tempo. No LinkedIn, Kafka nao nasceu como adorno de arquitetura. Ele virou o backbone de mensageria para monitoring, pub/sub tradicional, analytics e ate como bloco de construcao para outros sistemas distribuidos ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future)).

O custo real aparece depois do primeiro sucesso. Em 2015, o LinkedIn dizia processar mais de 1 trilhao de mensagens publicadas por dia, com pico de 4,5 milhoes de mensagens publicadas por segundo, e cada mensagem sendo consumida por cerca de quatro aplicacoes em media ([How We're Improving and Advancing Kafka at LinkedIn](https://engineering.linkedin.com/apache-kafka/how_we_re-improving-and-advancing-kafka-linkedin)). O ponto nao e o numero bonito. O ponto e o efeito colateral: cada nova aplicacao conectada ao backbone transforma uma decisao local em problema compartilhado de throughput, lag, schema e operacao.

### Fixacao Relampago 1

- `Pergunta`: quando fila simples comeca a perder para um event backbone?
- `Resposta com as suas palavras`: quando eu preciso de varios consumidores independentes, replay e historico de evento de verdade.
- `Resposta ruim que parece boa`: "Kafka e melhor porque escala mais".
- `Troque por isto`: backbone entra quando o problema mudou de job assinado para fluxo compartilhado de eventos.

## Contexto e Constraints do Caso Real

No LinkedIn, o backbone precisava atender times e linguagens diferentes, em mais de um datacenter e com niveis bem distintos de maturidade operacional. O post do time lista casos de uso que ja mostram por que fila simples nao bastava: metricas e traces operacionais, mensageria de aplicacoes como Search e Feed, analytics centralizado e replicacao/propagacao de mudancas para outros sistemas ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future)).

Essa variedade forca algumas decisoes chatas e importantes:

- eventos precisavam de contratos legiveis e evolutiveis, por isso o LinkedIn padronizou boa parte dos schemas em Avro com schema registry ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future));
- dados de varios datacenters precisavam ser agregados, o que levou ao uso de MirrorMaker para mover eventos entre clusters ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future));
- processamento em tempo real precisava existir em cima do backbone, e nao ao lado dele, o que aparece na relacao Kafka + Samza para feeds com milhares de subscribers ([Apache Samza: LinkedIn's Real-time Stream Processing Framework](https://engineering.linkedin.com/data-streams/apache-samza-linkedins-real-time-stream-processing-framework));
- reprocessamento e catch-up de consumers podiam saturar rede e disco, entao quotas, monitoramento de lag e balanceamento de particoes viraram parte da plataforma, nao detalhe de SRE ([How We're Improving and Advancing Kafka at LinkedIn](https://engineering.linkedin.com/apache-kafka/how_we_re-improving-and-advancing-kafka-linkedin)).

Repare na tensao: o backbone so vale a pena porque desacopla. Mas justamente por desacoplar ele atrai cada vez mais carga, mais replay e mais casos de uso. Sem governanca, o backbone vira um concentrador de acidentes.

## Decisao Tomada

A decisao canonica aqui nao e "use Kafka". E mais especifica:

1. publicar fatos de negocio uma vez, em topicos compartilhados, em vez de integrar produtor com cada consumidor;
2. escolher a particao pela entidade cuja ordem local realmente importa;
3. tratar schema, replay, lag e quotas como parte do produto da plataforma;
4. escalar consumidores por consumer group, sem pedir ao produtor que conheca todos eles;
5. aceitar que o backbone nao entrega ordenacao global, apenas ordenacao por particao.

No LinkedIn, isso significou usar Kafka como circulacao central de dados, mas cercado por componentes de plataforma: thin client REST para linguagens nao Java, schema registry para contratos, MirrorMaker para replicacao e ferramentas operacionais para lag, quotas e balanceamento ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future); [How We're Improving and Advancing Kafka at LinkedIn](https://engineering.linkedin.com/apache-kafka/how_we_re-improving-and-advancing-kafka-linkedin)).

Tambem significou assumir um fato importante para entrevistas e para producao: o evento bom nao representa "algo que um consumidor quer". Ele representa "algo que aconteceu no negocio". Quando voce erra essa linha, o produtor passa a publicar topicos para agradar consumidores especificos, e o backbone comeca a apodrecer no nascimento.

### Fixacao Relampago 2

- `Pergunta`: o que a particao realmente preserva?
- `Resposta com as suas palavras`: ordem dentro da chave certa, nao um relogio global do sistema inteiro.
- `Resposta ruim que parece boa`: "particionar nao muda nada, o sistema continua totalmente ordenado".
- `Troque por isto`: escolher mal a chave destroi ordem util e cria skew ao mesmo tempo.

## Rails First

Em Rails, a menor versao honesta desse desenho costuma ser `transactional outbox` + evento versionado + chave de particionamento explicita. O ganho nao esta em falar com Kafka cedo; esta em separar fato de negocio, publicacao e consumo idempotente.

```rb
class Orders::Confirm
  def call!(order)
    Order.transaction do
      order.update!(status: "confirmed")

      OutboxEvent.create!(
        stream: "commerce.order-events.v1",
        event_id: SecureRandom.uuid,
        event_type: "order.confirmed.v1",
        partition_key: order.account_id.to_s,
        payload: {
          order_id: order.id,
          account_id: order.account_id,
          total_cents: order.total_cents,
          confirmed_at: Time.current.iso8601
        }
      )
    end
  end
end

class OutboxPublisherJob
  def perform(outbox_event_id)
    event = OutboxEvent.pending.find(outbox_event_id)

    KafkaClient.publish(
      topic: event.stream,
      key: event.partition_key,
      headers: {
        "event_id" => event.event_id,
        "event_type" => event.event_type,
        "schema_version" => "1"
      },
      payload: JSON.generate(event.payload)
    )

    event.update!(published_at: Time.current)
  end
end

class SearchProjectionConsumer
  def consume(message)
    event_id = message.headers.fetch("event_id")
    return if ConsumedEvent.exists?(consumer: "search_projection", event_id: event_id)

    event = JSON.parse(message.payload)
    SearchProjection.upsert_from_order_confirmation!(event)

    ConsumedEvent.create!(consumer: "search_projection", event_id: event_id)
  end
end
```

O detalhe que mais importa e o `partition_key`. Se a ordem relevante e por conta, talvez `account_id` seja o certo. Se a ordem relevante e por pedido, talvez `order_id`. Se a ordem relevante e por SKU, a resposta muda. Particao nao e detalhe tecnico. E a forma concreta de dizer qual sequencia de fatos precisa continuar legivel.

## Stack Translation

- `Rails first`: outbox transacional, contratos de evento pequenos e consumidores modestos ainda perto do dominio.
- `Quando Elixir ensina mais`: quando ordenacao por chave, coordinacao entre consumidores e backpressure ficam mais educativos do que o proprio CRUD.
- `Quando Go ensina mais`: quando producer, consumer e ferramenta de stream precisam ser pequenos, rapidos e muito previsiveis em throughput.

## Por Que Nao Outra Abordagem

Nao "uma fila por feature" porque isso faz o produtor conhecer demais o mundo ao redor. Quando analytics, notificacao e antifraude dependem do mesmo fato, o produtor deveria publicar uma vez, nao tres.

Nao "um topico por consumidor" porque isso degrada o evento de negocio em API privada disfarcada. Um backbone bom reduz acoplamento. Um topico por consumidor o recria em outro formato.

Nao "uma unica particao para garantir ordem" porque isso compra uma ilusao cara. Voce ganha ordem total local e perde throughput, paralelismo e resiliencia do jeito mais previsivel possivel.

Nao "JSON livre sem contrato" porque a ausencia de schema formal so parece agil na primeira sprint. O LinkedIn padronizou schemas e registry justamente porque, em ambiente multi-time, quebrar consumer silenciosamente e um esporte facil demais ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future)).

## Traducao Explicita Para Empresa Menor

Empresa menor nao precisa copiar o zoologico inteiro do LinkedIn. Nao precisa multi-datacenter, MirrorMaker ou um time dedicado de plataforma para provar valor.

A traducao util costuma ser bem menor:

- um ou dois topicos de negocio importantes, nao vinte topicos especulativos;
- `transactional outbox` no banco principal;
- payload versionado com `event_id`, `event_type`, `occurred_at` e `aggregate_id`;
- dois ou tres consumidores independentes, por exemplo notificacao, busca e analytics;
- metrica de `consumer lag` e politica clara de replay antes de chamar isso de backbone.

Se hoje existe um unico consumidor e nenhuma necessidade real de replay, uma fila simples ou ate jobs no proprio banco podem ser a escolha certa. O backbone entra quando o mesmo fato precisa viver alem do primeiro consumidor.

### Fixacao Relampago 3

- `Pergunta`: quando um backbone de eventos vira exagero?
- `Resposta com as suas palavras`: quando eu ainda tenho um ou dois consumidores simples e nunca preciso replay serio.
- `Resposta ruim que parece boa`: "se tem mais de uma fila, ja preciso de Kafka".
- `Troque por isto`: antes de backbone, confirme se o produto realmente pede multiplos leitores, reprocessamento e autonomia de consumo.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- particionamento ruim cria skew, hot partitions e throughput pior do que o esperado;
- replay e catch-up de consumers geram carga real sobre broker, rede e storages derivadas;
- governanca de schema e compatibilidade viram trabalho continuo;
- observabilidade precisa incluir lag, rebalancing, falhas de consumo e backlog por grupo.

Sinais de uso errado:

- o produtor publica formatos diferentes do mesmo fato para agradar consumidores especificos;
- ninguem sabe explicar por que a chave de particionamento foi escolhida;
- replay de um consumidor antigo derruba o cluster inteiro ou suas dependencias;
- topicos viram dumping ground de JSON sem versao;
- existe apenas um consumidor simples, sem necessidade de replay, e mesmo assim o time quer um backbone porque "soa escalavel".

## Fechamento: Julgamento Arquitetural

Event backbone nao e compra de tecnologia. E compra de disciplina sobre distribuicao de fatos. O LinkedIn usou Kafka como backbone porque precisava que muitos sistemas trabalhassem juntos de forma frouxamente acoplada, com replay, stream processing e crescimento de consumidores ao longo do tempo ([Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future)). O aprendizado util para empresa menor nao e repetir a escala. E repetir o julgamento: so vale pagar por backbone quando o mesmo evento precisa servir mais de um fluxo importante e quando voce esta disposto a operar particoes, contratos e lag como parte da arquitetura.

## Decision Synthesis

### Use When

- varios consumidores independentes precisam reagir ao mesmo fato de negocio
- replay, fanout e processamento em tempo real trazem valor concreto
- a ordem que importa cabe por particao, e nao exige ordenacao global

### Why This Case Used It

- o LinkedIn precisava de um backbone compartilhado para monitoring, analytics, mensageria de aplicacoes e sistemas derivados
- o numero de consumidores e o volume de dados tornaram schema, quotas e lag parte da plataforma
- particoes e consumer groups permitiram escalar sem reescrever cada integracao ponto a ponto

### Main Trade-offs

- governanca de schema e compatibilidade adicionam processo e trabalho continuo
- particionamento errado gera skew e reduz o throughput util
- replay e catch-up aumentam a carga operacional e exigem observabilidade de verdade

### Warning Signs

- existe um unico consumidor e nenhuma necessidade clara de replay
- o produtor modela evento para agradar um consumidor especifico
- a equipe fala de Kafka, mas nao sabe qual entidade define a chave de particionamento

### Decision Checklist

- eu preciso mesmo de mais de um consumidor independente para o mesmo fato?
- qual entidade precisa manter ordenacao local?
- como vou versionar schema e detectar consumer lag cedo?
- se eu precisar reprocessar uma semana de dados, meu desenho aguenta?

## Navigation

- [Prev](./chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Index](./README.md)
- [Next](./chapter-07-durable-workflows-retries-and-compensation.md)
