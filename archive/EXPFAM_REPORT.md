# ExpFam Increment Report (step-6 increment 2)

Built to typed-port-spec.md as amended at the Task 2 freeze (the
normative per-sort production table; the ruled ExpFam node shape),
under the CLAUDE.md increment protocol. Scope as ruled at Task 0:
the expfam basis — `ExpFam`/`Carrier`/`Stats` as first-order priced
syntax, `bern` re-derived as a stdlib name, `rw` recorded as the
alphabet's one non-expfam member (T1). This report is the as-built
record against EXPFAM_PLAN.md's register; the increment ends when the
author runs the reviewer verification block at the bottom.

Commit chain: `aa22d06` plan → `f39bef6` Task 0 absorbed → `42f469e`
Task 1 (oracle runtime-red + stubs) → `8ca269c` group-6 revision
(3-point sufficiency discriminator) → `658f07c` Task 2 freeze (G) →
`4c7b49d` re-open (G; three-token shadowing rename) → `3649836`
Task 3 (syntax/prices) → `81f01f8` Task 4 (semantics) → `54a6126`
Task 5 (rewiring + E9 coupling).

## 1. Gate matrix at completion

`sh audit/run-gates.sh --phase 2` in an `env -i` clean shell → all
seven gates PASS, exit 0. Gate 5 runs four suites: acceptance 4/4,
properties 3/3, hygiene 15/15, expfam 22/22.
`sha256sum -c MANIFEST.sha256`: 33/33 OK. `audit/ablation.sh all`,
`test-hygiene/ablation.sh all`, and `test-expfam/ablation.sh all` all
green with attribution. All of src/ compiles under each of the eight
ablation flags. Working tree clean; MANIFEST.sha256 touched only by
the five signed commits (`d03bb10`, `db34a9a`, `b1c8e00`, `658f07c`,
`4c7b49d`).

## 2. Margin readout (unchanged from PHASE2/HYGIENE §2 — same program)

The Phase 2 scratchpad readout, recompiled unmodified against the
post-expfam library, prints digit-for-digit the same deltas a third
time:

| quantity | \|delta\| | Phase 2 / hygiene value |
|---|---|---|
| t4 full-grammar log-loss (160 ticks) | 7.105e-14 | 7.105e-14 |
| t4 frozen-agent log-loss | 5.684e-14 | 5.684e-14 |
| t3 agent log-loss, drift400 | 0.0 | 0.0 |
| t3 agent log-loss, flat400 | 1.137e-13 | 1.137e-13 |
| t1 MAP posterior | 1.665e-15 | 1.665e-15 |
| t1 / t3 MAP rendered programs | byte-identical | byte-identical |

The model-fragment path produces literally the same floats through
the entire re-derivation. That is Q3's mechanism (R4's
derivation-relative dl + the fast-form doctrine) doing its job, plus
the hygiene group-2 prior pins and expfam group-7 guardians holding
throughout.

## 3. As-built answers (E1–E12)

**E1 (T1, scope).** As ruled, (b)+(c): `bern` fully re-derived; `rw`
untouched in code and recorded as the alphabet's one non-expfam
member — interface.md §4 amended by the author (in effect from
`f39bef6`, frozen at `658f07c`), CLAUDE.md step 6 amended inside the
freeze commit, the T1 impossibility proof (source-dependent hard
zeros vs fixed base measure) cross-referenced in the spec.

**E2 (T2, sort-local pricing).** The production table is normative
spec text (pack §1, frozen). As built: nodeB = log2 10 unmoved (the
six frozen hygiene pins never wavered); `ExpFam` pays kerB + carrierB
+ statsB = log2 1 + 0 + log2 1 = 0 bits (every choice forced; the
registry is a singleton); stdB = log2 4 → log2 5 (STDNAME grows by
`Bern`, the reported change — no frozen pin prices a `Call`). Written
counts do not shrink under CPP ablation (R2 convention carried over).

**E3 (node shape).** `ExpFam :: Space Double -> Carrier c -> Stats c
-> Expr env (K Double c)` — no Params slot until its first consumer;
the node declares its parameter domain as an opaque payload (priced
0). Absorbed into the spec at the freeze (pack §2).

**E4 (Carrier).** `Carrier c` abstract in Syntax (`mkCarrier`,
`carrierName`, `carrierSize`, `carrierSpace` through the public
`mkSpace`); the declaration `obsCarrier` is domain data in Enumerate;
`carrierNames = ["obs"]` is the priced registry in Syntax beside
`featureNames`, mentions free while singleton.

**E5 (Stats).** `SId :: Real c => Stats c`, sole written member, 0
choice bits; evaluated by `statVal` in Eval (empty case under
`DROP_SID`); rendered `"id"`. The gauss pair stays named debt.

**E6 (the derived name).** `Bern :: Carrier Int -> StdName '[Double]
(B Int)`, carrier as opaque payload, rendered
`"('call', 'bern', ...)"`, priced log2 10 + log2 5 + param.

**E7 (executed-path doctrine).** `applyStd (Bern car) = bernFast car`
— the reference arithmetic verbatim, exported from Eval so
Enumerate's `emit` is THE SAME FORM
(`kernel thetaSpace (carrierSpace obsCarrier) (bernFast obsCarrier)`;
the parity-phase `bernBelief` is deleted, not shadowed). The generic
family is `evalx`'s ExpFam case: weights exp(η·T(y)) normalized over
the carrier's points through `fromBits` (the log-partition absorbed
by the one prior source's normalization). The expansion contract is
oracle group 5 (fast form at θ vs generic at logit θ, ≤ 1e-9
relative, the frozen CL-4 tolerance shape).

**E8 (T3, fast path deferred).** PropLang.Belief unchanged in every
byte; gate 2 never wavered. The fast path's semantic license landed
as oracle: group 6's sufficiency — REVISED at the Task-1 review after
the author's vacuity proof (on a binary carrier, equal (n, ΣT) forces
a permutation, and order-invariance holds for every iid kernel). As
frozen, the license rests on the 3-point carrier: the deterministic
[0,2]-vs-[1,1] minimal pair and a randomized multiset-trade property
(one {0,2} traded for {1,1}), with the binary case kept and labeled
as the permutation case it is.

**E9 (ablation coupling).** Four flags, all rows increment-local with
three checks and attribution. As built, the coupling is LAYER ABSENCE
rather than the plan's EmptyCase sketch: under `DROP_EXPFAM` or
`DROP_CARRIER_OBS`, everything from `emit` down (walkKernel,
HypState, Agent, mkAgent, initHyp, stepHyp, predictive, observe,
agentMeta, agentModels, and their exports) does not exist — sentences
stay sayable and enumerable, but nothing can assign likelihood and no
agent can be built, which is interface.md §4's tightened claim at the
code level. `bernFast` survives `DROP_BERN` (the name is sugar;
capability survives its deletion) and dies with the basis. All of
src/ compiles under every flag.

**E10 (pre-freeze mechanics).** Worked as designed with one hole, per
§4 below: `cabal exec ghc` + the project package environment ran the
oracle red with zero cabal edits; the stanza landed in the freeze
commit from `stanza.cabal.draft`.

**E11 (manifest scope).** As exercised by the author: 33 entries —
test-expfam/ (7 files), interface.md, and design.md joined at
`658f07c`; the freeze delta was exactly 9 additions + the 3
pack-edited files re-hashed, all other 21 entries byte-unchanged.

**E12 (tolerances).** As frozen. One deviation ACCEPTED at review:
the emit-vs-name pin is 1e-12 relative, not the plan's `==` — the
public readout of emit's rows goes through `push`'s renormalization
while the name constructs directly ("the plan's error, correctly
caught"). Note for the record: that pin and the expansion/sufficiency
properties went green at Task 4, one task earlier than the plan's
split — `bernFast` and the parity `bernBelief` were already
float-identical paths, so the cross-path pin held before Task 5 made
the identity structural. No anchor is implicated.

## 4. Incidents and rulings on the record

- **Custody override (Task 2, `658f07c`).** The author overrode the
  in-person signing rule ("you do it all") after line-item oracle
  review; the commit message carries the custody note. The rule
  remains the default for future boundaries.
- **Re-open (`4c7b49d`, G).** The frozen oracle was compile-red under
  its own stanza: `total` at ExpFam.hs:165 shadowed
  Test.Tasty.QuickCheck's `total`, fatal under the stanza's
  `-Wall -Werror`. Root cause: the E10 runner compiled WITHOUT the
  stanza's warning flags, so the red run never proved
  stanza-compilability — both the builder's run and the author's
  review saw a clean compile. Fixed by an author-authorized, delegated
  three-token rename (verified complete on a scratchpad copy before
  the frozen file was touched; red/green split unchanged).
  **Process correction for future increments: the out-of-cabal red
  runner must carry the stanza's exact ghc-options.**
- **Fixture-utterance ruling (combined principle).** A fixture utters
  the deleted item's home surface and nothing else operational
  (type-only sealed nouns OK; a declaration row utters the
  declaration's home module — UseObsCarrier/Enumerate approved).
- **Pack §3 placement.** The pack addressed the T1 cross-reference to
  "typed-port-spec.md §4"; it sits at the end of §4 as addressed. If
  §3 or §5 was intended, relocation is a one-line author edit at the
  next freeze boundary.
- **Group-6 revision (`8ca269c`, pre-freeze).** The author's vacuity
  proof; revised before the oracle became binding — the process
  working as designed.

## 5. Reviewer verification (run yourself; the builder's word is not load-bearing)

```
sha256sum -c MANIFEST.sha256                        # 33/33 OK
export PATH="$HOME/.ghcup/bin:$PATH"
sh audit/run-gates.sh --phase 2; echo $?            # gates 1-7 PASS, exit 0
cabal test all                                      # 4/4, 3/3, 15/15, 22/22
git log --format='%G? %h %s' -- MANIFEST.sha256     # exactly d03bb10 db34a9a b1c8e00 658f07c 4c7b49d, all G
git diff --name-only 658f07c..HEAD -- test test-hygiene audit CLAUDE.md \
    proplang.py tests_acceptance.py test_output.txt typed-port-spec.md \
    interface.md design.md proplang.cabal cabal.project.freeze     # empty
git diff 658f07c..HEAD -- test-expfam               # exactly the 4c7b49d rename, nothing else
sh test-expfam/ablation.sh all; echo $?             # four rows, exit 0
```

Personal eyeballs (mechanically unchecked): the two signed commits'
custody notes (`658f07c`, `4c7b49d`) against your own recollection of
what you authorized; `emit` vs `bernFast` (one arithmetic — the form
is imported, not duplicated); the spec's production table against the
implemented `bits` constants; and the §4 pack-placement note above.
