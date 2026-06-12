# STAR Tecnico + Q&A - Backend Ruby / Rails

Curriculo alvo: `allan_resume_fullstack_en.pdf`.

Enfase: Ruby, Rails, dados, concorrencia, seguranca, performance, filas, sistemas distribuidos e arquitetura senior.

Use este documento quando a vaga for backend-heavy. A ordem e do mais antigo para o mais novo para contar evolucao tecnica, mas em entrevista comece pela experiencia mais aderente a vaga.

## Evidence Boundary

Fatos diretamente sustentados pelo curriculo:

- Rails, Ruby, Sidekiq, PostgreSQL, MySQL/MariaDB, RabbitMQ, Kafka, Docker e Kubernetes.
- 100M+ requests por dia em APIs Rails.
- Plataforma financeira Banco Central-compliant.
- Kafka introduzido para remover gargalos sincrononos em 4 servicos criticos.
- Latencia do servico de pagamento reduzida em 20% com Rails 7 API optimization e query tuning.
- 95%+ de RSpec em modulos criticos.
- Enjoei Yellow Team com Red Team, hardening contra injection, privilege escalation, IDOR e data exposure.
- Globo com pagamento para 2.5M+ clientes por mes e APIs criticas 30% mais rapidas.
- Fulllab e Sonata com Rails 5, Sidekiq, PostGIS, Action Cable, RSpec e Cypress.

Detalhes como circuit breaker, GiST, ack manual, DLQ, `oj`, `stackprof` e contratos exatos devem ser usados como talk track tecnico so se voce conseguir defender que foram usados naquele projeto especifico. Se nao, formule como principio de desenho, nao como fato historico.

Confidence: high para fatos do curriculo; moderate para detalhes de implementacao inferidos.

## Claim Expansion Rule

Quando fizer uma afirmativa forte, responda sempre nesta ordem:

What.

O que exatamente era o sistema, o fluxo ou o problema.

Why.

Por que aquilo importava para negocio, escala, seguranca, latencia, compliance ou operacao.

How.

Como voce implementou ou conduziu a solucao: boundaries, queries, filas, idempotencia, autorizacao, testes, observabilidade.

Problemas evitados.

Quais falhas, regressos ou efeitos colaterais a solucao precisava evitar.

Result.

Qual efeito observavel voce teve, usando apenas numeros ou efeitos que o curriculo sustenta.

## Opening - Backend Rails

I am a senior Ruby on Rails backend engineer with 10+ years of experience building APIs, transaction-heavy systems, security-sensitive flows, and distributed backend architectures.

The strongest backend thread in my career is not just shipping endpoints. It is turning risky flows into predictable systems: defining the business boundary, making writes idempotent, understanding query plans, protecting authorization, moving the right work async, and keeping enough observability to debug production under pressure.

## 1. Fulllab / Total Commit - Full Stack Rails 5, 2016-2018

### STAR

Situation.

Dois backends Rails 5: Easylive, uma plataforma de troca de pontos integrando multiplas APIs de loyalty, e OJK, um produto com notificacoes geo em tempo real.

What.

No Easylive, eu estava construindo um backend de integracao. O trabalho nao era CRUD simples; era orquestrar provedores externos com contratos e disponibilidade diferentes. No OJK, eu estava construindo um backend com geolocalizacao e entrega realtime, o que muda completamente as preocupacoes de dados e entrega.

Why.

Integracao externa instavel pode contaminar o request path inteiro e transformar uma dependencia ruim em indisponibilidade do produto. Geolocalizacao em tempo real, por sua vez, quebra rapido se voce trata consulta espacial como query comum ou se mistura logica pesada no mesmo caminho do socket.

How.

No Easylive, a forma certa de tratar provedores de loyalty era como boundaries externos independentes. Em entrevista, eu explicaria isso assim: eu precisava isolar request/response, erro, timeout e politica de retry por provedor, para que a falha de um nao virasse falha sistemica de todos. O desenho que faz sentido nesse tipo de sistema e adapter por provedor, contrato normalizado para dentro do dominio, timeout explicito, retry com backoff quando o efeito e seguro, e trabalho lento fora do request sincronono quando possivel.

No OJK, a parte de geolocalizacao precisava de estrategia de dados propria. Se a pergunta e "quem esta dentro do raio" ou "qual ponto esta mais proximo", a decisao de usar PostGIS faz sentido porque consulta espacial precisa de indice espacial; calculo linha a linha nao escala. Para o realtime, Action Cable resolve entrega e fan-out, mas a parte que custa caro nao pode viver no callback de conexao ou broadcast. O padrao correto e manter a conexao leve e empurrar trabalho pesado para Sidekiq.

Tambem trabalhei com Sidekiq, otimizacao de queries PostgreSQL e estrategia de testes com RSpec e Cypress.

Problemas evitados.

Os primeiros problemas nesse tipo de sistema sao: latencia e indisponibilidade de provedor externo consumindo threads web, duplicidade de side effect por retry de job, query espacial sem indice virando full scan, e camada realtime sofrendo com broadcast amplo demais ou logica pesada na conexao.

Result.

O curriculo sustenta reducao do tempo de deteccao de bugs, carga de servidor reduzida e melhor responsividade sob pico.

### Q&A

Q: Por que PostGIS e nao calculo de distancia em PostgreSQL puro?

PostGIS oferece tipos geograficos e indices espaciais como GiST, que tornam consultas de proximidade performaticas. Se voce calcula distancia linha a linha sem indice espacial, tende a cair em full scan. O ponto nao e "usar PostGIS porque e bonito"; e que geolocalizacao em escala precisa de estrategia de indice.

Q: Onde Action Cable nao escala bem e como mitigar?

O gargalo costuma aparecer em conexoes WebSocket persistentes, broadcast amplo demais e Redis pub/sub mal dimensionado. Mitigo com canais escopados, audiencia real em vez de broadcast global, logica pesada fora do callback, jobs para processamento e metricas de conexao, fila e latencia.

Q: Por que jobs Sidekiq precisam ser idempotentes?

Porque fila deve ser tratada como at-least-once. Um job pode rodar de novo por retry, timeout ou crash. Sem idempotencia, voce duplica efeito colateral: email, cobranca, notificacao ou integracao externa. A protecao correta fica em chave de idempotencia, constraint unica, checagem de estado ou lock transacional.

Q: O que circuit breaker evita numa integracao externa?

Evita que um provedor lento ou indisponivel consuma todo o pool de threads e derrube o sistema por cascata. Depois de uma sequencia de falhas, o breaker abre e falha rapido. Isso preserva capacidade para fluxos saudaveis e torna a degradacao previsivel.

## 2. Sonata - Full Stack Rails 5 API, 2018-2019

### STAR

Situation.

Digifair era um e-commerce internacional com API Rails 5 que escalou significativamente depois do launch.

What.

Eu estava sustentando uma API Rails que precisava continuar entregando produto enquanto crescia. O problema central nao era apenas throughput; era manter o legado legivel e o request path eficiente nos fluxos que mais importavam.

Why.

Em e-commerce, API lenta ou codigo de negocio espalhado nao atrasa so a equipe; degrada compra, integracao, suporte e evolucao do produto. Quando o legado cresce sem boundary claro, o time perde velocidade e o sistema perde previsibilidade.

How.

Eu apliquei SOLID de forma pragmatica. Nao como estilo academico, mas como criterio para decidir onde uma regra de negocio deveria morar. Quando o fluxo cruzava models, integracoes, side effects ou transacoes, extrair para service object fazia sentido porque virava um caso de uso explicito e testavel. Controller continuava traduzindo HTTP, model mantinha invariantes locais, e service representava a operacao de negocio.

Na performance, o trabalho foi olhar o fluxo core e remover custos desnecessarios: N+1 com `includes` ou `preload` conforme o caso, indices em colunas de filtro e FKs, menos carga de objetos em memoria, e mais agregacao no banco quando o custo de ida e volta para Ruby era desnecessario.

Problemas evitados.

Os problemas que normalmente aparecem sao: regras de negocio espalhadas entre controller, model e callback; N+1 escondido em hot path; join desnecessario inflando cardinalidade; e request carregando objetos demais so para usar poucos campos.

Result.

O curriculo sustenta reducao de complexidade de modulos, legado mais sustentavel e melhora mensuravel de tempo de resposta em fluxos core.

### Q&A

Q: `includes` vs `preload` vs `eager_load`?

`preload` faz queries separadas para carregar associacoes. `eager_load` usa `LEFT OUTER JOIN`. `includes` escolhe estrategia conforme o uso, mas pode virar join se voce referencia a associacao em `where` ou `order`. Isso importa porque resolver N+1 com join desnecessario pode explodir cardinalidade e memoria.

Q: Quando service object vira overengineering?

Quando embrulha CRUD trivial. Service faz sentido para caso de uso que cruza models, tem transacao, autorizacao sensivel, integracao externa, fila ou side effect. A pergunta correta e: existe uma operacao de negocio com boundary proprio? Se sim, service ajuda. Se nao, e so deslocamento de codigo.

Q: `count` vs `size` vs `length` em associacao?

`count` faz `SELECT COUNT`. `length` carrega a associacao inteira em memoria. `size` usa cache se a associacao ja estiver carregada; senao pode fazer count. Em hot path, escolher errado gera query extra ou uso de memoria desnecessario.

## 3. Stormgroup / Globo / Projac - Tech Lead, 2019-2020

### STAR

Situation.

Eu trabalhei com processamento de pagamento para 2.5M+ clientes por mes em multiplas plataformas de broadcast, com endpoints criticos que precisavam melhorar tempo de resposta.

What.

O que eu estava operando aqui era um backend de pagamentos e APIs criticas, nao apenas uma aplicacao web comum. Isso significa que o sistema precisava manter corretude transacional e ao mesmo tempo responder sob volume alto.

Why.

Pagamento e uma area onde erros custam caro: cobranca indevida, falha de confirmacao, suporte, risco reputacional e auditoria. Performance tambem importa porque latencia em endpoint critico afeta jornada inteira. E, em deploy, uma migration errada pode quebrar checkout no meio do rollout.

How.

No fluxo de pagamento, a decisao tecnica relevante era operar com tokenizacao quando possivel, porque o sistema nao deve depender de trafegar ou persistir dado sensivel bruto sem necessidade. Em entrevista, eu explicaria isso como reducacao de superficie de risco e de acoplamento com dado sensivel.

Na performance, eu reduzi o tempo de resposta de APIs criticas em 30% com otimizacao PostgreSQL e MariaDB. O ponto importante aqui e o metodo: primeiro medir, depois atacar o gargalo real. Isso significa olhar logs/APM, queries lentas, `EXPLAIN`, indices, N+1, payload, serializacao e chamadas externas, em vez de otimizar Rails no escuro.

Tambem introduzi CI/CD com zero-downtime deployments. O valor nao e "automatizar deploy"; e reduzir risco humano e manter compatibilidade entre versao antiga e nova durante rollout.

Problemas evitados.

Em pagamento e APIs criticas, os problemas que aparecem primeiro sao duplicidade de efeito por retry de rede, query lenta em hot endpoint, migration incompativel durante rollout, e forte acoplamento entre deploy de codigo e schema.

Result.

APIs criticas ficaram 30% mais rapidas, release manual foi eliminado e a adocao de RSpec/TDD/BDD reduziu bugs em producao segundo o curriculo.

### Q&A

Q: Por que tokenizacao reduz risco em pagamento?

Porque o sistema deixa de trafegar ou armazenar o dado sensivel bruto e passa a operar com um token emitido pelo gateway ou provedor. Isso reduz superficie de ataque e escopo de auditoria. O detalhe exato de PCI depende da arquitetura, mas o principio e claro: minimizar contato com dado sensivel.

Q: Qual e o risco principal de deploy zero-downtime com migration?

Quebrar compatibilidade entre versao antiga e nova durante rollout ou travar tabela com operacao bloqueante. Eu uso raciocinio expand/contract: adicionar coluna nullable ou indice de forma segura, fazer deploy compativel, backfill em batches, ativar leitura/escrita nova e so depois remover o legado.

Q: Como garantir idempotencia em pagamento?

Toda tentativa recebe uma chave de idempotencia ou chave de negocio estavel. Retry de rede reenvia a mesma chave. O servidor reconhece operacao ja processada e retorna o resultado original sem duplicar cobranca. Sem isso, timeout seguido de retry pode virar cobranca dupla.

## 4. Enjoei - Rails Engineer, Application Security, 2020-2021

### STAR

Situation.

Enjoei tinha um programa formal de seguranca com Red Team ativo. Eu atuava no Yellow Team, focado em remediacao continua.

What.

Eu nao estava apenas corrigindo bugs pontuais. Estava fechando classes de vulnerabilidade em APIs Rails, especialmente em autenticacao, autorizacao e exposicao de dados.

Why.

O problema de seguranca serio nao e uma unica rota quebrada; e um padrao de design que permite repetir a falha em varios lugares. Se a correcao nao atacar a classe do problema, o sistema continua vulneravel mesmo depois do ticket fechado.

How.

Para IDOR, a pergunta tecnica e: quem define o escopo do objeto? A implementacao segura nao confia no ID puro do client; busca o recurso dentro do escopo autorizado do ator ou tenant. Em vez de `Order.find(params[:id])`, o desenho seguro e `current_user.orders.find(params[:id])` ou policy scope equivalente. O que eu estava corrigindo, na pratica, era object-level authorization.

Para injection, a regra e nao interpolar input em SQL e controlar identificadores dinamicos com allowlist. Para mass assignment, strong parameters estritos e revisao de campos sensiveis permitidos. Para exposicao de dados, revisar serializer, escopo de consulta e autorizacao antes de renderizar.

Tambem refatorei checkout com Rails 6 e TypeScript, isolando validacao em microservico. O por que disso e reduzir superficie de ataque e simplificar auditoria. Quando validacao e decisao sensivel ficam mais encapsuladas, o fluxo fica menos espalhado e mais testavel. Trabalhei ainda com lambdas Golang e otimizacao de Sidekiq em fluxos transacionais de alto volume.

Problemas evitados.

As falhas que mais se repetem aqui sao: confiar em ID do client sem escopo, strong params amplos demais, SQL dinamico sem controle, regra de autorizacao escondida so no controller e correcao pontual que nao fecha o padrao no codebase inteiro.

Result.

O curriculo sustenta fechamento de vetores por classe, checkout mais auditavel, throughput maior e custo operacional menor.

### Q&A

Q: O que e IDOR e como prevenir em Rails?

IDOR ocorre quando o app autentica o usuario, mas nao valida se ele pode acessar aquele objeto especifico. A prevencao e escopo por ator ou tenant e policy layer. `current_user.orders.find(params[:id])` e melhor que `Order.find(params[:id])` porque impede acesso cruzado por troca de ID.

Q: Onde Active Record nao protege contra SQL injection?

Interpolacao manual em `where`, `order`, `find_by_sql` e nomes dinamicos de coluna. Valores devem usar bind parameters. Identificadores dinamicos nao sao parametrizados da mesma forma; precisam de allowlist.

Q: Mass assignment ainda e problema?

Sim. Strong parameters defendem, mas falham quando alguem usa `permit!` ou permite `role`, `admin`, `account_id`, `user_id` ou campos sensiveis vindos do request. Isso vira privilege escalation.

Q: Diferenca pratica entre Red Team e Yellow Team?

Red Team encontra e demonstra o vetor. Yellow Team transforma o finding em correcao duravel. A postura senior e procurar o padrao no codebase inteiro e criar barreira para a classe de falha voltar.

## 5. Bornlogic / Farfetch / Spring Global - Tech Lead, 2022-Present

### STAR

Situation.

Eu trabalhei com APIs Rails a 100M+ requests por dia, transacoes bancarias multi-instituicao sob regulacao do Banco Central e 4 servicos criticos com acoplamento sincronono criando gargalo.

What.

Quando eu digo que operei APIs Rails a 100M+ requests por dia, o que isso significa na pratica e que eu estava responsavel por um request path onde pequenos desperdicios deixam de ser detalhe e viram incidente. Tambem significa que latencia, timeout, pool de conexao, serializacao, cache e observabilidade deixam de ser preocupacoes secundarias.

No lado financeiro, eu estava ajudando a construir uma plataforma Banco Central-compliant. Isso quer dizer que a discussao nao era apenas "como processar a operacao", mas "como processar sem duplicar efeito, como auditar, como reprocessar e como explicar a trilha da operacao depois".

Why.

Em 100M+ requests por dia, custos pequenos se multiplicam brutalmente: uma query ruim vira pressao constante no banco, serializacao ruim vira CPU, timeout externo vira saturacao de thread, e pool mal dimensionado vira fila escondida. Em sistema regulado, um write path mal desenhado nao gera so lentidao; pode gerar inconsistencias, reprocessamento inseguro e risco de compliance.

How.

Na plataforma financeira, tratei idempotencia, auditoria e falha de rede como requisitos de primeira classe. Em entrevista, a forma correta de expandir essa afirmativa e: eu precisava que retry nao duplicasse efeito, que cada operacao fosse rastreavel e que a ambiguidade de resultado fosse tratada como caso normal, nao como excecao rara.

Na comunicacao entre servicos, introduzi Kafka em 4 servicos para trocar chamadas sincronas por comunicacao event-driven assincrona. O por que disso era claro: existia acoplamento sincronono suficiente para virar gargalo operacional. O como disso nao e "colocar Kafka no diagrama"; e redefinir boundary de comunicacao, aceitar consistencia eventual onde o negocio permite, fazer consumidores idempotentes e melhorar observabilidade do fluxo assincrono.

Na operacao das APIs Rails, o trabalho era cuidar do hot path. Em entrevista, eu descreveria o como assim: primeiro medir com APM, logs, SQL timings e profiling; depois atacar query plan, N+1, indices, payload, serializacao, connection pool, cache e chamadas externas sincronas. Quando reduzi a latencia do servico de pagamento em 20%, a explicacao defensavel e exatamente essa: isolar o gargalo real e otimizar a parte que dominava o budget.

Tambem estabeleci 95%+ de cobertura RSpec em modulos criticos e liderei 8 engenheiros em code review, entrevistas tecnicas e knowledge sharing. O por que disso nao e vaidade de coverage; e proteger os fluxos onde regressao custa caro.

Problemas evitados.

Os maiores problemas em Rails nessa escala costumam ser:

- connection pool subdimensionado em relacao a threads;
- query sem indice em hot path;
- N+1 escondido em endpoint de alto volume;
- payload e serializacao consumindo CPU demais;
- chamada externa sincronona amplificando latencia;
- lock contention em write path concorrente;
- cache sem invalidacao correta;
- observabilidade fraca, que impede isolar o gargalo durante incidente.

Como eu lido com isso em entrevista: eu digo que a estrategia e reduzir custo no caminho sincronono, separar side effects nao criticos, tornar writes idempotentes, medir banco e serializacao explicitamente, e nunca tratar retry ou falha de rede como evento raro.

Result.

Zero incidentes regulatorios desde o launch segundo o curriculo, gargalos sincrononos eliminados em 4 servicos, latencia de pagamento reduzida em 20% e modulos criticos protegidos por 95%+ RSpec.

### Q&A

Q: Kafka vs RabbitMQ - quando usar cada um?

RabbitMQ e um broker de mensagens orientado a filas, roteamento, ack/nack e DLQ. E bom para task queue, command processing e workflows onde a mensagem e consumida e sai da fila. Kafka e um log distribuido append-only com retencao, replay e offsets independentes por consumidor. E forte para stream de eventos, fan-out e consumidores independentes. A escolha depende de replay, ordering, throughput, modelo de consumidor e maturidade operacional.

Q: "Exactly once" no Kafka existe?

Dentro de limites estreitos, Kafka oferece semanticas transacionais. No sistema inteiro, especialmente quando ha DB, API externa ou side effect, a resposta senior e projetar para at-least-once com consumidor idempotente. Quem promete exactly-once fim a fim sem idempotencia esta simplificando demais.

Q: 100M requests por dia em Rails - onde quebra primeiro?

Depende do perfil, mas os suspeitos comuns sao connection pool de DB, queries sem indice em hot path, N+1, serializacao pesada, payload grande, chamadas externas sincronas, lock contention, alocacao/GC e cache ruim. Eu mediria com APM, logs, SQL timings, profiling e metricas de pool antes de otimizar.

Q: Sistema financeiro regulado muda o que na arquitetura?

Auditabilidade e idempotencia deixam de ser detalhes e viram requisito de design. Toda operacao importante precisa ser rastreavel, reprocessavel e protegida contra duplicidade. Falha de rede e ambiguidade de resultado sao casos normais, nao excecao rara.

Q: Qual custo que ninguem cita em arquitetura event-driven?

Debug e consistencia. Voce troca uma chamada sincronona simples por estado distribuido: ordering, idempotencia, reprocessamento, observabilidade, schema de evento e consistencia eventual. So compensa quando o acoplamento sincronono e o gargalo real.

## Backend Deep Dives

### Plataforma financeira / Idempotencia

What.

Fluxos financeiros multi-instituicao com rastreabilidade, reprocessamento seguro e protecao contra duplicidade.

Why.

Em financeiro, retry errado duplica transacao. Timeout nao significa falha definitiva; significa resultado ambiguo. Mensagem duplicada e request repetido nao sao excecao rara, sao comportamento normal do sistema distribuido.

How.

Eu explico essa parte assim: a operacao precisa ter uma identidade estavel e um estado explicito. A forma mais defensavel de fazer isso e receber uma idempotency key, persisti-la com unique constraint, executar a mudanca de estado em transacao e retornar o resultado original se a mesma key reaparecer. Quando existe disputa no mesmo agregado, adiciono lock pontual no recurso certo, nao lock amplo no sistema inteiro. O write path precisa distinguir estados como `pending`, `processing`, `completed`, `failed` ou `waiting_reconciliation`, porque timeout e reprocessamento exigem semantica de estado, nao so sucesso ou erro binario.

Problemas evitados.

Duplicidade de cobranca ou transferencia, corrida entre requests concorrentes, timeout tratado como falha definitiva e retry reexecutando efeito externo.

Result.

O curriculo sustenta zero incidentes regulatorios desde o launch. Em entrevista, essa e a parte tecnica que explica por que um fluxo financeiro desse tipo precisa nascer com idempotencia e estado explicito.

Pergunta: Como implementar idempotencia financeira?
Resposta: Idempotency key unica no banco, unique constraint, transacao, estado explicito e retorno do resultado original. Para concorrencia no mesmo agregado, row-level lock pontual.

### Outbox Pattern / Mensageria

What.

Consistencia operacional entre banco e broker quando uma operacao de dominio precisa gerar evento ou comando assincrono.

Why.

Banco e broker nao participam da mesma transacao. Se eu faco commit no banco e o publish falha, o estado muda sem evento. Se eu publico antes e o banco rollbacka, gero evento falso. Esse e o problema classico de dual-write.

How.

A forma correta de defender isso tecnicamente e usar transactional outbox: a operacao de dominio e o registro do evento ficam na mesma transacao do banco. Depois, um worker le a outbox e publica no broker com retry controlado. Se o broker falhar, o evento continua pendente e reprocessavel. O ponto importante e que a consistencia forte fica no banco; a entrega ao broker vira responsabilidade observavel e reexecutavel de um worker.

Problemas evitados.

Evento perdido, evento publicado sem estado correspondente no banco, divergencia entre persistencia e mensageria e retry manual sem trilha.

Result.

O curriculo nao nomeia `outbox` explicitamente, entao eu trataria este item como o desenho tecnico que uso para explicar consistencia entre banco e mensageria em sistemas financeiros ou event-driven.

Pergunta: Por que nao publicar direto no Kafka ou RabbitMQ depois do commit?
Resposta: Porque o publish pode falhar e voce volta ao problema do dual-write. Outbox grava operacao e evento no mesmo commit; depois um worker publica com retry e observabilidade.

### RabbitMQ / Processamento Assincrono

What.

Fila transacional para processamento assincrono de tarefas criticas.

Why.

Worker pode cair, mensagem pode falhar, retry pode duplicar efeito e tarefa critica nao pode se perder. Quando a semantica e task queue com ack/nack, DLQ e roteamento, o desenho precisa tratar entrega e falha explicitamente.

How.

Eu explico RabbitMQ como uma camada de processamento onde a mensagem so e confirmada depois do processamento real. Isso significa ack manual quando o trabalho termina, retry policy para falhas recuperaveis, dead-letter para falhas nao recuperaveis e workers idempotentes para suportar redelivery. O objetivo nao e "usar broker"; e garantir que o sistema saiba quando concluiu, quando precisa tentar de novo e quando precisa estacionar para analise.

Problemas evitados.

Mensagem perdida, ack antes da conclusao, retry infinito, falha transitoria virando perda definitiva e reprocessamento duplicando efeito.

Result.

O curriculo sustenta uso de RabbitMQ na plataforma financeira. Esta e a forma tecnica de explicar por que ele faz sentido nesse tipo de fluxo.

Pergunta: Kafka vs RabbitMQ?
Resposta: RabbitMQ e melhor para task queue, routing, ack/nack e DLQ. Kafka e melhor para stream/event log, retencao, replay e multiplos consumidores independentes.

## Rails Senior Fast Answers

Q: Como aplicar SOLID em Rails?

Use SOLID para proteger boundaries. Model segura invariantes locais. Controller traduz HTTP. Service ou operation representa caso de uso com transacao, autorizacao, fila, integracao ou side effect. Nao crie abstracao para CRUD trivial.

Q: Validacao Rails basta para integridade?

Nao. Validacao melhora UX e regra de dominio, mas integridade critica precisa estar no banco com `NOT NULL`, `UNIQUE`, FK, `CHECK` e indices. `validates_uniqueness_of` sem indice unico tem race condition.

Q: Nested transaction no Rails?

Transacao aninhada normalmente participa da externa. `ActiveRecord::Rollback` interno pode nao abortar a externa. Para savepoint ou subtransacao, use `requires_new: true` quando o caso realmente pede.

Q: Offset ou cursor pagination?

Offset e simples, mas ruim para tabelas grandes e dados mutaveis. Cursor ou keyset e melhor para escala e consistencia porque pagina a partir de chave ordenavel e estavel.

Q: Como escrever job robusto?

Job pequeno, idempotente, retry-safe, com timeout, logs estruturados, chave unica quando necessario e sem depender de estado em memoria. Retry automatico so para falha transitoria.

Q: Como revisar PR senior?

Contrato, seguranca, concorrencia, dados, rollback, observabilidade, teste relevante, simplicidade, performance e migracao. A pergunta central e: como isso falha em producao e como voltamos atras?

## Perguntas Para Fazer ao Entrevistador

- Onde Rails costuma sofrer mais aqui: banco, serializacao, filas, chamadas externas, deploy ou observabilidade?
- Quais fluxos precisam de idempotencia hoje?
- Como voces lidam com retry, DLQ e reprocessamento?
- Quais tabelas ou endpoints sao hot paths?
- Como decisoes de boundary sao tomadas: ownership, escala, compliance, risco ou historico?
- O que um senior ou specialist backend precisa melhorar nos primeiros 90 dias?
