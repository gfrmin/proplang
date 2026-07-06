#!/bin/sh
# test-cirl/red-run.sh — the oracle-phase runner (CIRL_PLAN Task 1),
# carrying the STANZA'S EXACT ghc-options per the CLAUDE.md
# flag-fidelity clause: this runner compiles the suite exactly as the
# frozen `cabal test all` will after the Task 2 freeze lands the
# stanza.
#
# proplang.cabal stays untouched pre-freeze: the suite is compiled
# out-of-cabal against the project package environment (cabal exec).
#
# usage: sh test-cirl/red-run.sh   (from the repo root)

set -eu
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-cirl-red.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

cabal exec -- ghc \
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -itest-cirl \
    -package tasty -package tasty-hunit -package tasty-quickcheck \
    -package QuickCheck -package process \
    -outputdir "$out" -o "$out/cirl" \
    test-cirl/Cirl.hs

"$out/cirl" "$@"
