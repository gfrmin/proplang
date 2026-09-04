#!/usr/bin/env bash
# measure-drift.sh -- READ-ONLY.  Runs the drift-a cell and prints the observed
# deep/shallow mean ratio -- the RATIO-form re-mint value for selection-freeze-r1
# (register R8 / chooseeu-sitting-r0 clause 6).  Makes NO tree mutation, no
# commit, no tag.
#
# The deep/shallow ratio is FAR more load-robust than the absolute means (a
# loaded-box rehearsal moved the means ~97% and this ratio ~3.6%) -- but load
# STILL nudges it past the +/-0.03 band, so it is NOT invariant.  What makes the
# gate pass is that the frozen value IS this box's own measurement and gate 5
# re-measures on the SAME box: keep the box quiet/stable between this read and
# gate 5 and the delta is ~0.  Run BEFORE the frozen commit -- the old drift-a
# body prints the same REPORT line, so the read works either side of the install.
set -u
cd "$(git rev-parse --show-toplevel)"
out=$(mktemp); trap 'rm -f "$out"' EXIT
echo "measure-drift: building + running the drift-a cell (serialized; a few min)..."
cabal test breadth --test-options='-p /drift-a/' --test-show-details=streaming 2>&1 | tee "$out" || true
ratio=$(sed -n 's/.*REPORT deep\/shallow mean ratio \([0-9.][0-9.]*\).*/\1/p' "$out" | tail -1)
echo
if [ -z "$ratio" ]; then
  echo "measure-drift: no 'REPORT deep/shallow mean ratio' line found above." >&2
  exit 1
fi
echo "=================================================================="
echo "  observed deep/shallow mean ratio = $ratio"
echo "  next:  bash test-selection/freeze/install-close-edits.sh $ratio"
echo "  (or just run: bash test-selection/freeze/do-close.sh)"
echo "=================================================================="
echo "DRIFT_RATIO=$ratio"
