#!/usr/bin/env bash
# close.sh -- THE SELECTION INCREMENT'S CLOSE (selection-freeze-r1).
# Run by the AUTHOR from the author's own shell, with the author's signing
# key (thinkpad: gpg.format=ssh, user.signingkey=proplang-author-thinkpad).
# The builder wrote this file and NEVER runs it: MANIFEST.sha256 is
# re-signed here and the tag is the author's key act (the freeze.sh /
# freeze-r0a.sh custody, this increment's precedent).
#
# PRECONDITION (author, before this script): the frozen-layer installs and
# the drift-a re-mint are DONE and COMMITTED (an author commit), and the
# builder's close kit is in HEAD.  See CLOSE-RUNBOOK.md for the order.
# This script commits ONLY MANIFEST.sha256 (freeze-r0a.sh's discipline).
#
# WHAT IT DOES:
#   0. OB-29 live throwaway signature probe (execution, not inspection).
#   1. pre-close-check.sh gate (read-only readiness; shared generator).
#   2. gate 5 -- cabal test all -j1, quiet+serial (RUN_GATE5=0 to skip if
#      you just ran it; the drift-a re-mint must already be installed or
#      the drift cell false-reds).
#   3. MANIFEST re-sign: RE-HASH every row the author's edits moved (the
#      set DERIVED from sha256sum -c, never hand-listed) and ADD the new
#      files (from pre-close-check's ADD glob); sha256sum -c must pass.
#   4. prefreeze-lint 0 FAIL.
#   5. the MANIFEST commit (author identity) + the tag by -F (the
#      tag-message-is-a-file law) + the byte-identity record.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

TAG="selection-freeze-r1"
MSG="test-selection/freeze/r1-tag-msg.txt"
RUN_GATE5="${RUN_GATE5:-1}"

# ---- step 1: the readiness gate (shared with the dashboard) --------
# source it for ADD + run_checks, then enforce it (one generator).
source test-selection/freeze/pre-close-check.sh
run_checks || { echo "ABORT: pre-close-check reports NOT READY -- resolve the HARD failures above." >&2; exit 1; }
echo

# ---- step 0 (OB-29): a LIVE throwaway signature before any key act --
probe_tmp=$(mktemp -d); trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-selection-r1 -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED -- key absent or locked; nothing done" >&2; exit 1; }
git tag -v sig-probe-selection-r1 >/dev/null 2>&1 \
  || { git tag -d sig-probe-selection-r1 >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-selection-r1 >/dev/null
echo "step 0: live signature probe OK"

# ---- step 2: gate 5 -- the definition of done (quiet + serial) -----
if [ "$RUN_GATE5" = "1" ]; then
  echo "step 2: gate 5 (cabal test all -j1) -- this includes the drift walks (~10-13 min)."
  echo "        (set RUN_GATE5=0 to skip if you just ran it green on a quiet box)"
  if cabal test all -j1 --test-show-details=streaming; then
    echo "step 2: gate 5 GREEN (all suites, serialized)"
  else
    echo "ABORT: gate 5 is not green -- the close does not proceed over a red gate." >&2
    echo "       if drift-a false-red under load, re-run on a quiet box; if the band" >&2
    echo "       needs the re-mint, install it first (CLOSE-RUNBOOK step 2)." >&2
    exit 1
  fi
else
  echo "step 2: gate 5 SKIPPED by RUN_GATE5=0 -- you attest it ran green on a quiet box."
fi

# ---- step 3: MANIFEST re-sign (re-hash edited rows; add new rows) --
# 3a. edited rows = manifest-covered files whose content moved (DERIVED).
mapfile -t EDITED < <(sha256sum -c MANIFEST.sha256 2>/dev/null | sed -n 's/: FAILED$//p' || true)
if [ "${#EDITED[@]}" -gt 0 ]; then
  echo "step 3: these manifest-covered files will be RE-HASHED (the author's edits):"
  printf '          %s\n' "${EDITED[@]}"
else
  echo "step 3: no manifest-covered file changed (all close edits are new files or uncovered)."
fi
echo "        and these NEW files added: ${#ADD[@]} rows (mutants + driver + matrices + pack + kit)."
echo "        Read the two lists.  Abort with ctrl-C within 6s if anything is unexpected."
sleep 6

# 3b. drop the edited rows (exact trailing-path match), re-add fresh hashes.
if [ "${#EDITED[@]}" -gt 0 ]; then
  : > "$probe_tmp/keep"
  while IFS= read -r row; do
    p=${row#*  }                       # path = text after the first double-space
    drop=0
    for f in "${EDITED[@]}"; do [ "$p" = "$f" ] && { drop=1; break; }; done
    [ "$drop" -eq 0 ] && printf '%s\n' "$row" >> "$probe_tmp/keep"
  done < MANIFEST.sha256
  mv "$probe_tmp/keep" MANIFEST.sha256
  sha256sum "${EDITED[@]}" >> MANIFEST.sha256
fi

# 3c. add the new files (guarded: each tracked, none already a row).
for f in "${ADD[@]}"; do
  [ -n "$(git ls-files -- "$f")" ] || { echo "ABORT: ADD file not tracked: $f" >&2; exit 1; }
  grep -qF -- "  $f" MANIFEST.sha256 && { echo "ABORT: ADD file already a manifest row: $f" >&2; exit 1; }
done
sha256sum "${ADD[@]}" >> MANIFEST.sha256

# 3d. full verify -- every row now matches its file.
sha256sum --quiet -c MANIFEST.sha256
echo "step 3: MANIFEST re-hashed and fully verified ($(wc -l < MANIFEST.sha256) rows)"

# ---- step 4: prefreeze-lint gate (0 FAIL, MANIFEST now current) ----
bash tools/prefreeze-lint.sh | tee "$probe_tmp/lint.txt"
grep -q "0 FAIL" "$probe_tmp/lint.txt" \
  || { echo "ABORT: prefreeze-lint is not 0 FAIL" >&2; exit 1; }

# ---- step 5: the close commit (author identity) --------------------
git add MANIFEST.sha256
git commit -q -F - <<'COMMIT_EOF'
selection-freeze-r1: the selection increment's CLOSE (author)

Re-signs MANIFEST.sha256 over the selection increment's close: the
frozen-layer installs (FL-1 membrane-wire history bracket, FL-2 CLAUDE.md
roadmap re-point, FL-3 EXACT_PLAN.md supersession), the OBLIGATIONS
dispositions (OB-24 + OB-33 DISCHARGED, OB-30 instances, R5), L5 rev 2,
and the drift-a ratio re-mint -- each re-hashed here from the author's
own edits.  It ADDS the OB-33 mutants (M82-M89 selection, M90-M98
breadth), the one-generator breadth driver, the two kill-matrix
transcripts, the close pack, and this close kit.

From this commit the increment's oracle-and-audit layer is frozen as
test/.  The attestation is the signed selection-freeze-r1 tag over this
commit.  MANIFEST re-hash and tag are the author's own acts; the builder
authored the kit and the mutants and never runs this script.
COMMIT_EOF
echo "step 5: close commit $(git rev-parse --short HEAD) made (MANIFEST only)"

# ---- the tag, by -F (the tag-message-is-a-file law) ----------------
git tag -s "$TAG" -F "$MSG"
git tag -v "$TAG"
minted="$probe_tmp/minted"
git cat-file tag "$TAG" > "$probe_tmp/tagobj"
awk -v n="$(wc -l < "$MSG")" \
  'flag && c < n {print; c++} !flag && /^$/ {flag=1}' \
  "$probe_tmp/tagobj" > "$minted"
if cmp -s "$minted" "$MSG"; then
  echo "RECORD: minted tag message byte-identical to $MSG ($(wc -c < "$MSG") bytes)"
else
  echo "STOP: minted message differs from $MSG -- investigate before pushing" >&2
  diff "$minted" "$MSG" >&2; exit 1
fi

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "The selection increment is CLOSED (R-SHAPE rev 2, the third shape;"
echo "runEpisode migrated; chooseEU zero src consumers; OB-33 both halves)."
echo "Publish (fast-forward only, NEVER the merge button):"
echo "  git push origin master --follow-tags"
echo "Then close #24 citing this boundary (the wire AND library episode"
echo "path now select the declared argmax):"
echo "  gh issue close 24 --comment 'Fixed at selection-freeze-r1: runEpisode migrated to policyPick; clockless + library episode paths both select the declared argmax.'"
