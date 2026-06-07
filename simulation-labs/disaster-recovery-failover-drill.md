# Simulation Lab - Disaster Recovery / Failover Drill

## Scenario

Uma regiao principal caiu e o servico precisa decidir quais writes podem continuar, quais dados podem atrasar e como evitar split-brain.

## Controls

- replication mode
- DNS TTL
- write policy after failover
- derived data recovery

## What Changes

Standby quente e TTL menor reduzem RTO, mas aumentam custo fixo e superficie de erro operacional.

## Failure Mode

Banco faz failover, mas fila, busca, cache ou blob nao acompanham, e o sistema cria duas verdades parciais.

## Cost Signal

DR serio cobra capacidade ociosa, drills repetidos, verificacao de consistencia e clareza sobre RPO por componente.

## Interview Takeaway

Failover nao e so "trocar endpoint". E declarar que parte do sistema pode degradar sem mentir sobre perda e ordem.

## Linked Chapters

- [Chapter 05](../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Chapter 08](../chapters/chapter-08-blob-durability-and-storage-tiers.md)
- [Chapter 10](../chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)

## Linked Areas

- [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)

## Mastery Checks

- `Pergunta`: qual pergunta vem antes de apertar failover?
- `Resposta com as suas palavras`: que perda de dados e que degradacao de write o produto aceita agora.
- `Resposta ruim que parece boa`: caiu a regiao, entao promote tudo e depois ve o resto.
- `Troque por isto`: DR sem RTO, RPO e dependencias declaradas vira loteria operacional.
