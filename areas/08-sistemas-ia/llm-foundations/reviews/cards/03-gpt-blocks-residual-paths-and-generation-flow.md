# Review Card 03 - GPT Blocks, Residual Paths and Generation Flow

## Linked Material

- [Chapter 03](../../chapters/03-gpt-blocks-residual-paths-and-generation-flow.md)

## Anchor

- `Problema`: servir LLM parece uma chamada unica para quem esquece que a resposta sai token por token.
- `Decisao`: enxergar o bloco GPT como pilha repetida de transformacao e a geracao como loop autoregressivo.

## Cue Signal

- `Sinal`: TTFT, TTLT, streaming ou output longo viraram dor de produto.

## Case/Bridge Anchor

- `Ponte`: [Streaming Responses](../../../topics/streaming-responses.md), [Model Gateway](../../../topics/model-gateway.md)
- `Caso real`: [ChatGPT - LLM Product](../../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md)

## QDSAA Recall

- `Requirement corrigido`: latencia de LLM nao e um numero unico; existe tempo ate o primeiro token e tempo ate terminar o loop.
- `Delete`: a ideia de que streaming reduz custo total.
- `Forma simples`: blocos GPT refinam representacao; logits saem no fim; cada token novo pede outro passo de geracao.

## Trade-off to Remember

- `Custo`: respostas longas ajudam o usuario, mas cada token cobra mais compute e mais espera.
- `Failure mode`: produto parece rapido no primeiro token e continua lento, caro e dificil de cancelar.

## Trap

- `Resposta ruim`: "streaming resolveu latencia".
- `Troque por isto`: streaming melhora experiencia percebida, mas o loop autoregressivo continua cobrando tempo e custo.

## 1-Minute Answer

GPT gera texto iterativamente. Residual paths tornam profundidade viavel, e o loop token-a-token e o motivo pelo qual output, streaming e timeout entram no desenho do sistema.
