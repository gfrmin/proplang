#!/bin/sh
# test-hygiene/ablation.sh — the Fn alphabet's raises-by-type rows
# (grammar-hygiene increment, GRAMMAR_HYGIENE_PLAN R6; FROZEN with the
# rest of test-hygiene/ at the Task 2 signing).
#
# audit/ablation.sh is frozen and cannot gain rows, so this increment
# carries its own runner for the two Fn members, invoked by the hygiene
# suite exactly as the frozen test 4 invokes the frozen runner. Per
# row, the same three checks (bare "compilation failed" is NOT a pass):
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under -DDROP_<MEMBER>
#   (c) attribution: the compile error names the deleted constructor
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-hygiene/ablation.sh [fnind|fnutil|all]   (default: all)

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-hygiene-ablation.$$"
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

fail=0

row() {
    name="$1"; flag="$2"; fixture="$3"; token="$4"
    # (a) positive control
    if ! "$GHC" -fno-code -isrc "test-hygiene/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the member deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "test-hygiene/ablation/$fixture" \
            -outputdir "$tmp/abl-$name" >"$tmp/abl-$name.log" 2>&1; then
        echo "FAIL [$name] ablation: fixture still compiles under -D$flag"
        fail=1
        return
    fi
    # (c) attribution: the error must name the deleted constructor
    if ! grep -q -w "$token" "$tmp/abl-$name.log"; then
        echo "FAIL [$name] attribution: compile error does not mention '$token'"
        cat "$tmp/abl-$name.log"
        fail=1
        return
    fi
    echo "PASS [$name] unutterable by type under -D$flag (error names $token)"
}

case "${1:-all}" in
    fnind)  row fnind  DROP_FNIND  UseFnInd.hs  FnInd ;;
    fnutil) row fnutil DROP_FNUTIL UseFnUtil.hs FnUtil ;;
    all)    row fnind  DROP_FNIND  UseFnInd.hs  FnInd
            row fnutil DROP_FNUTIL UseFnUtil.hs FnUtil ;;
    *)      echo "usage: $0 [fnind|fnutil|all]"; exit 2 ;;
esac

exit $fail
