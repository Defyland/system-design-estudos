# Chapter 03 - System Design Delivery Framework

## Slice

Como conduzir uma pergunta aberta de system design sem cair em arquitetura prematura, diagrama confuso ou resposta sem prioridade.

## Study Context

- `Track order`: `03/06` - conduzir a conversa antes da lista de sistemas
- `Upstream principal`: [Hello Interview - System Design Delivery](https://www.hellointerview.com/learn/system-design/in-a-hurry/delivery)
- `Upstream complementar`: [System Design Primer](https://github.com/donnemartin/system-design-primer)
- `Topicos locais`: [REST API Design](../../../09-backend-principles/cards/rest-api-design.md), [Rate Limiting Algorithms and Keys](../../../09-backend-principles/cards/rate-limiting-algorithms-and-keys.md), [Logging, Monitoring, Observability](../../../09-backend-principles/cards/logging-monitoring-observability.md)
- `Casos ponte`: [Stripe - Idempotent Payments](../../../../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md), [Uber - Unified Checkout](../../../../real-world-cases/05-product-scenarios/uber-unified-checkout/README.md)
- `Review card`: [Card 03](../reviews/cards/03-system-design-delivery-framework.md)

## Why This Matters In Interviews

Pergunta aberta punindo improviso nao e sobre achar a arquitetura perfeita.

E sobre:
- ordenar incerteza
- escolher o problema certo primeiro
- defender trade-off
- deixar claro o que faria agora e o que faria em `10x`

## Conversation Framework

Use esta ordem quase sempre:

1. `Reframe the problem`
   - uma frase limpa sobre o produto
2. `Functional requirements`
   - o que o sistema precisa fazer
3. `Non-functional requirements`
   - latencia, disponibilidade, consistencia, custo, compliance
4. `Back-of-envelope`
   - usuarios, QPS, storage, payload, hot partitions
5. `API / contract`
   - endpoints ou fluxo principal
6. `Data model`
   - entidades e chaves
7. `High-level architecture`
   - request path, async path, storage, cache, queue
8. `What breaks first`
   - hot key, fanout, replica lag, retry storm, DLQ, auth leakage
9. `Evolution`
   - o que basta hoje, o que muda com crescimento

## The 80/20 Building Blocks

Voce nao precisa citar tudo. Precisa reconhecer quando cada bloco aparece:

- `Load balancer`
  - distribui trafego e faz health check
- `Cache`
  - reduz latencia e carga; invalidação e a parte cara
- `Queue`
  - desacopla, absorve pico e permite retry
- `Index`
  - acelera leitura, custa escrita e storage
- `Replication`
  - escala leitura e ajuda failover
- `Partition / shard`
  - divide dado por chave
- `Rate limit`
  - protege abuse e overload
- `Idempotency`
  - evita efeito duplicado em retry
- `Observability`
  - logs, metrics, tracing, alertas
- `Security`
  - authn, authz, input validation, secrets, encryption

## Back-of-Envelope Without Theater

Estimativa boa serve para cortar opcao ruim cedo:

- QPS de pico e medio
- read / write ratio
- payload medio
- cardinalidade de entidades quentes
- crescimento diario de storage

Exemplo de fala boa:
- "se write e baixa e read e altissima, cache logo entra na conversa"
- "se cada usuario tem fanout grande, eu preciso discutir feed materializado vs fanout on read"

## What To Say When You Do Not Know Yet

Boa resposta:
- "vou comecar pelo caminho principal do request"
- "assumindo consistencia eventual aceitavel para feed"
- "eu comeco simples com banco unico + cache e explico o que quebra primeiro"

Resposta ruim:
- "eu colocaria Kafka, Redis, Elastic e microservicos"

Componentes sem necessidade provada so parecem maturidade.

## Follow-ups You Should Expect

- qual e o gargalo de leitura e escrita?
- a consistencia pode ser eventual?
- como invalidar cache?
- como evitar duplicidade em retry?
- o que acontece quando um provider cai?
- qual e a chave de shard?
- como observar producao?
- o que voce simplificaria para uma empresa menor?

## Interview Compression

- `15 segundos`: system design bom comeca por requisito e nao por tecnologia.
- `15 segundos`: a ordem normal e requisitos, estimativas, API, dados, high-level, gargalos e trade-offs.
- `1 minuto`: voce nao precisa desenhar o estado final mais sofisticado; precisa mostrar julgamento de crescimento e falha.

## Decision Synthesis

### Use When

- voce esta praticando perguntas abertas
- quer parar de responder com lista de componentes
- precisa parecer senior em vez de "framework ambulante"

### Why This Matters

- a conversa e avaliada por clareza e prioridade
- estimativa errada leva arquitetura errada
- follow-up costuma testar a primeira fissura do seu desenho

### Main Trade-offs

- simplificar demais pode ignorar requisito critico
- sofisticar cedo demais parece cargo cult
- gastar tempo demais em API atrapalha a arquitetura

### Warning Signs

- voce nomeia tecnologia antes de latencia ou consistencia
- ignora write path e fala so de leitura
- nao diz o que quebra primeiro
- responde "depende" sem escolher nada

## Production Recall

- `Pergunta`: qual ordem mais segura para conduzir uma entrevista de system design?
- `Resposta com as suas palavras`: reafirmar o problema, fechar requisitos funcionais e nao funcionais, estimar demanda, modelar API e dados, desenhar arquitetura high-level, nomear gargalos e discutir evolucao.
- `Resposta ruim`: eu desenho a arquitetura primeiro e depois ajusto se o entrevistador reclamar.
- `Troque por isto`: arquitetura sem requisito fechado parece aleatoria.

## Design Pass Recall

- `Pergunta`: que blocos basicos aparecem de novo e de novo em system design?
- `Resposta curta`: cache, fila, banco/index, replicacao, particionamento, rate limit, idempotencia, observabilidade e seguranca.
- `Armadilha`: cada problema precisa de um componente novo e excentrico.
- `Correcao`: a maior parte das perguntas recompõe os mesmos blocos em trade-offs diferentes.
