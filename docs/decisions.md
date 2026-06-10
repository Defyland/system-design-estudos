# Decisions

Registro curto das decisoes tecnicas. Entrada nova no topo.

## 2026-06-10 - Tooling overhaul do curriculo

- **Ruby 3.4.9 fixado** (`.ruby-version` + `.tool-versions`). Ultima 3.4.x estavel,
  alinhada ao cockpit, com imagem Docker e suporte em `ruby/setup-ruby`.
- **Encoding UTF-8 por padrao nos scripts** (`Encoding.default_external/internal`).
  Os scripts liam arquivos com a encoding do locale e quebravam com
  "invalid byte sequence in US-ASCII" fora de um locale UTF-8. Escolhido por ser
  um fix global de uma linha em vez de passar `encoding:` em cada `.read`.
- **CI roda os scripts direto com `ruby`, sem Bundler.** Os scripts sao stdlib puro;
  evitar `bundle exec` no CI tira o acoplamento com a versao de Bundler do lock.
  O Gemfile/Rakefile ficam para o fluxo local.
- **STUDY_PLAN passa a ser gerado do manifest** (blocos `curriculum:start`).
  `COURSE_OUTLINE.md` e `CASE_DRIVEN_STUDY.md` ficam escritos a mao de proposito:
  sao material de origem (ementa) e metodo, nao derivados do manifest.
- **Foundations (06) amarrado por links reciprocos enforced pelo validador.**
  Cada chapter declara `foundations:` no manifest e precisa linkar os topicos no
  Study Context; os topicos ja linkavam de volta. Evita area orfa do spine.
- **Contrato de practice_area e estrutural, nao por secoes fixas.** Areas 01-05 sao
  prosa; exigir secoes rigidas geraria churn. O contrato exige que o README liste
  todos os examples/snippets e que `notes.md` tenha um unico H1.
- **Engine de simulacao cobre so os 4 labs numericos** (cache, consumer-lag, fanout,
  rate-limit). Labs procedurais (failover, ACL cutover, rollout) seguem como roteiro.
- **`progress.yml` e estado editado a mao, nao gerado.** As datas de inicio sao do
  usuario; gerar o arquivo apagaria esse estado. O `progress.rb` so avisa quando o
  conjunto de chapters diverge do manifest.
