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
its summation order, IS part of the spec; AND (the mandate-6 finding
of the close) the pin extends to the host libm — logBase compiles to
the C library's log, so the pinned Double displays are a function of
GHC + libm; a libm motion that moves a display is a re-measurement
event, not a defect; the earlier "N digits with a
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

## 11d. R5's geometry (the door's consequence — DEFINED here; the
## mandate-2 close finding: code cited it, no document derived it)

R5 ruled env construction door-only with exact namespace coverage.
Its GEOMETRY follows: every intra-tick read carries a FULL assignment,
so (i) a candidate's EU reads at feats ++ candidate (the exogenous
read, coverage supplied by the candidate's own writable names);
(ii) the reported predictive reads at feats ++ act — POST-CHOICE,
PRE-OBSERVATION (choice still precedes observation; the report
references the acted-upon world); (iii) dormant partial reads died
with the 0.0 default. Menu-less worlds are byte-unchanged (feats
alone covers). Membrane.hs and Host.hs cite this section.

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

## 13. The trampoline boundary (DRAFTED at the X.5 preparation, 2026-07-26; OPENED by the author's instruction of 2026-07-26 per the dyadic ruling 8; the boundary record below)

> **The boundary record (builder edit at close, under the author's
> eye).** OPENED 2026-07-26 ("open the trampoline boundary" —
> recorded verbatim in trampoline-author-pack.md Part I). Oracle
> phase: test-trampoline/ 17 rows in five groups, red 14/17 + 3
> capability pins seeded, SAT 17/17 on the flag-faithful overlay;
> six red-team mandates ran; pre-tag review round folded in. FROZEN
> at trampoline-freeze-r0 (2026-07-27, BUILDER key on the recorded
> delegation "you write everything, i just sign — execute the freeze
> on delegation"; manifest 71/71; the register R1-R11 ruled — R4
> substitution normative, R11 license-by-name, pack Part XI).
> IMPLEMENTATION GREEN at 278b721: 8/8 suites, gates 1-7 PASS,
> E1-E3 0; E4 STOP-AND-REPORT — four tokens, all in categories E4's
> own frozen prose licenses, the scriptable allowlist enumerated
> against the stub surface; the three-row repair staged for the r1
> sitting under the frozen-layer inventory clause. The close matrix
> and close-out ride the pack; the increment closes at the author's
> trampoline-freeze-r1 (R-D22).

### 13.0 THE DESTINATION MAP (charter preamble; installed verbatim from the author's directive of 2026-07-26 so the roadmap lives in the tree, never in a transcript)

The project's destination has four clauses, each completed by exactly
one remaining piece:

| destination clause                        | status                    | completed by        |
|-------------------------------------------|---------------------------|---------------------|
| "can ONLY be used for EU-maximal          | structural in the core;   | the trampoline (E4) |
|  decisions" (soundness)                   | the host can still choose |                     |
| "to CREATE Bayesian-optimal agents"       | witnessed by 4 tests,     | the completeness    |
|  (sufficiency)                            | unproven in general       | suite               |
| "INCLUDING METAREASONING" (closure)       | sayable + pinned, not     | the trampoline      |
|                                           | automatic                 | (same boundary)     |
| agents in the WORLD, not oracle worlds    | governor in shadow        | the demonstration   |
|                                           |                           | tier                |

The sequence, and why: (1) the X.5 sitting — chartered residue,
mostly author rulings; its lattice item GATES the trampoline
(think/refine rungs live in Lattice/Purchase). (2) OB-12's
differential run — a MEASUREMENT, not a boundary; the ledger's
highest-leverage unexecuted measurement, cited by two pending
readings; runs in parallel, waits for nothing. (3) The trampoline
boundary — the LAST language increment: completes soundness and
closure at once, and is the final surface motion. (4) The
completeness suite — proves sufficiency ONCE, against the final
surface (certifying before the trampoline would mean certifying
twice). (5) The demonstration tier — A-gate reading with OB-12's
result in hand, the benchmark, the paper; the paper's claim set is
then: necessity by executed deletion, sufficiency by executed
interpolation, soundness by four gates, exactness by ==, closure by
E4, and a live host. AFTER 5 THE ROADMAP TERMINATES. Everything else
is named demand-gated residue re-entering only through the two-sided
gate with a measurement: the quine face, OB-15, OB-19, continuous
carriers (foreclosed), and brief §6's self-compression (the agent
buying its own macros) — a research programme, named not scheduled.

*(Status annotations as of this draft: the X.5 sitting is PREPARED —
x5-author-pack.md; OB-12's run is EXECUTED — the pack's Track 2:
A-gate demand NOT MEASURED on 95k live events, B-gate UNDERPOWERED
at n_inv = 0, no engine passes the registered loss bar.)*

### 13.1 The dependency, recorded

This boundary DEPENDS ON X.5 ITEM 3 (the dyadic lattice coordinate).
The internal acts think/refine are priced menu rows whose machinery
is Lattice/Purchase; chartering metareasoning over a module whose
points are Double lies about irrational reals (pack x5 3.1), whose
guard can certify false robustness (3.2, the flip witness), and
whose scorer collides saturated thetas (3.3) would build the
closed-system agent on the one convicted island. The coordinate
ruling lands first; this charter assumes its diff (x5 3.6) as the
substrate.

### 13.2 The charter body

**The standing POLICY sentence.** The agent's per-tick behavior is
ONE derived macro — a sentence of the 9+1 grammar with the agent's
own belief bound in its env (the reflexive composition step 10
proved sayable) — evaluated once per tick by the host. The policy
sentence is data: priced at its expansion like every derived name,
declared once, never rebuilt per tick by host logic. Its shape: the
If/Gt-over-Expects choice family over the tick's full option menu
(external assignments ++ internal acts), each option's value an
Expect over the predictive at feats ++ option — the chooseEU
composition generalized to the whole menu, INCLUDING the internal
rows.

**Internal acts STANDING on the menu.** think (deepen one rung
[2026-07-27, the trampoline close, register R9 as ruled: the SHIPPED
face of think is the t2 lineage's BATCH-FOLD act — fold the world's
declared batch of the evidence stream, the frozen `min 3 bufLen`
law — not the lattice rung-deepening this draft phrase names; that
face, and the think/refine unification on ONE declared tick's menu,
are the completeness suite's standing question]) and
refine (buy one vocabulary node) are menu rows like any other,
priced by the world's declared clock (the R1 joint law's option
order: wait head, externals, internals LAST; CL-3 ties to
inaction). Metareasoning is therefore NEVER INVOKED and NEVER
EXCLUDABLE: there is no "decide whether to deliberate" host branch —
deliberation wins a tick exactly when its priced EU says so, through
the same one chooser as everything else. A world that prices the
clock at zero gets a maximal deliberator; a world that prices it
dear gets the myopic rung — with ZERO code difference (13.4's
oracle shape).

**The host reduced to a decision-free polling trampoline.** The loop
is: read line -> door -> ONE evalx of the standing policy sentence
with the belief in env -> execute by CONSTRUCTOR DISPATCH on the
result (an assignment fires on the wire; an internal act re-enters
the evaluator) -> fold evidence -> reply. The host branches ONLY on
constructor tags and wire input — never on any engine-derived
quantity. The Membrane's chooseEU fold (host carries beliefs between
binary evaluations) collapses INTO the policy sentence; what remains
of Membrane/Host is transport and the door.

**Gate E4 — THE SINGLE CHOOSER.** No comparison on any
engine-derived quantity outside evalx. Scriptable half (lands beside
E1-E3 in audit/gates-exact.sh, same sed-comment-strip discipline):
in src/PropLang/{Host,Membrane}.hs (the modules outside the
evaluator), zero occurrences of the comparison/ordering tokens
` > `, ` < `, ` >= `, ` <= `, `max `, `min `, `maximumBy`,
`minimumBy`, `compare` applied to values of engine provenance —
enforced as: those tokens may appear ONLY in (a) wire-input
validation (parse-layer, before the engine exists) and (b)
constructor-tag dispatch; the gate greps the stripped source for
the tokens and an allowlist of validation sites, exactly as E1
carries its Report allowlist. The non-scriptable half (what
"engine provenance" means) stays law as prose with the E-gate's
register. E4 upgrades lazy-genius from "no line chooses outside the
sentence that we could find" to "no line COULD exist without
failing a frozen gate."

**THE FLOOR — the fourth residue, named.** One un-deliberated policy
evaluation per tick. The trampoline must evaluate the standing
sentence to learn what the agent wants to do — including whether to
deliberate — and THAT evaluation is not itself deliberated (else
regress). This is the brief's laws-of-thought residue in
operational face: alongside the alphabet, the clock, and the
pointer, the floor is physics — named, priced at zero by
construction, and impossible to remove without removing the agent.
The charter records it beside the other three residues; KERNEL.md's
RESIDUES line gains "the floor" when this boundary's freeze touches
that page (frozen-layer inventory, under the author's key).

### 13.3 What dies

The last host folds: chooseEU's Either-fold (Membrane.hs) and the
Host's per-tick selection plumbing become the policy sentence's
expansion or leave; runEpisode's pilot dispatch reduces to the
trampoline; any surviving host-side max/min falls to E4. Candidate
process deletions ride their own sitting (x5 Track 1 item 1), not
this boundary.

BANKED OBSERVATION, registered here so it is not rediscovered (the
GroundC run, 2026-07-26, x5 pack 3.6a; COORDINATE-INDEPENDENT, so it
belongs to the boundary that next touches Purchase — this one): the
shipped value-based purchase candidate DEADLOCKS from root-only
vocabulary at deep-threshold stakes on BOTH coordinates — `val`'s
max-0 clamp zeroes the single-step gain whenever no one purchase
takes the pessimistic guard positive, so refine never fires and the
agent waits forever (measured: 40-60 all-correct ticks at stakes
(1,-24)/(1,-171), zero refines, both engines identically). The
trampoline's internal-act pricing must either (a) let the rung
ladder see multi-step purchase value (the kLadder multiplier's
original role, generalized lawfully), or (b) accept and DOCUMENT the
root-vocabulary deadlock as the myopic single-step candidate's
honest behavior. Per the banked-failure expiry clause, this
observation is re-executed against the dyadic Lattice as shipped
before this boundary relies on it.

### 13.4 The closed-loop lazy-genius oracle shape (drafted rows; oracle-first binds when the boundary opens)

- **The price-only differential:** the SAME trampoline binary against
  two worlds differing ONLY in declared prices (the clock row's
  values in the world declaration; zero code diff, zero flag diff):
  think-counts MOVE — the dear-clock world reproduces the myopic
  anchors (t2's 1/3/12/12 lineage), the free-clock world climbs
  rungs — and every movement is attributable to the declared price
  alone. The row asserts both count vectors exactly (the anchors
  derive from ExactReference extended to the trampoline loop).
- **E4's grep row:** the scriptable half above, run as a gate row
  (red on any engine-derived comparison outside evalx; the seeded-
  defect demonstration: a one-line host-side `if euA > euB` planted
  and caught — the pin-freeze red-run clause's shape).
- **The single-evaluation row:** the trampoline performs exactly ONE
  policy evaluation per tick (counted through a transcript identity,
  not instrumentation inside src — CL-1 reads at the boundary).
- **Composition rows:** the policy sentence's expansion == the
  shipped chooseEU route on menu-only worlds (the retirement's pin:
  the old selection is the new sentence's special case, extensional
  ==); internal-act rows reproduce R1's recurring-stakes buy and
  myopic-stay shapes as sentences (the R1-era suites retired at R11;
  their shapes return as trampoline rows under the new coordinate).

Per the increment protocol: the oracle for this boundary is written
oracle-first, runtime-red against type-surface stubs, SAT-transcribed
(overlay form, flag-faithful), frozen by the author, THEN
implemented. This section is a charter, not an oracle.

## 14. The completeness suite boundary (OPENED by the author's instruction of 2026-07-27 — "open the completeness suite boundary", in-session, immediately after the trampoline-freeze-r1 push; destination map step 4)

> **Boundary record.** OPENED 2026-07-27. Base 627bb12
> (trampoline-freeze-r1, author key, verified); manifest 71/71 at
> the opening. Per the V-cancellation lesson the opening becomes a
> custody fact only at this boundary's freeze tag; until then this
> charter, completeness-author-pack.md, and the builder commits
> carry it. NOTHING FROZEN TOUCHED at the opening: one frozen-tool
> repair was drafted, proven on the working tree, REVERTED, and
> staged as test-completeness/freeze/boundary-audit-repair.patch
> for the sitting (Part II of the pack).

### 14.0 The claim

Destination row 2 is the last unproven clause about the language
itself: "to CREATE Bayesian-optimal agents" — sufficiency. Today it
is witnessed by four acceptance tests plus the boundary anchors:
POINTS, hand-picked. The suite proves it ONCE, against the final
surface, and the paper's claim line becomes "sufficiency by executed
interpolation." The name's ground is the brief's own (brief.md:66):
Wald's complete-class theorem — every admissible decision rule is a
Bayes rule against some prior and utility. The executable face of
that theorem here: every world the wire can DECLARE gets, from the
9+1 grammar alone, an agent whose behavior is exactly (==, Rational)
the Bayes-optimal behavior an independent reference computes for
that world.

### 14.1 Executed interpolation, defined

Sufficiency over an infinite class is not executable; the honest
executable form has three parts, each already law-shaped:

1. **The certified class is DECLARED**: C = the closure of the
   World declaration — what a world can say (grids, arities,
   prices, batches, stakes, menus, refine economics). The claim is
   scoped to C by construction, and C is quoted, not implied.
2. **The family DERIVES from the declaration grammar** (the
   sweep-universe law: the universe derives from declared data,
   never hand-enumeration). A generator in the increment's oracle
   directory walks the declaration axes — grid size, arity K,
   price regime (free/dear/intermediate), batch depth, stake sign
   and magnitude, menu shape, refine present/absent — and emits
   the world family. The four acceptance anchors become four
   MEMBERS of the family, no longer the whole of the evidence.
   The generator lands in-tree with its artifact (the generator
   exemption; audit/capture_oracle.py the precedent).
3. **Every member is checked EXACTLY against an independent
   reference**: test/ExactReference.hs (frozen, row 42) extended
   inside test-completeness/ — R-D20 copies with file:line
   provenance wherever a frozen formula is shared, never a parallel
   derivation — computes the Bayes-optimal episode transcript per
   world; the row asserts shipped-vs-reference transcript equality
   at exact ==. The RESIDUAL — the axes and ranges the family does
   not span — is PRINTED by the suite, never absorbed (the
   no-silent-caps law).

### 14.2 The decision-law rows (the 2026-07-16 gap, landing here)

The brief-adherence assessment found the decision side never
property-tested — pins only. The laws land as exact rows over the
family, certifying the EU commitment itself rather than any anchor:

- **VoI >= 0**: the priced deliberation row never makes the agent
  worse off in expectation than the act-now incumbent — an exact
  Rational inequality per family member (the brief's own example of
  a composition, now a law row).
- **Affine invariance**: an affine rescale of the world's declared
  stakes leaves the chosen act invariant, exactly.
- **Admissibility (Wald's face, per-world)**: the chosen act is a
  Bayes act against the reference posterior — the executable
  fragment of the complete-class ground.

Each row arrives WITH its kill (the forward half), read per-row
against the pool (F6's amendment).

### 14.3 The kill side — OB-20/21 discharge here

The x5 sitting's ruling 4 scheduled two mutant pools with named
discharge events and no named home; the boundary audit's OB-row
flags them at this opening (open obligations against the closed
x5-sitting-r0), and THIS boundary is the drafted home — a
certification is honest only if its rows face pools that can reach
them:

- **OB-20, the reasoner pool**: Belief-level operators
  (normalization, refusal-law, measure-shape over the sealed
  reasoner) so the lawful + independence suites' 14 unreached rows
  face a pool that can reach them.
- **OB-21, the enumeration pool**: gating/combinatorics operators
  (enumeration count, membership, fragment-table) for the
  count/membership pins; the t2-price-path gap the first named
  candidate.

Discharge event per the ledger: the pools land in audit/mutants/
with a matrix run whose kill lines reach those stanzas. Verdicts
are the sitting's triage inputs, never auto-deletions.

### 14.4 Surface-final motions FIRST (certify once)

The destination map's own argument — certifying before the
trampoline would have meant certifying twice — binds the two
inherited dockets to run BEFORE the battery:

- **CR1, R9's unification** (the r1 tag's standing question): think
  AND refine on ONE declared tick's menu. No type can yet declare a
  world carrying both — DelibWorld {dwPrice, dwBatch} carries the
  clock, PurchaseWorld {pwStakes, pwLadderCap, pwRefine} the
  economics. The unification is a JOINT WORLD RECORD plus the one
  standing chooseKS sentence carrying wait head, externals, think,
  and refine rows through the same one chooser — a world-type and
  sentence motion, ZERO alphabet motion. [MEASURED at the opening
  (EV-CR1, pack Part IV): the record merge is NECESSARY BUT NOT
  SUFFICIENT — the naive union type-checks and its wire face is
  the pure field union, but every naive tick law fails (decide-once
  starves refine past the first decisive tick, three knob families
  refuted; habitat menus diverge exactly as predicted, 500 thinks
  to the driver cap). The unification's real object is THE JOINT
  PREPOSTERIOR: think's value = the preposterior of the menu's own
  best row — the policy sentence evaluated over itself, step 10's
  reflexive composition demanded by LIVENESS; convergent with the
  banked GroundC remedy (a).] DRAFT DEFAULT: unify at this
  boundary, before certification, WITH the joint preposterior as
  the measured work order; the alternative (certify as-is,
  unification a named follow-on) re-opens certification later by
  construction but is the honest smaller increment.
- **CR2, F5's deletion** (the r1 tag's docket, argument pre-written
  at trampoline pack XIII.3): forgoneS (Purchase.hs:126) is
  mentioned only in refineRow's arm reachable where pess <= 0, on
  which `If (Gt pessV zeroM) pessV zeroM` is identically zeroM —
  M34's disposition is the vacuity proof (the "mutant" is
  extensionally identical to shipped src). A PRICED MENTION THAT
  BUYS NOTHING is the prodTable conviction relocated inside a
  sentence. Deletion MOVES THE SENTENCE'S PRICE — adjudication,
  the author's. DRAFT DEFAULT: DELETE before the battery; the new
  price recorded; M34's identity becomes the deletion's
  extensional pin; every price-mentioning row re-derived from the
  frozen artifact.

After both rulings the surface is FINAL; any later motion re-opens
certification by construction, which is the destination map's
termination argument in contrapositive.

The dockets' MUTUAL order is also fixed (the review of 2026-07-27):
CR2 FIRST, then CR1, then the battery. They interact through price —
F5's deletion moves the purchase sentence's price, and CR1's
unification rows re-derive prices on the joint surface — so the
price delta is computed ONCE, against a known surface: delete on the
shipped surface where M34's extensional pin already holds, then
unify, then certify.

RULED IN-SESSION 2026-07-27 (the author, direction recorded in pack
Part VI; each ruling RATIFIES at its increment's freeze tag): the
boundary executes as THREE INCREMENTS, EACH UNDER ITS OWN TAG —
(1) the F5-deletion increment (smallest motion, pin in hand);
(2) the joint-preposterior increment (its own oracle, its own
mandate round, its own freeze: EV-CR1 falsified the record-merge
premise, and a reflexive preposterior — think's value defined over
the menu that contains think — is a novel semantic composition
whose liveness must be re-argued, not inherited; folding it into
the battery's freeze would mean drafting battery rows against a
surface still being designed); (3) the certification battery
against the then-final surface. This is 14.4's own logic applied at
increment granularity, and the X.5 ruling-8 precedent (one boundary
at a time; smaller bets localize). Certify-as-is was CONVICTED by
the contrapositive, its only defense removed by EV-CR1 (the
unification is no longer speculative — its object is identified and
measured). RECORDED WITH THE RULING: the joint-preposterior
increment discharges the GroundC deadlock fork THROUGH THE FRONT
DOOR — the demand gate asked for a measurement and EV-CR1 is that
measurement; R1's "documented myopic behavior" gets its named
successor rather than a silent upgrade.

### 14.5 What this boundary does NOT do

No alphabet motion (prodTable stays 9/1; a needed production is
stop-and-report through the two-sided entry gate — and per the
step-10 clause, any banked composition-failure this boundary would
rely on is re-executed first; the alphabet last moved at c2ca82c,
2026-07-25, and every bank relied on since was re-executed at or
after that motion). No demonstration-tier work (the H-row's eight
flagged symbols — the governor-features face and the founding
interface's dormant sentences — stay untouched; that vocabulary is
destination step 5's). No wire change beyond what the joint world
declaration requires (transport unbroken; the 2026-07-25 ruling 2
stands) — and that clause is not left open-ended: the CR1 prototype
transcript PINS exactly what the wire face gains (the joint
declaration's fields, enumerated), so the sitting rules on a
measured surface, never on this carve-out sentence. OB-15, OB-19, the quine face, continuous carriers:
demand-gated, untouched.

### 14.6 The oracle shape (drafted rows; oracle-first binds)

- **The family rows**: per family member, exact transcript equality
  shipped-vs-reference (the interpolation battery, 14.1).
- **The law rows**: VoI >= 0, affine invariance, admissibility over
  the family (14.2).
- **The unification rows** (under CR1's default): both internal
  acts standing on one declared tick's menu; the one-chooser law on
  the joint menu; the g3 (think) and g5 (refine) shapes reproduced
  on the joint world; the price-only differential re-run on the
  joint surface (same binary, two declared price rows, zero code
  diff).
- **The F5 rows** (under CR2's default): the sentence's new price
  pinned from the frozen artifact; pre/post-deletion extensional
  equality (M34's identity as the pin).
- **The pool rows**: the matrix run reaching the lawful,
  independence, and count/membership stanzas (14.3).

Per the increment protocol as amended through the trampoline: the
oracle is written oracle-first, runtime-red against type-surface
stubs, SAT-transcribed in overlay form flag-faithful, E-gate
allowlists enumerated against the SAT overlay, every red row with
its satisfiability transcript and every new row with its kill; the
six red-team mandates run against the increment; the pre-freeze
lint transcript rides the pack; the author freezes, THEN
implementation. This section is a charter, not an oracle.

### 14.7 The register (drafted defaults; the author rules at the freeze)

- **CR1** — R9's unification: RULED IN-SESSION 2026-07-27 — UNIFY
  HERE, SPLIT INCREMENTS (the joint-preposterior increment gets its
  own oracle, mandate round, and freeze; the battery certifies the
  then-final surface). Ratifies at the increments' freeze tags;
  the direction and its grounds in pack Part VI.
- **CR2** — F5's forgone term: RULED IN-SESSION 2026-07-27 —
  DELETE. Two statements the ruling text carries (the author's
  words, pack Part VI): deletion re-prices the purchase sentence
  downward and thereby SHIFTS PRIOR MASS toward it — deleting dead
  weight is still PRIOR MOTION, which is exactly why it is the
  author's signature and not cleanup; and the re-derivation
  discipline — every price-mentioning oracle row re-derives from
  the frozen pricing artifact POST-deletion, no row inherits a
  pre-deletion number, with M34's identity pinning that the
  extensional surface did not move while the price did (EXTENSION
  FIXED, PRICE MOVED is the deletion's complete signature).
  Ratifies at the F5 increment's freeze tag.
- **CR3** — the family's axes and size: which declaration axes the
  generator walks, at what density; the printed residual's form.
  [MEASURED at EV-CR3: the walk's proof of concept is green — 72
  cells from four declared axes, shipped == independent reference
  at exact == in all 72, the four t2 anchors falling out of the
  walk byte-equal to Anchors.t2RowsX. The register question is now
  EXTENSION (the residual's axes: purchase worlds post-CR1, K>2,
  the t1/t3 faces, stream compositions), not feasibility.]
- **CR4** — the decision-law row set: VoI/affine/admissibility in
  or out, each with its ground (the 2026-07-16 assessment the
  provenance). [MEASURED at EV-CR4: VoI >= 0 exact at all 227
  decision points of the family, minimum gap exactly 0 (the
  saturation ties); scaling invariance act-for-act at 3/3. Two
  sharpened sub-questions: the SHIFT half of affine invariance is a
  menu-convention ruling (the declared wait row pins zero); and
  admissibility's independent content needs richer menus than the
  binary face.]
- **CR5** — OB-20/21: discharge at this boundary (default; the
  OB-row flag is the trigger) vs a separate increment.
- **CR6** — the sufficiency claim's prose form for the paper: what
  "in general" honestly says given a declared class, a derived
  family, and a printed residual.
- **CR7** — the frozen-tool repairs staged at the opening
  (boundary-audit BF-row -S->-G; M5-row mutant-file definition
  sites): execute at the freeze under the key (default) vs decline.

### 14.8 The joint-preposterior increment (OPENED by the author's instruction of 2026-07-27 — "push, then open the joint-preposterior increment", immediately after the f5-freeze-r1 countersign; the ruled sequence's second act, on the post-deletion surface)

**The object.** EV-CR1 measured that no naive tick law is coherent
on the union surface; the unification's real object is the
REFLEXIVE VALUE — think's value defined over the menu that contains
think. The increment's design, drafted from the opening's evidence
programs (pack Part IX) and BUILT ORACLE-FIRST like everything
else:

1. **THE BASE-FIX** (EV-JP1): the preposterior's base case is the
   best external row OF THE DECLARED MENU. Measured: J1 — the four
   t2 anchors reproduce EXACTLY under the reflexive design, because
   menus are world-declared (the step-5 shape; the R-R2 option-order
   pin) and t2 worlds declare [L, R]: ANCHORS PRESERVED BY
   DECLARATION, not by luck. J2 — the
   phantom-value divergence is cured AT THE ROOT: EV-CR1's
   500-think diverger now waits at tick 0, because think's honest
   VoI over the actual menu is zero (the phantom 0.4 was actValueS
   evaluating acts not on the menu; honest VoI of a menu no
   evidence can improve IS zero, and the agent rationally waits).
2. **THE LOOKAHEAD REFINE ROW** (EV-JP2/JP2c, the front-door
   discharge — with the opening's OWN correction). The myopic
   single-step clamp (the deadlock's mechanism, EV-JP0 re-confirmed
   on the closed tree: wait 60/0/0 both deep cells) is replaced by
   a lookahead over buy-chains — but the opening MEASURED that
   chain-depth alone does not cure: at the deep cell's best counts
   (60,0) the guard goes positive with the chain (pess +0.0173 at
   k=4, +0.145 at k=5) yet the ONE-TICK chain value is negative at
   every (counts, depth) probed — THE MINTS EAT A SINGLE RESPOND'S
   VALUE. The frozen d6.2 world profits from its chain over
   FIFTEEN responds: vocabulary value AMORTIZES over the episode's
   remaining ticks. The cure is therefore lookahead-over-buys
   TIMES the declared-horizon amortization — and this is the
   kLadder multiplier's original role, generalized lawfully,
   exactly as 13.3's remedy (a) phrased it: pwLadderCap was a
   BAKED HORIZON (16 ~ the future responds a purchase amortizes
   over), convicted for bakedness, not for the horizon idea. The
   joint design derives the amortization from the WORLD-DECLARED
   episode length (already on the wire), never a constant.
3. **THE JOINT WORLD RECORD** with the wire face as pinned at
   EV-CR1 P4: the pure field union plus the declared lookahead
   depth — no other new field kind.

**The liveness argument, re-argued fresh (the ruling's demand).**
Think terminates by the honest-VoI tie — with the base equal to the
menu's own best external, prepost >= bestExt always (VoI >= 0,
RE-EXECUTED on the base-fixed object at EV-JP8: 240 decision
points, five stream shapes, zero violations — the EV-CR4 bank had
expired with the base change, the mandate-1 finding) and equality
at information exhaustion makes think TIE and lose to the
incumbent, structurally — plus row-absence at buffer exhaustion. Refine's lookahead recursion is well-founded (r
strictly decreases to the external-only base). LOOP-level refine
termination is an oracle obligation, not an assumption: the
transcript rows pin it.

**The register (JP1-JP10; the author rules at this increment's freeze):**

- **JP1** — the lookahead depth r: a world-declared field (the
  kLadder lesson: never baked); its wire name and default-absent
  semantics.
- **JP2** — pwLadderCap's fate: the cap was the myopic route's
  approximation of multi-step reach; the lookahead prices reach
  exactly. But frozen d6 rows CONSUME the cap (d6.4 pins cap-0
  kills / cap-16 buys), so deletion moves frozen anchors —
  adjudication. Drafted: the shipped myopic route keeps its cap and
  its pins; the JOINT world's refine row is the lookahead form; the
  cap's deletion is docketed to the battery sitting with the d6
  re-open priced.
- **JP3** — the sayable route: the reflexive value as a SENTENCE by
  d-unrolling (the vThink3Sentence precedent, g3.4's pin chain);
  the engine recursion is a fast path pinned extensionally to the
  unrolled sentence in the same increment (the optimisation law);
  the unrolled sentence's form, env-binding of the per-branch guard
  scalars, and its PRICE are this register item's content.
- **JP4** — cross-nesting (think inside refine's lookahead,
  think-of-think): EXCLUDED from this increment's draft — J1/J2
  hold without it and the deadlock's cure needs only buy-chains
  (EV-JP2); re-enters demand-gated with a measurement.
- **JP5** — the episode-shape law (CR1a's answer): the WORLD
  declares its episode shape — decide-once (the t2 face) or
  standing-service (the purchase face) — exactly as it declares its
  menu; both shapes carried by the one loop, the shape a
  declaration field. AMENDED at the mandate round (the wait-sense
  line): the decide-once null external is the null COMMITMENT and
  shares only the string "wait" with the standing loop's per-tick
  idleness; rows and prose citing "the agent waits" name the sense.
- **JP6** — the mandate round: FULL, per the ruling (fresh-context
  reviewers, one mandate each), run against the drafted oracle.
- **JP7** — the mutant pool's heirs: the M28/M30 class (ties,
  internal-first) re-cut against the joint loop, plus every new
  oracle row's forward-half kill.
- **JP9** — the said-in-sentence question, EXTENDED at the mandate
  round to the think side: the joint sentence carries no Get
  mention (the t2 policy's priced Get "price" is gone; the ceremony
  binding shares the world's declared namespace per R5), and
  today's price/choice namespace-invariance is a CONSEQUENCE OF
  GET-FREENESS, declared as such — any in-sentence mention the
  sitting orders re-opens it. The F5 doctrine cuts against
  re-minting a priced mention that buys nothing; the re-pricing of
  the t2 policy under the joint form is the sitting's to ratify.
- **JP8** — THE HORIZON IS THE CAP'S TRUE NAME (the opening's
  finding, EV-JP2c): refine's value in a standing world =
  (lookahead over buy-chains) x (the declared remaining-episode
  amortization); pwLadderCap is the baked ghost of that horizon.
  AMENDED AT THE MANDATE ROUND (EV-JP7's demonstration): the
  landed standing DP is the HINDSIGHT face — the declared-stream
  PLANNING evaluator (at tick 44 of a shared 45-prefix pair its
  acts differ by the tail alone) — which is exactly the
  optimal-play reference the certification battery needs; the LIVE
  agent's standing row value is READING B, the true preposterior
  (expectation over the predictive), REGISTERED demand-gated with
  no exact tractable form yet. The cap's retirement path (JP2's d6
  re-open pricing) keeps its ground.
- **JP10** — THE EXPLORATION SCOPE (registered in full at the
  mandate round; mandate 2 found it cited-not-registered). The
  refine lookahead explores extensions of the owned set; its two
  halves: DIRECTION — closed by dominance (EV-JP6: the
  direction-neutral both-children walk strictly dominates the
  hi-spine probe; a baked direction dies like a baked constant);
  DEPTH — a DECLARED world field (jwDepth; every oracle world
  declares 7, the frozen deepChain's depth plus one), so the
  sitting's ruling is the field's ratification or its derived
  successor — nothing frozen moves either way (the mandate-6
  repair).

**The oracle shape (drafted; oracle-first binds).** The
anchors-by-declaration rows (J1's four cells); the phantom-cure row
(the habitat cell's tick-0 wait, the honest-VoI value pinned
exactly); the deadlock-cure row (the deep cell's first-refine tick
and full transcript); the liveness rows (tie-structural,
absence-structural, loop-termination); the sayable-route pin
(engine == unrolled sentence, extensional, in-increment); the joint
sentence's price rows (re-derived post-F5, the ruling's
discipline); kills per row, read per-row against the pool.

### 14.9 The wire docket riding the next sittings (recorded 2026-07-28; the author: "as long as they're on the roadmap")

Three life-agent escalations of 2026-07-27 (issues #19, #20, #21 —
one batch, all on live-path evidence) are ON THE ROADMAP as of this
note, awaiting their SCHEDULING RULING at the next author sitting
(the jp freeze sitting if the author extends its docket; the
certification battery sitting by default). None touches the JP
oracle; all are wire/hosts-side and parallelizable with the JP
implementation. Each lands as its own oracle-first frozen increment
when ruled — this note schedules nothing by itself; it fixes the
docket so no sitting can miss them.

The natural order, from the dispositions pack's own analysis
(VIII.1-VIII.4), is:

1. **#20 first** — the K-ary readout micro-increment (VIII.1:
   GRANT, cheaper than filed; p0/the O(K) vector on the decide
   reply, observability-only). It is the INSTRUMENT that watches
   OB-19's null cap bind on live traffic, and the consumer now
   states it gates their M4 go/no-go.
2. **The OB-19 heir second** — enumeration breadth beyond
   one-vs-rest (ledger row OB-19, RULING-PENDING; #21 its first
   field demand, now a declared M4 blocker). The author's caution
   rider binds: the increment's oracle carries a ms/tick row; the
   consumer has OFFERED live latency-vs-K / population-vs-K curves
   (solicited in the issue comment of this date) to ground it.
3. **#19 (theta ceiling)** — either horn 1a (hello-declared finer
   theta grid, VIII.2's recommendation; now carrying a measured
   -0.58 EU/question regression on a committed path) or absorbed
   into VIII.4's one-doctrine option ("declared resolution, priced
   by mention bits, is world data; hard-wired resolution is a
   limitation with an heir"), which would dispose of #19(1a),
   OB-19's design direction, and W3's fifth scoping line in one
   ruling. Which of the two is the sitting's call.

## 15. The wire docket boundary — increment #20, the K-ary readout (OPENED by the author's election of 2026-07-31, in-session, immediately after the battery-freeze-r0 countersign: "Open #20", answered to the session's opening question, which named the battery tag's own scheduling ruling as the authorization)

The authorization is `battery-freeze-r0`'s register, verbatim: "the
14.9 wire scheduling (#20 first, the OB-19 heir second, #19
1a-or-doctrine third)". This is the first of those three, and the
first sitting of the wire docket — which makes it also the sitting
the battery tag routed its own post-tag findings to ("Anything
surfacing post-tag enters as a frozen-layer inventory row at the
wire docket's next sitting - the standing per-sitting channel,
never a standing license"). Section 15.6 opens that inventory.

### 15.0 The object

`p1` in a decision reply is P(atom 1) at ANY arity (membrane-wire.md:356
— the null-atom convention's own corollary, W3). That is the right
diagnostic for a binary world and it under-reads a (K+1)-ary
predictive: when the engine chooses `respond_j` with j /= 1, `p1` is
the mass of a DIFFERENT candidate. Issue #20 asks for the null mass
`p0`, the `argmax_code` and its mass `p_argmax` — or the full O(K)
vector — as OBSERVABILITY ONLY, in the same class as `residual_mean`
and `sensitivity` (membrane-wire.md section 6.4): telemetry on the
reply, consumer discipline binding, no decision-path semantics.

Two mechanical facts, both measured before the boundary opened:

1. **The ask is host-layer arithmetic over ALREADY-EXPORTED verbs**
   (dispositions-pack.md VIII.1, finding 1; re-confirmed at this
   opening against the shipped tree). `predictMassS` is already
   called at the reply builder (Host.hs:425) and `agentObsPoints`
   already enumerates the declared observation space three lines
   into `thinkValue` (Host.hs:516). The vector is a map over the
   second through the first. No new export, no new constructor, no
   engine change: THE ALPHABET DOES NOT MOVE and `prodTable` stays
   20/1. The primitivity gate is visibly not engaged — nothing here
   is a candidate production, so clause (a) is not owed.
2. **The cap BINDS at the operating point** (VIII.1, finding 2;
   K=6, 5845 models, 400 interleaved ticks): the readout's `p0`
   sits at 0.17998972 against R-D23's cap of 0.9/(K-1) = 0.18 —
   pinned to four significant figures — while the empirical null
   rate is 0.735. The engine under-reads the null atom four-fold
   and no evidence can fix it, because no sentence in the family
   can say "atom 0 is likely" (`Enumerate.hs:467`, `atoms =
   [1 .. k - 1]`).

Fact 2 is why #20 is scheduled FIRST rather than filed as a
convenience. The null-rate parameter — the W3 sitting's fifth
scoping line, and OB-19's design direction — is UNOBSERVABLE today,
and `p0` is exactly the number that observes it. Landing #20 is the
precondition for ruling OB-19 (item two) on evidence rather than on
argument.

### 15.1 The anchor-safety finding (opening inspection, stated as a claim to be executed against)

No frozen row pins the decide reply's bytes:

- `test-transport/Transport.hs:95` derives its expectation from the
  frozen pure core itself — `expectedReplies = snd (mapAccumL
  serveLine hostStart requests)` — which is the R-D20 form, never a
  hand-copied literal, so an additive field moves both sides
  together.
- The trampoline's wire rows match by `isInfixOf` (g6.1 at
  Trampoline.hs:500-502, g6.2 at :520-522), not by whole-reply
  equality.
- Acceptance's "probe rows: p1 exact" (test/Acceptance.hs:211)
  reads `predictMassS` DIRECTLY against `Anchors.t1ProbeRowsX`; it
  never goes through the reply builder.

So an additive readout is EXPECTED to move no pinned anchor. This
is a claim the full-corpus run must CONFIRM, not assume — the
increment's own step-0 baseline (green on the sealed tree, before
any edit) is what licenses attributing any later red to the
increment, and any pinned-anchor movement under an additive change
is stop-and-report, not a repair.

### 15.2 What this boundary does NOT do

- It does not rule **OB-19**. #20 is that ruling's INSTRUMENT, not
  its substitute; the ledger row stays RULING-PENDING and comes due
  at item two.
- It does not touch **#19**'s theta ceiling, nor the
  1a-or-doctrine fork, nor `JP2-d6`/pwLadderCap's RETIRE-UNTIL-N
  question — all three are item three's business.
- It does not move the alphabet, does not add a production, and
  does not put a number on any decision path. A readout reachable
  from choice would be semantics, not telemetry, and would change
  the increment's whole class: that is a stop-and-report trigger,
  not a design option.

### 15.3 The oracle shape (drafted rows; oracle-first binds when the increment's oracle freezes)

`test-readout/`, its own cabal stanza spliced at the freeze, the
`test-trampoline/` wire-row pattern and the `test-battery/` freeze-kit
pattern. Every row arrives WITH its unique kill against the STANDING
(pre-increment) corpus — the forward half of the kill-matrix clause;
sibling shadowing within the new suite is recorded as verdicts at the
next matrix run, never a close-blocker.

| row | the claim | its designed killer |
|---|---|---|
| r1 | at K=2 the reply's existing fields are byte-identical — the readout is PURELY ADDITIVE | a field-clobbering mutant |
| r2 | entry j == `predictMassS full j ag` for every j in `agentObsPoints ag` (R-D20 copy; the reference computed in-suite from exported verbs, never a literal) | an index off-by-one |
| r3 | the vector sums to 1 — the sealed reasoner's measure law, crossing the wire | the OB-20-class normalization mutant |
| r4 | `argmax_code` indexes a maximal entry, `p_argmax` IS that entry, and the tie rule is the declared one | a tie-rule flip |
| r5 | `p0` is the null atom's mass, and on a CONSTRUCTED null-dominant stream it sits at the R-D23 cap while the empirical rate is far above — the OB-19 instrument row | the vector built over `[1 .. K-1]` (Enumerate.hs:467's atom list), dropping the null |
| r6 | the vector survives the pipes (spawned host, the g6 form) — a WIRE fact, not a library fact | a serialization/buffering mutant |
| r7 | `p1` still means P(atom 1) at any arity: membrane-wire.md:356's corollary stays true, two-sided | `p1` re-pointed at the argmax |

The standing discipline these rows are built under, named so the
oracle phase cannot quietly skip one: the two-run triptych (a
runtime-red run proving every row CAN fire; a SAT run proving every
row CAN pass); the overlay SAT in its flag- AND package-faithful
form (the prototype wearing `PropLang.Host`'s name, the stanza's
exact flags with `-Werror`, `-hide-all-packages` plus the declared
`build-depends`); an R-D21 satisfiability transcript per red row,
each forcing the frozen side to normal form independently of the
stub side; and R-RED for r5 — the cap window is MEASURED first and
the stream placed strictly inside it, a constructed red, never an
owed one. If the window proves unconstructible, r5 disposes as a
RECORD row with the impossibility argument stated (the
honest-decline path), never fabricated into an artificial cell.

The type-derivation audit binds forward: if any new type reaches a
frozen surface it arrives with its one-line derivation from the
brief. The drafted shape avoids the question — a local
`[(Int, Rational)]` at the reply builder introduces no exported
type.

### 15.4 The register (drafted defaults; the author rules at the freeze)

| id | question | drafted default |
|---|---|---|
| CW1 | the full O(K) vector, or the three scalars (`argmax_code`, `p_argmax`, `p0`) | THE FULL VECTOR (VIII.1's recommendation: same O(K) cost, and the filer's report-pricing use needs EU of every menu row). The scalars are a strict subset, so declining narrows the oracle rather than rewriting it |
| CW2 | `argmax_code`'s tie rule | lowest index wins, DECLARED (r4 pins whichever rule is ruled) |
| CW3 | reply key names and field order | appended after `entropy_bits`, existing fields untouched (r1's additivity) |
| CW4 | rendering of the vector's rationals | the `p1` convention unchanged — `show (fromRational x :: Double)`; the 2^53 rendering cliff (transport t4) applies as it stands |
| CW5 | does the readout ride the internal-act ("think") reply too | NO — it is the DECISION reply's telemetry; the think reply names no act, so there is no candidate to read out |
| CW6 | the consumer discipline (readouts land in ledger rows and footers, never in a branch — HOSTS_PLAN 8.12(b)) | QUOTED INTO membrane-wire.md at the freeze (VIII.1's recommendation), not left in the issue thread |
| CW7 | the frozen-layer inventory row FL-1 (15.6) | repaired at this freeze, under the author's key |
| CW8 | close form | the TWO-TAG r0/r1 form. This is a real implementation increment, not a pin-freeze; the catch-net the battery traded away is where the trampoline E4 and jp package-faithfulness findings both surfaced |

### 15.5 The opening checklist

- **OB-19** — RULING-PENDING, item two of the wire docket. NOT
  ruled here; #20 is its instrument. Recorded so the sitting cannot
  drift into ruling it on argument.
- **JP2-d6 / pwLadderCap** — RETIRE-UNTIL-N, and its N is the **#19**
  sitting (item three), not this one. Stated explicitly rather than
  left silent: a deferred obligation living only in a comment is the
  R6 disease, and the RETIRE-UNTIL-N clause exists to put the return
  row on the right boundary's checklist, not on the next one that
  happens to sit.
- **OB-20 / OB-21** — discharged in SUBSTANCE at battery-freeze-r0
  (register CR5; the pool M56-M61 committed under `audit/mutants/`,
  the matrix at `test-battery/opening/pool-reach.txt`, titled "the
  discharge evidence"). Their LEDGER ROWS are stale — see FL-1.
- **The boundary audit** — run at the opening:
  M5=0, H=0, OB=1, BF=0. The single OB flag is FL-1; the M5 and H
  rows are clean; the banked-failure row is clean against the last
  alphabet motion (840961d, 2026-07-26).
- **The six red-team mandates** — to run, fresh-context reviewers,
  one mandate each. Mandate 6 ("what is it a function of?") is the
  live one here: the readout is a function of the predictive at
  `feats ++ act` and of the DECLARED observation space — not of the
  menu, and not of anything on the decision path. Mandate 5
  (silently overloaded convention) has a standing candidate in
  `p1`'s meaning, which r7 pins two-sided.

### 15.6 The frozen-layer inventory (opened here; the battery tag's routed channel)

**FL-1 — OB-20 and OB-21 read `SCHEDULED@x5-sitting-r0` against a
boundary that closed, and against their own executed discharge.**
`battery-freeze-r0`'s register CR5 states it outright: "OB-20/21 are
DISCHARGED at this boundary: M56-M61 committed with reach
demonstrated". The evidence is in the tree — the six mutants under
`audit/mutants/`, the reach matrix at
`test-battery/opening/pool-reach.txt` (M57 the independence suite's
sole killer, M60 the count stanza's, M61's predicted
generator-blindness cured in-increment by g-b4.1). But
`OBLIGATIONS.md` was last written at `trampoline-freeze-r0`
(e4f41f3): the battery's freeze kit never patched the ledger, so
both rows still carry the SCHEDULED state and neither carries a
discharge event. The substance is done; the record is wrong.

This is the OB-row of `tools/boundary-audit.sh` working exactly as
designed — the row installed because the VoI obligation evaporated
inside a composite, catching a discharge that happened and was
never written down. `OBLIGATIONS.md` is manifest-frozen, so the
repair executes at THIS freeze under the author's key (CW7):
both rows to `DISCHARGED@battery-freeze-r0` with their provenance,
the discharge events named.

**FL-2 (opened empty).** Anything the mandate round or the oracle
phase surfaces against frozen prose lands here before the freeze,
in the form its text class demands.
