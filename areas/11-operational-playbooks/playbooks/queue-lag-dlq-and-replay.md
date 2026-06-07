# Queue Lag, DLQ and Replay

## Trigger

Consumidores atrasados, tempo de fila explodindo, DLQ enchendo ou reprocessamento necessario depois de bug.

## Signals

- consumer lag crescente;
- backlog nao converge;
- retries repetindo a mesma falha;
- DLQ concentrada por tenant, topic ou payload.

## Immediate Actions

- bloquear producers nao essenciais se necessario;
- medir lag por partition e idade da mensagem;
- separar falha de capacidade de falha logica;
- congelar replay ate idempotencia e ordering estarem claras.

## Stabilize

Aumentar consumers quando o gargalo for capacidade, reduzir throughput de entrada, shuntar mensagens ruins para DLQ e isolar tenants ou partitions quentes.

## Deep Checks

Poison pill, schema incompatível, dependencia externa lenta, partition skew, consumer group rebalance, timeout de ack e custo do replay.

## Exit Criteria

Lag voltando a convergir, DLQ sob controle, replay com plano idempotente, e backlog restante com ETA defensavel.

## Practice Drill

Simule uma fila de cobranca com 6h de lag. Decida: pausar producers, escalar consumers, drenar DLQ, replayar ultimas 2h e validar efeito-once.

## Source Anchor

- [RabbitMQ - Dead Letter Exchanges](https://www.rabbitmq.com/docs/dlx).
- [Confluent - Monitor Consumer Lag](https://docs.confluent.io/platform/current/monitor/monitor-consumer-lag.html).
