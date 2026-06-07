# 11 - Operational Playbooks

## Por que esta area existe

Operational Playbooks cobre o passo que quase sempre falta depois do desenho: o que fazer quando o sistema ja esta em producao e precisa ser estabilizado sob pressao, com sinais imperfeitos e tempo curto.

## Como estudar

Para cada playbook:

1. leia o trigger e os sinais;
2. diga qual acao reduz risco nos primeiros minutos;
3. separe estabilizacao de diagnostico profundo;
4. transforme o caso em checklist executavel para um sistema seu.

Se voce veio de um chapter, comece pelo playbook apontado no `Study Context`. Ele e a ponte entre a decisao arquitetural e a primeira resposta operacional.

## Playbooks

- [Incident Severity and Triage](./playbooks/incident-severity-and-triage.md)
- [Database Migration and Backfill](./playbooks/database-migration-and-backfill.md)
- [Queue Lag, DLQ and Replay](./playbooks/queue-lag-dlq-and-replay.md)
- [Cache Hot Key and Origin Protection](./playbooks/cache-hot-key-and-origin-protection.md)
- [Search Reindex and Freshness](./playbooks/search-reindex-and-freshness.md)
- [Deploy Rollback and Kill Switch](./playbooks/deploy-rollback-and-kill-switch.md)
- [Disaster Recovery and Failover Drill](./playbooks/disaster-recovery-and-failover-drill.md)
- [Security Incident and Secret Rotation](./playbooks/security-incident-and-secret-rotation.md)

## Fonte

Baseado em runbooks recorrentes de SRE, operacao de plataforma, filas, busca, rollout e seguranca. A intencao aqui e estudar resposta operacional, nao so arquitetura estavel.
