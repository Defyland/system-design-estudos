# Narrativa Final - Backend Ruby / Rails

> Curriculo alvo: `allan_resume_fullstack_en.pdf`. Leia com pausas. A narrativa corrida e base de 6-8 min; a secao de Q&A de Reserva no fim e municao de follow-up - so puxe quando o entrevistador cavar.

---

## Abertura

Tenho mais de dez anos trabalhando com Ruby on Rails e sistemas backend, com base full stack. Vou seguir em ordem cronologica porque mostra bem a evolucao da minha carreira: comecei resolvendo integracao externa, confiabilidade e produto full stack; depois fui para arquitetura Rails, performance, pagamento, seguranca, sistemas financeiros regulados e mensageria em escala.

O fio condutor e sempre o mesmo: eu identifico onde esta o acoplamento, o risco ou o gargalo; crio uma fronteira tecnica; garanto consistencia; reduzo latencia; e deixo o sistema mais operavel.

---

## Fulllab / Total Commit - 2016 a 2018

Na Fulllab / Total Commit, trabalhei em produtos full stack com backend Rails, React e React Native. Os dois projetos mais relevantes para backend foram a Easylive, uma plataforma de troca de pontos integrada a multiplas APIs de loyalty, e o OJK, com notificacoes baseadas em geolocalizacao.

Na Easylive, o problema nao era simplesmente consumir APIs externas. O problema era confiabilidade. Cada provider de loyalty tinha autenticacao, payload, rate limit, timeout, disponibilidade e semantica de erro diferentes. Se a regra de negocio falasse diretamente com cada provider, qualquer mudanca externa contaminaria o dominio interno.

Entao eu colocava cada provider atras de um adapter, funcionando como uma anti-corruption layer. A aplicacao trabalhava com um contrato interno estavel, e cada adapter traduzia autenticacao, payload, formato de erro e resposta externa para esse contrato. O motivo era isolamento: se um provider mudasse contrato ou ficasse instavel, o impacto ficava localizado na integracao, nao espalhado pelo dominio.

Tudo que nao precisava estar no request sincronono ia para Sidekiq. Mas job assincrono precisa ser desenhado para falha. Sidekiq tem comportamento at-least-once: em retry, timeout ou crash, o mesmo job pode rodar mais de uma vez. Entao eu tratava jobs como operacoes idempotentes, com status de sincronizacao, checagem de estado antes do efeito colateral e, quando necessario, lock no agregado. O objetivo era evitar duplicar saldo, sobrescrever dado novo com resposta velha ou travar o fluxo principal por causa de provider externo.

No OJK, o desafio era geolocalizacao. A pergunta era: quem esta dentro deste raio? Calcular distancia em Ruby nao escala, porque eu precisaria carregar registros demais em memoria para depois filtrar. A abordagem correta era usar PostGIS, deixando o banco fazer a consulta geoespacial com indice espacial. Assim o dataset ja chegava reduzido para o Rails.

Para realtime, eu teria cuidado com o termo dependendo da versao do Rails. Se a fase ja estava em Rails 5, Action Cable e plausivel. Se era Rails 4 ou inicio do periodo, eu prefiro falar em realtime delivery com WebSockets, pub-sub ou polling fallback. O ponto tecnico era separar deteccao geografica da entrega da notificacao: query pesada nao ficava no request principal, e a entrega era escopada, autenticada e assincrona.

O ganho tecnico nessa fase foi aprender a isolar instabilidade externa, controlar efeitos assincronos e evitar que integracao, geolocalizacao ou realtime virassem gargalos do dominio principal.

---

## Sonata - 2018 a 2019

Na Sonata, trabalhei em uma plataforma internacional de e-commerce com Rails API, React, React Native e TypeScript. O problema era manter a API sustentavel conforme o produto crescia.

Em e-commerce, fluxos como carrinho, cupom, frete, pedido, estoque e pagamento tendem a virar controller gordo, model inchado ou callback escondido. Isso dificulta teste, manutencao e mudanca segura.

Minha abordagem foi aplicar SOLID de forma pragmatica. Eu nao criava service object para qualquer CRUD. Extraia quando o fluxo tinha multiplos passos, multiplos models ou efeitos colaterais. Controller ficava com request e response. Model ficava com persistencia e invariantes locais. Use case ou service ficava com orquestracao do fluxo e transaction boundary explicita.

O motivo disso era localizar mudanca e risco. Se a regra de frete mudasse, eu sabia onde mexer. Se o fluxo criava pedido, aplicava cupom, calculava frete e chamava pagamento, eu conseguia testar o caso de uso sem depender do controller inteiro.

Tambem trabalhei com performance de banco em fluxos core. Em e-commerce, latencia em listagem, carrinho ou checkout impacta diretamente conversao. Eu nao otimizava no chute. Primeiro olhava padrao de acesso, query lenta, N+1, joins, payload e carregamento de colunas. Depois escolhia a tecnica: preload, includes ou eager_load conforme o caso; indice em filtro, foreign key e ordenacao; reducao de payload; e counter cache ou agregacao no banco quando havia contagem repetida.

A diferenca entre essas tecnicas importa. Preload faz queries separadas. Eager load usa LEFT JOIN. Includes decide automaticamente, mas pode virar JOIN quando a associacao e usada em where ou order. Escolher errado pode resolver N+1, mas criar join desnecessario e piorar performance.

O ganho nessa fase foi tornar o legado mais previsivel: menos regra espalhada, menos callback escondido, fluxo de negocio mais testavel e hot paths de e-commerce com resposta melhor.

---

## Globo / Stormgroup / Projac - 2019 a 2020

Na Globo, o backend mais relevante para contar e pagamento em escala, performance de APIs e reducao de risco operacional com CI/CD.

O sistema processava pagamentos para milhoes de clientes mensais em multiplas plataformas. Em pagamento, o primeiro ponto era reduzir exposicao de dado sensivel. O backend nao deveria trafegar ou armazenar cartao cru se pudesse operar com token do gateway. Tokenizacao reduz risco porque o sistema passa a trabalhar com uma referencia segura, nao com PAN/cartao diretamente.

O segundo ponto era estado transacional. Timeout de gateway nao significa pagamento recusado. Significa estado desconhecido. Se eu dou retry cego, posso duplicar cobranca. Entao o fluxo precisa persistir estado pendente, suportar confirmacao posterior, webhook ou conciliacao. Retry so e seguro quando existe idempotencia.

Tambem trabalhei em performance de endpoints criticos, com tuning em PostgreSQL e MariaDB. O caminho era analisar plano de execucao, identificar full scan, ajustar indice e reduzir query cara em hot path. Em backend, a otimizacao correta comeca entendendo onde esta o custo: banco, serializacao, rede, query mal indexada ou chamada externa.

Alem disso, CI/CD e deploy sem downtime reduziram risco operacional. Em Rails, o cuidado principal e migration compativel: nao remover ou renomear coluna usada por versao antiga durante rollout. O padrao seguro e expand/contract: adiciona estrutura nova, deploya codigo compativel, migra dados e so depois remove legado.

O ganho tecnico foi reduzir risco em tres pontos criticos: pagamento, performance de API e processo de release.

---

## Enjoei - 2020 a 2021

No Enjoei, entrei forte em Application Security, no Yellow Team, trabalhando em cima de findings do Red Team. A mentalidade aqui era nao corrigir so o endpoint reportado; era fechar a classe inteira do problema.

Um exemplo forte e IDOR, Insecure Direct Object Reference. O erro comum e buscar recurso por ID global. O usuario esta autenticado, mas isso nao significa que ele esta autorizado a acessar aquele objeto. Autenticacao responde "quem e voce". Autorizacao responde "voce pode acessar este recurso especifico?".

Entao a correcao nao era so adicionar um if. Era mudar o padrao de acesso. Em vez de buscar recurso globalmente, a query precisava nascer do contexto autorizado: usuario, tenant, organization ou policy scope. Isso reduz enumeracao, evita vazamento de existencia do recurso e torna a autorizacao sistematica.

Tambem trabalhei com mass assignment e privilege escalation. O payload do cliente nunca pode decidir role, admin, tenant_id, owner_id ou ownership. Isso precisa vir do contexto autenticado e passar por policy. Strong parameters ajudam, mas falham se alguem usa permit amplo demais ou permite atributo sensivel.

Em SQL injection, ActiveRecord protege quando usado corretamente, mas nao protege interpolacao manual em where, order dinamico, find_by_sql ou nome de coluna vindo do cliente. Valor dinamico usa bind parameter. Identificador dinamico precisa de allowlist.

No checkout, apliquei Clean Architecture de forma pragmatica. O ponto nao era criar uma arvore de pastas com domain, application, infra, ports e adapters. O nucleo real era a regra de dependencia: dependencias apontam para dentro. A regra de negocio nao deveria depender diretamente de controller, HTTP, banco, framework, fila ou gateway externo. Rails pode conhecer a regra de negocio, mas a regra de negocio nao deveria precisar conhecer Rails.

Conceitualmente, as camadas seriam: entidades no centro, com regra de negocio mais pura; use cases como regra de aplicacao e orquestracao; interface adapters como controllers, presenters, serializers e gateways; e frameworks/drivers na borda, como Rails, banco, Sidekiq, Kafka, RabbitMQ e servicos externos.

O motivo disso e proteger o dominio de detalhes volateis. Framework muda, banco muda, transporte muda, gateway muda. A regra de negocio e o ativo que mais dura.

Mas existe uma tensao real com Rails: ActiveRecord viola Clean Architecture pura por design. Um model que herda de ApplicationRecord ja conhece banco, validacoes do framework, callbacks e persistencia. Em Clean Architecture puro, eu teria entidades Ruby puras e repositories traduzindo para ActiveRecord na borda.

So que, em muitos sistemas Rails, esse isolamento completo nao paga o custo. Voce duplica modelo, perde produtividade do ActiveRecord, cria indirecao e aumenta complexidade sem ganho proporcional.

Entao minha posicao e pragmatica: eu aplico o espirito, nao o dogma. Extraio use cases para orquestracao de fluxos criticos, desacoplo efeitos externos com gateways/adapters, deixo autorizacao em policies, explicito transaction boundary, uso Result object para resposta de dominio quando faz sentido, mas mantenho ActiveRecord onde ele continua sendo uma boa ferramenta.

Eu so introduzo repository quando existe dor real: multiplas fontes de dados, regra que precisa ser testada sem banco, queries muito complexas, troca de persistencia, ou quando ActiveRecord comeca a vazar detalhe demais para o fluxo de negocio.

No checkout, essa dor existia porque o fluxo envolvia pedido, pagamento, validacao, antifraude, autorizacao e dados sensiveis. Se isso fica espalhado em controller, model, callback e job, o sistema fica dificil de auditar, dificil de testar e facil de quebrar.

Entao eu centralizava a orquestracao em um use case ou service de aplicacao. O controller ficava fino, so traduzindo HTTP. O use case coordenava validacao de estado, autorizacao, transacao, chamada de gateway, auditoria e efeitos assincronos. Ao mesmo tempo, desacoplava detalhes: gateway externo atras de adapter, autorizacao em policy, auditoria isolada e retorno de dominio em Result object.

SOLID entrava como heuristica de acoplamento, nao como religiao.

Single Responsibility me ajudava a separar motivos de mudanca. Se a mesma classe mudava por HTTP, regra de negocio, pagamento e auditoria, ela tinha responsabilidades demais.

Open/Closed fazia sentido quando havia eixo real de variacao, como multiplos gateways, tipos de pagamento ou estrategias de validacao. Nesses casos, strategy ou polimorfismo era melhor do que if/else crescendo indefinidamente.

Liskov, em Ruby, aparecia como contrato comportamental. Nao basta o objeto responder ao mesmo metodo; ele precisa se comportar como o caller espera. Isso importa muito em adapters e gateways.

Interface Segregation aparecia como modulos pequenos e coesos, evitando mixins gordos que forcam uma classe a carregar comportamento que nao usa.

Dependency Inversion aparecia quando fluxo de alto nivel nao deveria instanciar diretamente HTTP client, gateway concreto ou servico externo. Quando havia dor real de teste, troca de implementacao ou isolamento de efeito externo, eu injetava a dependencia.

O ganho disso no Enjoei nao era "arquitetura bonita". Era reduzir superficie de ataque, tornar checkout mais auditavel, facilitar teste de regra critica, remover side effects escondidos e impedir que a mesma vulnerabilidade voltasse em outro fluxo.

---

## Bornlogic / Farfetch / Spring Global - 2022 ate agora

Na fase mais recente, o nivel de escala aumentou bastante. Trabalhei com Rails APIs de alto volume, plataforma financeira regulada, Kafka, RabbitMQ, Docker, Kubernetes e lideranca tecnica.

Em APIs Rails com 100M+ requests por dia, qualquer ineficiencia pequena vira custo grande. Uma query sem indice, serializer pesado, N+1, payload excessivo, connection pool saturado ou chamada externa dentro do request lifecycle vira gargalo real.

Eu comecava por medicao, nao por opiniao. A base era APM, tracing, p95, p99, throughput por endpoint, slow query logs e decomposicao do tempo de resposta: banco, Ruby, serializer, rede e chamada externa.

Os gargalos mais comuns nesse volume sao:

**Connection pool de banco.** Se a concorrencia da aplicacao e maior que o pool disponivel, requests comecam a esperar conexao. Parece lentidao generica, mas e contencao.

**Banco.** Query sem indice em hot path domina latency budget. Aqui entram EXPLAIN ANALYZE, indice composto ou parcial quando faz sentido, remocao de N+1 e reducao de leitura desnecessaria.

**Ruby e GC.** Alto volume significa muita alocacao por request. Se a aplicacao materializa colecoes grandes ou serializers criam objetos demais, isso aparece no p99.

**Serializacao e payload.** JSON pesado custa CPU e banda. Campo que o client nao usa e custo sem valor.

**Chamada externa.** Se uma API externa esta dentro do request, minha latencia fica acoplada a dela. Quando possivel, eu movia para fila ou evento. Quando precisava ser inline, usava timeout curto e tratamento de falha.

Em sistema financeiro, idempotencia e requisito de design. Retry errado duplica transacao. Timeout nao e falha definitiva. Mensagem duplicada e cenario esperado. Entao a operacao precisava ter idempotency key persistida com unique constraint no banco. Validacao so na aplicacao nao resolve corrida; duas requisicoes simultaneas podem passar ao mesmo tempo. Quem arbitra duplicidade com seguranca e o banco.

A operacao rodava em transacao e tinha estado explicito: pending, processing, completed, failed ou waiting_reconciliation. Se a mesma key chegasse de novo, o sistema retornava o resultado original ou o status atual, sem reexecutar o efeito externo. Quando duas operacoes podiam alterar o mesmo agregado, como conta ou transferencia, o lock precisava estar no agregado certo: lock demais reduz throughput; lock de menos permite corrida.

Com mensageria, usei o padrao de outbox para resolver dual-write. O problema classico e: banco commitou, mas o evento nao publicou; ou evento publicou e o banco rollbackou. Com outbox, a operacao e o evento sao gravados na mesma transacao do banco. Depois um worker publica. Se o broker falha, o evento continua persistido para retry. Isso garante que o evento representa algo realmente commitado.

Tambem trabalhei com RabbitMQ e Kafka, cada um para um tipo de problema. RabbitMQ e forte para task queue, routing, ack manual, nack, retry e dead-letter queue. E adequado quando voce quer processamento transacional de tarefas e controle de confirmacao. Kafka e diferente: e um log distribuido append-only, com retencao, replay e multiplos consumidores lendo o mesmo stream com offsets proprios. Usei Kafka para desacoplar servicos via eventos.

O motivo de Kafka era remover gargalos sincrononos. Antes, uma operacao dependia de varios servicos respondendo em cadeia. Isso acumula latencia e propaga falha. Com event-driven, o servico principal persiste estado e publica evento; consumidores processam independentemente.

Mas Kafka nao e magica. Voce troca simplicidade de chamada sincronona por consistencia eventual, ordering, DLQ, replay, schema versioning e idempotencia no consumer. A premissa honesta e at-least-once delivery com consumidor idempotente. Exactly-once fim a fim, atravessando banco e API externa, depende de idempotencia desenhada na aplicacao.

Tambem considero observabilidade parte do desenho, nao pos-producao. Em APIs de alto volume, eu preciso saber onde o sistema esta quebrando: p95, p99, error rate, throughput, slow queries, tempo em banco, tempo de serializer, latencia de chamada externa, saturacao de connection pool, fila do Sidekiq, retries, dead jobs, DLQ e consumer lag em Kafka.

Em incidente, minha ordem e: entender impacto, estabilizar, reduzir blast radius, achar o gargalo dominante, aplicar mitigacao segura e depois fazer postmortem. No meio do incidente, eu nao comeco refactor grande. Eu estabilizo primeiro.

O resultado dessa fase foi trabalhar com backend em escala maior: APIs Rails de alto volume, reducao de latencia em servico de pagamento, plataforma financeira com rastreabilidade, mensageria, confiabilidade e operacao previsivel.

---

## Testes - visao transversal

Sobre testes, eu nao trato como "ter cobertura". Eu trato como controle de risco. A pergunta principal nao e so quanto de coverage existe, mas qual risco aquele teste esta reduzindo.

No backend Rails, eu separo por tipo. Unit specs servem para regra isolada: service pequeno, policy, validator, parser, calculo ou objeto de dominio. Request specs servem para API real: rota, autenticacao, autorizacao, params, status HTTP, serializer e contrato de resposta. Integration specs servem para fluxos com banco, transacao, multiplos models, jobs ou side effects. System ou E2E specs ficam para jornada critica, porque sao mais lentos e frageis.

Em legado, eu nao comeco tentando cobrir tudo. Primeiro identifico hot paths: checkout, pagamento, autorizacao, jobs criticos, webhooks, conciliacao e endpoints de alto volume. Antes de refatorar, escrevo characterization tests para congelar o comportamento atual. Depois extraio o fluxo com seguranca. Se encontro bug, escrevo teste que reproduz o bug antes da correcao. Esse teste vira regressao.

Em seguranca, teste e parte da correcao. Para IDOR, crio usuario A e usuario B; A tenta acessar recurso de B; espero 404 ou 403. Para privilege escalation, mando payload tentando setar admin, role, tenant_id ou owner_id. Para mass assignment, garanto que atributos sensiveis sao ignorados ou bloqueados. Para injection ou order injection, testo input fora da allowlist.

Em sistemas financeiros, eu testo idempotencia e concorrencia. Mesmo request duas vezes com a mesma idempotency key nao pode duplicar efeito. Operacao pending nao pode virar completed por acidente. Timeout de gateway precisa gerar estado desconhecido ou reconciliavel, nao sucesso ou falha definitiva.

Em mensageria, testo o consumer como idempotente. Kafka e RabbitMQ podem entregar mensagem mais de uma vez. Entao processar o mesmo evento duas vezes nao pode duplicar pagamento, auditoria, saldo ou notificacao critica. Tambem testo payload invalido, retry, DLQ e falha parcial.

Sobre Minitest vs RSpec: Rails vem com Minitest por padrao. Ele e simples, rapido, tem pouca DSL e combina bem com a filosofia Rails. Para projetos menores ou times que preferem simplicidade, e uma boa escolha. RSpec tem mais DSL, expressividade e ecossistema forte para mocks, matchers, shared examples, request specs e organizacao de cenarios complexos. Em times Rails maiores, principalmente com BDD/TDD e muitos fluxos de negocio, RSpec costuma ser mais legivel e produtivo. Eu nao trataria como religiao. A escolha depende do time e do projeto. O problema nao e ferramenta; e teste que nao protege risco real.

Com mocks e stubs, eu uso principalmente em boundaries externos: gateway de pagamento, API de terceiro, fila, email e storage. Nao gosto de mockar ActiveRecord ou comportamento interno demais, porque o teste fica acoplado a implementacao.

A frase que resume minha visao de testes e: teste bom protege decisao importante; teste ruim so congela implementacao.

---

## Transaction boundary, erro e contratos de API

Em Rails, uma das coisas que mais diferencia codigo senior e saber onde comeca e termina a transacao. Em fluxo simples, ActiveRecord resolve bem. Mas em fluxo critico - pagamento, checkout, transferencia, cancelamento, conciliacao - a transacao precisa ser explicita.

Dentro da transacao ficam mudancas de estado que precisam ser atomicas. Fora da transacao ficam efeitos externos que nao participam do rollback: email, chamada HTTP, gateway, broker publish direto. Se preciso acoplar mudanca de estado e evento, uso outbox: gravo operacao e evento na mesma transacao; depois worker publica.

Tambem tomo cuidado com lock. Row-level lock resolve concorrencia no agregado certo, mas lock demais reduz throughput. Entao uso lock quando duas operacoes concorrentes podem quebrar invariante: saldo, status de pagamento, transferencia, estoque, assinatura.

Sobre error handling, eu separo erro esperado de erro inesperado. Erro esperado e dominio: cartao recusado, pedido invalido, usuario sem permissao, saldo insuficiente, assinatura ja cancelada. Isso pode ser Result object. Erro inesperado e bug, indisponibilidade nao tratada, falha de infraestrutura, nil inesperado, erro de banco ou timeout fora do previsto. Isso pode subir excecao, ser logado e monitorado. Para erro esperado, gosto de Result object quando o fluxo e critico: success/failure, payload, error code e mensagem de dominio. O controller traduz isso para HTTP. Isso evita usar exception como controle normal de fluxo.

Em API design, eu penso em contrato. API boa nao e so endpoint funcionando. Precisa ter status HTTP coerente, erro padronizado, idempotencia em operacoes mutaveis criticas, paginacao em listagens, filtros explicitos, payload enxuto, versionamento quando mudanca quebra contrato, autorizacao no backend e serializers sem vazamento de dado sensivel.

Em APIs de alto volume, payload importa. Campo que o client nao usa custa CPU, memoria, rede e serializacao. Entao eu tento manter resposta enxuta e previsivel. Tambem evito endpoint que faz operacao pesada demais de forma sincronona. Se o request dispara processamento longo e o dominio permite, prefiro responder 202 Accepted com status rastreavel e processar via job ou evento.

---

## Fechamento

Resumindo minha trajetoria backend: comecei com integracoes externas, Sidekiq, PostGIS e confiabilidade; evolui para arquitetura Rails, SOLID e performance de banco; depois pagamento, tokenizacao e CI/CD; depois Application Security e Clean Architecture pragmatica; e hoje atuo com Rails em alto volume, sistema financeiro regulado, idempotencia, outbox, RabbitMQ, Kafka e lideranca tecnica.

Alem de Rails, banco e mensageria, eu destacaria tres preocupacoes transversais na minha forma de trabalhar: teste, boundary e operacao. Teste, porque refatorar legado, checkout, seguranca ou sistema financeiro sem teste e risco desnecessario. Boundary, porque muitos problemas vem de regra espalhada: controller sabendo demais, model com callback perigoso, gateway externo acoplado ao dominio ou servico sincronono bloqueando outro. Operacao, porque sistema senior nao e so codigo limpo. Ele precisa ser observavel, idempotente, recuperavel e seguro para reprocessamento.

O padrao e: eu nao escolho tecnologia por moda. Eu olho onde esta o risco: acoplamento, latencia, inconsistancia, falha de seguranca ou gargalo operacional. Depois crio a fronteira certa, garanto consistencia, reduzo custo por request e deixo o sistema mais previsivel.

---

## Q&A de Reserva - Follow-ups Tecnicos

> Nao estao na narrativa corrida de proposito. Use so quando o entrevistador cavar - cada um sustenta um ponto que a narrativa toca de leve.

### 1. Locking otimista vs pessimista

**Q: Como voce escolhe entre lock otimista e pessimista numa operacao financeira?**

Pessimista (`SELECT FOR UPDATE` / `lock!`) segura a linha - uso sob alta contencao no mesmo agregado, tipo saldo de conta quente, onde retry constante seria pior que esperar o lock. Otimista (`lock_version` do Rails) nao bloqueia: detecta conflito no commit e levanta `StaleObjectError` para retry - uso sob baixa contencao, onde conflito e raro e o lock seguraria throughput a toa. O criterio e probabilidade de conflito, nao preferencia. Em ambos, transacao curta.

### 2. Isolation level e deadlock

**Q: Qual isolation level voce usa e como lida com deadlock?**

O default do Postgres e Read Committed, suficiente para a maioria. Subo para Repeatable Read ou Serializable quando preciso evitar anomalia como lost update ou write skew - o custo e serialization failure, entao o codigo tem que ter retry da transacao. Deadlock vem de ordem de aquisicao de lock inconsistente entre transacoes; mitigo lockando agregados sempre na mesma ordem e mantendo a transacao curta. Deadlock em sistema financeiro e esperado, nao exotico - o design assume retry.

### 3. Modelo de threading do Ruby (GVL)

**Q: Por que aumentar threads no Puma nem sempre melhora throughput?**

Ruby tem a GVL: threads nao executam codigo Ruby em paralelo, so liberam a GVL durante I/O. Entao threads ajudam em Rails porque a maioria dos requests e I/O-bound. Se o gargalo for CPU, aumentar thread piora contencao; nesse caso eu escalo com processos ou workers, ou reduzo CPU por request. Para paralelismo real de CPU voce precisa de processos - workers do Puma, que forkam. Por isso o connection pool tem que casar com `threads x workers`, senao satura. E o mesmo motivo de Sidekiq concorrente funcionar: jobs costumam ser I/O-bound.

### 4. Migration em escala

**Q: Como adiciona indice numa tabela de milhoes de linhas sem downtime?**

`add_index ... algorithm: :concurrently` com `disable_ddl_transaction!`, para nao pegar lock exclusivo na tabela durante a criacao. Coluna nova com backfill em lote via `in_batches`, nunca um `UPDATE` unico que segura lock e infla o WAL. `lock_timeout` e `statement_timeout` para a migration falhar rapido em vez de enfileirar request atras de um DDL travado. Ferramentas como `strong_migrations` podem funcionar como guardrail no CI, mas o ponto principal e a estrategia: migration compativel, indice concorrente, backfill em lote e timeout configurado.

### 5. Estrategia de cache

**Q: Como voce usa cache em API de alto volume?**

`Rails.cache` low-level com read-through e invalidacao por key versionada - mudo a key em vez de apagar, evitando race de invalidacao. Em leitura quente, cache ajuda muito, mas eu nao uso cache para esconder query ruim sem entender a causa. Primeiro eu entendo o padrao de acesso; depois decido se o gargalo pede indice, query tuning, cache ou mudanca de arquitetura. Em projetos desse tipo, abordagens como TTL escalonado, jitter ou protecao de regeneracao podem ajudar quando expiracao simultanea comeca a bater forte no banco. Redis como cache, com TTL e descartavel, e decisao diferente de Redis como store duravel.

### 6. Graceful shutdown

**Q: O que acontece com requests e jobs em andamento durante um deploy?**

No SIGTERM, o pod precisa drenar: o Puma para de aceitar conexao nova e termina as in-flight; o Sidekiq para de puxar job novo e deixa o atual terminar dentro do `terminationGracePeriod`. A readiness probe tira o pod do balanceador antes de matar. Sem isso, o deploy corta transacao no meio. Isso liga direto com idempotencia: o retry do job que morreu so e seguro porque o job e idempotente.

### 7. Saga / transacao compensatoria

**Q: Como garante consistencia numa operacao que cruza varios servicos?**

Quando a operacao cruza varios servicos e nao existe transacao distribuida viavel, a abordagem que eu usaria e saga: a operacao vira uma sequencia de passos locais, cada um com uma transacao compensatoria - um undo. Se um passo falha, executo as compensacoes dos passos anteriores em ordem reversa. Orquestracao, com um coordenador central, quando o fluxo e complexo e precisa de visibilidade; coreografia, onde cada servico reage a evento, quando e simples. E consistencia eventual com compensacao explicita, nao rollback distribuido.

### 8. Paginacao keyset

**Q: Por que offset pagination degrada em escala e o que usa no lugar?**

`OFFSET N` faz o banco varrer e descartar N linhas antes de retornar - em pagina alta vira scan caro, e ainda fica instavel se ha insercao entre requests, porque pula ou repete linha. Keyset ou cursor, por exemplo `WHERE id > :last_seen ORDER BY id LIMIT n`, usa o indice direto, e O(1) por pagina e estavel sob insercao. O custo e nao poder pular para pagina arbitraria, so next/prev - aceitavel em feed e scroll infinito, que e o caso de alto volume.

### 9. Multi-tenancy e data leakage

**Q: Como evita vazamento entre tenants?**

Tenant precisa estar no modelo de dados, nas queries, nas policies e nos testes. Eu nao dependo de filtro manual solto em controller. Todo acesso sensivel precisa nascer do tenant ou do current_user, ou passar por policy scope. Tambem testo usuario de um tenant tentando acessar recurso de outro, porque esse tipo de vazamento costuma aparecer em endpoint aparentemente simples.

### 10. Webhooks

**Q: Como processa webhook com seguranca?**

Primeiro valido assinatura e origem. Depois persisto o evento bruto com um `external_event_id` unico para idempotencia. O processamento real pode ir para job. Se o mesmo webhook chegar duas vezes, eu nao duplico efeito. Tambem gosto de separar evento recebido de evento processado, porque isso melhora replay, auditoria e investigacao de incidente.

### 11. Background jobs vs eventos

**Q: Quando usar job e quando usar evento?**

Job e comando interno: "faca essa tarefa". Evento e fato de dominio: "algo aconteceu". Sidekiq ou RabbitMQ funcionam bem para trabalho assincrono dirigido. Kafka faz mais sentido quando multiplos consumidores precisam reagir de forma independente ao mesmo fato, com retencao e replay. O criterio nao e a ferramenta em si; e o tipo de acoplamento e fan-out que o problema pede.

### 12. Fat model vs service object

**Q: Rails nao recomenda fat model?**

Fat model e melhor do que fat controller, mas nao significa colocar todo fluxo no model. Invariante local fica muito bem no model. Orquestracao com multiplos models, transacao, gateway, job, auditoria ou side effect costuma ficar melhor em use case ou service. O ponto e separar regra local de fluxo de negocio.

### 13. Callbacks

**Q: Callback e sempre ruim?**

Nao. Callback para normalizacao simples, como `downcase` de email, pode ser ok. Callback perigoso e o que dispara efeito colateral: cobranca, email, publish, job ou auditoria critica. Esse tipo eu prefiro mover para fluxo explicito, porque fica mais facil testar, auditar e controlar ordem de execucao.

### 14. Experiencia com Kafka

**Q: Qual foi sua experiencia com Kafka e por que voce introduziu Kafka no sistema?**

Eu uso Kafka quando o problema pede desacoplamento por eventos, replay e multiplos consumidores independentes. No curriculo, o ponto forte e que Kafka entrou para remover gargalos sincrononos em servicos criticos. A leitura senior dessa decisao e: antes, uma operacao dependia de varias chamadas em cadeia; isso aumentava latencia e propagava falha. Com eventos, o servico principal persiste o estado, publica um fato de dominio e os consumidores processam em seu proprio ritmo.

Eu nao venderia Kafka como fila generica. Eu explicaria que ele faz sentido quando o evento precisa ser retido, reprocessado, consumido por mais de um servico ou usado para auditoria e integracao entre dominios. O custo e maior complexidade: schema versioning, ordering por chave, consumer lag, DLQ ou topico de erro, replay seguro e idempotencia no consumer.

### 15. Kafka na pratica

**Q: Como voce desenharia um consumer Kafka idempotente?**

Eu assumo entrega at-least-once. O consumer pode receber a mesma mensagem de novo por retry, rebalance ou falha depois de processar e antes de commitar offset. Entao o efeito no banco precisa ter uma chave de deduplicacao: event id, idempotency key ou chave natural do dominio. A operacao roda em transacao curta; se a chave ja foi processada, retorno sem duplicar efeito.

Tambem separo tres estados: evento recebido, processamento aplicado e falha recuperavel. Offset so deve avancar quando o efeito local ficou consistente. Se a falha for permanente por payload invalido, eu mando para DLQ/topico de erro com contexto suficiente para investigar. Se for falha transitoria, retry com backoff.

### 16. Kafka vs RabbitMQ

**Q: Quando voce escolheria Kafka e quando escolheria RabbitMQ?**

RabbitMQ e melhor quando eu penso em tarefa: "execute este trabalho", com ack manual, retry, routing, dead-letter e controle de fila. Kafka e melhor quando eu penso em fato de dominio: "isso aconteceu", com retencao, replay, ordering por particao e multiplos consumidores lendo o mesmo historico.

Se eu tenho envio de email, job de processamento, integracao pontual ou task queue, RabbitMQ ou Sidekiq podem ser mais simples. Se eu tenho varios servicos que precisam reagir a pagamentos, pedidos, conciliacao ou eventos financeiros, Kafka tende a encaixar melhor. A escolha senior e pelo modelo de acoplamento, nao pela ferramenta mais sofisticada.

### 17. Outbox

**Q: Como voce evita o problema de banco commitado mas evento nao publicado?**

Eu uso outbox. A mudanca de dominio e o registro do evento sao gravados na mesma transacao do banco. Depois um worker publica o evento no broker e marca a outbox como publicada. Se o broker cair, o evento continua persistido para retry. Se a transacao do banco rollbackar, o evento nunca existiu.

Esse padrao resolve o dual-write classico: nao tento fazer commit no banco e publish externo como se fossem uma unica transacao distribuida. Eu aceito consistencia eventual, mas torno o caminho recuperavel, auditavel e reprocessavel.

### 18. Clean Architecture no Rails

**Q: Como voce implementou Clean Architecture em Rails sem virar overengineering?**

Eu apliquei o principio, nao o dogma. Em Rails, ActiveRecord e produtivo e conhece persistencia por design, entao eu nao duplicaria todas as entidades em POROs e repositories sem dor real. O que eu separo com mais disciplina sao fluxos criticos: checkout, pagamento, autorizacao, antifraude, conciliacao, jobs e integracoes externas.

O controller traduz HTTP. Policy cuida de autorizacao. O use case orquestra a operacao, define transaction boundary, chama adapters/gateways e devolve um resultado de dominio. ActiveRecord ainda pode representar persistencia e invariantes locais. Gateway externo fica atras de interface/adaptador, porque gateway muda, timeout falha e teste precisa isolar esse efeito.

### 19. Arquitetura de checkout

**Q: Se voce fosse redesenhar um checkout Rails, como faria?**

Eu comecaria pelos invariantes: usuario autorizado, carrinho valido, estoque/reserva, preco calculado, cupom, pagamento, antifraude, estado do pedido e auditoria. Depois separaria o fluxo em um use case explicito, com transacao apenas para mudancas atomicas locais. Chamada externa para gateway nao fica escondida em callback de model.

Pagamento precisa de idempotency key. Timeout do gateway vira estado pendente ou reconciliavel, nao sucesso nem falha definitiva. Evento de pedido/pagamento deve sair por outbox. O controller so chama o caso de uso e traduz resultado para HTTP: sucesso, conflito, validacao, recusado, pendente ou erro inesperado.

### 20. Arquitetura de API nova

**Q: Como voce faria a arquitetura de uma feature nova de backend do zero?**

Eu faria quatro perguntas antes de falar de stack: qual e o contrato da API, qual e o dado que precisa ficar consistente, qual e a carga esperada e quais falhas precisam ser toleradas. A partir disso eu escolho se o fluxo e sincronono, assincrono, eventual, transacional ou orientado a evento.

Em Rails, eu normalmente comeco simples: rota, controller fino, model com invariantes locais, policy, migration com constraints e teste de request. Se o fluxo crescer para varios models, gateway, job, auditoria ou pagamento, extraio um use case. Se virar integracao externa, adapter. Se precisar emitir evento confiavel, outbox.

### 21. APIs Rails de alto volume

**Q: Voce fala em APIs Rails com 100M+ requests por dia. Onde voce olha primeiro para otimizar?**

Eu olho medicao, nao opiniao. Primeiro p95/p99 por endpoint, throughput, erro, tempo em banco, tempo de serializacao, chamadas externas e saturacao de connection pool. Em Rails de alto volume, os problemas comuns sao N+1, query sem indice, serializer pesado, payload grande, alocacao demais em Ruby, cache mal usado e chamada externa dentro do request path.

Depois eu ataco o gargalo dominante. Se for banco, `EXPLAIN ANALYZE`, indice composto/parcial, reducao de colunas e batch. Se for serializer, payload menor e menos objetos. Se for pool, ajusto threads/workers/pool e removo queries desnecessarias. Se for chamada externa, timeout curto, fila ou evento quando o dominio permitir.

### 22. Latencia em pagamento

**Q: O que significa reduzir latencia de servico de pagamento sem sacrificar corretude?**

Significa acelerar o caminho seguro, nao pular garantia. Eu separaria o que precisa ser sincronono do que pode ser posterior. Validacao de entrada, autorizacao, criacao da tentativa e chamada necessaria ao gateway podem ficar no fluxo principal. Auditoria secundaria, notificacao, enriquecimento e integracao downstream podem ir para job/evento.

No banco, eu procuraria query lenta, lock longo, falta de indice, payload grande e serializer pesado. Em pagamento, toda otimizacao precisa preservar idempotencia, estado explicito e reconciliacao. Se o gateway da timeout, eu nao assumo falha definitiva; deixo estado pendente e trato por webhook ou conciliacao.

### 23. Seguranca e IDOR

**Q: Como voce corrigiria IDOR em Rails de forma sistematica?**

Eu nao corrigiria so o endpoint reportado. Eu mudaria o padrao de busca. Em vez de `Order.find(params[:id])`, o acesso nasce do contexto autorizado: `current_user.orders.find(params[:id])`, tenant scope ou policy scope. Assim o usuario nao consegue enumerar objeto global fora do proprio escopo.

Depois eu coloco teste negativo: usuario A tentando acessar recurso de usuario B deve receber 404 ou 403. Tambem reviso serializers para nao vazar dado e strong parameters para impedir mass assignment de `role`, `tenant_id`, `owner_id` ou campos de permissao.

### 24. Plataforma financeira regulada

**Q: O que muda quando o backend e financeiro ou regulado?**

Muda o nivel de tolerancia a ambiguidade. Operacao financeira precisa de idempotencia, trilha de auditoria, estados explicitos, reconciliacao, controle de acesso, logs sem vazar dado sensivel e capacidade de reprocessar com seguranca. Retry nao pode duplicar transacao. Timeout nao pode virar "acho que falhou".

Tambem muda o cuidado com deploy e migration. Schema precisa ser compativel durante rollout. Jobs e consumers precisam ser idempotentes. Toda integracao critica precisa ter observabilidade: taxa de erro, retries, DLQ, lag, latencia e divergencia de conciliacao.

### 25. Refatoracao de legado

**Q: Como voce refatora legado Rails sem quebrar producao?**

Primeiro eu congelo comportamento com characterization tests nos hot paths. Depois identifico o risco dominante: controller gordo, callback perigoso, query lenta, autorizacao espalhada ou integracao acoplada. A mudanca vem em fatias pequenas, com teste de regressao e deploy seguro.

Eu evito reescrever por gosto. Se o problema e checkout, pagamento ou autorizacao, eu extraio o caso de uso ao redor do fluxo real. Se o problema e query, eu mexo na query e provo com medicao. Se o problema e callback com side effect, eu torno o fluxo explicito. O objetivo e reduzir risco, nao trocar arquitetura por estetica.

### 26. Lideranca tecnica

**Q: Como voce atua como senior quando precisa decidir entre simplicidade e arquitetura mais robusta?**

Eu tento separar problema atual de problema imaginado. Se o fluxo e CRUD simples, Rails convencional e suficiente. Se envolve dinheiro, seguranca, concorrencia, integracao externa, alto volume ou auditoria, a robustez paga o custo. Eu explico a decisao em termos de risco: o que pode duplicar, vazar, ficar inconsistente, ficar lento ou ficar impossivel de operar.

Tambem deixo trade-off claro para o time. Kafka traz replay e desacoplamento, mas traz lag, schema e idempotencia. Service object ajuda fluxo critico, mas vira lixo se embrulhar CRUD. Cache reduz carga, mas cria invalidacao. Senioridade e escolher o menor desenho que aguenta o risco real.

### 27. PostGIS e geolocalizacao

**Q: Como voce defenderia sua experiencia com geolocalizacao e PostGIS?**

Eu explicaria que geolocalizacao nao deve ser tratada como filtro em Ruby. Se a pergunta e proximidade, raio ou ponto mais perto, o banco precisa usar tipo e indice espacial. PostGIS permite fazer a consulta perto dos dados e devolver ao Rails um dataset ja reduzido.

O cuidado e modelar unidade, indice, cardinalidade e frequencia da consulta. Tambem separo deteccao geografica da entrega realtime: calcular quem esta no raio e uma coisa; notificar via WebSocket, push ou job e outra. Misturar as duas no request principal cria gargalo.

### 28. Testes para experiencia do curriculo

**Q: Como voce prova em teste os pontos fortes que voce cita no curriculo?**

Para seguranca, testo usuario fora do escopo tentando acessar recurso. Para idempotencia, mando a mesma key duas vezes e garanto que o efeito nao duplica. Para mensageria, processo o mesmo evento duas vezes. Para migration/refactor, uso characterization tests antes de mexer. Para API, request specs cobrem contrato, status, autorizacao e payload.

Eu nao falaria de cobertura como numero isolado. O ponto e risco protegido. Em modulo critico, cobertura alta faz sentido quando ela cobre decisao importante: pagamento, autorizacao, transacao, estado, retry, webhook, consumer e erro.

### 29. Protecao de dado

**Q: Como voce protege PII ou dado sensivel em backend Rails?**

PII sensivel pode ser protegida com criptografia em repouso, controle de acesso, minimizacao de dados, masking em logs e auditoria de acesso. Em Rails moderno, Active Record Encryption e uma opcao. Mas a decisao principal e reduzir exposicao: nao logar payload sensivel, nao retornar campo desnecessario em serializer, limitar quem pode acessar e ter trilha de auditoria para operacao sensivel.

### 30. Rate limiting e backpressure

**Q: Como voce protegeria uma API Rails de pico, abuso ou dependencia externa lenta?**

Eu combinaria rate limiting, timeout curto, fila/evento quando possivel e degradacao controlada. Throttle por IP, usuario, tenant ou token protege abuso. Resposta 429 evita deixar request pendurado. Para dependencia externa lenta, circuit breaker ou fail-fast protege o pool de threads. Backpressure e aceitar que o sistema precisa recusar ou desacoplar carga antes que a fila interna vire indisponibilidade total.

### 31. Modelagem Rails

**Q: Como voce decide entre bigint, UUID, STI, polymorphic ou tabela separada?**

Eu uso bigint como padrao quando nao ha motivo forte para mudar. UUID faz sentido quando evitar enumeracao, integrar sistemas ou distribuir geracao compensa o custo de indice e locality. STI serve quando os subtipos compartilham quase tudo; se cada subtipo tem regras e colunas muito diferentes, tabela separada costuma ficar mais clara. Polymorphic e util para associacao generica, mas pode dificultar FK e integridade. Para soft delete, uma abordagem comum e combinar marcacao logica com unique index parcial para nao colidir com registro "apagado".
