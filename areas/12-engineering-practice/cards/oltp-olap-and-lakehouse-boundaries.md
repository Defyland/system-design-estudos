# OLTP, OLAP and Lakehouse Boundaries

## When to Use

Quando o mesmo dado precisa sustentar produto online e analise pesada, e o time ainda tenta resolver tudo no banco transacional.

## What Breaks First

Queries analiticas degradam escrita, warehouse recebe dados tarde demais, ownership do dado canonico vira confuso e ninguem sabe qual camada aceita correcao manual.

## Design Moves

Separe origem transacional de consumo analitico, declare SLA de sincronizacao, evite join pesado no OLTP e defina onde vive a verdade operacional versus a verdade analitica.

## Interview Trap

Chamar warehouse ou lakehouse de "banco maior". A questao central e workload, latencia, mutabilidade e custo de consulta.

## Practice Drill

Mapeie pedidos, pagamentos e cliques de um marketplace em camadas OLTP, stream e warehouse. Defina o que pode esperar minutos e o que nao pode.

## Source Anchor

- [Google Cloud - What is a data warehouse?](https://cloud.google.com/learn/what-is-a-data-warehouse).
- [Databricks - Lakehouse Architecture](https://www.databricks.com/glossary/lakehouse-architecture).
