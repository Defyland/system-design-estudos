# Review Card 03 - Idempotent Writes Under Ambiguous Failure

## Linked Material

- [Chapter 03](../../chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)
- [Lab 03](../../labs/chapters/chapter-03-idempotent-writes-under-ambiguous-failure.md)

## Anchor

- `Problema`: falha ambigua faz o cliente ou worker repetir uma mutacao que nao pode duplicar efeito.
- `Decisao`: tratar `Idempotency-Key` como identidade de uma intencao de negocio e fazer replay da primeira resposta canonica.

## Cue Signal

- `Sinal`: o retry e inevitavel, mas repetir a mutacao pode cobrar, reservar, enviar ou gravar duas vezes.

## Case Anchor

- `Caso real`: [Stripe - Idempotent Payments](../../real-world-cases/03-async-workflows-and-payments/stripe-idempotent-payments/README.md)
- `Lembrete`: a rede pode repetir request; o efeito financeiro nao pode repetir a mutacao.

## QDSAA Recall

- `Requirement corrigido`: o centro aqui nao e "responder rapido"; e proteger efeito unico.
- `Delete`: retry cego ou mutacao duplicada em downstreams sensiveis.
- `Forma simples`: tabela de idempotencia no mesmo banco da write com replay da primeira resposta.

## Trade-off to Remember

- `Custo`: guardar chave, fingerprint e resposta adiciona estado e semantica de replay.
- `Failure mode`: chave reaproveitada com payload diferente ou request presa em `processing`.

## Trap

- `Resposta ruim`: "indice unico ja resolve retry ambiguo".
- `Troque por isto`: idempotencia boa devolve a mesma resposta canonica e detecta reuso errado de payload.

## 1-Minute Answer

Quando repetir a mutacao pode cobrar, reservar ou criar estado extra, o servidor precisa registrar a primeira resposta e fazer replay dela nos retries. Payload diferente com a mesma chave vira conflito.
