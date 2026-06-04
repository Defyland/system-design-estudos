# Review Card 08 - Distributed IDs and Ordering Guarantees

## Linked Material

- [Chapter 08](../../chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)
- [Lab 08](../../labs/chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)

## 15-Second Recall

- `Pergunta`: o que um ID distribuido ordenavel te da?
- `Resposta curta`: unicidade sem contador central e uma ordem aproximada util.

## Wrong Turn

- `Resposta ruim`: "Snowflake me da ordem global perfeita".
- `Troque por isto`: clock, worker e concorrencia limitam a garantia; o ganho e rough ordering, nao verdade absoluta.

## 1-Minute Answer

IDs distribuidos entram quando um unico gerador central vira gargalo. Eles ajudam em insert locality e ordenacao aproximada, mas custam coordenacao de `worker_id` e disciplina de clock.

## Transfer Check

- se UUID ou serial ja resolvem, nao compre complexidade so para parecer distribuido
