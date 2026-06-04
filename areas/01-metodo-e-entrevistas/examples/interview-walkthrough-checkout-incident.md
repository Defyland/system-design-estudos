# Interview Walkthrough - Checkout Incident

## Cenario

O entrevistador diz:

"Depois de um rollout de checkout, a conversao caiu e o time acha que pode ser PSP, reauth ou idempotencia. Como voce responde?"

## Resposta senior boa

1. defina o impacto:
   - receita e caminho critico afetados
2. diga o que protegeria primeiro:
   - preservar mutacao correta e evitar duplicate charge
3. abra a investigacao certa:
   - conversao por etapa, `requires_action`, timeout de PSP, `processing` preso, taxa de conflito
4. proponha mitigacao:
   - desligar a regra nova ou o payment method novo
5. proponha rollback:
   - voltar ao fluxo anterior com contrato idempotente preservado
6. so depois fale de causa raiz:
   - PSP, risk step-up ou boundary novo

## Resposta fraca

- "eu olharia logs e tentaria mais retry"
- "talvez escalar mais o checkout resolva"
- "talvez trocar Stripe por outra stack ajude"

## O que o entrevistador quer ouvir

- ordem de prioridades correta
- clareza entre mitigar e investigar
- protecao do dinheiro antes da beleza da arquitetura
