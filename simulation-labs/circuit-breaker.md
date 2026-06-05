# Simulation Lab - Circuit Breaker

## Scenario

Uma dependencia externa comeca a falhar e cada request fica presa esperando timeout.

## Controls

- failure rate
- timeout
- open threshold
- cooldown

## What Changes

Closed tenta normalmente. Open falha rapido. Half-open testa recuperacao com pouco trafego.

## Failure Mode

Threshold frouxo deixa timeout espalhar. Threshold agressivo corta dependencia ainda recuperavel.

## Cost Signal

Falhar rapido reduz custo de thread, conexao e fila.

## Interview Takeaway

Circuit breaker nao corrige dependencia. Ele limita blast radius enquanto voce decide fallback ou rollback.

## Linked Chapters

- [Chapter 07](../chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)
- [Chapter 13](../chapters/chapter-13-realtime-concurrency-and-workload-isolation.md)

## Linked Areas

- [Arquitetura e Operacao](../areas/05-arquitetura-e-operacao/README.md)

## Mastery Checks

- `Pergunta`: qual e o primeiro ganho de abrir o circuito?
- `Resposta com as suas palavras`: parar de gastar tempo e recurso esperando uma dependencia que esta falhando.
- `Resposta ruim que parece boa`: o circuit breaker resolve a falha externa.
- `Troque por isto`: ele contem dano; a causa ainda precisa ser tratada.

