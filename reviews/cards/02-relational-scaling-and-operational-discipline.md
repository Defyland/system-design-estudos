# Review Card 02 - Relational Scaling and Operational Discipline

## Linked Material

- [Chapter 02](../../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Lab 02](../../labs/chapters/chapter-02-relational-scaling-and-operational-discipline.md)

## 15-Second Recall

- `Pergunta`: quando o banco doi, qual acusacao voce segura?
- `Resposta curta`: eu nao culpo SQL primeiro; eu olho leitura, escrita, cache, replica e upgrade.

## Wrong Turn

- `Resposta ruim`: "ficou lento, entao agora e NoSQL".
- `Troque por isto`: muitas vezes o problema e disciplina operacional fraca, nao o modelo relacional.

## 1-Minute Answer

O core continua relacional enquanto integridade e write transacional ainda dominam. Escale na ordem: query path, replica honesta, cache-aside e isolamento mais caro so quando blast radius justificar.

## Transfer Check

- se o usuario acabou de escrever e precisa ver o efeito agora, a leitura continua na primary
