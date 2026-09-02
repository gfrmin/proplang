#!/usr/bin/env bash
# The #24 sitting r1 -- closing verification.  Read-only against the frozen
# layer; asserts the round touched nothing it may not touch.
set -uo pipefail
cd "$(dirname "$0")/.."
echo "=== 1. CUSTODY: only new/untracked paths, no tracked file modified ==="
git status --porcelain
echo "  (expect exactly: ?? bench/, ?? chooseeu-author-pack.md, ?? chooseeu-sitting/)"
mod=$(git status --porcelain | grep -cE '^( M|M |MM|A |D )' || true)
[ "$mod" -eq 0 ] && echo "  PASS no tracked file modified" || echo "  FAIL $mod tracked file(s) modified"
echo
echo "=== 2. MANIFEST (frozen gate 6) ==="
if sha256sum -c MANIFEST.sha256 >/dev/null 2>&1; then
  echo "  PASS $(grep -c . MANIFEST.sha256) rows verified"
else
  echo "  FAIL"; sha256sum -c MANIFEST.sha256 2>&1 | grep -v ': OK$' | head
fi
echo
echo "=== 3. BOUNDARY AUDIT ==="
bash tools/boundary-audit.sh 2>&1 | tail -3
echo
echo "=== 4. PRE-FREEZE LINT ==="
echo "  EXPECTED: 4 FAIL, all L5, all the F2 defect this pack reports."
echo "  This pack REPRODUCES the defect by naming it -- see F2 and R4."
bash tools/prefreeze-lint.sh 2>&1 | tail -14
echo
echo "=== 5. THE GENERATOR IDENTITY ROW (bench/P2Real.hs) ==="
python3 bench/gen-p2real.py --check
echo
echo "=== 6. BENCH INSTRUMENT TESTS ==="
~/.cache/proplang-bench/bench-test 2>&1 | tail -2
