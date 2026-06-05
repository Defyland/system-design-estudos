# Simulation Lab - Sharding / Pod Isolation

## Scenario

Um tenant enterprise esquenta e jobs cross-tenant tornam o sistema inteiro lento.

## Controls

- tenant load
- shard count
- cross-shard queries
- move tenant cost

## What Changes

Shard aumenta capacidade. Pod reduz blast radius quando request fica presa ao boundary certo.

## Failure Mode

Query cross-pod transforma isolamento em teatro.

## Cost Signal

Mais shard compra throughput e cobra roteamento, movimentacao e operacao.

## Interview Takeaway

Isolamento bom comeca proibindo fluxo errado, nao adicionando banco sem boundary.

## Linked Chapters

- [Chapter 02](../chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 12](../chapters/chapter-12-distributed-ids-and-ordering-guarantees.md)

## Linked Areas

- [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)

## Mastery Checks

- `Pergunta`: qual fluxo voce proibe primeiro em pod isolation?
- `Resposta com as suas palavras`: qualquer query ou job cross-pod no caminho critico.
- `Resposta ruim que parece boa`: basta shardear o banco.
- `Troque por isto`: shard sem boundary so espalha o problema.

