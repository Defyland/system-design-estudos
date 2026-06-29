# Decisions

Registro curto das decisoes tecnicas. Entrada nova no topo.

## [2026-06-29] Integrar os 10 conceitos de backend como guia visual e lab de request path

Contexto: O artigo "10 Backend Concepts Every Developer Must Know" foi usado como lista de topicos para cobrir auth/authz, rate limiting, indexing, ACID/transactions, caching, queues, load balancing, CAP, reverse proxy e CDN dentro do curriculo existente. O material precisava servir para estudo ativo e preparacao de entrevista, sem copiar texto do artigo nem abrir uma trilha paralela redundante.

Opções consideradas:
- Criar um card integrador em `areas/09-backend-principles` e um lab ativo em `areas/13-backend-principle-labs`
- Criar dez cards novos separados — rejeitada porque duplicaria cards e chapters ja existentes sobre auth, cache, queues, rate limiting, search, CDN e CAP
- Criar um novo chapter canonico — rejeitada porque os 14 chapters ja cobrem parte dos conceitos em contexto de system design e um chapter extra quebraria a ordem principal sem necessidade
- Alterar o cockpit com nova feature visual — rejeitada porque o cockpit ja importa `backend_principle` e `backend_lab`; bastava atualizar a documentacao do sync

Decisão: Criar `ten-backend-concepts-visual-field-guide.md` como guia visual dos 10 conceitos e `map-a-backend-request-path.md` como lab de treino ativo, mantendo o conteudo em areas ja existentes e atualizando os indices locais.

Porquê: Um guia integrador evita duplicacao, conecta conceitos a chapters, labs, simulations e decision-contrasts ja existentes, e o lab transforma leitura em desenho, falha simulada e defesa oral.

Consequências / tradeoffs aceitos: O material novo fica mais denso que um card simples, mas ganha utilidade comparativa. A ordem canonica do curriculo nao muda; quem estuda pelo cockpit encontra o card e o lab pela biblioteca, nao como chapter numerado.

Revisar se: Os 10 conceitos virarem uma trilha independente com checkpoints proprios, ou se o cockpit passar a exigir navegacao dedicada para backend principles.

Relacionada: 2026-06-10 - Tooling overhaul do curriculo

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
