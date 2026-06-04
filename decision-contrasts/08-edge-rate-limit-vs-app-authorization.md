# Contrast 08 - Edge Rate Limit vs App Authorization

## Tension

Os dois barram request, mas em camadas e por razoes bem diferentes.

## Use Edge Rate Limit When

- o abuso e barato de reconhecer cedo
- brute force, scraping ou burst bruto precisam morrer antes da origem
- o custo principal e CPU, conexao ou dependencia externa

## Use App Authorization When

- a decisao depende de estado de dominio
- ownership, tenant, pedido ou contrato mudam a permissao
- a semantica da mutacao precisa ser conhecida

## Trap

- `Resposta ruim`: "se o gateway autenticou, a app nao precisa decidir mais nada".
- `Troque por isto`: gateway governa entrada; autorizacao fina continua perto do dominio.

## 15-Second Distinction

Edge bloqueia barato. App decide sentido de negocio.

## Pull Chapters

- [Chapter 10](../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 13](../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
