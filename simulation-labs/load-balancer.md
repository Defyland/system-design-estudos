# Simulation Lab - Load Balancer

## Scenario

Seu produto B2B recebe pico de requests no inicio do expediente. Dois servidores parecem saudaveis na media, mas um deles comeca a responder devagar.

## Controls

- requests per second
- server count
- algorithm
- per-server failure rate

## What Changes

Round robin distribui bem quando servidores sao parecidos. Least connections reage melhor quando um servidor fica lento.

## Failure Mode

Um servidor degradado recebe trafego demais e vira multiplicador de timeout.

## Cost Signal

Mais servidor reduz saturacao, mas tambem aumenta custo fixo.

## Interview Takeaway

Load balancing nao e so espalhar request; e impedir que um nodo ruim contamine o sistema inteiro.

## Linked Chapters

- [Chapter 06](../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)

## Linked Areas

- [Componentes](../areas/07-componentes-de-sistemas/README.md)

## Mastery Checks

- `Pergunta`: qual metrica voce olha primeiro quando o LB parece saudavel mas usuarios reclamam?
- `Resposta com as suas palavras`: eu olho latencia e erro por upstream, nao so throughput total.
- `Resposta ruim que parece boa`: aumentar servidores resolve.
- `Troque por isto`: primeiro descubra se o algoritmo esta mandando trafego para um nodo degradado.

