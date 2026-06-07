# Dia 00 - Pre-Sleep Flashcards

## Objetivo

Fechar o dia com um passe curto de `cue -> decisao -> trade-off`, para o chapter nao dormir como leitura solta.

## Regra

1. pegue so os cards estudados hoje
2. cubra a resposta e fale em voz alta:
   - qual `Cue Signal` acendeu?
   - qual decisao o chapter defendeu?
   - qual alternativa vizinha ficou de fora?
3. se hesitar, leia o `1-Minute Answer` e pare
4. limite em `5 minutos` ou `3 cards`

Nao reabra o chapter inteiro. O objetivo e consolidar, nao reiniciar a sessao.

## Deck Rapido

- [Card 01](./cards/01-relational-scaling-and-operational-discipline.md): o banco doi, mas integridade transacional ainda manda. O que voce corrige antes de shard ou NoSQL?
- [Card 02](./cards/02-pod-isolation-and-tenant-routing.md): um tenant ruidoso ou uma fronteira regional esta machucando todos. O que isso puxa antes de microservicos?
- [Card 03](./cards/03-idempotent-writes-under-ambiguous-failure.md): o `POST` pode ter dado certo, mas ninguem sabe. Qual contrato protege o retry?
- [Card 04](./cards/04-event-backbone-partitions-and-consumer-scale.md): o mesmo evento precisa alimentar varios consumidores em ritmos diferentes. Quando fila simples vira backbone?
- [Card 05](./cards/05-durable-workflows-retries-and-compensation.md): a operacao cruza servicos, demora e pode falhar no meio. Quando jobs encadeados deixam de bastar?
- [Card 06](./cards/06-edge-rate-limiting-waf-and-gateway-boundaries.md): o edge bloqueia volume e padrao, mas qual decisao continua morando na app?
- [Card 07](./cards/07-critical-checkout-flows-and-auth-boundaries.md): auth, risco e pagamento encostaram no mesmo fluxo critico. Qual boundary o chapter criou?
- [Card 08](./cards/08-blob-durability-and-storage-tiers.md): o arquivo ficou grande, quente e caro. O que sai do banco primeiro, e o que continua relacional?
- [Card 09](./cards/09-search-indexing-and-permission-aware-retrieval.md): busca rica quer texto, recall e ACL. Qual arquitetura nasce quando SQL correto nao basta para retrieval?
- [Card 10](./cards/10-cdn-placement-dns-and-cache-invalidation.md): latencia agora e geografia e invalidacao. O que precisa ir para a borda antes de mexer na app?
- [Card 11](./cards/11-geospatial-indexing-for-marketplace-search.md): o problema e candidatos proximos demais para testar um por um. Qual pre-filtro espacial entra antes do ranking fino?
- [Card 12](./cards/12-distributed-ids-and-ordering-guarantees.md): serial central nao escala e UUID puro mata ordenacao. Qual compromisso o chapter defende?
- [Card 13](./cards/13-realtime-concurrency-and-workload-isolation.md): conexoes realtime e trabalho pesado estao brigando pelo mesmo runtime. O que precisa ser isolado?
- [Card 14](./cards/14-feed-ranking-and-fanout-trade-offs.md): fanout explodiu ou ranking ficou cego. Qual separacao o chapter faz para segurar custo e relevancia?

## Done When

- seu ultimo contato do dia foi com `problema -> decisao -> trade-off`
- voce lembrou pelo `Cue Signal`, nao pelo titulo do chapter
- amanha cedo o card ainda parece familiar sem releitura longa
