# Notes

## Ida e Volta

- [Chapter 02 - Pod Isolation and Tenant Routing](../../chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 01 - Relational Scaling and Operational Discipline](../../chapters/chapter-01-relational-scaling-and-operational-discipline.md)
- [Chapter 05 - Durable Workflows, Retries and Compensation](../../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Chapter 13 - Realtime Concurrency and Workload Isolation](../../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Example - Smaller SaaS Architecture Evolution](./examples/smaller-saas-architecture-evolution.md)
- [Example - Incident Checkout Degradation](./examples/incident-checkout-degradation.md)
- [Example - Slow Rollout Read Path Regression](./examples/slow-rollout-read-path-regression.md)
- [Snippet - Boundary and Scaling Checklist](./snippets/architecture-boundary-and-scaling-checklist.md)
- [Snippet - First 15 Minutes Incident Checklist](./snippets/first-15-minutes-incident-checklist.md)
- [Snippet - Canary and Rollback Checklist](./snippets/canary-and-rollback-checklist.md)

## Estilo arquitetural

Regra adulta: escolha arquitetura pelo formato da dor, nao pelo prestigio da palavra.

Modelos mentais:
- monolito modular:
  - excelente quando o dominio ainda conversa muito consigo mesmo
- servico separado:
  - entra quando boundary, throughput, seguranca ou ownership realmente pagam a conta
- edge ou gateway:
  - bom para politicas compartilhadas; ruim para carregar regra de negocio pesada

## Operacao e deploy

Arquitetura sem operacao e desenho de quadro.

Perguntas que importam:
- consigo fazer rollout pequeno?
- consigo rollback claro?
- consigo isolar blast radius?
- consigo observar saturacao, fila, retry e latencia?

GitHub, Shopify, Cloudflare e Uber ensinam a mesma licao por angulos diferentes: operacao nao vem depois do design. Ela e parte do design.

## Performance e scaling

- escalar verticalmente compra tempo, nao estrategia
- escalar horizontalmente compra throughput, mas cobra coordenacao
- CPU-bound e IO-bound pedem escolhas diferentes de runtime, deploy e sizing
- quando o gargalo e read-heavy, talvez o problema seja dados; quando o gargalo e fanout ou conexao viva, talvez seja runtime

## Resiliencia

Resiliencia boa tem sempre um alvo:
- reduzir blast radius
- proteger dependencias caras
- manter caminho critico vivo
- devolver falha recuperavel em vez de caos silencioso

## SLO, error budget e degradacao aceitavel

SLO existe para decidir o que vale segurar vivo quando tudo nao cabe.

Perguntas uteis:
- qual caminho critico realmente nao pode cair?
- qual latencia ainda e feia, mas aceitavel?
- o que pode degradar sem quebrar a promessa central do produto?

Error budget serve para dar contexto ao risco:
- se o budget ja esta quase queimado, rollout agressivo piora
- se o budget esta saudavel, canary controlado compra aprendizado

Degradacao aceitavel costuma ser:
- esconder presence fina e manter mensagem
- atrasar analytics e manter checkout
- servir conteudo um pouco mais velho e manter a origem viva

## Rollout ladder

Senior de producao nao pensa so em "deploy" e "rollback". Pensa em escada:

1. dark launch:
   - codigo novo roda, mas nao decide nada visivel
2. observe-only:
   - regra ou score novo gera telemetria sem atuar
3. canary:
   - pequena coorte recebe o comportamento novo
4. partial rollout:
   - porcentagem maior, ainda com kill switch
5. full rollout:
   - so depois que metrica e comportamento passam
6. rollback:
   - desfaz a ultima mudanca com o menor blast radius possivel

O objetivo da escada nao e burocracia. E ganhar informacao antes de ganhar dano.

## Incident loop

Loop operacional curto:

1. detectar:
   - o que exatamente saiu do normal?
2. conter:
   - qual a menor mudanca que reduz o dano agora?
3. estabilizar:
   - como manter o caminho critico respirando?
4. recuperar:
   - como voltar o sistema a um estado seguro e coerente?
5. aprender:
   - qual guardrail deveria ter existido antes?

Erro comum:
- pular de `detectar` para `corrigir a arquitetura`

Senior bom primeiro contem. Depois melhora.

## Capacidade e custo

Escala sem custo e fantasia. Custo sem capacidade vira freio de produto.

Sinais de que custo virou assunto de arquitetura:
- fanout ou replay queimam infra sem melhorar experiencia
- replica, CDN ou fila estao baratos tecnicamente e caros economicamente
- a equipe esta comprando throughput para esconder desenho ruim

Sinais de que capacidade virou assunto de arquitetura:
- um unico tenant, room ou producer distorce o sistema inteiro
- picos normais parecem ataque
- backlog deixa de ser excecao e vira regime

Pergunta senior:
- "qual capacidade estou comprando e qual tipo de dano estou evitando?"

## Ownership e blast radius

Sistemas falham pior quando ninguem sabe quem pode apertar o botao de parar.

Ownership minimo por mudanca critica:
- quem observa a metrica principal
- quem pode desligar a feature
- quem valida que o rollback funcionou
- quem comunica impacto para produto ou suporte

Blast radius tambem e social:
- se muita gente precisa aprovar ou entender para reverter, o sistema ja esta mais perigoso do que parece
- se o rollout nao pode ser segmentado por tenant, rota ou cohort, a mudanca esta grande demais

## Matriz de decisao

| Sinal | Melhor movimento | Evite |
| --- | --- | --- |
| dominio ainda muito acoplado internamente | monolito modular com boundaries melhores | extrair servicos cedo |
| um fluxo longo exige retry, timeout e estado | workflow duravel ou state machine explicita | cadeia de jobs sem memoria |
| edge precisa proteger origem e banco | limiter, WAF, load management na borda | jogar regra de produto no gateway |
| realtime e fanout viraram parte do produto | runtime ou servico especializado | insistir em request/response por teimosia |
| um tenant ou dominio impoe muito risco aos outros | isolamento por boundary tecnico ou de dados | acoplamento total por conveniencia |

## Trade-offs principais

- monolito reduz custo de coordenacao, mas cobra disciplina interna
- servicos reduzem acoplamento de certos fluxos, mas sobem custo operacional
- edge melhora protecao e latencia, mas adiciona outra camada poderosa para errar
- runtimes especializados ajudam muito, mas so pagam quando o problema tambem e especializado

## Casos reais estudados

- [Shopify - Pods and Modular Monolith](../../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- [Discord - Elixir Realtime Scale](../../real-world-cases/01-platforms-and-apps/discord-elixir-realtime-scale/README.md)
- [Cloudflare - Edge Platform](../../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- [Uber - Cadence Workflows](../../real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)

## Ideias de implementacao em Rails

- modularizar boundary antes de distribuir fisicamente
- tornar retries, timeouts e state transitions explicitos
- deixar limiters e politicas de borda configuraveis, nao espalhados em controller
- medir o ponto em que o app deixa de ser boa ferramenta para realtime pesado

## Quando comparar com Elixir ou Go

- Elixir:
  - quando o problema central e concorrencia, isolamento por processo e recovery
- Go:
  - quando o problema central e servico enxuto, borda, utilitario de infra ou throughput previsivel
- Rails:
  - quando o aprendizado principal ainda e dominio, boundary e operacao de produto
