# Legacy Displacement and Transitional Architecture

## Case Pattern

Modernizacao boa quase nunca e "reescreve tudo e troca em um fim de semana". O padrao recorrente e encontrar `seams`, criar arquitetura transicional pequena, desviar fluxo aos poucos, manter coexistencia por algum tempo e remover os adaptadores temporarios assim que o novo caminho provar valor.

## When to Use

- Um sistema legado impede mudanca, custa caro ou virou risco operacional.
- O negocio nao pode aceitar big-bang rewrite.
- Existe chance real de extrair um slice com seam tecnico ou de processo.
- O time precisa conviver com velho e novo por um periodo controlado.

## What Breaks First

A equipe cai em `feature parity` infinita, reescreve stack sem mudar o fluxo certo ou cria arquitetura transicional que nunca morre. Sem seam clara, o novo sistema vira apendice caro; sem ownership de cutover, o legado continua centro do negocio.

## Interview Trap

Responder "faz strangler" sem dizer qual seam voce usa, como o fluxo e desviado, qual contrato temporario segura a coexistencia e quando o adaptador transicional sera removido.

## Practice Drill

Escolha um middleware ou modulo de checkout antigo. Desenhe:
- seam inicial;
- componente transicional minimo;
- estrategia de dark launch ou parallel run;
- metrica que permite desviar mais trafego;
- condicao para matar o caminho legado.

## Source Anchor

- Ian Cartwright, Rob Horn e James Lewis, [Patterns of Legacy Displacement](https://martinfowler.com/articles/patterns-legacy-displacement/).
- Ian Cartwright, Rob Horn e James Lewis, [Transitional Architecture](https://martinfowler.com/articles/patterns-legacy-displacement/transitional-architecture.html).
- Ian Cartwright, Rob Horn e James Lewis, [Dark Launching](https://martinfowler.com/articles/patterns-legacy-displacement/dark-launching.html).
