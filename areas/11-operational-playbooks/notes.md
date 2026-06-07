# Notes

## Modelo mental

Playbook bom nao tenta explicar tudo. Ele reduz variabilidade na primeira resposta: sinal, dono, acao inicial, estabilizacao, verificacoes profundas, criterio de saida e follow-up obrigatorio.

## Fluxo operacional

1. Detectar impacto real no usuario.
2. Declarar severidade e dono do incidente.
3. Estabilizar antes de otimizar.
4. Preservar evidencias e bloquear novas ampliacoes do problema.
5. Recuperar com caminho reversivel.
6. Fechar somente quando o sistema e o aprendizado estiverem claros.

## O que estes playbooks cobrem

- incidentes e triagem de severidade;
- migracoes e backfills sem downtime;
- filas com lag, DLQ e replay;
- cache sob hot keys e overload de origin;
- busca com freshness ruim ou reindex em curso;
- rollback, kill switch e rollout interrompido;
- DR, failover e failback;
- seguranca operacional, vazamento de secret e rotacao.

## Definicao de pronto

- cada playbook diz o que fazer nos primeiros minutos;
- estabilizacao e diagnostico profundo aparecem separados;
- existe criterio de saida objetivo;
- existe drill pratico para treino repetivel;
- existe ao menos um anchor externo verificavel.
