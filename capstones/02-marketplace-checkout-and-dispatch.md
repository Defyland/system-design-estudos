# Capstone 02 - Marketplace Checkout and Dispatch

## Pull Chapters

- [Chapter 03 - Idempotent Writes Under Ambiguous Failure](../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Chapter 06 - Edge Rate Limiting, WAF and Gateway Boundaries](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 11 - Geospatial Indexing for Marketplace Search](../chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)
- [Chapter 07 - Critical Checkout Flows and Auth Boundaries](../chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)

## First Principles Pass Before Drawing

Responda em voz alta antes de desenhar qualquer caixa:

- `Requirement Less Dumb`: o produto precisa mesmo de busca super precisa, checkout super centralizado e protecao dura ao mesmo tempo, ou algumas partes ainda aceitam forma menor?
- `Delete`: qual duplicacao de pagamento, busca ou protecao de borda voce cortaria primeiro?
- `Simplify`: qual e o menor desenho que separa descoberta, checkout critico e protecao de entrada sem overengineering?
- `Accelerate`: quais metricas de conversao, timeout, conflito e backlog voce abriria primeiro?
- `Automate Last`: o que ainda nao merece roteamento inteligente, retry adaptativo ou automacao espacial pesada?

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

## Production Twist

### Page

Uma campanha entra no ar, o PSP comeca a responder mais lento e o app cliente retry demais. Em paralelo, uma regra nova de edge entra para segurar abuso. Resultado: checkout falha, alguns pedidos ficam presos em `processing` e o time nao sabe se deve insistir no retry ou cortar trafego.

### First Dashboard

- conversao por etapa do checkout
- timeout e erro por metodo de pagamento
- quantidade de pedidos presos em `processing`
- conflitos de `Idempotency-Key`
- 429s no caminho critico

### Immediate Mitigation

- desligue a regra nova de edge se ela toca o caminho critico
- reduza retries agressivos do cliente
- preserve idempotencia e reconciliacao antes de liberar novas mutacoes

### Rollback or Hold

Rollback da mudanca recente de edge ou risco que piorou a conversao. Hold na investigacao profunda do PSP ate estabilizar a jornada e impedir dupla execucao de pedido.

### What Not to Change Mid-Incident

- nao desligue idempotencia para "destravar"
- nao reexecute pedidos cegamente
- nao mexa em varios metodos de pagamento ao mesmo tempo

## Trap

- "H3 resolve checkout, gateway resolve auth e Stripe resolve o resto"
