# Twelve-Factor App

## When to Use

Use como checklist para app backend operavel: config por ambiente, logs como stream, processos descartaveis, build/release/run separados e dependencias explicitas.

## What Breaks First

Ambiente vira snowflake, deploy depende de estado local, logs ficam presos em arquivo e config sensivel aparece no codigo.

## Interview Trap

Decorar os fatores sem conectar com operacao. O valor e tornar deploy, rollback, scale e debug previsiveis.

## Practice Drill

Pegue uma app Rails, Elixir ou Go e marque: config vem de env? processo pode morrer? logs vao para stdout? migration e release estao separados?

## Source Anchor

- [1. Roadmap for backend from first principles - 12 factor app](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1730s)
