# Lab - Chapter 03

## Chapter

- [Back to Chapter 03](../../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Use this snippet](../../areas/03-filas-e-consistencia/snippets/rails-idempotency-key-for-mutating-endpoints.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: o que o produto precisa garantir primeiro: resposta rapida ou efeito unico?
- `Delete`: qual retry ou efeito duplicado voce removeria antes de complicar o fluxo?
- `Simplify`: qual versao minima de idempotencia em Rails resolve o problema hoje?
- `Accelerate`: como voce reproduz commit feito com resposta perdida em poucos minutos?
- `Automate Last`: o que ainda nao merece replay e reconciliacao automatica?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modelem um `POST /orders` Rails com `Idempotency-Key`
- simulem a falha chata: commit feito, resposta perdida
- repitam a mesma request com a mesma chave e confirmem o mesmo `status` e o mesmo `body`
- repitam a mesma chave com payload diferente e confirmem conflito
- decidam qual TTL faz sentido para esse produto e defendam o por que

## Gabarito Oral Imediato

- `Resposta curta`: mesma chave e mesmo payload devolvem exatamente a primeira resposta canonica.
- `Resposta curta`: mesma chave com payload diferente vira conflito, porque mudou a intencao da operacao.
- `Resposta curta`: TTL deve cobrir a janela real de retry do produto, nao um numero magico aleatorio.
- `Armadilha`: "um indice unico ja cobre esse caso". Nao. Ele nao devolve replay de resposta nem conversa bem com integracao externa.
