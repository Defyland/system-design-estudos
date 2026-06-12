# Contrast 16 - Transitional Architecture vs Big-Bang Rewrite

## Tension

Os dois querem substituir sistema velho, mas so um compra aprendizado e convivio controlado no caminho.

## Use Transitional Architecture When

- o negocio nao pode parar para trocar tudo de uma vez;
- existe seam utilizavel para desviar fluxo ou interceptar eventos;
- o risco maior e de coexistencia controlada, nao de custo temporario extra;
- o time precisa provar o caminho novo com trafego real antes de matar o legado.

## Use Big-Bang Rewrite When

- o sistema pode realmente ser desligado por janela curta e reversivel;
- nao existe convivio parcial defensavel sem multiplicar risco demais;
- o escopo e pequeno o suficiente para substituicao direta;
- o custo de manter adaptadores temporarios seria maior que o risco concentrado da troca.

## Trap

- `Resposta ruim`: "incremental sempre e melhor".
- `Troque por isto`: arquitetura transicional ruim tambem apodrece; se voce nao consegue nomear seam, ownership e condicao de retirada, so trocou um risco por outro.

## 15-Second Distinction

Arquitetura transicional compra coexistencia e aprendizado. Big-bang compra troca direta, simplicidade temporaria e risco concentrado.

## Pull Chapters

- [Chapter 02](../chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Chapter 06](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Chapter 09](../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
