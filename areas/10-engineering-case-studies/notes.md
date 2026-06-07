# Notes

## Modelo mental

Um case study bom nao e "como empresa X fez Y". Ele e um padrao reutilizavel: pressao real, decisao estrutural, trade-off assumido, mecanismo de protecao e sinal de que a decisao funcionou ou falhou.

## Gaps corrigidos

| Gap | Cobertura adicionada | Conecta com |
| --- | --- | --- |
| migracoes em producao | schema changes, dual write, backfill, validacao sombra | Postgres, graceful shutdown, rollout |
| incident management | detect, assemble, mitigate, review, action items | observabilidade, fault tolerance |
| data engineering | Kafka, Flink, Beam, lineage, freshness | event backbone, feed, ML features |
| experimentacao | feature flags, exposure, guardrails, ramp-up | config management, API contracts |
| platform engineering | scorecards, ownership, dev portal, CI/E2E | DevOps, testing, ownership |
| multi-regiao | RPO/RTO, failover, dependency graph | CDN, database HA, queues |
| privacidade/governanca | data lineage, purpose limitation, runtime enforcement | authz, security, data contracts |
| realtime colaborativo | WebSocket, server authority, conflict model | concurrency, realtime backend |
| search/relevance | shard choice, index lag, reindex | Elasticsearch, permissions |
| feed/recommendations | candidate generation, ranking passes, guardrails | fanout, ranking, data pipelines |
| marketplace/geospatial | forecasting, dispatch, pricing, routing | H3, queues, workflows |
| media delivery | encoding, CDN placement, edge control plane | object storage, CDN, cache invalidation |

## Ordem de uso

1. Se o tema e fundamento de backend, leia `Backend Principles` primeiro.
2. Se o tema e decisao de arquitetura, leia o chapter ou decision contrast correspondente.
3. Depois use estes cards para enxergar o que muda em producao: ownership, rollout, dados, falhas e custo operacional.
4. Feche com o drill do card, sempre reduzindo o caso para um sistema menor.

## QDSAA aplicado

- `Question`: o objetivo nao e arquivar blogs; e transformar historias de producao em padroes que melhoram aprendizado.
- `Delete`: sem copiar artigo inteiro, sem pasta por empresa, sem card por post.
- `Simplify`: um card por padrao recorrente, com anchors para leitura e drill pratico.
- `Accelerate`: cada ciclo de curadoria termina com cards validados e importados no cockpit.
- `Automate Last`: automacao so entra quando o loop manual estabilizar e mostrar quais fontes realmente rendem cards.

## Definicao de pronto para um card

- tem H1 unico;
- explica quando usar;
- mostra o que quebra primeiro;
- tem armadilha de entrevista;
- tem drill pratico;
- tem pelo menos uma fonte primaria em `Source Anchor`;
- nao depende de copiar trechos longos do artigo.
