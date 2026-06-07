# Plan a Zero-Downtime Migration

## Objective

Traduzir um case de migracao em um plano executavel de expand-contract com cutover e rollback.

## Setup

Tabela ou indice quente com escrita continua e cliente nao coordenado.

## Tasks

- defina fases da migracao;
- escolha estrategia de backfill;
- descreva dual write/read;
- modele metricas de divergencia;
- planeje cutover e cleanup.

## Exit Criteria

Existe sequencia reversivel, metrica de divergencia, throttle de backfill e criterio explicito para desligar o caminho antigo.

## Deliverable

Plano em fases com riscos, checkpoints e rollback.

## Linked Concepts

Migration, backfill, dual write, cutover, cleanup.
