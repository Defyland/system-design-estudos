# Simulation Lab - Search Freshness / Reindex

## Scenario

Busca de documentos precisa respeitar ACL. O indice esta atrasado e alguns resultados aparecem inconsistentes.

## Controls

- indexing lag
- reindex throughput
- ACL filter position
- query rate

## What Changes

Scope de permissao cedo reduz vazamento e desperdicio.

## Failure Mode

ACL depois do top N deixa resultado proibido influenciar ranking, contagem ou snippet.

## Cost Signal

Frescor agressivo aumenta custo de ingestao e reindex.

## Interview Takeaway

Busca segura nao e so relevancia; permissao muda o plano de execucao.

## Linked Chapters

- [Chapter 09](../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)

## Linked Areas

- [Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)

## Mastery Checks

- `Pergunta`: qual SLA de frescor voce promete?
- `Resposta com as suas palavras`: so o necessario para a experiencia do produto, nao perfeicao abstrata.
- `Resposta ruim que parece boa`: indice deve ser sempre instantaneo.
- `Troque por isto`: frescor custa; prometa o que importa ao usuario.

