# Routing

## When to Use

Use routing para mapear uma combinacao de metodo e path para um handler claro, com parametros previsiveis e sem esconder regra de negocio.

## What Breaks First

Rotas ambguas, ordem dependente e handlers grandes tornam dificil saber quem responde por uma URL e onde uma regra deve mudar.

## Interview Trap

Colocar autorizacao de dominio ou decisao de negocio no roteador. Roteador escolhe destino; politica vive em boundary apropriado.

## Practice Drill

Desenhe rotas para `users`, `orders` e `order_items`. Marque quais parametros sao de path, query e body, e qual controller recebe cada caso.

## Source Anchor

- [6. What is Routing in Backend? How Requests Find Their Way Home](https://www.youtube.com/watch?v=SubuU1iOC2s)
