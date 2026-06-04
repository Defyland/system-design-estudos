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

## Production Twist

### Page

Depois de um rollout de replica para leitura e de uma camada nova de cache, o tenant enterprise abre chamado: "os dashboards ficaram rapidos, mas os numeros estao errados". Ao mesmo tempo, o suporte percebe que so um grupo pequeno de tenants reclama. Isso cheira a semantica quebrada, nao a queda generalizada.

### First Dashboard

- replica lag por endpoint critico
- hit ratio, miss ratio e invalidacao do cache novo
- latencia e erro por tenant
- volume de exports por tenant e por fila

### Immediate Mitigation

- volte fluxos sensiveis para leitura no primary
- desligue a chave de cache nova se a invalidacao estiver suspeita
- aplique fairness mais duro nos exports do tenant quente

### Rollback or Hold

Rollback do novo read path se os numeros inconsistentes atingem contratos de negocio. Hold em qualquer conversa sobre podding ou refactor maior ate separar o problema de semantica do problema de topologia.

### What Not to Change Mid-Incident

- nao mova mais tenants "para balancear"
- nao faca flush global de cache
- nao tente trocar banco ou modelo de tenancy no calor do incidente

## Trap

- "cliente grande chegou, entao agora e microservico, Kafka e shard para todo lado"
