# Review Card 09 - Realtime Concurrency and Workload Isolation

## Linked Material

- [Chapter 09](../../chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)
- [Lab 09](../../labs/chapters/chapter-09-realtime-concurrency-and-workload-isolation.md)

## 15-Second Recall

- `Pergunta`: quando realtime vira problema de isolamento?
- `Resposta curta`: quando room quente, presence ou fanout pesado comecam a machucar os outros fluxos.

## Wrong Turn

- `Resposta ruim`: "abri WebSocket, entao realtime esta resolvido".
- `Troque por isto`: canal aberto nao resolve fairness, backlog nem workload quente.

## 1-Minute Answer

Realtime maduro separa estado efemero, fanout e persistencia. O primeiro passo nao e copiar Discord; e isolar o hotspot que esta roubando ar do resto do sistema.

## Production Recall

- `Pergunta`: qual metrica denuncia o room quente mais rapido?
- `Resposta curta`: broadcast p99, backlog por fila e skew de subscribers por room.

## Wrong Production Move

- `Resposta ruim`: "deixa tudo no ar para nao piorar UX".
- `Troque por isto`: senior derruba presence e brilho antes de entregar mensagem ruim para todo mundo.

## Transfer Check

- Rails aguenta bastante com ActionCable e filas separadas; Elixir ensina mais quando a unidade viva de concorrencia vira o centro do problema
