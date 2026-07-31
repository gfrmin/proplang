# readout-author-pack.md — increment #20, the K-ary readout

The wire docket's first sitting. Charter: `EXACT_PLAN.md` section 15.
Opened by the author's election of 2026-07-31 ("Open #20"), on the
authorization `battery-freeze-r0` already carries: "the 14.9 wire
scheduling (#20 first, the OB-19 heir second, #19 1a-or-doctrine
third)".

---

## Part I — the opening

### I.1 State of the tree at the opening

| check | result |
|---|---|
| HEAD | `bd0d70c` — **is** `battery-freeze-r0`, tagged under the author's key |
| `sha256sum -c MANIFEST.sha256` | PASS, 109 rows |
| working tree | clean at the opening |
| `tools/boundary-audit.sh` | M5=0 H=0 OB=1 BF=0 — transcript at `test-readout/opening/boundary-audit.txt` |

The battery closed as a single-tag pin-freeze with no implementation
owed, so nothing is carried forward from it except its routed
findings channel (Part I.4) and its scheduling ruling.

### I.2 The object, and why it is first

`p1` is P(atom 1) at ANY arity (membrane-wire.md:356). At K-ary arity
that under-reads the predictive: when the engine chooses `respond_j`
with j /= 1, `p1` reports a different candidate's mass. Issue #20 asks
for `p0` / `argmax_code` / `p_argmax`, or the full O(K) vector, as
observability only — the `residual_mean`/`sensitivity` class
(membrane-wire.md section 6.4).

Two facts decide the increment's shape, both measured before the
boundary opened:

1. **Host-layer arithmetic over already-exported verbs.**
   `predictMassS` is already called at the reply builder
   (`src/PropLang/Host.hs:425`); `agentObsPoints` already enumerates
   the declared observation space at `:516`. The vector is a map of
   the first over the second. No new export, no constructor, no
   engine change — the alphabet does not move, `prodTable` stays
   20/1, and the primitivity gate is not engaged (nothing here is a
   candidate production, so clause (a) is not owed).
2. **The R-D23 cap binds at the operating point.**
   dispositions-pack.md VIII.1 finding 2, K=6, 5845 models, 400
   interleaved ticks: `p0` = 0.17998972 against the cap
   0.9/(K-1) = 0.18, while the empirical null rate is 0.735. The
   engine under-reads the null four-fold, and no evidence can fix it
   — `Enumerate.hs:467` makes atom 0 structurally undistinguished.

Fact 2 is the scheduling argument. OB-19's null-rate parameter is
UNOBSERVABLE today; `p0` is the number that observes it. #20 is the
instrument that lets item two be ruled on evidence rather than on
argument.

### I.3 Anchor safety — the claim this increment must execute against

An additive reply field is expected to move no pinned anchor. The
inspection behind that expectation:

| would-be pin | what it actually does | verdict |
|---|---|---|
| `test-transport/Transport.hs:95` | `expectedReplies = snd (mapAccumL serveLine hostStart requests)` — the R-D20 form, the frozen core folded over the same lines | both sides move together; no literal to break |
| `test-trampoline/Trampoline.hs:500-502`, `:520-522` (g6.1, g6.2) | `isInfixOf` against the reply | additive-safe |
| `test/Acceptance.hs:211` "probe rows: p1 exact" | reads `predictMassS` directly against `Anchors.t1ProbeRowsX` | never touches the reply builder |

Grep for a literal `"p1"` or `entropy_bits` anywhere under `test/`
or `test-*/` returns nothing. **This is a claim, not a result**: it is
confirmed by the full-corpus run on the implemented surface, and any
pinned-anchor movement under an additive change is stop-and-report.

### I.4 The frozen-layer inventory — FL-1

The battery tag routed its post-tag findings to this sitting. The
first row did not wait for a reviewer; the boundary audit's OB-row
produced it mechanically.

**FL-1 — OB-20 and OB-21 carry `SCHEDULED@x5-sitting-r0` against a
closed boundary and against their own executed discharge.**

- `battery-freeze-r0` register CR5: "OB-20/21 are DISCHARGED at this
  boundary: M56-M61 committed with reach demonstrated".
- The substance is in the tree: `audit/mutants/M56..M61`, and
  `test-battery/opening/pool-reach.txt`, whose own header reads "the
  discharge evidence" (M57 the independence suite's sole killer, M60
  the count stanza's, M61's predicted generator-blindness cured
  in-increment by g-b4.1).
- `OBLIGATIONS.md` was last written at `trampoline-freeze-r0`
  (e4f41f3). The battery's freeze kit spliced the stanza and extended
  the manifest but never patched the ledger.

So the work happened and the record does not say so. This is the
exact shape the OB-row was installed to catch (the VoI obligation
that evaporated inside a composite: a discharge that happened and was
never written down). `OBLIGATIONS.md` is manifest-frozen, so the
repair rides THIS freeze under the author's key — register item CW7,
both rows to `DISCHARGED@battery-freeze-r0` with provenance and named
discharge events.

**FL-2 — open, empty.** Whatever the mandate round or the oracle
phase surfaces against frozen prose lands here before the freeze, in
the form its text class demands.

### I.5 The opening checklist

| row | state at the opening |
|---|---|
| OB-19 | RULING-PENDING, wire docket item TWO. Not ruled here; #20 is its instrument. Recorded so the sitting cannot drift into ruling it on argument |
| JP2-d6 / pwLadderCap | RETIRE-UNTIL-N whose N is the **#19** sitting (item three), NOT this one. Stated rather than left silent |
| OB-20 / OB-21 | substance discharged at battery-freeze-r0; ledger stale — FL-1 |
| boundary audit | run, transcript committed; M5=0 H=0 OB=1 BF=0 |
| red-team mandates | to run, six fresh-context reviewers, one mandate each |
| pre-freeze lint | due at the freeze, with the full-corpus overlay build |

Mandate 6 has a live question here — what is the readout a function
of? Answer as designed: the predictive at `feats ++ act` and the
DECLARED observation space, and nothing else; not the menu, not the
decision path. Mandate 5 has a standing candidate in `p1`'s meaning,
which oracle row r7 pins two-sided.

### I.6 The toolchain, stated plainly

The build environment at the opening has **no Haskell toolchain**, and
GHC 9.10.3 — the compiler the frozen `cabal.project.freeze` implies
(`base 4.20.2.0`, `containers 0.7`) — cannot be fetched:
`downloads.haskell.org`, `deb.debian.org` and the ghcup mirrors are
all 403 at the agent proxy; Ubuntu's archive offers only GHC 9.4.7.
The ghcup binary itself is reachable from GitHub.

GHC 9.4.7 is NOT a substitute and was not used: `base 4.17` fails the
frozen freeze file, and a mismatched warning set or package closure is
precisely the defect class the flag-faithfulness and
package-faithfulness clauses were purchased to prevent (the step-5
reorder incident; the jp `Data.Map` prophecy that reached the
implementation phase unseen).

*[SUPERSEDED IN PART, 2026-07-31, same session: the network policy was
amended at the author's election and the toolchain arrived — GHC 9.10.3
and cabal 3.16.1.0 via ghcup, `downloads.haskell.org` reachable. The
paragraph above is kept as the opening's record; what it says about
GHC 9.4.7 stands unchanged and unused. Part III is the executed work
this section said was owed.]*

Consequence for this pack: everything in Part I is shell-and-grep work
and is EXECUTED. Every execution-bearing clause of the oracle phase —
the two-run triptych, the overlay SAT under the stanza's dependency
closure, the R-D21 satisfiability transcripts, the kill matrix, gate 5,
lint row v — is OWED and is not claimed. The oracle phase does not
close, and nothing freezes, until the toolchain exists and the
step-0 baseline (the sealed tree, green, before any edit) has run.
No row in this pack is reported green that was not run.

---

## Part II — the drafted oracle

`test-readout/Readout.hs` + `test-readout/stanza.cabal.draft`. **Drafted,
not executed** — see I.6. The file says so in its own header rather than
relying on this pack to say it.

### II.1 The world, and why it is shaped this way

ONE declared world: namespace `["move"]`, no guards, a menu of a single
name at a **single point**, the 9-point theta codebook, `obs_arity`
absent (the plain route) or 6 (the K-ary face).

The single-point menu is deliberate. It forces the chosen assignment, so
`feats ++ act` is known to the suite without parsing `act` back out of
the reply — which keeps the reference honest (computed through the
library) instead of round-tripping the engine's own answer. It also
makes mandate 6's answer structural: the readout is a function of the
predictive at that assignment and of the declared observation space, and
of nothing else. The menu cannot influence it because the menu has one
element.

### II.2 The rows as drafted

| row | shape | red |
|---|---|---|
| r1a | the shipped three fields carry their frozen meanings (`p1` == `predictMassS act 1`, `entropy_bits` == `entropyAgent`) | GREEN — the ATTRIBUTION PARTITION, transport t4's form: it proves the pre-increment fields are already right, so every other row's red is attributable to the missing readout alone |
| r1b | the vector joins them, and joins them AFTER `entropy_bits` (CW3) | red |
| r2 | entry j == `predictMassS (feats ++ act) j` over `agentObsPoints`, K=6 | red |
| r3 | the vector sums to 1 EXACTLY, in a POST-EVIDENCE state (distinct data from r2, so the row is not r2 wearing a law's name) | red |
| r4a | the prior vector HAS ties — so CW2's tie rule is genuinely exercised, not vacuously satisfied | red |
| r4b | `argmax_code` indexes a maximal entry, `p_argmax` IS that entry, on a stream constructed to move the argmax off 1 | red |
| r5a | the cap BINDS: an all-null stream reads far under its own empirical rate of 1 | red |
| r5b | **(M)** the readout CLIMBS to the cap (non-decreasing; the gap at least halves) | red |
| r5c | `p0` is the NULL atom's mass, on the wire | red |
| r6 | the vector survives the pipes (spawned host, g6 form) | red |
| r7a/b | `p1` still means P(atom 1), two-sided: the identity holds, AND `p1` differs from `p_argmax` when the argmax is not 1 | red |
| residual | the unwalked axes, PRINTED | RECORD row |

### II.3 The cap is DERIVED, never written down

`capQ = (1 - minimum thetaPts) / (fromIntegral kAry - 1)`.

R-D23's "0.9/(K-1)" and VIII.1's measured 0.18 are the same number, and
the suite writes neither. The derivation: no sentence in the family
distinguishes atom 0 (`Enumerate.hs:467`, `atoms = [1 .. k - 1]`), so
atom 0's mass is the spread rate (1-theta)/(K-1) under EVERY hypothesis,
and the posterior's best case is the codebook's lowest theta. A probe
reads declared data; the theta grid is declared once at the top of the
suite and every derived quantity reads it.

This is what makes r5 the OB-19 instrument rather than a restatement of
it: the row does not assert the cap's value, it asserts that the shipped
readout is bounded by a quantity computed from the world's own
declaration, while the stream's empirical rate is 1.

### II.4 What is OWED before this can freeze

Nothing below has been run, and none of it is claimed:

1. **The step-0 baseline** — the sealed tree green (`cabal test all`,
   12 suites; lint 0 FAIL; manifest) BEFORE any edit. This licenses
   attributing later reds to the increment.
2. **The red run** — every row above proven to CAN fire, under this
   stanza's exact flags and dependency closure.
3. **The overlay SAT** — the prototype wearing `PropLang.Host`'s name,
   the frozen text compiling unchanged, `-Werror` included,
   `-hide-all-packages` plus the declared `build-depends`.
4. **R-D21 transcripts** — one per red row, each forcing the frozen side
   to normal form independently of the stub side.
5. **The (M) row's measurement** — r5b's gap-closure shape is a
   HYPOTHESIS until the probe measures the approach. If it is not
   monotone, r5b is re-cut at measurement; r5a and r5c stand either way.
   Recorded as (M) in the file itself so no reviewer has to guess which
   assertions rest on unmeasured behaviour.
6. **The kill matrix** — each row's unique kill against the STANDING
   corpus, with the designed killers of section 15.3 cut as mutants
   (field-clobber, index off-by-one, the OB-20-class normalization
   mutant, tie-rule flip, the `[1..K-1]` null-dropping vector,
   serialization, `p1` re-pointed at the argmax).
7. **The six red-team mandates**, against the drafted oracle.
8. **The anchor-safety claim** (I.3) CONFIRMED on the implemented
   surface by the full corpus, not assumed.

### II.5 Register items the draft did not settle

CW1 (vector vs three scalars) is drafted for the vector, and the rows are
written so that declining it NARROWS them — r2/r3/r6's `p_codes`
assertions drop, r4/r5's `argmax_code`/`p_argmax`/`p0` assertions stand
unchanged. CW2's lowest-index tie rule is pinned by r4 whichever way it
is ruled; only the reference fold's direction changes. CW5 (no readout on
the think reply) is asserted nowhere and appears only in the printed
residual — if the author rules the other way, a row is owed.

---

## Part III — the oracle phase, EXECUTED

The toolchain arrived mid-session (I.6's dated bracket). Everything Part
II listed as owed under items 1-4 and 8 has now been run; what remains
owed is named in III.7.

### III.1 Step 0 — the baseline on the sealed tree

`test-readout/opening/baseline.txt`. On `bd0d70c` = `battery-freeze-r0`,
before any edit reached the build: manifest 109/109 rows OK, and
`cabal test all` **11 suites PASS** under GHC 9.10.3. This is what
licenses attributing every red below to the increment rather than to
the environment.

*(A count worth recording: the stanza census is ELEVEN suites, not the
twelve the battery's own gate-5 transcript reports. The boundary
audit's standing observation flags the same drift from the other side
— `test-writeup/check.sh` G2's retired-to-record row notes 8 stanzas
at its close date against 11 live. Not a defect in anything shipped;
recorded here so the next census counts rather than quotes.)*

### III.2 Finding 1 — the wire parses declared numbers through `Double`

`jQ = realToFrac <$> jNum` (`src/PropLang/Host.hs:239-242`). A world
that declares `0.1` therefore reaches the engine as
`toRational (0.1 :: Double)`, **not** as `1/10`.

The first draft's reference built its theta grid from exact decimal
rationals, so the reference and the wire were running *different
worlds*. They agree at the prior and drift apart under evidence: the
first red run had `r1a` green (the plain route, at the prior) and
`r7a` red after twelve folds, disagreeing in the sixteenth digit —
`2.5660752778443065e-2` on the wire against `2.5660752778443072e-2` in
the reference. A probe measured the cause directly.

The remedy is a declaration, not a workaround: the suite declares a
**binary-exact** theta grid (eighths), where the declared decimal and
the exact rational are the same number, so reference and wire build the
same world by construction. `r1a` and `r7a` are the rows that pin that
they do — the finding produced its own two-sided pin.

### III.3 Finding 2 — the reference ran a grid the suite had not declared

`refAgent` built its grid as `mkGrid "theta" (1 % 10 :| drop 1 thetaPts)`
— a hand-written head literal beside a `drop 1`. When Finding 1's fix
moved `thetaPts` to eighths, the head stayed `1/10`, so the reference's
θ-min was 0.1 while `capQ` derived 0.175 from the declared eighths. `r5a`
went red with `p0(20) = ...491919.../2745074... ≈ 0.1792 > 0.175`.

The violated law is the one the file cites three lines above the defect:
**a probe reads declared data and never re-declares a value it could
import**. Fixed by building the grid from `thetaPts` entirely.

Worth stating plainly: in the FIRST red run, `r5a` and `r5b` were
green — green against a world the suite had not declared. A green that
passes for the wrong reason is the two-run triptych's own failure mode,
and only the grid change made it visible.

### III.4 The two-run triptych, both sides

**Red run** (`opening/red-run.txt`, shipped pre-increment `src`) —
6 of 13 red, and the partition is exactly right:

| red | r1b, r2, r3, r4b, r5c, r6 — every row that asserts a readout field |
|---|---|
| **green** | r1a, r4a, r5a, r5b, r7a, r7b — the structural and library-side rows |

`r1a` is the attribution partition (transport t4's form): the shipped
`act`/`p1`/`entropy_bits` are proven to carry their frozen meanings on
the pre-increment surface, so the six reds are attributable to the
missing readout alone and to nothing else.

**SAT run** (`opening/sat-run.txt`) — **13/13 PASS** against an overlay
wearing `PropLang.Host`'s own name, so the oracle's exact frozen text
compiles unchanged, under the stanza's flags (`-Werror` included) and
its dependency closure. The overlay's first cut was rejected by
`-Werror=x-partial` for two uses of `head`; the accepted overlay is
total, which is the implementation's constraint too.

### III.5 The I.3 anchor-safety claim — CONFIRMED, not assumed

`opening/corpus-overlay.txt`: the **full corpus against the overlay,
12 of 12 suites PASS** — `transport` (whose expectation is the folded
core itself), `trampoline` (the g6 wire rows), `exact-acceptance` (the
t1/t2/t3 anchors and the deletion table), `battery` (all 82 rows),
alongside the new `readout` suite.

The increment's central risk was that an additive reply field moves a
pinned anchor. It does not, and that is now a measured result rather
than an inspection's expectation. Had it moved one, this was the
stop-and-report.

### III.6 The prophecy, and the prototype's disposal

`opening/prophecy.diff` (49 lines) is the overlay diff, saved before the
prototype was discarded (R-D21's overlay form; the generator exemption
does not apply — this is a prototype, not a generator). It is the
implementation phase's prophecy in the jp sense: the implementation is
expected to land it byte-for-byte, and any deviation is a reportable
event rather than a preference.

Its shape: `readoutFields :: [Rational] -> [String]`, total by pattern
match, argmax by a `foldl` that keeps the incumbent on ties (CW2's
lowest-index rule), called from `tickExternal`'s `decPart` after
`entropy_bits` (CW3). No new export, no engine change, no decision-path
reachability — the charter's claims, as built.

### III.7 What remains owed

1. **The kill matrix** (Part II item 6). Six rows have a live red; the
   other seven — r1a, r4a, r5a, r5b, r7a, r7b and the residual RECORD
   row — are green in BOTH runs by design, so their red must come from
   seeded defects. The designed killers are named in EXACT_PLAN 15.3
   and are cut as mutants against the implemented surface.
2. **The six red-team mandates** against the drafted oracle.
3. **The pre-freeze lint**, with the full-corpus overlay build (row v).
4. **The freeze kit** (`test-readout/freeze/`, the jp 1/2/3 form),
   rehearsed two-sided from a fresh clone.
5. **The register**, ruled at the sitting — CW1-CW8, plus FL-1's repair.

Nothing above is claimed. What Part III reports as green was executed
and its transcript is in `test-readout/opening/`.
