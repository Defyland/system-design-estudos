# Simulation Lab - Noisy Neighbor / Workload Isolation

## Scenario

Um tenant, room ou export batch domina os recursos compartilhados e comeca a piorar a experiencia dos vizinhos.

## Controls

- fairness identity
- per-tenant quota
- dedicated queue or pod
- shed target

## What Changes

Isolamento por identidade util recupera o trafego normal mais rapido do que um limite global cego.

## Failure Mode

O sistema limita o usuario ou IP errado, enquanto o workload barulhento continua ocupando o recurso quente.

## Cost Signal

Workload isolation compra previsibilidade, mas cobra routing extra, capacidade reservada e mais observabilidade por tenant ou room.

## Interview Takeaway

Noisy neighbor nao se resolve por slogan de microservico; se resolve escolhendo a fronteira certa de blast radius.

## Linked Chapters

- [Chapter 02](../chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 06](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 13](../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)

## Linked Areas

- [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)

## Mastery Checks

- `Pergunta`: o que voce isola primeiro quando um vizinho ruidoso aparece?
- `Resposta com as suas palavras`: a identidade que explica o blast radius real do recurso quente.
- `Resposta ruim que parece boa`: basta subir mais capacidade geral e observar.
- `Troque por isto`: capacidade sem fronteira de fairness costuma apenas comprar um outage maior.
