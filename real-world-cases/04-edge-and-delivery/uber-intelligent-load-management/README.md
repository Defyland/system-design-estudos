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

