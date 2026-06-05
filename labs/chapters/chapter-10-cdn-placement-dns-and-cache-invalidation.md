# Lab - Chapter 10

## Chapter

- [Back to Chapter 10](../../chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: qual conteudo realmente merece borda e qual continua local?
- `Delete`: que camada de cache ou purge voce cortaria primeiro?
- `Simplify`: qual e o menor uso de CDN que entrega valor real agora?
- `Accelerate`: como voce mediria hit ratio, staleness e rollback de TTL?
- `Automate Last`: o que ainda nao merece steering ou invalidacao automatica?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- modele tres objetos para um produto pequeno: asset imutavel, pagina editorial e resposta publica de API;
- defina TTL de browser, TTL de CDN e quando voce usaria versionamento, `stale-while-revalidate` ou purge;
- adicione um caso de pico geografico ou campanha e diga se roteamento por regiao realmente mudaria a experiencia;
- diga qual erro seria pior neste contexto: miss demais ou servir conteudo velho, e por que.

## Gabarito Oral Imediato

- `Resposta curta`: asset imutavel pede fingerprint e TTL longo; pagina editorial costuma pedir TTL curto ou purge cirurgico; API publica depende da tolerancia a stale.
- `Resposta curta`: `stale-while-revalidate` ajuda quando stale curto e melhor do que miss frequente.
- `Resposta curta`: georouting so vale se a geografia realmente mexe em latencia, custo ou disponibilidade.
- `Armadilha`: "um TTL serve para browser, CDN e todo o resto". Nao. Cada camada enxerga um risco diferente.
