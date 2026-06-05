# Smaller SaaS Architecture Evolution

## Cenario

Uma empresa pequena vende um SaaS de suporte com:
- app web unico
- jobs de notificacao
- dashboard interno
- integracao com email e ERP

No inicio, um monolito Rails resolve tudo. Depois surgem tres dores:
- um cliente muito maior que os outros
- jobs longos demais para retry cego
- picos de trafego pressionando endpoints publicos

## Evolucao boa

1. monolito modular primeiro
   - boundaries internos claros
2. isolamento de dados ou tenant quando blast radius justificar
3. workflow mais explicito para fluxos longos
4. protecao na borda para abuso e overload
5. runtime ou servico especializado so no hotspot certo

## Evolucao ruim

- 6 microservicos antes de 6 boundaries claros
- gateway virando cerebro do produto
- fila simples segurando workflow longo por teimosia
- migracao de linguagem antes de medir o gargalo

## Chapters ligados

- [Chapter 02 - Pod Isolation and Tenant Routing](../../../chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 05 - Durable Workflows, Retries and Compensation](../../../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Chapter 13 - Realtime Concurrency and Workload Isolation](../../../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](../../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
