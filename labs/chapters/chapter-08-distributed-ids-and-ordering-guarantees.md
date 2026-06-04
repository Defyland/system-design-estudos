# Lab - Chapter 08

## Chapter

- [Back to Chapter 08](../../chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- desenhe um gerador Snowflake-like com `timestamp`, `worker_id` e `sequence`;
- escolha como `worker_id` sera distribuido e o que o sistema faz quando o clock anda para tras;
- compare o que seu ID garante para unicidade, rough ordering e o que ele definitivamente nao garante;
- gere registros concorrentes de duas maquinas e explique onde a ordenacao continua util e onde ela falha;
- o experimento testa se o produto realmente precisa de IDs distribuidos ordenaveis ou so de unicidade simples.

## Gabarito Oral Imediato

- `Resposta curta`: `worker_id` precisa ser distribuido de forma coordenada ou estavel, senao a unicidade fica fraca.
- `Resposta curta`: se o clock volta, o gerador deve esperar, falhar seguro ou entrar em modo controlado; nunca fingir que nada aconteceu.
- `Resposta curta`: o ID te da unicidade e uma ordem aproximada boa; nao uma linha do tempo perfeita do cluster.
- `Armadilha`: "se o ID cresce, posso ordenar eventos globais sem pensar". Nao. Entre maquinas, isso e so aproximacao.
