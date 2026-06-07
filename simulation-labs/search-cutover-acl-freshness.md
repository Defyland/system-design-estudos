# Simulation Lab - Search Cutover / ACL / Freshness

## Scenario

Um indice novo promete mais frescor e melhor recall, mas o sistema ainda precisa respeitar ACL e rollback rapido.

## Controls

- shadow read percentage
- index lag budget
- ACL scope source
- cutover switch

## What Changes

Shadow query e double-read expõem drift de relevancia e permissao antes de voce trocar o caminho oficial.

## Failure Mode

Cutover vaza snippet, contagem ou documento fora do scope certo mesmo quando a latencia parece boa.

## Cost Signal

Double-write, double-read e rebuild paralelo custam CPU, storage e mais disciplina de operacao durante a troca.

## Interview Takeaway

Search cutover falha mais por permissao e rollback ruim do que por benchmark puro.

## Linked Chapters

- [Chapter 09](../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)

## Linked Areas

- [Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)

## Mastery Checks

- `Pergunta`: qual sinal mata um cutover antes da latencia?
- `Resposta com as suas palavras`: qualquer indicio de ACL leak ou scope errado.
- `Resposta ruim que parece boa`: se o indice novo esta mais rapido, o resto e tuning.
- `Troque por isto`: cutover de busca morre primeiro por seguranca e confianca, nao por benchmark bonito.
