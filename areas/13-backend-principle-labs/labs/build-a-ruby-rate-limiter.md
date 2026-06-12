# Build a Ruby Rate Limiter

## Objective

Implementar um limiter em Ruby que trate tres formas diferentes de dano: brute force em login, burst de leitura e tenant barulhento em endpoint caro.

## Setup

API pequena em Rails ou Rack, Redis disponivel para contadores compartilhados e pelo menos dois fluxos publicos com perfis diferentes de trafego.

## Tasks

- implemente um `fixed window` bruto para login por `IP` ou `device_id`, com `429` e `Retry-After`;
- implemente um limiter por `user_id` ou `api_key` com janela mais suave via Redis `ZSET` e `WATCH/MULTI`, sem Lua;
- modele um `tenant concurrency gate` para export, search pesada ou outro endpoint caro em que request em voo machuca mais do que request por minuto;
- decida por escrito quais rotas fazem `fail open` e quais justificam `fail closed`;
- escreva testes para virada de janela, NAT corporativo, burst legitimo e dois tenants competindo pelo mesmo recurso.

## Exit Criteria

Voce consegue mostrar por que login usa uma politica, busca usa outra e export precisa de concorrencia. O sistema devolve `429` de forma previsivel, preserva o tenant quieto e nao depende de contador em memoria local.

## Deliverable

Tabela `rota -> chave -> algoritmo -> fail mode`, snippet Ruby do limiter e lista de testes negativos obrigatorios.

## Linked Concepts

Rate limiting, fairness, Redis, Rack::Attack, concurrency gate, overload, noisy neighbor.
