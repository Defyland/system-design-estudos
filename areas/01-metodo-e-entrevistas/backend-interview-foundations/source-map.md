# Source Map

Nao existe dataset publico oficial e confiavel medindo "o que mais cai" em entrevistas backend por stack.

Esta trilha usa triangulacao pragmatica:
- listas e handbooks que concentram problemas recorrentes
- curriculos de estudo que repetem os mesmos patterns
- docs oficiais para a parte que precisa ser tecnicamente precisa

## Signal Sources

- DSA:
  - [Tech Interview Handbook - Algorithms Study Cheatsheet](https://www.techinterviewhandbook.org/algorithms/study-cheatsheet/)
  - [Tech Interview Handbook - Best Practice Questions](https://www.techinterviewhandbook.org/best-practice-questions/)
  - [NeetCode 150](https://neetcode.io/practice)
  - [NeetCode Roadmap](https://neetcode.io/roadmap)
- System design:
  - [System Design Primer](https://github.com/donnemartin/system-design-primer)
  - [Hello Interview - System Design Delivery](https://www.hellointerview.com/learn/system-design/in-a-hurry/delivery)
  - [Hello Interview - How I'd Prepare for System Design Interviews](https://www.hellointerview.com/blog/how-id-prepare)
- Ruby / Rails:
  - [Rails Guides - Active Record Query Interface](https://guides.rubyonrails.org/active_record_querying.html)
  - [Rails Guides - Active Job Basics](https://guides.rubyonrails.org/active_job_basics.html)
  - [Rails Guides - Caching with Rails](https://guides.rubyonrails.org/caching_with_rails.html)
  - [Rails Guides - Active Storage Overview](https://guides.rubyonrails.org/active_storage_overview.html)
  - [Rails Guides - Securing Rails Applications](https://guides.rubyonrails.org/security.html)
  - [Ruby Stdlib - Set](https://docs.ruby-lang.org/en/master/Set.html)
- JavaScript / TypeScript:
  - [MDN - Map](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Map)
  - [MDN - Set](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Set)
  - [MDN - Array.prototype.sort](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array/sort)
  - [TypeScript Handbook - Narrowing](https://www.typescriptlang.org/docs/handbook/2/narrowing.html)

## Mapa por chapter local

| Local | Signal spine | Official anchor | Observacao |
| --- | --- | --- | --- |
| [Chapter 01](./chapters/01-dsa-operating-system-and-pattern-selection.md) | Tech Interview Handbook study cheatsheet, best practice questions, NeetCode roadmap | Ruby Set, MDN Map/Set/sort | pattern selection antes de decorar lista |
| [Chapter 02](./chapters/02-dsa-core-problems-in-ruby-and-typescript.md) | Tech Interview Handbook, NeetCode 150 | Ruby Set, MDN Map/Set/sort, TypeScript narrowing | problemas nucleares + follow-ups que mais se repetem |
| [Chapter 03](./chapters/03-system-design-delivery-framework.md) | System Design Primer, Hello Interview delivery | Rails cache/jobs/security como ponte de implementacao | conduz a conversa antes de escolher stack |
| [Chapter 04](./chapters/04-system-design-canonical-problems.md) | System Design Primer, Hello Interview prep guide | Rails cache, Active Job, Active Storage | 80/20 de perguntas abertas recorrentes |
| [Chapter 05](./chapters/05-ruby-on-rails-interview-surface-area.md) | Ruby / Rails senior question banks, casos reais locais | Rails Guides de query, cache, jobs, security e storage | perguntas laterais que diferenciam senior de CRUD |
| [Chapter 06](./chapters/06-javascript-and-typescript-interview-surface-area.md) | handbooks e signal docs de entrevista | MDN + TypeScript Handbook | evita traps comuns de linguagem e runtime |

## Como usar as fontes

- use `signal spine` para saber o que reaparece com frequencia
- use `official anchor` para responder com precisao tecnica
- quando houver conflito, prefira a doc oficial para semantica e a lista de entrevista para priorizacao

## Drill Pack

Os chapters de DSA agora tem um pacote executavel em `interview/dsa-drills` com:

- suite Ruby para os problemas nucleares
- suite TypeScript para o mesmo conjunto
- comandos unificados via `bundle exec rake drills`
- prompts de pattern selection para treinar a resposta verbal antes do codigo

Isso evita que a trilha fique so em leitura e tambem preserva a superficie de `333` documentos importados no cockpit, porque o codigo executavel fica fora da area sincronizada como Markdown.

## Quality Audit

### Links quebrados

- `internos`: validados por `ruby scripts/validate_curriculum.rb`; sem links locais quebrados na superficie importada desta trilha em `2026-06-30`
- `externos`: permanecem dependentes de terceiros; a trilha usa docs e handbooks estaveis, mas nao faz monitoramento automatico de disponibilidade HTTP

### Duplicacoes

- `chapter 01` e `chapter 02` repetem parte dos mesmos patterns de proposito: o primeiro fixa selecao, o segundo fixa execucao
- `system design canonical problems` e chapters canonicos do repo principal cruzam temas de feed, rate limit e search; isso e reforco deliberado, nao conflito
- `Rails` e `system design` voltam em cache, jobs e idempotencia; a trilha trata isso como ponte entre entrevista e producao

### Gaps

- falta uma pratica explicita de `SQL whiteboard` com plano de indices, `EXPLAIN` e query shape
- falta uma unidade dedicada a `concorrencia` e locking sob contencao real em Ruby ou Postgres
- falta coverage explicita para `topological sort`, `union find` e `trie`, que ainda aparecem em alguns loops de big tech
- falta um drill de `senior communication` focado em custo, rollout, migration e blast radius sob restricao de negocio

### Pontos fracos para entrevista senior

- DSA forte sem narrativa de producao ainda parece perfil de exercicio, nao de ownership
- system design sem custo, rollout e observabilidade tende a soar mid-level
- Rails sem falar de `N+1`, transacao, lock, job idempotente e migration safety nao fecha senior
- TypeScript sem citar runtime traps, event loop e narrowing parece JavaScript com anotacao de tipo

### Next best additions

- adicionar um lab de query tuning com `EXPLAIN` e lock ordering
- adicionar um mock de `20` minutos focado em incident response e rollback
- adicionar um drill de "defenda ou corte este componente" para senioridade arquitetural

## O que nao espelhar

- ranking falso com porcentagens inventadas
- resposta pronta que parece inteligente mas nao defende follow-up
- lista infinita de problemas sem criterio de corte
