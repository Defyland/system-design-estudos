# Learning Journal

## Objetivo

Este repositório ensina system design como trilha prática, não como coleção de
notas soltas. Ao final da leitura, o learner deve conseguir:

- explicar por que a trilha canônica mora em `curriculum.yml` e não em vários
  READMEs independentes;
- navegar chapters, reviews, contrasts, capstones e simulation labs como um
  sistema único de retenção;
- distinguir catálogo, prática, caso real e side track;
- apontar quais partes do material ensinam leitura, quais ensinam decisão e
  quais ensinam validação empírica.

## Como ler o repositório primeiro

1. Leia `README.md` para o mapa geral.
2. Leia `curriculum.yml` e `STUDY_ORDER.md`.
3. Leia `chapters/chapter-01-relational-scaling-and-operational-discipline.md`.
4. Leia `reviews/README.md`, `decision-contrasts/README.md` e `capstones/README.md`.
5. Leia `simulation-labs/README.md`.
6. Leia `CASE_DRIVEN_STUDY.md` e `STUDY_PLAN.md`.
7. Leia `docs/decisions.md`.
8. Feche com `scripts/render_curriculum_indexes.rb`,
   `scripts/validate_curriculum.rb` e o `Rakefile`.

## História cronológica resumida

### Fase 1: estrutura compacta e casos reais (`0c31608` a `398b71a`)

- O projeto começou compacto, depois ganhou biblioteca de casos reais, pilot
  chapters, expansão curricular e uma ordem de estudo mais explícita.
- O ensino aqui é claro: a estrutura do material é tratada como produto.

### Fase 2: retenção e julgamento (`d8ddc1f` a `b62c4e2`)

- Retention loops, decision drills e a revisão maior de “produção/senior
  judgment” empurram o repo para além de resumo de conteúdo.
- A leitura deixa de ser passiva e vira sistema de treino.

### Fase 3: currículo como contrato executável (`0dfbef7` a `1f313cb`)

- A parte recente traz contratos de seção, progress tracker, estudo gerado do
  manifest, simulation engine, CI, decision journal, bench de replica lag e o
  empirical pass do Chapter 01.
- O repositório hoje ensina não só design de sistemas, mas também como
  transformar uma trilha de aprendizado em algo verificável.

## Features que mais ensinam

### Manifesto curricular como fonte canônica

- Problema: sem uma fonte única, a trilha se fragmenta em docs que divergem.
- Onde ler:
  `curriculum.yml`,
  `README.md`,
  `STUDY_ORDER.md`,
  `scripts/render_curriculum_indexes.rb`,
  `scripts/validate_curriculum.rb`.
- O que isso ensina:
  curriculum também precisa de source of truth, invariantes e tooling.

### Camadas de retenção e treino

- Problema: leitura sem recuperação ativa dá falsa sensação de domínio.
- Onde ler:
  `reviews/README.md`,
  `decision-contrasts/README.md`,
  `capstones/README.md`,
  `simulation-labs/README.md`.
- O que isso ensina:
  o repo foi desenhado para storage strength, não só fluency.

## O que o histórico não prova

- O histórico mostra um método forte de estudo, mas não prova que todo learner
  terá a mesma curva de retenção.
- Ele mostra tooling e CI, mas não substitui a experiência humana de discutir os
  casos e defender trade-offs oralmente.
- Ele mostra um empirical pass inicial, não um programa completo de benchmarks
  em todos os chapters.

## Perguntas de recuperação

- Qual arquivo é a fonte canônica da trilha e por quê?
- Onde a trilha diferencia revisão espaçada de contraste de decisão?
- Quais partes do repo exigem execução de script para permanecerem íntegras?
