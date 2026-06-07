# Capacity Planning and Headroom

## When to Use

Quando o sistema cresce, picos ja nao sao raros e a equipe precisa justificar capacidade, risco e custo antes de incidentes.

## What Breaks First

O time escala reativo demais, usa media em vez de percentil/pico e descobre limite real no meio do evento de negocio.

## Design Moves

Planeje por workload critico, headroom por camada, multiplicadores sazonais, dependencia compartilhada e tempo de recuperacao para nova capacidade.

## Interview Trap

Responder "auto scaling resolve". Escala automatica sem modelo de demanda e sem tempo de aquisicao ainda falha em pico.

## Practice Drill

Projete headroom para um checkout que faz 2k RPS normal e 8k RPS em campanha. Defina gatilhos, dependencia mais lenta e reserva minima.

## Source Anchor

- [Google SRE Workbook - Capacity Planning](https://sre.google/workbook/capacity-planning/).
- [AWS Well-Architected - Performance Efficiency](https://docs.aws.amazon.com/wellarchitected/latest/performance-efficiency-pillar/welcome.html).
