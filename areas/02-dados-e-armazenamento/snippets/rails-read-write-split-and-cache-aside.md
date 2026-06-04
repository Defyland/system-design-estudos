# Rails Read/Write Split and Cache Aside

## When to Use

Use este padrao quando:

- o core do dominio continua relacional;
- algumas leituras suportam pequena defasagem;
- o custo da primary vem mais de reads repetitivas do que de writes absurdas;
- voce consegue dizer com clareza quais endpoints exigem read-after-write.

Se voce ainda nao sabe responder a ultima linha, nao faca split automatico. Primeiro conheca o produto que esta operando.

## Rails First

Comece pelo padrao nativo do Rails para multi-database e mantenha a semantica explicita no codigo.

```yml
# config/database.yml
production:
  primary:
    adapter: mysql2
    database: app_production
  primary_replica:
    adapter: mysql2
    database: app_production
    replica: true
```

```rb
class TicketSummaries::Fetch
  STICKY_PRIMARY_WINDOW = 5.seconds

  def initialize(ticket_id:, tenant:, session:)
    @ticket_id = ticket_id
    @tenant = tenant
    @session = session
  end

  def call
    Rails.cache.fetch(cache_key, expires_in: 20.seconds) do
      with_role(read_role) do
        @tenant.tickets
          .includes(:assignee)
          .select(:id, :subject, :status, :priority, :updated_at, :assignee_id)
          .find(@ticket_id)
      end
    end
  end

  def update!(attrs)
    with_role(:writing) do
      ticket = @tenant.tickets.find(@ticket_id)
      ticket.update!(attrs)
      @session[:read_from_primary_until] = Time.current.to_i + STICKY_PRIMARY_WINDOW.to_i
      Rails.cache.delete(cache_key)
      ticket
    end
  end

  private

  def read_role
    sticky_until = @session[:read_from_primary_until].to_i
    sticky_until > Time.current.to_i ? :writing : :reading
  end

  def with_role(role, &block)
    ActiveRecord::Base.connected_to(role: role, &block)
  end

  def cache_key
    ["tenant", @tenant.id, "ticket", @ticket_id, "summary", 1]
  end
end
```

Leitura quente vai para replica so quando o negocio aceita lag. Leitura logo apos write fica temporariamente sticky na primary. Cache-aside entra em cima do read model, nunca no comando.

## Optional Elixir

Elixir ensina algo util aqui: deixar reader e writer explicitos costuma ser mais saudavel do que esconder consistencia atras de helper magico.

```elixir
defmodule TicketSummary do
  def fetch(id, fresh? \\ false) do
    repo = if fresh?, do: PrimaryRepo, else: ReplicaRepo
    repo.get!(Ticket, id)
  end
end
```

Se o sistema ganhou muita coordenacao concorrente, jobs e fan-out, Elixir ajuda. A decisao de negocio continua igual: acabou de gravar e precisa ver o resultado, leia da primary.

## Optional Go

Go ensina outra coisa: abrir reader e writer como dependencias distintas reduz ambiguidade operacional.

```go
type Store struct {
  Writer *sql.DB
  Reader *sql.DB
}

func (s Store) ReadTicket(ctx context.Context, id int64, fresh bool) (*Ticket, error) {
  db := s.Reader
  if fresh {
    db = s.Writer
  }

  // query omitida
  return &Ticket{}, nil
}
```

Vale quando voce quer um componente pequeno, read-heavy ou operacional, sem a ergonomia maior do Rails. O julgamento arquitetural nao muda nem um milimetro.

## Failure Modes

- replica lag quebrando read-after-write e gerando bugs "fantasma";
- cache key ampla demais, misturando tenants ou payloads diferentes;
- invalidacao esquecida no write path;
- cache stampede em endpoint quente sem TTL curto ou protecao;
- split de leitura usado para esconder query ruim, N+1 ou falta de indice;
- export e analytics pesados disputando replica que deveria servir trafego do produto.
