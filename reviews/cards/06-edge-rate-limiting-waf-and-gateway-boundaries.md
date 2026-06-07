# Review Card 06 - Edge Rate Limiting, WAF and Gateway Boundaries

## Linked Material

- [Chapter 06](../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Lab 06](../../labs/chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)

## Anchor

- `Problema`: trafego abusivo, caro ou invalido esta gastando CPU da origem e confundindo fronteiras.
- `Decisao`: matar barato na borda, governar entrada no gateway e deixar semantica e permissao fina na app.

## Case Anchor

- `Caso real`: [Cloudflare - Edge Platform](../../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- `Lembrete`: protecao de borda so fica madura quando separa bloqueio barato, governanca compartilhada e regra de negocio.

## QDSAA Recall

- `Requirement corrigido`: nem tudo deve morrer na borda; parte do julgamento ainda pertence ao dominio.
- `Delete`: regra duplicada entre edge, gateway e app.
- `Forma simples`: edge bloqueia abuso obvio, gateway governa entrada, app decide semantica.

## Trade-off to Remember

- `Custo`: mais poder na borda aumenta tuning e risco de falso positivo.
- `Failure mode`: trafego legitimo bloqueado ou identidade errada de fairness deixando o vizinho ruidoso passar.

## Trap

- `Resposta ruim`: "o gateway decide toda a autorizacao do sistema".
- `Troque por isto`: edge e gateway governam a entrada; a app ainda decide semantica e permissao fina.

## 1-Minute Answer

O desenho bom divide responsabilidade: edge bloqueia barato, gateway governa auth tecnica e roteamento, app protege regra de negocio e recursos caros recebem fairness mais perto do dano.
