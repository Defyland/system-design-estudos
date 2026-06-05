# First Principles Design Pass

Use isto antes de escolher tecnologia, componente ou topologia.

## Template

- `Requirement Less Dumb`: qual requisito parece forte no papel, mas talvez seja exagerado, legado ou medo?
- `Delete`: qual passo, fluxo, componente ou regra eu tentaria remover primeiro?
- `Simplify`: qual e a menor forma que ainda entrega o comportamento certo?
- `Accelerate`: como eu testo, observo, comparo e reverto isso rapido?
- `Automate Last`: o que eu deixo manual ou semi-manual ate o desenho ficar estavel?

## O que uma boa resposta parece

- comeca pelo problema e pelo requisito real
- adia componente caro ate ele se pagar
- escolhe o desenho menor que ainda segura o caso
- fala de metrica, rollback e ciclo de aprendizado
- automatiza por ultimo

## Armadilha comum

- `Resposta ruim`: "o sistema e grande, entao deve ter Kafka, Redis, CDN, workflow engine e microservicos."
- `Troque por isto`: "primeiro eu provo a necessidade de cada camada; sem isso, eu estou automatizando e distribuindo adivinhacao."
