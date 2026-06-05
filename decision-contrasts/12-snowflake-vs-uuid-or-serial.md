# Contrast 12 - Snowflake vs UUID or Serial

## Tension

Todos geram identidade, mas com garantias e custos diferentes.

## Use Snowflake When

- um contador central virou gargalo
- rough ordering ajuda leitura ou storage
- o custo de coordenar `worker_id` vale a pena

## Use UUID or Serial When

- unicidade simples basta
- ordenacao aproximada nao muda quase nada
- voce quer evitar custo de clock e de operacao

## Trap

- `Resposta ruim`: "ID ordenavel e sempre melhor".
- `Troque por isto`: garantia extra so vale quando o produto ou a topologia realmente usam essa garantia.

## 15-Second Distinction

Snowflake compra unicidade distribuida com ordem util. UUID e serial compram simplicidade.

## Pull Chapters

- [Chapter 12](../chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)
