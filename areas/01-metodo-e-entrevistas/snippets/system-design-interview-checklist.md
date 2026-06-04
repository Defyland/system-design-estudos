# System Design Interview Checklist

## Before Architecture

- qual e a acao principal do produto?
- o que precisa ficar rapido?
- o que nao pode duplicar, perder ou vazar?
- qual o pico aproximado de trafego?

## During Architecture

- diga o caminho principal do request ou do evento
- escolha o source of truth
- nomeie 2 ou 3 gargalos reais
- mostre uma versao agora e uma versao 10x maior

## Trade-off Questions

- por que nao uma solucao mais simples?
- o que piora com a solucao escolhida?
- qual limite faria voce evoluir o desenho?

## Rails First Reading

Para este repo, a pergunta util e:
- eu consigo explicar isso primeiro como produto e fluxo de negocio em Rails?

Se sim, otimo. Depois compare com Elixir ou Go apenas quando a natureza do problema pedir isso.
