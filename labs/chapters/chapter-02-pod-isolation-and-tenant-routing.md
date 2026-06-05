# Lab - Chapter 02

## Chapter

- [Back to Chapter 02](../../chapters/chapter-02-pod-isolation-and-tenant-routing.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: quais tenants pedem isolamento agora e quais ainda podem conviver?
- `Delete`: qual fluxo cross-tenant ou cross-pod voce tentaria cortar primeiro?
- `Simplify`: qual versao minima de roteamento por pod resolve o problema real?
- `Accelerate`: como voce ensaiaria move de tenant e rollback sem trauma?
- `Automate Last`: o que ainda nao merece rebalanceamento automatico?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modelem um SaaS multi-tenant pequeno com um tenant ruidoso e decidam onde o `pod_key` nasce, como ele entra em web requests e jobs, e qual dado pode continuar global
- expliquem um movimento simples de tenant entre pods sem downtime grande
- digam qual fluxo cross-pod voces proibiriam primeiro e por que

## Gabarito Oral Imediato

- `Resposta curta`: o `pod_key` nasce em um diretorio global minimo antes do primeiro acesso a dado e viaja em request e job.
- `Resposta curta`: a mudanca de tenant entre pods pede copia, catch-up e cutover pequeno; o app nao deveria descobrir isso no improviso.
- `Resposta curta`: o primeiro fluxo proibido costuma ser query ou job cross-pod no caminho critico.
- `Armadilha`: "da para descobrir o pod no meio da request". Nao. Isso e como deixar o trilho ser decidido depois que o trem ja saiu.
