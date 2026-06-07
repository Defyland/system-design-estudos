# Incident Management and SRE

## Case Pattern

Incidente nao e so debugging. E um fluxo operacional: detectar impacto, montar resposta, verificar severidade, mitigar, reparar, revisar e fechar action items com dono.

## When to Use

- Produto tem usuarios suficientes para falhas virarem evento de negocio.
- Alertas existem, mas ninguem sabe quem decide durante outage.
- O time corrige sintomas e repete incidentes parecidos.
- A arquitetura ja precisa de SLO, ownership e runbooks.

## What Breaks First

Sem comando claro, engenheiros investigam em paralelo sem coordenacao, comunicacao externa atrasa, o rollback compete com diagnostico e postmortem vira ritual sem mudanca estrutural.

## Interview Trap

Falar so de observabilidade tecnica. Resposta senior liga metrica de usuario, severidade, dono, canal de incidente, mitigacao rapida e aprendizagem que reduz recorrencia.

## Practice Drill

Modele um incidente de API com 30% de erro 500. Escreva: primeiro alerta, criterio de severidade, papel do incident commander, mitigacao inicial, metrica de all clear e dois action items verificaveis.

## Source Anchor

- Slack, [All Hands on Deck](https://slack.engineering/all-hands-on-deck/).
- Slack, [Service Delivery Index: A Driver for Reliability](https://slack.engineering/service-delivery-index-a-driver-for-reliability/).
- GitHub, [Building On-Call Culture at GitHub](https://github.blog/engineering/engineering-principles/building-on-call-culture-at-github/).
