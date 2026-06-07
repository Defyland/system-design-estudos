# Review Card 14 - Feed Ranking and Fanout Trade-offs

## Linked Material

- [Chapter 14](../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
- [Lab 14](../../labs/chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Anchor

- `Problema`: cronologia pura parou de gastar bem a atencao do usuario.
- `Decisao`: separar inventario candidato, custo de fanout e ordenacao final, em vez de fingir que tudo e uma lista.

## Cue Signal

- `Sinal`: ou o fanout de celebridade explode, ou o ranking precisa decidir tarde demais para caber no modelo atual.

## Case Anchor

- `Caso real`: [Meta - News Feed Ranking](../../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)
- `Lembrete`: feed maduro nao e lista ordenada; e inventario candidato + ranking + guardrails sob budget.

## QDSAA Recall

- `Requirement corrigido`: antes de ranking, o produto precisa provar que cronologia pura ja falhou.
- `Delete`: fonte de candidato ou sinal caro que nao muda relevancia real.
- `Forma simples`: inventario candidato enxuto com ranking leve antes de pipeline pesado.

## Trade-off to Remember

- `Custo`: relevancia extra compra mais compute, mais estado e mais opacidade.
- `Failure mode`: experimento melhora metrica local e piora qualidade real do feed, ou high-fanout explode custo.

## Trap

- `Resposta ruim`: "fanout-on-write para todo mundo resolve feed".
- `Troque por isto`: fanout ajuda inventario; ranking e frescor ainda decidem o que sobe.

## 1-Minute Answer

Feed maduro separa inventario candidato, custo de fanout e ordenacao final. Ranking so vale o aluguel quando existe metrica real de produto para melhorar.
