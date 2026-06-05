# Simulation Lab - RAG / Vector Search

## Scenario

Um assistente precisa responder perguntas usando documentos internos com permissoes por equipe.

## Controls

- chunk size
- top k
- metadata filter quality
- model latency

## What Changes

Top k maior aumenta recall e custo. Filtro de metadata cedo protege ACL e reduz ruido.

## Failure Mode

Retrieval ruim injeta contexto errado e gera resposta confiante.

## Cost Signal

Cada documento recuperado aumenta tokens, latencia e chance de ruido.

## Interview Takeaway

RAG e search + policy + generation + eval. Nao e apenas vector DB.

## Linked Chapters

- [Chapter 09](../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Linked Areas

- [Sistemas de IA](../areas/08-sistemas-ia/README.md)

## Mastery Checks

- `Pergunta`: onde voce aplica ACL em RAG?
- `Resposta com as suas palavras`: antes ou durante retrieval, nao depois da resposta pronta.
- `Resposta ruim que parece boa`: o modelo pode ignorar documentos proibidos se eu pedir.
- `Troque por isto`: permissao e regra de sistema, nao instrucao educada.

