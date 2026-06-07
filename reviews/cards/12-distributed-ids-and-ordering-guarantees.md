# Review Card 12 - Distributed IDs and Ordering Guarantees

## Linked Material

- [Chapter 12](../../chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)
- [Lab 12](../../labs/chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)

## Anchor

- `Problema`: um gerador central de IDs esta cobrando throughput ou topologia demais.
- `Decisao`: usar ID distribuido ordenavel para ganhar unicidade sem round-trip central e ainda carregar rough ordering util.

## Cue Signal

- `Sinal`: serial central virou gargalo e UUID puro removeu ordenacao, debuggability ou locality demais.

## Case Anchor

- `Caso real`: [Twitter - Snowflake IDs](../../real-world-cases/02-data-storage-and-search/twitter-snowflake-ids/README.md)
- `Lembrete`: Snowflake compra unicidade e rough ordering; nao compra causalidade nem ordem global perfeita.

## QDSAA Recall

- `Requirement corrigido`: o requisito pode ser unicidade simples, ordem aproximada ou ordem forte; sao coisas diferentes.
- `Delete`: exigencia falsa de ordenacao perfeita quando o produto so precisa de rough ordering.
- `Forma simples`: UUID ou sequence ate o momento em que throughput e ordenacao justifiquem Snowflake.

## Trade-off to Remember

- `Custo`: menos coordenacao central compra mais responsabilidade sobre clock e `worker_id`.
- `Failure mode`: colisao rara, clock rollback ou monotonicidade quebrada minando a confianca do sistema.

## Trap

- `Resposta ruim`: "Snowflake me da ordem global perfeita".
- `Troque por isto`: clock, worker e concorrencia limitam a garantia; o ganho e rough ordering, nao verdade absoluta.

## 1-Minute Answer

IDs distribuidos entram quando um unico gerador central vira gargalo. Eles ajudam em insert locality e ordenacao aproximada, mas custam coordenacao de `worker_id` e disciplina de clock.
