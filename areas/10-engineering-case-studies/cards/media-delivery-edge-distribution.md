# Media Delivery and Edge Distribution

## Case Pattern

Media delivery separa control plane, encoding pipeline, storage origin, edge placement, client steering e observabilidade de playback. O objetivo e qualidade percebida com custo controlado e baixa latencia.

## When to Use

- Conteudo grande precisa chegar perto do usuario.
- Bitrate, codec ou device capability mudam experiencia.
- Origin nao pode receber todo trafego.
- Cache/CDN precisa invalidacao, pre-positioning ou fallback.

## What Breaks First

Cache miss explode origin, manifest aponta variante ruim, edge fica sem objeto quente, invalidacao demora, cliente escolhe bitrate acima da rede ou encoding pipeline atrasa publicacao.

## Interview Trap

Desenhar CDN como caixa magica. Resposta forte separa ingestao, transcode, manifest, armazenamento, edge fill, request steering, DRM se existir, metricas de startup/buffering e fallback.

## Practice Drill

Modele entrega de video sob demanda. Defina upload, encoding adaptativo, object storage, manifest, CDN fill, escolha de bitrate, invalidacao e metricas de qualidade de experiencia.

## Source Anchor

- Netflix, [Open Connect](https://openconnect.netflix.com/).
- Netflix, [Open Connect: Celebrating a Decade of Smooth and Efficient Streaming](https://about.netflix.com/news/open-connect-celebrating-a-decade-of-smooth-and-efficient-streaming).
- Netflix Tech Blog, [Rebuilding Netflix Video Processing Pipeline with Microservices](https://netflixtechblog.com/rebuilding-netflix-video-processing-pipeline-with-microservices-4e5e6310e359).
- Meta, [Owl: Distributing content at Meta scale](https://engineering.fb.com/2022/07/14/data-infrastructure/owl-distributing-content-at-meta-scale/).
