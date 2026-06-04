# Contrast 15 - Retry More vs Roll Back

## Tension

Os dois parecem resposta rapida para incidente, mas so um costuma diminuir dano em sistemas ambiguos.

## Use Retry More When

- a operacao e idempotente e a dependencia esta so intermitente
- o backlog esta controlado
- voce sabe que o efeito ainda nao aconteceu

## Use Roll Back When

- a ultima mudanca nova e a principal suspeita
- retry piora pressao em dependencia cara
- existe risco de estado duplicado, inconsistente ou financeiro

## Trap

- `Resposta ruim`: "se esta falhando, insiste mais um pouco".
- `Troque por isto`: retry sem saber o estado real pode transformar incidente pequeno em incidente caro.

## 15-Second Distinction

Retry ajuda quando o contrato continua seguro. Rollback ajuda quando a mudanca nova corrompeu o contrato.

## Pull Chapters

- [Chapter 05](../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 07](../chapters/chapter-07-durable-workflows-retries-and-compensation.md)
- [Chapter 13](../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
