# Capstone 02 - Marketplace Checkout and Dispatch

## Pull Chapters

- [Chapter 05 - Idempotent Writes Under Ambiguous Failure](../chapters/chapter-05-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 12 - Geospatial Indexing for Marketplace Search](../chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)
- [Chapter 13 - Critical Checkout Flows and Auth Boundaries](../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)

## Interview Mode

Seu entrevistador pede: "desenhe um marketplace com busca nearby, checkout critico e protecao contra retries e abuso".

## Work Mode

Seu PO diz: "o usuario precisa achar fornecedor perto, fechar compra sem dupla cobranca e nao derrubar a API em dia de campanha".

## Oral Route

1. separe descoberta de fornecedor, mutacao de checkout e protecao de borda
2. diga quando PostGIS basta e quando H3 entra
3. explique por que checkout precisa de boundary proprio
4. explique como `Idempotency-Key` protege o `POST /orders`
5. diga o que morre no edge e o que so o dominio consegue decidir
6. diga o que voce implementa em Rails antes de pensar em Elixir ou Go

## Good Answer Sounds Like

- geospatial bucket reduz candidatos; distancia exata confirma
- checkout responde permissao critica, risco e estado de pagamento
- idempotencia protege retry ambiguo do cliente e do caminho financeiro
- rate limit e fairness ficam na borda e perto do recurso caro, nao so no controller

## Trap

- "H3 resolve checkout, gateway resolve auth e Stripe resolve o resto"
