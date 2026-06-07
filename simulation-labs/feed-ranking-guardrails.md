# Simulation Lab - Feed Ranking / Guardrails

## Scenario

Um ranker novo melhora clique curto, mas o time teme piorar latencia, diversidade ou confianca do feed.

## Controls

- candidate cap
- shadow ranker percentage
- guardrail threshold
- high-fanout policy

## What Changes

Candidate cap menor protege custo e latencia, mas pode matar recall antes do score final.

## Failure Mode

Experimento ganha metrica local e piora o feed real, ou aciona fanout e feature fetch caros demais para o budget.

## Cost Signal

Ranking serio cobra logging, online features, cohort control e rollback rapido por qualidade, nao so por erro tecnico.

## Interview Takeaway

Feed ranking adulto sempre define quem pode vetar a melhoria antes do rollout virar default.

## Linked Chapters

- [Chapter 14](../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)

## Linked Areas

- [Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/README.md)

## Mastery Checks

- `Pergunta`: que metrica pode vetar um ranker mesmo quando o clique sobe?
- `Resposta com as suas palavras`: a guardrail que protege qualidade, latencia ou confianca do feed.
- `Resposta ruim que parece boa`: se o CTR subiu, o experimento venceu.
- `Troque por isto`: feed bom responde ao produto inteiro, nao a uma metrica isolada.
