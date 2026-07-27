#!/usr/bin/env bash
# jp sitting, script 1/3 — READ-ONLY verification: see what you are
# signing. Mutates nothing; run as often as you like, before and
# during review. (Runnable from anywhere: cd's to the repo root and
# exports the ghcup PATH — the f5 first-run lesson.)
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# the commits under review (the mandate round's dispositions are pack
# Part XII; the register is JP1-JP10, every item measured)
git log --oneline 362e1c4..HEAD

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"
tail -3 test-jointprep/opening/red-run.txt    # 15/15 RED vs stubs
tail -3 test-jointprep/opening/sat-run.txt    # 15/15 SAT vs the overlay
cat test-completeness/opening/jp7-clairvoyance-run.txt  # the hindsight rename's ground
cat test-completeness/opening/jp8-voi-run.txt           # the VoI bank re-executed
git apply --check test-jointprep/freeze/implementation.diff
echo "prophecy applies"
git apply --check test-jointprep/freeze/e4-extension.patch
echo "e4 extension applies"

echo "ALL VERIFY CHECKS PASSED (read-only; nothing mutated)"
