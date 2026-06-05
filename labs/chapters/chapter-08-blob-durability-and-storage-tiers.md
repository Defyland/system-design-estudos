# Lab - Chapter 08

## Chapter

- [Back to Chapter 08](../../chapters/chapter-08-blob-durability-and-storage-tiers.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: este produto precisa mesmo de blob store dedicado agora?
- `Delete`: qual copia, tier ou uso do banco para bytes voce removeria primeiro?
- `Simplify`: qual divisao minima entre metadata e blob resolve o caso?
- `Accelerate`: como voce testaria restore e lifecycle cedo?
- `Automate Last`: o que ainda nao merece movimentacao automatica entre tiers?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modelem um upload Rails com metadata no banco e blob em um bucket quente, depois decidam quando o arquivo vira candidato a cold tier
- expliquem como validar a migracao antes de apagar a copia quente
- digam qual trade-off de custo, latencia de restore ou durabilidade esse experimento deve deixar visivel

## Gabarito Oral Imediato

- `Resposta curta`: metadata e ownership ficam no banco; o arquivo pesado vai para object storage quente.
- `Resposta curta`: o blob so vira frio quando o padrao de leitura caiu e o produto tolera restore mais lento.
- `Resposta curta`: antes de apagar a copia quente, valide checksum, restore de amostra e estado da migracao.
- `Armadilha`: "arquivo antigo sempre vai para frio". Nao. Antigo e frio nao sao sinonimos.
