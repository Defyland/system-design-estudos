# Review Card 04 - Event Backbone, Partitions and Consumer Scale

## Linked Material

- [Chapter 04](../../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Lab 04](../../labs/chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)

## Anchor

- `Problema`: o mesmo fato de negocio precisa servir varios consumidores, replay e historico.
- `Decisao`: sair da fila ponto a ponto e assumir um backbone de eventos com particao, schema e consumo independente.

## Cue Signal

- `Sinal`: o mesmo fato precisa alimentar varios consumidores, cada um com escala, atraso, replay e ownership proprios.

## Case Anchor

- `Caso real`: [LinkedIn - Kafka Backbone](../../real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
- `Lembrete`: Kafka virou backbone quando um produtor precisou publicar um fato uma vez e deixar varios leitores viverem no proprio ritmo.

## QDSAA Recall

- `Requirement corrigido`: o requisito nao e "tenho muito volume"; e "tenho varios consumidores e replay".
- `Delete`: evento que ainda e chamada interna fantasiada.
- `Forma simples`: fila simples com outbox antes de backbone completo.

## Trade-off to Remember

- `Custo`: schema governance, lag e replay viram responsabilidade de plataforma.
- `Failure mode`: particao quente ou replay grande derrubando downstream.

## Trap

- `Resposta ruim`: "Kafka e melhor sempre que ha muitas mensagens".
- `Troque por isto`: backbone entra quando o problema e multiplicidade de leitores e historico de evento, nao volume isolado.

## 1-Minute Answer

Evento com particao certa preserva ordem util dentro do agregado. Consumer lag, skew e replay passam a fazer parte do desenho, nao so da operacao.
