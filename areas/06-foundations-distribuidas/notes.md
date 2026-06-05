# Notes

## Modelo mental

Foundations distribuidas existem para impedir resposta magica. Sempre que alguem promete consistencia perfeita, ordenacao global ou ausencia de conflito sem custo, procure a coordenacao escondida.

## Matriz rapida

| Tema | Use para explicar | Armadilha |
| --- | --- | --- |
| CAP | trade-off sob particao | usar CAP para justificar qualquer coisa |
| relogios logicos | causalidade sem relogio fisico confiavel | confundir timestamp com verdade |
| 2PC | commit atomico entre participantes | ignorar bloqueio e coordinator failure |
| consenso | acordo sob falha | usar quando idempotencia bastaria |
| deadlock | espera circular por recurso | culpar banco sem olhar ordem de lock |

## Entrevista

Use foundations quando o entrevistador pedir garantias. Resposta senior troca "eu usaria Kafka/Postgres/Redis" por "qual garantia eu preciso, qual coordenacao ela custa e qual falha ainda sobra".

