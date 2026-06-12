# Rate Limiting Algorithms and Keys

## When to Use

Use quando o problema ja saiu de "precisamos de rate limit?" e virou "qual limite governa o dano certo?". Isso aparece em login, busca, endpoints caros, APIs publicas e workloads multi-tenant em que a escolha de algoritmo e identidade muda quem sofre o bloqueio.

## What Breaks First

O erro inicial quase sempre e limitar por conveniencia. `IP` pune NAT corporativo, `fixed window` deixa burst feio na virada da janela, `token bucket` nao resolve job caro em voo e um contador central ruim vira hot key ou latencia extra no caminho critico.

## Design Moves

- comece pelo dano, nao pelo nome do algoritmo: brute force, burst de leitura, endpoint caro ou dependencia saturada pedem politicas diferentes;
- escolha a chave que representa o blast radius real: `user_id`, `api_key`, `tenant_id`, `route`, `resource_id` ou combinacao deles;
- use `fixed window` para cap bruto, previsivel e barato, especialmente em login ou quota simples;
- use `sliding window` ou `floating window` quando fairness importa mais do que reset previsivel;
- use `token bucket` quando burst curto e aceitavel, mas a media de longo prazo precisa ficar sob controle;
- use `concurrency gate` quando o dano mora em requests em voo, workers ou conexoes presas, nao em contagem por minuto;
- escolha `fail open` ou `fail closed` por rota, nao como dogma global; disponibilidade e protecao nao pesam igual em login e em export interno.

## Interview Trap

Responder "token bucket" ou "rate limit por IP" sem dizer qual identidade esta sendo protegida, qual burst e aceitavel e onde mora o recurso caro.

## Practice Drill

Para `POST /sessions`, `GET /api/search`, `POST /api/exports` e `POST /webhooks/provider`, fale em voz alta:
1. qual chave representa o dano certo;
2. qual algoritmo faz mais sentido;
3. se a rota deveria `fail open` ou `fail closed`;
4. quando voce trocaria contagem por concorrencia.

## Source Anchor

- Smudge, [Visualizing algorithms for rate limiting](https://smudge.ai/blog/ratelimit-algorithms).
- Smudge, [Making a custom redis command for rate limiting](https://smudge.ai/blog/ratelimit).
