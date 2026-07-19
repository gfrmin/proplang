# wire-author-pack — the wire boundary's running pack

Opened 2026-07-20 at `7da274b` (`reflexive-freeze-r0`). Custody: builder,
under the author's fresh instruction of 2026-07-20 — "open boundary and
implement" — recorded verbatim; R-D22 obligations tracked in
WIRE_PLAN.md §8. This pack accumulates per-step; each W-step's sitting
materials append.

## Part I — W1, the opening measurement

### 1. Pre-statement (copied verbatim from the scratchpad original,
written BEFORE execution; the evidence-program clause's requirement)

Program 1 (contrast-context p1, issue #5): namespace `[t, risk, m]`,
guard `risk@[0.5]`, menu `m@[0.0]`; 60 ticks, evidence perfectly
correlated with alternating `risk`; probes attack `{t:61, risk:1}`,
benign `{t:61, risk:0}`, empty `{}`. Gates: **C1** discrimination
S >= 0.4; **C2** flat-defect replication S < 0.05 (pauses W3/W4,
boundary pivots to diagnosis); partial band 0.05 <= S < 0.4 (author
reads before W3); **C3** ceiling p1_attack <= 0.9 + 1e-9. p1(empty)
recorded, no gate.

Program 2 (ms/tick, issue #6): the four pinned populations
(1169 Enumerate.hs:329; 1241 Sentence.hs:288; 1529 Unify.hs:125;
1601 Unify.hs:126), configs COPIED from the frozen suites (R-D20-i),
models count asserted against the hello reply; hello ms + ms/tick over
100 observed ticks, wire-inclusive. No pass/fail gate — the program
creates the instrument issue #6 names as missing. Non-comparability of
the demolished engine's 8.26 ms/tick figure pre-declared.

### 2. Execution transcript (throwaway prototype, `ghc -O2 -isrc`,
zero src diff, 2026-07-20)

```
== Program 1: contrast-context p1 ==
hello reply: {"ok": true, "proto": 1, "models": 1241, "namespace_bits": 1.5849625007211563}
training ticks: 60, non-scoring replies: 0
attack probe reply: {"act": {"m": 0}, "p1": 0.8970592646390182, "entropy_bits": 0.3851090819310064}
p1(attack risk=1) = Just 0.8970592646390182
p1(benign risk=0) = Just 0.1029407353609769
p1(empty)         = Just 0.10294073536097696
S = p1_attack - p1_benign = 0.794119
C1 PASS: discrimination (S >= 0.4); C3 PASS: p1_attack <= 0.9 (ceiling confirmed)

== Program 2: ms/tick at pinned populations ==
pop 1169  (pin OK)  hello     0.0 ms      9.415 ms/tick
pop 1241  (pin OK)  hello     0.3 ms     10.254 ms/tick
pop 1529  (pin OK)  hello     0.0 ms     14.436 ms/tick
pop 1601  (pin OK)  hello     0.4 ms     14.603 ms/tick
```

Readings, as pre-stated:

- **C1 PASS at S = 0.794** (theoretical max on the shipped grid 0.8).
  The STRUCTURAL half of the flat-p1 finding (HOSTS_H_REPORT.md:167)
  does not hold of the re-derived engine: it is a genuine function of
  context when signal is present. SCOPED per the mandate-5 review:
  synthetic risk-bit contexts, not the govhost corpora — the
  host-corpus differential stays open until a host exists to run it.
- **C3 PASS at 0.897**: issue #4's structural ceiling confirmed by
  measurement — W3 is load-bearing, not cosmetic.
- p1(empty) equals p1(benign at t=61, risk=0) only to ~6e-17 — NOT
  bit-equal, because the t-guard families read the explicit t=61. The
  clean semantic fact is `Get`-absent = 0.0 (Eval.hs:80): empty is
  bit-equal to the EXPLICIT all-zeros context. Pinned that way
  (test-measure g1 row b), not as the near-coincidence.
- Timing: 9.4-14.6 ms/tick (prototype, -O2). The suite instrument was
  then REVISED at the sitting per mandate-6b (the laziness leak: the
  hello reply forces only the population count, deferring agent
  realization into the first tick — the naive hello window read
  0.0-0.4 ms, impossible, and the first tick overpaid). Figures of
  record from the revised instrument's first green run (stanza -O,
  machine-relative): setup (hello + first tick) 11.6 / 12.5 / 18.4 /
  18.6 ms; steady-state 9.90 / 10.92 / 14.43 / 15.12 ms/tick at
  1169/1241/1529/1601. Interactive governance budgets clear. **The
  "build only if slow" gate is now falsifiable and does not fire.**

### 3. Satisfiability / red-reachability record (pin-freeze form)

Step-10's amended clause governs: capability pin, no implementation
owed, red by seeded defect with attribution partitioned.

- g1 row a (discrimination): red reachable by dropping `FGuardHead` —
  executed live as row c, which holds the SAME stream flat
  (|S| < 0.05) under the guard-free fragment. Attribution partitioned:
  discrimination comes from the guard families and nowhere else.
- g1 row b (empty = all-zeros): red reachable by probing `t=61`
  zeros instead of true zeros — executed in the transcript above
  (differs, ~6e-17): the row discriminates.
- g2 rows (population pins): red reachable by any grid edit — the
  frozen 1529 -> 1601 step (test-unify/Unify.hs:125-126) is the
  standing demonstration.
- g2 timing halves are REPORT rows by declaration (issue #6's adopted
  disposition); their gate half is the population pin in the same
  test. Two-sided-instrument clause satisfied by that split.

First green run: `cabal test measure` — 7/7 (g1 3, g2 4), stanza's
exact flags (-Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns), first run after one unused-import -Werror
rejection (the flag set doing its job; no logic change).

### 4. Boundary-audit output (the standing event, run at this opening)

```
M5-row: FLAG D-g5 cited 4 times, candidate definition lines: 0
H-row:  FLAG gauss / observe_batch / residual_mean / residuals
        appear only in wire/membrane docs, no resolution site
note:   test-writeup/check.sh G2 asserts 8 cabal stanzas; cabal now
        has 14 (dated red-by-design instrument, recorded)
```

Re-run at the freeze after the opening's edits: `M5=0 H=4 OB=0` — the
D-g5 flag cleared (the boundary's own texts carry definition-shaped
lines the screen now sees) and the new OB-row fires clean on the
seeded ledger. Original triage kept below for the record.

Triage (flags are inputs, never verdicts): D-g5 is a step-10 sitting
ruling — definition expected in the step-10 pack's ruling table, prose
form the grep cannot see; carried to the W2 sitting for the human
sweep. The four H-row symbols live in membrane-wire.md's HISTORICAL
sections (bracketed at :175-183 as binding on nothing current) — the
flags are the historical bracket working as intended; no action. The
G2 stanza-count note gains one more stanza (measure, 15) at this
freeze — same dated instrument, same record.

### 5. W1 disposition

test-measure/ lands (g1 discrimination + semantics + attribution
control; g2 instrument), stanza `measure` appended to proplang.cabal,
WIRE_PLAN.md opens the boundary, manifest extended and re-signed.
Issues #5 and #6 close at this freeze with their measurements; #4's
severity is upgraded from "structural claim" to "measured at 0.897".

## Part II — W2, the owed law and the frozen-layer sitting

### 1. The VoI evidence program (gate derivation; R-D21)

Pre-stated: measure the floating-point floor of
`VoI(b, n) = v_think(b, n; price=0) − v_act(b)` over the frozen
step-10 composition (formulas copied from
test-reflexive/Reflexive.hs:83-126), across (i) 50,000 `fromBits`
beliefs (bits pseudo-random in [0, 20] over the 9 theta points,
deterministic integer hash — no RNG) × batch n ∈ {1, 2, 3}, and
(ii) 5,000 evidence-conditioned walks (0-12 obs) × the same n. The
gate is then the measured floor with margin (the CL-4 lesson), never
a round guess.

Transcript (throwaway prototype, `ghc -O2 -isrc`, zero src diff):

```
fromBits family:  n = 150000, min VoI = -1.1102230246251565e-16
cond-walk family: n = 15000,  min VoI = -2.7755575615628914e-17
theta points: [0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9]
```

One ulp of cancellation dust. **Gate: -1e-13** (three orders of
margin; same derivation pattern as the step-2 observeCounts gates,
1e-11 from measured 2.83e-13). Landed as test-law/ g1 (two
QuickCheck properties over the same two families + the seeded
single-arm defect, red at -0.36, kept live as its mirror). First
green run: `cabal test law` 3/3 under the stanza flags, after one
unused-import -Werror rejection (no logic change).

The debt this pays: AGENT_PLAN.md:1121-1126's step-9 row, the
project's remedy for its deepest diagnosed defect (VOI computed
negative, AGENT_PLAN.md:41-49). The mechanism that produced the
original defect is deleted (the five VoI verbs, step 9); this pins
that the composed successor cannot reproduce it.

### 2. The frozen-layer repairs (issue #7 + the doc halves of #1/#3/#8)

BUILDER-EXECUTED under the recorded delegation, in advance of and FOR
the author's sitting — no author has sat; every frozen-file mutation
below is covered by the R-D22 obligation in WIRE_PLAN §8 and becomes
law only at the author's countersignature (the mandate-5 review's
"sitting" finding, adopted: the word is reserved for the author's
event; this section is the builder's preparation of it). Forms per
text class, falsified sentences quoted inside their own repairs:

| doc | form | content |
|---|---|---|
| WRITEUP.md honesty #4 | dated in-place repair | "no arithmetic / 2u-1 unsayable" falsified at step 1; the debt it named was PAID; accidental-virtue measurement stands as history |
| AGENT_PLAN.md progress register | dated in-place repair | "steps 3-10 open" -> the signed tag list, steps 3-10 all closed; the tag list is the register |
| boundary-queue.md | HISTORICAL bracket | queue superseded by per-increment packs; item 5 (arithmetic-free boundary) abolished by step 1 |
| HOSTS_PLAN.md | HISTORICAL bracket | engine demolished at step 3; surviving content = demand shapes, re-registered as issues #9-#14 on WIRE_PLAN §5 |
| HOSTS_H_REPORT.md | HISTORICAL bracket + two dispositions | theta-grid "frozen alphabet-data change" false since step 1 (W3 is a host change); flat-p1 re-measured at W1, does NOT reproduce |
| membrane-wire.md §2 utility bullet | dated in-place repair | said@1 pricing/latent sentences overstate; truth of the wire until W4 re-states; the promised sentences bind W4's oracle |
| membrane-wire.md §3 head | dated statement | THE SHIPPED DECISION RULE IS MYOPIC; the ladder is a capability pin, not wire behavior, until W4c |

## Part III — root causes (the author's question, answered)

Three independent fresh-context researchers, one failure class each
(the red-team execution mode); WIRE_PLAN.md §2 carries the distilled
rulings. Condensed findings with artifact indexes:

### RC-1 — incorrect documentation (rc-docs)

The frozen-layer inventory — the repo's ONLY doc-repair mechanism —
is scoped frozen-only + increment-local + ruling-named. Consequences,
case by case: WRITEUP honesty #4 was falsified at step 1, FOUR
boundaries before the inventory clause existed, so no sitting ever
owned it (its step-7 blanket note delegated enumeration to
test-writeup/check.sh, whose record rows never covered arithmetic).
AGENT_PLAN.md's register and HOSTS_H_REPORT.md are UNFROZEN — zero
coverage by design (D-c6 scoped unfrozen docs out explicitly). The
membrane-wire said@1 claim NEVER HELD: landed at step 8 (2bf2a9e)
already false, latent@1-era vocabulary asserted of a path that never
built it — aspirational doctrine-carryover, not decay. The step-8/9
anti-staleness instruments (overlay build, rulings-sweep) police test
files; a false .md sentence builds against nothing. Compounding
silent overload: "arithmetic-free" shifted from "no operators" (CIRL
close) to "no formula meta-language" (step 8) — outcome-author-pack
re-asserts the boundary "holds" at the exact commit adding the
operators. Index: membrane-wire.md:79-86, Host.hs:348-380,
WRITEUP.md:389-402, check.sh record rows, AGENT_PLAN.md:855-862
(sole edit aa279be), c4aa9bb (the one-commit historicization that
bracketed membrane-wire's tail and skipped both HOSTS docs).

### RC-2 — the g4Self disease (rc-voi)

The VoI row was carried CORRECTLY to step 9's opening checklist
(outcome-author-pack.md:1013-1016; AGENT_PLAN.md:1121-1126) — and
dissolved AT step 9: tracked as a parenthetical inside a 3-property
composite whose other two members were already satisfied at step 6,
so the composite read "mostly done"; the step-9 pack then promoted
the row's own caveat ("pinning a verb the same increment deletes
would be a pin written to die") into its disposition — reading a
ROUTING instruction (pin over the surviving Expect) as a DON'T-PIN
ruling — and moved it to the dies-with-its-subject table with an
empty subject column (elim-author-pack.md:128). Decisive: step 9's
§13 register has D-f rows for every other checklist item and NONE
for VoI. The step-6 deferral CLAIMED retire-until-N form
(stream-author-pack.md:639-644) but its delegated AGENT_PLAN edit
folded the row into a bundle (:1641-1644). Contrast g4Self, which
survived the identical journey with (a) a register ruling at the
retiring freeze (D-a6), (b) a standalone bold checklist row
(AGENT_PLAN.md:924-929), (c) an explicit discharge event (:954).
BUNDLING IS WHAT KILLED IT. Remedy installed at this opening:
OBLIGATIONS.md (atomic rows, greppable states) + the OB-row in
tools/boundary-audit.sh (flag open obligations against closed
boundaries — run at step 9's close it fires instantly on the VoI
row).

### RC-3 / RC-4 — the grid ceiling and the myopic wire (rc-wire)

Neither is neglect; both are DELIBERATE decisions whose delivery
paths died, with stale records hiding the deliberateness.
The grid: the "frozen alphabet-data change" classification
(HOSTS_H_REPORT, 0b7b188, 2026-07-09) was true when written; two
days later 0170a40 parameterized the enumeration (for boundary R's
re-enumeration primitive — the AGENT's purchase mechanism, not host
declaration), and the author's directive of 2026-07-11
(METAREASONING_PLAN.md:30) CONDEMNED host-declared theta grids as a
category error, :216 "No emission grid key. No vocabulary
declaration of any kind." The sanctioned alternative (V→R) was then
cancelled (v-cancelled, ea891f0) and never built.
The wire: myopia ruled on the record (HOSTS_PLAN:920 register 12 —
engine-swap parity, "the myopic case is the ladder's chosen rung";
:889 the 8.4 baked assumption) and DOCUMENTED at
membrane-wire.md:214-224 — inside the sections bracketed HISTORICAL
at step 7, which is why the live spec read silent. Upgrade routes
closed: D0 skipped (R-D2), V cancelled. choose landed at step 7
(b85426d) as a node-for-node PilotEU copy; the step-10 pack never
mentions Host.hs (pin through evalx, zero src diff — nothing owed).
THE CROSS-CUTTING SPINE: boundary V's cancellation (2026-07-15)
orphaned BOTH remedies. The audit issues (#4, #8) each saw the
mechanism and missed the standing ruling — which is itself RC-1's
finding recursing: the rulings live in unfrozen or historical
documents. Dispositions: rulings R-W1 and R-W2 (WIRE_PLAN §5),
evidence assembled, decisions the author's.

## Part IV — the red-team mandates (this opening's sitting)

Execution mode per the step-6 clause: fresh-context reviewers, one
mandate each, over the boundary's uncommitted diff.

- **M1 (theorem-as-definition): NO FINDING.** The VoI property's two
  sides are independent Expr trees (vThinkS never references vActS);
  the inequality is emergent and the seeded defect proves it can go
  red. The discrimination ablation is a real removal-of-cause test.
  Two flags passed to coverage (not M1 findings): the VoI test
  catches likelihood UNDER-normalization but an over-count would
  inflate v_think and stay green; the attribution row's "nowhere
  else" compares the wire route (full) against the library route
  (guard-free) — closed only insofar as the two routes agree
  elsewhere. Both recorded here as candidate future rows, not
  blockers: the property pins non-negativity, not calibration, and
  the g3-optlaw suite pins wire/library agreement of the population.
- **M2 (ruling asserted, derived zero): FINDING, RESOLVED IN-WINDOW.**
  Caught RC-1..RC-4 relied on (once in a file being frozen —
  Law.hs's RC-2 cite; boundary-queue's ledger cite) while §2/Part III
  were still placeholders. Resolved before the tag: §2 and Part III
  filled from the three research reports; every RC cite now resolves.
  The reviewer's snapshot was mid-drafting — the finding is exactly
  what the mandate exists to catch had the tag come first.
- **M3 (quantity defined nowhere): FINDINGS, RESOLVED IN-WINDOW.**
  (a) 0.4 gate: rationale now stated (half the grid's achievable 0.8
  separation) at Measure.hs header. (b) 0.05 flat band: measured
  margin now RECORDED — guard-free S = 0.0 exactly, executed at the
  sitting, reported live by the row itself (testCaseInfo). (c) 1241
  cite corrected to Sentence.hs:287. (d) Law.hs sampled-domain caveat
  added (bits [0,20]; n in {1,2,3} = the shipped batchCap domain).
  The -1e-13 gate, populations, and ceiling were found properly
  provenanced.
- **M4 (type without derivation): NO FINDING.** Zero-src-diff
  verified; new files export only main, no new surface types.
- **M6 (what is it a function of): ONE REAL FINDING, FIXED
  IN-WINDOW.** The timing instrument's hello window excluded agent
  realization (laziness deferred it into the first tick; the 0.0 ms
  hello readings were the tell). Instrument restructured: SETUP
  (hello + first tick, forced) and STEADY-STATE (next 100 ticks) as
  separable windows; build-mode/machine dependence now declared in
  the emitted string. Also 6-a (dependence declared only in the
  pack): fixed by the same annotation.
- **M5 (silent overload): ONE SUBSTANTIVE FINDING, ADOPTED.**
  attack/benign/empty reused the govhost corpus vocabulary while
  measuring synthetic risk-bit contexts — the "does not reproduce"
  claim was licensed by the name collision. All three claim sites
  (WIRE_PLAN §1, pack Part I, HOSTS_H_REPORT bracket) re-scoped to
  the structural claim; the corpus re-run stated as open,
  host-gated. Moderate finding on "sitting" adopted (Part II §2
  re-headed: builder-executed, author's sitting owed). Minor "S"
  collision noted in Measure.hs. Pin-freeze reading ruled in-terms
  (cited loudly, seeded-defect red present); the reviewer's
  observation that W1 stretches "pin to a reference route" toward
  "clears a measured bar" is recorded here for the author's eye.

All six mandates ran; three found real defects; all three are fixed
inside the freeze window and re-witnessed green (`cabal test measure
law` after the fixes). The mandate mechanism paid for itself at its
second firing.

## Part V — the freeze transcripts

Pre-freeze lint at the tag (0 FAIL, 10 pre-existing advisory WARNs):

```
PASS  L1 forbidden-tokens-by-glob: 6 src files clean
PASS  L2 ASCII test names across test*/
PASS  L3 MANIFEST.sha256: 69 rows verified
PASS  L4 all 36 tags verify
PASS  L5 wire-author-pack.md records the four stanza flags (incl. -Werror)
PASS  L7 full-corpus overlay build: every test .hs builds against new src
```

`cabal test all`: 15/15 suites PASS (the thirteen standing + measure
+ law). Boundary audit at the freeze: M5=0 H=4 OB=0. Zero src/ diff
across the whole boundary opening (mandate-4 verified).
