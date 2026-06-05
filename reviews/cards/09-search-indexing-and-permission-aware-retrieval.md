# Review Card 09 - Search Indexing and Permission-Aware Retrieval

## Linked Material

- [Chapter 09](../../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Lab 09](../../labs/chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)

## 15-Second Recall

- `Pergunta`: por que busca nao sai direto da tabela transacional?
- `Resposta curta`: porque busca quer texto, recall e latencia; a tabela quer write correto.

## Design Pass Recall

- `Requirement`: qual parte da experiencia de busca o banco ja nao entrega mais?
- `Delete`: qual campo ou recurso de busca voce removeria primeiro do indice?
- `Forma mais simples`: indice derivado do banco, com ACL e frescor observados.

## Wrong Turn

- `Resposta ruim`: "indexa por `workspace_id` e a seguranca acabou".
- `Troque por isto`: permissao entra cedo para cortar o universo e entra de novo na saida para blindar a resposta.

## 1-Minute Answer

Busca rica pede indexacao assincrona, scope de ACL antes da query e revalidacao final. Frescor do indice e requisito de produto, nao obsessao abstrata.

## Production Recall

- `Pergunta`: qual metrica voce abre antes de tunar latencia?
- `Resposta curta`: index lag e qualquer sinal de ACL error ou resultado indevido.

## Wrong Production Move

- `Resposta ruim`: "reindexa tudo e depois ve a permissao".
- `Troque por isto`: primeiro contenha vazamento ou fallback; depois voce arruma a esteira.

## Transfer Check

- para produto menor, `tsvector` ou search gerenciado pode bastar desde que ACL e reindexacao tenham dono claro
