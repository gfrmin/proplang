#!/usr/bin/env bash
# battery sitting, script 1/3 — READ-ONLY verification: see what you
# are signing. Mutates nothing in the tree (the live run compiles to a
# throwaway temp dir); run as often as you like, before and during
# review. (Runnable from anywhere: cd's to the repo root and exports
# the ghcup PATH — the f5 first-run lesson.)
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# the commits under review (base = the jp close seal a2dcbbc; the
# mandate round's dispositions are pack Part XVII, the no-red-owed
# record and this kit are Part XVIII)
git log --oneline a2dcbbc..HEAD

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# the LIVE green (PIN-FREEZE form: the suite you are freezing is green
# NOW, on this tree — executed here under the stanza's dependency
# closure, the package-faithfulness law; ~90s)
tmp=$(mktemp -d)
cabal exec ghc -- -hide-all-packages -package base -package containers \
  -package tasty -package tasty-hunit -XGHC2021 \
  -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
  -isrc -itest -itest-battery -outputdir "$tmp" -o "$tmp/battery" \
  test-battery/Battery.hs > "$tmp/compile.log" 2>&1
"$tmp/battery" > "$tmp/run.log" 2>&1
tail -2 "$tmp/run.log"                       # expect: All 82 tests passed
grep -q "All 82 tests passed" "$tmp/run.log"
echo "live green confirmed (82/82 on this tree)"
rm -rf "$tmp"

# the recorded evidence (frozen with the oracle)
tail -2 test-battery/opening/green-run.txt   # the committed 82-row green
tail -12 test-battery/opening/battery-kill-matrix.txt  # the supersession: no red owed
tail -6 test-battery/opening/knife-probe.txt # the structural-cap probe record
tail -4 test-battery/opening/seeded-red.txt  # the designed-kill demonstrations

# the three [RULING] patches all apply to this tree (the two CLAUDE.md
# clauses are sequential, so the second is dry-run-checked on a temp
# copy carrying the first)
git apply --check test-completeness/freeze/boundary-audit-repair.patch
echo "R-CR7 boundary-audit repair applies"
git apply --check test-battery/freeze/no-silent-caps.patch
echo "R-CAPS no-silent-caps clause applies"
ptmp=$(mktemp -d)
cp CLAUDE.md "$ptmp/"
patch -p1 -s -d "$ptmp" < test-battery/freeze/no-silent-caps.patch
patch -p1 -s --dry-run -d "$ptmp" < test-battery/freeze/red-constructed.patch
echo "R-RED red-constructed clause applies (on top of R-CAPS)"
rm -rf "$ptmp"

echo "ALL VERIFY CHECKS PASSED (read-only; nothing mutated)"
