# ExpFam Increment Plan (step-6 increment 2)

> Build target: typed-port-spec.md §3 (ExpFam sketch), interface.md §4
> (the design source), design.md §5, under the CLAUDE.md increment
> protocol, with HYGIENE_REPORT.md as the worked example of the cycle.
> Scope as kicked off: **the ExpFam basis only.** The membrane and the
> fidelity ladder are out of scope; where a design question seemed to
> require them it is a register item below, not scope creep.
>
> This plan STOPS at author review — no implementation, no stubs, no
> oracle before the Task 0 rulings and the Task 2 freeze.
>
> **Standing rule (recorded per the kickoff):** signing mechanics at
> every boundary are executed by the human directly. The builder
> prepares everything up to the commit — manifest command ready, delta
> verified, message drafted — and stops. The builder never runs
> `git commit -S`. Task 2 below spells out the author-run sequence.

**Goal:** Land the exponential-family emission basis — `ExpFam` as
first-order grammar, `Stats` as a priced defunctionalized alphabet,
`bern` re-derived as a stdlib name over it — with every frozen anchor
byte-stable and the deletion audit tightened per interface.md §4
("delete expfam and nothing can assign likelihood").

**Architecture:** all code in the five `src/PropLang/*.hs` modules plus
a NEW increment-oracle directory `test-expfam/` and one cabal stanza
(which, `proplang.cabal` being frozen since `b1c8e00`, lands only
inside the author's Task 2 freeze commit). Frozen `test/`,
`test-hygiene/`, `audit/` are the regression net.

**Tech stack:** unchanged — GHC 9.10.3 (`~/.ghcup`), cabal 3.16, src/
depends on base only, tasty/tasty-hunit/tasty-quickcheck/process from
the frozen pin set.

## Global constraints

- **Behaviorally invisible to the frozen suites:** every gate green at
  the increment's close, every anchor unmoved. Anchor movement is
  stop-and-report, never a fix.
- **No builder diff under anything in MANIFEST.sha256** (24 entries:
  test/, test-hygiene/, audit/, CLAUDE.md, proplang.py,
  tests_acceptance.py, test_output.txt, typed-port-spec.md,
  proplang.cabal, cabal.project.freeze). The cabal stanza is drafted by
  the builder as a file inside `test-expfam/`; the author applies it at
  the freeze.
- `-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`
  clean; no IO outside Host; forbidden tokens clean; base only.
- The frozen suites' uttered surface keeps compiling unchanged. That
  surface now includes (from test-hygiene) `bits` absolutes on six
  closed forms with node cost log2 10, `mkC`, `FnInd`/`FnUtil`, the
  1169-model prior-mass pins; and (from test/) the whole Enumerate API:
  `Terminal(..)` — the constructor names `TBern, THmm, TIf, TGt, TGet,
  TC` — `allTerminals`, `enumerateModels`, `renderModel`, `Obs`,
  `obsSpace`, `thetaSpace`, `emit`, `Agent`, `mkAgent`, `predictive`,
  `observe`, `agentMeta`, `agentModels`. All export-list changes this
  increment are ADDITIVE.
- The `PropLang.Belief` export list is frozen by gate 2
  (audit/belief-exports.txt, 21 items) and does not change. See T3.

---

## The three tensions this plan surfaces (read these first)

The kickoff predicted teeth at Q5. Scoping found the Q5 collision
dissolves at the letter (see Q5 below) — but three real tensions live
elsewhere, and each one shapes the register.

### T1 — `rw` is not an exponential family; its spec'd re-derivation cannot be float-preserving. [STOP-AND-REPORT AT PLAN TIME]

interface.md §4 commits to `rw(rho) = expfam(THETA, id,
mean=('get','theta_prev'), scale=rho)`. The frozen reference semantics
of `rw` is the REFLECTED WALK (`walkKernel`): from grid position i,
mass 1−ρ at i, ρ/2 at each reflected neighbor, and **hard zeros
everywhere else — zeros that move with the source point**. An
exponential family over a fixed carrier has densities
`h(y)·exp(η·T(y) − A(η))`: its support is the support of the base
measure `h`, fixed for the whole family, independent of the parameter.
No stats basis with a fixed base measure expresses source-dependent
hard zeros. (Also: a `scale` parameter needs the (y, y²) stats pair,
which is the gauss/continuous debt.) So the choice is exact:

- **(a)** re-derive `rw` through a genuinely expfam kernel (discretized
  location-scale, full support) — this CHANGES the filter's floats and
  support, moves `t4LlFullD`/`t4LlNohmm` and the drift anchors, and is
  therefore a Phase-1 re-open of frozen anchors; or
- **(b)** record that `rw` is NOT in the expfam basis: it stays a named
  decision-free combinator (design §9), its deletion row stays the
  frozen restricted-enumeration row, and interface.md §4's `rw` line is
  amended by the author (the alphabet residue keeps one non-expfam
  member, printed and priced, per design §10's honesty standard); or
- **(c)** defer the adjudication with latent names (Q2): this increment
  re-derives `bern` only, `rw` untouched.

**Proposed disposition: (b) for the record plus (c) for the code** —
this increment re-derives `bern` fully; `rw` gains nothing and loses
nothing; the author amends interface.md §4's rw claim at the freeze
(interface.md is not manifest-frozen; the amendment is the author's
text). (a) is on the table only as a future author-initiated re-open.

### T2 — the frozen hygiene pins fix the EXPR node cost at log2 10; a flat alphabet count would break them.

test-hygiene group 3 (FROZEN at `db34a9a`) pins six absolute policy
prices built on node cost log2 10. If `ExpFam` were counted an 11th
EXPR alternative, every pinned absolute moves — a frozen-oracle
violation by arithmetic. The way out is already in the frozen spec
text: "description length is always relative to the generating
fragment's production grammar" (typed-port-spec §3), and interface.md
§4's published grammar introduces the constructor under its own
nonterminal — `KER ::= ('expfam', ...)`, the SOLE production of its
sort. **Proposed disposition: sort-local coding.** The EXPR production
alphabet stays the ten written alternatives (nodeB = log2 10,
unmoved); an `ExpFam` node is KER-sort and pays log2 1 = 0 constructor
bits plus its content (carrier mention + stats choice). The Fn
precedent is exactly this shape and is already frozen: Fn members pay
a sort-local FN choice bit, not an EXPR node cost. The alternative —
one flat alphabet, nExpr = 11 — requires the author to re-open
test-hygiene group 3 at a freeze boundary; the plan does not recommend
it, but it is the author's call to make, not the builder's to assume.

### T3 — the conjugate fast path is structurally unreachable without touching the frozen Belief export list.

CL-4's fast path must live "behind the opaque Belief handle." For
`cond` to take a sufficient-statistic shortcut it must RECOGNIZE an
expfam-structured kernel — but `Kernel`'s payload is an opaque
function, `kernel` (the only public constructor) cannot mark structure,
and adding a marked constructor or richer smart constructor to
PropLang.Belief changes an export list frozen by gate 2
(audit/belief-exports.txt is itself manifest-frozen). Nothing in any
frozen suite needs the speed. **Proposed disposition: defer the
representation fast path as named debt** (it lands, if ever, at an
author-initiated freeze that amends the export list), and land NOW the
two properties that are its entire semantic content — sufficiency and
name-expansion agreement (below). The frozen CL-4 properties pass
unmodified throughout because Belief does not change at all.

---

## Q1–Q5 (the kickoff's minimum)

**Q1 — what a Carrier is, and how natural-parameter semantics
discretize.** `Carrier c` is a declared finite output space as
first-order data: abstract type, smart constructor
`mkCarrier :: Name -> NonEmpty c -> Carrier c`, accessors
`carrierName`, `carrierSpace :: Carrier c -> Space c` (built through
the public `mkSpace`). It is `Grid` generalized: a named finite point
set, typed by its carrier. Declarations are domain data and live in
PropLang.Enumerate (`obsCarrier :: Carrier Int` = "obs" over 0 :| [1]),
exactly as the theta/tau/rho grids do. Pricing: a carrier mention costs
`log2 |carrierNames|` with `carrierNames :: [Name]` a priced namespace
constant in Syntax beside `featureNames` (same written rule: 0 bits
while the registry is a singleton — it is `["obs"]` this increment).
Discretization: parameters arrive as ordinary grid-priced sentences
evaluating to Doubles; the family maps a natural parameter η to a
belief over the carrier's points by normalizing over the finite
carrier — density `p(y) = exp(η·T(y)) / Σ_{y'} exp(η·T(y'))`, built
through `fromBits` (bits = `(A(η) − η·T(y)) / ln 2`), the only prior
source. No continuous carrier, no base-measure debt incurred: that
stays the named Event/Kernel-peer debt (design §3), recorded again
here.

**Q2 — latent-name-reading parameters: DEFERRED.** interface.md §7
orders the work: (2) expfam with discrete carriers, (3) latent names.
This increment is item (2). Consequence for `rw`: per T1 it cannot be
re-derived through expfam even WITH latent names without changing
frozen floats, so nothing is lost by deferring; `rw` stays exactly the
walkKernel combinator with its frozen anchors, and the latent-name
increment inherits the T1(b) record instead of a hidden promise.
Consequence for `bern`: none — plain `bern` needs no latent names; the
family kernel's INPUT is its parameter (that is what `K Double c`
says), which is how the hmm emission uses it today (`emit` maps each
latent theta point to a belief).

**Q3 — the exact float-stability mechanism: R4 extended by the CL-4
doctrine, applied at the name layer.**
Two halves, one for prices and one for floats:

*Prices (the 5.17 / 4.0 / 16.34-bit sentences).* Model-fragment dl is
charged at the MODEL grammar's derivation choice points (R4, frozen
into the spec as derivation-relative coding). The MODEL grammar's
derivation does not change when `bern` stops being primitive and
starts being a name: `MODEL ::= bern | hmm` is still a 1-bit choice,
the param mention trees are identical, and the addition trees in
`enumerateModels` (dlConst/dlWalk/dlChange, parenthesization and all)
are NOT TOUCHED by this increment. What changed is what the word
"bern" abbreviates — the stdlib layer beneath the name — and
derivation-relative coding is precisely the principle that makes that
invisible to dl. Guardian: frozen hygiene group 2 pins all 1169 prior
masses at 1e-12 relative.

*Floats (execution).* The executed emission path keeps the reference
arithmetic literally: the derived name's semantics is the FAST FORM —
`bernFast th = fromBits (carrierSpace obsCarrier) (\y -> Bits (negate
(logBase 2 (if y == 1 then th else 1 - th))))` — the identical float
sequence to today's `bernBelief`, and `emit` is rewired to it with no
arithmetic change. The generic expfam evaluator (normalized
`exp(η·T(y))`) EXISTS as the semantics of `ExpFam` sentences, and the
name's expansion through it is the property-enforced CONTRACT, not the
executed path. This is CL-4's own doctrine ("the fast path buys speed,
never semantics — legal iff extensionally equal to the generic,
enforced by a property test") promoted from `cond` to the emission
basis. The rejected alternative — executing bern through the generic
`exp(logit θ)` path — is mathematically equal and float-different
(log/exp round trips), i.e. anchor movement at accumulated-ulp scale:
stop-and-report territory, so it is not taken. Guardians: the frozen
acceptance anchors (tolBits 1e-4), hygiene group 2, and the Task 6
margin readout, which must stay digit-for-digit as in HYGIENE_REPORT
§2.

**Q4 — the Stats alphabet (REPORTED ALPHABET CHANGE).** Minimal for
the in-scope basis:

```haskell
data Stats c where
#ifndef DROP_SID
  SId :: Real c => Stats c     -- T(y) = y, the identity statistic
#endif
```

| member | price | justification | deletion proof (one line) |
|---|---|---|---|
| `SId` | log2 1 = 0 bits (sole written STATS production) | `bern`'s sufficient statistic IS T(y)=y (interface.md §4); no smaller basis states it | delete `SId` and no expfam sentence can state a sufficient statistic: the family node is uncompletable, and likelihood assignment dies at the stats door — same capability loss as deleting `expfam`, at a distinct site |

Why exactly one: gauss's (y, y²) pair is the continuous-carrier debt
(named, not incurred); `rw` is out of the basis per T1; nothing else
has a consumer. When the pair lands (gauss increment), STATS grows to
two written alternatives and every stats choice starts paying 1 bit —
a reported change at that freeze, priced by the same written-
alternatives convention as R2.

**Q5 — what happens to the frozen deletion rows for bern/rw.** The
teeth the kickoff expected here dissolve at the letter, and the plan
states why precisely, because the WHY is what keeps it honest:

- The frozen `audit/ablation.sh` has exactly two rows — `push` and
  `argmax`. There are no bern/rw CPP rows to break: **bern and rw were
  never grammar constructors in the typed port.** There is no `Bern`
  in `Expr` today; test 4's bern/rw rows are RESTRICTED-ENUMERATION
  rows through the exported Enumerate API: `t4NNobern = 0` pins
  `length (enumerateModels [TIf, TC, TGet, TGt])`, and `t4LlNohmm =
  211.05494026245512` (tolBits 1e-4) pins `runWorld [TBern, TIf, TC,
  TGet, TGt] drift250`.
- After re-derivation those rows compile against the UNCHANGED
  Enumerate exports (`Terminal(..)`, `enumerateModels`, …) and pass
  because (i) `TBern`/`THmm` remain the enumeration gates of the same
  branches and (ii) the branch floats are unchanged (Q3). What
  `TBern` now MEANS is "the derived name bern is available to the
  model fragment" — the gate names the same capability one layer up.
- interface.md §7's "old deletion-audit rows retargeted at expfam and
  at the carrier declarations" therefore executes ADDITIVELY: the
  frozen rows keep their compiled meaning; the tightened claims are
  NEW rows in the increment-local `test-expfam/ablation.sh` (table
  below), and frozen audit scripts grow nothing.
- The one place a bern/rw-shaped tension IS real is T1 — a frozen
  oracle (walk anchors) against a spec'd re-derivation (rw-as-expfam)
  — and it is met here at Task 0, as requested, not at a failing gate.

## The new grammar surface (proposed; author rules)

```haskell
-- Syntax.hs (additive; every new item behind its ablation flag)
data Carrier c              -- abstract; mkCarrier/carrierName/carrierSpace
data Stats c where SId :: Real c => Stats c

data Expr env t where
  ...ten existing constructors, unchanged...
#ifndef DROP_EXPFAM
  ExpFam :: Space Double -> Carrier c -> Stats c -> Expr env (K Double c)
#endif

data StdName args t where
  ...four existing members, unchanged...
#ifndef DROP_BERN
  Bern :: Carrier Int -> StdName '[Double] (B Int)
#endif
```

Two recorded deviations from the spec §3 sketch, for the author to
absorb into typed-port-spec.md at the freeze or reject at Task 0:

1. **No `Params env` slot on the node.** The family kernel's input IS
   its (single) natural parameter — `K Double c` already says so, and
   `bern` needs zero further params. Extra params (rw's `scale`,
   gauss's second slot) have no in-scope inhabitant; adding an
   uninhabited-in-practice `Args env ps` slot forces the generic
   evaluator to invent semantics for arbitrary param lists, i.e.
   partiality or fiction. The slot arrives with its first consumer as
   a reported constructor-shape change (YAGNI, totality-first —
   CLAUDE.md's own rule).
2. **The node declares its parameter space** (`Space Double` payload,
   opaque value-layer, priced 0 by the recorded payload convention).
   `kernel :: Space a -> Space b -> (a -> Belief b) -> Kernel a b` is
   frozen-listed and needs a domain space; the evaluator cannot mint
   one without a numeric literal in src/ (forbidden) and cannot reach
   domain data (module order). A kernel HAS a domain; declaring it on
   the sentence is declared structure, not ceremony.

`Bern` carries its carrier as an opaque payload (the Fn-payload
precedent) and is Belief-valued (`B Int`): `Call (Bern obsCarrier)
(p :* ANil)` is the emission distribution at the evaluated parameter —
the shape `stepHyp` actually consumes. The θ-indexed family kernel
(`emit`) is the same fast form spread over the theta grid; the
increment oracle pins them to the same floats.

**Prices** (all rules; the singleton-registry values in parentheses
are this increment's):

| site | price |
|---|---|
| `ExpFam` node | log2 1 KER choice + log2 &#124;carrierNames&#124; mention (0) + log2 1 STATS choice = **0 bits** — every choice is forced, and a forced choice carries no information; the RULES are what freeze |
| `Call (Bern _) p` | log2 10 (EXPR node) + log2 5 (StdName grows 4 → 5: reported) + price(p) |
| `Stats` payload | none (no payload) |
| `Space`/`Carrier` payloads on nodes/names | 0 (recorded opaque-payload convention, parity-scoped rider carried over) |

No frozen pin prices a `Call` or a kernel-typed sentence (verified:
hygiene group 3's six forms are Get / mkC / Argmax ×2 / Expect ×2), so
the stdB change is collision-free.

**Rendering:** `renderExpr` gains `ExpFam _ car st -> "('expfam', '" ++
carrierName car ++ "', '" ++ statsStr st ++ "')"` with `statsStr SId =
"id"`; `stdNameStr (Bern _) = "bern"`. No frozen test renders either;
the increment oracle pins both strings.

## Under-determination register (dispositions proposed; author rules)

1. **E1 — scope of the re-derivation** (= T1): bern fully re-derived;
   rw untouched in code, its expfam claim amended out of interface.md
   §4 by the author (rw stays a named non-expfam combinator of the
   alphabet, printed and priced per design §10). Alternatives: rw
   gains StdName namehood without expfam contract (stdB → log2 6), or
   a future anchor re-open for (a). CLAUDE.md step 6 says "bern/rw
   re-derived" — this disposition executes bern and RECORDS rw's
   impossibility; the author's ruling here is also the ruling on that
   frozen sentence's intent.
2. **E2 — sort-local pricing** (= T2): EXPR stays 10; ExpFam is
   KER-sort at 0 constructor bits; STATS its own sort. Alternative
   (flat nExpr = 11) requires an author re-open of frozen hygiene
   group 3 — named, not recommended.
3. **E3 — node shape**: no Params slot; Space Double payload (the two
   recorded spec deviations above). Author absorbs into
   typed-port-spec.md §3 at the freeze or rejects now.
4. **E4 — Carrier representation and registry**: abstract
   named-finite-point-set; declarations in Enumerate (`obsCarrier`);
   `carrierNames = ["obs"]` in Syntax beside `featureNames`.
   Alternative: declarations in Syntax (featureNames precedent) —
   rejected here because carriers are domain data like grids.
5. **E5 — Stats alphabet** = {SId}, 0 bits, deletion proof per Q4
   table; gauss pair is named debt.
6. **E6 — derived-name mechanics**: `Bern` as StdName member with
   carrier payload, Belief-valued; stdB log2 4 → log2 5 (reported
   alphabet change, this section is the report); render "bern".
7. **E7 — executed-path doctrine** (= Q3): fast form executed,
   expansion property-enforced. The property (group 5 below) is the
   increment's CL-4-for-the-basis.
8. **E8 — fast path deferred** (= T3): no Belief change of any kind;
   sufficiency property lands as the fast path's semantic license;
   representation debt named.
9. **E9 — ablation wiring**: four flags, all increment-local rows.
   `DROP_EXPFAM` removes the constructor AND its evalx/bits/render
   cases AND the derived layer (`Bern`, `bernFast`, `emit`, the
   emission-dependent enumeration branches, the `HypState` members) —
   under the flag `HypState` is an empty data type discharged by
   EmptyCase (the parity-phase `Fn` precedent exactly), enumeration is
   empty, and ALL of src/ still compiles (the spec §5 ablation
   standard). Deleting the basis deletes the derived names' semantics
   WITH it — that coupling is what makes "delete expfam and nothing
   can assign likelihood" TRUE at the code level rather than
   aspirational.
10. **E10 — pre-freeze oracle mechanics** (new; forced by the frozen
    cabal): at Task 1 the builder cannot add the test-suite stanza, so
    the runtime-red demonstration runs the oracle OUT of cabal:
    `cabal build all` (deps in scope) then
    `cabal exec -- ghc -isrc -itest-expfam test-expfam/ExpFam.hs
    -outputdir <scratch> -o <scratch>/expfam && <scratch>/expfam`,
    with the canonical tree never diffing a frozen file. The stanza
    ships as `test-expfam/stanza.cabal.draft`; the author applies it
    inside the Task 2 freeze commit. Gate 5 simply does not see the
    suite until the freeze; from the freeze to Task 5 completion gate
    5 is EXPECTED-FAIL (expfam suite red, frozen suites green) —
    documented, as the hygiene red window was.
11. **E11 — manifest scope at re-signing**: the 24-entry command
    extended by `test-expfam` in the find (exact command in Task 2).
    typed-port-spec.md re-hashes with the absorbed E3 amendments;
    interface.md stays outside the manifest (author's text, author's
    call — flagged for the author to reconsider since §4 is now
    load-bearing for this increment's semantics).
12. **E12 — tolerances** (part of the oracle, never widened in
    place): cross-path extensional properties 1e-9 relative (frozen
    CL-4 convention); same-arithmetic-path assertions exact `==`
    (hygiene group 4 convention); closed-form float pins 1e-12
    relative (hygiene group 2 convention); price pins 1e-12 absolute
    (hygiene group 3 convention).

## The increment oracle: `test-expfam/` (written at Task 1, runtime-red)

`ExpFam.hs` groups, with their red/green split at Task 1:

1. **Carrier basics** [RED]: `mkCarrier` name/size accessors;
   `carrierSpace` round-trips through public `top`/`expect` (a 2-point
   carrier's uniform belief has mass ½ ± 1e-12 per point).
2. **Price pins** [RED]: `bits (ExpFam sp obsCarrier SId)` = 0 exactly
   (± 1e-12); `bits (Call (Bern obsCarrier) (p :* ANil))` = log2 10 +
   log2 5 + price(p) for p = an mkC sentence over a local 4-point grid
   (mirrors hygiene g4); the six FROZEN hygiene forms are deliberately
   NOT re-pinned here (the frozen suite guards them; duplicating pins
   splits custody).
3. **Generic semantics** [RED]: `evalx (ExpFam sp obsCarrier SId)` at
   fixed η: p(1) = e^η/(1+e^η) within 1e-12 relative; QuickCheck over
   η ∈ [−6, 6]: masses normalize to 1 within 1e-12, p(1) strictly
   monotone in η.
4. **Name semantics and rendering** [RED]: `renderExpr` pins for the
   expfam node and `"('call', 'bern', ...)"`; `evalx (Call (Bern
   obsCarrier) (p :* ANil))` masses = (1−θ, θ) within 1e-12 relative
   (θ from p's grid point); `emit`'s row at each theta grid point
   equals the name's belief at the same θ — exact `==` on `expect`
   readouts (same arithmetic path after Task 5).
5. **CL-4 for the basis (name-expansion agreement)** [RED]: for
   θ ∈ [0.05, 0.95] randomized, the fast form at θ agrees with the
   generic family at η = log(θ/(1−θ)) (host-side logit; the grammar
   needs no logit): `expect`/`prob` agreement ≤ 1e-9 relative. This is
   the property that makes "re-derived" a checked claim instead of a
   comment.
6. **Sufficiency** [RED]: for a random parameter-grid prior and the
   generic family kernel, folding `cond` over two batches of equal
   length and equal ΣT(y) yields posteriors with `expect f` agreement
   ≤ 1e-9 relative for random f — the posterior depends on the data
   only through (n, ΣT). This is the entire semantic content of any
   future conjugate fast path, landed as oracle before any such path
   exists.
7. **Float guardians** [GREEN from the start]: `emit`'s masses at
   every theta grid point pinned to (1−θᵢ, θᵢ) within 1e-12 relative
   AGAINST TODAY'S CODE — green before, during, and after the Task 5
   rewiring; any drift in the executed emission path fails here before
   it can reach a 1e-4 acceptance anchor.
8. **Ablation rows** [GREEN from the start, against Task 1 stubs]:
   via `test-expfam/ablation.sh` (increment-local; frozen scripts
   untouched), three checks per row (positive control / fails under
   flag / error names the token):

| row | flag | fixture utters | one-line deletion proof |
|---|---|---|---|
| expfam | `DROP_EXPFAM` | `ExpFam` | the basis dies and the whole derived layer with it (E9 coupling): no sentence, name, or enumerated model can assign likelihood to any observation — interface.md §4's tightened claim, at the code level |
| sid | `DROP_SID` | `SId` | no sufficient statistic is sayable; the family node is uncompletable (Q4 table) |
| bern | `DROP_BERN` | `Call (Bern …)` | the derived name is unutterable; emission must be spelled as raw expfam — capability survives, brevity dies (the `call`-row honesty flag, design §2, applied to a derived name) |
| carrier-obs | `DROP_CARRIER_OBS` | `obsCarrier` | the obs carrier declaration dies; no expfam sentence can declare its output space over observations — observations become context-only (interface.md test E, restricted to the code level) |

Draft stanza (ships as `test-expfam/stanza.cabal.draft`; the author
applies it verbatim at Task 2):

```
test-suite expfam
    import:           warnings
    type:             exitcode-stdio-1.0
    main-is:          ExpFam.hs
    hs-source-dirs:   test-expfam
    build-depends:    base
                    , proplang
                    , tasty
                    , tasty-hunit
                    , tasty-quickcheck
                    , QuickCheck
                    , process
    default-language: GHC2021
```

## Expected gate matrix

| gate | Task 1 (oracle, pre-freeze) | Tasks 3–5 (red window) | at completion |
|---|---|---|---|
| 1 build -Werror | PASS (stubs compile clean) | PASS | PASS |
| 2 Belief exports | PASS (Belief untouched all increment) | PASS | PASS |
| 3 no IO | PASS | PASS | PASS |
| 4 forbidden tokens | PASS | PASS | PASS |
| 5 cabal test all | PASS — 3 suites; expfam suite not yet in cabal, red via the E10 runner | EXPECTED-FAIL (expfam red, frozen 3 green) | PASS (4 suites) |
| 6 manifest | PASS (24 entries, untouched) | PASS (extended set, author-signed) | PASS |
| 7 ablation | PASS | PASS | PASS (+ 4 increment-local rows via gate 5) |

Anchor movement anywhere in this matrix = stop-and-report.

## Reviewer verification (run yourself; the builder's word is not load-bearing)

```
sha256sum -c MANIFEST.sha256                        # all OK (extended set after your Task 2 signing)
export PATH="$HOME/.ghcup/bin:$PATH"
sh audit/run-gates.sh --phase 2; echo $?            # gates 1-7 PASS, exit 0
cabal test all                                      # acceptance 4/4, properties 3/3, hygiene 15/15, expfam all green
git log --format='%G? %h %s' -- MANIFEST.sha256     # exactly d03bb10, db34a9a, b1c8e00, + your Task 2 commit; all G, the new one yours
git diff --name-only <freeze>..HEAD -- test test-hygiene audit CLAUDE.md \
    proplang.py tests_acceptance.py test_output.txt \
    typed-port-spec.md proplang.cabal cabal.project.freeze   # empty (builder tasks 3-5 touched src/ and test-expfam-adjacent nothing)
sh test-expfam/ablation.sh all; echo $?             # four rows, exit 0
```

Personal eyeballs (mechanically unchecked): the Enumerate dl trees
still byte-identical to HYGIENE_REPORT's record; `emit`'s arithmetic
against `bernFast` (same float sequence); the T1 record in the report
against interface.md as amended; and `test-expfam/` contents BEFORE
you sign them.

---

### Task 0 (AUTHOR): rule on T1/T2/T3 as E1/E2/E8, and E3–E7, E9–E12

Nothing moves until the rulings return. If E1 lands anywhere but (b)+(c)
or E2 anywhere but sort-local, large parts of this plan re-open — those
two rulings are the plan's load-bearing joints.

### Task 1 (builder): type-surface stubs + the expfam oracle, runtime-red

Stubs in src/ (compile-enabling, per the canonized protocol): the four
flagged constructors/members (`ExpFam`, `SId`, `Bern`, `obsCarrier` +
`Carrier`/`mkCarrier`/accessors), `bits`/`evalx`/`renderExpr` cases
with `undefined`-free minimal bodies where totality demands them and
`error`-free stub values where it does not (the hygiene Task 1 pattern:
runtime-red, never compile-red, frozen suites green throughout).
`test-expfam/` written in full: `ExpFam.hs` (groups 1–8),
`ablation.sh` + four fixtures, `stanza.cabal.draft`. Red run via the
E10 runner; `cabal test all` (3 suites) stays green; gates 1–4, 6, 7
green. Commit (builder, unsigned).

### Task 2 (AUTHOR, in person — the standing rule's first exercise): freeze

The builder prepares and STOPS; you run, in your own shell:

```
# 1. review test-expfam/, the register dispositions as-built, and the
#    E3 spec amendments; apply the stanza:
$EDITOR proplang.cabal        # paste test-expfam/stanza.cabal.draft
$EDITOR typed-port-spec.md    # absorb E3 amendments (your text)
$EDITOR interface.md          # E1(b): amend the rw line (your text)
# 2. re-sign:
{ find test test-hygiene test-expfam audit -type f; echo CLAUDE.md;
  echo proplang.py; echo tests_acceptance.py; echo test_output.txt;
  echo typed-port-spec.md; echo proplang.cabal;
  echo cabal.project.freeze; } | sort | xargs sha256sum > MANIFEST.sha256
sha256sum -c MANIFEST.sha256
# 3. countersign, your hand:
git add proplang.cabal typed-port-spec.md interface.md MANIFEST.sha256
git commit -S -m "ExpFam Task 2: freeze the expfam oracle ..."
```

From your signature `test-expfam/` is as frozen as `test/`, and the
manifest history gains its first commit that attests author action,
not key access.

### Task 3 (builder): syntax and prices

`Carrier`/`Stats`/`ExpFam`/`Bern` real; `bits` KER-sort case;
`renderExpr` cases; `carrierNames`. Oracle groups 1–2 and the render
pins of 4 green; frozen suites green. Commit.

### Task 4 (builder): semantics

Generic `evalx` for `ExpFam` (normalized exp over the carrier);
`applyStd (Bern car)` = the fast form; groups 3, 5, 6 green. Commit.

### Task 5 (builder): rewiring and ablation coupling

`emit`/`bernBelief` re-expressed through `bernFast` (identical
arithmetic — group 7 is the tripwire); the E9 CPP coupling landed
(empty-HypState shape under `DROP_EXPFAM`; all of src compiles under
every flag); group 8 green; full suite green. Anchors byte-stable or
stop-and-report. Commit.

### Task 6 (builder → AUTHOR): verification and report

`sh audit/run-gates.sh --phase 2` exit 0 in a clean shell; margin
readout digit-for-digit (the scratchpad program, unchanged, third
outing); `EXPFAM_REPORT.md` (as-built answers to E1–E12, the T1
record, gate matrix, margins); author runs the reviewer verification
block and acknowledges. The builder signs nothing.

---

*Plan ends here. Stopped for Task 0 — no stubs, no oracle, no
implementation exists; the working tree holds this plan and the
archive/ housekeeping only.*
