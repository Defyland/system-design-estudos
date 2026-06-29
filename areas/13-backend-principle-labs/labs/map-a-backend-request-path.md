# Map a Backend Request Path

## Objective

Desenhar uma rota backend de ponta a ponta e provar onde entram authentication/authorization, rate limiting, indexing, ACID/transactions, caching, queues, load balancing, CAP, reverse proxy e CDN.

O objetivo nao e decorar definicoes. E mostrar qual boundary assume cada promessa e qual falha aparece primeiro se a promessa for falsa.

## Setup

Escolha uma API pequena, real ou ficticia, com pelo menos:

- uma rota publica cacheavel;
- uma rota autenticada de leitura;
- uma rota autenticada de mutacao;
- um efeito assincrono via job/fila;
- um banco relacional com pelo menos uma query indexada.

Use Rails, Go, Elixir ou pseudocodigo. O deliverable principal e o desenho mais as decisoes, nao a implementacao completa.

## Tasks

1. Desenhe o caminho base do request:

   ```mermaid
   flowchart LR
     Client["client"] --> CDN["CDN"]
     CDN --> Proxy["reverse proxy"]
     Proxy --> LB["load balancer"]
     LB --> App["app"]
     App --> Auth["authn/authz"]
     App --> Cache["cache"]
     App --> DB[(database)]
     App --> Queue["queue"]
     Queue --> Worker["worker"]
     Worker --> External["external effect"]
   ```

2. Preencha a matriz abaixo para a rota escolhida:

   | Conceito | Boundary dono | Decisao concreta | Falha simulada | Sinal de sucesso |
   | --- | --- | --- | --- | --- |
   | Auth/authz |  |  |  |  |
   | Rate limiting |  |  |  |  |
   | Indexing |  |  |  |  |
   | ACID/transactions |  |  |  |  |
   | Caching |  |  |  |  |
   | Queues |  |  |  |  |
   | Load balancing |  |  |  |  |
   | CAP/partition mode |  |  |  |  |
   | Reverse proxy |  |  |  |  |
   | CDN |  |  |  |  |

3. Injete uma falha por camada:

   - token valido tentando acessar tenant errado;
   - tenant ou IP excedendo limite;
   - query sem indice ou com indice de baixa seletividade;
   - mutacao parcialmente gravada;
   - cache key vazando entre tenants ou miss storm;
   - job duplicado ou DLQ ignorada;
   - upstream lento ainda recebendo trafego;
   - particao de rede entre replicas ou regioes;
   - header `X-Forwarded-For` nao confiavel;
   - resposta personalizada indo para CDN publico.

4. Para cada falha, escreva a frase de decisao que voce diria em entrevista:

   ```text
   Eu colocaria <controle> em <boundary> porque <dano protegido>.
   Eu aceitaria <tradeoff> e observaria <metrica>.
   Se <falha>, o fallback e <comportamento esperado>.
   ```

5. Rode os simuladores ja existentes quando o conceito pedir numero:

   - [Rate Limit vs Load Shedding](../../../simulation-labs/rate-limit-vs-load-shedding.md)
   - [Cache](../../../simulation-labs/cache.md)
   - [Queue Replay / Idempotency](../../../simulation-labs/queue-replay-idempotency.md)
   - [Event Backbone / Consumer Lag](../../../simulation-labs/event-backbone-consumer-lag.md)
   - [Load Balancer](../../../simulation-labs/load-balancer.md)
   - [Disaster Recovery / Failover Drill](../../../simulation-labs/disaster-recovery-failover-drill.md)

## Exit Criteria

Voce consegue apontar, no desenho, onde cada conceito vive e responder:

- qual promessa esta sendo protegida;
- qual dado ou recurso esta em risco;
- qual metrica mostra que a camada funciona;
- qual tradeoff foi aceito;
- qual capitulo, contraste ou simulation lab aprofunda aquela decisao.

O lab nao esta completo se a resposta for uma lista de tecnologias. Ele precisa terminar como um mapa de responsabilidades.

## Deliverable

Entregue:

- um diagrama Mermaid do caminho do request;
- a matriz `conceito -> boundary -> decisao -> falha -> sinal`;
- um paragrafo por conceito explicando o tradeoff;
- uma lista dos simuladores, cards e contrasts consultados;
- uma resposta de 2 minutos defendendo o design como se fosse entrevista.

## Linked Concepts

[10 Backend Concepts Visual Field Guide](../../09-backend-principles/cards/ten-backend-concepts-visual-field-guide.md), [Authentication and Authorization](../../09-backend-principles/cards/auth-authz.md), [Rate Limiting Algorithms and Keys](../../09-backend-principles/cards/rate-limiting-algorithms-and-keys.md), [Postgres Databases](../../09-backend-principles/cards/postgres-databases.md), [Caching](../../09-backend-principles/cards/caching.md), [Task Queues and Background Jobs](../../09-backend-principles/cards/task-queues-background-jobs.md), [CAP Theorem](../../06-foundations-distribuidas/topics/cap-theorem.md), [Reverse Proxy](../../07-componentes-de-sistemas/cards/reverse-proxy.md), [CDN](../../07-componentes-de-sistemas/cards/cdn.md).
