# Error Handling and Fault Tolerance

## When to Use

Use quando falhas precisam virar respostas previsiveis, retry seguro, degradacao controlada ou rollback, sem esconder estado ambiguo.

## What Breaks First

Catch generico transforma bug, timeout e validacao em mesma resposta; retry sem idempotencia duplica efeito; erro sem contexto nao guia operacao.

## Interview Trap

Prometer "sistema resiliente" sem dizer qual falha resta. Sempre nomeie timeout, dependencia, dado invalido, conflito, limite e rollback.

## Practice Drill

Para uma chamada a PSP, liste erros recuperaveis, nao recuperaveis e ambiguos. Defina resposta HTTP, retry, log e acao do usuario.

## Source Anchor

- [16. Error Handling and Building Fault Tolerant Systems](https://www.youtube.com/watch?v=8NaM_9aKS24)
