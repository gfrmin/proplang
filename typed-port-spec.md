# proplang typed port: specification (Haskell target)

Design document 3. Goal, verbatim from review: as much as possible of the
language and its execution becomes fait accompli rather than discipline —
"don't rely on discipline/convention/intelligence AT ALL." The consumer of
this spec is a coding agent (see CLAUDE.md for the build protocol); the type
system's job is to make the agent's shortcuts *unrepresentable*, and where
types cannot reach, frozen tests and audits take over. Every invariant below
is therefore tagged with its enforcement mechanism:

    [COMPILE]   ill states unrepresentable; violation = type error
    [PROPERTY]  extensional law checked by QuickCheck, frozen
    [FROZEN]    behavioral acceptance test or source audit, frozen
    [RESIDUE]   cannot be enforced; named

## 1. Why Haskell (recorded decision 3)

OCaml's abstract types seal the reasoner equally well, but OCaml does not
track effects: a hidden `Random.float` or a mutable cell inside the language
module type-checks fine, and purity regresses to grep-discipline. In
Haskell, the evaluator's type `evalx :: Expr env t -> Env env -> t` contains
no IO, so "no hidden randomness, no hidden state, no hidden clock in the
language" is checked by the compiler on every build. Purity was our largest
convention surface; this closes it. Acknowledged costs: laziness makes
cost-of-computation opaque (space leaks; mitigated by strict fields and
`-Wall -Werror`), and the well-typed-interpreter encoding (S3) is more
ceremony than the Python tuples. Rust was considered and rejected for the
same reason as OCaml: privacy yes, effect tracking no.

## 2. The sealed reasoner                                          [COMPILE]

One module owns all probability arithmetic. Its export list is the whole
ballgame — the `Belief` constructor is not in it, so no code outside the
module can read, write, or even name a log-weight. I1 stops being a
docstring and becomes a fact about what programs *can be written*.

```haskell
module PropLang.Belief
  ( Space, mkSpace, spacePoints -- spacePoints: the declared point list
                                -- (amended at code-freeze-r0, pack §6.10
                                -- item 6 — Code/Pos evaluation enumerates
                                -- a Space; the weights stay sealed)
  , Belief                      -- abstract: constructor NOT exported
  , Event, is, event            -- host-layer smart constructors
  , Kernel, kernel
  , Evidence(..)                -- closed variant: I2, see below
  , Bits(..), LogProb(..)       -- newtypes; derived numeric instances
  , uniform, point, fromBits    -- the ONLY prior sources in the system
  , expect, prob, push, cond, logPredict
  , entropyBits, top            -- CL-1 diagnostics, read-only by type
  ) where

data Belief a   -- = MkBelief !(Space a) !(Vector LogWeight)  (unexported)

fromBits   :: Space h -> (h -> Bits) -> Belief h
expect     :: Belief a -> (a -> Double) -> Double
push       :: Belief a -> Kernel a b -> Belief b
cond       :: Belief a -> Evidence a -> Maybe (Belief a)  -- Nothing = impossible evidence, total
logPredict :: Belief a -> Evidence a -> LogProb
```

`Bits` and `LogProb` are exported newtypes (DerivingStrategies for the
numeric instances), not transparent synonyms: confusing bits with nats at
the module boundary is precisely the bug class this port exists to make
unwritable. `cond` returning `Maybe` makes conditioning-on-the-impossible a value, not
an exception: totality [COMPILE]. `draw :: Belief a -> IO a` does not live
here — it lives in `PropLang.Host`, and its `IO` type is CL-2 made
compiler-checked: the language cannot utter it, because uttering it would
change the evaluator's type. Implementation standard (adopted from the
Phase 2 port, decision 7): `draw` samples by walking the cumulative
probabilities of the public `top` diagnostic, so even the host never sees
a log-weight — I1 binds the last component that used to sit outside the
sealed module. A `draw` that touches weights directly is nonconforming.

Evidence is a closed variant — I2 [COMPILE]:

```haskell
data Evidence a where
  Is  :: Event a -> Evidence a
  Saw :: Eq o => Kernel a o -> o -> Evidence a
```

No third constructor, in particular no function case. The engine can never
receive an opaque closure as evidence because no such term type-checks.

## 3. The grammar as a GADT: ill-typed sentences unrepresentable   [COMPILE]

The Python port's `evalx` could be handed `('if', 3, ...)` and would fail at
runtime. The typed grammar is indexed by result type and by a typed
environment (standard well-typed-interpreter construction, de Bruijn
indices), so a sentence that would crash cannot be *constructed*:

```haskell
data Expr env t where
  C      :: Grid -> Ix -> Expr env Double            -- priced constant;
         -- NOT exported: constructed only via
         -- mkC :: Grid -> Ix -> Maybe (Expr env Double), so an off-grid
         -- index is unconstructible rather than denoting. Get's 0.0 is
         -- dormancy for names that may appear; a grid index never can,
         -- and letting it denote leaves the prior improper over the
         -- sentence space (Phase 2 review ruling).
  Get    :: Name -> Expr env Double                  -- absent name ~> 0.0
  If     :: Expr env Bool -> Expr env t -> Expr env t -> Expr env t
  Gt     :: Expr env Double -> Expr env Double -> Expr env Bool
  Var    :: Idx env t -> Expr env t                  -- typed de Bruijn
  -- the verbs, sayable (reflexive closure):
  Push   :: Expr env (B a) -> Expr env (K a b) -> Expr env (B b)
  CondE  :: Expr env (B a) -> Expr env (Ev a) -> Expr env (Maybe (B a))
  Expect :: Expr env (B a) -> Fn a -> Expr env Double
  Argmax :: Expr env [o] -> Expr (o ': env) Double -> Expr env o
  Call   :: StdName args t -> Args env args -> Expr env t
  ExpFam :: Space Double -> Carrier c -> Stats c -> Expr env (K Double c)
  -- E3 as ruled: no Params slot until its first consumer (a slot
  -- with no inhabitant forces the evaluator to invent semantics);
  -- the node declares its parameter space as an opaque payload
  -- (priced 0, recorded payload convention) because a kernel HAS a
  -- domain and declaring it is declared structure. The parameter
  -- itself arrives where the kernel is applied, as K Double c says.

evalx :: Expr env t -> Env env -> t     -- pure: the type IS the purity claim
```

Two consequences worth flagging. First, `Argmax` binds its option variable
in an *extended typed environment* — "the value expression may mention the
candidate option" is now scoping discipline enforced by the index, not by an
env-dict convention. Second — the point surfaced by the port — **the grammar
is defunctionalized**: `Fn a` and `Stats c` are first-order syntax, not
Haskell lambdas. Embedding host lambdas in sentences would smuggle opaque
closures back into the language through the syntax door that I2 closed at
the evidence door. Declared structure now applies to the policy fragment
too, and it is [COMPILE].

Bit-pricing rides the same structure: `bits :: Expr env t -> Bits` is total
structural recursion over the GADT, so every constructible sentence has a
price — "no unpriced sentence exists" is [COMPILE] via totality
(`-Wincomplete-patterns` as error). Pricing requirements for the policy
fragment (load-bearing once the fidelity ladder lands): the code must be
prefix-decodable, so EVERY node pays its constructor-choice cost
log2(nExpr) with no exemptions — `Var` included — and then its content:
`Var` adds log2(scope size), a variable mention being a name mention,
and names never free once there is more than one (same rule as `Get`
over FEATURE_NAMES). Description length is always relative to the
generating fragment's production grammar: the same surface tree prices
differently derived as MODEL versus as EXPR, which is why model-fragment
anchors are untouched by policy pricing (the two-pricer arrangement,
Phase 2 R4, is principled coding, not a fudge). `Fn` must be inhabited
by first-order constructors before any priced policy sentence ships;
discharging `Expect` by empty case is a parity-phase expedient only.

> **The production system (normative; the priced object is this
> table, not the Haskell encoding).** Description lengths are charged
> per node against the node's generating sort:
>
> | sort | written alternatives | node cost |
> |---|---|---|
> | EXPR | C, Get, If, Gt, Var, Push, CondE, Expect, Argmax, Call, Pos, ToR, Add, Sub, Mul, Div, Neg, Exp, Log | log2 19 |
> | FN | FnInd, FnUtil | 1 bit |
> | STATS | SId | 0 bits |
> | KER | ExpFam, Code | log2 2 |
> | STDNAME | EU, IsEq, VAct, VThink, VThinkK, VPre | log2 6 |
> | UTIL | USay | 0 bits |
>
> STDNAME row amended at the prepost freeze to cover both the
> ladder's VThinkK (missed at that boundary) and VPre — two alphabet
> changes, one repair, per the frozen-text-states-no-falsehood
> standard.
>
> EXPR and KER rows repaired at the sentence freeze (step 3,
> 2026-07-15; the surfaced-defect delegation, sentence-author-pack.md
> §25/§27): step 1 (code-freeze-r0/r1) grew EXPR 10 -> 19 (Pos, ToR,
> Add, Sub, Mul, Div, Neg, Exp, Log) and KER 1 -> 2 (Code joined
> ExpFam), but this normative table was never amended at that
> boundary — a frozen-text falsehood standing since 2026-07-14,
> discovered by the step-3 sweep. The rows now state the as-frozen
> alphabet (prodTable's 19/2, pinned since that freeze by
> test-hygiene's lg 19 rows and test-expfam's lg 2 row); the
> membership lists are derived from the frozen pricer's own case
> arms (Syntax.hs, bitsAt), never from memory.
>
> STDNAME row amended again at the sentence freeze (step 3,
> 2026-07-15; delegated edit, sentence-author-pack.md SS20.5): `Bern`
> left the stdlib — Bernoulli emission is said as a CODE of the
> declared production table, and the evaluator's `bernFast` remains
> the E7-pinned fast form. Every STDNAME mention re-prices by the
> lg 7 - lg 6 = 0.222-bit refund (P5's pin re-pricing; the three
> sayable-fixture pins moved with it, D4 adjudication).
>
> Hole sorts are declared by the grammar, not inferred from types:
> kernel-valued positions (e.g. `Push`'s second child) are KER holes;
> function-valued positions on `Expect` are FN holes; everything else
> is an EXPR hole. This is what keeps the code prefix-decodable
> (Kraft-tight per hole): a free-riding alternative alongside the
> nineteen EXPR codewords at the same hole would violate Kraft; at a
> declared KER hole the two members (`ExpFam`, `Code`) each pay their
> log2 2 constructor choice (the step-1 repair note above).
> Utility-valued positions are declared UTIL holes (KER's sibling):
> USay is the sole codeword, its payload pricing as EXPR in a
> two-variable scope. The subprogram is closed by construction —
> evaluation discards the outer environment — so utilities are
> featureless and clockless as a definition-level fact, and Get
> inside a utility is dormant, per-node-priced syntax.
> GADT terms outside this published fragment (the Haskell encoding
> admits, e.g., `Var` at a kernel-typed hole) remain per-node priced
> for totality of `bits`, but lie outside the generative prior: no
> enumerator generates them and 2^(-|program|) normalizes over the
> published fragment only. Growing any sort's alternative count is a
> reported alphabet change repricing that sort's every mention
> (written-alternatives convention, R2); adding a sort is a reported
> grammar change requiring this table's amendment at a freeze
> boundary.

> **The namespace law (normative; membrane freeze).** Description
> length is namespace-relative: a name mention costs
> log2 |visible namespace| against the WORLD's declared namespace, at
> both priced sorts (the policy pricer's `Get` term and the model
> fragment's guard derivations), and 2^(-|program|) normalizes per
> world. Publishing a name therefore raises every name-mention's cost
> and re-weights the prior — a richer world makes every sentence about
> it more surprising. This is a semantic commitment, not an
> implementation detail. The namespace covers Get-mentionable feature
> names ONLY (ruling M5, load-bearing): the action vocabulary prices
> through slot grids and argmax, and keeping the two priced surfaces
> separate is what stops a fourth flow entering through the pricing
> door; no later increment may unify them. The frozen worlds are the
> singleton case (`featureNames = ["t"]`, 0 bits), whose prices this
> law leaves untouched.

## 4. The estimator choice, dissolved                    [COMPILE]+[FROZEN]

In the typed grammar there is no myopic special case to write. Deliberation
enters the menu as data — `Think :: Expr env Nat -> ...` with depth drawn
from a priced grid — and the evaluator has exactly one preposterior
recursion, structurally decreasing in depth (termination [COMPILE]). Myopia
is the value depth=1, chosen by argmax when the world's price makes it
optimal, never a branch in code. The interface.md §6 residue stands and is
restated for the typed port: the induction base — level-0 estimates taken at
face value — is [RESIDUE]; no type system removes it, because removing it is
a computation too. Acceptance test F (ladder honesty) is the [FROZEN] check
that the ladder actually reproduces test 2's numbers at its price points.

> The emission basis covers emissions fully and transitions partially:
> the reference `rw` (reflected walk, source-dependent support) is
> proven non-expfam (EXPFAM_PLAN T1) and remains a primitive
> combinator — the alphabet residue's one recorded non-expfam member.

## 5. What types cannot enforce, and what takes over

Honesty table — the discipline that *remains*, minimized and then frozen:

| invariant | mechanism |
|---|---|
| conjugate fast path == generic cond (CL-4) | [PROPERTY] QuickCheck, frozen; types cannot see extensional equality |
| fineness charged exactly once | [PROPERTY] refine a grid, assert predictive mass invariant within tolerance |
| adaptation absent from code | [FROZEN] forbidden-token audit + the four acceptance tests, ported verbatim |
| deletion audit | [FROZEN] per-terminal capability loss, measured; ablation standard (Phase 2, decision 4; STRENGTHENED at the membrane freeze to the ExpFam E9 as-built): a CPP flag removes the constructor AND everything from its first consumer down — the dependent layer's EXISTENCE, not just its cases — so all of src compiles ablated, only the frozen fixtures fail, and claims like "nothing can assign likelihood, no agent can be built" are literal absences rather than behavioral promises |
| no test tampering by the builder | protocol, not code: two-phase build with frozen oracle (CLAUDE.md) |
| alphabet choice, clock, pointer | [RESIDUE] as in design.md §10, unchanged |

The last non-code row is the one your "can't cheat" requirement really
turns on, and no language fixes it: the agent that writes the implementation
must not own the oracle. CLAUDE.md specifies the two-phase protocol — tests
and audits are written first, human-reviewed, hash-pinned into a manifest,
and thereafter read-only; the implementation phase is done when the compiler
gates (`-Wall -Werror`, no `unsafePerformIO`, no `Debug.Trace` in src/) and
the frozen suite both pass, with the manifest verified.

A frozen oracle that matches a variant exhaustively seals that variant
as a compile fact: -Werror incomplete-patterns makes every constructor
addition an edit to frozen surface, so future extension is by
composition around the sealed type, never by widening it — discovered
at the ladder increment, when M9's reserved additive constructor met
the membrane oracle's frozen match (LADDER pack §0).

## 6. Module map for the port

```
src/PropLang/Belief.hs     sealed reasoner (S2)          [COMPILE]
src/PropLang/Syntax.hs     GADT grammar + bits (S3)      [COMPILE]
src/PropLang/Eval.hs       evalx, pure                   [COMPILE]
src/PropLang/Enumerate.hs  model fragment, Cromwell frontier as a parameter
src/PropLang/Host.hs       draw :: IO, membrane, polling loop, affordances
test/Acceptance.hs          the four tests, ported, FROZEN after review
test/Properties.hs          CL-4, fineness-once, FROZEN after review
audit/forbidden.txt         token list, FROZEN
MANIFEST.sha256             oracle hashes, human-signed
```

Porting order and definition of done are in CLAUDE.md. The Python reference
implementation remains the executable spec of intended *behavior*: the
Haskell port must reproduce test 1's timeline shape, test 2's tick counts
(1/3/12/12 at the given prices and seed), test 3's log-loss relations, and
the full deletion audit, before any new capability (expfam, membrane,
ladder) is added on top.
