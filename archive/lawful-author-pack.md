# The lawfulness floor — author pack

*Builder-assembled freeze package for the `test-lawful/` increment. Unfrozen
until the author's tag. Custody: the builder signs its own commits with the
builder key; this increment becomes binding only when the author countersigns
the freeze commit with a signed tag from their own shell (CLAUDE.md, Custody).*

Status at assembly: oracle written, compiled clean under the gate flags, green
across **two sibling suites** (`lawful` 16/16, `lawful-independence` 7/7) and
the seeded-defect red run executed (every row fires). Nothing frozen has been
touched. `src/` is byte-unchanged (this is a **pin-freeze** — see Part 0).

---

## Part 0 — what this increment is (the pin-freeze framing)

The lawfulness floor certifies that **proplang obeys its own foundational
laws** — and it does so *natively*: every law's truth is determined by
**running proplang over proplang's own objects**, never over synthetic
Haskell beliefs. It adds no `src/`. It is therefore a **PIN-FREEZE** in the
CLAUDE.md sense ("an increment that pins an already-shipped fast path OR
CAPABILITY, where no implementation is owed") — the same shape as step 10
(reflexive-freeze-r0) and step 2 (optlaw): pin the shipped thing to the
reference route; seeded defects for the red.

- **Reference route** = the mathematical laws (normalization, linearity,
  monotonicity, Kraft; total expectation, marginal likelihood, chain rule,
  order-independence; `fromBits` as the only prior).
- **Shipped thing** = the sealed reasoner (`PropLang.Belief`) and the agent's
  own MDL machinery (`PropLang.Enumerate`), exactly as they ship at HEAD.
- **No implementation owed.** The red-run clause is satisfied by a
  **seeded-defect demonstration**: every row's red is reachable, attribution
  partitioned (Part VI).

Frozen files this increment adds (3): `test-lawful/Lawful.hs`,
`test-lawful/Independence.hs`, `test-lawful/stanza.cabal.draft`. The draft
declares **two sibling suites** — `lawful` (satisfaction; `main-is: Lawful.hs`)
and `lawful-independence` (the irreducibility meta-property; `main-is:
Independence.hs`) — per the author's ruling of 2026-07-24 that two stanzas read
clearer than one suite carrying the other as an `other-module`. Both mains are
`module Main` sharing `hs-source-dirs: test-lawful`; `cabal build all` compiles
each as its own component (neither imports the other), and the frozen
prefreeze-lint L7 leaves both to cabal (each `import`s `Test.Tasty`). This
matches the pure-pin-freeze precedent (test-reflexive, test-optlaw, test-code
ship only `<Name>.hs` mains + stanza — no runner, no ablation): the floor is
not process-level (no `red-run.sh` runner needed) and carries no deletion
ablation (no `ablation/run.sh` — it pins existing behaviour, it does not prove
a terminal deletable).

The alphabet does not move. `prodTable` is untouched. A capability is pinned;
the language is the same size.

---

## Part I — the native method (dogfooding)

The floor inspects **only proplang's own beliefs**:

| object | how it is produced | site |
|---|---|---|
| the corpus of sayable sentences | `enumerateSentences fragFull` (1169 sentences) | Enumerate.hs:369 |
| the agent's own MDL prior over them | `agentMeta = fromBits isp (hypBits!!)` | Enumerate.hs:674, :755 |
| the one-tick predictive | `predictive feats sub = push meta k` | Enumerate.hs:706 |
| the polling step | `observe = logPredict; cond` | Enumerate.hs:732 |

**Sayability is enumerator-determined; truth is evaluator-determined.** The
floor asserts nothing about beliefs no sentence can produce. This is the
reflection move (Coq's `vm_compute` over a procedure); here the procedure is
unverified, so it is *validation, not proof* — the honest tier, with the
external trusted base shrunk to R-C5 (GHC's binary64 == the host's).

The suite is **deterministic**: no QuickCheck, no seed. Every quantified row
folds over a DECLARED domain (subset pairs; the distinct bit-groups the corpus
actually has; the whole corpus × an environment battery), so the frozen
artifact computes bit-identically every run — only tasty's cosmetic timing
text varies.

---

## Part II — the two-tier law structure and the honest count (mandate 1)

The floor tests eight laws. **Four are irreducible axioms of the structure;
four are theorems of it.** Naming all eight "primitive" would install four
theorems as primitives — the Savage shape, red-team mandate 1 ("is any
theorem installed as a definition?"). This pack answers it explicitly, and
`Independence.hs` mechanizes the answer (Part III).

**L-core (L1–L4): the irreducible axioms**, exhibited on proplang's OWN meta
belief.

| law | statement | the proplang object it runs on |
|---|---|---|
| L1 normalization | `E[1] = 1` | `agentMeta` fresh + after an `observe` battery |
| L2 linearity/additivity | `prob` additive over disjoint sayable events | `prob` on `meta0` over declared subset pairs |
| L3 monotonicity | `A ⊆ B ⇒ prob A ≤ prob B` | `prob` on `meta0` over declared subset pairs |
| L4 Kraft (the prior) | `p_i/p_j = 2^(bits_j − bits_i)` | `agentMeta = fromBits (hypBits!!)` |

**L-seal (L5–L8): conformance theorems**, each derived from the core plus one
named sealed operation's definition, and each *tested by running that
operation*. The derivations (copied byte-wise from `src/PropLang/Belief.hs`,
R-D20-i, Part V):

- **L5 total expectation** — theorem given L2 + `push` = the marginal
  (Belief.hs:181-189). `expect (push b k) g = expect b (\x -> expect (fx x) g)`
  is finite Fubini; the only thing it *tests* is that the sealed `push`
  realizes the marginal. **Optimisation-law shape** (a specialized `lse` route
  pinned to the general `expect`-twice route).
- **L6 logPredict = log marginal** — theorem given the `lse` path
  (logPredict, Belief.hs:209-211) and the sum-of-exp path (`expect . prob`)
  are two independently-coded summations of the same number. **Optimisation-law
  shape.**
- **L7 chain rule** — theorem given `cond` = Bayes-multiply-then-renormalize
  (Belief.hs:204-205) and `1_A · 1_B = 1_{A∧B}`. Sequential = joint *exactly*
  (a normalize-then-normalize composes to one normalize).
- **L8 order-independence** — corollary of L7: likelihood factors commute under
  real multiplication. L8a is the belief-level statement (two `Saw`
  evidences); L8b the tick-order statement over the exchangeable fragment.

**The honest count** (why the seal is *tested* but *not called primitive*): L7
and L8 both reduce to one sealed fact (`cond` = likelihood-product then
renormalize), so the seal's four rows pin **three** sealed operations —
`push`, `logPredict`, `cond` — none of which is an axiom; all are conformance
facts about the opaque implementation. That is why they are tested (the seal
could violate any of them) and not called primitive (each is a theorem of the
core-four plus its definition).

*(This is the pre-existing "8 primitive laws" mislabel, caught by the author
with one question — "which of these are axioms and which are theorems?" — and
corrected here. The full L5–L8 derivations are in the working register,
`lawful-register.md` §II, folded from Belief.hs with file:line.)*

---

## Part III — the core four are irreducible (3 + 1, not four peers)

Independence is a meta-property of the AXIOM SYSTEM, proved with abstract
**separating witnesses** — some deliberately NOT proplang beliefs (a signed
functional is the whole point). `test-lawful/Independence.hs` mechanizes it:
if any core law were derivable from the others, its witness could not exist and
its row would go red. The honest structure is **3 + 1**, not four uniform
peers — a correction the machine forced (a mandate-1 imprecision that was
hiding *inside* the mandate-1 answer):

**L1–L3 — the eliminator triple (Riesz)** — constrain the `expect` functional
and are mutually independent *among themselves*: each has a functional witness
satisfying the OTHER TWO eliminator laws and failing its own.

| law | separating witness (satisfies the other two eliminator laws, fails this one) |
|---|---|
| L1 | `E'(g) = 2·E(g)` — linear, monotone, but `E'(1)=2` |
| L2 | `E'(g) = max_x g(x)` — normalized, monotone, not linear |
| L3 | signed weights `(2,−1)`: `E'(g)=2·g(0)−g(1)` — normalized, linear, not monotone |

**L4 — the introducer law — is separated differently**, and this is the
correction. L4 constrains the `fromBits` *introducer* (Belief.hs:159-162), not
an arbitrary eliminator-functional. Its witness is therefore an *introducer*
witness: `uniform sp3` over a space with varying description lengths is a
genuine measure (it satisfies L1, L2, L3) yet `p_x/p_y = 1 ≠ 2^(dl_y−dl_x)`,
so it **violates Kraft**; while `fromBits sp3 dl` obeys it.

**Why L4 is not a fourth peer** — a *reductio* that fixes the reading of L4,
not a claim that L3 is really redundant. Two readings of "L4":

- **per-functional (rejected):** "*this functional's own* weights obey Kraft."
  Under it, `{L1,L2,L4} ⇒ L3` — Kraft ratios `2^k` are strictly positive, so a
  positive normalized linear functional is automatically monotone and L3 falls
  out for free. It is absurd for "every belief's `expect` is monotone" to be a
  corollary of a statement about *one prior's* weights — so the collapse *is*
  the proof that this reading is wrong.
- **introducer (correct):** "*`fromBits`* produces Kraft weights." This
  constrains one operation's output, says nothing about an arbitrary belief's
  `expect`, and cannot force monotonicity on anything. L3 is independent.

The two implications point in opposite directions and never conflict:
`{L1,L2,L4} ⇒ L3` (only under the rejected reading) is an implication *into*
L3; the operative independence fact is `{L1,L2,L3} ⇏ L4` — the
`uniform`-over-varying-`dl` witness satisfies L1–L3 and violates Kraft. **The
count stays four.**

*This section was reviewed and signed off by the author, 2026-07-24.*

---

## Part IV — the anti-vigilance mechanizations ("why did I have to point it out?")

The author caught two foundational mislabels by eye this cycle: (1) "8
primitive laws" that were 4 axioms + 4 theorems; (2) an A-block that froze a
membrane **defect** as a green law. Both share one shape — *pattern-matching
on surface form, skipping the definitional check the artifact's name demands* —
and the first lesson filed too narrowly to catch the isomorphic second. The
directive: **the catch must not depend on human vigilance.** So each
error-class is converted into a suite fact.

**Catch 1 — theorem-as-axiom → `Independence.hs` (executed).** "Four
irreducible laws" is no longer a claim; it is a 7-row red/green fact. If any
core law were a theorem of the others, its separating witness could not exist
and its row goes red. Mechanizing it is what *forced* the 3 + 1 correction
(Part III) — the machine found the imprecision the eye had missed twice.

**Catch 2 — defect-as-green → two floor invariants.** The A-block asserted a
single computed point equal to a same-way-computed expected constant, over a
membrane behaviour that is a **defect** (absent `'t'` silently resolves to
`t=0`; measured extent 360 sentences). It is **removed from the floor** — a
lawfulness floor certifies only truths — and re-homed to the 1b membrane
increment, whose oracle will assert the CORRECT behaviour (red-then-green as
the fix lands). In its place, two invariants are stated in `Lawful.hs`'s
header and enforced:

- **(i) every law row is a UNIVERSAL over a NON-EMPTY proplang-derived
  domain, never a single point.** A universal over an empty domain is a green
  that cannot fail (the two-run-triptych clause). So every quantified row
  **asserts its domain non-empty in-line**, before the fold: L4 (`reps`,
  `samePairs`), L5/L6 (`rows`), L8b (`stateless`), S (`corpus`, `envBattery`).
  *This is the mechanized half* — the guard goes red the instant the grammar
  empties a domain (Part VI shows every domain's live size: `|corpus|=1169`,
  `|reps|=3`, `|samePairs|=3`, `|stateless|=1161`).
- **(ii) every equality relates two INDEPENDENTLY-COMPUTED proplang
  quantities** (two routes to one number: predictive-vs-tower,
  logPredict-vs-expect, seq-cond-vs-conjunction-cond, uniform-vs-fromBits),
  never a computed value against a baked expected constant. The only bare
  literals are the LAW-DEFINING constants (1 = total mass; 2 = the Kraft base)
  and the derived tolerance — no expected OUTPUT is hardcoded. *This is the
  reviewable half* — each equality's two sides are visibly two different
  computations. A bug in either route is caught by disagreement with the
  other.

The defining-question pass that surfaced Catch 2 (state what each block
certifies and run it over EVERY element, loudest on any "no") is recorded as
the standing pre-freeze gate in the working register (§IV note 5).

---

## Part V — provenance (copy-not-reconstruct, R-D20-i), re-checked at HEAD

Every derivation in Part II quotes its definition **byte-wise** from
`src/PropLang/Belief.hs`. Line numbers re-verified at HEAD at assembly time
(2026-07-24):

| symbol | HEAD line | used by |
|---|---|---|
| `mkBelief` (normalizer) | Belief.hs:108-113 | all |
| `fromBits` (the only prior) | Belief.hs:159-162 | L4, D |
| `expect` | Belief.hs:170-172 | all |
| `prob` | Belief.hs:175-176 | L2, L3, L4, S |
| `push` (= the marginal) | Belief.hs:181-189 | L5 |
| `loglik` (Is / Saw) | Belief.hs:195 / 196-199 | L7 / L8 |
| `cond` (Bayes-multiply-renormalize) | Belief.hs:204-205 | L7, L8 |
| `logPredict` (= log marginal) | Belief.hs:209-211 | L6 |
| `agentMeta = fromBits isp (hypBits!!)` | Enumerate.hs:674, :755 | L1, L4 |
| `predictive = push meta k` | Enumerate.hs:706 | L5 |
| `observe = logPredict; cond` | Enumerate.hs:732 | L1, L6, L8b |
| `stepSent` (one-tick predictive) | Enumerate.hs:688-700 | L5 (reconstruction) |

All references resolve exactly at HEAD.

---

## Part VI — the two-run evidence (the triptych, both directions)

"A green that cannot fail is the mirror image of the red that cannot fire."
The floor's two-run structure is load-bearing in BOTH directions.

### VI.1 — the SATISFIABILITY (green) run

Both suites compiled and run under the **stanza's exact flag set** (SAT
flag-faithfulness, the step-5 amendment: FLAG-faithful, `-Werror` included).
Each `main-is` file is compiled as its own `module Main` (exactly the build
`cabal build all` performs per component):

```
cabal exec -- ghc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
  -XGHC2021 -isrc -itest-lawful -outputdir <out-l> -o <out-l>/lawful       test-lawful/Lawful.hs
cabal exec -- ghc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
  -XGHC2021 -isrc -itest-lawful -outputdir <out-i> -o <out-i>/independence test-lawful/Independence.hs
```

(`-XGHC2021` supplies the stanza's `default-language: GHC2021`; `DataKinds` is
a file pragma in both modules.) Results:

```
=== cabal test lawful  (main-is Lawful.hs) ===
lawful (the native lawfulness floor)
  L: the laws of the sealed reasoner
    L-core: the irreducible laws, on proplang's own beliefs
      L1 native: the agent's own meta is normalized (fresh + after ticks):              OK
      L2 native (finite additivity of prob over disjoint sayable events):               OK
      L3 native (event monotonicity: A subset B => prob A <= prob B):                   OK
      L4 native (Kraft on the real hypBits): p_i/p_j = 2^(bits_j - bits_i):             OK
      L-red (the seeded-defect mirror): an unnormalized total trips near:               OK
    L-seal: conformance checks, by running proplang's own operations
      L5 native (push = marginal): predictive = the tower over the stateless fragment:  OK
      L6 native (logPredict = log marginal): observe's score = the marginal likelihood: OK
      L7 native (chain rule on the real meta): cond;cond Is = cond Is-conjunction:      OK
      L8a native (belief-level order): two fixed Saw evidences commute on meta0:        OK
      L8b native (tick-order independence on the exchangeable fragment via observe):    OK
      native-red (the comparator's teeth): sameBelief separates proplang's own beliefs: OK
  S: every sayable sentence denotes-or-refuses
    the whole corpus x the environment battery is lawful (0 unlawful):                  OK
    S-red (the seeded-defect mirror): a non-distribution is unlawful:                   OK
  D: fromBits is the only prior (extensional, on declared spaces)
    uniform sp = fromBits sp (const (Bits 0)) on thetaSpace and obsSpace:               OK
    point sp x = fromBits sp (0 at x, +inf elsewhere) on thetaSpace:                    OK
    D-red (the seeded-defect mirror): a non-flat 'uniform' diverges:                    OK

All 16 tests passed

=== cabal test lawful-independence  (main-is Independence.hs) ===
independence (the core four are irreducible)
  Riesz triple: L1,L2,L3 separated among the eliminator laws
    wL1 fails L1, satisfies L2 & L3:                               OK
    wL2 fails L2, satisfies L1 & L3:                               OK
    wL3 fails L3, satisfies L1 & L2:                               OK
  introducer: L4 separated from the eliminator laws
    the Kraft prior obeys L4 (the law is satisfiable):             OK
    uniform is a valid measure (L1-L3) yet fails L4 on varying dl: OK
  register correction (why 3+1, not 4 peers)
    the signed (2,-1) L3-witness cannot 'satisfy L4' as a measure: OK
  red mirror: a genuine measure passes every eliminator law:       OK

All 7 tests passed
```

### VI.2 — the SEEDED-DEFECT (red) run — every row CAN fire

The pin-freeze red-run clause. A throwaway harness (discarded prototype, R-D21;
kept in scratchpad as `lawful-red-harness.hs`, compiled under the identical
flag set) reproduces each row's comparison and seeds a defect in ONE side,
showing the predicate flips green→red. **Attribution is partitioned**: each
row's red is caused by its own seeded perturbation, never a shared defect.

```
== INDEPENDENCE rows (abstract separating witnesses) ==   [seed = swap the witness]
  wL1 fails L1               green=True red(seeded)=False
  wL1 satisfies L2           green=True red(seeded)=False
  wL1 satisfies L3           green=True red(seeded)=False
  wL2 fails L2               green=True red(seeded)=False
  wL2 satisfies L1           green=True red(seeded)=False
  wL2 satisfies L3           green=True red(seeded)=False
  wL3 fails L3               green=True red(seeded)=False
  wL3 satisfies L1           green=True red(seeded)=False
  wL3 satisfies L2           green=True red(seeded)=False
  Kraft obeys L4             green=True red(seeded)=False   [seed = target base 2.5]
  uniform fails L4           green=True red(seeded)=False
  eBase satisfies L1         green=True red(seeded)=False
  eBase satisfies L2         green=True red(seeded)=False
  eBase satisfies L3         green=True red(seeded)=False
== L-core native rows ==
  L1 fresh meta =1           green=True red=False   [a=1.000000000000012 aSeed=1.000001 b=1.0]
  L1 posterior meta =1       green=True red=False   [a=0.9999999999999853 aSeed=1.000001 b=1.0]
  L2 additivity              green=True red=False   [a=0.9818655.. aSeed=0.9916841.. b=0.9818655..]  (seed pab*1.01)
  L3 monotone                green(pA<=pB)=True red(reverse pB<=pA)=False   [pA=0.0363636.. pB=0.1090909..]
  L4 Kraft (seeded base)     green(near ratio 2^)=True red(near ratio 2.5^)=False
== L-seal native rows ==
  L5 predictive=tower        green=True red=False   [a=0.5000000000000001 aSeed=0.5050.. b=0.4999..]  (seed tower*1.01)
  L6 exp lp = marginal       green=True red=False   [a=0.4999.. aSeed=0.5249.. b=0.4999..]  (seed marg*1.05)
  L7 seq=conjunction         green(same a b)=True red(same aSeed b)=False   (seed = drop 2nd cond)
  L8a Saw commute            green(same a b)=True red(same aSeed b)=False   (seed = one observation)
  L8b tick-order             green(m12==m21)=True red(m12==m1)=False        (seed = one-tick posterior)
== S / D native rows ==
  S okProbs                  green([.5,.5])=True red([.6,.6])=False red([NaN,.5])=False
  D uniform=fromBits0        green=True red=False   [a=0.4999.. aSeed=0.4540.. b=0.4999..]  (seed = non-flat fromBits)
== NON-VACUITY: invariant-(i) guarded domain sizes (>0 required) ==
  subsetPairs = 8 (literal)   |corpus| = 1169   |envBattery| = 8 (literal)
  |reps| = 3   |samePairs| = 3   |stateless| = 1161   |rows(t=0)| = 1161
  guard fires on empty: not (null ([]::[Int])) = False
```

Every green row is proven to CAN-fire; every guarded domain is proven live and
would trip its guard if it emptied. The suite's own `*-red` rows (L-red,
native-red, S-red, D-red, "red mirror") are the comparators' built-in teeth,
green-by-construction because they *assert* a defect is caught.

### VI.3 — tolerance provenance (CL-4 doctrine: a gate is a measurement)

`tol = 1e-12`. Measured worst-case relative residual across every native
comparison in the floor is **2.98e-14** (the L5 tower over the 1161-row
stateless fragment; all else ≤ ~1e-15) — 1e-12 is ~33× above it and coincides
with the frozen `Properties.hs` (CL-4) tolerance: one tolerance across the
oracle suite, never a round guess. (Harness: `ResidMeasure.hs`, scratchpad.)

---

## Part VII — frozen-layer inventory (the step-7 clause)

Every boundary sitting receives an inventory of frozen prose the increment's
rulings or measurements have falsified. **This increment falsifies no frozen
prose.** It adds a suite; it changes no `src/`, no spec, no membrane wire, no
prior close-date document. The one behaviour it *declines to certify* (the
absent-`'t'` → `t=0` membrane defect) is a KNOWN defect already scoped to the
1b membrane increment; the floor is deliberately silent on it (never
reassuring about it — the `Lawful.hs` trailing note says so explicitly), so
no frozen sentence is contradicted. Inventory: empty.

---

## Part VIII — standing-clause status

- **prefreeze-lint** (mandatory before every freeze tag): run at assembly
  (pre-extension snapshot below) and again by the author as the final gate
  after the stanza + manifest land. Pre-extension result: **0 FAIL / 12 WARN**.

  ```
  PASS  L1 forbidden-tokens-by-glob: 8 src files clean (frozen gate 4 names 5)
  PASS  L2 ASCII test names across test*/
  PASS  L3 MANIFEST.sha256: 82 rows verified
  PASS  L4 all 50 tags verify
  PASS  L5 lawful-author-pack.md records the four stanza flags (incl. -Werror)
  WARN  L6 ... (12 advisory grid-literal flags, ALL on pre-existing files:
             test/Anchors.hs, test/Properties.hs, *gen_fixtures.py,
             test-transport/*, test-writeup/check.sh -- ZERO on test-lawful/)
  PASS  L7 full-corpus overlay build: every test .hs builds against new src
  === prefreeze-lint: 0 FAIL, 12 WARN ===
  ```

  **Two coverage caveats, resolved by the author's IX.1–IX.2 steps** (stated
  so the green is not mistaken for full coverage — the step-8 lesson): L3's
  `sha256sum -c` verifies only *listed* files, so the 3 new files pass by not
  yet being listed; and L7's `cabal build all` does not yet build either
  lawful suite (not stanza'd) and the standalone glob skips both mains (each
  imports `Test.Tasty`). Both come under real coverage the moment the two
  stanzas + the 3 manifest rows land — then the author's re-run (IX.3)
  verifies 85 rows AND builds both lawful suites through cabal. My `cabal exec
  -- ghc` compile of each main (Part VI.1) is the flag-faithful stand-in until
  then; it is the exact per-component build `cabal build all` will perform.
- **boundary-audit / the six red-team mandates**: these are roadmap-*boundary*
  events. A single pin-freeze increment is not a boundary (test-reflexive and
  test-optlaw, the pin-freeze precedents, ran neither). Not mandatory here.
  Mandate 1 (theorem-as-axiom) is nonetheless the increment's central subject
  and is answered in Part II + mechanized in Part III; mandate 6 ("what is it
  a function of?") — every floor object is a function of the corpus and the
  MDL prior, stated in Part I. External review remains available at the
  author's election.
- **ASCII test names** (prefreeze-lint L2): verified clean across
  `test-lawful/*.hs`.
- **SAT flag-faithfulness** (prefreeze-lint L5): the four flags `-Wall`
  `-Werror` `-Wincomplete-patterns` `-Wincomplete-uni-patterns` are recorded
  in Part VI.1.

---

## Part IX — the exact author sign sequence

The builder never owns a live oracle at the moment it becomes binding. The
steps below are the author's (or fresh per-instance delegation, recorded
verbatim in the tag). `src/` is byte-unchanged, so there is no implementation
step.

### IX.1 — paste the two stanzas into `proplang.cabal`

Append the contents of `test-lawful/stanza.cabal.draft` (the two stanzas —
`test-suite lawful` and `test-suite lawful-independence`, both
`hs-source-dirs: test-lawful`, no `other-modules`) to `proplang.cabal`. This
changes `proplang.cabal`, whose hash is manifest row 31.

### IX.2 — extend and re-sign `MANIFEST.sha256`

Manifest goes **82 → 85 rows** (3 new) plus the updated `proplang.cabal` row.
New-file hashes (computed at assembly; re-compute to confirm byte-stability):

```
10d06c2f333c796d8fe1de3a631cddd5c93eef2e94b2af1ad8607c1b2c86a2ae  test-lawful/Lawful.hs
8dee398240e4d64a7ed709ec791492ec264337547745ce6e93842801ef20ba8e  test-lawful/Independence.hs
6b06966a773484aea3c833dab042fade4920dff3b1c3c4a39013047de62077b2  test-lawful/stanza.cabal.draft
```

Update row 31 (`proplang.cabal`) to its new hash after the paste, and append
the three rows above.

### IX.3 — run the final gates

```
sh tools/prefreeze-lint.sh              # L3 manifest + L7 overlay build now green (stanzas + manifest in place)
export PATH="$HOME/.ghcup/bin:$PATH"
cabal test lawful                        # satisfaction suite: expect 16/16
cabal test lawful-independence           # irreducibility suite: expect 7/7
cabal test all                           # frozen gate 5: every suite green
sha256sum -c MANIFEST.sha256             # frozen gate 6
```

### IX.4 — countersign

Commit (builder key, if the builder stages it under delegation) then the
author's attestation:

```
git tag -s lawful-freeze-r0 <commit>     # author key, author's own shell
git tag -v lawful-freeze-r0              # GOOD
```

From that tag the increment oracle is as frozen as `test/`.

---

## Part X — under-determination register (as-built answers)

1. **Is Independence.hs a separate suite or an other-module?** → **a separate
   suite** — the author ruled two stanzas clearer (2026-07-24).
   `test-suite lawful-independence` (`main-is: Independence.hs`) is a sibling to
   `test-suite lawful` (`main-is: Lawful.hs`); both are `module Main` sharing
   `hs-source-dirs: test-lawful`, neither imports the other, and cabal builds
   each as its own component. Satisfaction and independence remain two facets
   of one increment — one oracle directory, one freeze — but each runs from its
   own `main`: `cabal test lawful` (16/16) and `cabal test lawful-independence`
   (7/7).
2. **Is the red-run a frozen script?** → **no.** Pin-freeze precedent
   (reflexive/optlaw/code) ships no runner; the seeded-defect red is a pack
   transcript (Part VI.2), the prototype discarded to scratchpad. `red-run.sh`
   exists only for process-level runners (transport/membrane); the floor is a
   pure suite.
3. **Does the floor certify the absence behaviour?** → **no, deliberately.**
   It is a known membrane defect, re-homed to 1b (Part IV, Part VII). The
   S-block proves absent-features yield a WELL-FORMED distribution, NOT that it
   is the CORRECT one.
4. **Open threads deferred to their own increments:** 1b (membrane/`Get`
   absence fix, oracle-first, will OWN the absence oracle this floor vacated,
   asserting CORRECT behaviour red-then-green); 1c (uniform/point single-door
   refactor). Neither is in this increment's scope.

---

*End of pack. Assembled by the builder; awaiting the author's review and tag.*
