# Secrets Rotation and Key Management

## When to Use

Quando servicos, jobs, third parties ou equipes compartilham credenciais de longa vida e a rotacao ainda depende de procedimento manual perigoso.

## What Breaks First

Secret vai para log ou repo, rotacao quebra consumidores esquecidos e ninguem sabe a cadeia completa de dependencias que precisa mudar junto.

## Design Moves

Centralize distribuicao, planeje dupla validade temporaria, desacople deploy da rotacao e declare tempo maximo de vida por tipo de credencial.

## Interview Trap

Falar so de onde guardar o secret. O risco operacional esta na rotacao, revogacao e comprovacao de que todos os consumidores atualizaram.

## Practice Drill

Desenhe a rotacao de uma API key usada por web app, worker e webhook consumer. Defina ordem, observabilidade e rollback.

## Source Anchor

- [AWS Secrets Manager Rotation](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html).
- [HashiCorp Vault - Dynamic Secrets](https://developer.hashicorp.com/vault/tutorials/get-started/understand-static-dynamic-secrets).
