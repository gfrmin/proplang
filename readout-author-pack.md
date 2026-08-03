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
   (`src/PropLang/Host.hs:425` **at `bd0d70c`**, the binding
   `p1 <- predictMassS full 1 ag`); `agentObsPoints` already
   enumerates the declared observation space at **`bd0d70c`**'s
   `:516`, the binding `(agentObsPoints ag)`. The vector is a map of
   the first over the second. No new export, no constructor, no
   engine change — the alphabet does not move, `prodTable` stays
   20/1, and the primitivity gate is not engaged (nothing here is a
   candidate production, so clause (a) is not owed).

   > **[2026-08-01 — the anchor and the binding names above were
   > added after the fact, and the reason is the ruling this
   > increment carries to the sitting.]** Both numbers were bare when
   > written and both are now FALSE of `HEAD`: the implementation
   > moved `p1 <- predictMassS full 1 ag` to `:426`, and `:516` is an
   > unrelated `let uB ::` line. They were TRUE of the tree Part I
   > declares (I.1: HEAD = `bd0d70c`) and stay true under the anchor.
   > A sitting reader has `HEAD` checked out, not the seal, so a bare
   > pre-implementation line number sends them to the wrong line —
   > which is exactly LINE-NUMBER PROVENANCE IN PRE-IMPLEMENTATION
   > ORACLES, the one ruling sought. The increment applied that remedy
   > to the ORACLE's copy table and not to its own pack; this is the
   > omission repaired, and it doubles as the demonstration that the
   > proposed remedy suffices.

2. **The R-D23 cap binds at the operating point.**
   dispositions-pack.md VIII.1 finding 2, K=6, 5845 models, 400
   interleaved ticks: `p0` = 0.17998972 against the cap
   0.9/(K-1) = 0.18, while the empirical null rate is 0.735. The
   engine under-reads the null four-fold, and no evidence can fix it
   — `Enumerate.hs:208` (`posAtoms`) makes atom 0 structurally undistinguished.

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
name at a **single point**, the declared 7-point theta codebook (eighths), `obs_arity`
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
distinguishes atom 0 (`Enumerate.hs:208`, `posAtoms = [1 .. kAr - 1]`), so
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
compiles unchanged, under the stanza's flags — `-Wall -Werror
-Wincomplete-patterns -Wincomplete-uni-patterns`, the full set, spelled
out here because the flag-faithfulness clause requires the pack to
RECORD them and the pre-freeze lint's L5 row enforces exactly that —
and its dependency closure. The overlay's first cut was rejected by
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

---

## Part IV — the mandate round, and what it cost

Six mandates, four fresh-context reviewers, run against the drafted
oracle and the implementation. This round found more than any other
step of the increment, and two of its findings would have frozen.

### IV.1 The findings, and their disposition

| # | finding | disposition |
|---|---|---|
| **F1** | **`R-D23` is cited for a proposition it does not contain.** R-D23's definition site (`archive/HOSTS_D_PACK.md:835`) is the batch residue + warm-segmentation declaration. At `membrane-wire.md:147` it is a GENRE label — "a declared limitation in the R-D23 sense" — and the charter promoted that label into the name of a number. `0.9/(K-1)` has no definition site anywhere. | REPAIRED in EXACT_PLAN 15.0, falsified words quoted inside the repair. The normative cap is `membrane-wire.md:147-148`'s `1/(K-1)`; the operative bound is `(1 - theta_min)/(K-1)` from the DECLARED codebook |
| **F2** | **The `0.9` is a deleted constant.** It is `1 - min thetaPoints` for a theta point-set hard-wired in `src` at probe time and deleted at the exact re-founding (E3). The probe ran on tree `9790089`, two boundaries back. On the shipped tree the cap is a function of the world's declaration — which is why the oracle derives 0.175 and why 0.18 is not reproducible. | REPAIRED with F1 |
| **F3** | **`0.735` / `5845 models` / `400 ticks` are defined nowhere**, from a discarded scratchpad probe on the pre-exact tree, in a pack that is not manifest-frozen. | REPAIRED: relabelled PRE-EXACT-TREE PROBE OBSERVATIONS in the charter, explicitly not pinned. The oracle's residual already declined to claim them |
| **F4** | **`Enumerate.hs:467` / `atoms = [1 .. k - 1]` is stale at every one of five sites** — the file is 462 lines and the binding is `posAtoms` at `:208`. Carried forward from `dispositions-pack.md:1197` without ever being checked. It was **about to enter manifest-frozen `membrane-wire.md`** through this increment's own patch. | REPAIRED everywhere, the wire patch included. The R-D20-i copy-not-reconstruct failure, caught one step before it froze |
| **F5** | **The residual row misdeclared its own axis** — "the 9-point theta grid" against a declared 7-point grid of eighths, stale from before the Finding-1 repair. It printed the wrong number in BOTH executed transcripts and survived the whole triptych, because nothing asserts against a printed string. The no-silent-caps instrument mis-declaring its own cap. | REPAIRED in `Readout.hs` and the pack |
| **F6** | **The red-partition header was false.** It claimed "r2..r7 runtime-red"; the executed red run shows five of those rows green. | REPAIRED, with the falsified words quoted, and the partition now cites the transcript that measured it |
| **F7** | **`argmax_code` is POSITION-keyed while `p0`/`p1` are VALUE-keyed.** They coincide only because the host builds the carrier `0 :| [1 .. K-1]`, three frames away — and NOTHING asserted it. A carrier keeping 0 first but permuting the rest leaves every row green while `argmax_code` reports a position that is not a code. | **NEW ROW r2b** pins `agentObsPoints ag == [0 .. K-1]`, and **NEW MUTANT M71** (carrier permuted) was cut when r2b ran UNREACHED against the M64-M70 pool |
| **F8** | **CW2's tie rule had no wire pin.** r4a proves the prior is tied and r4b puts `argmax_code` on the wire — but r4b's stream gives a UNIQUE maximum, so between them the tie rule was never exercised where it bites. M67 produced a byte-identical reply on every world the suite walked. | **NEW ROW r4c** asserts the argmax on the wire AT THE TIED PRIOR. M67 now dies, and dies to r4c ALONE |
| **F9** | **r5a is a theorem installed as a definition** (mandate 1's own shape). Since no sentence distinguishes atom 0, `p0 == (1 - E[theta])/(K-1)` exactly, so `p0 <= capQ` is "a weighted average of a declared grid is at least its minimum" — unfalsifiable by any readout defect, and its only demonstrated red was the oracle disagreeing with itself (III.3). | r5a RELABELLED a **RECORD row** with the conviction written into it, and the discriminating content moved to **r5c**, which now reads the RENDERED `p0` off the wire and checks it against the cap |
| **F10** | **The menu-independence claim is untested**, not verified: the single-point menu with no utility takes the wait branch, so `chooseEU`/`pickWire` are never entered and no mutant computing `vec` at a different act is killable. The wire patch was about to install that claim in frozen prose. | The frozen-prose claim was RE-CUT to what the rows support. The row itself is **NOT YET BUILT** — see IV.2 |
| **F11** | `R-RED` is cited as law but the canonized clause in `CLAUDE.md` carries no ID string; the name exists only in the battery's freeze kit. | FL-2 row, one-line patch at this freeze |
| **F12** | The R-D20 copy table pinned absolute line numbers that the implementation shifts by 2-3 the moment it lands. | REPAIRED: anchored to the sealed tree `bd0d70c` AND named by binding. The general question — line-number provenance in pre-implementation oracles — is a register item for the sitting |
| **F13** | Section 6.4 is under a "sections 4-6 are historical, binding on nothing current" bracket, yet the readout classed its normative discipline by reference to it. | REPAIRED: the readout's binding discipline is now the LIVE section-3 bullet; the wire patch names 6.4's historical status explicitly |

### IV.2 The one finding NOT closed

**F10, the menu-independence row, is OWED.** The reviewer showed a red
is CONSTRUCTIBLE — a two-point menu plus a `said@1` utility that makes
the non-head row win, then assert the reply's `p_codes` equals the
reference at the REPORTED act and differs from it at the losing row.
Under "a red is constructed, never owed", a constructible red is not
an honest decline, so this is a real gap and is named as one rather
than absorbed. It requires `refVec` to take the act as a parameter
instead of closing over `theAct`.

It rides to the sitting as a docket item. The frozen prose no longer
asserts what the rows do not support, so nothing false freezes if the
author rules it deferred.

### IV.3 What the round says about the process

Two of these (F4, F5) were already inside the two executed transcripts
and survived them. F5 in particular printed a wrong number in both runs
of the triptych — because the residual is a PRINTED row and nothing
asserts against printed strings. The two-run triptych proves rows can
fire and can pass; it says nothing about the rows' *prose*, and the
mandate round is the only instrument that reads it.

F1-F3 are one connected finding: the increment's scheduling argument
was carried by numbers from a discarded probe on a two-boundary-old
tree, under a ruling ID that does not contain them. The oracle was
never wrong — it derives its own cap from declared data and explicitly
declines the field figures. The CHARTER was the exposed surface. That
asymmetry is worth carrying forward: the executable artifact was
disciplined by its gates, and the prose around it was disciplined by
nothing until six reviewers read it.

---

## Part V — the kill matrix

`test-readout/opening/readout-kill-matrix.txt`. Pool M64-M71, serial,
each cell a FULL corpus run (12 suites) with the mutant applied to
`src` and `src` restored after.

> **[2026-08-01 — this part records the FIRST matrix run and its
> figures are of that round. FURTHER SUPERSEDED 2026-08-02: the pool
> is now **ten** — M64-M72 plus the declared import
> `M7-ties-to-challenger`, admitted at the 3c disposition round
> because it is the only thing that reaches r8a (see IX.5). The matrix
> was re-run WHOLE a third time, for the reason it was re-run a
> second: a verdict is pool-relative and a pool is grown.]** The pool
> was **M64-M72** at the second round and the
> oracle **19 rows**: `r8` and its designed killer `M72` landed after
> this part was written, and the whole matrix was RE-RUN rather than
> extended, because per-row kill lists shift with the row set (VII.1,
> VII.4). The committed transcript
> `test-readout/opening/readout-kill-matrix.txt` is the re-run, so it
> does not match this part's pool line — the transcript is current,
> the prose is historical. The manifest figure moves the same way
> across the pack and each occurrence is of its own round: **134** at
> the container rehearsal (VI), **136** at the first thinkpad
> rehearsal (VII.5), **137** as it stands (VIII.3, after `SITTING.md`
> joined the glob).
>
> [2026-08-02] "**137** as it stands" is falsified and quoted here
> inside its own repair: the 3c disposition round added two rows
> (`r-d20i-anchor.patch`, and `M7-ties-to-challenger.patch` hashed by
> name), so the figure at the sitting is **139**. The full sequence is
> **134 → 136 → 137 → 139**. See VIII.3(ii)'s bracket — the miss was
> caught by the second conferral, not by this pack.

### V.1 The runner's own defect, recorded rather than silently fixed

The first cut of the runner classified a cell as COMPILE DEATH by
grepping the log for `rror:` — which matches cabal's own
`Error: [Cabal-7125] Tests failed for test:readout`, the line printed
on **every ordinary test failure**. So the runner reported all seven
mutants as compile deaths and **could not have reported a kill at
all**: a matrix runner that cannot report a kill is the exact mirror
of a green that cannot fail. The repaired runner detects a GHC
diagnostic (`^src/... error:`) or a cabal build failure, and the note
rides in the transcript's own header.

### V.2 The matrix

| mutant | rows fired | standing corpus |
|---|---|---|
| M64 readout precedes the v1 fields | 1 — **r1b alone** | GREEN |
| M65 index off-by-one | 7 | GREEN |
| M66 unnormalized on the way out | 4 | GREEN |
| M67 tie rule yields to the challenger | 1 — **r4c alone** | GREEN |
| M68 null atom dropped | 7 | GREEN |
| M69 vector truncated | 3 | GREEN |
| M70 p1 re-pointed at the argmax | 1 — **r7a alone** | GREEN |
| M71 carrier permuted | 7 | GREEN |

Every kill is READOUT-UNIQUE: no mutant reddens a standing suite, so
each row's kill is unique against the standing pre-increment corpus —
the forward half of the kill-matrix clause, discharged.

Three sole killers, and two of them are rows the mandate round bought:
**r4c kills M67 alone** (before r4c, the tie rule had no wire pin and
M67 produced byte-identical replies on every world the suite walked),
and **r7a kills M70 alone** (the `p1`-overloading mutant). **r1b kills
M64 alone.**

### V.3 Two corrections the matrix forced

**M64's first cut was a genuine compile death.** Deleting the v1 fields
left `p1` and `hB` unused under `-Werror`. A mutant killed by the
compiler is not a mutant, so it was re-cut to break the *other* half of
additivity — CW3's ordering — with every binding live. It now kills r1b
alone.

**M71 corrected an oracle row's claim.** r2b was written to pin "the
observation space IS [0 .. K-1]", the premise that makes `argmax_code`
(a position) equal an atom code. M71 permutes the host's carrier — and
left r2b GREEN, because r2b asserts over `refAgent`, the ORACLE's own
carrier, which no src mutant can reach. What actually pins the host's
convention is the seven wire rows M71 does kill, since `refVec` is
built in declared order and the reply is not. r2b is therefore
relabelled a RECORD row for the reference's side, with the correction
written into it. **The pool growth found a defect in a row that the
pool growth existed to serve** — a verdict is pool-relative and a pool
is grown, never assumed.

### V.4 Rows with no kill in this pool

r1a, r2b, r4a, r5a, r5b, r7b, and the residual RECORD row. All are
reference-side or structural by design, and two of them (r5a, r2b) are
now explicitly RECORD rows carrying the reasons they cannot fail. Under
the dyadic clause these are UNREACHED verdicts, and they are triage
input for the sitting rather than deletions.

### V.5 Gates, as built

Seven of seven PASS with the readout implemented; the corpus is 12/12
including `readout` at 15 rows **[of this round — 19 as frozen, see
VII.4; this heading says "as built" and a standing-sounding heading
over a superseded figure is the worst place for one]**; the manifest
verifies. `src` carries
the prophecy byte-for-byte — `git apply` accepted
`opening/prophecy.diff` against the sealed tree without fuzz.

---

## Part VI — the freeze kit, rehearsed two-sided from a fresh clone

`test-readout/freeze/`, the jp 1/2/3 form. Rehearsed in a scratch clone
under the builder's hands; the kit the author runs is the kit as
rehearsed.

### VI.1 Green side, end to end

**1-verify** (read-only) passed from the fresh clone: manifest OK; the
**live 15/15** compiled and run under the stanza's exact flags AND its
dependency closure (`-hide-all-packages` plus the declared
`build-depends`, `-Werror` included), with `proplang-host` put on PATH
for r6's pipes; and — new to this kit — **as-built == the prophecy,
line for line**, a diff of the committed `prophecy.diff` against
`git diff bd0d70c..HEAD -- src/PropLang/Host.hs`. The jp increment
asserted that identity in prose; here the script checks it.

**2-freeze** (keyless) spliced the stanza, applied all three `[RULING]`
patches, ran **gate 5 green on the spliced tree** (12 suites, `readout`
among them, zero FAIL), and extended the manifest **109 → 134 rows**,
re-signing the four mutated frozen files. The manifest verifies after
the extension.

### VI.2 The rehearsal's finding, and why the kit was NOT weakened

The lint's **L4 rows failed for all 26 tags** — and they fail for the
ENVIRONMENT, not the tree. Two causes, both recorded rather than
worked around:

1. A fresh clone carries no local git config, so
   `gpg.ssh.allowedSignersFile` is unset. **Fixed in the kit**: 2-freeze
   now sets it before the lint, idempotently — the f5
   runnable-from-anywhere lesson in its signature-verification form.
2. This container has **no real `ssh-keygen`**, only a signing shim
   that answers "unsupported code-sign operation: currently only
   SSH-style signing (-Y sign) is supported". Tag *verification* is
   therefore impossible here at all.

So `2-freeze.sh` stopped at `grep -q "0 FAIL"` and refused to finish.
**That is the gate working**, and it was left alone: weakening a lint
row to make a rehearsal pass is the forbidden move, not a convenience.
Everything else was verified directly — **zero non-L4 lint failures**
on the spliced tree. L4 is discharged in the author's shell, which has
a real `ssh-keygen` and the allowed-signers file.

### VI.3 Red side, both guards

- **A second splice was REFUSED** — `GUARD: readout stanza already
  spliced - refusing to run twice`.
- **A 3-sign edited AFTER 2-freeze hashed the kit was REFUSED at the
  manifest re-check, before any key act.** HEAD unchanged, and no
  `readout-freeze-r0` tag exists in the clone. The decline-by-editing
  order is enforced mechanically, not by convention.

### VI.4 What the author's shell still owes

The **tag**. Every commit in this increment is UNSIGNED: the builder
key (`allowed_signers`' `proplang-builder` fingerprint) is not in this
container, and the available signing shim would mint a signature that
verifies against nothing in `allowed_signers` — worse than no
signature, so none was made. This is recorded in the commits
themselves rather than passed off as builder custody. No freeze is
affected: a freeze is the author's tag, and `3-sign.sh` is waiting
for it.

---

## Part VII — the pre-tag adversarial read, and F10 CONSTRUCTED

Executed 2026-08-01 on the author's election, on a builder shell stood
up on `thinkpad` (GHC 9.10.3 / cabal 3.16.1.0 via ghcup; `steel`, the
author's own machine, is out of commission for a few days). The step-0
baseline was reproduced here FIRST and matches the container's
exactly: **manifest 109/109, `cabal test all` 11 suites PASS**, and
`1-verify.sh` green end to end. Nothing in this part is claimed that
was not run on this machine.

### VII.1 F10 is DISCHARGED — the red is constructed, not owed

The opening carried F10 to the sitting as an owed red (IV.2), while
conceding that a red was constructible. Under **R-RED** — the clause
this very increment's kit patches into `CLAUDE.md` to give it a
citable ID — a constructible red is not an honest decline. It is now
built as `r8a`-`r8d`, and the window was **measured first**, on a
throwaway prototype (R-D21), before any row text was fixed. The
transcript is `test-readout/opening/f10-window.txt`; the prototype is
discarded.

Three measurements, each of which moved the design rather than
confirming it:

1. **In a guard-free world the predictive does not move with the act
   at all.** `refVecAt headAct == refVecAt otherAct` at the prior and
   under every stream probed. `guardFamilyJ` (`Enumerate.hs:264-274`)
   is the only production that reads a namespace name (`Get nm`), and
   the standing world declares no guards — so the suite's own world
   could not have hosted this row under ANY menu or utility. That is
   the second reason menu-independence went untested, and it is not
   the one the opening gave.
2. **A menu-less evidence tick is REFUSED under a guard** — `tick
   refused: missing declared [move]`, because the guard sentence needs
   `move` bound and the empty assignment is not a legal environment.
   Evidence must therefore fold AT an act. Rather than let the
   reference round-trip the engine's answer, `r8a` **pins** that every
   evidence tick reported the head; the reference folds there because
   a row says so, not because the suite assumed it.
3. **At the prior the two acts agree exactly.** The guard family
   carries every ordered pair `(a, b)`, `a /= b`, at equal charge, so
   the prior predictive is symmetric in the two branches and
   act-independent by construction. The window opens only under
   evidence. The declared one-tick stream `[0]` sits strictly inside
   it: `p0` is `0.125` at the menu head and `0.12351694915254237` at
   the chosen act, a separation of `1.4830508474576272e-3`.

The utility is **act-blind** (`["var", 1]`, the atom value), so the
row does not rest on OB-24's challenger-assignment convention: the
non-head wins on the beliefs alone, and OB-24 can be re-ruled without
touching r8.

The row is four-sided on purpose. `chooseEU` falls back to the head
(`maybe o0 fst picked`), so a row asserting only the vector would pass
while the head quietly won — `r8b` is what stops that. And `r8d`
asserts the window's nonemptiness BEFORE its negative half, because
the negative half is a red that cannot fire if the two
vectors coincide.

`r8` is a POST-IMPLEMENTATION row, so its red is a seeded defect
rather than the red run — the r4c/r2b precedent, where the mandate
round bought rows after the implementation landed and the matrix
supplied their reds. **M72** (`readout-at-menu-head`) is the designed
killer: it computes the vector at `feats ++ head opts` instead of at
the chosen act, which is **byte-identical to the shipped host on every
world with a single-point menu** — which is exactly why no standing
mutant could reach the claim.

#### The probe's own defect, recorded

The window search's first cut reported "non-head won: **False**" on
every trial and made the window look empty when it is wide. Its
detector built the act field with the `p1` rendering (`show
(fromRational v :: Double)` → `"-1.0"`), but the wire renders acts
through `rNum`, which prints an integral Double as an Integer →
`"-1"`. **The detector matched nothing and could not have reported a
win.** Same shape as the matrix runner's `rror:` grep, one step
further out. It is written into `Readout.hs`'s `actField` comment so
the next reader inherits the lesson rather than the bug.

### VII.2 Five findings that would have frozen

| # | finding | disposition |
|---|---|---|
| **P1** | **The wire patch cited `r2b` twice as the pin for the HOST's carrier convention** — in the identity table, and emphatically in the 6.4 paragraph ("That identity is a pin's subject here, never an assumption"). This increment's OWN kill matrix had already falsified it: `r2b` asserts over `refAgent`, the oracle's carrier, and M71 leaves it green (V.3). The mandate round corrected the row and did not propagate the correction into the frozen-document patch that cites it. | REPAIRED: the pin is now the seven wire rows M71 kills; `r2b` is named as the reference side. One step from a manifest-frozen document — the same shape and the same distance as the stale `Enumerate` citation |
| **P2** | **`Readout.hs` still carried its opening DRAFT banner** — "THIS FILE IS THE ORACLE-PHASE DRAFT AND HAS NOT BEEN EXECUTED … Every execution-bearing clause is therefore OWED and none is claimed" — while line 44 of the same file read "This partition is MEASURED … not predicted". The file was about to enter `MANIFEST.sha256` declaring itself unexecuted and unfreezable | REPAIRED: replaced by an EXECUTION STATUS banner with the falsified words quoted inside it |
| **P3** | **The red partition named `r5d`, a row that exists nowhere in the tree.** The `r5` group has three cases; `r5d` occurred exactly once in the whole repo, in this list — a phantom introduced when the list was widened for `r4c` | REPAIRED, with the phantom named |
| **P4** | **`1-verify.sh`'s as-built-==-prophecy check was a gate that could not fail.** `diff … && echo …`: under `set -e` a failure on the LEFT of `&&` does not abort, so a prophecy MISMATCH printed its diff, skipped the confirmation, and fell through to "ALL CHECKS PASSED" with exit 0. The rehearsal could not see it — the diff matched, so the defect lived entirely on a red side that had never been exercised. In the one check this kit was assembled to add | REPAIRED (bare `diff`, `set -e` catches it), and the repair is demonstrated TWO-SIDED against the same seeded corruption of `prophecy.diff`: the old `&& echo` form ran to completion with **exit 0**, the repaired form **exits 1** and never reaches "ALL CHECKS PASSED". The first attempt at that demonstration was itself a red that could not fire - the `sed` anchor matched no line, so the prophecy was never corrupted and the gate "passed" for the third time. Caught by checking, which is the only thing that ever catches it |

| **P5** | **The pack's "zero non-L4 lint failures" (VI.2) was false, and the sitting would have hit it.** `L5` requires the newest `*author-pack.md` to record all four stanza flags; `readout-author-pack.md` recorded only `-Werror`, so **three L5 rows were failing on the committed tree** — invisible inside a wall of 26 L4 failures, which is precisely how a claim like that gets made. The operational consequence is the sharp part: `2-freeze.sh` splices the stanza, applies three `[RULING]` patches and rewrites the manifest, and only THEN runs the lint and its `grep -q "0 FAIL"`. The author's sitting would have died at step 7 with the tree already half-frozen, no undo script, and the double-run guard refusing a second attempt | REPAIRED: the pack now spells out `-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`. **The full lint is now 0 FAIL, 0 WARN on this machine, L4 included** — the first clean lint this increment has had, because thinkpad has a real `ssh-keygen` and all 26 tags verify here |

Two smaller ones, both repaired: the manifest's `M7*.patch` glob also
matched `audit/mutants/M7-ties-to-challenger.patch`, a stranger from a
previous increment (now anchored to the digit-then-dash shape — a glob
that silently captures a stranger is hand-enumeration wearing a
sweep's clothes); and `1-verify` wrote `/tmp/readout-asbuilt.diff`
unconditionally and never removed it (now a `mktemp`).

**Not a finding, checked and dismissed:** the gate-5 and lint
transcripts ride the freeze commit un-hashed. That is the battery's
declared convention for the same artifacts and for the same reason
(the lint transcript is written after the manifest is re-signed and
cannot be hashed at all). The readout kit inherited the convention
without restating it; a comment now does.

### VII.3 One item routed forward, not repaired here

`src/PropLang/Host.hs:387` comments the no-utility branch as
`-- wait: the option space's head`. That branch is `Left o0` — the
EXTERNAL arm, which fires the decide reply — and the legend three
lines above defines `Left act` as "an external assignment fires" and
`Right waitH` as the internal act winning. The charter, the pack and
`3-sign`'s tag message all inherited the error ("the single-point menu
takes the wait branch"). The conclusion those texts drew is
nonetheless correct — `chooseEU` is unreachable without a utility —
but the stated mechanism is wrong.

The line is **bd0d70c's own text**, so editing it would put a
comment-only hunk into `git diff bd0d70c..HEAD -- src/PropLang/Host.hs`
and break the as-built-==-prophecy identity that `1-verify` checks.
Trading that identity for a comment is not a trade worth making. It
enters the **wire docket's next frozen-layer inventory** — the
standing per-sitting channel — and the tag says so.

### VII.4 What this part re-established

Every claim the new rows moved was re-derived, not patched:

- the oracle at **19 rows**, green live under the stanza's exact flags
  and dependency closure;
- the **full matrix re-run over M64-M72** (per-row kill lists shift
  with the row set, so "every kill is readout-unique" is re-earned,
  not inherited) **[2026-08-02: superseded by the third run, over the
  ten-mutant pool; and "every kill is readout-unique" is itself now
  false-as-stated — the declared import M7 reddens the standing
  corpus, which is r8a's finding rather than a defect. IX.5]**, by a
  runner now committed at
  `test-readout/kill-matrix.sh` — increment-local, as the protocol
  requires, and no longer a throwaway that the next boundary cannot
  re-run;
- the kit re-cut for the new row count and the discharged ruling.

### VII.5 The kit re-rehearsed two-sided from a fresh clone

Run on `thinkpad` from a clone of the repo with the increment fetched
into it, so nothing of the working tree's state could carry.

**Green side, END TO END — which the container's rehearsal never
reached.** `1-verify` green (live 19/19 under the stanza's dependency
closure; as-built == the prophecy). `2-freeze` spliced the stanza,
applied all three `[RULING]` patches, ran **gate 5 green on the
spliced tree — twelve suites, `readout` among them, zero FAIL** —
extended the manifest **109 → 136** with a clean post-extension
verify, and finished on **`prefreeze-lint: 0 FAIL, 0 WARN`, L4
included**. The container stopped at that lint and could not go
further: it had no real `ssh-keygen`, so all 26 tags failed L4 and the
three L5 rows (P5) were hidden behind them. This machine has one, so
the row that was noise there is signal here, and it is the reason P5
was found at all.

**Red side, both guards.**

- A second `2-freeze` was REFUSED: `GUARD: readout stanza already
  spliced - refusing to run twice`, exit 1.
- `3-sign.sh` edited AFTER `2-freeze` hashed the kit was REFUSED at the
  manifest re-check, **before any key act**: exit 1, `HEAD` unchanged,
  no `readout-freeze-r0` tag in the clone. The decline-by-editing order
  is enforced mechanically, not by convention.

The one thing this rehearsal still cannot exercise is `3-sign`'s key
act itself: the author's key is not on this machine (the only `~/.ssh`
keypair matches neither `allowed_signers` row), so `thinkpad` is a
builder shell and not the author's. Everything up to the signature is
now proven on a fresh clone; the signature waits for `steel`.

> **[2026-08-01, later the same day — the last sentence above is no
> longer true, and the manifest figure has moved.]** The author asked
> whether they could sign HERE. They can, and do: `thinkpad` became an
> author shell at `8b85edb`, and the signature no longer waits for
> `steel`. The count `109 → 136` was true of the rehearsal recorded
> above and became `109 → 137` when `SITTING.md` joined the manifest
> glob at `e86fefc`. Both are historical record and stand as written;
> **Part VIII** is the round that changed them.

## Part VIII — the custody round: signing from `thinkpad`

Executed 2026-08-01, after Part VII closed, on the author's question:
*"I'm not on steel and don't have its key, can I sign here instead?
How?"* The answer is yes, and this part is the record of what that
took. It is the only part of this increment whose subject is the
**custody root** rather than the oracle, and it is therefore the part
that most needs reading before the tag rather than after it.

Four commits: `8b85edb` (custody), `e6ca692` (the signing precheck),
`e86fefc` (the sitting sheet and the recovery path), `e970a73` (the
sheet's own register command). None of them touch `src/`, the oracle,
or any manifest-hashed artifact's CONTENT — the two kit scripts they
edit are hashed by `2-freeze` as run, which is the mechanism working
as designed, not around it.

### VIII.1 The author identity gains a SECOND key, one per shell

`allowed_signers` had two rows, `author` and `builder`, under one git
identity. The author row held **one** key, `SHA256:Sfh8OBG9…`, and it
lives only on `steel`, which is unreachable. A third row was added:

```
author   SHA256:vxt+FccnN/4Z/6kmg0v/rvNWe1qK4jtVTzGsM8ogeX0   (thinkpad)
```

`~/.ssh/proplang-author-thinkpad` — a **fresh, dedicated** ed25519
key, deliberately not the machine's general `~/.ssh/id_ed25519` auth
key, so an attestation can never be minted as the side effect of an
authentication flow. It is passphraseless because `3-sign.sh` signs
non-interactively; the protection is the file mode and the machine,
which is the same posture `steel`'s key has always had.

**Why this is key management and not a relaxation.** The custody rule
says the author countersigns *"from their own shell."* A key is that
identity's **instrument in a shell**, not the identity. The edit is
append-only and was checked to be so, three ways:

- **All 26 prior tags re-verify.** Run after the edit, and re-run
  fresh while writing this part: **26 verified, 0 failed** — each
  still checked against the key that actually signed it. Adding a row
  widens what verifies; it cannot retroactively re-attribute anything.
- **`allowed_signers` is not manifest-frozen.** It appears in no
  `MANIFEST.sha256` row, so no gate is disturbed and no freeze
  boundary is required to touch it.
- **Nothing asserts on its contents.** Swept `tools/`, `test*/` and
  `src/`; the only consumer is git's own
  `gpg.ssh.allowedSignersFile`.

**The delegation path was not used, and was not available.** The
protocol's escape — the builder tags with the BUILDER key and records
the delegation verbatim — requires the builder key, which is on
**neither machine** (the container never had it either; builder
commits have been unsigned by design and say so). And it would not
have helped: a builder signature truthfully attests builder action
under instruction and *cannot mint an author attestation*. That bar is
on the key's role, not on the shell.

**The independent reason to do this at all**, which outlives this
sitting: until `8b85edb` the attestation identity was **single-key**.
A lost `steel` meant nothing could ever again be signed as author, and
26 tags' worth of chain would have had no continuation. A
one-key-per-shell author identity is the fix, and an unreachable
machine is a cheap way to have discovered it.

**What the author ratifies by signing.** The `allowed_signers` edit is
an author act on the custody root that a *builder* executed, on the
author's explicit answer to a posed question (fresh dedicated key;
named in both the tag and `allowed_signers`). The tag is where that
becomes attested. It is named here rather than left implicit.

### VIII.2 Two operational hazards closed

**The signing precheck now runs in the READ-ONLY script.** `3-sign.sh`
is the last of three, so a shell that cannot sign discovered it only
*after* `2-freeze.sh` had spliced the stanza, applied three `[RULING]`
patches and rewritten the manifest. `1-verify.sh` now asks the
question in front of the mutations: `user.signingkey` set,
`gpg.format` = `ssh`, the key can actually produce a git-namespace
signature, and the key is **in `allowed_signers`** — that last because
a tag signed by an unlisted key verifies for nobody, which is strictly
worse than not signing. Demonstrated both ways (green on the
configured key; red on an unset one and on a key absent from the
file).

**`2-freeze.sh` had no undo and a guard that refuses a retry.** Any
mid-way failure left the tree spliced, patched and re-manifested with
no documented way back. The reset is now in `SITTING.md` and was
**tested**, not merely written: reset to a clean tree, then `2-freeze`
ran again to completion without tripping its own guard.

```bash
git checkout -- proplang.cabal membrane-wire.md OBLIGATIONS.md CLAUDE.md MANIFEST.sha256
rm -f test-readout/freeze/gate5-run.txt test-readout/freeze/lint-transcript.txt
git status --short          # expect clean
```

This is the hazard P5 would have sprung for real: the three hidden L5
rows failed at `2-freeze` **step 7**, after everything step 7 cannot
undo.

### VIII.3 The sitting sheet, and its own two defects

`SITTING.md` is the six-step command sheet the author runs. Written in
this round — and then found to carry two of the exact shapes this
increment has spent its whole pre-tag read convicting.

**(i) A range that never closed.** Step B pointed at the CW register
with `sed -n '/^CW1/,/^CW8/p' 3-sign.sh`, commented *"the eight
defaults"*. `CW8` occurs **mid-line** in the tag message ("…OB-row
caught it. CW8 the TWO-TAG form"), so `/^CW8/` never matched, the
range ran to end of file, and the command printed **120 lines** — the
whole tag message plus the rest of the script. It isolated nothing
while reading as though it had: the output looked like success because
output appeared. Repaired at `e970a73`, the falsified command quoted
in its own repair. Step B now names **both** forms of the register and
says which to rule from — `EXACT_PLAN` §15.4's table carries the
QUESTION column, the tag message carries only the answer — with both
ranges pattern-anchored and verified to terminate (12 and 16 lines).
Neither uses absolute line numbers, which is the very provenance
question this increment carries to the sitting as its one ruling
sought.

**(ii) A stale count in a forward-looking expectation.** Step C told
the author to expect the manifest to go **109 → 136**. That was true
of the Part VII.5 rehearsal and became **137** when `SITTING.md`
itself joined the manifest glob at `e86fefc` — a document that changed
the number by being written. Recomputed against the globs as they
stand: **137**. Nothing *asserts* on the figure (`2-freeze` prints it
and greps nothing), which is precisely the residual row's disease from
the mandate round: a printed number no row defends. Corrected in the
sheet; VII.5's occurrence is historical record and carries a dated
bracket instead.

> [2026-08-02, the second conferral] **THIS PASSAGE WENT STALE IN
> EXACTLY THE WAY IT DIAGNOSES, AND WAS CAUGHT BY THE CONFERRAL IT WAS
> SENT TO.** The sentence "Recomputed against the globs as they stand:
> **137**" was true when written at VIII.3 and was falsified inside the
> same day by the 3c disposition round, which added `r-d20i-anchor.patch`
> (+1 through `freeze/*.patch`) and `M7-ties-to-challenger.patch` (+1,
> hashed by name). **The count is 139**, verified against the script's
> own argument list: 109 existing rows, 30 added, zero overlap. Only
> `SITTING.md` was updated at the time; this passage was not, so the
> pack and the sheet disagreed by two rows in front of the author at
> the moment of an irreversible step. The conferring reviewer read the
> pack, quoted 137 faithfully, and returned it in the run instruction.
>
> A section titled "a stale count in a forward-looking expectation"
> that itself carried a stale count in a forward-looking expectation is
> not an irony to enjoy — it is **the fourth instrument-side defect**,
> and it lands in the same layer as the other three: the machinery that
> REPORTS, never the thing reported. The conferral's own summary
> enumerated three and drew its OB-27 argument from the count; the
> count was four, and the fourth was in the document making the
> argument. The repair is recorded rather than swapped, per this pack's
> own convention, so the sequence stays legible: **134 → 136 → 137 →
> 139**.
>
> **THE REVIEWER'S OWN DISPOSITION, AT THE REVIEWER'S REQUEST.** The
> second conferral asked that its part be recorded plainly, and it is:
> the conferring reviewer relied on a pack-quoted figure where the
> ruling it had itself made that same sitting — R-D20-i's amendment,
> anchor by commit hash and binding name, provenance never re-derived
> in parallel — obliged it to recompute against the artifact. The
> reviewer who ruled the binding-name anchor into standing law then
> relied on a bare number. Recorded because the adversarial discipline
> binds the sitting authority exactly as it binds the builder, and does
> not lapse because the miss belongs to the authority.
>
> **THE STEP-7 HAZARD WAS CHECKED AND DOES NOT EXIST.** The conferral's
> operative instruction was to confirm no gate expects 137, since a kit
> hashing to 139 against a gate expecting 137 stops at step 7 — after
> the irreversible splice. Checked across `1-verify.sh`, `2-freeze.sh`,
> `3-sign.sh`, `prefreeze-lint.sh` and `boundary-audit.sh`: **no gate
> hardcodes a row count anywhere.** Lint L3 derives it —
> `"$(wc -l < MANIFEST.sha256) rows verified"` — and asserts only that
> `sha256sum -c` passes; `2-freeze`'s re-sign line likewise prints
> `len(rows)` and greps nothing. The single `1xx` literal in the kit is
> `~403 and ~140` in a 3-sign comment, naming CLAUDE.md line offsets,
> not a count.
>
> That result has a sting in it, and it is the same fact from the other
> side. The reason no gate can fail on 139-vs-137 is precisely the
> reason the figure drifted for a day unnoticed: **nothing asserts on
> it.** VIII.3(ii) says so in its own next sentence — "a printed number
> no row defends" — and then the number it printed went undefended.
> The step-7 stop was never available to catch this; only a human
> reading two documents could, and both documents were wrong in one of
> them. That is the strongest available argument for OB-27's scope
> reaching PROSE and not only harness gates, and it is now measured
> rather than asserted.

Both were found by re-reading the sheet as an adversary rather than as
its author, which is the same move that bought Part VII's five.

### VIII.4 What is still NOT exercised, stated rather than smoothed

**`git tag -s` itself has never been run in this session.** The
harness classifier blocks `3-sign.sh`, and that is *correct* — the
action IS the author's attestation, and the protocol vests it in the
author. What can be said: it is the same `gpg.format=ssh` code path as
the `-S` commits in this round, all of which verify **Good** against
the new key, so the mechanism is proven even though that exact call is
not. The gap is one command wide and it is the author's command.

**The tag message asserts "all 26 prior tags were re-verified."** That
is a measurement with a timestamp, not an invariant. It was true when
taken and re-measured 26/0 while writing this part. The author's own
`git tag -v readout-freeze-r0` at the sitting is the check that
counts, and `1-verify`'s new precheck is what makes it fail loudly
rather than quietly.

**Commit signatures in this round used the thinkpad AUTHOR key**,
because it is the only key in this shell — the builder key is on no
machine Claude Code has run on. This is recorded rather than glossed:
the commits are builder work, their messages say so, and **the tag,
not any commit signature, is the attestation**. No commit signature in
this increment should be read as author review.

### VIII.5 Re-rehearsed from fresh clones, twice

Both after `e6ca692` and after the sheet landed. `1-verify` green
including the new row — `signing key OK:
SHA256:vxt+FccnN/4Z/6kmg0v/rvNWe1qK4jtVTzGsM8ogeX0, present in
allowed_signers`. `2-freeze` green: stanza spliced, three `[RULING]`
patches applied, **gate 5 twelve suites zero FAIL**, `manifest
re-signed over 137 rows`, clean post-extension verify,
**`prefreeze-lint: 0 FAIL, 0 WARN`**, L4 included. Then the recovery
path exercised on purpose: reset, clean tree, `2-freeze` again to
completion. Scratch clones deleted.

Everything up to the signature is proven on a fresh clone, **from the
shell that will sign it**. That is the sentence VII.5 could not write.

### VIII.6 The staleness sweep, and FL-3

Prompted by VIII.3's two: if the sheet carried a stale figure, what
else does. The universe is DERIVED, not hand-listed — `git diff
--name-only bd0d70c..HEAD`, **32 files** — and swept in three
mechanical classes.

**Class 1 — counts.** Every occurrence of a row count, manifest count,
mutant-pool range and suite count. Four hits, all in the pack, all
**historical rather than wrong**: V's `M64-M71` pool line, V.5's
`readout at 15 rows`, VI's `109 → 134`, VII.5's `109 → 136`. Each is a
true record of its own round. Two were nonetheless repaired, because
being historically true is not the same as reading that way: **V.5 is
headed "Gates, as built"**, and a standing-sounding heading over a
superseded figure is the worst place for one; and **V's pool line
disagrees with the committed transcript beside it**, since the matrix
was RE-RUN over M64-M72 rather than extended. Both now carry dated
brackets, and V's bracket maps the manifest figure across all three
rounds so 134/136/137 is a sequence rather than a puzzle.

> [2026-08-02] A FOURTH ROUND EXISTS AND THIS SWEEP PREDATES IT. The 3c
> disposition added two manifest rows, so the sequence is
> **134/136/137/139**. The staleness sweep that convicted three stale
> figures went stale itself within the same day — which is the precise
> reason such a sweep is dated at its head and RE-RUN at the boundary
> rather than trusted once. Recorded, not swapped. See VIII.3(ii).

**Class 2 — cited commit hashes** (the recorded-repairs rider: a
recorded repair cites its hash, and the checklist verifies the hash
touches the file the row names). Five distinct hashes cited:
`9790089`, `8b85edb`, `e6ca692`, `e86fefc`, `e970a73`. **All five
resolve and all five touch the file their row names** — `9790089` →
`Host.hs`, `8b85edb` → `allowed_signers`, `e6ca692` → the two kit
scripts, `e86fefc`/`e970a73` → `SITTING.md`. Clean.

**Class 3 — line-number citations.** Fourteen distinct. Thirteen
resolve to what the pack claims. `Enumerate.hs:467` resolves to a
blank line and is CORRECT usage — it is the mandate round's F4, quoted
as the falsified text inside its own repair. The two exceptions are
Part I.2's, and they are the interesting ones: `Host.hs:425` and
`:516` were true of `bd0d70c` and are false of `HEAD`, because the
implementation this pack prophesies moved them. Repaired in place with
the anchor and the binding names, and the bracket there says why —
this is **the one ruling sought, with a live instance in the pack that
asks for it**. The increment applied its own proposed remedy to the
oracle's copy table and not to its own prose.

#### FL-3 — the recorded-repairs rider names a mechanism that does not exist

Reported, not repaired here.

The rider (`CLAUDE.md`, the dyadic clause, ruling 2) reads: *"a repair
recorded in a pack CITES ITS COMMIT HASH in the repair row, and **the
pre-freeze checklist verifies every cited hash touches the file the
row names** — recorded repairs are verified against the tree,
**mechanically**, so the stale-green class dies structurally."*

There is no such row. `tools/prefreeze-lint.sh` is L1-L7 (forbidden
tokens, ASCII names, manifest, tag signatures, SAT flags, grid
re-declaration, full-corpus overlay build); `tools/boundary-audit.sh`
is M5-row, H-row, OB-row, banked-failure row. **None reads a cited
hash.** The clause's first half is honored by convention and its
second half — the mechanical half, the half the word "structurally"
rests on — is prose describing a script that was never written.

This is mandate 2's shape with a twist: not a ruling asserted and
never derived, but a ruling that **names its own enforcement and does
not have it**. The battery boundary's no-silent-caps finding is the
near precedent (cited three times, defined nowhere); the difference is
that this one has a definition site and the definition is false of the
tree.

Class 2 above discharges the rider **by hand for this increment**, 5/5
— so nothing here is unverified, and the sitting is not blocked.

Disposition is the author's. `tools/` is manifest-frozen, so a lint
row is a `[RULING]` patch under the author's key at a boundary, not a
builder edit. Three ways to close it, in the order I would recommend:

1. **Route to the r1 catch-net or the next boundary** — the mechanism
   is a dozen lines (`grep -oE` the hashes per pack, `git show
   --stat` each, assert the intersection with the row's named file is
   nonempty), but a NEW lint row landing between `2-freeze`'s manifest
   rewrite and its `grep -q "0 FAIL"` is the P5 hazard by
   construction, and this sitting has no reason to take that risk.
2. **Land it here** as a fourth `[RULING]` patch, if the author wants
   the law true of the tree at the boundary that noticed it. The row
   can be written and demonstrated two-sided before `2-freeze` runs.
3. **Amend the clause** to say what is actually done — a checklist
   item rather than a script. This is the honest option only if the
   mechanization is judged not worth its cost; the rider's own
   argument ("structurally") is against it.

Recorded here so the choice is made rather than inherited.

---

## Part IX — the sitting's rulings, executed (2026-08-02)

The conferral round returned rulings on all four open items. This part
records what was executed under each, and what each cost to establish.
The register CW1-CW8 was accepted as drafted; the four items below are
the ones that moved work.

### IX.1 The ruling sought (3a) — R-D20-i AMENDED, not extended

Ruled standing law in the binding-name form. The clause is not a new
one: **R-D20-i already mandated provenance and specified it as
`file:line`** — so the honest form of the ruling is an in-place
amendment with the falsified phrase quoted inside its own repair (the
frozen-layer inventory's form for normative prose), rather than a
fresh clause sitting beside a stale one.

The anchor is **the commit hash plus the binding name**; where the
citation must point at an anonymous expression, the **quoted
expression text** is the anchor. A line number may accompany as a
convenience and is never the referent. The carve-out matters: without
it, the rule is pious where it is most needed, because not every
citable site is a named binding.

Patch: `test-readout/freeze/r-d20i-anchor.patch`, applied by `2-freeze`
as step 4b. **Its scriptable half is deliberately not written** — it
routes with FL-3 as OB-26/27, per the ruling.

**The kit gained a check because of this patch, not merely a patch.**
Two patches now touch `CLAUDE.md` (`r-red-id` at ~403, `r-d20i-anchor`
at ~140), and `1-verify`'s per-patch `git apply --check` tests each
against the UNPATCHED tree — which is not the tree the second one
meets. The battery kit hit this exact shape and checked its pair
sequentially on a temp copy; this kit now does the same, and asserts
the ordering rather than assuming it (later-in-file first, so the
earlier hunk's context stays where its header says). Verified: the
pair applies sequentially, zero fuzz, both clauses present after.

### IX.2 FL-3 (3d) — disposition 1, with the condition met as OB-26

Routed forward, and the conferral's hard condition is the substance of
the ruling: **not a pack sentence**. A routed obligation living only in
prose is the recorded-repairs rider's own disease wearing a new hat, so
FL-3 lands as **OB-26**, state `SCHEDULED@readout-freeze-r0`, with the
OB-19 heir increment NAMED as its home boundary.

That state string is not decorative. `tools/boundary-audit.sh` row 3
flags every `SCHEDULED@X` row whose target tag exists — so from the
moment `readout-freeze-r0` is cut, OB-26 is surfaced by a script at
every subsequent boundary audit until it is discharged. The routing is
mechanized even though the check it routes is not yet written; that is
the most this sitting can honestly buy.

The row carries the builder constraint verbatim from the conferral: the
L8 increment's own freeze kit must order the manifest re-hash AFTER the
new row exists, or it seeds the exact defect class it closes.

### IX.3 The harness-gate scope note — OB-27

Routed with OB-26 to the same boundary, one CLAUDE.md touch. The
triptych clause was canonized for ORACLE ROWS; the pre-tag read's
finding (d) shows the reasoning applies to the INSTRUMENT as well, and
the clause's text does not say so. Recorded, not written here.

### IX.4 CW5 — the "no" stands, and WHY it stands is now on the record

Confirmed as drafted, with the addition the conferral asked for: the
"no" was chosen **because the alternative is unbuilt, not merely
undesired**. A "yes" would assert behaviour that lives nowhere in the
corpus today and only in the printed residual, and a residual is not a
specification — so a "yes" owes a row and could not have closed this
sitting. Recorded so that a future boundary wanting readout-on-think
knows it is NEW CONSTRUCTION under its own gate, and not a flag flip.

### IX.5 The UNREACHED rows (3c) — dispositioned PER ROW, not as a batch

The ruling was explicit that a batch waiver would not be signed
around: for each row, either grow a mutant that reaches it (preferred
— the pool gap is the finding) or record why it is structurally
unreachable. Both halves were done, and the discriminator turned out
to be mechanical rather than a matter of judgement.

**The partition, DERIVED not hand-asserted.** A `src` mutant can only
reach a row that reads the shipped reply. Partitioning the seven rows
by whether their body calls `replay`/`replayAll` at all:

```
r1a   READS-WIRE          r5a   reference-only
r2b   reference-only      r5b   reference-only
r4a   reference-only      r7b   reference-only
                          r8a   READS-WIRE
```

Five of the seven never read the wire. Their subject is the
REFERENCE — `refVec`, `agentObsPoints (refAgent …)`, `capQ` — and the
declared pool's universe is patches against `src`. Their UNREACHED
verdict is therefore a true statement about a category difference, not
a symptom of a thin pool, and this is the same reading the matrix
already gave r2b after M71 left it green.

That leaves exactly two rows where "the pool is deficient" was a live
hypothesis. Both were tested by execution rather than argued.

**r8a — REACHABLE, and its killer was in the tree all along.** r8a pins
that the F10 world's evidence tick reports the MENU HEAD, which holds
because the two acts agree exactly at the prior and the tie resolves to
the head. That is a property of the SELECTION path, so no readout
mutant can reach it. `M7-ties-to-challenger` inverts `chooseEU` at
precisely that tie: applied, the oracle goes **2/19 — r8a and r8b, and
nothing else**. r8a is not a green that cannot fail.

M7 also reddens the standing corpus — **`pins` and `trampoline` both
FAIL** — so its kill is NOT readout-unique, and that is the finding
rather than a defect in the import. r8a imports a premise that
standing rows already pin, and makes it a CHECKED FACT inside the
oracle, where the reference depends on it. The pool gap was real and
structural: **the readout pool contains only readout mutants, so a row
pinning a selection premise is unreachable by construction.**

In the regenerated matrix r8a moves **UNREACHED → SHADOWED** against
the whole corpus, and **EARNED against the STANDING corpus** (unique
vs standing: M7) — what it buys is a premise no pre-r8 row covers.
r8a and r8b shadow each other against M7 exactly as r8c/r8d do against
M72, and for the same reason: they differ in the DIRECTION of a
test-side assertion, and a test-blind src mutant cannot separate them.
Structural shadowing is an answer, not a failure.

The blanket phrasing of the previous two rounds — "every kill
readout-unique" — is **false as stated from this round on**, and is
corrected everywhere it appeared: the matrix reading, `1-verify`'s
summary label, and the freeze commit message. Every OTHER cell's
standing corpus is green.

M7 joins the pool as a **declared import** — named individually with
its reason in `kill-matrix.sh`, not swept in by widening the glob. The
distinction is the pre-tag read's own lesson: the anchored
`M7[0-2]` shape exists precisely because a bare `M7*` captured this
same stranger silently. A declared import is the opposite move — a
stranger admitted on the record.

**r1a — reachable in principle, tautological in practice, and that is
the finding.** r1a asserts the three v1 fields on the plain route.
`M8-entropy-sign-dropped` mutates `entropyOf`, which feeds
`entropyAgent` — and r1a stays green at **19/19**, because r1a compares
the wire against `entropyAgent`, *the same function that renders the
wire value*. Both sides move together. Its p1 clause has the sibling
defect: the natural killer M70 (p1 repointed at the argmax) is
invisible on r1a's world, because the binary tied prior makes
p1 == p_argmax — a margin artifact, R-RED's own disease, in a row whose
world cannot be changed without changing what it attributes.

So r1a's value clauses cannot fail under `src` mutation. Its real
content is **rendering presence**, and its real job is the attribution
partition's GREEN half, discharged at the red run and frozen in
`opening/red-run.txt`. **Recorded as a row-VALUE question for r1**, not
repaired here: relabel the clauses as presence pins, or move them off
the margin. Under the dyadic clause a row-value ruling is the author's
and never a pool obligation.

**The per-row table.**

| row | disposition | basis |
|---|---|---|
| r1a | rendering-presence pin; value clauses tautological under src mutation. Row-VALUE question routed to r1 | MEASURED: M8 probe 19/19 green; M70's standing cell kills r7a only |
| r2b | RECORD row, already convicted-and-relabelled in-tree; the HOST's carrier is pinned by M71's seven killers | matrix + in-tree comment |
| r4a | precondition guard for r4c: proves the prior HAS ties so the tie rule is exercisable. Reference-only | derived partition |
| r5a | RECORD row, convicted by mandate 1: a THEOREM (a weighted average of a declared grid is at least its minimum), unfalsifiable by any readout defect | in-tree comment |
| r5b | reasoner-concentration measurement (the (M) mark); no readout mutant reaches it. Reference-only | derived partition |
| r7b | guard for r7a: proves the world discriminates p1 from p_argmax, so M70's kill of r7a is meaningful rather than accidental. Reference-only | derived partition |
| r8a | REACHABLE — M7 kills it (2/19). Premise-import row; UNREACHED → **SHADOWED**, and **EARNED vs the standing corpus**. The kill is not readout-unique and that is the point | MEASURED: M7 cell; standing `pins` + `trampoline` FAIL |
| residual | RECORD row, already disposed under the F6 precedent | prior round |

Deleting any of r4a / r7b / r8a turns its sibling into a row that
passes on an assumption — which is the failure mode each exists to
close. No deletions are proposed.

### IX.6 What the pool growth cost, and what it caught

**The matrix runner's restore was narrower than its pool's reach.** It
read `git checkout -- src/PropLang/Host.hs` in three places, true only
because every pool member happened to patch that one file. M7 patches
`Membrane.hs`: under the narrow restore it would have survived its own
cell and **contaminated every later cell in the run**. The bug was
latent from the first matrix and became reachable the instant the pool
grew — the runner-level sibling of the green that cannot fail, found by
the very pool growth it exists to serve, and the second instrument-side
instance of that shape in this increment after the pre-tag read's
finding (d). Fixed to `src/` in all three places plus the final
byte-identity check.

The full matrix was re-run over the grown pool rather than the new cell
being appended: per-row kill lists are pool-relative, so "every kill is
readout-unique" had to be re-earned rather than assumed. A verdict is
pool-relative and a pool is grown, never assumed — that clause is why
the whole matrix reruns.

**And the same shape a third time, caught by running the kit.** Once
the import made the standing verdict load-bearing, `1-verify`'s matrix
summary had to print it — so the grep was widened. The widened pattern
also matched the READING prose below the cells and printed
"…standing corpus is GREEN…" **directly beneath M7's REDDENED line** —
a summary asserting the opposite of the cell it sat under. Tuning the
pattern again would have been the same bet; the region is DELIMITED
instead (`sed` from the cell header to `=== matrix done`), so prose
cannot leak in whatever it later says. Three instrument-side defects
this increment — finding (d), the runner's restore, and this — all of
them in the machinery that reports, none in the thing reported. That
is the argument for OB-27 in one sentence.

### IX.7 The verdict table is now DERIVED

The `PER-ROW VERDICTS` block was hand-transcribed in the first two
rounds. It is now computed from the cells by script, with the row
universe taken from the oracle's own run rather than from the cells —
a row that no mutant kills appears in NO cell, so deriving the universe
from the cells would make UNREACHED rows invisible, which is precisely
what the table exists to surface. The residual RECORD row appears in
the table for the first time as a result.

### IX.8 The run-sheet's figures are now DERIVED, and the gate caught two defects in itself

Built at the author's instruction after the second conferral, in answer
to "we must gate all assertions, no?" — and the answer taken was **no,
not all**. The standing enforcement ladder already says climb as high as
it goes and leave prose only for what provably cannot climb; gating
every sentence mints greens nobody red-tested, which is this
increment's own disease wearing a helpful face. The narrow rule taken
instead:

> **A figure a human reads and acts on at an IRREVERSIBLE step must be
> derived, not typed.**

`109 → 137` was exactly that. `134 → 136` inside a dated historical
bracket is not, and freezing it would be wrong.

**Two figures now derive.** `1-verify` extracts `2-freeze`'s own
manifest argument list and its own `git apply` sequence — never a
second copy of either, since two lists of the same thing is the drift
that cost this increment a round (R-D20-i: copy, do not reconstruct).
The patch loop no longer holds a hand-written list at all: divergence
between what `2-freeze` applies and what `1-verify` pre-checks is now
**unsayable** rather than gated, which is the higher rung. Absent that,
a patch added to the apply sequence and forgotten in the loop would
reach the irreversible step never once `--check`ed.

**A fifth stale figure, found by building the gate.** Step A read
"**three** patches apply clean" and had been wrong since
`r-d20i-anchor.patch` landed. Nothing defended it either. Corrected in
place, not swapped.

**And the gate broke twice, in this increment's exact signature shape.
Both were caught by executing the reds, not by reading the code.**

- **RED 8 — the guard was dead code.** `patches=$(grep … | awk …)`
  returns 1 when grep matches nothing, and under `set -euo pipefail`
  the ASSIGNMENT aborts the script before the `[ -n "$patches" ]`
  guard can speak: a silent death after the boundary-audit line, no
  `STOP`, and no `ALL CHECKS PASSED` either. **A guard that cannot
  fire, inside the gate written to cure guards that cannot fire.**
  `|| true` is load-bearing and was bought by that red.
- **RED 6 — a row that could never fire.** The orphan-patch row was
  ordered after the manifest-figure row, but an orphan also bumps the
  derived count, so the figure row always fired first and reported
  "139 vs 140" — the orphan caught, misdiagnosed, and its own row
  structurally unreachable. Rather than record a shadowed row, the
  order was changed so the precise diagnosis wins.

**Eight reds, eight distinct diagnoses, each executed:** sheet behind
kit · kit ahead of sheet · manifest block moved · step C's sentence
moved · applied patch missing on disk · orphan patch present · sheet's
patch word disagrees · apply sequence vanished. Green confirmed on the
real tree end to end. Reds ran on a throwaway clone (R-D21); the clone's
trailing `user.signingkey is unset` is the `e6ca692` guard doing its job
in a fresh checkout and confirms execution ran past the new rows.

The lesson is the one OB-27 is routed to install, now with its sharpest
data point: **the reds are what find this class.** Neither defect was
visible on the page. Both were obvious the instant the check was made
to fail.
