# Review Card 04 - Pretraining Loop, Data Flow and Loss Discipline

## Linked Material

- [Chapter 04](../../chapters/04-pretraining-loop-data-flow-and-loss-discipline.md)

## Anchor

- `Problema`: falar de treino sem entender batch, loss, validacao e checkpoint vira supersticao cara.
- `Decisao`: tratar pretraining como sistema de dados, compute, observabilidade e retomada.

## Cue Signal

- `Sinal`: a conversa virou "precisa de mais GPU" antes de olhar sequence length, batch ou validacao.

## Case/Bridge Anchor

- `Ponte`: [GPU Autoscaling](../../../topics/gpu-autoscaling.md), [LLM Observability](../../../topics/llm-observability.md)
- `Caso real`: [Perplexity - RAG Answer Engine](../../../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)

## QDSAA Recall

- `Requirement corrigido`: loss so vale quando observada junto com throughput, validacao e checkpoint.
- `Delete`: a explicacao preguiosa de que compute isolado resolve tudo.
- `Forma simples`: batches de tokens entram, loss sai, gradiente ajusta pesos e checkpoint protege experimento.

## Trade-off to Remember

- `Custo`: batch e sequence maiores podem ganhar cobertura ou throughput, mas cobram memoria e fila.
- `Failure mode`: loss melhora em treino, produto nao melhora e a equipe so percebe tarde.

## Trap

- `Resposta ruim`: "loss caiu, entao qualidade ja subiu".
- `Troque por isto`: treino precisa de validacao e avaliacao honestas; loss e necessaria, nao suficiente.

## 1-Minute Answer

Pretraining e pipeline operacional. Dados, batch, sequence length, validacao e checkpoint explicam custo e progresso melhor do que a frase pronta "mais GPU".
