# Configuration Management

## When to Use

Use config para separar comportamento por ambiente sem recompilar codigo: URLs, limites, flags, timeouts, credentials e defaults operacionais.

## What Breaks First

Config sem dono vira segredo no repo, default perigoso, flag esquecida ou diferenca invisivel entre staging e producao.

## Interview Trap

Confundir config com constante. Config muda por ambiente e precisa de validacao, origem clara, segredo protegido e rollback.

## Practice Drill

Liste configs de um backend: database URL, Redis URL, timeout PSP, feature flag, log level. Diga quais sao secretas e quais devem ter default.

## Source Anchor

- [17. Gerenciamento de configuracao de nivel de producao](https://www.youtube.com/watch?v=GR9NtirPXyc)
