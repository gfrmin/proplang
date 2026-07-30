#!/usr/bin/env bash
# readout sitting, script 2/3 — KEYLESS MECHANICS. Everything here is
# reviewable and reversible (git checkout); no key is touched.
# Running a [RULING] block intact accepts its drafted default —
# decline by editing BEFORE this script runs (the manifest loop below
# hashes the kit as run; 3-sign re-verifies it before any key act).
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# double-run guard
if grep -q "^test-suite readout" proplang.cabal; then
  echo "ABORT: the readout stanza is already spliced (2-freeze already ran)"
  exit 1
fi

sha256sum --quiet -c MANIFEST.sha256
echo "manifest pre-check OK"

# the stanza splice
printf '\n' >> proplang.cabal
cat test-readout/stanza.cabal.draft >> proplang.cabal
echo "stanza spliced (12 suites declared)"

# [RULING R6+R8, inventory F-2/F-3/F-4] the wire-doc install
git apply test-readout/freeze/membrane-wire-install.patch
echo "[RULING] membrane-wire install applied (p_codes bullet w/ consumer discipline + reply example + identity-table row + guards REQUIRED + the g7d citation re-home)"

# [RULING R7, inventory F-1] the OB-20/21 ledger flip
git apply test-readout/freeze/obligations-install.patch
echo "[RULING] OBLIGATIONS flip applied (OB-20/21 SCHEDULED -> DISCHARGED@battery-freeze-r0, CR5 quoted)"

# gate 5 on the spliced tree: THE PARTITION. The freeze seals a RED
# oracle (the dyadic precedent) — 11 standing suites PASS and the
# readout suite fails 6/6 BY DESIGN; a bare all-green here would
# prove the wrong thing.
set +e
cabal test all > test-readout/freeze/gate5-run.txt 2>&1
set -e
npass=$(grep -c "Test suite .*: PASS" test-readout/freeze/gate5-run.txt)
echo "standing suites PASS: $npass (want 11)"
test "$npass" -eq 11
grep -q "Test suite readout: FAIL" test-readout/freeze/gate5-run.txt
if ! grep -q "6 out of 6 tests failed" test-readout/freeze/gate5-run.txt; then
  readoutlog=$(ls -t dist-newstyle/build/*/*/proplang-*/t/readout/test/*.log | head -1)
  grep -q "6 out of 6 tests failed" "$readoutlog"
fi
echo "gate 5 partition holds: 11 PASS + readout 6/6 RED (gate5-run.txt recorded)"

# manifest: re-sign the three mutated frozen rows, then extend with
# the increment's 11 files (109 -> 120)
for f in proplang.cabal membrane-wire.md OBLIGATIONS.md; do
  row=$(sha256sum "$f")
  sed -i "s|^[0-9a-f]\{64\}  $f\$|$row|" MANIFEST.sha256
done
for f in test-readout/Readout.hs test-readout/stanza.cabal.draft \
         test-readout/opening/red-run.txt test-readout/opening/sat-run.txt \
         test-readout/freeze/membrane-wire-install.patch \
         test-readout/freeze/obligations-install.patch \
         test-readout/freeze/implementation-draft.diff \
         test-readout/freeze/freeze-commands.txt \
         test-readout/freeze/1-verify.sh \
         test-readout/freeze/2-freeze.sh \
         test-readout/freeze/3-sign.sh; do
  sha256sum "$f" >> MANIFEST.sha256
done
sha256sum --quiet -c MANIFEST.sha256
nrows=$(wc -l < MANIFEST.sha256)
echo "manifest extended + re-signed: $nrows rows (want 120)"
test "$nrows" -eq 120

bash tools/prefreeze-lint.sh | tee test-readout/freeze/lint-transcript.txt
grep -q " 0 FAIL" test-readout/freeze/lint-transcript.txt
echo "2-freeze: DONE (gate5-run.txt + lint-transcript.txt recorded; 3-sign is the author's)"
