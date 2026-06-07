# Concurrency and Parallelism

## When to Use

Use concurrency para lidar com esperas simultaneas e parallelism para executar trabalho ao mesmo tempo em CPU ou workers diferentes.

## What Breaks First

Race condition, lock errado, pool saturado, deadlock, job duplicado e CPU-bound rodando no lugar que deveria apenas esperar IO.

## Interview Trap

Confundir IO-bound com CPU-bound. A solucao para esperar rede nao e a mesma para processar imagem, ranking ou compressao.

## Practice Drill

Classifique cinco tarefas: query DB, chamada HTTP, gerar PDF, enviar email, recalcular ranking. Diga qual usa concurrency, parallelism ou fila.

## Source Anchor

- [22. Concurrency & Parallelism: IO Bound vs CPU Bound](https://www.youtube.com/watch?v=bs9MEYRTA30)
