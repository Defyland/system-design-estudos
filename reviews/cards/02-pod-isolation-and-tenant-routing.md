# Review Card 02 - Pod Isolation and Tenant Routing

## Linked Material

- [Chapter 02](../../chapters/chapter-02-pod-isolation-and-tenant-routing.md)
- [Lab 02](../../labs/chapters/chapter-02-pod-isolation-and-tenant-routing.md)

## Anchor

- `Problema`: alguns tenants estao machucando os outros, mas o dominio ainda nao pede microservicos.
- `Decisao`: comprar pod isolation e roteamento deterministico antes de desmontar o sistema em varios servicos.

## Case Anchor

- `Caso real`: [Shopify - Pods and Modular Monolith](../../real-world-cases/01-platforms-and-apps/shopify-pods-and-modular-monolith/README.md)
- `Lembrete`: pods entram para cercar tenant ruidoso sem desmontar cedo demais um monolito que ainda compra clareza.

## QDSAA Recall

- `Requirement corrigido`: nem todo tenant precisa de isolamento forte agora; o problema costuma morar nos hotspots.
- `Delete`: fluxo cross-pod ou cross-tenant no caminho critico.
- `Forma simples`: monolito modular com `pod_key` carregado da borda ate o datastore certo.

## Trade-off to Remember

- `Custo`: isolamento por pod complica analytics, tenant move e qualquer consulta cross-pod.
- `Failure mode`: drift de roteamento ou write indo para o pod errado.

## Trap

- `Resposta ruim`: "sharding de banco ja resolve isolamento".
- `Troque por isto`: sem boundary de runtime, o dano continua atravessando o sistema.

## 1-Minute Answer

Pods resolvem blast radius por tenant. O app continua monolito, mas request e job carregam `pod_key` desde a borda e tocam um unico datastore por unidade de trabalho.
