# Review Card 06 - Event Backbone, Partitions and Consumer Scale

## Linked Material

- [Chapter 06](../../chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)
- [Lab 06](../../labs/chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)

## 15-Second Recall

- `Pergunta`: quando fila simples deixa de bastar?
- `Resposta curta`: quando o mesmo fato precisa de varios consumidores, replay e vida propria alem do primeiro job.

## Wrong Turn

- `Resposta ruim`: "Kafka e melhor sempre que ha muitas mensagens".
- `Troque por isto`: backbone entra quando o problema e multiplicidade de leitores e historico de evento, nao volume isolado.

## 1-Minute Answer

Evento com particao certa preserva ordem util dentro do agregado. Consumer lag, skew e replay passam a fazer parte do desenho, nao so da operacao.

## Production Recall

- `Pergunta`: qual leitura voce quer antes de olhar lag medio?
- `Resposta curta`: a particao mais quente, a fila que nao drena e o schema que acabou de mudar.

## Wrong Production Move

- `Resposta ruim`: "se esta atrasado, aumenta replay e consumo para todos".
- `Troque por isto`: senior primeiro isola particao ruim e protege downstream, depois acelera.

## Transfer Check

- se voce ainda tem um unico consumidor e nunca reprocessa nada, provavelmente ainda esta no mundo da fila simples
