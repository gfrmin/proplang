#!/usr/bin/env bash
# readout sitting, script 1/3 — READ-ONLY verification. Run freely,
# from anywhere (the f5 runnable-from-anywhere lesson + its
# package-db sibling: the cabal build below is a cached no-op in the
# drafting tree and the enabling step in a fresh clone).
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

echo "== commits under review (since the battery seal bd0d70c) =="
git log --oneline bd0d70c..HEAD

echo "== manifest (pre-freeze: 109 rows) =="
sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK ($(wc -l < MANIFEST.sha256) rows)"

echo "== the 11 standing suites, LIVE (pre-splice) =="
cabal build -v0 lib:proplang
cabal test all 2>&1 | grep "Test suite .*: PASS" | tee /tmp/readout-1v-standing.txt
npass=$(grep -c "Test suite .*: PASS" /tmp/readout-1v-standing.txt)
echo "standing suites PASS: $npass (want 11)"
test "$npass" -eq 11

echo "== the oracle 6/6 RED, LIVE (the thing being sealed; stanza-faithful flags + dependency closure) =="
tdir=$(mktemp -d)
cabal exec ghc -- -hide-all-packages -package base -package containers \
  -package tasty -package tasty-hunit -XGHC2021 -Wall -Werror \
  -Wincomplete-patterns -Wincomplete-uni-patterns -isrc -itest-readout \
  -outputdir "$tdir" -o "$tdir/readout" test-readout/Readout.hs >/dev/null 2>&1
set +e
"$tdir/readout" > "$tdir/red.txt" 2>&1
set -e
tail -1 "$tdir/red.txt"
grep -q "6 out of 6 tests failed" "$tdir/red.txt"
rm -rf "$tdir"
echo "red confirmed LIVE: 6/6"

echo "== the recorded transcripts (red + SAT) =="
tail -1 test-readout/opening/red-run.txt
tail -1 test-readout/opening/sat-run.txt

echo "== the three staged patches apply =="
git apply --check test-readout/freeze/membrane-wire-install.patch
git apply --check test-readout/freeze/obligations-install.patch
git apply --check test-readout/freeze/implementation-draft.diff
echo "all three apply cleanly"

echo "1-verify: ALL GREEN"
