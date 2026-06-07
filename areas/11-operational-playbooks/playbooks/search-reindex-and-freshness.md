# Search Reindex and Freshness

## Trigger

Busca com documentos faltando, relevancia degradada, mudanca de schema do indice ou necessidade de reindex sem parar escrita.

## Signals

- freshness acima do SLA;
- fila de indexacao acumulando;
- bulk errors;
- diferenca entre banco canonico e indice.

## Immediate Actions

- congelar mudancas de mapping nao urgentes;
- medir backlog de indexacao e query impactada;
- separar problema de ingestion de problema de query;
- decidir se o indice atual continua servindo leitura durante o reindex.

## Stabilize

Diminuir throughput de reindex, reter eventos para replay, usar alias para cutover reversivel e limitar queries mais caras enquanto o indice converge.

## Deep Checks

Permission drift, shard skew, refresh interval, dependencias de enrichment, custo de rebuild completo e validação amostral entre fonte canonica e indice.

## Exit Criteria

Indice novo ou recuperado com freshness dentro do alvo, query principal estavel, plano de rollback claro e divergencia residual conhecida.

## Practice Drill

Planeje um reindex para busca de mensagens com schema novo de permissoes. Inclua alias, replay, sample validation, freshness target e rollback.

## Source Anchor

- [Elastic - Reindex API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-reindex.html).
- [Discord - How Discord Indexes Trillions of Messages](https://discord.com/blog/how-discord-indexes-trillions-of-messages).
