#!/usr/bin/env bash
# breadth close, script 5 — THE R1 COUNTERSIGN. Run by the AUTHOR
# from their own shell, with the AUTHOR's default signing key:
# R-D22's re-tag is the author's own signed tag covering the oracle
# as amended — a condition of closure that CANNOT be delegated (the
# delegated breadth-freeze-r0 is what this tag exists to ratify).
# The message is a FILE (-F from the committed r1-tag-msg.txt, whose
# bytes the manifest hashes — lint L9's law); the minted message is
# byte-compared against the file after the act (4-close's form).
set -euo pipefail
cd "$(dirname "$0")/../.."

TAG="breadth-freeze-r1"
MSG="test-breadth/freeze/r1-tag-msg.txt"

# step 0 (OB-29): a LIVE throwaway signature before the key act —
# execution, never inspection; the nonce rides a file (-F).
probe_tmp=$(mktemp -d)
trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe nonce over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-breadth-close -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED - key absent or locked; nothing minted" >&2; exit 1; }
git tag -v sig-probe-breadth-close >/dev/null 2>&1 \
  || { git tag -d sig-probe-breadth-close >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-breadth-close >/dev/null
echo "step 0: live signature probe OK"

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "ABORT: tag $TAG already exists" >&2; exit 1; }
[ -f "$MSG" ] || { echo "ABORT: $MSG missing" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] \
  || { echo "ABORT: tree not clean - the tag covers the close-out commit as committed" >&2; exit 1; }
grep -q "$MSG" MANIFEST.sha256 \
  || { echo "ABORT: $MSG is not a manifest row (the tag-message-is-a-file law)" >&2; exit 1; }
sha256sum --quiet -c MANIFEST.sha256

git tag -s "$TAG" -F "$MSG"
git tag -v "$TAG"

# the identity record row: minted message == the file, byte for byte
git cat-file tag "$TAG" | awk 'flag{print} /^$/{flag=1}' \
  | head -n "$(wc -l < "$MSG")" > /tmp/breadth-r1-minted-msg.$$
if cmp -s /tmp/breadth-r1-minted-msg.$$ "$MSG"; then
  echo "RECORD: minted tag message byte-identical to $MSG ($(wc -c < "$MSG") bytes)"
else
  echo "STOP: minted message differs from $MSG - investigate before pushing" >&2
  diff /tmp/breadth-r1-minted-msg.$$ "$MSG" | head >&2
  rm -f /tmp/breadth-r1-minted-msg.$$
  exit 1
fi
rm -f /tmp/breadth-r1-minted-msg.$$

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "R-D22 DISCHARGED: the author's own tag now covers the delegated"
echo "breadth-freeze-r0 by name and the close-out commit beneath it."
echo "The increment is CLOSED. Publish chain + tags on your call:"
echo "  git push origin master --follow-tags"
echo "Then issue #21 closes citing this boundary; the docket rolls to #19."
