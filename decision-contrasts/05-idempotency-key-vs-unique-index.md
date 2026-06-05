# Contrast 05 - Idempotency Key vs Unique Index

## Tension

Os dois bloqueiam duplicacao parcial, mas so um resolve retry ambiguo como contrato de API.

## Use Idempotency Key When

- o cliente pode repetir uma mutacao depois de falha ambigua
- precisa devolver a mesma resposta canonica
- payload divergente com mesma chave precisa ser detectado

## Use Unique Index When

- a regra de unicidade do dominio ja existe no banco
- voce quer bloquear duplicacao local simples
- nao precisa replay de resposta nem semantica de retry

## Trap

- `Resposta ruim`: "indice unico ja me da write segura".
- `Troque por isto`: ele bloqueia uma colisao local; nao resolve bem o buraco entre commit e resposta perdida.

## 15-Second Distinction

Indice unico protege a linha. Idempotency key protege a mutacao sob retry ambiguo.

## Pull Chapters

- [Chapter 03](../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
