# Chapter 04 - Pretraining Loop, Data Flow and Loss Discipline

## Slice

Como dados, batches, loss, checkpoints e throughput entram no loop de pretraining e por que isso muda a conversa sobre GPU, observabilidade e qualidade.

## Study Context

- `Track order`: `04/06` - treino como sistema
- `Upstream principal`: [ch05.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch05/01_main-chapter-code/ch05.ipynb)
- `Upstream complementar`: [gpt_train.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch05/01_main-chapter-code/gpt_train.py)
- `Opcional`: [Appendix D - appendix-D.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-D/01_main-chapter-code/appendix-D.ipynb)
- `Topicos locais`: [GPU Autoscaling](../../topics/gpu-autoscaling.md), [LLM Observability](../../topics/llm-observability.md)
- `Casos ponte`: [Perplexity - RAG Answer Engine](../../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)
- `Review card`: [Card 04](../reviews/cards/04-pretraining-loop-data-flow-and-loss-discipline.md)

## Why This Matters In Systems

Mesmo quando voce nao vai treinar foundation model do zero, entender o loop de pretraining corrige duas ilusoes: `loss boa nao garante produto bom` e `GPU autoscaling nao parece CPU autoscaling`.

## First Principles Learning Pass

- `Requirement Less Dumb`: voce quer entender o que de fato controla treino e custo, ou so usar "precisa de mais GPU" como muleta?
- `Delete`: ignore por enquanto dataset gigantesco, DDP e bells and whistles que nao mudam o esqueleto do loop.
- `Simplify`: batch de tokens entra, loss sai, gradiente ajusta pesos, checkpoint protege progresso e validacao impede autoengano.
- `Accelerate`: leia `gpt_train.py` e siga onde entram batch size, sequence length, split train/val e checkpoint.
- `Automate Last`: schedulers complexos, mixed precision, DDP e observabilidade profunda entram depois.

## Mental Model

Pretraining e um pipeline:

1. preparar dados como fluxo de tokens;
2. montar batches com janelas finitas;
3. rodar forward, calcular loss e fazer backward;
4. observar treino e validacao;
5. salvar checkpoints para continuar ou comparar.

O modelo melhora por repeticao disciplinada, nao por "mais GPU" isoladamente. Dados ruins, split ruim ou observabilidade ruim mascaram progresso falso.

## Build Checkpoint

- `Abra`: [ch05.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch05/01_main-chapter-code/ch05.ipynb)
- `Leia depois`: [gpt_train.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch05/01_main-chapter-code/gpt_train.py)
- `Observe`:
  - sequence length e batch mexem em memoria cedo
  - train/val separa aprendizado real de ilusionismo
  - checkpoint nao e so backup; e controle de experimento
- `Ignore por enquanto`:
  - treino distribuido
  - tuning agressivo de optimizer
  - benchmark de escala industrial

## System Design Bridge

- `GPU serving`: memoria e fila ja importam aqui; depois elas reaparecem em inferencia.
- `Observability`: loss e throughput sao metricas necessarias, mas nao suficientes para avaliar produto.
- `Capacity`: warm capacity, fila e custo por step explicam por que GPU autoscaling tem comportamento proprio.

## Interview Compression

- `15 segundos`: pretraining e um sistema de dados + compute + checkpoint, nao um botao de "treinar modelo".
- `15 segundos`: loss menor ajuda, mas nao prova qualidade de produto.
- `1 minuto`: batch, sequence length e checkpoint sao parte da conversa de custo e operacao, nao so de ML.

## Decision Synthesis

### Use When

- voce quer entender por que treino cobra disciplina operacional
- precisa discutir GPU, dados e observabilidade sem frase vaga
- quer separar metrica de treino de valor de produto

### Why This Matters

- corrige a tentacao de confundir compute com progresso real
- ajuda a avaliar claims de serving e autoscaling com mais rigor
- explica porque dados e validacao sao tao estruturais quanto o modelo

### Main Trade-offs

- batch maior pode ganhar throughput, mas cobra memoria
- sequence maior aumenta cobertura, mas pesa custo e estabilidade
- checkpoints frequentes ajudam retomada, mas cobram IO e storage

### Warning Signs

- ninguem mede validacao direito
- loss virou unico KPI
- "mais GPU" aparece antes de entender batch, fila e dataset
