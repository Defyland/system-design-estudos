# Privacy and Data Governance

## Case Pattern

Privacidade em escala precisa virar infraestrutura: classificacao de dados, lineage, anotacoes, purpose limitation, enforcement em runtime, auditoria e tooling para o desenvolvedor. ACL isolada nao acompanha fluxo de dados moderno.

## When to Use

- Dados pessoais atravessam servicos, pipelines, logs e modelos.
- Um mesmo dado pode ter usos permitidos e proibidos.
- Compliance depende de auditoria manual de codigo ou tabela.
- Times precisam inovar sem reinventar controles de privacidade.

## What Breaks First

Dados sao copiados para sinks sem contexto, logs preservam campo sensivel, jobs batch combinam propositos incompativeis, e correcoes exigem varrer centenas de sistemas manualmente.

## Interview Trap

Falar apenas "criptografa e limita acesso". Resposta forte diferencia acesso, uso permitido, propagacao, lineage, minimizacao e enforcement.

## Practice Drill

Pegue um campo `user_location`. Liste fontes, sinks, propositos permitidos, logs, modelos e dashboards. Defina uma anotacao de dado e uma regra que bloqueia gravacao em sink nao autorizado.

## Source Anchor

- Meta, [How Meta enforces purpose limitation via Privacy Aware Infrastructure at scale](https://engineering.fb.com/2024/08/27/security/privacy-aware-infrastructure-purpose-limitation-meta/).
- Meta, [How Meta understands data at scale](https://engineering.fb.com/2025/04/28/security/how-meta-understands-data-at-scale/).
- Airbnb, [Production Secret Management at Airbnb](https://medium.com/airbnb-engineering/production-secret-management-at-airbnb-ad230e1bc0f6).
- Uber, [Adding Determinism and Safety to Uber IAM Policy Changes](https://www.uber.com/en-IN/blog/adding-determinism-and-safety-to-uber-iam-policy-changes/).
