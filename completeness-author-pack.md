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
2. The oracle: test-completeness/ as a new stanza — family
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

## Part VI — CR1/CR2 ruled in-session (the author, 2026-07-27; asked and answered in the working session; each ruling RATIFIES at its increment's freeze tag)

**CR1 — UNIFY HERE, SPLIT INCREMENTS.** The author's grounds,
recorded: EV-CR1's finding is what decides between one increment
and two, because it FALSIFIED THE PREMISE of the drafted default —
"unify here" was priced as a small motion (record merge, one
sentence, zero alphabet motion) and the measurement says the real
object is a REFLEXIVE PREPOSTERIOR: think's value defined over the
menu that contains think. That is a novel semantic composition, not
a type repair — it will generate its own findings (F4's liveness
clause must be RE-ARGUED on the reflexive object; the fixpoint's
termination is a fresh question, not an inherited one) and it
deserves its own oracle, its own mandate round, and its own freeze.
Folding it into the battery's freeze would mean drafting battery
rows against a surface still being designed — and a mid-battery
discovery about the reflexive object would force exactly the choice
the discipline exists to prevent: re-open the frozen oracle or
paper over. Split is 14.4's own logic applied at increment
granularity (surface-final motions first, THEN the battery), and
the precedent is the author's own: X.5 ruling 8 chose one boundary
at a time over a combined opening, and both incidents since (the
checkout wipe, the E4 gap) happened inside large increments —
smaller bets localize. Certify-as-is is CONVICTED by the charter's
contrapositive (it certifies twice by construction) and EV-CR1
removed its only defense: the unification is no longer speculative,
its object identified and measured. RECORDED IN THE RULING: the
joint-preposterior increment discharges the GroundC deadlock fork
THROUGH THE FRONT DOOR — the demand gate asked for a measurement,
EV-CR1 is that measurement, and R1's "documented myopic behavior"
gets its NAMED SUCCESSOR rather than a silent upgrade.

**CR2 — DELETE.** The author: the most pre-decided ruling of the
sequence — vacuity proven (M34's extensional identity, the
strongest form: the "changed" program is behavior-identical),
doctrine settled (a priced mention that buys nothing is the
prodTable conviction, ruled the same way at three prior
boundaries), price measured (3^16 in weight, ~25.36 bits charged to
every expansion for an alternative that cannot fire under the
shipped gate). Keep-with-record would be the first time the project
KNOWINGLY accepted the HEAD-debt shape after convicting it, with no
argument why 25 dead bits are acceptable here when six unutterable
alternatives were not at prodTable. Deferral buys nothing: every
fact this ruling needs is already executed. TWO STATEMENTS THE
RULING TEXT CARRIES (the author's words): (1) deletion re-prices
the purchase sentence downward, which SHIFTS PRIOR MASS toward it —
deleting dead weight is still PRIOR MOTION, which is exactly why it
is the author's signature and not cleanup; (2) the re-derivation
discipline — every price-mentioning row in the oracle re-derives
from the frozen pricing artifact POST-deletion, no row inherits a
pre-deletion number, and M34's identity pin guarantees the
EXTENSIONAL surface did not move while the price did. That pair —
EXTENSION FIXED, PRICE MOVED — is the deletion's complete
signature, and both halves are already in hand.

**The ruled sequence**: the F5-deletion increment (first, smallest
motion, pin in hand) -> the joint-preposterior increment -> the
certification battery, EACH UNDER ITS OWN TAG.

## Part VII — the F5-deletion increment, ORACLE PHASE DONE (builder, 2026-07-27; stopped for the key)

The ruled sequence's first increment, executed to the freeze door:

| artifact | state |
|---|---|
| src: purchaseRows exported (Purchase.hs) | the compile-enabling surface (the trampoline stub precedent): the standing sentence's rows extracted to a top-level export so the PRICE is readable through weightIn — no new type, zero behavior motion, dyadic + trampoline suites re-run GREEN |
| test-f5/F5.hs | the oracle: TWO rows, the ruling's two statements in the header |
| test-f5/stanza.cabal.draft | flag-faithful stanza (the warnings import: -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns) |
| test-f5/opening/red-run.txt | RED 2/2 on shipped src, attributably: f1 shows the SHIPPED price (1 % 35917...043), f2 shows ratio 1 % 1 |
| test-f5/opening/sat-run.txt | SAT 2/2 on the deletion overlay, the oracle's EXACT text, the stanza's exact flags incl. -Werror |
| test-f5/freeze/deletion.diff | the implementation (applies clean; matches the SAT overlay byte-for-byte) |
| test-f5/freeze/M41-forgone-restored.draft.patch | the forward half's kill draft |
| test-f5/freeze/freeze-commands.txt | the sitting's sequence; the tag message carries the ruling's two statements |

**The two rows.** f1 pins the standing sentence's price RE-DERIVED
POST-DELETION (1 % 834385168331080533771857328695283 — the frozen
pricing artifact executed over the post-deletion construction,
EV-CR2's transcript the provenance; no inherited number, the
ruling's discipline). f2 pins EXTENSION FIXED, PRICE MOVED as one
expression: the live sentence's weight over a pre-deletion referent
held fixed (R-D20 copy pinned to commit 3835952) == 3^16 exactly.
The pin helper forces the frozen side (the evaluate-show idiom, the
dyadic convention) — one force per row per the step-2 clause.

**The extensional half is the STANDING corpus, by design.** M34's
close-matrix disposition (extensionally identical, killed by
nothing) is the executed proof that no new extensional row could be
anything but a green-that-cannot-fail — so the d6 cells and
trampoline g5 police that half by STAYING green through the
deletion, and this oracle carries only the price half, which M34
proves the standing corpus cannot see. The kill story inverts the
same fact: M41 (the term restored) is killed by f1/f2 and by
NOTHING standing — the unique kill is exactly the kill the corpus
provably cannot make.

**An incident, recorded (the overlay-hygiene cousin).** The first
SAT compile failed loudly: the scratch overlay directory carried a
STALE pre-trampoline module set from earlier session work, and the
-i ordering handed the oracle an old Syntax with no chooseKS. The
overlay was wiped and rebuilt with ONLY the Purchase overlay; the
SAT run then passed 2/2 with zero warnings. The lesson is the
overlay-scan law's sibling stated for surfaces: AN OVERLAY IS
BUILT FRESH FROM THE SHIPPED TREE PLUS THE ONE PROPHESIED DIFF —
a persistent overlay directory is a stale-surface generator. Noted
for the joint-preposterior increment, whose overlay will be larger.

**Open for the sitting**: the mandate round's depth for an
increment this small (the ruling ordered a full round for the
joint-preposterior increment specifically; the sitting calls it
here), and M34's DISCHARGED-PERMANENT execution at the close
(deletion of the file, per the step-9 clause, pins listed: M41 the
heir).

## Part VIII — the F5-deletion increment CLOSE-OUT (builder, 2026-07-27; closes at the author's f5-freeze-r1)

**The freeze** was the author's own: f5-freeze-r0 over 8437a2b
(author key, `tag -v` GOOD), the ruling's two statements in the tag
message, manifest extended to 77 rows, prefreeze-lint 0 FAIL (its
transcript frozen with the kit). No delegation anywhere in this
increment — R-D22's re-tag obligation never arises; the r1
countersign below is the close's ratification in the
dyadic/trampoline pattern, not a delegated-edit cure.

**The implementation** (ccc2256, builder key): freeze/deletion.diff
applied byte-for-byte — the SAT overlay's prophecy, 1 insertion,
2 deletions. 9/9 suites pass (f5 red -> green; the STANDING corpus
green through the deletion — M34's identity working as the pin,
extension fixed while the price moved). Gates 1-7 PASS, E1-E4 all
0, manifest 77/77.

**The applicability sweep** (the custody-derived universe: every
audit/mutants/*.patch against the post-implementation tree): 32 of
36 standing mutants still apply. The four stale, dispositioned:

- **M34 -> DISCHARGED-PERMANENT, the file DELETED** (the step-9
  clause: the deletion it proved possible became the deletion that
  happened; its mutation IS the shipped tree). The register
  category's second instance after UseBern.
- **M33, M39, M40 -> RE-CUT IN PLACE** (context drift only: the
  rows moved to purchaseRows and the forgone term died; each
  semantic line preserved, the M6 precedent). Kills RE-VERIFIED
  against the committed baseline: each applied, dyadic run, FAIL
  confirmed, reverted.

**M41-forgone-restored LANDED with its kill measured** (the
forward half): applied to the committed baseline — f5 FAILS (both
price rows fire), dyadic PASSES, trampoline PASSES, reverted. The
unique-kill claim is now an EXECUTED fact: f1/f2's kill is exactly
the kill the standing corpus cannot make, demonstrated on the tree
rather than inferred from M34's record.

**A near-miss, caught by the standing check**: the close-out's
first commit attempt deleted test-f5/freeze/M41-forgone-restored.
draft.patch on the reading that the finalized M41 supersedes it —
but the DRAFT entered the manifest at the freeze and is FROZEN; the
pre-commit `sha256sum -c` failed and the file was restored from the
freeze commit before anything landed. The lesson, one line: A
FREEZE-KIT ARTIFACT IS A MANIFEST ROW — supersession by a live file
does not un-freeze the draft; its disposition belongs to a sitting.

**A dated instrument fires as designed**: test-writeup/check.sh
pins 8 cabal stanzas and the cabal now carries 9 (the f5 stanza).
The instrument is frozen and self-documented as a dated
red-by-design record; its repair (if wanted) is a frozen-layer
inventory row for a future sitting, not this close's business.

**The close**: the author's own signed tag over the close-out
commit —

    git tag -s f5-freeze-r1 -m "the deletion reviewed; extension
    fixed, price moved, both halves verified on the tree. M34
    discharged-permanent, M41 standing with its kill measured."
    git tag -v f5-freeze-r1

Push remains withheld until the author's word (the boundary's five
opening commits, the freeze, the implementation, and this close-out
are all local).

**The residue handed forward**: the joint-preposterior increment
opens NEXT on this post-deletion surface (the ruled sequence's
second act) — its charter work order is EV-CR1's measurement, its
liveness question is fresh (F4 re-argued on the reflexive object),
and it carries its own mandate round per the ruling. Then the
battery. CR3/CR4/CR5/CR6/CR7 and the OB-20/21 discharge ride the
battery's sitting as chartered.

## Part IX — the joint-preposterior increment OPENED (the author: "push, then open the joint-preposterior increment", 2026-07-27, immediately after the f5-freeze-r1 countersign; base = 362e1c4, pushed)

The ruled sequence's second act. The charter is EXACT_PLAN 14.8
(builder-unfrozen, drafted at this opening); the register JP1-JP7;
the mandate round FULL per the ruling. The opening's evidence
programs (R-D21 throwaways, prototypes discarded, transcripts in
test-completeness/opening/):

**EV-JP0 — the GroundC reliance re-check on the closed tree.** The
refine arm moved twice since the dyadic transcript (the
purchaseRows refactor, the forgone deletion), so the bank was
re-executed before this increment relies on it: shipped
runPurchase, deep root-only cells, stakes (1,-24) and (1,-171),
60 all-1 obs — **wait=60 refine=0 respond=0 in both**, byte-equal
to the dyadic close's shape. The bank is CURRENT; the deadlock this
increment discharges is real on today's tree.

**EV-JP1 — the reflexive prototype (the base-fix measured).**
Pre-stated J1-J4; results:

- **J1 PASSES EXACTLY**: with the preposterior's base = the best
  external OF THE DECLARED MENU, the four t2 anchor cells (which
  declare menu [L, R] — no wait, no respond) reproduce
  Anchors.t2RowsX byte-for-byte. ANCHORS PRESERVED BY DECLARATION:
  the joint design changes nothing t2's declaration doesn't ask
  for.
- **J2 CURED AT THE ROOT, better than drafted**: EV-CR1's habitat
  diverger (500 thinks to the driver cap) now ends at tick 0 with
  wait — think's value under the base-fix is HONEST VoI over the
  actual menu, and honest VoI of a menu no evidence can improve is
  ZERO. The divergence was never a termination bug; it was a
  PHANTOM VALUE (a base evaluating acts not on the menu), and the
  base-fix deletes the phantom rather than taming it. VoI >= 0
  (EV-CR4's law) plus tie-to-incumbent is the whole liveness story.
- **J3 (decide-once) correctly negative**: in the decide-once
  shape the deep cell rationally ends at wait on tick 0 — ambient
  evidence hasn't arrived, and the lookahead over buys alone sees
  nothing at counts (0,0). The deadlock's habitat is the
  STANDING-SERVICE purchase shape; measured there in EV-JP2.

**EV-JP2 — the front-door discharge (the lookahead refine row in
the shipped standing loop).** The one change from shipped
runPurchaseS: the myopic clamp row replaced by refineVal r (max
over frontier chains of best-menu-external-after-buys minus the
mints, r declared); counts law and loop shape byte-faithful to the
shipped route (ambient, counts advance before the choice,
externals pass the tick). The frozen deepChain is SIX nodes, so
the sweep runs r past the chain's depth.
Results, and the opening's own correction:

- **The loop sweep (one-tick base): refine NEVER fires** — r = 1..3
  measured at both deep stakes (wait=60 refine=0 respond=0
  throughout), and the r = 4..7 sweep was cut short by cost, then
  EXPLAINED AND MOOTED by the chain probe below.
- **EV-JP2c, the chain probe (the decisive cell,
  jp2c-chain-probe.txt)**: at arrived counts (60,0), stakes
  (1,-24), the guard DOES go positive with the high chain — pess =
  +0.0173 at depth 4, +0.145 at depth 5 (the multi-step value is
  real, remedy (a)'s premise confirmed) — but the ONE-TICK chain
  value max(0,pess) - k*s is NEGATIVE at every (counts, depth)
  probed: THE MINTS EAT A SINGLE RESPOND'S VALUE. The frozen d6.2
  world profits from its pre-owned chain over FIFTEEN responds
  (respond x15 after tick 45): vocabulary value AMORTIZES over the
  episode's remaining ticks, and a one-tick-base lookahead can
  never see it at any depth.

**The finding, named (JP8 — THE HORIZON IS THE CAP'S TRUE NAME).**
The cure for the deadlock is (lookahead over buy-chains) x (the
declared remaining-episode amortization). pwLadderCap = 16 was the
BAKED GHOST of exactly that horizon (16 ~ the future responds a
purchase amortizes over) — convicted at X.3 for bakedness, not for
the horizon idea; 13.3's remedy (a) even named it ("the kLadder
multiplier's original role, generalized lawfully"). The joint
design derives the amortization from the WORLD-DECLARED episode
length, already on the wire. Charter 14.8 item 2 and register JP8
carry it; JP2's cap-retirement path now has its ground.

**The opening's scoreboard**: J1 PASSED exactly (anchors by
declaration); J2 CURED at the root (the phantom deleted, honest
VoI); J3's cure condition IDENTIFIED and measured (chain positivity
real, amortization required) — the deadlock-cure oracle row will
pin the amortized form; J4 rides J3's cell. Transcripts:
jp0-deadlock-recheck.txt, jp1-reflexive-run.txt,
jp2c-chain-probe.txt (test-completeness/opening/).

**Next in this increment**: the amortized-form evidence program
(the deadlock-cure demonstrated end-to-end on the standing loop),
then the oracle (14.8's drafted shape + the JP8 rows), the FULL
mandate round per the ruling, the freeze kit, and the author's
sitting over JP1-JP8.

## Part IX (continued) — EV-JP3/JP4: the naive forms convicted, the DP measured as the object (2026-07-27, after the opening commit 3e3f3c4)

**EV-JP3 — the naive amortization SPREES (transcript
jp3-amortized-run.txt).** Reading A as first drafted (refine row =
H_rem x guard improvement - mints, the shipped cap-shape with the
horizon declared): on the 60-stream it never fires (the crossing
comes too late for the remaining horizon — consistent with JP2c's
arithmetic); on the 120-stream it BREAKS THE DEADLOCK AT TICK 58 —
and then buys for 62 consecutive ticks and NEVER RESPONDS. The
mirror of F4's disease: a row whose value cites a future of
responds that its own selection keeps postponing. One-tick base
starves; naive horizon sprees — the two failures bracket the same
missing object.

**EV-JP4 — the finite-horizon DP, the lawful form (transcript
jp4-dp-run.txt).** The refine row's value = the OPTIMAL
CONTINUATION: V(o,t) = max(wait 0 + V; respond pess + V; refine
-s + V(o+c)) over the declared episode, V(:,T) = 0 — the joint
preposterior in realized-evidence form (reading B, expectation over
the predictive, stays demand-gated per JP8). Probe scope declared:
the high spine, chain extensions, memoized (chain, t). Pre-stated
criteria, all met:

- (1,-24), 60-stream: wait x45, refine x5 JUST IN TIME (@45-49),
  respond x10 (@50-59), episode value +0.5212... — the DP fires
  where BOTH naive forms fail, by anticipating the crossing and
  buying exactly when the remaining respond-run pays the mints.
- (1,-24), 120-stream: wait x45, refine x6, respond x69, value
  +24.78 — NO SPREE; the DP internalizes cashing in.
- (1,-171), 120-stream: all wait, value 0 — no spine chain pays at
  these stakes within the horizon; the DP DECLINES, exactly (the
  documented-myopia lineage's successor: honest refusal, valued).
- Episode values strictly dominate the all-wait baseline wherever
  refine fires.

**The increment's design conclusion, now fully measured**: the
unified internal menu's row values are the finite-horizon DP over
the declared episode — think and refine both — with the tick's act
the DP's argmax through the one chooser, incumbent-first. Every
approximation of it in the record has a measured conviction:
actValueS-off-menu (EV-CR1, diverges), the one-tick base (EV-JP2c,
starves), cap x gain (the shipped form — pwLadderCap the baked
horizon), naive amortization (EV-JP3, sprees). The sayable route is
the DP's unrolling over the declared horizon (finite by
declaration; the vThink3Sentence precedent), the engine's memoized
DP the fast path pinned to it. JP8's register entry now reads:
reading A = the realized-evidence DP (measured here), reading B =
the predictive-expectation DP (demand-gated, no exact tractable
form yet).

Transcripts: jp3-amortized-run.txt, jp4-dp-run.txt
(test-completeness/opening/). Next: the stub surface + the oracle
(the DP rows pin these transcripts), the FULL mandate round, the
freeze kit, the sitting over JP1-JP8.

**The sayable-route fork (JP3's register item, sharpened by JP4;
EV-JP5 is its evidence program, next).** The DP's naive sayable
form — the unrolled sentence — is priced at its expansion, and a
120-tick horizon's unrolling is astronomically priced: the
unrolling route works only for small declared horizons (the g3.4
precedent pinned depth <= 3). But step 10's banked POSITIVE result
points at the lawful form: THE HORIZON IS A COMPOSITION — the
frozen walk move-code has been a Pos-index ROLLFORWARD kernel since
step 1, and t3MoveGolden ships it; iterated structure is said in
ONE sentence with the index as data, priced at the composition, not
the unrolling. If the DP recursion composes as a Pos-rollforward
sentence (value-iteration as rollforward over the declared
horizon), the agent criterion closes cleanly: the engine's memoized
DP is a fast path pinned to a SMALL sentence, and the policy's
price stays sane. Per the banked-failure expiry clause (applied to
a banked positive, the step-10 amendment's own reading), the
step-10 composition is RE-EXECUTED against the shipped grammar as
EV-JP5 before the oracle relies on it. If it composes: the oracle's
sayable-route rows pin engine == rollforward-sentence at the JP4
cells. If it does not: the fork goes to the sitting as an
alphabet-adjacent question (the two-sided gate's territory), with
the failed attempt transcribed.

**EV-JP5 — the sayable-route fork CLOSED by demonstration
(transcript jp5-sayable-route-run.txt).** First finding of the
re-execution: the step-10 banked positive's machinery is GONE — Pos
died in the exact boundary's six-cut, so the expiry clause fires on
a banked POSITIVE exactly as the step-10 amendment reads. The
re-composition against the shipped 9+1 grammar dissolves the fork:
iteration in this grammar has ALWAYS lived in the engine's licensed
clock fold (the walk's move kernel, think's batch fold — the
sentence says the STEP, the declared clock folds it), and the
Bellman backup's chooser IS the standing chooseKS sentence — what
changes is only WHAT THE ENGINE BINDS into env (row values carrying
their continuations), and engine-bound row scalars are the shipped
convention (pess/opt/gain, Purchase.hs:159). Executed: the EV-JP4
DP with every per-tick choice made by evalx of the shipped-form
chooseKS sentence over env-bound backed-up values — ALL THREE CELLS
REPRODUCE BYTE-IDENTICALLY (acts, first-fire ticks, episode values
0.5212... / 24.7828... / 0). No alphabet motion, no unrolling, no
price explosion: the policy sentence's form and price are the
shipped ones; the engine's memoized DP is a fast path whose pin
target is this demonstrated identity. JP3's register item resolves
to a pin row; nothing alphabet-adjacent goes to the sitting.

**The design phase of this increment is COMPLETE.** Every fork
opened by EV-CR1 is now resolved by executed demonstration:
the base-fix (J1/J2), the episode-shape law (JP5's register
draft), the refine row's lawful form (the finite-horizon DP —
EV-JP2c/JP3/JP4's three-way conviction), and the sayable route
(EV-JP5). What remains is construction: the stub surface, the
oracle pinning these transcripts, the FULL mandate round, the
freeze kit, and the sitting over JP1-JP8.

## Part X — the construction design (builder, 2026-07-27; the surface the oracle's stubs enable)

**The E4 resolution: THE ONE CHOOSER CHOOSES EVERYWHERE.** The DP's
Bellman backups are max-comparisons on engine-derived quantities —
exactly what E4 exists to forbid outside evalx. The lawful
implementation therefore routes EVERY backup through evalx of the
standing chooser sentence with that state's row values bound — not
just the top-level tick (EV-JP5's demonstration) but every
hypothetical state inside the lookahead: the sentence chooses in
its own preposterior. The engine's licensed remainder is exactly
the shipped pattern: the clock fold (state enumeration over the
declared horizon) and value ARITHMETIC (sums/products building
env-bound scalars — pess/opt/gain's precedent); zero ordering
tokens outside evalx, E4 green by construction.

**The surface (stubs land now, red-attributable; types arrive WITH
their derivation lines per the audit):**

- `ExtOpt` (OWait | OLeft | ORight | ORespond) — derivation: the R1
  law's menu-as-world-data, now as a declared external option sort.
- `EpisodeShape` (DecideOnce | Standing) — derivation: JP5's
  episode-shape law (the two shipped faces' shapes, declared).
- `JointWorld` — the field union (EV-CR1 P4's pin): the declared
  external menu (order = incumbency), think (price, batch), refine
  (mint), stakes, shape. The horizon is the declared stream's
  length — NO new field kind.
- `runJointW :: Namespace -> Space Rational -> Kernel Rational Int
  -> JointWorld -> [Int] -> Either String [String]` — the one loop,
  both shapes; internal-act values per the MEASURED forms (think =
  the base-fix preposterior, EV-JP1; refine = the DP continuation,
  EV-JP4/5); the value-unification of both internals under one DP
  stays registered (JP4, demand-gated).
- `jointPolicyWeight :: JointWorld -> Rational` — the standing
  sentence's price for a declared world, built by the engine from
  the declaration and priced through the frozen weightIn (the F5
  lesson: price rows read src, never a test-side copy).

**A tension recorded for the sitting (JP9, registered here).** R7's
victory said the straddle gate IN-SENTENCE; the JP refine row's
value is an env-bound DP continuation, so the joint sentence says
LESS than purchaseRows' sentence does. The line drawn by precedent:
guard machinery outputs were always engine data (pess/opt/gain,
R2's payload ruling); what E4 and the agent criterion protect is
the CHOICE, and the one-chooser-everywhere law protects it at every
depth. Whether the straddle gate should ALSO reappear in-sentence
on the joint surface (a priced mention the DP route makes
extensionally redundant) is a row-value question for the sitting —
the F5 doctrine cuts AGAINST a priced mention that buys nothing.

**The oracle (test-jointprep/, the increment's stanza):** g-jp1 the
four anchors-by-declaration (transcripts derived from the frozen
t2RowsX via g3.3's partition law); g-jp2 the phantom-cure (habitat
transcript == ["wait"] at three prices); g-jp3 the DP cells (the
three jp4/jp5 transcripts, full act-lists); g-jp4 liveness
(standing |transcript| == |stream|; decide-once external-final; the
honest-decline row); g-jp5 the sayable-route/reference pin
(runJointW == the oracle-side reference that recomputes values by
the quoted formulas and chooses via evalx — EV-CR3's
reference-equality form carrying EV-JP5's identity); g-jp6 the
price rows (jointPolicyWeight pinned per canonical cell, literals
derived at SAT time per R-D21). Kills per row at the close.

## Part XI — the oracle phase executed; the SAT run's finding (2026-07-27)

**The oracle** (test-jointprep/, 15 rows in six groups) went RED
15/15 against the stub surface (ExtOpt/EpisodeShape/JointWorld +
runJointW/jointPolicyWeight stubs in Membrane, each failure
attributable to the stub's own message; E4 stayed 0 and the
standing suites green through the stub landing). The overlay — the
implementation as prophecy, built FRESH per the stale-overlay law —
implements both episode shapes with THE ONE CHOOSER EVERYWHERE:
every tick menu, every Bellman backup, and every refine payload
selection is evalx of a chooseKS sentence over env-bound values
(chooseIdx + the scalar one-env binder withQVals); the engine keeps
arithmetic and the clock only.

**The SAT run CAUGHT A PROBE ARTIFACT (12/15, then 15/15).** The
first satisfiability run failed exactly the three DP-transcript
rows: the overlay's DIRECTION-NEUTRAL exploration (both children
per extension, depth-capped) fires one tick earlier and buys one
node deeper than the hi-spine probe the pins were drafted from
(44 waits/6 refines vs 45/5 on the 60-cell; 44/7 vs 45/6 on the
120-cell). EV-JP6 — an independent plain-max both-children DP —
settled which side is right BY DOMINANCE: it reproduces the
overlay's transcripts exactly with episode values STRICTLY GREATER
than the probe's (0.6064... > 0.5212...; 24.9357... > 24.7828...).
The probe's hi-spine restriction UNDER-BOUGHT; the baked direction
dies by dominance, exactly as baked constants die. The pins were
re-derived from EV-JP6's transcript, the oracle's inlined reference
rewritten to the same declared scope (both children, depth cap,
memoized, still sentence-choosing), and the red run re-verified
15/15 against the stubs before the corrected SAT run.

**JP10 sharpened.** The direction half of the exploration-scope
question is CLOSED (neutrality wins by dominance); the DEPTH half
remains the register's: the cap (7, probe-inherited, the frozen
deepChain's depth plus one) lives in the OVERLAY only — the sitting
rules its lawful form (world-declared vs derived) before the
implementation lands in src.

**E4 at the overlay (the canonized enumeration law).** The joint
code's comparison tokens are: the recursion bases written in the
allowlisted `| d <= 0 =` form (the loop clock, the existing row's
category and text), and `min (jwBatch w) (length buf)` (the batch
law's joint face) — ONE new allowlist row, enumerated against this
overlay, staged for the freeze beside the stanza.

**The corrected SAT: 15/15 (transcript
test-jointprep/opening/sat-run.txt).** One residual defect between
the runs, caught and fixed inside the oracle phase: the reference's
4-ary chooser minted its fourth code from a 3-point grid (mkC
refused index 3 — the door doing its job); per-arity grids fixed
it; the red run re-verified 15/15 against the stubs before the
final SAT. The freeze kit stands: implementation.diff (the overlay
prophecy, 291 lines, applies clean), e4-extension.patch (the three
enumerated loop-clock rows, both gate copies together),
stanza.cabal.draft. Remaining before the sitting: the FULL mandate
round (the ruling's demand) and freeze-commands; the sitting rules
JP1-JP10.

## Part XII — THE FULL MANDATE ROUND (six fresh-context reviewers, one mandate each, per the CR1 ruling; findings, dispositions, and the two demanded measurements; 2026-07-27)

**The round's yield: eleven findings, three in the mandates' own
incident lineages.** Dispositions executed pre-freeze (the oracle is
builder-owned until the tag) unless marked SITTING.

**Mandate 1 (theorem-as-definition).** (1a) "the DP IS the joint
preposterior" was INSTALLED: the standing DP reads realized FUTURE
counts. EV-JP7 (jp7-clairvoyance-run.txt) DEMONSTRATED the
clairvoyance: two standing worlds sharing a 45-tick all-1s prefix,
tails diverging — at tick 44, inside the shared prefix on identical
past evidence, the all-1s-tail world BUYS and the 0s-tail world
WAITS. REPAIRED BY RENAME: the standing DP is the HINDSIGHT
(declared-stream PLANNING) face — exactly the optimal-play
reference a certification battery needs — and the live agent's
standing row value is READING B (the true preposterior), registered
demand-gated (JP8's entry as amended). (1b) VoI >= 0 was cited from
an EXPIRED bank (EV-CR4 measured the pre-base-fix object). EV-JP8
(jp8-voi-run.txt) RE-EXECUTED it on the joint surface: 240 decision
points — the two frozen worlds (t2, habitat) x two perturbation
scales (p=0 exact, p=1/20) x 60 ticks — ZERO violations;
jointPrepost/bestExtJ exported for the future law rows. [Repaired
at the sitting, 2026-07-28: this row previously said "five stream
shapes (incl. all-0s and alternating)" — that described the earlier
SCRATCH probe, not the committed transcript; the R-D20 discipline
(describe the artifact, never the parallel memory) caught it at the
author's 1-verify.sh run, the falsified words quoted here inside
their own repair.] (1c) = mandate 3's finding 1, repaired below.

**Mandate 2 (asserted-not-derived).** (2a) JP10 was cited and never
registered — REPAIRED: registered in full at 14.8. (2b) "the R1
law" has no definition site; its content belongs to the STEP-5
shape (menus as world data), R-R2/R_SCOPE section 2 (the
option-order pin), and CL-3 (first-listed ties) — REPAIRED: both
frozen derivation lines and the charter re-cited to the true
provenances; the name retired.

**Mandate 3 (defined-nowhere).** (3a) EV-JP6's transcript was
uncommitted while the g-jp3 pins cited transcripts CONTRADICTING
them — REPAIRED: jp6-dominance-run.txt committed, the oracle's copy
table re-pointed. (3b) the price literal's claimed derivation
record did not exist — REPAIRED: the derivation is HERE: the frozen
weightIn executed over the drafted 3-row chooser (codes grid
"jacts" 0..2, env arity 3, values three bound Vars) printed
1 % 109418989131512359209 = 1 % 3^42; re-executable via
jointPolicyWeight against the overlay. (3c) H_rem was defined
nowhere — REPAIRED, the reading-A formula defined here for the
record: EV-JP3's convicted amortized row was refineVal = max over
chain extensions (depth <= r) of H_rem * (pess_after^+ -
pess_now^+) - (mints spent), where H_rem = the declared episode
length minus ticks elapsed, pess^+ = max 0 pess, mint = the world's
refine surcharge per node; its conviction (the spree) and the DP
that replaced it are Parts IX-X. (3d, minor) the d61 citation's
take-36 divergence — noted in the oracle header.

**Mandate 4 (type derivations).** (4a) jwThink :: Bool was the Util
shape — a think-presence toggle licensed by no law, contradicting
"never invoked, never excludable" — REPAIRED BY DELETION: the field
is gone; decide-once always carries the think row (priced, never
excludable); the standing shape's think-absence is an ENGINE-SCOPE
line under JP4, never a world declaration. (4b/4c) the JointWorld
and ExtOpt derivation lines cited laws that did not say what was
claimed — REPAIRED: re-cited (P4 with the cap->horizon and
declared-depth resolutions; EV-CR1 P1's constructors; the step-5 /
R-R2 provenances).

**Mandate 5 (overloaded conventions).** (5a) standingDP never read
jwExts — the standing menu was preserved BY LUCK, R17's
second-hand-declared-shape disease — REPAIRED: the standing loop
now derives rows, order, and names from the declaration (OLeft/
ORight in standing = an honest error naming register JP4); a
divergent-declaration kill becomes possible at the close. (5b)
jwPrice's double role (think economics + ceremony binding) and the
silent disappearance of the priced Get "price" mention from the t2
policy — REGISTERED: JP9 extended to the think side (SITTING); the
Get-freeness/namespace-invariance consequence (mandate 6's F3)
recorded with it. (5c) "wait" terminal-vs-idle — REPAIRED as a
sense line in EpisodeShape's derivation + REGISTERED under JP5
(SITTING ratifies the naming).

**Mandate 6 (function-of).** (6a) cAt's silent (total, 0) fallback
baked the all-1s shape symmetrically into engine and reference —
REPAIRED: both are errors now, like their siblings (and the nodeAt
truncation likewise). (6b) depthCap = 7 was ALSO inside the
to-be-frozen oracle, so "lives in the overlay only" was false —
REPAIRED STRUCTURALLY: jwDepth is a DECLARED JointWorld field (the
charter P4 restatement's "declared lookahead depth"), every oracle
world declares 7, engine and reference read the declaration; a
JP10 "declared" ruling now changes nothing frozen. (6c) the chooser
env's dead inputs and the third namespace in jointPolicyWeight —
REGISTERED with JP9's extension: today's price/choice
namespace-invariance is a consequence of the sentence's
Get-freeness, declared here as such; any future in-sentence mention
(JP9's question) re-opens it (SITTING).

**After the round**: red re-verified 15/15 against the repaired
stubs; SAT re-run against the repaired overlay; the implementation
prophecy regenerated. The sitting rules JP1-JP10 with every
register item carrying executed evidence and the mandate round's
dispositions on the table.

## Part XIII — the sitting rehearsal (builder, 2026-07-27; the draft script executed end-to-end before the author touches it)

**The instrument.** The author asked for help with the draft script
(test-jointprep/freeze/freeze-commands.txt). The builder's answer,
in the "enforced, never trusted" line: a DRESS REHEARSAL — the
sitting script run verbatim in a scratch clone (repo-local
verification config replicated; `touch` restores the pack's mtime
ordering that a clone checkout scrambles), with exactly the two
author-key steps stubbed (`git commit -S` -> `--no-gpg-sign`;
`git tag -s` -> unsigned `-a`, its `tag -v` failure EXPECTED and
labeled). Every other line — the splice, the [RULING] patch, the
manifest extension and three-row re-sign, the full pre-freeze
lint, the freeze commit's staging — executed for real.

**Run 1 caught a would-be sitting failure.** Lint L7 (the
full-corpus overlay build) FAILED: the drafted jointprep stanza
named `hs-source-dirs: test-jointprep` only, while JointPrep.hs
imports three modules from frozen test/ (Anchors, OracleWorld,
Streams). The red/SAT runs resolved them via `ghc -isrc -itest`,
so the defect was invisible to both transcript runs and would have
fired FIRST at the author's sitting, inside the lint, after the
manifest was already extended. The repair is the trampoline
stanza's own form (`hs-source-dirs: test-jointprep, test` +
`other-modules`), build-plumbing only — no flag changes, no row
changes; the red/SAT transcripts' flag-faithfulness is untouched.

**Run 2: green end-to-end.**

    manifest OK pre-freeze
    prophecy applies / e4 extension applies
    manifest re-signed OK            (77 -> 88 rows)
    PASS  L1..L6
    PASS  L7 full-corpus overlay build
    === prefreeze-lint: 0 FAIL, 0 WARN ===
    [master ...] jp freeze: ... 5 files changed
    REHEARSAL-EXPECTED: unsigned stub tag does not verify
    (git status --porcelain: clean)

The five staged files are exactly the intended set (proplang.cabal,
MANIFEST.sha256, the two E4 gate copies, the lint transcript); the
tag message renders as drafted, JP1-JP10.

**Three draft repairs alongside the stanza fix**, each restoring an
existing law or precedent, all builder-editable (nothing frozen
moved):

1. **The kit freezes itself** — `freeze/freeze-commands.txt` added
   to the manifest loop. The dyadic and trampoline kits both carry
   their own freeze-commands as manifest rows; f5 skipped it and
   the jp draft inherited the skip. The M41 lesson ("a freeze-kit
   artifact is a manifest row") decides for the majority form; the
   hash is taken at run time, so a decline-by-edit is what gets
   frozen — the custody record IS the ruling as run.
2. **EV-JP5's transcript joins the manifest loop** — the tag cites
   EV-JP5/JP6/JP7 by name and ratifies EV-JP8; jp6/7/8 were frozen,
   jp5-sayable-route-run.txt was the one tag-cited evidence program
   left outside. The recorded-repairs rider's spirit: what the tag
   cites, the manifest covers.
3. **The charter's stale register header** — EXACT_PLAN 14.8 said
   "(JP1-JP7...)" over a register that runs through JP10; repaired
   to JP1-JP10 (the same stale-count class as the opening review's
   71->76 citation, caught by the same kind of cross-check).

After these, the ONLY lines of the sitting script never executed
anywhere are the two that only the author's key can execute. That
is the smallest untested surface a rehearsal can leave.

**Part XIII continued — the kit split into three scripts (the
author's word, mid-construction: "of course we can use multiple
scripts").** The monolith became a cover page plus three scripts,
each owning one phase of the sitting: `1-verify.sh` (read-only,
re-runnable freely), `2-freeze.sh` (the keyless mechanics: splice,
[RULING] E4 patch, manifest extension + re-sign, lint), `3-sign.sh`
(the author's two key acts and NOTHING else). The split bought four
enforcements the monolith lacked: `set -euo pipefail` everywhere
(the monolith plowed on past failures — the f5 first-run incident's
shape); a DOUBLE-RUN GUARD on the splice (an interrupted sitting
re-runs safely; a second run would have corrupted proplang.cabal);
3-sign.sh RE-VERIFIES the manifest before its first key act, so a
ruling edit made after 2-freeze.sh hashed the kit is refused
mechanically instead of by comment; and 3-sign.sh's git add sweeps
the kit, so a legitimate pre-2 decline-by-edit rides the freeze
commit itself — the frozen record is the sitting as run.

**The rehearsal caught the rehearser.** The two-sided rehearsal
(PART A: green path, edit before 2; PART B: red path, edit after 2
must be refused) first convicted the new enforcement line itself:
`check && echo ok` under set -e is exempt on the left of `&&`, so
PART B's refusal did not fire — the exact green-that-cannot-fail /
red-that-cannot-fire pair the two-run-triptych clause names, here
applied to sitting instrumentation. Every check now stands on its
own line. Final run, both sides:

    PART A: manifest 91 rows / lint 0 FAIL, 0 WARN /
            GUARD-FIRED-AS-EXPECTED on the second 2-freeze.sh /
            SEALED / tree clean post-seal / manifest OK post-seal
    PART B: 3-sign.sh: FAILED (the edited row) ->
            B-REFUSED-AS-EXPECTED exit=1 / B-NO-TAG (good)

After this, the only lines of the sitting never executed anywhere
remain the two only the author's key can execute — and both of
their guards have now been shown to pass when they should and fire
when they must.

## Part XIV — the implementation phase's stop-and-report: the package-faithfulness gap (2026-07-28, minutes after jp-freeze-r0)

**The incident.** The first `cabal test all` after applying the
frozen prophecy FAILED TO BUILD: Membrane.hs's DP memo imports
Data.Map, and the LIBRARY stanza's build-depends is base-only — BY
RECORDED DECISION, not oversight ("src depends on base ONLY
(frozen-oracle decision: keeps the audit's `ghc -isrc` ablation
compiles package-DB-free)"). proplang.cabal is frozen; the builder
stopped and reported rather than hatching.

**Why the oracle phase could not catch it.** The overlay SAT
compile ran through plain ghc, which exposes the GLOBAL package db
— every GHC boot library, containers included. `cabal build` hides
everything not declared. So the overlay was FLAG-faithful (the
step-5 law) but not PACKAGE-faithful: a dependency gap in the
frozen build file is invisible to every plain-ghc compile by
construction. CANONIZATION CANDIDATE for the r1 sitting: an
overlay SAT compile runs under the stanza's DEPENDENCY CLOSURE
(cabal-visible packages only, e.g. `-hide-all-packages` plus the
declared list), so bit-faithful means flag-faithful AND
package-faithful — the same clause, one level down the toolchain.

**The discriminating work, executed.** (1) The frozen ablation
runner (audit/ablation-exact/run.sh, manifest row) was run against
the containers-importing src: 6/6 PASS — the plain-ghc audit
surface is UNAFFECTED. (2) containers-0.7 verified resident in
GHC 9.10.3's own lib/package.conf.d — a boot library, present in
every bare install; the decision's RATIONALE (ablation compiles
need nothing beyond bare GHC) survives the amendment; only its
literal words do not. (3) Route B (a base-only rewrite of the memo)
was declined: it deviates from the SAT-certified overlay and
re-opens the oracle phase's evidence to preserve words whose
substance survives Route A.

**The remedy** is 4-repair.sh + containers-repair.patch (the
author's key): the decision re-stated as GHC-BOOT-LIBRARIES-ONLY
with the falsified words quoted inside the amendment (the
frozen-layer inventory form), the manifest re-signed with the
repair kit hashing itself in, the frozen ablation audit re-executed
green inside the script, R-D22 satisfied by the r1 ratification.
Validated end-to-end in a scratch clone (sealed HEAD + prophecy +
stubbed repair -> jointprep suite) before the author was handed the
script.

## Part XV — the jp CLOSE-OUT: implementation green, the matrix run, the JP7 heirs discharged (builder, 2026-07-28)

**The implementation phase's spine.** The prophecy applied
byte-for-byte (284 insertions into Membrane.hs); the first build
FAILED on the frozen library stanza's base-only decision (Part
XIV's stop-and-report); the author's 4-repair.sh (ef6a782, author
key) amended the decision to GHC-boot-libraries-only; then GREEN
END-TO-END: jointprep red->green 15/15, all ten suites pass, gates
1-7 PASS, E1-E4 all 0 under the extended allowlist (both gate
copies agree). Implementation commit e7268d7.

**The close matrix.** Pool = 14 mutants (audit/mutants/ M42-M55),
derived from the increment's OWN incident case law plus the
declared operator list (the sweep-universe law): the two JP7 heirs
(M42 = the M28 tie class re-cut at the joint dispatch's row order;
M43 = the M30 menu-order class re-cut at the decide-once tick), the
EV-JP1 phantom (M44), the baked horizon (M45, the pwLadderCap
lineage), the F2 order at the standing site (M46), the E4-row
semantic siblings (M47 batch-min, M54 clock-short), the free mint
(M48, M40's standing sibling), the jwThink ghost (M49), the EV-JP4
chain-order bug (M50), the hi-spine direction (M51), the flipped
shape term (M52), the F4 swallowed act (M53), the negated guard
(M55, the M26 class). Every mutant cut against the COMMITTED
baseline e7268d7 (the dyadic lesson), every patch compiles (see
incidents below), src restored clean after every cell.

**Results.** 12/14 killed; every kill lands in jointprep ONLY — the
STANDING CORPUS IS GREEN UNDER ALL 14 (each mutant lives in
joint-only code paths), so every row kill is unique against the
standing corpus by construction, discharging the forward half for
all 15 rows at once. ALL 15 ROWS REACHED (no green-that-cannot-fail
in the sealed oracle):

    g-jp1.1 M44,M53   g-jp1.2 M44,M53   g-jp1.3 M42,M44,M53
    g-jp1.4 M42,M44,M53
    g-jp2 p=0 M42,M43,M53 (M43's SOLE killer - unique)
    g-jp2 p=1/20 M53   g-jp2 p=3/10 M53
    g-jp3.1 M42,M45,M48,M50,M51,M54,M55
    g-jp3.2 M42,M45,M50,M51,M54,M55
    g-jp3.3 M54,M55
    g-jp4.1 M54   g-jp4.2 M53
    g-jp5.1 M42,M45,M48,M50,M51,M54,M55
    g-jp6.1 M49,M52 (M49's SOLE killer - unique)   g-jp6.2 M52

Within-suite sibling shadowing (the price-variant rows g-jp1.1/1.2
and g-jp2 p>0 share kill sets with their p-siblings) is STRUCTURAL
— rows differing only in test-side data — recorded as verdicts per
the dyadic R7 pre-ruling and the structural-shadowing clause, never
a close-blocker.

**The two UNREACHED, honestly (verdicts to the sitting).**
M46-standing-menu-reversed: no tie exists at any standing act site
in the three declared streams, so the standing MENU ORDER is
unpinned by the current rows — a battery-row candidate. M47-batch-
min-dropped: the decide-once streams never present a partial tail
batch, so the min's SEMANTIC side is unpinned (its clock side is an
E4-enumerated gate row) — a battery-row candidate. Both are
pool-relative verdicts ("a verdict is pool-relative"); neither
convicts a row.

**Two compile-death incidents, recorded.** The first cuts of M48
(mint dropped -> unused `s`) and M53 (bound name unused) died under
-Werror at BUILD — a mutant killed by the compiler is not a mutant;
both re-cut to compiling forms (mint zeroed with `s` consumed; the
wildcard arm). And the mint-HALVED intermediate cut ran UNREACHED —
a real finding: the three declared streams' transcripts are
insensitive to a 2x mint change (the buy thresholds sit far from
s/2), so the mint's LEVEL is pinned only through the g-jp5.1 value
identity, not through any transcript. Rides the battery docket
beside the M46/M47 candidates.

**One attribution incident, repaired in-method.** cabal runs suites
in parallel and interleaves stdout, which glued standing-suite row
NAMES onto jointprep FAIL details in the first extraction (the
"consult ticks" false read); the matrix's row attribution was
re-run SERIALLY per mutant (jointprep alone, non-interleaved), and
suite-level integrity was read from the unambiguous per-suite
summary lines. Attribution above is from the serial pass only.

**Frozen-layer inventory for r1 (one item).** The standingDP header
comment shipped inside the byte-for-byte prophecy still carried the
pre-ruling draft ("the depth bound 7 ... register JP10 rules its
final form before the implementation lands") — falsified at
jp-freeze-r0 by JP10's ruling and by the code itself (depthCap =
jwDepth w). Repaired in the close-out commit with the falsified
words quoted in place; src is builder surface, the prophecy was
honored byte-for-byte at e7268d7 first.

**r1's docket.** (1) The package-faithfulness canonization
([RULING], test-jointprep/freeze/package-faithful.patch — the Part
XIV incident's clause, amending the step-5 flag-faithful line in
CLAUDE.md). (2) Ratification of the 4-repair freeze-boundary edit
(author key ef6a782; R-D22's chain closes at r1). (3) The matrix
verdicts received (M46/M47 UNREACHED + mint-level finding -> the
battery docket; the structural-shadowing verdicts recorded). (4)
The wire docket (EXACT_PLAN 14.9) rides to the battery sitting
unless extended here.

## Part XVI — the CERTIFICATION BATTERY increment OPENED (the author: "push and then sitting", 2026-07-28; the ruled sequence's third act; base = a2dcbbc pushed, jp-freeze-r0/r1 on origin)

**The consolidated docket** (everything the battery sitting rules,
gathered from the chartered register plus what the two prior
increments docketed here):

| item | question | drafted default / ground |
|---|---|---|
| CR3 | the family's axes + density; residual form | EXTEND the EV-CR3 walk to the JOINT declaration closure (post-CR1 the shipped object is runJointW); residual printed |
| CR4 | the law-row set | VoI + scale-invariance IN (measured); SHIFT half = menu-convention ruling; admissibility needs richer menus |
| CR5 | OB-20/21 discharge here vs separate | HERE (the OB-row flag; 14.3's drafted home) |
| CR6 | the sufficiency claim's prose form | drafted with the pack at the freeze |
| CR7 | frozen-tool repairs staged at the opening | EXECUTE at the freeze under the key |
| JP2-d6 | pwLadderCap's fate | measured below (E-B1); the sitting rules |
| M46/M47 | the standing menu-order + partial-tail-batch rows | rows drafted into the battery oracle (the close matrix's verdicts) |
| mint-level | the standing mint's level pinned only via g-jp5.1 | a transcript-level differential row drafted |
| 14.9 | the wire docket's scheduling ruling | #20 readout -> OB-19 heir -> #19 1a-or-doctrine |

**E-B1 (the cap's live extent, measured at the opening).** grep
over src/: NO module imports PropLang.Purchase — the wire routes
nothing through it (issue #19's own finding, still true), Membrane
mentions it in comments only, and the jp DP reads jwRefine/jwDepth,
never pwLadderCap. The cap's ONLY consumers are frozen oracles
(test-dyadic declares 16 in three rows; test-f5's price pins read
purchaseRows). So the JP2 question at this sitting is honestly
NAMED: not "does the cap distort a live route" (it cannot — no live
route exists) but "does the myopic Purchase face stay in the
language as a frozen-pinned alternative, or retire now that the
joint DP is the shipped object". Retiring the FIELD breaks the
frozen dyadic declarations — a frozen-oracle amendment under the
author's key, the R-D22 form; keeping it keeps a test-only organ
with its pins honest. The sitting rules with this measurement on
the table.

**The build plan (oracle-first, the jp pattern).** test-battery/
carries: the family generator walking the JOINT declaration
closure (jwExts family, price regime, batch, refine
present/absent, shape, stakes, streams — density per CR3's
ruling), every member checked shipped-vs-reference at exact ==,
the reference extending test/ExactReference.hs + the jp refSolve
by R-D20 copy with provenance; the law rows (VoI >= 0, scale
invariance, admissibility-fragment) over the family via the
exported jointPrepost/bestExtJ; the F5 rows (the post-deletion
price pin + M34's identity, re-derived); the M46/M47/mint rows
(a standing tie stream, a partial-tail-batch stream, a mint-level
differential); the OB-20/21 pools in audit/mutants/ with the
matrix run reaching the lawful/independence/count stanzas. Red
against stubs where implementation is owed; where the battery
pins ALREADY-SHIPPED behavior (the family rows), the PIN-FREEZE
clause applies and the red half is seeded-defect demonstrations
(the step-2 precedent, as amended step-10).

**Part XVI continued — the battery construction through the pools
(builder, 2026-07-28; commits b560ec1, 86d9d0f, e8d9ae1).** The
oracle stands at 80 rows, green on the shipped surface (PIN-FREEZE
form): g-b1 the 72-cell family — the axes DECLARED (3 grids x 4
prices x 3 batches x 2 streams), shipped runJointW == the
independent reference at exact == in every cell, the reference an
R-D20 copy of the frozen ExactReference formulas generalized to
the declared axes, the four t2 anchors falling out of the walk —
g-b2 the law rows (VoI >= 0 at every family root; stake-scale
invariance x2/x5), g-b3 the docketed rows (BOTH of the jp close's
UNREACHED verdicts cured by sole-killer rows: M46 by the
refine-declared tie stream after the first cut exposed the
goPlain/runFrom act-site split; M47 by the knife-edge cell whose
window was measured exactly — VoI(1)=0 < 1/20 < VoI(3)=36/625 at
the post-think belief), g-b4 the enumeration-gate reach row, and
the residual PRINTED. The compile is the package-faithfulness
law's first application (hidden-all + the stanza's dependency
closure). Seeded-defect red demonstrated: M42 fires 45 rows, M44
fires 58, M46/M47 their sole rows.

**The OB-20/21 pools landed** (M56-M61, the reach table in
test-battery/opening/pool-reach.txt): the lawful stanza reached by
three reasoner mutants, the independence suite the SOLE killer of
the refusal-law mutant, pins the SOLE killer of the count-gate —
and M61 ran UNREACHED exactly as the ledger predicted (the
membership row is an intension predicate, generator-blind), cured
in-increment by g-b4.1. The discharge events the x5 ruling 4 named
are now EXECUTED; the verdicts ride to the sitting.

**Remaining before the sitting**: the mint-level knife-edge cell
(drafted in the residual; its construction needs the standing
reference), the F5-row decision (test-f5 already stands green —
whether the battery duplicates its pins or cites them is a sitting
line), the mandate round over the increment, and the freeze kit
(stanza splice, manifest, the sitting scripts in the 1/2/3 form).

## Part XVII — THE BATTERY MANDATE ROUND (six fresh reviewers, one mandate each; findings and the repair docket; 2026-07-28)

**M4 (types).** (4a) g-b2.2 compares Either-to-Either: a
stakes-independent refusal (Left==Left) passes as scale invariance
— the triptych's green-that-cannot-fail. REPAIR: case-split, Left
fails. (4b) vThinkG lacks its R-D20 line (<- ExactReference.hs:199
vThink). REPAIR: add. (4c) spaceKOf keys the frozen borrow on the
STRING "g9", discarding points — a name/points drift ships the
frozen kernel over a wrong reference grid. REPAIR: guard the g9
branch on pts == thetaG9.

**M6 (function-of).** spaceKOf/refDelib/familyCells/mutants clean;
(6a) the R-D20 kernel copy evaluates under tNs/("price",0) where
the quoted original uses wNs/("t",0) — semantically inert (body
reads only binders) but unheralded inside a copy. REPAIR: one
comment line. (6b) = 4c.

**M2 (cited-never-derived).** (2a) the pin-freeze clause demands
EVERY row's red reachable, attribution partitioned; reds exist
only for g-b1.1 cells + g-b3.1/g-b3.3/g-b4.1. REPAIR: full serial
battery matrix vs the pool with COMMITTED per-row kill lists; cut
M62 (pess affine-shift — scale invariance's true killer; negation
and scaling are both covariant, so no standing mutant can reach
g-b2.2) and M63 (goPlain menu reversal — g-b3.2's deferred
candidate, due now). Already shown by the standing logs: g-b1.2
FAILS under M42+M44, g-b2.1 FAILS under M44. (2b) "the
no-silent-caps law" cited 3x, defined nowhere — the substance
lives at EXACT_PLAN 14.1 ("the RESIDUAL ... is PRINTED by the
suite, never absorbed"). REPAIR: cite 14.1 as the definition site;
canonization offered to the sitting.

**M3 (undefined quantities).** (3a) = 2a (the 45/58 counts are
bare; the committed matrix cures). (3b) THE RESIDUAL ROW IS FALSE
OF ITS OWN FILE: it still prints the M47 cell as "DRAFTED" while
g-b3.3 ships it. REPAIR: re-cut the residual text (mint-level
stays, M47 line dies). Knife-edge numbers re-derived clean by the
reviewer; jwDepth inert in every battery expectation.

**M5 (overloaded conventions).** (5a) = 2a (red-demonstrated vs
red-deferred never ruled — the matrix cures by leaving no deferred
row). (5b) the header declares the pool "M42-M55" while g-b4.1's
sole killer is M61. REPAIR: header says M42-M63 (the pool as of
this increment's close).

**M1 (theorem-as-definition).** [landed after the five above; the
disposition line appended at the kit assembly, 2026-07-30.] Two
findings; the refDelib independence concern examined and CLEARED
(the reference route is pure list arithmetic vs runJointW's
Belief/evalx/chooseKS route; M42/M44 fire 45/58 rows, so g-b1
agreement is non-vacuous). (1a) g-b2.1 is, over the family walked,
Jensen's theorem of the code's OWN shared mass decomposition
(jointPrepost and bestExtJ bottom out in the same condK/predictMass
list), and at review time no transcript showed it could fire —
only a chooser-direction or mass-decoherence mutant can break it.
DISPOSITION: the verdict rides the committed matrix honestly —
M44 (prepost-base-off-menu, exactly the mass-decoherence class)
fires g-b2.1, red committed in the serial matrix; the row is a
conformance pin on the decomposition, not an independent law, and
the tag names it so. (1b) the 72-cell sweep collapses: price never
enters jointPrepost (bound as an env feature no evaluated body
reads) and stream content enters only as d = min n 36 = n, so the
g-b2.1 family computes 9 distinct values. DISPOSITION: recorded as
honest accounting (the sweep's value for g-b2.1 is reach, not
variety); the residual row's discipline covers it. (1c) g-b4.1's
green side was vacuous under an under-generating corpus (an empty
budget-5 corpus passes the no-If assert). REPAIR: nonemptiness
assert at budget 5, landed with the 3e01564 batch.

**The residual row's class**: a printer cannot fail by design —
disposed as a RECORD row (the F6/test-writeup precedent), named so
in the row title at the repair.

## Part XVIII — NO RED OWED + THE BATTERY FREEZE KIT (builder, 2026-07-28/30; the sitting's materials)

**The author's standing ruling, 2026-07-28** (on g-b2.2's owed red):
"never owe a red if possible." Executed the same day, window-first —
the knife-edge method is: compute the exact decision margin, place a
declared parameter strictly inside it, then confirm the seeded
defect fires. Invariance laws have reds only at decision margins;
generic streams jump over margins, so these reds are CONSTRUCTED,
never hoped for.

**The probe** (R-D21 throwaway; transcript committed at
test-battery/opening/knife-probe.txt): the first pass, on the wrong
stream, came back empty; the second measured the guard surface
itself and found a STRUCTURAL CAP — at root-owned counts the
worst-node win probability saturates at 1/2, so the pessimism guard
is bounded by g_max = (1-s)/2, and M62's discrimination window
(-1, -1/5) was UNREACHABLE at stakes (1,-24) on ANY stream. The
stakes axis was the free variable: at (1,-2), g(0,0) = -7/8 sits
inside the window at tick 0. The mint margin measured on the same
pass: on the all-ones-60 buyer stream at stakes (1,-24), the buys
flip from 6 (mint 1/10) to 0 (mint 1/5).

**Three rows landed from one measurement** (commit d7a1272; suite
79 -> 82):
- g-b2.2 gains the window triple (1,-2)/(2,-4)/(5,-10) — shipped
  transcripts invariant (green); M62's +1 shift makes the scales
  disagree at tick 0 (red fires).
- g-b2.3 mint-with-stakes homogeneity: scaling ALL payoffs
  including the mint (jwRefine = k/10, stakes (k, -24k), k in
  {1,2,5}) leaves the buying transcript invariant, pinned on a real
  6-buy trajectory, not a degenerate all-wait one.
- g-b3.4 the mint-level differential at the measured margin: 6 buys
  at 1/10, zero at 1/5 — the x2 sensitivity the jp close found the
  transcripts blind to, now live. Its red is M48, whose battery
  reach was ZERO before this row.

The committed serial matrix's OWED verdict for g-b2.2 is superseded
in place (dated block inside battery-kill-matrix.txt, the
frozen-layer repair form); post-supersession the pin-freeze clause
is satisfied IN FULL: every battery row red-demonstrated, no red
owed anywhere, the residual row a RECORD row.

**The freeze kit** (test-battery/freeze/, the jp 1/2/3 form; this
is a SINGLE-TAG close — pin-freeze, no implementation owed, the
matrix already run against the committed baseline, so no r1 phase
follows):

- 1-verify.sh — read-only; includes a LIVE 82/82 battery run under
  the stanza's dependency closure (the package-faithfulness law),
  so the green being signed is executed at the sitting, not only
  recorded.
- 2-freeze.sh — keyless mechanics: the stanza splice; three
  [RULING] patches, each declinable by editing the script before
  running it (CR7's boundary-audit repair, staged at the opening;
  the NO-SILENT-CAPS canonization into CLAUDE.md, mandate 2's
  offer, substance = EXACT_PLAN 14.1; the RED-IS-CONSTRUCTED
  canonization into CLAUDE.md — the author's own 2026-07-28 ruling
  offered as standing law); the first stanza'd `cabal test battery`
  run; the manifest extension (oracle + transcripts + kit, the
  kit-freezes-itself form) + re-sign of the four mutated frozen
  rows; the pre-freeze lint.
- 3-sign.sh — the author's two key acts only (commit -S, tag -s
  battery-freeze-r0), guarded by a manifest re-check so a
  post-2-freeze edit is refused mechanically.

The tag message carries the register as drafted: CR3 (axes as
built, residual printed), CR4 (VoI + scale rows in; the SHIFT half
ruled a menu convention — the declared wait row pins zero;
admissibility deferred to the K>2 residual), CR5 (OB-20/21
discharged here), CR6 (the sufficiency prose form), CR7 (execute),
JP2-d6 (pwLadderCap: RETIRE-UNTIL-N — the question returns at the
wire docket's #19/doctrine sitting), the M46/M47/mint discharge,
the mandate-round ratifications, and the 14.9 wire scheduling
(#20 first, the OB-19 heir second, #19 1a-or-doctrine third).
Declining any drafted line = editing 3-sign.sh (or the [RULING]
lines in 2-freeze.sh) BEFORE 2-freeze.sh runs.

**The kit's two-sided rehearsal** (fresh scratch clone, builder key,
2026-07-30; the jp rehearsal form). FIRST RED, caught and repaired:
1-verify's live compile assumed the drafting tree's package db —
`cabal exec` reads dist-newstyle/packagedb, which a fresh checkout
lacks; the script failed in the clone at exactly the step that
exists to prove the green is true of ANY honest copy of the tree.
Repaired (a cached-no-op `cabal build lib:proplang` before the exec
line, 3d0065f) and the full rehearsal re-run from a fresh clone,
end to end: 1-verify ALL CHECKS PASSED with the live 82/82; 2-freeze
spliced, applied all three [RULING] patches, ran gate 5 green on the
spliced tree (12 suites PASS, battery among them), re-signed the
manifest 95 -> 109 rows, lint 0 FAIL 0 WARN; the RED side both ways —
the double-run guard refused a second splice, and a 3-sign edited
AFTER 2-freeze was refused at the manifest re-check before any key
act; 3-sign sealed battery-freeze-r0 (BUILDER key, rehearsal only —
the real sitting's plain -s is the author's), tag -v GOOD, manifest
verifying post-seal. The kit the author runs is the kit as rehearsed.

**The author's pre-sign review (2026-07-30) — four holds, all
executed before any script ran** (the kit had not run in the real
repo, so every amendment rides the manifest as-run):

1. THE SUBSTANTIVE HOLD - CR6's claim prose vs mandate 1. "72
   cells" + "VoI >= 0 holds" reads as more independent coverage
   than 1a/1b license. EXECUTED: the tag's CR6 is re-cut to TWO
   SENTENCES - (i) exact shipped-vs-reference agreement across the
   72 declared cells, non-vacuous (M42/M44 fire 45/58 rows); (ii)
   the law rows as CONFORMANCE PINS with reach-not-variety
   accounting stated (9 distinct values; M44 the red) - and the
   coverage of (i) is never implied for the rows of (ii).
2. The mandate round's asymmetry made legible. EXECUTED: the tag
   now lists which findings were REPAIRED in-tree (4a, 3b, 1c,
   4c/6b, 4b/6a, 5b, 2a/3a/5a) and which were RECORDED as honest
   accounting with no repair owed (1a, 1b).
3. The single-tag close owned as a TRADE. EXECUTED: the tag's
   opening and the cover page both name what is given up (the r1
   catch-net where the trampoline E4 and jp package-faithfulness
   findings surfaced), the grounds, the substitute (the live 82/82
   in 1-verify), and the channel if anything surfaces post-tag (a
   frozen-layer inventory row at the wire docket's sitting).
4. R-RED gains its escape clause. EXECUTED: the patch is
   regenerated with THE HONEST-DECLINE PATH as part of the law -
   where no red is constructible, the row disposes as a RECORD row
   with the impossibility argument stated (the residual row's
   precedent), never fabricated into an artificial cell; "the law
   demands the window computation, not a red by any means."

R-CR7 and R-CAPS taken as drafted. The amended kit re-rehearses
two-sided from a fresh clone before the sitting (the changed
surfaces: the R-RED patch content and the tag message text).
