# Review Card 02 - Self-Attention, Causal Masking and Multi-Head Structure

## Linked Material

- [Chapter 02](../../chapters/02-self-attention-causal-masking-and-multi-head-structure.md)

## Anchor

- `Problema`: o time quer jogar mais contexto no prompt sem entender o que o modelo faz com isso.
- `Decisao`: lembrar que attention compara tokens entre si, mascara causal protege geracao e multi-head separa padroes diferentes.

## Cue Signal

- `Sinal`: contexto longo ficou caro e confuso, mas ninguem sabe explicar o por que.

## Case/Bridge Anchor

- `Ponte`: [Token Cost](../../../topics/token-cost.md), [Streaming Responses](../../../topics/streaming-responses.md)
- `Caso real`: [GitHub Copilot - AI Coding](../../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md)

## QDSAA Recall

- `Requirement corrigido`: o problema nao e "dar mais texto"; e selecionar contexto que mereca attention.
- `Delete`: a fantasia de que prompt grande sempre ajuda.
- `Forma simples`: attention mede relevancia entre tokens; mascara causal impede olhar o futuro; varias heads capturam relacoes diferentes.

## Trade-off to Remember

- `Custo`: mais contexto compra alcance, mas pesa compute e pode diluir sinal util.
- `Failure mode`: latencia explode e a resposta continua ruim porque o contexto entrou sem filtro.

## Trap

- `Resposta ruim`: "se faltou resposta, aumenta o contexto que resolve".
- `Troque por isto`: mais contexto sem selecao vira custo e ruido antes de virar qualidade.

## 1-Minute Answer

Self-attention explica por que contexto nao e gratis. A mascara causal mantem geracao autoregressiva honesta, e multi-head ajuda o modelo a capturar padroes diferentes sem fingir que um unico mapa de relevancia basta.
