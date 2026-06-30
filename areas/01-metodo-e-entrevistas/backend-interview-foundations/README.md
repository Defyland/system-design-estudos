# Backend Interview Foundations

## Objetivo

Esta trilha paralela existe para cobrir o 80/20 de entrevistas backend sem virar colecao solta de LeetCode, definicao decorada ou arquitetura bonita demais para o problema.

O foco aqui e:
- DSA com pattern selection e resposta verbalizavel
- system design com condução senior da conversa
- perguntas laterais de Ruby on Rails e JavaScript/TypeScript
- gaps de conhecimento que costumam travar gente boa na hora H

## Boundary

- isto e `side track`, nao substitui os `14 chapters` canonicos
- nao existe dataset publico oficial dizendo "o que mais cai"; esta trilha triangula listas recorrentes, handbooks populares e docs oficiais
- aqui o objetivo nao e expor "pensamento interno"; e treinar o raciocinio que voce deve verbalizar em entrevista
- o criterio e `pattern -> trade-off -> follow-up -> resposta curta forte`

## Como estudar

1. leia `1` chapter desta trilha por vez
2. fale em voz alta a resposta curta antes de ler a secao inteira
3. feche com o review card correspondente em [reviews/README.md](./reviews/README.md)
4. para chapters de DSA, resolva `2` problemas no papel ou no editor logo depois
5. para chapters de system design, force um mock de `20-30` minutos com cronometro

Para os chapters de DSA desta trilha, rode tambem o drill pack executavel em:
- `interview/dsa-drills/README.md`
- `bundle exec rake drills:ruby`
- `bundle exec rake drills:typescript`

Use a mesma cadencia do repo principal:
- [Dia 00 - Pre-Sleep Flashcards](../../../reviews/day-00-pre-sleep-flashcards.md)
- [Dia 01 - Anchor Recall](../../../reviews/day-01-anchor-recall.md)
- [Dia 03 - Discrimination Pass](../../../reviews/day-03-discrimination-pass.md)
- [Dia 07 - Transfer Pass](../../../reviews/day-07-transfer-pass.md)
- [Dia 14 - Interview Compression](../../../reviews/day-14-interview-compression.md)
- [Dia 30 - Retention Audit](../../../reviews/day-30-retention-audit.md)

## Ordem

<!-- curriculum:start:backend-interview-foundations-chapters -->
1. [Chapter 01 - DSA Operating System and Pattern Selection](chapters/01-dsa-operating-system-and-pattern-selection.md)
2. [Chapter 02 - DSA Core Problems in Ruby and TypeScript](chapters/02-dsa-core-problems-in-ruby-and-typescript.md)
3. [Chapter 03 - System Design Delivery Framework](chapters/03-system-design-delivery-framework.md)
4. [Chapter 04 - System Design Canonical Problems](chapters/04-system-design-canonical-problems.md)
5. [Chapter 05 - Ruby on Rails Interview Surface Area](chapters/05-ruby-on-rails-interview-surface-area.md)
6. [Chapter 06 - JavaScript and TypeScript Interview Surface Area](chapters/06-javascript-and-typescript-interview-surface-area.md)
<!-- curriculum:end:backend-interview-foundations-chapters -->

## O que entra

- `DSA`: arrays, hash map, sliding window, binary search, DFS/BFS, heap, intervals e DP basico
- `System design`: requisitos, estimativas, APIs, dados, arquitetura high-level, gargalos e trade-offs
- `Rails`: N+1, transacoes, locks, jobs, cache, indices, seguranca e escalabilidade
- `JS/TS`: Map vs Object, Set, sort comparator, Promise concurrency, unions, narrowing e traps do runtime
- `Drills`: pacote executavel Ruby + TypeScript em `interview/dsa-drills`

## O que nao entra

- maratona de `500` problemas
- puzzle raro que quase nunca muda decisao de carreira
- micro-otimizacao sem valor de entrevista
- resposta generica do tipo "usa microservicos, Redis e Kafka" antes de provar necessidade

## Pontes Locais

- `Metodo`: [Interview Checklist](../snippets/system-design-interview-checklist.md), [Senior Production Answer Template](../snippets/senior-production-answer-template.md), [First Principles Design Pass](../snippets/first-principles-design-pass.md)
- `Story bank`: [Ruby / Rails Senior Question Bank](../../../interview/story-bank/03-ruby-rails-senior-question-bank.md), [STAR Tecnico + Q&A](../../../interview/story-bank/01-ruby-rails-backend-story-bank.md)
- `Casos reais`: [GitHub - Rails and MySQL at Scale](../../../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md), [Stripe - Idempotent Payments](../../../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md), [Meta - News Feed Ranking](../../../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md), [Dropbox - Nautilus Search](../../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)

## Source Spine

- [Source Map](./source-map.md)
- sinais de recorrencia: Tech Interview Handbook, NeetCode, System Design Primer e Hello Interview
- anchors de linguagem e framework: Rails Guides, MDN, TypeScript Handbook e Ruby stdlib docs
