# 03 - Filas e Consistencia

## Por que esta area existe

Fila nao e so broker. Este bloco junta os problemas realmente importantes de sistemas assincronos: entrega, retries, ordenacao e consistencia.

## O que estudar aqui

- queues, particionamento e semanticas de entrega
- Kafka, RabbitMQ e alternativas cloud
- readers, escalabilidade e gargalos
- respostas assincronas, DLQ, retries e idempotencia
- CQRS, SAGA, Event Sourcing
- Sequencer / Snowflake

## O que foi absorvido

- definicoes introdutorias de fila
- separacoes artificiais entre topicos que dependem uns dos outros

## Casos reais para estudar esta area

- [LinkedIn - Kafka Backbone](../../real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
- [Stripe - Idempotent Payments](../../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- [Uber - Cadence Workflows](../../real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- [Twitter - Snowflake IDs](../../real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)
- [Discord - Elixir Realtime Scale](../../real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)

## Ordem sugerida

1. LinkedIn Kafka
2. Stripe
3. Uber Cadence
4. Twitter Snowflake
5. Discord

## Regra de implementacao

- Rails primeiro
- Elixir depois para explorar supervision e concorrencia
- Go depois para workers, consumers e throughput

