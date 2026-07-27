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
