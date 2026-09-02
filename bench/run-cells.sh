#!/usr/bin/env bash
# bench/run-cells.sh — the fold-depth measurement runner (bench r01).
#
# Builds the instrument with plain ghc against the shipped src (the
# frozen ablation runner's `ghc --make -isrc` form; -O1 = cabal's
# default optimisation for the served proplang-host), runs the bench
# tests, then executes the protocol's cells in WAVES of at most four
# concurrent single-threaded processes under `nice -n 10`, each cell a
# separate process, each timed cell (route 1) with its own wall budget
# — a cell that exhausts its budget writes a "# TRUNCATED at tick N"
# line into its CSV and keeps every completed window (no silent caps).
#
# Usage:  bench/run-cells.sh [wave ...]     (waves: A B C D E R; default A-E)
#         R is the r02 P2real wave (the consumer's real declaration), run
#         separately and serialized; it is NOT in the default set.
# Scratch (logs, per-tick raw dumps, build) lives under
# ~/.cache/proplang-bench; only bench/results/*.csv is repo-bound.
set -euo pipefail
cd "$(dirname "$0")/.."           # the repo root: the build stamp reads git here
CACHE=${PROPLANG_BENCH_CACHE:-$HOME/.cache/proplang-bench}
OUT=bench/results
RAW=$CACHE/raw
LOGS=$CACHE/logs
mkdir -p "$CACHE/build" "$CACHE/build-test" "$CACHE/build-gmp" "$OUT" "$RAW" "$LOGS"
EXE=$CACHE/bench-fold-depth

build() {
  ghc -O1 -Wall -Werror -isrc -ibench -outputdir "$CACHE/build" -o "$EXE" bench/BenchFoldDepth.hs
  ghc -O1 -Wall -Werror -isrc -ibench -outputdir "$CACHE/build-test" -o "$CACHE/bench-test" bench/BenchTest.hs
  ghc -O1 -Wall -Werror -outputdir "$CACHE/build-gmp" -o "$CACHE/gmpops" bench/GmpOps.hs
  "$CACHE/bench-test" | tee "$OUT/bench-test.txt"
}

machine() {
  {
    echo "== $(date -u +%FT%TZ) $1"
    echo "host=$(uname -n) kernel=$(uname -r) HEAD=$(git rev-parse --short HEAD) src-dirty=$(git status --porcelain src | wc -l)"
    echo "cpu=$(lscpu | sed -n 's/^Model name: *//p') cores=$(nproc) governor=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor 2>/dev/null || echo n/a)"
    echo "mem: $(free -m | awk '/^Mem:/{print "total="$2"MB used="$3"MB avail="$7"MB"}')  swap: $(free -m | awk '/^Swap:/{print "used="$3"MB"}')"
    echo "loadavg: $(cut -d' ' -f1-3 /proc/loadavg)"
    echo "ghc=$(ghc --numeric-version) cabal=$(cabal --numeric-version)"
    echo "top cpu consumers (other than this bench):"
    # `|| true`: under `set -o pipefail` this pipeline returns 141 whenever
    # `head` closes the pipe before `grep` has finished writing -- a RACE, so
    # the wave aborted only sometimes, silently, after writing the machine
    # record and before the first cell, with NO error line in the log (a
    # harness gate that fails invisibly; the r02 wave hit it first).
    ps -eo pcpu,comm --sort=-pcpu | grep -v bench-fold-depth | head -6 | sed 's/^/  /' || true
  } >> "$OUT/machine.txt"
}

# cell PROFILE TICKS SEED ROUTE [BUDGET_S]
cell() {
  local p=$1 t=$2 s=$3 r=$4 b=${5:-}
  local name="$p-T$t-s$s-route$r"
  local args=(--profile "$p" --ticks "$t" --seed "$s" --route "$r" --out "$OUT")
  [ "$r" = 1 ] && args+=(--raw "$RAW")
  [ -n "$b" ] && args+=(--budget-s "$b")
  echo "[$(date -u +%T)] start $name ${b:+(budget ${b}s)}"
  nice -n 10 "$EXE" "${args[@]}" > "$LOGS/$name.log" 2>&1 \
    && echo "[$(date -u +%T)] done  $name" \
    || echo "[$(date -u +%T)] FAILED $name (see $LOGS/$name.log)"
}

wave_R() {   # the P2real wave (bench r02): the consumer's ACTUAL declaration.
             # SERIALIZED -- one process at a time, never concurrent -- because
             # P2real is the most expensive profile in the corpus and the r01
             # report measured 7-9% shallow-window inflation under sibling
             # load.  Budgets are generous and truncation is honest: a cell
             # that exhausts its budget writes "# TRUNCATED at tick N" and
             # keeps every completed window (no silent caps).
  machine "wave R start (P2real, serialized)"
  cell P2real 100  1 1
  cell P2real 300  1 1 2400
  cell P2real 1000 1 1 3600
  cell P2real 100  1 2
  cell P2real 300  1 2 2400
  cell P2real 100  2 1
  cell P2real 300  2 1 2400
  machine "wave R end"
}

wave_A() {   # the cheap cells: every 10^2/10^3 cell, P1 at 10^4, the sanity cells, calibration variants
  machine "wave A start"
  "$CACHE/gmpops" | tee "$OUT/gmp-ops.txt"
  for s in 1 2 3; do cell P1 100 $s 1; cell P1 100 $s 2; cell P1 1000 $s 1; cell P1 1000 $s 2; done
  for s in 1 2 3; do cell P2 100 $s 1; cell P2 100 $s 2; done
  cell P3 100 1 1 & cell P3 100 2 1 & cell P3 100 3 1 & wait
  cell P3 100 1 2 & cell P3 100 2 2 & cell P3 100 3 2 & wait
  cell S1 10000 1 1 & cell S0 10000 1 1 & cell S1 100000 1 1 & cell S0 100000 1 1 & wait
  cell P1 10000 1 1 & cell P1 10000 2 1 & cell P1 10000 3 1 & cell P2nw 100 1 1 & wait
  cell P1 10000 1 2 & cell P1 10000 2 2 & cell P1 10000 3 2 & cell P2nw 1000 1 1 & wait
  cell P2 1000 1 1 & cell P2 1000 2 1 & cell P2 1000 3 1 & cell P3wide 100 1 2 & wait
  cell P2 1000 1 2 & cell P2 1000 2 2 & cell P2 1000 3 2 & cell P2nw 1000 1 2 & wait
  machine "wave A end"
}

wave_B() {   # the gating cells: P2 at 10^4 (three seeds, timed) + P3 at 10^3 seed 1; 2 h budget each
  machine "wave B start"
  cell P2 10000 1 1 7200 & cell P2 10000 2 1 7200 & cell P2 10000 3 1 7200 & cell P3 1000 1 1 7200 & wait
  machine "wave B end"
}

wave_C() {   # P1 at 10^5 (three seeds, timed) + route 2 for P2 at 10^4 seed 1; 75 min budget each
  machine "wave C start"
  cell P1 100000 1 1 4500 & cell P1 100000 2 1 4500 & cell P1 100000 3 1 4500 & cell P2 10000 1 2 4500 & wait
  machine "wave C end"
}

wave_D() {   # P3 at 10^3 seeds 2,3 (timed) + route 2 for P1 at 10^5 and P3 at 10^3 (seed 1); 45 min budget each
  machine "wave D start"
  cell P3 1000 2 1 2700 & cell P3 1000 3 1 2700 & cell P1 100000 1 2 2700 & cell P3 1000 1 2 2700 & wait
  machine "wave D end"
}

wave_E() {   # SOLO controls, run one at a time on the box: the sanity cells and P1@10^4 without any
             # sibling cell, so the concurrency factor and the warm-up transient can be read off
             # against the same cells inside the waves; written to bench/results/solo/
  machine "wave E start (solo controls)"
  local out0=$OUT; OUT=$OUT/solo; mkdir -p "$OUT"
  cell S1 100000 1 1; cell S0 100000 1 1; cell P1 10000 1 1; cell S1 100000 2 1
  OUT=$out0
  machine "wave E end"
}

build
if [ $# -eq 0 ]; then set -- A B C D E; fi
for w in "$@"; do "wave_$w"; done
echo "all requested waves done; analyze with: python3 bench/analyze.py"
