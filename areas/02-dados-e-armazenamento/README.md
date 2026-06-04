# 02 - Dados e Armazenamento

## Por que esta area existe

Boa parte dos trade-offs reais de system design nasce aqui: modelagem, leitura, escrita, consistencia, custo e escala.

## O que estudar aqui

- SQL de verdade: indexes, query plan, particionamento, leitura e escrita
- ACID, BASE, replicacao, federacao e scaling
- NoSQL e escolha por caso de uso
- Blob/object storage
- Cache como acelerador de acesso a dados

## O que foi absorvido

- "o que sao bancos de dados"
- introducoes rasas de SQL e NoSQL
- overview de opcoes que nao precisa de pasta propria

## Regra de implementacao

- Rails primeiro
- Elixir so se houver ganho de concorrencia ou coordenacao
- Go so se houver ganho de throughput ou simplicidade operacional
