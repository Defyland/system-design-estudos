# Simulation Lab - Rate Limit vs Load Shedding

## Scenario

Uma rota cara sofre abuso e, ao mesmo tempo, usuarios legitimos fazem pico normal.

## Controls

- request rate
- backend capacity
- tenant limit
- burst size

## What Changes

Rate limit protege fairness. Load shedding protege sobrevivencia do sistema quando a capacidade ja foi ultrapassada.

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

## Mastery Checks

- `Pergunta`: por que aumentar retry durante overload costuma piorar?
- `Resposta com as suas palavras`: retry aumenta carga justamente quando o sistema ja esta saturado.
- `Resposta ruim que parece boa`: retry ajuda a vencer instabilidade.
- `Troque por isto`: sob overload, reduza entrada ou degrade resposta antes de repetir trabalho.

