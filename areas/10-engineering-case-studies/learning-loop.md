# Learning Loop

## Objetivo

Manter o projeto vivo sem virar backlog infinito de links. O loop busca dados relevantes, detecta gaps contra o curriculo atual e adiciona somente conhecimento que vira pratica estudavel.

## Ciclo

1. `Question`: escolher 1 objetivo de estudo por ciclo, por exemplo "migracoes sem downtime" ou "experimentos com guardrails".
2. `Source Intake`: coletar ate 12 candidatos de fontes primarias, priorizando blogs oficiais e posts com arquitetura, falha, metrica ou migracao real.
3. `Gap Scan`: classificar cada candidato contra `chapters`, `Backend Principles`, `decision-contrasts`, `simulation-labs` e esta area.
4. `Delete`: descartar artigo que e marketing, opiniao sem mecanismo, duplicado de card existente ou dependente demais de produto interno.
5. `Simplify`: converter sobreviventes em no maximo 3 cards novos ou atualizacoes pequenas em cards existentes.
6. `Validate`: rodar render, check, validador do curriculo e testes de importacao do cockpit.
7. `Review`: registrar quais gaps ficaram e qual sera o proximo objetivo.

## Pontos de finalizacao

Um ciclo termina quando todos estes pontos forem verdadeiros:

- pelo menos 8 fontes candidatas foram avaliadas ou nao ha mais fonte primaria relevante para o objetivo;
- nenhum candidato restante tem impacto claro em entrevista, implementacao ou operacao;
- todo card novo tem `Source Anchor`, `Practice Drill` e link local sem quebra;
- `ruby scripts/render_curriculum_indexes.rb --check` passa;
- `ruby scripts/validate_curriculum.rb` passa;
- os testes focados do cockpit para `ContentKind` e `Content::Importer` passam;
- foi registrado um proximo gap ou a decisao explicita de encerrar o tema.

## Limites por ciclo

- Maximo de 3 cards novos por tema especifico.
- Maximo de 90 minutos de pesquisa antes de converter em material.
- Maximo de 2 fontes por empresa no mesmo ciclo, salvo quando o tema exigir continuidade de uma serie.
- Se dois ciclos seguidos nao adicionarem card nem atualizacao, o tema entra como coberto por enquanto.

## Backlog inicial

- Migracoes sem downtime e backfills.
- Incident response e SLO.
- Data freshness, lineage e stream processing.
- Experimentacao com guardrails.
- Platform engineering e scorecards.
- Privacidade como infraestrutura.
- Search/relevance em escala.
- Realtime colaborativo.
- Marketplace/geospatial.
- Media delivery e edge.
