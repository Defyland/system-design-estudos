# Review Card 01 - Tokens, Embeddings and Training Windows

## Linked Material

- [Chapter 01](../../chapters/01-tokens-embeddings-and-training-windows.md)

## Anchor

- `Problema`: custo, chunking e retrieval parecem arbitrarios quando o time nao entende a unidade real de entrada do modelo.
- `Decisao`: pensar em `tokens -> embeddings -> window finita` antes de desenhar prompt, RAG ou budget.

## Cue Signal

- `Sinal`: word count parou de explicar custo, latencia ou corte de contexto.

## Case/Bridge Anchor

- `Ponte`: [Token Cost](../../../topics/token-cost.md), [Vector Search](../../../topics/vector-search.md)
- `Caso real`: [Perplexity - RAG Answer Engine](../../../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)

## QDSAA Recall

- `Requirement corrigido`: a unidade de custo e contexto nao e palavra humana; e token dentro de janela finita.
- `Delete`: heuristica de prompt baseada so em caracteres, paginas ou "parece pequeno".
- `Forma simples`: texto vira tokens; tokens viram vetores; a janela decide o que cabe.

## Trade-off to Remember

- `Custo`: mais contexto pode ajudar a resposta, mas cobra latencia e dinheiro cedo.
- `Failure mode`: prompt bloat, chunking ruim ou retrieval despejando coisa demais na janela.

## Trap

- `Resposta ruim`: "embedding ja e a semantica pronta, entao retrieval esta resolvido".
- `Troque por isto`: embedding ajuda a representar e recuperar; selecao de contexto e janela continuam mandando.

## 1-Minute Answer

LLM enxerga tokens, nao palavras. Embeddings sao o ponto de partida vetorial, e a training window e o limite estrutural que obriga custo, chunking e retrieval a existirem.
