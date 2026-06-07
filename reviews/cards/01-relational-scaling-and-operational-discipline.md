# Review Card 01 - Relational Scaling and Operational Discipline

## Linked Material

- [Chapter 01](../../chapters/chapter-01-relational-scaling-and-operational-discipline.md)
- [Lab 01](../../labs/chapters/chapter-01-relational-scaling-and-operational-discipline.md)

## Anchor

- `Problema`: o banco esta doendo e o time quer culpar o modelo cedo demais.
- `Decisao`: manter o core relacional e escalar na ordem certa: query path, replica honesta, cache-aside e isolamento mais caro so quando blast radius justificar.

## Cue Signal

- `Sinal`: leitura quente, primary saturada e pressao por throughput, mas integridade transacional ainda continua no centro do produto.

## Case Anchor

- `Caso real`: [GitHub - Rails and MySQL at Scale](../../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- `Lembrete`: GitHub e Shopify mostram que disciplina operacional costuma render mais do que trocar de datastore por ansiedade.

## QDSAA Recall

- `Requirement corrigido`: nem toda leitura precisa do mesmo frescor.
- `Delete`: query ornamental ou leitura quente demais na primary.
- `Forma simples`: relacional bem operado com replica e cache antes de shard ou datastore novo.

## Trade-off to Remember

- `Custo`: replica e cache aliviam throughput, mas compram staleness e invalidacao.
- `Failure mode`: read-after-write quebrando porque a leitura saiu cedo demais da primary.

## Trap

- `Resposta ruim`: "ficou lento, entao agora e NoSQL".
- `Troque por isto`: muitas vezes o problema e disciplina operacional fraca, nao o modelo relacional.

## 1-Minute Answer

O core continua relacional enquanto integridade e write transacional ainda dominam. Escale na ordem: query path, replica honesta, cache-aside e isolamento mais caro so quando blast radius justificar.
