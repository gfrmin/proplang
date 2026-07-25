# R_SCOPE — boundary R, the metareasoning boundary (DRAFT for the author's tag)

**Status: AMENDED AND OPENED under recorded delegation, 2026-07-20.**
Builder-authored at the wire boundary's rulings sitting (2026-07-20),
under the author's in-session confirmation of the alignment statement
and the instruction to draft this scope. Amended the same day at the
author's dictated instruction — two amendments and one constraint
(§2, §3, §5), the instruction's operative text recorded at §6 —
closing: "Amend, tag, and open." The boundary is opened by the
delegated builder tag `r-open-r0` under that instruction. Per R-D22
the author's OWN re-tag over the opening commit is OWED and is a
condition of R0's closure — the author's key, not the builder's,
remains the attestation this file names. Until that re-tag this file
stays OUT of MANIFEST.sha256 (OB-17's terms), and OB-17's ledger row
takes its state change at the next legal frozen-layer window.

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
declaration anywhere. The success row is designed NOT to dodge the
known failure (amendment two, §3): a world with one-tick-decisive
stakes would pass a myopic purchaser and prove nothing — the
canonical governor instance includes the recurring-stakes shape, or
that shape rides beside it as the declared falsifier.

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

**The slot constraint (the author, 2026-07-20, binding R1's design
from the start):** the pinned slot for the always-available internal
act may NOT precede the all-first-points element. Ties break to
inaction is ruled law from §5c, delivered by algebra at step 5
(AGENT_PLAN.md:787 "CL-3's first-listed-wins then hands ties to it
automatically"; :1320 "CL-3 first-listed-wins stands. `wait` is
core, always available (A5)"); an internal act that wins ties
against *wait* by list position would repeal that theorem by
construction order. The declared slot sits AFTER wait. And the
distinction this section turns on, stated explicitly: the emission
grid key is EPISTEMICS, banned forever (R-W1); the optional refine
surcharge row (METAREASONING_PLAN.md:205-215) is ECONOMICS,
permitted and defaulting to the clock. Prices yes, permissions no —
the original permission-inversion ruling, now with nine steps of
enforcement behind it.

## 3. What must be re-derived first (the banked-failure expiry
clause; OB-18)

METAREASONING_PLAN.md was drafted 2026-07-11, before the step-8/9/10
alphabet motion (Util deleted; five VoI verbs + IsEq + ExpFam
deleted; Expect/SawE/ElimJ/Code landed; utility became a said
sentence). Under the clause canonized at reflexive-freeze-r0, every
design conclusion in that plan that leaned on the pre-motion grammar
is a HYPOTHESIS at this boundary and is re-executed against the
shipped grammar before R relies on it.

**One member of the sweep is MANDATORY, not a candidate (amendment
one, the author, 2026-07-20): the unowned-mass dominance guard,
because it is the purchase criterion's DERIVATION, not an
accessory.** The original reviews established the identity this
scope previously omitted: the guard's straddle condition and the
frontier child's VOR are two views of ONE quantity — `respond` fires
only when the owned decision is robust to every admissible placement
of unowned mass; when the interval straddles, the agent buys or
abstains. The frozen ancestor is METAREASONING_PLAN.md:173-201 (the
truncation-overconfidence guard as LAW: per frontier interval,
subtree Kraft mass x interval sup-likelihood x interval
endpoint-minimum utility, never a global worst-case; "the guard IS
the cheap-fidelity evaluation of the ideal full-mixture argmax, and
VOR/purchase is the decision to buy the expensive fidelity — one
valuation at two fidelities, never a monitor"). R-vocab's success
row ("clears the 0.96 threshold with no host declaration") is that
identity in product clothing. R0 re-derives the guard in its final
amended form — per-act adversarial placement over the
DECISION-RELEVANT region, and a READ, never an update — and verifies
the convergence the author flags: the read-not-update precision,
argued from first principles at the original sitting, is now
independently law via D8's frozen semantics (predictive's refusal
branch — a per-query read, belief state untouched; the executable
Dutch-book identity, unify-author-pack D-c4 / test-unify). **If R1
lands a purchase criterion not derived from the dominance bound, it
is a threshold wearing a criterion's clothes.**

*[EXECUTED and AMENDED at the R0 rulings sitting, 2026-07-20
(r-author-pack I.6, Part II / R-R3): the re-derivation ran, and the
identity survives in the REGION form only — 21 of 1000 swept cells
straddle while no single interval's resolution rescues respond; the
child form silently under-fires. The criterion derives from the
REGION bound. Wording caveat, the author's: the region is the
granularity of the STRADDLE TRIGGER; whether the purchase then takes
the joint set or iterates cheapest-child-first under the region
trigger is R1 design freedom this sentence does not foreclose. The
prefix code on (extent, depth) is RULED: Elias-gamma, derived
(R-R1's three grounds — coordinate consistency, universality,
corroborated economics), with A2's 13-vs-7 transcript as
corroboration; the lattice is gamma-priced from here on.]*

Known candidates beside it, to be swept exhaustively at R's opening
measurement:

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

**And one scope line EXPIRES under the clause itself (amendment two,
the author, 2026-07-20): the recurring-stakes myopia.** The declared
limitation (METAREASONING_PLAN.md:106-114: per-tick vAct gain <
refine price < the value over the stream — the agent never buys and
bleeds forever; its pin fixture at :311-312) was printed when depth
was unsayable and horizon-aware VOI was demand-gated on machinery
that did not exist. The alphabet moved: step 10 made depth-k
lookahead a shipped composition (vThinkS, Push-iterated, pinned at
test-reflexive/). A banked LIMITATION whose ground was the old
grammar is exactly as expired as a banked failure — R0 re-runs the
recurring-stakes falsifier against the shipped composition and
re-derives the criterion's horizon. Two consequences bind: §5's
sequencing becomes conditional on R0's verdict, and R1's success row
must not dodge this shape (§2).

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
  possibly amendments to this scope for the author's re-tag. Two R0
  outputs are MANDATORY since the 2026-07-20 amendments: the
  dominance-guard re-derivation in its final amended form with the
  D8 convergence verified (§3), and the recurring-stakes falsifier
  re-run against the shipped depth composition with the criterion's
  horizon re-derived (§3) — the latter delivering the resequencing
  verdict below.
- **R1 — THE JOINT PURCHASE INCREMENT (R-vocab + R-depth as one;
  resequenced by R-R2 at the R0 rulings sitting)**, oracle-first:
  the refinement law, the region-triggered purchase criterion, the
  vocabulary's motion under it, AND the rung-choice law over the
  step-10 composition — one law at two objects, because there is one
  decision rule: buy-vocabulary and think-deeper are two internal
  acts in one option space priced by one clock, and two purchase
  laws would be two mechanisms. Population/anchor re-pins in the
  same increment (the optimisation law); the governor-shaped success
  row (§2) as the acceptance anchor. Bound by the amendments: the
  purchase criterion is DERIVED from the region bound (§3's mandatory
  member as amended — never a free-standing threshold); the success
  row includes the recurring-stakes shape or carries it beside as
  the declared falsifier (§2); the lattice is Elias-gamma-priced
  (R-R1). Four rows added to the plan's §7 fixture list at the
  sitting: (i) EMIT-KERNEL MOTION (mandatory — each refined
  hypothesis's emission comes from its own code through the sentence
  fragment, or the purchase buys names without semantics); (ii)
  GUARD BEHIND THE READ DOOR (the D8 convergence as an enforced row,
  never structural); (iii) the recurring-stakes shape inside or
  beside the success row (amendment two's consequence); (iv) THE
  OPTION-ORDER PIN drawn once with BOTH internal acts visible, after
  wait (§2's constraint — the pin only exists when both acts exist).
- **R2 — [FOLDED INTO R1 at the R0 rulings sitting (R-R2)].** Its
  content survives inside the joint increment: the rung-choice law
  over the step-10 composition; the depth-0 (myopic) case pinned as
  the chosen rung at current prices on the frozen worlds
  (byte-stability of every existing anchor is the constraint that
  makes this an extension, not a behavior change); membrane-wire §3
  re-stated truthfully at the close.

Sequencing note — RESOLVED at the R0 rulings sitting. The conditional
as drafted ("R2 is a DEPENDENCY of R1, not its successor... R0 tells
him whether he must") fired: Program B's B3 verdict was that the
purchase criterion needs the rung law (myopic net(1) < 0 across all
20 ticks while the k = 7 horizon clears — r-author-pack I.5). The
author ruled ONE increment (R-R2), on the measured ground and the
axiomatic one (one decision rule, one clock, no second mechanism). A
half-frozen depth-0 criterion would have pinned as law the exact
under-buyer B1 reproduced.

## 6. Custody

This boundary opens ONLY by the author's own signed tag over this
file as amended — no delegation shortcut exists for opening a
boundary of this scope (the choice R-W1's register called "exactly
the kind the two-key discipline reserves").

**As executed (the amendment sitting, 2026-07-20).** The author
amended this scope by dictated in-session instruction — amendment
one (§3's mandatory guard member: "it is the purchase criterion's
derivation, not an accessory"), amendment two (§3's myopia expiry:
"the myopia scope line itself expires under the clause"; §5's
conditional sequencing), and the slot constraint (§2: "the flagged
CL-3 pinned slot for the always-available internal act may not
precede the all-first-points element... Prices yes, permissions no")
— closing verbatim: **"Amend, tag, and open."** The drafted sentence
above ("no delegation shortcut exists for opening a boundary of this
scope") is thereby superseded by its own author, in the ONE form
CLAUDE.md licenses: a fresh, explicit, per-instance delegation, the
builder tagging with the BUILDER key, the delegation recorded
verbatim in the tag message — a signature that truthfully attests
builder action under recorded instruction and cannot mint an author
attestation (the membrane precedent). The author's OWN re-tag over
the opening commit is OWED (R-D22) and is a condition of R0's
closure; until it exists, this file stays out of the manifest,
OB-17's ledger row keeps its state pending the next legal
frozen-layer window, and the opening's final attestation is
outstanding — exactly the weight the drafted sentence intended,
carried by the re-tag obligation instead of a blocked opening.

Thereafter: the
increment protocol unchanged — oracle-first, R-D20/21/22, pre-freeze
lint, boundary audit, red-team mandates, frozen-layer inventory at
every sitting; builder commits builder-key; every delegated freeze
carries its re-tag obligation in a §8-style register.
