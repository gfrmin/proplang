#!/bin/sh
# test-cirl/ablation.sh — the pointer's deletion row (CIRL_PLAN C7/C8;
# frozen with the rest of test-cirl/ at the Task 2 signing).
#
# audit/ablation.sh is frozen and cannot gain rows, so this increment
# carries its own runner (the canonized shape). The row runs FOUR
# checks (bare "compilation failed" is NOT a pass):
#   (0) layer absence: all of src/ still compiles under -DDROP_USAY —
#       the door dies; the worlds, the verbs, the myopic base, the
#       ladder, and the preposterior all survive
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under -DDROP_USAY
#   (c) attribution: the compile error names the deleted surface
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-cirl/ablation.sh [usay|all]   (default: all)

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-cirl-ablation.$$"
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

fail=0

row() {
    name="$1"; flag="$2"; fixture="$3"; tokens="$4"
    # (0) layer absence: src stays whole with the layer deleted
    if ! "$GHC" -fno-code -isrc "-D$flag" \
            src/PropLang/Membrane.hs src/PropLang/Host.hs \
            -outputdir "$tmp/src-$name" >"$tmp/src-$name.log" 2>&1; then
        echo "FAIL [$name] layer absence: src/ does not compile under -D$flag"
        cat "$tmp/src-$name.log"
        fail=1
        return
    fi
    # (a) positive control
    if ! "$GHC" -fno-code -isrc "test-cirl/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the layer deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "test-cirl/ablation/$fixture" \
            -outputdir "$tmp/abl-$name" >"$tmp/abl-$name.log" 2>&1; then
        echo "FAIL [$name] ablation: fixture still compiles under -D$flag"
        fail=1
        return
    fi
    # (c) attribution: the error names the deleted surface
    for tok in $tokens; do
        if grep -q "$tok" "$tmp/abl-$name.log"; then
            echo "PASS [$name] deleted; error names $tok"
            return
        fi
    done
    echo "FAIL [$name] attribution: error does not name any of: $tokens"
    cat "$tmp/abl-$name.log"
    fail=1
}

target="${1:-all}"

case "$target" in
    usay|all) row usay DROP_USAY UseUSay.hs "USay" ;;
    *) echo "unknown row: $target"; exit 2 ;;
esac

exit "$fail"
