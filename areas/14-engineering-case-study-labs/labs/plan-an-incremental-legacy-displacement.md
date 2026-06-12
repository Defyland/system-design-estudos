# Plan an Incremental Legacy Displacement

## Objective

Planejar modernizacao incremental de um componente legado sem depender de big-bang cutover.

## Setup

Sistema antigo ainda carrega regra critica de negocio, mas mudar nele virou lento, caro ou perigoso. O negocio nao aceita congelar entrega durante a troca.

## Tasks

- definir qual resultado de negocio a modernizacao precisa melhorar;
- encontrar o primeiro seam tecnico ou de processo;
- escolher arquitetura transicional minima;
- decidir como coexistencia vai funcionar: divert the flow, event interception, parallel run ou dark launch;
- escrever criterio objetivo para aumentar trafego no caminho novo;
- definir quando o adaptador transicional morre e quem aprova o desligamento do legado.

## Exit Criteria

Existe plano incremental com seam clara, ownership de cutover, estrategia de coexistencia e criterio explicito para remover a arquitetura transicional.

## Deliverable

Plano de displacement em fases com seam, componentes temporarios, metricas de ramp-up e condicao de decommission.

## Linked Concepts

Legacy modernization, transitional architecture, dark launch, event interception, cutover, rollback.
