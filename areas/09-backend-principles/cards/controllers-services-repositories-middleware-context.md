# Controllers, Services, Repositories, Middleware and Context

## When to Use

Use controller para adaptar HTTP, service para coordenar regra de negocio, repository/query object para persistencia, middleware para politica transversal e context para dados do request.

## What Breaks First

Controller vira script com auth, parse, regra, SQL, job e response. Depois qualquer mudanca pequena atravessa camadas sem dono claro.

## Interview Trap

Criar camadas por ritual. Cada camada precisa reduzir uma responsabilidade real; wrapper vazio so aumenta indirecao.

## Practice Drill

Pegue um endpoint de checkout e separe em cinco linhas: controller recebe, policy autoriza, service decide, repository persiste, job roda efeito posterior.

## Source Anchor

- [10. What are controllers, services, repositories, middlewares and request context?](https://www.youtube.com/watch?v=hyc-7w3pee8)
