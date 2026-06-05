# Capstone 03 - Collaboration Search, Uploads and Realtime

## Pull Chapters

- [Chapter 08 - Blob Durability and Storage Tiers](../chapters/chapter-08-blob-durability-and-storage-tiers.md)
- [Chapter 09 - Search Indexing and Permission-Aware Retrieval](../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 13 - Realtime Concurrency and Workload Isolation](../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Chapter 10 - CDN Placement, DNS and Cache Invalidation](../chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)

## First Principles Pass Before Drawing

Responda em voz alta antes de desenhar qualquer caixa:

- `Requirement Less Dumb`: o que precisa ser realtime, buscavel e duravel agora, e o que ainda pode ser eventual?
- `Delete`: qual copia de blob, indexacao redundante ou evento ao vivo voce removeria primeiro?
- `Simplify`: qual desenho minimo separa upload, indexacao e colaboracao sem criar tres plataformas novas?
- `Accelerate`: que dashboards de index lag, backlog realtime e restore voce abriria cedo?
- `Automate Last`: o que ainda nao merece pipeline sofisticado ou autoscale agressivo?

## Interview Mode

Seu entrevistador pede: "desenhe um produto colaborativo com upload de arquivos, busca em documentos e notificacao realtime".

## Work Mode

Seu PO diz: "queremos documentos, busca rapida, comentarios ao vivo e boa experiencia global sem vazar permissao".

## Oral Route

1. separe metadata, blob e indice de busca
2. explique onde ACL entra na busca
3. diga qual parte do realtime fica efemera e qual precisa persistir
4. diga o que CDN protege e o que continua sendo cache interno
5. diga o que um room quente faria com a arquitetura
6. diga onde Elixir ensinaria mais do que Rails

## Good Answer Sounds Like

- blob pesado sai do banco e vai para object storage
- indexacao e assincrona e ACL entra cedo e tarde
- realtime precisa isolar fanout e presence quentes
- CDN ajuda asset e leitura publica; busca autorizada continua no app e no backend de search

## Production Twist

### Page

Voce recebe tres sintomas juntos: index lag disparou, backlog de websocket cresceu e restores de objetos frios ficaram lentos demais. O erro comum aqui e tratar tudo como um unico problema. Nao e. E um sistema com tres gargalos diferentes se contaminando.

### First Dashboard

- lag de indexacao e taxa de erro de ACL
- profundidade da fila de broadcast e p99 de entrega
- latencia de restore e falhas de checksum
- hit ratio de CDN e pressao no origin

### Immediate Mitigation

- degrade presence e sinais nao criticos
- force fallback de busca ou reduza a promessa de frescor
- pause mudancas de lifecycle se cold restore estiver travando a experiencia

### Rollback or Hold

Rollback da mudanca que disparou backlog ou do novo caminho de indexacao. Hold em reindex global ou purge em massa ate o origin e as filas respirarem de novo.

### What Not to Change Mid-Incident

- nao rode reindex total por reflexo
- nao faca purge global de cache
- nao misture tuning de realtime com mudanca de ACL

## Trap

- "Elastic, S3 e WebSocket juntos ja resolvem o produto"
