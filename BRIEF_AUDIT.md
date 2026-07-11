# BRIEF_AUDIT — the conformance register (corner the language again)

> Builder, 2026-07-11, at the author's direction: the alphabet has only ever been
> audited against its own increment history — exactly how handholding survives, one
> reasonable increment at a time. This register audits the as-built against `brief.md`
> itself. Binds nothing until the author's ruling; every row carries file:line
> evidence (R-D20 copy-not-reconstruct — grep-checkable, no verdict by memory).
>
> **Verdicts:** CONFORMANT (meets the brief as-built) · RESIDUE-PRINTED (a §11-class
> residue, honestly recorded) · DEBT (a violation with a named discharging boundary).
> **Provenance column** (deletion rows only): GENERIC (capability loss demonstrated on
> worlds independent of the terminal's own generating process) · SELF-LICENSED (the
> demonstrating world was authored by the terminal's own process — the row proves the
> capability, not the atom).

## A. The alphabet (brief §1, §5, §9, §12)

**A1 — bern.** [§4/§9 | CONFORMANT | provenance: GENERIC | —]
A stdlib name, not a grammar constructor, since the ExpFam boundary:
`EXPFAM_REPORT.md:54` ("bern fully re-derived; rw untouched"), `:84` (E6 —
`Bern :: Carrier Int -> StdName '[Double] (B Int)`, priced log2 10 + log2 5 + param),
`:88` (E7 executed-path doctrine, fast form = generic family at eta = logit theta);
`interface.md:116` ("bern(p) = expfam over {0,1}, stats T(y)=y — a stdlib name").
On a two-point carrier the family spans every distribution — no content beyond the
declared carrier. Deletion proof executed and generic: delete the scorer or the
carrier and nothing assigns likelihood (`src/PropLang/Enumerate.hs:35-38`, plan E9).
The brief's own arrangement (§4: "the stdlib may of course name these compositions").

**A2 — rw.** [§8/§9/§12 | DEBT — molecule recorded as an atom | provenance:
SELF-LICENSED | discharge: boundary K]
The capability is required and real: drift-sayability is §8's core demand; the guard
family competed in the enumeration and the drifting world's MAP went to the walk
(`test/Anchors.hs:100` — `('hmm', ('c','rho',3))`), and the frozen deletion row
costs 3.96 bits (`test/Anchors.hs:117-118`: 211.05 vs 207.10; asserted
`test/Acceptance.hs:364`).
Two findings against the atom:
(i) *Unpriced content in one codeword.* `rw` = mix rho (neighbor-step) identity —
nearest-neighbor topology, symmetric rho/2 split, reflecting boundary
(`proplang.py:350-360`; `src/PropLang/Enumerate.hs` `walkOn`), none priced because
the molecule is one codeword. Asymmetric steps, directed drift, absorbing boundaries
are unsayable — invisibly. The ExpFam boundary proved rw is not an expfam POINT
(`EXPFAM_PLAN.md:72-78` — source-dependent hard zeros vs fixed base measure, a real
obstruction) and recorded it as "the alphabet residue's one non-expfam member"
(`interface.md:123-128`) — but never asked whether it is a COMPOSITION. It is.
(ii) *The deletion proof is self-licensed in spirit; its letter is corrected here
(external review, finding 2 — an R-D20-class defect in this register's first
printing).* Test 3's world is a CLAMPED nearest-neighbor walk on the theta grid at
rate 0.2: `i = max(0, min(len(grid) - 1, i + rng.choice((-1, 1))))`
(`tests_acceptance.py:266`, seed 5) — at the edge the outward step self-loops —
while `rw` REFLECTS: at the edge the full rho mass moves inward
(`proplang.py:353-357`). The world's process is strictly OUTSIDE the rw family; the
earlier sentence "test 3's world IS a reflected nearest-neighbor walk" was false as
written. The verdict stands — the world was authored in the family's image, morally
self-licensed — and the correction slightly STRENGTHENS the deletion row: the 3.96
bits were earned on a world the family can only approximate, a sliver of
generic-capability evidence the first printing did not claim.
Proposed ruling (the bern precedent): `rw` becomes a stdlib name over utterable,
individually priced, individually deletion-proven kernel atoms `mix`/`step`/`id`;
executed path `walkOn` verbatim (anchors byte-stable). Census-bearing (new codewords,
P5 discipline) ⇒ own boundary K, demand-gated. K's scope INCLUDES authoring
non-self-licensed worlds, or the atoms' rows inherit this row's offense; and — the
KER sort becoming generative after decomposition — K's census scopes the
kernel-enumeration frontier, with at least one non-self-licensed world making a
newly sayable molecule (e.g. asymmetric drift) earn its bits, else the atoms are
decoration (external review, D2).
The reflecting-boundary sub-row is CLOSED BY EXECUTION — the row's own
executed-not-asserted standard, discharged by the external review (2026-07-11),
verified by detailed balance this session: the uniform-stationarity defense is
REFUTED. The reflected walk's stationary law is ∝ (1, 2, ..., 2, 1) — half weight at
the edge points; it is the CLAMPED walk that is uniform-stationary, so the defense,
executed, vindicates the boundary the language didn't choose. The derivation that
stands instead: the step atom is UNIFORM OVER THE NEIGHBOR SET — interior points get
the symmetric rho/2 split, an edge point's singleton neighbor set receives all rho —
deriving topology, symmetry, and boundary in one decision-free stroke,
byte-for-byte `walkOn`'s edge case. K's row carries this route, not the
stationarity one.
Adjacency scope, ruled at the author checkpoint (2026-07-11, counsel's finding):
the neighbor set presupposes an adjacency structure, so the route's
decision-freeness is SCOPED — adjacency = the covering relation of the ordered
vocabulary's canonical order (forced, for a totally ordered carrier, exactly as
root 1/2 was forced by symmetry; the theta grid is ordered by log-odds).
Extending the walk decomposition to an UNORDERED carrier reopens adjacency as a
declared residue, never a free inheritance. K's register also carries the
owned-set relativity question (builder): under refinement the covering relation
is relative to the OWNED set, so "step on the owned vocabulary" and "step on the
legacy grid" are distinguishable kernels — K pins which one the stdlib name `rw`
denotes.

**A3 — the model-fragment terminals `if`/`>`/`get`/`c`.** [§9 | CONFORMANT |
provenance: GENERIC | —]
Decision-free, slot-carrying, priced at derivation (`src/PropLang/Enumerate.hs:
261-282` — the dl trees); deletion rows frozen and executed per terminal
(`test/Acceptance.hs:341-364`; `design.md:68` table). Their demonstrating worlds
(consult/deletion worlds) are not authored by any single terminal's process.

**A4 — the theta vocabulary.** [§5 | DEBT | discharge: boundary R]
`thetaPoints = 0.1..0.9` baked (`src/PropLang/Enumerate.hs:96-97`). The lattice law
(METAREASONING_PLAN §1, criterion form: the dyadic lattice in the family's natural
parameter) plus purchase (refine) discharges it; the founding 9-point grid remains as
printed legacy residue for worlds without refinement, pinned by the founding oracle
(RESIDUE-PRINTED after R).

**A5 — the tau grid.** [§5/§11 | DEBT, addressable not resolved | discharge: register
question at R's freeze]
`tauPoints` baked (`src/PropLang/Enumerate.hs:99-100`), a feature-threshold
vocabulary over the declared `t`. The generalized lattice law makes this row
ADDRESSABLE ("the feature's canonical coordinate") but may not resolve it: theta's
coordinates were forced (bits ⇒ base 2, expfam ⇒ log-odds, symmetry ⇒ root 1/2); a
raw feature axis has no forced origin or scale. The row is permitted to conclude
open-residue (§11's alphabet residue) — a world-supplied coordinate may be the honest
end-state, in which case tau thresholds are declared-feature vocabulary (interface
data) rather than agent-purchasable. Note (external review, D6, ratified): even the
open-residue endpoint migrates the baked `tauPoints` to a world declaration with the
frozen grid as default — the declared-guard-grid migration-residue precedent;
open-residue rules the COORDINATE question, never the baking.

**A6 — the rho grid.** [§5 | DEBT | discharge: rides on K]
`rhoPoints` baked (`src/PropLang/Enumerate.hs:102-103`) — the walk-rate vocabulary;
its coordinate question (a rate's natural parameter) and its purchase question both
follow the atom's fate at K.

**A7 — the depth-1 Cromwell frontier.** [§6 | DEBT | discharge: the generator's depth
axis, demand-gated]
"Enumeration to the Cromwell frontier (depth-1 in `if`; a parameter of the
implementation, not the language)" (`src/PropLang/Enumerate.hs:5-6`). The brief §6
demands the frontier be a belief-aware costed DECISION, not a parameter. R
establishes the pattern (purchase priced by expected utility); depth is the same
pattern on a different axis, unbuilt, named in C3 below.

**A8 — fineness charged once (§12's named deliverable, executed row).** [§5 |
CONFORMANT | —]
The charge enters exactly once, at mention-pricing, through the one prior source —
frozen: `test/Properties.hs:110-155`, the ensemble priced "1 (MODEL choice) + 1
(PARAM choice) + log2 n (grid index) bits, through 'fromBits' — the only prior
source" (`:121-124`), and "There is no separate fineness-penalty axis; the grid's
log2 n enters through the prior and nowhere else" (`:140-143`); property registered
at `:36`. The system runs both routes simultaneously — code-length prior x per-node
likelihood — which is prior-times-likelihood, not double-charging; THIS row is the
standing tripwire against any future penalty term that would make it triple.

## B. The verbs (brief §4, §7)

**B1 — sayability.** [§4 | CONFORMANT | —]
All four exist as `Expr` constructors — `Push`/`CondE`/`Expect`/`Argmax`
(`src/PropLang/Syntax.hs:148-161`, "The verbs are sayable (reflexive closure)" at
`:144`), each priced nodeB = log2 10 plus subterms (`:416-422`; `ProdTable 10 2 1 1
7 1` at `:366`). VOI, VThink, VPre are stdlib NAMES for compositions — §4's exact
discipline (a fourth verb must be a composition or rejected; these are compositions,
named).

**B2 — the model/policy split.** [§2/§11 | RESIDUE-PRINTED | —]
Hypotheses can utter only the model fragment (`src/PropLang/Enumerate.hs:283-296` —
the `Model` constructors and the enumerator's shapes, the load-bearing evidence;
`design.md:29-52`); the verbs are utterable in policy sentences only. Lawful today —
a hypothesis containing argmax is a model of another AGENT, which is §11's named open
problem (reflective closure against computable peers), registered in F below, not
closed here.

**B3 — the one argmax at the wire.** [§7 | DEBT | discharge: boundary V]
"Think more or act now is one argmax" — today the wire's v1 path is the myopic
`argmaxEU` only (`host-governor/Wire.hs:478`; `src/PropLang/Membrane.hs:282-285,361`)
and v2 pins depth (`host-governor/WireU.hs:424`); `vThinkK` is reached by test
harnesses only (whole-repo call-site sweep, this session). V routes the single
preposterior rule to the wire with `argmaxEU` as its rung-0 evaluation.

## C. The generator (brief §6)

**C1 — status of the axis roster: OPEN, not exhaustive.** Governed case-law style
(brief §10's registry discipline): any new axis enters only through the same
deletion-method scrutiny, registered by amendment in the change that relies on it.
An unstated roster is how the next hand-carved axis arrives politely.

**C2 — resolution (exploration in theta).** Boundary R — the first built axis;
purchase priced by change in expected value, retro-coherent, guarded (the
Kraft-remainder cheap fidelity vs VOR's expensive fidelity — §6's one currency at two
fidelities).

**C3 — depth.** Unbuilt (A7). The same purchase pattern over if-nesting; demand-gated.

**C4 — compression.** Unbuilt. §6's cheap prior-only fidelity (subprogram promotion,
priceable at depth one from grammar + frequency); demand-gated; NOT the same axis as
C2 and must not be conflated (prior effect vs likelihood effect — §6's central
distinction).

**C5 — kernel composition.** Opens at K (A2); after K, the deletion method applies to
boundary programs themselves (D3).

## D. Adaptation (brief §8)

**D1 — the changing-world test.** [§12 | CONFORMANT | provenance: GENERIC for the
capability, SELF-LICENSED for the atom (A2)]
Executed and frozen: test 1's consult window (redispersal at the change point,
`test/Anchors.hs:51`), test 3's drift world (agent 339.78 beats the best
oracle-tuned forgetter 340.88, `test/Anchors.hs:84-95`), the forgetting-factor trap
run as designed ("never told; 'the world drifts at rate rho' is merely SAYABLE",
`tests_acceptance.py:259-260`). No change-detection code exists (gate 4's forbidden
tokens are the standing grep).

**D2 — permanent counts.** [§8 | DEBT | discharge: change families under the §3
criterion]
R's carried sufficient statistics hard-code exchangeability — the stationarity
assumption in load-bearing form; under drift, refinement is anti-adaptive (buys
resolution around the time-averaged theta). Honestly scoped in METAREASONING_PLAN §0
("R buys PRECISION, not adaptation"). Discharge: change is a HYPOTHESIS — regime /
change-point families, each supplying a finite carried statistic of which its
posterior is a pure function (the criterion, not the content).

**D3 — the change-family boundary opens BY the deletion method.** After K: execute
the collapse check — is BOCPD already utterable as mix-over-regime-kernels with a
hazard weight from K's atoms? If yes, the "boundary" was a molecule too: a stdlib
name plus a carried-statistic registration. The brief's method applied to its own
roadmap.

## E. Handholding (brief §9, §11) — the hello inventory vs the three lawful residues

The brief licenses exactly three residues: the alphabet, the clock, the pointer
(§11). Each hello key audited against them:

**E1 — namespace + features.** [§9 | CONFORMANT] Named not indexed, one-hot,
dormancy-by-default-0.0 (`src/PropLang/Eval.hs:54,81`; `membrane-wire.md:111-119`) —
both §9 payoffs hold as built.

**E2 — menu (affordances as data).** [§9 | CONFORMANT] The world's action space is
interface, not epistemics; normative order = the world's own tie-break commitment
(`membrane-wire.md:46-53`).

**E3 — tick price / think row.** [§7 | CONFORMANT] The clock residue: the world
charges for its own time (`membrane-wire.md:131` — the think row's declared H, v1;
`:176` — v2's `price` naming the tick-price FEATURE); measured as a feature, never
a constant (`src/PropLang/Membrane.hs:379-381`, quote at `:380` — rider 1's
stratification).

**E4 — the utility step table (v1).** [§9 | DEBT | discharge: one-utility-object,
queued]
The brief: utility is latent and inferred (CIRL); the pointer is the residue, not the
table. v2's latent form exists (increment D); the queued ruling dissolves the
declared table into a point-mass latent — the proper CIRL degeneracy, keeping the
pointer and surrendering the tables. `membrane-wire.md:54-58` v1 tables become the
degenerate case, not the default architecture.

**E5 — the gauge.** [§11 | CONFORMANT] Zero + dollar-slope (`host-governor/
WireU.hs:210-215`, R-D7): the pointer residue plus units — meaning, not values. The
one wire that genuinely cannot be inferred from its own signal.

**E6 — the refine row (the permission inversion).** [§7 | DEBT | discharge: the
clock-default ruling at R; fallback retirement at K or D3's boundary, whichever
first satisfies the byte-stability obligation — on the NO branch only, see below]
"No refine row ⇒ statically-vocabularied agent" is a permission dressed as a price —
the host gatekeeping what the agent may think about; autonomy switched on by the
harness author. Ruling recorded: absent prices default to the clock — refine is
always available, priced by the tick's opportunity cost every world already imposes.
NO NEW NUMBER exists anywhere in this ruling: the cost of delay is endogenous, the
act-now EU forgone this tick, already computed by the same argmax — §7's
termination-in-the-clock in its purest form. The opt-in fallback is a migration
residue; its retirement condition is executable (does refine ever pay under the
frozen worlds' tick streams? measured, not assumed) and R's byte-stability fixture
is residue-TAGGED at freeze with that condition in its own register row, so
retirement is the discharge of a declared obligation, never an oracle amendment.
Polarity of the license (external review, finding 5): the check licenses retirement
on NO only — refine never pays ⇒ clock-default replays byte-identically ⇒ clean
discharge. On YES, retiring the fallback moves live-binary transcripts on frozen
worlds (goldens in `test-membrane/`, `test-d/`, `test-govhost/`, none carrying this
fixture's residue tag): that branch is a golden-moving author boundary, or the
fallback becomes permanent printed residue.

**E7 — the declared grids (guards, slots, latents).** [§9 | CONFORMANT with A5's
caveat] Parameter vocabularies of declared channels travel with the world;
theta's return to law is R (A4); tau's status is A5's open question.

## F. Open problems (brief §11 — named, not closed)

1. Exact exploration pricing against arbitrary computable peers (§6) — untouched.
2. Convergence-safety: corrigibility evaporates as the posterior sharpens — partly
   MEASURED here: voiB → 0 at k >= 4 (the deference-floor amendment, rd14-close,
   `7c2a811`); the change-point re-funding + strict k in {1,2,3} edge stand proven.
3. Revealed vs idealised preferences — the observation-model choice, open.
4. Reflective closure against computable peers — B2's register line; the brief's own
   plausible dissolution (act-to-policy argmax upgrade) recorded, not executed.
5. VOR myopia (the recurring-stakes failure) — pinned as declared limitation at R;
   horizon-aware VOI the named successor, demand-gated.

## G. The reshaped boundary program

V (the single decision rule at the wire) → R (vocabulary purchase, with the review's
guard and fixtures) → K (kernel decomposition, demand-gated, census-bearing,
non-self-licensed worlds costed in) → change families (opened by the deletion
method, D3). One-utility-object queued at the author's next frozen-text edit.
Normative detail: `METAREASONING_PLAN.md`. Nothing above binds until the author's
boundary sentence; every DEBT row names its discharge; no unowned debt.

External review (2026-07-11, advisory, committed verbatim at
`reviews/2026-07-11-metareasoning-external-review.md`): open the program, no
blocking findings — RECOMMEND with amendments (D1–D3), AMEND (D4 guard, D5
coherence), RATIFY (D6), RECOMMEND with additions (D7), none blocking (D8). Its
amendments are absorbed in this commit (A2's corrected letter and closed
stationarity sub-row, A5's migration note, E6's polarity, the citation hygiene in
A2/B2/E3, and METAREASONING_PLAN §§3, 4, 7, 9.4, 10).

Author checkpoint (2026-07-11, counsel's decision sheet at
`reviews/2026-07-11-author-counsel-decision-sheet.md`): V OPENED by the boundary
sentence (METAREASONING_PLAN.md, head); R2–R6 ratified as amended — the adjacency
scope added to A2, the guard's interval-minimum emphasis and the
route-through-the-scorer ruling in METAREASONING_PLAN §3, the criterion-untested
limitation in §3, the prefix-code critical-path clause in §9.4. E4 stays queued
as a DEPENDENCY of V's byte-stable measurement baseline; the clock-default's
"permanent printed residue" accepted as a legitimate terminal state (R3).
