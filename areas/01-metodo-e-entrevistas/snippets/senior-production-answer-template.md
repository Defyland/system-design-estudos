# Senior Production Answer Template

## Use When

Quando a pergunta de system design vira incidente, degradacao, rollout ruim ou falha sob pressao.

## Template

1. `Impacto`
   - "o caminho critico afetado e ..."
2. `Protecao imediata`
   - "eu preservaria primeiro ..."
3. `Primeira leitura`
   - "as primeiras metricas ou dashboards seriam ..."
4. `Mitigacao`
   - "a menor mudanca segura agora e ..."
5. `Rollback`
   - "se a mudanca nova estiver implicada, eu reverteria ..."
6. `Nao mexer agora`
   - "eu evitaria mudar ... no meio do incidente"
7. `Correcao posterior`
   - "depois de estabilizar, eu investigaria ..."

## Wrong Answer Pattern

- comecar por tecnologia
- sugerir reescrita
- sugerir aumentar retry ou capacidade antes de entender o contrato quebrado

## Rails First

Rails continua excelente para explicar:
- caminho critico
- boundary
- regra de negocio
- rollback de feature flag

Elixir e Go entram depois, quando o incidente depende do tipo de runtime, e nao antes.
