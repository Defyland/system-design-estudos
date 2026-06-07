# Chapter 01 - Tokens, Embeddings and Training Windows

## Slice

Como texto bruto vira unidades processaveis, vetores iniciais e uma janela finita que passa a governar custo, latencia e recuperacao de contexto.

## Study Context

- `Track order`: `01/06` - base mecanica de entrada
- `Upstream principal`: [ch02.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch02/01_main-chapter-code/ch02.ipynb)
- `Upstream complementar`: [dataloader.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch02/01_main-chapter-code/dataloader.ipynb)
- `Warmup opcional`: [Appendix A - code-part1.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/appendix-A/01_main-chapter-code/code-part1.ipynb)
- `Topicos locais`: [Token Cost](../../topics/token-cost.md), [Vector Search](../../topics/vector-search.md)
- `Casos ponte`: [ChatGPT - LLM Product](../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [Perplexity - RAG Answer Engine](../../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)
- `Review card`: [Card 01](../reviews/cards/01-tokens-embeddings-and-training-windows.md)

## Why This Matters In Systems

No sistema real, `token` vira unidade de custo, `window` vira limite de arquitetura e `embedding` vira lingua franca de retrieval. Sem essa base, e facil falar besteira sobre chunking, caching, vector search ou budget por request.

## First Principles Learning Pass

- `Requirement Less Dumb`: voce quer entender por que contexto custa caro e por que retrieval existe, ou so decorar que "LLM usa embeddings"?
- `Delete`: ignore por enquanto detalhes de BPE, merges e compressao historica que nao mudam seu julgamento de sistema.
- `Simplify`: texto vira `token ids`; token ids viram vetores; a janela limita quantos vetores entram por vez.
- `Accelerate`: valide cedo em notebook que `token != palavra` e que sequence length mexe no batch e no custo.
- `Automate Last`: tokenizer custom, pipeline propria de ingestao e tuning fino de chunking entram depois.

## Mental Model

Pense em tres camadas:

1. `Tokenizacao`: quebra o texto em unidades processaveis que raramente coincidem com palavras humanas.
2. `Embedding lookup`: cada token recebe um vetor inicial aprendivel.
3. `Training window`: o modelo so enxerga um trecho finito por vez; o que nao couber precisa ser resumido, recuperado ou descartado.

O erro comum e confundir `embedding` com conhecimento semantico completo. Ele e so o ponto de partida que permite ao modelo e aos sistemas em volta operarem sobre vetores.

## Build Checkpoint

- `Abra`: [ch02.ipynb](https://github.com/rasbt/LLMs-from-scratch/blob/main/ch02/01_main-chapter-code/ch02.ipynb)
- `Observe`:
  - a mesma string pode explodir em contagens de token diferentes do que voce imagina
  - sequence length muda memoria e throughput cedo
  - embedding e uma tabela aprendida, nao magia de busca
- `Ignore por enquanto`:
  - tokenizer propria
  - escolhas exoticas de vocabulario
  - dataset enorme

## System Design Bridge

- `Token cost`: custo por request nasce do que voce manda e do que o modelo devolve, nao do tamanho aparente em palavras.
- `RAG`: retrieval existe porque a janela e finita; voce seleciona o que merece entrar, nao despeja tudo.
- `Vector search`: embedding ajuda a achar contexto candidato, mas nao substitui ACL, metadata ou ranking final.

## Interview Compression

- `15 segundos`: token nao e palavra; window nao e detalhe de implementacao.
- `15 segundos`: embeddings ajudam a representar entrada e a alimentar retrieval, mas nao eliminam a necessidade de selecionar contexto.
- `1 minuto`: system design de IA comeca a ficar caro quando o time trata contexto como infinito.

## Decision Synthesis

### Use When

- voce quer entender custo por token e limite de contexto sem cair em frase pronta
- precisa raciocinar sobre chunking, retrieval e vector search
- quer parar de tratar embedding como "semantica pronta"

### Why This Matters

- quase toda decisao de produto com LLM bate em janela, custo ou contexto
- sem esta base, e facil exagerar no prompt e subestimar latencia
- ela explica por que sistemas de IA precisam selecionar entrada antes de gerar

### Main Trade-offs

- mais contexto pode aumentar qualidade, mas cobra custo e latencia
- chunk pequeno melhora recall de retrieval, mas pode matar coerencia
- embedding util para busca ainda depende de pipeline e metadata honestas

### Warning Signs

- o time mede prompt em palavras em vez de tokens
- RAG vira despejo de documentos na janela
- vector search e tratado como substituto de index, ACL ou ranking
