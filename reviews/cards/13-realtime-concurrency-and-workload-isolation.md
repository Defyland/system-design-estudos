# Review Card 13 - Realtime Concurrency and Workload Isolation

## Linked Material

- [Chapter 13](../../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Lab 13](../../labs/chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)

## Anchor

- `Problema`: um workload vivo, como room quente, presence ou fanout, esta roubando ar do resto do sistema.
- `Decisao`: isolar a unidade de concorrencia e o hotspot antes de reescrever o core inteiro.

## Case Anchor

- `Caso real`: [Discord - Elixir Realtime Scale](../../real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- `Lembrete`: WebSocket abre canal; isolamento, fairness e backlog e que definem o problema realtime de verdade.

## QDSAA Recall

- `Requirement corrigido`: o requisito nao e "ter realtime"; e proteger o resto do sistema do workload vivo.
- `Delete`: evento, presence ou fanout ornamental antes de trocar runtime.
- `Forma simples`: isolar o workload quente sem reescrever o core inteiro.

## Trade-off to Remember

- `Custo`: mais statefulness, roteamento, handoff e observabilidade dificil.
- `Failure mode`: room quente sequestra broadcast, presence ou backlog dos outros.

## Trap

- `Resposta ruim`: "abri WebSocket, entao realtime esta resolvido".
- `Troque por isto`: canal aberto nao resolve fairness, backlog nem workload quente.

## 1-Minute Answer

Realtime maduro separa estado efemero, fanout e persistencia. O primeiro passo nao e copiar Discord; e isolar o hotspot que esta roubando ar do resto do sistema.
