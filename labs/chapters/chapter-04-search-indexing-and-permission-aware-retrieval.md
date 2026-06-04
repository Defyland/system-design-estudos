# Lab - Chapter 04

## Chapter

- [Back to Chapter 04](../../chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modelem uma busca de documentos com indexacao assincrona, scope por `workspace_id` ou `namespace_id` e double-check de ACL antes da resposta
- decidam qual SLA de frescor do indice voces aceitariam para esse produto
- digam o que o experimento deve provar sobre permissao, latencia e estrategia de reindexacao

## Gabarito Oral Imediato

- `Resposta curta`: a query ja nasce com scope de permissao, e a resposta ainda passa por uma segunda checagem antes de sair.
- `Resposta curta`: o SLA de frescor so precisa ser tao curto quanto a experiencia do produto exige.
- `Resposta curta`: o experimento precisa provar que a busca nao vaza ACL e que reindexacao tem caminho de rollback.
- `Armadilha`: "basta filtrar permissao depois do top 10". Nao. Isso gasta CPU com coisa proibida e pode vazar pista errada.
