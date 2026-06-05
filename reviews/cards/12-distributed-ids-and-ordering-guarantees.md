# Review Card 12 - Distributed IDs and Ordering Guarantees

## Linked Material

- [Chapter 12](../../chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)
- [Lab 12](../../labs/chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)

## 15-Second Recall

- `Pergunta`: o que um ID distribuido ordenavel te da?
- `Resposta curta`: unicidade sem contador central e uma ordem aproximada util.

## Design Pass Recall

- `Requirement`: voce precisa de ordem aproximada entre varios nos ou so unicidade?
- `Delete`: qual exigencia falsa de ordenacao voce cortaria primeiro?
- `Forma mais simples`: UUID ou sequence ate o momento em que throughput e ordenacao justifiquem Snowflake.

## Wrong Turn

- `Resposta ruim`: "Snowflake me da ordem global perfeita".
- `Troque por isto`: clock, worker e concorrencia limitam a garantia; o ganho e rough ordering, nao verdade absoluta.

## 1-Minute Answer

IDs distribuidos entram quando um unico gerador central vira gargalo. Eles ajudam em insert locality e ordenacao aproximada, mas custam coordenacao de `worker_id` e disciplina de clock.

## Production Recall

- `Pergunta`: qual sinal operacional te faz desconfiar do gerador antes do produto reclamar?
- `Resposta curta`: clock skew, fallback estranho e qualquer colisao ou monotonicidade quebrada.

## Wrong Production Move

- `Resposta ruim`: "o throughput do gerador esta alto, entao ele esta bom".
- `Troque por isto`: o problema aqui e confianca de identidade, nao benchmark.

## Transfer Check

- se UUID ou serial ja resolvem, nao compre complexidade so para parecer distribuido
