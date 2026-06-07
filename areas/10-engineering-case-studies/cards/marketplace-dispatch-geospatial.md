# Marketplace, Dispatch and Geospatial Systems

## Case Pattern

Marketplace fisico em tempo real combina oferta, demanda, geografia, previsao, matching, pricing, ETA, workflow e fairness operacional. A arquitetura precisa tomar decisoes locais rapido e corrigir com sinais globais.

## When to Use

- Usuarios, provedores e itens se movem no mundo fisico.
- Matching depende de distancia, tempo, capacidade, preco e restricoes.
- A decisao precisa acontecer em segundos, mas o aprendizado vem de historico.
- Falhas afetam dinheiro, seguranca ou experiencia presencial.

## What Breaks First

ETA fica obsoleto, oferta e demanda mudam entre previsao e dispatch, geohash/H3 escolhido cria hot spots, workflow perde compensacao, ou otimizacao local piora experiencia global.

## Interview Trap

Responder marketplace como CRUD com mapa. O problema real e sistema de decisao sob incerteza: forecast, dispatch, pricing, routing, idempotencia e observabilidade por regiao.

## Practice Drill

Desenhe despacho de entregas por restaurante. Inclua celulas geograficas, fila por area, ETA, assignment, timeout, reassign, cancelamento, metrica de fairness e backpressure em pico.

## Source Anchor

- Uber, [H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/blog/h3/).
- Uber, [DeepETA: How Uber Predicts Arrival Times Using Deep Learning](https://www.uber.com/us/en/blog/deepeta-how-uber-predicts-arrival-times/).
- Uber, [How Trip Inferences and Machine Learning Optimize Delivery Times on Uber Eats](https://www.uber.com/en-CI/blog/uber-eats-trip-optimization/).
- Uber, [Food Discovery with Uber Eats: Recommending for the Marketplace](https://www.uber.com/us/en/blog/uber-eats-recommending-marketplace/).
