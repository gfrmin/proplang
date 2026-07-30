#!/usr/bin/env bash
# battery sitting, script 3/3 — THE AUTHOR'S ATTESTATION, nothing
# else. Run from the author's shell: the repo's local user.signingkey
# is the author's own, so plain -S/-s here IS the author's key. The
# tag message below carries the full register ruling as drafted —
# running it intact accepts the drafted defaults; DECLINE BY EDITING
# this file (or a [RULING] line in 2-freeze.sh) BEFORE running
# 2-freeze.sh, whose manifest loop hashes the kit as run. The manifest
# re-check below ENFORCES that order: an edit made after 2-freeze.sh
# already hashed this file is refused here, before any key act —
# restore the tree and re-open the sitting instead.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK (the kit rows match the scripts as run)"

git add proplang.cabal MANIFEST.sha256 CLAUDE.md tools/boundary-audit.sh \
        test-battery/freeze test-battery/stanza.cabal.draft \
        test-completeness/freeze/boundary-audit-repair.patch
git commit -S -m "battery freeze: the certification oracle sealed (82 rows, green live at the sitting, every row red-demonstrated against the committed M42-M63 pool - no red owed; stanza spliced; CR7 + both canonization patches applied; manifest extended) - single-tag close"
git tag -s battery-freeze-r0 -m "the certification battery's register ruled (single-tag close: a
pin-freeze with no implementation owed; the 22-mutant serial kill
matrix already run against the committed baseline, every row
red-demonstrated, the residual a RECORD row). The single-tag form
is a TRADE, owned: it removes the r1 catch-net where the last two
increments' largest findings surfaced (the trampoline E4 allowlist
gap, the jp package-faithfulness gap), on the grounds that a
pin-freeze has no implementation phase for defects to enter
through and the matrix is already cut; the live 82/82 inside
1-verify is the substitute. Anything surfacing post-tag enters as
a frozen-layer inventory row at the wire docket's next sitting -
the standing per-sitting channel, never a standing license.

CR3 the family's axes are the as-built declaration - 3 grids x 4
prices x 3 batches x 2 streams, 72 cells, the four t2 anchors
falling out of the walk byte-equal to frozen t2RowsX - and the
residual is PRINTED, never absorbed; the unwalked axes (K>2 and
the t1/t3 faces, longer and adversarial streams, deeper batches,
finer grids) stay in the printed residual. CR4 the decision-law
rows land as VoI>=0 (g-b2.1, named honestly per mandate 1: a
conformance pin on the engine's shared mass decomposition, M44
its committed red) and scale invariance (g-b2.2 with the
constructed window triple, g-b2.3 mint-with-stakes homogeneity,
g-b3.4 the mint-level differential at the measured margin); the
SHIFT half of affine invariance is ruled a MENU CONVENTION (the
declared wait row pins zero, so a stake shift is a
re-declaration, not an invariance); admissibility DEFERS to the
K>2 residual (no independent content on the binary face). CR5
OB-20/21 are DISCHARGED at this boundary: M56-M61 committed with
reach demonstrated - lawful reached, the independence suite the
refusal-law mutant's sole killer, pins the count-gate's, and
M61's predicted generator-blindness cured in-increment by
g-b4.1. CR6 the sufficiency claim's prose form is TWO SENTENCES,
never one (mandate 1's findings constrain the wording, and this
is the sentence the boundary exists to produce): (i) the shipped
joint loop is exact-equal to an independent reference across all
72 cells of the DECLARED class C - the closure of the World
declaration walked at the committed axes - and non-vacuously so
(M42/M44 fire 45/58 rows); (ii) the law rows are CONFORMANCE
PINS on the engine's shared mass decomposition, stated with
their reach-not-variety accounting (g-b2.1 computes 9 distinct
values across the walk - price never enters jointPrepost and
stream content enters only as d = min n 36; its red is M44).
The unwalked axes stay printed as the residual; never 'in
general' without the class named, and never the coverage of (i)
implied for the rows of (ii). CR7 the
staged frozen-tool repairs EXECUTE at this freeze (the BF-row
-S to -G, the M5-row mutant-file definition sites; applied by
2-freeze.sh).

JP2-d6 pwLadderCap: measured at ZERO live consumers (E-B1);
ruled RETIRE-UNTIL-N - the myopic face stays frozen-pinned and
the retirement question RETURNS as an opening-checklist row at
the wire docket's #19 sitting, whose 1a-or-doctrine ruling
decides whether the face gains its first live consumer or
retires with its pins listed.

The jp close's UNREACHED verdicts are DISCHARGED: M46 by g-b3.1
(sole killer), M47 by g-b3.3 (sole killer, the measured VoI
window); the mint-level blindness by g-b3.4 (M48's battery reach
0 -> 2). The battery mandate round (pack Part XVII, all six
reviewers, eleven findings) is received and ratified WITH ITS
ASYMMETRY LEGIBLE: REPAIRED in-tree - g-b2.2's case-split (4a),
the false residual (3b), g-b4.1's nonemptiness (1c), spaceKOf's
points-guard (4c/6b), the provenance lines (4b/6a), the
pool-extent header (5b), and the committed matrix + M62/M63
cuts (2a/3a/5a); RECORDED as honest accounting, no repair owed -
1a (g-b2.1 a conformance pin of the shared decomposition, named
in CR4 and CR6 above) and 1b (the 9-distinct-values reach
accounting, stated in CR6). The author's ruling of 2026-07-28 -
never owe a red - is RATIFIED as executed (the knife-edge
constructions, pack Part XVIII: the guard's structural cap
g_max=(1-s)/2 found, the stakes axis the free variable) and
canonized in CLAUDE.md by this sitting's R-RED patch WITH the
honest-decline clause (an unconstructible red disposes as a
RECORD row with the impossibility argument stated, never
fabricated into an artificial cell - the residual row's
precedent), beside R-CAPS giving the no-silent-caps law its
definition site.

The 14.9 wire docket's scheduling is RATIFIED in the recorded
order: #20 (the K-ary readout micro-increment) first, the OB-19
heir (enumeration breadth; the consumer's latency and population
curves solicited) second, #19 ruled as 1a-or-doctrine per
dispositions-pack VIII.4 third - each its own oracle-first
frozen increment. The completeness boundary's third act closes
with this tag."
git tag -v battery-freeze-r0

echo "SEALED at battery-freeze-r0 (single-tag close; no implementation phase follows)"
echo "push on your word: git push origin master battery-freeze-r0"
echo "next per the ratified 14.9 order: the #20 readout increment opens oracle-first"
