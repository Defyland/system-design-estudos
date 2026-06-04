# Review Card 11 - CDN Placement, DNS and Cache Invalidation

## Linked Material

- [Chapter 11](../../chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)
- [Lab 11](../../labs/chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)

## 15-Second Recall

- `Pergunta`: qual pergunta vem antes de "qual TTL eu uso?"?
- `Resposta curta`: quem consome isso, por quanto tempo continua valido e em qual camada vale guardar mais.

## Wrong Turn

- `Resposta ruim`: "purge all a cada deploy e simples".
- `Troque por isto`: versionamento e TTL por camada preservam hit ratio e evitam miss storm.

## 1-Minute Answer

CDN bom combina placement, roteamento e freshness. Asset imutavel pede fingerprint e TTL longo; conteudo mutavel pede TTL curto, `stale-while-revalidate` ou purge cirurgico.

## Production Recall

- `Pergunta`: qual numero abre um purge ruim mais rapido?
- `Resposta curta`: hit ratio caindo junto com origem subindo de repente.

## Wrong Production Move

- `Resposta ruim`: "purga tudo de novo para corrigir".
- `Troque por isto`: purge demais tambem e incidente; primeiro proteja a origem.

## Transfer Check

- empresa menor quase sempre compra valor enorme so acertando headers, fingerprint e invalidacao
