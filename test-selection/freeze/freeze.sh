#!/usr/bin/env bash
# THE SELECTION FREEZE — the author's act.  Run from the author's shell
# with the author's signing key.  The builder wrote this and NEVER runs
# it: proplang.cabal and MANIFEST.sha256 are manifest-covered, and the
# tag is the author's key (the close.sh custody, one increment up).
#
# What it does, in order: OB-29 live signature probe; prefreeze-lint
# gate; splice the selection stanza into proplang.cabal; confirm the
# frozen oracle still compiles and is RED at the freeze; extend and
# re-verify MANIFEST.sha256 (hashes COMPUTED here, never hand-copied —
# the one-generator law); commit the freeze under your identity; and
# mint selection-freeze-r0 by -F over that commit (the
# tag-message-is-a-file law), with the byte-identity record.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

TAG="selection-freeze-r0"
MSG="test-selection/freeze/r0-tag-msg-draft.txt"
STANZA="test-selection/stanza.cabal.draft"
SUITE="test-selection/Selection.hs"

# ---- preconditions -------------------------------------------------
[ -z "$(git status --porcelain)" ] \
  || { echo "ABORT: tree not clean — commit or stash first" >&2; exit 1; }
git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "ABORT: tag $TAG already exists" >&2; exit 1; }
[ -f "$MSG" ] && [ -f "$STANZA" ] && [ -f "$SUITE" ] \
  || { echo "ABORT: a freeze input is missing" >&2; exit 1; }
grep -q "^test-suite selection$" proplang.cabal \
  && { echo "ABORT: the selection stanza is already in proplang.cabal" >&2; exit 1; }
grep -q "  $SUITE\$" MANIFEST.sha256 \
  && { echo "ABORT: MANIFEST already carries $SUITE (re-run?)" >&2; exit 1; }

# ---- step 0 (OB-29): a LIVE throwaway signature before any key act --
probe_tmp=$(mktemp -d); trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-selection-freeze -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED — key absent or locked; nothing done" >&2; exit 1; }
git tag -v sig-probe-selection-freeze >/dev/null 2>&1 \
  || { git tag -d sig-probe-selection-freeze >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-selection-freeze >/dev/null
echo "step 0: live signature probe OK"

# ---- step 1: prefreeze-lint gate (0 FAIL required) -----------------
echo "step 1: prefreeze-lint ..."
bash tools/prefreeze-lint.sh | tee "$probe_tmp/lint.txt"
grep -q "0 FAIL" "$probe_tmp/lint.txt" \
  || { echo "ABORT: prefreeze-lint is not 0 FAIL" >&2; exit 1; }

# ---- step 2: splice the stanza (the block from 'test-suite' on) ----
echo "" >> proplang.cabal
sed -n '/^test-suite selection$/,$p' "$STANZA" >> proplang.cabal
echo "step 2: selection stanza spliced into proplang.cabal"

# ---- step 3: the frozen oracle compiles and is RED at the freeze ---
b="$probe_tmp/build"; mkdir -p "$b"
ghc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
    -isrc -outputdir "$b" -o "$b/sel" "$SUITE" >/dev/null 2>&1 \
  || { echo "ABORT: the frozen suite does not compile against src at the freeze" >&2; exit 1; }
if "$b/sel" --skip-heavy >/dev/null 2>&1; then
  echo "ABORT: the suite is GREEN at the freeze — the stub is not red; a" >&2
  echo "       freeze over a passing oracle proves nothing" >&2
  exit 1
fi
echo "step 3: the oracle compiles and is RED at the freeze (stub in place)"

# ---- step 4: extend + re-verify the manifest (hashes computed here) -
newcabal=$(sha256sum proplang.cabal)
sed -i "s|.*  proplang\.cabal\$|$newcabal|" MANIFEST.sha256
sha256sum "$SUITE" "$STANZA" \
          test-selection/freeze/*.txt \
          test-selection/freeze/*.md \
          test-selection/freeze/*.diff \
          test-selection/freeze/*.sh >> MANIFEST.sha256
sha256sum --quiet -c MANIFEST.sha256
echo "step 4: MANIFEST extended and fully verified ($(wc -l < MANIFEST.sha256) rows)"

# ---- step 5: the freeze commit (your identity) --------------------
git add proplang.cabal MANIFEST.sha256
git commit -q -m "selection-freeze-r0: the (3) increment's ORACLE FREEZE (author)

Freezes test-selection/ as the increment's binding red set under
chooseeu-sitting-r0 (R-SHAPE rev 2).  The selection stanza is spliced
into proplang.cabal and MANIFEST.sha256 extended to cover the suite,
its stanza draft, and the freeze transcripts + kit.  From this commit
the oracle is as frozen as test/; the builder implements prophecy.diff
until green and may not touch these bytes.

Author commit: the manifest extension and the cabal splice are the
author's acts; the attestation is the signed tag over this commit."
echo "step 5: freeze commit $(git rev-parse --short HEAD) made"

# ---- step 6: the tag, by -F (the tag-message-is-a-file law) --------
git tag -s "$TAG" -F "$MSG"
git tag -v "$TAG"
minted="$probe_tmp/minted"
# pipe-free by construction (the close.sh SIGPIPE-under-pipefail
# repair, carried forward): cat-file to a file, awk a bounded count —
# never `... | head`, whose early close SIGPIPEs the producer.
git cat-file tag "$TAG" > "$probe_tmp/tagobj"
awk -v n="$(wc -l < "$MSG")" \
  'flag && c < n {print; c++} !flag && /^$/ {flag=1}' \
  "$probe_tmp/tagobj" > "$minted"
if cmp -s "$minted" "$MSG"; then
  echo "RECORD: minted tag message byte-identical to $MSG ($(wc -c < "$MSG") bytes)"
else
  echo "STOP: minted message differs from $MSG — investigate before pushing" >&2
  diff "$minted" "$MSG" | head >&2; exit 1
fi

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "The oracle is FROZEN.  The implementation phase opens: apply"
echo "test-selection/freeze/prophecy.diff byte-for-byte, gates 1-7,"
echo "then the close (chooseeu-sitting-r0 clause 6)."
echo "Publish (fast-forward only, never the merge button):"
echo "  git push origin master --follow-tags"
