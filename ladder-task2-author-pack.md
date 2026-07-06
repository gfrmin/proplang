# Ladder Task 2 — author freeze pack (step-6 increment 4)

Builder-prepared worksheet for the `ladder-freeze` boundary. Oracle
state at `21702c1`: test-ladder/ runtime-red 9/20 under the stanza's
exact flags; all five frozen suites green; gates 7/7 PASS; manifest
42/42. Nothing frozen has been touched. The freeze binds when you
countersign the freeze commit with the `ladder-freeze` signed tag
(from your own shell, or by fresh per-instance delegation).

---

> **Pack rulings (author, 2026-07-06 — verbatim intent, binding):**
> - **Section 0 APPROVED** — the sealed-sort placement is a
>   compile-forced resolution, not the T2 dodge; L2's doctrine
>   survives by composition; the -1 echo is dormant doctrine for the
>   driver-wiring increment.
> - **Edit (7) ADDED**: one sentence to typed-port-spec section 5
>   (author text) recording the sealed-variant lesson. *Text did not
>   arrive with the ruling — AWAITING AUTHOR SENTENCE.*
> - **Section 1(2)**: amend the literal AND the test name.
> - **Sections 1(4), 1(5)**: approved as drafted.
> - **Section 2's full-battery one-expected-failure run is recorded
>   as the standard form of alphabet-change completeness.**
> - **Custody: UNFILLED** — the ruling's own bracket ("I will tag
>   from my own shell; paragraph stands" vs "truthful-delegation
>   amendment in edit (4); tag by fresh delegation") is marked
>   "author fills this in at the freeze."
> - With the slots filled: run the section-5 sequence; the freeze
>   commit carries seven edits; expected 49/49.

> **Dry run (builder, post-rulings — the freeze application is
> mechanical once the two slots arrive):** all seven edits applied to
> a scratch copy (edit (7) as a marked placeholder); manifest
> regenerates at 49 entries, 49/49 verify; the five frozen suites
> compile under the stanza flags and run GREEN against the applied
> state (expfam 22/22 under the amended pin and the lg-6 surface);
> the ladder suite holds its 9/20 red set with the sayable row's
> failure moving from compile-stage to run-stage as designed (fixture
> compiles; price pin and worker-identity checks green; verb-vs-VThink
> and the sentence-driven episode red until Task 3).

## 0. ITEM FOR EXPLICIT RULING — the sealed-sort deviation from L2

Your L2 ruling approved the rung as an additive `ThinkK` constructor
on `InternalAct`. That placement is **unimplementable without editing
frozen surface**: the frozen membrane oracle matches `InternalAct`
exhaustively and compiles under the stanza's `-Werror`. Compile-proof
(scratch copy of src with a constructor added, nothing else changed):

```
test-membrane/Membrane.hs:172:17: error: [GHC-62161]
    [-Wincomplete-patterns, Werror=incomplete-patterns]
    Pattern match(es) are non-exhaustive
    In a case alternative:
        Patterns of type 'Choice' not matched:
            InternalFired (ThinkKProof _)
172 | choiceName1 c = case c of
```

(src's own `lastActionCode` trips first but is editable; `choiceName1`
is frozen.) The membrane freeze thus sealed `InternalAct` and `Choice`
against extension **as a compile fact** — the type system defending
the frozen oracle, discovered at this increment's Task 1.

**Resolution as built** (Task 1, `21702c1`): the rung is its own sort
in `PropLang.Membrane` — `Rung` exported TYPE-ONLY (constructor
private: off-grid rungs unconstructible, a door stronger than the mkC
pattern trick), `baseRung` = depth 1 with its one spelling, `mkRung ::
Grid -> Ix -> Maybe Rung` accepting only integral grid points >= 2,
`ladderRungs` shallow-first (CL-3 at the menu, per your L1 rider).
`InternalAct`, `Choice`, `internalMenu`, and every frozen membrane pin
are untouched by construction. Consequences: rungs do not flow through
the membrane driver this increment (consistent with L4 as ruled); the
ruled "-1 echo for deeper rungs" becomes dormant doctrine, recorded
here for the increment that wires rungs into the driver.

**Approve the sealed-sort placement, or re-open L2.** Everything else
in this pack assumes it.

## 1. The freeze commit, enumerated (L12 as ruled, six edits)

The freeze commit (builder-signed, author-tagged) applies exactly:

**(1) src: STDNAME's sixth member** — drafted and PROVEN in scratch
(fixture typechecks; battery evidence in §2). Four hunks:

- `Syntax.hs`, after the `VThink` member, guarded `#ifndef DROP_LADDER`:

```haskell
  -- the fidelity ladder's rung valuation (increment 4, LADDER_PLAN L1
  -- reading c / L3 as ruled): a REPORTED alphabet change, STDNAME
  -- grows 5 -> 6 (stdB moves lg 5 -> lg 6; the author's one-literal
  -- amendment of the frozen expfam price pin accompanies this member
  -- in the same freeze commit). Contract: @VThinkK d b k ys u acts n
  -- price@ is Est_d - Est_0 the value of acting now (the induction
  -- base), Est_k the next-batch preposterior of Est_{k-1} minus the
  -- tick's price - so depth 1 is exactly @VThink@ and depth k
  -- telescopes to the k-batch preposterior of acting minus k*price.
  -- Dies with the ladder (DROP_LADDER), never with the myopic base.
  VThinkK :: Eq y => StdName '[Int, B h, K h y, [y], Util a h, NonEmpty a, Int, Double] Double
```

- `Syntax.hs`: `stdB = logBase 2 5` becomes `logBase 2 6` (the literal
  is unconditional — stdB counts written alternatives regardless of
  ablation flags, the Bern precedent), with the production-table
  comment's "five STDNAME members" updated to six.
- `Eval.hs`, after the `VThink` equation, same guard:
  `applyStd VThinkK (d :. b :. k :. ys :. u :. acts :. n :. price :. VNil)
  = vThinkK d b k ys u acts n price`.
- `Enumerate.hs`, after `stdNameStr VThink`, same guard:
  `stdNameStr VThinkK = "VThinkK"` (the renderer's exhaustive match —
  found by the scratch battery, src-side, no frozen render involves it).

**(2) test-expfam/ExpFam.hs:140 — your one-literal frozen amendment:**
`(lg 10 + lg 5 + (lg 10 + lg 4))` becomes `(lg 10 + lg 6 + (lg 10 +
lg 4))`. The test NAME on line 137 says "stdname choice of 5" — I
propose amending it to "of 6" in the same edit so the frozen text does
not state a falsehood; your call, flag if you prefer the literal only.

**(3) proplang.cabal** — the ladder stanza, verbatim from
`test-ladder/stanza.cabal.draft` (no exposed-module change).

**(4) CLAUDE.md — your text.** The porting-order line naming
increments 5–6 (the ROADMAP commitment), and the ASCII-only
canonization. Proposals you may rewrite freely:
- porting order item 6, appended: ", then action-dependence in
  vThink's preposterior (increment 5) and utility-as-latent under the
  discrete reading (increment 6, CIRL)."
- increment protocol, appended sentence: "Increment-oracle test names
  are ASCII-only (the membrane's locale incident, 2026-07-05)."

**(5) interface.md — your test-F amendment** (L1 rider 2: amended, not
strained). The measured fact it must absorb: no honest reading gives
the myopic rung at all four price points — at 0.005/0 the deeper rung
values strictly dominate (fidelity is cheap there and the ladder
buys it; forcing myopia would need a tuned non-price penalty), while
ticks, acts, and batch order reproduce everywhere. Proposal:

> **F. Ladder honesty.** With the fidelity ladder enabled, re-run the
> lazy-genius world: at test 2's price points the tick counts and
> final acts must reproduce (1/3/12/12), with the myopic rung chosen
> wherever the clock bites and deeper rungs bought only where fidelity
> is cheap — behavior identical either way; at prices near zero with
> an adversarial buffer, the agent must sometimes *buy* a deeper
> estimate and outperform the fixed-myopia agent — the estimator
> choice earning its keep by evidence, like everything else here.

**(7) typed-port-spec.md section 5 — your one sentence** recording the
sealed-variant lesson (added by pack ruling; text awaited).

**(6) MANIFEST.sha256** — extended and re-signed, applied LAST (after
edits 1–5 and 7). Command (test-ladder joins the find; everything else
unchanged):

```
{ find test test-hygiene test-expfam test-membrane test-ladder audit -type f; \
  echo CLAUDE.md; echo proplang.py; echo tests_acceptance.py; \
  echo test_output.txt; echo typed-port-spec.md; echo interface.md; \
  echo design.md; echo proplang.cabal; echo cabal.project.freeze; } \
  | sort | xargs sha256sum > MANIFEST.sha256
```

Expected: **49 entries** (42 + 7 test-ladder files), with re-hashes of
proplang.cabal, CLAUDE.md, interface.md, typed-port-spec.md, and
test-expfam/ExpFam.hs. Verified by the dry run.

## 2. One-pin completeness (your ruled checklist item), verified

The claim: STDNAME growth moves exactly one frozen literal. Two
sweeps, both clean:

```
grep -rn "lg 5\|lg 4\|logBase 2 5\|logBase 2 4" test/ test-hygiene/ test-expfam/ test-membrane/
  -> every hit except ExpFam.hs:140 is a GRID-size pin (lg 10 + lg 4
     = node + four-point grid), stdB-independent
grep -rn -B2 -A2 "assertBits\|bits (Call" <frozen suites> | grep -i call
  -> exactly one Call-price pin: ExpFam.hs:139-141
```

And the decisive test — the FULL frozen battery compiled and run
against the drafted six-member surface (scratch src, nothing else):

| frozen suite | vs drafted surface |
|---|---|
| acceptance | GREEN (4/4) |
| properties | GREEN (3/3) |
| hygiene | GREEN (15/15) |
| membrane | GREEN (31/31) |
| expfam | **1 out of 22 failed** — exactly "Call (Bern _) prices node + stdname choice of 5 + param" |

No model-fragment anchor can move: the enumerator's dl trees never
touch stdB (t1/t3/membrane anchors are enumerator-priced).

## 3. The Task-0 sim tables (discriminating power; pins never from here)

Direction 1 — test 2's world, four frozen price points, three readings
(the real frozen verbs via `evalx (Call ...)`, frozen buffer36):

| reading | 0.3 | 0.05 | 0.005 | 0.0 |
|---|---|---|---|---|
| (b') recursive-max, virtual ticks | 1/L [1] | 3/L [1,1,1] | 12/L deep | 12/L deep |
| (b'') recursive-max, physical ticks | 1/L [1] | 3/L [1,1,1] | **31 BREAK** | **36 BREAK** |
| (c) macro-act commitment (RULED) | 1/L [1] | 3/L [1,1,1] | 12/L [3,3,3,3] | 12/L [3,3,3,3] |

Rung menu values at t=0 (uniform prior): at p=0.3 the recursive family
ties EXACTLY (every continuation stops; the k=2 arithmetic collapses
into k=1's) — CL-3's shallow-first tie-break earning its keep; at
p=0.005/0 deeper rungs strictly dominate (0.332 / 0.356 / 0.375 at
0.005) — the measured fact behind the F amendment. The fragile stop
decision at p=0.05 after three batches holds with margin: act 0.0909
vs think1 0.0759, think2 0.0398, think3 -0.0102.

Direction 2 — F-world (history [1,1,1,1] folded through cond by the
host per your L6 correction; twelve zeros; true theta 0.1):
prior E[2th-1] = 0.576013 = vAct; myopic VoI at p=0 measured at
-1.11e-16 (float dust — the oracle runs direction 2 at positive
prices only, your margins standard):

| price | myopic | ladder (c) | net myopic | net ladder |
|---|---|---|---|---|
| 0.005 | 0 ticks, R | no buy: 0, R | -0.8000 | -0.8000 |
| 0.001 | 0 ticks, R | buys [3]: 3, L | -0.8000 | **+0.7970** |
| 0.0005 | 0 ticks, R | buys [3]: 3, L | -0.8000 | **+0.7985** |

design.md section 7's recorded bias ("myopic VoI is zero whenever no
next-batch outcome can flip the decision... deeper lookahead would
sometimes disagree"), made flesh and measured.

## 4. The oracle at a glance (frozen at your signature)

20 tests, 6 groups, ASCII names. Pin provenance: tick counts and acts
IMPORTED from frozen `Anchors.t2Rows` (the stanza reads test/
directly); rung sequences and F-world nets are new-world
intended-behavior pins from the Task-0 sim (provenance comments at
each site). Scope limits recorded in the suite header: whole-batch
buffers; rungs not in the membrane driver; the sayable surface behind
the compile-fixture row.

Red at Task 1 (9): worker-verb identities (fixed + property),
degenerate-ladder, direction-1 behavior x3, direction-2 buy + net,
sayable. Green-from-start (11): frozen-verb-only rows (the myopic
reference against t2Rows; VoI-zero; myopic-wrong), real data plumbing
(door, C-node prices, menu order), ablation + audit rows, and three
STUB-ACCIDENTAL greens called out honestly: dear-clock no-buy,
termination bound, grid-extension — each becomes load-bearing only
once the worker is real (Task 3).

The sayable fixture (test-ladder/fixture/Sayable.hs) is red on exactly
`VThinkK` not in scope, and was proven type-correct against the
drafted surface (it caught one real bug pre-freeze: Argmax's options
argument indexes the OUTER environment — the frozen policyThink shape —
fixed at Task 1). Against the draft it runs price-pin GREEN, worker
identity GREEN (stub == stub), verb-vs-VThink RED until Task 3 — the
expected post-freeze red set.

## 5. Freeze-sequence checklist (run in order)

```
git log --format='%G? %GF %h %s' -3          # 21702c1 builder-key G
sha256sum -c MANIFEST.sha256                 # 42/42 (pre-freeze state)
sh test-ladder/red-run.sh                    # 9/20 red, compiles under exact flags
cabal test all                               # five frozen suites green
# review pack sections 0-4; rule on section 0; finalize your texts (4),(5)
# builder applies the six edits as ONE freeze commit (builder-signed)
sha256sum -c MANIFEST.sha256                 # 49/49 on the freeze commit
cabal test all                               # acceptance/properties/hygiene/expfam/membrane GREEN
                                             # (expfam green under the amended pin + lg-6 surface);
                                             # ladder present and RED in its Task-1 subset minus sayable-compile
grep -rn "lg 5" test-expfam/                 # no stale literal
git tag -s ladder-freeze <freeze-commit>     # YOUR key, YOUR shell — the attestation
```

From the tag, test-ladder/ and the amended frozen texts are as frozen
as test/. Then Tasks 3-5 (worker arithmetic; anchors; report), each
builder-signed, stop-and-report on any pinned-anchor movement.
