# Lab - Chapter 04

## Chapter

- [Back to Chapter 04](../../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: voce precisa de replay e varios consumidores ou so de assincronia?
- `Delete`: qual evento voce eliminaria porque ainda e so chamada interna fantasiada?
- `Simplify`: fila simples, outbox ou backbone: qual e o menor desenho que entrega o caso?
- `Accelerate`: como voce mediria lag, schema break e throughput cedo?
- `Automate Last`: o que ainda nao merece auto-scale ou rebalancing?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modele um evento `order.confirmed.v1` com `event_id`, `aggregate_id`, `occurred_at` e payload versionado;
- escolha a chave de particionamento e defenda qual ordem ela preserva de verdade;
- desenhe dois consumidores independentes e diga como cada um lida com replay e deduplicacao;
- force um caso de skew ou catch-up e diga qual metrica mostraria que sua particao ficou errada;
- o experimento testa se voce precisa de backbone com replay multi-consumer ou se uma fila simples ainda basta.

## Gabarito Oral Imediato

- `Resposta curta`: a chave de particionamento costuma nascer no agregado sobre o qual a ordem importa, como `order_id`.
- `Resposta curta`: replay seguro pede consumidor idempotente, dedup e contrato claro de reprocessamento.
- `Resposta curta`: lag por particao, skew de throughput e catch-up infinito mostram particao ruim.
- `Armadilha`: "o backbone preserva ordem global". Nao. Ordem boa normalmente vive dentro da particao certa.
