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
data World = World          -- declared OUTSIDE the core, carried at the membrane
  { wLatent :: Grid          -- was thetaPoints
  , wTau    :: Grid          -- was tauPoints
  , wRho    :: Grid          -- was rhoPoints
  , wObs    :: Carrier Obs }  -- was obsCarrier / obsSpace
```

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
| `Mul` | **SURVIVES** | FORCED by the categorical (`catBody`, K>2, `Enumerate.hs:486`): the `(1−θ)/(K−1)` spread couples a *world integer* `(K−1)` **multiplicatively** with the hypothesis variable `θ`. Weight-form scales the target atom to `(K−1)·θ` against `(1−θ)` for the rest — an irreducible `Mul` of a variable by a world constant. Validated this session (`CatBody.hs`: both `Div`- and `Mul`-forms reproduce `[7/30,7/30,3/10,7/30]` exactly; a multiplicative op is unavoidable for K>2). At K=2 `(K−1)=1`, the multiply is identity — which is why `bern` alone looked Mul-free. |
| **survivors** | `Add Sub Mul Gt If` | + the leaves `Lit`/`Get`/`Var` and the grammar sorts (`Code`, `CondE`, `SawE`, `ElimJ`, `Expect`, `Argmax`). |

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
   but a cumulative marginal is a product of per-tick rationals whose
   denominators grow with stream length. Confined: the per-tick **belief
   state** is renormalized each tick (denominators bounded by the grid);
   only the **reporting** loss accumulator would grow, and it is display —
   report per-tick loss exactly, accumulate for display in §4. State stays
   exact and bounded; nothing unbounded is load-bearing.
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

- exact rational arithmetic, shipped-body-determined: `{Add, Sub, Mul, Gt,
  If}` (the two-sided entry gate: a terminal survives only if a shipped
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
