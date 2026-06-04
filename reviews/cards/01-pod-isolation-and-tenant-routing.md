# Review Card 01 - Pod Isolation and Tenant Routing

## Linked Material

- [Chapter 01](../../chapters/chapter-01-pod-isolation-and-tenant-routing.md)
- [Lab 01](../../labs/chapters/chapter-01-pod-isolation-and-tenant-routing.md)

## 15-Second Recall

- `Pergunta`: quando pods entram na conversa?
- `Resposta curta`: quando um tenant ruidoso pede cerca operacional antes de pedir microservicos.

## Wrong Turn

- `Resposta ruim`: "sharding de banco ja resolve isolamento".
- `Troque por isto`: sem boundary de runtime, o dano continua atravessando o sistema.

## 1-Minute Answer

Pods resolvem blast radius por tenant. O app continua monolito, mas request e job carregam `pod_key` desde a borda e tocam um unico datastore por unidade de trabalho.

## Production Recall

- `Pergunta`: qual painel voce abre primeiro?
- `Resposta curta`: erro por `pod_key`, tenant mais afetado e qualquer sinal de cross-pod no caminho critico.

## Wrong Production Move

- `Resposta ruim`: "vamos mover mais tenants para balancear logo".
- `Troque por isto`: primeiro congele movimento e descubra se o roteamento ja esta errado.

## Transfer Check

- em empresa menor, o primeiro passo costuma ser diretorio simples de tenant e proibicao de fluxo cross-pod no caminho critico
