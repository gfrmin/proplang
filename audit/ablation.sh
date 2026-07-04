#!/bin/sh
# audit/ablation.sh — the deletion audit's raises-by-type rows (FROZEN).
#
# In the typed port, deleting the push/argmax verbs cannot raise at
# runtime the way the Python reference's NameError does: deletion is a
# code-level ablation (the GADT constructor sits behind a CPP flag in
# src/PropLang/Syntax.hs), so uttering a deleted verb is a COMPILE
# error. This script is the single source for those two rows: the
# frozen acceptance test (test 4) invokes it, and gate 7 invokes it —
# no duplicated ablation logic.
#
# Per row, three checks (bare "compilation failed" is NOT a pass):
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under -DDROP_<VERB>
#   (c) attribution: the compile error names the deleted constructor
#       (matched as a bare token; GHC-version sensitivity of the
#       message is recorded in PHASE1_REPORT.md — a toolchain change is
#       a documented re-open trigger for this row)
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: audit/ablation.sh [push|argmax|all]   (default: all)

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-ablation.$$"
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

fail=0

row() {
    name="$1"; flag="$2"; fixture="$3"; token="$4"
    # (a) positive control
    if ! "$GHC" -fno-code -isrc "audit/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the constructor deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "audit/ablation/$fixture" \
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
    push)   row push   DROP_PUSH   UsePush.hs   Push ;;
    argmax) row argmax DROP_ARGMAX UseArgmax.hs Argmax ;;
    all)    row push   DROP_PUSH   UsePush.hs   Push
            row argmax DROP_ARGMAX UseArgmax.hs Argmax ;;
    *)      echo "usage: $0 [push|argmax|all]"; exit 2 ;;
esac

exit $fail
