#!/usr/bin/env bash
# readout sitting, script 3/3 — THE AUTHOR'S ATTESTATION, nothing
# else. Run from the author's shell: the repo's local user.signingkey
# is the author's own, so plain -S/-s here IS the author's key. The
# tag message carries the register as drafted — running it intact
# accepts the drafted defaults; DECLINE BY EDITING this file (or a
# [RULING] line in 2-freeze.sh) BEFORE running 2-freeze.sh, whose
# manifest loop hashes the kit as run. The manifest re-check below
# ENFORCES that order: an edit made after 2-freeze.sh already hashed
# this file is refused here, before any key act.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK (the kit rows match the scripts as run)"

git add proplang.cabal MANIFEST.sha256 CLAUDE.md membrane-wire.md \
        OBLIGATIONS.md EXACT_PLAN.md readout-author-pack.md \
        src/PropLang/Host.hs test-readout audit/mutants
git commit -S -m "readout freeze: the K-ary readout sealed (15 rows, live green at the sitting under the stanza's dependency closure; the M64-M71 matrix with three sole killers and every kill readout-unique; stanza spliced; membrane-wire, OBLIGATIONS/FL-1 and the R-RED id patches applied; manifest extended)"
git tag -s readout-freeze-r0 -m "the K-ary readout's register ruled (#20, the wire docket's first
sitting; the authorization is battery-freeze-r0's own scheduling
line, '#20 first, the OB-19 heir second, #19 1a-or-doctrine third').

CW1 THE FULL VECTOR, not the three scalars: same O(K) cost, and the
filer's report-pricing use needs the EU of every menu row. CW2 the
tie rule is LOWEST INDEX, declared and pinned ON THE WIRE at the
tied prior by r4c - which kills its mutant ALONE. CW3 the readout is
APPENDED after entropy_bits and the v1 fields are byte-identical
beside it (r1a the attribution partition, r1b the ordering, M64 its
sole-killed mutant). CW4 the p1 rendering convention unchanged. CW5
NO readout on the internal-act reply - it names no act, so there is
no candidate to read out; honored structurally, not by a flag. CW6
the consumer discipline is quoted INTO membrane-wire's LIVE section-3
contract rather than inherited from the historical section 6.4. CW7
FL-1 repaired: OB-20/21 to DISCHARGED@battery-freeze-r0 with their
discharge events named - the battery's kit spliced its stanza and
extended the manifest but never patched the ledger, and the boundary
audit's OB-row caught it. CW8 the TWO-TAG form: an implementation
increment keeps the r1 catch-net.

THE MANDATE ROUND is this increment's largest finding and two of its
rows would have frozen. R-D23 was cited for a proposition it does not
contain - a genre label promoted into the name of a number, whose
0.9/(K-1) traces to a theta point-set DELETED from src at the exact
re-founding and measured two boundaries back. The Enumerate citation
was stale at five sites and was inside this increment's own wire
patch, one step from entering a manifest-frozen document. The
residual row misdeclared its own axis and printed the wrong number in
BOTH transcripts of the triptych - nothing asserts against a printed
string. All repaired in place with the falsified words quoted; the
field figures are relabelled pre-exact-tree probe observations,
pinned by nothing, and what carries the scheduling argument is the
STRUCTURE: the cap is real, it is a function of the declared
codebook, and it was unobservable on the wire until now.

TWO RULINGS SOUGHT AT THIS SITTING, both named rather than absorbed.
(1) THE MENU-INDEPENDENCE ROW IS OWED: the oracle's single-point menu
takes the wait branch, so no mutant computing the vector at a
different act is killable, and a red IS constructible (a two-point
menu plus a said@1 utility making the non-head row win). Under R-RED
that is not an honest decline. The frozen prose was re-cut to what
the rows support, so nothing false freezes either way. (2) LINE-NUMBER
PROVENANCE IN PRE-IMPLEMENTATION ORACLES: an oracle frozen before the
implementation it prophesies has stale absolute lines the moment that
implementation lands. This increment anchored its copy table to the
sealed tree AND named the bindings; the general rule is the author's.

R2B AND THE MATRIX'S SELF-CORRECTION, recorded because the lesson is
not local: the matrix runner's first cut grepped 'rror:', which
matches cabal's own 'Error:' line on every ordinary test failure, so
it reported all seven mutants as compile deaths and could not have
reported a kill at all - the mirror image of a green that cannot
fail. And M71, cut because r2b ran UNREACHED, left r2b green: r2b
asserts over the ORACLE's carrier, which no src mutant can reach. The
pool growth found a defect in the row it existed to serve."
echo
echo "SEALED. Verify: git tag -v readout-freeze-r0"
