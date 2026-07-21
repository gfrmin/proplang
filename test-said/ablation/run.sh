#!/usr/bin/env bash
# test-said/ablation/run.sh — the W4 seeded-defect tripwire
# (wire-author-pack Part VIII; the W3/R1 run.sh precedent). Seed the
# defect the pricing pins exist to catch — the namespace-relative
# pricing call re-aimed at a wrong, default-shaped namespace (the M1
# namespace-law violation: Get mentions price log2 1 = 0 instead of
# log2 |declared|) — and confirm the frozen oracle CATCHES it with
# attribution partitioned:
#   g2a (utility_bits == frozen bitsIn)   REDS  (Get priced 0)
#   g2c (singleton-cgrid priced route)    REDS  (its program reads a)
#   g2b (absent-key shipped reply)        GREEN (the shipped route
#                                                never prices)
#   g4a (log-utility EU behavior)         GREEN (no Get in its
#                                                program; pricing
#                                                never steers acts)
# The parse rows (g1) and the door rows (g3) are deliberately BLIND
# to this mutation: pricing is reply economics, invisible to parse
# and validation — which is exactly why the extensional pricing pins
# are the load-bearing rows.
#
# Runs against the IMPLEMENTED src (meaningless while src lacks W4).
# Requires ghcup's ghc on PATH and a built cabal environment.
set -euo pipefail
cd "$(dirname "$0")/../.."

SRC=${W4_SRC:-src}

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT
mkdir -p "$TMP/PropLang"

hits=$(grep -c "W4-ANCHOR" "$SRC/PropLang/Host.hs" || true)
if [ "$hits" -ne 1 ]; then
  echo "ABLATION ERROR: expected exactly 1 W4-ANCHOR in Host.hs, found $hits"
  exit 1
fi
cp "$SRC"/PropLang/*.hs "$TMP/PropLang/"
sed 's/bitsIn nsN prog/bitsIn (mkNamespace ("t" :| [])) prog/' \
  "$SRC/PropLang/Host.hs" > "$TMP/PropLang/Host.hs"
if cmp -s "$SRC/PropLang/Host.hs" "$TMP/PropLang/Host.hs"; then
  echo "ABLATION ERROR: mutation did not apply"
  exit 1
fi

cabal exec -- ghc -Wall -Wincomplete-patterns -Wincomplete-uni-patterns \
  -XGHC2021 -i"$TMP" -outputdir "$TMP/obj" \
  test-said/Said.hs -o "$TMP/mutant" >/dev/null

for row in 'g2a the priced hello reply' 'g2c a singleton cgrid'; do
  if "$TMP/mutant" -p "/$row/" >/dev/null 2>&1; then
    echo "ABLATION FAILED: '$row' passed under the namespace-law leak"
    exit 1
  fi
  echo "tripwire fires: '$row' REDS under the leak"
done

for row in 'g2b the ABSENT key' 'g4a the priced log-utility'; do
  if ! "$TMP/mutant" -p "/$row/" >/dev/null 2>&1; then
    echo "ABLATION FAILED: attribution broken ('$row' red under the leak)"
    exit 1
  fi
  echo "attribution clean: '$row' stays green under the leak"
done
echo "W4 ablation PASS"
