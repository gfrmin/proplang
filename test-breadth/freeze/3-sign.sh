#!/usr/bin/env bash
# breadth oracle freeze, script 3/4 — THE FREEZE COMMIT. Run by the
# AUTHOR from their own shell (default signing key), or by the builder
# under a fresh, explicit, per-instance delegation with the builder
# key and the delegation recorded verbatim (the membrane precedent;
# R-D22 then obliges the author's re-tag within the increment).
set -euo pipefail
cd "$(dirname "$0")/../.."

# step 0 (OB-29): a LIVE throwaway signature before the key act —
# execution, never inspection; the nonce rides a file (-F).
probe_tmp=$(mktemp -d)
trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe nonce over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-breadth-sign -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED - key absent or locked; nothing committed" >&2; exit 1; }
git tag -v sig-probe-breadth-sign >/dev/null 2>&1 \
  || { git tag -d sig-probe-breadth-sign >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-breadth-sign >/dev/null
echo "step 0: live signature probe OK"

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK (2-freeze's extension in place)"

git add -A
git status --short | head -30
printf 'Commit the freeze under YOUR key? Type yes: '
read -r answer
[ "$answer" = "yes" ] || { echo "declined - nothing committed"; exit 1; }

# the -m below is a kit-authored CONSTANT, not reviewed prose (the
# OB-30 recorded boundary case); the ATTESTATION rides the TAG, whose
# message is a FILE (4-close.sh, -F from the committed tag-msg.txt)
git commit -S -m "the OB-19 heir ORACLE FREEZE (breadth-freeze-r0): test-breadth/ b1-b8 + gated drift row frozen; the sitting's routed installs land - the stanza splice, the one CLAUDE.md touch (OB-27 scope line + the prose-claim gate), lint L8 + the OB-28 hardenings with two-sided demos, the ledger advances (OB-25/26/27/28/29 discharged, OB-31/OB-19 landed, OB-32 minted), the FL repairs (boundary-audit note, Host.hs wait comment, dispositions-pack dated bracket); manifest extended and re-signed AFTER the lint rows (OB-26's order)"
git log --oneline -1
echo
echo "FREEZE COMMITTED. 4-close.sh mints the tag from the committed message file."
