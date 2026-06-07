# LLM Foundations

## Objetivo

Esta trilha paralela existe para cobrir fundamentos de LLM com mais profundidade do que "chamar API", sem virar um segundo curso solto dentro do repo.

Ela usa [rasbt/LLMs-from-scratch](https://github.com/rasbt/LLMs-from-scratch) como `source spine`, mas nao espelha o livro inteiro e nao muda a ordem canonica dos `14 chapters` principais.

## Boundary

- isto e `side track`, nao prerequisito da trilha principal
- o `curriculum.yml` continua mandando so nos `14 chapters`
- aqui o foco e `mecanismo -> trade-off -> consequencia arquitetural`

## Como estudar

1. leia `1` chapter desta trilha por vez
2. abra o `Build checkpoint` e os links do [Source Map](./source-map.md)
3. feche com o review card correspondente em [reviews/README.md](./reviews/README.md)
4. use a mesma cadencia do repo:
   - [Dia 00 - Pre-Sleep Flashcards](../../../reviews/day-00-pre-sleep-flashcards.md)
   - [Dia 01 - Anchor Recall](../../../reviews/day-01-anchor-recall.md)
   - [Dia 03 - Discrimination Pass](../../../reviews/day-03-discrimination-pass.md)
   - [Dia 07 - Transfer Pass](../../../reviews/day-07-transfer-pass.md)
   - [Dia 14 - Interview Compression](../../../reviews/day-14-interview-compression.md)
   - [Dia 30 - Retention Audit](../../../reviews/day-30-retention-audit.md)

## Ordem

1. [Chapter 01 - Tokens, Embeddings and Training Windows](./chapters/01-tokens-embeddings-and-training-windows.md)
2. [Chapter 02 - Self-Attention, Causal Masking and Multi-Head Structure](./chapters/02-self-attention-causal-masking-and-multi-head-structure.md)
3. [Chapter 03 - GPT Blocks, Residual Paths and Generation Flow](./chapters/03-gpt-blocks-residual-paths-and-generation-flow.md)
4. [Chapter 04 - Pretraining Loop, Data Flow and Loss Discipline](./chapters/04-pretraining-loop-data-flow-and-loss-discipline.md)
5. [Chapter 05 - Finetuning, Instruction Following and LoRA Boundaries](./chapters/05-finetuning-instruction-following-and-lora-boundaries.md)
6. [Chapter 06 - From Model Internals to LLM System Design](./chapters/06-from-model-internals-to-llm-system-design.md)

## Obrigatorio vs Opcional

- `Obrigatorio`: os `6` chapters locais e os `6` review cards
- `Opcional`: Appendix A como warmup de PyTorch, Appendix D para treino mais robusto, Appendix E para LoRA
- `Nao entra na v1`: labs executaveis locais, sync automatico com o repo upstream e novos chapters no `curriculum.yml`

## Pontes Locais

- `LLM Systems`: [LLM Gateway](../topics/llm-gateway.md), [Model Gateway](../topics/model-gateway.md), [RAG](../topics/rag.md), [Streaming Responses](../topics/streaming-responses.md), [Prompt Injection](../topics/prompt-injection.md), [LLM Observability](../topics/llm-observability.md), [Token Cost](../topics/token-cost.md), [GPU Autoscaling](../topics/gpu-autoscaling.md), [Agentic Systems](../topics/agentic-systems.md)
- `Casos reais`: [ChatGPT - LLM Product](../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [GitHub Copilot - AI Coding](../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md), [Perplexity - RAG Answer Engine](../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)

## Source Spine

- [Source Map](./source-map.md)
- upstream principal: [rasbt/LLMs-from-scratch](https://github.com/rasbt/LLMs-from-scratch)
