# Review Card 09 - Search Indexing and Permission-Aware Retrieval

## Linked Material

- [Chapter 09](../../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Lab 09](../../labs/chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)

## Anchor

- `Problema`: busca rica quer texto, recall, latencia e ACL; a tabela transacional quer write correto.
- `Decisao`: criar indice derivado, aplicar scope de permissao antes da query e revalidar ACL na saida.

## Case Anchor

- `Caso real`: [Dropbox - Nautilus Search](../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)
- `Lembrete`: permission-aware search nao e "search + auth depois"; ACL muda o plano de retrieval.

## QDSAA Recall

- `Requirement corrigido`: o banco nao precisa ganhar "mais poder"; a experiencia de busca e que mudou.
- `Delete`: campo, boost ou recurso de busca que infla o indice sem melhorar o produto.
- `Forma simples`: indice derivado do banco, com ACL e frescor observados.

## Trade-off to Remember

- `Custo`: indice assincrono compra latencia, mas traz staleness e mais operacao.
- `Failure mode`: ACL leak, snippet errado ou indice velho fazendo o produto parecer quebrado.

## Trap

- `Resposta ruim`: "indexa por `workspace_id` e a seguranca acabou".
- `Troque por isto`: permissao entra cedo para cortar o universo e entra de novo na saida para blindar a resposta.

## 1-Minute Answer

Busca rica pede indexacao assincrona, scope de ACL antes da query e revalidacao final. Frescor do indice e requisito de produto, nao obsessao abstrata.
