# Security Incident and Secret Rotation

## Trigger

Credencial exposta, chave suspeita, acesso indevido, pacote comprometido ou comportamento anomalo em sistema sensivel.

## Signals

- uso inesperado de credencial;
- acesso fora de horario ou origem;
- secret em log, commit ou ticket;
- alerta de scanner, IAM drift ou exfiltracao possivel.

## Immediate Actions

- revogar ou rotacionar credencial exposta;
- limitar blast radius por conta, ambiente e servico;
- preservar evidencias antes de limpeza ampla;
- declarar owner tecnico e owner de comunicacao.

## Stabilize

Trocar secrets, cortar sessao/token, reforcar policy temporaria, congelar deploys relacionados e validar integridade de workloads afetados.

## Deep Checks

Origem da exposicao, quais sistemas usavam o secret, caches e sidecars com credenciais antigas, artefatos vazados e necessidade de rotacao em cadeia.

## Exit Criteria

Secret invalido em toda a superficie, acessos nao autorizados interrompidos, trilha de auditoria preservada e follow-up para raiz e deteccao futura definido.

## Practice Drill

Simule o vazamento de uma API key usada por webhooks e jobs. Escreva rotacao, ordem de revogacao, validacao de consumidores, logs a preservar e comunicacao minima.

## Source Anchor

- [AWS Secrets Manager - Rotate AWS Secrets Manager secrets](https://docs.aws.amazon.com/secretsmanager/latest/userguide/rotating-secrets.html).
- [GitGuardian - Secret Incident Response Playbook](https://www.gitguardian.com/remediation/secrets/playbook).
