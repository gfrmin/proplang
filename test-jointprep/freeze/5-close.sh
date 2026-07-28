#!/usr/bin/env bash
# jp sitting, script 5 — THE r1 CLOSE (author's key): rules the close
# docket (pack Part XV) and countersigns the increment. Running with
# the [RULING] intact accepts the drafted default — decline by
# editing BEFORE running (this file is hashed into the manifest
# below, so the frozen kit records the sitting as run).
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

if grep -q "PACKAGE-faithful" CLAUDE.md; then
  echo "GUARD: the canonization is already applied - refusing to run twice" >&2
  exit 1
fi

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-close"

# [RULING: PACKAGE-FAITHFULNESS canonized — the Part XIV incident's
# clause, amending the step-5 flag-faithful line in CLAUDE.md:
# bit-faithful means flag-faithful AND package-faithful; an overlay
# SAT compile runs under the stanza's dependency closure]
git apply test-jointprep/freeze/package-faithful.patch
echo "canonization applied"

sha256sum test-jointprep/freeze/package-faithful.patch >> MANIFEST.sha256
sha256sum test-jointprep/freeze/5-close.sh >> MANIFEST.sha256
sed -i "s|^[0-9a-f]*  CLAUDE.md\$|$(sha256sum CLAUDE.md)|" MANIFEST.sha256
sha256sum --quiet -c MANIFEST.sha256
echo "manifest re-signed OK ($(grep -c . MANIFEST.sha256) rows)"

tools/prefreeze-lint.sh | tee test-jointprep/freeze/lint-r1-transcript.txt

git add CLAUDE.md MANIFEST.sha256 \
        test-jointprep/freeze/package-faithful.patch \
        test-jointprep/freeze/5-close.sh \
        test-jointprep/freeze/lint-r1-transcript.txt
git commit -S -m "jp close sealed: package-faithfulness canonized (the Part XIV incident's clause into CLAUDE.md's flag-faithful line); manifest extended over the close kit; lint transcript rides the pack"
git tag -s jp-freeze-r1 -m "the jp increment CLOSED: implementation green through the sealed
oracle (jointprep red->green 15/15, ten suites, gates 1-7 PASS,
E1-E4 all 0 under the extended allowlist), the close matrix run
against the committed baseline — 14 mutants derived from the
increment's own incident case law, 12 killed, ALL 15 ROWS REACHED
(no green-that-cannot-fail in the sealed oracle), the standing
corpus green under every mutant so every kill is standing-unique:
the forward half discharged for all 15 rows. The JP7 heirs landed
(M42/M43 = the M28/M30 classes re-cut at the joint sites; M43
killed solely by the phantom-cure row, M49 solely by the DP price
row). The M46/M47 UNREACHED verdicts and the mint-level finding are
DOCKETED to the certification battery beside the structural-
shadowing verdicts (pool-relative, never auto-deletions). The
freeze-boundary containers repair (ef6a782, my key over the frozen
cabal) is RATIFIED and R-D22's chain closes; PACKAGE-FAITHFULNESS
is canonized by this sitting's patch (bit-faithful means
flag-faithful AND package-faithful: an overlay SAT compile runs
under the stanza's dependency closure — the jp prophecy's Data.Map
import reached the implementation phase unseen through exactly that
gap). The standingDP pre-ruling comment stands repaired with its
falsified words quoted in place. The joint preposterior is the
shipped object; the certification battery opens at the next
sitting, carrying the 14.9 wire docket."
git tag -v jp-freeze-r1

echo "CLOSED at jp-freeze-r1 - the certification battery is next (its sitting opens on the author's word)"
