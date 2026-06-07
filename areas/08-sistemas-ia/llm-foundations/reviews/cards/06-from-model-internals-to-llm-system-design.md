# Review Card 06 - From Model Internals to LLM System Design

## Linked Material

- [Chapter 06](../../chapters/06-from-model-internals-to-llm-system-design.md)

## Anchor

- `Problema`: todas as falhas de produto com LLM parecem iguais para quem nao sabe ligar mecanismo de modelo a arquitetura.
- `Decisao`: localizar primeiro se a dor mora em contexto, comportamento, custo, safety ou avaliacao.

## Cue Signal

- `Sinal`: a equipe ja quer trocar de modelo, mas ainda nao isolou o tipo de falha.

## Case/Bridge Anchor

- `Ponte`: [LLM Gateway](../../../topics/llm-gateway.md), [Model Gateway](../../../topics/model-gateway.md), [RAG](../../../topics/rag.md), [Agentic Systems](../../../topics/agentic-systems.md)
- `Casos reais`: [ChatGPT - LLM Product](../../../../../real-world-cases/05-product-scenarios/chatgpt-llm-product/README.md), [GitHub Copilot - AI Coding](../../../../../real-world-cases/05-product-scenarios/github-copilot-ai-coding/README.md), [Perplexity - RAG Answer Engine](../../../../../real-world-cases/05-product-scenarios/perplexity-rag-answer-engine/README.md)

## QDSAA Recall

- `Requirement corrigido`: antes de mexer no modelo, descubra se o sistema falhou em contexto, roteamento, policy ou avaliacao.
- `Delete`: a resposta reflexa "modelo melhor" para toda dor de IA.
- `Forma simples`: escolha o menor movimento que corrige o problema certo.

## Trade-off to Remember

- `Custo`: mais sistema em volta compra controle, mas adiciona operacao e latencia.
- `Failure mode`: tuning caro ou stack complexa em cima de requisito mal localizado.

## Trap

- `Resposta ruim`: "hallucination" virou nome para qualquer defeito de produto.
- `Troque por isto`: classifique a falha primeiro; so depois escolha entre RAG, tuning, routing, policy ou eval.

## 1-Minute Answer

Fundamento de modelo so paga o aluguel quando vira julgamento arquitetural. Primeiro localize a dor real; depois escolha entre melhorar contexto, comportamento, custo, safety ou avaliacao.
