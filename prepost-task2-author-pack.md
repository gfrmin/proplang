# Prepost Task 2 — author freeze pack (step-6 increment 5)

Builder-prepared worksheet for the `prepost-freeze` boundary. Oracle
state at `2bf6c72`: test-prepost/ runtime-red 9/15 under the stanza's
exact flags; all six suites green on the real tree; gates 7/7 PASS;
manifest 49/49. Nothing frozen has been touched. Custody per the
amended paragraph, as you ruled at Task 0: the freeze binds on your
`prepost-freeze` tag — your shell, or fresh per-instance delegation
recorded verbatim in the tag message.

No open ruling requests this boundary: P1–P12 were ruled at Task 0
(including the P12 author text, in hand), and Task 1 surfaced no
ruling-vs-frozen collision. One methodological finding for the record
(§2, the battery blind spot) folds into the standard form.

## 1. The freeze commit, enumerated (six edits)

**(1) src: STDNAME's seventh member** — drafted and PROVEN in scratch
(fixture typechecks with 0 errors against it; battery evidence in
§2). Four hunks:

- `Syntax.hs`, after the VThinkK block, guarded `#ifndef DROP_VPRE`:

```haskell
  -- the action-dependent preposterior (increment 5, PREPOSTERIOR_PLAN
  -- P1/P4 as ruled): a REPORTED alphabet change, STDNAME grows 6 -> 7
  -- (stdB moves lg 6 -> lg 7; the author's two frozen price-pin
  -- amendments accompany this member in the same freeze commit).
  -- Contract: @VPre d b ch ys uD ds u acts n price@ is W_d - W_0 the
  -- frozen leaf (vAct over the terminal menu, the induction base),
  -- W_j the best interior decision's immediate prevision plus the
  -- continuation through ITS OWN channel, price outside the max. The
  -- frozen VThink chain is the mute-singleton degenerate case (the
  -- oracle pins == at the verb layer). Dies with DROP_VPRE; the
  -- myopic base and the fidelity ladder survive.
  VPre :: Eq y => StdName '[Int, B h, Chan d h y, [y], Util d h, NonEmpty d, Util a h, NonEmpty a, Int, Double] Double
```

- `Syntax.hs`: `stdB = logBase 2 6` becomes `logBase 2 7`
  (unconditional, the counting convention), production-table comment
  "six STDNAME members" -> "seven".
- `Eval.hs`: `applyStd VPre (d :. b :. ch :. ys :. uD :. ds :. u :.
  acts :. n :. price :. VNil) = vPre d b ch ys uD ds u acts n price`,
  same guard.
- `Enumerate.hs`: `stdNameStr VPre = "VPre"`, same guard.

**(2) test-expfam/ExpFam.hs — your frozen amendment, second visit:**
line 140's literal `lg 6 -> lg 7` AND the test name "choice of 6" ->
"of 7" (the ruled test-name form).

**(3) test-ladder/fixture/Sayable.hs — your frozen amendment, first
visit for this file:** line 205's literal `lg 6 -> lg 7`, the header
comment's "six-member alphabet" (line 11) -> "seven-member", and
test-ladder/sayable.sh line 9's "price pin under lg 6" -> "lg 7"
(the two stale comment lines, P6 as ruled).

**(4) proplang.cabal** — the prepost stanza, verbatim from
`test-prepost/stanza.cabal.draft`.

**(5) CLAUDE.md — your P12 sentence, verbatim, appended after the
pin-provenance sentence in increment-protocol item 2:**

> "A compile-red fixture is proven type-correct against the drafted
> future surface before the freeze seals it — its red must be
> demonstrated to be the missing constructor, not assumed (the
> ladder's Argmax-environment bug, caught by exactly this proof)."

**(6) MANIFEST.sha256** — extended and re-signed, applied LAST.
Same command with `test-prepost` joining the find. Expected: **56
entries** (49 + 7 test-prepost files), with re-hashes of
proplang.cabal, CLAUDE.md, test-expfam/ExpFam.hs,
test-ladder/fixture/Sayable.hs, and test-ladder/sayable.sh.

## 2. Alphabet-change completeness (the standard form, plus a clause)

Census (run at plan and re-verified at Task 1): stdB appears in
exactly TWO frozen assertion literals — ExpFam.hs:140 and
Sayable.hs:205 — plus the two stale comment lines in (3). Increment
6 will carry three (P5's bounded forward ruling: the roadmap
terminates there; any extension makes a single-site frozen alphabet
constant a mandatory boundary item).

The standard-form battery against the drafted seven-member surface:

| suite | vs drafted surface |
|---|---|
| acceptance | GREEN (4/4) |
| properties | GREEN (3/3) |
| hygiene | GREEN (15/15) |
| membrane | GREEN (31/31) |
| expfam | **1/22 FAIL** — exactly the Bern price pin |
| ladder | GREEN — but see the clause below |

**The blind-spot clause (new, joins the standard form):** shellRow
rows recompile their fixtures from the WORKING TREE, so a battery run
against a scratch draft cannot see them move. The frozen ladder
fixture was therefore re-run DIRECTLY against the draft: it fails on
exactly the census line — "FAIL price: Call VThinkK = node + lg 6 +
eight Var mentions", all its other checks green. Completeness holds:
two literals, both enumerated in (2)-(3), nothing else moves. Future
completeness runs must re-run script-recompiled frozen fixtures
directly against the draft.

The new fixture (SayableP.hs) against the draft, per the canonized
habit: typechecks with 0 errors (its red is exactly the missing
constructor); runs with the expected pre-Task-3 set — price pin GREEN
under lg 7, verb==worker GREEN (stub == stub), degenerate-verb-vs-
VThinkK and the sentence-driven decisions RED until the worker lands.

## 3. The Task-0 sim tables (recap; discriminating power only)

b0 = uniform folded through declared history [1] by the host:
E[2θ−1] = 0.266667, uninformed act R. VoI(probe) = 0.070400; the
noise channel's conditioning no-op measured at 1.665e-16.

| world | s | value(safe) | value(probe) | chooses | margin |
|---|---|---|---|---|---|
| W | 0.05 | 0.306667 | 0.327067 | **probe** | 0.020400 |
| W | 0.40 | 0.656667 | 0.327067 | **safe** | 0.329600 |
| W0 | 0.05 | 0.306667 | 0.256667 | **safe** | 0.050000 (= s, analytic) |

Realized (true theta 0.1, zeros): W — anticipating +0.78 vs myopic
−0.77; W0 — safe −0.77 vs forced probe −0.82 (loses exactly the
sacrifice). Degeneracy spot-check: sim recursion at const-k vs the
real exported vThinkK: 0.0e0 at all six depth/price points.

## 4. The oracle at a glance (frozen at your signature)

15 tests, 6 groups, ASCII names. Pins: value pins asserted against
FROZEN-VERB COMPOSITIONS at 1e-12 (safe = s + noise-continuation − p
where the continuation IS vThinkK at price 0), never transcribed
decimals; choices and nets are Task-1 intended-behavior pins; the
degeneracy identity pinned with == (fixed cases, depths 1–3, plus a
QuickCheck property over prefixes and prices). Red/green enumerated
in the suite header (9 red / 6 green, one stub-accidental named).
Scope limits in the header: depth-1 worlds; no driver wiring; the
sayable surface behind the fixture row.

## 5. Freeze-sequence checklist (run in order)

```
git log --format='%G? %GF %h %s' -2          # 2bf6c72, 04638df builder-key G
sha256sum -c MANIFEST.sha256                 # 49/49 (pre-freeze state)
sh test-prepost/red-run.sh                   # 9/15 red, compiles under exact flags
cabal test all                               # six suites green
# review pack sections 1-4; builder applies the six edits as ONE freeze commit
sha256sum -c MANIFEST.sha256                 # 56/56 on the freeze commit
cabal test all                               # five frozen suites + ladder GREEN
                                             # (expfam and ladder green under the amended pins
                                             #  + the lg-7 surface); prepost present, RED in its
                                             #  Task-1 subset minus sayable-compile
grep -rn "lg 6" test-expfam/ test-ladder/    # no stale assertion literal (comments amended)
git tag -s prepost-freeze <freeze-commit>    # YOUR shell — or fresh per-instance delegation,
                                             # recorded verbatim in the tag message
```

From the tag, test-prepost/ and the amended frozen files are as
frozen as test/. Then Task 3 (vPreAt lands, vThinkAt re-based — the
identity becomes definition), Task 4 (ablation + report + the sixth
margin run), each builder-signed, stop-and-report on any
pinned-anchor movement.
