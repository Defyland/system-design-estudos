# Contrast 01 - Read Replica vs Cache-Aside

## Tension

Os dois aliviam leitura, mas aliviam de jeitos diferentes.

## Use Read Replica When

- a query continua certa no banco e so precisa sair da primary
- voce aceita algum stale read controlado
- quer escalar leitura sem mudar tanto o modelo de leitura

## Use Cache-Aside When

- a mesma leitura se repete muito
- o valor pode ser materializado ou resumido
- o custo de recalcular e maior do que o custo de invalidar

## Trap

- `Resposta ruim`: "qualquer leitura quente pede cache primeiro".
- `Troque por isto`: replica preserva query path; cache muda o contrato de frescor e invalidacao.

## 15-Second Distinction

Replica tira peso da primary. Cache tira repeticao da leitura.

## Pull Chapters

- [Chapter 01](../chapters/chapter-01-relational-scaling-and-operational-discipline.md)
