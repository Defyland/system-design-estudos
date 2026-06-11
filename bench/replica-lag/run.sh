#!/usr/bin/env bash
#
# Replica lag, measured — not argued.
#
# Spins up an ephemeral Postgres primary + streaming replica (no Docker), induces
# replication apply lag, and MEASURES it: the read-after-write stale rate and the
# lag distribution (p50/p95/p99). The point of the drill is to derive the
# read-your-writes stickiness window from an observed p99 instead of a guess, and
# to see that on a co-located box the *natural* floor is tiny — the bug is a
# property of your deployment (network + load), so you must measure it there.
#
# Everything lives in a temp dir and is torn down on exit.
#
#   ./run.sh                         # default: 300ms induced apply delay
#   APPLY_DELAY=0 ./run.sh           # observe the natural local floor
#   APPLY_DELAY=1s TRIALS=40 ./run.sh
#
# Requires the Postgres 14+ server binaries (initdb, pg_ctl, pg_basebackup, psql).
# Override their location with PGBIN=/path/to/pg/bin.
set -euo pipefail

PGBIN="${PGBIN:-/opt/homebrew/opt/postgresql@14/bin}"
PRIMARY_PORT="${PRIMARY_PORT:-54330}"
REPLICA_PORT="${REPLICA_PORT:-54340}"
APPLY_DELAY="${APPLY_DELAY:-300ms}"   # recovery_min_apply_delay on the standby
TRIALS="${TRIALS:-40}"                # read-after-write trials
SAMPLES="${SAMPLES:-120}"             # lag samples taken during a write burst
SUPER="${SUPER:-postgres}"

[ -x "$PGBIN/initdb" ] || { echo "initdb not found under PGBIN=$PGBIN" >&2; exit 1; }

WORK="$(mktemp -d "${TMPDIR:-/tmp}/replica-lag.XXXXXX")"
PRIMARY="$WORK/primary"
REPLICA="$WORK/replica"
SOCK="$WORK/sock"; mkdir -p "$SOCK"
PSQL_P=("$PGBIN/psql" -h localhost -p "$PRIMARY_PORT" -U "$SUPER" -d postgres -At)
PSQL_R=("$PGBIN/psql" -h localhost -p "$REPLICA_PORT" -U "$SUPER" -d postgres -At)

cleanup() {
  "$PGBIN/pg_ctl" -D "$REPLICA" -m immediate stop >/dev/null 2>&1 || true
  "$PGBIN/pg_ctl" -D "$PRIMARY" -m immediate stop >/dev/null 2>&1 || true
  rm -rf "$WORK"
}
trap cleanup EXIT

echo "# replica-lag bench  (apply_delay=$APPLY_DELAY, trials=$TRIALS, samples=$SAMPLES)"

# --- primary ---------------------------------------------------------------
"$PGBIN/initdb" -D "$PRIMARY" -U "$SUPER" --auth=trust >/dev/null
cat >> "$PRIMARY/postgresql.conf" <<EOF
listen_addresses = 'localhost'
port = $PRIMARY_PORT
unix_socket_directories = '$SOCK'
wal_level = replica
max_wal_senders = 10
wal_keep_size = 128MB
hot_standby = on
EOF
cat >> "$PRIMARY/pg_hba.conf" <<EOF
host all all 127.0.0.1/32 trust
host all all ::1/128 trust
host replication all 127.0.0.1/32 trust
host replication all ::1/128 trust
EOF
"$PGBIN/pg_ctl" -D "$PRIMARY" -l "$WORK/primary.log" -w -t 30 start >/dev/null

# --- replica (streaming, via base backup) ----------------------------------
"$PGBIN/pg_basebackup" -h localhost -p "$PRIMARY_PORT" -U "$SUPER" -D "$REPLICA" -R -X stream -c fast >/dev/null 2>&1
cat >> "$REPLICA/postgresql.auto.conf" <<EOF
port = $REPLICA_PORT
unix_socket_directories = '$SOCK'
recovery_min_apply_delay = '$APPLY_DELAY'
EOF
"$PGBIN/pg_ctl" -D "$REPLICA" -l "$WORK/replica.log" -w -t 30 start >/dev/null

# --- wait for streaming to establish ---------------------------------------
for _ in $(seq 1 40); do
  n="$("${PSQL_P[@]}" -tc "select count(*) from pg_stat_replication" 2>/dev/null || echo 0)"
  [ "${n:-0}" -ge 1 ] && break
  sleep 0.25
done
echo "streaming replicas connected: $("${PSQL_P[@]}" -tc "select count(*) from pg_stat_replication" 2>/dev/null || echo 0)"

# --- schema ----------------------------------------------------------------
"${PSQL_P[@]}" -c "create table bench(id bigserial primary key, payload text, written_at timestamptz default clock_timestamp())" >/dev/null
for _ in $(seq 1 50); do
  ok="$("${PSQL_R[@]}" -tc "select to_regclass('public.bench') is not null" 2>/dev/null || echo f)"
  [ "$ok" = "t" ] && break
  sleep 0.1
done

# --- read-after-write: write on primary, immediately read the replica ------
stale=0; fresh=0
for _ in $(seq 1 "$TRIALS"); do
  id="$("${PSQL_P[@]}" -c "insert into bench(payload) values (repeat('x',256)) returning id" 2>/dev/null || true)"
  [ -n "$id" ] || continue
  seen="$("${PSQL_R[@]}" -c "select count(*) from bench where id=$id" 2>/dev/null || echo 0)"
  if [ "$seen" = "1" ]; then fresh=$((fresh+1)); else stale=$((stale+1)); fi
done

# --- lag distribution while writes flow continuously -----------------------
# The metric now()-pg_last_xact_replay_timestamp() is only meaningful while
# transactions keep arriving; during idle it measures metric staleness, not
# apply lag. So the writer runs for the WHOLE sampling window, not a fixed count.
rm -f "$WORK/stop"
( while [ ! -e "$WORK/stop" ]; do
    "${PSQL_P[@]}" -c "insert into bench(payload) select repeat('y',256) from generate_series(1,4000)" >/dev/null 2>&1 || true
  done ) &
writer=$!
samples="$WORK/lag.txt"; : > "$samples"
for _ in $(seq 1 "$SAMPLES"); do
  "${PSQL_R[@]}" -c "select coalesce(round(extract(epoch from (now()-pg_last_xact_replay_timestamp()))*1000,1),0)" >> "$samples" 2>/dev/null || true
  sleep 0.05
done
touch "$WORK/stop"
wait "$writer" 2>/dev/null || true

# --- report ----------------------------------------------------------------
read -r p50 p95 p99 pmax < <(sort -n "$samples" | awk '
  function q(p,  i){i=int(p*(n-1))+1; if(i<1)i=1; if(i>n)i=n; return a[i]}
  {a[NR]=$1}
  END{
    n=NR; if(n==0){print "0 0 0 0"; exit}
    printf "%s %s %s %s\n", q(0.50), q(0.95), q(0.99), a[n]
  }') || true
total=$((stale+fresh))
rate=$(awk -v s="$stale" -v t="$total" 'BEGIN{printf "%.0f", (t? 100*s/t:0)}')
window=$(awk -v x="${p99:-0}" 'BEGIN{printf "%d", x+0.999}')

echo ""
echo "read-after-write on the replica : $stale/$total stale (${rate}%)"
echo "replica apply lag (ms)          : p50=$p50  p95=$p95  p99=$p99  max=$pmax"
echo "stickiness window from observed : >= ${window} ms (ceil p99) + margin"
