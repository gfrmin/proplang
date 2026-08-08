#!/usr/bin/env bash
# doctrine sitting close — THE R1 COUNTERSIGN. Run by the AUTHOR from
# their own shell, with the AUTHOR's default signing key: R-D22's
# re-tag is the author's own signed tag covering the sitting's acts as
# executed on delegation — a condition of closure that CANNOT be
# delegated (the delegated doctrine-sitting-r0 is what this tag exists
# to ratify). The message is a FILE (-F from the committed
# r1-tag-msg.txt, whose bytes the manifest hashes — lint L9's law);
# the minted message is byte-compared against the file after the act.
set -euo pipefail
cd "$(dirname "$0")/.."

TAG="doctrine-sitting-r1"
R0="doctrine-sitting-r0"
MSG="doctrine-sitting/r1-tag-msg.txt"

# step 0 (OB-29): a LIVE throwaway signature before the key act —
# execution, never inspection; the nonce rides a file (-F).
probe_tmp=$(mktemp -d)
trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe nonce over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-doctrine-close -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED - key absent or locked; nothing minted" >&2; exit 1; }
git tag -v sig-probe-doctrine-close >/dev/null 2>&1 \
  || { git tag -d sig-probe-doctrine-close >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-doctrine-close >/dev/null
echo "step 0: live signature probe OK"

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "ABORT: tag $TAG already exists" >&2; exit 1; }
git tag -v "$R0" >/dev/null 2>&1 \
  || { echo "ABORT: $R0 does not verify - the delegated tag this r1 ratifies" >&2; exit 1; }
[ "$(git rev-parse "$R0^{commit}")" = "$(git rev-parse HEAD)" ] \
  || { echo "ABORT: HEAD is not the sitting commit $R0 covers" >&2; exit 1; }
[ -f "$MSG" ] || { echo "ABORT: $MSG missing" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] \
  || { echo "ABORT: tree not clean - the tag covers the sitting commit as committed" >&2; exit 1; }
grep -q "$MSG" MANIFEST.sha256 \
  || { echo "ABORT: $MSG is not a manifest row (the tag-message-is-a-file law)" >&2; exit 1; }
sha256sum --quiet -c MANIFEST.sha256

git tag -s "$TAG" -F "$MSG"
git tag -v "$TAG"

# the identity record row: minted message == the file, byte for byte
minted="$probe_tmp/minted-msg"
git cat-file tag "$TAG" | awk 'flag{print} /^$/{flag=1}' \
  | head -n "$(wc -l < "$MSG")" > "$minted"
if cmp -s "$minted" "$MSG"; then
  echo "RECORD: minted tag message byte-identical to $MSG ($(wc -c < "$MSG") bytes)"
else
  echo "STOP: minted message differs from $MSG - investigate before pushing" >&2
  diff "$minted" "$MSG" | head >&2
  exit 1
fi

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "R-D22 DISCHARGED: the author's own tag now covers the delegated"
echo "$R0 by name and the sitting's acts beneath it. The #19 sitting is"
echo "CLOSED; the wire docket's three scheduled items all stand closed."
echo "Publish chain + tags on your call:"
echo "  git push origin master --follow-tags"
echo "Then issue #19 closes citing this sitting (the witness comment is"
echo "already on the issue; the close cites $R0/$TAG)."
