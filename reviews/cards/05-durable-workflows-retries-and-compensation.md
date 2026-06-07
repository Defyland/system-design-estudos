# Review Card 05 - Durable Workflows, Retries and Compensation

## Linked Material

- [Chapter 05](../../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Lab 05](../../labs/chapters/chapter-05-durable-workflows-retries-and-compensation.md)

## Anchor

- `Problema`: fluxo longo atravessa varios passos, espera, retry e compensation que nao cabem em job encadeado ingenuo.
- `Decisao`: explicitar estado duravel do processo para retomar do ponto certo, em vez de recomecar tudo no escuro.

## Case Anchor

- `Caso real`: [Uber - Cadence Workflows](../../real-world-cases/03-async-workflows-and-payments/uber-cadence-workflows/README.md)
- `Lembrete`: o ganho do workflow duravel e memoria do caminho, nao "mais fila".

## QDSAA Recall

- `Requirement corrigido`: o centro do problema e sobreviver a espera, crash e efeitos externos, nao so fazer async.
- `Delete`: passo ou compensation que nao precisa existir.
- `Forma simples`: coordenador explicito ou maquina de estados antes de engine dedicada.

## Trade-off to Remember

- `Custo`: mais infraestrutura, visibilidade e disciplina de estado.
- `Failure mode`: execucoes presas entre steps ou compensation falhando depois do efeito externo.

## Trap

- `Resposta ruim`: "se falhar no meio, eu reinicio tudo".
- `Troque por isto`: efeitos externos e timers longos pedem retomada por estado, nao recomeco heroico.

## 1-Minute Answer

Workflow duravel aparece quando retry, timeout e compensation variam por etapa e precisam sobreviver a crash. O primeiro efeito externo serio ja merece compensation explicita.
