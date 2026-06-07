# Chapter 01 - Relational Scaling and Operational Discipline

## Slice

Como um produto cresce sem transformar o banco relacional no vilao errado.


## Study Context

- `Study Order`: `01/14` - `Fase 1 - Base forte`
- `Caso real principal`: [GitHub - Rails and MySQL at Scale](../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- `Caso real complementar`: [Shopify - Pods and Modular Monolith](../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- `Area principal`: [02 - Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)
- `Area secundaria`: [05 - Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)
- `Notes principais`: [Dados e Armazenamento](../areas/02-dados-e-armazenamento/notes.md), [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/notes.md)
- `Lab`: [Lab - Chapter 01](../labs/chapters/chapter-01-relational-scaling-and-operational-discipline.md)
- `Review card`: [Card 01](../reviews/cards/01-relational-scaling-and-operational-discipline.md)
- `Contraste sugerido`: [Contrast 01 - Read Replica vs Cache-Aside](../decision-contrasts/01-read-replica-vs-cache-aside.md)
- `Simulation labs`: [Cache](../simulation-labs/cache.md), [Sharding / Pod Isolation](../simulation-labs/sharding-pod-isolation.md)
- `Operational playbook`: [Database Migration and Backfill](../areas/11-operational-playbooks/playbooks/database-migration-and-backfill.md)
- `Bridge lab`: [Tune Postgres Indexes and Transactions](../areas/13-backend-principle-labs/labs/tune-postgres-indexes-and-transactions.md)

## Historia de Produto

Seu PO pede duas coisas que parecem inocentes: dashboard mais rapido para contas enterprise e mais mudancas de produto sem medo de deploy. Voce olha para o banco sofrendo e pensa: "eu preciso de outro datastore, ou preciso finalmente operar o meu direito?".

## Onde Isso Aparece Antes da Teoria

- produtos cujo core continua transacional e relacional
- dashboards, listas e contadores quentes que pesam mais na leitura do que na escrita
- times que comecam a sofrer com upgrades, replicas e slow queries antes de sofrer com limite estrutural


## First Principles Design Pass

- `Requirement Less Dumb`: voce precisa de consistencia fresca em todo read, ou so nos fluxos que realmente doem se lerem atrasado?
- `Delete`: corte query analitica, contador pesado e leitura ornamental do caminho da primary antes de culpar o modelo relacional.
- `Simplify`: mantenha um core relacional unico com replica e cache bem escolhidos antes de falar em shard ou datastore novo.
- `Accelerate`: monte um ciclo curto para medir slow query, replica lag e rollback de read path sem drama.
- `Automate Last`: failover, rebalancing e tuning automatico entram depois que o caminho manual ja e previsivel.

### Fixacao Relampago: Design Pass

- `Pergunta`: quando o banco relacional doi, qual pergunta vem antes de "precisamos de outro datastore"?
- `Resposta com as suas palavras`: eu preciso saber se o requisito pede mesmo esse nivel de frescor e escala, ou se eu so estou operando leitura e escrita mal.
- `Resposta ruim que parece boa`: "SQL ficou pequeno para o produto".
- `Troque por isto`: primeiro eu provo que o requisito e real; depois eu vejo se replica, cache e disciplina operacional ja resolvem.

## Foco em Entrevistas

- como defender SQL relacional sem parecer preso ao passado
- quando replica, cache e isolamento entram antes de shard ou NoSQL
- como falar de read-after-write, stale read e upgrade seguro com clareza


## A Tensao Real

Quando o banco comeca a sofrer, a conclusao apressada costuma ser "SQL nao escala". GitHub e Shopify contam uma historia menos confortavel: quase sempre o problema nao e o modelo relacional; e operar esse modelo sem disciplina. O GitHub ainda roda um monolito Rails com quase 2 milhoes de linhas, mais de 1.000 engenheiros colaborando diariamente e deploys ate 20 vezes por dia ([Building GitHub with Ruby and Rails](https://github.blog/engineering/architecture-optimization/building-github-with-ruby-and-rails/)). A Shopify chegou ao limite de "comprar uma maquina maior" em 2015; shardear resolveu throughput, mas piorou a resiliencia porque varias acoes ainda atravessavam shards demais ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale)).

O ponto duro e este: banco relacional aguenta muito desaforo, mas cobra juros altos quando o time trata schema, query plan, replica e upgrade como detalhe operacional.

### Fixacao Relampago 1

- `Pergunta`: quando o banco doi, qual acusacao voce nao faz primeiro?
- `Resposta com as suas palavras`: eu nao culpo SQL de cara. Primeiro eu olho se o time esta operando leitura, escrita, cache e upgrade direito.
- `Resposta ruim que parece boa`: "se esta lento, esta na hora de NoSQL".
- `Troque por isto`: muita dor de banco e falta de disciplina operacional, nao limite estrutural do modelo relacional.

## Contexto e Constraints do Caso Real

No GitHub, a restricao nao era "Rails demais"; era manter um core transacional sob mudanca continua. O time faz upgrades frequentes de framework e, na migracao para MySQL 8.0, operou um ambiente misto de 5.7 e 8.0, rodou as duas versoes lado a lado em CI, subiu replicas gradualmente, preservou rollback em cada etapa e promoveu uma replica 8.0 a primary em vez de fazer cirurgia direta na primary ([Upgrading GitHub.com to MySQL 8.0](https://github.blog/engineering/infrastructure/upgrading-github-com-to-mysql-8-0/)).

Na Shopify, a restricao era dupla: crescimento de dados e blast radius. Depois do sharding inicial, ficou claro que uma shard em pane podia indisponibilizar a mesma acao para a plataforma inteira. A resposta foi isolar shops em pods, garantir que recursos compartilhados falassem com um pod por vez e fazer cada request tocar apenas um pod ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale)). Ao mesmo tempo, o produto continuou no trilho do monolito modular: mais de 2,8 milhoes de linhas de Ruby, modularizacao por componentes e extracao de servicos so quando a vantagem e nitida, porque um sistema distribuido aumenta bastante a complexidade total ([Under Deconstruction: The State of Shopify's Monolith](https://shopify.engineering/shopify-monolith)).

Em ambos os casos, o banco relacional continua no centro porque o negocio depende de integridade entre entidades, mudancas frequentes e operacao previsivel. O truque nao foi escapar do relacional. Foi cercar o relacional com julgamento arquitetural.

## Decisao Tomada

A decisao canonica aqui e manter o core relacional e escalar na seguinte ordem:

1. corrigir o caminho da escrita e das queries antes de inventar outro datastore;
2. usar replicas para ampliar leitura, mas sem mentir sobre consistencia;
3. usar cache-aside para leituras repetitivas e derivadas, nunca como fonte de verdade;
4. isolar tenants ou shards quando o problema vira blast radius, nao antes;
5. transformar upgrades e rollback em rotina, nao em ritual de guerra.

O GitHub exemplifica a disciplina de upgrade e topologia. A Shopify exemplifica o isolamento por pod, o balanceamento de shards em escala de terabytes e a insistencia em adiar servicos quando o monolito ainda e a escolha mais barata em complexidade ([Shard Balancing: Moving Shops Confidently with Zero-Downtime at Terabyte-scale](https://shopify.engineering/mysql-database-shard-balancing-terabyte-scale)).

### Fixacao Relampago 2

- `Pergunta`: em que ordem um sistema relacional bem operado costuma escalar?
- `Resposta com as suas palavras`: primeiro eu arrumo query e write path, depois uso replica e cache com honestidade, e so mais tarde penso em isolamento mais pesado.
- `Resposta ruim que parece boa`: "replica e cache servem para esconder qualquer problema".
- `Troque por isto`: replica e cache ajudam quando a semantica de consistencia esta clara; sem isso, voce so troca lentidao por confusao.

## Rails First

Em Rails, isso normalmente vira um padrao chato e correto: writes na primary, reads elegiveis na replica, pequena janela de stickiness para read-after-write e cache-aside nos endpoints quentes.

```rb
class Accounts::Summary
  STICKY_PRIMARY_WINDOW = 5.seconds

  def initialize(account_id:, tenant:, session:)
    @account_id = account_id
    @tenant = tenant
    @session = session
  end

  def fetch
    Rails.cache.fetch(cache_key, expires_in: 30.seconds) do
      with_role(read_role) do
        @tenant.accounts
          .select(:id, :name, :plan, :updated_at)
          .find(@account_id)
      end
    end
  end

  def update!(attrs)
    with_role(:writing) do
      account = @tenant.accounts.find(@account_id)
      account.update!(attrs)
      @session[:read_from_primary_until] = Time.current.to_i + STICKY_PRIMARY_WINDOW.to_i
      Rails.cache.delete(cache_key)
      account
    end
  end

  private

  def read_role
    sticky_until = @session[:read_from_primary_until].to_i
    sticky_until > Time.current.to_i ? :writing : :reading
  end

  def with_role(role, &block)
    ActiveRecord::Base.connected_to(role: role, &block)
  end

  def cache_key
    ["tenant", @tenant.id, "account", @account_id, "summary", 1]
  end
end
```

O valor do padrao nao esta na elegancia. Esta na honestidade: algumas leituras podem aceitar replica e cache; outras precisam de primary por alguns segundos porque negocio nenhum gosta de "acabei de salvar e sumiu". O snippet completo fica em [Rails Read/Write Split and Cache Aside](../areas/02-dados-e-armazenamento/snippets/rails-read-write-split-and-cache-aside.md).

## Stack Translation

- `Rails first`: `connected_to`, stickiness curta na primary, cache-aside e migrations pequenas com rollback claro.
- `Quando Elixir ensina mais`: quando CDC, read models e workers com muito backpressure passam a importar mais do que o request/response transacional.
- `Quando Go ensina mais`: quando proxy, schema mover, replicacao ou worker de ingestao viram a parte dura da operacao.

## Production Mode

### What Breaks First

- replica lag transformando leitura quente em bug intermitente
- cache stale sobrevivendo mais do que o fluxo de negocio tolera
- migration ou upgrade alterando read path antes de rollback ficar claro

### Signals to Watch

- replica lag p95 e p99
- cache hit ratio junto com taxa de invalidacao e stale complaints
- erro e latencia por query depois de rollout
- lock time, replication delay e migration duration

### Safe Rollout

- canary de leitura em replica por endpoint e por tenant
- feature flag para stickiness na primary
- migration pequena, reversivel e com etapa de observacao
- rollout de cache novo sem apagar o caminho antigo de uma vez

### Rollback Trigger

- read-after-write quebrando no fluxo visivel
- crescimento rapido de stale read ou miss storm
- migration pressionando lock, replica ou latencia alem do budget

### First 15 Minutes

- mova reads sensiveis de volta para a primary
- desligue a cache key nova se a invalidacao ficou errada
- pause a migration ou segure o rollout antes de tentar tunar query no escuro
- compare metrica nova contra baseline por endpoint

### Fixacao de Producao

- `Pergunta`: o que voce olha primeiro quando "o banco ficou estranho" depois de rollout?
- `Resposta com as suas palavras`: eu separo se a dor veio de replica, cache ou migration antes de culpar o banco inteiro.
- `Resposta ruim que parece boa`: "abre o slow query log e vai otimizando tudo".
- `Troque por isto`: senior primeiro identifica qual camada quebrou o contrato de leitura ou escrita.

## Por Que Nao Outra Abordagem

Nao "microservicos primeiro" porque isso troca um problema de dados por um problema de coordenacao. A propria Shopify diz que separa funcionalidade em servicos so por bons motivos, como um fluxo read-only de throughput muito alto ou um boundary de seguranca forte; caso contrario, a complexidade sobe mais que o beneficio ([Under Deconstruction: The State of Shopify's Monolith](https://shopify.engineering/shopify-monolith)).

Nao "escala vertical infinita" porque esse filme acabou cedo para a Shopify. Em 2015, comprar um banco maior deixou de ser opcao e o trabalho de verdade passou a ser isolamento, roteamento e movimentacao segura de carga ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale)).

Nao "upgrade direto na primary" porque o GitHub mostrou o caminho menos heroico: subir replica, observar, preservar rollback, mudar topologia e promover com failover gracioso ([Upgrading GitHub.com to MySQL 8.0](https://github.blog/engineering/infrastructure/upgrading-github-com-to-mysql-8-0/)).

## Traducao Explicita Para Empresa Menor

Empresa menor nao deve copiar pods, Ghostferry e fleets de replicas. Deve copiar a ordem mental das decisoes.

Se voce toca um SaaS B2B com um banco principal, tres ou quatro endpoints quentes e alguns tenants desiguais, a traducao pratica e esta:

- mantenha o dado transacional principal em SQL relacional;
- resolva indice, `EXPLAIN`, N+1 e payload excessivo antes de abrir outro banco;
- use uma replica so para dashboards, exports ou listas quentes que toleram pequena defasagem;
- aplique cache-aside em summaries e contadores que sao lidos muito mais do que escritos;
- faca migrations pequenas, reversiveis e com observabilidade desde cedo.

O cenario menor equivalente esta em [Smaller SaaS Read/Write and Cache](../areas/02-dados-e-armazenamento/examples/smaller-saas-read-write-and-cache.md). Ele nao tem drama de "mover shop entre shards de terabytes", mas tem o mesmo julgamento: onde a consistencia manda, voce nao terceiriza para replica nem para cache.

### Fixacao Relampago 3

- `Pergunta`: quando uma leitura deve continuar na primary?
- `Resposta com as suas palavras`: quando o usuario acabou de escrever e espera ver o efeito agora, sem atraso esquisito.
- `Resposta ruim que parece boa`: "se existe replica, toda leitura deve ir para ela".
- `Troque por isto`: replica e opcao de consistencia mais fraca, nao default moral de toda query.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- replicas introduzem stale reads e exigem estrategia clara para read-after-write;
- cache reduz carga, mas cobra invalidacao, namespace e observabilidade;
- isolamento por shard ou pod reduz blast radius, mas encarece analytics e fluxos cross-tenant;
- upgrades seguros consomem calendario e pedem automacao, CI e rollback de verdade.

Sinais de uso errado:

- voce quer "colocar Redis" antes de olhar slow queries e `EXPLAIN`;
- voce manda leitura imediatamente apos escrita para replica e depois chama o bug de "intermitente";
- voce fala em shard antes de provar que existe tenant quente ou blast radius relevante;
- cada upgrade de banco ou framework parece uma aposta de cassino, nao uma rotina previsivel.

## Fechamento: Julgamento Arquitetural

O aprendizado util deste capitulo nao e "sempre use SQL". E mais exigente do que isso: use relacional enquanto ele continua comprando clareza para o core do negocio e pague o preco correto em disciplina operacional. GitHub e Shopify escalaram porque trataram upgrades, replicas, isolamento e observabilidade como parte da arquitetura. Quando o time faz isso, SQL deixa de ser gargalo ideologico e volta a ser o que deveria ser: um mecanismo poderoso de coordenacao.

## Decision Synthesis

### Use When

- o core do produto depende de relacoes fortes, transacoes e integridade entre entidades
- o principal gargalo ainda esta em leitura quente, query ruim ou operacao descuidada, nao em limite estrutural do modelo
- voce consegue distinguir com clareza o que precisa de consistencia imediata e o que tolera replica ou cache

### Why This Case Used It

- o GitHub precisava manter um produto central em mudanca continua sem transformar upgrade em evento traumatico
- a Shopify precisava escalar throughput e reduzir blast radius sem pagar cedo demais o custo de um sistema distribuido inteiro
- nos dois casos, o relacional ainda comprava mais clareza de negocio do que dor estrutural

### Main Trade-offs

- replica melhora leitura, mas introduz stale read e roteamento mais cuidadoso
- cache reduz carga, mas cobra invalidacao, observabilidade e disciplina de key space
- isolamento por tenant ou pod reduz blast radius, mas complica analytics e operacao

### Warning Signs

- voce quer trocar de banco antes de abrir `EXPLAIN`
- read-after-write esta indo para replica por conveniencia
- shard ou pod entraram na conversa sem tenant ruidoso, sem blast radius real e sem metrica que justifique

### Decision Checklist

- meu gargalo e realmente o relacional ou meu uso dele?
- eu sei quais endpoints aceitam lag e quais nao aceitam?
- eu tenho plano simples de rollback, upgrade e observabilidade?
- estou adicionando complexidade topologica por necessidade ou por ansiedade?

## Navigation

- [Index](./README.md)
- [Next](./chapter-02-pod-isolation-and-tenant-routing.md)
