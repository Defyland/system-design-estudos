# Capstone 04 - Social Feed and Event Backbone

## Pull Chapters

- [Chapter 06 - Event Backbone, Partitions and Consumer Scale](../chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 08 - Distributed IDs and Ordering Guarantees](../chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)
- [Chapter 14 - Feed Ranking and Fanout Trade-offs](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Interview Mode

Seu entrevistador pede: "desenhe um feed social com muitos produtores, consumidores independentes e necessidade de ranking".

## Work Mode

Seu PO diz: "a timeline cronologica esta piorando, e agora notificacao, analytics e feed estao brigando pelo mesmo fluxo de eventos".

## Oral Route

1. diga quando uma fila deixa de bastar e um backbone aparece
2. escolha a chave de particao que preserva a ordem que importa
3. diga por que feed nao e so `ORDER BY created_at`
4. explique quando fanout-on-write ajuda e quando atrapalha
5. diga se um ID distribuido ordenavel muda algo relevante aqui
6. diga qual baseline em Rails voce faria antes de qualquer infra heroica

## Good Answer Sounds Like

- evento vira backbone quando varios consumidores querem o mesmo fato com replay
- particao preserva ordem util do agregado, nao ordem cosmica
- feed separa inventario candidato de ranking
- ID ordenavel ajuda onde rough ordering importa; nao substitui desenho do feed

## Production Twist

### Page

Um ranker novo entra em producao ao mesmo tempo em que o time aumenta o fanout. Logo depois, uma particao esquenta muito mais do que as outras e o feed fica mais lento e mais estranho. Esse e o classico caso em que qualidade e infraestrutura quebram juntas.

### First Dashboard

- lag por particao
- quantidade de candidatos por request
- p95 do feed
- metrica de qualidade do feed ou CTR de guardrail

### Immediate Mitigation

- volte para o ranker anterior ou para um fallback cronologico aceitavel
- corte a fonte de candidatos mais cara
- pause replay ou fanout que esteja enchendo a particao quente

### Rollback or Hold

Rollback do ranker novo se a regressao bate usuario ou latencia. Hold em retuning global de particoes ate separar o que e defeito de ranking do que e defeito de throughput.

### What Not to Change Mid-Incident

- nao mude schema e algoritmo ao mesmo tempo
- nao acelere replay so porque backlog assusta
- nao avalie saude do feed apenas pela ausencia de 500

## Trap

- "Kafka, Snowflake e ranking resolvem feed automaticamente"
