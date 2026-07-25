# exact-author-pack.md — the minimal-basis re-founding (Phase-1 sitting pack)

*Builder-authored, unfrozen. Prepared 2026-07-25 for the author's Phase-1
sitting on the exact-rational re-founding under the overriding aim stated
this day: **as few primitives as possible, EVERYTHING else derived — and
forced to be derived.** Charter: EXACT_PLAN.md §0–§11 (same commit).
Every claim below is backed by an executed R-D21 throwaway; prototypes
live in the session scratchpad and are discarded on close; their outputs
are transcribed verbatim here.*

## Part 0 — what this sitting decides

This pack asks for ONE opening decision and EIGHT design rulings
(Part III). The opening decision: freeze the Phase-1 boundary as chartered
— the exact re-founding proceeds oracle-first, with the evidence below as
its Phase-A record. Three rulings you made at the planning sitting are
already binding and recorded (Part I).

## Part I — rulings of 2026-07-25 (recorded, already given)

1. **The Double lawful floor never freezes** ("never freeze incorrect
   code, and we agreed using Double is wrong"). test-lawful/ is re-derived
   EXACT inside this boundary (structure ported: 4 axioms + 4 conformance
   theorems, 3+1 independence, separating witnesses; u/tol/near deleted;
   two sibling stanzas per your 2026-07-24 ruling).
   lawful-author-pack.md is SUPERSEDED by this pack.
2. **The wire is out of scope** — transport, not language. It changes only
   where the World declaration requires; external consumers unbroken.
3. **Documents owe their existence a justification** ("why do we have
   documents?") — the census and dispositions are Part IV.

## Part II — the executed evidence (verbatim transcripts)

### II.A2 — the exact prior (ExactPrior.hs, gate flags, shipped corpus)

    corpus size: 1169 (expect 1169)
    ROW A  price-is-log2-of-integer failures: 0 / 1169
           distinct width-products M: [16,36,82944]
    ROW A' wCharge constCharge = 1/36
           wCharge walkCharge  = 1/16
           wCharge guardCharge = 1/82944
    ROW B  Expr-pricer faithfulness failures: 0 / 1169
    ROW C  Kraft sum S = 55/72  (<= 1: True)
           deficiency 1 - S = 17/72
    ROW D  exact p_i * M_i constant (==): True  value = 72/55  (recip S: True)
           Double-route spread of p_i*M_i (max/min - 1): 2.220446049250313e-16
    ROW E  L4' exact (p*Z == w, all points): True
           uniform == fromWeights(const 1): True
           point 1 == fromWeights(indicator 1): True
    ROW F  Expr node counts over corpus bodies: [15,25,130]
           max relative-price drift 20->14 = (10/7)^115 = 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000/15355876181909280421724151687580911741041895655149613132104515881830657073678671819100413262089943 ~= 6.512165038020412e17
           FINDING: fragment prior uses fragWidth, raw-Expr layer uses prodTable — two declared width tables, one mechanism.

Reading: every shipped corpus price is log2-of-an-integer; the exact
weight recursion REPRODUCES the shipped pricer bit-for-bit in the only
sense that matters (0/1169 disagreements at 1e-9); Kraft is EXACTLY
55/72 with the HEAD debt visible as 17/72; the introducer law L4'
(`prob·Z == w`, and p_i·M_i constant) holds by `==`, not tolerance; and
the Double route already drifts (one ulp on a three-price corpus — the
drift the re-founding deletes). The 20->14 note and the two-width-tables
finding are Part III items 2 and 5.

### II.A3 — the binder basis (a3/, gate flags)

    # A3 transcript — binder-basis attempts (2026-07-25, R-D21 throwaways)
    
    ## Universe: git ls-files '*.hs' (38 files)
    
    ## Push utterance census (constructor use outside Syntax/Eval definition+pricing sites):
    audit/ablation/UsePush.hs:14 (its own fixture) + Enumerate.hs:155 (renderExpr pretty-printer case) — ZERO shipped or test sentences.
    
    ## Corridor census: SawE/CondE/ElimJ outside src/ appear ONLY fused (test-elim g5/g6, Elim.hs:210 'ElimJ (CondE b (SawE k y)) j n') or in their per-constructor ablation fixtures (UseSawE.hs:13, UseElimJ.hs:14).
    
    ## Expected-RED attempts (flags: -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns):
    ### TryExpect.hs — scalar from belief without Expect:
    TryExpect.hs:14:18: error: [GHC-83865]
        • Couldn't match type ‘PropLang.Belief.Belief Double’ with ‘Double’
          Expected: Idx '[B Double] Double
            Actual: Idx '[B Double] (B Double)
        • In the first argument of ‘Var’, namely ‘Z’
          In the first argument of ‘Add’, namely ‘(Var Z)’
          In the expression: Add (Var Z) (Var Z)
       |
    14 | readB = Add (Var Z) (Var Z)
       |                  ^
    ### TryBayes.hs — Bayes without CondE (Push runs forward only):
    TryBayes.hs:18:30: error: [GHC-83865]
        • Couldn't match type ‘Int’ with ‘Double’
          Expected: Idx [K Double Int, B Double] (K Double Double)
            Actual: Idx [K Double Int, B Double] (K Double Int)
        • In the first argument of ‘Var’, namely ‘Z’
          In the second argument of ‘Push’, namely ‘(Var Z)’
          In the expression: Push (Var (S Z)) (Var Z)
       |
    18 | post = Push (Var (S Z)) (Var Z)
       |                              ^
    
    
    ## Runnable demonstrations:
    ### TryConst:
    Get "x" at [("x",3)] = 3.0
    Get "x" at []          = 0.0
    constant? False
    => no MkC-free closed term denotes a constant; MkC is the door.
    ### TryNoVar:
    varFree1 y-invariant: True
    varFree2 y-invariant: True
    => Var-free bodies denote y-constant columns only (uniform emissions); Var earns its seat.
    ### A3Battery:
    (e) walk interior exact over rho battery: True
        walk edge     exact over rho battery: True
        categorical K=4 Mul-form == truth: True
    (f) Gt-eq trichotomy theorem over 17689 exact pairs: True
    (g) Is-event == Saw-through-indicator-kernel, exactly: True
    ### ArgmaxK:
    K=2 family == Argmax over battery: True
    K=3 family == Argmax over battery: True
    pairwise-tie case agrees (first tied maximum wins): True
    
    ## Sort-role table (ghci :t over the living grammar):
    Get :: Name -> Expr env Double
    If :: Expr env Bool -> Expr env t -> Expr env t -> Expr env t
    Gt :: Expr env Double -> Expr env Double -> Expr env Bool
    Var :: Idx env t -> Expr env t
    Push :: Expr env (B a) -> Expr env (K a b) -> Expr env (Belief b)
    CondE
      :: Expr env (B a) -> Expr env (Ev a) -> Expr env (Maybe (B a))
    Expect
      :: Real a =>
         Expr env (B a) -> Expr (Double : env) Double -> Expr env Double
    Argmax
      :: Expr env (NonEmpty t) -> Expr (t : env) Double -> Expr env t
    SawE
      :: Eq b => Expr env (K a b) -> Expr env b -> Expr env (Evidence a)
    ElimJ
      :: Expr env (Maybe (B a))
         -> Expr (B a : env) t -> Expr env t -> Expr env t
    Code
      :: Space a
         -> Space b -> Expr (b : a : env) Double -> Expr env (Maybe (K a b))
    Pos :: Eq a => Space a -> Expr env a -> Expr env Double
    ToR :: Real c => Expr env c -> Expr env Double
    Add :: Expr env Double -> Expr env Double -> Expr env Double
    Sub :: Expr env Double -> Expr env Double -> Expr env Double
    Mul :: Expr env Double -> Expr env Double -> Expr env Double
    Div :: Expr env Double -> Expr env Double -> Expr env Double
    Log :: Expr env Double -> Expr env Double
    Exp :: Expr env Double -> Expr env Double
    Neg :: Expr env Double -> Expr env Double
    mkC :: Grid -> Ix -> Maybe (Expr env Double)
    
    ## Fusion price note: at Expr width w, the fused conditioning verb pays one node charge (1/w) where the chain pays three (1/w^3) — at w=14, conditioning becomes 196x more probable in the prior; expressiveness lost = sentences binding a corridor sort (Ev / Maybe(B)) from env, which no shipped or wire-reachable sentence does (census above; the wire cannot inject corridor-sort values).

### II.A1 — the exact reference pipeline (ExactPipeline.hs, -O1, 46 s)

Streams imported from the FROZEN test/Streams.hs (the artifact itself);
anchors from the frozen test/Anchors.hs.

    enumeration: 1169 (anchor 1169)
    -- TEST 1 --
    probe actions reproduce: True
    consult ticks: [0,1,3,4,65,66,67,68,69,70]
      == anchor: True
    MAP: bern(if t>tau[11] theta[0] theta[8])  posterior 0.6383157408996583  (anchor posterior 0.6383157408996493)
      MAP is guard tau[11]/theta[0]/theta[8]: True
    max |dP(y=1)| over probe rows: 3.3306690738754696e-16
    max |dH| over probe rows: 2.842170943040401e-14
    H(59) = [3.1489671033557154] (anchor 3.1489671033557265); max H[60,90) = 3.9528542433140363 (anchor 3.9528542433140568)
    -- TEST 2 --
    price 0.3 -> 1 tick(s), act L
    price 0.05 -> 3 tick(s), act L
    price 0.005 -> 12 tick(s), act L
    price 0.0 -> 12 tick(s), act L
    tick counts + final acts == anchors (1/3/12/12, L): True
    -- TEST 4 --
    frozen agent marginal == 2^-160 EXACTLY: True  (ll = 160.0, anchor 160.00000000000003)
    full 96.68277182241701 (anchor 96.682771822417)
    noif 103.44568113917315 (anchor 103.44568113917315); noget 103.44568113917315 (anchor 103.44568113917315)
    drift250 full 207.0975831630571 (anchor 207.09758316305718); nohmm 211.05494026245512 (anchor 211.05494026245512)
    counts noc/nobern: 0/0 (anchors 0/0)
    -- TEST 3 --
    agent drift400 339.78242360387446 (anchor 339.7824236038744)
    agent flat400  351.1061771452692 (anchor 351.1061771452692)
    forgetter gamma 0.8: drift 369.7929712967314, flat 396.6021006870599
    forgetter gamma 0.9: drift 345.5037265510023, flat 370.03357768556754
    forgetter gamma 0.95: drift 340.88263044835253, flat 359.3527535371698
    forgetter gamma 0.98: drift 348.9379571990413, flat 353.28252431117664
    forgetter gamma 1.0: drift 397.92621119190125, flat 350.330276640413
    test-3 story: agent beats every forgetter on drift (True), loses to tuned forgetter on flat (True)

Reading: EVERY discrete anchor reproduces — the re-founding changes no
story. Continuous anchors move at the last ulp only. The frozen agent's
marginal is EXACTLY 2^-160 (the Python anchor's 160.00000000000003 was
float error — the exact number is the definition the oracle should have
had). Cost of exactness, measured honestly: 46 s for the full four-test
suite at -O1 (EXACT_PLAN §8.1 repaired accordingly).

### II.A4/A5 — codebook-parametric engine + the fail-closed door

    A4: engine under world9: 1161 models
        engine under world5: 85 models (same engine, no code change)
        frozen marginal == 2^-10 exactly in BOTH worlds: True
    
    A5: the fail-closed door over namespace [t, price]:
      full tick:      Right [("t",3 % 1),("price",1 % 2)]
      missing price:  Left "tick refused: missing declared [\"price\"]"
      undeclared x:   Left "tick refused: undeclared [\"x\"]"
      duplicate t:    Left "tick refused: duplicate [\"t\"]"
      (shipped route: Get absent = 0.0 — executed in a3/TryConst)

Reading: the engine names no grid (9-point and 5-point worlds, same
code); the t4 symmetry marginal is exact in both. The door refuses
missing / undeclared / duplicate features — the Get-absent 0.0 default
(your standing discomfort, vindicated at the dormancy sitting) dies
structurally. Rider: the Code space payload is priced 0 today — under
the criterion that free ride is a subsidy (Part III item 3 note).

### II.A7 — the lattice coordinate

    level | log-odds thetas (Double, IRRATIONAL for k>=1) | dyadic thetas (exact)
    k=0  logodds: [0.5]
          dyadic:  [1 % 2]
    k=1  logodds: [0.4142135623730951,0.585786437626905]
          dyadic:  [1 % 4,3 % 4]
    k=2  logodds: [0.3728848808245891,0.45678638313705516,0.5432136168629449,0.627115119175411]
          dyadic:  [1 % 8,3 % 8,5 % 8,7 % 8]
    dyadic mirror theta <-> 1-theta exact at k=3: True
    roots agree at 1/2: True
    dyadic denominators are powers of 2: True

Reading: the shipped log-odds coordinate places every depth>=1 node at
an IRRATIONAL theta (2^k-th root of an odd power of two) — the R1
lattice cannot live inside the exact core as-is. The dyadic-in-theta
ladder is exact, mirror-symmetric, root 1/2, gammaBits unchanged. What
the re-ruling must re-derive is R-R1's log-odds spacing argument
(Part III item 6).

## Part III — the decision sheet (eight rulings, each with executed evidence)

1. **World/grid reading.** World = CODEBOOKS (mention domains: the value
   sets sentences may quote; the obs arity; the namespace). FINENESS
   remains the agent's, priced — fineness-charged-once is exact weight
   division (II.A2), and R1's refinement lattice is the shipped
   buy-your-own-fineness mechanism. The walk latent's carrier derives
   from the theta codebook; no separate reasoning-grid config exists.
   *Recommend: adopt.* This reconciles the World-on-the-wire ruling with
   the grid-as-hypothesis conviction: the world declares what values
   MEAN; the agent buys how finely to REASON.
2. **prodTable 20 -> 14 at the boundary** (the P5 single-site edit;
   shipping 1/20 would charge every node for six unutterable
   alternatives — the HEAD-debt disease grammar-wide). SEPARATELY:
   written-alternatives vs type-pruned widths is a prior re-weighting
   (drift up to (10/7)^115 ~ 6.5e17 across corpus bodies) — adjudication,
   brought with the exact ratio-drift table when you want it.
   *Recommend: 14 now; pruning as its own later ruling.*
3. **Push and Argmax's seats.** Push is uttered ONLY by its own ablation
   fixture (census, II.A3); its seat rests on the step-10 preposterior
   cluster's credit. Argmax's executable route is a host-side fold that
   bypasses it; the per-K index-menu family is DERIVED and extensionally
   identical, ties included (II.A3). *Recommend: DELETE both under the
   demand-gate discipline (re-enterable via the two-sided entry gate when
   a shipped body demands them). This is the criterion applied without
   fear or favor; if you prefer the step-10 credit to stand for Push, say
   so and the seat keeps its named future.*
4. **The corridor fusion.** SawE -> CondE -> ElimJ are never separated
   outside their own fixtures; fusing to ONE conditioning primitive
   removes two constructors and two corridor sorts, prices conditioning
   196x more probable at width 14, and loses only env-bound corridor
   sentences no wire can produce. *Recommend: fuse (its own oracle rows
   in Phase D; the g5/g6 battery ports as the pin).*
5. **The two width tables.** The corpus prior uses fragWidth
   (MODEL/THETA/HEAD/RATE); raw said-sentences use prodTable. One
   mechanism, two declared tables — the "how did we end up with two
   pricing laws" shape one level up. *Recommend: register as a named
   question for the increment that lands the stdlib layer (a derived
   name's price = its expansion price may subsume the fragment table
   entirely); not rushed at this freeze.*
6. **The lattice coordinate** (dyadic-in-theta; II.A7). *Recommend: adopt
   dyadic at the exact boundary; R-R1's spacing derivation re-derives
   under your key (the probe is the discriminating exhibit).*
7. **The sealed reasoner shrinks.** uniform/point become definitions over
   fromWeights (verified exact, II.A2); Is-evidence derivable through an
   indicator kernel (II.A3(g)) so I2's closed variant can shrink.
   *Recommend: adopt both; export list shrinks accordingly.*
8. **The Get-absent door** (II.A4/A5). Undeclared-name reference dies at
   the door (fail-closed ticks); no 0.0 default survives anywhere.
   *Recommend: adopt; the dormancy convention's wire half becomes "a tick
   covers the declared namespace exactly" (wire change is World-required,
   inside ruling 2's scope).*

## Part IV — the document census (ruling 3; universe: git ls-files '*.md', 72 files, ~26k lines)

Classes: (a) restates code/oracle facts -> derive or delete; (b)
historical record -> archive (dated bracket already standard); (c)
irreducible prose -> stays.

- **(c) stays (7):** CLAUDE.md (the protocol), brief.md, README.md,
  design.md, interface.md, typed-port-spec.md, EXACT_PLAN.md (the live
  charter). membrane-wire.md stays but its FORMS TABLE is class (a) —
  the "thirteen forms" parenthetical lists 12 (`=` missing,
  membrane-wire.md:130 vs Host.hs:434): the drift is the argument for
  deriving that section from the dispatch table at the freeze.
- **(b) archive sweep (~50):** every closed *_PLAN / *_REPORT /
  task2/task3 pack / reviews/ / stop-report — candidates for a mechanical
  `git mv` into archive/ under your key at the freeze (list scripted, in
  the census output; OBLIGATIONS.md and boundary-queue.md stay as the
  live ledger + its historical bracket).
- **author packs (~15):** custody record — keep in place (or packs/ if
  you prefer; mechanical either way).
- **Superseded by this boundary:** lawful-author-pack.md (Part I ruling
  1); WRITEUP.md gains a dated supersession note when the exact oracle
  lands (its Double numbers stop being the numbers).

*Recommend: approve the archive sweep as a freeze item; approve deriving
membrane-wire's forms table; everything else stays.*

## Part V — the CLAUDE.md clause (drafted for YOUR key, at the freeze)

> THE MINIMALITY CRITERION (canonized at the exact boundary, 2026-07-25).
> A primitive exists only under a demonstrated failed composition
> (clause (a), applied to the standing stock — a boundary that moves the
> alphabet expires every bank) plus its ablation fixture (clause (b)).
> Everything else is a derived name: a macro whose expansion is a
> sentence of the primitive grammar, priced at its expansion —
> convenience, never probability. Every invariant climbs the enforcement
> ladder as high as it goes: unsayable at compile; derived at build from
> declared data; a frozen oracle row; prose only for what provably
> cannot climb. "Derive" means syntactic macro expansion (decidable,
> mechanical); primitivity claims are extensional and are earned by
> executed transcript, never by argument.

## Part VI — sequence from here (oracle-first, custody unchanged)

1. You rule Part III (and the opening decision). Discrete-story changes:
   NONE found (II.A1) — the exact oracle tells the same four stories with
   definitional numbers.
2. Phase D: I re-derive test/ to exact anchors from the A1 reference,
   the exact lawful floor in test-lawful/, and the audit's increment
   oracle (per-survivor ablations, per-macro derivation rows), R-D21
   transcripts in the overlay form, runtime-red proven against stubs.
3. You freeze: MANIFEST re-signed over the exact oracle, your tag from
   your shell; the frozen-layer repairs (Part IV + EXACT_PLAN §6) execute
   under that key; prefreeze-lint + boundary-audit transcripts ride the
   close.
4. Phase 2: src/ re-founded; gates 1-7 + E1/E2/E3; the full-corpus
   overlay build.

*Local path: /home/g/git/proplang/exact-author-pack.md — also sent to
pixel6 by Taildrop with this commit.*
