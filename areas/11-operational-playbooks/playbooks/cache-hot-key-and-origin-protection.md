# Cache Hot Key and Origin Protection

## Trigger

Uma chave quente, invalidacao em massa ou queda parcial de cache derruba o origin e espalha latencia.

## Signals

- miss rate subindo rapido;
- origin QPS muito acima do normal;
- poucos objetos respondendo pela maior parte do trafego;
- saturacao de CPU ou conexoes na camada de origem.

## Immediate Actions

- identificar chaves e paths quentes;
- aplicar rate limit, stale serve ou request coalescing;
- suspender invalidacoes amplas;
- proteger origin antes de discutir tuning fino.

## Stabilize

Stale-if-error, stale-while-revalidate, TTL temporario mais longo, warming dirigido, single flight e shed load para endpoints nao criticos.

## Deep Checks

Padrao de invalidação, cardinalidade de chave, tenant skew, cache fragmentation, comportamento do client e ausencia de negative caching.

## Exit Criteria

Origin de volta a headroom segura, miss rate estabilizada, hot keys mapeadas e mudanca estrutural planejada para evitar recorrencia.

## Practice Drill

Desenhe a resposta para uma home page com 90% do trafego concentrado em 5 chaves e origem saturando depois de um deploy de invalidacao.

## Source Anchor

- [Google Cloud CDN - Serve stale content](https://cloud.google.com/cdn/docs/serving-stale-content).
- [Redis - Identifying Issues: Hot Keys](https://redis.io/learn/howtos/antipatterns#hot-keys).
