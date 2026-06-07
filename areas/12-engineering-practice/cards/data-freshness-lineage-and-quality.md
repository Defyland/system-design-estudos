# Data Freshness, Lineage and Quality

## When to Use

Quando dashboards, features ou alertas dependem de dados que podem chegar atrasados, duplicados ou silenciosamente errados.

## What Breaks First

Metrica parece certa mas chega tarde, upstream muda sem aviso, e o time nao sabe de onde veio o numero que orientou uma decisao.

## Design Moves

Meça freshness explicitamente, registre lineage, aplique checks de qualidade no pipeline e declare quais datasets bloqueiam operacao ou experimentos.

## Interview Trap

Tratar data quality como problema de BI. Em plataforma moderna, ela afeta feature flags, fraude, ranking e resposta operacional.

## Practice Drill

Defina freshness, lineage e dois checks de qualidade para um dataset de pagamentos usado por financeiro e recomendacao.

## Source Anchor

- [OpenLineage Documentation](https://openlineage.io/docs/).
- [Great Expectations Documentation](https://docs.greatexpectations.io/docs/core/introduction/try_gx/).
