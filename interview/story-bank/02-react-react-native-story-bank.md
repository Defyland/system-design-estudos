# STAR Tecnico + Q&A - Frontend React / React Native

Curriculo alvo: `allan_resume_rn_en.pdf`.

Enfase: React, React Native, TypeScript, UI/UX, performance de render, mobile, Smart TV, estado, micro-frontends e arquitetura frontend.

Use este documento quando a vaga for frontend/mobile-heavy. Backend aparece apenas como vantagem de contexto: API contracts, permissoes, cache, seguranca e producao end-to-end.

## Evidence Boundary

Fatos diretamente sustentados pelo curriculo:

- 10+ anos com React e React Native.
- Apps em iOS, Android, Samsung Tizen e LG webOS.
- React, Next.js, TypeScript, Redux, TanStack Query, GraphQL e Module Federation.
- TurboRepo, Webpack, Vite, Docker, Kubernetes, AWS, CI/CD e observability.
- Jest, React Testing Library, Cypress, Playwright, Detox e RSpec.
- Micro-frontends: 8 independentes, 5 squads, deploy de cerca de 2 dias para menos de 1 hora.
- TurboRepo em 15 apps/shared libraries, CI de 25 para 8 min e PR single-package abaixo de 3 min.
- TanStack Query em dashboards de alto volume.
- Lista critica de 7s para 2s sob o mesmo volume com render optimization e virtualization.
- App RN multi-tenant com geolocation targeting para campanhas localizadas.
- Smart TV RN compartilhado para Samsung Tizen e LG webOS, com remote navigation, memory management e incremental rail rendering.

Detalhes como `requiredVersion`, `strictVersion`, grafo explicito de foco, implementacao exata de reconnect/backoff e metricas de bundle devem ser usados como talk track tecnico so se voce conseguir defender que foram realmente usados. Se nao, formule como desenho ou abordagem.

Confidence: high para fatos do curriculo; moderate para detalhes de implementacao inferidos.

## Claim Expansion Rule

Quando fizer uma afirmativa forte, responda sempre nesta ordem:

What.

O que exatamente era a tela, o app, o boundary de frontend ou o problema de performance.

Why.

Por que aquilo importava para release, UX, platform constraints, consistencia de estado ou throughput do time.

How.

Como voce implementou: boundaries, cache, virtualization, state management, versioning, foco, memoization, profiling, testes.

Problemas evitados.

Quais falhas, regressos ou efeitos colaterais a solucao precisava evitar.

Result.

Qual efeito observavel voce teve, usando apenas numeros ou efeitos sustentados pelo curriculo.

## Opening - React / React Native

I am a senior React and React Native engineer with 10+ years of experience building web, mobile, and Smart TV applications.

The strongest frontend pattern in my career is not just shipping screens. It is reducing coordination cost, making server state predictable, controlling render cost under real data volume, and adapting the UI architecture to the actual platform constraints instead of pretending web, mobile, and Smart TV are the same environment.

## 1. Fulllab / Total Commit - Full Stack React + React Native, 2016-2018

### STAR

Situation.

Dois produtos com web React e mobile React Native: Easylive, uma plataforma de troca de pontos, e OJK, um produto com notificacoes geo em tempo real e location-aware push.

What.

O que eu estava construindo aqui eram clientes web e mobile que dependiam de integracoes, estado distribuido entre dispositivos e comportamento realtime. Nao era so "fazer a tela"; era manter consistencia de UX e estado em produtos com eventos assincronos chegando no client.

Why.

Realtime mal implementado no client vira bug intermitente: mensagem duplicada, dado defasado depois de reconexao, UI presa em estado antigo. Em React Native antigo, performance ruim em lista ou animacao virava problema visivel rapidamente.

How.

No OJK, o client consumia notificacoes geo em tempo real via WebSocket/Action Cable. A forma correta de explicar esse claim em entrevista e: abrir o socket era a parte simples; o trabalho serio era reconexao com backoff, dedupe de mensagem e reconciliacao de estado depois que a conexao caia. Em mobile, a rede muda, o app vai para background e a conexao volta em momento imprevisivel, entao o client precisa recuperar consistencia em vez de assumir sessao linear.

Tambem trabalhei com Cypress no frontend, o que fazia sentido porque ajudava a detectar bug de fluxo antes de producao.

Problemas evitados.

Os primeiros problemas nesse tipo de app sao: socket sem politica de reconnect, estado divergente depois de reconectar, re-render caro em React Native mais antigo, e tentativa de compartilhar codigo de UI entre web e native de forma errada.

Result.

Entrega consistente entre web e mobile e deteccao de bugs mais rapida no ciclo.

### Q&A

Q: Tempo real no client - o que tratar alem de abrir o socket?

Reconexao com backoff, porque mobile cai de rede, entra em background e troca conexao o tempo todo. Tambem precisa dedupe de mensagem depois de reconectar e reconciliacao de estado: o que foi perdido enquanto o socket estava fora? Socket ingenuo funciona em demo, mas quebra em rede real.

Q: React Native cedo, em 2016, tinha quais limitacoes?

O custo da bridge JS/native era mais visivel, especialmente em listas grandes e animacoes. Sem a infraestrutura atual como Hermes e nova arquitetura, performance dependia muito de disciplina de render, listas virtualizadas e evitar trabalho pesado na thread JS.

Q: Quanto reaproveitar entre React web e React Native?

Reaproveite logica de dominio, estado, cliente de API, schemas e validacoes em JS puro. Nao force reaproveitamento de UI porque DOM e native primitives sao diferentes. A fronteira boa e: dominio compartilhado, apresentacao separada.

## 2. Sonata - React/TypeScript Web + React Native, 2018-2019

### STAR

Situation.

Digifair era um e-commerce internacional com web React/TypeScript e app React Native, escalando depois do launch.

What.

O problema aqui era manter paridade de UX e consistencia de dados entre duas superficies diferentes: web e mobile, compartilhando comportamento sem acoplar apresentacao.

Why.

Quando web e mobile implementam estado e integracao de forma independente, o produto diverge rapido. O usuario sente isso como comportamento inconsistente; a equipe sente como duplicacao de bug e dificuldade de evolucao.

How.

Arquitetei estado compartilhado com Redux entre web e mobile. O ponto importante nao e "usei Redux"; e por que a camada compartilhada fazia sentido. Reducers, actions, selectors e API client podiam viver em pacote agnostico de plataforma, sem dependencias de DOM ou native UI. Cada plataforma mantinha navegacao e componentes proprios, mas o fluxo de dados e regras de sincronizacao eram consistentes.

Tambem implementei testes com Jest e React Testing Library em modulos criticos de web e mobile, o que ajuda porque protege comportamento sem acoplar a teste de implementacao interna.

Problemas evitados.

Os problemas comuns aqui sao: estado duplicado e divergente entre plataformas, dados aninhados demais causando updates caros, share de codigo no lugar errado e testes acoplados a estrutura interna do componente.

Result.

Paridade de UX entre plataformas e crescimento mensuravel de engajamento segundo o curriculo.

### Q&A

Q: Como estruturar Redux para compartilhar entre web e RN sem acoplar?

Camada de estado em pacote agnostico: store, reducers, selectors e API client sem import de DOM ou native. Web e RN consomem essa camada via hooks ou conectores, mas a UI e a navegacao ficam separadas. O que muda e a borda de apresentacao, nao o dominio.

Q: Por que normalizar estado no Redux?

Estado relacional aninhado gera duplicacao e update inconsistente. Normalizar por entidade/id permite update previsivel e evita recalcular arvores grandes de UI. Sem isso, atualizar um item pode forcar re-render caro em listas inteiras.

Q: O que testar com React Testing Library?

Comportamento do ponto de vista do usuario: o que renderiza, como interage e qual resultado aparece. Nao testar nome de metodo nem estado interno. Isso reduz acoplamento e sobrevive melhor a refactor.

## 3. Stormgroup / Globo / Projac - Tech Lead Smart TV, 2019-2020

### STAR

Situation.

App de TV em Samsung Tizen e LG webOS, rodando em hardware com CPU/RAM limitadas, navegacao por controle remoto e interfaces densas em rails de midia.

What.

O que eu estava liderando aqui era um codebase React Native compartilhado para Smart TV, nao um app mobile comum portado para outra tela. A superficie principal era uma home rica em conteudo, navegada por foco, em hardware limitado e com sessao longa.

Why.

Smart TV muda o problema tecnico. O input e D-pad, nao touch. O custo de render e memoria aparece muito mais cedo. E o app pode ficar aberto por horas, entao vazamento ou renderizacao excessiva nao derruba uma tela; derruba a experiencia inteira.

How.

Resolvi o problema a partir das restricoes reais da plataforma: navegacao por foco com controle remoto, gestao de memoria, rendering performance e incremental rail rendering. A forma defensavel de explicar isso e: eu nao podia montar centenas de tiles com imagem no boot e esperar que o hardware reagisse bem. A arquitetura precisava renderizar so o que era visivel, manter buffer controlado e reciclar o que saia do viewport.

Tambem forcei TypeScript strict mode no time e ajustei Webpack para reduzir bundle e melhorar throughput de CI/CD. O motivo disso era reduzir classe de bug de contrato e diminuir surpresa em runtime numa plataforma onde debugar e caro.

Problemas evitados.

Os problemas que aparecem primeiro em Smart TV sao: foco imprevisivel, home montando componentes demais, memoria crescendo com sessao longa, lista virtualizada quebrando navegacao e bundle pesado piorando startup e estabilidade.

Result.

O app rodou dentro das restricoes de memoria/performance de Smart TV, bundle ficou menor e bugs reduziram segundo o curriculo.

### Q&A

Q: O que muda em Smart TV vs mobile/web?

Input, hardware e ciclo de vida. Controle remoto exige foco previsivel. CPU/RAM sao limitadas, entao re-render e GC custam caro. O app pode ficar aberto por horas, entao vazamento de memoria derruba sessao. Virtualizacao e reciclagem de view sao requisito, nao luxo.

Q: Como implementar navegacao por controle remoto?

Com sistema de foco gerenciado. Cada elemento focavel precisa saber para onde o foco vai ao receber cima/baixo/esquerda/direita, ou o sistema precisa calcular isso de forma previsivel. O caso dificil e foco dentro de lista virtualizada: ao chegar no fim do renderizado, voce precisa renderizar o proximo bloco e transferir foco sem flicker.

Q: Qual problema a renderizacao incremental de rails resolve?

Uma home de TV pode ter 20 rails com 30 tiles cada, ou seja, centenas de componentes com imagem. Montar tudo no boot consome memoria e bloqueia a UI. Renderize rails visiveis mais buffer, virtualize tiles dentro de cada rail e recicle o que sai do viewport.

Q: O que TypeScript strict mode ganha num time?

`strictNullChecks` e `noImplicitAny` transformam contrato implicito em contrato compilavel. Em time grande, isso reduz bug de null/undefined, melhora refactor e diminui defensive coding em runtime.

## 4. Enjoei - Rails Engineer, Application Security, 2020-2021

### STAR

Papel majoritariamente backend/seguranca. Para entrevista frontend, use este angulo de forma honesta: TypeScript no checkout e mentalidade de seguranca aplicada ao client.

Situation.

Programa formal de seguranca, com remediacao continua de vulnerabilidades encontradas pelo Red Team.

What.

O que faz sentido usar desta experiencia em entrevista frontend nao e fingir que era um papel puro de UI. E mostrar que eu trabalhei em checkout com TypeScript e que seguranca mudou a forma como eu penso o client.

Why.

Frontend senior que ignora seguranca toma decisoes ruins em token storage, HTML dinamico, CSRF, permissoes e validacao. O client nao e fronteira de autorizacao; no maximo e uma camada de UX sobre regras que pertencem ao servidor.

How.

Refatorei checkout com Rails 6 e TypeScript, isolando validacao em microservico. O valor disso para o frontend e que a responsabilidade ficou mais clara: o client melhora experiencia, mas a fonte de verdade fica no backend. Em entrevista, eu ligo isso a XSS, CSRF, armazenamento de token e `dangerouslySetInnerHTML`: qualquer decisao de client precisa partir da premissa de que browser e input sao hostis por natureza.

Problemas evitados.

Os erros mais comuns aqui sao confiar em validacao de client como regra de negocio, usar HTML dinamico sem sanitizacao, guardar token de forma descuidada e tratar permissao como controle de render em vez de contrato de backend.

Result.

Checkout desacoplado e auditavel, com superficie de ataque reduzida.

### Q&A

Q: Que seguranca um frontend senior precisa dominar?

XSS, CSRF, armazenamento de token e o principio de nunca confiar no client. XSS envolve evitar ou sanear HTML dinamico, especialmente `dangerouslySetInnerHTML`. CSRF importa quando ha cookie/sessao em requests mutaveis. Token em `localStorage` sofre com XSS; cookie httpOnly reduz exposicao ao JS, mas traz trade-offs de CSRF e configuracao.

Q: `dangerouslySetInnerHTML` - quando usar?

Raramente, e somente com conteudo confiavel ou sanitizado. Se a fonte inclui input de usuario, precisa sanitizacao robusta. O nome e "dangerously" por um motivo: injeta HTML cru e abre vetor de XSS.

## 5. Bornlogic / Farfetch / Spring Global - Tech Lead, 2022-Present

### STAR

Situation.

Frontend monolitico compartilhado por 5 squads, deploy acoplado de cerca de 2 dias, dashboards de alto volume com fetch inconsistente, lista critica levando 7s para carregar e necessidade de app RN multi-tenant para distribuicao de conteudo em rede de franquias.

What.

O que eu estava resolvendo aqui eram tres problemas de naturezas diferentes, mas conectados: release coupling entre squads, server state inconsistente em dashboards de alto volume e custo alto de render numa lista critica. Ao mesmo tempo, havia um app React Native com regras de permissao multi-tenant e targeting por geolocalizacao.

Why.

Deploy acoplado custa tempo organizacional. Server state inconsistente custa bug e retrabalho. Lista de 7 segundos custa UX e confianca no produto. Permissao multi-tenant mal desenhada custa vazamento de contexto entre usuarios e tenants.

How.

Migrei o monolito para 8 micro-frontends com Module Federation. O por que dessa decisao era claro: o problema real era release ownership, nao apenas build tooling. Em entrevista, eu explicaria assim: eu precisava dar a cada squad uma unidade de deploy sem recriar um caos de runtime. Isso exige boundaries mais claros, disciplina em shared dependencies, contratos versionados, error boundaries e governanca minima para nao virar monolito distribuido.

Implementei TurboRepo no monorepo de 15 apps/shared libraries. O valor disso nao e somente "build mais rapido"; e reduzir feedback loop e evitar que um PR pequeno pague custo de repo inteiro sem necessidade.

Nos dashboards, introduzi TanStack Query para substituir fetch ad-hoc por uma camada explicita de cache, dedupe, stale-while-revalidate e invalidacao por key. O motivo e que server state tem problemas proprios: staleness, retry, refetch, sincronizacao com foco e reconexao. Tratar isso como estado local ou Redux puro costuma gerar complexidade desnecessaria.

Na lista critica, reduzi o load de 7s para 2s com virtualization/windowing e correcao de re-render. A forma correta de explicar o "como" e: primeiro profiler, depois virtualizar o que nao precisava existir em tela ao mesmo tempo, estabilizar keys, reduzir prop churn, memoizar onde o custo justificava e tirar calculo derivado caro do render.

No app React Native, construi o sistema de permissao multi-tenant e targeting por geolocalizacao com a premissa correta: o client mostra e filtra experiencia, mas a autorizacao real pertence ao servidor. No frontend, o desafio e manter cache e estado isolados por tenant e nao deixar contexto de um usuario contaminar outro.

Problemas evitados.

Os primeiros problemas nesse tipo de ambiente sao: version skew entre host e remotes, React duplicado em runtime, ownership difuso de shared package, invalidacao ruim de server state, lista grande renderizando o que nao esta visivel, memoization aplicada sem profiling e vazamento de contexto entre tenants no client.

Result.

Deploy de cerca de 2 dias para menos de 1 hora, release independente por squad, CI de 25 para 8 min, PR single-package abaixo de 3 min, e lista critica de 7s para 2s no mesmo volume de dados.

### Q&A

Q: Por que Module Federation e nao iframe ou single-spa?

Iframe isola demais e cria custo de comunicacao via `postMessage`, alem de dificultar design system e estado compartilhado. single-spa ajuda orquestracao, mas nao resolve sharing de dependencia em runtime da mesma forma. Module Federation e forte quando voce quer deploy independente mantendo stack comum e compartilhamento controlado de libs.

Q: Como evitar version skew entre host e remotes?

Contratos versionados, shared dependencies com politica clara, compatibilidade SemVer, checks de CI e isolamento por error boundary. Em Module Federation, detalhes como singletons e `requiredVersion` podem evitar duplicar React ou carregar versoes incompativeis, mas precisam ser governados.

Q: Lista de 7s para 2s - como chegar nesse resultado?

Primeiro profiler, nao chute. Identifique se o gargalo e rede, payload, render, layout ou imagem. Nesse caso, o resultado foi com render optimization e virtualization: renderizar so o visivel, corrigir re-render em cascata, estabilizar keys, memoizar itens quando fazia sentido, evitar prop churn e tirar calculo derivado caro do render.

Q: TanStack Query resolve o que Redux nao resolve bem?

Server state e diferente de client state. TanStack Query resolve cache de servidor: dedupe de request, stale-while-revalidate, invalidacao por key, refetch em foco/reconexao, retry e garbage collection de cache. Redux para server state vira reimplementar isso manualmente. Eu uso TanStack Query para server state e deixo Redux ou local state para estado de cliente quando necessario.

Q: `useMemo` e `useCallback` nao sao otimizacao prematura?

Podem ser, se aplicados sem medir. Fazem sentido quando uma prop instavel quebra `React.memo` ou quando calculo derivado e realmente caro. Sem filho memoizado ou custo mensurado, `useCallback` sozinho pode so adicionar complexidade.

Q: App RN multi-tenant - qual o desafio de frontend?

Permissao por tenant dirige o que cada usuario ve e pode fazer, mas o client nunca e fronteira de autorizacao. No frontend, o trabalho e renderizacao condicional por permissao, cache isolado por tenant, estado consistente por contexto e evitar vazamento visual ou de dados entre tenants. A autoridade final fica no servidor.

## React / RN Fast Answers

Q: Micro-frontends quando valem a pena?

Quando o custo de coordenar release entre squads e maior que a complexidade operacional de dividir o frontend. Se uma equipe sozinha consegue manter deploy simples, monolito frontend e mais barato.

Q: Como pensar server state?

Server state tem staleness, cache, retry, refetch, invalidacao, erro e loading. Nao trate como estado local. Query key e parte do contrato.

Q: Como otimizar render?

Meca primeiro. Se for render, reduza volume, virtualize listas, estabilize props, divida contexto, memoize onde ha custo real e evite recomputar derivado no render. Se for rede ou payload, mude contrato da API.

Q: Como testar frontend senior?

Jest/RTL para comportamento de componente, Cypress/Playwright para fluxos criticos web, Detox para comportamento mobile ou device quando o risco justifica. Teste comportamento, nao implementacao interna.

## Perguntas Para Fazer ao Entrevistador

- O maior gargalo hoje e performance runtime, deploy coordination, state consistency, design-system drift ou CI feedback?
- Micro-frontends ja existem ou estao sendo considerados?
- Como shared packages sao versionados e owned?
- Qual estrategia de server state: TanStack Query, Redux, GraphQL cache, fetch custom ou mistura?
- Em React Native, quais plataformas importam e quais restricoes sao mais duras: startup, memoria, navegacao, offline ou native modules?
- Em Smart TV, como foco e memory leak sao testados?
- O que um senior frontend ou mobile precisa melhorar nos primeiros 90 dias?
