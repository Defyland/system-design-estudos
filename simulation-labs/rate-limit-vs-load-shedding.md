# Simulation Lab - Rate Limit vs Load Shedding

## Scenario

Uma rota cara sofre abuso e, ao mesmo tempo, usuarios legitimos fazem pico normal.

## Controls

- request rate
- backend capacity
- tenant limit
- burst size

## Run It

```bash
rake 'simulate[rate-limit]'                                      # defaults
rake 'simulate[rate-limit]' ARGS="arrival_rps=2000 capacity_rps=1000"
```

Veja, sob `arrival_rps` acima da `capacity_rps`, quanto cada estrategia serve e descarta:
rate limit rejeita por taxa, shedding desce ate a capacidade. Engine: [sim/run.rb](./sim/run.rb).

## What Changes

Rate limit protege fairness. Load shedding protege sobrevivencia do sistema quando a capacidade ja foi ultrapassada.

## Algorithm Lens

- `fixed window`: cap barato e previsivel, bom para abuso obvio, mas deixa burst feio na virada;
- `sliding window` ou `token bucket`: melhores quando trafego legitimo vem em rajadas e voce nao quer punir leitura interativa do mesmo jeito;
- `concurrency gate`: melhor que contagem por minuto quando o dano real mora em jobs, conexoes ou workers presos.

## Failure Mode

Limite por IP pune NAT corporativo e deixa tenant barulhento escapar.

## Cost Signal

Toda request ruim que passa da borda custa CPU, banco ou dependencia externa.

## Interview Takeaway

Rate limit decide quem pode consumir. Load shedding decide o que precisa morrer para o core viver.

## Linked Chapters

- [Chapter 06](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 03](../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)

## Linked Areas

- [Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/README.md)
- [Backend Principles](../areas/09-backend-principles/README.md)

## Build Bridge

- [Rate Limiting Algorithms and Keys](../areas/09-backend-principles/cards/rate-limiting-algorithms-and-keys.md)
- [Build a Ruby Rate Limiter](../areas/13-backend-principle-labs/labs/build-a-ruby-rate-limiter.md)

## Mastery Checks

- `Pergunta`: por que aumentar retry durante overload costuma piorar?
- `Resposta com as suas palavras`: retry aumenta carga justamente quando o sistema ja esta saturado.
- `Resposta ruim que parece boa`: retry ajuda a vencer instabilidade.
- `Troque por isto`: sob overload, reduza entrada ou degrade resposta antes de repetir trabalho.
