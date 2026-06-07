# Realtime Collaboration and Consistency

## Case Pattern

Realtime colaborativo combina transporte persistente, autoridade de estado, modelo de conflito, operacao offline, reconexao, ordenacao e limites de consistencia. O algoritmo deve caber no dominio, nao no fascinio por CRDT/OT.

## When to Use

- Varios usuarios editam o mesmo objeto ao mesmo tempo.
- Latencia percebida importa mais que consistencia imediata global.
- Clientes precisam operar offline ou com reconexao frequente.
- O estado tem conflitos semanticos que precisam regra explicita.

## What Breaks First

Clientes divergem, operacoes chegam fora de ordem, undo/redo sobrescreve edicao alheia, reconexao duplica evento, ou o servidor aceita estado impossivel como ciclo em uma arvore.

## Interview Trap

Responder "usa WebSocket" como se transporte resolvesse colaboracao. WebSocket move bytes; o problema real e propriedade do estado, merge, rejeicao, replay e UX de conflito.

## Practice Drill

Desenhe um editor colaborativo de kanban. Defina autoridade do servidor, formato de operacao, idempotencia, reordenacao de cards, conflito de titulo, reconexao e como evitar ciclo em subtarefas.

## Source Anchor

- Figma, [How Figma's multiplayer technology works](https://www.figma.com/blog/how-figmas-multiplayer-technology-works/).
- Figma, [Making multiplayer more reliable](https://www.figma.com/blog/making-multiplayer-more-reliable/).
- Discord, [How Discord Scaled Elixir to 5,000,000 Concurrent Users](https://discord.com/blog/how-discord-scaled-elixir-to-5-000-000-concurrent-users).
- Discord, [Using Rust to Scale Elixir for 11 Million Concurrent Users](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users).
