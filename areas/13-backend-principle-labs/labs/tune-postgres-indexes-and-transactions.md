# Tune Postgres Indexes and Transactions

## Objective

Melhorar um caminho de consulta e escrita em Postgres sem quebrar consistencia nem adicionar indice inutil.

## Setup

Tabela quente com filtros reais, carga de escrita continua e um endpoint com latencia crescente.

## Tasks

- inspecione query path;
- escolha indice com justificativa;
- defina isolamento transacional suficiente;
- proteja invariantes no banco;
- diga como validaria o ganho antes e depois.

## Exit Criteria

Consulta alvo fica mais previsivel, escrita nao degrada de forma surpresa e invariantes seguem protegidas em concorrencia.

## Deliverable

Antes/depois do query path, estrategia de indice e escolha de transacao.

## Linked Concepts

Indexes, transactions, constraints, locking, contention.
