# Testing and Code Quality

## When to Use

Use testes para proteger contrato, regra de negocio e regressao operacional. Qualidade de codigo entra quando reduz custo de mudanca real.

## What Breaks First

Teste acoplado a implementacao trava refactor; teste amplo demais nao aponta falha; falta de teste em boundary deixa bug aparecer so em producao.

## Interview Trap

Prometer 100% coverage. Melhor: testes de contrato, unitarios nos invariantes, integracao nos efeitos externos e um caminho feliz end-to-end.

## Practice Drill

Para `POST /orders`, escreva uma matriz minima: validacao invalida, idempotencia, transacao, job emitido e resposta HTTP.

## Source Anchor

- [1. Roadmap for backend from first principles - Testing and code quality](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1686s)
