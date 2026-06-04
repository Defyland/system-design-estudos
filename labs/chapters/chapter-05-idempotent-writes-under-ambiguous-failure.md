# Lab - Chapter 05

## Chapter

- [Back to Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Use this snippet](../../areas/03-filas-e-consistencia/snippets/rails-idempotency-key-for-mutating-endpoints.md)

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
