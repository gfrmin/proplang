#!/usr/bin/env bash
# jp sitting, script 2/3 — the KEYLESS freeze mechanics: the stanza
# splice, the [RULING] E4 extension, the manifest extension +
# re-sign, the pre-freeze lint. No signature here; stops on the
# first failure (set -euo pipefail) and refuses to run twice.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# double-run guard: an interrupted sitting re-runs safely (the f5
# first-run failure is the incident class; a second splice would
# corrupt proplang.cabal)
if grep -q "test-suite jointprep" proplang.cabal; then
  echo "GUARD: jointprep stanza already spliced - refusing to run twice" >&2
  exit 1
fi

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# 1. the stanza splice (proplang.cabal is frozen; this is the
#    freeze-boundary cabal edit, the trampoline precedent)
cat test-jointprep/stanza.cabal.draft >> proplang.cabal
tail -18 proplang.cabal

# 2. [RULING: the E4 allowlist extension — three loop-clock rows
#    enumerated against the SAT overlay (the canonized law); JP10's
#    depth-bound row enters WITH the register item that rules the
#    bound's lawful form before implementation]
git apply test-jointprep/freeze/e4-extension.patch

# 3. extend the manifest over the increment oracle, then re-sign.
#    The kit freezes ITSELF — all three sitting scripts and the cover
#    page, hashed as actually run, post any decline-by-edit (the
#    dyadic/trampoline form; the M41 lesson: a freeze-kit artifact is
#    a manifest row) — and every evidence program the tag cites by
#    name (EV-JP5..JP8) has its transcript under the manifest.
for f in test-jointprep/JointPrep.hs test-jointprep/stanza.cabal.draft \
         test-jointprep/freeze/implementation.diff \
         test-jointprep/freeze/e4-extension.patch \
         test-jointprep/freeze/freeze-commands.txt \
         test-jointprep/freeze/1-verify.sh \
         test-jointprep/freeze/2-freeze.sh \
         test-jointprep/freeze/3-sign.sh \
         test-jointprep/opening/red-run.txt \
         test-jointprep/opening/sat-run.txt \
         test-completeness/opening/jp5-sayable-route-run.txt \
         test-completeness/opening/jp6-dominance-run.txt \
         test-completeness/opening/jp7-clairvoyance-run.txt \
         test-completeness/opening/jp8-voi-run.txt; do
  sha256sum "$f" >> MANIFEST.sha256
done
sed -i "s|^[0-9a-f]*  proplang.cabal\$|$(sha256sum proplang.cabal)|" MANIFEST.sha256
sed -i "s|^[0-9a-f]*  audit/gates-exact.sh\$|$(sha256sum audit/gates-exact.sh)|" MANIFEST.sha256
sed -i "s|^[0-9a-f]*  test-trampoline/freeze/gate-e4.sh\$|$(sha256sum test-trampoline/freeze/gate-e4.sh)|" MANIFEST.sha256
sha256sum --quiet -c MANIFEST.sha256
echo "manifest re-signed OK"

# 4. the pre-freeze lint (its transcript rides the pack; pipefail
#    makes a lint failure stop the sitting here, before any key act)
tools/prefreeze-lint.sh | tee test-jointprep/freeze/lint-transcript.txt

echo "FREEZE MECHANICS DONE (keyless) - next: bash test-jointprep/freeze/3-sign.sh"
