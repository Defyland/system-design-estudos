# Review Card 04 - Search Indexing and Permission-Aware Retrieval

## Linked Material

- [Chapter 04](../../chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)
- [Lab 04](../../labs/chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)

## 15-Second Recall

- `Pergunta`: por que busca nao sai direto da tabela transacional?
- `Resposta curta`: porque busca quer texto, recall e latencia; a tabela quer write correto.

## Wrong Turn

- `Resposta ruim`: "indexa por `workspace_id` e a seguranca acabou".
- `Troque por isto`: permissao entra cedo para cortar o universo e entra de novo na saida para blindar a resposta.

## 1-Minute Answer

Busca rica pede indexacao assincrona, scope de ACL antes da query e revalidacao final. Frescor do indice e requisito de produto, nao obsessao abstrata.

## Transfer Check

- para produto menor, `tsvector` ou search gerenciado pode bastar desde que ACL e reindexacao tenham dono claro
