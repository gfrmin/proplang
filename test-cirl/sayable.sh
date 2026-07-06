#!/bin/sh
# test-cirl/sayable.sh — the said-utility row (CIRL_PLAN C3/C9 as
# ruled). RED BY COMPILE FAILURE until the Task 2 freeze lands the
# UTIL sort's sole codeword (USay) — the inversion, keeping every
# frozen suite green on every pre-freeze tree state. Per the canonized
# fixture-proof habit, the red is DEMONSTRATED to be the missing
# constructor (the fixture type-checks against the drafted surface;
# evidence in the pack). On compile success the fixture RUNS its own
# assertions (the USay and sentence price pins, the bridge identities,
# the featureless-and-clockless doctrine check, the sentence-driven
# defer-then-act episode) and this row goes green only when they all
# pass.
#
# src/ depends on base only, so plain ghc suffices (audit convention).
# Set $GHC to override the compiler.
#
# usage: sh test-cirl/sayable.sh   (from the repo root)

set -eu
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-cirl-sayable.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

if ! "$GHC" -isrc -outputdir "$out" -o "$out/sayablec" \
        test-cirl/fixture/SayableC.hs >"$out/compile.log" 2>&1; then
    echo "sayable fixture does not compile (RED: the freeze has not landed USay):"
    tail -n 6 "$out/compile.log"
    exit 1
fi

"$out/sayablec"
