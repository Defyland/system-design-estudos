# Lab - Chapter 14

## Chapter

- [Back to Chapter 14](../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: a cronologia ja falhou para o produto ou voce esta pulando para ranking cedo demais?
- `Delete`: qual fonte de candidato ou sinal caro voce removeria primeiro?
- `Simplify`: qual e a menor forma de misturar fanout e ordenacao com valor real?
- `Accelerate`: como voce mediria qualidade, frescor e latencia cedo?
- `Automate Last`: o que ainda nao merece pipeline pesado de ML?

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
