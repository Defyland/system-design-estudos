# Contrast 06 - Queue vs Event Backbone

## Tension

Os dois movem trabalho assincrono, mas so um trata o fato como algo que vive alem do primeiro consumidor.

## Use Queue When

- ha um trabalho claro para executar
- o consumidor principal ja esta definido
- replay e multipla leitura nao sao centrais

## Use Event Backbone When

- o mesmo fato interessa a varios consumidores
- replay e historico importam
- contratos de evento e particao viram parte da arquitetura

## Trap

- `Resposta ruim`: "mais mensagens significa Kafka".
- `Troque por isto`: backbone entra quando o problema e autonomia de consumo e vida longa do evento.

## 15-Second Distinction

Fila entrega trabalho. Backbone compartilha fatos.

## Pull Chapters

- [Chapter 04](../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
