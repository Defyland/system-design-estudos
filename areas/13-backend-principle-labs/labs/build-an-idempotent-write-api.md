# Build an Idempotent Write API

## Objective

Implementar uma mutacao `POST /orders` que suporte retry sob falha ambigua sem criar efeitos duplicados.

## Setup

API pequena com banco relacional, tabela de pedidos e storage para idempotency key por cliente.

## Tasks

- modele a chave de idempotencia;
- defina janela de retencao;
- persista resultado ou estado intermediario;
- trate retry concorrente e erro parcial;
- exponha resposta consistente para duplicata.

## Exit Criteria

Retry do mesmo request nao duplica pedido, erro depois do commit continua retornando resultado consistente e a key expira sem corromper historico.

## Deliverable

Fluxo de request, tabela envolvida, pseudo-codigo do write path e testes principais.

## Linked Concepts

Idempotency, retries, transactions, unique index, ambiguous failure.
