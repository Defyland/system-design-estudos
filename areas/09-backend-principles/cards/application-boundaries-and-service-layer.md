# Application Boundaries and Service Layer

## When to Use

Use quando voce precisa decidir qual unidade do sistema realmente segura uma regra de negocio, uma transacao ou um contrato de operacao. O boundary define o que o resto do sistema pode pedir e onde a decisao final mora; a service layer costuma ser a forma mais simples de expor esse boundary para HTTP, jobs, workers ou integracoes.

## What Breaks First

O sistema vira turismo de decisao. Controller, job, consumer e script batch repetem meio fluxo cada um, ninguem sabe qual caminho e canonico e a mesma mutacao ganha validacoes diferentes dependendo de quem chamou.

## Design Moves

- trate boundary como unidade social e tecnica ao mesmo tempo: codigo visto como unidade, funcionalidade percebida como unidade e ownership financiado como unidade;
- nomeie operacoes do negocio no boundary, nao detalhes de framework;
- concentre transacao, autorizacao sensivel, idempotencia e efeitos essenciais na service layer ou operacao equivalente;
- deixe controller, fila e adapter traduzirem entrada e saida, sem redecidir o dominio;
- extraia servico separado so quando ownership, throughput, seguranca ou deploy independente realmente mudarem o jogo.

## Interview Trap

Confundir boundary com topologia de deploy. Servico remoto nao cria boundary por si so; e monolito nao impede boundary forte.

## Practice Drill

Pegue um fluxo de `checkout`. Escreva em voz alta:
1. qual operacao canonica o sistema oferece;
2. qual camada pode chamar essa operacao;
3. onde mora a decisao final de risco, estoque e cobranca;
4. o que fica fora do boundary por ser adaptacao de borda.

## Source Anchor

- Martin Fowler, [Application Boundary](https://martinfowler.com/bliki/ApplicationBoundary.html).
- Martin Fowler, [Service Layer](https://martinfowler.com/eaaCatalog/serviceLayer.html).
