# Validation and Transformation

## When to Use

Use na fronteira para rejeitar input invalido cedo e transformar dados externos em forma interna segura para o dominio.

## What Breaks First

Validacao espalhada cria divergencia: API aceita um shape, service espera outro e banco segura o erro tarde demais.

## Interview Trap

Validar so presença. Backend senior valida formato, tamanho, range, enum, ownership, transicao de estado e invariantes do banco.

## Practice Drill

Modele validacao de cadastro: normalize email, rejeite nome vazio, limite tamanho, valide senha, e diga qual constraint tambem fica no banco.

## Source Anchor

- [9. Validations and transformations for backend engineers](https://www.youtube.com/watch?v=qedj_JjjL-U)
