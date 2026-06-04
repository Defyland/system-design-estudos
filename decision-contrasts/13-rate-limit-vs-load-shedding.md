# Contrast 13 - Rate Limit vs Load Shedding

## Tension

Os dois cortam trafego, mas um tenta governar entrada e o outro protege recurso ja saturado.

## Use Rate Limit When

- o abuso ou burst pode ser reconhecido cedo
- a decisao depende de rota, IP, token ou tenant
- voce quer evitar que o trabalho caro comece

## Use Load Shedding When

- o recurso ja esta sob saturacao
- a fila, threadpool ou dependencia cara precisa respirar agora
- voce precisa preservar um subconjunto de requests mais valiosas

## Trap

- `Resposta ruim`: "rate limit e suficiente para qualquer overload".
- `Troque por isto`: quando a saturacao ja esta dentro do sistema, shed load fica mais perto do dano do que o bloqueio de borda.

## 15-Second Distinction

Rate limit governa entrada. Load shedding salva recurso ja sufocado.

## Pull Chapters

- [Chapter 10](../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
