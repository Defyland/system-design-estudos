# Review Card 04 - System Design Canonical Problems

## Linked Material

- [Chapter 04](../../chapters/04-system-design-canonical-problems.md)

## Anchor

- `Problema`: parece que cada entrevista pede um sistema inedito, quando na pratica as families se recombinam.
- `Decisao`: estudar os problemas canonicos como familias de gargalo e trade-off.

## Cue Signal

- `Sinal`: voce nao sabe por onde comecar quando o entrevistador fala "desenhe um news feed" ou "desenhe um rate limiter".

## Case/Bridge Anchor

- `Ponte`: [Caching](../../../../../areas/09-backend-principles/cards/caching.md), [Task Queues and Background Jobs](../../../../../areas/09-backend-principles/cards/task-queues-background-jobs.md), [Realtime Backend Systems](../../../../../areas/09-backend-principles/cards/realtime-backend-systems.md)
- `Caso real`: [Meta - News Feed Ranking](../../../../../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md), [Dropbox - Nautilus Search](../../../../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)

## QDSAA Recall

- `Requirement corrigido`: o entrevistador quer ver escolha inicial forte, gargalo primeiro e evolucao em 10x.
- `Delete`: diagrama maximalista no primeiro minuto.
- `Forma simples`: URL shortener, rate limiter, feed, chat, notification system, file upload, autocomplete e job queue.

## Trade-off to Remember

- `Custo`: sistema simples demais pode ignorar ordering, idempotencia ou ACL.
- `Failure mode`: falar componente sem dizer qual problema ele resolve.

## Trap

- `Resposta ruim`: "cada um desses sistemas exige uma arquitetura completamente diferente".
- `Troque por isto`: "as families mudam de cara, mas cache, fila, ordenacao, retry e hot key reaparecem".

## 1-Minute Answer

Os problemas canonicos existem para treinar as mesmas decisoes fundamentais: caminho principal, storage, cache ou fila, primeiro gargalo e evolucao. O nome do sistema muda; a disciplina de resposta deveria continuar igual.
