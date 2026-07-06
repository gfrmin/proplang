#!/bin/sh
# test-ladder/sayable.sh — the sayable rung valuation row (LADDER_PLAN
# L3/L4 as ruled). RED BY COMPILE FAILURE until the Task 2 freeze lands
# STDNAME's sixth member (VThinkK) together with the author's
# one-literal amendment of the frozen expfam price pin — the deletion
# audit's inversion, used forward: it keeps the pre-freeze tree with
# every frozen suite green (the five-member alphabet is untouched)
# while this row alone carries the sayable surface's red. On compile
# success the fixture RUNS its own assertions (price pin under lg 6,
# verb/worker identities, the sentence-driven episode against the
# direction-1 pins) and this row goes green only when they all pass.
#
# src/ depends on base only, so plain ghc suffices (audit convention);
# Streams comes from the frozen test/ directory, base-only likewise.
# Set $GHC to override the compiler.
#
# usage: sh test-ladder/sayable.sh   (from the repo root)

set -eu
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-ladder-sayable.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

if ! "$GHC" -isrc -itest -outputdir "$out" -o "$out/sayable" \
        test-ladder/fixture/Sayable.hs >"$out/compile.log" 2>&1; then
    echo "sayable fixture does not compile (RED: the freeze has not landed VThinkK):"
    tail -n 6 "$out/compile.log"
    exit 1
fi

"$out/sayable"
