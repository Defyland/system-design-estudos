# Canary and Rollback Checklist

## Use When

Quando uma mudanca de comportamento pode afetar caminho critico, consistencia, latencia ou custo.

## Canary

1. defina a menor coorte segura:
   - tenant
   - rota
   - payment method
   - cidade
   - producer
2. escolha a metrica principal
3. escolha a metrica de dano colateral
4. mantenha kill switch claro
5. deixe o caminho anterior vivo enquanto observa

## Rollback

1. qual foi a ultima mudanca material?
2. consigo reverter sem corromper estado?
3. qual parte fica ligada mesmo depois do rollback?
4. quem confirma que o sistema voltou ao baseline?

## Wrong Move

- canary grande demais
- rollback sem comparar com baseline
- desligar tambem as protecoes boas junto com a feature ruim
