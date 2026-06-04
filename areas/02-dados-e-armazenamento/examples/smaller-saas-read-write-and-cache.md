# Smaller SaaS - Read/Write and Cache

## Cenario

Imagine um SaaS B2B de help desk para operacoes internas. Cada empresa tem agentes, filas, tickets, comentarios, SLAs e relatorios simples. O core do produto e relacional: permissoes cruzam usuarios e equipes, um ticket depende de estado, prioridade, historico e ownership, e o financeiro ainda quer reconciliar tudo no mesmo banco.

O sistema nao esta em escala de "milhoes de merchants", mas ja tem sinais reais:

- uma conta enterprise responde por 35% da leitura do dashboard;
- agentes atualizam tickets o dia todo e esperam ler a mudanca imediatamente;
- o dashboard de fila e os counters de SLA sao consultados centenas de vezes por minuto;
- exports e relatorios pesados aparecem sempre no pior horario possivel, claro.

## Decisao Boa o Bastante

Para esse estagio, a melhor decisao costuma ser:

- manter o banco relacional como fonte de verdade;
- mandar writes e leituras logo apos write para a primary;
- usar uma replica apenas para dashboard, lista de tickets e export que toleram pequena defasagem;
- aplicar cache-aside em summaries por tenant, counters e cards da home;
- adiar shard, pod e servicos separados ate existir um problema claro de blast radius.

## Por Que Isso Funciona

Esse produto nao precisa de inventividade topologica; precisa de honestidade operacional. O ganho vem de proteger o caminho quente:

- ticket detail e update continuam consistentes na primary;
- queue summary e counters repetitivos saem da primary com replica e cache;
- invalidacao acontece no write, no mesmo fluxo em que o ticket muda;
- o time aprende cedo qual endpoint tolera lag e qual endpoint quebra negocio se ficar velho.

## O Que Seria Exagero

- shardear antes de provar que um tenant quente esta esmagando os outros;
- jogar tudo em cache e torcer para os invalidadores lembrarem do mesmo key space;
- abrir Elasticsearch so para fugir de query ruim em lista paginada;
- extrair servicos porque "um dia talvez escale".

## Regra de Julgamento

Empresa menor nao precisa copiar GitHub ou Shopify em topologia. Precisa copiar a pergunta certa: "qual parte do meu trafego realmente precisa de consistencia imediata, e qual parte pode comprar throughput com replica ou cache?". Se voce responder isso com rigor, o sistema cresce sem teatro.

## Proximo Passo

Implemente o padrao com o snippet [Rails Read/Write Split and Cache Aside](../snippets/rails-read-write-split-and-cache-aside.md) e use o [Lab - Chapter 02](../../../labs/chapters/chapter-02-relational-scaling-and-operational-discipline.md) como experimento curto.
