#!/usr/bin/env bash
# jp sitting, script 3/3 — THE AUTHOR'S ATTESTATION, nothing else.
# Run from the author's shell: the repo's local user.signingkey is
# the author's own, so plain -S/-s here IS the author's key. The tag
# message below carries the JP1-JP10 register ruling as drafted —
# running it intact accepts the drafted defaults; DECLINE BY EDITING
# this file BEFORE running 2-freeze.sh (whose manifest loop hashes
# the kit as run). The manifest re-check below ENFORCES that order:
# an edit made after 2-freeze.sh already hashed this file is refused
# here, before any key act — restore the tree and re-open the
# sitting instead.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK (the kit rows match the scripts as run)"

git add proplang.cabal MANIFEST.sha256 audit/gates-exact.sh \
        test-trampoline/freeze/gate-e4.sh \
        test-jointprep/freeze/lint-transcript.txt \
        test-jointprep/freeze/freeze-commands.txt \
        test-jointprep/freeze/1-verify.sh \
        test-jointprep/freeze/2-freeze.sh \
        test-jointprep/freeze/3-sign.sh \
        test-jointprep/stanza.cabal.draft
git commit -S -m "jp freeze: the reflexive oracle sealed (15 rows red on the stubs, SAT 15/15 on the one-chooser-everywhere overlay; stanza spliced; the E4 loop-clock extension applied; manifest extended)"
git tag -s jp-freeze-r0 -m "the joint-preposterior increment's register ruled: JP1 the
lookahead is bounded by declared data, JP2 the shipped myopic route
keeps its cap and pins (the cap's deletion docketed to the battery
sitting), JP3 the sayable route = the one-chooser-everywhere
identity (EV-JP5, the oracle's g-jp5 pin), JP4 cross-nesting stays
demand-gated, JP5 the episode shape is a world declaration, JP6 the
mandate round ran full (pack Part XII), JP7 the pool heirs arrive
at the close, JP8 the standing DP ships as the HINDSIGHT
(declared-stream planning) face — EV-JP7's demonstration named it
honestly — and reading B (the live preposterior) stays registered
demand-gated, JP9 no re-minted mention on either side (the F5
doctrine; the Get-freeness invariance recorded), JP10 the
direction is neutral-by-dominance (EV-JP6) and the depth is
DECLARED WORLD DATA (jwDepth, ratified as declared). The mandate
round's eleven findings and dispositions (pack Part XII) are
received; the round's three repairs-by-deletion (jwThink, the
silent fallbacks, the by-luck standing menu) are ratified. The
implementation lands after this tag, pinned to the sealed oracle."
git tag -v jp-freeze-r0

echo "SEALED at jp-freeze-r0 - hand back to the builder (implementation.diff, cabal test all, gates incl. extended E4, close matrix with the JP7 heirs, close-out report, jp-freeze-r1)"
