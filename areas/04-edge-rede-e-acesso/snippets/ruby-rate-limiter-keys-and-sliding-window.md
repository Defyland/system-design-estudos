# Ruby Rate Limiter Keys and Sliding Window

- [Chapter 06](../../../chapters/chapter-06-edge-rate-limiting-waf-and-gateway-boundaries.md)
- [Related Card](../../../areas/09-backend-principles/cards/rate-limiting-algorithms-and-keys.md)
- [Related Lab](../../../areas/13-backend-principle-labs/labs/build-a-ruby-rate-limiter.md)

## When to Use

Use este snippet quando `Rack::Attack` ou um throttle bruto ja explicam a ideia, mas voce quer estudar duas perguntas que normalmente ficam vagas:

- qual identidade deve ser limitada;
- como ficaria um limiter mais suave em Ruby antes de partir para infra mais especializada.

## Rails First

Para login e abuso obvio, um `fixed window` barato ainda resolve bastante:

```rb
# config/initializers/rack_attack.rb
Rack::Attack.throttle("sessions/ip", limit: 10, period: 1.minute) do |req|
  req.ip if req.path == "/sessions" && req.post?
end
```

Quando a rota e mais sensivel a fairness do que a reset previsivel, da para estudar um `sliding window` compartilhado em Redis sem sair de Ruby:

```rb
require "securerandom"

class RedisSlidingWindowLimiter
  Result = Struct.new(:allowed?, :remaining, :retry_after_seconds, keyword_init: true)

  def initialize(redis:, key:, limit:, window_seconds:, clock: -> { Time.now.to_f })
    @redis = redis
    @key = key
    @limit = limit
    @window_seconds = window_seconds
    @clock = clock
  end

  def hit
    loop do
      now_ms = (@clock.call * 1000).to_i
      cutoff_ms = now_ms - (@window_seconds * 1000)

      @redis.watch(@key)
      @redis.zremrangebyscore(@key, 0, cutoff_ms)
      current_count = @redis.zcard(@key)

      if current_count >= @limit
        oldest = @redis.zrange(@key, 0, 0, withscores: true).first
        @redis.unwatch

        retry_after_ms = oldest ? oldest.last.to_i + (@window_seconds * 1000) - now_ms : 0

        return Result.new(
          allowed?: false,
          remaining: 0,
          retry_after_seconds: [retry_after_ms / 1000.0, 0].max
        )
      end

      member = "#{now_ms}:#{SecureRandom.hex(4)}"

      applied = @redis.multi do |tx|
        tx.zadd(@key, now_ms, member)
        tx.expire(@key, @window_seconds.ceil)
      end

      next unless applied

      return Result.new(
        allowed?: true,
        remaining: @limit - current_count - 1,
        retry_after_seconds: 0
      )
    ensure
      @redis.unwatch
    end
  end
end
```

Uso intencional:

```rb
class SearchQueriesController < ApplicationController
  def index
    limiter = RedisSlidingWindowLimiter.new(
      redis: REDIS,
      key: "search:account:#{Current.account.id}:user:#{current_user.id}",
      limit: 120,
      window_seconds: 60
    )

    result = limiter.hit
    if result.allowed?
      response.set_header("RateLimit-Remaining", result.remaining)
      render json: SearchQuery.run!(params[:q])
    else
      response.set_header("Retry-After", result.retry_after_seconds.ceil)
      render json: { error: "rate_limited" }, status: :too_many_requests
    end
  end
end
```

## Why This Is Still Honest

Esse desenho ensina bem a decisao arquitetural:

- `IP` ainda serve para defesa bruta de usuario anonimo;
- `user_id` ou `api_key` representam melhor consumo legitimo;
- `tenant_id` importa quando o dano real e multi-tenant;
- `WATCH/MULTI` ja mostra que contagem distribuida tem custo e disputa propria.

Tambem deixa claro o limite da abordagem: sob contencao alta ou necessidade de decisao extremamente atomica, a logica tende a migrar para mais perto do data store ou para um limiter gerenciado. O ponto do estudo aqui e entender o mecanismo e a fronteira, nao fingir que Ruby elimina a tensao distribuida.

## Failure Modes

- usar `IP` como chave principal em produto B2B e punir o tenant errado;
- aplicar contagem por minuto em export pesado quando o dano real e concorrencia em voo;
- `fail closed` em indisponibilidade do Redis e transformar o limiter em causa do incidente;
- esquecer `Retry-After` e deixar o cliente cego sobre quando tentar de novo;
- compartilhar uma chave global demais e criar hot spot no Redis.
