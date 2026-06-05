# Simulation Lab - Event Backbone / Consumer Lag

## Scenario

Novos consumidores entram no log de eventos e um deles comeca a atrasar horas.

## Controls

- publish rate
- partition count
- consumer throughput
- replay size

## What Changes

Mais particoes aumentam paralelismo, mas a chave errada cria skew.

## Failure Mode

Replay grande compete com trafego ao vivo.

## Cost Signal

Backbone barato para publicar pode ficar caro para consumir e reprocessar.

## Interview Takeaway

Kafka e log compartilhado. Cada consumidor novo vira responsabilidade operacional.

## Linked Chapters

- [Chapter 04](../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 13](../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)

## Linked Areas

- [Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)

## Mastery Checks

- `Pergunta`: qual chave de particionamento nasce primeiro?
- `Resposta com as suas palavras`: a chave do agregado onde ordem importa.
- `Resposta ruim que parece boa`: particionar aleatoriamente distribui melhor.
- `Troque por isto`: distribuicao sem ordem correta quebra semantica.

