# Review Card 05 - Durable Workflows, Retries and Compensation

## Linked Material

- [Chapter 05](../../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Lab 05](../../labs/chapters/chapter-05-durable-workflows-retries-and-compensation.md)

## 15-Second Recall

- `Pergunta`: o que workflow duravel compra que job encadeado nao compra?
- `Resposta curta`: memoria do caminho. O sistema sabe onde parou e de onde retoma.

## Design Pass Recall

- `Requirement`: esse fluxo precisa mesmo viver por muito tempo e compensar etapas?
- `Delete`: qual passo ou compensacao voce cortaria primeiro?
- `Forma mais simples`: coordenador explicito ou maquina de estados antes de engine dedicada.

## Wrong Turn

- `Resposta ruim`: "se falhar no meio, eu reinicio tudo".
- `Troque por isto`: efeitos externos e timers longos pedem retomada por estado, nao recomeco heroico.

## 1-Minute Answer

Workflow duravel aparece quando retry, timeout e compensation variam por etapa e precisam sobreviver a crash. O primeiro efeito externo serio ja merece compensation explicita.

## Production Recall

- `Pergunta`: qual tela ou metrica abre um workflow quebrado mais rapido?
- `Resposta curta`: execucoes presas por step, timeout rate e compensation failure.

## Wrong Production Move

- `Resposta ruim`: "aumenta timeout e deixa rodar mais um pouco".
- `Troque por isto`: quando o fluxo esta preso, senior primeiro pausa entrada e impede retry avalanche.

## Transfer Check

- para produto menor, uma tabela de execucao e jobs retomaveis ensinam muito antes de instalar Temporal ou Cadence
