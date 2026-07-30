#!/usr/bin/env bash
# battery sitting, script 2/3 — the KEYLESS freeze mechanics: the
# stanza splice, the three [RULING] patches, gate 5 on the spliced
# tree, the manifest extension + re-sign, the pre-freeze lint. No
# signature here; stops on the first failure (set -euo pipefail) and
# refuses to run twice.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# double-run guard (an interrupted sitting re-runs safely; a second
# splice would corrupt proplang.cabal)
if grep -q "test-suite battery" proplang.cabal; then
  echo "GUARD: battery stanza already spliced - refusing to run twice" >&2
  exit 1
fi

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# 1. the stanza splice (proplang.cabal is frozen; this is the
#    freeze-boundary cabal edit, the trampoline/jp precedent)
cat test-battery/stanza.cabal.draft >> proplang.cabal
tail -19 proplang.cabal

# 2. [RULING R-CR7: the staged frozen-tool repairs EXECUTE — the
#    BF-row's -S->-G (the in-place prodTable edit 20->9 was invisible
#    to the pickaxe) and the M5-row's mutant-patch-files-are-
#    definition-sites upgrade; staged at the boundary opening, its
#    repaired-run transcript already in test-completeness/opening/]
git apply test-completeness/freeze/boundary-audit-repair.patch

# 3. [RULING R-CAPS: NO SILENT CAPS canonized in CLAUDE.md — mandate
#    2's finding (cited three times, defined nowhere); the substance
#    is EXACT_PLAN 14.1's printed-residual discipline, and the new
#    clause is the citation's definition site]
git apply test-battery/freeze/no-silent-caps.patch

# 4. [RULING R-RED: A RED IS CONSTRUCTED, NEVER OWED canonized in
#    CLAUDE.md — the author's own ruling of 2026-07-28, executed the
#    same day (the knife-edge constructions, pack Part XVIII);
#    g-b2.2's structural-cap discovery its provenance]
git apply test-battery/freeze/red-constructed.patch

# 5. gate 5 on the spliced tree: the battery's first stanza'd run,
#    alongside every standing suite (a single-tag close signs a tree
#    whose gates are green AT THE SEAL, not by recollection). The
#    transcript rides the freeze commit, un-hashed like the lint's.
cabal test all 2>&1 | tee test-battery/freeze/gate5-run.txt
grep "Test suite battery: PASS" test-battery/freeze/gate5-run.txt
echo "gate 5 green on the spliced tree (battery in the stanza set)"

# 6. extend the manifest over the increment oracle, then re-sign.
#    The kit freezes ITSELF — the three sitting scripts, the cover
#    page, and both canonization patches, hashed as actually run,
#    post any decline-by-edit (the jp form; the M41 lesson: a
#    freeze-kit artifact is a manifest row) — and every transcript
#    the tag cites (the green run, the serial kill matrix, the
#    knife probe, the seeded reds, the pool reach).
for f in test-battery/Battery.hs \
         test-battery/stanza.cabal.draft \
         test-battery/opening/green-run.txt \
         test-battery/opening/seeded-red.txt \
         test-battery/opening/battery-kill-matrix.txt \
         test-battery/opening/knife-probe.txt \
         test-battery/opening/pool-reach.txt \
         test-battery/freeze/freeze-commands.txt \
         test-battery/freeze/1-verify.sh \
         test-battery/freeze/2-freeze.sh \
         test-battery/freeze/3-sign.sh \
         test-battery/freeze/no-silent-caps.patch \
         test-battery/freeze/red-constructed.patch \
         test-completeness/freeze/boundary-audit-repair.patch; do
  sha256sum "$f" >> MANIFEST.sha256
done
sed -i "s|^[0-9a-f]*  proplang.cabal\$|$(sha256sum proplang.cabal)|" MANIFEST.sha256
sed -i "s|^[0-9a-f]*  CLAUDE.md\$|$(sha256sum CLAUDE.md)|" MANIFEST.sha256
sed -i "s|^[0-9a-f]*  tools/boundary-audit.sh\$|$(sha256sum tools/boundary-audit.sh)|" MANIFEST.sha256
sha256sum --quiet -c MANIFEST.sha256
echo "manifest re-signed OK"

# 7. the pre-freeze lint (its transcript rides the freeze commit;
#    pipefail makes a lint failure stop the sitting here, before any
#    key act)
tools/prefreeze-lint.sh | tee test-battery/freeze/lint-transcript.txt

echo "FREEZE MECHANICS DONE (keyless) - next: bash test-battery/freeze/3-sign.sh"
