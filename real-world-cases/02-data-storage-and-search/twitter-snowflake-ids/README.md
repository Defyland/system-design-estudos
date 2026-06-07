# Twitter - Snowflake IDs

## Why this case matters

E o caso classico de sequencer real: IDs ordenaveis, distribuidos e praticos para sistemas de alto throughput.

## Course topics

- sequencer
- ordenacao temporal
- IDs distribuidos
- escalabilidade

## Stack relevance

- Rails: high
- Elixir: high
- Go: high

## Primary sources

- [Announcing Snowflake](https://blog.x.com/engineering/en_us/a/2010/announcing-snowflake.html)

## What to extract

- por que UUID puro nao resolve todos os casos
- por que rough ordering importa
- composicao de um ID distribuido
- limites operacionais de clock e machine IDs

## Strong Anchor

Snowflake-like ID compra throughput e rough ordering. Nao compra causalidade nem verdade absoluta de tempo.

## Architecture spine

- timestamp carrega proximidade temporal util
- worker id desambiguar emissores sem round-trip central
- sequence local suporta burst no mesmo intervalo
- operacao precisa de politica clara para clock rollback e colisao de worker

## Failure mode to remember

Colisao rara de worker id ou clock drift parecem pequenos, mas envenenam a identidade do sistema inteiro.

## 3-Minute Drill

- qual garantia realmente paga o custo aqui: unicidade, ordem aproximada ou ordem forte?
- como o worker id e alocado e auditado?
- o que acontece se um no voltar no tempo?

## Linked Chapters

- [Chapter 12 - Distributed IDs and Ordering Guarantees](../../../chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)
