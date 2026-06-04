# Notes

## Ida e Volta

- [Chapter 05 - Idempotent Writes Under Ambiguous Failure](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 06 - Event Backbone, Partitions and Consumer Scale](../../chapters/chapter-06-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 07 - Durable Workflows, Retries and Compensation](../../chapters/chapter-07-durable-workflows-retries-and-compensation.md)
- [Chapter 08 - Distributed IDs and Ordering Guarantees](../../chapters/chapter-08-distributed-ids-and-ordering-guarantees.md)
- [Smaller B2B - Idempotent Order Submission](./examples/smaller-b2b-idempotent-order-submission.md)
- [Rails Idempotency Key Snippet](./snippets/rails-idempotency-key-for-mutating-endpoints.md)

## Modelos Mentais

- falha ambigua e falha de confirmacao, nao necessariamente falha de execucao
- idempotencia protege uma intencao de negocio, nao um metodo HTTP isolado
- unique index evita duplicar linha; idempotency key evita duplicar efeito e ainda permite replay da resposta
- exactly-once global quase nunca vale o custo; effect-once na fronteira certa quase sempre vale
- retries sao normais em sistemas distribuidos; o erro esta em aceitar retry sem identidade
- operacao assincrona boa continua sendo idempotente: ela so troca resposta imediata por estado recuperavel

## Matriz De Decisao

| Situacao | Escolha padrao | Por que | Ver o chapter |
| --- | --- | --- | --- |
| `PUT` ou `DELETE` de um recurso totalmente identificado | Sem chave extra, mas com semantica realmente idempotente | O proprio contrato do recurso ja descreve substituicao ou remocao | [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md) |
| `POST` que cria pagamento, pedido ou reserva | `Idempotency-Key` + resposta persistida | O cliente pode perder a confirmacao e repetir a write | [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md) |
| Duplicacao local e o unico risco | Unique index de negocio | Mais simples e barato quando nao ha replay nem efeito externo relevante | [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md) |
| Fluxo vai para fila e pode ser reentregue | Chave na borda + consumer idempotente | A fila nao elimina a ambiguidade do primeiro `POST` | [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md) |
| Varios passos com confirmacao externa assincrona | Estado de negocio + correlacao de eventos | Nao basta deduplicar request; e preciso saber se o efeito final confirmou | [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md) |
| Muitos times e checkouts diferentes disputam a mesma infraestrutura de pagamento | Camada de checkout/orquestracao unica | Centraliza integracao, metodos de pagamento e recovery | [Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md) |

## Empresa Menor Vs Empresa Maior

| Dimensao | Empresa menor | Empresa maior |
| --- | --- | --- |
| Fronteira principal | Um monolito Rails ou poucos servicos | Checkout ou payments platform compartilhado |
| Persistencia da chave | Tabela local em Postgres | Servico dedicado ou storage compartilhado com politicas por dominio |
| Escopo da chave | Conta + operacao + payload fingerprint | Contrato cross-LOB, cross-channel e cross-processor |
| Estados | `processing`, `completed`, `failed` bastam | Estados intermediarios, reconciliacao e callbacks assincronos viram rotina |
| Integracoes externas | 1 PSP, 1 ERP, 1 broker | Muitos PSPs, risco, auth, compliance e metodos locais |
| Observabilidade | logs e metricas por endpoint | tracing, recovery funnels e experimentos de conversao |
| Erro mais comum | TTL ruim ou falta de unique index | vazamento de complexidade para times consumidores |

O ponto de traducao e este: empresa menor copia o principio de Stripe primeiro. Empresa maior eventualmente precisa da disciplina organizacional que a Uber colocou no Unified Checkout.

## Casos Reais Estudados

- Stripe formaliza o contrato: mesma chave, mesma resposta, comparacao de parametros e poda posterior da chave ([Stripe engineering](https://stripe.com/blog/idempotency), [Stripe docs](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)).
- Stripe tambem modela o pagamento como estado reaproveitavel ao longo da sessao com PaymentIntents ([Stripe Payment Intents](https://docs.stripe.com/payments/payment-intents)).
- Uber centralizou checkout porque tinha dezenas de endpoints financeiros, metodos de pagamento inconsistentes e processadores assincronos ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)).

## Ideias De Implementacao Em Rails

- use uma tabela `idempotency_records` no mesmo banco da write principal
- adicione indice unico por `scope` e `key`
- guarde `request_fingerprint`, `status_code`, `response_body`, `state` e `expires_at`
- so persista replay definitivo depois que a operacao realmente comecar
- retorne `409` para reuso da mesma chave com payload diferente
- se houver side effect externo, propague a referencia de negocio ou a propria chave quando o downstream suportar

Veja o codigo base em [Rails Idempotency Key For Mutating Endpoints](./snippets/rails-idempotency-key-for-mutating-endpoints.md) e o cenario reduzido em [Smaller B2B - Idempotent Order Submission](./examples/smaller-b2b-idempotent-order-submission.md).

## Quando Comparar Com Elixir Ou Go

- compare com Elixir quando o aprendizado novo for supervisao, estados de processamento e workers com recuperacao
- compare com Go quando o aprendizado novo for middleware leve, concorrencia explicita e servicos pequenos de alta taxa
- se nenhuma dessas comparacoes mudar a decisao arquitetural, fique no Rails e avance

## Volta Ao Chapter

- [Voltar para o Chapter 05](../../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
