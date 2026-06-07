# Postgres Databases

## When to Use

Use Postgres para dados relacionais com integridade, constraints, transacoes, indices e queries expressivas antes de buscar datastores mais exoticos.

## What Breaks First

Sem constraints e indices corretos, o app vira o unico guardiao de invariantes e a query lenta vira incidente de produto.

## Interview Trap

Falar "database" sem falar transacao, isolamento, indice, cardinalidade, migration e constraint. Banco tambem e contrato.

## Practice Drill

Modele `orders` e `payments`: chaves, foreign keys, unique constraints, status enum, indice para listagem por cliente e transacao de criacao.

## Source Anchor

- [12. Mastering Databases with Postgres](https://www.youtube.com/watch?v=F7Vwp2Xo5Do)
