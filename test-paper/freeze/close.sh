#!/usr/bin/env bash
# close.sh -- THE DEMONSTRATION TIER'S CLOSE (paper-freeze-r0).  THE TERMINUS.
# Run by the AUTHOR from the author's own shell, with the author's signing
# key (thinkpad: gpg.format=ssh, user.signingkey=proplang-author-thinkpad).
# The builder wrote this file and NEVER runs it: MANIFEST.sha256 is
# re-signed here and the tag is the author's key act (the freeze.sh /
# freeze-r0a.sh / selection close.sh custody, this repo's precedent).
#
# PRECONDITION (author, before this script): the frozen-layer installs
# (FL-P1 CLAUDE.md, FL-P2 EXACT_PLAN.md) are DONE and COMMITTED as an
# author commit, and the builder's paper kit is in HEAD.  See
# CLOSE-RUNBOOK.md for the order, or run do-close.sh which chains it.
# This script commits ONLY MANIFEST.sha256 (freeze-r0a.sh's discipline).
#
# WHAT IT DOES:
#   1. pre-close-check.sh gate (read-only readiness; SOURCED, so the ADD
#      list has one generator and is never hand-copied here).
#   0. OB-29 live throwaway signature probe (execution, not inspection --
#      a key act that fails AFTER the manifest is rewritten is the worst
#      possible ordering, so the key is proven usable before anything moves).
#   2. gate 5 -- cabal test all -j1, quiet+serial (RUN_GATE5=0 to skip if
#      you just ran it green on a quiet box).
#   3. MANIFEST re-sign: RE-HASH every row the author's edits moved (the
#      set DERIVED from sha256sum -c, never hand-listed) and ADD the new
#      files (from pre-close-check's ADD list); sha256sum -c must pass.
#   4. prefreeze-lint 0 FAIL.
#   5. the MANIFEST commit (author identity) + the tag by -F (the
#      tag-message-is-a-file law, OB-30 / lint row L9) + the byte-identity
#      record, then the paper checker in --close mode as the final proof.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

TAG="paper-freeze-r0"
MSG="test-paper/freeze/r0-tag-msg.txt"
RUN_GATE5="${RUN_GATE5:-1}"

probe_tmp=$(mktemp -d); trap 'rm -rf "$probe_tmp"' EXIT

# ---- step 1: the readiness gate (shared with the dashboard) --------
# source it for ADD + run_checks, then enforce it (one generator).
source test-paper/freeze/pre-close-check.sh
run_checks || { echo "ABORT: pre-close-check reports NOT READY -- resolve the HARD failures above." >&2; exit 1; }
echo

# ---- step 0 (OB-29): a LIVE throwaway signature before any key act --
printf 'sig-probe over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-paper-r0 -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED -- key absent or locked; nothing done" >&2; exit 1; }
git tag -v sig-probe-paper-r0 >/dev/null 2>&1 \
  || { git tag -d sig-probe-paper-r0 >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-paper-r0 >/dev/null
echo "step 0: live signature probe OK"

# ---- step 2: gate 5 -- the definition of done (quiet + serial) -----
if [ "$RUN_GATE5" = "1" ]; then
  echo "step 2: gate 5 (cabal test all -j1) -- includes the drift walks (~10-13 min)."
  echo "        (set RUN_GATE5=0 to skip if you just ran it green on a quiet box)"
  if cabal test all -j1 --test-show-details=streaming; then
    echo "step 2: gate 5 GREEN (all suites, serialized)"
  else
    echo "ABORT: gate 5 is not green -- the close does not proceed over a red gate." >&2
    echo "       if a timing cell false-reds under load, re-run on a quiet box." >&2
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
  echo "step 3: no manifest-covered file changed -- EXPECTED at this close is CLAUDE.md (FL-P1)."
fi
echo "        and these NEW files added: ${#ADD[@]} rows (the paper, its checker, the inventory, this kit)."
printf '          %s\n' "${ADD[@]}"
echo "        Read both lists.  Abort with ctrl-C within 6s if anything is unexpected."
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
paper-freeze-r0: the demonstration tier's CLOSE -- THE TERMINUS (author)

Re-signs MANIFEST.sha256 over the close of step 5, the demonstration
tier, and with it the roadmap of EXACT_PLAN.md section 13.0.  It
RE-HASHES CLAUDE.md (the FL-P1 repair: the "ONE ITEM REMAINS: step 5"
paragraph repaired in place, the falsified clause quoted inside its own
repair) and ADDS PAPER.md, test-paper/check.sh,
test-paper/terminus-inventory.md and this close kit.  FL-P2 (the
EXACT_PLAN.md terminus bracket) rides outside the manifest, per the
selection-freeze-r1 FL-3 precedent for that file.

From this commit PAPER.md and its checker are as frozen as test/.  The
attestation is the signed paper-freeze-r0 tag over this commit.  MANIFEST
re-hash and tag are the author's own acts; the builder authored the
paper, the checker, the inventory and this kit, and never runs this
script.

THE ROADMAP TERMINATES HERE.  Everything remaining is named demand-gated
residue re-entering only through the two-sided gate with a measurement.
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

# ---- the final proof: the paper's own checker, close mode ----------
echo
echo "final: sh test-paper/check.sh --close"
sh test-paper/check.sh --close \
  || { echo "STOP: the paper checker is not green in --close mode after the close." >&2; exit 1; }

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "THE DEMONSTRATION TIER IS CLOSED.  THE ROADMAP HAS TERMINATED."
echo "Publish (fast-forward only, NEVER the merge button):"
echo "  git push origin master --follow-tags"
