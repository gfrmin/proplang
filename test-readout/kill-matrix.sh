#!/usr/bin/env bash
# test-readout/kill-matrix.sh — the readout increment's own kill-matrix
# runner (increment-local, per the increment protocol: "increment-local
# ablations carry their own fixtures and runner inside the increment's
# oracle directory - frozen audit scripts never grow rows").
#
# The opening's matrix was run by a throwaway; it is committed here
# because the row set MOVED when F10's r8 group landed, and a matrix
# whose runner is gone cannot be re-derived at the next boundary.
#
# Each cell: the mutant applied to src, the FULL corpus measured, src
# restored. The corpus is the eleven stanza'd suites PLUS the readout
# oracle compiled standalone under the stanza's own flags and
# dependency closure (the stanza is not spliced until 2-freeze, so the
# standalone compile is how readout joins the corpus before the
# freeze - the same route 1-verify uses).
#
# RUNNER NOTE, kept from the opening because the lesson is not local:
# compile death is detected as a GHC diagnostic line or a cabal build
# failure - NEVER as the string 'Error:', which cabal prints on every
# ordinary test failure. The opening's first runner made that mistake
# and reported all seven mutants as compile deaths, so it COULD NOT
# HAVE REPORTED A KILL AT ALL: the mirror image of a green that cannot
# fail.
set -uo pipefail
cd "$(dirname "$0")/.."
export PATH="$HOME/.ghcup/bin:$PATH"

trap 'git checkout -- src/PropLang/Host.hs 2>/dev/null || true' EXIT

MUTANTS=$(ls audit/mutants/M6[4-9]-*.patch audit/mutants/M7[0-2]-*.patch 2>/dev/null | sort)

echo "=== THE READOUT KILL MATRIX (serial, per-row; baseline = the implemented surface) ==="
echo "date: $(date -u +%Y-%m-%d)   ghc $(ghc --numeric-version)   cabal $(cabal --numeric-version)"
echo "pool: $(echo "$MUTANTS" | wc -l) mutants —"
echo "$MUTANTS" | sed 's|^|  |'
echo "each cell: mutant applied to src, FULL corpus (11 stanza'd suites +"
echo "  the readout oracle standalone), src restored"
echo

for p in $MUTANTS; do
  name=$(basename "$p" .patch)
  git checkout -- src/PropLang/Host.hs
  if ! git apply "$p" 2>/dev/null; then
    echo "$name: PATCH DID NOT APPLY (the mutant is stale against src)"
    echo
    continue
  fi

  tmp=$(mktemp -d)
  if ! cabal build -v0 lib:proplang > "$tmp/lib.log" 2>&1; then
    echo "$name: COMPILE DEATH (a mutant killed by the compiler is not a mutant)"
    sed -n '1,6p' "$tmp/lib.log" | sed 's|^|      |'
    rm -rf "$tmp"; echo; continue
  fi
  if ! cabal exec ghc -- -hide-all-packages -package base -package containers \
        -package directory -package process -package tasty -package tasty-hunit \
        -XGHC2021 -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
        -isrc -itest-readout -outputdir "$tmp" -o "$tmp/readout" \
        test-readout/Readout.hs > "$tmp/compile.log" 2>&1; then
    echo "$name: COMPILE DEATH (the oracle does not build against the mutant)"
    sed -n '1,6p' "$tmp/compile.log" | sed 's|^|      |'
    rm -rf "$tmp"; echo; continue
  fi

  cabal build -v0 exe:proplang-host > /dev/null 2>&1
  exedir=$(dirname "$(cabal list-bin exe:proplang-host)")
  PATH="$exedir:$PATH" "$tmp/readout" > "$tmp/run.log" 2>&1

  # the fired rows: tasty prints "<name>: FAIL" for each
  fired=$(grep -oE "^ *[A-Za-z0-9].*: +FAIL" "$tmp/run.log" | sed 's/: *FAIL$//' | sed 's/^ *//')
  n=$(printf '%s' "$fired" | grep -c . || true)
  echo "$name: $n readout row(s) fired"
  [ "$n" -gt 0 ] && printf '%s\n' "$fired" | sed 's|^|    |'

  cabal test all > "$tmp/corpus.log" 2>&1
  cfail=$(grep -oE "Test suite [a-z-]+: FAIL" "$tmp/corpus.log" | sort -u)
  if [ -z "$cfail" ]; then
    echo "    standing corpus GREEN - the kill is READOUT-UNIQUE"
  else
    echo "    STANDING CORPUS REDDENED - the kill is NOT readout-unique:"
    printf '%s\n' "$cfail" | sed 's|^|      |'
  fi
  rm -rf "$tmp"
  echo
done

git checkout -- src/PropLang/Host.hs
echo "=== matrix done; src restored ==="
git diff --quiet src/PropLang/Host.hs && echo "src is byte-identical to HEAD"
