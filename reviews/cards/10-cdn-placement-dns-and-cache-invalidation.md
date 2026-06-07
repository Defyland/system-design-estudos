# Review Card 10 - CDN Placement, DNS and Cache Invalidation

## Linked Material

- [Chapter 10](../../chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)
- [Lab 10](../../labs/chapters/chapter-10-cdn-placement-dns-and-cache-invalidation.md)

## Anchor

- `Problema`: latencia global e freshness estao sendo tratadas como se fossem so "mais cache".
- `Decisao`: pensar CDN como placement, roteamento e envelhecimento por camada, nao so como TTL.

## Cue Signal

- `Sinal`: o gargalo ficou geografico e de invalidacao, nao de CPU da app ou SQL da origem.

## Case Anchor

- `Caso real`: [Netflix - Open Connect CDN](../../real-world-cases/04-edge-and-delivery/netflix-open-connect-cdn/README.md)
- `Lembrete`: placement e freshness andam juntos; cache bom nao e so "ficar perto".

## QDSAA Recall

- `Requirement corrigido`: a dor real pode ser geografia, origem ou freshness, nao "falta de cache" genericamente.
- `Delete`: purge exagerado e camada duplicada de cache sem contrato claro.
- `Forma simples`: CDN para conteudo estavel com invalidacao previsivel.

## Trade-off to Remember

- `Custo`: mais cache e placement compram hit ratio, mas complicam freshness e origem.
- `Failure mode`: miss storm depois de purge ruim ou stale demais em conteudo sensivel.

## Trap

- `Resposta ruim`: "purge all a cada deploy e simples".
- `Troque por isto`: versionamento e TTL por camada preservam hit ratio e evitam miss storm.

## 1-Minute Answer

CDN bom combina placement, roteamento e freshness. Asset imutavel pede fingerprint e TTL longo; conteudo mutavel pede TTL curto, `stale-while-revalidate` ou purge cirurgico.
