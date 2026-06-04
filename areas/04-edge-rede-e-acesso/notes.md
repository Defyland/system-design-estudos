# Notes

## Ida e Volta

- [Chapter 10 - Edge Rate Limiting, WAF and Gateway Boundaries](../../chapters/chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 11 - CDN Placement, DNS and Cache Invalidation](../../chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)
- [Chapter 13 - Critical Checkout Flows and Auth Boundaries](../../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
- [Example - Smaller Marketplace Checkout Boundary](./examples/smaller-marketplace-checkout-boundary.md)
- [Snippet - Rails Checkout Boundary and Auth Guard](./snippets/rails-checkout-boundary-and-auth-guard.md)
- [Lab - Chapter 13](../../labs/chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)

## Modelos Mentais

### Borda responde identidade; checkout responde mutacao

`authenticate` na borda responde quem entrou. Checkout responde se aquela identidade pode concluir esta mutacao agora, com este carrinho, este risco e este metodo.

### O caminho da receita precisa de replay seguro

Se o cliente nao sabe se a cobranca aconteceu, ele precisa repetir a operacao sem criar efeito colateral extra. E por isso que idempotencia nao e "extra de API", e parte do contrato do checkout ([Stripe Idempotent Requests](https://docs.stripe.com/api/idempotent_requests?javascript=false&lang=node)).

### Step-up auth e evento, nao estado global

Nao reautentique a sessao inteira por esporte. Exija step-up quando o checkout cruza um limiar sensivel: troca recente de payment method, valor alto, risco anormal, alteracao de conta ou exigencia regulatoria.

### O payload de recuperacao deve ser generico

A Uber deliberadamente empurrou `Checkout Actions` opacas para evitar vazamento da complexidade de pagamento para cada LOB ([Uber Unified Checkout](https://www.uber.com/blog/unified-checkout/)). O principio aqui vale para empresa menor: UI recebe "proxima acao", nao detalhes do motor interno.

## Matriz de Decisao

| Pergunta | Fica na borda/gateway | Fica no checkout boundary |
| --- | --- | --- |
| Quem e o usuario? | Sim | Nao, so consome contexto |
| O token/sessao e valido? | Sim | Nao, salvo casos de reauth |
| O usuario pode mutar este carrinho/pedido? | Parcial, de forma generica | Sim, de forma final |
| Precisa de 3DS, 2FA ou reauth? | Nao consegue decidir sozinho | Sim |
| Retry pode cobrar duas vezes? | Nao resolve | Sim, com idempotencia |
| Qual proxima acao de recuperacao mostrar? | Nao | Sim |
| Rate limit e WAF | Sim | Nao |

## Empresa Menor vs Empresa Maior

| Tema | Empresa menor | Empresa maior |
| --- | --- | --- |
| Topologia | Monolito Rails com modulo de checkout | Servico ou plataforma de checkout |
| Auth | Sessao padrao e reauth pontual | Sessao global, risco, 2FA, multiplos canais |
| Pagamentos | Stripe com `PaymentIntent` e idempotencia | Multiplos processadores e payment methods |
| Integracao de produto | 1 ou 2 fluxos principais | Muitos LOBs e fluxos heterogeneos |
| Maior risco | Espalhar logica em controllers | Virar gargalo de plataforma |
| Boa decisao inicial | Boundary logico interno | API/contrato generico entre times |

## Empresa Menor: traducao pratica

Se voce tem uma operacao pequena, nao copie a topologia da Uber. Copie a disciplina:

- um ponto claro de entrada para `submit checkout`
- escopo de idempotencia por carrinho ou tentativa de pedido
- reauth apenas quando o contexto pede
- retorno estruturado para `completed`, `requires_action` ou `failed`

Isso ja entrega quase todo o aprendizado importante do chapter sem introduzir microservicos por vaidade.

## Sinais de uso errado

- middleware ou gateway tentando decidir 3DS, captura ou estado do pedido
- controller de produto falando direto com Stripe e tambem atualizando pedido
- mesma `Idempotency-Key` reutilizada com payload diferente
- toda falha devolvida como 500 sem acao corretiva
- checkout boundary crescendo ate virar "produto inteiro"

## Rails First

- use `before_action` para sessao e identidade, nao para orquestrar pagamento
- modele `Checkout::SubmitOrder` ou equivalente com resultado explicito
- persista idempotencia em tabela propria com `scope`, `key`, `status`, `response_body`
- deixe a UI consumir estado do checkout, nao detalhes do processador

## Quando Elixir ou Go ensinam algo novo

- Elixir ensina quando o problema vira mais sobre coordenar muitas etapas concorrentes e recovery de processos de longa duracao
- Go ensina quando voce quer isolar uma borda de alto throughput, um adaptador de gateway ou uma peca de infra mais enxuta
- em ambos os casos, o julgamento do boundary continua igual

## Voltar para o chapter

- [Releia o julgamento arquitetural completo no Chapter 13](../../chapters/chapter-13-critical-checkout-flows-and-auth-boundaries.md)
