<!-- Provenance (builder note, not part of the review text): transcribed verbatim
     2026-07-11 from the reviewer's artifact "metareasoning-review.md"
     (claude.ai/code/artifact/9f7bc4e5-4bfc-4106-b3b7-55e9b89980fe), committed
     into the repo so the register's citations of this review resolve for future
     sessions. Advisory only; binds nothing until the author's boundary sentence. -->

# Independent review — the proplang metareasoning program

**Scope:** `brief.md` conformance audit (`BRIEF_AUDIT.md`) + plan of record
(`METAREASONING_PLAN.md`), boundaries V → R → K → change families
**Repo state reviewed:** HEAD `9b5a766`, working tree clean · ten frozen suites
green (`cabal test all`, exit 0) · audit gates 7/7 · `MANIFEST.sha256` verifies
**Reviewer stance:** adversarial verification, advisory only — signs nothing, rules
nothing, edits nothing
**Date:** 2026-07-11

---

## Verdict

**The program should open. No blocking findings.** The repo at HEAD is fully green
and the two documents under review are the most honest artifacts of their kind this
reviewer has examined: every DEBT row names its discharge, the citations are real
(one materially inaccurate evidence sentence out of thirty-plus checked —
Finding 2), and the plan's own declared limitations (VOR myopia, walk exclusion,
R-buys-precision-not-adaptation) are the right ones. Four amendments should land in
the plan/audit text **before** the author's boundary sentence ratifies them — each
is cheap now and an oracle re-open later:

1. **The truncation guard needs its utility pessimism stated per frontier
   interval.** Executed numerically, the global reading blocks `respond` forever at
   every purchase depth — the guard becomes an unpriced throttle in the fatal
   direction (Finding 3).
2. **BRIEF_AUDIT A2's evidence sentence "test 3's world IS a reflected
   nearest-neighbor walk" is false** — the world generator clamps at the boundary
   while `rw` reflects; and the audit's proposed uniform-stationarity defense of the
   reflecting boundary *refutes itself when executed* (Findings 1–2).
3. **The §3 coherence fixture's byte-identity is implementable only under a
   canonical-evaluation discipline the fixture must state** — the live incremental
   `cond` path and a counts-based retro-scorer cannot agree bit-for-bit in IEEE 754
   (Finding 4).
4. **The E6 fallback's executable retirement condition licenses retirement only on
   the "refine never pays" branch** — the wording should say so (Finding 5).

---

## Findings, sharpest first

### Finding 1 — the uniform-stationarity defense is refuted by execution

BRIEF_AUDIT A2 proposes the reflecting-boundary choice inside `rw` "may be derivable
(uniform-stationarity defense) — an argument to EXECUTE on a prototype, never
assert." Executed: the walk as implemented (`proplang.py:350-360`,
`src/PropLang/Enumerate.hs:342-358` — at the edge, the full ρ mass moves inward) has
stationary distribution ∝ (1, 2, 2, …, 2, 1) — **half weight at the boundary
points, not uniform** (numerically: 0.0625, 0.125×7, 0.0625 on the 9-point grid).
The *clamped* walk — step then clip, a self-loop at the edge — is the one with the
uniform stationary law. The defense, executed, vindicates the boundary the language
didn't choose.

A correct derivation exists and is cleaner: define the step atom as **uniform over
the neighbor set**. Interior points get the symmetric ρ/2 split; an edge point's
neighbor set is a singleton, which receives all ρ — byte-for-byte `walkOn`'s edge
case. Uniformity-over-neighbors derives topology, symmetry, and boundary in one
decision-free stroke, the way root-½ was forced by symmetry. K's row should carry
this route and strike the stationarity one.

### Finding 2 — A2's evidence sentence misdescribes the world (R-D20-class), and the truth is more interesting

The test-3 world generator (`tests_acceptance.py:263-266`) is
`i = max(0, min(n-1, i + choice(-1,1)))` — **clamped**: at the edge, half the move
mass self-loops. The `rw` hypothesis kernel **reflects**: at the edge all move mass
goes inward. The world's process is strictly *outside* the rw family. This cuts two
ways: it weakens the letter of the SELF-LICENSED verdict (the row is morally
self-licensed — the world was authored in the family's image — but not literally),
and it slightly *strengthens* the deletion row: the 3.96 bits (verified:
211.05494 − 207.09758 = 3.9574, `test/Anchors.hs:117-118`) were earned on a world
the family can only approximate — a sliver of generic-capability evidence the audit
doesn't claim credit for. Under the house's own copy-not-reconstruct rule, correct
the sentence at the checkpoint; keep the verdict.

### Finding 3 — the truncation guard as worded can be implemented uselessly

METAREASONING_PLAN §3 specifies the remainder's *likelihood* bound per frontier
interval but is silent on how the remainder's *utility* is assigned. Closed-form
check (integer log-odds ladder, toy prefix code dl = 2+|j|, u_correct = +1,
u_wrong = −9, all-correct evidence):

| Owned set | θ_max | EU(respond), global pessimism | EU(respond), per-interval |
|---|---|---|---|
| root only | 0.5000 | −9.000 | −4.000 (blocked — must purchase) |
| j = 0..3 | 0.8889 | −9.000 | −0.111 (blocked, just under) |
| j = 0..4 | 0.9412 | −8.999 | **+0.412 (releases)** |
| j = 0..5 | 0.9697 | −8.999 | +0.697 |

- **Global worst-case utility:** EU ≈ −9 at every owned depth and every n — the
  unowned upper tail always contains θ→1 at sup-likelihood 1, so the remainder never
  washes out. `respond` is permanently blocked: the incumbent latent@1
  constant-block failure, rebuilt as a law.
- **Per-interval pessimism** (each frontier interval's Kraft mass × its
  sup-likelihood × its worst utility; E[u|θ] is *linear* in θ for binary outcomes,
  so the interval min is an endpoint evaluation — closed form): release occurs
  exactly when the owned frontier's upper edge crosses the stakes threshold
  p* = 0.9. "The Cromwell frontier emerges from the utility," quantitative,
  precisely as §3 promises.

Both are faithful implementations of the current sentence. The per-interval utility
bound (endpoint evaluation, by linearity) must enter §3 and the `test-refine/`
unowned-mass-guard fixture wording. The existing "stakes buy the frontier" fixture
would red under a global-pessimism implementation, so the failure is catchable
end-to-end — but a direct closed-form guard pin localizes it and costs one row.

### Finding 4 — byte-identity, in both places it is promised, needs an explicit arithmetic-seam discipline

**The §3 coherence fixture (D5).** `cond` is `zipWith (+)` then per-update
normalization through `mkBelief`'s log-sum-exp (`Belief.hs:181-182`, `:95-99`). A
hypothesis's total log-likelihood accumulated as n1 successive additions of log θ is
**not** IEEE-754-equal to a retro-scorer's n1·log θ, and per-tick normalization
compounds this. Byte-identity between "bought at t" and "had it from tick 0" is
implementable **only** if both sides are materialized by the same canonical scorer
(posterior as a pure function of (dl, n1, n0) per node; owned set folded in
canonical code order; one lse). Finding 5b in the plan shows the authors know this;
what's missing is the consequence spelled into the fixture — see D5 below.

**V's goldens (D1).** Act-leg byte-identity is plausible *by construction*:
`vPreAt` at depth 0 is `vAct`, whose per-option value is
`expect b (applyUtil u a)` — the very expression `applyStd EU` evaluates inside
`argmaxEU`, under the same strict-improvement first-listed fold (`Eval.hs:99-109`,
`:136`, `:187-190`). The one numerical hazard: `uChoose` reaches `vPre` through a
`pairB` pushforward even when the residual is degenerate (`Membrane.hs:543-544`);
`push` re-normalizes and reorders sums. V's oracle should state: **rung-0 faces take
the naked predictive.** Then any act-leg float difference in the measurement is an
implementation bug, never a seam justification.

### Finding 5 — the E6 retirement condition is well-posed but its license is one-sided

"Does refine ever pay under the frozen worlds' tick streams — measured" is
executable and deterministic. But it licenses retirement of the opt-in fallback only
on **NO**: refine never pays ⇒ clock-default replays byte-identically ⇒ clean
discharge, as worded. On **YES**, retiring the fallback moves live-binary
transcripts on frozen worlds — goldens pinned in `test-membrane/`, `test-d/`,
`test-govhost/`, none of which carry this fixture's residue tag. That branch is a
golden-moving author boundary (or the fallback becomes permanent printed residue).
One sentence in §4/§7 stating the polarity closes the gap. Also unpinned: the
always-available `refine`'s position in the option order (CL-3 ties are
first-listed; an always-present internal act needs a declared slot in the fold).

### Finding 6 — the V measurement should classify divergences, because one of them is designed

The think leg is *supposed* to change value under V (sentinel-row EU → `vThinkK`);
transcripts stay byte-stable only if `vThinkK` minus price never beats the best act
on any frozen tick. Prior measurements (voiB → 0 at k ≥ 4; think never fired on the
governor) make no-divergence the likely outcome, but the plan's "measure" should
distinguish three results in advance: **act-leg float drift** (a bug — must be zero,
per Finding 4), **think-leg value change without a choice flip** (expected,
byte-stable), and **a think-wins flip** (the designed behavior surfacing — a
behavioral question for the author, not a numerics failure).

### Finding 7 — minor citation nits (everything else checked clean)

B2's `Enumerate.hs:118-120` supports the dl-relativity claim only obliquely; the
load-bearing evidence is the `Model` constructors plus the enumerator's shapes
(`Enumerate.hs:283-296`). E3's `membrane-wire.md:121-140` range covers the whole
utility-table section, of which the tick-price claim is a subset. A2's clause "the
guard family was in the enumeration and lost" reads backwards on first pass. None
change any verdict.

---

## Decisions D1–D8

| # | Decision | Ruling |
|---|---|---|
| D1 | Open the program; V's scope | **RECOMMEND** (with Findings 4/6 folded into V's oracle wording) |
| D2 | The rw/K ruling | **RECOMMEND with two amendments** (Findings 1–2) |
| D3 | Permission-inversion / clock-default | **RECOMMEND with the polarity amendment** (Finding 5) |
| D4 | Truncation-overconfidence guard | **AMEND** — state per-interval utility pessimism (Finding 3) |
| D5 | Coherence fixture byte-identity | **AMEND** — a stated discipline, not a tolerance |
| D6 | Remaining debt verdicts (A5, A7, E4) | **RATIFY all three**, one note each |
| D7 | R's queued rulings + fixture list | **RECOMMEND with four fixture additions**, strike nothing |
| D8 | Blocking findings | **NONE** |

### D1 — Open the program; V's scope: RECOMMEND

The scope is right: one preposterior rule at the wire, `argmaxEU` as its rung-0
evaluation, depth un-pinned, zero new declared numerics. The **noisy-gather deferral
is right**: declared-reliability channels are class-1 world data (the shape already
exists — `upVerdict`/`noiseK`, `WireU.hs:414-420`), so they violate nothing, but
they add a wire key, and V's discipline is no new wire keys; ask + think already
exercise every branch of the rule. On the sub-question: **measure, don't presume the
seam** — byte-identity is better than plausible for the act legs, it is achievable
by code-path identity, so the measurement is really a one-bit question about the
think leg. *Flips me:* `vThinkK` beating the best act on any frozen governor tick,
or V unable to keep rung-0 on the naked predictive.

### D2 — The rw/K ruling: RECOMMEND with two amendments

The DEBT verdict, molecule diagnosis, and K discharge (stdlib name over priced
atoms, `walkOn` verbatim, non-self-licensed worlds costed in, demand-gated) are
correct; keeping `rw` as printed residue would be the *worse* ruling now that the
audit itself has shown the decomposition exists and the bern precedent shows the
executed-path doctrine preserves anchors. `mix` is decision-free (a
convex-combination combinator, its one slot from a priced grid — §9's exact shape).
**But** the reflecting-boundary sub-row must swap derivation routes: uniform
stationarity is refuted by execution (Finding 1); uniformity-over-the-neighbor-set
derives topology, split, and boundary in one stroke and matches `walkOn` exactly.
Amend A2's world-description sentence (Finding 2). One addition to K's scope: after
decomposition the KER sort becomes generative, so K's census must scope the
kernel-enumeration frontier, and at least one non-self-licensed world should make a
*newly sayable* molecule (e.g. asymmetric drift) earn its bits — otherwise the atoms
are decoration. *Flips me:* a demonstration that `step` cannot be stated
decision-free over the space's adjacency (this reviewer could not construct one).

### D3 — Permission-inversion / clock-default: RECOMMEND with the polarity amendment

The ruling is sound and is brief §7 in its purest available form: "no refine row ⇒
no refinement" is a permission dressed as a price, and the discharge introduces
genuinely no new number — the cost of delay is the act-now EU forgone, already
computed by the same argmax. The retirement check is well-posed and executable. The
residue-tagged fixture wording prevents the frozen-test-is-wrong collision **on the
NO branch only**; state the polarity, and pin refine's tie-break position.

### D4 — The truncation guard: AMEND

Sound in conception — the two-fidelities framing is exactly brief §6, and the guard
is what makes "the frontier emerges from utility" quantitative. But the text
under-determines the utility side of the pessimism, and the two faithful readings
differ between "releases exactly at the stakes threshold" and "blocks respond
forever at any depth" (Finding 3's table). Amend §3 to state: per frontier interval,
mass = the subtree's Kraft sum, likelihood ≤ the interval sup (closed form),
utility = the interval endpoint minimum (E[u|θ] linear in θ). With that: the
root-only start correctly cannot respond under stakes at any evidence level (it must
purchase — the design, not over-blocking), and release occurs at the first owned
rung past the stakes threshold with modest n. *Flips me:* a world with non-binary
outcomes where E[u|θ] is not linear and endpoint pessimism under-blocks — out of
scope for the Bernoulli instance R-1 ships.

### D5 — Coherence byte-identity: AMEND to a stated discipline, not a tolerance

Byte-identity is implementable and worth keeping — the strongest available tripwire
against smuggled forgetting — but only as purchase-**order** independence through
one canonical scorer (fixed association order per node score; owned set folded in
canonical code order; one lse). The buy-vs-had-always comparison against the *live
incremental* path cannot be byte-identical in IEEE 754 (n1 additions ≠ one
multiply). Concretely, two fixtures: **(i)** byte-identical order-independence via
the scorer; **(ii)** scorer-vs-incremental agreement at tolerance (CL-4's 1e-9
pattern). The mutation tripwire (forgetting factor injected into carried stats) reds
fixture (i) — the property doing constitutional work. If R instead routes
exchangeable families' live posteriors *through* the scorer (legitimate; the
cleanest reading of finding 5c's sealing), the frozen-world ulp question folds into
the same residue tag as the E6 fallback — the tag should cover the **arithmetic
seam**, not just refine-availability.

### D6 — Remaining debt verdicts: RATIFY all three

- **A5 (tau grid):** ratify "addressable, not resolved"; open-residue is a
  legitimate end-state — a raw feature axis has no forced origin or scale, and the
  theta category-error ruling does not apply to `t` (the world's own clock
  granularity is interface data, not the agent's latent precision). Note: even the
  open-residue endpoint requires the baked `tauPoints` (`Enumerate.hs:99-100`) to
  migrate to a world declaration with the frozen grid as default — the same
  precedented migration-residue shape as declared guard grids.
- **A7 (depth-1 frontier):** ratify; the depth axis is the same purchase pattern and
  R establishes it; demand-gated is right.
- **E4 (one-utility-object):** **keep queued, do not promote** — folding the
  dissolution into V would put golden-moving unification (the v1/v2 arithmetic
  differs in ulps through `pairB`) inside a boundary whose oracle promises v1/v2
  goldens byte-stable; and the next author act is already spoken for (the A-gate
  reading).

### D7 — R's queued rulings and the fixture list: RECOMMEND with additions

**Prefix code:** agree the divergence property is the statute — but do not call the
code choice behaviorally minor. Unary extent prices log-odds j at ~j bits;
Elias-gamma at ~2·log₂ j; under the guard these produce very different
stakes-to-rung economics. Jurisprudentially minor, behaviorally load-bearing; pin it
at freeze and say so. **Walk exclusion from retro-refinement in R-1:** ratify — the
carried latent is lattice-relative, the exclusion is printed, the flattening route
is named. **Fixture list:** strike nothing; add four rows:

1. the guard-release closed-form pin (per-interval arithmetic —
   owned-through-threshold + all-correct evidence ⇒ respond permitted);
2. a lattice fineness-charged-once analog — the augmented mixture's prior masses are
   exactly the 2^−dl Kraft terms and nothing else (the A8 tripwire extended to the
   frontier);
3. a prefix-freeness / Kraft-computability pin (the guard's remainder mass is only
   sound if the code is prefix-free);
4. a purchase-log row (§8 promises every owned hypothesis printed at purchase; a
   guarantee that matters belongs in the oracle, not prose).

### D8 — Blocking findings: NONE

The tree is green at HEAD (ten suites, gates 7/7, manifest verifies); no citation is
dead; no frozen artifact contradicts either document; nothing in the plan is a
category error against `brief.md`. The four amendments above are pre-freeze paper
edits — precisely what this checkpoint exists to absorb — and none blocks the
boundary sentence for V, whose scope touches none of them.

---

## Verification appendix

### (a) Citations checked and status

All nine DEBT rows plus eleven others. **Clean:** A1 (`EXPFAM_REPORT.md:54/84/88` —
E1's quote wraps lines 54–55; `interface.md:116`; `Enumerate.hs:35-38`) · A2's code
cites (`Anchors.hs:100`, `:117-118`; `Acceptance.hs:364`; `proplang.py:350-360`;
`EXPFAM_PLAN.md:72-78`; `interface.md:123-128`) · A3 (`Enumerate.hs:261-282`;
`Acceptance.hs:341-364`; `design.md:68` table) · A4/A5/A6/A7
(`Enumerate.hs:96-97 / :99-100 / :102-103 / :5-6`) · A8 (`Properties.hs:36`,
`:110-155`, quotes at `:121-124` and `:140-143` verbatim) · B1 (`Syntax.hs:144`,
`:148-161`, `:366`, `:416-422`) · B3 (`Wire.hs:478`; `Membrane.hs:282-285`, `:361`;
`WireU.hs:424`; plus an independent sweep confirming `vThinkK` is reached only by
test suites) · D1 (`Anchors.hs:51`, `:84-95`; `tests_acceptance.py:259-260`) · E1
(`Eval.hs:54`, `:81`; `membrane-wire.md:111-119`) · E2 (`:46-53`) · E4 (`:54-58`) ·
E5 (`WireU.hs:210-215`) · F2's commit `7c2a811`.
**Inaccurate:** A2's characterization of `tests_acceptance.py:257-266` as a
*reflected* walk (it is clamped — Finding 2).
**Loose but alive:** B2's `Enumerate.hs:118-120`; E3's `membrane-wire.md:121-140`
(Finding 7).

### (b) Verified by execution vs taken from documents

**Executed:** `cabal test all` (ten suites, exit 0); `audit/run-gates.sh` (7/7); the
3.9574-bit rw deletion delta; the reflected-vs-clamped stationary distributions; the
D4 guard numbers (global vs per-interval, four owned-set depths × three evidence
levels); the `vThinkK` call-site sweep; all file:line reads above.
**Taken from documents (not re-derived):** the Python-stream parity of the frozen
anchors themselves; the "voiB → 0 at k ≥ 4" measurement and the credence-governor
shadow results; the E-prototype's frozen-suite invariance claim (§6); the host
session's two defect measurements (confirmed against source structure, not re-driven
against the live binary).

### (c) Checks that were limited or ambiguous

The D4 toy split the unowned Kraft remainder 50/50 between the two tails rather than
computing per-subtree code masses (the real decomposition depends on the prefix-code
ruling still queued); the qualitative conclusion is insensitive — the lower tail's
weight is killed by its sup-likelihood regardless — but the release-point numbers
would shift slightly under a real code. `proplang-govhost` was not re-driven to
reproduce the 0.9-ceiling and VOI-unreached measurements (read-only stance; source
structure confirms both). The exact line anchor for EXPFAM_REPORT's "bern fully
re-derived" spans a line wrap at :54–55 — cosmetically off, not a dead cite.

---

*Advisory only. Two-key custody stands: the author takes these recommendations into
their checkpoint; nothing here binds until the author's boundary sentence.*
