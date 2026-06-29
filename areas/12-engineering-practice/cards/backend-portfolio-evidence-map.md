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

Escolha 3 linhas do mapa, abra os arquivos e rode os comandos. Depois responda em voz alta: qual risco o projeto controla, qual custo ele aceita e por que nao escolheu a alternativa vizinha.

## Evidence Map

Regra de leitura:

1. abra o arquivo exato;
2. rode o comando de verificacao;
3. diga o trade-off sem olhar a resposta.

A maior parte das ancoras abaixo reaproveita os repos locais ja prontos para avaliacao. As duas excecoes deliberadas sao:

- `system-design-estudos` para CAP, porque a evidencia canonica aqui e conceitual antes de ser de produto;
- `kubepulse-go-operator` para Kubernetes, porque ele e o repo local mais claro sobre reconciliacao e policy-before-apply, mesmo fora do tranche atual de "ready: yes".

| Concept | Project | Exact evidence file | Verification command | Tradeoff taught |
| --- | --- | --- | --- | --- |
| Auth | [TrustVault Go Security Control Plane](../../../../trustvault-go-security-control-plane/README.md) | [docs/security/authorization-matrix.md](../../../../trustvault-go-security-control-plane/docs/security/authorization-matrix.md) | `cd ../trustvault-go-security-control-plane && make verify` | Centralizar ciclo de credenciais e escopos evita drift de seguranca entre servicos, mas cria um control plane que tambem precisa governanca forte. |
| Rate limits | [FerrisLedger Rust Financial Runtime](../../../../ferrisledger-rust-financial-runtime/README.md) | [README.md](../../../../ferrisledger-rust-financial-runtime/README.md) | `cd ../ferrisledger-rust-financial-runtime && cargo test --workspace --all-targets` | Rate limit de trafego valido e rate limit de falha de auth sao controles diferentes; misturar os dois esconde abuso real ou derruba cliente legitimo. |
| Idempotency | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [test/requests/idempotency_test.rb](../../../../settleflow-rails-financial-core/test/requests/idempotency_test.rb) | `cd ../settleflow-rails-financial-core && bin/rails test test/requests/idempotency_test.rb` | Idempotencia precisa morar junto da identidade do comando e da escrita de negocio, nao so em middleware ou cache efemero. |
| Queues | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/events/messaging.md](../../../../settleflow-rails-financial-core/docs/events/messaging.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/jobs/outbox_publish_job_test.rb test/jobs/outbox_sweep_job_test.rb test/services/outbox_event_contract_test.rb` | Outbox mais job local simplifica o MVP e preserva consistencia; broker-first so vale quando fanout e throughput realmente exigem. |
| Caching | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/database/redis-usage.md](../../../../settleflow-rails-financial-core/docs/database/redis-usage.md) | `cd ../settleflow-rails-financial-core && REDIS_URL=redis://localhost:6379/0 bin/rails redis:verify` | Cache e lock temporario podem aliviar operacao, mas dinheiro, reconciliacao e idempotencia continuam no banco de verdade. |
| Observability | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [README.md](../../../../tracebridge-go-observability-pipeline/README.md) | `cd ../tracebridge-go-observability-pipeline && make review` | Nao basta instrumentar a app; o proprio pipeline de observabilidade precisa metricas, readiness, DLQ e sinais de backpressure. |
| CI/CD | [Active Record Optimizer](../../../../active_record_optimizer/README.md) | [.github/workflows/ci.yml](../../../../active_record_optimizer/.github/workflows/ci.yml) | `cd ../active_record_optimizer && bundle exec rake verify` | CI forte valida contrato publicado, empacotamento e integracao real, nao so unit tests locais. |
| Railway | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [railway.json](../../../../tracebridge-go-observability-pipeline/railway.json) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/config -run 'TestLoad(UsesRailwayPortWhenTracebridgeAddrIsUnset|PrefersTracebridgeAddrOverPort)' -count=1` | Demo deploy rapido acelera review e sharing, mas o topo Railway de um servico ainda nao substitui a topologia completa de producao. |
| Transactions | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/database/transaction-boundaries.md](../../../../settleflow-rails-financial-core/docs/database/transaction-boundaries.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/services/database_consistency_verifier_test.rb` | Ledger, projection, idempotency e outbox precisam comitar juntos; publicacao e cache podem esperar o pos-commit. |
| CAP | [System Design Estudos](../../../README.md) | [areas/06-foundations-distribuidas/topics/cap-theorem.md](../../06-foundations-distribuidas/topics/cap-theorem.md) | `bundle exec rake check` | Particao nao e detalhe de infra; ela obriga escolha explicita entre disponibilidade e coordenacao antes de discutir produto ou banco. |
| Ledgers | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [docs/adr/0001-double-entry-ledger.md](../../../../settleflow-rails-financial-core/docs/adr/0001-double-entry-ledger.md) | `cd ../settleflow-rails-financial-core && bin/rails test test/services/database_consistency_verifier_test.rb` | Ledger de dupla entrada torna saldo explicavel e auditavel; balance field mutavel simplifica o CRUD e empobrece a verdade financeira. |
| Kubernetes | [KubePulse Go Operator](../../../../kubepulse-go-operator/README.md) | [docs/architecture/overview.md](../../../../kubepulse-go-operator/docs/architecture/overview.md) | `cd ../kubepulse-go-operator && make review` | Reconciliacao com status conditions custa mais que manifestos estaticos, mas ganha drift detection, policy enforcement e feedback operacional. |
| Event sourcing | [FerrisLedger Rust Financial Runtime](../../../../ferrisledger-rust-financial-runtime/README.md) | [docs/architecture/data-consistency.md](../../../../ferrisledger-rust-financial-runtime/docs/architecture/data-consistency.md) | `cd ../ferrisledger-rust-financial-runtime && cargo test --workspace --all-targets` | Evento como verdade primaria da replay e auditoria, mas puxa para dentro do produto a complexidade de versionamento, snapshot e storage. |
| Retries | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [README.md](../../../../tracebridge-go-observability-pipeline/README.md) | `cd ../tracebridge-go-observability-pipeline && make review` | Retry sem classificacao e backoff so converte outage temporario em tempestade permanente. |
| DLQ | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [docs/runbooks/dlq-spike.md](../../../../tracebridge-go-observability-pipeline/docs/runbooks/dlq-spike.md) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/httpapi -run 'TestReplay(MetricsTrackAcceptedAndSkippedEntries|OmitsOtherTenantEntriesWhenAuthenticatedTenantIsScoped|RejectsTenantMismatchForAPIKey)' -count=1` | Dead-letter preserva evidencia e controla blast radius, mas obriga triagem humana antes de devolver trafego ao pipeline. |
| Replay | [TraceBridge Go Observability Pipeline](../../../../tracebridge-go-observability-pipeline/README.md) | [docs/runbooks/replay-failures.md](../../../../tracebridge-go-observability-pipeline/docs/runbooks/replay-failures.md) | `cd ../tracebridge-go-observability-pipeline && go test ./internal/httpapi -run 'TestReplay(MetricsTrackAcceptedAndSkippedEntries|OmitsOtherTenantEntriesWhenAuthenticatedTenantIsScoped|RejectsTenantMismatchForAPIKey)' -count=1` | Replay seguro e feature de operacao com escopo, tenant e lote; nao e botao magico de "reprocessar tudo". |
| Tenant isolation | [SettleFlow Rails Financial Core](../../../../settleflow-rails-financial-core/README.md) | [test/requests/v1_authorization_matrix_test.rb](../../../../settleflow-rails-financial-core/test/requests/v1_authorization_matrix_test.rb) | `cd ../settleflow-rails-financial-core && bin/rails test test/requests/v1_authorization_matrix_test.rb test/requests/ops_authorization_matrix_test.rb` | Isolamento real atravessa API, backoffice e auditoria; nao basta schema multi-tenant se o caminho ops fura a fronteira. |

## Source Anchor

- [Architecture Decision Records](https://adr.github.io/).
- [Google SRE Workbook](https://sre.google/workbook/).
- [AWS Well-Architected Framework](https://docs.aws.amazon.com/wellarchitected/latest/framework/welcome.html).
