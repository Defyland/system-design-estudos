# Metodo de Estudo Orientado por Casos Reais

## Objetivo

Estudar system design puxando conhecimento sob demanda a partir de casos reais, sem perder cobertura da ementa.

## Regra central

O fluxo nao e:
- ler toda a teoria
- depois procurar exemplos

O fluxo passa a ser:
1. escolher uma area do curso
2. selecionar um slice pequeno de um caso real
3. extrair os conceitos daquela area
4. registrar trade-offs e limites
5. implementar algo pequeno se isso aumentar entendimento

## Politica de implementacao

Quando um conceito merecer experimento:
1. implemente primeiro em Ruby on Rails
2. reimplemente em Elixir se houver ganho claro em concorrencia, resiliencia ou tempo real
3. reimplemente em Go se houver ganho claro em throughput, controle operacional ou simplicidade de runtime

Nao reimplemente por esporte. Reimplemente apenas quando a segunda linguagem trouxer um aprendizado novo.

## Matriz de cobertura inicial

### 02 - Dados e Armazenamento

- Casos principais:
  - [GitHub - Rails and MySQL at Scale](./real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
  - [Shopify - Pods and Modular Monolith](./real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- O que extrair:
  - modelagem de dados
  - leitura vs escrita
  - indexes, query plan e scaling
- Quando implementar:
  - Rails primeiro
  - exemplos bons: read replica simulation e cache-aside

### 03 - Filas e Consistencia

- Casos principais:
  - [Stripe - Idempotent Payments](./real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
  - [LinkedIn - Kafka Backbone](./real-world-cases/03-async-workflows-and-payments/linkedin-kafka-backbone/README.md)
- O que extrair:
  - retries, DLQ, idempotencia
  - particionamento
  - semanticas de entrega
- Quando implementar:
  - Rails primeiro
  - reimplemente em Elixir ou Go so se a comparacao ensinar algo novo

### 04 - Edge, Rede e Acesso

- Casos principais:
  - [Cloudflare - Edge Platform](./real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
  - [Uber - Unified Checkout](./real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- O que extrair:
  - load balancing
  - auth e gateway boundaries
  - rate limiting e protecao de borda
- Quando implementar:
  - Rails primeiro para auth, throttle e cache

## Fluxo de sessao

Para cada sessao de estudo:
1. escolha uma area
2. escolha um caso base
3. escolha um slice pequeno do caso
4. registre:
   - conceito
   - decisao arquitetural
   - trade-off
   - risco
   - como aplicaria no seu stack
5. se restar ambiguidade tecnica, faca um experimento pequeno

## Navegacao pronta

Se preferir uma sequencia guiada:
- abra [chapters/README.md](./chapters/README.md)
- siga um chapter por decisao arquitetural
- use os links do chapter para ir e voltar entre caso, area, notas e lab
