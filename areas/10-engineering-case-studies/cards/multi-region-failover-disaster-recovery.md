# Multi-Region Failover and Disaster Recovery

## Case Pattern

Multi-regiao e uma decisao sobre RPO, RTO, dependencia compartilhada e custo operacional. A parte dificil nao e ter recursos em duas regioes; e saber quando, como e por quem o trafego e o estado mudam de lugar.

## When to Use

- Um unico region outage derruba jornada critica.
- Regulacao ou negocio exige continuidade em desastre.
- Dados precisam backup cross-region, pilot light, warm standby ou active-active.
- Eventos e pipelines precisam continuar durante falha regional.

## What Breaks First

Dependencias nao replicadas bloqueiam failover, DNS/clients cacheiam endpoint antigo, banco promove com split-brain, jobs processam duas vezes ou o runbook nunca foi testado.

## Interview Trap

Desenhar active-active sem declarar consistencia, conflito de escrita, RPO/RTO, roteamento, health check, dados derivados e plano de failback.

## Practice Drill

Modele DR para checkout. Separe dados transacionais, cache, search, fila, object storage e analytics. Para cada um, defina RPO, RTO, estrategia de restauracao e teste semestral.

## Source Anchor

- AWS Architecture Blog, [Creating an organizational multi-Region failover strategy](https://aws.amazon.com/blogs/architecture/creating-an-organizational-multi-region-failover-strategy/).
- AWS Architecture Blog, [Disaster recovery with AWS managed services - Multi-Region backup and restore](https://aws.amazon.com/blogs/architecture/disaster-recovery-with-aws-managed-services-part-ii-multi-region-backup-and-restore/).
- GitHub, [MySQL High Availability at GitHub](https://github.blog/engineering/infrastructure/mysql-high-availability-at-github/).
- LinkedIn, [Load-balanced Brooklin Mirror Maker](https://www.linkedin.com/blog/engineering/data-streaming-processing/load-balanced-brooklin-mirror-maker-replicating-large-scale-kaf).
