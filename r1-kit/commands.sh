#!/usr/bin/env bash
# THE r1 SITTING — one script, the whole sitting: verification, the
# E4 repair, the canonizations, the mutant deletions, the manifest
# re-sign, the lint, the sitting commit, the trampoline-freeze-r1
# tag, and the push. Drafted by the builder under the standing
# delegation; RUN FROM THE AUTHOR'S SHELL — this repo's local
# user.signingkey is the author's own key, so every -S/-s below is
# the author's attestation. Running this script is the ruling on its
# defaults (each marked [RULING]) and step 9's push is the word. To
# decline a [RULING], delete its block and adjust the commit and tag
# messages before running. Aborts hard on any failure (set -euo).
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
# The ghcup toolchain is not on the default PATH (the first-run
# abort's lesson: lint's L7 corpus build needs ghc and cabal).
export PATH="$HOME/.ghcup/bin:$PATH"

echo "== 0: see what you are signing =="
[ -z "$(git status --porcelain)" ] || { echo "tree not clean — aborting"; exit 1; }
git log --oneline f062dc6..HEAD
git tag -v trampoline-freeze-r0        # builder key, delegation recorded
sha256sum --quiet -c MANIFEST.sha256 && echo "manifest 71/71 OK"

echo "== 1: the E4 allowlist repair (Part XII's staged diff; verified 4 -> 0) =="
git apply r1-kit/e4-repair.patch

echo "== 2: [RULING] CLAUDE.md canonizations (XIII.1 overlay-scan law + XIII.4 F6 amendment) =="
git apply r1-kit/claude-canonizations.patch

echo "== 3: [RULING] membrane-wire Edit 2 gains F4's liveness clause (XIII.2) =="
git apply r1-kit/membrane-f4-liveness.patch

echo "== 4: [RULING] the four dead fold-mutants die (heirs M39/M28/M33/M40 standing) =="
git rm --quiet audit/mutants/M19-ladder-cap-baked-one.patch \
       audit/mutants/M20-wait-tie-surrendered.patch \
       audit/mutants/M22-straddle-gate-inverted.patch \
       audit/mutants/M27-norefine-buys-free.patch

echo "== 5: re-sign the touched manifest rows (skip-safe for declined items) =="
for f in audit/gates-exact.sh test-trampoline/freeze/gate-e4.sh CLAUDE.md membrane-wire.md; do
  sed -i "s|^[0-9a-f]*  $f\$|$(sha256sum "$f")|" MANIFEST.sha256
done
sha256sum --quiet -c MANIFEST.sha256 && echo "manifest re-signed, 71/71 OK"

echo "== 6: verify — both gates green, then the pre-freeze lint before the tag =="
bash audit/gates-exact.sh
bash test-trampoline/freeze/gate-e4.sh
tools/prefreeze-lint.sh | tee r1-kit/lint-r1-transcript.txt
# cabal test all   # optional: src is untouched by this sitting

echo "== 7: the sitting commit (AUTHOR key) =="
git add audit/gates-exact.sh test-trampoline/freeze/gate-e4.sh \
        CLAUDE.md membrane-wire.md MANIFEST.sha256 \
        r1-kit/lint-r1-transcript.txt
git commit -S -m "the r1 sitting: E4 allowlist repaired, the overlay-scan law and F6's amendment canonized, F4's liveness clause installed, four dead fold-mutants deleted; manifest re-signed 71/71"

echo "== 8: the tag (AUTHOR key; names BOTH delegated tags — XIII.5's cure) =="
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

echo "== 9: push — this IS the word =="
git push origin master trampoline-freeze-r0 trampoline-freeze-r1

echo "== the trampoline boundary is CLOSED and PUBLISHED =="
