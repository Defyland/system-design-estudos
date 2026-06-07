# Uber - Intelligent Load Management

## Why this case matters

Caso forte para overload control real: proteger banco e dependencias sem tratar rate limit como um numero fixo simplista.

## Course topics

- rate limiting
- overload protection
- load shedding
- fairness
- p99 e throughput sob degradacao

## Stack relevance

- Rails: medium
- Elixir: medium
- Go: high

## Primary sources

- [How Uber Conquered Database Overload: The Journey from Static Rate-Limiting to Intelligent Load Management](https://www.uber.com/en-FR/blog/from-static-rate-limiting-to-intelligent-load-management/)

## What to extract

- por que limite estatico falha
- sinais de overload
- shed vs queue vs reject
- como manter fairness entre clientes

## Strong Anchor

Overload control maduro nao pergunta "qual numero de RPS eu deixo passar?". Ele pergunta "quem esta machucando qual recurso agora, e quem merece sobreviver primeiro?".

## Architecture spine

- sinais de carga nascem do recurso quente, nao de um threshold global decorado
- fairness precisa de identidade util, como tenant, rota critica ou classe de workload
- shed, queue e reject servem para dores diferentes e nao deveriam compartilhar a mesma regra
- feedback loop operacional precisa separar alivio imediato de tuning fino

## Failure mode to remember

Limiter global por IP derruba trafego bom e ainda deixa o tenant barulhento escapar porque a identidade errada foi protegida.

## 3-Minute Drill

- qual recurso aquece primeiro: banco, fila, CPU ou conexao?
- qual identidade captura o vizinho ruidoso de verdade?
- o que voce desliga antes: batch, export ou trafego interativo?

## Linked Chapters

- [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](../../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 13 - Realtime Concurrency and Workload Isolation](../../../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
