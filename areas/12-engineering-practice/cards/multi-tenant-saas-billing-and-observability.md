# Multi-Tenant SaaS Billing and Observability

## When to Use

Quando o produto precisa isolar tenants, medir uso, aplicar limites, explicar cobranca e detectar noisy neighbors sem perder eficiencia operacional.

## What Breaks First

Tenant grande esconde problema em metricas globais, billing usa dado inconsistente e suporte nao consegue responder por tenant, plano ou regiao.

## Design Moves

Faça tenant ID atravessar logs, metrics e traces, separe limite tecnico de limite comercial, modele metering auditavel e preserve override operacional explicito.

## Interview Trap

Falar so de isolamento de banco. SaaS multi-tenant serio tambem exige billing, tenancy-aware observability, limits e supportability.

## Practice Drill

Desenhe metering e observabilidade por tenant para uploads e webhooks em um SaaS B2B com planos Free, Pro e Enterprise.

## Source Anchor

- [AWS Well-Architected SaaS Lens](https://docs.aws.amazon.com/wellarchitected/latest/saas-lens/welcome.html).
- [Azure Architecture Center - Multitenant solution considerations](https://learn.microsoft.com/en-us/azure/architecture/guide/multitenant/considerations/overview).
