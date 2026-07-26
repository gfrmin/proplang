#!/usr/bin/env bash
# tools/oracle-audit.sh — the oracle-row deletion audit's first run
# (EXACT_PLAN §12 step 7; pack IX.6 the drafted clause). For each
# DECLARED mutant (audit/mutants/*.patch — named minimal patches
# instantiating recorded failure shapes), run every frozen suite and
# record the per-row kills. The matrix's verdicts (EARNED / SHADOWED /
# UNREACHED) are TRIAGE INPUTS for the close sitting, never
# auto-deletions. Runs AFTER the R11 retirement (IX.8a composition):
# the matrix covers exactly the surviving law.
set -u
cd "$(dirname "$0")/.." || exit 2
OUT="${1:-/tmp/oracle-audit}"
mkdir -p "$OUT"
suites="exact-acceptance exact-properties lawful lawful-independence pins dyadic"
for p in audit/mutants/*.patch; do
  m=$(basename "$p" .patch)
  echo "=== mutant $m ==="
  git apply "$p" || { echo "APPLY FAILED: $m"; continue; }
  if ! cabal build lib:proplang >/dev/null 2>&1; then
    echo "$m: DOES NOT COMPILE (a compile-kill; every suite counts)" \
      | tee "$OUT/$m.kills"
  else
    : > "$OUT/$m.kills"
    for s in $suites; do
      log=$(timeout 150 cabal test "$s" 2>&1) || \
        { [ $? -eq 124 ] && echo "[$s] TIMEOUT-KILL (the suite cannot terminate under the mutant — intractability is a kill)" >> "$OUT/$m.kills"; }
      if echo "$log" | grep -q "Test suite $s: FAIL"; then
        echo "$log" | grep -E '^\s+.*:\s+FAIL' | sed "s/^/[$s] /" \
          >> "$OUT/$m.kills"
        echo "$log" | grep -oE 'FAIL' >/dev/null && echo "[$s] SUITE-FAIL" >> "$OUT/$m.kills"
      fi
    done
    kn=$(wc -l < "$OUT/$m.kills")
    echo "$m: $kn kill lines"
  fi
  git checkout -- src/
done
echo "=== matrix summary ==="
for f in "$OUT"/*.kills; do
  echo "--- $(basename "$f" .kills): $(wc -l < "$f") lines"
  head -6 "$f"
done
