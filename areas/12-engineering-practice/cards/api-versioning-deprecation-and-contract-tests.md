# API Versioning, Deprecation and Contract Tests

## When to Use

Quando clientes externos ou internos dependem da API e a mudanca nao pode assumir deploy coordenado.

## What Breaks First

Client antigo continua chamando shape removido, deprecacao existe so em texto e regressao so aparece no integrador mais lento.

## Design Moves

Declare politica de breaking change, deprecacao e sunset, publique contrato executavel e mantenha testes que representem clientes reais ou pactos minimos.

## Interview Trap

Responder com "coloca v2" sem falar de sunset, compatibilidade, custo de suporte e rollout dos consumidores.

## Practice Drill

Planeje a remocao de um campo de resposta usado por parceiros. Defina aviso, sunset, fallback, teste de contrato e metrica para desligar.

## Source Anchor

- [Stripe API versioning](https://docs.stripe.com/api/versioning).
- [Pact Documentation](https://docs.pact.io/).
