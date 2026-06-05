# Simulation Lab - Saga / Compensation

## Scenario

Checkout reserva estoque, cobra pagamento e emite notificacao. A cobranca pode falhar depois da reserva.

## Controls

- step failure rate
- retry limit
- compensation quality
- timeout

## What Changes

Saga torna cada passo explicito e permite compensar quando a transacao distribuida nao cabe.

## Failure Mode

Compensation incompleta deixa estado de negocio preso.

## Cost Signal

Modelar compensation custa mais cedo e custa menos durante incidente.

## Interview Takeaway

Saga nao e desculpa para caos eventual. Ela exige ownership do fluxo.

## Linked Chapters

- [Chapter 05](../chapters/chapter-05-durable-workflows-retries-and-compensation.md)
- [Chapter 07](../chapters/chapter-07-critical-checkout-flows-and-auth-boundaries.md)

## Linked Areas

- [Filas e Consistencia](../areas/03-filas-e-consistencia/README.md)

## Mastery Checks

- `Pergunta`: qual passo costuma ganhar compensation primeiro?
- `Resposta com as suas palavras`: o passo que criou efeito externo caro, como cobrar ou reservar.
- `Resposta ruim que parece boa`: retry ate completar.
- `Troque por isto`: retry sem compensation so adia inconsistencia.

