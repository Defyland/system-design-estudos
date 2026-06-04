# Contrast 03 - Blob Store vs Relational Binary Storage

## Tension

Os dois guardam bytes, mas so um deles foi feito para viver com payload pesado por muito tempo.

## Use Blob Store When

- payload e grande
- lifecycle, durabilidade e custo importam
- arquivo quase nunca precisa mutar in-place

## Use Relational Binary Storage When

- o payload e pequeno e rarissimo
- atomicidade total com o registro vale mais do que custo e escalabilidade
- o produto ainda nao entrou em volume real de anexos

## Trap

- `Resposta ruim`: "se o banco ja existe, guardar binario nele simplifica para sempre".
- `Troque por isto`: simplifica cedo e cobra caro depois em backup, restore e custo.

## 15-Second Distinction

Banco coordena estado. Blob store aguenta peso e lifecycle.

## Pull Chapters

- [Chapter 03](../chapters/chapter-03-blob-durability-and-storage-tiers.md)
