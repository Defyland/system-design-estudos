# Search Indexing and Relevance

## Case Pattern

Busca em escala exige separar escrita canonica de indice derivado. As decisoes importantes sao shard key, estrategia de reindex, permissoes, frescor, relevancia, fanout de query e isolamento de outliers.

## When to Use

- Queries relacionais nao sustentam busca textual, filtros e ranking.
- Objetos precisam ser buscados por usuario, grupo, permissao ou semantica.
- Indice precisa migrar sem parar novas escritas.
- Alguns tenants ou comunidades sao grandes o bastante para exigir tratamento dedicado.

## What Breaks First

Fila de indexacao perde mensagens, bulk indexing amplifica falha de um node, query fanout cresce com shards, permissao fica desatualizada no indice ou reindex bloqueia escrita nova.

## Interview Trap

Responder "usa Elasticsearch" sem explicar origem canonica, index lag, replay, shard strategy, autorizacao e plano de reindex.

## Practice Drill

Projete busca de mensagens para workspace pequeno e workspace gigante. Escolha shard key, fluxo de indexacao, estrategia de reindex, filtro de permissao e metrica de freshness.

## Source Anchor

- Discord, [How Discord Indexes Trillions of Messages](https://discord.com/blog/how-discord-indexes-trillions-of-messages).
- Discord, [How Discord Indexes Billions of Messages](https://discord.com/blog/how-discord-indexes-billions-of-messages).
- Figma, [The Infrastructure Behind AI Search in Figma](https://www.figma.com/blog/the-infrastructure-behind-ai-search-in-figma/).
- GitHub, [How we rebuilt the search architecture for high availability in GitHub Enterprise Server](https://github.blog/engineering/architecture-optimization/how-we-rebuilt-the-search-architecture-for-high-availability-in-github-enterprise-server/).
