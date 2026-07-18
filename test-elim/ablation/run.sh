#!/bin/sh
# test-elim/ablation/run.sh -- step 9's increment-local ablation runner
# (D-f9: the deletion audit UNIFIED on FOUR checks, with the
# GENERIC/SELF-LICENSED column). The new terminals Expect / SawE / ElimJ
# each prove deletable-and-attributable against the real grammar.
# MECHANICS COPIED from the frozen audit/ablation.sh and the step-3
# runner test-sentence/ablation/run.sh (R-D20-i; deltas: the row table,
# the fixture dir, and check (0)). Frozen audit scripts never grow rows.
#
# Per row, FOUR checks (bare "compilation failed" is NOT a pass):
#   (0) LAYER ABSENCE + classification: does ALL of src compile under
#       -DDROP_<NAME>?  GENERIC => yes (src only pattern-matches it, the
#       arms CPP-guarded).  SELF-LICENSED => no (src CONSTRUCTS it, e.g.
#       Expect in Membrane.argmaxEU) -- and that failure IS the license:
#       the layer needs it.  The row declares its expected kind.
#   (a) positive control: the fixture compiles against the real grammar
#   (b) ablation: the fixture fails to compile under -DDROP_<NAME>
#   (c) attribution: the compile error names the deleted constructor
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-elim/ablation/run.sh [expect|sawe|elimj|all]   (default: all)

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/../.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-elim-ablation.$$"
mkdir -p "$tmp" || exit 2
trap 'rm -rf "$tmp"' EXIT INT TERM

fail=0

# check (0): the full-src closure under the DROP flag, via Host.hs (top
# of the dependency graph). kind in {generic, self}.
layer() {
    name="$1"; flag="$2"; kind="$3"
    if "$GHC" -fno-code -isrc "-D$flag" src/PropLang/Host.hs \
            -outputdir "$tmp/la-$name" >"$tmp/la-$name.log" 2>&1; then
        got=generic
    else
        got=self
    fi
    if [ "$got" != "$kind" ]; then
        echo "FAIL [$name] (0) layer absence: expected $kind, src is $got under -D$flag"
        fail=1
        return 1
    fi
    if [ "$kind" = self ]; then
        echo "PASS [$name] (0) SELF-LICENSED: src constructs it; -D$flag breaks src (the license)"
    else
        echo "PASS [$name] (0) GENERIC: all src compiles under -D$flag (only pattern-matched)"
    fi
    return 0
}

row() {
    name="$1"; flag="$2"; kind="$3"; fixture="$4"; token="$5"
    layer "$name" "$flag" "$kind" || return
    # (a) positive control
    if ! "$GHC" -fno-code -isrc "test-elim/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] (a) positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"; fail=1; return
    fi
    # (b) ablation
    if "$GHC" -fno-code -isrc "-D$flag" "test-elim/ablation/$fixture" \
            -outputdir "$tmp/abl-$name" >"$tmp/abl-$name.log" 2>&1; then
        echo "FAIL [$name] (b) ablation: fixture still compiles under -D$flag"; fail=1; return
    fi
    # (c) attribution
    if ! grep -q -w "$token" "$tmp/abl-$name.log"; then
        echo "FAIL [$name] (c) attribution: compile error does not mention '$token'"
        cat "$tmp/abl-$name.log"; fail=1; return
    fi
    echo "PASS [$name] (a-c) unutterable by type under -D$flag (error names $token)"
}

case "${1:-all}" in
    expect) row expect DROP_EXPECT self    UseExpect.hs Expect ;;
    sawe)   row sawe   DROP_SAWE   generic UseSawE.hs   SawE ;;
    elimj)  row elimj  DROP_ELIMJ  generic UseElimJ.hs  ElimJ ;;
    all)
        row expect DROP_EXPECT self    UseExpect.hs Expect
        row sawe   DROP_SAWE   generic UseSawE.hs   SawE
        row elimj  DROP_ELIMJ  generic UseElimJ.hs  ElimJ
        ;;
    *) echo "usage: $0 [expect|sawe|elimj|all]" >&2; exit 2 ;;
esac

exit "$fail"
