# Lab - Chapter 02

## Chapter

- [Back to Chapter 02](../../chapters/chapter-02-relational-scaling-and-operational-discipline.md)

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- use o snippet [Rails Read/Write Split and Cache Aside](../../areas/02-dados-e-armazenamento/snippets/rails-read-write-split-and-cache-aside.md) como ponto de partida;
- modele um endpoint de leitura quente e um endpoint de update para um SaaS B2B pequeno;
- decida quais reads podem ir para replica, quais precisam ficar sticky na primary por alguns segundos e quais cache keys voce invalida no write;
- diga qual metrica faria voce desligar leitura por replica hoje mesmo.

## Gabarito Oral Imediato

- `Resposta curta`: lista, dashboard e leitura repetida costumam aceitar replica; leitura logo apos write sensivel costuma ficar grudada na primary por alguns segundos.
- `Resposta curta`: invalide a chave do summary ou contador que depende diretamente do write, nao o cache do sistema inteiro.
- `Resposta curta`: desligue leitura por replica se o lag comecar a quebrar a semantica que o usuario percebe.
- `Armadilha`: "todo GET vai para replica". Nao. Consistencia tambem faz parte do contrato da leitura.
