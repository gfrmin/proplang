#!/bin/sh
# test-govhost/ablation.sh — H's deletion rows (HOSTS_PLAN 2.9; frozen
# with the rest of test-govhost/ at H's signing).
#
# audit/ablation.sh is frozen and cannot gain rows, so this increment
# carries its own runner (the canonized 4-check shape; bare
# "compilation failed" is NOT a pass):
#   (0) layer absence: all of the driver-facing src still compiles
#       under the flag — the layer dies whole, nothing else does
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under the flag
#   (c) attribution: the compile error names the deleted surface
#
# H adds NO grammar surface, so there is no new DROP flag: these are
# CONSUMER-COUPLING rows under the EXISTING flags — the driver's
# fixture must die with the argmax verb (nothing may select an action
# but expected value), with the affordance layer (no menu, no choice
# flow), and with the echo layer (the membrane driver dies with the
# membrane). The RESTRICTED-ENUMERATION row (guard families die
# without TGet at the governor namespace) lives in the suite itself
# (GovHost.hs g3), the frozen deletion table's precedent.
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-govhost/ablation.sh [argmax|affordance|echo|all]

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-govhost-ablation.$$"
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
    if ! "$GHC" -fno-code -isrc "test-govhost/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the layer deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "test-govhost/ablation/$fixture" \
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
    argmax)     row argmax     DROP_ARGMAX     UseDriver.hs "argmaxEU" ;;
    affordance) row affordance DROP_AFFORDANCE UseDriver.hs "menuOptions Affordance wMenu Fire" ;;
    echo)       row echo       DROP_ECHO       UseDriver.hs "runMembrane noEcho EchoSpec" ;;
    all)
        row argmax     DROP_ARGMAX     UseDriver.hs "argmaxEU"
        row affordance DROP_AFFORDANCE UseDriver.hs "menuOptions Affordance wMenu Fire"
        row echo       DROP_ECHO       UseDriver.hs "runMembrane noEcho EchoSpec"
        ;;
    *) echo "unknown row: $target"; exit 2 ;;
esac

exit "$fail"
