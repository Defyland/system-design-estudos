# Incident Severity and Triage

## Trigger

Erros, latencia, fila de suporte, pagamento falhando ou degradacao de jornada critica sem causa unica clara.

## Signals

- p95 e taxa de erro acima do normal;
- queda de conversao ou completions;
- multiplos alerts em cascata;
- volume anormal de tickets ou logs de timeout.

## Immediate Actions

- declarar severidade e incident commander;
- congelar mudancas nao essenciais;
- abrir canal unico de operacao;
- confirmar impacto em usuario e blast radius.

## Stabilize

Rollback, disable de feature, throttling, shed load, fail open/fail closed conforme risco, ou isolamento de tenant/regiao antes de diagnostico detalhado.

## Deep Checks

Timeline de eventos, mudancas recentes, dependencia degradada, saturacao, erro de deploy, correlacao por tenant, regiao ou endpoint, e validade dos sinais.

## Exit Criteria

Impacto principal neutralizado, caminho de operacao conhecido, stakeholder atualizado, action items com dono e janela de follow-up marcada.

## Practice Drill

Simule um checkout com 25% de erro 500. Escreva em 10 minutos: severidade, dono, primeira mitigacao, duas verificacoes profundas e criterio de all clear.

## Source Anchor

- [Google SRE Workbook - Incident Response](https://sre.google/workbook/incident-response/).
- [Slack Engineering - All Hands on Deck](https://slack.engineering/all-hands-on-deck/).
