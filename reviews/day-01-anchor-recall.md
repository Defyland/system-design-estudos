# Dia 01 - Anchor Recall

## Objetivo

Fixar o par mais importante de cada chapter:
- qual problema apareceu
- qual decisao respondeu a esse problema

## Ordem

Comece pelos cards mais centrais para o repo:
- [Card 01](./cards/01-relational-scaling-and-operational-discipline.md)
- [Card 03](./cards/03-idempotent-writes-under-ambiguous-failure.md)
- [Card 06](./cards/06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Card 07](./cards/07-critical-checkout-flows-and-auth-boundaries.md)

Depois rode o resto:
- [Card 02](./cards/02-pod-isolation-and-tenant-routing.md)
- [Card 08](./cards/08-blob-durability-and-storage-tiers.md)
- [Card 09](./cards/09-search-indexing-and-permission-aware-retrieval.md)
- [Card 04](./cards/04-event-backbone-partitions-and-consumer-scale.md)
- [Card 05](./cards/05-durable-workflows-retries-and-compensation.md)
- [Card 12](./cards/12-distributed-ids-and-ordering-guarantees.md)
- [Card 13](./cards/13-realtime-concurrency-and-workload-isolation.md)
- [Card 10](./cards/10-cdn-placement-dns-and-cache-invalidation.md)
- [Card 11](./cards/11-geospatial-indexing-for-marketplace-search.md)
- [Card 14](./cards/14-feed-ranking-and-fanout-trade-offs.md)

## Mixed Oral Checks

- se o tenant ruidoso machuca todos os outros, qual escolha arquitetural o chapter 02 ensinou?
- se o usuario acabou de salvar e nao pode ver stale read, qual decisao do chapter 01 responde isso?
- se o `POST` pode ser repetido depois de falha ambigua, qual contrato vira o centro do chapter 03?
- se auth, risco e pagamento se encostam, qual boundary o chapter 07 faz nascer?
- se a cronologia falhou no produto, quais duas partes o chapter 14 separa?

## Done When

- voce lembra o problema central de pelo menos `10/14` cards sem olhar
- as respostas ruins ja comecam a soar obviamente erradas
- voce consegue explicar os 4 cards prioritarios em `15 segundos` cada
