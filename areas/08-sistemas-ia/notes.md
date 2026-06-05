# Notes

## Modelo mental

Sistema de IA nao e "chamar um modelo". E uma pipeline com entrada, contexto, politicas, custo, streaming, avaliacao e fallback.

## Matriz rapida

| Dor | Movimento | Risco |
| --- | --- | --- |
| resposta inventa fatos | RAG com fontes e avaliacao | contexto ruim aumenta confianca errada |
| custo por request explode | gateway com budget e cache | cachear resposta sensivel ou stale |
| latencia incomoda | streaming e roteamento de modelo | mascarar tempo total ruim |
| prompt injection | boundaries e sanitizacao de ferramenta | tratar prompt como autorizacao |
| qualidade varia | observabilidade e evals | medir so latencia e ignorar resposta |

## Entrevista

Explique primeiro o fluxo: user input -> policy -> retrieval -> model -> tools -> streaming -> logging/eval. Depois pese custo, latencia, seguranca e qualidade.

