# HTTP Protocol

## When to Use

Use HTTP como contrato base de APIs: metodo, path, headers, body, status code, cache semantics e idempotencia dizem o que o cliente pode esperar.

## What Breaks First

Status code generico, metodo errado e retry sem idempotencia fazem cliente e servidor discordarem sobre sucesso, falha e repeticao segura.

## Interview Trap

Tratar HTTP como transporte burro. Em backend, `GET`, `POST`, `PUT`, `PATCH`, `DELETE`, headers e status sao parte do contrato do produto.

## Practice Drill

Pegue tres endpoints reais e classifique: metodo, status de sucesso, status de erro, idempotente ou nao, headers obrigatorios e se pode ter cache.

## Source Anchor

- [5. Understanding HTTP for backend engineers, where it all starts](https://www.youtube.com/watch?v=a3C1DMswClQ)
