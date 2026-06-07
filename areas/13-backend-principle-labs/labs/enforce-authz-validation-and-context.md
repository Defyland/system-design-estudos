# Enforce Authz, Validation and Context

## Objective

Proteger um endpoint de atualizacao com autenticacao, autorizacao por recurso e normalizacao de input antes do dominio.

## Setup

Servico com usuarios, tenants e recurso `invoice` ou `project`, com roles diferentes e pelo menos um fluxo cross-tenant proibido.

## Tasks

- modele request context;
- valide shape e invariantes basicas;
- aplique authz por recurso e tenant;
- separe erro de auth de erro de validacao;
- registre actor e alvo no audit log.

## Exit Criteria

Request malformado falha cedo, usuario autenticado sem permissao nao muta recurso e operacao autorizada deixa trilha audivel.

## Deliverable

Matriz de acesso, fluxo do request e lista de testes negativos obrigatorios.

## Linked Concepts

Authn, authz, validation, middleware, context, audit.
