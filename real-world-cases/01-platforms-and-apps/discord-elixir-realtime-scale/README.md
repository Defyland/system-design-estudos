# Discord - Elixir Realtime Scale

## Why this case matters

Caso obrigatorio para entender concorrencia, realtime e os limites praticos do ecossistema BEAM em producao.

## Course topics

- concorrencia e paralelismo
- filas e eventos em tempo real
- resiliencia
- observabilidade
- gargalos e bottlenecks

## Stack relevance

- Rails: low
- Elixir: very high
- Go: medium

## Primary sources

- [How Discord Scaled Elixir to 5,000,000 Concurrent Users](https://pax.discord.com/blog/how-discord-scaled-elixir-to-5-000-000-concurrent-users)
- [Using Rust to Scale Elixir for 11 Million Concurrent Users](https://discord.com/blog/using-rust-to-scale-elixir-for-11-million-concurrent-users)
- [Maxjourney: Pushing Discord's Limits with a Million+ Online Users in a Single Server](https://discord.com/blog/maxjourney-pushing-discords-limits-with-a-million-plus-online-users-in-a-single-server)
- [Tracing Discord's Elixir Systems (Without Melting Everything)](https://discord.com/blog/tracing-discords-elixir-systems-without-melting-everything)

## What to extract

- escolha do BEAM para workloads realtime
- isolamento por unidade de trabalho
- onde Elixir brilhou e onde precisou de ajuda externa
- como observar um sistema altamente concorrente

