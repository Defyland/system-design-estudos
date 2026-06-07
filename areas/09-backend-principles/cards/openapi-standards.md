# OpenAPI Standards

## When to Use

Use OpenAPI quando API precisa de contrato legivel por humanos e ferramentas: docs, clients, mocks, testes de contrato e alinhamento entre times.

## What Breaks First

Spec desatualizada vira mentira formal. Cliente gera codigo errado e backend quebra consumidores sem perceber.

## Interview Trap

Tratar OpenAPI como documentacao bonita. Ela deve refletir request, response, erros, auth, versionamento e exemplos reais.

## Practice Drill

Especifique `POST /payments`: schema de request, responses `201`, `400`, `409`, `422`, auth exigida e exemplo de erro padronizado.

## Source Anchor

- [1. Roadmap for backend from first principles - OpenAPI standards](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1735s)
