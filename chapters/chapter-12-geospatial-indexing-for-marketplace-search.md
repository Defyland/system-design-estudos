# Chapter 12 - Geospatial Indexing for Marketplace Search

## Slice

Como um marketplace geolocalizado transforma lat/long em buckets operaveis para busca, dispatch e cobertura sem fingir que "mais perto" e so uma conta de distancia.

## Historia de Produto

Seu PO nao quer um mapa bonito. Ele quer resposta util: qual motorista esta perto o bastante, qual tecnico cobre esta area, qual locker ainda faz sentido para este CEP, qual restaurante entra no SLA prometido. A partir daqui, coordenada bruta para de parecer modelo de dados e comeca a parecer custo.

## Onde Isso Aparece Antes da Teoria

- marketplaces, dispatch, delivery e busca por proximidade
- produtos cuja pergunta central e "o que esta perto o bastante agora?"
- sistemas em que cobertura, calor de demanda e matching dependem mais de area do que de ponto exato

## Case Anchors

- [Uber - H3 Geospatial Marketplace](../real-world-cases/02-data-storage-and-search/uber-h3-geospatial-marketplace/README.md)

## Foco em Entrevistas

- como explicar por que bucket espacial ajuda mais do que lat/long bruto nas consultas quentes
- quando um indice geografico entra como acelerador operacional, nao como capricho matematico
- como discutir resolucao, borda de celula, frescor e filtro final de distancia com clareza

## Study Links

- [Area - Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)
- [Notes - Dados e Armazenamento](../areas/02-dados-e-armazenamento/notes.md)
- [Area - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/README.md)
- [Notes - Metodo e Entrevistas](../areas/01-metodo-e-entrevistas/notes.md)
- [Example - Interview Walkthrough](../areas/01-metodo-e-entrevistas/examples/interview-walkthrough-marketplace-search.md)
- [Snippet - Interview Checklist](../areas/01-metodo-e-entrevistas/snippets/system-design-interview-checklist.md)
- [Lab](../labs/chapters/chapter-12-geospatial-indexing-for-marketplace-search.md)

## A Tensao Real

Geografia engana. No comeco, parece que basta guardar `latitude` e `longitude` e rodar um `ORDER BY distance`. O problema e que o produto raramente pergunta "qual e o ponto matematicamente mais perto?". Ele pergunta "quem entra rapido no conjunto de candidatos para dispatch, ETAs, cobertura e preco dinamico?". Na Uber, isso acontece sobre milhoes de eventos diarios espalhados pela cidade, e analisar tudo no ponto exato fica caro demais para o caminho principal ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)).

Quando a pergunta operacional vira "o que esta perto o bastante nesta parte da cidade?", voce precisa de uma unidade intermediaria entre o globo real e a query do banco. E aqui entra a parte importante: o indice geografico nao serve para substituir distancia. Ele serve para reduzir o espaco de busca ate a distancia exata voltar a caber.

### Fixacao Relampago 1

- `Pergunta`: indice espacial substitui distancia exata?
- `Resposta com as suas palavras`: nao. Ele so corta o universo para a distancia exata voltar a caber.
- `Resposta ruim que parece boa`: "se esta na mesma celula, ja esta resolvido".
- `Troque por isto`: bucket gera candidato; filtro exato confirma se o candidato realmente serve.

## Contexto e Constraints do Caso Real

A Uber descreve o problema de forma bem pragmatica: eventos do marketplace acontecem em localizacoes especificas, mas raciocinar cidade inteira no ponto exato e dificil e caro; por isso a empresa analisa areas, nao pontos soltos ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)). Esses buckets alimentam decisoes como surge pricing, matching e outras otimizacoes de marketplace em escala de cidade ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/); [Visualizing City Cores with H3](https://www.uber.com/ca/en/blog/visualizing-city-cores-with-h3/)).

O detalhe tecnico so importa porque conversa com as constraints do produto. A Uber rejeita zonas arbitrarias, CEPs e poligonos manuais porque eles mudam por motivos alheios ao produto, variam demais de forma e tamanho e exigem manutencao continua. Tambem evita grade quadrada como default porque quadrados tem dois tipos de vizinhos com distancias diferentes, enquanto hexagonos tem uma distancia uniforme entre centros vizinhos, o que simplifica smoothing, proximidade e analise espacial ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)).

H3 resolve isso com um indice hexagonal hierarquico. A hierarquia importa porque uma cidade nao precisa da mesma granularidade para tudo: uma busca imediata por oferta pode usar uma resolucao, enquanto uma visao agregada de cobertura ou demanda pode subir para a celula ancestral. O artigo descreve 16 resolucoes e destaca tres propriedades que valem ouro em design de sistemas: converter lat/long em uma chave compacta, recuperar vizinhos por anel (`kRing`) e compactar conjuntos de celulas quando a representacao precisa ficar menor ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)).

## Decisao Tomada

A decisao canonica aqui nao e "usar H3 porque e famoso". E esta:

1. transformar ponto geografico em bucket espacial estavel;
2. usar o bucket para gerar candidatos baratos;
3. aplicar distancia exata e regras de negocio so no conjunto reduzido;
4. escolher resolucao conforme a pergunta do produto, nao conforme a curiosidade tecnica.

Em outras palavras, o indice entra como chave operacional. O bucket ajuda a responder "onde procurar primeiro?", e o filtro exato responde "o candidato realmente serve?". Essa separacao evita dois erros comuns: usar distancia exata cedo demais, ou tratar a celula como se ela fosse a resposta final.

### Fixacao Relampago 2

- `Pergunta`: como escolher resolucao do bucket?
- `Resposta com as suas palavras`: pelo tamanho real da pergunta do produto, nao pela vontade de usar o nivel mais fino.
- `Resposta ruim que parece boa`: "quanto menor a celula, melhor o sistema".
- `Troque por isto`: resolucao fina demais aumenta ruido e custo; grossa demais perde precisao util.

## Rails First

Em Rails, o caminho principal costuma ser bem menos heroico do que o nome "geospatial indexing" sugere: persistir a celula H3 no write de localizacao, buscar candidatos pelas celulas vizinhas e so depois fazer o filtro exato por distancia.

```rb
class NearbyProvidersQuery
  RESOLUTION = 8
  RING_SIZE = 2
  MAX_DISTANCE_METERS = 3_000

  def initialize(indexer: Geo::HexIndexer.new)
    @indexer = indexer
  end

  def call(lat:, lng:)
    origin_cell = @indexer.cell_for(lat: lat, lng: lng, resolution: RESOLUTION)
    candidate_cells = @indexer.neighbor_cells(origin_cell, ring: RING_SIZE)
    distance_sql = ApplicationRecord.sanitize_sql_array(
      [
        "ST_DistanceSphere(ST_MakePoint(longitude, latitude), ST_MakePoint(?, ?))",
        lng,
        lat
      ]
    )

    ProviderAvailability
      .active
      .where(h3_cell: candidate_cells)
      .where("updated_at >= ?", 2.minutes.ago)
      .select(Arel.sql("provider_availabilities.*, #{distance_sql} AS distance_meters"))
      .where(Arel.sql("#{distance_sql} <= #{MAX_DISTANCE_METERS}"))
      .order("distance_meters ASC")
      .limit(50)
  end
end
```

O padrao importante e o de duas fases:

- `h3_cell` reduz o universo de busca;
- a distancia exata protege contra erro de borda e garante que "perto" continue significando algo real.

Se voce pular a segunda fase, a celula vira aproximacao demais. Se voce pular a primeira, a query geografica vira cara cedo demais.

## Stack Translation

- `Rails first`: PostGIS, celula H3 persistida e query em duas fases resolvem muito antes de qualquer plataforma dedicada.
- `Quando Elixir ensina mais`: quando localizacao muda o tempo todo e dispatch vira problema de muitos atores concorrentes em tempo real.
- `Quando Go ensina mais`: quando API de proximidade, streams de localizacao e workers geoespaciais ficam pesados no throughput.

## Por Que Nao Outra Abordagem

Nao "lat/long puro para tudo" porque isso ate funciona em volume menor, mas degrada quando o mesmo produto precisa repetir busca por proximidade, heatmap de cobertura e raciocinio por area muitas vezes por minuto. A Uber descreve exatamente essa necessidade de analise e otimizacao em escala de cidade ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)).

Nao "zonas manuais, bairros ou CEPs" porque elas mudam por motivacoes administrativas e operacionais que nao refletem o comportamento real do marketplace. O proprio artigo explica por que shapes arbitrarios e zonas desenhadas manualmente nao sao uma base boa para analise consistente ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)).

Nao "grade quadrada padrao" porque a geometria piora o problema exatamente onde voce quer simplificar. H3 escolhe hexagonos porque eles minimizam quantization error para pessoas em movimento e facilitam aproximar raios e vizinhancas ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/); [Visualizing City Cores with H3](https://www.uber.com/ca/en/blog/visualizing-city-cores-with-h3/)).

## Traducao Explicita Para Empresa Menor

Empresa menor nao precisa "hexagonificar o mundo" no primeiro dia. Se o seu produto ainda tem poucas buscas por proximidade e um `ST_DWithin` simples no Postgres resolve, use isso e siga em frente.

Mas o limiar muda quando:

- a mesma busca de proximidade vira caminho quente de leitura;
- voce precisa comparar oferta e demanda por area, nao so por ponto;
- cobertura e dispatch passam a depender de buckets repetiveis;
- varias superficies do produto reaproveitam a mesma pergunta geografica.

Nessa hora, a traducao pragmatica e esta:

- compute uma celula H3 na escrita ou atualizacao de localizacao;
- escolha uma unica resolucao inicial alinhada ao tamanho real da busca;
- gere candidatos por vizinhanca de celulas;
- aplique distancia exata e regra de negocio no segundo passo;
- coloque TTL curto em disponibilidade, porque proximidade sem frescor vira mentira.

O erro mais comum em empresa menor nao e "nao usar H3". E usar H3 cedo demais ou usar H3 e mesmo assim continuar pensando em ponto exato para tudo.

### Fixacao Relampago 3

- `Pergunta`: quando vale sair de PostGIS simples para bucket espacial proprio?
- `Resposta com as suas palavras`: quando proximidade vira caminho quente repetido e eu preciso raciocinar por area, nao so por ponto.
- `Resposta ruim que parece boa`: "qualquer busca por mapa ja pede H3".
- `Troque por isto`: bucket espacial entra quando reduz trabalho repetido de produto; antes disso, `ST_DWithin` pode bastar muito bem.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- resolucao grossa demais mistura areas diferentes e piora matching;
- resolucao fina demais cria buckets vazios, mais churn de update e menos beneficio operacional;
- bordas entre celulas exigem vizinhanca e filtro final de distancia;
- oferta movel pede frescor, nao apenas indexacao bonita;
- analytics, dispatch e busca podem pedir resolucoes diferentes com o tempo.

Sinais de uso errado:

- voce trata a celula como resposta final e nunca confirma distancia real;
- a resolucao foi escolhida sem ligar para SLA, raio util ou densidade da cidade;
- localizacao muda a cada poucos segundos e o sistema nao pensou em churn, TTL ou deduplicacao;
- o produto quase nunca pergunta "o que esta perto?" mas o time quer um indice geoespacial porque parece sofisticado.

## Fechamento: Julgamento Arquitetural

Indice geografico bom nao e o mais inteligente na teoria. E o que traduz geografia em decisao operacional repetivel. A Uber nao usa H3 para provar que gosta de matematica; usa porque cidade, movimento e marketplace precisam de buckets estaveis para buscar, agrupar e decidir rapido ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/)). Para empresa menor, o julgamento certo e mais simples: se proximidade ainda e so um filtro ocasional, fique no banco. Se proximidade virou a pergunta central do produto, transforme coordenada em estrutura antes que cada query vire uma pequena negociacao com a CPU.

## Decision Synthesis

### Use When

- proximidade geografica e central para matching, busca, dispatch ou cobertura
- lat/long bruto ja nao cabe com conforto nas consultas principais
- a mesma pergunta espacial se repete bastante o suficiente para merecer bucketizacao

### Why This Case Used It

- a Uber precisava analisar e otimizar oferta, demanda e proximidade em escala de cidade ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/))
- H3 permitiu usar buckets hexagonais hierarquicos como unidade operacional para busca e analise ([H3: Uber's Hexagonal Hierarchical Spatial Index](https://www.uber.com/us/en/blog/h3/))
- a escolha do hexagono reduz erro de quantizacao e simplifica vizinhanca e aproximacao de raio ([Visualizing City Cores with H3](https://www.uber.com/ca/en/blog/visualizing-city-cores-with-h3/))

### Main Trade-offs

- precisao e custo dependem fortemente da resolucao escolhida
- entidades moveis aumentam churn de update e exigem frescor
- buckets aceleram o candidato inicial, mas nao substituem filtro exato

### Warning Signs

- a equipe usa celula espacial como se fosse distancia exata
- a resolucao nao conversa com densidade, SLA ou raio real do produto
- o problema principal ainda nao e proximidade recorrente, mas o time quer sofisticacao

### Decision Checklist

- qual pergunta espacial o produto realmente precisa responder rapido?
- em que ponto bucketizacao reduz custo sem estragar precisao?
- eu preciso de um indice operacional ou um filtro geografico simples no banco ainda basta?
- como vou lidar com vizinhanca, borda de celula e frescor da localizacao?

## Navigation

- [Prev](./chapter-11-cdn-placement-dns-and-cache-invalidation.md)
- [Index](./README.md)
- [Next](./chapter-13-critical-checkout-flows-and-auth-boundaries.md)
