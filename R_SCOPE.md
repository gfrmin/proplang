# R_SCOPE — boundary R, the metareasoning boundary (DRAFT for the author's tag)

**Status: DRAFT.** Builder-authored at the wire boundary's rulings
sitting (2026-07-20), under the author's in-session confirmation of
the alignment statement and the instruction to draft this scope. It
is a PROPOSAL: R opens only when the author's own signed tag covers
this file, as amended by the author. Until that tag this file stays
OUT of MANIFEST.sha256 (OB-17) and binds nothing.

## 1. The ruling that orders this boundary

R-W1 and R-W2 (WIRE_PLAN.md §5, ruled 2026-07-20) are two corollaries
of one confirmed principle — the alignment statement, quoted in full
at WIRE_PLAN.md §5, whose operative invariant is:

> Everything between input and output — prior, hypothesis space,
> vocabulary fineness, belief representation, deliberation depth —
> is internal, governed by frozen law, purchased by the agent when
> stakes make it pay, and crosses the wire in NEITHER direction.
> The world declares economics (channels, options, stakes, prices);
> it never declares epistemics.

R is the boundary that makes the two outstanding "purchased" clauses
true of the shipped engine. Its constitutional basis is
METAREASONING_PLAN.md §0 (the author's directive of 2026-07-11):
the edge of the hypothesis space is not declared and not inferred —
it is purchased. That plan was drafted to ride on boundary V; V was
cancelled 2026-07-15 and the plan was orphaned, never refuted (the
RC-3/RC-4 spine, WIRE_PLAN.md §2). R re-opens it against the
post-step-10 language.

## 2. Deliverables — the two purchases

**R-vocab — purchased vocabulary refinement (discharges issue #4;
the R-W1 terminus).** The agent adjusts its own hypothesis-space
fineness — the theta vocabulary first — by maximizing expected
utility under prices. No emission grid key exists on the wire, ever
(the ruling); the hard-wired `thetaPoints` (Host.hs:261) is retired
from constant to *initial* vocabulary, refined when refinement pays.
The mechanism drafted at METAREASONING_PLAN §§3-4 (permanent counts,
the purchased edge, refinement always available) is the starting
text, subject to §3 below. Success is measurable in the terms that
created the demand: on a stream where the true parameter and the
stakes make sub-0.1-resolution near 1 decision-relevant (the
governor's 0.96 threshold is the canonical instance), the agent
buys the refinement and clears the threshold — with no host
declaration anywhere.

**R-depth — purchased deliberation depth (discharges OB-9; the R-W2
terminus).** Depth is a rung the same argmax chooses under prices,
the choice living INSIDE the language: deliberating one more rung is
an always-available internal act whose cost is endogenous — the
act-now EU forgone this tick, already computed by the same argmax
(the permission-inversion ruling, METAREASONING_PLAN :205-215,
applied to depth; no new number anywhere). Step 10's composition
(`vThinkS`, Push-iterated, priced per rung, pinned at
test-reflexive/) is the raw material: R-depth's work is the rung
CHOICE as law, not the rungs themselves — those exist. The myopic
case must emerge as the chosen rung where deeper thought does not
pay (CLAUDE.md porting order 4, reaffirmed at the ruling); the
shipped single-shot `choose` retires from branch to the depth-0
special case of the chooser.

Both purchases move ZERO alphabet productions on current evidence:
R-vocab is enumerator-data motion through the already-parameterized
`enumerateSentencesGrid` (0170a40, built for exactly this), and
R-depth is composition plus choice-law. Any step that finds itself
needing a production stops and reports — with one flagged
candidate: METAREASONING_PLAN §4's optional `{"internal": "refine"}`
surcharge row and the always-available internal act may want a
pinned slot in the option order (CL-3 ties break first-listed — an
ever-present internal act needs a DECLARED slot, ruled at R's
freeze, never an accident of construction order; the plan's own
words).

## 3. What must be re-derived first (the banked-failure expiry
clause; OB-18)

METAREASONING_PLAN.md was drafted 2026-07-11, before the step-8/9/10
alphabet motion (Util deleted; five VoI verbs + IsEq + ExpFam
deleted; Expect/SawE/ElimJ/Code landed; utility became a said
sentence). Under the clause canonized at reflexive-freeze-r0, every
design conclusion in that plan that leaned on the pre-motion grammar
is a HYPOTHESIS at this boundary and is re-executed against the
shipped grammar before R relies on it. Known candidates, to be swept
exhaustively at R's opening measurement:

- the failed-alternatives record (§0: declared-grid condemned,
  grid-as-hypothesis collapses) — the *arguments* look
  grammar-independent, but the collapse argument quantifies over
  "reparameterized prior" in the old prior's terms; re-state against
  the shipped 2^(-dl) source.
- the refinement act's interaction with the fold and CL-3 (the
  option-order pin) — drafted against the pre-step-5 menu shape.
- permanent counts vs the shipped walk/cond doors (Belief's public
  surface moved at steps 6-9).
- the migration-residue plan (§4: opt-in fallback, one-sided
  retirement license) — its byte-stability referent worlds are
  pre-demolition goldens; identify the surviving referents.
- the scope caveat "R buys PRECISION, not adaptation" (§0, author
  finding 2) — carried forward unchanged unless the author re-opens
  it; drift families stay demand-gated elsewhere.

## 4. Interim brackets (outcome iii, in force from the rulings
sitting, cited hereafter)

Until R closes: `thetaPoints` is the declared interim operating
point (ceiling 0.897, measured at W1); hosts binding at thresholds
above the ceiling (0.95/0.96/0.9942 registered) are OUT OF SCOPE;
the wire is myopic (membrane-wire §3 bracket as resolved
2026-07-20). These are statements of record, not defects — the
defect would be leaving them unstated (RC-1).

## 5. Proposed structure (each step the CLAUDE.md increment
protocol unchanged)

- **R0 — the re-derivation audit (the opening measurement).** §3
  executed as an evidence program: every banked conclusion
  re-stated and re-run against the shipped grammar, verdicts
  transcribed, before any R ruling freezes (the step-10 E-g1
  precedent — that audit is what stood between step 10 and a
  needless production). R0's output is the surviving design, and
  possibly amendments to this scope for the author's re-tag.
- **R1 — R-vocab**, oracle-first: the refinement law, the purchase
  criterion, the vocabulary's motion under it; population/anchor
  re-pins in the same increment (the optimisation law); the
  governor-shaped success row (§2) as the acceptance anchor.
- **R2 — R-depth**, oracle-first: the rung-choice law over the
  step-10 composition; the depth-0 (myopic) case pinned as the
  chosen rung at current prices on the frozen worlds (byte-stability
  of every existing anchor is the constraint that makes this an
  extension, not a behavior change); membrane-wire §3 re-stated
  truthfully at the close.

Sequencing note: R1 before R2 because R-vocab's purchase criterion
exercises the endogenous price machinery on the simpler object
(vocabulary, no lookahead), and R2 then reuses the proven price law.
The author may resequence.

## 6. Custody

This boundary opens ONLY by the author's own signed tag over this
file as amended — no delegation shortcut exists for opening a
boundary of this scope (the choice R-W1's register called "exactly
the kind the two-key discipline reserves"). Thereafter: the
increment protocol unchanged — oracle-first, R-D20/21/22, pre-freeze
lint, boundary audit, red-team mandates, frozen-layer inventory at
every sitting; builder commits builder-key; every delegated freeze
carries its re-tag obligation in a §8-style register.
