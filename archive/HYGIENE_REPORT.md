# Grammar-Hygiene Increment Report (step-6 increment 1)

Built to the amended typed-port-spec.md under the recursive increment
protocol (CLAUDE.md, canonized at the Task 2 freeze, commit `db34a9a`).
Scope as ruled at Task 0: (a) `mkC`, (b) real policy prices, (c) `Fn`
inhabited. This report is the as-built record against the plan's
register (GRAMMAR_HYGIENE_PLAN.md); the increment ends when the author
runs the reviewer verification block at the bottom.

Commit chain: `f6c3a1b` Task 0 (spec v3 absorbed, plan corrected) →
`9db47dd` Task 1 (oracle runtime-red + type-surface stubs) → `db34a9a`
Task 2 (author freeze, signed) → `6961352` Task 3 (mkC) → `45de901`
Task 4 (prices) → `4da81de` Task 5 (Fn semantics).

## 1. Gate matrix at completion

`sh audit/run-gates.sh --phase 2` → all seven gates PASS, exit 0.
Gate 5 now runs three suites: acceptance 4/4, properties 3/3, hygiene
15/15. `audit/ablation.sh all` and `test-hygiene/ablation.sh all` both
green (three checks per row). `sha256sum -c MANIFEST.sha256`: 22/22 OK.
Working tree clean; MANIFEST.sha256 touched only by the two signed
freeze commits (`d03bb10`, `db34a9a`).

## 2. Margin readout (unchanged from PHASE2_REPORT §2 — same program)

The Phase 2 scratchpad readout, recompiled unmodified against the
post-hygiene library, prints digit-for-digit the Phase 2 deltas:

| quantity | \|delta\| | Phase 2 value |
|---|---|---|
| t4 full-grammar log-loss (160 ticks) | 7.105e-14 | 7.105e-14 |
| t4 frozen-agent log-loss | 5.684e-14 | 5.684e-14 |
| t3 agent log-loss, drift400 | 0.0 | 0.0 |
| t3 agent log-loss, flat400 | 1.137e-13 | 1.137e-13 |
| t1 MAP posterior | 1.665e-15 | 1.665e-15 |
| t1 / t3 MAP rendered programs | byte-identical | byte-identical |

Not merely inside tolerance: the model-fragment path produces the same
floats it did before the increment. That is R4 doing its job.

## 3. As-built answers

**Q1 (the Fn alphabet — reported change, as approved).** Exactly
`FnInd :: Event a -> Fn a` and `FnUtil :: Util o a -> o -> Fn a`, one
FN choice bit each, opaque payloads priced 0 (parity-scoped, CIRL
rider). Semantics are the plan sketch verbatim, against the public
Belief API only: `FnInd e -> prob (evalx b env) e`;
`FnUtil u o -> expect (evalx b env) (applyUtil u o)` (Eval.hs). Each
branch sits behind its R6 flag so deletion takes verb and semantics
together. Recorded ruling (pre-freeze review): type-only imports of
sealed nouns (`Event` in UseFnInd.hs) are permitted in ablation
fixtures — "Syntax only" means no operational utterance; the fixture
signatures pin the approved member types, so a drifted signature fails
the positive control.

**Q2 (increment protocol).** Canonized into CLAUDE.md by the author at
the Task 2 freeze and covered by the re-signed manifest (22 entries,
now including `test-hygiene/` and `typed-port-spec.md` per R9). The
approved re-signing command was run verbatim. Consequence for the
plan's reviewer block: the frozen-surface diff since `e24647d` is
empty EXCEPT CLAUDE.md, whose only diff is the author's signed
appendix at `db34a9a` — the verification block below is amended
accordingly.

**R1 (unexported C).** As approved: real constructor
`MkC Grid Ix Double` unexported; exported surface is the match-only
`pattern C g k v <- MkC g k v` (bundled with `Expr` in an explicit
export list), a CPP-tracked `{-# COMPLETE #-}` set, and
`mkC g k = MkC g k <$> gridLookup g k` — the only door. The grid point
is resolved once at construction; `evalx`'s case is a field read
(`C _ _ v -> v`): no lookup, no dormant 0.0, no error site. The
overturned Phase 2 decision 3 is fully retired.

**R2 (alternative counts).** nExpr = 10 and the stdlib's 4, written as
alphabet data inside `bits` with the written-alternatives convention
recorded; counts do not shrink under CPP ablation (counting is by
written alternatives, not type-pruned availability).

**R3 (Var's scope).** `bits :: forall env t. KnownScope env => Expr
env t -> Bits` reads |scope| at the root via `scopeLen` and tracks it
as a plain Int through `Argmax` binders (`go (sc + 1)` on the body).

**R4 (two pricers).** `Model` carries its `Bits` on both constructors;
description lengths are charged at the derivation choice points in
`enumerateModels`, with addition trees term-for-term the parity-phase
pricer's (the parenthesization is written out in the Enumerate
comment). Evidence it held: hygiene group 2 pins all 1169 prior masses
at 1e-12 relative through the repricing, and §2's identical margins.

**R5 (policy price table, as corrected at Task 0).** Implemented
exactly; all six group-3 closed forms pass at 1e-12 absolute: `Get` =
log2 10; constant = log2 10 + log2 |grid|; `Argmax (Var Z) (Get "t")`
= 3·log2 10; inner Var at scope 2 = log2 10 + 1; both `Expect` forms =
2·log2 10 + 1.

**R6 (Fn deletion wiring).** `DROP_FNIND`/`DROP_FNUTIL` guard the
constructors (Syntax), their `bits` reach (via the Fn wildcard), and
their semantics (Eval). The increment-local runner and fixtures were
author-reviewed pre-freeze; both rows green from the hygiene suite,
with attribution (`Data constructor not in scope: FnInd :: Event a ->
Fn a`).

**R7 (gridLookup).** Retired from the Syntax exports; survives as
`mkC`'s private validator. Grep evidence pre-change: zero consumers in
test/, test-hygiene/, audit/, or the Python oracle.

**R8 (enumeration under mkC).** `MHmm Bits (Expr '[] Double)` — the
rate constant IS the sentence; rate by evaluation (`initHyp` evaluates
the closed constant; first error site gone), rendering by match.
Enumeration builds every constant via
`[ e | k <- [0 .. gridSize g - 1], Just e <- [mkC g k] ]`; the
change-point diagonal is excluded by index (`zip [0..]`), as the
reference does. The second error site (`walkKernel`'s point→index
lookup) dissolved by totalizing the mass function over grid POSITIONS:
`mass (Just i) (Just j)` is the reference's three-term sum unchanged;
any missing position has mass 0, i.e. infinite description length
through `fromBits` — the same road every non-neighbor grid point
already travels, and unreachable besides (`kernel` applies `step` only
to its own space's points). Note for review: the `MHmm` Bits field
landed at Task 3 with the shape change (its dl arithmetic unchanged);
`MBern`'s at Task 4 with the repricing.

**R9 (manifest scope).** Exercised by the author as recommended:
`typed-port-spec.md` is in the re-signed manifest. Still outside it
(recorded at signing, author's call): `proplang.cabal`,
`cabal.project.freeze`.

## 4. Reviewer verification (run yourself; the builder's word is not load-bearing)

```
sha256sum -c MANIFEST.sha256                       # 22/22 OK
export PATH="$HOME/.ghcup/bin:$PATH"
sh audit/run-gates.sh --phase 2; echo $?           # gates 1-7 PASS, exit 0
cabal test all                                     # acceptance 4/4, properties 3/3, hygiene 15/15
git log --format='%G? %h %s' -- MANIFEST.sha256    # exactly d03bb10 and db34a9a, both G (signed)
git diff --name-only e24647d..HEAD -- test audit proplang.py \
    tests_acceptance.py test_output.txt            # empty
git diff e24647d..HEAD -- CLAUDE.md                # exactly your Task-2 appendix (provenance db34a9a)
sh test-hygiene/ablation.sh all; echo $?           # both Fn rows, exit 0
```

Personal eyeballs (mechanically unchecked): the Syntax export list
(`MkC` absent; `C` match-only via the bundled pattern), and the
derivation-charged dl trees in Enumerate against the parity-phase
arithmetic.
