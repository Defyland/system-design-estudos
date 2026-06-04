# Review Card 05 - Idempotent Writes Under Ambiguous Failure

## Linked Material

- [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Lab 05](../../labs/chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)

## 15-Second Recall

- `Pergunta`: o que a idempotency key representa?
- `Resposta curta`: uma intencao unica de negocio, nao uma tentativa tecnica qualquer.

## Wrong Turn

- `Resposta ruim`: "indice unico ja resolve retry ambiguo".
- `Troque por isto`: idempotencia boa devolve a mesma resposta canonica e detecta reuso errado de payload.

## 1-Minute Answer

Quando repetir a mutacao pode cobrar, reservar ou criar estado extra, o servidor precisa registrar a primeira resposta e fazer replay dela nos retries. Payload diferente com a mesma chave vira conflito.

## Transfer Check

- para produto menor, uma tabela de idempotencia no mesmo Postgres da write principal ja compra a maior parte do valor
