# 05 - Arquitetura e Operacao

## Por que esta area existe

Este bloco junta as decisoes que mudam o formato do sistema e o custo operacional dele.

## O que estudar aqui

- microservicos vs monolitos
- service mesh
- resiliencia e deployment
- concorrencia e paralelismo
- IO-bound vs CPU-bound
- containers e cold start
- scaling horizontal vs vertical

## O que foi absorvido

- fragmentacao excessiva entre arquitetura, deploy e escalabilidade

## Casos reais para estudar esta area

- [Shopify - Pods and Modular Monolith](../../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- [Discord - Elixir Realtime Scale](../../real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- [Cloudflare - Edge Platform](../../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- [Uber - Cadence Workflows](../../real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)

## Regra de implementacao

- Rails primeiro para boundaries e jobs
- Elixir para concorrencia
- Go para servicos simples e IO-bound
