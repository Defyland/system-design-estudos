# Dropbox - Nautilus Search

## Why this case matters

Caso muito bom para estudar busca de verdade: indexacao, serving, personalizacao e controle de acesso no resultado.

## Course topics

- busca
- indexacao
- ranking
- latencia
- escalabilidade

## Stack relevance

- Rails: medium
- Elixir: medium
- Go: medium

## Primary sources

- [Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/tech/2018/09/architecture-of-nautilus-the-new-dropbox-search-engine/)

## What to extract

- pipeline de indexacao
- pipeline de serving
- personalizacao por usuario
- impacto de permissoes na arquitetura de busca

## Strong Anchor

Permission-aware search nao e "search + auth depois". ACL muda o proprio plano de retrieval.

## Architecture spine

- indexacao e serving andam separados para escalar e reindexar com rollback
- namespaces entram cedo para cortar o universo de busca antes do ranking
- o serving faz segunda checagem de ACL antes de responder
- rebuild offline convive com mutacoes online para preservar frescor e recuperabilidade

## Failure mode to remember

Cutover de indice que parece rapido e barato, mas vaza snippet, contagem ou documento fora do scope de permissao.

## 3-Minute Drill

- que parte da permissao precisa entrar antes da query?
- qual budget de freshness o produto realmente precisa?
- como voce volta para o indice anterior sem perder o mapa de mutacoes?

## Linked Chapters

- [Chapter 09 - Search Indexing and Permission-Aware Retrieval](../../../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
