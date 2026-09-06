#!/usr/bin/env bash
# pre-close-check.sh -- the READ-ONLY readiness dashboard for the
# paper-freeze-r0 close (the TERMINUS).  Makes NO commit, NO tag, NO tree
# mutation.  The author (or the builder, rehearsing) runs this to see what
# is staged and what is still owed before close.sh -- the key act -- is
# armed.
#
# It is ALSO close.sh's precondition gate: close.sh SOURCES this file to
# reuse the ADD list and the run_checks function, so the two artefacts
# share ONE generator (the one-generator law -- no parallel hand-copy of
# the new-file set).  When SOURCED it defines ADD + run_checks and returns;
# when EXECUTED it runs the checks and exits with their status.
#
# HARD checks (a failure means close.sh cannot safely run): tree/tag state,
# the tag message committed, every new file tracked and not already a
# manifest row, the FL-P1 install actually landed, and the paper's own
# checker green in base mode.  ADVISORY checks (reported, never fatal --
# the author's eye is the authority on prose): the FL-P2 bracket, which is
# NOT manifest-covered and so cannot be seen by sha256sum -c.
#
# ITS RED SIDE (the harness-gate law): run this BEFORE the author's edits
# land and the FL-P1 HARD row reds, the FL-P2 advisory reads ABSENT, and
# the tag-message row reds until the kit is committed.  That is the
# rehearsal, and it is the intended pre-close state -- not a defect.
set -uo pipefail
cd "$(git rev-parse --show-toplevel)"

TAG="paper-freeze-r0"
MSG="test-paper/freeze/r0-tag-msg.txt"

# ---- the new-file set (ADD) -- the terminus deliverables + this kit -----
# Enumerated ONCE, here; close.sh sources it and never re-declares it.
# test-paper/check.sh's own --close mode independently requires the first
# two rows, so the manifest coverage is checked from both sides.
ADD=(
  PAPER.md
  test-paper/check.sh
  test-paper/terminus-inventory.md
  test-paper/hello9.sh
  test-paper/hello9-transcript.txt
  test-wire/Wire.hs
  test-paper/sitting/BRIEF.md
  test-paper/sitting/make-conferral.sh
  test-paper/sitting/drift-distribution.sh
  test-paper/sitting/drift-distribution.txt
  test-paper/sitting/quiet-box.sh
  test-paper/sitting/drift-quiet.txt
  test-paper/sitting/wire-attribution.sh
  test-paper/sitting/wire-attribution.txt
  test-paper/freeze/close.sh
  test-paper/freeze/pre-close-check.sh
  test-paper/freeze/do-close.sh
  test-paper/freeze/install-close-edits.sh
  test-paper/freeze/frozen-layer.patch
  test-paper/freeze/r0-tag-msg.txt
  test-paper/freeze/CLOSE-RUNBOOK.md
)

# NB: the manifest RE-HASH set is DERIVED at close time from `sha256sum -c`
# (whatever the author's edits moved), never a hand-list here.

fail=0
ok()   { printf '  [ OK ] %s\n' "$1"; }
bad()  { printf '  [FAIL] %s\n' "$1"; fail=$((fail+1)); }
note() { printf '  [ -- ] %s\n' "$1"; }

run_checks() {
  echo "== paper-freeze-r0 :: readiness (THE TERMINUS) =="
  echo

  echo "-- HARD: tree / tag / kit --"
  if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
    bad "tag $TAG already exists (close is already done, or a stale tag must go)"
  else ok "tag $TAG does not yet exist"; fi

  if [ "$(git rev-parse --abbrev-ref HEAD)" = master ]; then ok "on master"
  else bad "not on master (the freeze commits and the tag live on master; do not branch)"; fi

  if [ -z "$(git status --porcelain)" ]; then ok "working tree clean"
  else bad "working tree NOT clean -- the author's edits must be committed before close.sh (it commits only MANIFEST)"; fi

  if [ -f "$MSG" ] && [ -n "$(git ls-tree -r --name-only HEAD -- "$MSG")" ]; then
    ok "tag message $MSG present and committed in HEAD (the tag covers its own message)"
  else bad "tag message $MSG missing or not committed in HEAD"; fi

  echo
  echo "-- HARD: the new files (must be tracked, must NOT already be a manifest row) --"
  local nmiss=0 ndup=0 f
  for f in "${ADD[@]}"; do
    if [ -z "$(git ls-files -- "$f")" ]; then bad "not tracked: $f"; nmiss=$((nmiss+1)); continue; fi
    if grep -qF -- "  $f" MANIFEST.sha256 2>/dev/null; then bad "already a manifest row (double-add): $f"; ndup=$((ndup+1)); fi
  done
  [ "$nmiss" -eq 0 ] && ok "all ${#ADD[@]} new files tracked"
  [ "$ndup" -eq 0 ] && ok "no new file is already a manifest row"

  # THE EXPECTED POST-CLOSE ROW COUNT IS COMPUTED, NEVER TYPED.  It was a
  # hand copy in two prose files and went stale TWICE (12 ADD -> 17 -> 19)
  # -- the one-generator law's own provenance shape: "a hand copy tracking
  # a generated value is correct at birth and wrong at the first
  # regeneration."  Re-hashed rows do not change the count; only ADDs do.
  local now_rows exp_rows
  now_rows=$(wc -l < MANIFEST.sha256)
  exp_rows=$(( now_rows + ${#ADD[@]} ))
  note "EXPECTED POST-CLOSE MANIFEST SIZE: $exp_rows rows ($now_rows now + ${#ADD[@]} ADD)"
  note "  ^ this line is the ONE generator of that number; prose cites it, never a literal"

  echo
  echo "-- HARD: the REQUIRED frozen-layer edit actually landed --"
  # The robust substance gate: a manifest-covered file the close must edit
  # appears in the sha256sum -c mismatch set (the SAME set close.sh
  # re-hashes).  This enforces "not skipped" without depending on exact
  # prose wording; the marker greps below are guidance on "looks right".
  local edited
  edited=$(sha256sum -c MANIFEST.sha256 2>/dev/null | sed -n 's/: FAILED$//p' || true)
  if printf '%s\n' $edited | grep -qxF -- CLAUDE.md; then
    ok "CLAUDE.md changed -> FL-P1 (the ONE ITEM REMAINS repair) installed"
  else
    bad "CLAUDE.md UNCHANGED -- FL-P1 not yet installed and committed (test-paper/freeze/install-close-edits.sh)"
  fi
  # proplang.cabal is manifest-covered and the wire increment adds a
  # stanza to it, so it is EXPECTED in the re-hash set.  Flagged, not
  # required: it is already committed by the time this runs, and its
  # absence would only mean the stanza never landed -- which the wire
  # suite's own existence in `cabal test all` already proves.
  if printf '%s\n' $edited | grep -qxF -- proplang.cabal; then
    ok "proplang.cabal changed -> the test-wire stanza (expected in the re-hash set)"
  else
    note "proplang.cabal unchanged -- expected if the wire stanza landed in an earlier freeze"
  fi
  if grep -qF -- "ROADMAP TERMINATED at paper-freeze-r0" CLAUDE.md; then
    ok "FL-P1 marker present (ROADMAP TERMINATED at paper-freeze-r0)"
  else
    bad "FL-P1 marker absent from CLAUDE.md"
  fi
  if grep -qF -- 'read "ONE ITEM REMAINS: step 5' CLAUDE.md; then
    ok "FL-P1 quotes the falsified clause inside its own repair (normative-prose form)"
  else
    bad "FL-P1 does not quote the falsified clause -- the repair form is wrong for normative prose"
  fi

  echo
  echo "-- HARD: the paper's own checker, base mode --"
  local capture
  capture=$(sh test-paper/check.sh 2>&1 || true)
  if printf '%s\n' "$capture" | grep -q ', 0 failed'; then
    ok "test-paper/check.sh base mode GREEN ($(printf '%s\n' "$capture" | tail -1))"
  else
    bad "test-paper/check.sh base mode NOT green: $(printf '%s\n' "$capture" | tail -1)"
    printf '%s\n' "$capture" | grep 'FAIL' | sed 's/^/         /'
  fi

  echo
  echo "-- ADVISORY: FL-P2, outside the manifest (the author's eye is the authority) --"
  # EXACT_PLAN.md is NOT manifest-covered (the selection-freeze-r1 FL-3
  # precedent for this file), so sha256sum -c cannot see it: grep instead.
  grep -qF -- "TERMINATED 2026-09-05 at paper-freeze-r0" EXACT_PLAN.md \
    && ok "FL-P2 installed (EXACT_PLAN.md terminus bracket; not manifest-covered)" \
    || note "FL-P2 not yet in EXACT_PLAN.md (cheapest edit, outside the manifest)"
  grep -qF -- "the X.5 sitting is PREPARED" EXACT_PLAN.md \
    && ok "FL-P2 kept the draft-time annotation VERBATIM (record class, not a rewrite)" \
    || note "the draft-time status annotation is gone from EXACT_PLAN.md -- record class says keep it"
  note "close-mode rows (C manifest x2, C tag) are RED until close.sh runs -- that is the pre-close state, not a defect"

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
