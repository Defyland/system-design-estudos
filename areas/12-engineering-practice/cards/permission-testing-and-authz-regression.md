# Permission Testing and Authz Regression

## When to Use

Quando autorizacao depende de combinacao de role, tenant, ownership, plano ou estado do recurso, e a regressao pode vazar dado sem quebrar a API.

## What Breaks First

Casos negativos nao sao testados, policy muda longe do fluxo de negocio e um endpoint novo herda permissao errada.

## Design Moves

Teste matriz de acesso, use fixtures que representem fronteiras reais, proteja endpoints e jobs, e adicione regressao automatica para casos negados e cross-tenant.

## Interview Trap

Confundir autenticacao com autorizacao. O usuario estar logado nao prova que ele pode ler ou mutar aquele recurso.

## Practice Drill

Monte a matriz de permissao para invoices em um SaaS multi-tenant: admin, member, suporte interno e webhook. Escolha 6 casos que precisam virar teste.

## Source Anchor

- [OWASP Web Security Testing Guide - Authorization Testing](https://owasp.org/www-project-web-security-testing-guide/latest/4-Web_Application_Security_Testing/05-Authorization_Testing/README).
- [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/).
