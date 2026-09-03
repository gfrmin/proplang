#!/usr/bin/env bash
# pre-close-check.sh -- the READ-ONLY readiness dashboard for the
# selection-freeze-r1 close.  Makes NO commit, NO tag, NO tree mutation.
# The author (or the builder, rehearsing) runs this to see what is staged
# and what is still owed before close.sh -- the key act -- is armed.
#
# It is ALSO close.sh's precondition gate: close.sh sources this file to
# reuse the ADD list and the run_checks function, so the two artefacts
# share ONE generator (the one-generator law -- no parallel hand-copy of
# the new-file set).  When SOURCED it defines ADD + run_checks and returns;
# when EXECUTED it runs the checks and exits with their status.
#
# HARD checks (a failure means close.sh cannot safely run): tree/tag state,
# the tag message committed, every new file tracked and not already a
# manifest row.  ADVISORY checks (reported, never fatal here -- the author's
# eye is the authority on prose): the frozen-layer installs and the drift-a
# re-mint.  Its red side is demonstrated by running it BEFORE the author's
# edits land: every advisory reads ABSENT, the tag-message HARD row reds
# until the kit is committed.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

TAG="selection-freeze-r1"
MSG="test-selection/freeze/r1-tag-msg.txt"

# ---- the new-file set (ADD) -- derived from the tree, never hand-listed --
#   this increment's mutants: M82-M89 (selection) + M90-M98 (breadth), by glob;
#   the one-generator driver; the two kill matrices; the close pack; this kit.
# M8[2-9]-* excludes M8-/M80/M81 (already frozen); M9[0-8]-* excludes M9-/M99.
ADD_MUTANTS=$(git ls-files 'audit/mutants/M8[2-9]-*.patch' 'audit/mutants/M9[0-8]-*.patch')
ADD=(
  $ADD_MUTANTS
  audit/mutants/breadth_matrix_driver.py
  test-selection/close-kill-matrix.txt
  test-breadth/close-kill-matrix.txt
  selection-close-pack.md
  test-selection/freeze/close.sh
  test-selection/freeze/pre-close-check.sh
  test-selection/freeze/r1-tag-msg.txt
  test-selection/freeze/CLOSE-RUNBOOK.md
)

# NB: the manifest RE-HASH set is DERIVED at close time from `sha256sum -c`
# (whatever the author's edits moved), never a hand-list here.  The HARD
# install checks below key on the exact strings the frozen drafts dictate.

fail=0
ok()   { printf '  [ OK ] %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=$((fail+1)); }
note() { printf '  [ -- ] %s\n' "$1"; }

run_checks() {
  echo "== selection-freeze-r1 :: readiness =="
  echo
  echo "-- HARD: tree / tag / kit --"
  if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
    bad "tag $TAG already exists (close is already done, or a stale tag must go)"
  else ok "tag $TAG does not yet exist"; fi

  if [ -z "$(git status --porcelain)" ]; then ok "working tree clean"
  else bad "working tree NOT clean -- author edits must be committed before close.sh (it commits only MANIFEST)"; fi

  if [ -f "$MSG" ] && [ -n "$(git ls-tree -r --name-only HEAD -- "$MSG")" ]; then
    ok "tag message $MSG present and committed in HEAD (the tag covers its own message)"
  else bad "tag message $MSG missing or not committed in HEAD"; fi

  echo
  echo "-- HARD: the new files (must be tracked, must NOT already be a manifest row) --"
  local nmiss=0 ndup=0
  for f in "${ADD[@]}"; do
    if [ -z "$(git ls-files -- "$f")" ]; then bad "not tracked: $f"; nmiss=$((nmiss+1)); continue; fi
    if grep -qF -- "  $f" MANIFEST.sha256 2>/dev/null; then bad "already a manifest row (double-add): $f"; ndup=$((ndup+1)); fi
  done
  [ "$nmiss" -eq 0 ] && ok "all ${#ADD[@]} new files tracked"
  [ "$ndup" -eq 0 ] && ok "no new file is already a manifest row"

  echo
  echo "-- HARD: the REQUIRED frozen-layer edits actually landed (each file must have CHANGED) --"
  # The robust substance gate: every manifest-covered file the close must edit
  # appears in the sha256sum -c mismatch set (the SAME set close.sh re-hashes).
  # This enforces "not skipped" without depending on exact prose wording; the
  # marker greps below are ADVISORY guidance on "looks right".
  local edited
  edited=$(sha256sum -c MANIFEST.sha256 2>/dev/null | sed -n 's/: FAILED$//p' || true)
  local REQ=(membrane-wire.md CLAUDE.md OBLIGATIONS.md tools/prefreeze-lint.sh test-breadth/Breadth.hs)
  local -A why=(
    ["membrane-wire.md"]="FL-1 (history bracket)"
    ["CLAUDE.md"]="FL-2 (roadmap re-point to EXACT_PLAN 13.0)"
    ["OBLIGATIONS.md"]="OB-24 + OB-33 discharge, OB-30, R5"
    ["tools/prefreeze-lint.sh"]="L5 rev 2"
    ["test-breadth/Breadth.hs"]="drift-a ratio re-mint"
  )
  local r
  for r in "${REQ[@]}"; do
    if printf '%s\n' $edited | grep -qxF -- "$r"; then ok "$r changed -> ${why[$r]}"
    else bad "$r UNCHANGED -- ${why[$r]} not yet installed (and committed)"; fi
  done
  # drift-a is structural, not prose: the literal must have moved off the r0 mint.
  if grep -q 'driftFrozenMeanRatio = 2.0092' test-breadth/Breadth.hs; then
    bad "drift-a ratio still literally 2.0092 (the r0 absolute-ms mint) -- re-mint owed"
  else ok "drift-a ratio moved off 2.0092 ($(grep -m1 'driftFrozenMeanRatio =' test-breadth/Breadth.hs | sed 's/^[[:space:]]*//'))"; fi

  echo
  echo "-- ADVISORY: markers look right? (guidance -- the author's eye is the authority) --"
  grep -qF -- "EXACT_PLAN.md section 13.0" CLAUDE.md && ok "FL-2 marker present (EXACT_PLAN.md section 13.0)" || note "FL-2 marker 'EXACT_PLAN.md section 13.0' not found in CLAUDE.md"
  grep -Eq "\|[[:space:]]*OB-24[[:space:]].*DISCHARGED@selection-freeze-r1" OBLIGATIONS.md && ok "OB-24 discharge string present" || note "OB-24 row lacks 'DISCHARGED@selection-freeze-r1'"
  grep -Eq "\|[[:space:]]*OB-33[[:space:]].*DISCHARGED@selection-freeze-r1" OBLIGATIONS.md && ok "OB-33 discharge string present" || note "OB-33 row lacks 'DISCHARGED@selection-freeze-r1'"
  grep -q 'SAT-SECTION' tools/prefreeze-lint.sh && ok "L5 rev 2 marker present (SAT-SECTION)" || note "L5 rev 2 marker 'SAT-SECTION' not found in tools/prefreeze-lint.sh"
  grep -qF -- "SUPERSEDED 2026-09-01" EXACT_PLAN.md && ok "FL-3 installed (EXACT_PLAN.md; not manifest-covered)" || note "FL-3 not yet in EXACT_PLAN.md (cheapest, outside the manifest)"
  note "M1/M3/M4 comment nits (src/PropLang/Membrane.hs): REPAIR or DECLINE per selection-close-pack.md #1"
  local nm; nm=$(printf '%s\n' $ADD_MUTANTS | grep -c . || true)
  ok "$nm this-increment mutants staged (M82-M89 + M90-M98)"

  echo
  if [ "$fail" -eq 0 ]; then
    echo "== READY: all HARD checks pass.  Review the advisories, then run close.sh. =="
    return 0
  else
    echo "== NOT READY: $fail HARD check(s) failed.  Resolve them; close.sh will refuse to run. =="
    return 1
  fi
}

# executed directly -> run and exit; sourced -> just export ADD + run_checks
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  run_checks
  exit $?
fi
