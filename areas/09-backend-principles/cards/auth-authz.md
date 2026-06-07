# Authentication and Authorization

## When to Use

Use authentication para provar identidade e authorization para decidir permissao. As duas perguntas aparecem em todo endpoint sensivel.

## What Breaks First

Sistema autentica bem, mas autoriza mal: usuario logado acessa tenant errado, muta recurso que nao possui ou pula step-up em acao critica.

## Interview Trap

Dizer "tem JWT" como se isso resolvesse permissao. Token identifica; politica decide o que pode acontecer naquele recurso.

## Practice Drill

Para `PATCH /accounts/:id/billing`, escreva quem pode chamar, qual escopo precisa, qual tenant deve bater e quando exigir reauth.

## Source Anchor

- [8. Authentication and authorization for backend engineers](https://www.youtube.com/watch?v=A95rliroC8Q)
