# Bitly - URL Shortener

## Why this case matters

URL shortener e caso canonico de entrevista: IDs, redirect path, cache, abuso, analytics e leitura muito maior que escrita.

## Course topics

- ID generation
- cache
- redirect latency
- analytics pipeline
- abuse prevention

## Stack relevance

- Rails: high
- Elixir: medium
- Go: high

## Primary sources

- [Bitly Engineering Blog](https://bitly.com/blog/)
- [URL shortening overview](https://en.wikipedia.org/wiki/URL_shortening)

## What to extract

- separar create path de redirect path
- cachear redirects quentes sem perder controle de abuso
- enviar analytics para async pipeline
- discutir custom alias, expiracao e reputacao de URL

