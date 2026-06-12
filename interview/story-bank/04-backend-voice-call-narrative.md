# Interview Narrative - Voice / Call - Backend (Ruby / Rails)

Curriculo alvo: `allan_resume_fullstack_en.pdf`.

Foco: backend, dados, concorrencia, seguranca e sistemas distribuidos.

Use este documento para entrevista ao vivo por voz. Leia com pausas. A base e de 6 a 8 minutos; em entrevista real, escolha 2 ou 3 historias conforme a pergunta.

## Opening - 15 seconds

Tenho dez anos de backend Rails, com peso em dados, concorrencia e sistemas distribuidos, e fundo full stack. Vou seguir cronologico, do mais antigo para o mais recente, porque da para ver a progressao: comecei resolvendo integracao e confiabilidade, e fui subindo para performance, seguranca, sistema financeiro regulado e mensageria em escala. O fio condutor e sempre o mesmo: eu acho o acoplamento, o risco ou o gargalo, crio uma fronteira, garanto consistencia e reduzo latencia.

## Fulllab / Total Commit - 2016 a 2018

Full stack, mas com responsabilidade forte de backend Rails. Dois projetos: Easylive, troca de pontos integrada a varias APIs de fidelidade, e OJK, com notificacao geolocalizada em tempo real.

O problema central era confiabilidade. Integracao externa sempre falha: timeout, rate limit, payload inconsistente, mudanca de contrato, indisponibilidade parcial. Se a regra de negocio fala direto com cada provider, qualquer instabilidade externa contamina meu dominio.

O que eu fiz e por que:

Cada API ficava atras de um adapter proprio, um anti-corruption layer. A aplicacao trabalhava com um contrato interno estavel, e cada adapter traduzia autenticacao, payload, formato de erro e comportamento daquele provider. O motivo era isolamento: se o provider mudasse contrato, eu mexia em um adapter, nao na regra; e a queda de um nao derrubava os outros.

Como tratei o assincrono:

Tudo que podia sair do request sincronono ia para Sidekiq. Mas job nao pode rodar de novo as cegas, porque Sidekiq e at-least-once. Em retry ou crash ele pode rodar duas vezes. Sem idempotencia, eu duplico saldo ou sobrescrevo dado novo com resposta velha. Entao cada job carregava status de sincronizacao, controle de estado e lock no agregado quando precisava. O efeito colateral so disparava se o estado permitisse.

OJK e geolocalizacao:

Eu precisava responder "quem esta dentro deste raio". Calcular distancia no Ruby e errado; eu buscaria registros demais em memoria para filtrar na aplicacao. Usei PostGIS com indice espacial GiST, entao o banco reduz o dataset com query geografica antes de qualquer coisa chegar no Ruby. Para tempo real, separei a deteccao geografica da entrega: a query pesada nao fica no request principal e a notificacao sai por broadcast assincrono. Nao acoplar "descobrir quem" com "entregar".

## Sonata - 2018 a 2019

E-commerce internacional com Rails API servindo web e mobile.

O problema era manter a API sustentavel enquanto o produto crescia. Carrinho, cupom, frete, pedido e pagamento tendem a virar controller gordo e model inchado, porque cada regra nova cai onde for mais rapido no dia.

SOLID, e por que pragmatico:

Eu nao criava service object para qualquer CRUD. Isso e so indirecao a mais. Eu extraia quando o fluxo tinha multiplos passos, multiplos models ou efeito colateral. Divisao clara: controller cuida de request/response, model cuida de persistencia e invariante local, service/use case cuida da orquestracao. O por que e localizar a mudanca: se a regra de frete muda, eu sei exatamente onde mexer e testo o caso de uso, nao o controller inteiro.

Performance de banco, e por que importa:

Em e-commerce, lentidao em listagem, carrinho ou checkout bate direto na conversao. E receita, nao detalhe. Mas eu nao otimizava no chute. Primeiro entendia o padrao de acesso, depois atacava: N+1 com `includes` ou `preload` conforme o caso, indice em filtro e foreign key, parar de carregar coluna demais, e trocar `COUNT` repetido por counter cache ou agregacao no banco. A ordem importa: medir antes de mexer.

## Globo / Stormgroup / Projac - 2019 a 2020

Aqui meu angulo backend foi pagamento em escala, 2.5M+ de clientes por mes em multiplas plataformas de broadcast.

Tokenizacao, o que e e por que:

O sistema nao deveria tocar cartao cru se podia trabalhar com token do gateway. O por que e duplo: reduz exposicao de dado sensivel e reduz o escopo de PCI, porque o que voce nao armazena nao precisa auditar. O backend opera com o token, que sozinho nao tem valor.

O ponto fino do pagamento, estado desconhecido:

Timeout de gateway nao significa recusado; significa estado desconhecido. Retry cego nesse caso duplica cobranca. Entao o fluxo persiste estado pendente, permite conciliacao e nunca reprocessa as cegas. Isso e desenhar pagamento assumindo falha de rede como caso normal, nao excecao.

Performance de banco em escala:

Reduzi tempo de resposta em endpoints criticos com tuning de PostgreSQL e MariaDB: `EXPLAIN ANALYZE` para ver o plano, indice certo e eliminacao de full scan em hot path. Tambem introduzi CI/CD com deploy sem downtime, tirando o release manual, que era risco operacional puro.

## Enjoei - 2020 a 2021

Aqui eu entrei forte em application security, no Yellow Team, em cima dos findings do Red Team.

A mentalidade:

Nao corrigir o endpoint reportado, e sim fechar a classe inteira do problema no codebase.

IDOR, o que e, por que acontece, como corrigi:

O erro comum e buscar recurso por ID global. Autenticado nao quer dizer autorizado para aquele objeto. `GET /orders/123` devolve o pedido de outra pessoa porque ninguem checou ownership. A correcao e a query nascer do contexto autorizado: os pedidos deste usuario, encontra o `123`. Isso devolve 404 em vez de vazar e mata enumeracao. Em escala, isso vira policy sistematica, nao checagem solta por endpoint.

Mass assignment e privilege escalation:

Um payload nunca pode decidir `role`, `admin`, `tenant_id` ou ownership. Isso vem do contexto autenticado. Strong parameters resolve o caso geral; a falha classica e permitir conjunto amplo demais e o atacante setar `admin: true` no JSON.

SQL injection:

O ActiveRecord ajuda, mas nao protege interpolacao manual, `order` dinamico ou nome de coluna vindo do client. Argumento sempre como bind. Identificador dinamico so com allowlist, porque nome de coluna nao da para parametrizar.

Checkout com Clean Architecture, pragmatico:

Checkout e dominio critico: pedido, pagamento, validacao, antifraude, dado sensivel. Separei em camadas com responsabilidade explicita: controller fino, use case para orquestracao, domain service para regra, gateway para integracao externa, policy para autorizacao e transaction boundary explicita. O por que e reduzir superficie de ataque e deixar a auditoria clara: voce sabe onde a autorizacao acontece e onde o efeito externo dispara.

Tambem construi lambdas em Golang e otimizei Sidekiq em fluxos transacionais de alto volume, melhorando throughput e custo.

## Bornlogic / Farfetch / Spring Global - 2022 ate agora

Escala maior: Rails APIs de alto volume, plataforma financeira regulada, Kafka, RabbitMQ e lideranca tecnica.

Rails API a 100M+ requests por dia, o que, por que, como e onde quebra:

O que:

Ownership de APIs Rails nessa ordem de volume, com accountability por confiabilidade, latency budget e resposta a incidente.

Como comeca:

Nesse volume, otimizar sem medir e chute caro. A base e instrumentacao: APM, tracing distribuido, p95 e p99 por endpoint, slow query log, e decompor o tempo de resposta: quanto foi banco, Ruby, serializer, chamada externa. So depois de saber onde o tempo vai e que eu mexo.

Os maiores problemas nesse volume, e o tratamento de cada um:

- Connection pool de banco satura primeiro. Cada thread segura uma conexao; pool menor que a demanda enfileira requests esperando conexao, e voce ve timeout que parece lentidao de banco mas e contencao de pool. Dimensionei o pool em funcao de threads e workers, e cortei query desnecessaria para liberar conexao mais rapido.
- GC pressure. Volume alto significa muita alocacao por request; o GC pausa e isso aparece na cauda, no p99. Reduzi alocacao em hot path e evitei materializar colecao grande a toa.
- Serializacao vira gargalo de CPU. Montar JSON em volume custa caro. Enxuguei payload e tratei serializacao como parte real do latency budget.
- Banco como gargalo real. Query sem indice em hot path domina o budget. Indice obrigatorio em filtro e FK, nada de N+1, e read replica quando o padrao de leitura justificava.
- Chamada externa dentro do request lifecycle. Acopla minha latencia a do terceiro e propaga a falha dele para mim. Tirei do caminho sincronono quando possivel.
- Cauda de latencia e cache stampede. No p99, o que mata e thundering herd quando cache expira e muitos requests batem no banco juntos. A mitigacao e estrategia de expiracao, protecao de stampede e observabilidade.

A sintese:

Escala nao se resolve com truque; se resolve medindo, achando o gargalo dominante, atacando, remedindo e indo para o proximo.

Idempotencia em sistema financeiro, por que vira requisito de design:

Validacao so na aplicacao nao resolve corrida; dois requests concorrentes passam os dois pela checagem antes de qualquer um gravar. Entao a idempotency key e persistida com unique constraint no banco. E o banco que arbitra a corrida, nao a aplicacao. A operacao roda em transacao, com estado explicito: `pending`, `processing`, `completed`, `failed`, `waiting_reconciliation`. Mesma key de novo, o sistema retorna o resultado original e nao reexecuta o efeito. E assim que retry de rede nao vira cobranca dupla.

Outbox pattern, o problema do dual-write:

Com mensageria existe a armadilha classica: o banco commitou mas o evento nao publicou, ou o evento publicou mas o banco fez rollback. Os dois deixam o sistema inconsistente. Com outbox, gravo operacao e evento na mesma transacao, numa tabela de saida; depois um worker le e publica. O evento so existe se a operacao realmente commitou.

Kafka e RabbitMQ, quando cada um, e o custo que eu nao escondo:

RabbitMQ usei no fluxo transacional: entrega garantida, ack manual, dead-letter queue, bom para task queue com descarte apos consumo. Kafka e log append-only com retencao e replay, com varios consumidores no mesmo stream em offsets proprios. Usei para desacoplar servicos via evento.

Antes, uma operacao dependia de varios servicos respondendo em cadeia sincronona, o que soma latencia e espalha falha. Com Kafka, o servico principal persiste estado e publica; consumidores processam independentes. Mas eu nao vendo isso como magica: voce troca chamada sincronona por consistencia eventual, ordering, DLQ, replay, schema versioning e idempotencia no consumer. A premissa honesta e at-least-once com consumidor idempotente.

## Closing - 20 seconds

Resumindo o backend: comecei em integracao externa e confiabilidade; evolui para arquitetura Rails, SOLID e performance de banco; depois pagamento, tokenizacao e CI/CD; depois application security e Clean Architecture; e hoje em escala, com Rails de alto volume, sistema financeiro regulado, idempotencia, outbox, Kafka e RabbitMQ.

O fio condutor e esse: eu acho o acoplamento, o risco ou o gargalo; crio a fronteira; garanto a consistencia; reduzo a latencia; fecho o vetor de seguranca; e deixo o sistema mais operavel. Toda decisao por trade-off explicito e medicao, nao por moda.
