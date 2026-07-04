# Grammar-Hygiene Increment Plan (step-6 increment 1)

> Build target: the AMENDED typed-port-spec.md (author amendment of
> 2026-07-05, absorbed pre-increment; supersedes this plan's 2026-07-04
> draft). Scope is exactly (a) mkC, (b) real policy prices, (c) Fn
> inhabited. This plan STOPS at author review — no implementation
> before the rulings on the register below and the Task 2 freeze.
>
> **For agentic workers:** REQUIRED SUB-SKILL: superpowers:executing-plans
> (single session; the tasks share one module's types). Do not begin
> Task 1 until the author approves this plan; do not begin Task 3
> until the author has completed the Task 2 freeze.

**Goal:** Retire the three parity-phase expedients — denoting off-grid
constants, placeholder policy prices, empty `Fn` — exactly as the
amended spec §3 now requires, with zero behavioral change visible to
the frozen suite.

**Architecture:** All code changes live in the five `src/PropLang/*.hs`
modules plus a NEW increment-oracle directory `test-hygiene/` and one
cabal stanza. The frozen oracle is the regression net; the frozen gate
5 (`cabal test all`) absorbs the new suite with no edit to any frozen
file.

**Tech stack:** GHC 9.10.3 (`~/.ghcup`), cabal 3.16, base-only src/;
tasty / tasty-hunit / tasty-quickcheck (already pinned in
`cabal.project.freeze`).

## Global constraints

- **Behaviorally invisible to the frozen suite**: every gate stays
  green, every anchor unmoved. An anchor that moves is
  **stop-and-report**, never a fix (CLAUDE.md; kickoff).
- No diff under anything hashed in MANIFEST.sha256, and no diff to
  MANIFEST.sha256 itself by the builder — the manifest is edited only
  by the author, at the Task 2 freeze.
- `-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`
  clean; no IO token outside Host; forbidden-token list clean; src/
  depends on base only.
- The frozen tests' uttered surface keeps compiling unchanged:
  `Argmax, Var, If, Get, Call, Z, S, (:*), ANil, EU, IsEq, VAct,
  VThink, mkUtil, B, K, Util, mkEnv, VNil, (:.), evalx`, the Belief
  export list, the Enumerate API, and the two ablation fixtures
  (which utter `Push`/`Argmax`/`Var`/`Get` only). No frozen file
  utters `C`, `CondE`, `Expect`, or `bits` — those corners may change
  shape.

---

## Open question 1 — the Fn alphabet (REPORTED ALPHABET CHANGE)

Per CLAUDE.md ("if you need a new function form, add a first-order
constructor with a bit-price and report it as an alphabet change"),
this section is that report. Proposed alphabet — the smallest set
under which the frozen stdlib compositions become expressible as
priced syntax later:

```haskell
data Fn a where
  FnInd  :: Event a -> Fn a          -- the indicator of a declared event
  FnUtil :: Util o a -> o -> Fn a    -- a utility section: one option's stake profile
```

| member | price | justification (smallest-set argument) | deletion proof (one line) |
|---|---|---|---|
| `FnInd` | 1 bit (FN choice, 2 alternatives) + 0 (opaque Event payload) | design §3 derives probability FROM prevision: `prob b e = expect b (indicator e)`. Without a sayable indicator, that derivation has no syntactic witness and `prob` is primitive rather than derived. | Delete `FnInd` and no sentence can say P(E): probability-as-prevision becomes unutterable; the grammar loses contact with declared events except through `CondE`. |
| `FnUtil` | 1 bit (FN choice, 2 alternatives) + 0 (opaque Util + option payloads) | the frozen `EU` contract IS `expect b (applyUtil u a)` — a utility section. `VAct` is Argmax/max over EU shapes and `VThink` is logPredict/cond folds closing over `VAct`; `IsEq` needs no Fn. So every frozen StdName expands over {FnUtil} ∪ verbs, and nothing smaller does it. | Delete `FnUtil` and expected utility becomes unutterable as a sentence: the policy fragment can no longer quote its own scoring rule, and EU/VAct/VThink survive only as unexpandable primitives. |

Why exactly two: `IsEq` is Fn-free; `VAct`/`VThink` reduce to EU's
shape plus verbs already in the grammar; `prob` and `EU` are the only
published expansions in the reference (proplang.py design §3 comment;
tests_acceptance `make_eu` docstring). Anything further (identity,
composition, arithmetic on Fn) is speculative structure with no frozen
consumer — YAGNI until CIRL, at which point Util/Event payloads must
themselves become priced syntax (the parity-scoped rider on Phase 1
ruling 3 carries over to both payloads here).

Payload prices of 0 are the recorded convention for opaque value-layer
objects (Phase 1 report §4.3); they are named here as part of the
alphabet change rather than silently assumed.

`Expect`'s empty-case discharge retires; `evalx` gains real semantics,
compiled against the public Belief API only:

```haskell
Expect b f -> case f of
  FnInd e    -> prob (evalx b env) e
  FnUtil u o -> expect (evalx b env) (applyUtil u o)
```

## Open question 2 — the new-test protocol (recursive two-phase)

Frozen `test/` cannot grow; new capability needs its own oracle with
the same custody chain. Proposal:

1. **Location:** one directory per increment, sibling of `test/`:
   `test-hygiene/` now, `test-expfam/` etc. later. Each is a cabal
   test-suite stanza (`proplang.cabal` is unfrozen). The frozen gate 5
   already runs `cabal test all`, so every increment suite joins the
   gate with zero edits to frozen audit scripts.
2. **Cycle, mirroring Phase 1 exactly:** (i) the builder writes the
   increment oracle FIRST, red against unimplemented code; (ii) the
   author reviews oracle + register dispositions; (iii) the author
   extends and re-signs the manifest — from this signature the
   increment oracle is as frozen as `test/`; (iv) only then does
   implementation begin. The builder never owns a live oracle at the
   moment it becomes binding.
3. **Re-signing command** (author, Task 2; adds the increment oracle
   and — recommended, register R9 — the now-load-bearing spec):

```
{ find test test-hygiene audit -type f; echo CLAUDE.md; echo proplang.py;
  echo tests_acceptance.py; echo test_output.txt; echo typed-port-spec.md; } |
  sort | xargs sha256sum > MANIFEST.sha256
```

4. **Mid-increment gate state is documented, not hidden:** between
   (i) and (iv), gate 5 reports the same EXPECTED-FAIL discipline
   Phase 1 ran under (hygiene suite red, frozen suites green); gates
   1–4, 6, 7 stay green throughout.

## Under-determination register (dispositions proposed; author rules)

> **Task 0 rulings received 2026-07-05:** Q1 APPROVED as written; Q2
> APPROVED and canonized (the author appends the recursive increment
> protocol to CLAUDE.md at Task 2 and includes it in the re-signed
> manifest — future increments cite CLAUDE.md, not this plan); R1–R4
> and R6–R9 APPROVED as proposed (R4 additionally recorded in the spec
> as derivation-relative coding); **R5 CORRECTED** for
> prefix-decodability — see the amended entry below; **Task 1
> AMENDED** — the oracle ships with compile-enabling type-surface
> stubs so the red window is runtime-red (a compile-failing oracle
> proves nothing), with the frozen suites staying green throughout.
> Build target is the re-amended spec (typed-port-spec-3.md, absorbed
> pre-Task-1).

1. **R1 — how an unexported `C` survives cross-module evaluation.**
   The spec's letter ("NOT exported") collides with the frozen
   architecture twice: `evalx` (Eval) and the renderer/enumerator
   (Enumerate) must pattern-match `C` from outside Syntax, and the
   frozen gate-3/4 scan lists (exactly five files) plus spec §6's
   module map preclude an Internal module. Disposition: **the real
   constructor `MkC Grid Ix Double` is unexported; a unidirectional
   pattern synonym `pattern C g k v <- MkC g k v` is exported bundled
   with `Expr`** — match-only, so construction is impossible anywhere
   (including src/) except through `mkC :: Grid -> Ix -> Maybe (Expr
   env Double)`, which is the spec's exact door. The pattern carries
   the resolved point VALUE, fixed once at mkC time: `evalx` reads it
   with no lookup, no dormant 0.0, no error site — off-grid is
   unconstructible AND everything constructible denotes. Costs:
   `PatternSynonyms` pragma + CPP-guarded `{-# COMPLETE #-}` set for
   exhaustiveness under `-Werror`. (The match pattern exposing three
   fields where the spec sketch draws two is match-direction surface
   only; the construction interface is exactly the spec's.)
2. **R2 — "genuine alternative counts": the count is the shipped
   grammar's.** nExpr = 10 (the ten constructors of this increment;
   ExpFam is absent until its own increment). Policy prices therefore
   shift when the alphabet grows — legal, since no frozen anchor
   prices a policy sentence, and every alphabet growth is already a
   reported change. Counting is by written alternatives (the Python
   convention), not type-pruned availability.
3. **R3 — `Var` needs |scope| from the type**, so `bits` grows a
   constraint: `bits :: KnownScope env => Expr env t -> Bits`, where
   `KnownScope` is the two-instance class computing the type-level
   env length. The spec sketch's signature is kept modulo constraint;
   no frozen file utters `bits`. Recursion gets `KnownScope (o ':
   env)` for Argmax bodies for free from the instance head.
4. **R4 — two pricers coexist, as in the reference.** Model-fragment
   description lengths are charged AT THE DERIVATION (the enumerator
   composes dl as it composes the sentence — design §5's own wording:
   "charged at derivation choice points"), with arithmetic kept
   term-for-term identical to today's; `Model` carries its `Bits`.
   Public `bits` becomes the policy-sentence pricer per spec §3. This
   mirrors Python's bits_model/bits_param family versus the (never
   written) policy pricer, and is what keeps the anchors byte-stable
   while verb nodes get genuine prices.
5. **R5 — policy price table** (CORRECTED at Task 0:
   prefix-decodability requires EVERY node to pay its
   constructor-choice cost log2 nExpr with no exemptions, `Var`
   included; content is then added). With log2 10 ≈ 3.3219, children
   in EXPR context: `C` = log2 10 + log2(gridSize); `Get` = log2 10 +
   (log2 |featureNames| if >1 else 0); **`Var` = log2 10 + log2(scope
   size)**; `If`/`Gt`/`Push`/`CondE` = log2 10 + children; `Expect` =
   log2 10 + child + Fn price (Q1 table); `Argmax` = log2 10 +
   options + body(scope+1); `Call` = log2 10 + log2 4 (closed StdName
   alphabet) + args.
6. **R6 — Fn deletion wiring.** The Q1 deletion proofs stand as
   normative one-liners; additionally (recommended, same standard as
   the spec §5 ablation row) `FnInd`/`FnUtil` go behind
   `DROP_FNIND`/`DROP_FNUTIL` CPP flags with two fixtures and a local
   runner in `test-hygiene/ablation/` — `audit/ablation.sh` is frozen
   and cannot gain rows, so the increment carries its own, invoked
   from the hygiene suite exactly as test 4 invokes the frozen one.
7. **R7 — `gridLookup` retires from the Syntax exports** (its only
   consumer was the dormant read this increment deletes); it survives
   as the private validator inside `mkC`. `mkGrid`/`gridName`/
   `gridSize` stay.
8. **R8 — enumeration under mkC discipline.** `MHmm` stores its rate
   constant AS the sentence it is (`MHmm Bits (Expr '[] Double)` —
   Python's `('hmm', ('c','rho',k))` literally): rate value by
   evaluation, rendering by match, and both remaining Enumerate
   `error` sites dissolve. Change-point/constant enumeration builds
   via `[ e | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]` —
   no error site, and completeness is pinned by the frozen 1169 count
   plus the hygiene dl pins.
9. **R9 — manifest scope at re-signing:** include typed-port-spec.md
   (its §3 price table is now load-bearing); recommended, author's
   call. Increment report lands as `HYGIENE_REPORT.md` at Task 6.

## Expected gate matrix

| gate | red window (oracle written, pre-freeze/impl) | at completion |
|---|---|---|
| 1 build -Werror | PASS | PASS |
| 2 Belief exports | PASS (untouched) | PASS |
| 3 no IO | PASS | PASS |
| 4 forbidden tokens | PASS | PASS |
| 5 cabal test all | EXPECTED-FAIL (hygiene red; frozen suites green) | PASS (3 suites) |
| 6 manifest | PASS (pre-freeze: old manifest intact) | PASS (extended, author-signed) |
| 7 ablation | PASS | PASS (+ hygiene-local Fn rows per R6) |

Anchor movement anywhere in this matrix = stop-and-report.

## Reviewer verification (run yourself; the builder's word is not load-bearing)

```
sha256sum -c MANIFEST.sha256                      # all OK (extended set after your Task-2 signing)
sh audit/run-gates.sh --phase 2; echo $?          # gates 1-7 PASS, exit 0
git log --oneline -- MANIFEST.sha256              # only author-signed commits touch it
git diff --name-only e24647d..HEAD -- test audit CLAUDE.md \
    proplang.py tests_acceptance.py test_output.txt   # empty
cabal test acceptance                              # anchors byte-stable
```

Personal eyeballs (mechanically unchecked): the Syntax export list
(`MkC` absent; `C` match-only), the Fn alphabet against the Q1 table,
and `test-hygiene/` contents BEFORE you sign them.

---

### Task 0 (AUTHOR): rule on Q1, Q2, R1–R9

The spec amendment is already absorbed (typed-port-spec.md replaced
2026-07-05). Nothing else moves until these rulings return.

### Task 1 (builder): the hygiene oracle, RUNTIME-red (as amended at Task 0)

**Files:** create `test-hygiene/Hygiene.hs` (+ `test-hygiene/ablation/`
fixtures and runner per R6); modify `proplang.cabal` (add `hygiene`
stanza: copy `properties`, `hs-source-dirs: test-hygiene`, deps +
tasty-hunit + process).

**Type-surface stubs (Phase 1 precedent: type surface is oracle-phase
work), so the oracle compiles and fails at RUNTIME while the frozen
suites stay green:** in `src/PropLang/Syntax.hs` — the two `Fn`
constructors behind their `DROP_FNIND`/`DROP_FNUTIL` CPP flags,
`mkC = undefined`, the `KnownScope` class head + its two instances,
`bits` gaining the R3 constraint (body still the parity placeholder —
that is what keeps group 3 red); in `src/PropLang/Eval.hs` — the
`Expect` empty case replaced by an `error` body (the empty case cannot
survive an inhabited `Fn`). `cabal test acceptance properties` must
stay green through this task.

Test groups (values assume R-dispositions as proposed; Task 0 rulings
adjust before this task runs):

1. `mkC` validity: `isJust (mkC g k)` on-grid, `isNothing` off-grid
   (−1, size, 99) for a locally built `mkGrid "g4" (0.2 :| [0.4, 0.6,
   0.8])`; `(\e -> evalx e (mkEnv [] VNil)) <$> mkC g 2 == Just 0.6`;
   sayable ⇔ denoting (QuickCheck over sizes/indices).
2. Model-dl pins through the PRIOR (the public route): a fresh full
   agent's `top` masses take exactly three values, closed-form
   2^−dl/Z with dl ∈ {2 + log2 9, 4, 10 + 2·log2 9}; assert at 1e-12
   relative. (Keeps R4's byte-stability honest without touching
   frozen anchors.)
3. `bits` table pins at 1e-12 vs closed forms (per the CORRECTED R5):
   `Get "t" :: Expr '[] Double` = log2 10; an `mkC`-sentence =
   log2 10 + log2 4; `Argmax (Var Z) (Get "t") :: Expr '[NonEmpty
   Double] Double` = 3·log2 10; `Argmax (Var Z) (Var Z)` (same env) =
   3·log2 10 + 1, the inner Var at scope 2 paying log2 10 + 1;
   `Expect (Var Z) (FnInd e) :: Expr '[B Obs] Double` = log2 10 +
   (log2 10 + 0) + 1.
4. Fn semantics (QuickCheck over small `fromBits` beliefs):
   `evalx (Expect (Var Z) (FnInd e)) (mkEnv [] (b :. VNil)) == prob b e`
   and the FnUtil analogue against `expect b (applyUtil u o)` — exact
   `==`, both sides being the identical arithmetic path.
5. Per R6: the two Fn ablation rows (compiles clean; fails under
   `-DDROP_FNIND`/`-DDROP_FNUTIL`; error names the constructor).

Steps: write stubs + oracle; `cabal build --enable-tests all` →
compiles clean (`-Werror`); `cabal test hygiene` → runs and FAILS at
runtime (groups 1, 3, 4 red on stub bodies; groups 2 and 5 are pins
and green from the start); `cabal test acceptance properties` → still
PASS; commit `test-hygiene: the grammar-hygiene oracle (runtime-red) +
type-surface stubs`.

### Task 2 (AUTHOR): freeze

Review `test-hygiene/` + the Task 0 rulings as-built; run the Q2
re-signing command; countersign via signed commit. From here
`test-hygiene/` is frozen for this builder.

### Task 3 (builder): (a) mkC

Modify `src/PropLang/Syntax.hs` (MkC/pattern C/COMPLETE/mkC; retire
gridLookup export), `src/PropLang/Eval.hs` (`C _ _ v -> v`),
`src/PropLang/Enumerate.hs` (R8 shapes). Verify: build clean; hygiene
group 1+5(partial) green; `cabal test acceptance properties` green;
`sh audit/ablation.sh all` green. Commit.

### Task 4 (builder): (b) prices

Modify `src/PropLang/Enumerate.hs` (dl at derivation), `src/PropLang/
Syntax.hs` (`KnownScope`; policy `bits` per R5; CPP guards kept).
Verify: hygiene groups 2+3 green; acceptance green (anchors
byte-stable — movement is stop-and-report). Commit.

### Task 5 (builder): (c) Fn

Modify `src/PropLang/Syntax.hs` (Fn constructors + prices + CPP flags
per R6), `src/PropLang/Eval.hs` (Expect semantics; EmptyCase retired).
Verify: hygiene suite fully green. Commit.

### Task 6 (builder → AUTHOR): verification and report

`sh audit/run-gates.sh --phase 2` exit 0; margin readout unchanged at
the 1e-13 level (scratchpad, as PHASE2_REPORT §2); write
`HYGIENE_REPORT.md` (as-built answers to Q1/Q2/R1–R9); author runs the
Reviewer verification block and acknowledges.

---

*Plan ends here. Stopped for review — no implementation has begun; the
working tree holds only the spec replacement (author's own amendment)
and this plan.*
