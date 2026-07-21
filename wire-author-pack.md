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

## Part VI — the rulings sitting (2026-07-20, in-session)

The author put the question directly ("The input to and the output
from the agent should be crystal clear by now. Let's confirm we're
aligned, by you stating them"), the builder stated the alignment,
the author confirmed verbatim: **"i confirm"**. The confirmed
statement is recorded as ruling text of record at WIRE_PLAN.md §5
("The alignment statement"). The exchange that produced it, for the
record:

1. The author's grid argument, which DEFEATED the builder's recorded
   recommendation (ii) for R-W1: the grid approximates a CONTINUOUS
   latent — the world does not have nine thetas — so any finite grid
   is the agent's representational choice, and there is no
   world-side fact for a hello key to state. The builder conceded on
   the spot; the concession is in the R-W1 ruling record. The same
   argument convicts the baked `thetaPoints` (Host.hs:261) — held as
   a bracketed interim operating point until R.
2. The author's depth argument for R-W2: if the ladder is a
   composition of the alphabet, depth should be decided by
   metareasoning, not defaulted — which is CLAUDE.md porting order
   4's own doctrine ("the myopic case must be the ladder's chosen
   rung, not a branch"), sharpened to reject W4c's HOST-SIDE rung
   assembly as the wrong home. Depth is an in-language purchase,
   clock-priced, delivered at R.
3. The unification, confirmed: both rulings instantiate one
   invariant — the world declares economics, never epistemics;
   everything between input and output is internal and purchased.

Acts executed at the sitting (all under the "i confirm" delegation,
author re-tag OWED per R-D22, WIRE_PLAN §8):

- WIRE_PLAN.md §5: R-W1 RULED (i)+(iii-interim), R-W2 RULED
  (depth-by-metareasoning at R), the alignment statement installed
  as ruling text; §3 riders (W3 = arity only; W4c STRUCK); §6/§8
  custody rows.
- OBLIGATIONS.md: OB-4 DISCHARGED-BY-RULING; OB-5 note (arity
  only); OB-9 re-homed SCHEDULED@r-open; OB-10 re-repair shape
  ruled; OB-17 (R opens by author tag over R_SCOPE.md) and OB-18
  (METAREASONING_PLAN re-derivation, banked-failure expiry) born.
- membrane-wire.md §3 bracket: conditional resolved in place
  (myopic until R).
- R_SCOPE.md drafted (R0 re-derivation audit → R1 vocab → R2
  depth), kept OUT of the manifest until the author's R-opening
  tag.
- Manifest re-signed for the three amended frozen files (69 rows,
  row count unchanged — no file added or removed).

### Pre-freeze lint at wire-rulings-r0

```
PASS  L1 forbidden-tokens-by-glob: 6 src files clean
PASS  L2 ASCII test names across test*/
PASS  L3 MANIFEST.sha256: 69 rows verified
PASS  L4 all 38 tags verify
PASS  L5 wire-author-pack.md records the four stanza flags (incl. -Werror)
PASS  L7 full-corpus overlay build: every test .hs builds against new src
=== prefreeze-lint: 0 FAIL, 10 WARN (the same pre-existing advisories) ===
```

Manifest 69/69 OK after the three-row re-sign. Zero src/ diff at
this sitting (docs + ledger + scope draft only).

## Part VII — W3, the arity increment (oracle phase, opened 2026-07-21)

Scope of record: OB-5 — "observation arity declarable at the handshake
(K-ary carrier/space), default binary" — arity ONLY (the grid half died
with R-W1). Zero alphabet productions (WIRE_PLAN §4: W3 moves
enumerator data and space data). The banked HOSTS-era claim "K-ary is
NOT a grammar change" (HOSTS_PLAN §4.1) postdates no alphabet motion it
assumed — but per the step-10 expiry clause it is RE-EXECUTED here
anyway: the SAT phase writes the K-ary emission as a sentence of the
SHIPPED grammar and compiles it; the transcript in VII.5 is the
re-execution.

### VII.1 The design

**The declaration.** `world` gains one optional key: `"obs_arity": K`
— finite, integral, K >= 2, else bad hello (fail-closed; the D-f8/NaN
door discipline). Absent => the shipped binary path, byte-identical
(that code path is not edited). Semantics is R-W1's ruled line,
verbatim: *the wire may declare the codomain of observation — what the
channel can emit — never the support of belief about the channel's
law.* The codomain is atoms 0..K-1.

**The null-atom convention (builder-derived, for the author's
endorsement at the freeze).** Atom 0 is the null emission; a
sentence's distinguished atom is POSITIVE, j in {1..K-1}. Grounds,
all already pinned wire law: (a) W1's measured pin "a missing feature
reads as 0.0; the empty stream IS the all-zeros stream"
(test-measure g1, Eval.hs:80); (b) the fragment's own reading —
bern(theta) prices the positive event, guards modulate its RATE;
(c) the wire's p1 diagnostic and observe's refusal row both treat 0
as the background pole. Consequence: the arity mention is priced
log2(K-1) — ZERO at the default, exactly the M1 namespace law's
singleton shape ("0 while singleton", Enumerate.hs:296-298). The
default's prices do not move, by the same law that priced guards.

**The family (sentences of the shipped grammar; zero productions).**
At arity K, distinguished atom j, rate theta:

    P(y = j) = theta;  P(y /= j) = (1-theta)/(K-1) uniformly.

The body is composed: If/Gt (the step-9 eqE composition), ToR, Div,
Sub, constants through the one mkC door; the atom code j and the
constant K-1 come from grids DERIVED FROM THE DECLARED ARITY (world
data, not steering literals — the tauGrid/namespace precedent). At
K=2, j=1 this is bernBody's extension exactly, and bit-exactly in
floats ((1-theta)/1.0 == 1-theta in IEEE); the RENDER differs (Gt vs
the eqE spelling — two spellings of one sentence). Families mirror
the fragment: consts (K-1)x|eg|, walks (K-1)x|rho| (theta walks, atom
fixed), guards (K-1)x per-name (context switches theta, atom fixed);
j is the OUTERMOST loop per family (a fresh coordinate, D2, recorded).
Charges: each K-tree is CSum <the shipped tree> (CBits jB),
jB = 0 when K=2 else log2(K-1); chargeBits' fold (Syntax.hs:394) is a
left sum, so the appended +0.0 is bit-exact at the default.

**Routing.** Declared K (any K >= 2, including 2) routes through the
arity enumerator; the ABSENT key routes through the shipped call,
untouched. Declared-2 vs absent is then a COINCIDENCE THEOREM, not a
branch — pinned extensionally per the optimisation law's shape
(section 1b: a divergence is legal only if pinned to the general
route): dl multiset bit-equal, emissions pointwise bit-equal, wire
replies byte-equal on a shared stream.

**Surfaces.** Enumerate.hs: `obsSpaceAt :: Int -> Space Obs`;
`enumerateSentencesArity :: Int -> NonEmpty Double -> Namespace ->
[(Name, Grid)] -> [FragProd] -> [Hyp]`; declared K-charge trees
`constChargeA/walkChargeA/guardChargeA` (the step-4 doctrine: the
oracle pins the trees themselves; the shipped `constCharge`/
`walkCharge`/`guardCharge` are frozen-test-imported and untouched);
`Agent` carries its observation space (new field; constructor is NOT
exported, so no surface outside the module sees it),
`sentenceAgentK :: Space Obs -> [Hyp] -> Agent` with
`sentenceAgent = sentenceAgentK obsSpace` definitional, and
`agentObsSpace :: Agent -> Space Obs`; predictive/observe/
observeCounts/observeVia read the agent's space (extensionally inert
at default — the field IS the old constant there). Type-derivation
line (the section-8c audit, arriving WITH the type change): the
agent's observation space is the codomain the world declared at the
handshake — wire-declarable world structure under R-W1's ruled line.
Host.hs: hello parses/validates the key; K present => arity
enumerator + sentenceAgentK (obsSpaceAt K); tick's p1 reads
agentObsSpace. Purchase.hs is UNTOUCHED (the R1 purchase law is the
binary channel's; arity-vs-purchase composition travels with the
host-wire integration residue, already declared at R1's close).

### VII.2 The demand's honest scope (issue #9's register lines)

Delivered: the declared codomain; per-atom concentration sentences;
the namespace-law pricing of the atom mention; the default untouched
and re-pinned. NOT delivered, each with its ground: (a) host-supplied
tabular log-densities — that is the world declaring the channel's
LAW, i.e. epistemics over the wire, refused by the alignment
statement (the world declares economics, never epistemics); the law
lives in-language as the family above; (b) mid-episode K growth —
issue #10, OB-11, RULING-PENDING, untouched here; (c) the
preposterior over K observations — composes in-language via Expect
(step 10's theorem), not W3 scope; (d) answer-brain's P_NONE = 0.5
prior — the dl-prior prices null-reading sentences by derivation;
the host sets no priors (HOSTS_PLAN §4.2's line, still binding);
(e) [added at the freeze sitting, ruling 1, 2026-07-21] the
null-dominant sparse channel at K >= 3 — with the spread uniform
over the K-1 non-distinguished atoms INCLUDING the null, the null
atom's predictive mass is structurally capped at 1/(K-1) for every
sentence and every mixture, so a channel that mostly emits nothing
has no good hypothesis in this family and never will. This is the
correct minimal, Cromwell-safe choice (the one-versus-null
alternative buys the sparse channel at the price of hard zeros on
the other atoms, which g4b rightly forbids), and it is a DECLARED
LIMITATION in the R-D23 sense: the richer family — a second,
null-rate parameter — is its named, demand-gated heir. At K=2 the
cap is vacuous; nothing shipped is touched.

### VII.3 The oracle (test-arity/, 8 groups)

g1 the default re-pin (the optimisation law's re-pin, same
increment): (a) the four populations 1169/1241/1529/1601 through
serveLine hello — worlds COPIED from test-measure/Measure.hs:207-213
(R-D20 provenance); (b) declared-2 == absent: hello + 6-tick stream,
replies byte-equal pairwise. g2 the coincidence pin: (a) count and
dl multiset of the arity-2 enumeration bit-equal (w64) the shipped
enumeration's; (b) paired emissions pointwise bit-equal over probe
features x y in {0,1}; (c) spacePoints (obsSpaceAt 2) == spacePoints
obsSpace. g3 pricing: (a) at K=5 a cat const's dl == its declared
tree == shipped dl + log2(4) (formula provenance: the M1 law,
Enumerate.hs:296-298); (b) strict monotonicity K=3 < 5 < 9;
(c) K=2 tree bit-equal the shipped tree (w64). g4 the law's shape:
(a) enumerated masses match the closed form (theta at j, spread
elsewhere) at K in {3,5,10}; (b) Cromwell — every atom's mass
strictly positive at every grid theta. g5 behavior: K=4 worlds —
(a) a stream concentrated on atom 2 makes MAP the (j=2,
theta=0.9) sentence, render string pinned (derived from the frozen
renderExpr in SAT); (b) a uniform stream leaves every cat sentence
below a measured posterior bound — strict discrimination between
the two worlds. g6 conjugacy as oracle: K=3 consts-only world, hand
Bayes over (j, theta) — prior read from the enumerated hypBits
themselves (R-D20: never re-derived), likelihood the closed form —
vs agentMeta, gate from measurement. g7 wire: (a) obs_arity 4 =>
models == (K-1)*1169 == 3507; (b) y=3 observed => finite loss_bits,
y=7 => impossible-evidence; (c) bad declarations (1, 2.5, 1e999) =>
bad hello; (d) p1 == P(atom 1) cross-checked against predictive.
g8 ablation (data-form: the family is world-data-gated — the
deletable-and-declarable criterion; no production entered, so no CPP
row is owed): restricted enumeration (drop FBern => consts empty at
K; drop FGuardHead => guards empty), plus test-arity/ablation/run.sh
— the seeded-defect tripwire (spread divisor K-1 -> K) reds g2b and
g4a while Cromwell stays green (attribution partitioned, the R1
run.sh precedent).

### VII.4 Under-determination register (for the freeze sitting)

1. The null-atom convention and j in {1..K-1} (VII.1's grounds) —
   author endorsement owed.
2. The key's name and placement: flat `"obs_arity"` in `world`.
3. j-outermost enumeration order (fresh coordinate, D2).
4. The VII.2 scoping lines as the recorded answer to issue #9's
   remainder.
5. Frozen edits owed AT the freeze, under delegation: membrane-wire
   §2 (the key, with R-W1's line quoted) and §3 (p1 = P(atom 1) at
   any arity); WIRE_PLAN §8's three stale OWED marks (discharged by
   wire-rulings-r1, author key, 2026-07-20 — the frozen-layer
   inventory's first W3 row); MANIFEST + cabal stanza + OBLIGATIONS
   OB-5 -> LANDED@wire-w3.
6. observeCounts at K > 2 keeps its (n1, n0) reading as counts of
   atoms 1 and 0 — the collapse verb is inherently binary; a K-ary
   collapse verb is future demand, not smuggled here.

### VII.5 The satisfiability transcript (R-D21, overlay form)

Overlay realization: a full copy of src/ wearing the real module
names (Enumerate + Host implemented per VII.1), under the scratchpad,
discarded after this transcript. The EXACT oracle text of
test-arity/Arity.hs as drafted for the freeze compiles UNCHANGED
against both the stub src and the overlay, under the stanza's exact
flag set `-XGHC2021 -Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns` (flag-faithful, -Werror included — the
step-5 amendment).

**Red run (real src, oracle-phase stubs): 18 of 21 rows FAIL.**
Attribution per row: g2a/g2b (enumerateSentencesArity stub error),
g2c (obsSpaceAt stub error), g3a/g3a-wg/g3b/g3c (charge-tree stub
errors), g4a/g4b, g5a/g5b, g6, g7d, g8a/g8b (stub errors through
their entry point); g7a (ignored key: models 1169, wanted 3507),
g7b (ignored key: binary world calls y=3 impossible — the red IS the
missing codomain), g7c (ignored key: obs_arity 1 accepted). Every
red is the missing implementation; no stub shadows a defect.
**Green at stub, by design (the re-pin rows):** g1a (four
populations through the wire), g1b (declared-2 byte-equal absent —
green today because the key is ignored, green after because the
coincidence is a theorem; its red capability is the ablation's
demonstrated firing, below), g8c (the shipped 1169).

**SAT run (overlay realization): 21 of 21 rows PASS**, same text,
same flags. Per-row forcing (the step-2 deepseq clause): every
comparison lands on a scalar (Double via w64/Integer, Int count, or
String) whose (@?=) forces both sides to normal form; g2a's two
sorted dl lists are forced end-to-end by the list equality; no lazy
structure survives a row.

**Gate floors measured on the overlay (the CL-4 discipline):**
g4a max deviation 5.551115123125783e-16 over every (K, j, theta, y)
cell at K in {3,5,10} — gate 1e-12 (~3.3 orders margin); g6 max
deviation 1.1102230246251565e-16 — gate 1e-12; g5b uniform-stream
top mass 6.2024897563036765e-2 (deterministic fixture) — bound
0.125 = 2x measured; the concentrated world's MAP mass > 0.5 and
its index is 17 = (j=2 block, theta=0.9), the declared coordinate.
g5a's render literal derived by executing the FROZEN renderExpr on
the overlay's enumerated (j=2, theta=0.9) sentence — a copy through
the frozen artifact, not a parallel derivation (constants render as
grid-name + index: ('c','theta',8) is theta=0.9, ('c','km1',0) is
the K-1 constant).

**The seeded-defect runner (test-arity/ablation/run.sh), fired
against the overlay:** the spread denominator K-1 mutated to K at
the single W3-ANCHOR site; g1b REDS (the declared-2 coincidence
breaks), g2b REDS (arity-2 diverges from shipped), g4a REDS (the
law's spread off by (K-1)/K), Cromwell stays GREEN — attribution
partitioned. The render pin deliberately does NOT fire (renders
carry grid name + index, not value): the mutation is visible only
extensionally, which is why the extensional pins are load-bearing.

**The banked-claim re-execution (the step-10 expiry clause):**
HOSTS_PLAN §4.1's "K-ary observation is NOT a grammar change" was
banked before the step-8/9 alphabet motion. Re-executed here: the
K-ary emission body is written as a sentence of the SHIPPED grammar
(If/Gt equality composition, ToR, Div, Sub, mkC constants over
world-derived grids) and compiles + scores on the overlay with zero
productions touched. The claim SURVIVES re-execution — the verdict
is stronger post-demolition than when banked (the family needs no
Model layer at all; it is enumerator data end to end).

### VII.6 SAT findings (repaired before the freeze, in-window)

1. **The g7d mirror defect (the SAT window's catch).** The drafted
   mirror built its agent on namespace [t] against a wire world of
   [t, m] and probed the predictive at feats ++ menu-name. Both are
   wrong: the namespace mention reprices every guard sentence
   (structural divergence, w64-visible at the 8th decimal), and the
   wire's p1 is computed at the tick's FEATURES, pre-act. Repaired:
   the mirror declares [t, m] and probes at features only. The row
   now doubles as the probe-discipline lesson: a mirror is subject
   to the same world-declaration the wire is.
2. **g5b's drafted bound was under the measurement** (0.05 drafted,
   6.2e-2 measured): a plucked bound, caught by the transcript and
   re-derived as 2x measured. The row's teeth are the strict
   concentrated-vs-uniform ordering plus the bound.
3. **g5a's placeholder replaced** by the renderer-derived literal
   (above), per the drafted derivation plan.

### VII.7 The freeze sitting (2026-07-21) — the author's rulings,
recorded verbatim

The author ruled on the VII.4 register, in its order. The rulings
below are the author's words, unedited; the builder's execution
notes follow in brackets where an edit was ordered.

> **1. The null-atom convention — endorsed, with the strongest
> ground promoted to first place.** The three cited grounds are
> consonance; the *forcing* ground is the K=2 anchor: g2b demands
> the arity-2 family be `bernBody` bit-exactly, bernBody's
> background is 0, and the convention is then the unique extension —
> any other null atom breaks the coincidence theorem before it is
> stated. Record it as forced by the anchor, corroborated by the
> three pinned laws, with the pricing consequence (log2(K-1), zero
> at the default by the M1 singleton shape) as the derivation it
> is. And the endorsement carries one *addition to the scoping
> lines*, because the family's shape has a printable consequence
> nobody has printed: with the spread uniform over the K-1
> non-distinguished atoms *including the null*, the null's
> predictive mass is structurally capped at 1/(K-1) for every
> sentence and every mixture — a null-dominant sparse channel at
> K >= 3 (a channel that mostly emits nothing) has no good
> hypothesis in this family and never will. That is the correct
> minimal, Cromwell-safe choice — the one-versus-null alternative
> buys the sparse channel at the price of hard zeros on the other
> atoms, which g4b rightly forbids — but the cap is a declared
> limitation in the R-D23 sense: print it as the fifth scoping
> line, with the richer family (a second, null-rate parameter)
> named as its demand-gated heir. At K=2 the cap is vacuous, so
> nothing shipped is touched.
>
> **2. `"obs_arity"`, flat in `world` — endorsed.** The name states
> the OB-5 language, the placement sits beside the namespace and
> menu where world structure lives, and the fail-closed validation
> (integral, K >= 2, else bad hello) is the D-f8 door discipline
> applied before the defect class can exist. g7c's rejection rows
> are the pin.
>
> **3. j-outermost — endorsed as a declared, recorded coordinate.**
> The D2 lesson is honoured by declaration rather than accident,
> and the choice earns its keep twice: each j-block is internally
> the shipped layout, so the arity-2 block coincides positionally
> with the frozen enumeration, and positions decompose readably —
> g5a's index 17 = (j=2 block, theta=0.9) is a coordinate a
> reviewer can parse without the enumerator. A fresh coordinate
> whose positions carry meaning is the best available outcome for
> an artifact that must be arbitrary somewhere.
>
> **4. The VII.2 scoping lines — recorded as the answer to issue
> #9's remainder, with the tabular-log-density refusal singled out
> as the alignment statement's cleanest application to date.** A
> host-supplied likelihood table is the world declaring the
> channel's *law* — epistemics over the wire, the exact thing R-W1
> exists to refuse — and the family living in-language, priced by
> the one arithmetic, is what "the world declares economics, never
> epistemics" means when it costs something to mean it. Lines (b),
> (c), (d) are correctly homed: mid-episode growth to OB-11's
> pending ruling, the K-preposterior to step 10's composition
> theorem, and the P_NONE prior refused because the dl-prior
> already prices null-reading sentences by derivation and hosts set
> no priors. With the fifth line from ruling 1, the register is the
> honest perimeter of what W3 delivers.
>
> **5. The frozen edits — proceed under the delegation as listed**,
> with one consistency note for the membrane-wire §3 edit: "p1 =
> P(atom 1) at any arity" is the null convention's own corollary
> and should cite it, so the diagnostic's meaning and the
> codomain's background are one recorded fact, not two adjacent
> ones.
>
> **6. observeCounts stays binary-reading — endorsed, with one
> precision the line must carry.** The verb's semantics is fixed
> and remains *lawful* at any arity: it asserts n1 observations of
> atom 1 and n0 of atom 0, and every such assertion is scoreable
> evidence under the K-ary family. What it is *not*, at K > 2, is
> the stream's sufficient collapse — the K-ary family's sufficient
> statistic is per-sentence (count of j versus rest), and a
> two-atom count pair does not summarize a K-ary stream. Say both
> halves: lawful as it stands, insufficient as a collapse, and the
> count-vector verb is future demand under its own gate, not
> smuggled here. A verb whose domain quietly narrowed relative to
> its name is the gBoundary class; the register line stating the
> narrowing is what keeps it out of that class.
>
> For the record beside the rulings: the g7d repair deserves its
> sentence in the pack — *a mirror is subject to the same
> world-declaration the wire is* — as the probe-discipline clause's
> furthest extension yet; the seeded runner's render-pin
> deliberately not firing, with the reason stated (renders carry
> grid name and index, so the mutation is visible only
> extensionally), is the sharpest one-line argument for extensional
> pins this project has produced; and the banked K-ary claim
> surviving re-execution *stronger* than when banked — enumerator
> data end to end, no Model layer even available to change — is the
> expiry clause returning a verdict of innocence for once, which is
> worth as much as its convictions. Freeze on these rulings; the
> transcript is complete and the window has done its work.

Execution notes (the builder, same sitting, under the delegation):
ruling 1's fifth scoping line added as VII.2(e); ruling 6's
two-halves precision is register line 6's recorded reading (lawful
at any arity as an assertion about atoms 1 and 0; NOT a sufficient
collapse at K > 2; the count-vector verb future demand under its
own gate); ruling 5's consistency note applied — the §3 edit cites
the null convention as the p1 sentence's derivation. Frozen edits
executed: membrane-wire §2 (the `obs_arity` bullet, R-W1's line
quoted) and §3 (the p1 corollary bullet); WIRE_PLAN §8's three
OWED marks repaired to DISCHARGED with wire-rulings-r1 named (the
frozen-layer inventory's first W3 row); OBLIGATIONS OB-5 ->
LANDED@wire-w3; the arity stanza into proplang.cabal;
MANIFEST.sha256 extended to cover test-arity/ and re-signed over
the amended frozen files. Transcripts of the pre-freeze lint and
the boundary-audit rows follow in VII.8.

### VII.8 The freeze transcripts (pre-freeze lint + boundary audit,
run at the W3 sitting, 2026-07-21, after the sitting's edits)

Pre-freeze lint (tools/prefreeze-lint.sh, verbatim result line):

```
PASS  L1 forbidden-tokens-by-glob: 8 src files clean
PASS  L2 ASCII test names across test*/
PASS  L3 MANIFEST.sha256: 76 rows verified
PASS  L4 all 44 tags verify
PASS  L5 wire-author-pack.md records the four stanza flags (incl. -Werror)
WARN  L6 x10 (the standing thetaPoints/tauPoints/rhoPoints literal
      advisories in the Phase-1 frozen tests and fixture generators
      — pre-existing, unchanged from the wire-rulings-r0 run)
PASS  L7 full-corpus overlay build: every test .hs builds against src
      (test-arity now stanza'd, so the corpus row covers it; it
      BUILDS against the oracle-phase stubs and is red-by-design
      until W3 implementation)
=== prefreeze-lint: 0 FAIL, 10 WARN ===
```

Boundary-audit rows (tools/boundary-audit.sh; flags are triage
inputs, never verdicts):

```
M5-row: FLAG D-c4 cited 4 times, candidate definition lines: 0
H-row:  FLAG gauss / observe_batch / residual_mean / residuals
OB-row: 0 flagged
note:   test-writeup/check.sh G2 asserts 8 cabal stanzas; cabal now
        has 17 (dated red-by-design instrument, recorded)
=== boundary-audit done: M5=1 H=4 OB=0 ===
```

Triage: the D-c4 flag is the screen's shape heuristic missing a
real definition site — D-c4 is DEFINED at unify-author-pack.md:173
(the step-7 sitting's ruling table; table-row form, not the
definition shape the grep recognizes); cited from E-c3/E-c2 notes
and R_SCOPE.md:137. No action; the flag joins D-g5's precedent
(prose/table definitions are the human sweep's half). The four
H-row symbols are the opening run's known flags, unchanged: they
live in membrane-wire.md's HISTORICAL sections 4-6, bracketed as
binding on nothing current — the historical bracket working as
intended. OB-row clean: no open obligation against a closed
boundary (OB-5's own row moved to LANDED@wire-w3 at this sitting,
which is exactly the state whose target tag does not yet exist).
The G2 stanza note advances 16 -> 17 with the arity stanza — same
dated instrument, same record.

## Part VIII — W4, wire completeness (oracle phase, opened 2026-07-21
after the W3 close at w3-freeze-r1)

### VIII.1 Scope (frozen at WIRE_PLAN §3, as ruled)

(a) `parseSaid` extended to the full priced grammar — Div/Log/Exp/
Neg; `<` composes as swapped Gt, NOT a new form unless ruled.
(b) said@1 priced: the declared program's bits charged against the
declared grids and returned in the hello reply; constants priced
against a declared constant grid rather than fresh singletons — the
grid-priced parameter latent per membrane-wire §2's original
promise, or that promise narrowed at the sitting (stop-and-report
if the latent proves to want an alphabet change). (c) STRUCK by
R-W2. Zero alphabet productions throughout (WIRE_PLAN §4).

### VIII.2 Opening survey (evidence rows, file:line)

1. The shipped parser: `parseSaid` (Host.hs:378-402) — nine forms
   (var 0/1, c, +, -, *, get, if / >, =), `=` already the step-9
   If/Gt composition. Each `["c", v]` mints a fresh singleton grid
   (`mkC (mkGrid "k" (v :| [])) 0`, Host.hs:383) — log2 1 = 0
   content bits, issue #1's defect.
2. The pricing mechanism ALREADY TOTAL over the target grammar:
   `bitsIn :: KnownScope env => Namespace -> Expr env t -> Bits`
   (Syntax.hs:559) prices any Expr namespace-relatively; the charge
   tree covers Div/Log/Exp/Neg (Syntax.hs:508-513). W4b is
   host-side data threading into a frozen arithmetic — zero
   productions, confirmed at the survey.
3. THE BYTE-PIN CONSTRAINT (load-bearing): test-outcome g4
   (Outcome.hs:234-240) byte-pins the hello reply for a said@1
   hello WITH a constant and NO grid key — `{"ok": ..., "models":
   N, "namespace_bits": B}` exactly; test-unify helloB
   (Unify.hs:271-333) likewise exercises constants with no grid
   key. So constants-without-a-declared-grid must stay lawful and
   their reply byte-identical: the pricing lands behind an
   OPTIONAL utility-block key (the W3 routing shape), never as a
   breaking change to the shipped hello.
4. The latent's engine surface: `uAt` was RETIRED from Eval at
   step 9; test-outcome g5 (Outcome.hs:280-305) demonstrates the
   parameter latent as an IN-LANGUAGE COMPOSITION — the family
   u_p over a parameter grid, prior, likelihood, posterior mixing
   all composed test-side; the engine contributes evaluation only.
   The wire has no evidence-to-parameter channel: g5's likelihood
   (0.9/0.1 per approval) is supplied BY THE COMPOSER.

### VIII.3 Design of record (drafted; the sitting rules)

W4a — four new forms, mechanical: `["/", a, b]` -> Div, `["log",
a]` -> Log, `["exp", a]` -> Exp, `["neg", a]` -> Neg. Everything
else still refuses (fail-closed). `<` is NOT added: `[">", b, a]`
says it — a SUCCESSFUL composition, so the primitivity gate's
mirror applies (no codeword for what the grammar already says);
the oracle demonstrates the composition extensionally.

W4b — the optional constant grid, the W3 routing shape:
- The utility block MAY carry `"cgrid": [p1, ...]` — one declared,
  named, finite grid for the program's constants. ABSENT: the
  shipped path byte-identically (fresh singletons, no bits in the
  reply — survey row 3 forces this). DECLARED: every `["c", v]`
  must sit ON the grid (the mkC door refuses off-grid; fail-closed
  bad hello), NaN/inf points bad hello (D-f8), and the hello reply
  gains `"utility_bits": <bitsIn nsN program>` — the frozen
  arithmetic end to end: constants log2 |cgrid| through their
  grid, `get` log2 |namespace| (the M1 law), operators by the
  frozen production charges, vars by scope. R-D20: the oracle
  imports `bitsIn` and compares the reply against it — the
  formula is copied by call, never re-derived.
- Declared-singleton cgrid vs absent: the priced route with
  log2 1 = 0 constant content — the reply differs (utility_bits
  present), so this is NOT a coincidence theorem; the pin is that
  dl arithmetic agrees and the ACT stream is byte-equal (pricing
  is reply economics; the point-mass decision is unchanged).
- The grid-priced parameter latent, honest reading: the declared
  value's GRID-POINT IDENTITY is now priced — the declaration is
  the degenerate (point-mass) case of the latent machinery, per
  the doctrine, and W4 delivers exactly that degenerate case.

### VIII.4 The narrowing brought to the sitting (OB-8)

The OPEN parameter latent — belief over the parameter moving with
evidence — requires an evidence-to-parameter LIKELIHOOD. On this
wire that likelihood has exactly two possible sources, and each is
already ruled: (i) the world declares it — the tabular-likelihood
shape, EPISTEMICS over the wire, the alignment statement's refusal
(R-W1; W3 scoping line (a) refused the same shape for the
observation channel — this would be its third and identical
application); (ii) it is composed in-language — the g5 shape,
already a demonstrated capability (Outcome.hs:280-305), living
where the alignment statement wants it. So the narrowed promise:
W4 lands the grid-priced DEGENERATE latent (pricing + door);
the open latent's wire form is REFUSED in its likelihood-declared
shape, and its lawful in-language form is registered as future
demand under its own gate (no host has registered it; OB-15's
coupled latents would arrive here if ruled). NO alphabet motion is
needed for anything delivered, so no stop-and-report — but the
narrowing itself is the author's to rule, scheduled for the W4
freeze sitting. membrane-wire §2's bracket (the three falsified
sentences of 2026-07-20) is then repaired to the narrowed truth at
the same sitting (OB-7's edit; OB-10's §3 half stays until R).

### VIII.5 Opening measurement (R-D21 prototype, executed
2026-07-21; throwaway W4Proto.hs, `cabal exec ghc -isrc`)

The helloB-shaped program (if (get a > c1) then (c2*var1 - c1)
else c0; 4 constant mentions) against ns [t,z,a]:

```
shipped-singletons bits = 45.80424344959478
declared-cgrid    bits = 52.1440934524794   (cgrid = 3 points)
delta = 6.339850002884624  (4 x log2 3 = 6.339850002884625)
Neg increment = 4.321928094887363   (= log2 20, the prodTable head)
Log increment = 4.321928094887363
Exp increment = 4.321928094887363
Div increment = 10.228818690495881  (= log2 20 + the operand's bits)
Get alone     = 5.906890595608519   (= log2 20 + log2 3, the M1 law)
```

Findings: (1) the frozen `bitsIn` is the whole mechanism — every
W4b quantity is one call against the declared namespace, no new
arithmetic anywhere; (2) the delta row shows subtraction-level fp
divergence at the last ulp — oracle rows pin FULL bitsIn values
(w64 two-route), never hand-computed deltas; delta rows get gates
derived from measured floors; (3) the operator increments confirm
prodTable 20/1 pricing reaches the said surface unchanged.

### VIII.6 The oracle (test-said/, 4 groups, 17 rows)

g1 the parse extension: (a1-a4) each new form ("/", "log", "exp",
"neg") parses to an ok hello; (b) the composite -log-scored program
(all four forms) decides like the mirror EU arithmetic (two-route,
copied from Outcome.hs:241-253); (c) unknown forms still refuse —
the fail-closed pin SURVIVES the extension; (d-i) `["<", a, b]` is
NOT a form (bad hello, the primitivity mirror: successful
composition forbids the codeword); (d-ii) less-than is SAID by the
swap TODAY — `[">", c1, var1]` decides as the mirror y<1 utility
(green throughout: the composition demonstration). g2 the pricing
route: (a) the priced hello reply byte-pinned to shipped shape +
`"utility_bits": bitsIn ns3 mirror` (R-D20 copy-by-call); (b) the
ABSENT key byte-equal the shipped reply (the optimisation-law
re-pin; world fixture copied Outcome.hs:216-222); (c) a singleton
cgrid prices 0-bit constants and its act stream is byte-equal the
absent route; (d) the Sub-wrap delta == 2 x log2 20 + log2 3, gate
1e-12 (floor measured 0.0 at SAT — bit-exact). g3 the door: (a)
off-grid constant bad hello; (b) non-finite cgrid point bad hello
(D-f8); (c) empty cgrid bad hello; (d) constant-free program under
a declared cgrid prices lawfully. g4 behavior: the priced
log-utility's act == the mirror EU argmax. Ablation:
test-said/ablation/run.sh — the namespace-law leak (pricing
re-aimed at a wrong default namespace) reds g2a/g2c while
g2b/g4a stay green: pricing is reply economics, blind to parse and
acts, which is why the extensional pricing pins are load-bearing.

### VIII.7 Under-determination register (for the W4 freeze sitting)

1. The key's name and placement: `"cgrid"` inside the utility
   block; the reply key `"utility_bits"`, appended last, hello
   reply only.
2. THE OB-8 NARROWING (VIII.4) — the sitting's decision item: W4
   delivers the grid-priced DEGENERATE latent (pricing + door); the
   open parameter latent is refused in its likelihood-declared wire
   form (the alignment statement's third application) and its
   lawful in-language form (the g5 composition) is future demand
   under its own gate. membrane-wire §2's original promise is then
   narrowed accordingly at the same sitting.
3. `<` stays uncoded (g1d's two pins) — endorsement of the
   primitivity-mirror reading for the wire's parse surface.
4. On-grid membership is PARSED-VALUE IDENTITY (elemIndex over the
   declared points — exact equality of two doubles parsed from the
   same JSON number grammar); register the reading.
5. The per-tick utility sentence (membrane-wire §3, "a FULL
   replacement said@1 declaration for this tick only") is
   UNSHIPPED — the shipped tick never reads a utility key (survey:
   Host.hs tick, no utility path). Frozen-layer inventory row for
   the sitting: repair the sentence (bracket, implement-on-demand)
   or rule the implementation into W4. The builder recommends the
   bracket: (a)+(b) are the ruled scope.
6. Frozen edits owed AT the freeze, under delegation: membrane-wire
   §2's dated bracket of 2026-07-20 repaired to the as-ruled truth
   (pricing lands, the door, the degenerate latent; OB-7's edit);
   the §3 per-tick sentence per item 5; stanza into proplang.cabal;
   MANIFEST rows for test-said/{Said.hs, stanza.cabal.draft,
   ablation/run.sh}; OBLIGATIONS OB-6/OB-7 -> LANDED@wire-w4 and
   OB-8 per the narrowing ruling.

### VIII.8 The satisfiability transcript (R-D21, overlay form)

Red run (final row text, shipped src, exact stanza flags incl.
-Werror): 13 out of 17 failed. Attribution on final text: g1a-1..4,
g1b, g4a red as `bad hello`/missing act (the four forms absent from
parseSaid); g2a, g2c, g2d, g3d red as `utility_bits` absent from
the reply; g3a-c red as the hello wrongly ok (no door). Green by
design: g1c, g1d-i (fail-closed pins that must survive), g1d-ii
(the composition demonstration), g2b (the absent-route re-pin).

SAT run (overlay realization wearing the real module names —
Host.hs edited in a throwaway copy of src; oracle text UNCHANGED;
same exact flags): 17/17 green. The overlay implementation:
parseSaidWith parameterizing the constant rule (shipped singletons
vs cgrid-bound elemIndex), the four new forms, the cgrid-aware
hello with `utility_bits` from `bitsIn nsN prog` behind the
W4-ANCHOR marker, absent-route byte-identical.

Forcing: every comparison row lands on String `@?=` (both sides
forced to normal form by equality) or a strict Double comparison
whose frozen side is a bitsIn/expect call forced by the compare;
no lazy field escapes (the one-deepseq-per-row clause satisfied
structurally).

Floors: g2d residual measured 0.0 (bit-exact; expected
10.228818690495881 == measured), gate 1e-12 stands.

Two convictions repaired IN-WINDOW (the SAT run's catches, the
R-D21 purpose): (1) the okPrefix helper compared take 12 against
an 11-character literal — it would have redded a CORRECT ok reply;
green in the red run for the right reason, wrong on the green
side; repaired to isPrefixOf. (2) g2d's drafted expected delta
forgot the constant's own node head (log2 20 + log2 3 drafted;
2 x log2 20 + log2 3 true — VIII.5's own Div-increment row showed
the shape and the draft ignored it); repaired with the derivation
in the row.

Ablation firing record (against the overlay, W4_SRC): tripwire
fires on g2a and g2c; g2b and g4a stay green — attribution
partitioned exactly as designed. Runner asserts exactly one
W4-ANCHOR before mutating.

Banked-claim check (the step-10 expiry clause): W4 relies on no
banked composition-failure; its one negative-shaped claim ("<" has
no codeword) is a POSITIVE composition result re-executed live in
g1d-ii at every run — the clause's preferred form.
