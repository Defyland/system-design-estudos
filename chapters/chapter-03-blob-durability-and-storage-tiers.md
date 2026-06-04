# Chapter 03 - Blob Durability and Storage Tiers

## Slice

Como um blob store real equilibra durabilidade, replicacao, custo e cold storage.

## Historia de Produto

Seu PO quer upload de arquivos, anexos e historico longo. No comeco tudo cabe "em algum lugar". Depois o custo sobe, o restore vira medo e a pergunta muda: "onde termina metadata e onde comeca blob de verdade?".

## Onde Isso Aparece Antes da Teoria

- produtos com anexos, midia, documentos ou backups
- fluxos em que o payload e grande, pouco mutavel e valioso demais para perder
- sistemas em que custo de storage importa tanto quanto latencia

## Case Anchors

- [Dropbox - Magic Pocket Blob Store](../real-world-cases/02-data-storage-and-search/dropbox-magic-pocket-blob-store/README.md)

## Foco em Entrevistas

- por que blob store nao e so "mais uma tabela com binario"
- como separar metadata, durabilidade e lifecycle de armazenamento
- quando hot, warm e cold storage realmente mudam o design

## Study Links

- [Area - Dados e Armazenamento](../areas/02-dados-e-armazenamento/README.md)
- [Notes - Dados e Armazenamento](../areas/02-dados-e-armazenamento/notes.md)
- [Lab](../labs/chapters/chapter-03-blob-durability-and-storage-tiers.md)

## A Tensao Real

O erro mais caro aqui e tratar blob como se fosse so "mais uma coluna grande". Nao e. O dia em que voce junta metadata transacional, payload pesado, replicacao e lifecycle no mesmo lugar costuma ser o dia em que backup fica lento, restore fica assustador e cada decisao de custo ameaca confiabilidade.

Dropbox resolveu esse problema separando explicitamente duas coisas: metadata de arquivos e conteudo dos arquivos. Em 2016, a empresa relatava mais de 500 PB de dados de usuario e dizia com todas as letras que havia dois tipos de dado no sistema: metadata sobre arquivos e usuarios, e file content ([Scaling to exabytes and beyond](https://dropbox.tech/infrastructure/magic-pocket-infrastructure)). A licao pratica nao e "construa seu proprio S3". E "nao misture responsabilidades que exigem ritmos diferentes de durabilidade, mutabilidade e custo".

### Fixacao Relampago 1

- `Pergunta`: qual e o erro mais comum quando o produto comeca a lidar com arquivos grandes?
- `Resposta com as suas palavras`: tratar blob como se fosse mais uma coluna do banco principal.
- `Resposta ruim que parece boa`: "guardar no Postgres simplifica, entao vamos manter tudo la".
- `Troque por isto`: metadata continua perto da transacao; o blob vai para storage desenhado para volume, durabilidade e ciclo de vida proprio.

## Contexto e Constraints do Caso Real

No Magic Pocket, o blob store foi desenhado como armazenamento imutavel por blocos. Cada bloco criptografado tem ate 4 MB e, depois de escrito, nunca muda; a mutabilidade sobe para outra camada, o FileJournal, que registra como os arquivos evoluem ao longo do tempo ([Inside the Magic Pocket](https://dropbox.tech/infrastructure/inside-the-magic-pocket)). Essa separacao simplifica muito a vida: voce deixa o storage fazer bem aquilo que storage sabe fazer e deixa a semantica de "arquivo editado" para cima da pilha.

O segundo constraint era escala sem perder isolamento. O Magic Pocket organiza capacidade em cells logicas autocontidas, com algo em torno de 50 PB de dados brutos por cell; cada cell tem um master fora do data plane, OSDs para armazenamento e tabelas de replicacao menores em MySQL para mapear volumes e buckets ([Inside the Magic Pocket](https://dropbox.tech/infrastructure/inside-the-magic-pocket)). Quando um OSD falha, o sistema dispara repair depois de 15 minutos offline, rapido o bastante para reduzir vulnerabilidade, sem sair re-replicando por qualquer soluco da maquina ([Inside the Magic Pocket](https://dropbox.tech/infrastructure/inside-the-magic-pocket)).

So que durabilidade extrema custa caro. Por isso o time introduziu dois tiers: warm e cold. O cold storage migra dados em background quando eles esfriam, preserva durabilidade, aceita ligeiro aumento de latencia e tolera pausar writes porque os writes do usuario continuam entrando no warm tier ([How we optimized Magic Pocket for cold storage](https://dropbox.tech/infrastructure/how-we-optimized-magic-pocket-for-cold-storage)). Dropbox rejeitou uma solucao de erasure coding global unico entre regioes porque um unico software instance aumentando demais a superficie de bug violava a promessa pratica de durabilidade. Preferiu uma arquitetura em camadas e mais simples, com regioes independentes e multiplas validacoes antes de purgar a copia original ([How we optimized Magic Pocket for cold storage](https://dropbox.tech/infrastructure/how-we-optimized-magic-pocket-for-cold-storage)).

## Decisao Tomada

A decisao canonica aqui e clara:

1. blob grande vira objeto imutavel, nao linha mutante;
2. metadata operacional fica separada e pequena;
3. write entra no tier quente onde disponibilidade e simples;
4. lifecycle move o dado frio de forma assincrona;
5. purga so acontece depois de validacao, nunca por fe.

O ponto forte do caso Dropbox e que custo entra depois da semantica correta, nao antes. Eles primeiro garantem durabilidade e recuperacao; depois usam tiering para capturar economia. No exemplo de cold tier com tres regioes, a empresa relata 25% de reducao de uso de disco frente ao warm tier equivalente ([How we optimized Magic Pocket for cold storage](https://dropbox.tech/infrastructure/how-we-optimized-magic-pocket-for-cold-storage)).

### Fixacao Relampago 2

- `Pergunta`: o que vai para o banco e o que vai para o bucket?
- `Resposta com as suas palavras`: o banco guarda o mapa; o bucket guarda o peso.
- `Resposta ruim que parece boa`: "se o banco sabe do arquivo, ele deveria guardar o arquivo tambem".
- `Troque por isto`: o banco precisa saber quem e o objeto e como encontra-lo; nao precisa carregar cada byte dele.

## Rails First

Para um produto Rails, a regra pratica e mais simples do que o caso Dropbox e ainda assim muito melhor do que enfiar blob no Postgres: metadata no banco relacional, payload no object storage, tier inicial quente e migracao fria controlada por lifecycle.

```rb
class Uploads::CreateBlob
  def initialize(storage: ObjectStorage)
    @storage = storage
  end

  def call!(account:, io:, filename:, checksum_sha256:, byte_size:)
    blob = account.blobs.create!(
      filename: filename,
      byte_size: byte_size,
      checksum_sha256: checksum_sha256,
      storage_tier: "warm",
      state: "pending"
    )

    key = "warm/#{account.id}/#{blob.id}"
    @storage.put(
      bucket: ENV.fetch("WARM_BLOB_BUCKET"),
      key: key,
      io: io,
      checksum_sha256: checksum_sha256
    )

    blob.update!(storage_key: key, state: "stored")
    BlobLifecycleJob.set(wait: 30.days).perform_later(blob.id)

    blob
  end
end
```

Esse desenho nao tenta imitar cells, OSDs ou repair protocols. So preserva o principio certo: metadata e blob nao brigam pelo mesmo contrato. Se voce mais tarde quiser cold tier, adicione `storage_tier`, migracao assincrona e verificacao de integridade antes de apagar a copia quente.

## Stack Translation

- `Rails first`: metadata no SQL, upload para object storage e lifecycle jobs controlando tier e integridade.
- `Quando Elixir ensina mais`: quando copia, verificacao e promocao de blobs viram muitos fluxos concorrentes que precisam de supervisao limpa.
- `Quando Go ensina mais`: quando checksum, multipart upload, replicacao e movers de storage ficam throughput-heavy de verdade.

## Production Mode

### What Breaks First

- lifecycle movendo arquivo quente cedo demais
- checksum ou restore falhando so quando o arquivo e pedido de volta

### Signals to Watch

- restore latency p95
- taxa de checksum mismatch
- `not found` depois de tier move

### Safe Rollout

- mova primeiro uma coorte pequena
- verifique restore e checksum antes de purgar a copia quente

### Rollback Trigger

- restore SLA quebrado
- objeto frio indisponivel ou inconsistente

### First 15 Minutes

- pause lifecycle e purge
- force restore de amostra
- mantenha leitura no tier quente enquanto mede o dano

### Fixacao de Producao

- `Pergunta`: qual erro operacional mais trai o storage frio?
- `Resposta com as suas palavras`: descobrir o problema so na hora de restaurar, quando o usuario ja esta esperando.
- `Resposta ruim que parece boa`: "se moveu e ocupou menos disco, esta tudo certo".
- `Troque por isto`: storage so prova durabilidade quando restaurar ainda funciona no tempo certo.

## Por Que Nao Outra Abordagem

Nao "guarda tudo no banco principal" porque banco transacional foi feito para coordenar estado, nao para ser o lugar ideal de durabilidade barata para payloads enormes.

Nao "escreve direto no cold tier" porque o proprio Dropbox separa write path quente do lifecycle frio. Cold e otimizado para custo, nao para virar o primeiro lugar onde a request do usuario pousa ([How we optimized Magic Pocket for cold storage](https://dropbox.tech/infrastructure/how-we-optimized-magic-pocket-for-cold-storage)).

Nao "uma so camada global super inteligente" porque a equipe Dropbox passou por isso e recuou. Quando a arquitetura para economizar custo aumenta demais a chance de bug sistemico, ela trai a meta principal do storage: nao perder dado ([How we optimized Magic Pocket for cold storage](https://dropbox.tech/infrastructure/how-we-optimized-magic-pocket-for-cold-storage)).

## Traducao Explicita Para Empresa Menor

Empresa menor quase sempre deve comprar storage em vez de construir storage. Mas deve desenhar o produto como se entendesse storage.

A traducao pratica costuma ser:

- Postgres para metadata pequena, ownership e referencias;
- S3, GCS ou equivalente para o blob em si;
- classe quente padrao para uploads novos;
- regra de lifecycle para mover arquivos frios depois de dias ou semanas;
- verificacao de checksum e restore de amostra antes de confiar no tier frio.

Se o produto exige mutabilidade aparente, faca versionamento ou novos objetos. Nao sobrescreva payload como se fosse um campo qualquer. E se um dia um worker em Go passar a cuidar da migracao de tiers, o ganho nao vem do Go. Vem do fato de a camada de storage ja estar separada do resto.

### Fixacao Relampago 3

- `Pergunta`: quando tier frio faz sentido?
- `Resposta com as suas palavras`: quando o arquivo quase nao e lido e eu aceito restore mais lento em troca de custo menor.
- `Resposta ruim que parece boa`: "todo arquivo antigo deve descer logo para o tier mais barato".
- `Troque por isto`: frio cedo demais machuca UX e operacao; primeiro confirme padrao real de acesso e tempo de restauracao aceitavel.

## Trade-offs e Sinais de Uso Errado

Os trade-offs reais:

- separar metadata e blob elimina um problema e cria outro: consistencia entre banco e storage externo;
- tiering economiza dinheiro, mas adiciona estado de lifecycle, validacao e observabilidade;
- cold restore pode ser um pouco mais lento e precisa de expectativa explicita no produto;
- verificacao antes de purga custa tempo e capacidade, mas o barato sem isso sai caro.

Sinais de uso errado:

- voce consulta o conteudo interno do blob o tempo todo, como se ele fosse tabela normal;
- todo upload precisa ser mutavel in-place, sem versionamento;
- a equipe quer cold storage so porque "esta mais barato", sem antes medir acesso real;
- apagou a copia quente logo depois da migracao, sem validacao forte.

## Fechamento: Julgamento Arquitetural

Blob durability nao e um concurso de engenhosidade. E uma disciplina de separar aquilo que muda do que deve durar. Dropbox mostra a versao extrema: blocos imutaveis, cells isoladas, repairs claros, warm e cold tiers desenhados a partir de durabilidade primeiro e custo depois. Para empresa menor, o julgamento certo costuma ser bem menos heroico: use object storage gerenciado, mantenha metadata pequena no relacional e trate lifecycle como parte da arquitetura, nao como limpeza de bucket. Quando isso fica claro, "onde termina metadata e onde comeca blob" deixa de ser duvida e vira boundary de sistema.

## Decision Synthesis

### Use When

- voce armazena objetos grandes, pouco mutaveis e com alta exigencia de durabilidade
- metadata e conteudo podem viver separados
- custo por classe de armazenamento importa tanto quanto latencia

### Why This Case Used It

- a Dropbox precisava armazenar arquivos em escala extrema com durabilidade alta
- separar blobs de metadata simplificou o desenho e permitiu otimizar custo
- tiers e cold storage ajudaram a alinhar uso real com custo de infraestrutura

### Main Trade-offs

- metadata e blob precisam ficar consistentes sem transacao unica
- mover dados entre tiers aumenta complexidade de lifecycle
- recuperar dados frios costuma custar mais em tempo e operacao

### Warning Signs

- o dado e pequeno, quente e altamente transacional
- voce precisa consultar campos internos do objeto o tempo todo
- o sistema nao ganha nada separando metadata de payload

### Decision Checklist

- o objeto e melhor tratado como blob imutavel?
- eu preciso de durabilidade, replicacao ou versionamento fortes?
- o ganho de tiering compensa a complexidade operacional?
- eu sei onde metadata termina e onde blob comeca?

## Navigation

- [Prev](./chapter-02-relational-scaling-and-operational-discipline.md)
- [Index](./README.md)
- [Next](./chapter-04-search-indexing-and-permission-aware-retrieval.md)
