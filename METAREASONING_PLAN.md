# METAREASONING_PLAN — the agent owns its hypothesis space

> Drafted by the builder 2026-07-11, superseding the declared-emission-grid design
> (boundary E's wire key is DROPPED; its substrate refactor survives, §6). Binds nothing
> until the author's boundary sentence (Rider R3); rulings R-D20/21/22 bind every oracle
> below, as canonized in CLAUDE.md at the R-D14 boundary.

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

## 2. The purchase law (metareasoning as expected utility)

`refine` is the **second internal act**, exactly parallel to `think`:

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

## 3. The carried state (the one genuinely new law)

To make purchases time-consistent the agent carries **sufficient statistics**: per
emission channel and per declared guard cell (each side of each declared threshold),
the counts (n1, n0). Finite, printable, lawful — the exchangeable family's own memory,
not adaptation code (no window, no decay: the counts are total and permanent).

**Coherence theorem (the load-bearing claim, a property fixture in R's oracle):** for
exchangeable hypotheses, buy-then-retro-score equals having-had-it-always — the
posterior after a purchase is byte-identical to the posterior of an agent whose
enumeration contained the node from tick 0 at the same prior. Purchase ORDER does not
matter. The growth path affects only when vocabulary is available, never the coherence
of beliefs over what is owned.

**The walk family is excluded from retro-refinement in R's first increment** (walks are
not exchangeable; their latent's history is lattice-relative). Walks live on the legacy
grid of their world (§6). Printed as a declared limitation, the R-D23 discipline —
never smuggled. Retro-refinement for walks (via the flattened likelihood the
observe_counts verb already prints) is demand-gated future work.

## 4. The wire surface (what the host provides — nothing about theta)

- One additive utility row: `{"internal": "refine", "u": [...]}` — the latency price
  the world charges for a refinement tick, exactly parallel to the think row. That the
  world prices the agent's latency is class-1 interface data (its clock, its resource);
  what to buy, when, and how deep is all law.
- **No emission grid key. No vocabulary declaration of any kind.** The declared-grid
  bridge (old boundary E) is dropped un-shipped.
- Worlds that declare no refine row get a statically-vocabularied agent: byte-identical
  to today. Every frozen suite is untouched by construction.

## 5. The pricing amendment (single-site, author-ruled)

Lattice constants price at their node's code length; today's `mention g = 1 + log2|g|`
is uniform. This is ONE new case in the constant-pricing law, at the C production —
no new production alternative, no census codeword, the P5 single-site discipline
observed: the graded-mention rule enters as one frozen formula, pinned by the oracle,
ablatable. (This is exactly the law the baked-universal-alphabet design would have
needed anyway; here it earns its keep lazily.)

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

**Boundary R — refinement (rides on V).** `refine` as the second internal act valued by
V's machinery. New-sort maneuver: `InternalAct` gains `Refine` behind `DROP_REFINE`
(triple guard; type-only export so frozen matches stay exhaustive). Oracle
`test-refine/` key fixtures:
- **stakes buy the frontier**: u_wrong = -9 answer world under all-correct evidence —
  the agent purchases up the odds ladder, p1 crosses 0.9, `respond` fires; the SAME
  evidence under governor-scale stakes buys nothing;
- **coherence**: purchase-path independence (the §3 theorem as a property test);
- **Cromwell**: no purchase sequence reaches certainty (price diverges);
- **byte-stability**: any world without a refine row replays byte-identically against
  frozen transcripts;
- **refine-vs-think**: the two internal acts compete correctly under one law (low
  refine price + vocabulary-limited posterior ⇒ refine fires; evidence-limited
  posterior ⇒ think/gather fires instead). Every red pin transcript-backed (R-D21).

Hermes' answer host: Move A proceeds now (unchanged); Move B lands with V; confidence
lands with R — no interim wire key. The dominance experiment's engine dependencies are
V + R, both boundary-clean.

## 8. The audit amendment (stated honestly for the author)

"Every hypothesis printed and priced before evidence" becomes: **the generator is
printed and priced before evidence** (the lattice law + the pricing case, frozen and
ablatable), and **every owned hypothesis is printed at purchase** (the purchase log is
part of the transcript). At any instant the owned space is finite and printed; the
reachable space is lawful and code-length-enumerated. The guarantee that matters — no
hidden hypotheses, no unpriced influence — survives; the guarantee that changes — a
static list — is exactly the autonomy the directive demands. The deletion audit ablates
the refine constructor and the graded-pricing case like any other grammar surface.

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
4. The prefix code on (extent, depth) — Elias-gamma vs unary-extent — is R's one
   canonical-choice ruling; both are constant-free; the oracle pins whichever the
   author ratifies, with the symmetry and monotonicity properties pinned
   representation-independently.
