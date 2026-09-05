#!/usr/bin/env bash
# install-close-edits.sh -- applies the paper-freeze-r0 frozen-layer patch
# (FL-P1 CLAUDE.md, FL-P2 EXACT_PLAN.md) into the working tree.  Makes NO
# commit and NO tag: the author reviews the resulting diff and commits it
# under their own identity (do-close.sh's REVIEW GATE, or by hand per
# CLOSE-RUNBOOK.md).
#
# The patch is the builder's DRAFT of the repairs named in
# test-paper/terminus-inventory.md; applying it is the AUTHOR's act.  It
# is applied whole (`git apply`), never hand-retyped -- the inventory's
# prose and this patch are ONE artefact, not two hand-maintained copies
# (the one-generator law).
#
# Idempotence is enforced, not hoped for: if the patch is already applied
# the script says so and exits 0 without touching anything.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
P=test-paper/freeze/frozen-layer.patch

[ -f "$P" ] || { echo "ABORT: missing $P" >&2; exit 1; }

# already applied?  (reverse-applies cleanly => it is in the tree)
if git apply --check --reverse "$P" 2>/dev/null; then
  echo "install: frozen-layer patch is ALREADY APPLIED -- nothing to do."
  exit 0
fi

if ! git apply --check "$P" 2>/dev/null; then
  echo "ABORT: $P does not apply cleanly to this tree." >&2
  echo "       The frozen text moved under the draft.  Do NOT hand-edit:" >&2
  echo "       stop and report, and the patch is regenerated from the" >&2
  echo "       inventory at test-paper/terminus-inventory.md." >&2
  git apply --check "$P" || true
  exit 1
fi

git apply "$P"
echo "install: frozen-layer patch applied (FL-P1 CLAUDE.md, FL-P2 EXACT_PLAN.md)."

# substance gate: both files must actually have changed, and the terminus
# marker must be present in each.  Errs red on what it sees.
fail=0
for f in CLAUDE.md EXACT_PLAN.md; do
  if git diff --quiet -- "$f"; then
    echo "  [FAIL] $f UNCHANGED after apply" >&2; fail=1
  else
    echo "  [ OK ] $f changed"
  fi
done
grep -qF -- "ROADMAP TERMINATED at paper-freeze-r0" CLAUDE.md \
  && echo "  [ OK ] FL-P1 marker present (ROADMAP TERMINATED at paper-freeze-r0)" \
  || { echo "  [FAIL] FL-P1 marker absent from CLAUDE.md" >&2; fail=1; }
grep -qF -- "TERMINATED 2026-09-05 at paper-freeze-r0" EXACT_PLAN.md \
  && echo "  [ OK ] FL-P2 marker present (TERMINATED 2026-09-05 at paper-freeze-r0)" \
  || { echo "  [FAIL] FL-P2 marker absent from EXACT_PLAN.md" >&2; fail=1; }

# the quoted-falsified-clause discipline: FL-P1 is normative prose, so the
# sentence it repairs must survive INSIDE the repair, in quotes.
grep -qF -- 'read "ONE ITEM REMAINS: step 5' CLAUDE.md \
  && echo "  [ OK ] FL-P1 quotes the falsified clause inside its own repair" \
  || { echo "  [FAIL] FL-P1 does not quote the falsified clause" >&2; fail=1; }

[ "$fail" -eq 0 ] || { echo "install: SUBSTANCE GATE FAILED -- review before committing." >&2; exit 1; }
echo "install: done.  REVIEW THE DIFF (git diff), then commit under your identity."
