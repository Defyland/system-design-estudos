# Example - Slow Rollout Read Path Regression

## Cenario

SaaS B2B pequeno. Um rollout manda mais leituras para replica e adiciona cache em summaries quentes.

Uma hora depois:
- usuarios dizem "acabei de salvar e sumiu"
- dashboard parece intermitente
- origem melhorou um pouco, mas a experiencia piorou

## Leitura senior

- parece escala, mas o incidente e de contrato de leitura
- replica e cache ajudaram throughput e quebraram semantica visivel

## Primeiros 15 minutos

1. devolver reads sensiveis para primary
2. desligar a cache key nova se a invalidacao estiver errada
3. medir replica lag e hit ratio ao mesmo tempo
4. comparar antes e depois por endpoint, nao so por banco

## Rollback certo

- reverte a politica de read routing
- segura a migration ou a invalidacao errada
- nao troca de banco nem muda topologia no calor do incidente

## Aprendizado

Senior bom separa ganho de throughput de quebra de contrato de leitura.
