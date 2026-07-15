#!/bin/sh
# test-sentence/ablation/run.sh — step 3's increment-local ablation
# runner (decision 9: increment-local fixtures for Code / Pos / ToR;
# the CPP hooks were wired at Syntax.hs:38-44 at step 1, the fixtures
# land here). MECHANICS COPIED from the frozen audit/ablation.sh
# (R-D20-i; deltas: the row table below, the fixture directory, and
# cd two levels up). Frozen audit scripts never grow rows — this
# runner is the increment's own.
#
# Per row, three checks (bare "compilation failed" is NOT a pass):
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under -DDROP_<NAME>
#   (c) attribution: the compile error names the deleted constructor
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-sentence/ablation/run.sh [code|pos|tor|all]   (default: all)

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/../.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-sentence-ablation.$$"
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

fail=0

row() {
    name="$1"; flag="$2"; fixture="$3"; token="$4"
    # (a) positive control
    if ! "$GHC" -fno-code -isrc "test-sentence/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the constructor deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "test-sentence/ablation/$fixture" \
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
    code) row code DROP_CODE UseCode.hs Code ;;
    pos)  row pos  DROP_POS  UsePos.hs  Pos ;;
    tor)  row tor  DROP_TOR  UseTor.hs  ToR ;;
    all)  row code DROP_CODE UseCode.hs Code
          row pos  DROP_POS  UsePos.hs  Pos
          row tor  DROP_TOR  UseTor.hs  ToR ;;
    *)    echo "usage: $0 [code|pos|tor|all]"; exit 2 ;;
esac

exit $fail
