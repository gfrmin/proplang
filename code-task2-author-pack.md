# Step 1 author pack — "the likelihood is a code"

**Boundary:** `agent-boundary-r1` (author-signed).
**Increment:** step 1 — `Code`, `Pos`, `ToR`, arithmetic. **ADDITIVE** (author's sequencing
ruling, 2026-07-12: *"additive first, subtractive later"*).
**Status:** oracle phase COMPLETE. **The builder does not own a live oracle.** Awaiting the
author's review, amendments, and freeze.

---

## 1. State of the gates, right now

| | |
|---|---|
| **gate 1** (`-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`) on `src/` | ✅ **clean** |
| **gate 5** — all **ten** frozen suites | ✅ **PASS** (the oracle-phase requirement: *"existing frozen suites stay green throughout"*) |
| **gate 6** — `sha256sum -c MANIFEST.sha256` | ✅ **81/81** — no frozen file has moved |
| **`test-code`** (the new oracle) | 🔴 **38/38 FAIL — runtime-red, as required** |
| oracle compiles under the **stanza's exact flags** | ✅ (*"a red run under weaker flags proves nothing"* — the ExpFam re-open, 4c7b49d) |

**The red is the missing implementation, and nothing else.** Groups 1–5 hit the `Eval.hs`
type-surface stubs; group 6 fails **numerically** (`expected 6.2479, got 4.3219`) because
`prodTable` is still `10 2 1 1 7 1` while the oracle asserts the new counts. Two distinct,
correct kinds of red.

---

## 2. THE FALSIFIER DID NOT FIRE

Step 1 was stated with a kill-switch, before the fact:

> *"`rw` is the falsifier — **if a code cannot express the reflected walk, stop and report.**"*

**It can.** R-D21 satisfiability transcript — every asserted quantity executed once against a
throwaway prototype, **against the frozen artifacts themselves** (R-D20-i), prototypes now
discarded:

| pin | vs the FROZEN artifact | result |
|---|---|---|
| **`rw`** | `walkOn`, 7 ρ × 81 cells | **567/567 BIT-EXACT** |
| **`bern`** | the shipped `emit` kernel | **9/9 BIT-EXACT** |
| **`expfam`** | `ExpFam` at η = logit θ | **9/9 BIT-EXACT** |
| the walk's **hard zero** | a non-neighbour cell | `L = Infinity` ⇒ weight **exactly 0** |
| `logBase 2 y` vs `Div (Log y) (Log 2)` | GHC.Float's own definition | **9/9 BIT-EXACT** |

**T1 is dissolved by execution, not by argument.** Its proof — *an expfam's support is the base
measure's, fixed for the family* — is **true and irrelevant to this engine, which never used an
exponential family.** `walkOn` has always computed `2^(-L)` through `fromBits`; its own comment
says so. **Codifying it is a rename, not a re-derivation** — and the bit-exactness is the proof,
which is why `test-code` asserts **bit-equality and not a tolerance.**

*(The last row deletes `logBase` from the alphabet before it was ever proposed.)*

---

## 3. What the AUTHOR must do at the freeze

**Frozen texts change only at freeze boundaries, only by the author.** Four items:

1. **Apply the cabal stanza** — `test-code/stanza.cabal.draft` → `proplang.cabal`.
   (`proplang.cabal` is manifest-frozen; the builder never edits it. This is the recorded
   pattern — `proplang.cabal:76-78`, the expfam increment.)
2. **Absorb the `prodTable` amendment** — `ProdTable 10 2 1 1 7 1` → **`ProdTable 19 2 1 2 7 1`**
   (`prodExpr` 10 → 19: `Pos`, `ToR`, `Add`, `Sub`, `Mul`, `Div`, `Log`, `Exp`, `Neg`;
   `prodKer` 1 → 2: `Code` **beside** `ExpFam`).
3. **Re-price the frozen pins** — P5's own clause makes this **mandatory, not optional**
   (`Syntax.hs:355-361`): *"A count change edits exactly this value **plus the enumerated frozen
   pins of the changed sort** — the P5 forward ruling's **mandatory boundary item**."*
   **39 `lg 10` hits across 8 suites.** Mechanical, and the builder will do it on instruction —
   but it is a frozen edit, so **R-D22 then obliges an author re-tag within the increment.**
4. **Re-sign `MANIFEST.sha256`** to cover `test-code/` + the amended cabal + the re-priced pins.

**Sequencing note (why the pins are not already re-priced):** flipping `prodTable` reds all 39
pins instantly, and the oracle phase requires the frozen suites to **stay green throughout**. So
`prodTable` stays at 10/1 until your freeze. That is why group 6 is red today and will go green
the moment the amendment lands.

---

## 4. Register — the author rules; the builder does not

### R-C1 — **`fromBits`'s hazards are UNGUARDED, and this increment makes both reachable. BLOCKING.**

AGENT_PLAN OPEN 4. Today `L` is hardcoded, so neither can fire. Under `Code`, an arbitrary `L`
can, and **`test-code` deliberately contains NO row for this, because the guard's SHAPE is the
author's to choose and the builder will not pre-empt it by writing a test that assumes one.**

- **(a)** `L = +∞` at *every* point ⇒ `mkBelief` → `Nothing` ⇒ `error "fromBits: belief has no
  mass"`. **A live `error` site — and `fromBits`'s signature admits no failure value.**
- **(b)** `L = −∞` or `NaN` ⇒ weight `+∞` ⇒ `lse` gives `NaN` ⇒ the `z == negInf` test is `False`
  ⇒ **a silently invalid `Belief` of NaNs.** **There is no `isNaN` check anywhere in
  `Belief.hs`.** (b) is the worse one: it is silent.

The candidate readings, none of them free:
- **(i)** change `fromBits`'s signature to `Maybe` — but it is a **frozen** signature and this is
  a Phase-1 re-open;
- **(ii)** `error` — but CLAUDE.md says *"totality is the point"*;
- **(iii)** rule that a code with no mass **means the impossible**, and give `Code` a
  `Maybe (Kernel a b)` codomain — pushing the partiality into the type, where the project's own
  doctrine says it belongs.

**The builder's reading is (iii), and the builder is not acting on it.**

### R-C2 — `Neg` vs `Sub k0`: the sign of zero (OPEN 5)

`0 − 0` is `+0.0`; `negate 0` is `−0.0`. That IEEE-754 fact is the **only** reason `Neg` is its
own production rather than sugar. `test-code` group 5 pins it. **If the author rules the sign of
zero irrelevant, that row must be RETIRED — and retiring it is then a recorded alphabet change
(prodExpr 19 → 18), not a quiet edit.**

### R-C3 — **§8's survivor list is FALSE, and the correction is bigger than the boundary said**

AGENT_PLAN §8: *"SURVIVE — inference was always right: `hygiene`, acceptance test 1,
`test/Acceptance.hs` entirely."* **Measured, and false for all three:**

| suite | why it cannot survive the DELETIONS |
|---|---|
| `test/Acceptance.hs` | uses `Util` (×5), `EU`/`VAct`/… (×4), `Terminal` |
| `test-hygiene/Hygiene.hs` | uses **`FnInd` (×21)** and `lg 10` (×6) |
| `test-expfam/ExpFam.hs` | `ExpFam`/`SId`/`Carrier` (×40) |
| every other suite | all break |

**The only genuine survivor of the whole re-derivation is `test/Properties.hs`** — the one file
carrying the `1e-9` defect (§2b). *This does not touch step 1* (which is additive and breaks
nothing) but it **falsifies §8's scope statement**, and the author ruled the disposition already:
**PORT the anchors — they ARE the proof.** §8 should be amended to say so at this freeze.

### R-C4 — the intermediate alphabet is a real alphabet

Step 1's counts (**EXPR 19 / KER 2**) are **not** §5b's end state (**EXPR 21 / KER 1**), which is
reached only after the deletions of steps 3 and 9. Prices therefore move **twice**. That is the
declared cost of the author's additive-first ruling, and it is recorded rather than smoothed over:
**an intermediate alphabet is still an alphabet, and it still IS the prior.**

> **CORRECTED at the author's review (2026-07-13, §6.13 item 1):** this row cited "§5b's end
> state (EXPR 21)" as though the signed plan had always said 21. The signed §5b said **20**;
> the +1 is `ToR`, and while §5d recorded the *defect* that forced it, OPEN 6's resolution
> (both readers, two productions) had never been recorded as a **ruling**, and `ToR` carried
> no deletion proof. Both are now in the frozen plan (§5b's primitivity entry; §9 OPEN 6's
> ruling clause), at the same tag.

---

## 5. Evidence that the audits work

**The deletion audit caught the builder during this increment.** `walkOn` was exported for the
oracle to compare against (R-D20-i: check against the artifact, never a transcription) — but
`walkOn`'s *definition* sits inside `#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)`, so
an **unconditional** export made the `DROP_CARRIER_OBS` ablation fail on `walkOn` instead of
`obsCarrier`, breaking the audit's **attribution** check. `test-expfam` went red immediately and
named the cause. Fixed by guarding the export exactly as its definition is guarded.

**Nobody had to notice. The audit noticed.** That is the whole argument for the type-derivation
audit (§8c) — the deletion audit polices the alphabet, and until now *nothing policed the types.*

---

## 6. The R-C1/R-C2 evidence program (2026-07-13) — executed, not argued

The author declined to rule R-C1/R-C2 on argued trade-offs: *"we just didn't do enough work to
justify decisions."* This section is that work. Every number below was **executed** on throwaway
scratch copies (never the repo; prototypes discarded; the frozen corpus untouched — manifest
still 81/81). Two of the builder's own argued claims **fell under execution** and are called out
as such. The options are re-presented with measurements attached; **nothing here is a ruling.**

### 6.1 Hazard reachability (E1): the guard is load-bearing at frontier prices

Sweep: all 3,770 code bodies of ≤ 4 nodes over the declared grids (atoms: grid constants,
`Get "t"`, `Get`-dormancy, the two Code binders, `Pos`), classified per cell over the 9×9 grid.

| hazard | cheapest witness | nodes | price @ lg 19 | vs the fragment's own prices |
|---|---|---|---|---|
| −∞ entry | `Log (Get "t")` at t=0 | **2** | **9.50 bits** | dlConst = 5.17, dlGuard = 16.25 |
| all-+∞ column | `Neg (Log (Get "t"))` at t=0 | 3 | 13.74 bits | — |
| NaN entry | `Log (Log θ₀)` | 3 | 16.91 bits | — |

**490 of 3,770 bodies are hazardous at t=0.** The hazards sit inside the frozen fragment's own
price range — they are not exotic-depth pathologies.

**202 bodies change hazard class between t=0 and t=5** (`Log (Get "t")` is −∞ at t=0 and lawful
at t=5). **The `mkC` discipline therefore cannot extend to `Code`: features arrive at eval time,
so construction-time validation cannot be total.** The guard is an eval-time act, wherever it
lives — and a sentence may denote at one tick and not at another (the dormancy convention's
price).

### 6.2 The failure taxonomy (E1c): hazard (b) measured consumer by consumer

An ill-formed L (−∞ or NaN anywhere) makes `fromBits` return a garbage `Belief` **silently** —
and then:

| consumer | behaviour on the garbage belief |
|---|---|
| `prob` / `expect` | **silent**: total probability mass **0.0** — a "belief" assigning zero to everything |
| `entropyBits` | **silent**: −0.0 |
| `logPredict` | **silent**: NaN |
| `cond` | **silent**: returns **`Just`** more garbage |
| `push` | raises — and only by the accident that `NaN > negInf` is `False` |

**Silent in 4 of 5 consumers.** (All-+∞ columns raise in `fromBits` itself: a live `error` on a
frozen signature.) The original pack understated this: hazard (b) is not merely "silent NaN" — it
is a coherence violation (`Σp = 0`) that every read-only consumer accepts.

### 6.3 Blast radius per option (E2), measured by compilation

**(i) `fromBits → Maybe`** — flipped on a scratch copy and chased to a green lib:
- **5 src sites forced to `error`-unwrap shims** (`ExpFam`, `bernFast`, `walkOn`, `mkAgent`,
  `observeCounts`) because **`Kernel`'s field type `a -> Belief b` demands a bare `Belief`**:
  the partiality is *relocated into every kernel column, not removed*. Honest removal requires
  changing `Kernel` too — a **second** frozen-type change.
- Frozen fallout, compiler-verified: **17 error sites across 3 frozen files**
  (`test/Properties.hs` 9, `test-hygiene` 4, `test-expfam` 4; the test-d/test-ladder grep hits
  are comments). The Phase-1 re-open is confirmed at exactly this size.

**(ii) keep `error` + an explicit NaN/−∞ check** — installed on a scratch copy:
- **All ten frozen suites PASS with the check in place.** The guard is *unobservable by the
  entire frozen corpus*; its only effect ever is to turn §6.2's silence into a raise — on a
  2-node sentence at 9.5 bits (§6.1), i.e. a reachable runtime `error`, against
  "totality is the point".

**(iii) the `Maybe` moves into `Code`'s type index** (`Expr env (Maybe (K a b))`), eager grid
validation at eval:
- src diff: **2 lines in Syntax + 15 in Eval. The lib compiles clean.** Pricer, renderer,
  COMPLETE pragma untouched.
- Oracle fallout: **4 error sites in `test-code`** — all type-signature lines on the code-builder
  helpers; mechanical to amend, and the oracle is still the builder's (pre-freeze).
- The validator, executed: all three hazard classes → `Nothing`; the walkOn-shaped hard-zero
  code → `Just` with the hard zero preserved bit-exactly; the ulp-cliff code (§6.5) → `Just`;
  prices unchanged.
- A discovered coherence point: under (iii), `Push b (Code …)` is **ill-typed** — an unvalidated
  code cannot feed a verb at all. This is the **`CondE` precedent verbatim**: `CondE` already
  produces `Expr env (Maybe (B a))` with elimination deferred (ElimJ, build-order step 9). The
  grammar already contains exactly this pattern for evidence; (iii) applies it to codes.
- A discovered constraint either way: **the frozen `Belief` export list has no Space-points
  reader**, and `Code`/`Pos` evaluation needs one. Implementation requires either a gate-2
  export amendment at the freeze or point-carrying payloads (the `walkOn`/`MHmm` pattern).

### 6.4 The Nothing sink (E3): the builder's armchair preference REVERSED by measurement

Structural facts first, all executed:
- A zero-likelihood-everywhere row is **unrepresentable** in the sealed layer (every `Belief`
  is normalized). "Scores-as-impossible" therefore cannot be a kernel row; its implementable
  form is **conditioning the meta-belief on the denotation EVENT** (`Is`-evidence) — plus a
  well-formed **dummy row** for each dead hypothesis, because `cond`'s strict arithmetic
  demands the row even at weight −∞ (measured: an `error`-dummy crashes `cond`, is skipped by
  `push`). Omit the denotation-cond and the dummy **invents likelihood**: P(h_dead) after 8
  ticks = 0.263 instead of 0.
- With the denotation-cond in place: posteriors and predictives **bit-identical** to
  filter-at-enumeration at all 9 checkpoints and both predictive readouts (this world; measured
  equivalence, not a proven theorem).
- Filter-at-enumeration cost, measured: **2.9 µs per candidate — 3.3 ms for the whole
  1,169-sentence fragment**, once per enumeration.

**The builder's plan-stage recommendation (scores-as-impossible, to keep enumeration syntactic)
does not survive these numbers**: the posterior cannot tell the sinks apart, filtering costs
3.3 ms, and scores-as-impossible needs an `Is`-event plus dummy-row machinery that is fragile
under strictness. The evidence now favours **filter-at-enumeration**; the layer-coupling it buys
costs 3.3 ms and removes two shims. Re-presented, not ruled.

### 6.5 Shift-invariance and the negative-L boundary (E4): one claim died, a stronger fact replaced it

- **The builder's "per-column shift-invariance ⇒ finite L of any sign lawful" argument is FALSE
  as a bit-exact claim.** Measured: L vs L+c is bit-identical at **no** tested c (bern and
  walkOn columns; max |Δp| from 1.1e-16 at c=10⁻³ to 1.07e-14 at c=300). It survives only as an
  approximate invariance. (Transcriptions were anchored first: `fromBits∘L ≡ bernFast` 18/18 and
  `≡ walkOn` rows 648/648, bit-exact.)
- **What replaces it is stronger: the FROZEN engine already relies on negative finite L.** The
  shipped `ExpFam` node computes L = −η·T(y)/ln2, which is **negative in 4 of 18 cells** over
  the θ grid at η = logit θ (every θ > 0.5, y = 1) — executed through the real node: all 9 rows
  normalize NaN-free through `fromBits`. **A strict L ≥ 0 boundary would refuse 4 of 9 frozen
  ExpFam rows.** The NaN/−∞-only boundary is not a preference; it is the only one compatible
  with the frozen engine.
- The ulp cliff is real and sayable: 4 of 17 grid points have `exp(log x)/x > 1`, and the 6-node
  sentence `Neg(Log(Div(Exp(Log θ₀)))(θ₀))` computes L = **−2.2e-16** where mathematics says 0.
  Strict L ≥ 0 refuses it; the NaN/−∞ boundary passes it (verified through the (iii) validator).

### 6.6 Neg vs Sub k0 (E5): "no lawful posterior changes" is FALSE — the builder's own claim

- Atomic sweep over the 30 reachable values: `negate v` ≠ `0−v` bitwise at **exactly the three
  reachable zeros** (carrier 0 via `ToR`, position 0 via `Pos`, dormancy 0.0 via `Get`);
  bit-equal everywhere else.
- The refusal pair: `Div c (Neg y)` at y=0 is L = −∞ (**ill-formed class**);
  `Div c (Sub k0 y)` is L = +∞ (**lawful hard zero**). Different refusal classes, as argued.
- **The lawful pair, which the argument missed:** `Exp(Div c (Neg y))` vs
  `Exp(Div c (Sub k0 y))` — **both validated lawful** (executed through the (iii) validator),
  rows P(y=0) = 0.6045… vs **exactly 0**, and the two-hypothesis posterior after observing y=0
  is **[1, 0]**. Two lawful sentences, bit-different posteriors, differing **only** in
  `Neg` vs `Sub k0`. **Retiring Neg deletes lawful, posterior-visible expressive content that is
  reachable today.** (The retire case's premise, stated by the builder at the boundary, is
  falsified by the builder's own experiment.)
- The k0 dependency, scanned: **no frozen grid declares 0** (θ, ρ scanned; τ = 5…80 by
  provenance, Enumerate.hs:113). The only sayable +0.0 left-argument today is `Get`-dormancy.

### 6.7 The 19-vs-18 price impact (E6): zero strict inversions; anchors immune, hex-exact

- prodExpr **18 vs 19: 0 strict order inversions** over all 7.1M sentence pairs of the sweep.
  17,952 tie pairs form or break (consequential only where a frontier cuts an exact tie).
- 10 → 19 (the step-1 amendment itself): 39,416 strict inversions — the policy-pricer landscape
  genuinely moves, which is exactly why P5 mandates the pin re-pricing at the freeze.
- **Anchor immunity, executed hex-exact:** the model fragment's 1,169 dl values
  (sum hex `40d27582567af28a`) and the top-5 posterior after 20 fixed ticks are **bit-identical
  under prodTable 10, 18, and 19** — the fragment's derivation charges never read `prodTable`;
  no frozen anchor can move under either R-C2 outcome.
- Cost of keeping Neg, stated: lg 19 − lg 18 = **0.0781 bits/node** on every sentence.

### 6.8 The substrate question (E7, 2026-07-13): R-C5 — Decimal/MPFR/CReal vs binary64

Raised by the author with specifics (`rounded`/MPFR, `exact-real`/CReal), and the author
**corrected the builder's first-pass claim**: arbitrary-precision floats DO carry full
`Floating` with correctly-rounded transcendentals at any precision. That claim survives
only against Rational/Decimal, where it is demonstrated twice over: `log 2 :: Rational`
is a TYPE ERROR (no `Floating Rational`), and `1 % 0` CRASHES ("Ratio has zero
denominator") where `1/0 :: Double` is the *value* `Infinity` — exact types turn IEEE's
flowing, validatable values into exceptions at every division site. The remaining
questions were then **executed** (MPFR 4.2.2 via `rounded-1.1.1`, `exact-real-0.12.5.1`,
GHC 9.10.3; scratch project, discarded):

| | measured |
|---|---|
| **E7a — hazard classes vs precision** | MPFR carries NaN, ±∞, AND signed zero, identically at p = 53/128/512: `isNaN (0/0)` True, `1/(negate 0) = -Infinity`, `negate 0` negative-zero, `0−0` not. **Every R-C1 hazard class and the R-C2 sign-of-zero distinction recur verbatim at 512 bits.** The guard question is precision-invariant. |
| **E7b — the roundtrip cliff** | `exp(log x)/x ≠ 1` at **1498 / 1499 / 1461 of 10,006** sweep points at p = 53/128/512 — the cliff DENSITY is constant in precision; only its epsilon shrinks. The 17 frozen grid values still cliff at p=512 (5 of 17, 3 of them > 1, i.e. L < 0). **Strict L ≥ 0 cliffs at every finite precision.** |
| **E7c — lse shift-invariance** | Still fails at p=128 (max diff ~2e-37) and p=512 (~1.5e-153); one exactly-representable cell (c=1, p=512) came out equal — a representability fluke, not a law. The §6.5 structure persists at every precision. |
| **E7d — cost** | The 3-hypothesis posterior loop: **×52 at 128 bits, ×116 at 512** vs Double. The as-built 8.26 ms/tick warm replay and govhost's wall-cost rows are binary64 numbers. |
| **E7e — CReal comparison** | `exact-real`'s Eq/Ord are APPROXIMATE: at `CReal 64`, `2 == 2 + 2^-100` is **True** and `compare` answers **EQ** for two DISTINCT reals. Termination is bought by lying. CL-3's argmax tie-break and grid membership (`elemIndex`, the `mkC` discipline) become silently unsound. |

What no experiment can change: the executable specification (`proplang.py`) is binary64;
CLAUDE.md Phase 1 demands its streams **bit-for-bit**; the frozen `Belief.hs` header pins
ULP-level cross-language agreement; and test-code group 5 pins IEEE-754 facts as oracle
rows. A substrate migration re-opens the corpus AND the reference — a P5-route boundary,
never a step-1 shape. Note also: even MPFR at p=53 breaks anchor parity, because MPFR's
correctly-rounded `exp`/`log` differ from libm's faithful-but-not-correctly-rounded ones.

The strongest pro-MPFR argument, stated and answered: correct rounding is bit-reproducible
across platforms where libm binary64 is not — and the project's reproducibility is already
secured by the gate-7 toolchain freeze plus wire-level host conformance (engine contests
bind to the membrane wire, never GHC artifacts). If cross-platform engine-internal
reproduction ever becomes a demand, MPFR returns as a boundary proposal with this table as
its cost sheet. Recorded concession: the prior weights (products of 1/n) and the bern/walk
likelihoods are exactly rational; a Rational core for that fragment is conceivable and
dies at ExpFam, entropy, the wire's loss_bits, and step 1's arithmetic.

**R-C5 (the register row): the numeric substrate.** The builder's disposition, on the
table above: binary64 stands; precision buys smaller epsilons on pathologies the R-C1
guard turns into typed refusals, at ×52–116 measured cost, against the maximal re-open —
and the exact alternatives are structurally disqualified (Rational: no transcendentals,
crash-partiality; CReal: approximate equality). **The author rules.**

### 6.9 What the author now rules, on the numbers

- **R-C1 guard shape** — (i) 5 relocated error shims + 17 frozen sites / 3 files + an honest
  version needs `Kernel` changed too; (ii) a corpus-unobservable check whose only effect is a
  reachable runtime raise at 9.5 bits; (iii) 2+15 src lines, clean lib, 4 mechanical oracle
  amendments, validator executed on every class, and the `CondE`/ElimJ precedent already in the
  grammar. The builder's reading is still (iii), now with §6.1–6.3 behind it.
- **R-C1 ill-formed boundary** — NaN/−∞-only is **forced** by the frozen ExpFam rows (§6.5);
  strict L ≥ 0 is incompatible with the shipped engine and cliffs on a measured ulp.
- **R-C1 sink** — the posterior cannot distinguish the sinks (§6.4, bit-identical); the
  builder's earlier preference is reversed by the shim-and-cost measurements; the evidence
  favours filter-at-enumeration.
- **R-C2** — the retire case's "no lawful posterior changes" premise is falsified (§6.6);
  keeping Neg costs 0.0781 bits/node and flips **no** strict ordering (§6.7). The basis ruling
  (the IEEE-754 required-op set + pinned-libm transcendentals) remains available as the grounds
  that ends per-operator litigation, now with the measured witness that Neg is not sugar.
- **R-C5** — the numeric substrate (§6.8): binary64 stands, or a substrate migration is
  ordered as a P5-route boundary proposal with E7's table as its cost sheet. The exact
  alternatives (Rational/Decimal, CReal) are structurally disqualified by demonstration;
  MPFR reproduces every hazard class at every precision at ×52–116 measured cost.
- **The sink, sharpened by E1's tick-dependence** — validation is per-tick at kernel
  construction (the `stepHyp` site); a hypothesis whose code fails to denote at an
  observed tick asserted the impossible there and is refuted permanently (evidence-shaped
  zero; dormancy is for absent NAMES, never for likelihood failure). Falsifier row queued
  for group 7: a code ill-formed at t=0 and lawful at t≥1 is dead from tick 0 onward.
- **The Space-points reader** — `Code`/`Pos` evaluation needs one and the frozen `Belief`
  export list has none: a one-name gate-2 export amendment (`spacePoints` — `Space` is
  the point list `mkSpace` was given; nothing sealed leaks) vs point-carrying payloads
  (changes Code/Pos arities, re-touches oracle rows). The builder's reading is the export
  amendment; the author rules at the freeze.

### 6.10 RULED (the author, 2026-07-13) — all six, on the evidence above

The author ruled in one sitting, each ruling against its measured section; recorded verbatim
by the builder the same day. **These are the rulings the freeze enacts.**

1. **R-C5 — binary64 stands.** The substrate question is CLOSED on §6.8's table: MPFR
   reproduces every hazard class at every precision at ×52–116 measured cost; the cliff
   density is constant in precision; CReal's Eq/Ord are approximate; Rational/Decimal are
   structurally disqualified. A future migration, if ever demanded, is a P5-route boundary
   proposal with §6.8 as its cost sheet.
2. **R-C1 shape — (iii).** `Code`'s codomain becomes `Expr env (Maybe (K a b))`, eager
   validation at eval; the `CondE`/ElimJ precedent applied to codes. `fromBits` and
   `Kernel` stay frozen as shipped; `Belief.hs:101-103` remains a theorem.
3. **R-C1 boundary — NaN/−∞-only, confirmed.** A code column is refused exactly on NaN or
   −∞ entries; every L in [0, +∞] denotes (hard zeros and negative-by-ulp L included) —
   the only boundary compatible with the frozen ExpFam rows (§6.5).
4. **Refutation semantics — per-tick denotation conditioning, confirmed.** Validation
   happens at kernel construction each tick; a hypothesis whose code fails to denote at an
   observed tick asserted the impossible there and is refuted PERMANENTLY (an
   evidence-shaped zero). Dormancy remains reserved for absent NAMES. Filtering
   tick-independent codes at enumeration stays legal as an optimisation — it exploits
   structure and never lives in the prior (§1b's law; §6.4 measured the mechanisms
   bit-identical where both apply). Binds step 3's integration; group 7 pins the
   eval-level half now.
5. **R-C2 — Neg stays; prodExpr 19.** Retiring Neg would delete measured, reachable,
   posterior-visible content (§6.6's lawful pair, posteriors [1, 0]); keeping it costs
   0.0781 bits/node and flips no strict ordering (§6.7). Group 5's sign-of-zero row
   STANDS. The freeze absorbs `ProdTable 19 2 1 2 7 1`.
6. **The Space-points reader — the gate-2 export amendment.** `spacePoints` joins the
   frozen `Belief` export list at the freeze (typed-port-spec S2 amended by the author's
   tag; one name; `Space` is the point list `mkSpace` was given; the weights stay sealed).
   Point-carrying payloads are rejected.

Freeze-item delta (extends §3's four items, same delegation, same R-D22 re-tag):
item 5 — the `spacePoints` export line (`Belief.hs` export list + typed-port-spec S2);
item 6 — the AGENT_PLAN §8 survivor-list amendment (R-C3; the author already ruled the
disposition: PORT the anchors — they ARE the proof).

### 6.11 R-D21 satisfiability transcript — group 7 (the ruled rows), executed 2026-07-13

The amended oracle (`Code`'s `Maybe` codomain at 4 signature sites; group 7's seven rows)
compiles clean under the stanza's exact flags and runs **45/45 runtime-red** — every red
demonstrated to be the missing implementation (`PropLang.Eval: Code is oracle-phase
surface`) or the freeze-pending `prodTable` (group 6's kerB row: got lg 1 + lg 10 + lg 2,
expects the 19/2 table). The ten frozen suites stay green; manifest 81/81.

Every group-7 asserted quantity, executed once against the throwaway (iii) prototype,
mirrored 1:1 from the oracle text (same expressions, same envs, same grid indices);
prototype discarded:

```
== R-D21 transcript: test-code group 7, row by row ==
  row 1  Log (Get t) @ t=0            : Nothing (REFUSED)
  row 2  Neg (Log (Get t)) @ t=0      : Nothing (REFUSED)
  row 3  Log (Log theta0)             : Nothing (REFUSED)
  row 4  Neg(Log(Div(Exp(Log th0))th0)): Just (DENOTES)
  row 5  hard-zero code: Just; P(y=1) = 0000000000000000 (assert 0), P(y=0) = 3ff0000000000000 (assert 1)
  row 6a Log (Get t) @ t=0            : Nothing (REFUSED)
  row 6b Log (Get t) @ t=5            : Just (DENOTES)
  row 7  both DENOTE; Sub P(y=0) = 0000000000000000 (assert 0), Neg P(y=0) = 3fe3508c5d030c55 (assert > 0)
  row 7  posterior after y=0: P(h_neg) = 3ff0000000000000 (assert 1), P(h_sub) = 0000000000000000 (assert 0)
```

Every exact-value assertion in the group (the hard zero, the survivor's full mass, the
posterior pair) is satisfied **bit-exactly** — `+0.0` and `1.0` on the nose, no tolerance
anywhere. The refusal rows refuse; both per-tick verdicts land as ruled; both lawful-pair
sides denote and their posterior is the measured `[1, 0]` of §6.6.

### 6.12 Phase B, executed under the recorded delegation (2026-07-13) — the freeze awaits your tag

Delegation of record: the author's custody ruling for this increment's freeze edits —
**"Delegate to builder + you re-tag"** — plus §6.10's freeze-item delta (items 5–6). Per
R-D22 the increment does not close until your own signed tag covers the oracle as amended.
**Nothing below is binding until that tag exists.**

The ledger, item by item (every edit adjudicated by the engine on a scratch copy FIRST,
then applied to the repo verbatim):

1. **Stanza applied** — `test-suite code` → `proplang.cabal`, from the draft, with the
   delegation noted in the stanza comment.
2. **`prodTable`** — `ProdTable 10 2 1 1 7 1` → **`ProdTable 19 2 1 2 7 1`** (the P5
   single site, `Syntax.hs`).
3. **EXPR pins re-priced** — **47 nodeB occurrences moved `lg 10` → `lg 19`** across 8
   suites + 3 sayable fixtures (assertions AND test-name strings — a frozen name that
   misdescribes its assertion is R-C3's disease). The one classified exception:
   `SayableP.hs:190`'s per-Var **scope mention stays `lg 10`** (ten Vars each price
   nodeB + lg 10-scope; the assertion now reads `10 * (lg 19 + lg 10)` and the engine
   confirms it to 1e-12).
4. **FINDING — §3's enumeration was INCOMPLETE.** The "39 `lg 10` hits" enumeration
   missed the **KER sort's own pins**: three rows asserting *"ExpFam node prices at 0
   (every choice forced)"* — written as the literal `0`, invisible to any lg-grep
   (`test-expfam/ExpFam.hs:133`, `test-govhost/GovHost.hs:228`, `test-d/D.hs:298`).
   With `Code` joining the sort the choice is no longer forced; kerB moves lg 1 → lg 2
   exactly as test-code group 6 declares. Re-priced to `lg 2` with truthful names under
   the same P5 clause — *"the enumerated frozen pins of the changed sort"* — the sort's
   enumeration now actually complete. Surfaced here rather than smoothed over: the
   under-count was the builder's, in this pack's own §3.
5. **`spacePoints`** (§6.10 item 6) — the function + export in `Belief.hs`, the row in
   `audit/belief-exports.txt` (22 items), the list in typed-port-spec §2, each carrying
   the amendment note. Gate 2: **CLEAN**.
6. **AGENT_PLAN §8** (§6.10 item 6 / R-C3) — the false survivor list replaced by the
   measured register; the ruled disposition (*PORT the anchors — they ARE the proof*)
   now stated where the falsehood stood.
7. **`MANIFEST.sha256`** — 12 rows recomputed, 2 added (`test-code/Code.hs`,
   `test-code/stanza.cabal.draft`): **83 rows, verifies 83/83.**

Verification at the freeze commit: gates 1–4, 6, 7 **PASS** (gate 2 clean on the amended
list; ablation attribution intact); gate 5 = the ten pre-existing suites **PASS** and
`test-code` runs **39/45 runtime-red by design** — group 6 (the price pins) went green
the moment `prodTable` landed, and the 39 reds are exactly groups 1–5 and 7, each red on
`PropLang.Eval: ... oracle-phase surface, not yet implemented`.

**Your act, from your own shell** (R-D22; the tag, not any commit signature, is the
attestation):

    git tag -s code-freeze-r0 -m "step-1 oracle freeze: the likelihood is a code; \
the six rulings of pack 6.10 enacted; delegated freeze edits reviewed and countersigned" \
<freeze-commit>

From that signature, `test-code/` is as frozen as `test/`, and Phase C (implementation)
begins.

### 6.13 The author's review of the freeze package (2026-07-13) — three items, enacted

The author reviewed §6.10–6.12 and returned three items, one a genuine block, plus
endorsements for the record. All three are enacted below, inside the same delegation
window, and the tag now points at the commit that carries them.

**1. `ToR` was an undeclared alphabet change (BLOCK — enacted).** The signed §5b said
EXPR 20; the +1 is `ToR`. §5d recorded the *defect* (Pos does not subsume Stats/SId),
and §5b's table carries the count correction — but OPEN 6's resolution ("index or
value?" → **both, two productions**) had never been recorded as a **ruling**, and `ToR`
carried no deletion proof — an alphabet member without one, against the law's own
demand. Enacted: §9 OPEN 6 now carries the ruling clause (the resolution stands as an
AUTHOR ruling at code-freeze-r0; the 20 → 21 delta is a DECLARED change); §5b's
primitivity audit gains `ToR`'s entry with the author's one-line proof — **value is not
derivable from index without a grid-indexing production, just as index is not derivable
from value on the FP-nonuniform grids** — with test-code group 4 as the executed
witness; R-C4 above carries the visible correction. (§5b's `Code` signature block was
also stale against ruling (iii) — the Maybe codomain and the ruled boundary are now
stated there, flagged here for the review.)

**2. The registers reconciled (enacted).** §9 OPEN 4 and OPEN 5 were still open in the
frozen plan while §6.10's rulings closed them — a frozen text misdescribing the state,
the same disease Phase B item 3 corrected in test names. Both rows now carry their
strikethrough + RULED clauses with the evidence pointers (OPEN 4 → §6.10 items 2–3 and
the forced boundary; OPEN 5 → item 5 and the [1, 0] lawful pair).

**3. Ruling 4 sharpened by one clause (enacted, queued against step 3).** "Fails to
denote at an OBSERVED tick" — refutation is conditional on an observation actually
arriving on the code's channel at that tick; **silence never refutes**. Without the
clause, construction-time validation would kill hypotheses about intermittent sensors
for failing to predict an event that never occurred. Now a named obligation at build
order step 3, beside two falsifier rows: the t=0/t≥1 permanence row (eval half pinned in
group 7) and the silent-tick survival row.

**Endorsements recorded at the review:** the NaN/−∞-only boundary is forced, not
preferred (frozen ExpFam computes negative finite L in 4 of 18 cells; strict L ≥ 0 was
never available). R-C5 is properly closed (E7a kills "precision fixes it" permanently;
E7e's approximate `Eq` — "termination is bought by lying" — ends the CReal road at
CL-3's tie-break). And the consonance now recorded at step 3 so nobody later "fixes" it:
transcript row 5 makes a certainty KERNEL sayable where the old lattice made certain
PARAMETERS unsayable — no conflict, **Cromwell lives in the mixture, not the member**; a
dogmatic hypothesis is one contrary observation from a permanent zero, ruling 4 applied
to itself.

### 6.14 STOP AND REPORT (Phase C, 2026-07-14): frozen group 3 is unsatisfiable as written

**The frozen test appears wrong; the builder stops.** Phase C's implementation went in
(the ruled validator, `Pos`, `ToR`, the seven ops — src only) and the frozen oracle
adjudicated: **36/45 green; the 9 reds are exactly group 3**, and their failure is not in
the implementation.

**The smallest reproducing detail.** Group 3's rows push
`point thetaSpace eta` with `eta = logit θ`. `point` (frozen, `Belief.hs:139-141`)
weights `negInf` at every grid point `p /= x`, and **`logit θ` is never a member of
`thetaPoints`** (logit maps the grid into ℝ; even logit 0.5 = 0.0 is off-grid) — so the
point mass has no mass, and `orImpossible "point"` raises (`Belief.hs:105`) **on both the
frozen and coded sides, before any assertion runs**. No implementation can satisfy the
row; the crash is upstream of everything this increment built.

**Why the freeze did not catch it — two mechanisms, both owned.**
(a) *Stub masking:* at the freeze, `codedK` is forced before the lazy `frozen` thunk, so
group 3's red presented as `PropLang.Eval: Code is oracle-phase surface` — the expected
red, hiding the point-crash behind it. (b) *Transcript/row drift:* §2's R-D21 row
("expfam | ExpFam at η = logit θ | **9/9 BIT-EXACT**") is true of what the oracle-phase
prototype executed — which used an **eta-containing domain** — while the row as drafted
pushes through `thetaSpace`. The transcript did not match the row that froze. That is
precisely the failure R-D21 exists to prevent, and it is the builder's breach to record:
**a transcript line proves satisfiability only of the expression actually frozen.**

**The fix candidate, executed, not argued.** The frozen corpus already contains the
correct idiom — `test-expfam`'s `genericAt` (`ExpFam.hs:90-98`), whose own comment reads:
*"build the family kernel over a domain **containing eta**, then apply it by pushing the
point mass at eta."* The two-line amendment (both push sites gain `etaSp = mkSpace
(eta :| [])`):

```haskell
          etaSp  = mkSpace (eta :| [])
          frozen = push (point etaSp eta) (eval0 frozenExpFam)
          ...
      let coded = push (point etaSp eta) codedK
```

Scratch-verified against the live implementation: **45/45 PASS**; the ten frozen suites
are untouched by the amendment. The row's intent (frozen `ExpFam` vs the coded expfam,
bit-for-bit at each η) is unchanged — only the broken push mechanism moves, to the
corpus's own precedent.

**Disposition — the author's.** The amendment is a frozen-oracle edit: a re-open of the
step-1 freeze, by you or under a fresh per-instance delegation, followed by your re-tag
(R-D22). The builder has applied NOTHING to the frozen file and holds at 36/45.
