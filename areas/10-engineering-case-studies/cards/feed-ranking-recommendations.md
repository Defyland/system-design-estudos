# Feed Ranking and Recommendations

## Case Pattern

Feeds e recomendacoes viram pipeline de decisao: gerar candidatos, buscar features, predizer valor, aplicar regras, diversificar, registrar exposicao e medir impacto. O sistema precisa equilibrar relevancia, frescor, custo e integridade.

## When to Use

- Usuario pode receber mais itens do que consegue consumir.
- Ranking personalizado muda retencao, receita ou seguranca.
- O produto precisa misturar conteudo recente, historico e regras de integridade.
- Experimentos de ranking precisam guardrails fortes.

## What Breaks First

Feature chega atrasada, modelo otimiza metrica local, candidato relevante nao entra no recall, ranking custa demais por request ou feedback loop reforca conteudo ruim.

## Interview Trap

Desenhar fanout/cache e esquecer ranking. Para feed moderno, armazenamento e entrega sao so metade; a outra metade e candidate generation, feature freshness, scoring e metricas.

## Practice Drill

Modele um feed de rede social para 10M usuarios. Defina candidate sources, features online/offline, pre-rank, rank final, diversificacao, cache e evento de exposicao para aprendizado.

## Source Anchor

- Meta, [News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/core-infra/news-feed-ranking/).
- Uber, [Engineering More Reliable Transportation with Machine Learning and AI](https://www.uber.com/us/en/blog/machine-learning/).
- Airbnb, [Chronon - A declarative feature engineering framework](https://medium.com/airbnb-engineering/chronon-a-declarative-feature-engineering-framework-b7b8ce796e04).
- Pinterest Engineering Blog, [Unified Flink Source at Pinterest](https://medium.com/pinterest-engineering/unified-flink-source-at-pinterest-streaming-data-processing-c9d4e89f2ed6).
