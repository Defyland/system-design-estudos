# Lab - Chapter 05

## Chapter

- [Back to Chapter 05](../../chapters/chapter-05-durable-workflows-retries-and-compensation.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: esse processo precisa mesmo de estado duravel ao longo do tempo?
- `Delete`: qual passo ou compensacao voce cortaria para revelar o fluxo real?
- `Simplify`: qual e a forma minima de coordenar isso antes de engine dedicada?
- `Accelerate`: como voce testaria timeout, retry e compensacao hoje?
- `Automate Last`: o que ainda nao merece auto-recovery?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modele um fluxo com tres passos: cobranca, dependencia externa e entrega final;
- decida qual estado precisa sobreviver a crash, qual retry muda por etapa e qual timeout vira falha permanente;
- diga qual compensation explicita voce usaria para o primeiro efeito externo irreversivel;
- simule a falha chata: passo 2 falha depois do passo 1 ter dado certo, e explique de onde o fluxo retoma;
- o experimento testa se jobs encadeados ainda bastam ou se o processo ja pede workflow duravel.

## Gabarito Oral Imediato

- `Resposta curta`: o estado que precisa sobreviver e o da fronteira entre passos, principalmente depois do primeiro efeito externo.
- `Resposta curta`: retry e timeout mudam por dependencia, nao por capricho global.
- `Resposta curta`: se o passo 1 deixou rastro irreversivel, a compensation nasce ali, nao no fim da historia.
- `Armadilha`: "se falhar no meio, eu recomeco tudo". Nao. Workflow duravel existe justamente para retomar do estado certo.
