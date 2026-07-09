#!/bin/sh
# test-d/ablation.sh — increment D's deletion rows (HOSTS_D_PACK
# section 9; frozen with the rest of test-d/ at D's signing).
#
# audit/ablation.sh is frozen and cannot gain rows, so this increment
# carries its own runner (the canonized 4-check shape; bare
# "compilation failed" is NOT a pass):
#   (0) layer absence: the driver-facing src still compiles under the
#       flag — the layer dies whole, nothing else does
#   (a) positive control: the fixture compiles against the real surface
#   (b) ablation: the fixture fails to compile under the flag
#   (c) attribution: the compile error names the deleted surface
#
# D's two rows:
#   upilot  DROP_UPILOT  the whole latent-utility surface dies
#           together (the triple-guard: sorts, enumerator, kernel,
#           readout, pilot, both driver faces)
#   uwalk   DROP_UWALK   the drift sort alone dies — restricted
#           enumeration; gHeadline's floor collapses to the frozen
#           decay (drift is the floor's SOLE source)
#
# src/ depends on base only, so `ghc -isrc` needs no package flags.
# Set $GHC to override the compiler (defaults to `ghc` on PATH).
#
# usage: test-d/ablation.sh [upilot|uwalk|all]

set -u
GHC="${GHC:-ghc}"
cd "$(dirname "$0")/.." || exit 2

tmp="${TMPDIR:-/tmp}/proplang-test-d-ablation.$$"
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
    if ! "$GHC" -fno-code -isrc "test-d/ablation/$fixture" \
            -outputdir "$tmp/ctl-$name" >"$tmp/ctl-$name.log" 2>&1; then
        echo "FAIL [$name] positive control: fixture does not compile without -D$flag"
        cat "$tmp/ctl-$name.log"
        fail=1
        return
    fi
    # (b) ablation: with the layer deleted, the fixture must not compile
    if "$GHC" -fno-code -isrc "-D$flag" "test-d/ablation/$fixture" \
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
    upilot) row upilot DROP_UPILOT UseUPilot.hs \
              "UPilot enumerateUModels verdictKernel latentMarginal membraneTickU runMembraneU mkTauSpec UFamily" ;;
    uwalk)  row uwalk  DROP_UWALK  UseUWalk.hs  "UWalk" ;;
    all)
        row upilot DROP_UPILOT UseUPilot.hs \
          "UPilot enumerateUModels verdictKernel latentMarginal membraneTickU runMembraneU mkTauSpec UFamily"
        row uwalk  DROP_UWALK  UseUWalk.hs  "UWalk"
        ;;
    *) echo "unknown row: $target"; exit 2 ;;
esac

exit "$fail"
