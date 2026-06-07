# Load Testing and Performance Budgets

## When to Use

Quando o time precisa descobrir limite antes do incidente e transformar performance em budget explicito, nao em sensacao.

## What Breaks First

Teste synthetico nao representa mistura real, gargalo muda por camada e a equipe mede throughput sem erro, latencia e custo juntos.

## Design Moves

Escolha workload representativo, teste read/write path separados, defina budget de p95/p99 e acompanhe degradacao junto de custo e erro.

## Interview Trap

Falar apenas de benchmark maximo. O numero importante e a faixa segura com headroom e comportamento degradado entendido.

## Practice Drill

Escreva um plano de load test para upload de arquivos e webhooks: workload, SLO, budget de erro, limitante esperado e sinal de parada.

## Source Anchor

- [Grafana k6 Documentation](https://grafana.com/docs/k6/latest/).
- [Google - Defining SLOs](https://sre.google/workbook/implementing-slos/).
