# Perplexity - RAG Answer Engine

## Why this case matters

Caso para estudar answer engine, retrieval, citation, inference cost, GPU serving e qualidade sob latencia.

## Course topics

- RAG
- vector search
- citations
- inference serving
- GPU autoscaling

## Stack relevance

- Rails: medium
- Elixir: medium
- Go: high

## Primary sources

- [Perplexity RAG cookbook](https://docs.perplexity.ai/docs/cookbook/articles/embeddings-rag/README)
- [CuTeDSL at Perplexity](https://research.perplexity.ai/articles/cutedsl-at-perplexity)

## What to extract

- retrieval precisa ser medido por qualidade, nao so latencia
- citacao e grounding fazem parte da confianca do produto
- serving proprio muda a conversa para GPU, fila e batching
- traduzir para busca com resposta em produto menor

## Foundation Bridge

- [Chapter 01 - Tokens, Embeddings and Training Windows](../../../areas/08-sistemas-ia/llm-foundations/chapters/01-tokens-embeddings-and-training-windows.md)
- [Chapter 04 - Pretraining Loop, Data Flow and Loss Discipline](../../../areas/08-sistemas-ia/llm-foundations/chapters/04-pretraining-loop-data-flow-and-loss-discipline.md)
- [Chapter 06 - From Model Internals to LLM System Design](../../../areas/08-sistemas-ia/llm-foundations/chapters/06-from-model-internals-to-llm-system-design.md)
