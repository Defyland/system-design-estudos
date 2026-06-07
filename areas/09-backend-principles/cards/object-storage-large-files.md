# Object Storage and Large Files

## When to Use

Use object storage para arquivos grandes, blobs, anexos, imagens, videos e exports que nao devem morar como bytes no banco transacional.

## What Breaks First

Upload preso no request principal estoura timeout, arquivo sem metadata fica orfao e permissao mal desenhada vaza objeto privado.

## Interview Trap

Falar "S3 resolve" sem fluxo. Backend precisa coordenar metadata, upload direto ou indireto, assinatura, virus scan, lifecycle e permissao.

## Practice Drill

Desenhe upload de invoice PDF: cria metadata, gera signed URL, cliente envia arquivo, job valida, atualiza status e expira objeto abandonado.

## Source Anchor

- [1. Roadmap for backend from first principles - Object storage and large files](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1667s)
