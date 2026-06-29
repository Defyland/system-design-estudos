# Learning Journal

Este journal documenta a história do repositório até o commit `1ec148a`, que é o
`HEAD` gravado no momento desta edição.

## Como este journal usa evidências

- Base primária:
  `git log`, `README.md`, `curriculum.yml`, `STUDY_ORDER.md`, `STUDY_PLAN.md`,
  `CASE_DRIVEN_STUDY.md`, `docs/decisions.md` e os scripts em `scripts/`.

- Quando o texto fala de “currículo como contrato executável”:
  a afirmação se apoia na existência do manifest, dos renderers/validators e dos
  commits que amarram conteúdo à estrutura.

## O que o histórico não prova

- O histórico não prova que toda pessoa aprenderá no mesmo ritmo.
- Não prova que o material já cobre todos os casos reais importantes.
- Não prova que todos os chapters já têm validação empírica profunda.

## 1. Objetivo do projeto

Este repositório existe para ensinar system design como sistema de estudo, não
como pasta de notas. O que ele quer tornar explícito é:

- a trilha canônica mora num manifest;
- retenção exige loops, contrasts e capstones;
- chapter, case study e simulation lab têm papeis diferentes;
- tooling e CI também fazem parte da qualidade pedagógica.

Ao terminar este journal, o leitor deve conseguir:

- explicar por que `curriculum.yml` é a source of truth;
- seguir a relação entre chapter, review, contrast, capstone e simulation lab;
- apontar onde o repo ensina decisão e onde ensina verificação empírica;
- reconstruir as principais viradas do material.

## 2. Como ler o repositório primeiro, em ordem de aprendizado

1. Leia `README.md`.
2. Leia `curriculum.yml`.
3. Leia `STUDY_ORDER.md` e `STUDY_PLAN.md`.
4. Leia `chapters/chapter-01-relational-scaling-and-operational-discipline.md`.
5. Leia `reviews/README.md`, `decision-contrasts/README.md` e `capstones/README.md`.
6. Leia `simulation-labs/README.md`.
7. Leia `docs/decisions.md`.
8. Feche com `scripts/render_curriculum_indexes.rb`,
   `scripts/validate_curriculum.rb` e `Rakefile`.

## 3. História cronológica da implementação

### Fase 1: estrutura compacta, casos reais e chapters (`0c31608` a `398b71a`, 2026-06-04 a 2026-06-05)

- O projeto começou compacto e rapidamente ganhou biblioteca de casos reais,
  pilot chapters, expansão curricular, retention loops e explicit study order.
- A primeira lição é forte: a estrutura de estudo é tratada como produto.

### Fase 2: manifest canônico, catálogos e side tracks (`11566d2` a `4ffff95`, 2026-06-05 a 2026-06-07)

- O currículo deixa de ser coleção de READMEs e vira sistema centrado em
  `curriculum.yml`.
- Entram backend/engineering catalogs, practice/lab contracts, review cards
  recall-first e a trilha lateral de LLM foundations.

### Fase 3: currículo verificável por tooling (`fb5a6aa` a `1ec148a`, 2026-06-10 a 2026-06-12)

- UTF-8 fix global, pin de Ruby 3.4.9, wiring de distributed foundations,
  anchor validation, section contracts, progress tracker, STUDY_PLAN gerado,
  simulation engine, CI, decision journal, replica-lag bench, empirical pass e
  patterns de arquitetura inspirados em Fowler.
- O repositório agora ensina também como transformar material de estudo em
  sistema verificável.

## Features importantes como unidades completas

### `curriculum.yml` como source of truth

- Problema que resolve:
  sem um manifest central, a trilha se fragmenta em documentos que divergem.

- Commits principais:
  `11566d2`, `0dfbef7`, `a2cd87f`, `2127137`.

- Arquivos principais:
  `curriculum.yml`,
  `scripts/render_curriculum_indexes.rb`,
  `scripts/validate_curriculum.rb`,
  `README.md`.

- O que isso ensina:
  currículo também precisa de contrato, render e validação.

### Loops de retenção e treino

- Problema que resolve:
  leitura linear não constrói storage strength.

- Commits principais:
  `d8ddc1f`, `1838cbe`, `31286f8`, `5f3f68e`, `5ad0462`.

- Arquivos principais:
  `reviews/README.md`,
  `decision-contrasts/README.md`,
  `capstones/README.md`,
  `simulation-labs/README.md`.

- Prós:
  o repo deixa de ser biblioteca passiva.

- Contras:
  cresce a quantidade de superfície pedagógica para manter.

### Empirical pass e measurement labs

- Problema que resolve:
  system design sem medição corre o risco de virar retórica.

- Commits principais:
  `299a770`, `1f313cb`.

- Arquivos principais:
  `bench/replica-lag/README.md`,
  chapters e simulation labs ligados ao tema.

## 4. Decisão por decisão

- Manifesto curricular central:
  escolhido para reduzir deriva.

- Catálogos separados por função:
  escolhidos para diferenciar prática, referência e caso real.

- Simulation engine restrito aos labs numéricos:
  escolhido para não fingir automação onde o material ainda é procedural.

- CI para validar currículo:
  escolhido porque material pedagógico também pode quebrar.

## 5. Prós e contras das escolhas principais

- Manifest canônico:
  pró: consistência.
  contra: maior custo de tooling.

- Retention loops explícitos:
  pró: aprendizado mais durável.
  contra: mais manutenção editorial.

- Empirical pass:
  pró: aproxima teoria de medida.
  contra: só cobre parte do currículo por enquanto.

## 6. Erros, correções e endurecimentos

- O histórico mostra que encoding, anchors e contracts de seção precisaram de
  tooling explícito para não depender do ambiente do autor.
- O material foi ficando menos “coleção de markdowns” e mais “currículo com
  invariantes”.

## 7. Como os testes e checks foram usados

- Via scripts e CI, não via suíte de app web.
- O equivalente aqui a “testes de produto” são renderers, validators, contracts
  e a checagem automática do material derivado.

## 8. Timeline dos commits atômicos

| Commit | Pergunta que o commit responde | Mudança principal |
| --- | --- | --- |
| `0c31608` | Como começar sem inflar a árvore? | estrutura compacta |
| `9f49a36` | Como trazer realidade? | biblioteca de casos |
| `bd8df66` | Como iniciar os chapters? | pilot chapters |
| `62ba543` | Como expandir a trilha? | chapter curriculum |
| `d8ddc1f` | Como reter melhor? | loops e drills |
| `3d66fda` | Como elevar o material? | production-senior judgment |
| `b62c4e2` | Como ordenar o estudo? | explicit study order |
| `398b71a` | Como ampliar o currículo? | expansão case-driven |
| `11566d2` | Onde mora a verdade da trilha? | manifest canonical |
| `affef7f` | Como cobrir backend/engineering? | new catalogs |
| `409a4a9` | Como estruturar prática/labs? | catalog contracts |
| `cd6cb6d` | Como abrir trilha lateral? | LLM foundations |
| `fb5a6aa` | Como evitar locale bugs? | UTF-8 script fix |
| `de6a0b2` | Como alinhar toolchain? | Ruby 3.4.9 + Bundler/Rake |
| `13cb414` | Como validar docs? | markdown anchors |
| `0dfbef7` | Como formalizar sections? | section contracts |
| `5f3f68e` | Como rastrear retenção? | progress tracker |
| `a2cd87f` | Como gerar plano? | STUDY_PLAN from manifest |
| `5ad0462` | Como simular numericamente? | simulation engine |
| `2127137` | Como proteger tudo isso? | CI |
| `79822bb` | Como registrar decisões? | decisions journal |
| `299a770` | Como medir replica lag? | bench |
| `1f313cb` | Como ligar chapter à empiria? | empirical pass |
| `1ec148a` | Como aprofundar padrões? | Fowler-inspired architecture patterns |

## 9. Perguntas de recuperação

- Qual arquivo é a fonte canônica do currículo e por quê?
- Onde o repo diferencia leitura de treino?
- O que muda quando um chapter ganha empirical pass?

## 10. Comandos de terminal que um specialist usaria aqui

```bash
git log --oneline --reverse
ruby scripts/render_curriculum_indexes.rb
ruby scripts/validate_curriculum.rb
rake
```

## 11. Como adicionar a próxima feature sem quebrar a aula

Se a próxima feature for um novo chapter ou side track:

1. registre no `curriculum.yml`;
2. defina o papel pedagógico do material;
3. atualize os índices derivados;
4. valide anchors e contracts;
5. só depois refine README e Study Plan.

## 12. Limites de produção deixados de propósito

- não tenta virar LMS completo;
- não promete medir empiricamente todos os chapters;
- mantém foco em learnability, retenção e integridade da trilha.

## 2026-06-29 - Guia visual dos 10 conceitos de backend

- O artigo "10 Backend Concepts Every Developer Must Know" foi tratado como lista de topicos, nao como texto a copiar.
- A integracao escolhida foi um guia visual em `areas/09-backend-principles/cards/ten-backend-concepts-visual-field-guide.md` e um lab ativo em `areas/13-backend-principle-labs/labs/map-a-backend-request-path.md`.
- O guia conecta cada conceito a pelo menos uma fronteira de sistema, falha comum, pergunta de entrevista, exemplo backend e material ja existente no curriculo.
- O lab força transferencia: desenhar o request path, preencher `conceito -> boundary -> decisao -> falha -> sinal` e rodar simuladores quando o tema pedir numero.
- O cockpit nao precisou de codigo novo porque `backend_principle` e `backend_lab` ja sao content kinds importados; o README do cockpit foi ajustado para documentar essa superficie.

## 2026-06-29 - Portfolio evidence map

- `areas/12-engineering-practice/cards/backend-portfolio-evidence-map.md` agora conecta conceitos estudados a repos locais, arquivo de evidencia exato e comando curto de verificacao.
- A descoberta fica no fluxo normal do repo: o card entrou no catalogo de `Engineering Practice` e ganhou um ponteiro curto no `README.md` raiz.
- As ancoras priorizam repos ja prontos para review (`tracebridge`, `settleflow`, `trustvault`, `ferrisledger`, `active_record_optimizer`); as excecoes declaradas sao CAP em `system-design-estudos` e Kubernetes em `kubepulse-go-operator`.
