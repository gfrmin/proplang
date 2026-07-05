#!/bin/sh
# test-membrane/ablation.sh — the membrane's raises-by-type rows
# (membrane increment, MEMBRANE_PLAN group 7; frozen with the rest of
# test-membrane/ at the Task 2 signing).
#
# audit/ablation.sh is frozen and cannot gain rows, so this increment
# carries its own runner (the canonized increment-protocol shape). Per
# row, the same three checks (bare "compilation failed" is NOT a pass):
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under -DDROP_<MEMBER>
#   (c) attribution: the compile error names the deleted item
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-membrane/ablation.sh [slot-grid|affordance|echo|all]
#        (default: all)

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-membrane-ablation.$$"
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

fail=0

row() {
    name="$1"; flag="$2"; fixture="$3"; token="$4"
    # (a) positive control
    if ! "$GHC" -fno-code -isrc "test-membrane/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the item deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "test-membrane/ablation/$fixture" \
            -outputdir "$tmp/abl-$name" >"$tmp/abl-$name.log" 2>&1; then
        echo "FAIL [$name] ablation: fixture still compiles under -D$flag"
        fail=1
        return
    fi
    # (c) attribution: the error must name the deleted item
    if ! grep -q -w "$token" "$tmp/abl-$name.log"; then
        echo "FAIL [$name] attribution: compile error does not mention '$token'"
        cat "$tmp/abl-$name.log"
        fail=1
        return
    fi
    echo "PASS [$name] unutterable by type under -D$flag (error names $token)"
}

case "${1:-all}" in
    slot-grid)  row slot-grid  DROP_SLOT_GRID  UseSlotGrid.hs   Slot ;;
    affordance) row affordance DROP_AFFORDANCE UseAffordance.hs Affordance ;;
    echo)       row echo       DROP_ECHO       UseEcho.hs       echoFeatures ;;
    all)        row slot-grid  DROP_SLOT_GRID  UseSlotGrid.hs   Slot
                row affordance DROP_AFFORDANCE UseAffordance.hs Affordance
                row echo       DROP_ECHO       UseEcho.hs       echoFeatures ;;
    *)          echo "usage: $0 [slot-grid|affordance|echo|all]"; exit 2 ;;
esac

exit $fail
