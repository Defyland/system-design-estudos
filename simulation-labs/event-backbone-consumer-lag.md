# Simulation Lab - Event Backbone / Consumer Lag

## Scenario

Novos consumidores entram no log de eventos e um deles comeca a atrasar horas.

## Controls

- publish rate
- partition count
- consumer throughput
- replay size

## Run It

```bash
rake 'simulate[consumer-lag]'                                       # defaults
rake 'simulate[consumer-lag]' ARGS="produce_rps=1500 consumers=3"
```

Compare `produce_rps` com `consumer_rps x consumers` e veja o saldo, o lag acumulado em
`horizon_s` e o minimo de consumers para acompanhar. Engine: [sim/run.rb](./sim/run.rb).

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

