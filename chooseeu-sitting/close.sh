#!/usr/bin/env bash
# THE #24 SITTING'S CLOSE -- the author's signature over R-SHAPE rev 2.
# Run by the AUTHOR from their own shell, with the AUTHOR's signing key
# (thinkpad: gpg.format=ssh, user.signingkey=proplang-author-thinkpad).
# The builder wrote this file and NEVER runs it (signing custody: the
# key act is the author's alone).
#
# The message is a FILE (-F from the committed r0-tag-msg.txt -- the
# tag-message-is-a-file law); this sitting touches no manifest-covered
# file, so the message's bytes are fixed by the sitting COMMIT the tag
# covers (the tag names the commit, the commit hashes the file) --
# the same custody a manifest row provides at a manifest-touching
# boundary.  The minted message is byte-compared against the file
# after the act (the readout-r1 identity record, reused).
set -euo pipefail
cd "$(dirname "$0")/.."

TAG="chooseeu-sitting-r0"
MSG="chooseeu-sitting/r0-tag-msg.txt"

# step 0 (OB-29): a LIVE throwaway signature before the key act --
# execution, never inspection; the nonce rides a file (-F).
probe_tmp=$(mktemp -d)
trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe nonce over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-chooseeu-close -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED - key absent or locked; nothing minted" >&2; exit 1; }
git tag -v sig-probe-chooseeu-close >/dev/null 2>&1 \
  || { git tag -d sig-probe-chooseeu-close >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-chooseeu-close >/dev/null
echo "step 0: live signature probe OK"

git rev-parse -q --verify "refs/tags/$TAG" >/dev/null \
  && { echo "ABORT: tag $TAG already exists" >&2; exit 1; }
[ -f "$MSG" ] || { echo "ABORT: $MSG missing" >&2; exit 1; }
# NOTE pipe-free by repair (2026-09-02): the first cut piped ls-tree
# into grep -q, and under this script's own pipefail grep's early exit
# SIGPIPEd ls-tree into a FALSE ABORT on the author's first run.
[ -n "$(git ls-tree -r --name-only HEAD -- "$MSG")" ] \
  || { echo "ABORT: $MSG is not in HEAD's tree - the tag must cover its own message" >&2; exit 1; }
[ -z "$(git status --porcelain)" ] \
  || { echo "ABORT: tree not clean - if you amended anything, commit it first (the tag covers reviewed bytes)" >&2; exit 1; }

echo "Tagging $(git rev-parse --short HEAD) as $TAG (read the summary line below and abort with ctrl-C within 5s if this is not the sitting commit):"
git log -1 --format='  %h  %s'
sleep 5

git tag -s "$TAG" -F "$MSG"
git tag -v "$TAG"

# the identity record row: minted message == the file, byte for byte
minted="$probe_tmp/minted-msg"
git cat-file tag "$TAG" > "$probe_tmp/tagobj"
awk -v n="$(wc -l < "$MSG")" \
  'flag && c < n {print; c++} !flag && /^$/ {flag=1}' \
  "$probe_tmp/tagobj" > "$minted"
if cmp -s "$minted" "$MSG"; then
  echo "RECORD: minted tag message byte-identical to $MSG ($(wc -c < "$MSG") bytes)"
else
  echo "STOP: minted message differs from $MSG - investigate before pushing" >&2
  diff "$minted" "$MSG" | head >&2
  exit 1
fi

echo
echo "DONE: $TAG minted over $(git rev-parse --short HEAD) and verifies."
echo "R-SHAPE rev 2 is ADOPTED; the (3) increment opens ORACLE-FIRST."
echo "Publish on your call (fast-forward only -- never the merge button):"
echo "  git push origin master --follow-tags"
