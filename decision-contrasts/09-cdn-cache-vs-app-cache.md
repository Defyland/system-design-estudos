# Contrast 09 - CDN Cache vs App Cache

## Tension

Os dois cacheiam, mas um protege a borda publica e o outro protege o trabalho interno da app.

## Use CDN Cache When

- o conteudo e publico ou amplamente compartilhado
- latencia geografica e offload de origem importam
- browser e edge podem segurar o objeto

## Use App Cache When

- o dado e especifico de dominio
- o gargalo esta dentro do app ou do banco
- a resposta nao se beneficia tanto de estar na borda

## Trap

- `Resposta ruim`: "qualquer resposta quente vai para CDN".
- `Troque por isto`: personalizacao e auth destroem hit ratio e podem vazar dado.

## 15-Second Distinction

CDN protege origem publica. App cache corta repeticao interna.

## Pull Chapters

- [Chapter 02](../chapters/chapter-02-relational-scaling-and-operational-discipline.md)
- [Chapter 11](../chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)
