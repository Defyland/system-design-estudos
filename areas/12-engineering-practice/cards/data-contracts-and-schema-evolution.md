# Data Contracts and Schema Evolution

## When to Use

Quando eventos, APIs ou datasets possuem varios consumidores e uma mudanca pequena em shape pode quebrar producao fora do seu servico.

## What Breaks First

Consumidor antigo interpreta dado novo errado, schema change passa sem gate, replay falha e ownership do contrato fica difuso.

## Design Moves

Defina owner do contrato, compatibilidade explicita, schema registry ou lint equivalente, versionamento por evolucao e politica de deprecacao antes da remocao.

## Interview Trap

Falar "manda JSON e documenta depois". Sem contrato executavel, o problema volta em cada consumer novo.

## Practice Drill

Desenhe a evolucao do evento `OrderPaid` com um campo novo obrigatorio. Defina compatibilidade, rollout, validação em CI e criterio para remover o campo antigo.

## Source Anchor

- [Confluent Schema Registry Documentation](https://docs.confluent.io/platform/current/schema-registry/index.html).
- [Protocol Buffers - Do's and Don'ts](https://protobuf.dev/best-practices/dos-donts/).
