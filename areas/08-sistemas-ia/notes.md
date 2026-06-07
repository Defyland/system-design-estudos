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

## Foundation bridge

| Problema de sistema | Fundamento de modelo | O que isso evita falar errado |
| --- | --- | --- |
| custo por request explode | tokenizacao + training window | evita medir prompt em palavras e ignorar limite de contexto |
| retrieval e chunking estao ruins | embeddings + attention | evita tratar vector search como substituto de selecao de contexto |
| streaming melhorou UX, mas nao throughput | generation loop autoregressivo | evita fingir que primeiro token rapido significa resposta barata |
| fine-tune nao resolveu resposta desatualizada | finetuning vs RAG | evita usar ajuste de pesos para problema de conhecimento vivo |
| fila ou GPU estao sofrendo | pretraining / inferencia como pipeline | evita comparar GPU serving com app web CPU-bound sem nuance |

## Entrevista

Explique primeiro o fluxo: user input -> policy -> retrieval -> model -> tools -> streaming -> logging/eval. Depois pese custo, latencia, seguranca e qualidade.
