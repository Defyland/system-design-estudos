# Chapter 04 - Search Indexing and Permission-Aware Retrieval

## Slice

Como um sistema de busca indexa documentos, respeita permissoes e entrega resultados com baixa latencia.

## Historia de Produto

Seu PO quer busca em tudo: nome, texto livre, comentario, documento e atalho. Duas semanas depois vem a segunda bomba: "nao pode vazar nada que o usuario nao possa ver". Pronto. Ja nao e mais uma query esperta com `LIKE`.

## Onde Isso Aparece Antes da Teoria

- SaaS com documentos, tickets, comentarios ou knowledge base
- produtos em que achar rapido o item certo vale mais do que navegar por listas
- sistemas em que permissao muda o resultado final, nao so a tela

## Case Anchors

- [Dropbox - Nautilus Search](../real-world-cases/02-data-storage-and-search/dropbox-nautilus-search/README.md)

## Foco em Entrevistas

- por que busca nao e so banco relacional com indice
- onde ACL entra: no indice, no serving ou nos dois
- como discutir frescor, ranking e latencia sem virar abstracao vaga

## Study Links

- [Area - Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)
- [Notes - Dados e Armazenamento](../areas/02-dados-e-armazenamento/notes.md)
- [Area - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/README.md)
- [Notes - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/notes.md)
- [Example - Interview Walkthrough](../areas/01-metodo-e-entrevistas/examples/interview-walkthrough-marketplace-search.md)
- [Snippet - Interview Checklist](../areas/01-metodo-e-entrevistas/snippets/system-design-interview-checklist.md)
- [Lab](../labs/chapters/chapter-04-search-indexing-and-permission-aware-retrieval.md)

## A Tensao Real

Busca fica bonita no demo e cruel em producao. O usuario quer encontrar "aquele documento de ontem" em meio a bilhoes de objetos, com latencia baixa e sem nenhum vazamento de permissao. Se voce resolve so a metade tecnica da busca, entrega ranking ruim. Se resolve so a metade semantica da permissao, entrega incidente de seguranca.

Dropbox deixa essa tensao bem explicita no Nautilus. O problema deles nao era apenas escala, com centenas de bilhoes de pieces of content. Era tambem personalizacao por usuario, corpus mudando com frequencia e a necessidade de preservar privacidade ao longo de toda a pipeline ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)). Essa combinacao e o motivo pelo qual busca deixa de ser um `LIKE` com autoestima.

### Fixacao Relampago 1

- `Pergunta`: por que busca quase nunca deveria nascer direto da tabela transacional?
- `Resposta com as suas palavras`: porque buscar e outra conversa. Eu quero texto, relevancia e rapidez, nao so integridade de write.
- `Resposta ruim que parece boa`: "um `LIKE` bem escrito resolve ate escalar".
- `Troque por isto`: tabela transacional e fonte de verdade; indice de busca e estrutura de leitura especializada.

## Contexto e Constraints do Caso Real

Nautilus separa o sistema em dois blocos majoritariamente independentes: indexing e serving ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)). O lado de indexing processa atividade de arquivos e usuarios, extrai conteudo e metadata, grava isso em um document store e produz mutacoes quase em tempo real para o indice vivo; em paralelo, rebuilds offline acontecem em media a cada tres dias para recriar o indice invertido com calma e permitir rollback de experimentos ruins ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)).

O lado de permissao e ainda mais importante. Dropbox organiza arquivos em namespaces. O conjunto de namespaces aos quais o usuario tem acesso define exatamente o scope da busca; isso permite consultar so conteudo acessivel no momento da query ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)). E o sistema nao para ai: o Octopus primeiro chama o access-control service para descobrir os namespaces visiveis, usa isso para scope do retrieval engine e ainda faz uma segunda checagem de ACL por resultado antes de devolver ao usuario ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)).

O terceiro constraint e tempo. O Nautilus mira um budget de 500 ms no percentil 95 para a busca inteira, enquanto o retrieval engine e ajustado para recall alto e o ranking posterior trabalha precisao usando sinais como BM25, atividade recente do usuario e freshness ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)). Ou seja: achar muitos candidatos rapido, sem vazar nada, e so depois decidir o que merece subir.

## Decisao Tomada

A decisao canonica aqui e separar preocupacoes sem separar semantica:

1. extraia e normalize documentos fora do request path;
2. mantenha um document store ou log de mutacoes como base de reconstruibilidade;
3. use um indice voltado a retrieval, nao o banco operacional como motor de busca geral;
4. aplique permissao na definicao de escopo antes da busca e valide de novo na saida;
5. trate ranking e frescor como sistemas em tensao, nao como bonus.

O caso Dropbox ensina um detalhe que costuma faltar em entrevistas: ACL nao e um filtro decorativo depois do top 10. Ela muda o plano de execucao da busca. Se o scope de namespaces nao entra cedo, o sistema desperdica CPU procurando coisa proibida e ainda arrisca inconsistencias de contagem, snippet ou cache.

### Fixacao Relampago 2

- `Pergunta`: onde a permissao deve ser checada de verdade?
- `Resposta com as suas palavras`: eu uso o indice para cortar muito resultado ruim, mas confirmo permissao de novo antes de devolver.
- `Resposta ruim que parece boa`: "se indexei por `workspace_id`, a seguranca ja esta resolvida".
- `Troque por isto`: indice ajuda a baratear a busca; autorizacao final continua sendo responsabilidade do caminho de leitura.

## Rails First

Em Rails, o desenho principal costuma ser um servico de indexacao assicrona mais um boundary de query que recebe o scope de permissao antes de falar com o backend de search.

```rb
class Search::QueryService
  def call(actor:, raw_query:)
    namespace_ids = AccessControl.visible_namespaces_for(actor)
    normalized_query = QueryUnderstanding.normalize(raw_query)

    hits = SearchBackend.search(
      query: normalized_query,
      namespace_ids: namespace_ids,
      limit: 50
    )

    hits
      .select { |hit| AccessControl.can_read?(actor, hit.document_id) }
      .sort_by { |hit| -RankingSignals.score(hit, actor: actor) }
      .first(10)
  end
end
```

O paralelo com Nautilus e direto. `visible_namespaces_for` faz o papel do scope de query; `SearchBackend` faz retrieval em cima de um indice proprio; o `select` final repete a blindagem de ACL; e o ranking entra depois do recall bruto. Para um produto menor, isso ja ensina a ordem mental correta sem exigir um Octopus inteiro.

## Stack Translation

- `Rails first`: fonte de verdade no relacional, indexacao assincrona por job e double-check de ACL antes da resposta.
- `Quando Elixir ensina mais`: quando a pipeline de indexacao vira uma esteira concorrente com backpressure, retry e varias etapas independentes.
- `Quando Go ensina mais`: quando ingestao, retrieval gateway ou servico de busca de baixa latencia passam a ser boundary proprio de infra.

## Production Mode

### What Breaks First

- lag de index deixando o produto parecer quebrado
- vazamento de ACL em resultado, snippet ou cache de busca

### Signals to Watch

- index lag
- erro de ACL por resultado
- latencia de busca e taxa de fallback

### Safe Rollout

- shadow query antes de trocar o backend principal
- indexe um subconjunto antes de abrir a todos

### Rollback Trigger

- qualquer indicio de ACL leak
- lag ou latencia fugindo do SLA visivel

### First 15 Minutes

- pare o rollout do indice novo
- force fallback para retrieval antigo ou modo degradado
- compare ACL scope e payload de resultados afetados

### Fixacao de Producao

- `Pergunta`: qual incidente acaba com a busca mais rapido que latencia?
- `Resposta com as suas palavras`: mostrar coisa que o usuario nao podia ver.
- `Resposta ruim que parece boa`: "staleness chata e sempre pior que tudo".
- `Troque por isto`: latencia ruim irrita; ACL leak vira incidente de seguranca.

## Por Que Nao Outra Abordagem

Nao "so usa SQL com indice" quando a pergunta do produto ja pede full-text, ranking, autocomplete, documentos heterogeneos ou frescor mais agressivo. O relacional continua excelente para metadata e ownership. Como motor principal de busca rica, ele costuma ficar caro demais cedo demais.

Nao "filtra permissao depois" porque isso distorce recall, desperdica capacidade e pode vazar pistas de existencia. Nautilus primeiro restringe o universo via namespaces e depois ainda revalida ACL no orquestrador ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)).

Nao "so indexa streaming" porque rebuild offline existe por uma razao: experimentar formatos de indice, heuristicas e annotators, e conseguir rollback quando uma ideia piora a busca ([Architecture of Nautilus, the new Dropbox search engine](https://dropbox.tech/machine-learning/architecture-of-nautilus-the-new-dropbox-search-engine)).

## Traducao Explicita Para Empresa Menor

Empresa menor nao precisa de ML ranking no dia um. Precisa de boundaries honestos.

A traducao pratica costuma ser:

- um modelo de permissoes reduzido a `workspace_id`, `project_id` ou equivalente;
- indexacao assincrona via job quando documento, comentario ou ticket muda;
- busca em Elastic, OpenSearch, Meilisearch ou ate `tsvector` se o problema ainda e modesto;
- scope de permissao resolvido antes da query;
- double-check de ACL antes de montar a resposta final.

Se o produto crescer, voce troca o motor ou adiciona ranker. O que nao deveria mudar e a disciplina: index nao e source of truth, permissoes entram cedo e reindexacao precisa de rollback.

### Fixacao Relampago 3

- `Pergunta`: quando o lag do indice e aceitavel?
- `Resposta com as suas palavras`: quando o produto aguenta alguns segundos ou minutos sem parecer quebrado para o usuario.
- `Resposta ruim que parece boa`: "indice tem que refletir write na hora sempre".
- `Troque por isto`: frescor custa caro; o SLA de indexacao precisa nascer da experiencia do produto, nao do perfeccionismo tecnico.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- indice assincrono compra latencia, mas aceita alguma staleness;
- ACL na busca aumenta custo e complexidade operacional;
- ranking melhor costuma competir com latencia e simplicidade;
- rebuild e backfill exigem storage extra e processo de rollout.

Sinais de uso errado:

- o time trata search como query SQL glorificada e ignora relevance;
- a busca usa um indice global e tenta esconder ACL so no serializer;
- nao existe estrategia de reindexacao, shadowing ou rollback;
- o produto promete "busca instantanea" sem definir budget de frescor.

## Fechamento: Julgamento Arquitetural

Permission-aware retrieval e o ponto em que busca vira arquitetura de verdade. O Nautilus e valioso porque mostra a composicao completa: document extraction, indice invertido, mutacoes em streaming, rebuild offline, scope por namespace, rechecagem de ACL e ranking separado. Para empresa menor, a traducao nao e copiar a complexidade; e copiar a ordem. Primeiro defina quem pode ver o que. Depois faca retrieval rapido nesse universo. So depois melhore ranking. Quando a equipe inverte essa ordem, a busca ate parece funcionar, mas o sistema fica pronto para decepcionar usuario e seguranca ao mesmo tempo.

## Decision Synthesis

### Use When

- a busca exige ranking, latencia baixa e tolerancia a texto livre
- permissoes precisam afetar o resultado final
- a leitura do usuario nao pode depender de scans ou joins pesados toda vez

### Why This Case Used It

- a Dropbox precisava buscar documentos rapidamente sem violar ACLs
- separar indexacao e serving permitiu escalar o fluxo de busca
- o problema nao era apenas achar o documento, mas achar o documento certo que o usuario pode ver

### Main Trade-offs

- resultados podem ficar stale dependendo da estrategia de indexacao
- ACLs tornam a busca mais cara e mais complexa
- ranking, frescor e custo computacional entram em conflito constante

### Warning Signs

- busca simples por igualdade ja resolve o produto
- o volume de dados e baixo e nao justifica pipeline de indexacao
- permissoes nao influenciam nada no serving

### Decision Checklist

- eu preciso de full-text, ranking ou autocomplete de verdade?
- a permissao e aplicada no indice, no serving ou nos dois?
- qual o SLA de frescor do indice?
- eu sei o custo de reindexacao e backfill?

## Navigation

- [Prev](./chapter-03-blob-durability-and-storage-tiers.md)
- [Index](./README.md)
- [Next](./chapter-05-idempotent-writes-under-ambiguous-failure.md)
