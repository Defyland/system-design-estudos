# Capstone 03 - Collaboration Search, Uploads and Realtime

## Pull Chapters

- [Chapter 03 - Blob Durability and Storage Tiers](../chapters/chapter-03-blob-durability-and-storage-tiers.md)
- [Chapter 04 - Search Indexing and Permission-Aware Retrieval](../chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 09 - Realtime Concurrency and Workload Isolation](../chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)
- [Chapter 11 - CDN Placement, DNS and Cache Invalidation](../chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)

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

## Trap

- "Elastic, S3 e WebSocket juntos ja resolvem o produto"
