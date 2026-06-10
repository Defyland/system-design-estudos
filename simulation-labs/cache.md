# Simulation Lab - Cache

## Scenario

Um dashboard de tenant grande recarrega a mesma consulta centenas de vezes por minuto.

## Controls

- hit rate
- TTL
- origin latency
- invalidation quality

## Run It

```bash
rake 'simulate[cache]'                                  # defaults
rake 'simulate[cache]' ARGS="hit_rate=0.8 origin_ms=60"
```

Mexa em `hit_rate`, `origin_ms`, `cache_ms`, `rps` e `ttl_s` e observe a latencia efetiva,
o RPS que sobra para a origem e a janela de stale. Engine: [sim/run.rb](./sim/run.rb).

## What Changes

Hit rate alto reduz latencia e carga na origem. TTL longo aumenta risco de stale.

## Failure Mode

Purge ruim ou miss storm joga tudo de volta para o banco.

## Cost Signal

Cache economiza origem, mas cobra memoria e disciplina de invalidacao.

## Interview Takeaway

Cache bom tem contrato de frescor. Cache sem contrato e bug intermitente.

## Linked Chapters

- [Chapter 01](../chapters/chapter-01-relational-scaling-and-operational-discipline.md)
- [Chapter 10](../chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)

## Linked Areas

- [Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)

## Mastery Checks

- `Pergunta`: quando cache e replica competem, qual pergunta vem primeiro?
- `Resposta com as suas palavras`: eu pergunto qual frescor a leitura precisa.
- `Resposta ruim que parece boa`: cache e sempre mais rapido.
- `Troque por isto`: rapidez sem semantica de stale e troca de problema.

