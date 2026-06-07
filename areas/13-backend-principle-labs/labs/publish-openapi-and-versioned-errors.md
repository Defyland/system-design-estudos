# Publish OpenAPI and Versioned Errors

## Objective

Definir contrato de API com OpenAPI, erros versionados e politica minima para breaking change.

## Setup

Servico HTTP com pelo menos dois endpoints e um integrador externo ou cliente mobile simulado.

## Tasks

- descrever request e response;
- padronizar envelope de erro;
- decidir codigos e metadados;
- documentar um caminho de deprecacao;
- ligar contrato a um teste automatizado.

## Exit Criteria

Contrato pode ser consumido sem ler o codigo, erros sao previsiveis e uma mudanca breaking passa a ter processo explicito.

## Deliverable

Snippet OpenAPI, tabela de erros e regra de versionamento.

## Linked Concepts

OpenAPI, API contracts, deprecation, error design, client compatibility.
