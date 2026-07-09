#!/bin/sh
# test-d/red-run.sh — increment D's oracle-phase runner (HOSTS_D_PACK
# sections 10 and 15), carrying the STANZA'S EXACT ghc-options per
# the CLAUDE.md flag-fidelity clause: this compiles the suite AND the
# driver executable exactly as the frozen `cabal test all` will after
# D's freeze lands the test-d stanza.
#
# proplang.cabal stays untouched pre-freeze: everything is compiled
# out-of-cabal against the project package environment (cabal exec).
# The driver binary (H's, whose latent@1 path is stubbed) is built
# here and handed to gWire's process row via GOVHOST_EXE.
#
# Expected result in the oracle phase: COMPILES CLEAN under the full
# flag set, then runs GREEN on g0/gCensus/gRouting and gBudget's
# world-side rows (frozen surfaces only) and RED on gDegeneracy /
# gHeadline / gConsult / gTauMix / gLedger / gOffPath / gO3 /
# gDriver / gWire and gBudget's utility-side rows (the missing
# implementation) — the red proven to be runtime, not compile.
#
# usage: sh test-d/red-run.sh   (from the repo root)

set -eu
cd "$(dirname "$0")/.." || exit 2

out="${TMPDIR:-/tmp}/proplang-test-d-red.$$"
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
    -isrc -itest-d -ihost-governor \
    -package tasty -package tasty-hunit \
    -package process \
    -outputdir "$out/suite" -o "$out/test-d" \
    test-d/D.hs

GOVHOST_EXE="$out/proplang-govhost" "$out/test-d" "$@"
