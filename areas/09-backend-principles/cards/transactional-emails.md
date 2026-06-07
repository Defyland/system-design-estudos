# Transactional Emails

## When to Use

Use para efeitos externos disparados por eventos de produto: confirmacao de conta, recibo, reset de senha, alerta de seguranca e notificacao operacional.

## What Breaks First

Email dentro da transacao principal aumenta latencia, duplica envio em retry e deixa o usuario sem rastreabilidade quando o provedor falha.

## Interview Trap

Tratar email como detalhe de controller. Email transacional precisa de evento, template versionado, idempotencia, retry, status e auditoria.

## Practice Drill

Modele `order_paid`: grave o pedido, emita evento, enfileire email de recibo, evite duplicacao por chave e exponha status de entrega para suporte.

## Source Anchor

- [1. Roadmap for backend from first principles - Transactional emails](https://www.youtube.com/watch?v=0Rwb4Xmlcwc&t=1204s)
