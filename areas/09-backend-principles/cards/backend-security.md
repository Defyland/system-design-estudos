# Backend Security

## When to Use

Use seguranca como boundary permanente: input nao confiavel, identidade, permissao, segredo, rate limit, auditoria e resposta a abuso.

## What Breaks First

Confiar no cliente, vazar segredo, montar query insegura, esquecer tenant scope ou aceitar payload grande demais.

## Interview Trap

Falar so de criptografia. Segurança backend tambem e autorizacao, validacao, least privilege, secret rotation, logs sem PII e protecao de abuso.

## Practice Drill

Revise um endpoint publico: limite de tamanho, auth, authorization, rate limit, SQL injection, PII em logs e resposta de erro.

## Source Anchor

- [20. Backend Security: Everything You Need to Know](https://www.youtube.com/watch?v=xB1C1xZZW4k)
