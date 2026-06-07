# Platform Engineering and Developer Experience

## Case Pattern

Platform engineering transforma requisitos recorrentes de qualidade em trilhos: scorecards, ownership, templates, dev portal, automacao de checks, sandboxes e controles que aparecem dentro do fluxo do desenvolvedor.

## When to Use

- Muitos servicos repetem o mesmo problema de disponibilidade, seguranca ou acessibilidade.
- Onboarding e deploy dependem de conhecimento tribal.
- Times criam infra parecida com padroes divergentes.
- Testes E2E chegam tarde demais para proteger mudancas criticas.

## What Breaks First

A plataforma vira burocracia se nao reduzir toil real. Scorecards sem ownership viram dashboard ignorado, e automacao fora do fluxo diario vira tarefa manual disfarcada.

## Interview Trap

Responder com "cria uma plataforma interna" sem dizer qual comportamento ela padroniza, qual toil remove, qual dono responde por scorecard e como evita bloquear entrega sem feedback util.

## Practice Drill

Escolha 5 servicos. Crie um scorecard minimo com ownership, alerta, runbook, SLO, secret scanning e teste de smoke. Defina qual falha abre issue automaticamente e qual falha congela deploy.

## Source Anchor

- GitHub, [GitHub's Engineering Fundamentals program](https://github.blog/engineering/githubs-engineering-fundamentals-program-how-we-deliver-on-availability-security-and-accessibility/).
- GitHub, [Building GitHub with Ruby and Rails](https://github.blog/engineering/architecture-optimization/building-github-with-ruby-and-rails/).
- Uber, [Shifting E2E Testing Left at Uber](https://www.uber.com/us/en/blog/shifting-e2e-testing-left/).
- Figma, [How we migrated onto K8s in less than 12 months](https://www.figma.com/blog/migrating-onto-kubernetes/).
