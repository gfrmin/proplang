#!/usr/bin/env bash
# breadth oracle freeze, script 4/4 — THE TAG. The message is a FILE
# (readout-freeze-r1's canon, lint L9's law): -F from the COMMITTED
# tag-msg.txt, whose bytes the manifest already hashes. After the
# mint, the minted message is byte-compared against the file (the
# r1 standing record row's form).
set -euo pipefail
cd "$(dirname "$0")/../.."

TAG="breadth-freeze-r0"
MSG="test-breadth/freeze/tag-msg.txt"

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "ABORT: tag $TAG already exists" >&2; exit 1; }
[ -f "$MSG" ] || { echo "ABORT: $MSG missing" >&2; exit 1; }
git diff --quiet HEAD -- "$MSG" \
  || { echo "ABORT: $MSG differs from the committed copy - commit first (the manifest hashes it)" >&2; exit 1; }
sha256sum --quiet -c MANIFEST.sha256

git tag -s "$TAG" -F "$MSG"
git tag -v "$TAG"

# the identity record row: minted message == the file, byte for byte
git cat-file tag "$TAG" | awk 'flag{print} /^$/{flag=1}' \
  | head -n "$(wc -l < "$MSG")" > /tmp/breadth-minted-msg.$$
if cmp -s /tmp/breadth-minted-msg.$$ "$MSG"; then
  echo "RECORD: minted tag message byte-identical to $MSG ($(wc -c < "$MSG") bytes)"
else
  echo "STOP: minted message differs from $MSG - investigate before pushing" >&2
  diff /tmp/breadth-minted-msg.$$ "$MSG" | head >&2
  rm -f /tmp/breadth-minted-msg.$$
  exit 1
fi
rm -f /tmp/breadth-minted-msg.$$

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "Local by design - publish at the increment's close, on the author's call."
echo "If this run was delegated (builder key): the author's re-tag within"
echo "the increment is R-D22's condition of closure, never a courtesy."
echo "NEXT: the implementation phase (Phase 3) - stubs replaced, gates 1-7,"
echo "kill matrix vs the grown pool, close-out pack, author countersign."
