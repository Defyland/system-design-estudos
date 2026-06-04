# Lab - Chapter 14

## Chapter

- [Back to Chapter 14](../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- desenhem um feed pequeno em que cronologia pura ja nao basta
- decidam quais produtores entram em fanout-on-write e qual tipo de produtor ficaria fora desse caminho
- escolham no maximo quatro sinais para um ranking inicial no read path
- definam um `pass0` de candidatos antes do ranking final e defendam o corte
- digam o que o experimento precisa testar primeiro: latencia, frescor ou qualidade percebida do feed

## Gabarito Oral Imediato

- `Resposta curta`: produtores comuns podem ir para fanout-on-write; produtores gigantes costumam pedir tratamento diferente para nao explodir escrita.
- `Resposta curta`: ranking inicial simples ja pode usar recencia, relacao, engajamento e diversidade.
- `Resposta curta`: o `pass0` existe para nao gastar score caro em candidato demais.
- `Armadilha`: "se o feed precisa de relevancia, eu faco fanout para todo mundo". Nao. Fanout ajuda inventario; nao resolve custo e frescor sozinho.
