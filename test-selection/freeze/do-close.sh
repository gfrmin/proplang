#!/usr/bin/env bash
# do-close.sh -- ONE script for the author to run the whole selection-freeze-r1
# close.  Builder-authored, AUTHOR-RUN (the close.sh custody).  It chains:
#   0 push -> 1 measure drift -> 2 install frozen edits + L5 demo -> REVIEW GATE
#   -> 3 commit (your identity) -> 4 the key act (close.sh: sig probe, gate 5,
#   MANIFEST re-sign, tag) -> 5 push + close #24.
#
# Two human gates are preserved ON PURPOSE:
#   * after the install it prints the full diff and WAITS for you to type
#     'reviewed' -- the reviewed diff is the attestation, custody not decoration;
#   * close.sh keeps its own 6-second MANIFEST abort window and gate 5.
# This script performs NO key act itself: close.sh mints the tag with YOUR
# signing key, and the frozen-layer commit is made under YOUR git identity.
#
# Knobs:  SKIP_PUSH=1  (do not push in step 0 or 5)
#         RATIO=<val>  (skip the drift measurement, use this ratio)
#         RUN_GATE5=0  (passed through to close.sh -- skip gate 5 only if you
#                       just ran `cabal test all -j1` green on a quiet box)
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
F=test-selection/freeze
say(){ printf '\n\033[1m== %s ==\033[0m\n' "$*"; }
die(){ printf '\nABORT: %s\n' "$*" >&2; exit 1; }

# ---- preflight (read-only) ----
[ "$(git rev-parse --abbrev-ref HEAD)" = master ] || die "not on master (freeze commits + tag live on master; do not branch)"
[ -z "$(git status --porcelain)" ] || die "working tree not clean -- commit or stash first (this script commits the frozen layer for you)"
! git rev-parse -q --verify refs/tags/selection-freeze-r1 >/dev/null || die "tag selection-freeze-r1 already exists -- close already done (or a stale tag must go)"
for f in frozen-layer.patch install-close-edits.sh measure-drift.sh l5-demo.sh close.sh; do
  [ -f "$F/$f" ] || die "missing $F/$f (is the pt.4 builder commit in HEAD?)"
done
grep -q '__DRIFT_RATIO__' "$F/frozen-layer.patch" || die "frozen-layer.patch has no __DRIFT_RATIO__ placeholder (already consumed?)"

# ---- step 0: publish r0a chain + the builder commit ----
if [ "${SKIP_PUSH:-0}" != 1 ]; then
  say "step 0: git push origin master --follow-tags"
  git push origin master --follow-tags
else
  say "step 0: SKIP_PUSH=1 -- not pushing"
fi

# ---- step 1: measure the box-invariant drift ratio ----
ratio="${RATIO:-}"
if [ -z "$ratio" ]; then
  say "step 1: measure drift ratio ($F/measure-drift.sh) -- a few min on a quiet box"
  mout=$(mktemp); trap 'rm -f "$mout"' EXIT
  bash "$F/measure-drift.sh" | tee "$mout"
  ratio=$(sed -n 's/^DRIFT_RATIO=//p' "$mout" | tail -1)
  [ -n "$ratio" ] || die "could not read DRIFT_RATIO from measure-drift.sh"
else
  say "step 1: RATIO=$ratio supplied -- skipping the measurement"
fi
say "drift ratio = $ratio"

# ---- step 2: install the frozen layer + set the ratio, then the L5 demo ----
say "step 2: install frozen edits ($F/install-close-edits.sh $ratio)"
bash "$F/install-close-edits.sh" "$ratio"
say "L5 two-sided demo ($F/l5-demo.sh)"
bash "$F/l5-demo.sh" || die "L5 demo did not pass 7/7 -- investigate before committing"

# ---- REVIEW GATE (custody: the reviewed diff is the attestation) ----
say "REVIEW the frozen-layer diff (scroll up after this, or re-run: git diff)"
git --no-pager diff
printf '\nType exactly \033[1mreviewed\033[0m to COMMIT the frozen layer and run the close.\n'
printf 'Anything else aborts (nothing committed, nothing signed): '
read -r ans
[ "$ans" = reviewed ] || die "not confirmed.  To discard the install: git checkout -- . && git clean -f $F"

# ---- step 3: the frozen-layer commit (your identity) ----
say "step 3: git commit -am '... (author)'"
git commit -am "selection-freeze-r1: frozen-layer installs + drift-a re-mint (author)"

# ---- step 4: the key act (close.sh does sig probe, gate 5, MANIFEST, tag) ----
say "step 4: the key act -- $F/close.sh"
bash "$F/close.sh"

# ---- step 5: publish + close #24 ----
if [ "${SKIP_PUSH:-0}" != 1 ]; then
  say "step 5: publish + close #24"
  git push origin master --follow-tags
  gh issue close 24 --comment 'Fixed at selection-freeze-r1: runEpisode migrated to policyPick; clockless + library episode paths both select the declared argmax.' \
    || echo "(gh issue close failed -- run it by hand)"
else
  say "step 5: SKIP_PUSH=1 -- publish + close #24 by hand"
fi
say "DONE -- selection-freeze-r1 closed."
