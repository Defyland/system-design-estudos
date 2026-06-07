# Review Card 05 - Finetuning, Instruction Following and LoRA Boundaries

## Linked Material

- [Chapter 05](../../chapters/05-finetuning-instruction-following-and-lora-boundaries.md)

## Anchor

- `Problema`: o time mistura comportamento, conhecimento e policy, e escolhe a ferramenta errada para cada dor.
- `Decisao`: separar `finetuning`, `instruction following`, `LoRA` e `RAG` por funcao real.

## Cue Signal

- `Sinal`: a qualidade caiu, mas ainda nao esta claro se faltou contexto, comportamento estavel ou policy fora do modelo.

## Case/Bridge Anchor

- `Ponte`: [RAG](../../../topics/rag.md), [Prompt Injection](../../../topics/prompt-injection.md), [Model Gateway](../../../topics/model-gateway.md)
- `Caso real`: [GitHub Copilot - AI Coding](../../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md)

## QDSAA Recall

- `Requirement corrigido`: conhecimento vivo pede contexto; comportamento recorrente pede ajuste; policy continua no sistema.
- `Delete`: usar fine-tuning para corrigir documento desatualizado.
- `Forma simples`: RAG injeta conhecimento; finetuning muda comportamento; LoRA barateia adaptacao.

## Trade-off to Remember

- `Custo`: tuning compra especializacao, mas adiciona governanca e operacao.
- `Failure mode`: time treina pesos para resolver um problema que retrieval ou boundary externo resolveriam melhor.

## Trap

- `Resposta ruim`: "se a resposta estiver errada, fine-tune resolve".
- `Troque por isto`: primeiro descubra se a dor e de conhecimento, comportamento ou policy.

## 1-Minute Answer

Finetuning muda comportamento do modelo; RAG muda o contexto que entra; LoRA reduz custo de adaptacao. Nenhum deles substitui policy externa ou retrieval honesto.
