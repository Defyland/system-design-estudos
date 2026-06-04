# Chapters

Sequencia guiada de leitura por decisao arquitetural, nao por empresa inteira.

## Como pensar um chapter

Cada chapter pega uma fatia de um caso real:
- qual problema existia
- qual caso real ajuda a enxergar o problema grande
- qual decisao foi tomada
- por que nao escolheram outra coisa
- quais topicos do curso explicam essa decisao
- qual experimento pequeno vale fazer

## Piloto inicial

Estes tres chapters validam o metodo do repo:
- [Chapter 02 - Relational Scaling and Operational Discipline](./chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 05 - Idempotent Writes Under Ambiguous Failure](./chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 13 - Critical Checkout Flows and Auth Boundaries](./chapter-13-critical-checkout-flows-and-auth-boundaries.md)

## Cobertura do piloto

- SQL, leitura, escrita, replica e cache:
  - Chapter 02
- retries, idempotencia e mutacoes ambiguas:
  - Chapter 05
- auth, gateway boundary e checkout critico:
  - Chapter 13
