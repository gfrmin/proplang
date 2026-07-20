#!/usr/bin/env bash
# test-refine/ablation/run.sh — design row 10 (r-author-pack III.2;
# METAREASONING_PLAN.md:313-316): the adversarial mutation tripwire.
# Inject a leak factor into the carried count where it enters the
# canonical scorer, and confirm the frozen oracle CATCHES it: the g1
# scorer-vs-incremental row must RED under the mutant (the leaked
# scorer diverges from the sealed reasoner's own cond arithmetic)
# while g6 (Cromwell) stays GREEN — attribution partitioned, the
# seeded-defect pattern (step-2/step-10 precedent). Polices
# "hypotheses yes, machinery no": the scorer computes the counts law
# and nothing else.
#
# Runs against the IMPLEMENTED src (gate-7 style; meaningless while
# src carries oracle-phase stubs). Requires ghcup's ghc on PATH and
# a built cabal environment (cabal exec provides tasty).
set -euo pipefail
cd "$(dirname "$0")/../.."

ANCHOR='fromIntegral n1 \* negate (logBase 2 th)'
MUTANT='fromIntegral n1 * 0.97 * negate (logBase 2 th)'

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/PropLang"

hits=$(grep -c "fromIntegral n1 \* negate (logBase 2 th)" src/PropLang/Lattice.hs || true)
if [ "$hits" -ne 1 ]; then
  echo "ABLATION ERROR: expected exactly 1 anchor site in Lattice.hs, found $hits"
  exit 1
fi
sed "s/$ANCHOR/$MUTANT/" src/PropLang/Lattice.hs > "$TMP/PropLang/Lattice.hs"
if ! grep -q "0.97" "$TMP/PropLang/Lattice.hs"; then
  echo "ABLATION ERROR: mutation did not apply"
  exit 1
fi

cabal exec -- ghc -Wall -Wincomplete-patterns -Wincomplete-uni-patterns \
  -XGHC2021 -i"$TMP" -isrc -outputdir "$TMP/obj" \
  test-refine/Refine.hs -o "$TMP/mutant" >/dev/null

if "$TMP/mutant" -p '/scorer vs incremental/' >/dev/null 2>&1; then
  echo "ABLATION FAILED: the leaked scorer passed the tripwire row"
  exit 1
fi
echo "tripwire fires: scorer-vs-incremental REDS under the leak"

if ! "$TMP/mutant" -p '/Cromwell/' >/dev/null 2>&1; then
  echo "ABLATION FAILED: attribution broken (Cromwell red under a scorer leak)"
  exit 1
fi
echo "attribution clean: Cromwell stays green under the leak"
echo "row-10 ablation PASS"
