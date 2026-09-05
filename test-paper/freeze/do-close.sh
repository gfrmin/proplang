#!/usr/bin/env bash
# do-close.sh -- ONE script for the author to run the whole paper-freeze-r0
# close: THE TERMINUS.  Builder-authored, AUTHOR-RUN (the close.sh custody).
# It chains:
#   0 push -> 1 install the frozen-layer edits -> REVIEW GATE -> 2 commit
#   (your identity) -> 3 the key act (close.sh: readiness gate, sig probe,
#   gate 5, MANIFEST re-sign, lint, tag, checker) -> 4 push.
#
# Two human gates are preserved ON PURPOSE:
#   * after the install it prints the full diff and WAITS for you to type
#     'reviewed' -- the reviewed diff is the attestation, custody not
#     decoration.  This close repairs CLAUDE.md, the protocol itself; it is
#     the last place a rubber stamp belongs;
#   * close.sh keeps its own readiness gate and 6-second MANIFEST abort
#     window, and refuses to proceed over a red gate 5 or a red lint.
# This script performs NO key act itself: close.sh mints the tag with YOUR
# signing key, and the frozen-layer commit is made under YOUR git identity.
#
# Knobs:  SKIP_PUSH=1  (do not push in step 0 or 4)
#         RUN_GATE5=0  (passed through to close.sh -- skip gate 5 only if
#                       you just ran `cabal test all -j1` green on a quiet box)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
F=test-paper/freeze
say(){ printf '\n\033[1m== %s ==\033[0m\n' "$*"; }
die(){ printf '\nABORT: %s\n' "$*" >&2; exit 1; }

# ---- preflight (read-only) ----
[ "$(git rev-parse --abbrev-ref HEAD)" = master ] || die "not on master (freeze commits + tag live on master; do not branch)"
[ -z "$(git status --porcelain)" ] || die "working tree not clean -- commit or stash first (this script commits the frozen layer for you)"
! git rev-parse -q --verify refs/tags/paper-freeze-r0 >/dev/null || die "tag paper-freeze-r0 already exists -- close already done (or a stale tag must go)"
for f in frozen-layer.patch install-close-edits.sh pre-close-check.sh close.sh r0-tag-msg.txt CLOSE-RUNBOOK.md; do
  [ -f "$F/$f" ] || die "missing $F/$f (is the paper kit commit in HEAD?)"
done
[ -f PAPER.md ] && [ -f test-paper/check.sh ] || die "PAPER.md / test-paper/check.sh missing (is the paper draft commit in HEAD?)"
git apply --check "$F/frozen-layer.patch" 2>/dev/null \
  || git apply --check --reverse "$F/frozen-layer.patch" 2>/dev/null \
  || die "$F/frozen-layer.patch neither applies nor is already applied -- the frozen text moved; stop and report"

# ---- step 0: publish the builder commits ----
if [ "${SKIP_PUSH:-0}" != 1 ]; then
  say "step 0: git push origin master --follow-tags"
  git push origin master --follow-tags
else
  say "step 0: SKIP_PUSH=1 -- not pushing"
fi

# ---- step 1: install the frozen layer (FL-P1 CLAUDE.md, FL-P2 EXACT_PLAN.md) ----
say "step 1: install frozen-layer edits ($F/install-close-edits.sh)"
bash "$F/install-close-edits.sh"

if [ -z "$(git status --porcelain)" ]; then
  say "step 1: nothing to commit -- the frozen layer was ALREADY installed and committed."
else
  # ---- REVIEW GATE (custody: the reviewed diff is the attestation) ----
  say "REVIEW the frozen-layer diff (scroll up after this, or re-run: git diff)"
  git --no-pager diff
  printf '\nThis repairs CLAUDE.md (the protocol) and brackets EXACT_PLAN.md section 13.0.\n'
  printf 'Type exactly \033[1mreviewed\033[0m to COMMIT the frozen layer and run the close.\n'
  printf 'Anything else aborts (nothing committed, nothing signed): '
  read -r ans
  [ "$ans" = reviewed ] || die "not confirmed.  To discard the install: git checkout -- CLAUDE.md EXACT_PLAN.md"

  # ---- step 2: the frozen-layer commit (your identity) ----
  say "step 2: git commit -am '... (author)'"
  git commit -am "paper-freeze-r0: frozen-layer installs (FL-P1 CLAUDE.md, FL-P2 EXACT_PLAN.md) (author)"
fi

# ---- step 3: the key act (close.sh does readiness, probe, gate 5, MANIFEST, tag) ----
say "step 3: the key act -- $F/close.sh"
bash "$F/close.sh"

# ---- step 4: publish ----
if [ "${SKIP_PUSH:-0}" != 1 ]; then
  say "step 4: publish (fast-forward only, never the merge button)"
  git push origin master --follow-tags
else
  say "step 4: SKIP_PUSH=1 -- publish by hand: git push origin master --follow-tags"
fi
say "DONE -- paper-freeze-r0 closed.  THE ROADMAP HAS TERMINATED."
