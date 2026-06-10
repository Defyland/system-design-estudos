# Engine de Simulacao

Engine Ruby sem dependencias que transforma os labs numericos em algo que voce
roda e ajusta, em vez de so ler. Cada modelo recebe parametros `k=v` e imprime o
trade-off que o lab descreve.

## Uso

```bash
ruby simulation-labs/sim/run.rb --list
ruby simulation-labs/sim/run.rb cache hit_rate=0.8 origin_ms=60
ruby simulation-labs/sim/run.rb consumer-lag produce_rps=1500 consumers=3

# via Rakefile
rake simulate:list
rake 'simulate[cache]' ARGS="hit_rate=0.8 origin_ms=60"
```

## Modelos

| Modelo | Lab | Trade-off |
| --- | --- | --- |
| `cache` | [Cache](../cache.md) | hit rate vs latencia, carga na origem e janela de stale |
| `consumer-lag` (`event-backbone-consumer-lag`) | [Event Backbone / Consumer Lag](../event-backbone-consumer-lag.md) | produzir vs consumir e crescimento de lag |
| `fanout` (`fanout-feed-ranking-cost`) | [Fanout / Feed Ranking Cost](../fanout-feed-ranking-cost.md) | fanout-on-write vs fanout-on-read |
| `rate-limit` (`rate-limit-vs-load-shedding`) | [Rate Limit vs Load Shedding](../rate-limit-vs-load-shedding.md) | rate limit vs load shedding sob overload |

Os demais labs do diretorio sao drills procedurais (rollout, failover, ACL cutover)
sem um modelo numerico unico; eles continuam como roteiro guiado.

## CI

`ruby simulation-labs/sim/run.rb --selftest` roda todos os modelos com os defaults e
falha se algum nao produzir saida finita. O workflow `curriculum` executa esse selftest.
