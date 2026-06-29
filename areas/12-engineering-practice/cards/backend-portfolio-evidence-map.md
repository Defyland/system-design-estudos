# Backend Portfolio Evidence Map

## When to Use

Quando voce quer sair do estudo abstrato e provar um conceito com evidencia de portfolio: repo certo, arquivo certo e comando certo.

## What Breaks First

O estudo vira lista de buzzwords. A pessoa sabe falar "idempotencia", "DLQ" ou "tenant isolation", mas nao consegue abrir um repo proprio e mostrar onde isso aparece de verdade.

## Design Moves

Trate cada conceito como um caminho de prova curto: nomeie o melhor projeto ancora, linke um arquivo exato, execute um comando pequeno e explique o trade-off que aquele artefato ensina.

## Interview Trap

Responder com arquitetura generica sem evidencias. Portfolio forte nao e so "tenho um projeto com isso"; e "aqui esta o arquivo, aqui esta o teste, aqui esta a decisao".

## Practice Drill

Faca 3 passes:

1. pegue 1 conceito de `request boundary`, 1 de `consistency spine` e 1 de `runtime and delivery`;
2. abra o arquivo exato e rode o comando;
3. diga em voz alta: que risco esta sendo controlado, o que quebra primeiro e qual alternativa foi rejeitada;
4. so depois compare com um exemplo `em construcao`.

## Trust Legend

Autoridade usada neste card:
- [full-program-readiness-2026-06-29.json](../../../../.agents/eval-reports/full-program-readiness-2026-06-29.json)

Como ler o status:

- `Trusted first`: `ready: yes` no report. Comece por aqui.
- `Em construcao`: `ready: no` no report. Leia como contraste arquitetural, nao como primeira ancora de confianca.
- `Publication signal`: o report nao expõe um campo separado de visibilidade GitHub. Quando ele nao traz um sinal explicito de publicacao, trate a confianca como `readiness-first`, nao como prova de repo publico.

## How to Read This Map

Nao leia em ordem alfabetica. Leia em ordem de sistema:

1. `request boundary`: quem entra, com qual chave, com qual tenant, com qual replay protection;
2. `consistency spine`: onde ficam verdade, transacao, fila, cache e ledger;
3. `runtime and delivery`: como provar health, retry, replay, deploy e CI.

## Pass 1 - Request Boundary

| Concept | Project | Exact evidence file | Verification command | Trust status | Tradeoff taught |
| --- | --- | --- | --- | --- | --- |
| Auth | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/adr/0003-api-key-idempotency.md](../../../../settleflow-rails-financial-core/docs/adr/0003-api-key-idempotency.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/requests/v1_authorization_matrix_test.rb test/requests/idempotency_test.rb` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | API key com escopo e idempotency key simplifica server-to-server fintech APIs, mas o produto passa a ser dono de rotacao, escopos e auditoria de credenciais. |
| Idempotency | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [test/requests/idempotency_test.rb](../../../../settleflow-rails-financial-core/test/requests/idempotency_test.rb) | `cd ../settleflow-rails-financial-core && bin/rails test test/requests/idempotency_test.rb` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Idempotencia so funciona de verdade quando metodo, path, query e request hash entram na identidade do comando; middleware sozinho nao protege debito duplicado. |
| Rate limits | [FerrisLedger Rust Financial Runtime](../../../../ferrisledger-rust-financial-runtime/README.md) | [docs/security/authorization-matrix.md](../../../../ferrisledger-rust-financial-runtime/docs/security/authorization-matrix.md) | `cd ../ferrisledger-rust-financial-runtime && cargo test --workspace --all-targets` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Rate limit de trafego autenticado e limite de falha de auth precisam ser separados; misturar tudo vira ruído operacional e mascara abuso real. |
| Tenant isolation | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [test/requests/v1_authorization_matrix_test.rb](../../../../settleflow-rails-financial-core/test/requests/v1_authorization_matrix_test.rb) | `cd ../settleflow-rails-financial-core && bin/rails test test/requests/v1_authorization_matrix_test.rb test/requests/ops_authorization_matrix_test.rb` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Isolamento real atravessa API publica, console ops e auditoria; schema multi-tenant sem matriz de permissao ainda deixa vazamento pelo caminho humano. |

## Pass 2 - Consistency Spine

| Concept | Project | Exact evidence file | Verification command | Trust status | Tradeoff taught |
| --- | --- | --- | --- | --- | --- |
| Transactions | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/database/transaction-boundaries.md](../../../../settleflow-rails-financial-core/docs/database/transaction-boundaries.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/services/database_consistency_verifier_test.rb` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Ledger, projection, idempotency e outbox precisam comitar juntos; publicacao, analytics e cache ficam para depois do commit. |
| Queues | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/events/messaging.md](../../../../settleflow-rails-financial-core/docs/events/messaging.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/jobs/outbox_publish_job_test.rb test/jobs/outbox_sweep_job_test.rb test/services/outbox_event_contract_test.rb` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Outbox transacional com jobs locais segura consistencia cedo; broker-first so compensa quando throughput, fanout ou integracoes pedem mais que isso. |
| Caching | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/database/redis-usage.md](../../../../settleflow-rails-financial-core/docs/database/redis-usage.md) | `cd ../settleflow-rails-financial-core && REDIS_URL=redis://localhost:6379/0 bin/rails redis:verify` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Cache e lock temporario ajudam operacao, mas saldo, reconciliacao e idempotencia continuam no sistema de verdade; perder Redis nao pode corromper dinheiro. |
| Ledgers | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/adr/0001-double-entry-ledger.md](../../../../settleflow-rails-financial-core/docs/adr/0001-double-entry-ledger.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/services/database_consistency_verifier_test.rb test/services/ledger_journal_poster_test.rb` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Ledger de dupla entrada encarece o modelo, mas transforma saldo em evidencia explicavel em vez de numero mutavel sem trilha contábil. |
| Event sourcing | [FerrisLedger Rust Financial Runtime](../../../../ferrisledger-rust-financial-runtime/README.md) | [docs/architecture/data-consistency.md](../../../../ferrisledger-rust-financial-runtime/docs/architecture/data-consistency.md) | `cd ../ferrisledger-rust-financial-runtime && cargo test --workspace --all-targets` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Replay como verdade primaria ajuda auditoria e rebuild, mas puxa para dentro do produto a complexidade de versionamento, snapshot e storage append-only. |
| CAP | [System Design Estudos](../../../README.md) | [areas/06-foundations-distribuidas/topics/cap-theorem.md](../../06-foundations-distribuidas/topics/cap-theorem.md) | `bundle exec rake check` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Particao nao e detalhe de infraestrutura; e o limite que obriga escolher onde voce aceita indisponibilidade e onde voce aceita coordenação fraca. |

## Pass 3 - Runtime and Delivery

| Concept | Project | Exact evidence file | Verification command | Trust status | Tradeoff taught |
| --- | --- | --- | --- | --- | --- |
| Observability | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [internal/app/app_test.go](../../../../tracebridge-go-observability-pipeline/internal/app/app_test.go) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/app -run TestAppOperationalSurfaceReflectsPipelineState -count=1` | Trusted first. `ready: yes` no report. Railway surface passes in authority file. Publication signal not explicit in authority file. | O pipeline de observabilidade tambem precisa ser observavel; health, readiness, metrics e accepted/exported counts sao parte do produto, nao detalhe lateral. |
| Retries | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [internal/pipeline/retry_test.go](../../../../tracebridge-go-observability-pipeline/internal/pipeline/retry_test.go) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/pipeline -run TestRetryPolicy -count=1` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Retry sem classificacao de erro e backoff capped so converte outage temporario em tempestade repetida. |
| DLQ | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [docs/runbooks/dlq-spike.md](../../../../tracebridge-go-observability-pipeline/docs/runbooks/dlq-spike.md) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/httpapi -run 'TestReplay(MetricsTrackAcceptedAndSkippedEntries|OmitsOtherTenantEntriesWhenAuthenticatedTenantIsScoped|RejectsTenantMismatchForAPIKey)' -count=1` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | DLQ preserva evidencia e reduz blast radius, mas cobra triagem humana antes de qualquer replay em lote. |
| Replay | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [internal/httpapi/api_test.go](../../../../tracebridge-go-observability-pipeline/internal/httpapi/api_test.go) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/httpapi -run 'TestReplay(MetricsTrackAcceptedAndSkippedEntries|OmitsOtherTenantEntriesWhenAuthenticatedTenantIsScoped|RejectsTenantMismatchForAPIKey)' -count=1` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Replay seguro e fluxo de operacao com escopo de tenant e lote pequeno; nao e botao magico para "processar tudo de novo". |
| Railway | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [docs/deployment/railway.md](../../../../tracebridge-go-observability-pipeline/docs/deployment/railway.md) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/config -run 'TestLoad(UsesRailwayPortWhenTracebridgeAddrIsUnset|PrefersTracebridgeAddrOverPort)' -count=1` | Trusted first. `ready: yes` no report. Railway surface passes in authority file. Publication signal not explicit in authority file. | Railway acelera demo e smoke deploy, mas memory buffer e DLQ local ainda sao topologia de review, nao topologia final de producao. |
| CI/CD | [Active Record Optimizer](../../../../active_record_optimizer/README.md) | [.github/workflows/ci.yml](../../../../active_record_optimizer/.github/workflows/ci.yml) | `cd ../active_record_optimizer && bundle exec rake verify` | Trusted first. `ready: yes` no report. Publication signal: authority file inclui commit `Initial public release`. | CI forte prova contrato publicado, empacotamento e integracao real; nao basta rodar unit test solto no host do autor. |
| Kubernetes | [KubePulse Go Operator](../../../../kubepulse-go-operator/README.md) | [internal/controller/goservice_controller_test.go](../../../../kubepulse-go-operator/internal/controller/goservice_controller_test.go) | `cd ../kubepulse-go-operator && go test ./internal/controller -count=1` | Trusted first. `ready: yes` no report. Publication signal not explicit in authority file. | Reconciliacao com status conditions custa mais que Helm ou manifestos estaticos, mas compra drift repair, idempotencia e feedback de rollout. |

## Advanced Security Control Plane

Use esta linha depois de dominar as ancoras `trusted first` do request boundary
e do runtime.

| Concept | Project | Exact evidence file | Verification command | Trust status | Tradeoff taught |
| --- | --- | --- | --- | --- | --- |
| Auth control plane | [TrustVault Go Security Control Plane](../../../../trustvault-go-security-control-plane/README.md) | [docs/security/authorization-matrix.md](../../../../trustvault-go-security-control-plane/docs/security/authorization-matrix.md) | `cd ../trustvault-go-security-control-plane && make verify` | Trusted first. O sweep ativo agora marca `ready: yes`, e o repo ja esta publico em `main`. | Tirar credenciais, secret rotation e break-glass de cada servico reduz drift de seguranca, mas cria um novo plano de controle que tambem precisa alta disciplina operacional. |

## Source Anchor

- [Architecture Decision Records](https://adr.github.io/).
- [Google SRE Workbook](https://sre.google/workbook/).
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html).
