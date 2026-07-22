#!/bin/sh
# test-transport/red-run.sh — the oracle-phase runner for the #18
# transport suite, carrying the STANZA'S EXACT ghc-options (the ExpFam
# re-open's process correction; flag-faithful means FLAG-faithful, the
# step-5 amendment). proplang.cabal stays untouched pre-freeze: the
# suite compiles out-of-cabal against the project package environment
# (cabal exec), exactly as `cabal test all` will after the freeze
# lands test-transport/stanza.cabal.draft.
#
# The suite resolves the proplang-host binary via PATH (findExecutable)
# — the FIRST process-level oracle class, so the runner's one extra
# duty over the membrane precedent is placing a binary on PATH:
#   red run:  PATH gets the HEAD dist binary's dir (default below)
#   SAT run:  PATH gets a throwaway prototype's dir (R-D21 overlay)
# Override with TRANSPORT_HOST_DIR.
#
# usage: sh test-transport/red-run.sh   (from the repo root)

set -eu
cd "$(dirname "$0")/.." || exit 2

hostdir="${TRANSPORT_HOST_DIR:-$PWD/dist-newstyle/build/x86_64-linux/ghc-9.10.3/proplang-0.1.0.0/x/proplang-host/build/proplang-host}"
[ -x "$hostdir/proplang-host" ] || {
  echo "no proplang-host in $hostdir (build it, or set TRANSPORT_HOST_DIR)" >&2
  exit 2
}

out="${TMPDIR:-/tmp}/proplang-transport-red.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

cabal exec -- ghc \
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -itest-transport \
    -package tasty -package tasty-hunit -package process -package directory \
    -outputdir "$out" -o "$out/transport" \
    test-transport/Transport.hs

PATH="$hostdir:$PATH" "$out/transport" "$@"
