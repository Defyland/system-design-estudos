# Contrast 14 - Canary vs Big-Bang Rollout

## Tension

Os dois colocam mudanca em producao, mas so um compra informacao antes de comprar dano.

## Use Canary When

- a mudanca toca caminho critico
- existe metrica observavel para validar
- rollback segmentado e possivel

## Use Big-Bang Rollout When

- a mudanca e realmente pequena e facilmente reversivel
- nao existe forma sensata de segmentar
- o custo de manter dois caminhos e maior que o risco

## Trap

- `Resposta ruim`: "canary sempre e melhor".
- `Troque por isto`: canary ruim tambem existe; se voce nao consegue medir ou segmentar, ele vira teatro.

## 15-Second Distinction

Canary compra aprendizado gradual. Big-bang compra simplicidade e risco concentrado.

## Pull Chapters

- [Chapter 01](../chapters/chapter-01-relational-scaling-and-operational-discipline.md)
- [Chapter 06](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
