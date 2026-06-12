# Ruby / Rails Senior Question Bank

Nao existe ranking oficial. Esta e uma lista pratica dos temas mais recorrentes em entrevista tecnica para Backend Ruby on Rails Senior/Specialist.

Use como drill rapido antes de entrevista backend. O objetivo nao e decorar definicao; e responder com precisao, trade-off e exemplo de producao.

## Answer Frame

Para qualquer pergunta abaixo, responda nesta ordem:

What.

O que o conceito e em termos simples e precisos.

Why.

Por que ele importa em producao, escala, seguranca, corretude ou manutenibilidade.

How.

Como ele aparece no Rails, no banco, na fila ou no request path real.

Trade-off.

Qual e a principal armadilha, custo ou limite do conceito.

## Ruby

1. include vs extend vs prepend?

`include` adiciona metodos de instancia. `extend` adiciona metodos ao objeto/classe receptor. `prepend` coloca o modulo antes da classe na cadeia de lookup, util para sobrescrever comportamento. Modulos servem para namespace e mixins.

2. Como funciona method lookup no Ruby?

Ruby procura primeiro metodos singleton, depois modulos com `prepend`, classe, modulos incluidos, superclasses e, no fim, `BasicObject`. `Class.ancestors` ajuda a inspecionar.

3. Block vs Proc vs Lambda?

Block e sintaxe passada para metodo. Proc e objeto. Lambda e um tipo de Proc com aridade mais rigida e `return` local. Proc comum tem aridade mais permissiva e `return` pode sair do metodo externo.

4. nil e false: o que e falsy?

Apenas `nil` e `false`. `0`, `""`, `[]` e `{}` sao truthy.

5. Symbol vs String?

String e dado mutavel. Symbol representa identificador/nome. Use symbol para chaves internas/nomes; string para dados externos ou texto de usuario.

6. O que e GVL/GVM lock?

No MRI/CRuby, threads Ruby concorrem, mas execucao de bytecode Ruby tem limitacao por lock da VM. Threads ajudam muito em I/O, pouco em CPU-bound. Para CPU-bound, use processos, jobs separados, native extensions que liberam GVL ou outra arquitetura.

7. Ruby e thread-safe?

A linguagem permite threads, mas seu codigo pode nao ser. Evite estado global mutavel, class variables compartilhadas, singletons com cache mutavel sem lock, memoization insegura e dependencia em ordem de execucao.

8. Quando usar freeze?

Para tornar objetos imutaveis, reduzir bugs por mutacao acidental e estabilizar constantes. Exemplo: `STATUSES = %w[pending paid].freeze`.

9. Quando usar metaprogramacao?

So quando reduz duplicacao estrutural real. Evite para regra de negocio comum. Prefira codigo explicito para manutencao, debug e busca.

10. method_missing e aceitavel?

Raramente. Se usar, implemente tambem `respond_to_missing?`. Melhor gerar metodos explicitamente quando possivel.

## Rails Core

11. Explique MVC no Rails.

Model concentra dominio e persistencia, Controller orquestra request/response, View serializa/renderiza saida. Em backend API, View pode ser serializer/representer.

12. O que e fat model?

Model com validacoes, callbacks, queries, regras, integracoes e orquestracao demais. Solucao: extrair policies, query objects, form objects, services de aplicacao e POROs de dominio.

13. Service Object: quando usar?

Quando ha caso de uso com multiplos passos, transacao, integracao externa ou coordenacao entre models. Nao usar para esconder metodo simples de model.

14. Callback em model: bom ou ruim?

Bom para invariantes locais e efeitos internos simples. Ruim para side effects externos, jobs, chamadas HTTP, regras complexas e fluxo dificil de prever.

15. Validacao Rails basta para integridade?

Nao. Validacao melhora UX e dominio, mas integridade critica deve estar no banco: `NOT NULL`, `UNIQUE`, FK, `CHECK`, indices. Validacao de unicidade sem indice unico tem race condition.

16. Concern e boa pratica?

Depende. Bom para comportamento pequeno e coeso compartilhado. Ruim quando vira pasta de mixins genericos que escondem acoplamento.

17. Como funciona autoload/eager load no Rails?

Rails usa Zeitwerk para autoload/reload. Em producao, eager loading carrega codigo no boot, reduz surpresa em runtime e e Copy-on-Write friendly.

18. O que e middleware Rack?

Camada entre servidor e app Rails. Pode autenticar, logar, comprimir, manipular sessao, CORS, rate limit etc.

19. Rails API-only muda o que?

Remove partes focadas em browser/view quando nao necessarias e mantem stack para JSON APIs, controllers, routing, Active Record, jobs e middleware selecionado.

20. Onde colocar regra de autorizacao?

Fora do controller. Use policy/ability layer. Controller chama autorizacao; regra vive em objeto testavel.

## Active Record / Banco

21. O que e N+1 query?

Carregar lista e depois buscar associacao item a item. Exemplo: 1 query para livros + 10 queries para autores. Corrige com eager loading: `includes`, `preload`, `eager_load`.

22. includes vs preload vs eager_load?

`preload`: queries separadas. `eager_load`: `LEFT OUTER JOIN`. `includes`: escolhe estrategia conforme uso; pode virar join se houver condicao/order na tabela associada.

23. joins resolve N+1?

Nao necessariamente. `joins` filtra/combina no SQL, mas nao hidrata associacao para uso posterior. Para acessar associacao sem N+1, use preload/eager load.

24. joins vs left_joins?

`joins` gera `INNER JOIN`: so registros com associacao. `left_joins` preserva registros da esquerda mesmo sem associacao.

25. Como buscar registros com/sem associacao?

Use `where.associated(:assoc)` e `where.missing(:assoc)` quando aplicavel.

26. Como funciona transaction?

Agrupa operacoes no banco. Se erro nao tratado ocorre, rollback. Use `save!`, `create!`, `update!` dentro da transacao para falhar explicitamente.

27. Pegadinha de nested transaction?

Transacao aninhada normalmente participa da externa. `ActiveRecord::Rollback` interno pode nao abortar a externa. Para savepoint/subtransacao, use `requires_new: true`.

28. Optimistic vs pessimistic locking?

Optimistic usa `lock_version` e falha se outro processo alterou o registro. Pessimistic usa lock no banco, normalmente dentro de transacao, bloqueando concorrentes.

29. Quando usar lock pessimista?

Saldo financeiro, estoque, reserva, claim de recurso unico, qualquer caso onde conflito concorrente e esperado e perda de atualizacao e inaceitavel.

30. update_all vs update em loop?

`update_all` faz SQL direto, rapido, sem callbacks/validations/timestamps automaticos. Loop com `update!` executa callbacks/validations, mas e mais lento.

31. pluck vs select vs map?

`pluck` traz colunas cruas sem instanciar models. `select` limita colunas mas instancia models. `map` depois de carregar objetos pode ser desperdicio.

32. Como processar milhoes de registros?

Use `find_each`/`in_batches`, evite carregar tudo em memoria, use cursores/paginacao por chave, batches pequenos, transacoes curtas e metricas.

33. Indice resolve tudo?

Nao. Indice acelera leitura/filtro/order/join, mas custa escrita e storage. Indice errado nao e usado. Valide com `EXPLAIN ANALYZE`.

34. Migracao zero-downtime?

Evite operacao bloqueante longa. Adicione coluna nullable, backfill em batches, depois constraint. Crie indice concurrentemente no PostgreSQL. Separe deploy de codigo e schema.

35. Data migration dentro de schema migration?

Evite para grandes volumes. Prefira task/job idempotente, batch, observavel e reexecutavel.

36. has_many :through vs HABTM?

Use `has_many :through` quando a relacao tem atributos, validacoes, callbacks ou comportamento proprio. Use HABTM so para join simples sem entidade propria.

37. Problema com default_scope?

Esconde filtro global, quebra queries administrativas, dificulta composicao e debug. Prefira scopes explicitos.

## APIs

38. REST: diferenca entre PUT e PATCH?

`PUT` substitui recurso completo. `PATCH` aplica alteracao parcial. Na pratica Rails usa `PATCH` para update parcial.

39. Status HTTP comuns?

200 OK, 201 criado, 204 sem corpo, 400 request invalido, 401 nao autenticado, 403 nao autorizado, 404, 409 conflito, 422 erro semantico/validacao, 429 rate limit, 500.

40. Autenticacao vs autorizacao?

Autenticacao identifica quem e. Autorizacao decide o que pode fazer.

41. Como versionar API?

Por path (`/v1`), header ou content negotiation. Path e simples e operacionalmente claro. Evite quebrar contrato sem versao.

42. Como lidar com paginacao?

Offset e simples, ruim em tabelas grandes e dados mutaveis. Cursor/keyset e melhor para escala e consistencia.

43. Idempotencia em API?

Mesma operacao repetida deve produzir o mesmo efeito. Essencial para pagamentos, criacao com retry, webhooks e jobs. Use idempotency key + constraint no banco.

44. Como projetar endpoint de alta escala?

Defina SLA, cardinalidade, padrao de acesso, indice, paginacao, cache, rate limit, payload minimo, tracing e caminho assincrono para trabalho pesado.

## Jobs / Assincrono

45. Quando usar background job?

Trabalho lento, externo, retryable ou nao necessario para resposta sincrona: email, webhook, processamento, relatorios, integracoes.

46. Active Job vs Sidekiq/Solid Queue?

Active Job e abstracao Rails. Backend real executa fila. Sidekiq usa Redis. Solid Queue usa banco. Active Job padroniza API e callbacks, mas a semantica operacional depende do backend.

47. Como escrever job robusto?

Idempotente, pequeno, retry-safe, com timeout, logs estruturados, chave unica quando necessario, sem depender de estado em memoria.

48. Como evitar duplicidade em job?

Constraint unica no banco, idempotency key, lock transacional, unique jobs ou dedupe no enqueue. Nao confie so em "nao enfileirar duas vezes".

49. Quando nao usar retry automatico?

Erro permanente: validacao, autorizacao, dado inexistente esperado. Retry so para falha transitoria: timeout, rate limit, indisponibilidade temporaria.

## Performance / Escala

50. Como diagnosticar endpoint lento?

Meca primeiro: tempo total, SQL, alocacao, cache hit, chamadas externas, serializacao, fila, lock, GC. Depois otimize o gargalo real.

51. Principais causas de lentidao em Rails?

N+1, query sem indice, payload grande, serializer pesado, callback caro, chamada externa sincrona, cache ruim, lock no banco, GC por muita alocacao.

52. Como usar cache corretamente?

Cache dado caro e relativamente estavel. Defina chave, expiracao, invalidacao e fallback. Cuidado com cache que esconde autorizacao ou tenant errado.

53. O que e cache stampede?

Muitos requests recalculam o mesmo cache expirado ao mesmo tempo. Mitigue com lock, race condition TTL, refresh assincrono ou jitter.

54. Puma threads/processes: como ajustar?

Threads aumentam concorrencia I/O, mas exigem connection pool compativel. Processos aumentam paralelismo e memoria. Ajuste com benchmark real.

55. Connection pool: erro comum?

Puma threads maior que `database.yml pool` causa espera por conexao. Sidekiq/jobs tambem precisam de pool proprio dimensionado.

56. Como escalar leitura no banco?

Indices, query tuning, cache, read replicas, particionamento, sharding. Escolha conforme gargalo real e custo operacional.

## Seguranca

57. Como evitar SQL Injection?

Use query parametrizada/Active Record seguro. Nunca concatene input em SQL. Cuidado com `order(params[:sort])`, `where("x = #{params[:x]}")` e identificador dinamico sem allowlist.

58. CSRF importa em API?

Depende. API stateless com bearer token nao usa a mesma protecao que app com cookie/sessao. Se usa cookie de sessao, CSRF importa.

59. XSS em backend API?

Pode ocorrer se API persiste HTML/script e outro cliente renderiza sem escape. Sanitize/escape no boundary correto.

60. Mass assignment ainda e problema?

Sim, via strong params mal definidos. Nunca permita campos sensiveis como `admin`, `role`, `account_id`, `user_id` direto do request.

61. Open redirect?

Redirecionar para URL controlada pelo usuario permite phishing/token leak. Use allowlist ou paths internos.

62. O que revisar em seguranca Rails?

Sessoes, cookies, CSRF, SQL injection, XSS, upload, redirect, headers, auth, brute force e logs sem segredo.

## Observabilidade / Operacao

63. Logs bons tem o que?

Request id, user/account id quando seguro, endpoint, status, duracao, erro, job id, correlation id, sem segredo/token/PII sensivel.

64. Metrica vs log vs trace?

Metrica mostra tendencia. Log mostra evento. Trace mostra caminho distribuido. Senior usa os tres.

65. Como instrumentar Rails?

Use `ActiveSupport::Notifications` para medir eventos internos/customizados. Rails expoe hooks para SQL, controller, jobs, cache etc.

66. O que fazer em incidente de producao?

Mitigar impacto, preservar evidencia, rollback/feature flag se possivel, medir, corrigir causa raiz, postmortem sem caca as bruxas.

## Testes / Qualidade

67. Que testes espera num backend Rails?

Model specs para regra local, request specs para contrato API, service specs para caso de uso, job specs para assincrono, system tests so quando necessario.

68. Mockar ou nao mockar?

Mock para boundary externo. Nao mockar Active Record sem motivo. Teste comportamento, nao implementacao interna.

69. Factory lenta: como resolver?

Menos callbacks, menos associacoes implicitas, `build_stubbed` quando possivel, fixtures para dados estaveis, factories explicitas.

70. O que e teste fragil?

Depende de ordem, tempo real, rede, banco compartilhado, texto incidental, implementacao interna ou dados globais.

## Arquitetura Senior / Specialist

71. Como quebrar monolito Rails?

Primeiro modularize dentro do monolito: boundaries, ownership, eventos, contratos, dependencias. So extraia servico quando houver motivo operacional forte.

72. Monolito modular vs microservices?

Monolito modular reduz complexidade operacional. Microservice so compensa com escala organizacional, deploy independente, ownership claro e maturidade observavel.

73. Como desenhar multi-tenancy?

Opcoes: `tenant_id` por tabela, schema por tenant, banco por tenant. Escolha por isolamento, escala, compliance, custo operacional e complexidade de queries.

74. Como garantir consistencia entre DB e servico externo?

Nao existe transacao distribuida simples. Use outbox pattern, idempotencia, retry, estado intermediario e reconciliacao.

75. Como lidar com webhook?

Verificar assinatura, salvar evento bruto, processar assincronamente, idempotencia por event id, responder rapido, retry-safe.

76. Como revisar PR senior?

Contrato, seguranca, concorrencia, dados, rollback, observabilidade, teste relevante, simplicidade, impacto em performance e migracao.

77. Como responder "explique uma decisao arquitetural"?

Use trade-off: contexto, restricoes, alternativas, decisao, consequencia e plano de reversao.

78. O que diferencia specialist de senior comum?

Especialista antecipa falha operacional: concorrencia, rollback, dados, seguranca, custo, observabilidade, manutencao e evolucao do sistema.
