# Chapter 05 - Durable Workflows, Retries and Compensation

## Slice

Como um fluxo longo deixa de caber em jobs encadeados e passa a precisar de estado duravel, timers persistentes e compensation nomeada.


## Study Context

- `Study Order`: `05/14` - `Fase 1 - Base forte`
- `Caso real principal`: [Uber - Cadence Workflows](../real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- `Area principal`: [05 - Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)
- `Area secundaria`: [03 - Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)
- `Notes principais`: [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/notes.md), [Filas e Consistencia](../areas/03-filas-e-consistencia/notes.md)
- `Lab`: [Lab - Chapter 05](../labs/chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- `Review card`: [Card 05](../reviews/cards/05-durable-workflows-retries-and-compensation.md)
- `Contraste sugerido`: [Contrast 07 - Durable Workflow vs Chained Jobs](../decision-contrasts/07-durable-workflow-vs-chained-jobs.md)

## Historia de Produto

Seu PO descreve um fluxo aparentemente inocente: cobrar, esperar aprovacao externa, emitir documento, disparar fulfillment, talvez reembolsar se a ultima etapa falhar. No quadro branco parece uma sequencia de jobs. Em producao, algumas etapas duram minutos, outras horas, e o dia ruim chega quando metade do processo andou, a outra metade falhou e ninguem sabe onde retomar sem duplicar efeito.

## Onde Isso Aparece Antes da Teoria

- onboarding ou fulfillment que atravessa varios sistemas externos
- processos com esperas longas, sinais assincronos ou aprovacoes humanas
- fluxos em que cada etapa pede retry, timeout e SLA diferentes


## First Principles Design Pass

- `Requirement Less Dumb`: esse fluxo precisa manter estado e decidir proximo passo por horas ou dias, ou e so uma sequencia curta de jobs?
- `Delete`: corte passos sem efeito proprio, retries redundantes e compensacoes que so existem porque o fluxo ficou espalhado.
- `Simplify`: uma maquina de estados ou coordenador explicito costuma vir antes de engine dedicada de workflow.
- `Accelerate`: escolha um caminho de negocio e treine timeout, retry, pausa e compensacao nele antes de generalizar.
- `Automate Last`: auto-retry e auto-recovery entram depois que a equipe entende quando pausar, reexecutar ou compensar manualmente.

### Fixacao Relampago: Design Pass

- `Pergunta`: quando um workflow duravel comeca a merecer o custo dele?
- `Resposta com as suas palavras`: quando o fluxo tem muitos passos assincronos, janelas longas e compensacao real; nao quando eu so empilhei alguns jobs.
- `Resposta ruim que parece boa`: "tres jobs em sequencia ja pedem engine de workflow".
- `Troque por isto`: primeiro eu provo a necessidade de estado duravel e compensacao; so depois subo a ferramenta.

## Foco em Entrevistas

- quando uma fila simples vira o lugar errado para carregar estado de processo
- como diferenciar retry de atividade, timeout de workflow e compensation de negocio
- como explicar por que um workflow engine remove complexidade mesmo adicionando infraestrutura


## A Tensao Real

Fila simples e excelente para trabalho curto, idempotente e com fronteira clara. Ela comeca a quebrar conceitualmente quando o sistema precisa lembrar onde parou, esperar um sinal externo por horas, tratar timeout de um jeito em um passo e de outro jeito no seguinte, e ainda preservar uma trilha de retomada humana.

Uber chegou exatamente nesse tipo de problema. Na descricao de Cadence 1.0, a empresa apresenta a plataforma como um engine para construir e gerenciar servicos com estado em escala, usado por mais de mil servicos internos e desenhado para remover falhas comuns, capacidade e overhead operacional do codigo de negocio ([Announcing Cadence 1.0](https://www.uber.com/nl/en/blog/announcing-cadence/)). O ponto duro e este: quando o fluxo e importante o bastante, "deixa um worker tentar de novo" deixa de ser estrategia e vira supersticao.

### Fixacao Relampago 1

- `Pergunta`: quando uma sequencia de jobs vira workflow de verdade?
- `Resposta com as suas palavras`: quando estado, retry e retomada precisam sobreviver a crash e atravessar mais de uma etapa sensivel.
- `Resposta ruim que parece boa`: "basta encadear mais `perform_later`".
- `Troque por isto`: job encadeado cobre fluxo curto; workflow duravel aparece quando a orquestracao vira parte do problema.

## Contexto e Constraints do Caso Real

Os posts da Uber deixam claro que o problema nao era apenas "rodar muitos jobs". Era operar muitos workflows concorrentes, de muitos times, com semanticas diferentes e impacto desigual no cluster. No texto sobre multi-tenant task processing, a Uber diz que Cadence ajuda centenas de times a rodar aplicacoes fault-tolerant e long-running, com milhoes de execucoes concorrentes; e que cargas explosivas de um cliente podiam atrasar workflows interativos de outros e ate sobrecarregar o banco a jusante ([Cadence Multi-Tenant Task Processing](https://www.uber.com/gb/en/blog/cadence-multi-tenant-task-processing/)).

Tambem aparece um detalhe tecnico essencial para entender workflow duravel: em Cadence, atividades assincronas como timers, signals e activity tasks sao geradas e commitadas atomicamente junto com a transicao de estado do workflow ([Cadence Multi-Tenant Task Processing](https://www.uber.com/gb/en/blog/cadence-multi-tenant-task-processing/)). Isso e o oposto de uma colagem de jobs onde voce atualiza estado em um lugar, agenda retry em outro e torce para os dois continuarem coerentes depois de um crash.

Do lado operacional, a Uber precisou introduzir isolamento serio entre tenants. O mesmo post relata que o reprojeto do task processing reduziu as worker goroutines por host de 16 mil para 100 enquanto mantinha a mesma carga, e que testes com 3 milhoes de timers disparando em 10 minutos precisaram ser espalhados ao longo de cerca de 1,6 hora para preservar latencia de outros workloads ([Cadence Multi-Tenant Task Processing](https://www.uber.com/gb/en/blog/cadence-multi-tenant-task-processing/)). Isso ensina duas coisas:

- timer nao e adorno, e parte do modelo;
- sem isolamento, workflow engine vira vitima do proprio sucesso.

## Decisao Tomada

A decisao canonica aqui e promover o processo a entidade de primeira classe:

1. workflow tem identidade, estado, historico e ponto de retomada proprios;
2. retries e timers pertencem a etapas especificas, nao ao worker inteiro;
3. atividades externas continuam idempotentes, mas o encadeamento delas vive em estado duravel;
4. compensation fica nomeada no fluxo, nao enterrada em scripts de limpeza;
5. operacao do engine inclui capacidade, backlog, isolamento e observabilidade por tenant ou por tipo de workflow.

Os textos da Uber enfatizam retries, failover, resets e controle de capacidade como responsabilidades nativas do engine ([Announcing Cadence 1.0](https://www.uber.com/nl/en/blog/announcing-cadence/)). A traducao arquitetural importante vem daqui: se o engine automatiza o que e comum, a compensation continua sendo a parte que o negocio precisa explicitar. Essa ultima frase e inferencia nossa a partir dos casos. Os posts focam mais em durabilidade, task processing e isolamento do que em nomear compensacoes, mas isso reforca a fronteira correta: retries sao infraestrutura; desfazer efeito de negocio e projeto de dominio.

### Fixacao Relampago 2

- `Pergunta`: qual passo costuma ganhar compensation primeiro?
- `Resposta com as suas palavras`: o primeiro efeito externo irreversivel ou caro de desfazer no grito.
- `Resposta ruim que parece boa`: "eu compenso tudo no final se der ruim".
- `Troque por isto`: compensation boa nasce junto com o passo que pode deixar rastro fora do seu processo.

## Rails First

Em Rails, a menor versao honesta desse problema costuma ser uma tabela de `workflow_executions` com `current_step`, `state`, `attempts`, `next_run_at` e referencias idempotentes para cada atividade. Nao e Cadence. E um degrau antes de Cadence, mas ja com a forma mental correta.

```rb
class ProvisioningWorkflowRunner
  def call!(execution)
    case execution.current_step
    when "charge_customer"
      Payments.capture!(
        payment_ref: execution.payment_ref,
        idempotency_key: "#{execution.id}:charge"
      )
      execution.advance_to!("reserve_vendor")

    when "reserve_vendor"
      Vendors.reserve!(
        request_id: execution.vendor_request_id,
        account_id: execution.account_id
      )
      execution.advance_to!("issue_document")

    when "issue_document"
      Documents.issue!(account_id: execution.account_id)
      execution.complete!
    end
  rescue Vendors::Timeout
    execution.retry_later!(
      step: execution.current_step,
      run_at: 15.minutes.from_now
    )
  rescue Vendors::Rejected
    compensate_charge!(execution) if execution.completed_step?("charge_customer")
    execution.fail!("vendor_rejected")
  end

  private

  def compensate_charge!(execution)
    Payments.refund!(
      payment_ref: execution.payment_ref,
      idempotency_key: "#{execution.id}:refund"
    )
  end
end
```

O valor do exemplo nao esta no Ruby em si. Esta nas promessas:

- o fluxo sabe em que passo esta;
- o retry volta para o passo certo, com timer duravel;
- a compensation tem nome, gatilho e referencia idempotente;
- o operador consegue inspecionar uma execucao sem abrir cinco filas e tres dashboards.

Quando isso cresce para dezenas de tipos de workflow, waits de dias, versionamento de execucoes em voo e alto volume concorrente, workflow engine de verdade deixa de ser luxo e vira simplificacao.

## Stack Translation

- `Rails first`: tabela de execucao no banco, jobs retomaveis e compensation explicita para o primeiro efeito externo serio.
- `Quando Elixir ensina mais`: quando timers, supervisao e estado resumivel por fluxo ensinam mais do que simplesmente encadear jobs.
- `Quando Go ensina mais`: quando workers de atividade, pollers e runtime de workflow viram a fronteira operacional principal.

## Production Mode

### What Breaks First

- workflows presos entre steps por timeout mal calibrado
- storm de retry abrindo mais dano do que a falha original
- compensation falhando e deixando estado externo torto

### Signals to Watch

- quantidade de workflows `running` ou `waiting` acima do normal
- idade do step atual por tipo de atividade
- timeout rate, retry rate e compensation failure rate
- backlog por activity queue

### Safe Rollout

- publique versao nova do workflow com slice pequeno e observavel
- separe starter, activity e compensation com pause control
- mantenha timeouts conservadores no primeiro rollout
- prefira adicionar visibilidade antes de adicionar mais automacao

### Rollback Trigger

- stuck workflows crescendo sem caminho claro de resume
- compensation falhando num efeito externo caro
- retry avalanche piorando a dependencia externa

### First 15 Minutes

- pause novos starters
- segure a activity ou versao que comecou a falhar
- reduza retry automatico antes de pressionar de novo a dependencia
- liste quais execucoes precisam de intervencao humana e quais podem retomar sozinhas

### Fixacao de Producao

- `Pergunta`: qual reflexo piora um workflow quebrado?
- `Resposta com as suas palavras`: deixar retry correr solto e transformar uma falha local em tempestade.
- `Resposta ruim que parece boa`: "se travou, aumenta retry e timeout para passar".
- `Troque por isto`: senior primeiro contem, isola a versao ruim e protege os efeitos externos antes de tentar otimizar o fluxo.

## Por Que Nao Outra Abordagem

Nao "encadear jobs e pronto" porque cadeia de jobs nao te da, por si so, historico coerente, timers duraveis por etapa, reset de execucao nem visibilidade decente de onde o fluxo travou.

Nao "state machine em memoria ou Redis efemero" porque o problema aqui e justamente sobreviver a crash, rede ruim, restart e deploy no meio do processo.

Nao "coreografia por eventos para tudo" quando ninguem e dono do fluxo inteiro. Em processos longos, a ausencia de orquestrador costuma produzir o pior dos mundos: varios servicos reagem, mas nenhum responde pela jornada completa, pelos timeouts e pela compensation.

Nao "cron de limpeza depois" porque cleanup posterior nao e compensation. Compensation faz parte do contrato do fluxo desde o desenho, especialmente quando ja houve efeito externo irreversivel ou caro.

## Traducao Explicita Para Empresa Menor

Empresa menor normalmente nao precisa instalar Cadence ou Temporal na primeira semana. Mas tambem nao deve fingir que um fluxo multi-passo com espera externa cabe confortavelmente em Sidekiq encadeado para sempre.

A traducao pratica costuma ser esta:

- comece com uma tabela de execucao de workflow no banco principal;
- modele `current_step`, `state`, `next_run_at` e referencias idempotentes por atividade;
- defina timeout e politica de retry por etapa, nao por fluxo inteiro;
- defina pelo menos uma compensation explicita para o primeiro efeito externo irreversivel;
- exponha uma visao operacional minima: quantos `running`, quantos `waiting`, quantos `failed`.

Se o time passa a conviver com timers longos, versionamento de workflows em voo, muitos tipos de processo e muitos operadores humanos, o proximo passo natural e um engine especializado. O importante e nao pular direto do "job simples" para "workflow engine" sem antes aprender qual estado precisa sobreviver.

### Fixacao Relampago 3

- `Pergunta`: o que workflow duravel compra que retry simples nao compra?
- `Resposta com as suas palavras`: memoria do caminho. O sistema sabe onde parou e de onde retoma sem adivinhacao.
- `Resposta ruim que parece boa`: "ele so repete steps automaticamente".
- `Troque por isto`: o valor central e estado recuperavel com historico e decisao explicita de retry, timeout e compensation.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- workflow engine ou coordenador duravel adiciona uma camada operacional de verdade;
- testes e debugging pedem historico, replay e visibilidade melhores do que numa fila comum;
- compensation torna a modelagem de negocio mais honesta, mas tambem mais explicita e trabalhosa;
- timers, backlog e isolamento passam a ser preocupacoes de plataforma.

Sinais de uso errado:

- o fluxo cabe em um unico job curto e idempotente, mas o time quer "workflow" por fascinio;
- ninguem sabe dizer qual estado precisa sobreviver a um crash;
- compensation foi terceirizada para suporte manual ou script de madrugada;
- retries disparam em toda a pipeline sem distinguir timeout, erro permanente e dependencia indisponivel;
- operadores so descobrem workflow preso quando o cliente abre ticket.

## Fechamento: Julgamento Arquitetural

Durable workflow e menos sobre orquestrar passos e mais sobre preservar julgamento ao longo do tempo. A Uber investiu nisso porque processos longos demais, multi-tenant e sensiveis a burst nao cabiam mais em logica espalhada por workers ([Announcing Cadence 1.0](https://www.uber.com/nl/en/blog/announcing-cadence/); [Cadence Multi-Tenant Task Processing](https://www.uber.com/gb/en/blog/cadence-multi-tenant-task-processing/)). Para empresa menor, a licao nao e "instale Cadence". E mais severa: pare de esconder estado de processo em fila, retry global e boa vontade do operador. Quando o fluxo vive por horas ou dias, ele precisa de memoria propria.

## Decision Synthesis

### Use When

- o fluxo atravessa varios passos, sistemas externos e janelas de tempo longas
- retries, timers e timeouts diferem por etapa
- falha parcial exige retomada coerente e, em alguns casos, compensation

### Why This Case Used It

- a Uber precisava tirar retries, capacidade e fault tolerance do codigo espalhado pelos times
- workloads concorrentes e bursty exigiram isolamento serio entre tenants e tipos de workflow
- timers, signals e activities precisavam andar junto com o estado duravel do processo

### Main Trade-offs

- mais infraestrutura e observabilidade operacional
- modelo mental mais pesado do que fila simples
- compensation explicita aumenta o custo de modelagem, mas reduz o custo de caos

### Warning Signs

- o processo cabe em um job curto, mas a equipe quer um workflow engine por moda
- o fluxo depende de espera longa, mas nao existe estado duravel para retomada
- timeouts e retries sao iguais para todas as etapas por preguica de desenho

### Decision Checklist

- qual estado do processo precisa sobreviver a crash e deploy?
- quais passos aceitam retry automatico e quais exigem compensation?
- como vou inspecionar e retomar execucoes presas?
- meu fluxo ja justifica um engine especializado ou um coordenador duravel em Rails basta por enquanto?

## Navigation

- [Prev](./chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Index](./README.md)
- [Next](./chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
