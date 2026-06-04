# 04 - Edge, Rede e Acesso

## Por que esta area existe

Nem todo problema de system design mora no core do dominio. Muitos gargalos e protecoes vivem na borda, na rede e nos mecanismos de acesso.

## O que estudar aqui

- load balancing e roteamento
- DNS e estrategias de failover
- CDN, cache e invalidacao
- API gateway, WAF e rate limiting
- auth e controle de acesso

## O que foi absorvido

- explicacoes basicas demais de DNS
- subpastas pequenas para auth, WAF e gateway sem material suficiente

## Regra de implementacao

- Rails primeiro para auth, throttle e cache
- Go depois se o experimento precisar ensinar proxy, edge service ou limiting de alta taxa
