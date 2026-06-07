# Disaster Recovery and Failover Drill

## Trigger

Queda regional, perda de dependencia critica ou exercicio programado de DR com impacto potencial em producao.

## Signals

- regiao indisponivel;
- erro persistente em servicos compartilhados;
- replication delay ou backup inconsistente;
- falha de health check para caminho principal.

## Immediate Actions

- declarar modo DR;
- confirmar RTO e RPO do servico afetado;
- listar dependencias que nao acompanham o failover;
- decidir failover parcial, total ou somente freeze operacional.

## Stabilize

Desviar trafego, promover standby, cortar workloads nao criticos e impedir escrita ambigua enquanto a topologia nova estabiliza.

## Deep Checks

Split-brain, caches antigos, consumers duplicando efeito, dados derivados atrasados, DNS/client caching e caminho de failback.

## Exit Criteria

Trafego estabilizado em topologia nova ou principal recuperada, perda de dados quantificada, failback planejado e gaps do drill registrados.

## Practice Drill

Modele o failover de um checkout multi-regiao com banco, cache, search, queue e object storage. Defina o que muda em 5, 30 e 120 minutos.

## Source Anchor

- [AWS - Disaster recovery with AWS: Multi-Region backup and restore](https://aws.amazon.com/blogs/architecture/disaster-recovery-with-aws-managed-services-part-ii-multi-region-backup-and-restore/).
- [AWS - Creating an organizational multi-Region failover strategy](https://aws.amazon.com/blogs/architecture/creating-an-organizational-multi-region-failover-strategy/).
