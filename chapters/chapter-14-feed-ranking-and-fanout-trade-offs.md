# Chapter 14 - Feed Ranking and Fanout Trade-offs

## Slice

Como um feed deixa de ser lista cronologica e vira uma decisao de produto sobre inventario, ranking, frescor e custo.


## Study Context

- `Study Order`: `14/14` - `Fase 3 - Runtime e produto em escala`
- `Caso real principal`: [Meta - News Feed Ranking](../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)
- `Area principal`: [01 - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/README.md)
- `Area secundaria`: [02 - Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)
- `Notes principais`: [Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/notes.md), [Dados e Armazenamento](../areas/02-dados-e-armazenamento/notes.md)
- `Lab`: [Lab - Chapter 14](../labs/chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
- `Review card`: [Card 14](../reviews/cards/14-feed-ranking-and-fanout-trade-offs.md)
- `Contraste sugerido`: [Contrast 11 - Fanout-on-Write vs Fanout-on-Read](../decision-contrasts/11-fanout-on-write-vs-fanout-on-read.md)
- `Simulation labs`: [Fanout / Feed Ranking Cost](../simulation-labs/fanout-feed-ranking-cost.md), [Feed Ranking / Guardrails](../simulation-labs/feed-ranking-guardrails.md)
- `Operational playbook`: [Deploy Rollback and Kill Switch](../areas/11-operational-playbooks/playbooks/deploy-rollback-and-kill-switch.md)
- `Bridge lab`: [Design a Feed Ranking Experiment Loop](../areas/14-engineering-case-study-labs/labs/design-a-feed-ranking-experiment-loop.md)

## Historia de Produto

Seu PO nao quer "mostrar posts". Ele quer gente abrindo o app e encontrando algo que valha o tempo dela. A partir daqui, o feed deixa de ser storage com `ORDER BY created_at` e vira uma fronteira onde produto e infraestrutura discutem o tempo inteiro.

## Onde Isso Aparece Antes da Teoria

- timelines sociais, activity feeds, inboxes priorizadas e superficies com muito conteudo competindo pela atencao
- produtos em que relevancia ja pesa mais do que ordem temporal pura
- sistemas com muitos produtores, muitos consumidores e custo real para montar a lista final


## First Principles Design Pass

- `Requirement Less Dumb`: o produto ja sofre com cronologia pura, ou estamos querendo ranking caro antes de provar que ele melhora a experiencia?
- `Delete`: corte fontes de candidato, features e fanout ornamental que nao movem relevancia nem retencao.
- `Simplify`: comece com um inventario candidato enxuto e ranking leve antes de convocar pipeline pesado de ML.
- `Accelerate`: rode experimento curto de qualidade, frescor e latencia para aprender rapido se o ranking ganhou o direito de existir.
- `Automate Last`: treinamento sofisticado, feature pipeline e ajuste automatico entram depois que a heuristica basica ja gera ganho real.

### Fixacao Relampago: Design Pass

- `Pergunta`: qual pergunta vem antes de falar em ranker e feed inteligente?
- `Resposta com as suas palavras`: eu preciso provar que mostrar o mais novo primeiro ja nao entrega bem o objetivo do produto.
- `Resposta ruim que parece boa`: "feed grande sempre termina em ML".
- `Troque por isto`: primeiro eu provo a falha da cronologia e o ganho de relevancia; so depois eu pago o custo do ranking.

## Foco em Entrevistas

- como comparar fanout-on-write, fanout-on-read e modelos hibridos sem virar slogan
- quando ranking e parte do produto, nao perfumaria de ML
- como falar de frescor, inventario candidato, diversidade e custo com julgamento


## A Tensao Real

Cronologia pura parece justa ate o dia em que ela deixa de servir o produto. A Meta descreve um feed que precisa ranquear conteudo para mais de 2 bilhoes de pessoas, com mais de 1.000 posts por usuario por dia, em tempo real, incluindo sinais que mudaram ha minutos ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)). Nesse mundo, "mostrar o mais novo primeiro" deixa de ser simplicidade. Vira desperdicio de atencao.

O problema real nao e so ordenar melhor. E decidir quanto do feed voce prepara antes e quanto voce calcula na hora de abrir. Se tudo for precomputado cedo demais, o feed perde frescor e personalizacao. Se tudo for resolvido no read path, latencia e custo crescem. O feed bom vive no meio desse cabo de guerra.

### Fixacao Relampago 1

- `Pergunta`: por que `ORDER BY created_at` para de bastar em um feed?
- `Resposta com as suas palavras`: porque novidade sozinha nao garante valor; relevancia e frescor comecam a puxar para lados diferentes.
- `Resposta ruim que parece boa`: "ranking e so perfumaria de ML".
- `Troque por isto`: quando o produto depende de atencao bem gasta, ranking vira parte do core do feed.

## Contexto e Constraints do Caso Real

A arquitetura descrita pela Meta deixa isso bem claro. O front-end chama uma camada Web/PHP, que consulta um `feed aggregator`. Esse agregador busca acoes, objetos e summaries nos `feed leaf databases`, depois processa, agrega, ranqueia e devolve as `FeedStories` para renderizacao ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)).

O inventario candidato ja nasce mais complicado do que "posts desde o ultimo login". O artigo diz que o feed reconsidera conteudo fresco nao visto antes por `unread bumping` e tambem pode ressuscitar posts que ganharam conversa relevante por `action bumping` ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)). Isso importa porque o produto nao quer apenas novidade. Quer novidade util.

Depois vem a restricao computacional. A Meta descreve um pipeline em varias passagens: primeiro um modelo leve escolhe aproximadamente 500 candidatos com alta recordacao; depois acontece o scoring principal; por fim entram sinais contextuais, como diversidade de tipo de conteudo ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)). Em outras palavras: nem a Meta tenta aplicar o modelo mais caro em todo o universo de candidatos. Ela faz poda inteligente antes.

## Decisao Tomada

A decisao canonica aqui e separar tres coisas que muita implementacao mistura:

1. como o sistema forma o inventario candidato;
2. onde o sistema ranqueia esse inventario;
3. qual parte do feed precisa ficar fresca ate o momento do read.

Na fonte da Meta, a parte explicita e o ranking on-read via agregador. A traducao para entrevista, que aqui e uma inferencia arquitetural a partir dessa fonte, e a seguinte: fanout serve para ajudar a formar inventario e reduzir trabalho bruto, mas a ordenacao final relevante precisa continuar perto do read path quando sinais de frescor e personalizacao importam.

Isso leva a um desenho hibrido e muito comum em produtos maduros:

- produtores comuns podem empurrar candidatos para uma inbox de feed;
- produtores de alto fanout podem ser buscados no read path para evitar explosao de escrita;
- o agregador junta essas fontes, aplica regras de elegibilidade e so entao ranqueia.

O nome bonito muda de empresa para empresa. O julgamento nao muda: fanout sozinho nao resolve relevancia, e ranking sozinho nao resolve custo.

### Fixacao Relampago 2

- `Pergunta`: o que fanout resolve e o que ele nao resolve?
- `Resposta com as suas palavras`: ele ajuda a formar inventario barato; nao decide sozinho o que merece subir para cada usuario.
- `Resposta ruim que parece boa`: "se eu fizer fanout-on-write para tudo, o feed esta pronto".
- `Troque por isto`: fanout mexe no custo e na latencia; relevancia final ainda nasce perto do read path.

## Rails First

Em Rails, a primeira versao honesta quase nunca precisa de ML pesado. Ela precisa de um inventario claro, uma poda barata e um ranking final simples o bastante para evoluir depois.

```rb
class Feed::BuildTimeline
  PASS0_LIMIT = 500
  FINAL_LIMIT = 50

  def call(viewer:, cursor: nil)
    candidate_ids = pushed_candidate_ids(viewer, cursor) + pulled_high_fanout_ids(viewer)

    candidates = Story
      .where(id: candidate_ids.uniq)
      .includes(:author, :engagement_snapshot)
      .select { |story| eligible?(viewer, story) }

    pass0 = candidates
      .reject(&:blocked_or_hidden?)
      .sort_by { |story| -lightweight_score(viewer, story) }
      .first(PASS0_LIMIT)

    ranked = pass0
      .map { |story| [story, final_score(viewer, story)] }
      .sort_by { |(_, score)| -score }
      .map(&:first)

    diversify(ranked).first(FINAL_LIMIT)
  end

  private

  def pushed_candidate_ids(viewer, cursor)
    FeedInboxEntry
      .where(viewer_id: viewer.id)
      .where("created_at < ?", cursor || Time.current)
      .order(created_at: :desc)
      .limit(2_000)
      .pluck(:story_id)
  end

  def pulled_high_fanout_ids(viewer)
    Story
      .where(author_id: viewer.high_fanout_followee_ids)
      .where("created_at >= ?", 2.days.ago)
      .limit(300)
      .pluck(:id)
  end
end
```

O detalhe importante nao e a formula de score. E o recorte:

- `FeedInboxEntry` suporta fanout-on-write onde ele ainda e barato;
- `pulled_high_fanout_ids` evita jogar celebridade ou grande publisher dentro da mesma estrategia;
- `pass0` existe para nao gastar ranking caro com candidatos demais;
- `diversify` lembra que o melhor feed nem sempre e o de maior score bruto.

## Stack Translation

- `Rails first`: inventario candidato, ranking simples e fanout hibrido ainda perto do app principal.
- `Quando Elixir ensina mais`: quando fanout, coordenacao e fluxos vivos de feed passam a ter mais peso do que a request sincrona.
- `Quando Go ensina mais`: quando agregador, feature fetcher ou infraestrutura quente de fanout e ranking viram a parte cara do sistema.

## Production Mode

### What Breaks First

- rollout de ranking piorando qualidade do feed antes de dar erro tecnico
- fanout ou candidate generation explodindo custo de escrita ou latencia de leitura
- feed tentando ser inteligente demais e perdendo fallback simples

### Signals to Watch

- p95 e p99 do feed
- candidate count por request
- write amplification e queue depth de fanout
- metrica de qualidade: click, dwell, hide, bounce ou equivalente

### Safe Rollout

- shadow ranker antes de ranker valendo resposta real
- cohort pequeno e comparacao com baseline cronologico
- mantenha fallback para feed cronologico ou ranker anterior
- isole produtores de alto fanout antes de mexer no algoritmo inteiro

### Rollback Trigger

- queda rapida de metrica de qualidade do feed
- latencia ou custo subindo alem do budget
- candidate explosion ou backfill de fanout virando incidente

### First 15 Minutes

- volte para o ranker anterior ou para um fallback cronologico aceitavel
- corte a fonte de candidatos mais cara antes de revisar o modelo inteiro
- preserve frescor e latencia minima antes de tentar salvar sofisticacao
- separe regressao de qualidade de regressao de infraestrutura

### Fixacao de Producao

- `Pergunta`: qual incidente mais trai esse chapter?
- `Resposta com as suas palavras`: o feed continua servindo, mas piora a experiencia e ninguem percebe cedo porque so olhou erro tecnico.
- `Resposta ruim que parece boa`: "se nao tem 500, o rollout esta bom".
- `Troque por isto`: em feed, queda de qualidade e latencia ruim tambem sao incidente de producao.

## Por Que Nao Outra Abordagem

Nao "cronologico puro" porque a propria Meta mostra que unseen posts, conversas que reacenderam e preferencias individuais precisam voltar para o inventario; caso contrario, o feed privilegia frequencia de postagem, nao valor para a pessoa ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)).

Nao "fanout-on-write para tudo" porque a ordenacao final perde a chance de usar sinais frescos de engajamento, diversidade e contexto. A fonte nao usa a linguagem classica de fanout, mas a existencia do agregador, do unread bumping e das multiplas passagens mostra que a lista final continua sendo montada perto do consumo, nao congelada no momento da escrita ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)).

Nao "pull everything on read" porque custo e latencia explodem. O mesmo artigo deixa claro que mesmo com infraestrutura massiva o sistema poda candidatos cedo para caber em tempo real ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)).

## Traducao Explicita Para Empresa Menor

Empresa menor nao precisa copiar o News Feed. Precisa copiar a ordem das decisoes.

Se o produto ainda funciona bem com ordem temporal, pare ai. Ranking prematuro costuma virar mais dashboard do que melhoria real.

Mas se relevancia ja importa, a traducao pratica costuma ser:

- fanout-on-write para usuarios comuns, porque e simples e rapido;
- excecao para autores de alto fanout, buscados no read path;
- ranking leve no read com poucos sinais: recencia, relacao, engajamento e talvez diversidade;
- limite duro de candidatos antes do ranking final;
- observabilidade de latencia e de qualidade, nao so de throughput.

Para uma rede menor, um score linear honesto costuma comprar bastante: `0.5 * recency + 0.3 * relationship + 0.2 * engagement`. O passo adulto nao e trocar isso por rede neural cedo demais. E separar inventario de ranking antes que tudo vire um unico SQL impossivel de explicar.

### Fixacao Relampago 3

- `Pergunta`: quando ranking ainda seria exagero?
- `Resposta com as suas palavras`: quando cronologia ja entrega uma experiencia boa e ninguem sabe qual metrica de produto quer melhorar.
- `Resposta ruim que parece boa`: "qualquer timeline madura precisa de score complexo".
- `Troque por isto`: so compre ranking quando ele melhora um objetivo real de produto, nao quando ele parece sofisticado.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- mais relevancia pede mais compute, mais estado e mais tuning;
- feed precomputado demais ganha velocidade e perde frescor;
- feed calculado demais no read ganha frescor e perde previsibilidade de latencia;
- modelos melhores reduzem explainability e aumentam dependencia de metricas;
- excecoes de alto fanout simplificam custo, mas complicam o desenho mental do time.

Sinais de uso errado:

- a equipe fala de ranking, mas nao consegue dizer qual metrica de produto quer melhorar;
- todo produtor entra em fanout-on-write, inclusive contas gigantes que explodem storage e filas;
- tudo e on-read e a latencia cresce a cada nova regra de relevancia;
- o score manda mais do que o senso de produto e o usuario deixa de confiar no feed;
- ninguem consegue explicar por que um item voltou ao topo.

## Fechamento: Julgamento Arquitetural

Feed nao e um problema de lista. E um problema de escolha sob restricao. A Meta mostra isso de forma didatica: primeiro forma inventario, depois calcula previsoes, depois combina sinais em varias passagens e ainda aplica contexto para diversidade ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/)). A traducao arquitetural mais util e esta: use fanout para baratear candidato, use ranking para decidir relevancia e use frescor como limite moral do que pode ser precomputado. Quando o produto pede ordem temporal, nao complique. Quando pede relevancia, pare de fingir que `ORDER BY created_at` e arquitetura.

## Decision Synthesis

### Use When

- o valor do produto depende mais de relevancia do que de cronologia pura
- o numero de produtores e consumidores torna caro montar a timeline ingenuamente
- frescor, personalizacao e diversidade afetam o sucesso da experiencia

### Why This Case Used It

- a Meta precisava ranquear inventario para mais de 2 bilhoes de pessoas em tempo real ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/))
- o agregador separa coleta de candidatos, scoring e renderizacao final ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/))
- unread bumping, action bumping e ranking em varias passagens mostram que frescor e relevancia convivem em tensao constante ([News Feed ranking, powered by machine learning](https://engineering.fb.com/2021/01/26/ml-applications/news-feed-ranking/))

### Main Trade-offs

- mais ranking melhora relevancia, mas aumenta custo e opacidade
- mais fanout reduz latencia de leitura, mas pode explodir escrita e storage
- mais calculo no read melhora frescor, mas pressiona SLA

### Warning Signs

- cronologia ainda basta, mas o time quer ranking por ansiedade
- autores gigantes usam a mesma estrategia de fanout dos usuarios comuns
- o sistema nao separa inventario candidato de ordenacao final

### Decision Checklist

- meu produto precisa mesmo de ranking ou so de boa ordenacao temporal?
- quais produtores podem usar push e quais pedem pull ou modelo hibrido?
- quais sinais precisam estar frescos no momento do read?
- qual metrica de qualidade justificaria o custo adicional do ranking?

## Navigation

- [Prev](./chapter-13-realtime-concurrency-and-workload-isolation.md)
- [Index](./README.md)
