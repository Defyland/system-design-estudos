# Chapter 02 - Self-Attention, Causal Masking and Multi-Head Structure

## Slice

Como o modelo decide a quais tokens prestar atencao, por que a mascara causal existe e por que contexto maior custa mais do que parece.

## Study Context

- `Track order`: `02/06` - mecanismo central de relacao entre tokens
- `Upstream principal`: [ch03.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch03/01_main-chapter-code/ch03.ipynb)
- `Upstream complementar`: [multihead-attention.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch03/02_bonus_efficient-multihead-attention/multihead-attention.ipynb)
- `Topicos locais`: [Token Cost](../../topics/token-cost.md), [Streaming Responses](../../topics/streaming-responses.md)
- `Casos ponte`: [ChatGPT - LLM Product](../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [GitHub Copilot - AI Coding](../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md)
- `Review card`: [Card 02](../reviews/cards/02-self-attention-causal-masking-and-multi-head-structure.md)

## Why This Matters In Systems

Attention explica por que prompt longo nao e gratis, por que retrieval e compressao de contexto importam e por que "jogar mais texto" quase sempre piora custo antes de melhorar resposta.

## First Principles Learning Pass

- `Requirement Less Dumb`: voce quer entender de onde vem a habilidade de relacionar tokens, ou so decorar que Transformers sao melhores?
- `Delete`: ignore por enquanto derivacao matricial longa e variantes de eficiencia que nao mudam o modelo mental.
- `Simplify`: cada token pergunta `o que importa para mim?`, a mascara causal impede olhar para o futuro, e varias heads aprendem relacoes diferentes.
- `Accelerate`: rode o notebook e veja na pratica que custo de atencao cresce com o contexto, nao so com o output.
- `Automate Last`: flash attention, kernels especiais e tunings finos entram depois que o mecanismo base ficou claro.

## Mental Model

Self-attention faz tres trabalhos ao mesmo tempo:

1. compara tokens entre si para medir relevancia;
2. combina informacao relevante em uma representacao nova;
3. respeita a direcao temporal quando o modelo gera o proximo token.

`Causal masking` e a trava que mantem o treino e a geracao honestos. Sem ela, o modelo veria a resposta pronta durante o treino autoregressivo.

`Multi-head` nao e enfeite. Ele permite que o bloco observe padroes diferentes em paralelo, como dependencia local, copia, sintaxe ou relacoes mais longas.

## Build Checkpoint

- `Abra`: [ch03.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch03/01_main-chapter-code/ch03.ipynb)
- `Depois`: [multihead-attention.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch03/02_bonus_efficient-multihead-attention/multihead-attention.ipynb)
- `Observe`:
  - a mascara causal muda a estrutura do problema, nao so a seguranca do treino
  - mais contexto aumenta trabalho quadratico cedo
  - varias heads ajudam o modelo a separar padroes diferentes
- `Ignore por enquanto`:
  - benchmarks de kernel
  - otimizacoes especificas de hardware
  - variantes exoticas de attention

## System Design Bridge

- `Prompt assembly`: contexto tem custo mecanico real; portanto montar prompt e trabalho de arquitetura.
- `RAG`: retrieval bom existe para reduzir universo antes da attention, nao para competir com ela.
- `Inference scaling`: contexto gigante sem filtragem vira latencia e fila, mesmo com streaming.

## Interview Compression

- `15 segundos`: attention e o motivo de prompt grande custar caro e de contexto selecionado importar.
- `15 segundos`: mascara causal protege a geracao autoregressiva de olhar o futuro.
- `1 minuto`: multi-head existe para capturar relacoes diferentes sem fingir que um unico mapa de relevancia resolve tudo.

## Decision Synthesis

### Use When

- voce precisa explicar custo por contexto com fundamento
- quer ligar retrieval e chunking ao mecanismo do modelo
- precisa discutir porque contexto maior tem retorno decrescente

### Why This Matters

- explica por que inferencia degrada quando o time despeja contexto demais
- evita tratar streaming como solucao de latencia total
- ancora a conversa de arquitetura em custo computacional real

### Main Trade-offs

- mais contexto aumenta alcance, mas piora custo e ruida relevancia
- mais heads aumentam expressividade, mas tambem complexidade e compute
- filtrar contexto cedo ajuda custo, mas pode cortar sinal util

### Warning Signs

- "mais contexto sempre melhora"
- retrieval e tratado como feature de produto, nao como alivio estrutural
- ninguem sabe explicar por que a janela ficou cara
