# Review Card 08 - Blob Durability and Storage Tiers

## Linked Material

- [Chapter 08](../../chapters/chapter-08-blob-durability-and-storage-tiers.md)
- [Lab 08](../../labs/chapters/chapter-08-blob-durability-and-storage-tiers.md)

## Anchor

- `Problema`: o sistema quer guardar bytes pesados como se fossem mais uma linha relacional.
- `Decisao`: separar metadata relacional de blob imutavel em object storage, e deixar tiering entrar so depois.

## Case Anchor

- `Caso real`: [Dropbox - Magic Pocket Blob Store](../../real-world-cases/02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)
- `Lembrete`: banco guarda o mapa; storage aguenta o peso e o lifecycle do byte grande.

## QDSAA Recall

- `Requirement corrigido`: o problema nao e "guardar um arquivo"; e guardar bytes com durabilidade e custo coerentes.
- `Delete`: copia inutil e uso errado do banco para payload pesado.
- `Forma simples`: metadata no relacional, blob no object store.

## Trade-off to Remember

- `Custo`: consistencia entre metadata e blob fica mais explicita, e lifecycle adiciona operacao.
- `Failure mode`: restore falha so quando o arquivo frio volta a ser pedido.

## Trap

- `Resposta ruim`: "se o banco ja tem metadata, pode guardar o arquivo inteiro tambem".
- `Troque por isto`: payload pesado pede storage com contrato de durabilidade, lifecycle e custo proprio.

## 1-Minute Answer

Blob grande vira objeto imutavel em storage proprio; metadata fica pequena e relacional. Tier frio entra depois, quando o padrao real de leitura permite restore mais lento.
