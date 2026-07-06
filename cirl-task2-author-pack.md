# CIRL Task 2 — author freeze pack (step-6 increment 6, the last)

Builder-prepared worksheet for the `cirl-freeze` boundary. Oracle
state at `52da285`: test-cirl/ runtime-red 2/17 under the stanza's
exact flags (both reds by compile failure, both errors naming the
missing USay); all seven suites green on the real tree; manifest
56/56. Nothing frozen has been touched. Custody per the amended
paragraph: the freeze binds on your `cirl-freeze` tag — your shell,
or fresh per-instance delegation recorded verbatim in the tag
message.

No open ruling requests this boundary: C1–C12 were ruled at Task 0
(both author texts in hand, verbatim below), and Task 1 surfaced no
ruling-vs-frozen collision. One sequencing note for the record (§1,
the compile-forced split) — it follows the prepost precedent and the
plan's approved shape, stated here precisely.

## 1. The freeze commit, enumerated (five edits)

**The compile-forced split, stated plainly:** the USay constructor
cannot land without ALL THREE of its src cases — bits, evalx, and
renderExpr each match Expr exhaustively under `-Werror
-Wincomplete-patterns`, so a caseless constructor is a compile
failure, not an option. The split therefore mirrors prepost exactly:
the freeze lands the ALPHABET FACT whole — constructor, REAL bits
case (the pricing), REAL renderExpr case (trivial), and a STUB evalx
case (the mute utility) — and Task 3 replaces the stub with the
definitional one-liner, turning the fixture's bridge and episode rows
green. The fixture's measured freeze-state set (§3) documents exactly
this shape.

**(1) src: the pointer's door** — drafted and PROVEN in scratch
(fixture typechecks 0 errors and runs all-green against the full
draft; the whole battery is green against it; §2). Six hunks across
three files, all guarded `#ifndef DROP_USAY` (the FOURTEENTH flag):

- `Syntax.hs`, the Expr export list, after the ExpFam guard block:

```haskell
#ifndef DROP_USAY
        , USay
#endif
```

- `Syntax.hs`, the GADT, after the ExpFam block:

```haskell
#ifndef DROP_USAY
  -- the pointer's door (increment 6, CIRL_PLAN C3 as ruled): the
  -- priced utility. A NEW SORT (UTIL, spec section 3 table row at this
  -- increment's freeze): USay is the sole codeword at declared
  -- utility-valued holes (the ExpFam maneuver — outside EXPR's ten
  -- written alternatives, 0 constructor bits), its payload priced as
  -- EXPR in its own two-variable scope. Env convention as ruled:
  -- Var Z is the option code, Var (S Z) the latent parameter. The
  -- subprogram is CLOSED — evaluation discards the outer environment —
  -- so utilities are featureless and clockless as a definition-level
  -- fact ('Get' inside a utility is dormant, per-node-priced syntax).
  -- Dies with DROP_USAY: delete the door and no sentence can hold a
  -- utility; the worlds, the verbs, and the opaque world-data face
  -- ('mkUtil') all survive.
  USay :: Expr '[Double, Double] Double -> Expr env (Util Double Double)
#endif
```

- `Syntax.hs`, the COMPLETE pragma: `USay,` in its own
  `#ifndef DROP_USAY` block before `Call`.
- `Syntax.hs`, `bitsAt`: `utilB` joins the price bindings
  (`utilB = logBase 2 1`, unguarded — the statsB precedent) and the
  case, before `Call`:

```haskell
#ifndef DROP_USAY
      -- UTIL-sort (spec section 3 as amended at the cirl freeze):
      -- sole-codeword constructor choice (0 bits); the payload prices
      -- as EXPR in its own closed two-variable scope
      USay p     -> utilB + go 2 p
#endif
```

- `Eval.hs`, `evalx`, before the Call case — the FREEZE STUB (the
  prepost split; Task 3 lands the definitional line):

```haskell
#ifndef DROP_USAY
  -- Task-2 freeze STUB (the prepost precedent): the alphabet fact
  -- (constructor + pricing) lands at the freeze; the definitional
  -- semantics land at Task 3. Returns the mute utility until then.
  USay _ -> mkUtil (\_ _ -> 0)
#endif
```

- `Enumerate.hs`, `renderExpr`:

```haskell
#ifndef DROP_USAY
  USay p     -> "('usay', " ++ renderExpr p ++ ")"
#endif
```

**(2) typed-port-spec.md §3 — AUTHOR TEXT 1, verbatim as ruled:**
the production table gains the row

```
| UTIL | USay | 0 bits |
```

and, after the KER hole sentence:

> "Utility-valued positions are declared UTIL holes (KER's sibling):
> USay is the sole codeword, its payload pricing as EXPR in a
> two-variable scope. The subprogram is closed by construction —
> evaluation discards the outer environment — so utilities are
> featureless and clockless as a definition-level fact, and Get
> inside a utility is dormant, per-node-priced syntax."

**(3) CLAUDE.md porting order — AUTHOR TEXT 2, verbatim as ruled,**
appended to the step-6 line:

> "Completed through increment 6 (the pointer). The roadmap
> terminates here; any further scope binds P5's single-site
> alphabet-constant clause and requires a new roadmap boundary."

**(4) proplang.cabal** — the cirl stanza, verbatim from
`test-cirl/stanza.cabal.draft`.

**(5) MANIFEST.sha256** — extended and re-signed, applied LAST. Same
command with `test-cirl` joining the find. Expected: **63 entries**
(56 + 7 test-cirl files), with re-hashes of typed-port-spec.md,
CLAUDE.md, and proplang.cabal.

**NO frozen assertion literal moves** — the empty census (§2), a
first, recorded with its full evidence.

## 2. Completeness: the empty census, all three instruments

- **Greps (plan-time, re-verified at Task 1):** stdB stays lg 7 (no
  new verb) — the four standing sites (ExpFam.hs:140, Sayable.hs:205,
  SayableP.hs:190, the spec §3 STDNAME row) do not move; EXPR's ten
  stay ten (USay is outside the written alternatives — the ExpFam
  precedent), so every frozen `lg 10` pin stands; FN stays two (its
  1-bit price lives in exactly Hygiene.hs:134 and :138, both
  untouched — a censused reason the UTIL sort, not FN growth, is the
  right door).
- **The full battery against the drafted surface:** acceptance 4/4,
  properties 3/3, hygiene 15/15, membrane 31/31, expfam 22/22,
  ladder 20/20, prepost 15/15 — ALL GREEN (110 frozen tests; compiled
  under the stanzas' exact flag set).
- **The blind-spot clause (standard form since the prepost pack):**
  the two script-recompiled frozen fixtures re-run DIRECTLY against
  the draft — ladder's Sayable.hs and prepost's SayableP.hs both
  all-green.
- **The sealed-variant proof:** the draft compiles `-Wall -Werror
  -Wincomplete-patterns` clean (so every Expr-exhaustive matcher in
  src is covered — bits, evalx, renderExpr, no others exist) and
  compiles whole under `-DDROP_USAY` (layer absence).

## 3. The fixture, proven (the frozen P12 habit, discharged)

`SayableC.hs` typechecks with **0 errors** against the drafted
surface — its red on the real tree is demonstrated to be exactly the
missing constructor (both suite reds' compile errors name USay).

Against the FULL draft (the Task-3 shape): all six checks pass — the
two price pins are thereby DERIVED from bits-on-draft, never a
parallel derivation: `USay worth` = 11·lg 10 + 2·lg 2 + 5·lg 4 (11
nodes, two scope-2 Var mentions, five four-point grid mentions, 0
sort bits); the sentence = lg 10 + lg 7 + 8·(lg 10 + lg 8) + two
said-utility subtrees.

Against the FREEZE-shaped draft (stub evalx, real pricing): prices
GREEN, bridges RED, episode RED, and ONE STUB-ACCIDENTAL GREEN, named
here: "Get is dormant" passes at the stub (mute 0 == 0); it becomes
load-bearing when Task 3 lands the real evaluation.

Task-1 suite state: 2/17 red (the sayable row, the deletion row —
the deletion row's positive control needs the constructor), 15 green
from start — every world row runs on already-frozen verbs, pinning
the worlds and the measurement against future drift (C9 as approved;
the increment's implementation IS the door, and every test of the
door lives in the fixture).

## 4. The measurement, recapped (CIRL_PLAN T4 has the full tables)

Deference bought at k=0 (margin +0.344, VoI 0.233 over the control's
abstention +0.111); asking dies at k=1, listening at k=4 — the two
vanishings separated; VoI decays 0.233 → 0.122 → 0.029 → 0.008 → 0;
the control's margin is minus the step prevision analytically
(≤1.1e-16 at every stage); at point-mass certainty the pointer
collapses (VoI ≤ 4.4e-16, deference only as abstention). Realized:
the switch saves the step at true u=0.2 (−0.02 vs −1.02); the u=0.8
tie is exact. Off first-listed — CL-3's tie-break carrying safety
content for the first time (C1's rider, for the report).

## 5. Freeze-sequence checklist (run in order)

```
git log --format='%G? %GF %h %s' -2          # 52da285, 311d10d builder-key G
sha256sum -c MANIFEST.sha256                 # 56/56 (pre-freeze state)
sh test-cirl/red-run.sh                      # 2/17 red, compiles under exact flags
cabal test all                               # seven suites green
# review pack sections 1-4; builder applies the five edits as ONE freeze commit
sha256sum -c MANIFEST.sha256                 # 63/63 on the freeze commit
cabal test all                               # seven frozen suites GREEN; cirl present,
                                             # RED in its freeze-state subset (sayable row
                                             # red on bridge+episode; deletion row GREEN —
                                             # all four checks pass once USay exists)
grep -n "UTIL" typed-port-spec.md            # the new row + the hole sentence
git tag -s cirl-freeze <freeze-commit>       # YOUR shell — or fresh per-instance
                                             # delegation, recorded verbatim in the
                                             # tag message
```

From the tag, test-cirl/ and the amended frozen files are as frozen
as test/. Then Task 3 (the definitional evalx line lands — the bridge
identity becomes definition; all 17 green; the SEVENTH digit-for-digit
margin run; all FOURTEEN flags), Task 4 (ablation + CIRL_REPORT.md
with the reviewer block and C1's recorded rider; taildrop to pixel6),
each builder-signed, stop-and-report on any pinned-anchor movement.
