# Review Card 05 - Ruby on Rails Interview Surface Area

## Linked Material

- [Chapter 05](../../chapters/05-ruby-on-rails-interview-surface-area.md)

## Anchor

- `Problema`: resposta fraca de Rails fica em MVC e gems; resposta forte cruza app, banco, fila e seguranca.
- `Decisao`: estudar as perguntas laterais que mais refletem operacao real.

## Cue Signal

- `Sinal`: quando pedem "como escalar Rails?" e a sua primeira reacao e citar microservicos.

## Case/Bridge Anchor

- `Ponte`: [Postgres Databases](../../../../../areas/09-backend-principles/cards/postgres-databases.md), [Backend Security](../../../../../areas/09-backend-principles/cards/backend-security.md), [Scaling Performance](../../../../../areas/09-backend-principles/cards/scaling-performance.md)
- `Caso real`: [GitHub - Rails and MySQL at Scale](../../../../../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)

## QDSAA Recall

- `Requirement corrigido`: entrevista Rails senior mede query shape, integridade, idempotencia, cache e seguranca.
- `Delete`: resposta de framework sem banco ou operacao.
- `Forma simples`: N+1, constraints, transacao/lock, jobs robustos, cache e SQL injection.

## Trade-off to Remember

- `Custo`: abstrair cedo demais pode esconder o caminho critico.
- `Failure mode`: callback, cache ou job sem fronteira clara vira bug dificil de rastrear.

## Trap

- `Resposta ruim`: "Rails escala com Redis e Sidekiq".
- `Troque por isto`: "Rails escala quando query shape, idempotencia, cache e pool estao corretos antes da infra extra".

## 1-Minute Answer

Rails senior nao e saber MVC. E saber como evitar N+1, onde a integridade realmente mora, como desenhar jobs idempotentes, como cachear sem vazar tenant ou auth e como medir o gargalo antes de escalar a arquitetura.
