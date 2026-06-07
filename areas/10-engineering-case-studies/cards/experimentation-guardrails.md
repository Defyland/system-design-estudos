# Experimentation and Guardrails

## Case Pattern

Experimentacao em producao exige assignment consistente, exposicao correta, metricas de sucesso, guardrails, exclusividade entre testes, holdbacks, ramp-up e deteccao de regressao. Feature flag sozinho nao e plataforma de experimento.

## When to Use

- Times querem validar produto com A/B tests em vez de opiniao.
- Mudancas de config precisam rollout gradual e rollback.
- Muitos experimentos podem interferir no mesmo usuario ou superficie.
- Metricas de negocio precisam ser protegidas enquanto o time otimiza uma metrica local.

## What Breaks First

Exposicao e tratamento divergem, amostra fica enviesada, experimentos colidem, guardrail detecta tarde, ou um resultado "vencedor" degrada uma metrica critica de outro time.

## Interview Trap

Confundir canary, feature flag e A/B test. Canary protege deploy; A/B test mede hipotese; guardrails protegem o sistema contra ganho local com dano global.

## Practice Drill

Desenhe o rollout de uma nova tela de checkout. Inclua assignment por usuario, evento de exposicao, sucesso, guardrails, exclusividade, criterio de parada e plano se crash rate subir.

## Source Anchor

- Spotify, [Spotify's New Experimentation Platform - Part 1](https://engineering.atspotify.com/2020/10/spotifys-new-experimentation-platform-part-1).
- Spotify, [Spotify's New Experimentation Platform - Part 2](https://engineering.atspotify.com/2020/11/spotifys-new-experimentation-platform-part-2).
- Airbnb, [Designing Experimentation Guardrails](https://medium.com/airbnb-engineering/designing-experimentation-guardrails-ed6a976ec669).
- Airbnb, [How Airbnb Safeguards Changes in Production](https://medium.com/airbnb-engineering/how-airbnb-safeguards-changes-in-production-9fc9024f3446).
