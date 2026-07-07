#!/bin/sh
# test-govhost/red-run.sh — the oracle-phase runner (HOSTS_PLAN 2.9),
# carrying the STANZA'S EXACT ghc-options per the CLAUDE.md
# flag-fidelity clause: this runner compiles the suite AND the driver
# executable exactly as the frozen `cabal test all` will after H's
# freeze lands the stanzas.
#
# proplang.cabal stays untouched pre-freeze: everything is compiled
# out-of-cabal against the project package environment (cabal exec).
# The stub binary is built here and handed to g5 via GOVHOST_EXE (the
# stanza's build-tool-depends takes over at the freeze).
#
# Expected result in the oracle phase: COMPILES CLEAN under the full
# flag set, then runs RED on g1/g2/g5 (the missing implementation)
# and GREEN on g0/gP5/g3/g4 (frozen surfaces only) — the red proven
# to be runtime, not compile.
#
# usage: sh test-govhost/red-run.sh   (from the repo root)

set -eu
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-govhost-red.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

# the driver executable, stanza flags verbatim
cabal exec -- ghc \
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -ihost-governor \
    -outputdir "$out/exe" -o "$out/proplang-govhost" \
    host-governor/Main.hs

# the oracle suite, stanza flags verbatim
cabal exec -- ghc \
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -itest-govhost -ihost-governor \
    -package tasty -package tasty-hunit -package tasty-quickcheck \
    -package QuickCheck -package process \
    -outputdir "$out/suite" -o "$out/govhost" \
    test-govhost/GovHost.hs

GOVHOST_EXE="$out/proplang-govhost" "$out/govhost" "$@"
