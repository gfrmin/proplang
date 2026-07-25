# Ladder Increment Report (step-6 increment 4)

Built to interface.md §6 (as amended at this increment's freeze) and
§7(5), acceptance test F, under typed-port-spec.md as amended (the
sealed-variant lesson, §5), per the CLAUDE.md increment protocol — the
first increment run end-to-end under the truthful-delegation custody
amendment, and the first whose freeze carried an amendment to a frozen
oracle file (the expfam price pin). This is the as-built record
against LADDER_PLAN.md's register; the increment ends when the author
runs the reviewer verification block at the bottom.

Commit chain: `5faa212` Task 0 (plan + readings measured) → `21702c1`
Task 1 (oracle runtime-red 9/20; the sealed-sort discovery) →
`c688782` pack → `7126750` pack rulings + freeze dry run → `75f730e`
Task 2 freeze applied (seven edits, manifest 49/49) →
**ladder-freeze tag** (builder-signed on the recorded fresh
delegation) → `033b4ee` Tasks 3+4 (the worker; all 20 green).

## 1. Gate matrix at completion

`env -i PATH HOME LC_ALL=C.UTF-8 sh audit/run-gates.sh --phase 2` →
all seven gates PASS, exit 0. Gate 5 now runs six suites: acceptance
4/4, properties 3/3, hygiene 15/15, expfam 22/22 (under the amended
pin), membrane 31/31, **ladder 20/20**. Manifest 49/49. All FOUR
increment ablation runners green with attribution. All of src/
compiles under each of the TWELVE ablation flags (11 inherited +
DROP_LADDER). Frozen-surface diff since the ladder-freeze tag: empty
(one file, src/PropLang/Eval.hs, changed post-tag — implementation
surface only). Working tree clean.

## 2. Margin readout (same scratchpad program, FIFTH digit-for-digit run)

| quantity | value |
|---|---|
| t4 full-grammar log-loss delta | 7.105e-14 |
| t4 frozen-agent log-loss delta | 5.684e-14 |
| t3 agent log-loss, drift400 | 0.0 |
| t3 agent log-loss, flat400 | 1.137e-13 |
| t1 MAP posterior delta | 1.665e-15 |
| t1 / t3 MAP renders | byte-identical |

The increment rewired `vThink` itself (now the depth-1 face of the one
worker, `vThinkAt`) and flipped `stdB` from lg 5 to lg 6, and no
frozen anchor moved by an ulp: the fold is line-for-line the frozen
arithmetic at depth 1, and no frozen dl pin contains stdB except the
one the author amended (§4, incident 2).

Beyond the inherited anchors, the load-bearing new result is test F,
both directions, as CHOSEN behavior: the frozen t2Rows (imported, not
transcribed) reproduce through the ladder with the myopic rung chosen
at 0.3 and 0.05 ([1], [1,1,1]) and depth bought where fidelity is
cheap ([3,3,3,3] at 0.005 and 0 — twelve thinking ticks and act L
either way); and in the adversarial world (myopic VoI exactly zero by
construction), fixed myopia acts immediately into the stakes' wrong
side (net −0.8) while the ladder buys one depth-3 rung, flips to L,
and nets +0.797/+0.7985 at prices 0.001/0.0005 — design.md §7's
recorded bias, measured and closed. The clock residue now stands at
its proven minimum: the induction base (Est_0 used as-is) is the one
thing the ladder cannot price away, and the DROP_LADDER row states it
as a compile fact.

## 3. As-built answers (L1–L12 highlights)

**L1 (reading c, with the riders).** A rung is an option with
DECLARED TERMINATION — one choice committing k batches over k real
ticks; Est_k = E_batch[Est_{k−1}] − price, grounded at Est_0 = act
now. Est_1 IS the frozen VThink (== pinned, fixed + property);
shallow-first menu order is CL-3 at the menu. Interface.md's test-F
sentence was amended at the freeze (rider 2) to say what the sim
proved: behavior pins at all four price points, the myopic rung where
the clock bites, depth bought only where fidelity is cheap.

**L2 as landed (the sealed sort — pack §0, approved).** The ruled
ThinkK-in-InternalAct was compile-impossible: the frozen membrane
oracle's exhaustive matches seal `InternalAct` and `Choice` under
-Werror. The rung is its own sort — `Rung` exported TYPE-ONLY
(constructor private: off-grid rungs unconstructible, a door stronger
than the mkC pattern trick), `baseRung` depth 1 with one spelling,
`mkRung` accepting integral grid points ≥ 2 only, `ladderRungs`
shallow-first. The lesson is now spec text (§5, author's sentence);
the −1 echo for deeper rungs is dormant doctrine for the
driver-wiring increment.

**L3/T2 (the alphabet change).** STDNAME 5 → 6 (VThinkK), stdB
lg 5 → lg 6; the author amended the ONE stdB-bearing frozen literal
(and its test name) in the same freeze commit. The full-battery
one-expected-failure run — four suites green, expfam failing on
exactly that pin against the drafted surface — is now the recorded
standard form of alphabet-change completeness.

**L4 (the sequencing).** The sayable surface rode the
compile-fixture inversion: sayable.sh red on exactly the missing
constructor through the oracle phase (every frozen suite green on
every tree state), the member + amendment landing together in the
freeze commit, the row turning fully green when the worker landed.
The fixture's episode is driven each tick by evalx of ONE first-order
policy sentence (argmax over the published options, nested IsEq
dispatch, depths as typed env values, price via Get "price") — the
reflexive-closure doctrine held: the ladder's choices are sayable.

**L5–L7.** Firing depth k consumes k batches over k real ticks, then
re-decides; rung availability capped by the remaining buffer. The
F-world's tilt arrives as DECLARED PRE-EPISODE HISTORY folded through
cond by the host (L6 as corrected — uniform/point/fromBits stay the
only prior sources). Depth prices at the menu's grid (log2-grid C-node
pins + monotonicity); depth args in sentences ride the env, the
frozen batchN precedent.

**L8 (what cannot be deleted).** DROP_LADDER removes the rung sort,
the door, the menu, the verb, and the exported worker; src compiles
whole; the fixture dies naming the surface. What survives is exactly
fixed myopia — §6's honest minimum as the row's attribution.

**L11 (pin provenance).** Every frozen quantity is IMPORTED
(Anchors.t2Rows, Streams.buffer36); rung sequences and F-world nets
are declared intended-behavior pins from the Task-0 sim, margins in
the pack; the b7f120e standard held with nothing to re-open.

## 4. Incidents and rulings on the record

1. **The sealed-variant discovery (pack §0).** M9's reserved
   "additive constructor" met the membrane oracle's frozen exhaustive
   match: -Werror incomplete-patterns makes every constructor
   addition an edit to frozen surface. Caught at Task 1 by
   compile-proof BEFORE the oracle was authored against the doomed
   shape; resolved by composition (the sealed sort); approved by pack
   ruling; canonized as the author's spec §5 sentence at the freeze.
2. **First amendment of a frozen ORACLE file.** test-expfam's Bern
   price pin (literal AND test name, as ruled) — drafted in the pack,
   proven by the one-expected-failure battery run, applied in the
   freeze commit, covered by the re-signed manifest. Frozen texts
   changed only at the boundary, only on the author's ruling.
3. **The fixture caught a real bug pre-freeze.** Proving the sayable
   fixture against the drafted surface (rather than trusting its
   compile-failure) exposed an index error — Argmax's options
   argument evaluates in the OUTER environment, the frozen
   policyThink shape — fixed at Task 1, before the freeze sealed it.
   The proof habit (type-check red fixtures against the drafted
   future surface) is a candidate lesson for the next boundary.
4. **Custody: the second delegated tag, first under the amendment.**
   The author filled the pack's custody slot with option B; the
   truthful-delegation amendment landed in the freeze commit
   (CLAUDE.md edit 4) and the tag records the delegation verbatim,
   read as a per-instance grant for that tag only. The builder's
   reading of the filled slot AS the grant is stated in the tag
   message for the author's review.
5. **One slot arrived empty.** The pack rulings referenced edit (7)'s
   author text as provided when it had not arrived; the builder
   stopped, reported both open slots, and staged a dry run instead of
   proceeding — the freeze ran only after the author supplied the
   sentence and the custody choice.
6. **Tasks 3 and 4 merged (declared).** The loops and worlds were all
   oracle-side at Task 1; the worker alone turned every group green
   on its first landing (`033b4ee`).

## 5. Reviewer verification (run yourself; the builder's word is not load-bearing)

```
export PATH="$HOME/.ghcup/bin:$PATH"
sha256sum -c MANIFEST.sha256                        # 49/49 OK
env -i PATH="$PATH" HOME="$HOME" LC_ALL=C.UTF-8 \
    sh audit/run-gates.sh --phase 2; echo $?        # gates 1-7 PASS, exit 0
cabal test all                                      # 4/4, 3/3, 15/15, 22/22, 31/31, 20/20
git tag -v ladder-freeze                            # Good signature, BUILDER key; read the delegation record
git log --format='%G? %GF %h %s' -- MANIFEST.sha256 # exactly 8: d03bb10 db34a9a b1c8e00 658f07c 4c7b49d (author key), fd70162 b7f120e 75f730e (builder key)
git diff --name-only ladder-freeze..HEAD -- test test-hygiene \
    test-expfam test-membrane test-ladder audit CLAUDE.md proplang.py \
    tests_acceptance.py test_output.txt typed-port-spec.md interface.md \
    design.md proplang.cabal cabal.project.freeze   # empty
sh test-ladder/ablation.sh all; echo $?             # ladder row, four checks, exit 0
sh test-ladder/sayable.sh; echo $?                  # compiles AND all four checks pass, exit 0
grep -rn "lg 5" test-expfam/                        # nothing
```

Personal eyeballs (mechanically unchecked): the ladder-freeze tag's
custody record against your own words (the filled slot as the
per-instance grant — reject the reading and the tag is remade from
your shell); your three verbatim texts as landed (CLAUDE.md custody
amendment + porting-order + ASCII line; interface.md F; spec §5
sealed-variant sentence); `vThink = vThinkAt 1` and `vThinkK =
vThinkAt` in src/PropLang/Eval.hs (the E7 doctrine, one arithmetic);
and the g2/g3 rung-sequence pins against the pack §3 sim tables they
were authored from.
