# 08 - Sistemas de IA

## Por que esta area existe

Produtos com IA mudam system design: custo por token, streaming, retrieval, guardrails, observabilidade e abuso entram no caminho critico.

## Dois eixos

### LLM Systems

Camada de produto e arquitetura em volta do modelo:

- [LLM Gateway](./topics/llm-gateway.md)
- [RAG](./topics/rag.md)
- [Vector Search](./topics/vector-search.md)
- [Model Gateway](./topics/model-gateway.md)
- [Streaming Responses](./topics/streaming-responses.md)
- [Prompt Injection](./topics/prompt-injection.md)
- [LLM Observability](./topics/llm-observability.md)
- [Token Cost](./topics/token-cost.md)
- [GPU Autoscaling](./topics/gpu-autoscaling.md)
- [Agentic Systems](./topics/agentic-systems.md)

### LLM Foundations

Trilha paralela declarada no `curriculum.yml` para entender internals do modelo e pipeline de treino sem mudar a ordem canonica do repo:

<!-- curriculum:start:side-track-list -->
- [Backend Interview Foundations](../01-metodo-e-entrevistas/backend-interview-foundations/README.md) - Area: [Metodo e Entrevistas](../01-metodo-e-entrevistas/README.md) - [Source Map](../01-metodo-e-entrevistas/backend-interview-foundations/source-map.md) - [Reviews](../01-metodo-e-entrevistas/backend-interview-foundations/reviews/README.md)
- [LLM Foundations](llm-foundations/README.md) - Area: [Sistemas de IA](README.md) - [Source Map](llm-foundations/source-map.md) - [Reviews](llm-foundations/reviews/README.md)
<!-- curriculum:end:side-track-list -->

## Chapters conectados

- [Chapter 06 - Edge Rate Limiting](../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 09 - Search Indexing](../../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 14 - Feed Ranking](../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
