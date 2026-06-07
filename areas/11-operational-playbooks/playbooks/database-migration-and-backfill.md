# Database Migration and Backfill

## Trigger

Mudanca de schema, coluna quente, reindex, split de tabela ou migracao de datastore com producao ativa.

## Signals

- lock time aumentando;
- replica lag;
- divergencia entre leitura antiga e nova;
- backfill competindo com trafego online.

## Immediate Actions

- confirmar expand-contract em vez de big bang;
- definir throttle, checkpoints e rollback;
- separar migracao estrutural de backfill;
- declarar metrica de divergencia antes do cutover.

## Stabilize

Reduzir throughput do backfill, pausar batches, manter dual write/read, isolar jobs pesados e impedir cleanup prematuro.

## Deep Checks

Cardinalidade real, skew de chaves, lock amplification, atraso de replicas, custo de reprocessamento e cobertura de validacao sombra.

## Exit Criteria

Novo caminho servindo trafego, divergencia zerada ou dentro do limite, rollback ainda viavel ate o cleanup final, e caminho antigo removido com evidencia.

## Practice Drill

Planeje a migracao de `orders.status` string para tabela normalizada com escrita dupla, backfill paginado, leitura sombra, cutover gradual e cleanup.

## Source Anchor

- [GitHub - gh-ost: GitHub's online schema migration tool for MySQL](https://github.blog/news-insights/company-news/gh-ost-github-s-online-migration-tool-for-mysql/).
- [Prisma - Expand and contract migrations](https://www.prisma.io/dataguide/types/relational/expand-and-contract-pattern).
