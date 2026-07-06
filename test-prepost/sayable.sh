#!/bin/sh
# test-prepost/sayable.sh — the sayable action-dependent preposterior
# row (PREPOSTERIOR_PLAN P4/P9 as ruled). RED BY COMPILE FAILURE until
# the Task 2 freeze lands STDNAME's seventh member (VPre) together
# with the author's two frozen literal amendments — the inversion,
# keeping every frozen suite green on every pre-freeze tree state.
# Per the canonized fixture-proof habit, the red is DEMONSTRATED to be
# the missing constructor (the fixture type-checks against the drafted
# surface; evidence in the pack). On compile success the fixture RUNS
# its own assertions (price pin under lg 7, verb/worker and degenerate
# identities, the sentence-driven decisions in both worlds).
#
# src/ depends on base only, so plain ghc suffices (audit convention).
# Set $GHC to override the compiler.
#
# usage: sh test-prepost/sayable.sh   (from the repo root)

set -eu
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-prepost-sayable.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

if ! "$GHC" -isrc -outputdir "$out" -o "$out/sayablep" \
        test-prepost/fixture/SayableP.hs >"$out/compile.log" 2>&1; then
    echo "sayable fixture does not compile (RED: the freeze has not landed VPre):"
    tail -n 6 "$out/compile.log"
    exit 1
fi

"$out/sayablep"
