#!/usr/bin/env bash
# readout sitting, script 3/3 — THE AUTHOR'S ATTESTATION, nothing
# else. Run from the author's shell: the repo's local user.signingkey
# is the author's own, so plain -S/-s here IS the author's key.
# On thinkpad that key is ~/.ssh/proplang-author-thinkpad
# (SHA256:vxt+FccnN/4Z/6kmg0v/rvNWe1qK4jtVTzGsM8ogeX0), the author
# identity's SECOND key, registered in allowed_signers at 8b85edb
# because steel's key is not on this machine and steel is unreachable.
# Read that commit before reading this signature: it records why a
# per-shell author key is key management rather than a relaxation of
# the custody rule, and why the delegation path was NOT available
# (it needs the builder key, which is on neither machine).
# The tag message carries the register as drafted — running it intact
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
git commit -S -m "readout freeze: the K-ary readout sealed (19 rows, live green at the sitting under the stanza's dependency closure; the M64-M72 matrix, three sole killers against the whole corpus and M72 unreachable by every STANDING row, every kill readout-unique; F10's menu-independence red CONSTRUCTED rather than owed; stanza spliced; membrane-wire, OBLIGATIONS/FL-1 and the R-RED id patches applied; manifest extended)"
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

F10, THE MENU-INDEPENDENCE ROW, IS DISCHARGED - CONSTRUCTED, NOT
OWED. The opening carried it to this sitting as an owed red, which
under R-RED is not an honest decline while the red is constructible.
It is built: r8a-r8d, on a world whose window was MEASURED first.
Three measurements shaped it. In a GUARD-FREE world the predictive
does not move with the act at all, so the standing world could not
have hosted the row on any menu or utility - guardFamilyJ is the only
production that reads a namespace name. A menu-less evidence tick is
REFUSED under a guard, so the fold has to land at an act and r8a PINS
which one instead of assuming it - the reference still never
round-trips the engine. And at the prior the two acts agree EXACTLY,
because the guard family carries every ordered (a,b) pair at equal
charge; the window opens only under evidence, and the declared
one-tick stream sits inside it with a separation of 1.48e-3 on p0.
The utility is act-BLIND, so the row does not lean on OB-24's
challenger-assignment convention and survives its re-ruling. M72 (the
vector computed at the MENU HEAD) is the designed killer and dies to
r8c/r8d alone; on every single-point-menu world it is byte-identical
to the shipped host, which is precisely why no standing mutant could
reach this claim.

ONE RULING SOUGHT, named rather than absorbed. LINE-NUMBER
PROVENANCE IN PRE-IMPLEMENTATION ORACLES: an oracle frozen before the
implementation it prophesies has stale absolute lines the moment that
implementation lands. This increment anchored its copy table to the
sealed tree AND named the bindings; the general rule is the author's.

THE PRE-TAG ADVERSARIAL READ (2026-08-01) found five more that would
have frozen, and they are listed because three of them are the same
shape the mandate round convicted. (a) The wire patch cited readout
r2b TWICE - once emphatically, 'a pin's subject here, never an
assumption' - as the pin for the HOST's carrier convention, which
this increment's OWN matrix had already falsified: r2b asserts over
the oracle's carrier and M71 leaves it green. (b) Readout.hs still
carried its opening DRAFT banner, 'THIS FILE IS THE ORACLE-PHASE
DRAFT AND HAS NOT BEEN EXECUTED', contradicting line 44 of its own
file and about to enter MANIFEST.sha256 saying so. (c) The red
partition named a row, r5d, that exists nowhere in the tree. (d)
1-verify's as-built-==-prophecy check was `diff ... && echo`, and
under set -e a failure on the left of && does not abort: a prophecy
MISMATCH would have printed its diff and fallen through to 'ALL
CHECKS PASSED' with exit 0. The rehearsal could not see it, because
the diff matched - a gate that could not fail, in the one check this
kit was built to add. (e) The pack's claim of 'zero non-L4 lint
failures' was false: L5 wants the four stanza flags recorded and the
pack recorded only -Werror, so three rows were failing, invisible
inside 26 L4 failures. That one would have stopped THIS SITTING at
2-freeze step 7 - after the splice, the three patches and the manifest
rewrite, with no undo script and the double-run guard refusing a
retry. All five repaired, the falsified words quoted. The full lint is
now 0 FAIL 0 WARN, L4 included.

ONE ITEM ROUTED FORWARD rather than repaired here: Host.hs:387's
comment calls the no-utility branch 'wait', though that branch is
Left - the external arm - and the legend three lines above defines
Left as an external assignment firing. The pack and this increment's
own charter inherited the error. The line predates this increment
(it is bd0d70c's text), so editing it would break the
as-built-==-prophecy identity for a comment; it enters the wire
docket's next frozen-layer inventory instead.

THIS TAG IS SIGNED FROM THINKPAD, not steel, and says so rather than
leaving a future reader to reconstruct it from a fingerprint diff. The
author identity gained a SECOND key at 8b85edb - one per shell,
ed25519, dedicated to signing and not the machine's general auth key -
because steel held the identity's ONLY key and is unreachable. The
protocol asks the author to countersign 'from their own shell';
thinkpad is that shell, and a key is the identity's instrument in a
shell rather than the identity itself. The delegation path was not
available and was not used: it requires the BUILDER key, which is on
neither machine, and a builder signature cannot mint an author
attestation in any case. All 26 prior tags were re-verified after the
custody edit - 26 verified, 0 failed - each still checked against the
key that actually signed it. The independent reason to do this at all:
a single-key attestation identity is a single point of failure, and
until 8b85edb a lost steel meant nothing could ever again be signed as
author. The round is recorded in full as pack Part VIII, including
what it does NOT exercise: `git tag -s` was never run before this
moment, and that round's commit signatures used this same AUTHOR key
because the builder key is on no machine - they are builder work,
their messages say so, and no commit signature in this increment
should be read as author review. This tag is.

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
