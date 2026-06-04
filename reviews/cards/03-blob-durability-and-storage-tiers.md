# Review Card 03 - Blob Durability and Storage Tiers

## Linked Material

- [Chapter 03](../../chapters/chapter-03-blob-durability-and-storage-tiers.md)
- [Lab 03](../../labs/chapters/chapter-03-blob-durability-and-storage-tiers.md)

## 15-Second Recall

- `Pergunta`: o que separa banco de blob store?
- `Resposta curta`: o banco guarda o mapa; o blob store aguenta o peso.

## Wrong Turn

- `Resposta ruim`: "se o banco ja tem metadata, pode guardar o arquivo inteiro tambem".
- `Troque por isto`: payload pesado pede storage com contrato de durabilidade, lifecycle e custo proprio.

## 1-Minute Answer

Blob grande vira objeto imutavel em storage proprio; metadata fica pequena e relacional. Tier frio entra depois, quando o padrao real de leitura permite restore mais lento.

## Transfer Check

- em empresa menor, comece com object storage gerenciado e lifecycle simples; nao invente Magic Pocket cedo
