# System Design Estudos

Repositorio de apoio para estudar system design sem inflar a estrutura com pastas de baixo valor.

## O que ficou

Mantive pasta apenas para blocos que de fato acumulam material:
- [01 - Metodo e Entrevistas](./areas/01-metodo-e-entrevistas/README.md)
- [02 - Dados e Armazenamento](./areas/02-dados-e-armazenamento/README.md)
- [03 - Filas e Consistencia](./areas/03-filas-e-consistencia/README.md)
- [04 - Edge, Rede e Acesso](./areas/04-edge-rede-e-acesso/README.md)
- [05 - Arquitetura e Operacao](./areas/05-arquitetura-e-operacao/README.md)

## O que nao virou pasta

Nao criei pastas separadas para:
- introducao e certificado
- topicos puramente definicionais como "o que sao bancos de dados"
- subitens pequenos que fazem mais sentido como secao de uma area maior

Esses itens foram absorvidos nos READMEs das areas, porque nao justificam uma arvore propria.

## Estrutura

- `areas/`: blocos principais de estudo
- cada area tem `README.md`, `notes.md`, `examples/` e `snippets/`
- `assets/ementa/`: imagens da ementa original

## Regra pratica

Se um assunto nao gerar:
- notas densas
- exemplos proprios
- snippets
- comparacoes de trade-off

entao ele nao merece uma pasta propria.

## Materiais de origem

- [Ementa consolidada](./COURSE_OUTLINE.md)
- [Plano de estudo](./STUDY_PLAN.md)
- [Metodo de estudo orientado por casos reais](./CASE_DRIVEN_STUDY.md)
- [Sequencia guiada em chapters](./chapters/README.md)
- [Playbook de implementacao e experimentos](./labs/README.md)
- [Revisoes espacadas](./reviews/README.md)
- [Contrastes de decisao](./decision-contrasts/README.md)
- [Capstones cumulativos](./capstones/README.md)
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
