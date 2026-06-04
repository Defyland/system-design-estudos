# Notes

## Ida e Volta

- [Chapter 01 - Pod Isolation and Tenant Routing](../../chapters/chapter-01-pod-isolation-and-tenant-routing.md)
- [Chapter 02 - Relational Scaling and Operational Discipline](../../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 03 - Blob Durability and Storage Tiers](../../chapters/chapter-03-blob-durability-and-storage-tiers.md)
- [Chapter 04 - Search Indexing and Permission-Aware Retrieval](../../chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 08 - Distributed IDs and Ordering Guarantees](../../chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)
- [Chapter 12 - Geospatial Indexing for Marketplace Search](../../chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)
- [Example - Smaller SaaS Read/Write and Cache](./examples/smaller-saas-read-write-and-cache.md)
- [Snippet - Rails Read/Write Split and Cache Aside](./snippets/rails-read-write-split-and-cache-aside.md)
- [Lab - Chapter 02](../../labs/chapters/chapter-02-relational-scaling-and-operational-discipline.md)

## Modelos Mentais

- `relacional e coordenacao`: use SQL quando regra de negocio atravessa varias entidades e inconsistencia custa mais do que alguns milissegundos.
- `replica compra leitura, nao inocencia`: se a escrita esta ruim, a replica so espalha a dor com mais hosts.
- `cache e derivacao`: cache bom guarda respostas repetitivas; verdade continua no banco.
- `upgrade e parte da arquitetura`: se atualizar banco ou framework virou evento traumatico, a disciplina operacional ja esta atrasada.
- `isole pelo blast radius`: shard, pod ou tenant split so valem quando um hot tenant ou uma falha local ameacam muita coisa ao redor.

## Matriz de Decisao

| Sinal observado | Melhor movimento | Evite |
| --- | --- | --- |
| dashboards, listas e counters concentram a leitura | cache-aside e replica para reads tolerantes a lag | trocar de banco cedo demais |
| read-after-write importa no fluxo | manter janela sticky na primary | mandar tudo para replica por padrao |
| um tenant quente atrapalha varios outros | isolar por tenant, shard ou pod | microservicos como reflexo |
| upgrades e migrations estao virando medo organizacional | rollout gradual, CI com versoes mistas, rollback claro | congelar stack por meses |
| joins e transacoes seguem no centro do dominio | insistir no relacional com mais disciplina | inventar NoSQL por moda |
| shape do dado muda toda semana e relacoes sao fracas | reavaliar o store certo para esse subdominio | forcar joins onde nao ha ganho |

## Empresa Menor vs Empresa Maior

| Tema | Empresa menor | Empresa maior |
| --- | --- | --- |
| objetivo principal | manter um banco unico previsivel | manter varios clusters previsiveis |
| leitura | uma replica opcional e poucos caches quentes | fleets de replicas, budgets de lag e roteamento mais fino |
| escrita | indices, batches e queries saudaveis | topologia, shard balancing e tenant movement |
| mudanca segura | migrations pequenas e reversiveis | rollout por etapas, versoes mistas, rollback por cluster |
| operacao | runbook curto e visibilidade basica | observabilidade forte, automacao e ownership claro |

Empresa menor quase nunca precisa copiar a topologia de GitHub ou Shopify. Precisa copiar o criterio: primeiro sanidade no caminho feliz, depois mecanismos para throughput, e so depois isolamento estrutural.

## Casos Reais Estudados

- GitHub mostra que um monolito Rails pode continuar produtivo com upgrades frequentes, CI disciplinado e topologia de replicas bem operada ([Building GitHub with Ruby and Rails](https://github.blog/engineering/architecture-optimization/building-github-with-ruby-and-rails/), [Upgrading GitHub.com to MySQL 8.0](https://github.blog/engineering/infrastructure/upgrading-github-com-to-mysql-8-0/)).
- Shopify mostra o limite da escala vertical, a necessidade de isolar shards em pods e o cuidado para continuar no monolito enquanto a extracao de servicos ainda nao se paga ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale), [Under Deconstruction: The State of Shopify's Monolith](https://shopify.engineering/shopify-monolith), [Shard Balancing: Moving Shops Confidently with Zero-Downtime at Terabyte-scale](https://shopify.engineering/mysql-database-shard-balancing-terabyte-scale)).

## Ideias de Implementacao em Rails

- usar `ActiveRecord::Base.connected_to` para distinguir `:writing` e `:reading`;
- manter uma janela curta de stickiness na primary depois de writes sensiveis;
- aplicar cache-aside em summaries, listas e counters, nunca em comandos;
- versionar cache keys por tenant e por shape de payload;
- tratar migration segura, `EXPLAIN`, slow query e observabilidade como parte do codigo, nao do posfacio.

## Quando Comparar com Elixir ou Go

- Elixir entra bem quando o problema novo e coordenacao concorrente, filas, fan-out ou job orchestration; a decisao de consistencia continua a mesma.
- Go entra bem em componentes pequenos, read-only, de alto throughput, ou em ferramentas operacionais de movimentacao e rebalancing; de novo, a semantica dos dados nao muda.
- Se trocar de linguagem parece mais facil do que olhar query plan, o problema ainda e de dados.

## Voltar ao Chapter

- [Back to Chapter 02](../../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
