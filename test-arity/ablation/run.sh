#!/usr/bin/env bash
# test-arity/ablation/run.sh — the W3 seeded-defect tripwire
# (wire-author-pack Part VII.3 g8; the R1 run.sh precedent). Seed the
# one defect the coincidence pin exists to catch — the spread
# denominator K-1 mutated to K (the law's residual mass leaks) — and
# confirm the frozen oracle CATCHES it with attribution partitioned:
#   g1b (declared-2 byte-equal absent)  REDS  (the coincidence breaks)
#   g2b (paired emissions bit-equal)    REDS  (arity-2 /= shipped)
#   g4a (masses match the law)          REDS  (spread off by (K-1)/K)
#   g4b (Cromwell)                      GREEN (no atom hits zero mass)
# The render pin (g5a) deliberately does NOT fire: renderExpr shows
# the grid's name and index, not its value — the mutation is invisible
# to rendering and visible only extensionally, which is exactly why
# the extensional pins are the load-bearing rows.
#
# Runs against the IMPLEMENTED src (meaningless while src carries
# oracle-phase stubs). Requires ghcup's ghc on PATH and a built cabal
# environment (cabal exec provides tasty).
set -euo pipefail
cd "$(dirname "$0")/../.."

SRC=${W3_SRC:-src}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/PropLang"

hits=$(grep -c "W3-ANCHOR" "$SRC/PropLang/Enumerate.hs" || true)
if [ "$hits" -ne 1 ]; then
  echo "ABLATION ERROR: expected exactly 1 W3-ANCHOR in Enumerate.hs, found $hits"
  exit 1
fi
sed 's/km1Grid = mkGrid "km1" (fromIntegral (k - 1)/km1Grid = mkGrid "km1" (fromIntegral k/' \
  "$SRC/PropLang/Enumerate.hs" > "$TMP/PropLang/Enumerate.hs"
if cmp -s "$SRC/PropLang/Enumerate.hs" "$TMP/PropLang/Enumerate.hs"; then
  echo "ABLATION ERROR: mutation did not apply"
  exit 1
fi

cabal exec -- ghc -Wall -Wincomplete-patterns -Wincomplete-uni-patterns \
  -XGHC2021 -i"$TMP" -i"$SRC" -outputdir "$TMP/obj" \
  test-arity/Arity.hs -o "$TMP/mutant" >/dev/null

for row in 'byte-equal to the absent key' 'g2b paired emissions' 'g4a masses'; do
  if "$TMP/mutant" -p "/$row/" >/dev/null 2>&1; then
    echo "ABLATION FAILED: '$row' passed under the spread-denominator leak"
    exit 1
  fi
  echo "tripwire fires: '$row' REDS under the leak"
done

if ! "$TMP/mutant" -p '/Cromwell/' >/dev/null 2>&1; then
  echo "ABLATION FAILED: attribution broken (Cromwell red under the leak)"
  exit 1
fi
echo "attribution clean: Cromwell stays green under the leak"
echo "W3 ablation PASS"
