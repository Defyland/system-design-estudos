# Production Migrations and Backfills

## Case Pattern

Use migracoes incrementais quando o dado ou schema precisa mudar sem congelar produto. O padrao recorrente e separar mudanca estrutural, backfill, dual write/read, comparacao sombra, cutover e cleanup.

## When to Use

- Alterar tabela quente, indice grande, storage engine ou datastore.
- Trocar caminho de leitura sem perder escrita recente.
- Migrar historico grande com trafego online ativo.
- Reduzir risco de lock, lag, downtime ou rollback impossivel.

## What Breaks First

O backfill compete com producao, a replicacao atrasa, leituras antigas e novas divergem, o cleanup fica esquecido ou o cutover depende de uma janela heroica.

## Interview Trap

Responder "faz uma migration" sem falar de dual write, validacao de consistencia, throttling, rollback, cutover e remocao do caminho antigo.

## Practice Drill

Desenhe a migracao de `orders.status` string para tabela normalizada. Inclua: expand schema, escrita dupla, backfill paginado, leitura sombra, metrica de divergencia, cutover gradual e cleanup.

## Source Anchor

- GitHub, [gh-ost: GitHub's online schema migration tool for MySQL](https://github.blog/news-insights/company-news/gh-ost-github-s-online-migration-tool-for-mysql/).
- Discord, [How Discord Stores Trillions of Messages](https://discord.com/blog/how-discord-stores-trillions-of-messages).
- Airbnb, [Building a next-generation key-value store at Airbnb](https://medium.com/airbnb-engineering/building-a-next-generation-key-value-store-at-airbnb-0de8465ba354).
