# Capstone 01 - B2B SaaS Enterprise Growth

## Pull Chapters

- [Chapter 01 - Pod Isolation and Tenant Routing](../chapters/chapter-01-pod-isolation-and-tenant-routing.md)
- [Chapter 02 - Relational Scaling and Operational Discipline](../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)

## Interview Mode

Seu entrevistador pede: "desenhe um SaaS B2B multi-tenant que cresceu, ganhou um cliente enterprise muito barulhento e agora sofre com dashboard lento, exports pesados e risco de blast radius".

## Work Mode

Seu PO diz: "precisamos manter o cliente grande feliz sem quebrar os menores, e o time nao quer desmontar o monolito agora".

## Oral Route

1. diga por que isso nao pede microservicos de reflexo
2. explique o que fica relacional e o que vai para replica ou cache
3. escolha se ja existe caso para pod isolation ou se ainda cabe isolamento mais simples
4. diga onde export pesado morre: edge, fila, concurrency gate ou todos
5. diga qual metrica faria voce evoluir a arquitetura
6. diga o que Rails resolve hoje e o que Go so ensinaria depois

## Good Answer Sounds Like

- tenant ruidoso e problema de isolamento, nao de hype arquitetural
- replica e cache aliviam leitura antes de podding, se a semantica permitir
- export pesado precisa fairness por tenant e fila separada
- pods entram quando blast radius vira fronteira operacional real

## Trap

- "cliente grande chegou, entao agora e microservico, Kafka e shard para todo lado"
