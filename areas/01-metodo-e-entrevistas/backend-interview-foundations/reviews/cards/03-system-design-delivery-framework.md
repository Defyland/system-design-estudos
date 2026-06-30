# Review Card 03 - System Design Delivery Framework

## Linked Material

- [Chapter 03](../../chapters/03-system-design-delivery-framework.md)

## Anchor

- `Problema`: pergunta aberta vira despejo de tecnologia quando nao existe ordem para fechar requisito, estimativa e gargalo.
- `Decisao`: conduzir a conversa com um framework curto e repetivel.

## Cue Signal

- `Sinal`: voce quer desenhar microservicos antes de dizer quem usa o sistema e o que mais importa no caminho critico.

## Case/Bridge Anchor

- `Ponte`: [REST API Design](../../../../../areas/09-backend-principles/cards/rest-api-design.md), [Logging, Monitoring, Observability](../../../../../areas/09-backend-principles/cards/logging-monitoring-observability.md)
- `Caso real`: [Stripe - Idempotent Payments](../../../../../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)

## QDSAA Recall

- `Requirement corrigido`: system design nao e adivinhar arquitetura final; e ordenar incerteza e trade-off.
- `Delete`: componentes cedo demais sem necessidade provada.
- `Forma simples`: requisitos, estimativas, API, dados, high-level, gargalos e evolucao.

## Trade-off to Remember

- `Custo`: simplificar demais pode ignorar requisito critico.
- `Failure mode`: sofisticar cedo demais destrói clareza e priorizacao.

## Trap

- `Resposta ruim`: "eu colocaria Kafka, Redis e microservicos".
- `Troque por isto`: "eu comeco pelo caminho principal, assumo X, e explico o que quebra primeiro".

## 1-Minute Answer

Boa resposta de system design comeca por requisitos e estimativas, passa por API e dados, desenha o high-level mais simples que funciona e deixa explicito o primeiro gargalo, o trade-off e o plano de evolucao.
