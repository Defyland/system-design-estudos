# bench/ - Empirical drills

O resto do repo argumenta a partir de primeiros principios. Aqui voce **mede,
quebra e observa** - porque "eu sei argumentar o que vai acontecer" nao e o mesmo
que "eu medi o que acontece, e onde meu argumento estava errado".

Cada drill pareia uma afirmacao dedutiva de um chapter com um experimento que
tenta **falsifica-la ou quantifica-la**, no ciclo:

`Predict -> Measure/Break -> Observe -> Reconcile`

## Drills

- [replica-lag](./replica-lag/README.md) - Chapter 01. Sobe um Postgres primary +
  replica streaming efemero (sem Docker), induz lag, mede a distribuicao e a taxa
  de read-after-write stale; voce deriva a janela de stickiness do p99 observado.

## Regras

- **Opt-in.** O `bench/` fica fora do contrato do `curriculum.yml` e do validador:
  nada aqui e obrigatorio para "passar". O nucleo dedutivo (chapters, reviews)
  continua leve.
- **Roda local.** Os drills precisam de servicos reais (Postgres etc.), entao nao
  rodam no CI - rodam na sua maquina, contra um sistema de verdade.
- **Numero + reconciliacao.** O entregavel de um drill nao e prosa: e um numero
  medido e a conversa honesta com o que o chapter prometeu.
