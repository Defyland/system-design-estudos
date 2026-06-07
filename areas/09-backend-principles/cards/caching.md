# Caching

## When to Use

Use cache quando uma leitura repetida ou cara pode aceitar dado derivado por um tempo controlado, com invalidacao ou TTL bem definido.

## What Breaks First

Cache sem freshness contract entrega dado velho em fluxo sensivel, mascara query ruim e cria miss storm quando todo mundo expira junto.

## Interview Trap

Responder "coloca Redis". Antes: o que pode ficar stale, por quanto tempo, quem invalida, e qual fallback protege o origin?

## Practice Drill

Escolha um dashboard. Defina chave, TTL, regra de invalidacao, dado que nao pode ser cacheado e metrica para desligar o cache.

## Source Anchor

- [13. Caching, the secret behind it all](https://www.youtube.com/watch?v=estH64OkwxU)
