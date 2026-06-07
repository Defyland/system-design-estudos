# Execute a Multi-Region DR Drill

## Objective

Transformar DR em exercicio repetivel com RTO, RPO, failover e failback claros.

## Setup

Servico com banco, cache, fila e busca, com dependencia critica em uma regiao principal.

## Tasks

- declare RTO e RPO por componente;
- descreva failover;
- liste dependencias que nao acompanham;
- modele verificacao de consistencia apos troca;
- escreva failback minimo seguro.

## Exit Criteria

O drill tem passos executaveis, limite de perda aceitavel, validacao apos failover e plano de retorno que evita split-brain.

## Deliverable

Checklist de DR com tempos alvo e pontos de verificacao.

## Linked Concepts

Disaster recovery, multi-region, failover, failback, data consistency.
