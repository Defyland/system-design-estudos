# Notes

## Modelo mental

Backend e o caminho controlado entre uma intencao externa e um efeito seguro no sistema. Um request entra sem confianca, passa por protocolo, roteamento, auth, validacao, regra de negocio, persistencia, efeitos colaterais e observabilidade.

## Pipeline pratico

| Etapa | Pergunta senior | Armadilha |
| --- | --- | --- |
| HTTP | qual contrato chegou? | tratar header, metodo e status como detalhe |
| routing | quem deve receber esse request? | espalhar regra de negocio no roteador |
| auth/authz | quem e voce e o que pode fazer? | autenticar e esquecer permissao |
| validacao | qual dado entra no dominio? | validar tarde demais |
| service/repository | quem decide e quem persiste? | controller virar script gigante |
| database | qual invariante o banco protege? | confiar so em validacao de app |
| cache/job/search | qual caminho ficou caro ou assincrono? | adicionar infra antes de medir dor |
| emails/webhooks/files/realtime | qual efeito sai do request principal? | misturar entrega externa com transacao core |
| observabilidade | como sei que quebrou? | logar muito e nao responder nada |
| testes/contratos/devops | como provo e opero mudanca? | confiar em deploy heroico |

## Ordem de estudo

1. Entenda o caminho do request: HTTP, routing, serialization.
2. Proteja a fronteira: auth, authorization, validation.
3. Organize o codigo: controllers, services, repositories, middleware e context.
4. Modele contratos e dados: REST, Postgres, cache.
5. Tire trabalho do request: jobs, search, emails e scheduling.
6. Modele efeitos externos: object storage, realtime, webhooks e OpenAPI.
7. Opere em producao: errors, config, logs, graceful shutdown, security, DevOps.
8. Escale com evidencia: performance, concurrency e backpressure.

## QDSAA: gaps que ficaram depois da primeira versao

- `Question`: a area nao precisa virar nova trilha; ela precisa completar fundamentos que aparecem antes de system design.
- `Delete`: nao importar artigos inteiros nem criar um diretório por blog agora.
- `Simplify`: cada lacuna vira um card curto com drill pratico.
- `Accelerate`: engineering blogs entram como mapa de leitura para escolher proximos casos sem travar a area.
- `Automate Last`: so automatizar coleta de posts depois que o mapa manual provar quais fontes realmente rendem estudo.

## Entrevista

Resposta boa nao lista frameworks. Ela mostra o fluxo, declara invariantes, separa efeito sincrono de efeito assincrono e diz qual sinal provaria que a decisao esta errada.
