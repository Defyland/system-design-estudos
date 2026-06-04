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

## Regra de implementacao

- Rails primeiro
- Elixir depois para explorar supervision e concorrencia
- Go depois para workers, consumers e throughput
