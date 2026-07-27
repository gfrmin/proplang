#!/usr/bin/env bash
# THE r1 SITTING — the command crib (drafted by the builder under the
# standing delegation's "you write everything" half; agenda = pack
# Part XIII.6). EVERY command below runs in the AUTHOR's shell and
# signs with the AUTHOR's key — this repo's local user.signingkey is
# ~/.ssh/id_ed25519.pub (the author's; the builder always overrides
# per-command, so plain `git commit -S` / `git tag -s` here is the
# author's attestation). READ BEFORE RUNNING: the [RULING] blocks are
# choices — delete a block to decline it, then edit the commit and
# tag messages to match what you actually ruled.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

## 0 — see what you are signing.
git log --oneline f062dc6..HEAD
git tag -v trampoline-freeze-r0        # builder key, delegation recorded
sha256sum --quiet -c MANIFEST.sha256 && echo "manifest 71/71 OK"

## 1 — the E4 allowlist repair (Part XII's staged diff, byte-for-byte;
##     builder-verified on scratch copies: E4 goes 4 -> 0 against
##     shipped src, both scripts exit 0). Touches the two frozen gate
##     scripts only.
git apply r1-kit/e4-repair.patch

## 2 — [RULING] the two CLAUDE.md canonizations in ONE patch (XIII.1
##     the overlay-scan law; XIII.4 F6 as the unique-kill clause's
##     amendment). Declining one of the two means hand-editing the
##     patch or the file — they are adjacent paragraphs.
git apply r1-kit/claude-canonizations.patch

## 3 — [RULING] F4's liveness clause into membrane-wire.md Edit 2
##     (XIII.2's drafted frozen-layer inventory row: menu order is
##     TERMINATION, not only semantics).
git apply r1-kit/membrane-f4-liveness.patch

## 4 — [RULING] delete the four dead fold-mutants (post-re-land they
##     patch code that no longer exists; heirs all standing:
##     M19->M39, M20->M28, M22->M33, M27->M40). Not manifest rows.
git rm --quiet audit/mutants/M19-ladder-cap-baked-one.patch \
       audit/mutants/M20-wait-tie-surrendered.patch \
       audit/mutants/M22-straddle-gate-inverted.patch \
       audit/mutants/M27-norefine-buys-free.patch

## 5 — re-sign the touched manifest rows (skip-safe: a row whose file
##     was not edited re-signs to its identical hash).
for f in audit/gates-exact.sh test-trampoline/freeze/gate-e4.sh CLAUDE.md membrane-wire.md; do
  sed -i "s|^[0-9a-f]*  $f\$|$(sha256sum "$f")|" MANIFEST.sha256
done
sha256sum --quiet -c MANIFEST.sha256 && echo "manifest re-signed, 71/71 OK"

## 6 — verify: both gates green, then the pre-freeze lint before the
##     tag (the lint law; transcript rides in-tree beside the kit).
bash audit/gates-exact.sh
bash test-trampoline/freeze/gate-e4.sh
tools/prefreeze-lint.sh | tee r1-kit/lint-r1-transcript.txt
# cabal test all   # optional: src is untouched by this sitting

## 7 — the sitting commit (AUTHOR key). Edit to match your rulings.
git add -A
git commit -S -m "the r1 sitting: E4 allowlist repaired, the overlay-scan law and F6's amendment canonized, F4's liveness clause installed, four dead fold-mutants deleted; manifest re-signed 71/71"

## 8 — the tag (AUTHOR key; the message names BOTH delegated tags —
##     XIII.5's cure). F5 defaults to DOCKETED, not deleted: its
##     deletion moves the sentence's price and belongs to the
##     completeness suite's oracle, not a sitting.
git tag -s trampoline-freeze-r1 -m "the close-out reviewed; the trampoline stands. The per-instance
delegations recorded in dyadic-freeze-r0 and trampoline-freeze-r0
are ratified BY NAME - each was fresh at its instance; neither is,
nor becomes, a standing arrangement. R4 (substitution normative) and
R11 (license-by-name) ratified as ruled. Executed under this key at
this sitting: the E4 allowlist repair, the overlay-scan law, F6's
amendment, F4's liveness clause, the four dead fold-mutants'
deletion (heirs M39/M28/M33/M40 standing). F5's forgone term:
DOCKETED to the completeness suite, not ruled here."
git tag -v trampoline-freeze-r1

## 9 — push, on your word (this command IS the word).
git push origin master trampoline-freeze-r0 trampoline-freeze-r1
