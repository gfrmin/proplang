#!/usr/bin/env bash
# THE SELECTION RE-FREEZE r0a — the author's act.  Run from the author's
# shell with the author's signing key.  The builder wrote this and NEVER
# runs it: MANIFEST.sha256 is re-signed here and the tag is the author's
# key (the freeze.sh custody, one increment up).
#
# The re-open adds ONE oracle row (s11, the runEpisode migration) to the
# already-frozen selection suite.  This script: OB-29 live signature
# probe; confirm the amended suite COMPILES and is RED (s11 fails) at
# HEAD; re-hash the two changed MANIFEST rows (Selection.hs, register.md)
# and ADD rows for prophecy-r0a.diff + the two r0a transcripts +
# r0a-tag-msg-draft.txt + this script; re-verify; prefreeze-lint 0 FAIL;
# commit MANIFEST under your identity; mint selection-freeze-r0a by -F
# over that commit (the tag-message-is-a-file law), with the byte-
# identity record.  The builder's oracle-amendment commit (s11 + the
# r0a files) is ALREADY in HEAD; this script commits only MANIFEST.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

TAG="selection-freeze-r0a"
MSG="test-selection/freeze/r0a-tag-msg-draft.txt"
SUITE="test-selection/Selection.hs"
PROPHECY="test-selection/freeze/prophecy-r0a.diff"

# ---- preconditions -------------------------------------------------
[ -z "$(git status --porcelain)" ] \
  || { echo "ABORT: tree not clean — the oracle amendment must be committed first" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "ABORT: tag $TAG already exists" >&2; exit 1; }
for f in "$MSG" "$SUITE" "$PROPHECY" \
         test-selection/freeze/r0a-red-run.txt \
         test-selection/freeze/r0a-sat-run.txt \
         test-selection/freeze/register.md \
         test-selection/freeze/freeze-r0a.sh; do
  [ -f "$f" ] || { echo "ABORT: freeze input missing: $f" >&2; exit 1; }
done
grep -q "s11.episode24-runEpisode-argmax" "$SUITE" \
  || { echo "ABORT: s11 is not in the suite" >&2; exit 1; }
git apply --check -p1 "$PROPHECY" \
  || { echo "ABORT: prophecy-r0a.diff does not apply cleanly to HEAD's src" >&2; exit 1; }

# ---- step 0 (OB-29): a LIVE throwaway signature before any key act --
probe_tmp=$(mktemp -d); trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-selection-r0a -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED — key absent or locked; nothing done" >&2; exit 1; }
git tag -v sig-probe-selection-r0a >/dev/null 2>&1 \
  || { git tag -d sig-probe-selection-r0a >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-selection-r0a >/dev/null
echo "step 0: live signature probe OK"

# ---- step 1: the amended suite COMPILES and is RED (s11 fails) ------
b="$probe_tmp/build"; mkdir -p "$b"
ghc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -outputdir "$b" -o "$b/sel" "$SUITE" >/dev/null 2>&1 \
  || { echo "ABORT: the amended suite does not compile against src" >&2; exit 1; }
if "$b/sel" --skip-heavy >/dev/null 2>&1; then
  echo "ABORT: the suite is GREEN at the re-freeze — s11 is not red; runEpisode" >&2
  echo "       must still call chooseEU (the migration is Phase-3 work, applied" >&2
  echo "       from prophecy-r0a.diff AFTER this tag)" >&2
  exit 1
fi
echo "step 1: the amended suite compiles and is RED (s11 fails; runEpisode->chooseEU)"

# ---- step 2: re-hash the changed rows + ADD the new (hashes here) ---
grep -v -e '  test-selection/Selection.hs$' \
        -e '  test-selection/freeze/register.md$' MANIFEST.sha256 > "$probe_tmp/m"
mv "$probe_tmp/m" MANIFEST.sha256
sha256sum "$SUITE" \
          test-selection/freeze/register.md \
          "$PROPHECY" \
          test-selection/freeze/r0a-red-run.txt \
          test-selection/freeze/r0a-sat-run.txt \
          "$MSG" \
          test-selection/freeze/freeze-r0a.sh >> MANIFEST.sha256
sha256sum --quiet -c MANIFEST.sha256
echo "step 2: MANIFEST re-hashed and fully verified ($(wc -l < MANIFEST.sha256) rows)"

# ---- step 3: prefreeze-lint gate (0 FAIL; after MANIFEST is current) -
bash tools/prefreeze-lint.sh | tee "$probe_tmp/lint.txt"
grep -q "0 FAIL" "$probe_tmp/lint.txt" \
  || { echo "ABORT: prefreeze-lint is not 0 FAIL" >&2; exit 1; }

# ---- step 4: the re-freeze commit (your identity) ------------------
git add MANIFEST.sha256
git commit -q -m "selection-freeze-r0a: RE-FREEZE for the runEpisode migration (author)

Re-freezes test-selection/ with the s11 row (runEpisode under PilotEU
on #24's world) added, under the author's re-open ruling of 2026-09-03
(mandate 5: the r0 prophecy migrated only the wire, leaving runEpisode
on the act-blind chooseEU).  MANIFEST re-hashes Selection.hs +
register.md and covers prophecy-r0a.diff + the r0a transcripts + kit.
From this commit the amended oracle is as frozen as test/; the builder
applies prophecy-r0a.diff (Membrane.hs:460 chooseEU->policyPick) until
green and may not touch these bytes.

Author commit: the MANIFEST re-hash and this tag are the author's acts;
the attestation is the signed tag over this commit."
echo "step 4: re-freeze commit $(git rev-parse --short HEAD) made"

# ---- step 5: the tag, by -F (the tag-message-is-a-file law) --------
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
  echo "STOP: minted message differs from $MSG — investigate before pushing" >&2
  diff "$minted" "$MSG" >&2; exit 1
fi

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "The amended oracle is FROZEN.  Implementation opens: apply"
echo "test-selection/freeze/prophecy-r0a.diff (git apply -p1), gates 1-7,"
echo "then the close resumes (chooseeu-sitting-r0 clause 6 + OB-33)."
echo "Publish (fast-forward only, never the merge button):"
echo "  git push origin master --follow-tags"
