# Chapter 04 - System Design Canonical Problems

## Slice

Como responder os sistemas que mais reaparecem em entrevista sem decorar diagrama pronto e sem ignorar o que quebra primeiro.

## Study Context

- `Track order`: `04/06` - problemas canonicos e respostas de partida
- `Upstream principal`: [Hello Interview - How I'd Prepare for System Design Interviews](https://www.hellointerview.com/blog/how-id-prepare)
- `Upstream complementar`: [System Design Primer](https://github.com/donnemartin/system-design-primer)
- `Topicos locais`: [Caching](../../../09-backend-principles/cards/caching.md), [Realtime Backend Systems](../../../09-backend-principles/cards/realtime-backend-systems.md), [Object Storage and Large Files](../../../09-backend-principles/cards/object-storage-large-files.md), [Task Queues and Background Jobs](../../../09-backend-principles/cards/task-queues-background-jobs.md)
- `Casos ponte`: [Meta - News Feed Ranking](../../../../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md), [Dropbox - Nautilus Search](../../../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md), [Uber - H3 Geospatial Marketplace](../../../../real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
- `Review card`: [Card 04](../reviews/cards/04-system-design-canonical-problems.md)

## Why This Matters In Interviews

As perguntas mudam de nome, mas os eixos se repetem:
- lookup rapido
- fanout
- ordering
- retry
- hot key
- throughput assimetrico entre leitura e escrita

## The Canonical Pack

### 1. URL Shortener

- `Core`: criar short URL e redirecionar rapido
- `Comeco forte`:
  - API simples
  - tabela `links`
  - codigo curto com unique index
  - cache `code -> long_url`
- `Primeiro gargalo`: lookup quente e colisao de codigo
- `Follow-ups`:
  - custom alias
  - expiracao
  - analytics async
  - abuso / malware
- `Rails angle`:
  - Postgres + unique index
  - `Rails.cache.fetch`
  - job para analytics

### 2. Rate Limiter

- `Core`: permitir ou negar request por chave
- `Comeco forte`:
  - escolha explicita do algoritmo
  - token bucket ou sliding window counter
  - estado central em Redis ou store atomica
- `Primeiro gargalo`: concorrencia e burst na borda
- `Follow-ups`:
  - por IP vs usuario vs API key
  - multiplas regioes
  - headers `Retry-After`
- `Rails angle`:
  - middleware Rack
  - decisao de usar Redis em vez de inventar limiter no banco

### 3. News Feed

- `Core`: usuario ve posts relevantes das contas seguidas
- `Comeco forte`:
  - separar write path do read path
  - discutir `fanout on write`, `fanout on read` ou hibrido
  - paginacao por cursor
- `Primeiro gargalo`: celebridade com muitos followers
- `Follow-ups`:
  - ranking
  - delete / tombstone
  - consistency eventual
  - block / mute
- `Caso local`: [Meta - News Feed Ranking](../../../../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)

### 4. Chat / Messaging

- `Core`: enviar, persistir e entregar mensagem quase em tempo real
- `Comeco forte`:
  - WebSocket para online
  - push notification para offline
  - sequence por conversa, nao ordering global
- `Primeiro gargalo`: ordering, duplicidade e presence
- `Follow-ups`:
  - idempotency por `client_message_id`
  - grupos
  - receipts
  - reconexao
- `Rails angle`:
  - Action Cable ou gateway dedicado
  - persistir antes do ack

### 5. Notification System

- `Core`: fanout por email, push, SMS ou in-app
- `Comeco forte`:
  - request entra, persiste, vai para fila
  - workers por canal
  - preferencia do usuario antes do provider
- `Primeiro gargalo`: retries que duplicam entrega
- `Follow-ups`:
  - fallback de provider
  - rate limit
  - dedupe
  - DLQ

### 6. File Upload / Dropbox-like

- `Core`: upload/download de arquivo grande com metadata
- `Comeco forte`:
  - metadata no app
  - upload direto para object storage
  - pre-signed URL
  - worker para scan / preview
- `Primeiro gargalo`: arquivo grande no app server
- `Follow-ups`:
  - multipart upload
  - versionamento
  - permissionamento
  - CDN
- `Caso local`: [Dropbox - Nautilus Search](../../../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md) ajuda na parte de metadata e retrieval

### 7. Autocomplete / Search

- `Core`: sugerir rapido para prefixo ou consulta curta
- `Comeco forte`:
  - cache para prefixos quentes
  - indice proprio ou trie se o escopo for simples
  - ranking separado da busca bruta
- `Primeiro gargalo`: memoria e freshness
- `Follow-ups`:
  - typo tolerance
  - ACL
  - ranking global vs personalizado
- `Caso local`: [Dropbox - Nautilus Search](../../../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)

### 8. Distributed Job Queue

- `Core`: enqueue, claim, retry, timeout e DLQ
- `Comeco forte`:
  - delivery at-least-once
  - worker idempotente
  - visibility timeout
  - lock curto
- `Primeiro gargalo`: jobs travados e replay inseguro
- `Follow-ups`:
  - prioridade
  - schedule
  - dedupe
  - poison message
- `Rails angle`:
  - Active Job com backend adequado
  - idempotencia antes de retry

## How To Answer Without Overbuilding

Para qualquer sistema acima:

1. diga o caminho principal
2. diga a primeira storage decision
3. diga o primeiro mecanismo de scale
4. diga o que quebra primeiro
5. diga o que mudaria em `10x`

Se voce pula do item `1` para "multiregion, microservices, Kafka", a resposta perde credibilidade.

## Interview Compression

- `15 segundos`: URL shortener, rate limiter, feed, chat, notificacao, upload, autocomplete e job queue cobrem quase todas as families classicas.
- `15 segundos`: toda boa resposta precisa de caminho principal, storage, cache/fila quando couber e gargalo inicial.
- `1 minuto`: o entrevistador quer ver trade-off, nao souvenir de arquitetura.

## Decision Synthesis

### Use When

- voce quer repertorio de problemas classicos
- precisa saber por onde comecar em cada familia
- quer conectar system design a implementacao real

### Why This Matters

- as perguntas abertas quase sempre caem nessas familias
- a maioria dos follow-ups testa o primeiro gargalo ignorado
- caso real ajuda a nao soar academico

### Main Trade-offs

- simplificar demais pode ignorar ordering ou consistency critica
- sofisticar demais cedo demais mata clareza
- tecnologia sem motivo enfraquece a resposta

### Warning Signs

- voce nao escolhe algoritmo de rate limit
- feed sem discutir fanout
- chat sem discutir ordering
- upload grande passando pelo app server
- queue sem idempotencia

## Production Recall

- `Pergunta`: quais problemas de system design mais comprimem o 80/20 de entrevistas?
- `Resposta com as suas palavras`: URL shortener, rate limiter, news feed, chat, notification system, file upload, autocomplete e distributed job queue.
- `Resposta ruim`: cada entrevista pede um sistema completamente diferente.
- `Troque por isto`: os componentes e follow-ups se repetem; muda mais o trade-off do que a lista de blocos.

## Design Pass Recall

- `Pergunta`: qual pergunta voce deve fazer cedo em quase todo problema canonico?
- `Resposta curta`: o que quebra primeiro neste desenho simples?
- `Armadilha`: partir direto para a arquitetura final mais sofisticada.
- `Correcao`: boa entrevista mede julgamento de evolucao e falha, nao so o diagrama final.
