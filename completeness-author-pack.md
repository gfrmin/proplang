# The completeness suite boundary — author pack (opening)

Builder-prepared, 2026-07-27. THE OPENING RECORD (mandate-2's
demand — the authority recorded in-tree, not in a transcript): the
author wrote, in-session, 2026-07-27, immediately after the
trampoline-freeze-r1 push: "open the completeness suite boundary".
The step is the destination map's step 4 (EXACT_PLAN 13.0): the
suite proves sufficiency ONCE, against the final surface — and the
surface became final at trampoline-freeze-r1 (author key over
627bb12, verified), which is why this boundary could not open
earlier (certifying before the trampoline would have meant
certifying twice). The same tag hands this boundary its two
dockets by name: F5's forgone term "DOCKETED to the completeness
suite, not ruled here", and R9's think/refine unification as the
suite's standing question. Per the V-cancellation lesson, the
opening becomes a CUSTODY fact only at the freeze tag; until then
this record and the builder commits carry it.

The charter is EXACT_PLAN section 14, drafted at this opening
(EXACT_PLAN is builder-unfrozen; the charter freezes nothing).
Base: 627bb12; manifest 71/71 verified at the opening and again
after the frozen-tool incident below. NOTHING FROZEN HAS BEEN
TOUCHED: one drafted repair to a frozen tool was proven, REVERTED,
and staged for the sitting (Part II).

---

## Part I — deliverables at this opening (builder commits, builder key)

| artifact | state |
|---|---|
| EXACT_PLAN.md section 14 | the charter: the claim (14.0), executed interpolation defined (14.1), the decision-law rows (14.2), OB-20/21 homed (14.3), surface-final motions first (14.4), the non-scope (14.5), the oracle shape (14.6), the register CR1-CR7 (14.7) |
| completeness-author-pack.md | this pack: opening record, standing events, register grounds |
| test-completeness/freeze/boundary-audit-repair.patch | the two frozen-tool repairs, staged (Part II; CR7); `git apply --check` clean at this commit |
| test-completeness/opening/boundary-audit-repaired-run.txt | the repaired audit's full transcript (throwaway-prototype run, R-D21 form) |

The oracle directory test-completeness/ is claimed here; the oracle
itself (the family generator, the reference extension, the law
rows, the pool drafts) is the next phase's work, oracle-first,
runtime-red, and nothing in it binds until the author's freeze.

## Part II — the boundary-opening standing events

**The boundary audit** (tools/boundary-audit.sh at the base
627bb12): **M5=17, H=8, OB=1, BF=0** — with the BF row reporting
the alphabet as last moved at f989c42 (2026-07-08).

Two findings against the instrument itself, both repaired in a
drafted patch, both two-sided:

1. **The BF row under-reads alphabet motion.** Its `-S` pickaxe
   fires only when the search string's OCCURRENCE COUNT changes, so
   the in-place value edit `ProdTable 20 1` -> `ProdTable 9 1` at
   the exact re-founding was invisible: the row reported the
   alphabet as last moving 2026-07-08 (f989c42) when the true last
   motion is c2ca82c, 2026-07-25 — the 9+1 surface itself. The
   date is what the human sweep triages banked failures against,
   so the under-read is load-bearing. Repair: `-S` -> `-G` (fires
   on any diff line matching the regex). Two-sided demonstration:
   old output f989c42/2026-07-08, repaired output
   c2ca82c/2026-07-25T18:44:21+03:00, both recorded here.
2. **The M5 row's definition-site heuristic never counted mutant
   patch files** (the trampoline Part II triage named this upgrade;
   at this base the noise grew to 17 flags — every one a mutant ID
   whose definition site is its audit/mutants/*.patch file). Repair:
   an `audit/mutants/<ID>-*.patch` file counts as a definition
   site, and a DELETED patch with its deletion in git history also
   counts (M19/M20/M22/M27, deleted at the trampoline r1 sitting,
   keep their historical pack citations legal).

**The frozen-tool incident (the stop-and-revert).** The repairs
were first applied directly to tools/boundary-audit.sh on the
reading — recorded at the trampoline opening (Part II) — that
"tools are unfrozen". That reading is FALSE: tools/boundary-audit.sh
is MANIFEST ROW 28 and tools/prefreeze-lint.sh row 27, both frozen
since the step-6 sitting — 06a8424, 2026-07-16, where they entered
as rows 75-76 of THAT ERA's 76-row manifest (the sitting's "71->76"
extension; the coincidence with today's 71-row post-re-founding
manifest is accidental, verified at the review's flag) — and
continuously covered since: the -S query over MANIFEST.sha256 shows
exactly one occurrence-count change per tool, the addition.
The edit was REVERTED (`git restore`; manifest re-verified 71/71),
the diff staged as test-completeness/freeze/boundary-audit-repair.patch
for the sitting under the author's key (register CR7), and the
repaired audit was re-run as a THROWAWAY-PROTOTYPE measurement
(R-D21's form — the transcript rides this pack; the in-tree file is
byte-identical to its manifest row). The trampoline pack's "tools
are unfrozen" line is hereby recorded as falsified prose in an
unfrozen historical pack — corrected here, the closed record left
untouched (the frozen-layer inventory's record-class discipline).

**The repaired audit** (throwaway run at the base): **M5=0, H=8,
OB=1, BF=0**, alphabet last moved c2ca82c (2026-07-25). Triage:

- **H-row, 8 flags, out of scope, carried**: `enumerateSentencesIn`,
  `observe_batch`, `observe_counts`, `residual_mean`, `residuals`,
  `sensitivity` live in membrane-wire's governor-features face —
  demonstration-tier vocabulary (destination step 5); `gauss` and
  `ticks_spent_thinking` are the founding interface.md's dormant
  spec sentences (unchanged triage since the trampoline opening).
- **OB-row, 1 flag, THIS BOUNDARY'S TRIGGER**: OB-20/21
  (OBLIGATIONS.md lines 48-49) — the reasoner and enumeration
  mutant pools, SCHEDULED at x5-sitting-r0 with named discharge
  events and no named home, now flagged against the closed x5
  boundary. Charter 14.3 homes their discharge here (register CR5).
- **BF-row, 0 flags at the true date**: the alphabet last moved at
  the exact re-founding (c2ca82c, 2026-07-25); the standing banks
  are inventoried below and none is relied on without a transcript
  at or after that motion.

**The banked-failure inventory** (the step-10 clause, applied at
the opening):

| bank | status at this opening |
|---|---|
| GetV (OB-16) | re-executed at exact-freeze-r1 against the 9/1 motion — the wall stands, stronger; condition reset; NO alphabet motion since c2ca82c, so the bank is current |
| GroundC deadlock (13.3's banked observation) | re-executed at the dyadic close on shipped src (wait 60/0/0 both deep cells); relied on by trampoline R1 with that transcript; current |
| the feats-aware kernel (trampoline R8) | demand-gated, NOT relied on by this charter |
| CatBody / MulBank (the §5 Mul seat) | executed AT the exact boundary against the surface it certified; no motion since; current |

Any bank the oracle phase later leans on is re-checked at that
reliance — the clause binds per-reliance, not per-opening.

**The frozen-layer inventory** (prose this boundary's design
touches; repairs execute only at the sitting, under the key):

1. tools/boundary-audit.sh (manifest row 28) — the staged repair
   patch (CR7).
2. OBLIGATIONS.md rows OB-20/21 (manifest row 31) — gain their
   discharge citations at the freeze if CR5 rules discharge here.
3. membrane-wire.md (manifest row 25) — if CR1 rules unify, the
   world-declaration face gains the joint record's form; the
   install is staged during the oracle phase, executed at the
   freeze (the membrane-wire-install precedent, third instance).
4. EXACT_PLAN 13.2's amended R9 phrase — CONSUMED by this charter
   (the standing question becomes CR1); no repair, the citation is
   the closure.
5. test-writeup/check.sh's stanza-count note — dated red-by-design
   instrument, recorded, untouched; test-completeness's stanza will
   move the live count when it lands (the standing observation
   already prints both sides).

**The opening checklist** (obligations arriving at this boundary by
prior rulings): F5's deletion docket (the r1 tag), R9's standing
question (register R9 as ruled at the trampoline freeze), OB-20/21
(the OB-row flag). NO RETIRE-UNTIL-N return rows are scheduled to
this boundary (the category's instances — g4Self at step 6, the
host-less window at step 7 — are all discharged at max span).

## Part III — the register's grounds (CR1-CR7; drafted defaults in charter 14.7)

- **CR1 (R9's unification — default UNIFY HERE).** The gap is a
  TYPE gap, measured: DelibWorld {dwPrice, dwBatch} and
  PurchaseWorld {pwStakes, pwLadderCap, pwRefine} share no joint
  form, so no declared world can put think and refine on one tick's
  menu, and the one-chooser law is pinned on two disjoint faces
  (g3, g5). Unification is a joint world record plus one chooseKS
  sentence with both internal rows — zero alphabet motion. The
  oracle phase brings the evidence: a joint-world prototype
  transcript (R-D21) showing both rows priced on one menu, the
  incumbent tie-law intact (F4's liveness clause binds the joint
  order too), and the WIRE FACE PINNED — the prototype enumerates
  exactly which fields the joint declaration adds to the wire, so
  the sitting rules on a measured surface, not on 14.5's carve-out
  clause (the review of 2026-07-27). Certify-once is the argument
  for HERE; the alternative re-opens certification at the
  follow-on. Order per 14.4 as amended: CR2 executes FIRST, so the
  price delta lands once, against a known surface.
- **CR2 (F5's deletion — default DELETE).** The argument is
  pre-written (trampoline pack XIII.3) and the proof executed
  (M34: extensionally identical to shipped src). The oracle phase
  brings the price delta computed from the frozen pricing artifact
  (never a parallel derivation) and the pre/post extensional pin.
- **CR3 (the family's axes).** The generator walks declared axes
  only; the axis table and density arrive with the oracle draft;
  the residual's printed form is a suite output, not prose.
- **CR4 (the decision-law rows).** VoI >= 0, affine invariance,
  admissibility — the 2026-07-16 brief-adherence gap. Each lands
  only with a kill (forward half, per-row per F6).
- **CR5 (OB-20/21 — default DISCHARGE HERE).** The OB-row flag is
  the trigger; the pools' operator lists arrive with the oracle
  draft; verdicts stay sitting-triage, never auto-deletions.
- **CR6 (the claim's prose form).** Drafted with the oracle:
  declared class, derived family, exact reference equality,
  printed residual — what "in general" honestly says.
- **CR7 (the staged tool repairs — default EXECUTE AT THE FREEZE).**
  The patch is in-tree, two-sided demonstrations recorded above;
  declining costs nothing but keeps the false alphabet date in the
  BF row's output.

## Part IV — the evidence programs (R-D21 throwaways, executed 2026-07-27; transcripts in test-completeness/opening/, prototypes discarded)

**EV-CR2 — the F5 price delta (transcript:
test-completeness/opening/f5-price-delta-transcript.txt).**
Pre-stated criterion: deleting the forgone term moves the shipped
policy sentence's weight by exactly 9^7 * 3^2 = 3^16 (seven removed
nodes at 1/9 each, two of them scope-3 Vars) — computed from the
FROZEN pricing artifact (Syntax.weightIn), the row construction a
COPY of Purchase.hs:115-139 with provenance. RESULT: holds at
exact == — ratio 43046721 % 1, i.e. the term charges 16*log2(3)
~ 25.36 bits for an unutterable alternative. The single-mention
structure of the folded sentence is confirmed by the ratio itself
(a k-fold duplication would give 3^16k). CR2's adjudication now has
its number beside XIII.3's argument and M34's identity.

**EV-CR1 — the joint-world program (transcript:
test-completeness/opening/joint-world-run.txt).** Pre-stated
criteria P1-P4 in the program header; row bodies COPIES with
provenance (Membrane.hs:361-365, Purchase.hs:115-172, reindexed
into the joint env); fixtures IMPORTED from the frozen test modules
(egSpace/emitK/buffer36 — the probe-reads-declared-data law);
economics from the d6.1 refine-firing cell (Dyadic.hs:214-218).

- **P1 (type) PASSES.** The joint record — the pure UNION of
  DelibWorld and PurchaseWorld's fields — plus ONE chooseKS
  sentence over the six-row menu (wait head, L/R/respond
  externals, think/refine LAST) COMPILES. The R9 type gap closes
  with zero alphabet motion.
- **P4 (wire) PASSES.** The joint declaration's wire face is
  enumerated: price, batch | stakes, refine_mint, ladder_cap — NO
  new field kind. 14.5's carve-out is now a measured surface.
- **P3 (think liveness) PASSES, and the F4 law GENERALIZES.** The
  think bound holds in every terminating cell, and the tie fires at
  BOTH exhaustion faces: buffer exhaustion (price 0, buffer36: 12 =
  36/3 thinks then tie) and INFORMATION exhaustion (d6.1's decisive
  stream: tv saturates to the best act's value after 3 folds, think
  ties, the incumbent ends the episode — the lazy genius stopping
  because further evidence cannot flip the act).
- **P2 (both internals fire) FAILS IN EVERY NAIVE CELL — and the
  failure LOCALIZES.** Three knob families executed and refuted:
  (i) the evidence clock is not the blocker — batch 1 walks the
  purchase loop's exact count-path and refine still never fires;
  (ii) the stream is not the blocker — on d6.1's own stream the
  gain-positive window EXISTS (counts (2,0): bestGain 1/189,
  refineValue +131/3780, the only positive point measured) but lies
  beyond the first decisive tick; (iii) stakes scaling is not the
  escape — refine's window and respond's guard row scale TOGETHER
  ((10,-1) crowns respond at tick 0; (10,-10) and (100,-100) end
  at final=R before the window). The blocker is the EPISODE SHAPE:
  the decide-once loop (t2's) ends at the first decisive external,
  and the refine window sits past it, structurally.
- **The predicted divergence CONFIRMED.** The purchase-habitat menu
  (wait/respond/think/refine — the t2 externals absent) was
  PREDICTED IN ADVANCE to diverge at price 0: think's preposterior
  base (actValueS) evaluates L/R, acts NOT on that menu, so the F4
  tie can never fire. Measured: 500 thinks, DRIVER-CAP, exactly as
  predicted. THE TERMINATION LAW IS CONDITIONAL: think terminates
  only when the menu CONTAINS the acts its value function
  evaluates.

**The finding, named (CR1a).** R9's unification has NO coherent
naive form: the record merge type-checks (P1) but the naive union
either starves refine (decide-once) or diverges (habitat menus).
The unification's real object is THE JOINT PREPOSTERIOR — think's
value must be the preposterior of the MENU'S OWN best row, i.e. the
policy sentence evaluated preposteriorly over itself (step 10's
reflexive composition, now demanded by LIVENESS, not aspiration).
This CONVERGES with the banked GroundC remedy (a) (EXACT_PLAN 13.3:
"let the rung ladder see multi-step purchase value") — the joint
preposterior is exactly that remedy, generalized to the whole menu.
CR1's register consequence: the UNIFY-HERE default now carries this
measured work order (a joint preposterior increment, not a record
merge); the honest smaller alternative remains certify-as-is with
the unification a named follow-on. The sitting chooses with the
size known.

**EV-CR3 — the family generator's axis walk (transcript:
test-completeness/opening/family-walk-transcript.txt).** The family
DERIVES from four declared axis lists (3 theta grids x 4 prices x
3 batches x 2 streams = 72 cells; the walk is the product, never
hand-enumeration) and every cell is checked against an INDEPENDENT
reference calculator — plain (theta, weight) lists, no engine call
on the reference side, the frozen choice/preposterior formulas
quoted with provenance (Membrane.hs:361-373). Pre-stated criteria,
all met on the first run:

- **G1 PASSES**: the four t2 anchor cells fall OUT OF THE WALK and
  equal Anchors.t2RowsX exactly — the acceptance anchors are now
  four MEMBERS of a 72-cell family (charter 14.1's sentence,
  demonstrated).
- **G2 PASSES**: 72/72 cells agree shipped-vs-reference at exact
  transcript ==. Sixty-eight cells are NEW evidence — interpolation
  the four anchors never covered.
- **G3**: the residual printed — purchase/refine worlds (await
  CR1), K>2 arities and the t1/t3 faces, other stream
  lengths/compositions, the decision-law rows.

**EV-CR4 — the decision laws, measured before pinned (transcript:
test-completeness/opening/decision-laws-transcript.txt).** The
2026-07-16 gap's rows, run over the EV-CR3 family:

- **V1 (VoI >= 0) PASSES**: 227 decision points across 72 cells,
  ZERO violations; the minimum gap is EXACTLY 0 — the saturation
  ties (information exhaustion) appearing as exact zeros, the F4
  generalization's arithmetic face.
- **V2 (scaling invariance) PASSES**: the d6.1 purchase transcript
  is act-for-act invariant under joint positive scaling of the
  declared economics (stakes AND mint, a in {2, 7, 1/3}: 3/3). The
  honest scope is SCALING: a shift b breaks the menu's declared
  zero row (wait), so the b-half of affine invariance is a
  menu-convention question FOR THE SITTING, not a law violation —
  CR4's register entry carries it.
- **V3 (admissibility)**: SUBSUMED at this surface — EV-CR3's
  equality rows already check every chosen act against the
  reference's exact Bayes act; Wald's face gains independent
  content only with richer menus (the oracle's business).

**The CR5 pool drafts (OB-20/21; operator lists DECLARED here, the
pools land with the oracle increment and their matrix run, cut
against the committed baseline — the dyadic incident's law).**

The reasoner pool (OB-20; the target is the lawful + independence
stanzas' 14 unreached rows; lineage: the engine-level unnormalized
family M2/M11/M12/M13, now cut INSIDE Belief.hs):

| operator | the cut | reaches |
|---|---|---|
| MR1 | fromWeights skips normalization | L1/L2, the Kraft rows |
| MR2 | fromWeights accepts negative weight | the refusal law |
| MR3 | condK skips renormalization | conditioning laws |
| MR4 | predictMass unnormalized at source | marginal-mass rows |
| MR5 | point spreads (point = uniform) | the ruling-#7 definition rows |
| MR6 | expect ignores weights (plain average) | expectation laws |
| MR7 | points/weights views misaligned | the CL-1 view rows |

The enumeration pool (OB-21; gating/combinatorics over
Enumerate.hs; the t2-price-path gap is the first named candidate,
per the ledger):

| operator | the cut | reaches |
|---|---|---|
| ME1 | frontier off-by-one | the count pins |
| ME2 | membership widened (a filter dropped) | membership rows |
| ME3 | membership narrowed (a legal production filtered) | counts, the deletion table |
| ME4 | fragment-table rows swapped | the fragment-derivation pin |
| ME5 | a charge site skipped | the pricing rows (the t2-price-path gap) |
| ME6 | one sentence enumerated twice | the Kraft-deficiency row |

Verdicts stay pool-relative and sitting-triaged; a pool is grown,
never assumed.

## Part V — what happens next (the oracle phase; nothing binds until the key)

1. Phase-A evidence is COMPLETE: EV-CR1/CR2/CR3/CR4 executed
   (Part IV), the CR5 operator lists drafted above. What remains
   before the freeze is ORACLE work, and its shape FORKS on CR1:
   the family rows, law rows, F5 rows, and pools are
   rulings-independent in form, but the certified surface differs
   by an entire joint-preposterior implementation depending on
   CR1's ruling — so the cheap moment for the author's direction
   on CR1 (and the docket order's CR2) is BEFORE the oracle is
   drafted, not at the freeze.
2. The oracle: test-completeness/ as the ninth stanza — family
   rows, law rows, unification rows, F5 rows, pool matrix — written
   runtime-red against type-surface stubs, SAT in overlay form
   flag-faithful, E-gate allowlists against the overlay, every red
   row with its satisfiability transcript, every new row with its
   kill.
3. The six red-team mandates, fresh-context reviewers, one each.
4. The pre-freeze lint; the freeze kit (staged installs: the
   OBLIGATIONS discharge rows, the membrane-wire joint-world form
   if CR1, the tool repairs); the author's sitting rules CR1-CR7;
   the freeze extends and re-signs the manifest; implementation
   only after the tag.
