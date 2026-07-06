#!/bin/sh
# test-ladder/red-run.sh — the oracle-phase runner (LADDER_PLAN Task 1),
# carrying the STANZA'S EXACT ghc-options: the flag-fidelity clause now
# in CLAUDE.md (a red run proves nothing unless it is bit-faithful to
# the future gate conditions — same flags, same warning set), so this
# runner compiles the suite exactly as the frozen `cabal test all` will
# after the Task 2 freeze lands the stanza.
#
# proplang.cabal stays untouched pre-freeze: the suite is compiled
# out-of-cabal against the project package environment (cabal exec).
#
# usage: sh test-ladder/red-run.sh   (from the repo root)

set -eu
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-ladder-red.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

cabal exec -- ghc \
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -itest-ladder -itest \
    -package tasty -package tasty-hunit -package tasty-quickcheck \
    -package QuickCheck -package process \
    -outputdir "$out" -o "$out/ladder" \
    test-ladder/Ladder.hs

"$out/ladder" "$@"
