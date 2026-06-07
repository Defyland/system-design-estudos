# ChatGPT - LLM Product

## Why this case matters

Caso para estudar gateway de modelo, streaming, RAG, safety, custo por token e observabilidade de respostas.

## Course topics

- LLM gateway
- streaming responses
- RAG
- prompt injection
- token cost
- observability

## Stack relevance

- Rails: high
- Elixir: medium
- Go: high

## Primary sources

- [OpenAI Cookbook - RAG with Elasticsearch](https://cookbook.openai.com/examples/vector_databases/elasticsearch/elasticsearch-retrieval-augmented-generation)
- [OpenAI Help - RAG and semantic search](https://help.openai.com/en/articles/8868588-retrieval-augmented-generation-rag-and-semantic-search-for-gpts)

## What to extract

- separar entrada, policy, retrieval, model call, tools, streaming e eval
- controlar custo por tenant e por feature
- tratar prompt injection como problema de boundary
- traduzir para copiloto interno de SaaS menor

## Foundation Bridge

- [Chapter 03 - GPT Blocks, Residual Paths and Generation Flow](../../../areas/08-sistemas-ia/llm-foundations/chapters/03-gpt-blocks-residual-paths-and-generation-flow.md)
- [Chapter 05 - Finetuning, Instruction Following and LoRA Boundaries](../../../areas/08-sistemas-ia/llm-foundations/chapters/05-finetuning-instruction-following-and-lora-boundaries.md)
- [Chapter 06 - From Model Internals to LLM System Design](../../../areas/08-sistemas-ia/llm-foundations/chapters/06-from-model-internals-to-llm-system-design.md)
