# Lab - Chapter 01

## Chapter

- [Back to Chapter 01](../../chapters/chapter-01-relational-scaling-and-operational-discipline.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: quais leituras precisam mesmo de frescor imediato e quais podem aceitar replica ou cache?
- `Delete`: qual query, dashboard ou contador voce tiraria do caminho da primary primeiro?
- `Simplify`: qual e a forma mais simples de aliviar o banco sem criar outro datastore agora?
- `Accelerate`: como voce mediria slow query, replica lag e rollback do read path hoje?
- `Automate Last`: o que voce so automatizaria depois de provar que o fluxo manual esta sob controle?

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
