# Lab - Chapter 06

## Chapter

- [Back to Chapter 06](../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)

## First Pass

Responda em voz alta antes de desenhar:

- `Requirement Less Dumb`: o que deve morrer no edge e o que ainda depende do dominio?
- `Delete`: qual regra duplicada entre edge, gateway e app voce removeria primeiro?
- `Simplify`: qual fronteira minima deixa cada camada com um trabalho claro?
- `Accelerate`: como voce soltaria e observaria uma regra nova sem atingir login ou checkout?
- `Automate Last`: o que ainda nao merece bloqueio automatico?

## Drill de 3 Minutos

Responda em voz alta. Nao escreva; use o gabarito logo abaixo para corrigir na hora.

- desenhe o request path de uma API pequena com edge, gateway, Rails e banco;
- escolha tres riscos: brute force, scraping e tenant barulhento;
- diga qual risco morre no edge, qual passa pelo gateway e qual so o app ou o gate interno consegue decidir;
- imagine o overload: um cliente dispara exports pesados; explique como voce preserva fairness sem derrubar login e leitura interativa.

## Gabarito Oral Imediato

- `Resposta curta`: brute force e scraping bruto deveriam morrer cedo no edge; semantica fina de tenant barulhento costuma precisar chegar mais perto do recurso.
- `Resposta curta`: gateway governa auth tecnica, schema e roteamento comum; a app ainda decide se aquela mutacao faz sentido.
- `Resposta curta`: fairness para exports pesados costuma pedir fila e concorrencia separadas do fluxo interativo.
- `Armadilha`: "rate limit por IP resolve tudo". Nao. Em multi-tenant, o dano real raramente mora so no IP.
