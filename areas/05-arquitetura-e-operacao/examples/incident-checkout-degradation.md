# Example - Incident Checkout Degradation

## Cenario

Marketplace pequeno. Depois de ativar step-up auth para pagamentos de maior risco:
- `requires_action` sobe muito
- conversao cai
- suporte comeca a receber reclamacao de "pagamento preso"

## Leitura senior

- o problema pode ser regulatorio ou de risco, mas o incidente e de conversao em caminho de receita
- o primeiro medo e ambiguidade financeira, nao UX feia

## Primeiros 15 minutos

1. abrir conversao por etapa
2. comparar timeout de PSP e abandono em `requires_action`
3. desligar a regra nova se ela for o ultimo grande dif
4. preservar idempotencia e reconciliacao antes de qualquer replay manual

## Rollback certo

- volta a regra de risk step-up
- mantem o boundary de checkout
- nao desmonta a protecao de idempotencia no susto

## Aprendizado

Senior de producao nao "resolve checkout". Ele primeiro para de perder dinheiro e de confundir estado.
