# Preposterior Increment Report (step-6 increment 5)

Built to ROADMAP increment 5 as sharpened at kickoff (action-dependence
in vThink's kernel — the one mechanism that makes exploration priceable,
the true CIRL prerequisite), under typed-port-spec.md §3 as amended at
this increment's freeze (the STDNAME production-table repair) and the
CLAUDE.md increment protocol as amended (the fixture-proof habit, P12).
This is the as-built record against PREPOSTERIOR_PLAN.md's register;
the increment ends when the author runs the reviewer verification
block at the bottom.

Commit chain: `04638df` Task 0 (plan; both worlds measured, margins in
the plan) → `2bf6c72` Task 1 (oracle runtime-red 9/15; the battery
blind-spot discovery) → `63c724f` Task 2 pack → `5df7d3a` Task 2
freeze applied (SEVEN edits — the pack's six plus the author's edit
(7) at approval — manifest 56/56) → **prepost-freeze tag**
(author-signed in person from their shell; the two flagged bytes
recorded as reviewed and accepted in the tag message) → `10cd930`
Task 3 (vPreAt lands, vThinkAt re-based; all 15 green) → Task 4 (this
report).

## 1. Gate matrix at completion

`env -i PATH HOME LC_ALL=C.UTF-8 sh audit/run-gates.sh --phase 2` →
all seven gates PASS, exit 0. Gate 5 now runs seven suites: acceptance
4/4, properties 3/3, hygiene 15/15, expfam 22/22 (under the
twice-amended pin), membrane 31/31, ladder 20/20 (under its amended
pin), **prepost 15/15**. Manifest 56/56. The increment's ablation
runner green with attribution (four checks including layer absence).
All of src/ compiles under each of the THIRTEEN ablation flags (12
inherited + DROP_VPRE), per the audit convention (plain ghc; gate 1's
full -Wall -Werror set holds on the default configuration).
Frozen-surface diff since the prepost-freeze tag: empty (one file,
src/PropLang/Eval.hs, changed post-tag — implementation surface only).

## 2. Margin readout (same scratchpad program, SIXTH digit-for-digit run)

| quantity | value |
|---|---|
| t4 full-grammar log-loss delta | 7.105e-14 |
| t4 frozen-agent log-loss delta | 5.684e-14 |
| t3 agent log-loss, drift400 | 0.0 |
| t3 agent log-loss, flat400 | 1.137e-13 |
| t1 MAP posterior delta | 1.665e-15 |
| t1 / t3 MAP renders | byte-identical |

All six readout quantities byte-identical to the fifth run
(LADDER_REPORT §2). The increment re-based `vThinkAt` itself — it is
now DEFINED as `vPreAt` at the mute singleton — and flipped `stdB`
from lg 6 to lg 7, and no frozen anchor moved by an ulp: the
degenerate branch's arithmetic is line-for-line the pre-increment
fold (the immediate prevision is exactly 0.0, the singleton max is
the identity, and IEEE `0.0 + x` is exact), and no frozen dl pin
contains stdB except the two the author amended (§4, incident 3).

## 3. As-built answers to the register (P1–P12 as ruled at Task 0)

- **P1 (the recursion).** As ruled. `vPreAt` in Eval.hs: W_0 is
  `vAct` over the terminal menu — the same frozen function, not a
  copy; W_j is `foldl' pick negInf` over per-decision branches
  (immediate prevision + own-channel continuation, the one kernel
  weighting the outcome sequences AND conditioning the belief), with
  `- price` outside the max. Depth-general; the worlds exercise depth
  1, the degeneracy pins depths 1–3.
- **P2 (the degeneracy identity).** Identity-as-definition, the
  required form:
  `vThinkAt d b k ys u acts n price = vPreAt d b (const k)
  (mkUtil (\_ _ -> 0)) (() :| []) ys u acts n price`. The `==` pins
  are green at the verb layer (three beliefs × depths 1–3 × prices
  {0.05, 0}, plus 100 QuickCheck trials over random prefixes and
  prices); the sixth margin run (§2) guarded the frozen anchors.
- **P3 (where action enters the type).** As ruled: `Chan d h y`
  opaque wrapper in Syntax beside `Util` (constructor private,
  `mkChan`/`applyChan`), parity-scoped debt recorded in the haddock —
  due in the CIRL neighborhood alongside Util's. `Evidence`, `Kernel`,
  `Belief`, `InternalAct` untouched; gate 2's export discipline
  unaffected; conditioning still enters only as evidence.
- **P4 (the verb).** `VPre` as ruled, STDNAME 6→7, signature exactly
  as proposed (depth first, the frozen leaf's `u`/`acts` verbatim in
  the tail). Landed at the freeze with `stdB = logBase 2 7` and the
  applyStd/stdNameStr cases, all behind DROP_VPRE.
- **P5 (the moving literals; bounded growth).** As-built, larger than
  registered by author ruling and one sweep: the census's two frozen
  assertion literals (ExpFam.hs:140, Sayable.hs:205 — test names
  moving with them per the ruled form), the two stale comment lines
  (Sayable.hs:11, sayable.sh:9), the author's edit (7) — the spec §3
  STDNAME production-table row, stale since the ladder boundary,
  repaired for both alphabets in one edit with provenance note — and
  two flagged bytes beyond the pack's enumeration (§4, incident 3).
  Standing consequence recorded at pack approval: **the production
  table joins the census.** Growth stays bounded (the roadmap
  terminates at increment 6); increment 6's census is four sites —
  ExpFam.hs:140, test-ladder/fixture/Sayable.hs:205,
  test-prepost/fixture/SayableP.hs:190, and the spec §3 table row —
  plus their names/comment lines per the standard forms.
- **P6 (the worlds).** As measured at Task 0, pinned at Task 1, green
  at Task 3: declared history `[1]` folded through cond by the host
  (the L6 doctrine); the noise channel built from the exported
  surface; s ∈ {0.05, 0.4}, p = 0.01, true theta 0.1, zeros stream;
  W0 differs from W in the probe's channel alone (the cross-world
  `==` on safe's value held). The probe is bought at s = 0.05,
  declined at s = 0.4; the myopic agent never probes; realized nets
  +0.78 / −0.77 / −0.82 all at 1e-12; the control's margin is the
  sacrifice exactly.
- **P7 (module homes).** As ruled: worker private and unconditional
  in Eval (`vPreAt`, unguarded — it mentions no Chan and dies with
  nothing); `Chan` in Syntax; public `vPre` + verb + `Chan` behind
  DROP_VPRE; no new src module (the six-file guard is a green oracle
  row); no Membrane change.
- **P8 (ablation).** DROP_VPRE deletes `Chan`/`vPre`/`VPre`; the
  fixture dies with attribution naming the deleted surface; src
  compiles whole under the flag (the myopic base and the ladder
  survive); all thirteen flags green.
- **P9 (sequencing).** As ruled. Compile-fixture inversion carried
  the sayable surface red-by-compile-failure across every pre-freeze
  tree state; the fixture was proven type-correct (0 errors) against
  the drafted seven-member surface before the freeze sealed it — the
  canonized habit, discharged on its first outing; frozen suites
  green at every intermediate state.
- **P10 (tolerances).** E12 verbatim, as-built: `==` for the
  degeneracy identities and the cross-world structural assertion;
  behavioral pins exact; value pins and nets at 1e-12 asserted
  against frozen-verb compositions; the control's analytic margin
  (exactly s) at 1e-12; CL-4 shape (1e-9 relative) for the noise
  no-op previsions.
- **P11 (pin provenance).** Frozen imports where frozen quantities
  exist (Streams.buffer36; every continuation composition IS
  `vThinkK` at price 0); the world choices and nets are Task-1
  intended-behavior pins; the Task-0 sim was discriminating power
  only — no pin was transcribed from it (b7f120e held with nothing to
  re-open).
- **P12 (boundary queue).** The fixture-proof sentence (author text,
  verbatim) landed in CLAUDE.md increment-protocol item 2 at the
  freeze; porting order needed no touch-up (author ruling); the
  amendment-set growth is recorded as BOUNDED with the escape
  condition on the record (any scope extension beyond the roadmap
  makes a single-site frozen alphabet constant a mandatory boundary
  item).

## 4. Incidents and rulings on the record

1. **The battery blind spot (Task 1).** shellRow rows recompile
   their fixtures from the WORKING TREE, so the standard-form battery
   against a scratch draft cannot see script-recompiled frozen
   fixtures move — the ladder suite showed green against the drafted
   seven-member surface. Caught by re-running the frozen ladder
   fixture DIRECTLY against the draft (it failed on exactly the
   census line). The clause — completeness runs re-run
   script-recompiled frozen fixtures directly against the draft —
   was ACCEPTED into the standard form at pack approval.
2. **The spec §3 production-table staleness (pack review).** The
   author's catch, and the increment's defining ruling: the normative
   STDNAME row still read five members at log2 5 — never amended at
   the ladder boundary (a miss on both sides of the membrane; the
   H_pre precedent applied by the author to the author). Repaired for
   both alphabets in one edit (7) with a provenance note beneath the
   table, under the named **frozen-text-states-no-falsehood
   standard**. Standing consequence: the production table JOINS THE
   CENSUS for every future alphabet change.
3. **Two bytes beyond the pack's enumeration (freeze execution).**
   The builder's widened pre-edit census sweep found two grep-visible
   stale bytes not enumerated in the approved pack, both inside the
   check the pack already amends: Sayable.hs:203 (the check NAME of
   the 205 pin, still asserting "lg 6") and the residual "lg 6"
   phrase on Sayable.hs:11. Both were required by the approved
   checklist's clean-grep expectation and covered by standing ruled
   forms (the test-name form; P6's line unit); applied with the
   deviation recorded in the freeze commit message; the author
   reviewed and accepted both in the prepost-freeze tag message.
   The past-tense boundary records (sayable.sh:7's "five-member",
   the ladder stanza draft's "lg 5 -> lg 6") were left untouched —
   true as written.
4. **Custody.** All four builder commits this increment signed with
   the builder key; the prepost-freeze tag signed by the author in
   person from their own shell — no delegation this boundary.

## 5. Reviewer verification block (run by the human; closes the increment)

```
export PATH="$HOME/.ghcup/bin:$PATH"
sha256sum -c MANIFEST.sha256                # expect: 56/56 OK
env -i PATH HOME LC_ALL=C.UTF-8 sh audit/run-gates.sh --phase 2
                                            # expect: gates 1-7 PASS, exit 0
git log --format='%G? %GF %h %s' -- MANIFEST.sha256
                                            # expect: 9 commits, all G —
                                            # 5 author-key (…UucsY),
                                            # 4 builder-key (…XAmgc)
git tag -v prepost-freeze                   # expect: good author-key
                                            # signature, object 5df7d3a
git verify-commit 5df7d3a 10cd930           # expect: builder-key G on both
sh test-prepost/ablation.sh                 # expect: PASS [vpre] with
                                            # attribution
```

The margin readout (§2) is a scratchpad diagnostic outside the repo
(read-only against frozen test/Anchors.hs); to reproduce:
`ghc -O1 -isrc -itest -i<scratchpad> -o margins <scratchpad>/Margins.hs
&& ./margins`.

On the author's green: increment 6 (utility-as-latent, CIRL, discrete
reading only) opens with the Util type-shape ruling the roadmap holds
for its kickoff, and `Chan`'s parity-scoped debt comes due alongside
Util's.
