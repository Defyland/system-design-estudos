# Chapter 11 - CDN Placement, DNS and Cache Invalidation

## Slice

Como decidir o que merece ficar perto do usuario, quem escolhe o caminho ate esse cache e quando invalidar e mais caro do que versionar.

## Historia de Produto

Seu PO quer home rapida em Sao Paulo, landing page boa na Europa e video sem travar em horario de pico. A parte ingenua da conversa termina em "poe CDN". A parte adulta comeca quando voce precisa escolher o que vai para edge, como usuarios sao roteados e como impedir que conteudo velho sobreviva mais do que deveria.

## Onde Isso Aparece Antes da Teoria

- midia, assets, HTML cacheavel e APIs publicas com audiencia distribuida
- produtos em que a latencia de entrega pesa mais que o compute da origem
- sistemas em que refresh de conteudo e parte do contrato de produto

## Case Anchors

- [Netflix - Open Connect CDN](../real-world-cases/04-edge-and-delivery/netflix-open-connect-cdn/README.md)
- [Cloudflare - Edge Platform](../real-world-cases/04-edge-and-delivery/cloudflare-edge-platform/README.md)
- [Meta - Video Delivery](../real-world-cases/04-edge-and-delivery/meta-video-delivery/README.md)

## Foco em Entrevistas

- como falar de placement sem resumir tudo a "mais perto do usuario"
- qual a diferenca pratica entre TTL, versionamento, purge e stale strategy
- onde DNS, peering e roteamento entram de verdade no design

## Study Links

- [Area - Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/README.md)
- [Notes - Edge, Rede e Acesso](../areas/04-edge-rede-e-acesso/notes.md)
- [Lab](../labs/chapters/chapter-11-cdn-placement-dns-and-cache-invalidation.md)

## A Tensao Real

CDN quase sempre entra na conversa como "cache na frente". Os casos bons mostram que isso esta incompleto. A Netflix criou o Open Connect em 2011 nao so para baixar latencia, mas para trabalhar direto com ISPs e usar um modelo de cache proativo e dirigido que reduz demanda upstream em varias ordens de magnitude ([Netflix Open Connect Overview](https://openconnect.netflix.com/Open-Connect-Overview.pdf)).

Isso muda a pergunta arquitetural. Nao e apenas "onde coloco cache?". E "quais objetos merecem placement fisico dedicado, quem decide o roteamento ate eles e como cada tipo de conteudo envelhece?". A resposta para video sob pico nao e igual a resposta para asset versionado ou para HTML que muda a cada deploy.

### Fixacao Relampago 1

- `Pergunta`: qual pergunta boa de cache vem antes de "qual TTL eu uso?"?
- `Resposta com as suas palavras`: quem consome isso, por quanto tempo isso continua valido e em qual camada vale guardar mais.
- `Resposta ruim que parece boa`: "cache e so um numero de segundos na frente da resposta".
- `Troque por isto`: placement, roteamento e freshness andam juntos; TTL sozinho nao explica o desenho.

## Contexto e Constraints do Caso Real

O Open Connect deixa o placement muito concreto. A Netflix opera milhares de OCAs, implantados tanto em IXPs quanto diretamente dentro de redes de ISPs. No modelo embarcado, os ISPs controlam quais clientes sao roteados para seus OCAs, enquanto peering continua servindo para resiliencia e para o processo de `fill` e atualizacao noturna ([Netflix Open Connect Overview](https://openconnect.netflix.com/Open-Connect-Overview.pdf)). Em outras palavras: placement e roteamento nao sao detalhes da app; sao parte do acordo fisico de entrega.

A Meta mostra outro constraint importante: a forma de consumo muda o desenho do cache. Eles descrevem que live streams recebem a maior parte do watch time durante a transmissao ou poucas horas depois, enquanto VOD pode ganhar cauda longa muito depois da publicacao ([Meta encoding](https://engineering.fb.com/2021/04/05/video-engineering/how-facebook-encodes-your-videos/)). No evento da final da Champions League citado, a plataforma viu pico de 7,2 milhoes de viewers concorrentes em duas transmissoes de Facebook Live e precisou reforcar ingestao e entrega para absorver a avalanche de misses e acessos simultaneos na borda ([Meta live streaming](https://engineering.fb.com/2020/10/22/video-engineering/live-streaming/)).

Cloudflare acrescenta o constraint de controle. O artigo de `CDN-Cache-Control` mostra que o mesmo objeto pode precisar de TTLs diferentes em browser, no edge da Cloudflare e em outros CDNs, sem misturar tudo em um unico `Cache-Control` ([Cloudflare CDN-Cache-Control](https://blog.cloudflare.com/cdn-cache-control/)). Esse e o detalhe que muita resposta de entrevista esquece: invalidacao nao e so `purge all`. As vezes a decisao certa e separar TTL por camada e deixar asset imutavel viver muito mais tempo do que a pagina que o referencia.

## Decisao Tomada

A decisao canonica aqui e combinar placement, roteamento e freshness como um unico desenho:

1. conteudo repetido e pesado vai para o edge o mais perto possivel do consumo;
2. roteamento e DNS escolhem o caminho ate esse cache com base em geografia, rede e disponibilidade;
3. assets imutaveis preferem versionamento e TTL longo;
4. conteudo mutavel prefere TTL curto, `stale-while-revalidate` ou purge cirurgico;
5. live, VOD e resposta personalizada recebem politicas diferentes, porque o padrao de miss e o custo do erro tambem sao diferentes.

Netflix e o caso extremo de placement fisico. Meta mostra por que o tipo de video muda o lifetime util do cache. Cloudflare mostra que controlar TTL por camada e parte da solucao, nao perfumaria.

### Fixacao Relampago 2

- `Pergunta`: quando versionamento vale mais do que purge?
- `Resposta com as suas palavras`: quando o objeto e imutavel. A invalidacao vira o nome novo do arquivo.
- `Resposta ruim que parece boa`: "purge all a cada deploy e mais simples".
- `Troque por isto`: purge em massa desperdica hit ratio e cria miss storm justamente quando o trafego sobe.

## Rails First

Empresa menor nao precisa desenhar Open Connect. Precisa emitir cabecalhos corretos, versionar assets e saber quando o cache da CDN pode ser bem mais agressivo do que o do browser.

```rb
class PublicAssetsController < ApplicationController
  def show
    asset = MarketingAsset.published.find(params[:id])

    fresh_when(
      etag: asset.cache_key_with_version,
      last_modified: asset.updated_at,
      public: true
    )

    expires_in 10.minutes, public: true
    response.headers["CDN-Cache-Control"] = "max-age=86400, stale-while-revalidate=60"
    response.headers["Cloudflare-CDN-Cache-Control"] = "max-age=604800"

    render json: {
      id: asset.id,
      title: asset.title,
      url: asset.versioned_url
    }
  end
end
```

O desenho do snippet e simples de proposito. Browser recebe vida curta porque pode haver troca de referencia. A CDN pode segurar muito mais porque o objeto foi versionado. Se voce estiver servindo HTML editorial que muda com frequencia, talvez o TTL do edge seja curto e a invalidacao seja pontual. Se estiver servindo asset com fingerprint, purge vira excecao, nao rotina.

## Stack Translation

- `Rails first`: headers corretos, asset fingerprint e invalidacao cirurgica ja compram quase todo o valor para produto menor.
- `Quando Elixir ensina mais`: quando fluxos de purge, revalidacao ou entrega concorrente de midia pedem coordenacao viva e supervisionada.
- `Quando Go ensina mais`: quando edge proxy, cache-fill daemon ou control plane de cache comeca a importar mais do que renderizacao web.

## Por Que Nao Outra Abordagem

Nao "purge tudo a cada deploy" porque isso joga fora o ganho principal do cache e cria janelas de miss em massa exatamente nos momentos de pico.

Nao "um TTL unico para todas as camadas" porque browser, edge e outros CDNs podem ter necessidades diferentes. O proprio exemplo da Cloudflare existe para separar esses horizontes de cache de forma explicita ([Cloudflare CDN-Cache-Control](https://blog.cloudflare.com/cdn-cache-control/)).

Nao "cacheia qualquer resposta" porque personalizacao, auth e variacao por usuario destroem hit ratio e aumentam risco de vazamento.

Nao "monta CDN propria" porque placement fisico dentro de ISP, peering e capacidade global fazem sentido quando trafego, geografia e custo de transit ja viraram problema material. Antes disso, um CDN gerenciado com politicas boas compra quase todo o valor.

## Traducao Explicita Para Empresa Menor

Empresa menor normalmente deveria copiar a ordem mental, nao a topologia:

- use um CDN gerenciado para assets, imagens e respostas publicas de alto reuse;
- versione assets imutaveis e deixe a CDN segurar bastante;
- mantenha HTML e API cacheavel com TTL conservador e regras claras de revalidacao;
- trate purge como ferramenta cirurgica para conteudo mutavel ou incidente editorial;
- pense em geografia e roteamento apenas quando a audiencia e distribuida o suficiente para isso aparecer em latencia, custo ou erro.

Se sua audiencia esta quase toda em uma regiao e a origem responde bem, nao existe vergonha nenhuma em um desenho bem mais simples. O erro e comprar complexidade global antes de ter dor global.

### Fixacao Relampago 3

- `Pergunta`: quando vale pensar em georouting mais serio?
- `Resposta com as suas palavras`: quando audiencia, custo ou erro ja mudam de verdade entre regioes.
- `Resposta ruim que parece boa`: "todo produto na internet precisa de estrategia global desde cedo".
- `Troque por isto`: complexidade geografica se compra quando a dor geografica aparece, nao por ansiedade.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- caches mais proximos reduzem latencia e custo, mas tornam freshness mais delicado;
- versionamento simplifica invalidacao, mas pede disciplina de publicacao;
- TTL curto reduz stale, mas derruba hit ratio e aumenta pressao na origem;
- multi-CDN, DNS e placement fisico aumentam muito a superficie operacional.

Sinais de uso errado:

- todo deploy vem com `purge all`;
- o time nao sabe diferenciar objeto imutavel de conteudo editorial mutavel;
- resposta personalizada esta indo para cache publico por acidente;
- o cache key inclui variacao demais e mata hit ratio, ou de menos e vaza resposta;
- voces estao discutindo private CDN antes de dominar `Cache-Control`, `ETag` e versionamento.

## Fechamento: Julgamento Arquitetural

O ponto forte deste chapter e simples: CDN nao e um produto que voce "coloca". E uma politica de distancia, roteamento e envelhecimento. Netflix mostra o extremo em que placement fisico dentro do caminho de rede faz sentido. Meta mostra que o comportamento do conteudo muda a politica de cache. Cloudflare mostra que controlar freshness por camada e uma parte essencial da honestidade do sistema. Quando voce escolhe bem o que merece edge e como aquilo envelhece, a CDN para de ser "um cache na frente" e vira parte do design do produto.

## Decision Synthesis

### Use When

- o mesmo conteudo precisa ser entregue para muita gente em geografia ampla
- latencia de entrega e custo de transit pesam mais do que compute da origem
- freshness, versionamento e invalidacao influenciam a experiencia do usuario

### Why This Case Used It

- a Netflix precisava localizar trafego e reduzir dependencia de upstream com placement proativo
- a Meta precisava lidar com perfis de consumo muito diferentes entre live e VOD
- a Cloudflare precisava dar controle fino de TTL entre camadas de cache

### Main Trade-offs

- placement e caches mais fortes aumentam complexidade de freshness
- conteudo mutavel ou personalizado reduz eficiencia do CDN
- DNS, peering e multi-layer cache exigem mais operacao e mais criterio

### Warning Signs

- voce esta usando purge global como fluxo normal
- a maioria da resposta e personalizada e quase nada e realmente cacheavel
- a audiencia nao e distribuida e a origem ainda nao e o gargalo de entrega

### Decision Checklist

- este objeto e realmente repetido e cacheavel?
- ele deveria ser versionado ou purgado?
- browser, edge e outros CDNs precisam do mesmo TTL?
- o ganho de latencia e custo justifica a complexidade de placement e roteamento?

## Navigation

- [Prev](./chapter-10-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Index](./README.md)
- [Next](./chapter-12-geospatial-indexing-for-marketplace-search.md)
