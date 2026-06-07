# Chapter 05 - Finetuning, Instruction Following and LoRA Boundaries

## Slice

Quando ajustar pesos muda comportamento de verdade, quando instruction tuning entra, onde LoRA ajuda e por que isso nao substitui RAG nem policy externa.

## Study Context

- `Track order`: `05/06` - especializacao e alinhamento
- `Upstream principal`: [ch06.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch06/01_main-chapter-code/ch06.ipynb)
- `Upstream complementar`: [ch07.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/ch07.ipynb)
- `Opcional`: [Appendix E - appendix-E.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-E/01_main-chapter-code/appendix-E.ipynb)
- `Topicos locais`: [RAG](../../topics/rag.md), [Prompt Injection](../../topics/prompt-injection.md), [Model Gateway](../../topics/model-gateway.md)
- `Casos ponte`: [ChatGPT - LLM Product](../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [GitHub Copilot - AI Coding](../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md)
- `Review card`: [Card 05](../reviews/cards/05-finetuning-instruction-following-and-lora-boundaries.md)

## Why This Matters In Systems

Sem este chapter, o time mistura tres problemas diferentes: comportamento, conhecimento e policy. A resposta fica cara e errada: fine-tunar quando faltava retrieval, ou usar RAG quando faltava ajustar comportamento.

## First Principles Learning Pass

- `Requirement Less Dumb`: o problema e comportamento estavel, conhecimento atualizado ou policy de sistema?
- `Delete`: ignore por enquanto receitas de benchmark e dataset glamouroso que nao mudam o boundary da decisao.
- `Simplify`: pretraining ensina linguagem ampla; finetuning ajusta comportamento; instruction tuning melhora seguimento de instrucoes; LoRA barateia adaptacao.
- `Accelerate`: compare rapidamente classificacao, instruction tuning e adapter leve antes de falar em treinar do zero.
- `Automate Last`: pipelines de continual finetuning, data flywheel e modelo por tenant entram depois.

## Mental Model

Pense na escolha assim:

1. `RAG` injeta conhecimento novo ou privado sem mudar pesos.
2. `Finetuning` muda o comportamento esperado do modelo em tarefas recorrentes.
3. `Instruction tuning` melhora obediencia a formatos e intencoes.
4. `LoRA` permite ajustar parte do comportamento sem carregar o custo de mexer no modelo inteiro.

Nada disso elimina a necessidade de policy externa. Tool use, ACL e safety continuam pertencendo ao sistema.

## Build Checkpoint

- `Abra`: [ch06.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch06/01_main-chapter-code/ch06.ipynb)
- `Depois`: [ch07.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/ch07.ipynb)
- `Opcional`: [Appendix E - appendix-E.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-E/01_main-chapter-code/appendix-E.ipynb)
- `Observe`:
  - classificacao e instruction following mudam objetivos diferentes
  - adapter leve muda custo de adaptacao
  - melhorar comportamento nao equivale a atualizar conhecimento
- `Ignore por enquanto`:
  - leaderboard chasing
  - dataset gigantesco de alinhamento
  - fine-tuning continuo por feature

## System Design Bridge

- `RAG vs finetuning`: use RAG para conhecimento movel; finetuning para comportamento estavel.
- `Safety`: prompt injection e misuse nao somem porque o modelo obedece melhor instrucoes.
- `Routing`: model gateway pode decidir entre base model, tuned model e fallback sem misturar tudo.

## Interview Compression

- `15 segundos`: finetuning muda comportamento; RAG muda contexto.
- `15 segundos`: LoRA e ferramenta de custo e velocidade para adaptacao, nao substituto universal.
- `1 minuto`: policy externa continua fora do modelo, mesmo depois de instruction tuning.

## Decision Synthesis

### Use When

- voce precisa separar ajuste de comportamento de atualizacao de conhecimento
- quer discutir por que nem todo gap de qualidade pede modelo novo
- precisa explicar LoRA sem transformar isso em hype

### Why This Matters

- evita gastar tuning em problema de retrieval
- evita prometer safety so com melhor prompt ou melhor fine-tune
- ajuda a desenhar rotas mais honestas entre modelo e sistema

### Main Trade-offs

- finetuning melhora especializacao, mas adiciona custo operacional
- LoRA barateia adaptacao, mas ainda exige avaliacao e governanca
- RAG e mais flexivel para conhecimento vivo, mas depende de retrieval bom

### Warning Signs

- o time usa fine-tune para corrigir documento desatualizado
- RAG e usado para forcar comportamento consistente
- safety e tratada como propriedade emergente do modelo
