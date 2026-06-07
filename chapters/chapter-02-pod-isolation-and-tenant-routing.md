# Chapter 02 - Pod Isolation and Tenant Routing

## Slice

Como um monolito em escala isola tenants e roteia requests para o pod ou shard certo.


## Study Context

- `Study Order`: `02/14` - `Fase 1 - Base forte`
- `Caso real principal`: [Shopify - Pods and Modular Monolith](../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- `Caso real complementar`: [GitHub - Rails and MySQL at Scale](../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)
- `Area principal`: [05 - Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)
- `Area secundaria`: [02 - Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)
- `Notes principais`: [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/notes.md), [Dados e Armazenamento](../areas/02-dados-e-armazenamento/notes.md)
- `Lab`: [Lab - Chapter 02](../labs/chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- `Review card`: [Card 02](../reviews/cards/02-pod-isolation-and-tenant-routing.md)
- `Contraste sugerido`: [Contrast 02 - Pod Isolation vs Microservices](../decision-contrasts/02-pod-isolation-vs-microservices.md)
- `Simulation labs`: [Sharding / Pod Isolation](../simulation-labs/sharding-pod-isolation.md), [Noisy Neighbor / Workload Isolation](../simulation-labs/noisy-neighbor-workload-isolation.md)
- `Operational playbook`: [Incident Severity and Triage](../areas/11-operational-playbooks/playbooks/incident-severity-and-triage.md)
- `Bridge lab`: [Write a Multi-Tenant ADR](../areas/14-engineering-case-study-labs/labs/write-a-multi-tenant-adr.md)

## Historia de Produto

Seu PO chega com uma noticia meio amarga: um cliente enterprise cresceu tanto que qualquer incidente ou carga torta dele comeca a machucar clientes menores. A pergunta nao e "viramos microservicos agora?". A pergunta e "como isolar esse tenant sem desmontar o produto inteiro?".

## Onde Isso Aparece Antes da Teoria

- SaaS multi-tenant com poucos clientes muito maiores que os outros
- marketplaces em que um grupo de sellers ou merchants concentra muito trafego
- produtos cujo core ainda cabe em monolito, mas cujo dado ja pede isolamento


## First Principles Design Pass

- `Requirement Less Dumb`: todo tenant precisa de isolamento forte agora, ou o problema real mora em poucos tenants quentes e em blast radius?
- `Delete`: remova joins, jobs e fluxos que atravessam pods sem necessidade antes de desenhar topologia mais cara.
- `Simplify`: um monolito modular com request tocando um pod so e mais forte que varios servicos mal recortados.
- `Accelerate`: torne mudanca de tenant, auditoria de roteamento e rollback de pod move operacoes rapidas de ensaio.
- `Automate Last`: balanceamento automatico de tenants so entra quando o move manual ja e seguro e observavel.

### Fixacao Relampago: Design Pass

- `Pergunta`: qual pergunta vem antes de partir para microservicos por causa de tenant barulhento?
- `Resposta com as suas palavras`: eu preciso descobrir se o problema e isolamento de poucos tenants ou se o dominio inteiro realmente pede outra fronteira.
- `Resposta ruim que parece boa`: "multitenancy em escala sempre vira microservico".
- `Troque por isto`: primeiro eu reduzo blast radius e atravessamento entre tenants; servico separado so entra quando o corte do dominio se paga.

## Foco em Entrevistas

- quando particionar por tenant e melhor do que extrair servicos
- como request routing encontra o pod certo
- como reduzir blast radius sem explodir a complexidade operacional


## A Tensao Real

O erro classico aqui e confundir throughput com isolamento. No comeco, shardear parece resolver tudo: mais capacidade, mais banco, mais folego. Shopify descobriu o custo escondido em 2015. Quando ficou inviavel continuar comprando um banco maior, o time shardou para crescer horizontalmente, mas passou a carregar codigo que iterava por shards inteiros; se uma shard caia, a mesma acao podia ficar indisponivel para a plataforma toda ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale/)).

Esse e o tipo de problema que nao pede microservicos por reflexo. Pede uma pergunta mais fria: "qual e a menor fronteira que me deixa limitar blast radius sem desmontar o produto?". A resposta da Shopify foi tenant isolation com podding. O contraexemplo util e o GitHub: um monolito Rails com quase 2 milhoes de linhas, mais de 1.000 engenheiros colaborando diariamente e deploys ate 20 vezes por dia ainda funciona porque o time so compra mais topologia quando ela resolve um risco real, nao um desconforto teorico ([Building GitHub with Ruby and Rails](https://github.blog/engineering/architecture-optimization/building-github-with-ruby-and-rails/)).

### Fixacao Relampago 1

- `Pergunta`: se um tenant grande machuca os outros, qual problema voce deve enxergar primeiro?
- `Resposta com as suas palavras`: esta faltando cerca. O barulho de um cliente ainda atravessa o sistema inteiro.
- `Resposta ruim que parece boa`: "o banco esta pequeno, entao sharding resolve".
- `Troque por isto`: capacidade pode ate doer, mas o primeiro problema aqui e blast radius sem fronteira operacional.

## Contexto e Constraints do Caso Real

Na Shopify, o constraint nao era so "temos muitos shops". Era "cada request e cada job precisam depender de um unico conjunto de datastores". Pods viraram esse pacote: um conjunto de shops vivendo em datastores totalmente isolados, com workers, app servers e load balancers compartilhados falando com apenas um pod por vez ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale/)). O request lifecycle tambem mudou: um componente nos load balancers chamado Sorting Hat aplica regras para mapear cada request a um pod, adiciona um header e encaminha o trafego ao lugar certo; os app servers usam esse header para conectar no datastore correto ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale/)).

So que pod sem mobilidade vira jaula. Quando a distribuicao de carga entorta, voce precisa mover shops entre pods sem parar a loja. No trabalho de shard balancing, a Shopify descreve o Ghostferry copiando dados por batches, usando `SELECT ... FOR UPDATE` para manter atomicidade e tailing do binlog para reaplicar mudancas ate o cutover ficar a segundos do tempo real ([Shard Balancing: Moving Shops Confidently with Zero-Downtime at Terabyte-scale](https://shopify.engineering/blogs/engineering/mysql-database-shard-balancing-terabyte-scale)). Em paralelo, a empresa continuou investindo em modularizacao do monolito, com component boundaries internos e Packwerk, justamente para nao trocar um problema de dados por caos de acoplamento distribuido ([Under Deconstruction: The State of Shopify's Monolith](https://shopify.engineering/blogs/engineering/shopify-monolith)).

## Decisao Tomada

A decisao canonica aqui e dividir por tenant forte, mas manter a aplicacao como um monolito coerente:

1. cada tenant relevante ganha uma identidade de roteamento deterministica;
2. cada request e cada job carregam essa identidade desde a borda;
3. todo acesso a dados daquela unidade de trabalho fica preso a um unico pod;
4. a plataforma investe cedo em mover tenant entre pods e em failover por pod;
5. servicos so saem do monolito quando ensinam algo que o boundary por pod nao resolve.

O detalhe importante e que "pod" nao e um hash aleatorio. E uma fronteira operacional. Serve para capacity planning, disaster recovery e limitacao de blast radius ao mesmo tempo.

### Fixacao Relampago 2

- `Pergunta`: qual dado precisa viajar junto em toda request e em todo job?
- `Resposta com as suas palavras`: a identidade do tenant e do pod. Sem isso, o trabalho passeia entre bancos.
- `Resposta ruim que parece boa`: "eu descubro o shard no meio da request quando precisar".
- `Troque por isto`: o pod precisa ser resolvido antes do acesso a dados, nao no meio do caminho.

## Rails First

Em Rails, a traducao madura costuma ser menos glamourosa que a da Shopify e suficientemente boa: um diretorio global pequeno para descobrir o `pod_key`, `Current` para carregar contexto do tenant, e `connected_to` ou shards nomeados para prender a request inteira ao datastore certo.

```rb
class Current < ActiveSupport::CurrentAttributes
  attribute :tenant_id, :pod_key
end

class PodDirectory
  def self.resolve!(host:)
    tenant = TenantDirectory.find_by!(canonical_host: host)
    Current.tenant_id = tenant.id
    Current.pod_key = tenant.pod_key
  end
end

class PodRouter
  def self.with_request_pod(request_method:, &block)
    role = request_method == "GET" ? :reading : :writing
    ApplicationRecord.connected_to(role: role, shard: Current.pod_key, &block)
  end
end

class ApplicationController < ActionController::Base
  around_action :route_to_pod

  private

  def route_to_pod
    PodDirectory.resolve!(host: request.host)
    PodRouter.with_request_pod(request_method: request.request_method) { yield }
  ensure
    Current.reset
  end
end
```

Isso nao replica o Sorting Hat nem o Pod Mover da Shopify. Replica a ideia certa: resolver o pod antes de tocar dado e impedir que a request fique fazendo turismo entre bancos. Para jobs, o padrao precisa ser o mesmo: `pod_key` no payload e conexao aberta explicitamente naquele pod.

## Stack Translation

- `Rails first`: diretorio de tenant, `Current`, shards e jobs carregando `pod_key` dentro do monolito.
- `Quando Elixir ensina mais`: quando isolamento por tenant aparece em muitos fluxos assincronos e supervisao por workload comeca a importar mais do que controller e CRUD.
- `Quando Go ensina mais`: quando roteamento fino, ferramentas de migracao ou control plane de pods viram problema proprio de infra.

## Production Mode

### What Breaks First

- drift entre `tenant_directory` e o pod real onde a request deveria cair
- jobs ou queries cross-pod escapando para o caminho critico
- movimentacao de tenant ficando no meio do caminho e deixando reads ou writes no pod errado

### Signals to Watch

- taxa de erro por `pod_key` e por tenant
- skew de carga entre pods
- contagem de requests e jobs que tentam tocar mais de um pod
- lag ou duracao de cutover em tenant moves

### Safe Rollout

- comece com um tenant pequeno ou interno
- rode shadow checks do roteamento antes de mudar o destino real
- mantenha kill switch por tenant ou por pod
- congele tenant moves durante mudanca de routing

### Rollback Trigger

- writes chegando ao pod errado
- erro concentrado no tenant recem-movido
- crescimento de fluxos cross-pod no request path

### First 15 Minutes

- pause novos tenant moves
- pinne o tenant afetado ao ultimo pod conhecido como bom
- confira drift entre diretorio, app e banco
- desligue o caminho novo de routing antes de investigar otimizacao

### Fixacao de Producao

- `Pergunta`: qual e o primeiro medo operacional aqui?
- `Resposta com as suas palavras`: mandar request certa para o lugar errado e espalhar dano sem perceber na hora.
- `Resposta ruim que parece boa`: "se o pod existe, o problema agora e so throughput".
- `Troque por isto`: podding falha primeiro em contexto, roteamento e mobilidade, nao em glamour de topologia.

## Por Que Nao Outra Abordagem

Nao "microservicos primeiro", porque o problema original e isolamento de tenant, nao distribuicao funcional. Se o seu request continua precisando tocar o mesmo conjunto de dados do mesmo tenant, quebrar em servicos cedo so adiciona RPC, tracing e coordenacao.

Nao "so shardear o banco" porque foi exatamente essa meia-solucao que doeu na Shopify. Shard sem boundary de runtime deixa request e job atravessarem shards demais, entao a falha volta a se espalhar ([A Pods Architecture To Allow Shopify To Scale](https://shopify.engineering/a-pods-architecture-to-allow-shopify-to-scale/)).

Nao "deixa a movimentacao para depois" porque tenancy isolada sem rebalancing seguro envelhece mal. O Ghostferry existe como prova de que mover tenants em producao vira parte da arquitetura, nao uma tarefa rara de DBA ([Shard Balancing: Moving Shops Confidently with Zero-Downtime at Terabyte-scale](https://shopify.engineering/blogs/engineering/mysql-database-shard-balancing-terabyte-scale)).

## Traducao Explicita Para Empresa Menor

Empresa menor nao precisa de Pods com data center ativo e recovery por unidade. Precisa copiar a disciplina de fronteira.

Para um SaaS B2B menor, a traducao pratica costuma ser:

- uma tabela global minima `tenant_directories` dizendo qual tenant vive em qual `pod_key`;
- um ou dois pods logicos, nao dez;
- jobs assincronos sempre carregando `tenant_id` e `pod_key`;
- relatorios cross-tenant indo para replica analitica ou export batch, nunca para o request path;
- plano de mover um tenant quente para outro pod sem reescrever o app.

Se um dia voce extrair um roteador em Go ou um worker especializado em Elixir, a licao nao muda. O ponto nao e a linguagem. E a determinacao do pod e a proibicao de trabalho cross-pod no caminho critico.

### Fixacao Relampago 3

- `Pergunta`: quando pods sao uma boa ideia para empresa menor?
- `Resposta com as suas palavras`: quando um tenant ja virou fonte real de dano e eu preciso isolar sem explodir o dominio em servicos.
- `Resposta ruim que parece boa`: "sempre que eu quiser parecer enterprise".
- `Troque por isto`: pods entram quando isolamento paga o custo operacional; antes disso, viram teatro arquitetural.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- podding reduz blast radius, mas complica analytics, faturamento agregado e ferramentas internas;
- diretorio global de tenants vira dependencia critica e precisa ser pequeno, estavel e observavel;
- rebalancing e failover por pod pedem automacao de verdade;
- bugs de contexto ficam piores: um job sem `pod_key` pode operar no lugar errado sem explodir na hora.

Sinais de uso errado:

- voce esta introduzindo pods sem noisy neighbor, tenant quente ou requisito claro de isolamento;
- requests ou jobs fazem query cross-pod "so desta vez";
- dados globais crescem ate virarem um segundo monolito de banco fora dos pods;
- a equipe fala em pods, mas nao consegue explicar como mover um tenant sem downtime grande.

## Fechamento: Julgamento Arquitetural

Pod isolation e um bom julgamento quando tenant ja virou fronteira operacional antes de virar fronteira de negocio em servicos separados. Shopify mostra o motivo: shard sem runtime isolation deixa o produto exposto a incidentes desnecessarios. GitHub mostra o freio: monolito bem operado continua excelente enquanto o problema ainda e disciplina, nao blast radius. O trabalho senior aqui e saber diferenciar uma coisa da outra. Quando o tenant ruidoso comeca a machucar todos os outros, podding deixa de ser exagero e vira higiene arquitetural.

## Decision Synthesis

### Use When

- o sistema e multi-tenant e alguns tenants crescem mais que outros
- voce precisa reduzir blast radius sem quebrar o produto em muitos servicos
- o dominio ainda cabe bem em monolito, mas os dados ja pedem isolamento

### Why This Case Used It

- a Shopify precisava isolar shops e manter o monolito produtivo em escala
- o roteamento por pod permitiu crescer, mover carga e limitar falhas locais
- isso resolveu um problema de dados e operacao sem pagar o custo imediato de microservicos

### Main Trade-offs

- roteamento e movimentacao de tenants adicionam complexidade operacional
- consultas cross-pod ficam mais caras ou mais limitadas
- o app continua monolitico, entao nem todo gargalo desaparece

### Warning Signs

- voce ainda nao tem problema real de isolamento ou noisy neighbor
- tenants nao sao uma fronteira forte do dominio
- o sistema e pequeno e o ganho de isolamento nao paga a operacao extra

### Decision Checklist

- eu consigo escolher o pod certo de forma deterministica?
- eu consigo mover tenants sem downtime grande?
- eu sei quais queries quebram quando os dados ficam isolados?
- eu tenho um motivo melhor que "microservicos estao na moda"?

## Navigation

- [Prev](./chapter-01-relational-scaling-and-operational-discipline.md)
- [Index](./README.md)
- [Next](./chapter-03-idempotent-writes-under-ambiguous-failure.md)
