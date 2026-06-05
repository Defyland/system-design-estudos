# Review Card 14 - Feed Ranking and Fanout Trade-offs

## Linked Material

- [Chapter 14](../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
- [Lab 14](../../labs/chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## 15-Second Recall

- `Pergunta`: quando cronologia pura deixa de bastar?
- `Resposta curta`: quando o produto precisa gastar melhor a atencao do usuario, nao so mostrar o mais novo.

## Design Pass Recall

- `Requirement`: a cronologia ja falhou ou o ranking ainda e precoce?
- `Delete`: qual fonte de candidato ou sinal caro voce eliminaria primeiro?
- `Forma mais simples`: inventario candidato enxuto com ranking leve antes de pipeline pesado.

## Wrong Turn

- `Resposta ruim`: "fanout-on-write para todo mundo resolve feed".
- `Troque por isto`: fanout ajuda inventario; ranking e frescor ainda decidem o que sobe.

## 1-Minute Answer

Feed maduro separa inventario candidato, custo de fanout e ordenacao final. Ranking so vale o aluguel quando existe metrica real de produto para melhorar.

## Production Recall

- `Pergunta`: qual dado mostra feed ruim sem precisar de erro 500?
- `Resposta curta`: latencia do feed junto com a metrica de qualidade que o produto realmente usa.

## Wrong Production Move

- `Resposta ruim`: "se a pagina abre, o rollout do ranker esta ok".
- `Troque por isto`: em feed, regressao de qualidade e frescor tambem e incidente de producao.

## Transfer Check

- se ninguem sabe qual metrica de relevancia quer mexer, talvez o problema ainda seja ordenacao temporal boa
