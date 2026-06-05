# Simulation Lab - LLM Gateway / Token Cost

## Scenario

Tres features chamam modelos diferentes. Um tenant grande comeca a gastar muito e aumentar latencia.

## Controls

- requests per minute
- input tokens
- output tokens
- model tier
- cache hit rate

## What Changes

Modelos maiores melhoram qualidade em alguns casos, mas custo e latencia sobem rapido.

## Failure Mode

Sem gateway, cada feature cria sua propria politica de modelo, budget e fallback.

## Cost Signal

Contexto inutil vira custo recorrente.

## Interview Takeaway

LLM gateway existe para tornar custo, policy, routing e fallback observaveis.

## Linked Chapters

- [Chapter 06](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Linked Areas

- [Sistemas de IA](../areas/08-sistemas-ia/README.md)

## Mastery Checks

- `Pergunta`: qual reducao vem antes de trocar modelo?
- `Resposta com as suas palavras`: cortar contexto inutil e limitar output.
- `Resposta ruim que parece boa`: usar modelo menor sempre resolve custo.
- `Troque por isto`: modelo menor pode destruir qualidade; primeiro reduza desperdicio.

