# Architecture Boundary and Scaling Checklist

## Before Splitting Anything

- qual boundary de negocio ja esta claro?
- qual gargalo esta medido, nao so imaginado?
- o problema e dados, fanout, conexoes vivas, seguranca ou ownership?

## Good Reasons to Extract

- throughput ou runtime muito diferente do resto
- isolamento de seguranca ou compliance
- edge ou infra compartilhada por varios produtos
- workflow ou operacao tao especifica que o boundary ficou nitido

## Bad Reasons to Extract

- "microservicos parecem mais senior"
- falta de organizacao dentro do monolito
- medo de tocar codigo antigo sem diagnostico real

## Rails First

Em geral, primeiro prove:
- modulo claro
- responsabilidade clara
- medicao clara

Depois escolha se o proximo passo e Rails melhor organizado, Elixir para concorrencia, ou Go para peca enxuta de infra.
