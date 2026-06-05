# Notes

## Ida e Volta

- [Chapter 09 - Search Indexing and Permission-Aware Retrieval](../../chapters/chapter-09-search-indexing-and-permission-aware-retrieval.md)
- [Chapter 04 - Event Backbone, Partitions and Consumer Scale](../../chapters/chapter-04-event-backbone-partitions-and-consumer-scale.md)
- [Chapter 11 - Geospatial Indexing for Marketplace Search](../../chapters/chapter-11-geospatial-indexing-for-marketplace-search.md)
- [Chapter 14 - Feed Ranking and Fanout Trade-offs](../../chapters/chapter-14-feed-ranking-and-fanout-trade-offs.md)
- [Interview Walkthrough Example](./examples/interview-walkthrough-marketplace-search.md)
- [Interview Walkthrough Checkout Incident](./examples/interview-walkthrough-checkout-incident.md)
- [Interview Checklist Snippet](./snippets/system-design-interview-checklist.md)
- [Senior Production Answer Template](./snippets/senior-production-answer-template.md)
- [First Principles Design Pass](./snippets/first-principles-design-pass.md)

## Requisitos

A primeira pergunta de system design nao e "qual tecnologia?". E "o que exatamente o produto precisa entregar?".

Checklist rapido:
- quem usa isso?
- qual acao principal precisa ficar excelente?
- qual latencia ou disponibilidade realmente importa?
- o que e core e o que pode degradar?
- existe requisito de consistencia, frescor, privacidade ou compliance?

Se voce pula essa parte, a resposta inteira vira arquitetura de estima.

## Estimativas

Estimativa boa em entrevista nao e exibicao de matematica. E uma ferramenta para cortar opcao ruim cedo.

Perguntas que quase sempre pagam aluguel:
- quantos usuarios ativos por dia e por pico?
- quantas writes por segundo?
- quanto dado novo por dia?
- qual payload medio?
- quantos objetos ou entidades quentes existem ao mesmo tempo?

Use ordem de grandeza para escolher:
- banco unico vs particionamento
- cache opcional vs cache obrigatorio
- fila simples vs backbone de eventos
- cronologia simples vs ranking caro

## Framework de resposta

Framework enxuto que combina com este repo:

1. clareza:
   - reafirme o problema em uma frase boa
2. restricoes:
   - latency, consistency, cost, privacy, scaling
3. nucleo:
   - descreva o caminho principal do request ou do evento
4. gargalos:
   - nomeie 2 ou 3 pontos que vao doer primeiro
5. evolucao:
   - diga o que faria agora e o que faria em 10x de escala
6. trade-offs:
   - explique o que ganhou e o que piorou

Este e o ponto em comum entre os chapters: eles ensinam decisoes, nao so componentes.

## First Principles Design Pass

Antes de escolher componente, rode este pass. Ele existe para te impedir de vender tecnologia cedo demais.

1. `Requirement Less Dumb`
   Pergunte qual requisito e real e qual e heranca, medo ou exagero. Isso evita overengineering porque corta exigencia artificial antes que ela vire arquitetura. Em entrevista, melhora a resposta porque mostra que voce sabe separar necessidade de slogan.
2. `Delete`
   Tente remover passo, componente, fluxo ou feature antes de adicionar outro. Isso evita complexidade acumulada em cima de coisa inutil. Em sistema real, costuma ser a forma mais barata de ganhar desempenho ou resiliencia.
3. `Simplify`
   Se algo ainda precisa existir, reduza para a menor forma que entrega a funcao. Isso evita otimizar topologia complexa demais cedo demais. Em entrevista, mostra julgamento porque voce comeca pelo desenho pequeno que ainda funciona.
4. `Accelerate`
   Encurte o ciclo de aprendizado. Pergunte como medir, testar, reverter e comparar a mudanca rapido. Isso evita ficar preso a arquitetura bonita que demora semanas para provar valor. Em producao e em entrevista, mostra que voce pensa em iteracao, nao so em estado final.
5. `Automate Last`
   Automatize depois que a versao simples ja esta certa e observavel. Isso evita automatizar desperdicio, esconder requisito ruim ou travar um processo que ainda muda. Em resposta senior, isso mostra disciplina operacional.

Formula curta para usar em qualquer problema:
- qual requisito eu questiono primeiro?
- o que eu tentaria remover antes de adicionar?
- qual e a forma mais simples que ainda funciona?
- como eu aprendo rapido se isso esta certo?
- o que eu so automatizo depois?

## Erros recorrentes

- responder com tecnologia antes de responder com produto
- falar "microservicos", "Kafka" ou "Redis" antes de provar a necessidade
- ignorar consistency requirements em pagamentos, auth ou pedidos
- nao distinguir empresa menor de empresa gigante
- desenhar sistema bonito demais e caminho de falha feio demais

## Aprendizados de mocks

- uma boa resposta de entrevista quase sempre parece uma boa aula curta
- conte uma historia do problema antes do componente
- diga onde voce usaria a ideia antes de descrever a ideia
- quando puder, compare solucao "agora" com solucao "quando doer 10x"

## Como responder incidente em entrevista

A resposta senior para incidente nao comeca com tecnologia. Comeca com estabilizacao.

Ordem util:
1. diga o impacto em linguagem de produto
2. diga o que voce protegeria primeiro
3. diga qual metrica ou dashboard abriria antes de especular
4. diga o que mitigaria agora
5. diga o que investigaria depois que a hemorragia parou

Boa resposta:
- "primeiro eu preservo checkout e login"
- "depois separo se o problema e latencia externa, regra nova ou saturacao interna"
- "so depois penso em ajuste fino"

Resposta fraca:
- "eu abriria os logs e sairia debugando"

## Como narrar mitigacao e rollback

Muita resposta de system design fica bonita ate a primeira falha. Em nivel senior, voce precisa soar como alguem que sabe parar o sangramento.

Formula boa:
- `mitigar`: o que mantem o caminho critico vivo agora
- `rollback`: o que desfaz a mudanca mais suspeita com o menor blast radius
- `segurar`: o que voce deliberadamente nao muda no meio do incidente

Exemplo:
- mitigo desligando o novo rate limit na rota errada
- rollback do rollout do ranker novo
- nao mexo no schema, no cache inteiro e nem em tres variaveis ao mesmo tempo

## Como falar de risco sem soar generico

Risco fraco:
- "isso pode dar problema de escala"

Risco senior:
- "essa replica pode violar read-after-write no checkout"
- "esse replay pode derrubar downstream se eu nao limitar taxa"
- "essa regra de edge pode bloquear login legitimo e piorar receita"

Fale risco sempre no formato:
- qual caminho critica
- qual sintoma aparece
- qual tipo de dano isso causa

## Mitigar agora vs corrigir depois

Senior de producao sabe diferenciar:

- `mitigar agora`:
  - desligar regra nova
  - reduzir taxa
  - voltar leitura para primary
  - congelar tenant move
  - cortar feature nao critica
- `corrigir depois`:
  - reescrever algoritmo
  - refatorar o boundary
  - trocar broker
  - criar novo servico

Em entrevista, essa distincao vale ouro. Ela mostra que voce sabe operar um sistema real, nao so redesenha-lo no papel.

## Casos reais estudados

- [Dropbox - Nautilus Search](../../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)
- [Uber - H3 Geospatial Marketplace](../../real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)
- [Meta - News Feed Ranking](../../real-world-cases/05-product-scenarios/meta-news-feed-ranking/README.md)
- [GitHub - Rails and MySQL at Scale](../../real-world-cases/01-platforms-and-apps/github-rails-and-mysql-at-scale/README.md)

## Aplicacao no stack

- Rails:
  - excelente para explicar o caminho principal e modelar o dominio com clareza
- Elixir:
  - entra quando a entrevista pede concorrencia, realtime ou muitos processos leves
- Go:
  - entra quando a conversa pede servicos de infra, throughput ou componentes enxutos

O erro seria tentar provar dominio em Go so porque a entrevista parece "mais senior". Senioridade aqui e julgamento, nao linguagem.
