# 04 - Edge, Rede e Acesso

## Por que esta area existe

Este e o bloco de entrada do sistema: trafego, roteamento, autenticacao e protecoes de borda.

## O que estudar aqui

- load balancers
- DNS e estrategias de routing
- API Gateway, WAF e rate limiting
- auth, OAuth, Keycloak e social login
- Backend for Frontends
- CDN e invalidacao

## O que foi absorvido

- subtopicos pequenos de networking que nao exigem pasta isolada

## Casos reais para estudar esta area

- [Cloudflare - Edge Platform](../../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- [Netflix - Open Connect CDN](../../real-world-cases/04-edge-and-delivery/netflix-open-connect-cdn/README.md)
- [Uber - Intelligent Load Management](../../real-world-cases/04-edge-and-delivery/uber-intelligent-load-management/README.md)
- [Meta - Video Delivery](../../real-world-cases/04-edge-and-delivery/meta-video-delivery/README.md)

## Ordem sugerida

1. Cloudflare
2. Netflix
3. Uber Load Management
4. Meta Video

## Apoios desta area

- [Notes](./notes.md)
- [Example - Smaller Marketplace Checkout Boundary](./examples/smaller-marketplace-checkout-boundary.md)
- [Snippet - Rails Checkout Boundary and Auth Guard](./snippets/rails-checkout-boundary-and-auth-guard.md)
- [Snippet - Ruby Rate Limiter Keys and Sliding Window](./snippets/ruby-rate-limiter-keys-and-sliding-window.md)

## Regra de implementacao

- Rails primeiro para auth, throttle e caching
- Go depois para proxies, gateways e limiters
