# Source Map

Mapa local -> upstream para estudar fundamento sem copiar notebooks para dentro do repo.

## Warmup Opcional

- `PyTorch basico`: [Appendix A - code-part1.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-A/01_main-chapter-code/code-part1.ipynb) e [code-part2.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-A/01_main-chapter-code/code-part2.ipynb)
  Use so se voce estiver enferrujado em tensor, batch e treino basico.

## Mapa por chapter local

| Local | Upstream principal | Upstream complementar | Observacao |
| --- | --- | --- | --- |
| [Chapter 01](./chapters/01-tokens-embeddings-and-training-windows.md) | [ch02.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch02/01_main-chapter-code/ch02.ipynb) | [dataloader.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch02/01_main-chapter-code/dataloader.ipynb) | absorve o essencial de `ch01` e `ch02` sem repetir teoria introdutoria longa |
| [Chapter 02](./chapters/02-self-attention-causal-masking-and-multi-head-structure.md) | [ch03.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch03/01_main-chapter-code/ch03.ipynb) | [multihead-attention.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch03/02_bonus_efficient-multihead-attention/multihead-attention.ipynb) | foco em mecanismo e custo de contexto |
| [Chapter 03](./chapters/03-gpt-blocks-residual-paths-and-generation-flow.md) | [ch04.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch04/01_main-chapter-code/ch04.ipynb) | [gpt.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch04/01_main-chapter-code/gpt.py) | conecta bloco GPT com serving e streaming |
| [Chapter 04](./chapters/04-pretraining-loop-data-flow-and-loss-discipline.md) | [ch05.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch05/01_main-chapter-code/ch05.ipynb) | [gpt_train.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch05/01_main-chapter-code/gpt_train.py) | Appendix D opcional para bells and whistles de treino |
| [Chapter 05](./chapters/05-finetuning-instruction-following-and-lora-boundaries.md) | [ch06.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch06/01_main-chapter-code/ch06.ipynb) | [ch07.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/ch07.ipynb) | [Appendix E](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-E/01_main-chapter-code/appendix-E.ipynb) entra como opcional de LoRA |
| [Chapter 06](./chapters/06-from-model-internals-to-llm-system-design.md) | [gpt_instruction_finetuning.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/gpt_instruction_finetuning.py) | [ollama_evaluate.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch07/01_main-chapter-code/ollama_evaluate.py) | fecha em avaliacao, comportamento e ponte de arquitetura |

## O que nao espelhar

- exercicios solucionados
- derivacao matematica longa
- detalhes de setup local que nao mudam o julgamento arquitetural
- todo appendix como se fosse obrigatorio
