#!/bin/sh
# test-membrane/red-run.sh — the oracle-phase runner (MEMBRANE_PLAN
# Task 1), carrying the STANZA'S EXACT ghc-options: the ExpFam re-open's
# process correction, first applied here. A red run proves nothing
# unless it is bit-faithful to the future gate conditions — same flags,
# same warning set — so this runner compiles the suite exactly as the
# frozen `cabal test all` will after the Task 2 freeze lands the stanza.
#
# proplang.cabal stays untouched pre-freeze: the suite is compiled
# out-of-cabal against the project package environment (cabal exec).
#
# usage: sh test-membrane/red-run.sh   (from the repo root)

set -eu
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-membrane-red.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

cabal exec -- ghc \
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -itest-membrane -itest \
    -package tasty -package tasty-hunit -package tasty-quickcheck \
    -package QuickCheck -package process \
    -outputdir "$out" -o "$out/membrane" \
    test-membrane/Membrane.hs

"$out/membrane" "$@"
