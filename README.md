# System Design Estudos

Repositorio de apoio para estudar system design sem inflar a estrutura com pastas de baixo valor.

## Comece Por Aqui

<!-- curriculum:start:readme-start -->
Comece em [Chapter 01 - Relational Scaling and Operational Discipline](chapters/chapter-01-relational-scaling-and-operational-discipline.md).

A trilha canonica vem de `curriculum.yml`. Quando ordem, lab, review, caso ou area mudarem, atualize o manifest e rode:

```bash
ruby scripts/render_curriculum_indexes.rb
ruby scripts/validate_curriculum.rb
```

Se quiser o mapa pedagogico da mesma trilha:
- [Ordem de Estudo](STUDY_ORDER.md)
- [Curriculum manifest](curriculum.yml)
<!-- curriculum:end:readme-start -->

O caminho padrao do repo agora e:
1. comecar em `Chapter 01`
2. rodar o `First Principles Design Pass` dentro do chapter antes da arquitetura final
3. seguir os chapters em ordem numerica
4. fazer o lab e o review card do mesmo chapter
5. a cada 2 chapters, fazer 1 contraste
6. a cada 4 chapters, fazer 1 capstone

## O que ficou

Mantive pasta apenas para blocos que de fato acumulam material:
<!-- curriculum:start:area-list -->
- [01 - Metodo e Entrevistas](areas/01-metodo-e-entrevistas/README.md) (`practice_area`)
- [02 - Dados e Armazenamento](areas/02-dados-e-armazenamento/README.md) (`practice_area`)
- [03 - Filas e Consistencia](areas/03-filas-e-consistencia/README.md) (`practice_area`)
- [04 - Edge, Rede e Acesso](areas/04-edge-rede-e-acesso/README.md) (`practice_area`)
- [05 - Arquitetura e Operacao](areas/05-arquitetura-e-operacao/README.md) (`practice_area`)
- [06 - Foundations Distribuidas](areas/06-foundations-distribuidas/README.md) (`topic_catalog`)
- [07 - Componentes de Sistemas](areas/07-componentes-de-sistemas/README.md) (`component_catalog`)
- [08 - Sistemas de IA](areas/08-sistemas-ia/README.md) (`topic_catalog`)
<!-- curriculum:end:area-list -->

## O que nao virou pasta

Nao criei pastas separadas para:
- introducao e certificado
- topicos puramente definicionais como "o que sao bancos de dados"
- subitens pequenos que fazem mais sentido como secao de uma area maior

Esses itens foram absorvidos nos READMEs das areas, porque nao justificam uma arvore propria.

## Estrutura

- `areas/`: blocos principais de estudo
- cada area declara seu contrato em `curriculum.yml` via `kind` e `content_dirs`
- `simulation-labs/`: simulacoes guiadas para carga, custo, falha e trade-off
- `curriculum.yml`: fonte canonica para o cockpit navegar a trilha
- `assets/ementa/`: imagens da ementa original

## Regra pratica

Se um assunto nao gerar:
- notas densas
- exemplos proprios
- snippets
- comparacoes de trade-off

entao ele nao merece uma pasta propria.

## Materiais de origem

- [Ordem de estudo canonica](./STUDY_ORDER.md)
- [Ementa consolidada](./COURSE_OUTLINE.md)
- [Plano de estudo](./STUDY_PLAN.md)
- [Metodo de estudo orientado por casos reais](./CASE_DRIVEN_STUDY.md)
- [Sequencia guiada em chapters](./chapters/README.md)
- [Playbook de implementacao e experimentos](./labs/README.md)
- [Revisoes espacadas](./reviews/README.md)
- [Contrastes de decisao](./decision-contrasts/README.md)
- [Capstones cumulativos](./capstones/README.md)
- [Simulation labs](./simulation-labs/README.md)
- [Imagem da ementa - pagina 1](./assets/ementa/page-1.png)
- [Imagem da ementa - pagina 2](./assets/ementa/page-2.png)

## Motor de Retencao

O repositorio agora tem tres camadas para nao depender so de leitura:
- [reviews/](./reviews/README.md): revisao espacada em `1, 3, 7, 14, 30` dias
- [decision-contrasts/](./decision-contrasts/README.md): treino para nao confundir opcoes parecidas
- [capstones/](./capstones/README.md): drills orais cumulativos misturando varios chapters

## Casos reais

- [Biblioteca de casos reais pesquisados na internet](./real-world-cases/README.md)
- [Roadmap priorizado de leitura dos casos reais](./real-world-cases/ROADMAP.md)
