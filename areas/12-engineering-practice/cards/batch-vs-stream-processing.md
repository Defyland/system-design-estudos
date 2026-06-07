# Batch vs Stream Processing

## When to Use

Quando o time precisa decidir entre processar por janela ou reagir continuamente a eventos.

## What Breaks First

Tudo vira stream sem necessidade, ou tudo fica em batch e chega tarde demais. O custo explode ou o dado perde valor temporal.

## Design Moves

Escolha pela latencia de decisao, corrija event time versus processing time, planeje replay e stateful operators e preserve uma trilha para recomputacao.

## Interview Trap

Responder que stream e sempre mais moderno. Sem necessidade de baixa latencia, batch pode ser mais simples e mais barato.

## Practice Drill

Classifique notificacoes, detecao de fraude, faturamento diario e painel de BI entre batch, stream ou hibrido. Justifique atraso aceitavel e caminho de replay.

## Source Anchor

- [Apache Beam Programming Guide](https://beam.apache.org/documentation/programming-guide/).
- [Apache Flink - Event Time and Watermarks](https://nightlies.apache.org/flink/flink-docs-stable/docs/concepts/time/).
