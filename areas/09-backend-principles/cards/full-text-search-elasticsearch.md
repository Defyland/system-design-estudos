# Full Text Search and Elasticsearch

## When to Use

Use busca dedicada quando o banco ja nao entrega ranking, tokenizacao, typo tolerance, filtros compostos ou volume de leitura com custo aceitavel.

## What Breaks First

Indice fica stale, permissao vira filtro decorativo, relevancia piora sem metrica e reindex compete com trafego de producao.

## Interview Trap

Tratar Elasticsearch como banco principal. O source of truth continua em outro lugar; o indice e uma projecao buscavel.

## Practice Drill

Desenhe busca de documentos: campos indexados, ACL, atraso aceitavel, fluxo de reindex, fallback se o indice estiver atrasado.

## Source Anchor

- [15. Full text search using Elasticsearch for blazingly fast search](https://www.youtube.com/watch?v=7_sovzAhRSM)
