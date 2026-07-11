# METAREASONING_PLAN — the agent owns its hypothesis space

> Drafted by the builder 2026-07-11, superseding the declared-emission-grid design
> (boundary E's wire key is DROPPED; its substrate refactor survives, §6). Binds nothing
> until the author's boundary sentence (Rider R3 — entered below, 2026-07-11); rulings R-D20/21/22 bind every oracle
> below, as canonized in CLAUDE.md at the R-D14 boundary.

## The boundary sentence (the author, 2026-07-11)

> The metareasoning program opens at boundary V: the wire's decision becomes a
>    single preposterior rule over affordances, within which argmaxEU survives
>    only as the rung-0 evaluation and think(k) climbs by vThinkK at un-pinned
>    depth — no new wire key, no new number. The seam is measured, not presumed:
>    act-leg divergence from the frozen goldens is a bug driven to zero, and a
>    think-wins flip on any frozen tick returns to me as a behavioral question,
>    not a numerics failure. V opens oracle-first under §9; R rides on it.

V is OPEN from this commit (Rider R3: the author's hand, the author's words, this
commit). The oracle work (`test-answerhost/`, §7) proceeds under HOSTS_PLAN
§0.4/§9; R rides on V; K and the change families remain demand-gated.

## 0. The principle (the author's directive, 2026-07-11)

The agent is as autonomous as possible, including metareasoning: it adjusts its own
hypothesis SPACE — not just hypothesis probabilities — by maximizing expected utility.
Nobody declares vocabularies. The world brings only its interface (channels, names, menu,
gauge) and the prices of the resources it charges for; every epistemic commitment beyond
that is *bought* by the agent, under frozen law, when the stakes make it pay.

The week's failed alternatives, for the record: a host-declared theta grid (condemned —
the host declaring its preferred fineness of a latent's vocabulary is a category error;
precision is the agent's resource) and grid-as-hypothesis (collapses — a grid has no
likelihood of its own; over any fixed superset it is a reparameterized prior, and the
superset's edge is still somebody's undeclarable choice). What survives both critiques:
the edge is not *declared* and not *inferred* — it is **purchased**.

**Scope, stated honestly (author review, 2026-07-11, finding 2): R buys PRECISION, not
adaptation.** Permanent counts (§3) are the stationarity assumption in load-bearing form:
under drift, a refined exchangeable posterior concentrates on the time-averaged theta and
buys expensive resolution around a value that no longer obtains. Adaptation under change
is not R's deliverable; it arrives as *hypotheses* — regime/change-point families
(BOCPD-style run-length recursions; West–Harrison) entering the space and priced like
everything else, at a later demand-gated family boundary that §3's criterion is worded to
admit without constitutional amendment. The irony is recorded: the one family with
temporal structure (walks) is exactly the family R-1 excludes from refinement.

## 1. The alphabet law (no new constants)

The theta vocabulary is the **dyadic log-odds lattice**: points theta with
log2(theta/(1-theta)) = j / 2^k, arranged as the infinite binary tree rooted at
theta = 1/2 (log-odds 0), extended outward by integer log-odds and inward by dyadic
halving. Every coordinate choice is forced by the language itself:

- **base 2** because the language prices in bits;
- **log-odds** because it is the Bernoulli family's canonical coordinate (the expfam
  increment's own eta = logit theta);
- **root 1/2** because it is the unique symmetric point;
- **price = the node's code length** under the canonical prefix code on (extent,
  depth) — "fineness charged once" (a frozen founding property) extended to its natural
  limit. No scale constant, no extent constant, no size constant.

Cromwell's rule becomes a theorem instead of a parameter: no finite code names 0 or 1,
so certainty is unsayable at any depth, and no finite purchase sequence reaches it.
(The honest phrasing and no grander one — the lattice mixture is, after all, certain
that theta is dyadic, which is false with probability one and merely harmless
prequentially. Ruled at review: keep "certainty is unsayable".)

**What this construction is (author review, finding 1).** Strip the purchase vocabulary
and R is: a FIXED, countable, code-length-priced hypothesis space, of which the agent
lazily materializes the decision-relevant part. The ideal space never changes; purchase
is **lazy marginalization**, not space modification — the §3 coherence theorem is
precisely the statement that owned beliefs are the ideal full-mixture agent's beliefs
conditioned on membership in the owned set. The audit position is therefore stronger
than "amended" (§8): the generator plus the pricing formula IS the prior, printed in
full before any evidence. Lineage, for the spec: **the Jeffreys–Wrinch simplicity
postulate completed** — Jeffreys' enumerable candidate laws in decreasing prior
probability, whose complexity measure he conceded was never stated precisely enough to
give exact prior probabilities, here given that precise form for the Bernoulli family by
the lattice + prefix code, with the constants forced rather than chosen.

## 2. The purchase law (metareasoning as expected utility)

`refine` is the **second internal act** — one law with `think`, NOT symmetric to it
(author review, finding 4): `vThinkK` is a genuine preposterior expectation over
uncertain computation outcomes, while VOR is *arithmetic* — the retro-scored
augmented posterior is known exactly at valuation time. Asymmetric acts under one
rule:

- **Candidates**: the frontier of the owned tree (children of owned nodes) — finite,
  enumerated in canonical code order (the determinism/tie-break discipline, CL-3's
  analog).
- **Value of refinement (VOR)**: for candidate node K, the agent computes the posterior
  it WOULD have had if K's sentences had been enumerated from tick 0 at prior 2^-dl(K)
  — computable exactly by retro-scoring on carried sufficient statistics (§3) — and
  takes the improvement in `vAct` under the augmented mixture, minus the world's
  declared refine price. The same Russell–Wefald preposterior law as `vThinkK`; no new
  valuation machinery.
- **Firing**: `refine` competes with every other act (respond / abstain / gather /
  think) inside the ONE decision rule (§7, boundary V). When the stakes are
  u_wrong = -9 and evidence has piled at the owned vocabulary's edge, the tail child's
  VOR is the value of flipping abstain to respond — the agent buys its way up the odds
  ladder exactly as far as the stakes pay. **The Cromwell frontier emerges from the
  utility; it is never declared.** Worlds without stakes never buy tails; a governor
  world's frontier stays coarse of its own accord.

**Declared limitation — VOR is myopic** (finding 4). Retro-coherence removes the
usual pressure to refine early: buying late loses nothing epistemically — a genuine
design virtue. The residual loss is interim decisions taken at coarse vocabulary,
which one-step VOR cannot see. The failure is pinned, not hidden: a recurring-stakes
world where per-tick vAct improvement < refine price < the value over the stream —
the agent never buys and bleeds forever (`test-refine/` carries the fixture asserting
the myopic outcome as declared behavior). The named successor is horizon-aware VOI
(the author's Paper 1 machinery, with its attribution-fidelity contingency),
demand-gated.

## 3. The carried state (the one genuinely new law)

**The law, stated as criterion, not content** (author review, finding 2): *each
hypothesis family supplies a finite carried statistic of which its posterior is a
pure function.* The exchangeable Bernoulli counts — per emission channel and per
declared guard cell (each side of each declared threshold), the totals (n1, n0),
permanent, no window, no decay — are the law's FIRST INSTANCE, not the law.
Change-point families (BOCPD run-length distribution x per-run counts, finite under
lattice-priced truncation) enter at a later boundary under the same criterion,
without constitutional amendment. Finite, printable, lawful — a family's own memory,
not adaptation code. The pure-function discipline is load-bearing twice (finding 5b):
it is what makes purchases time-consistent, and it is the exact condition under which
the coherence fixture's byte-identity holds — without it the property test reds for
floating-point-ordering reasons unrelated to the theorem.
**Declared limitation (author checkpoint, R7): the criterion is aspirational
until a second family tests it.** R-1 builds only the exchangeable/Bernoulli
instance; whether the guard/scorer/VOR machinery is truly criterion-shaped — or
quietly Bernoulli-hard-wired — is validated only when a change family arrives,
and no R fixture can reveal it (brief §11's masked-hole warning applied to this
section). R's green suite proves the instance, never the generalization.

**Coherence theorem (the load-bearing claim, a property fixture in R's oracle):** for
exchangeable hypotheses, buy-then-retro-score equals having-had-it-always — the
posterior after a purchase is byte-identical to the posterior of an agent whose
enumeration contained the node from tick 0 at the same prior. Purchase ORDER does not
matter. The growth path affects only when vocabulary is available, never the coherence
of beliefs over what is owned.
**What byte-identity means here (external review, D5 — the discipline, not a
tolerance):** purchase-ORDER independence through ONE canonical scorer — the
posterior a pure function of (dl, n1, n0) per node, the owned set folded in
canonical code order, fixed association order, one log-sum-exp. The live
incremental `cond` path (n1 successive additions with per-tick normalization,
`Belief.hs:181-182`) cannot be IEEE-754-identical to the scorer's n1 * log theta;
scorer-vs-incremental agreement is therefore pinned at tolerance (CL-4's 1e-9
pattern), never byte. **Ruled at the author checkpoint (2026-07-11): R routes exchangeable
families' live posteriors THROUGH the canonical scorer** (finding 5c's sealing,
converted from reading to ruling on counsel's argument — the mutation tripwire
polices what the scorer computes, so the scorer must be what the agent runs, or
the strongest anti-smuggling property guards a path the agent doesn't take). The
ruling's scope is bounded by the freeze: single-scorer-everywhere would move the
Phase-1 founding anchors in ulps (n1 successive additions are not IEEE-equal to
n1 * log theta), so the scorer is the canonical live path everywhere the frozen
goldens do not pin the legacy arithmetic, and the incremental path survives ONLY
inside the tagged migration residue — where the frozen suites themselves are the
anti-mutation tripwire (any injected factor moves the pinned anchors and reds
gate 5). Two paths, both policed, no shadow. The frozen-world ulp question folds
into the byte-stability residue tag — the tag covers the ARITHMETIC SEAM, not
just refine-availability. If section 9.2's measured per-tick envelope forbids
routing-through, that reopens this ruling as a measured perf/constitution trade
for the author, never a silent fork.

**The walk family is excluded from retro-refinement in R's first increment** (walks are
not exchangeable; their latent's history is lattice-relative). Walks live on the legacy
grid of their world (§6). Printed as a declared limitation, the R-D23 discipline —
never smuggled. Retro-refinement for walks (via the flattened likelihood the
observe_counts verb already prints) is demand-gated future work.

**The truncation-overconfidence guard (finding 3 — a law of R).** The owned mixture
renormalizes away unowned prior mass and so systematically OVERSTATES confidence
relative to the ideal mixture — for a u_wrong = -9 respond/abstain agent, the fatal
direction. The repair is lawful and constant-free, and its pessimism is assigned
**per frontier interval** (external review, D4 — the binding arithmetic): for each
frontier interval, mass = that subtree's Kraft sum (computable from the code),
likelihood ≤ the interval's sup of theta^n1 (1-theta)^n0 (closed form for
Bernoulli), and utility = the interval MINIMUM of the family's E[u] — never a global
worst-case. That is the LAW (emphasis ruled at the author checkpoint,
2026-07-11); the ENDPOINT evaluation is the Bernoulli INSTANCE'S computation of
that minimum, licensed by binary-outcome linearity (E[u|theta] linear in theta,
so the interval minimum sits at an endpoint — closed form). A non-binary-outcome
family reopens the instance computation (the minimum may be interior) under the
same per-interval criterion, without constitutional amendment. The reading this sentence EXCLUDES: a single global worst-case utility
on the whole remainder. Executed, the global reading blocks `respond` forever at
every purchase depth (the unowned tail always contains theta -> 1 at sup-likelihood
1, so the remainder never washes out) — the incumbent latent@1 constant-block
failure rebuilt as a law, an unpriced throttle in the fatal direction. Under the
per-interval reading the consequences are the design: a root-only agent under
stakes correctly cannot respond at any evidence level (it must purchase — that is
the point, not over-blocking), and release occurs at the first owned rung past the
stakes threshold p*. The pessimistic remainder folds into the respond/abstain
evaluation: under stakes the agent must purchase or abstain — never respond
confidently against belief that might hide beyond the frontier. This makes "the
Cromwell frontier emerges from utility" quantitative rather than rhetorical. **The framing that binds the
implementation (brief §6's one currency at two fidelities): the guard IS the
cheap-fidelity evaluation of the ideal full-mixture argmax, and VOR/purchase is the
decision to buy the expensive fidelity — one valuation at two fidelities, never a
monitor.**

## 4. The wire surface (what the host provides — nothing about theta)

- **Refinement is always available; absent prices default to the clock** (the
  permission-inversion ruling, 2026-07-11). "No refine row ⇒ no refinement" would be
  a permission dressed as a price — the host gatekeeping what the agent may think
  about, autonomy switched on by the harness author. The cost of delay is ENDOGENOUS:
  the act-now EU forgone this tick, already computed by the same argmax — §7's
  termination-in-the-clock in its purest form. **The ruling introduces no new number
  anywhere**; an implementer who reads "priced by the tick" and goes looking for a
  tick-price constant to declare has misread this sentence. A world declares the
  optional `{"internal": "refine", "u": [...]}` row only to charge MORE than its
  clock (class-1 interface data — its resource); what to buy, when, and how deep is
  all law.
- **No emission grid key. No vocabulary declaration of any kind.** The declared-grid
  bridge (old boundary E) is dropped un-shipped.
- **Migration residue, printed:** R-1 ships the opt-in fallback (no refine row ⇒
  static vocabulary) solely for frozen-world byte-stability, tagged as residue with a
  named retirement boundary (K or the change-family boundary, whichever first
  satisfies the obligation). Its retirement condition is EXECUTABLE: does refine ever
  pay under the frozen worlds' tick streams — measured, not assumed. **The license is
  one-sided (external review, finding 5):** NO ⇒ clock-default replays
  byte-identically, clean discharge; YES ⇒ retirement moves live-binary transcripts
  on frozen worlds whose goldens carry no residue tag — a golden-moving author
  boundary, or the fallback stays permanent printed residue.
- **The always-available refine takes a pinned position in the option order:** CL-3
  ties break first-listed, so an ever-present internal act needs a DECLARED slot in
  the fold — ruled at R's freeze, never an accident of construction order.

## 5. The pricing amendment (single-site, author-ruled)

Lattice constants price at their node's code length; today's `mention g = 1 + log2|g|`
is uniform. This is ONE new case in the constant-pricing law, at the C production —
no new production alternative, no census codeword, the P5 single-site discipline
observed: the graded-mention rule enters as one frozen formula, pinned by the oracle,
ablatable. (This is exactly the law the baked-universal-alphabet design would have
needed anyway; here it earns its keep lazily.) **Approved by the author without
reservation** (review, 2026-07-11): the code-length prior IS the multiplicity
adjustment — the winner's-curse correction done properly.

## 6. What survives from the E prototype (worktree `proto/emission-grid`)

The substrate refactor is R's enabling change and is kept:

- `Model`/`HypState` carry their value space and points per hypothesis
  (`MBern ... (Space Double)`, `MHmm ... (Space Double) (NonEmpty Double)`) — the
  per-hypothesis vocabulary R requires;
- `walkOn` unified (one reflected-walk shape, every instantiation);
- `enumerateModelsGrid` (enumeration relative to a given vocabulary) — becomes R's
  incremental re-enumeration primitive;
- the frozen-suite invariance of all of the above (ten suites, to be run green before
  any oracle work).

The `parseEmission`/`buildWorldE`/`buildWorldUE` wire threading is dropped.

## 7. Sequencing (two boundaries, protocol-standard)

**Boundary V — the single decision rule at the wire (prerequisite).** The preposterior
rule over affordances `(name, slots, price, channel)` becomes THE wire decision;
terminals are null-channel affordances; `argmaxEU` survives only as the rung-0
evaluation inside it (ruled 2026-07-11); `think(k)` climbs by `vThinkK`; depth un-pinned.
Oracle `test-answerhost/`: the two mandatory §0.4 fixtures first (interior-menu max
above the singleton; action-dependent vPreAt above depth 1), gather-fires-iff-VOI>cost,
ladder-climbs-through-the-wire, discrimination fixture (flat-p1 register item),
v1/v2 goldens byte-stable. Distinct from HOSTS_PLAN increment B (inferred-rho family,
still demand-gated on a reliability-LEARNING shortfall after A).
Two oracle-wording rulings from the external review (D1, findings 4/6):
- **Rung-0 faces take the NAKED predictive.** Act-leg byte-identity to the myopic
  path is achievable by code-path identity (`vPreAt` at depth 0 is `vAct`, the same
  `expect b (applyUtil u a)` the myopic `argmaxEU` evaluates, under the same
  strict-improvement first-listed fold) — but only if V does not route terminals
  through the `pairB` double-pushforward `uChoose` builds unconditionally
  (`Membrane.hs:543-544`), which re-normalizes and reorders sums even for the
  degenerate zero residual (`:448-451`). With that stated, any act-leg float
  difference in the measurement is an implementation bug, never a seam
  justification.
- **The seam measurement classifies divergences in advance**, three kinds: act-leg
  float drift (a bug — must be zero, per the ruling above); think-leg value change
  without a choice flip (expected, byte-stable transcripts); a think-wins flip (the
  designed behavior surfacing — a behavioral question for the author, not a
  numerics failure).

**Boundary R — refinement (rides on V).** `refine` as the second internal act valued by
V's machinery. New-sort maneuver: `InternalAct` gains `Refine` behind `DROP_REFINE`
(triple guard; type-only export so frozen matches stay exhaustive). Oracle
`test-refine/` key fixtures:
- **stakes buy the frontier**: u_wrong = -9 answer world under all-correct evidence —
  the agent purchases up the odds ladder, p1 crosses 0.9, `respond` fires; the SAME
  evidence under governor-scale stakes buys nothing;
- **coherence, two fixtures (the §3 discipline)**: (i) purchase-ORDER independence,
  byte-identical through the canonical scorer; (ii) scorer-vs-incremental agreement
  at tolerance (CL-4's 1e-9 pattern) — never byte across the arithmetic seam;
- **the unowned-mass guard (per-interval arithmetic)**: under stakes, `respond` is
  blocked whenever the per-interval pessimistic remainder — subtree Kraft mass x
  interval sup-likelihood x interval endpoint-minimum utility — could flip it; the
  agent purchases or abstains (finding 3 with teeth, §3's binding arithmetic);
- **guard-release closed-form pin**: owned rungs through the stakes threshold plus
  all-correct evidence ⇒ `respond` permitted — the release point pinned in closed
  form; pinned numerals derived at freeze from a prototype under the RULED prefix
  code (R-D21): the external review's toy-code numbers established discriminating
  power, not pin values (the membrane pre-tag precedent);
- **lattice fineness-charged-once**: the augmented mixture's prior masses are exactly
  the 2^-dl Kraft terms and nothing else — A8's frozen tripwire extended to the
  frontier;
- **prefix-freeness / Kraft-computability pin**: the guard's remainder mass is sound
  only if the ruled code is prefix-free and its subtree sums computable — pinned,
  not presumed;
- **the purchase log**: every owned hypothesis printed at purchase (§8's promise as
  an oracle row, not prose);
- **recurring-stakes myopia pin**: the declared-limitation fixture — VOR never buys
  when per-tick gain < price < stream value (finding 4);
- **the adversarial mutation check (increment-local ablation)**: inject a forgetting
  factor into the carried statistics and confirm the purchase-path-independence
  fixture reds — the tripwire that polices "hypotheses yes, machinery no"
  (finding 5a);
- **Cromwell**: no purchase sequence reaches certainty (price diverges);
- **byte-stability (residue-TAGGED at freeze)**: any world without a refine row
  replays byte-identically against frozen transcripts — the fixture's own register
  row carries its retirement condition (§4's measured does-refine-ever-pay check), so
  its later retirement under the clock-default end-state is the discharge of a
  declared obligation, never an oracle amendment;
- **refine-vs-think**: the two internal acts compete correctly under one law (low
  refine price + vocabulary-limited posterior ⇒ refine fires; evidence-limited
  posterior ⇒ think/gather fires instead). Every red pin transcript-backed (R-D21).

Hermes' answer host: Move A proceeds now (unchanged); Move B lands with V; confidence
lands with R — no interim wire key. The dominance experiment's engine dependencies are
V + R, both boundary-clean.

## 8. The audit amendment (PROMOTED per finding 1)

**The generator plus the pricing formula IS the prior** — the static-list guarantee is
not weakened but promoted to a formula, printed in full before any evidence. Purchase
is lazy marginalization of that fixed prior (§1): the ideal hypothesis space never
changes; what changes is which portion is computed. **Every owned hypothesis is
printed at purchase** (the purchase log is part of the transcript); at any instant the
owned space is finite and printed; the reachable space is lawful and
code-length-enumerated. The guarantee that matters — no hidden hypotheses, no unpriced
influence — survives strengthened. The deletion audit ablates the refine constructor
and the graded-pricing case like any other grammar surface.

**Type-enforced sealing (finding 5c):** the posterior computation is sealed in a
module the metareasoning code cannot import, and `Refine`'s output type is consumable
only by enumeration — the type system, not the transcript, guarantees refine touches
the space and nothing else (the gate-2 export-list discipline extended).

## 9. Open problems (named now, ruled at their boundaries)

1. Walk-family retro-refinement (excluded in R-1; demand-gated, flattening route
   sketched in §3).
2. Guard-family growth: a purchase adds guard sentences pairing the new point with
   owned points across declared thresholds — O(|owned| x |thresholds|) per purchase,
   quadratic overall, same shape as today's enumeration; the per-tick VOR cost is
   frontier-bounded. The R pack carries a measured performance envelope
   (measure-before-ruling, LADDER_PLAN T1).
3. The founding 9-point grid remains in the library as the legacy default for worlds
   without a refine row — pinned by the founding oracle, dormant data, retired only at
   an (unlikely) Phase-1-touching boundary. Printed as the known residue.
4. The property that carries the Cromwell theorem is pinned
   representation-independently: **cumulative price along any path to a degenerate
   limit diverges**. The prefix code on (extent, depth) — Elias-gamma vs unary-extent
   — remains R's one canonical-choice ruling (both constant-free); the divergence
   property is the statute. The code choice is jurisprudentially minor but
   BEHAVIORALLY load-bearing (external review, D7): unary extent prices log-odds j
   at ~j bits, Elias-gamma at ~2 log2 j — very different stakes-to-rung economics
   under the guard. Pinned at the freeze, with this reason stated in the ruling —
   and the ruling sits on R's CRITICAL PATH, not just its freeze: the
   guard-release fixture's satisfiability transcript (R-D21) needs the RULED
   code, so the code choice gates the oracle phase itself; ruled deliberately,
   never carried by "minor" (author checkpoint, 2026-07-11).
5. **The alphabet law is stated in criterion form: the dyadic lattice in the family's
   NATURAL PARAMETER, or the feature's canonical coordinate** — log-odds is the
   Bernoulli instance, not the law. This makes the tau-grid row of BRIEF_AUDIT.md
   addressable, not resolved: theta's coordinates were all forced (bits ⇒ base 2,
   expfam ⇒ log-odds, symmetry ⇒ root 1/2), but a raw feature axis may have no
   forced origin or scale, and its row may honestly conclude open-residue (§11's
   alphabet residue).

## 10. Review log

2026-07-11, author review (five findings; two insisted preconditions for R's oracle
work — §3's criterion form and the guard + recurring-stakes fixtures — both applied):
finding 1 (lazy marginalization; Jeffreys–Wrinch pedigree; §8 promoted) → §1, §8;
finding 2 (permanent counts = stationarity; law as criterion; change families under
it) → §0, §3; finding 3 (truncation-overconfidence guard; two-fidelities framing) →
§3, §7; finding 4 (VOR asymmetry; myopia + recurring-stakes pin; horizon-aware
successor) → §2, §7; finding 5 (mutation tripwire; pure-function-of-carried-state;
type-enforced sealing) → §3, §7, §8. Riders absorbed: the permission inversion
(clock-default pricing, no new number; opt-in fallback = tagged migration residue
with executable retirement) → §4, §7; the lattice law generalized to criterion form
→ §9.5; the residue-tagged byte-stability fixture wording → §7. Companion register:
`BRIEF_AUDIT.md` (the brief-conformance audit; the onward program V → R → K → change
families, the latter two opened by the deletion method).

2026-07-11, external review (advisory; adversarial verification with machine access;
committed verbatim at `reviews/2026-07-11-metareasoning-external-review.md`).
Verdict: open the program, no blocking findings. Dispositions: RECOMMEND with
amendments (D1 program/V scope — measure the seam, don't presume it; D2 rw/K; D3
clock-default); AMEND (D4 the guard, D5 coherence byte-identity); RATIFY (D6 —
A5/A7 as written, E4 stays QUEUED: promotion would put golden-moving v1/v2
unification inside a boundary whose oracle promises those goldens byte-stable);
RECOMMEND with additions (D7 — four fixture rows, the prefix-code note); D8 none.
Findings absorbed: per-interval guard pessimism (the global reading executed and
shown to block respond forever) → §3, §7; coherence byte-identity as a canonical-
scorer discipline, scorer-vs-incremental at tolerance, the residue tag covering the
arithmetic seam → §3, §7; the retirement license's one-sided polarity + refine's
pinned tie-break slot → §4; naked-predictive rung-0 faces + the three-way divergence
taxonomy for V's measurement → §7; the prefix-code economics note → §9.4; the
uniform-stationarity refutation, the clamped-world correction, and K's
generative-census scope → BRIEF_AUDIT A2; the tau migration note → BRIEF_AUDIT A5;
citation hygiene (finding 7) → BRIEF_AUDIT A2/B2/E3. The reviewer's executed
numbers (guard-release table, stationary distributions) establish discriminating
power only; every oracle pin derives at freeze from a prototype under the ruled
code (R-D21).

2026-07-11, the author checkpoint (counsel's decision sheet committed verbatim at
`reviews/2026-07-11-author-counsel-decision-sheet.md`; builder assessment
in-session). Rulings: R1 — V OPENED by the boundary sentence at the head of this
document; R2 — rw/K ratified with the adjacency scope (→ BRIEF_AUDIT A2) and the
owned-set relativity register question for K; R3 — clock-default ratified,
"permanent printed residue" consciously accepted as a legitimate terminal state;
R4 — the guard's law restated with the emphasis inverted (the interval minimum of
the family's E[u] is the law; endpoint evaluation is the Bernoulli instance) →
§3; R5 — route-through-the-scorer converted from reading to RULING with the
freeze-boundary scope → §3; R6 — debt register ratified (A5 with its migration
obligation, A7 demand-gated, E4 queued as a DEPENDENCY of V's byte-stable
baseline, not inertia); R7 — the criterion-untested declared limitation → §3, the
prefix-code critical-path clause → §9.4.
