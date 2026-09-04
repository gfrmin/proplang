#!/usr/bin/env bash
# install-close-edits.sh -- AUTHOR-RUN.  Applies the reviewed frozen-layer.patch
# (every verbatim frozen edit for selection-freeze-r1) and sets the drift-a
# ratio re-mint, then prints the diff for YOUR review and STOPS.  It makes NO
# commit, does NOT touch MANIFEST, does NOT tag -- those are your key acts (see
# CLOSE-RUNBOOK.md).  Custody: the builder authored the patch (the FL/OB/L5/drift
# drafts in applyable form); running it + reviewing the diff + committing under
# your identity + the signed tag IS the attestation -- the close.sh precedent.
#
# Usage:  bash test-selection/freeze/install-close-edits.sh <drift-ratio>
#         (get <drift-ratio> from: bash test-selection/freeze/measure-drift.sh)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
ratio="${1:-}"
case "$ratio" in
  ''|*[!0-9.]* ) echo "usage: install-close-edits.sh <drift-ratio>  (a decimal, e.g. 2.0033)" >&2; exit 2;;
esac
PATCH="test-selection/freeze/frozen-layer.patch"
[ -f "$PATCH" ] || { echo "ABORT: $PATCH not found." >&2; exit 1; }

# 1. clean tree -- close.sh commits only MANIFEST, so the frozen edits must be a
#    clean, reviewable author commit of their own.
if [ -n "$(git status --porcelain)" ]; then
  echo "ABORT: working tree is not clean.  Commit or stash first, then re-run." >&2
  git status --short >&2; exit 1
fi

# 2. apply cleanly or STOP (never a partial install).
if ! git apply --check "$PATCH" 2>/tmp/ice.$$; then
  echo "ABORT: $PATCH does not apply cleanly to HEAD:" >&2; cat /tmp/ice.$$ >&2; rm -f /tmp/ice.$$
  echo >&2
  echo "The frozen targets drifted from what the patch was cut against.  Hand-install" >&2
  echo "from the drafts instead: FL-1/2/3 in chooseeu-sitting/drafts/FL-repairs.txt;" >&2
  echo "the L5 rev-2 block is the '# L5-BEGIN'..'# L5-END' hunk of $PATCH; OB-24/30/33/34" >&2
  echo "and the drift-a body are its other hunks.  Then set driftFrozenMeanRatio by hand." >&2
  exit 1
fi
rm -f /tmp/ice.$$
git apply "$PATCH"

# 3. the one author-measured value.
grep -q '__DRIFT_RATIO__' test-breadth/Breadth.hs \
  || { echo "ABORT: __DRIFT_RATIO__ placeholder gone after apply (already applied?)." >&2; exit 1; }
sed -i "s/__DRIFT_RATIO__/$ratio/" test-breadth/Breadth.hs
echo "installed: frozen-layer.patch applied; driftFrozenMeanRatio set to $ratio"
echo
git --no-pager diff --stat
echo
echo "------------------------------------------------------------------"
echo "REVIEW the full diff:        git diff"
echo "optional demo (7/7):         bash test-selection/freeze/l5-demo.sh"
echo "COMMIT (your identity):      git commit -am 'selection-freeze-r1: frozen-layer installs + drift-a re-mint (author)'"
echo "the key act:                 bash test-selection/freeze/close.sh"
echo "------------------------------------------------------------------"
echo "This script made NO commit and did NOT touch MANIFEST or any tag."
