# Data Pipelines and Stream Processing

## Case Pattern

Pipelines de dados em escala precisam de contrato de evento, schema registry, processamento com estado, replay, monitoramento de lag, lineage e freshness. O valor nao e "usar Kafka"; e transformar eventos em dados confiaveis para produto, ML e operacao.

## When to Use

- O mesmo evento alimenta analytics, ML features, notificacoes, busca ou anti-abuse.
- Batch diario ficou tarde demais para decisao de produto.
- Consumidores precisam replayar historico depois de bug.
- Data freshness virou requisito de usuario ou receita.

## What Breaks First

Schema muda sem compatibilidade, consumidores acumulam lag, jobs duplicam logica, dados chegam tarde, reprocessamento nao e idempotente ou ninguem sabe qual upstream atrasou.

## Interview Trap

Desenhar um topico e varios consumers sem falar de schema, ownership do evento, retention, replay, DLQ, consumer lag, data quality e SLA de freshness.

## Practice Drill

Pegue um evento `OrderPaid`. Defina schema, chave de particao, consumers, retencao, estrategia de replay, metricas de lag e uma regra para quebrar build quando schema deixa de ser compativel.

## Source Anchor

- LinkedIn, [Kafka Ecosystem at LinkedIn](https://www.linkedin.com/blog/engineering/open-source/kafka-ecosystem-at-linkedin).
- LinkedIn, [Revolutionizing Real-Time Streaming Processing: 4 Trillion Events Daily at LinkedIn](https://www.linkedin.com/blog/engineering/data-streaming-processing/revolutionizing-real-time-streaming-processing--4-trillion-event).
- Pinterest, [Unified Flink Source at Pinterest: Streaming Data Processing](https://medium.com/pinterest-engineering/unified-flink-source-at-pinterest-streaming-data-processing-c9d4e89f2ed6).
- Airbnb, [Visualizing data timeliness at Airbnb](https://medium.com/airbnb-engineering/visualizing-data-timeliness-at-airbnb-ee638fdf4710).
