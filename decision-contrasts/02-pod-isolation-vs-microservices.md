# Contrast 02 - Pod Isolation vs Microservices

## Tension

Os dois podem aparecer quando o sistema cresceu, mas a dor que aciona cada um nao e a mesma.

## Use Pod Isolation When

- tenant ruidoso ja virou problema de blast radius
- o dominio ainda cabe em monolito
- o dado e a operacao pedem cerca antes da funcionalidade pedir servicos

## Use Microservices When

- existe boundary funcional forte
- ownership, deploy ou risco regulatorio ja pedem independencia
- o custo de acoplamento funcional ficou maior que o de distribuicao

## Trap

- `Resposta ruim`: "um cliente grande chegou, entao agora viramos microservicos".
- `Troque por isto`: tenant barulhento pede isolamento operacional; servico extraido pede boundary de dominio de verdade.

## 15-Second Distinction

Pod isola por tenant. Microservice separa por capacidade ou dominio.

## Pull Chapters

- [Chapter 01](../chapters/chapter-01-pod-isolation-and-tenant-routing.md)
- [Chapter 02](../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
