#!/usr/bin/env bash
# readout sitting, script 1/3 — READ-ONLY verification: see what you
# are signing. Mutates nothing in the tree (the live run compiles to a
# throwaway temp dir). Runnable from anywhere: cd's to the repo root
# and exports the ghcup PATH (the f5 lesson).
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# the commits under review (base = the battery seal bd0d70c)
git log --oneline bd0d70c..HEAD

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# THE LIVE GREEN, executed here under the stanza's DEPENDENCY CLOSURE
# (-hide-all-packages plus the declared build-depends — the
# package-faithfulness law) and its exact flag set including -Werror.
# The library build is a cached no-op; it exists because `cabal exec`
# reads the project package db, which a fresh checkout lacks (the
# battery rehearsal's first red).
cabal build -v0 lib:proplang
tmp=$(mktemp -d)
cabal exec ghc -- -hide-all-packages -package base -package containers \
  -package directory -package process -package tasty -package tasty-hunit \
  -XGHC2021 -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
  -isrc -itest-readout -outputdir "$tmp" -o "$tmp/readout" \
  test-readout/Readout.hs > "$tmp/compile.log" 2>&1
# r6 spawns proplang-host over pipes, so it must be on PATH
cabal build -v0 exe:proplang-host
exedir=$(dirname "$(cabal list-bin exe:proplang-host)")
PATH="$exedir:$PATH" "$tmp/readout" > "$tmp/run.log" 2>&1
tail -2 "$tmp/run.log"                       # expect: All 19 tests passed
grep -q "All 19 tests passed" "$tmp/run.log"
echo "live green confirmed (19/19 on this tree, dependency-closed)"
rm -rf "$tmp"

# the prophecy was applied byte-for-byte: src == the sealed tree plus
# exactly the diff the oracle phase committed.
#
# THE `&& echo` FORM WAS A GATE THAT COULD NOT FAIL, and it is written
# out here rather than quietly corrected. Under `set -e` a command on
# the LEFT of `&&` does not abort the script — only the command after
# the final `&&` is checked — so a prophecy MISMATCH printed its diff,
# skipped the confirmation line, and fell through to "ALL CHECKS
# PASSED" with exit 0. The rehearsal could not see it: the diff
# matched, so the bug lived entirely on the red side of a check that
# had never been red. That is the mirror image of the green that
# cannot fail, in the one check this kit was assembled to add.
# Caught by the pre-tag adversarial read, 2026-08-01, and demonstrated
# before it was believed.
asbuilt=$(mktemp)
git diff bd0d70c..HEAD -- src/PropLang/Host.hs > "$asbuilt"
diff <(grep -E '^[+-]' test-readout/opening/prophecy.diff | grep -vE '^(\+\+\+|---)') \
     <(grep -E '^[+-]' "$asbuilt" | grep -vE '^(\+\+\+|---)')
rm -f "$asbuilt"
echo "as-built == the prophecy, line for line"

# the recorded evidence (frozen with the oracle)
echo "--- red run (the sealed pre-increment src) ---"
grep -E "out of|All 19" test-readout/opening/red-run.txt
echo "--- the implemented surface ---"
grep -E "out of|All 19" test-readout/opening/impl-run.txt
echo "--- kill matrix (every kill readout-unique) ---"
grep -E "row\(s\) fired|COMPILE DEATH" test-readout/opening/readout-kill-matrix.txt
echo "--- boundary audit at the opening ---"
tail -1 test-readout/opening/boundary-audit.txt

# the three frozen-layer patches this freeze applies
for p in test-readout/freeze/membrane-wire-readout.patch \
         test-readout/freeze/obligations-fl1.patch \
         test-readout/freeze/r-red-id.patch; do
  git apply --check -p1 "$p"
  echo "applies clean: $p"
done

echo
echo "ALL CHECKS PASSED - nothing was mutated. 2-freeze.sh next."
