#!/usr/bin/env bash
# readout sitting, script 3/3 — THE AUTHOR'S ATTESTATION, nothing
# else. Run from the author's shell: the repo's local user.signingkey
# is the author's own, so plain -S/-s here IS the author's key. The
# tag message below carries the full register ruling as drafted —
# running it intact accepts the drafted defaults; DECLINE BY EDITING
# this file (or a staged patch) BEFORE 2-freeze.sh runs. The manifest
# re-check below ENFORCES that order: an edit made after 2-freeze.sh
# already hashed this file is refused here, before any key act —
# restore the tree and re-open the sitting instead.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK (the kit rows match the scripts as run)"

git add proplang.cabal MANIFEST.sha256 membrane-wire.md OBLIGATIONS.md \
        test-readout
git commit -S -m "readout freeze: the #20 oracle sealed (6 rows red-by-design vs shipped src, re-demonstrated live at the sitting; SAT 6/6 vs the staged overlay; stanza spliced; membrane-wire + OBLIGATIONS installs applied; manifest 120) - the 14.9 wire docket's first increment, two-phase"
git tag -s readout-freeze-r0 -m "the #20 K-ary readout's register ruled (the 14.9 wire docket's
first increment, opened per battery-freeze-r0's ratified order;
grant = dispositions-pack VIII.1, re-executed at this opening
against the shipped exact engine — the banked measurement treated
as a hypothesis per the step-10 clause, and it reproduced
STRONGER: p0 pinned at the structural cap (1-thetaMin)/(K-1) to
six significant figures while the empirical null rate is 0.75,
argmax atom 3 while the shipped scalar reads atom 1).

R1 the reply ships the FULL VECTOR ONLY (p_codes; the filed
scalars argmax_code/p_argmax/p0 are projections of it - VIII.1's
two grounds). R2 the member's name is p_codes, appended LAST (the
utility_bits precedent). R3 N1 RIDES THIS INCREMENT: the opening
probe found the shipped decision reply emitting entropy_bits NaN
after a long fold (Report.hs entropyOf guards the exact weight
but multiplies in Double; underflow makes 0 * log 0) - a live
invalid-JSON defect on the wire, repaired at the reporting edge
(the Double-side guard; an underflowed term displays its limit,
0), its own oracle row (g6) red today for exactly that reason.
R4 presence scope is exactly decPart: decision + combined
replies, never evidence-only / silent / internal. R5 elements
render as p1 renders (show @Double), joined by the reply's own
commaSep. R6 the membrane-wire install executes at this freeze
(the p_codes bullet with the consumer discipline QUOTED into the
frozen doc at the grant's own instruction - readouts land in
ledger rows and footers, NEVER in a branch, HOSTS_PLAN 8.12(b);
the reply example; the identity-table row). R7 the boundary
audit's flag at this opening - OB-20/21 still reading SCHEDULED
against the closed x5 boundary - is repaired through the exact
channel the battery's TRADE paragraph named: the ledger flips to
DISCHARGED@battery-freeze-r0 with CR5 quoted. R8 the guards key
is documented REQUIRED (the probe note N2; Host.hs:251 always
enforced it).

The frozen-layer inventory F-1..F-4 executes with this tag (the
OB flip; the reply example + p1 bullet; the guards word; the
stale test-arity g7d citation re-homed - the suite retired at the
exact boundary and the citation outlived it).

The oracle: 6 rows, each red against the SHIPPED src for its own
stated reason (no stub was owed - the type surface was complete
before the increment, which is VIII.1's finding executed), each
with its designed kill named (M-r1..M-r7), kills MEASURED at the
close matrix against the committed baseline (the dyadic
incident's law; sibling shadowing per the dyadic R7 pre-ruling).
SAT 6/6 against the overlay staged verbatim as
implementation-draft.diff - the implementation phase re-lands the
prophecy under the builder's key, then the close matrix, then the
author's readout-freeze-r1 over the close-out ends the increment.
The docket proceeds in the ratified order: the OB-19 heir next
(p_codes is the instrument its demand gate reads), then #19 as
1a-or-doctrine with JP2-d6's pwLadderCap return row on its
opening checklist."
git tag -v readout-freeze-r0

echo "SEALED at readout-freeze-r0 (two-phase: the implementation opens on the builder's key)"
echo "push on your word: git push origin master readout-freeze-r0"
