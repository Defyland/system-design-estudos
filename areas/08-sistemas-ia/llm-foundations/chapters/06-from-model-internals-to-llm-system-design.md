# Chapter 06 - From Model Internals to LLM System Design

## Slice

Como transformar o que voce aprendeu sobre tokenizacao, attention, geracao, treino e tuning em escolhas de arquitetura para produtos com LLM.

## Study Context

- `Track order`: `06/06` - sintese e transferencia
- `Upstream principal`: [gpt_instruction_finetuning.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/gpt_instruction_finetuning.py)
- `Upstream complementar`: [ollama_evaluate.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/ollama_evaluate.py)
- `Topicos locais`: [LLM Gateway](../../topics/llm-gateway.md), [Model Gateway](../../topics/model-gateway.md), [RAG](../../topics/rag.md), [Streaming Responses](../../topics/streaming-responses.md), [Prompt Injection](../../topics/prompt-injection.md), [Agentic Systems](../../topics/agentic-systems.md)
- `Casos ponte`: [ChatGPT - LLM Product](../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [GitHub Copilot - AI Coding](../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md), [Perplexity - RAG Answer Engine](../../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)
- `Review card`: [Card 06](../reviews/cards/06-from-model-internals-to-llm-system-design.md)

## Why This Matters In Systems

Fundamento sem transferencia vira cultura geral cara. Este chapter fecha a trilha mostrando quando o problema pede `melhor contexto`, `melhor roteamento`, `melhor policy`, `melhor modelo` ou `melhor avaliacao`.

## First Principles Learning Pass

- `Requirement Less Dumb`: o fracasso observado e de conhecimento, comportamento, custo, latencia, seguranca ou orchestration?
- `Delete`: remova a resposta automatico "troca de modelo" antes de provar que o gargalo mora nos pesos.
- `Simplify`: comece pelo menor ajuste que move o sistema certo: prompt/contexto, retrieval, routing, tool boundary, model tuning ou eval.
- `Accelerate`: compare duas ou tres rotas pequenas com metricas honestas antes de ampliar a stack.
- `Automate Last`: multi-agent loop, modelo por tenant e flywheel de tuning entram so depois que a pipeline simples ficar clara.

## Mental Model

A traducao pratica do fundamento para arquitetura costuma caber nestas perguntas:

1. `Contexto`: o modelo nao sabe porque nao viu, ou porque viu demais e mal?
2. `Comportamento`: a tarefa pede formato, estilo ou obediencia recorrente?
3. `Custo e latencia`: o gargalo esta em tokens, contexto, modelo ou output?
4. `Safety`: a decisao precisa de policy fora do texto?
5. `Evaluation`: como voce sabe que melhorou sem se enganar com metrica local?

Quando voce entende o mecanismo, para de tratar todas as falhas como se fossem "hallucination" ou "precisa de modelo maior".

## Build Checkpoint

- `Abra`: [gpt_instruction_finetuning.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/gpt_instruction_finetuning.py)
- `Depois`: [ollama_evaluate.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/ollama_evaluate.py)
- `Observe`:
  - comportamento ajustado ainda precisa de avaliacao externa
  - output bom em um script nao resolve pipeline inteira
  - medir qualidade separadamente do treino e parte do sistema
- `Ignore por enquanto`:
  - framework de agente
  - benchmark publico como verdade final
  - automacao pesada de eval

## System Design Bridge

- `ChatGPT`: streaming, gateway, safety e custo por token pedem julgamento sobre geracao e policy.
- `Copilot`: contexto de repositorio, routing e tool boundary pedem clareza sobre janela, attention e comportamento.
- `Perplexity`: retrieval, citacao e serving pedem entendimento de window, embeddings e avaliacao.

## Interview Compression

- `15 segundos`: primeiro eu localizo se a falha mora em contexto, comportamento, custo, safety ou avaliacao.
- `15 segundos`: melhor modelo nao corrige automaticamente prompt ruim, retrieval ruim ou policy inexistente.
- `1 minuto`: system design de IA fica mais rigoroso quando voce sabe ligar mecanismo de modelo a decisao de arquitetura.

## Decision Synthesis

### Use When

- voce quer traduzir fundamento em arquitetura concreta
- precisa decidir entre RAG, tuning, routing e policy
- quer discutir IA com mais rigor do que "vamos usar um modelo melhor"

### Why This Matters

- fecha a ponte entre mecanica do modelo e stack de produto
- reduz resposta cargo-cult em discussoes de LLM system design
- ajuda a escolher o menor movimento que realmente corrige a dor

### Main Trade-offs

- mais sistema em volta aumenta controle, mas cobra operacao
- mais tuning melhora especializacao, mas reduz flexibilidade
- mais retrieval melhora grounding, mas adiciona latencia e dependencia de index

### Warning Signs

- tudo vira problema de prompt
- tudo vira problema de modelo
- ninguem sabe dizer o que mudou na qualidade alem de sensacao
