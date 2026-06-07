# Chapter 03 - GPT Blocks, Residual Paths and Generation Flow

## Slice

Como attention, MLP, residuals e layer normalization viram um bloco GPT repetivel e por que gerar texto e um loop token-a-token, nao uma chamada unica.

## Study Context

- `Track order`: `03/06` - bloco de inferencia e geracao
- `Upstream principal`: [ch04.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch04/01_main-chapter-code/ch04.ipynb)
- `Upstream complementar`: [gpt.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch04/01_main-chapter-code/gpt.py)
- `Topicos locais`: [Streaming Responses](../../topics/streaming-responses.md), [Model Gateway](../../topics/model-gateway.md)
- `Casos ponte`: [ChatGPT - LLM Product](../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [GitHub Copilot - AI Coding](../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md)
- `Review card`: [Card 03](../reviews/cards/03-gpt-blocks-residual-paths-and-generation-flow.md)

## Why This Matters In Systems

Serving de LLM so parece "uma chamada de modelo" para quem nao entendeu que a resposta sai por iteracao autoregressiva. Esse chapter e o ponto onde tempo ate o primeiro token, tempo total e custo por output ficam mais concretos.

## First Principles Learning Pass

- `Requirement Less Dumb`: voce quer entender por que gerar resposta demora e por que streaming ajuda a experiencia, ou so decorar o nome do bloco GPT?
- `Delete`: ignore detalhes numericos finos de inicializacao e hiperparametros que nao mudam o julgamento arquitetural.
- `Simplify`: um bloco GPT combina attention + MLP + residual path; varios blocos empilhados refinam a representacao antes de produzir logits.
- `Accelerate`: leia `gpt.py` e siga o fluxo `input -> block stack -> logits -> next token`.
- `Automate Last`: KV cache, batching sofisticado e serving tuning entram depois que o loop de geracao estiver claro.

## Mental Model

O modelo nao "escreve a resposta inteira". Ele repete um ciclo:

1. recebe tokens de entrada e o que ja gerou;
2. passa isso por varios blocos GPT;
3. produz distribuicoes para o proximo token;
4. escolhe um token;
5. repete.

Residual paths existem para estabilizar profundidade e preservar sinal util ao longo da pilha. Eles importam porque sem eles o bloco fica mais dificil de treinar e escalar.

## Build Checkpoint

- `Abra`: [ch04.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch04/01_main-chapter-code/ch04.ipynb)
- `Leia depois`: [gpt.py](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch04/01_main-chapter-code/gpt.py)
- `Observe`:
  - logits nascem so depois da pilha inteira
  - output e iterativo; cada token novo custa mais trabalho
  - residual path e parte estrutural do bloco, nao detalhe de implementacao
- `Ignore por enquanto`:
  - sampling strategies exoticas
  - compressao de weights
  - tuning de serving por provider

## System Design Bridge

- `Streaming`: melhora tempo percebido porque libera resposta antes do fim do loop, mas nao elimina custo total.
- `Model routing`: escolher modelo tambem e escolher perfil de profundidade, latencia e output budget.
- `Caching`: cache de resposta final e diferente de cache de estado interno; saber disso evita comparacoes ruins.

## Interview Compression

- `15 segundos`: GPT gera token por token; por isso TTFT e TTLT sao metricas diferentes.
- `15 segundos`: residual path ajuda profundidade e estabilidade, nao so limpeza de implementacao.
- `1 minuto`: streaming melhora experiencia porque expoe o loop de geracao ao usuario em vez de esconder tudo ate o fim.

## Decision Synthesis

### Use When

- voce quer explicar latencia de inferencia com fundamento
- precisa ligar arquitetura de serving ao comportamento autoregressivo
- quer parar de tratar modelo como caixa-preta instantanea

### Why This Matters

- fundamenta discussoes sobre streaming, timeout e custo de output
- evita prometer respostas longas como se fossem gratis
- ajuda a comparar modelos alem de benchmark de qualidade

### Main Trade-offs

- output maior compra mais utilidade, mas cobra tempo e custo
- blocos mais robustos podem melhorar qualidade, mas pesam serving
- streaming melhora UX, mas aumenta complexidade de cancelamento e billing

### Warning Signs

- o time mede so latencia total e ignora TTFT
- a equipe trata resposta longa como quase custo zero
- provider swap e visto como solucao magica para problema de arquitetura
