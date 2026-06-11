# Replica Lag - measured, not argued

Chapter: [01 - Relational Scaling and Operational Discipline](../../chapters/chapter-01-relational-scaling-and-operational-discipline.md)

Sobe um Postgres **primary + replica streaming efemero** (via `initdb` +
`pg_basebackup`, sem Docker), induz lag de replicacao e mede:

- a taxa de **read-after-write stale** (escreve no primary, le o mesmo id na replica na hora);
- a **distribuicao de lag** (`p50/p95/p99/max`) sob escrita continua;
- a **janela de stickiness** read-your-writes derivada do `p99` observado.

## Rodar

```bash
./run.sh                  # 300ms de apply delay induzido (demonstra o fenomeno)
APPLY_DELAY=0 ./run.sh    # piso natural, sem delay induzido
APPLY_DELAY=1s TRIALS=40 SAMPLES=120 ./run.sh
```

Precisa dos binarios de servidor do Postgres 14+ (`initdb`, `pg_ctl`,
`pg_basebackup`, `psql`). Aponte com `PGBIN=/caminho/para/pg/bin`. Tudo vive em um
tempdir e e derrubado no fim.

## Exemplo de saida observada

Nesta maquina (`40` trials, `120` amostras):

```
# apply_delay=300ms
read-after-write on the replica : 40/40 stale (100%)
replica apply lag (ms)          : p50=320.8  p95=428.0  p99=772.8  max=893.0

# apply_delay=0  (piso natural)
read-after-write on the replica : 40/40 stale (100%)
replica apply lag (ms)          : p50=22.9  p95=176.9  p99=310.3  max=494.6
```

## O que observar

- **Read-after-write contra a replica costuma ser 100% stale**, mesmo com lag
  "zero": a replicacao e assincrona, o primary confirma antes de a replica aplicar.
  O lag nao decide *se* ha stale; decide *por quanto tempo*.
- O `p99` do lag e o que dimensiona a janela de stickiness - meca no SEU ambiente
  (replica distante, carregada), nao herde uma constante chutada.
- Armadilha de medicao embutida no drill: `now() - pg_last_xact_replay_timestamp()`
  so vale enquanto ha escrita fluindo; em idle mede obsolescencia da metrica, nao
  lag. Por isso o writer roda durante toda a janela de amostragem.
