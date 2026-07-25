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

## Part VII — rulings record (the opening sitting, 2026-07-25)

Ruled by the author at the planning session (sealed by the Phase-1 freeze
tag when the exact oracle is reviewed):

1. BOUNDARY OPEN as chartered; #6/#7/#8 as recommended; #5 + pruning
   registered; Part IV approved as freeze items.
2. prodTable ships **10/1** (six-cut −6, Push/Argmax −2, fusion −2; the
   1/14 intermediate never ships — Phase-D pins price the node 1/10).
3. Push and Argmax DELETED, with the selection-fold re-homing obligation
   (the general route becomes the derived sayable composition; the host
   fold survives only opt-law-pinned).
4. The corridor FUSES inside this boundary (one conditioning primitive;
   Ev and Maybe(B) sorts leave the grammar; g5/g6 port as the pin).

Plus THE AGENT CRITERION (EXACT_PLAN §11c): a deletion is legal only if
the agent capability it served remains sayable and the executable route
runs through the sentence — host folds only as pinned fast paths. Its
provenance is the author's directive at this sitting: "lets make sure
we're building a bayesian AGENT, not a calculator."

Phase D begins under these rulings: the exact oracle (test/ re-derived
from the A1 reference, the exact lawful floor, the audit increment
oracle over the 10+1 grammar with the fused verb), oracle-first,
R-D20/21/22 throughout, your key at the freeze.

## Part VIII — the Phase-D record (the exact oracle, built and SAT-proven)

*Executed 2026-07-25 under the Part-VII rulings. The overlay — an R-D21
throwaway realization of the 10+1 surface wearing the real module names
(PropLang.Belief/Syntax/Eval/Enumerate), living in the session scratchpad
and discarded on close — carries every SAT transcript below; the oracle
files themselves are staged in test-exact/ and test-lawful/ and are what
your freeze seals.*

### VIII.1 The surface (D2) and its proof of semantics

The 10+1 grammar as ruled: C(MkC), Get, Var, If, Gt, Add, Sub, Mul,
Expect, Cond | Code; prodTable 10/1; CMass Rational pricing; World as
codebooks; fromWeights the sole introducer with uniform/point as its
definitions; the fail-closed door (no 0.0 default). Every constant in
every enumerated body is DERIVED from world declarations (obs atoms give
0/1; two = Add one one; the walk step = Sub theta1 theta0; equality =
If/Gt) — the census F2 violations (shGrid copy, the 0.5 literal, Pos)
are gone by construction.

ONE SURFACE AMENDMENT, found by the oracle's own type-checking and
recorded for your freeze review: Cond's observed-outcome argument is
Expr env Rational (Real b carrier) — the outcome crosses into the
sentence AS A RATIONAL, the deleted ToR's conversion living in the
verb's binder exactly as Expect's and Code's already do. The grammar
has no Int-sort expressions, so this is forced, and it completes the
ToR-deletion story rather than amending it.

SAT smoke (SmokeExact): the sentence-driven engine on the oracle world
reproduces the A1 reference EXACTLY — count 1169; Kraft == 55/72; every
probe p1, action, and H display ==; consult ticks ==; MAP guard[11,0,8]
with exact posterior; the 160-tick marginal ==; frozen == 2^-160;
deletion counts 17/0/0. 4.8 s.

### VIII.2 The suites (D3, D4) — all green on the SAT run

    exact-acceptance  13/13  (44.8 s; t3 through the sentence engine 26.9 s)
      exact acceptance (the re-founded oracle)
        t1 changing world
          enumeration count:                                                                                        OK
          probe rows: p1 exact, action, H display:                                                                  OK (1.00s)
          consult ticks (exact list):                                                                               OK (2.90s)
          MAP is the change-point guard; exact posterior:                                                           OK (0.83s)
          cumulative marginal (exact):                                                                              OK (2.23s)
          entropy pre/post (display):                                                                               OK (0.61s)
        t2 lazy genius
          tick counts and final acts (exact prices):                                                                OK (0.01s)
          AGENT CRITERION: the batch-1 preposterior is sayable, and the sentence route == the engine route (exact): OK
        t3 forgetting trap
          agent marginals over drift400/flat400 (exact):                                                            OK (26.92s)
        t4 deletion audit
          frozen agent: marginal == 2^-160 EXACTLY:                                                                 OK (0.39s)
          full/noif/noget marginals (exact):                                                                        OK (2.84s)
          drift250 full/nohmm marginals (exact):                                                                    OK (7.01s)
          deletion counts:                                                                                          OK
      
      All 13 tests passed (44.75s)

    exact-properties  11/11  — CL-4' Bayes by ==, L4', Kraft 55/72 with
    deficiency 17/72 asserted, corpus law w == 1/M per family, fineness
    exact halving, node-price 1/10 hand-check, eq-THEOREM (exhaustive),
    the derived choice family CL-3-faithful with exact ties, g5' fused
    round trip sayable, g6' Nothing arm through the DERIVED indicator
    kernel (the Is-derivation executed), the walk law from the SHIPPED
    move sentences.

    lawful 8/8 + lawful-independence 7/7 — the exact floor: 4 axioms
    (L1-L3 + L4') + 4 conformance theorems (T1-T4), 3+1 independence
    with exact witnesses; u/tol/near DELETED; no tolerance constant in
    either file. The Double floor is superseded per your ruling and its
    files are archived in the session record only.

THE AGENT CRITERION row (Acceptance t2): the batch-1 preposterior is
ONE SENTENCE of the 10+1 grammar (Expect for the predictive masses, the
fused Cond for the posteriors, If/Gt-over-Expects for the inner choice,
Get for the world's price) and the sentence route == the engine route
EXACTLY over a belief/price battery. Deliberation lives in the language.

### VIII.3 The ablations (D5) and the red

    PASS  UseCOND compiles against the surface
PASS  UseCOND fails under -DDROP_COND (ablation fires)
PASS  UseEXPECT compiles against the surface
PASS  UseEXPECT fails under -DDROP_EXPECT (ablation fires)
PASS  UseCODE compiles against the surface
PASS  UseCODE fails under -DDROP_CODE (ablation fires)
    PASS  UseCOND compiles against the surface
    PASS  UseCOND fails under -DDROP_COND (ablation fires)
    PASS  UseEXPECT compiles against the surface
    PASS  UseEXPECT fails under -DDROP_EXPECT (ablation fires)
    PASS  UseCODE compiles against the surface
    PASS  UseCODE fails under -DDROP_CODE (ablation fires)

Cond is the ENTRANT (clause (b) discharged in-increment); Expect and
Code re-earn their flags on the exact surface. The remaining seven
structural atoms carry their A3 compile-fact transcripts; their DROP
flags land with Phase 2's src (each is uttered by the whole corpus, so
their ablations fire trivially — recorded as a Phase-2 gate-7 row).

RED RUN (the oracle against SHIPPED src): compile-red, attributed to
the missing exact surface — the first errors name World and its fields;
the exact grammar (Cond, condV, weightIn, the Rational sort) follows.
Transcript in the session record; the red is the missing constructor,
not an accident.

GATES (test-exact/gates-exact.sh; RED BY DESIGN pre-Phase-2):
    E1 forbidden-inexactness tokens in core: 103 (must be 0)
    E2 fromRational renders in core: 0 (must be 0; display lives at the edge)
    E3 concrete point-sets in src: 19 (must be 0; worlds declare)
E2 is already 0; E1's 103 and E3's 19 are Phase 2's work orders.

### VIII.4 What your freeze seals (the choreography)

1. Review this pack + the staged oracle (test-exact/, test-lawful/,
   EXACT_PLAN §11c incl. the Cond-outcome amendment).
2. The swap, under your key (or delegated with the R-D22 re-tag):
   test/ := {test-exact/Streams.hs (byte-identical), Anchors.hs,
   Acceptance.hs, Properties.hs}; test-exact/ablation + gates-exact.sh
   join audit/'s runner set; the four stanzas
   (test-exact/stanzas.cabal.draft) paste into proplang.cabal; the old
   Double-anchor test/ retires.
3. MANIFEST extended + re-signed over the exact oracle; your tag
   (suggested: exact-freeze-r0) from your shell; prefreeze-lint +
   boundary-audit ride the close.
4. Phase 2: src/ re-founded to the proven surface (the overlay is its
   reference, discarded per R-D21 — Phase 2 rebuilds under gates);
   gates 1-7 + E1/E2/E3 green; the selection-fold re-homing (ruling 3)
   lands with its opt-law pin; the full-corpus overlay build closes it.

## Part IX — the repair pass (R1–R16 + the Add sitting), executed and re-witnessed

*2026-07-25, after the freeze-sitting review (six mandates, five
blockers). The author ruled ALL SIXTEEN as recommended, then — on the
R15 re-execution's findings — ruled the Add sitting. Everything below
is the executed record; every transcript is verbatim; the staged
oracle at this commit is the repaired one.*

### IX.1 The Add sitting (the ruling the R15 attempts forced)

The seven remaining clause-(a) attempts EXECUTED (SevenSeats, MulBank,
TryNoIf/TryNoGt/TryNoCode — transcripts in IX.3). Two came back
positive and the author ruled:

- **Add DELETED — the table ships 9/1.** The author's algebra, now the
  bank's canonical form (no codebook zero borrowed — addition is
  sayable in EVERY declarable world): `Sub x x == 0`;
  `Sub (Sub b b) b == −b`; `Sub a (Sub (Sub b b) b) == a + b`.
  "Keep Add, delete Sub" does not exist: Sub is a GENERATOR; every
  Add/Mul/If/Gt composition over non-negative codebook points is
  piecewise a polynomial with non-negative coefficients — monotone
  non-decreasing — and `1 − θ`, the Bernoulli complement, is strictly
  decreasing. That same argument is Sub's own clause-(a) bank,
  transcribed. Add ships as the stdlib macro `addM` (overlay
  Syntax.hs), priced at its expansion; its derivation row IS its
  deletion proof — no terminal to DROP. The mixture-pricing worry is
  REGISTERED beside the two-width-tables and pruning questions: if a
  measurement ever shows 9/1 mis-biasing a shipped additive body, Add
  re-enters through the two-sided gate carrying that measurement.
- **Mul HOLDS on corrected provenance.** The categorical does NOT
  force it ((K−1)·θ is an Add-chain; the Mul-free categorical column
  reproduces [7/30,7/30,3/10,7/30] exactly) — the banked CatBody claim
  expired under the boundary's own clause. The real ground: the
  preposterior's mass×value products are BILINEAR, and every Mul-free
  term is piecewise-affine in its free reads (MulBank: mixed second
  differences vanish; the target's is d·s ≠ 0). §5/§11c repaired
  in place, falsified sentences quoted.

Part VII ruling 2 carries the dated supersession (10/1 → 9/1, sealed
by the same freeze tag). ERRATA to Part VIII: its "deletion counts
17/0/0" line conflated the noif count with the (full, noc, nobern)
triple (1169, 0, 0); its "ONE surface amendment" claim was false —
the amendments are three (IX.2).

### IX.2 The blockers, repaired (B1–B5)

**B1.** Displays left the core: PropLang.Report (entropy views, bits
view) derives from exact read-only views (`weights`, `metaPosterior`);
`entropyS`/`entropyBits` no longer exist in E1-firewalled modules.
Env construction is DOOR-ONLY: `mkEnvIn :: Namespace -> Features ->
Vals env -> Either String (Env env)` is the sole constructor, with the
three named refusals (the A5 Either form); the engine carries its
namespace and refuses under-specified ticks; t2 declares its own World
(namespace {price}) — NO doorless env exists in the staged oracle, and
the door has its own refusal rows.

**B2.** Every compensating pin now EVALUATES THE GRAMMAR: the
eq-THEOREM row builds If/Gt sentences over codebook mentions and runs
evalx (81 pairs, negatives and ties included); the choice row builds
the If/Gt-over-Expects sentences (values as Expects over env-bound
beliefs, options as mentions) against the CL-3 reference fold over the
same evalx'd values, full-tie pinned; noget COLLAPSED to one row
recording the extensional coincidence (Get's structural proof =
Phase-2 DROP_GET, gate 7); and the COMPOSED BATCH-3 preposterior is
one sentence — eight Cond branches, masses by Expect, choice by
If/Gt-over-Expects, price by Get — equal to the engine exactly (R9).
The t4 frozen row asserts only the engine run (the literal readback
trimmed).

**B3.** All transcripts land verbatim (IX.3). The generator lands
in-tree (test-exact/ExactReference.hs, emit-only, probe rule DECLARED)
and the REGENERATION IDENTITY is verified: its emitted module equals
the staged Anchors.hs byte-for-byte modulo comment header. condK
(Eq-keyed, engine) and condV (Rational-keyed, the Cond verb's binder
convention) are both documented in Belief with the distinction stated.

**B4.** The derivation-line table (the forward law, discharged):

| name | one-line derivation (function of) |
|---|---|
| `World` | the world's declarations: namespace, carrier, three codebooks (R4; five fields) |
| `Namespace` | the declared feature names — the door's law (unchanged role) |
| `AgentS` | the engine's live state: its namespace + the enumeration + the observation history |
| `mkEnvIn` | THE DOOR: the sole Env constructor; Either with three named refusals (R5) |
| `observeS` | one Bayes step of AgentS; Either (a refused tick is Left — total, where shipped observe's Maybe carried impossible-evidence: that case is per-hypothesis here, weight 0) |
| `stepFrozenS` | observeS with the update deleted (the t4 frozen agent) |
| `predictMassS` | the exact predictive mass of a PARAMETER outcome (R16: no baked event) |
| `metaPosterior` | the exact normalized meta weights (read-only view; displays derive at the edge) |
| `mapS` | the top hypothesis's declared tag + exact posterior |
| `weights` | Belief's exact read-only weight view (the seal guards construction, not reading) |
| `weightIn` | the exact raw-sentence weight relative to a namespace (∏ 1/width; node 1/9) |
| `hypTag` | the hypothesis's declared identity (family, mention indices) — introspectable data so probes never re-derive |
| `addM` | the Add macro in the author's closed form — priced at its expansion |
| `Cond` | the fused conditioning verb; outcome AS Rational (amendment #1); off-codebook outcome = all-zero column = Nothing arm (R1 rider, pinned) |
| `Code` | binders cross latent and outcome AS Rational (amendment #3 — the ToR conversion is the binder's) |
| `Mass/Prob` | DROPPED as newtypes (amendment #2): non-negativity is enforced at the introducers' doors (fromWeights/Code refusal), not by a wrapper |
| `Report.*` | displays as pure functions of exact views; == under the pinned toolchain (R7) |

**B5.** The S2 re-derivation draft and the pin census follow (IX.4,
IX.5).

### IX.3 Transcripts (verbatim)

**SAT: exact-acceptance (17/17, 63 s at -O1):**
    exact acceptance (the re-founded oracle)
      the door (ruling 8: fail-closed, refusals named)
        a full tick passes; missing/undeclared/duplicate are refused:                   OK
        the engine refuses an under-specified tick (no dormancy):                       OK
      t1 changing world
        enumeration count:                                                              OK
        probe rows: p1 exact, action, H display:                                        OK (1.45s)
        consult ticks (exact list):                                                     OK (3.81s)
        MAP is the change-point guard; exact posterior:                                 OK (1.28s)
        cumulative marginal (exact):                                                    OK (2.74s)
        entropy pre/post (display):                                                     OK (0.85s)
      t2 lazy genius (the agent criterion)
        tick counts and final acts (exact prices):                                      OK (0.01s)
        the batch-1 preposterior is ONE SENTENCE == the engine (door-served):           OK
        the COMPOSED BATCH-3 preposterior is ONE SENTENCE == the engine (R9):           OK (0.01s)
      t3 forgetting trap
        agent marginals over drift400/flat400 (exact):                                  OK (29.42s)
        the quarantined forgetter reproduces its anchors, and the RELATIONS hold (R10): OK (10.77s)
      t4 deletion audit
        frozen agent: the engine's 160-tick marginal == 2^-160 EXACTLY:                 OK (0.84s)
        full and no-if marginals (exact); no-get COINCIDES (R8):                        OK (3.98s)
        drift250 full/nohmm marginals (exact):                                          OK (8.09s)
        deletion counts:                                                                OK
    
    All 17 tests passed (63.29s)

**SAT: exact-properties (12/12):**
    exact properties (laws by ==)
      CL-4': conditioning IS Bayes (division-free, all points, a belief battery):         OK
      L4': prob * Z == w on fromWeights; uniform/point are its definitions:               OK
      Kraft: the enumeration sums to EXACTLY 55/72:                                       OK
      corpus law: every weight == its family's 1/M (A2-pinned widths):                    OK
      fineness charged once: doubling a mention codebook halves the weight, exactly:      OK
      pricing: a hand-computable sentence at node 1/9 (the 9/1 table):                    OK
      eq-THEOREM: the If/Gt SENTENCE == (==), evalx over mention pairs (B2 repair):       OK
      the derived CHOICE SENTENCES are CL-3-faithful, ties included (B2 repair):          OK
      g5': the fused round trip is sayable (Cond -> Expect), exactly:                     OK
      g6': the Nothing arm is load-bearing, through the DERIVED indicator kernel:         OK
      R1 rider: an OFF-CODEBOOK outcome is impossible evidence — the Nothing arm, pinned: OK
      the walk law from the SHIPPED move sentences: Mul-form normalizes exactly:          OK
    
    All 12 tests passed (0.01s)

**SAT: lawful (8/8) + lawful-independence (7/7):**
    the exact lawful floor (satisfaction)
      axioms
        L1 normalization: E[1] == 1, every belief:                       OK
        L2 linearity: exact, declared probes:                            OK
        L3 monotonicity: exact <=:                                       OK
        L4' the introducer law: prob * Z == w, per point, every battery: OK
      conformance theorems
        T1 prob == E[indicator]:                                         OK
        T2 uniform/point ARE fromWeights (ruling #7):                    OK
        T3 conditioning IS Bayes (division-free):                        OK
        T4 push obeys the tower, exactly:                                OK
    
    All 8 tests passed (0.00s)
    independence (the exact core four are irreducible)
      Riesz triple: L1,L2,L3 separated among the eliminator laws
        wL1 fails L1, satisfies L2 & L3:                                              OK
        wL2 fails L2, satisfies L1 & L3:                                              OK
        wL3 fails L3, satisfies L1 & L2:                                              OK
      introducer: L4' separated from the eliminator laws
        the weighted prior obeys L4' (the law is satisfiable), exactly:               OK
        uniform is a valid measure (L1-L3) yet fails L4' on varying weights, exactly: OK
      register correction (why 3+1, not 4 peers)
        the signed L3-witness cannot be a measure (exact negative ratio):             OK
      red mirror: a genuine measure passes every eliminator law:                      OK
    
    All 7 tests passed (0.00s)

**R15 banks (SevenSeats + MulBank):**
    Add-from-Sub (CLOSED FORM) reproduces (+) exactly: True
      Sub x x == 0 and Sub (Sub b b) b == -b, full battery: True
    (K-1)*theta == Add-chain (K=4), exactly: True
    Mul-free categorical column == [7/30,7/30,3/10,7/30]: True
    walk stay 2*(1-rho) == Add of two Subs, exactly: True
    Sub-free candidates all non-decreasing at (1/10, 9/10): True; 1-theta decreases (9/10 > 1/10): True -> the Bernoulli complement is uncoverable; Sub's seat HOLDS
    Get-free bodies are feature-invariant: True -> no world contact without Get; the seat HOLDS
    Mul-free candidates: mixed second differences all vanish: True
    the target mass*value (Mul (Get a) (Get b)): mixed == d*s /= 0: True
    -> bilinear products are outside the piecewise-affine closure; Mul's seat HOLDS (the preposterior forces it)

**R15 compile-red banks (If, Gt, Code):**
    === TryNoIf (EXPECT RED) ===
    /tmp/claude-1000/-home-g-git-proplang/634d1373-74f5-4627-92a1-15651d705356/scratchpad/a3/TryNoIf.hs:11:19: error: [GHC-83865]
        • Couldn't match type ‘Bool’ with ‘GHC.Internal.Real.Ratio Integer’
          Expected: Expr '[] Rational
            Actual: Expr '[] Bool
        • In the first argument of ‘Mul’, namely ‘(Gt (Get "a") (Get "b"))’
          In the expression: Mul (Gt (Get "a") (Get "b")) (Get "c")
          In an equation for ‘branchless’:
              branchless = Mul (Gt (Get "a") (Get "b")) (Get "c")
    === TryNoGt (EXPECT RED) ===
    /tmp/claude-1000/-home-g-git-proplang/634d1373-74f5-4627-92a1-15651d705356/scratchpad/a3/TryNoGt.hs:13:18: error: [GHC-83865]
        • Couldn't match type: Bool : env10
                         with: '[]
          Expected: Idx '[] Bool
            Actual: Idx (Bool : env10) Bool
        • In the first argument of ‘Var’, namely ‘Z’
          In the expression: Var Z
          In an equation for ‘closedBool’: closedBool = Var Z
    === TryNoCode (EXPECT RED) ===
    /tmp/claude-1000/-home-g-git-proplang/634d1373-74f5-4627-92a1-15651d705356/scratchpad/a3/TryNoCode.hs:11:11: error: [GHC-83865]
        • Couldn't match type: K Rational Int : env10
                         with: '[]
          Expected: Idx '[] (K Rational Int)
            Actual: Idx (K Rational Int : env10) (K Rational Int)
        • In the first argument of ‘Var’, namely ‘Z’
          In the expression: Var Z
          In an equation for ‘mkK’: mkK = Var Z

**Ablations (9/1 surface):**
    PASS  UseCOND compiles against the surface
    PASS  UseCOND fails under -DDROP_COND (ablation fires)
    PASS  UseEXPECT compiles against the surface
    PASS  UseEXPECT fails under -DDROP_EXPECT (ablation fires)
    PASS  UseCODE compiles against the surface
    PASS  UseCODE fails under -DDROP_CODE (ablation fires)

**Red-run vs shipped src (attributed):**
    === RED RUN r2: the exact oracle vs SHIPPED src (COMPILE-RED, attributed) ===
    Loaded package environment from /home/g/git/proplang/dist-newstyle/tmp/environment.-3161835/.ghc.environment.x86_64-linux-9.10.3
    [1 of 8] Compiling Anchors          ( test-exact/Anchors.hs, nothing ) [Optimisation flags changed]
    [6 of 8] Compiling OracleWorld      ( test-exact/OracleWorld.hs, nothing ) [Optimisation flags changed]
    test-exact/OracleWorld.hs:23:28: error: [GHC-61689]
        Module ‘PropLang.Enumerate’ does not export ‘atomGridOf’.
       |
    23 | import PropLang.Enumerate (atomGridOf)
       |                            ^^^^^^^^^^
    
    [7 of 8] Compiling Streams          ( test-exact/Streams.hs, nothing ) [Optimisation flags changed]

**Gates (red by design pre-Phase-2):**
    E1 forbidden-inexactness tokens in core: 103 (must be 0)
    E2 fromRational renders in core: 0 (must be 0; display lives at the edge)
    E3 concrete point-sets in src: 19 (must be 0; worlds declare)
    (regeneration identity: /tmp scratch run — 'REGENERATION IDENTITY: emitted == staged (mod comments)')

### IX.4 The S2 re-derivation draft (R12 — for your key at the freeze)

typed-port-spec S2's export list re-derives to the exact surface, and
audit/belief-exports.txt follows it (gate 2 then binds to the exact
reasoner). The drafted list — exactly the staged overlay's:

    Space, mkSpace, spacePoints,
    Belief,                    -- abstract; constructor never exported
    Kernel, kernel, kernelSpace, kernelAt,
    fromWeights,               -- the SOLE introducer (L4')
    uniform, point,            -- its definitions (ruling #7)
    expect, prob,              -- prob predicate-typed (R3: Event DELETED;
                               -- on a finite carrier the indicator is
                               -- evaluated extensionally and exactly;
                               -- the evidence-introduction side stays
                               -- closed — I2's concern guards there)
    push,                      -- engine machinery (agent criterion note)
    condK, condV,              -- Bayes: engine-keyed / verb-keyed
    predictMass,
    weights, top               -- exact read-only views

Retired from S2: Bits, LogProb, Evidence(..), Is, Saw, fromBits,
logPredict, entropyBits (a Report function now), event, is (Event died
with R3 — `prob b (== x)` is the idiom).

### IX.5 The pin census (R11 — the 17-suite mass retirement at the Phase-2 close)

Universe: the stanza'd suites at HEAD minus transport/writeup (which pin
wire bytes / stanza counts and move under their own rows). Destinations:
PORTED (the exact oracle already carries the pin), PHASE-2 GATE (the pin
re-homes as a gate row on the exact src), DISCHARGED-PERMANENT (the pin
died with its subject; file DELETED at the retirement).

| suite | what it pins | destination |
|---|---|---|
| test/ (old Acceptance+Anchors) | the Double anchors | RETIRED at the swap (superseded by the exact oracle; streams byte-survive) |
| test-hygiene | grammar hygiene rows on the Double surface | PHASE-2 GATE (re-derive the greps over the exact src) |
| test-code | Code/Pos/ToR semantics, kGrid, walk golden | PORTED in part (walk law, eq-theorem now sentence rows); Pos/ToR rows DISCHARGED-PERMANENT (terminals gone) |
| test-optlaw | observeCounts fast-path pin (1e-11 gates) | PHASE-2 GATE: the opt-law pin re-executes EXACTLY (==) against the exact route when the fast path re-lands; until then the fast path does not ship |
| test-sentence | sentence-scoping, prodTable 6-era pins | DISCHARGED-PERMANENT (superseded tables) + the ablation RUNNER pattern PORTED (audit/) |
| test-pricing | chargeBits/two-table rows, float-order mirror | DISCHARGED-PERMANENT (the float-order apparatus is vacuous under CMul; the two-table QUESTION stays registered #5) |
| test-actions | menu/assignment/wait rows | PORTED to Phase-2 membrane rows (actions unchanged semantically; Double reads re-derive exact) |
| test-stream | actions-in-stream, EXOGENOUS-READ falsifier | PORTED to Phase-2 membrane rows (the falsifier re-executes exact) |
| test-unify | pricing unification + Dutch-book row | Dutch-book PORTED exact; unification rows DISCHARGED-PERMANENT (one arithmetic already) |
| test-outcome | USent utility rows | PORTED exact (utility is an ordinary sentence — unchanged) |
| test-elim | Expect/SawE/ElimJ rows, g5/g6 | g5'/g6' PORTED (fused); SawE/ElimJ rows DISCHARGED-PERMANENT (fused away); ablation fixtures for the dead verbs DELETED |
| test-reflexive | the step-10 composition + t2Rows via sentences | PORTED: the batch-3 preposterior sentence row IS its successor (stronger: exact) |
| test-said | the 13-form wire grammar, log2-20 pricing gates | PHASE-2 GATE on the wire's exact re-pricing (said layer; wire out of scope otherwise — ruling 2 of the opening sitting) |
| test-arity | K-ary handshake, arity charges | PORTED to Phase-2 wire rows (obs_arity unchanged; charges re-derive exact) |
| test-refine | R1 lattice rows (log-odds coordinate) | PHASE-2 GATE under R6-of-Part-III (dyadic coordinate re-derivation; R-R1 re-opens under the author's key) |
| test-measure | wire discrimination/timing instruments | PORTED as instruments (report rows; gates re-measure on the exact engine) |
| test-law | VoI non-negativity over the composition | PORTED exact (the composition survives; the -1e-13 gate becomes >= 0 EXACTLY — the tolerance dies) |
| test-lawful | the exact floor (already rewritten) | STAYS (this boundary's own) |
| test-transport | pipe transport bytes | STAYS (transport; re-witness at Phase-2 close) |
| test-writeup | WRITEUP pins incl. retired DROP count | PHASE-2 GATE: rows re-derive or gain RECORD brackets (the fourteen-flags pin already self-documents as RECORD) |

Each PORTED/GATE row lands as a named row in Phase 2's checklist; each
DISCHARGED-PERMANENT file is DELETED at the retirement commit under
your key, with this table as the retirement's pin list (the
retirement-lists-its-pins clause discharged by construction).

### IX.6 CLAUDE.md drafts (your key; the freeze's process half)

**The R-D21 generator exemption (R14):** "A generator of frozen data
is not a prototype: it lands in-tree with the artifact it generates,
and regenerating the artifact from it is a standing identity row
(capture_oracle.py the precedent; ExactReference.hs the second
instance)."

**The process deletion audit (the third move; candidates — you rule
each, retirements list their pins):**
1. The NaN-door case law (R-C1's reading, the step-9 NaN guard rows):
   NaN is unconstructible over Rational — vacuous; retire with a
   two-sided record row.
2. The float-order/tree-shape law (step 4's "the tree shape IS the
   float order"; the E-s1 mirror pins): CMul is associative — the
   apparatus is vacuous; retire (the pricing-tree DATA stays).
3. The tolerance case law (CL-4 1e-12's repair lineage, tolProb/
   tolBits conventions): exact quantities assert (==); tolerances
   survive ONLY as display-edge conventions under R7 — trim the
   clause to that residue.
4. The dormancy-as-wait convention (mandate-5's overload): the door
   kills dormancy — retire with the wire's Phase-2 repair.
5. The lse/log-space riders wherever they bind (skip-on-negInf rules):
   vacuous; retire.
Each retirement executes at a boundary under your key, pins listed,
never by builder discretion — the process getting the deletion test
the language already passed.

### IX.7 The R16 bundle + notes, discharged

100× → 81× at width 9 (both quoted figures repaired in place);
"census F2" citations replaced by the in-tree facts (the F2 violations
are GONE from the staged surface — no shGrid copy, no 0.5 literal, no
Pos); §5's phantom `Lit` leaf corrected to `C`; the 46 s / 63 s
timings transcribed (IX.3); interface.md:117's gauss promise in §6's
inventory; condK/condV documented with the distinction; predictive1S
RENAMED predictMassS with the outcome a parameter; emitK declared once
in OracleWorld with provenance; the sentinel one-point grid annotated
as test-side convention at its use sites; hypTag carries its
derivation line (IX.2); lawful-author-pack.md moves to archive/ at the
freeze (the superseded sitting's custody record); OB-16/GetV: this
boundary IS the alphabet motion its row waits on — the re-execution
lands on Phase 2's opening checklist. KERNEL.md is drafted at the root
(the one page; the standing test is in its header).

### IX.7a Erratum (the review sitting's re-lint, 2026-07-25)

The repair pass introduced one ASCII-clause violation: the R1-rider
row's test name carried an em-dash (Properties.hs:186; prefreeze-lint
L2, the membrane locale clause). Fixed to ASCII at the review sitting;
the IX.3 transcript's row label differs from the staged name by that
one character (the transcript records the run that happened; the
author's freeze verification re-run prints the ASCII name).

### IX.8 Sequence

1. You review this pack part and the staged diff.
2. The swap under your key or per-instance delegation (R13's corrected
   mechanics: the four files + OracleWorld + ExactReference into test/;
   ablation/ + gates-exact.sh into audit/; stanzas pasted; MANIFEST
   extended + re-signed; your tag — suggested exact-freeze-r0).
3. Phase 2 (builder): src/ to the proven 9/1 surface; gates 1-7 +
   E1/E2/E3; the selection-fold re-homing with its opt-law pin; the
   R11 retirement with IX.5 as its pin list; the full-corpus overlay
   build closes it.
