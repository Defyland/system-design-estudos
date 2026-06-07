# Audit Logs and Forensics

## When to Use

Quando operacoes sensiveis precisam explicacao depois do fato: quem fez, de onde, em qual recurso, com qual efeito e em qual tenant.

## What Breaks First

Logs de app existem mas nao provam causalidade, campos criticos faltam, relogio nao bate entre servicos e o time nao consegue reconstruir um incidente.

## Design Moves

Separe audit log de debug log, padronize actor/action/resource/result, preserve request correlation e retenha trilha suficiente para investigacao e compliance.

## Interview Trap

Responder com "loga tudo". Forense util exige estrutura, retenção, integridade e busca pelos campos certos.

## Practice Drill

Defina o schema de audit log para alteracao de permissao, exportacao de dados e rotacao de billing owner em um SaaS B2B.

## Source Anchor

- [Google Cloud - Cloud Audit Logs overview](https://cloud.google.com/logging/docs/audit).
- [AWS - Logging strategies for security incident response](https://docs.aws.amazon.com/whitepapers/latest/building-effective-security-monitoring/logging-strategy.html).
