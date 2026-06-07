# LinkedIn - Kafka Backbone

## Why this case matters

Caso real e fundacional para mensageria: pub-sub, streaming, schema registry e operacao multi-datacenter.

## Course topics

- queues e pub-sub
- particionamento
- retries e durabilidade
- schemas de eventos
- stream processing

## Stack relevance

- Rails: medium
- Elixir: medium
- Go: high

## Primary sources

- [Kafka at LinkedIn: Current and Future](https://engineering.linkedin.com/kafka/kafka-linkedin-current-and-future)
- [How We're Improving and Advancing Kafka at LinkedIn](https://engineering.linkedin.com/apache-kafka/how-we_re-improving-and-advancing-kafka-linkedin)
- [Apache Samza: LinkedIn's Real-time Stream Processing Framework](https://engineering.linkedin.com/data-streams/apache-samza-linkedins-real-time-stream-processing-framework)

## What to extract

- papel do Kafka como backbone
- schema registry e contratos
- consumo multi-subscriber
- replicacao e agregacao entre datacenters

## Strong Anchor

Kafka vira backbone quando o mesmo fato de negocio precisa sobreviver a multiplos consumidores, replay e evolucao de schema sem pedir ao produtor que conheca cada leitor.

## Architecture spine

- producer publica o fato uma vez com chave de particao explicita
- schema registry impede payload solto de virar contrato invisivel
- consumer groups deixam cada uso escalar no proprio ritmo
- replay, MirrorMaker e quotas viram parte da plataforma, nao detalhe tardio

## Failure mode to remember

Replay amplo ou schema incompativel derruba downstream enquanto o broker parece saudavel.

## 3-Minute Drill

- qual agregado define a chave de particao aqui?
- qual consumidor pode atrasar sem virar incidente de negocio imediato?
- que guardrail trava um replay antes dele competir com trafego ao vivo?

## Linked Chapters

- [Chapter 04 - Event Backbone, Partitions and Consumer Scale](../../../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
