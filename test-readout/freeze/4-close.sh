#!/usr/bin/env bash
# readout close, script 4/4 — THE r1 CATCH-NET'S CLOSE (CW8's second
# tag). Run from the author's shell, HEAD at readout-freeze-r0 or a
# descendant, tree clean. Running it intact ACCEPTS the drafted r1
# register:
#   - the r0 key-act conviction recorded, and the class canonized:
#     THE TAG MESSAGE IS A FILE (tag-message-file.patch -> CLAUDE.md;
#     lint-l9.patch -> tools/prefreeze-lint.sh row L9, the scriptable
#     half; L8 stays reserved to OB-26, named at scheduling)
#   - r1a KEPT as presence pins (r1a-presence-pin.patch, comment-only;
#     no transcript row name moves; the carriers NAMED per the
#     conferral: p1 -> r7a, entropy -> no standing row -> OB-31)
#   - FOUR OBLIGATIONS OPENED (obligations.patch -> OBLIGATIONS.md
#     rows OB-28..OB-31, from the pixel-9a conferral of 2026-08-04)
#   - the tag message in r1-tag-msg.txt, minted by -F — the law this
#     close canonizes, eaten by its own kit first
# DECLINE BY EDITING r1-tag-msg.txt or dropping a patch line below,
# BEFORE running. This script hashes the kit AS RUN into the manifest
# (kit-hashes-itself), message file included: what is signed is what
# was hashed, in the same run, with no shell parser in between.
#
# If it dies part-way (before the commit), reset with:
#   git checkout -- CLAUDE.md tools/prefreeze-lint.sh \
#                   test-readout/Readout.hs OBLIGATIONS.md MANIFEST.sha256
#   rm -f test-readout/freeze/r1-gate5-run.txt \
#         test-readout/freeze/r1-lint-transcript.txt
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

KIT=test-readout/freeze
TAG=readout-freeze-r1

# 0. guards: r0 present and an ancestor, r1 absent, tree clean,
#    manifest verifies, signature verification configured (idempotent;
#    a fresh clone has no local git config — the f5 lesson in its
#    signature-verification form, carried from 2-freeze).
git rev-parse -q --verify refs/tags/readout-freeze-r0 >/dev/null \
  || { echo "REFUSE: readout-freeze-r0 does not exist here"; exit 1; }
git merge-base --is-ancestor readout-freeze-r0 HEAD \
  || { echo "REFUSE: HEAD does not contain readout-freeze-r0"; exit 1; }
if git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; then
  echo "REFUSE: $TAG already exists"; exit 1
fi
[ -z "$(git status --porcelain)" ] \
  || { echo "REFUSE: tree not clean"; exit 1; }
git config --local gpg.ssh.allowedSignersFile allowed_signers
git config --get user.signingkey >/dev/null \
  || { echo "REFUSE: no user.signingkey — the key act would fail AFTER the tree mutated (the 1-verify fresh-clone lesson)"; exit 1; }
[ "$(git config --get gpg.format)" = ssh ] \
  || { echo "REFUSE: gpg.format is not ssh"; exit 1; }
sha256sum --quiet -c MANIFEST.sha256
echo "guards OK: r0 ancestor, no r1, tree clean, signing config present, manifest verifies"

# 1. THE RECORD ROW: the minted r0 tag message is byte-identical to
#    the drafted register inside the frozen 3-sign.sh. The transform
#    is the sitting's own: minted side = the tag object minus headers
#    and SSH signature; drafted side = lines 30-237 minus the -m
#    wrapper (line 30's prefix, line 237's closing quote). Two-sided:
#    the red was demonstrated against a perturbed message at the
#    rehearsal (pack Part X).
minted=$(mktemp); drafted=$(mktemp)
git cat-file tag readout-freeze-r0 | sed '1,/^$/d' \
  | sed '/^-----BEGIN SSH SIGNATURE-----$/,$d' > "$minted"
awk 'NR>=30 && NR<=237' "$KIT/3-sign.sh" \
  | sed -e '1s/^git tag -s readout-freeze-r0 -m "//' \
  | perl -0777 -pe 's/"\n\z/\n/' > "$drafted"
if ! diff -u "$minted" "$drafted"; then
  echo "RECORD ROW RED: minted r0 message differs from the drafted register"
  rm -f "$minted" "$drafted"
  exit 1
fi
echo "record row OK: minted r0 tag message == drafted register ($(wc -c < "$minted") bytes)"
rm -f "$minted" "$drafted"

# 2. the four [RULING] patches — four DIFFERENT files, so a
#    per-patch check against the unpatched tree is sound here (the
#    sequential-pair hazard needs two patches to one file). Explicit
#    file arguments ALWAYS: the r0 hang was git apply --check reading
#    the terminal when its prose twin lost its argument.
for p in tag-message-file.patch lint-l9.patch r1a-presence-pin.patch obligations.patch; do
  git apply --check "$KIT/$p"
done
for p in tag-message-file.patch lint-l9.patch r1a-presence-pin.patch obligations.patch; do
  git apply "$KIT/$p"
  echo "applied: $p"
done

# 3. gate 5 on the patched tree (the oracle edit is comment-only —
#    enforced, never trusted).
cabal build lib:proplang >/dev/null
cabal test all 2>&1 | tee "$KIT/r1-gate5-run.txt" | tail -3
grep -q "Test suite readout: PASS" "$KIT/r1-gate5-run.txt"
echo "gate 5 green on the patched tree"

# 4. the manifest: re-hash the four patched rows, add the kit's seven
#    (kit-hashes-itself, message file included; the arithmetic
#    reconciles to this list, per the conferral: 4-close.sh,
#    r1-tag-msg.txt, four patches, r1-gate5-run.txt = 7 new rows).
#    ORDER IS LAW here: the re-hash runs AFTER the L9 row exists in
#    the tree — IX.2's builder constraint, carried from the sitting
#    that scheduled OB-26. 139 -> 146 rows.
python3 - <<'PY'
import hashlib, re
rows = {}
for ln in open("MANIFEST.sha256"):
    m = re.match(r"^(\S+)\s+(.*)$", ln.rstrip("\n"))
    if m: rows[m.group(2)] = m.group(1)
for f in ("CLAUDE.md", "tools/prefreeze-lint.sh", "test-readout/Readout.hs",
          "OBLIGATIONS.md",
          "test-readout/freeze/4-close.sh",
          "test-readout/freeze/r1-tag-msg.txt",
          "test-readout/freeze/tag-message-file.patch",
          "test-readout/freeze/lint-l9.patch",
          "test-readout/freeze/r1a-presence-pin.patch",
          "test-readout/freeze/obligations.patch",
          "test-readout/freeze/r1-gate5-run.txt"):
    rows[f] = hashlib.sha256(open(f, "rb").read()).hexdigest()
with open("MANIFEST.sha256", "w") as fh:
    for k in sorted(rows): fh.write(f"{rows[k]}  {k}\n")
print("manifest re-signed over", len(rows), "rows")
PY
sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK post-extension"

# 5. the pre-freeze lint, PATCHED — L9 is live and sees the final
#    tree. Its transcript is written after the re-sign and rides the
#    close commit un-hashed (the same ordering reason as r0's
#    lint-transcript.txt, stated rather than inferred). The grep is
#    anchored: a bare "0 FAIL" matches "10 FAIL" and is shadowed only
#    by pipefail — recorded at Part X, not repeated here.
if ! bash tools/prefreeze-lint.sh 2>&1 | tee "$KIT/r1-lint-transcript.txt"; then
  echo "REFUSE: lint failed"; exit 1
fi
grep -q ": 0 FAIL," "$KIT/r1-lint-transcript.txt" \
  || { echo "REFUSE: lint transcript lacks the anchored zero"; exit 1; }

# 6. the key act: the signed close commit, then the tag FROM THE
#    FILE. The -F path is the canonized law's first execution.
git add CLAUDE.md tools/prefreeze-lint.sh OBLIGATIONS.md MANIFEST.sha256 \
        test-readout readout-author-pack.md EXACT_PLAN.md
git commit -S -m "readout close: the r1 catch-net executed, conferral-amended (the key-act conviction recorded - the r0 -m string executed its own prose, and the shell PARSED it into a word list that was not the register, so the tag owed could never have been minted; the tag minted true by -F with the byte-identity now a standing record row; THE TAG MESSAGE IS A FILE canonized with lint L9 its scriptable half, L8 left reserved to OB-26; r1a ruled KEPT as presence pins with its carriers NAMED - p1 by r7a, entropy by no standing row; OB-28..OB-31 opened; manifest 139 -> 146)"
git tag -s "$TAG" -F "$KIT/r1-tag-msg.txt"

echo
echo "SEALED. Verify: git tag -v $TAG"
echo "Land:   cd ~/git/proplang && git checkout master"
echo "        git merge --ff-only claude/readout-r1"
echo "        git push origin master --follow-tags"
