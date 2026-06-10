#!/usr/bin/env ruby
# frozen_string_literal: true

# Tiny dependency-free simulation engine for the numeric simulation labs.
# Each model takes named parameters (k=v on the command line) and prints the
# trade-off the lab describes, so the learner can move a knob and watch the
# numbers move instead of only reading prose.
#
#   ruby simulation-labs/sim/run.rb --list
#   ruby simulation-labs/sim/run.rb cache hit_rate=0.8 origin_ms=60
#   ruby simulation-labs/sim/run.rb consumer-lag produce_rps=1500 consumers=3
#
# Also runs through the Rakefile:  rake 'simulate[cache]'  ARGS="hit_rate=0.8"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

module Sim
  module_function

  def round(value, digits = 2)
    return value unless value.is_a?(Numeric)

    rounded = value.round(digits)
    rounded == rounded.to_i ? rounded.to_i : rounded
  end

  def pct(fraction)
    "#{round(fraction * 100, 1)}%"
  end

  # --- cache: hit rate vs latency, origin load and stale risk ----------------
  def cache(p)
    hit = p.fetch(:hit_rate)
    origin_ms = p.fetch(:origin_ms)
    cache_ms = p.fetch(:cache_ms)
    rps = p.fetch(:rps)
    ttl_s = p.fetch(:ttl_s)

    effective = hit * cache_ms + (1 - hit) * origin_ms
    origin_rps = rps * (1 - hit)

    [
      "hit rate            : #{pct(hit)}",
      "latency sem cache   : #{round(origin_ms)} ms",
      "latency com cache   : #{round(effective)} ms",
      "origin RPS sem cache: #{round(rps)}",
      "origin RPS com cache: #{round(origin_rps)}  (offload #{pct(hit)})",
      "pior caso de stale  : ate #{round(ttl_s)} s (TTL)",
      "leitura             : hit alto derruba latencia e carga; TTL longo aumenta janela de stale"
    ]
  end

  def cache_defaults
    { hit_rate: 0.9, origin_ms: 40.0, cache_ms: 1.0, rps: 500.0, ttl_s: 30.0 }
  end

  # --- consumer-lag: produce vs consume throughput on an event backbone ------
  def consumer_lag(p)
    produce = p.fetch(:produce_rps)
    per_consumer = p.fetch(:consumer_rps)
    consumers = p.fetch(:consumers)
    backlog = p.fetch(:backlog)
    horizon = p.fetch(:horizon_s)

    consume = per_consumer * consumers
    net = produce - consume
    min_consumers = (produce / per_consumer.to_f).ceil

    lines = [
      "produzido           : #{round(produce)} msg/s",
      "consumido           : #{round(consume)} msg/s (#{round(consumers)} x #{round(per_consumer)})",
      "saldo               : #{round(net)} msg/s"
    ]

    if net > 0
      lines << "status              : NAO acompanha; lag cresce #{round(net)} msg/s"
      lines << "lag em #{round(horizon)}s        : #{round(backlog + net * horizon)} msg"
      lines << "minimo de consumers : #{min_consumers} para acompanhar"
    elsif backlog > 0
      drain = backlog / -net.to_f
      lines << "status              : acompanha; drena backlog de #{round(backlog)} em #{round(drain)} s"
      lines << "minimo de consumers : #{min_consumers}"
    else
      lines << "status              : acompanha com folga (#{round(-net)} msg/s de margem)"
      lines << "minimo de consumers : #{min_consumers}"
    end
    lines
  end

  def consumer_lag_defaults
    { produce_rps: 1200.0, consumer_rps: 400.0, consumers: 2.0, backlog: 0.0, horizon_s: 60.0 }
  end

  # --- fanout: fanout-on-write vs fanout-on-read cost per user/day -----------
  def fanout(p)
    followers = p.fetch(:avg_followers)
    following = p.fetch(:avg_following)
    posts = p.fetch(:posts_per_day)
    reads = p.fetch(:reads_per_day)

    write_ops_fow = posts * followers          # 1 feed-write per follower per post
    read_ops_fow = reads                       # read own materialized feed
    write_ops_for = posts                       # 1 write to author timeline
    read_ops_for = reads * following            # merge timelines at read time

    fow_total = write_ops_fow + read_ops_fow
    for_total = write_ops_for + read_ops_for
    winner = fow_total <= for_total ? "fanout-on-write" : "fanout-on-read"

    [
      "perfil              : #{round(followers)} seguidores, #{round(following)} seguidos, " \
        "#{round(posts)} posts/dia, #{round(reads)} leituras/dia",
      "fanout-on-write     : #{round(write_ops_fow)} writes + #{round(read_ops_fow)} reads = #{round(fow_total)} ops/dia",
      "fanout-on-read      : #{round(write_ops_for)} writes + #{round(read_ops_for)} reads = #{round(for_total)} ops/dia",
      "mais barato         : #{winner}",
      "leitura             : write amplifica por seguidor (ruim p/ celebridade); read amplifica por seguido (ruim p/ feed quente)"
    ]
  end

  def fanout_defaults
    { avg_followers: 500.0, avg_following: 300.0, posts_per_day: 2.0, reads_per_day: 20.0 }
  end

  # --- rate-limit vs load-shedding under overload ----------------------------
  def rate_limit(p)
    capacity = p.fetch(:capacity_rps)
    arrival = p.fetch(:arrival_rps)
    limit = p.fetch(:limit_rps)

    # No protection: above capacity the queue collapses, goodput <= capacity.
    raw_goodput = [arrival, capacity].min

    # Rate limit: admit up to the configured limit, reject the rest as 429.
    admitted_rl = [arrival, limit].min
    served_rl = [admitted_rl, capacity].min
    rejected_rl = arrival - admitted_rl

    # Load shedding: shed down to capacity, serve everything admitted.
    served_shed = [arrival, capacity].min
    shed = arrival - served_shed

    [
      "chegada / capacidade: #{round(arrival)} / #{round(capacity)} rps",
      "sem protecao        : goodput ~#{round(raw_goodput)} rps, resto vira congestion collapse",
      "rate limit (#{round(limit)})   : serve #{round(served_rl)}, rejeita #{round(rejected_rl)} (429)",
      "load shedding       : serve #{round(served_shed)}, descarta #{round(shed)} por prioridade",
      "leitura             : rate limit corta por taxa (cego a prioridade); shedding protege capacidade e preserva trafego critico"
    ]
  end

  def rate_limit_defaults
    { capacity_rps: 1000.0, arrival_rps: 1500.0, limit_rps: 1100.0 }
  end

  MODELS = {
    "cache" => { aliases: [], desc: "hit rate vs latencia, carga na origem e stale", defaults: method(:cache_defaults), run: method(:cache) },
    "consumer-lag" => { aliases: %w[event-backbone-consumer-lag], desc: "produzir vs consumir e crescimento de lag", defaults: method(:consumer_lag_defaults), run: method(:consumer_lag) },
    "fanout" => { aliases: %w[fanout-feed-ranking-cost], desc: "fanout-on-write vs fanout-on-read", defaults: method(:fanout_defaults), run: method(:fanout) },
    "rate-limit" => { aliases: %w[rate-limit-vs-load-shedding], desc: "rate limit vs load shedding sob overload", defaults: method(:rate_limit_defaults), run: method(:rate_limit) }
  }.freeze

  def resolve(name)
    return name if MODELS.key?(name)

    MODELS.each { |key, spec| return key if spec[:aliases].include?(name) }
    nil
  end

  def parse_params(defaults, argv)
    params = defaults.dup
    argv.each do |arg|
      key, value = arg.split("=", 2)
      next unless value

      sym = key.to_sym
      next unless params.key?(sym)

      params[sym] = value.include?(".") ? Float(value) : Integer(value)
    end
    params
  end

  def run_model(name, argv)
    key = resolve(name)
    abort "modelo desconhecido: #{name} (use --list)" unless key

    spec = MODELS.fetch(key)
    params = parse_params(spec[:defaults].call, argv)
    puts "# #{key} - #{spec[:desc]}"
    puts spec[:run].call(params)
  end

  def list
    puts "modelos de simulacao disponiveis:"
    MODELS.each do |key, spec|
      names = ([key] + spec[:aliases]).join(", ")
      puts "  - #{names}"
      puts "      #{spec[:desc]}"
      puts "      defaults: #{spec[:defaults].call.map { |k, v| "#{k}=#{round(v)}" }.join(' ')}"
    end
  end

  def selftest
    failures = []
    MODELS.each do |key, spec|
      lines = spec[:run].call(spec[:defaults].call)
      blob = Array(lines).join("\n")
      failures << "#{key}: sem saida" if blob.strip.empty?
      failures << "#{key}: valor nao-finito" if blob.match?(/NaN|Infinity/)
    end
    if failures.empty?
      puts "selftest OK: #{MODELS.size} modelos"
    else
      puts failures.map { |failure| "- #{failure}" }
      exit 1
    end
  end
end

case ARGV[0]
when nil, "--help", "-h"
  puts "uso: ruby simulation-labs/sim/run.rb <modelo> [k=v ...]"
  puts "     ruby simulation-labs/sim/run.rb --list"
  Sim.list
when "--list"
  Sim.list
when "--selftest"
  Sim.selftest
else
  Sim.run_model(ARGV[0], ARGV[1..])
end
