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

## Trap

- "Kafka, Snowflake e ranking resolvem feed automaticamente"
