# Lab - Chapter 09

## Chapter

- [Back to Chapter 09](../../chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modele um chat pequeno em Rails com um room normal e um room quente;
- decida qual estado fica no Postgres, qual fica no Redis e qual fila separa fanout normal de fanout pesado;
- force o caso ruim: o room quente explode de mensagens e presence; explique como o sistema protege os outros rooms;
- diga qual metrica faria voce sair de `ActionCable` puro e extrair o realtime para um boundary proprio.

## Gabarito Oral Imediato

- `Resposta curta`: mensagem duravel costuma ficar no Postgres; presence e fanout rapido vivem melhor em Redis ou memoria especializada.
- `Resposta curta`: room quente precisa de fila ou capacidade isolada para nao roubar ar dos rooms normais.
- `Resposta curta`: backlog de broadcast, p99 de entrega e pressao de presence mostram a hora de separar o workload realtime.
- `Armadilha`: "chat pequeno ja pede arquitetura de Discord". Nao. Primeiro isole o que esta quente de verdade.
