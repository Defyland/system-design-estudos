# Playbook de Implementacao e Experimentos

## Objetivo

Usar implementacoes pequenas para fixar conceitos que vieram dos casos reais.

## Ordem de stack

1. Ruby on Rails
2. Elixir
3. Go

## Regra de escolha

Use Rails como default quando o objetivo for:
- modelar dominio
- experimentar APIs
- testar auth, idempotencia, cache, leitura e escrita
- validar fluxos de negocio

Use Elixir quando o objetivo for:
- concorrencia
- supervision
- realtime
- filas ou workers com forte coordenacao

Use Go quando o objetivo for:
- throughput
- servicos simples e IO-bound
- proxies, gateways, consumers ou utilities de infraestrutura

## Labs do piloto

- [Chapter 02 - Relational Scaling and Operational Discipline](./chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 05 - Idempotent Writes Under Ambiguous Failure](./chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 13 - Critical Checkout Flows and Auth Boundaries](./chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
