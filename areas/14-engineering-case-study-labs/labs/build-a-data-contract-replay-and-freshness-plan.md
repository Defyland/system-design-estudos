# Build a Data Contract, Replay and Freshness Plan

## Objective

Projetar um pipeline de evento com contrato executavel, replay seguro e SLA de freshness.

## Setup

Evento central como `OrderPaid` ou `MessageSent`, com consumidores de analytics, feature store e notificacao.

## Tasks

- definir schema e owner;
- escolher chave de particao;
- declarar retention e replay;
- medir freshness;
- listar checks de qualidade.

## Exit Criteria

Contrato tem dono, replay nao duplica efeito critico, freshness tem alvo numerico e a qualidade minima bloqueia uso indevido do dado.

## Deliverable

Spec do evento, fluxo de consumers e plano de replay/freshness.

## Linked Concepts

Data contracts, replay, partitioning, freshness, quality.
