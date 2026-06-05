# Simulation Lab - Canary Rollout

## Scenario

Uma nova regra de ranking melhora uma metrica offline, mas pode aumentar latencia e erro.

## Controls

- rollout percent
- new error rate
- new latency
- rollback threshold

## What Changes

Canary pequeno compra aprendizado com blast radius limitado.

## Failure Mode

Metrica errada deixa rollout continuar enquanto usuario real sofre.

## Cost Signal

Dois caminhos vivos aumentam custo cognitivo, mas reduzem risco de dano total.

## Interview Takeaway

Senior nao fala so "deploy". Fala dark launch, canary, hold, rollback e metrica de parada.

## Linked Chapters

- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
- [Chapter 01](../chapters/chapter-01-relational-scaling-and-operational-discipline.md)

## Linked Areas

- [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)

## Mastery Checks

- `Pergunta`: quando voce segura canary em vez de rollback imediato?
- `Resposta com as suas palavras`: quando o dano esta contido e preciso de mais sinal para decidir.
- `Resposta ruim que parece boa`: se teve erro, rollback sempre.
- `Troque por isto`: rollback e para dano claro; hold e para incerteza controlada.

