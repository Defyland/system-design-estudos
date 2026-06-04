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

## Production Recall

- `Pergunta`: qual primeira metrica separa problema de replica de problema de cache?
- `Resposta curta`: replica lag por endpoint e stale complaint no fluxo que acabou de escrever.

## Wrong Production Move

- `Resposta ruim`: "limpa todo o cache e deixa a replica ligada para ver se melhora".
- `Troque por isto`: senior primeiro devolve o fluxo sensivel para a primary e isola a camada que quebrou o contrato.

## Transfer Check

- se o usuario acabou de escrever e precisa ver o efeito agora, a leitura continua na primary
