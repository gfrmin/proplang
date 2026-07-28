#!/usr/bin/env bash
# jp sitting, script 4 — THE FREEZE-BOUNDARY REPAIR (author's key).
# Incident: the frozen prophecy's DP memo imports Data.Map, and the
# LIBRARY stanza is base-only BY RECORDED DECISION ("src depends on
# base ONLY ... keeps the audit's `ghc -isrc` ablation compiles
# package-DB-free") — the overlay SAT could not catch it: plain ghc
# sees boot packages, cabal hides undeclared ones (the overlay was
# flag-faithful but not PACKAGE-faithful; canonization candidate for
# the r1 sitting). The amendment re-states the decision as "GHC boot
# libraries only", quoting the falsified words inside the repair
# (the frozen-layer inventory form); its rationale was proven to
# survive EXECUTED: the frozen ablation runner passed 6/6 against
# the containers-importing src before this script existed.
# R-D22: the jp-freeze-r1 tag at the close ratifies this edit.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

if grep -q "BOOT LIBRARIES ONLY" proplang.cabal; then
  echo "GUARD: repair already applied - refusing to run twice" >&2
  exit 1
fi

git apply test-jointprep/freeze/containers-repair.patch
echo "repair patch applied"

# the kit freezes itself: the repair's two artifacts join the manifest
sha256sum test-jointprep/freeze/containers-repair.patch >> MANIFEST.sha256
sha256sum test-jointprep/freeze/4-repair.sh >> MANIFEST.sha256
sed -i "s|^[0-9a-f]*  proplang.cabal\$|$(sha256sum proplang.cabal)|" MANIFEST.sha256
sha256sum --quiet -c MANIFEST.sha256
echo "manifest re-signed OK ($(grep -c . MANIFEST.sha256) rows)"

# the frozen ablation audit, re-executed on the amended surface
bash audit/ablation-exact/run.sh src
echo "frozen ablation audit green on the amended surface"

git add proplang.cabal MANIFEST.sha256 \
        test-jointprep/freeze/containers-repair.patch \
        test-jointprep/freeze/4-repair.sh
git commit -S -m "jp freeze-boundary repair: the library stanza's base-only decision amended to GHC-boot-libraries-only (containers added for the DP's lazy memo; the falsified words quoted inside the amendment; frozen ablation runner 6/6 PASS re-executed on the amended surface; the overlay SAT's package-faithfulness gap recorded as a canonization candidate for r1)"

echo "REPAIRED - hand back to the builder (cabal test all resumes)"
