# Cloudflare - Edge Platform

## Why this case matters

Cloudflare e um caso muito denso para estudar a borda do sistema: LB, rate limiting, WAF, API gateway e cache.

## Course topics

- load balancers
- rate limiting
- WAF
- API Gateway
- CDN e cache
- DNS e edge routing

## Stack relevance

- Rails: high
- Elixir: high
- Go: high

## Primary sources

- [Unimog - Cloudflare's edge load balancer](https://blog.cloudflare.com/unimog-cloudflares-edge-load-balancer/)
- [How we built rate limiting capable of scaling to millions of domains](https://blog.cloudflare.com/counting-things-a-lot-of-different-things/)
- [Designing the new Cloudflare Web Application Firewall](https://blog.cloudflare.com/designing-the-new-cloudflare-waf/)
- [Announcing the Cloudflare API Gateway](https://blog.cloudflare.com/api-gateway/)
- [CDN-Cache-Control: Precision Control for your CDN(s)](https://blog.cloudflare.com/cdn-cache-control/)

## What to extract

- anycast e edge load balancing
- contagem distribuida para rate limiting
- onde WAF e gateway entram no request path
- cache control e invalidacao na borda

