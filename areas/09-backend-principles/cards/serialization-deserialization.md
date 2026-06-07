# Serialization and Deserialization

## When to Use

Use para transformar bytes externos em dados internos e dados internos em resposta publica, preservando tipos, nomes, formato e compatibilidade.

## What Breaks First

Parse permissivo demais aceita shape errado; serializacao acoplada ao model interno vaza campos, quebra versionamento e expande contrato sem perceber.

## Interview Trap

Confundir JSON com contrato. O contrato inclui tipos, campos obrigatorios, nullability, datas, enums, erros e compatibilidade.

## Practice Drill

Defina request e response de `POST /payments`. Liste campos obrigatorios, campos opcionais, formato de data, enum de status e erro de parse.

## Source Anchor

- [7. Serialization and Deserialization for backend engineers](https://www.youtube.com/watch?v=vzg90tY3uM0)
