# EXACT_PLAN.md — the exact-rational re-founding (a Phase-1 proposal)

*Builder-authored. Status: PROPOSAL. It opens nothing by itself. On the
author's ruling it opens a Phase-1 boundary; until then it is unfrozen
design material, like AGENT_PLAN / WIRE_PLAN / HOSTS_PLAN. The builder
touches no frozen file (`test/`, `audit/`, `CLAUDE.md`, `MANIFEST.sha256`)
in writing or discussing it.*

## 0. The one sentence

Make **exactness a belief-state invariant**: every weight the reasoner
holds, and every Bayesian operation over it, is an exact `Rational`;
inexactness exists only at the **reporting edge**, where a genuinely
irrational display quantity (a bit-length, an entropy) is rendered for a
human — and even there the exact rational is retained beside it.

## 1. Why this is right, not merely more precise

The decisive fact is not "rationals are more accurate." It is that
`Rational` **has none of the pathologies the current core was built to
survive**, so exactness *deletes* machinery rather than adding it:

| `Double` pathology | machinery it forced | under `Rational` |
|---|---|---|
| `NaN` / `±∞` | R-C1's denotation guards; `isNaN`/`isInfinite` in `gridLookup` (`Syntax.hs:125`), `Code` `colOK` (`Eval.hs:140`), `Pos`→`NaN` (`Eval.hs:158`); the step-9 NaN door | **cannot occur** — `Rational` is a pair of `Integer`s. Guards go vacuous. |
| non-associative `+` | the step-4 `Charge` tree-shape-**is**-the-float-order apparatus; "association ships as data so correctness never depends on coincidence" | multiplication of exact multipliers is associative — **the tree shape stops being load-bearing**; `chargeBits` collapses to a product. |
| log-space for stability | `lse` / log-sum-exp; the skip-on-`negInf` rules; `ln2` round-trips | linear space is already stable — **`lse` disappears**; a sum is a sum. |
| `0.1 ≠ 1/10`, FP-nonuniform grids | `Pos` ("adjacency is a positional, not a value, fact") | grids are exact; adjacency **is** a value fact again (see §5). |
| representational slop | `tolProb=1e-6`, `tolBits=1e-4`, `CL-4 1e-12`; "validation, not verification" | laws become exact `==`; **the gap between the law and the check closes.** |

So the re-founding is a *simplification and a de-partialization*. That is
why it is the right foundation and not just a nicer one: the current
numbers are lossy encodings of exact rationals, and half a dozen rulings
exist only to manage the lossiness. Remove the loss and the rulings
retire with it. `Log`/`Exp`, `NaN`, `lse`, the float-order tree, `Pos`'s
justification, and every tolerance are all one defect wearing six hats.

## 1a. The second firewall: core/world (grids are not the language)

The standing deletion test: a point-set that can be **declared and
deleted** is world data, and the core keeps only laws. `thetaPoints`,
`tauPoints`, `rhoPoints` — and, by the same law, the `obs` carrier `{0,1}`
(already half-anticipated by W3's arity handshake, `obsSpaceAt`) — are all
declarable, so **not one concrete point-set may live in `src/`.** The core
holds the `Grid`/`Carrier`/`Space` *types* and the grid-agnostic engine; a
**World** value declares the point-sets, at the boundary:

```haskell
-- [REPAIRED 2026-07-25 (R4): the four-field sketch below was staged as
-- FIVE fields — the namespace joins the World (the door needs it), and
-- wLatent is renamed wTheta, a CODEBOOK (mention domain), never a
-- reasoning-fineness config. The staged form:]
data World = World          -- declared OUTSIDE the core, carried at the membrane
  { wNs    :: Namespace      -- the declared feature names (the door's law)
  , wObs   :: Carrier Int    -- was obsCarrier / obsSpace
  , wTheta :: Grid           -- was thetaPoints (a codebook)
  , wTau   :: Grid           -- was tauPoints
  , wRho   :: Grid }         -- was rhoPoints
```
The §1a open sub-decision is RULED (R4): the wire is World's home;
host-config acceptable as interim. Host.hs's existing `World` renames
or subsumes in Phase 2.

The engine (`enumerate`, `observe`) takes a `World` parameter — the hooks
already exist (`enumerateSentencesGrid` is grid-parameterized; `obsSpaceAt`
is arity-parameterized). The concrete worlds live in the host/wire layer,
and — for the oracle — in the test worlds.

This **dissolves the `0.1` vs `1/10` question at the language level**: the
core never contains a grid to get wrong. The world declares its points as
exact rationals; the language reasons exactly over whatever ℚ-points it is
handed. The two firewalls compose — the world declares exact point-sets,
the core does exact arithmetic, and neither holds a `Double` nor a concrete
grid. **Open sub-decision (the boundary's reach):** the `World` rides the
membrane wire (the principled home — it *is* the world/agent boundary, and
W3's handshake already carries arity) versus a host-owned config as an
interim. Recommend the wire; stage-able as config first if you want the
smaller step.

## 2. The single ruling left to the author — emission representation

Everything below is written under **(II)**. This is the only place a
different ruling changes the design.

- **(II) weight-parameterization — RECOMMENDED.** A `Code`'s body denotes
  the emission **mass** (a non-negative rational), directly. `bernBody`
  stops being `Neg (Div (Log θ) (Log 2))` and becomes `θ`. "Bits" survive
  only as a reporting view (`−log₂ w`). *Grounds:* the `−log₂` transform
  is fixed machinery (`Code`/`fromWeights`), not hypothesis content —
  charging the agent, per hypothesis, to spell it out **misprices the
  prior**. A Bernoulli's complexity is `θ`, not a neg-log-quotient.
- **(I) restricted length primitive — the fallback.** Keep the
  prior/likelihood symmetry ("both are `2^(−length)`") by replacing
  unrestricted `Log` with a single **exactly-invertible** `lg(rational)`
  primitive whose length carries the rational it is the `−log₂` of.
  Exact, but keeps a length costume around what is already a weight.

The rest of this document is (II). Under (I): §3's `Mass` still holds; the
`Code` body stays length-typed through `lg`; `Log`/`Exp` are *replaced by
`lg`* rather than deleted; the prior mispricing stands uncorrected. If you
rule (I), I re-issue §3/§5 accordingly; nothing else moves.

## 3. The type re-founding (proposed signatures; author reviews exact forms)

**The language's real sort becomes `Rational`.** Every `Expr env Double`
becomes `Expr env Rational` (mechanical): `Get`, `Gt`, `MkC`, `Pos`,
`ToR`, the arithmetic, the `Code` body, the `Expect` binder.

```haskell
-- Belief.hs — the sealed reasoner, now exact
newtype Mass = Mass Rational        -- unnormalized, invariant >= 0
                                    -- (replaces `Bits Double`)
newtype Prob = Prob Rational        -- a marginal likelihood in [0,1]
                                    -- (replaces `LogProb Double`; its log is a display)

data Belief a = Belief (Space a) [Rational]   -- normalized: each >= 0, sum = 1

mkBelief :: Space a -> [Mass] -> Maybe (Belief a)
mkBelief sp ms =
  let z = sum [m | Mass m <- ms]
  in if z == 0 then Nothing               -- the impossible-evidence value
                else Just (Belief sp [m / z | Mass m <- ms])

fromWeights :: Space h -> (h -> Mass) -> Belief h   -- the ONLY prior source
                                                    -- (replaces `fromBits`)

expect :: Belief a -> (a -> Rational) -> Rational
expect (Belief (Space pts) ws) f = sum [w * f x | (x, w) <- zip pts ws]
  -- no skip-on-negInf: a 0 weight contributes 0, exactly

prob :: Belief a -> Event a -> Rational
prob b (Event p) = expect b (\x -> if p x then 1 else 0)

cond :: Belief a -> Evidence a -> Maybe (Belief a)
cond (Belief sp ws) ev =
  mkBelief sp (zipWith (\w (Mass l) -> Mass (w * l)) ws (lik (Belief sp ws) ev))
  -- multiply by likelihood, renormalize — exact rational throughout

predict :: Belief a -> Evidence a -> Prob        -- (replaces `logPredict`)
predict (Belief _ ws) ev = Prob (sum [w * l | (w, Mass l) <- zip ws (lik ...)])
```

`lse` is **deleted** (a log-space artifact). `push` becomes an exact
rational matrix product. `lik` (was `loglik`) returns `[Mass]`, not
log-likelihoods.

**The prior's length is an exact multiplier, not a `logBase 2`.** The
program prior mass is `1 / (product of alternative counts)`:

```haskell
-- Syntax.hs — pricing, now exact and associative
chargeMult :: (s -> Integer) -> Charge s -> Rational   -- a PRODUCT of widths
progMult   :: KnownScope env => Expr env t -> Rational -- (replaces `bits`)
-- prior: fromWeights corpus (\h -> Mass (1 / progMult h))
```

`Charge`'s `CSum` (float addition) becomes `CMul` (rational
multiplication); because multiplication is associative, the frozen
tree-shape-as-float-order guarantee is discharged as vacuous, and any
future "skip the tree" fast path needs no §1b pin — there is nothing left
for it to get wrong.

**`Code` under (II) — denotation becomes a total, decidable, exact test:**

```haskell
Code :: Space a -> Space b -> Expr (b : a : env) Rational -> Expr env (Maybe (K a b))

-- Eval.hs
Code dom cod body ->
  let cell x y = evalx body (Env feats (y :. x :. vals))   -- :: Maybe Rational (see below)
      colOK ms = all (>= 0) (catMaybes' ms) && any (> 0) (catMaybes' ms) && all isJust ms
  in if all (\x -> colOK [cell x y | y <- spacePoints cod]) (spacePoints dom)
       then Just (kernel dom cod (\x -> fromWeights cod (\y -> Mass (fromJust (cell x y)))))
       else Nothing
```

The R-C1 "no `NaN`/`−∞`, some finite" predicate becomes "**all masses
non-negative, some positive**" — an exact, decidable statement about
rationals, replacing a statement about float bit-patterns.

**The `Grid`/`Carrier` types stay (now `Rational`-typed); the concrete
point-sets LEAVE the core** (§1a). No `thetaPoints`/`tauPoints`/
`rhoPoints`/`obs` value in `src/` — a `World` declares them at the
boundary as exact rationals, and re-declaring a grid exactly changes no
size and no price.

## 4. The reporting edge (the only place a `Double` may appear)

[AMENDED 2026-07-25 (R7): displays are asserted (==) UNDER THE PINNED
TOOLCHAIN (gate 7 pins GHC 9.10.3) — the display function, including
its summation order, IS part of the spec; the earlier "N digits with a
derived bound" convention is retired as buying no oracle value. The
overlay's PropLang.Report is the staged form: entropy and bits views
derive from exact read-only views (weights, metaPosterior); the core
never renders.]

A small, named boundary — living in the host/reporting layer, **never** in
`Belief`/`Syntax`/`Eval`/`Enumerate`:

```haskell
-- Report.hs (new) — the transcendental display boundary
lossBits   :: Prob -> Double         -- negate (logBase 2 (fromRational p))
entropyBits :: Belief a -> Double    -- moved off Belief.hs; reads exact weights
```

Each reporting call ships the exact rational beside the Double: the tick
row prints the exact `P(obs)` and its `−log₂` to N digits with a derived
bound, not a Double masquerading as the truth. `entropyBits`/`top` (the
CL-1 diagnostics) move here; `top` returns exact `[(a, Rational)]`.

## 5. Alphabet consequences (the deletion audit re-run)

The ruthless reading of the deletion directive: weight-form + exactness +
world-declared grids + foreclosed expfam remove the *reason* for every
non-structural terminal. Measured this session — the bern, walk, guard, and
**categorical** bodies touch exactly `{Add, Sub, Mul, Gt, If}` (`Eq`/booleans
are DERIVED from `Gt`+`If`, `Enumerate.hs:428`, not terminals). **Six
terminals fall:**

| terminal | fate | status / proof |
|---|---|---|
| `Exp` | **deleted** | PROVEN — `DROP_EXP` compiles the whole library (this session). |
| `Log` | **deleted** | sole role `−log₂(p)`; weight-form removes it. `DROP_LOG` owed. |
| `Pos` | **deleted** | the only walked grid (theta) is exactly uniform; the reflected walk reproduces EXACTLY, Pos-free, in weight-form — correct boundary reflection, this session's kernel. `DROP_POS` owed. |
| `Neg` | **deleted** | only ever inside `−log₂`; a non-negative mass never negates. `DROP_NEG` owed. |
| `ToR` | **deleted** | identity under the `Rational` sort; its expfam justification is foreclosed. `DROP_TOR` owed. |
| `Div` | **deleted** | its uses (walk `ρ/2`; categorical `(1−θ)/(K−1)`) both go to the surviving `Mul` — `Mul rho ½` and the `(K−1)·θ` vs `(1−θ)` scaling. Deleting `Div` (not `Mul`) is what keeps `evalx` total. `DROP_DIV` owed. |
| `Mul` | **SURVIVES** | [REPAIRED 2026-07-25, the R15 re-execution: this row originally read "FORCED by the categorical (`catBody`, K>2): ... a multiplicative op is unavoidable for K>2" — FALSIFIED: the banked CatBody attempt never tried repeated addition, and `(K−1)·θ` composes as an Add-chain (the Mul-free categorical column reproduces `[7/30,7/30,3/10,7/30]` exactly; SevenSeats transcript). The banked-failure-expiry clause fired on this boundary's own headline evidence.] The seat HOLDS on the CORRECTED provenance: **the preposterior's mass×value products** — `vThink`'s terms multiply two FREE quantities, and every Mul-free term is piecewise-AFFINE in its free reads (MulBank transcript: mixed second differences vanish; the bilinear target's is d·s ≠ 0). The agent's own deliberation composition forces Mul; the categorical's world-integer coupling stands as the secondary, composable ground. |
| `Add` | **deleted** (ruled 2026-07-25, the repair sitting: 9/1) | The clause-(a) attempt SUCCEEDS in the author's CLOSED FORM — `Sub x x == 0`, `Sub (Sub b b) b == −b`, `Sub a (Sub (Sub b b) b) == a + b` — borrowing no codebook zero, total, exact in every declarable world (SevenSeats transcript). Add ships as the stdlib macro `addM`, priced at its expansion (three Sub nodes, b's subtree paid three times — the honest cost of a 9-letter alphabet). Its derivation row IS its deletion proof; no terminal to DROP. Sub is the GENERATOR (Add cannot generate Sub: non-negative coefficients, 1−θ unsayable). |
| **survivors** | `Sub Mul Gt If` | + the leaves `C`/`Get`/`Var` and the verbs (`Expect`, the fused `Cond` | `Code`). |

**Partiality vanishes with `Div`.** Division-by-zero was the *only*
arithmetic partiality (`Rational` has no `NaN`/`±∞`; `Mul` is total).
Deleting `Div` — and keeping `Mul` — makes `evalx` **total** (no `Maybe`
arithmetic), and the sole denotation failure becomes "a column has no
positive mass" (a decidable modeling condition, not a pathology). Because
`Mul` survives, the walk's `ρ/2` is `Mul rho ½` and needs **no**
World-reparameterization (the earlier `q = ρ/2` proposal is now
unnecessary). Each of the six deletions carries a `DROP_` ablation (the
two-sided entry gate) in the increment.

## 6. Frozen-layer inventory (prose the re-founding falsifies)

[EXTENDED 2026-07-25 (R16): interface.md:117's `gauss` expfam promise
joins the inventory — the exact boundary forecloses expfam, so the
promise is falsified prose and repairs under the author's key at the
freeze, in the §6 form.]

Repaired under the boundary's key at the Phase-1 freeze, in the form each
text class demands (the step-7 clause):

1. **R-C1** (the `NaN`/`−∞` denotation ruling) — vacuous; `Code`
   denotation restated as non-negative-mass/positive-total.
2. **The step-4 "float order as declared data" doctrine** — retired;
   exact multiplication is associative.
3. **`Pos`'s FP-nonuniformity deletion proof** (`Syntax.hs:250`) —
   rewritten or the terminal deleted (§5).
4. **R-C5** ("the arithmetic is IEEE-754 binary64") — superseded: the
   *sayable* arithmetic is exact `Rational`; binary64 survives only behind
   the §4 reporting boundary. This is the load-bearing frozen reversal;
   it is the reason this is Phase-1 and author-only.
5. **`tolProb` / `tolBits` / `CL-4 1e-12`** — the numerical anchors become
   exact `==`; the tolerances that remain are on §4 display quantities
   only, and are *derived* bounds, not chosen ones.
6. **The `Bits`/`LogProb` type-derivation lines** ("the prior's only
   currency: 2^-L") — amended: the currency is exact mass; length is a
   display view.

## 7. New gates (the enforcement — "inexactness unsayable in the core")

The mechanical capstone you asked for earlier, now numeric as well as
structural:

- **Gate E1 — the exactness firewall.** No token `Double`, `Float`,
  `log`, `exp`, `logBase`, `**`, `sqrt` anywhere in `Belief.hs`,
  `Syntax.hs`, `Eval.hs`, `Enumerate.hs`. A grep row in
  `audit/forbidden.txt`'s successor. **Inexactness becomes unsayable in
  the belief-construction core by construction** — the numeric analogue of
  the sealed `Belief` constructor.
- **Gate E2 — reporting confinement.** `Double`/`logBase`/`fromRational`
  appear only in the §4 reporting module. The firewall has exactly one
  door.
- **Gate E3 — the core/world firewall (§1a).** No concrete point-set
  literal in `src/`: no `_ :| [_ ..]` grid/carrier value, no `mkSpace`/
  `mkGrid`/`mkCarrier` on a literal, in any core module. Point-sets enter
  only as `World` parameters. The checkable twin of E1 — as inexactness is
  unsayable in the core, so is a baked world.
- **Laws as `==`.** The lawful floor (normalization, Kraft, monotonicity,
  the introducer law) states exact rational equalities. A law that cannot
  be written as `==` is a law about a §4 display quantity, and says so.

## 8. Costs, stated without flinching

1. **Bignum growth over long streams.** Exact rationals never over/underflow,
   but denominators grow with stream length. [REPAIRED 2026-07-25, the
   minimal-basis sitting: this section originally claimed "the per-tick
   belief state is renormalized each tick (denominators bounded by the
   grid)" — FALSE. Renormalization does not bound a posterior's reduced
   denominator: after n Bernoulli ticks it grows ~linearly in bit-length
   with n (a walk latent's likewise). The honest statement: growth is
   POLYNOMIAL (O(n) bits per weight) and measured acceptable — the full
   four-test exact pipeline (1169 hypotheses, 160+36+800+660 ticks,
   §11 A1) runs in ~46 s at -O1; the per-tick cost is the price of
   exactness and it is affordable where it matters, the oracle.]
2. **Continuous / max-entropy / expfam models are foreclosed.** Their
   weights (`e^{−η·T(y)}`) are genuinely transcendental. proplang is
   finite and discrete; it never shipped them, and `Exp`'s door is proven
   shut. This is a promise the language arguably should never have made.
3. **The entire frozen oracle re-derives.** `test/Acceptance.hs`,
   `test/Properties.hs`, and `MANIFEST.sha256` reopen; the anchors move —
   not to exact copies of the same numbers, but to whatever the exact
   language produces (the prior reprices under (II)). Per your ruling, the
   movement is the *correction*, not a regression; the old Double anchors
   were the wrong numbers. Any discrete-anchor **story** change (a tick
   count, a change-point) is surfaced at the freeze for your review, not
   silently absorbed.

## 9. Custody and sequence (oracle-first, unchanged)

1. **You rule** — open Phase-1, and rule (II) vs (I).
2. **Phase 1, oracle re-derivation.** Builder re-derives `test/` to exact
   anchors and re-states the lawful floor as `==`, runtime-red against
   compile-enabling stubs, under the exact gate flags (bit-faithful /
   flag-faithful per the R-D21 overlay clause). Satisfiability transcripts
   ride the pack (R-D21). No implementation yet.
3. **You review and re-sign** `MANIFEST.sha256` over the re-derived oracle.
   From that signature the exact oracle is as frozen as `test/` is today.
4. **Phase 2, implementation.** Builder re-founds `src/` until gates
   1–7 **plus E1/E2** are green and anchors are byte-stable to the newly
   frozen exact oracle. The pre-freeze lint and boundary audit run; the
   red-team mandates are put to the increment.

The builder never owns the exact oracle at the moment it becomes binding.

## 10. The irreducible floor, after

What remains genuinely primitive — the exact core of a Bayesian
decision-theoretic agent, with nothing the compiler could have forced left
as prose or tolerance:

- exact rational arithmetic, attempt-determined: `{Sub, Mul, Gt, If}`
  [REPAIRED 2026-07-25: originally `{Add, Sub, Mul, Gt, If}` with Mul
  credited to the categorical — Add fell to the closed-form composition
  (9/1) and Mul's ground is the preposterior, §5] (the two-sided entry gate: a terminal survives only if a shipped
  body needs it — `Div`/`Neg` would close the rationals mathematically but
  no shipped weight-form body divides or negates; `Mul` survives because the
  categorical does, §5);
- the Bayesian operations — condition, push, marginal, normalize — closed
  over the rationals on finite carriers;
- the MDL prior: program length as an exact multiplier, mass `1/M`;
- the grids as exact rational declared data;
- one reporting boundary (§4), where — and only where — an irrational
  display number is rendered, with its exact rational retained beside it.

Everything else was scaffolding for `Double`, and comes down with it.

## 11. The minimal-basis amendment (2026-07-25, the planning sitting)

The author's organizing criterion, stated at this sitting and governing
every section above: **as few primitives as possible, EVERYTHING else
derived — and FORCED to be derived** ("we rely too much on our
intelligence when we should be relying on 'compilation'"; "greppable is a
hacky way to assert truths"; "unproven statements wont even be sayable").

> **THE MINIMALITY CRITERION.** A primitive exists only under a
> demonstrated failed composition (clause (a), applied to the STANDING
> stock — every pre-boundary bank EXPIRED when this boundary moved the
> alphabet) plus its ablation fixture (clause (b)). Everything else is a
> derived name: a macro whose expansion is a sentence of the primitive
> grammar, priced at its expansion. **ENFORCEMENT LADDER**: (i) unsayable
> at compile; (ii) derived at build from declared data; (iii) frozen
> oracle row; (iv) prose — only for what provably can't climb.
> "Derive" is pinned as SYNTACTIC macro expansion (decidable, mechanical);
> primitivity claims are extensional, hence *executed* attempts.

Three author rulings of the sitting: the Double lawful floor NEVER
freezes ("never freeze incorrect code") — test-lawful/ is re-derived
exact inside this boundary, its 4-axiom + 4-theorem structure and 3+1
independence ported, u/tol/near deleted; the WIRE is out of scope
(transport, not language — it changes only where the World declaration
requires); and DOCUMENTS owe their existence a justification ("why do we
have documents?") — the census (72 tracked .md, ~26k lines, universe by
`git ls-files`) rides the pack with per-class dispositions.

### 11a. Evidence executed at this sitting (R-D21 throwaways; transcripts in the pack)

- **A2, the exact prior.** Weight-as-Rational CONFIRMED end-to-end on the
  shipped corpus: every one of the 1169 prices is log₂ of an integer
  (M ∈ {16, 36, 82944}); the exported charge trees fold exactly to 1/M;
  the exact Expr-weight recursion reproduces the shipped `bitsAt` on all
  corpus bodies (0/1169 failures). **Kraft is exactly 55/72** (deficiency
  17/72 — the HEAD debt made visible, printed not absorbed).
  **L4′ stated and verified**: `prob B (is sp x) · Z == w x` exact, and
  the corpus law `p_i · M_i ≡ 1/S` exactly (the Double route already
  drifts by one ulp). `uniform`/`point` verified as DEFINITIONS over
  `fromWeights`. Corrections adopted from the design review: the per-node
  factor is **1/14** post-cut (prodTable 20→14, the P5 single-site edit);
  `Charge`'s content constructor becomes `CMass Rational` (a stored
  `CBits :: Double` cannot be inverted); the float-order tree dies.
  **FINDING — two width tables under one mechanism**: the corpus prior is
  priced by `fragWidth` (MODEL/THETA/HEAD/RATE) while raw said-sentences
  are priced by `prodTable`; whether they unify is a sitting question.
  The 20→14 re-pricing moves relative raw-Expr prices by up to
  (10/7)^115 ≈ 6.5e17 across corpus bodies (node counts 15–130) — it
  binds the said/utility layer, not the corpus prior.
- **A3, the binder basis.** The 12 survivors split three ways, every
  verdict EXECUTED: (A) compile-fact primitives — Expect, CondE, Code,
  Get, Var, MkC, If, Gt (negative compile transcripts + the ghci-extracted
  sort-role table; CondE is where the language's one remaining division
  lives); (B) the corridor SawE→CondE→ElimJ is NEVER separated outside
  its own ablation fixtures (census over all 38 tracked .hs) — the FUSION
  of three constructors + two corridor sorts into one conditioning
  primitive is the headline compression candidate (one fused node vs the three-node chain — 81× at the shipped width 9
  [figure repaired 2026-07-25; originally quoted at the voided width
  14 as 196×]; loses only env-bound corridor sentences no wire can
  produce); (C) unearned seats — **Push is uttered only by its own
  fixture**; **Argmax's executable route bypasses it** and the per-K
  index-menu family is DERIVED and extensionally identical (ties
  included, CL-3-faithful by construction; battery green). MkC's scope
  shrinks by NORMALIZATION, not derivation: Mul-form walk masses
  (2−2ρ, ρ, ρ) and categorical ((K−1)θ, 1−θ, …) normalize exactly to the
  shipped laws — the ½ and 1/(K−1) mentions die. Gt's derived-equality
  upgrades from measurement (0/1225) to THEOREM (exact trichotomy;
  17,689-pair exhaustive check). Is-evidence is derivable through an
  indicator kernel — I2's closed variant can shrink.
- **A1, the exact reference pipeline.** The full four-test suite,
  grid-agnostic over a declared World, exact end-to-end, against the
  FROZEN streams (imported from test/Streams.hs — the artifact itself):
  **every discrete anchor reproduces** — 1169/0/0 enumeration counts, all
  probe actions, consult ticks [0,1,3,4,65–70], the τ=60 MAP change-point
  sentence, tick counts 1/3/12/12 with act L, the full deletion table —
  and the continuous anchors move only at the last ulp (max |ΔP| =
  3.3e-16, log-losses to ~1e-13). **The frozen agent's marginal is
  EXACTLY 2⁻¹⁶⁰** where the Python anchor carried float error
  (160.00000000000003). The re-founding changes no story; it makes the
  numbers definitional.
- **A4/A5.** The engine is codebook-parametric (same engine, 9-point and
  5-point θ worlds; the t4 symmetry marginal exact in both). The
  fail-closed feature door executes: a tick must cover the declared
  namespace exactly — missing/undeclared/duplicate all refused; the
  0.0-dormancy default dies at the door (the author's standing
  discomfort, resolved structurally). Rider: the `Code` space payload is
  priced 0 (opaque-payload convention) — under the criterion that free
  ride is a subsidy; re-price or derive from the World declaration.
- **A7, the lattice coordinate.** `nodeTheta = 1/(1+2^(−p/2^k))` is
  irrational for every depth ≥ 1 node (2^k-th root of an odd power of 2);
  the dyadic-in-theta ladder (odd p / 2^(k+1)) is exact, root 1/2, mirror
  θ↔1−θ exact, denominators dyadic (compatible with 2^-gammaBits
  weights), same tree so gammaBits carries unchanged. The R-R1 log-odds
  spacing derivation is what the re-ruling must re-derive — author item.

### 11b. Items put to the author at the Phase-1 freeze sitting

1. World/grid reading: World = CODEBOOKS (mention domains); fineness
   remains the agent's, priced (fineness-charged-once exact; R1's lattice
   the shipped refinement mechanism). Recommendation: adopt; wLatent's
   carrier derives from the θ codebook, no separate reasoning-grid config.
2. prodTable 20→14 now; written-alternatives vs type-pruned widths as a
   SEPARATE ruling with the exact ratio-drift table (a prior re-weighting
   is adjudication, not porting).
3. Push's seat (fixture-only vs the step-10 cluster's credit) and
   Argmax's seat (per-K derived family + host fold) — keep or delete,
   demand-gated re-entry via the entry gate.
4. The corridor fusion (SawE/CondE/ElimJ → one conditioning primitive).
5. The two-width-tables question (fragment prior vs Expr pricer).
6. The lattice coordinate re-ruling (dyadic-in-theta; re-opens R-R1).
7. uniform/point as fromWeights definitions (Belief export shrink) and
   I2's Is shrink.
8. Document dispositions (the census table) and the CLAUDE.md minimality
   clause's canonization text.

### 11c. The rulings of the opening sitting (author, 2026-07-25, recorded)

The author ruled the Part-III sheet at the planning session (decision
record; the tag that seals them is the Phase-1 freeze tag over the exact
oracle):

1. **The boundary is OPEN as chartered** (§0–§11). #6 (dyadic-in-theta
   lattice), #7 (uniform/point as fromWeights definitions; I2's Is
   shrink), #8 (the fail-closed door) ruled AS RECOMMENDED. #5 (two width
   tables) and the type-pruned-widths half of #2 REGISTERED as named
   later questions. Part IV (archive sweep; membrane-wire forms table
   derived) approved as freeze items.
2. **prodTable leaves 20** — and, composed with rulings 3 and 4, the
   SHIPPED table is ~~10/1~~ **[SUPERSEDED 2026-07-25 at the repair
   sitting, sealed by the same freeze tag: 9/1 — Add's seat fell to
   the executed closed-form composition (R15; §5's Add row); every
   Phase-D pin prices the node at 1/9]**. The original composition: the six-cut (−6), Push and Argmax deleted
   (−2), the corridor fused three-into-one (−2). The 1/14 figure was the
   six-cut intermediate and never ships; every Phase-D pin prices the
   node at **1/10** (KER at 1/1). The P5 single-site edit lands 20→10 in
   Phase 2.
3. **Push and Argmax DELETED** — the criterion without fear or favor:
   both banks expired, both named futures were discharged without them
   (step 10's vActS is If/Gt-over-Expects; vThinkS is corridor+Add/Sub;
   Reflexive.hs:99-120). WITH the re-homing obligation: the wire's
   selection fold (Membrane.hs:234-252, the deferred-and-never-resolved
   classification — the calculator residue) is re-homed in Phase 2 so
   the GENERAL route is the derived sayable composition and the host
   fold survives only as an optimisation-law-pinned fast path.
4. **The corridor FUSES INSIDE THIS BOUNDARY**: SawE/CondE/ElimJ become
   one conditioning primitive (working name `Cond`: belief, kernel,
   observed outcome, Just-arm binder, Nothing-arm — g6's load-bearing
   Nothing arm retained); the `Ev` and `Maybe (B a)` corridor sorts
   leave the grammar. Phase D writes the fused grammar's oracle rows
   directly; g5/g6 port as the pin.

**THE AGENT CRITERION** (companion clause, drafted at this sitting under
the author's "lets make sure we're building a bayesian AGENT, not a
calculator"): a deletion is legal only if the agent capability it served
remains SAYABLE, and the executable route runs through the sentence — a
host fold is legal only as a fast path pinned to the sayable route by
the optimisation law. Applied to this boundary: choice → the If/Gt
family (CL-3-pinned, ArgmaxK battery); preposterior deliberation → the
step-10 composition; conditioning → the fused verb; prediction → the
corridor + Expect. The selection-fold re-homing of ruling 3 is this
clause's first enforcement.

**Post-ruling alphabet (the Phase-2 target):**
`C(MkC), Get, Var, If, Gt, Sub, Mul, Expect, Cond` (EXPR, 9 — as
superseded at the repair sitting) +
`Code` (KER, 1) + the sorts `Rational, Bool, B, K, Space, Grid, Carrier,
Namespace, World` (Namespace added at the review sitting — the mandate-3
census omission; its line rides pack IX.2 B4) — each type with its
derivation line, each production with its transcript.

## 12. Phase 2 — the work order (drafted at the review sitting of 2026-07-25; executes only after the author's exact-freeze-r0 tag)

**R17 — THE AGENT IS A DERIVATION (drafted for the author's adoption at
the freeze tag; the organizing principle of Phase 2).** The agent
layer's normative definition is four derivations over the sealed
reasoner's API — never trusted engine code:

    corpus W  = the sentences of the grammar sayable under W's
                codebooks, within a declared frontier parameter
    agent W   = fromWeights (corpus W) (\h -> 1 / M h)
    tick y    = Cond (agent) (interp-kernel feats) y
                  where interp = evalx of each hypothesis's Code at
                  the door-served features
    predict   = Expect over the pushforward
    choose    = the If/Gt family over Expects (CL-3-pinned)

Engine code implementing any of these is a fast path under the
optimisation law (S1b), pinned extensionally to the derivation in the
same increment. The fragment/fragWidth apparatus either DERIVES from
the price bound or dies — this resolves registered question #5's shape
(the fragment table is an optimisation of the frontier-parameterized
enumeration, so it owes a derivation or a pin; it cannot remain a
second hand-declared shape of the hypothesis space).

**The work order (builder; the oracle is frozen before any of this):**

1. **Opening checklist.** OB-16/GetV re-executes (this boundary moved
   the alphabet — the banked-failure expiry clause); the R-R1 dyadic
   spacing re-derivation lands under opening ruling #6 (author item,
   brought to the close); the two R15 positive banks (the addM closed
   form; Mul's bilinearity) are this increment's standing banks.
2. **src/ re-founds to the proven 9/1 surface** under gates 1-7 +
   E1/E2/E3: modules Belief / Syntax / Eval / Enumerate / Report (+ the
   boundary layer). Enumerate re-founds PER R17: (i) the corpus
   generator derived from the grammar's own declared production table
   under a frontier parameter (enforcement rung ii); (ii) every engine
   fast path opt-law-pinned to the R17 derivation (the oracle's
   agent-criterion rows are the precedent and the first pins). The
   derivation-line table (pack IX.2 B4) lands as in-file lines at each
   definition site. Host.hs's `World` renames or subsumes (R4). The
   selection-fold re-homing lands with its pin (opening ruling 3).
3. **Ablations.** DROP flags for the six structural atoms + DROP_GET
   (gate-7 rows); every ablation demonstrably fires.
4. **The R11 mass retirement** executes with pack IX.5 as its pin
   list: PORTED/GATE rows land as named rows in this increment;
   DISCHARGED-PERMANENT files are DELETED; the manifest re-signs at
   the close (author key or recorded delegation + re-tag, R-D22).
5. **KERNEL.md page 2** — the module-derivation table describing the
   as-built architecture, one line per module; a module without a line
   is collapsed, not documented.
6. **Close.** Full-corpus overlay build green (lint L7); prefreeze-lint
   + boundary-audit transcripts ride the close; the red-team mandates
   are put to the increment (S9.4); the as-built report answers this
   section's register; the author countersigns (suggested tag
   exact-freeze-r1). The process-deletion-audit candidates (pack IX.6)
   are brought to that sitting for the author's per-item ruling.
7. **The oracle-row deletion audit, first run** (pack IX.6, the fourth
   move — the deletion test applied to the law itself). Deliverables
   of this close: tools/oracle-audit.sh and the DECLARED mutant
   registry (audit/mutants/ — each mutant a named minimal patch
   instantiating a recorded failure shape; the pool derived from the
   incident case law plus a declared operator list, never
   hand-enumerated). The audit runs every frozen suite against every
   mutant and brings the KILL MATRIX to the close sitting: EARNED /
   SHADOWED / UNREACHED per row, flags as triage inputs never
   verdicts; any row deletion executes under the author's key with
   its pins listed. The drafted clause (including the forward half —
   a new oracle row arrives WITH its unique kill) is put to the
   author for CLAUDE.md canonization at the same sitting. Note the
   composition with IX.8a: the audit runs AFTER the R11 retirement,
   so the matrix covers exactly the surviving law, not rows already
   leaving.
