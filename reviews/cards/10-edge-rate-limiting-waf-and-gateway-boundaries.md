# Review Card 10 - Edge Rate Limiting, WAF and Gateway Boundaries

## Linked Material

- [Chapter 10](../../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Lab 10](../../labs/chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)

## 15-Second Recall

- `Pergunta`: o que deve morrer antes da app?
- `Resposta curta`: trafego obviamente abusivo, invalido ou caro demais para ganhar CPU da origem.

## Wrong Turn

- `Resposta ruim`: "o gateway decide toda a autorizacao do sistema".
- `Troque por isto`: edge e gateway governam a entrada; a app ainda decide semantica e permissao fina.

## 1-Minute Answer

O desenho bom divide responsabilidade: edge bloqueia barato, gateway governa auth tecnica e roteamento, app protege regra de negocio e recursos caros recebem fairness mais perto do dano.

## Transfer Check

- limite por IP quase nunca conta a historia inteira em produto B2B ou multi-tenant
