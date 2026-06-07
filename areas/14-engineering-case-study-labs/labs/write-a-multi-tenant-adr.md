# Write a Multi-Tenant ADR

## Objective

Documentar a decisao entre isolamento por schema, banco, pod ou camada logica para um SaaS em crescimento.

## Setup

Produto B2B com planos diferentes, billing por uso e ao menos um tenant grande o bastante para gerar preocupacao de blast radius.

## Tasks

- escrever contexto e restricoes;
- comparar ao menos tres opcoes;
- declarar decisao e consequencias;
- definir sinais para revisitar a escolha;
- ligar a decisao a observabilidade e billing por tenant.

## Exit Criteria

ADR consegue ser lido fora da reuniao original e explica por que a opcao escolhida paga o custo operacional.

## Deliverable

ADR curto com contexto, decisao, trade-offs e gatilho de revisao.

## Linked Concepts

Multi-tenancy, SaaS architecture, billing, observability, ADR.
