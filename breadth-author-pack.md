# The OB-19 heir opening pack — enumeration breadth beyond one-vs-rest

Builder pack for the heir's OPENING SITTING (a ruling sitting, the
dispositions Part VIII form — not a freeze pack: no oracle is drafted
here, no tag is cut, and the red-team mandate round and pre-freeze
lint ride the heir's FREEZE pack later, per the Part VIII precedent).
Prepared 2026-08-05 at HEAD = 0766ebe (`readout-freeze-r1`), tree
clean, manifest 146/146 OK, all 65 tags verify (the thinkpad key is
in the tracked `allowed_signers`; full sweep run this session).
Nothing frozen was touched; every prototype below is throwaway (R-D21
spirit); transcripts are quoted with the build line that produced
them. Builder recommendations are marked as such and are not rulings.

Build for every probe: `PATH=$HOME/.ghcup/bin:$PATH`,
`cabal exec -- ghc -isrc -O1`, GHC 9.10.3, HEAD = 0766ebe, run from
the repo root (one incident recorded: a re-compile invoked from
outside the project directory failed silently and re-ran a stale
binary — caught because the re-run reproduced the superseded
transcript byte-for-byte; the reproducibility of the timing cells
across the three runs is itself evidence, all cells within noise).

## I. Docket position and authorization

The authorization is `battery-freeze-r0`'s register, verbatim: "the
14.9 wire scheduling (#20 first, the OB-19 heir second, #19
1a-or-doctrine third)" (EXACT_PLAN.md 14.9/15; the readout suite
header carries the same register). #20 is CLOSED
(readout-freeze-r0/r1; OB-25 LANDED; the GitHub issue closed this
session citing the tags). The heir is next. This pack is its opening.

Housekeeping executed this session under the author's session
approval: all 65 tags pushed to origin (37 were steel-only — the
older attestation chain now survives the machine), issue #20 closed,
the two stray fully-merged `origin/claude/*` branches deleted.

## II. Opening verifications

`tools/boundary-audit.sh` at 0766ebe (transcript, verbatim tail):

    M5-row: 0 flagged   H-row: 0 flagged (of 66 symbols)
    FLAG  obligation(s) at OBLIGATIONS.md line(s) 54,55 still open against CLOSED boundary readout-freeze-r0
    FLAG  obligation(s) at OBLIGATIONS.md line(s) 56,57,59 still open against CLOSED boundary readout-freeze-r1
    OB-row: 2 flagged (open obligations against closed boundaries)
    banked-failure row: alphabet last moved at c2ca82c (2026-07-25T18:44:21+03:00)
    banked-failure row: 0 flagged
    note: test-writeup/check.sh G2 asserts 8 cabal stanzas; the cabal now has 12 (dated red-by-design instrument, recorded)
    === boundary-audit done: M5=0 H=0 OB=2 BF=0 ===

The five flagged rows are exactly the five obligations this sitting
dockets (OB-26/27/28/29/31) — triage inputs, dispositioned in Part
VII. The alphabet has not moved since c2ca82c (the exact
re-founding); nothing after it (dyadic, trampoline, battery, readout)
touched the alphabet.

## III. Four findings that reshape the increment (verified against the tree)

**F-1. The ms/tick instrument named by OB-19's row no longer
exists.** `test-measure/Measure.hs` was deleted at the Phase-2 close
(0460b9a). The row's clause "a ms/tick row from the existing
test-measure instrument" is stale at HEAD; the instrument must be
rebuilt in the heir's oracle. The deleted file (readable via
`git show 2796c4a:test-measure/Measure.hs`) remains the row-form
precedent: population pins GATE; absolute timings are REPORT rows;
setup and steady state separated. OB-3's standing "run each freeze"
half currently has no carrier — a docket line (Part VI item 4). A
conferral-style amendment of the row text is drafted in Part VIII.

**F-2. The cost bar's denominator is doubly stale.** The "shipped
219" (dispositions VIII.3) was measured at HEAD = 9790089
(`transport-freeze-r1`, 2026-07-22): BEFORE the exact re-founding
replaced the engine (c2ca82c, 2026-07-25 — the same world's
population is ~20x smaller at HEAD), and BEFORE #20 added
O(K x population) `predictMassS` work to every decide reply
(Host.hs, the readout block). P0 re-measures the denominator at
0766ebe on the consumer's own size class. The multiple the sitting
names should bind against P0's rows, with the 219 kept as history.

**F-3. The null-rate face's composition transcript was OWED — it is
now EXECUTED (P2), and the composition SUCCEEDS.** Comp21.hs
(dispositions VII.1) proved only the atom-switching face. Canon:
"primitivity claims are extensional and are earned by executed
transcript, never by argument." P2 closes the gap: the null-rate
sentence is `catBody` at j=0 — the enumeration's own emission shape
pointed at the null atom (posAtoms=[1..K-1] excludes it from the
ENUMERATION; the GRAMMAR says it fine). No primitivity gate engages;
the heir stays enumeration breadth, zero alphabet motion, both faces.

**F-4. Comp21's own verdict predates the re-founding.** It ran at
9790089; the alphabet moved at c2ca82c. A banked composition verdict
is a hypothesis once the alphabet moves (the step-10 law, applied in
its succeeding direction). P1 re-executes the atom-switching
composition on the shipped grammar: it still composes, and the tie
still dissolves. Both faces' verdicts are now HEAD-dated.

## IV. The evidence program (P0-P5, all executed this session)

**The declared cost world** (used by every cost cell; calibrated to
the consumer's live curves in issue #21, which record population
exactly 1601 per positive atom): namespace [t, c1, c2, skill]; theta
9 points (sixteenths 1/16..9/16); rho 8 points; guards c1, c2 with
11-point tau grids (3/16..13/16); so per positive atom
9 + 8 + 2 x 11 x (9 x 8) = 1601, and models = (K-1) x 1601 — landing
exactly on the consumer's population column (1601 / 4803 / 8005 /
14409). The consumer's "K" counts positive atoms (= obs_arity - 1):
their 8005-sentence row is obs_arity 6 here. Streams are 8:1
interleaved (the #21 corpus shape). The semantics world is probe21's
(VII.1): ns [t, ctx, skill], one guard ctx@[0.5], theta tenths,
obs_arity 5, the 60+8 stream.

### P0 — the baseline at HEAD (the bar's denominator)

    == P0 baseline @ HEAD 0766ebe: shipped one-vs-rest K-ary route ==
    K=2   models 1601    ev  9.07   ev+ro  26.97   wire   92.61  ms/tick steady
    K=4   models 4803    ev 36.12   ev+ro 172.10   wire  635.31
    K=6   models 8005    ev 74.63   ev+ro 487.90   wire 1869.98
    K=10  models 14409   ev 162.13  ev+ro 1662.97  wire 6993.50
    (60 library ticks/cell, 30 wire ticks; K=10: 30/15; first-10
    setup means printed in the full transcript; CPU ms, -O1,
    single-threaded; residuals printed: process spawn not walked,
    menu width 4, namespace width 4)

Classes: `ev` = the evidence fold (observeS + mass forcing — the
host's own forcing shape); `ev+ro` = ev + the #20 readout (full
K-vector + entropy); `wire` = serveLine end-to-end combined tick
(parse + EU over the menu + readout + fold + render) in one live
session. CROSS-CHECK: the wire row reproduces the consumer's live
curve at the shared operating points — their 8005-sentence row: p50
1237 / mean 1760 ms (fresh-session, wall) vs 1870 CPU here; their
16010 row: p50 6881 vs 6994 here at 14409. The library instrument
and the production shadow agree; the bar can bind to either class.

DECOMPOSITION FINDING: at K=6 the evidence fold is 75 ms of the
1870 ms wire tick; the readout adds ~413 ms; EU/menu scoring and
render dominate (~1380 ms). Population-proportional predictive work
(readout + EU), not the fold, is where the heir's multiplier lands —
the consumer's "the two compound" reading, confirmed by parts.

### P1 — the naive atom-pair family, measured (and the #21 semantics at HEAD)

Family as filed: per guard, per ORDERED distinct positive pair
(jHi, jLo), per (kt, a, b), a /= b:
`If (Gt (Get nm) tau_kt) (catBody jHi theta_a) (catBody jLo theta_b)`;
charge = the shipped guard tree x a pair mention mass (two
conventions priced: pA = 1/((K-1)(K-2)) ordered-pair mention;
pB = 1/(K-1)^2 two independent mentions — the choice is a sitting
input, Part IX).

    probe21 world: models 324 + pairs 864 = 1188
    T1a P(1)==P(4) exact: True   (P(0)==P(1) exact: False)
    T1b double-render coincidence {0,1,3,4}, all > P(2): True
    T1c exact argmax = 3   P(3)-P(1) = 3.996e-32
    T2 pair-extended: minority argmax 3, P(3)=0.7572 > 1/2,
       dominant argmax stays 2; MAP ("pairguard",[3,2,0,7,8]) @ 0.6783
    T3 pair family at K=2 EMPTY (no distinct ordered pair): True
    T4 kraft: shipped 0.254630, +pairs(pA) 0.259259, +pairs(pB) 0.258102
    cost world:
    K=3   3202 ->   6370 (x1.989)   ev  28.38
    K=4   4803 ->  14307 (x2.979)   ev  71.77
    K=6   8005 ->  39685 (x4.958)   ev 241.71   ev+ro 1568.92
    K=8  11207 ->  77735 (x6.936)   ev 511.73   [8 ticks]
    K=10 14409 -> 128457 (x8.915)   ev 940.85   [6 ticks]

TWO RECORDED HONESTY ITEMS. (1) The first run's T1 criterion was
FALSIFIED and re-stated with the falsified words quoted in the probe
header: the drafted form read "EXACT tie P(0)==P(1)==P(3)==P(4)
(Rational ==)"; the measurement says the four DOUBLES coincide but
the exact engine resolves the tie — P(3) leads by 4e-32 (the 8
minority ticks favor j=3 sentences beyond double precision), and
P(0) is not exactly P(1). The #21 signature's OBSERVABLE shape (the
double-render four-way tie beating the dominant atom) reproduces;
its "exact uniform" wording is a double-render artifact. The b3
oracle row should pin the vector from the reference route, not
assert exact uniformity. (2) The replayed p1 (0.21197764952526807)
differs from probe21's wire-measured 0.21190844945217382 in the 4th
decimal — the Double-parse world class (the readout suite's eighths
lesson: the wire's declared 0.1 reaches the engine as
toRational(0.1::Double); probe21 ran through the wire, this replay
declares exact tenths). Anchors for the heir's oracle must be minted
on ONE side of that parse, deliberately.

### P2 — the null-rate face: the owed composition, executed (it composes)

    models shipped 324 + nullconsts 9 + nullguard 72 = 405
    kraft 0.254630 -> 0.318287 (< 1)
    prices: null-const 7.17 bits, guarded-null 15.92 bits
    200-tick null-dominant stream (75% y=0):
    shipped  p0 = 0.225000  (== the structural cap (1-min theta)/(K-1); S1)
    extended p0 = 0.743928  MAP ("nullconst",[0,6]) @ 0.5503  (S2: in
    (0.60,0.85) and > 2x shipped: both True)
    naive nu-family factor (counting): probe21 x1.250; consumer-class
    K=2 x2.000, K=4 x1.333, K=6 x1.200, K=10 x1.111 (= K/(K-1))
    K=2: catBody0(nu) == catBody1(1-nu) marginal identity, 9 nu
    points, exact ==: True

THE HEADLINE: the M4-BLOCKING face (the consumer holds M4 on the p0
under-read, not on the tie) is the CHEAP face — one more atom-class,
x K/(K-1), x1.2 at K=6. And at K=2 the null family duplicates the
shipped family EXACTLY (measured, 9/9 grid points), so any design
must exclude or refuse it at K=2 or the frozen coincidence pin
(test-pin ARITY, by ==) moves.

### P3 — declared breadth (the doctrine's shape; builder-recommended design)

The hello declares the family's extent — a pair codebook (and/or the
null flag), priced by mention bits over the DECLARED codebook (1/|S|
per pair mention); ABSENT KEY => byte-identical shipped behavior.
This shape is FORCED, not just preferred: test-pin's ARITY group
pins K=2 coincidence by == and test-readout's reference agents run
through `enumerateWithArity`, so a default-on family moves frozen
rows; the declared key is the only design that opens the gate
without a frozen-row ruling. It is also VIII.4's doctrine verbatim
("declared resolution, priced by mention bits, is world data").

    D1 absent key: models equal AND folded minority vec exact ==: True
    D2 declared [(3,2),(2,3)]: tie breaks (argmax 3, P(3)=0.7573,
       dominant argmax 2; MAP ("dpair",[3,2,0,7,8]) @ 0.6785)
    D5 kraft 0.259259 (< 1)
    cost world, |S|=2:
    K=4   4803 ->  7971 (x1.660)  ev 43.49   ev+ro 207.07
    K=6   8005 -> 11173 (x1.396)  ev 81.68   ev+ro 532.16
    K=8  11207 -> 14375 (x1.283)  ev 117.60  [10 ticks]
    K=10 14409 -> 17577 (x1.220)  ev 165.26  [8 ticks]
    declared family CONSTANT at 3168 sentences at every K (D4: flat
    in K — the naive family is x(K-1)(K-2))

At K=6 the declared design's measured ev+ro multiple is x1.09.

### P4 — the exchangeability quotient (the lawful "observed atoms")

The naive "restrict pairs to session-observed atoms" makes the PRIOR
data-dependent — epistemics through the wire. The lawful form: the
FULL family is the prior; the runtime representation collapses
permutation orbits of evidence-untouched positive atoms to
representatives with multiplicities (exact — evidence only lands on
live atoms, where every orbit member emits identically; dead-atom
masses reconstruct by symmetry + normalization).

    probe21, live {2,3}: naive 864 pair sentences -> 504 reps
    Q1 quotient vec == full vec, EXACT ==, at tick 10 and tick 68: True
       (and the quot68 vector is bit-identical to P1's full68 — a
       cross-probe consistency check that cost nothing)
    cost world: K=6 naive 31680 | quot-friendly 11088 | adversarial 31680
                ev 255.31 -> 130.74 ms/tick (x1.95)
    K=10 naive 114048 | quot-friendly 11088 (CONSTANT in K) | adversarial 114048
                ev 1127.15 -> 232.29 ms/tick (x4.85)
    Q3 adversarial (all atoms live) == naive count: True — the honest
    worst case; residual: dynamic orbit-splitting (live-set growth
    mid-session) is design work, not walked

### P5 — the evaluation fast path (table-driven mass, optimisation-law shape)

Per tick a const/guard sentence's emission mass takes one of a small
set of values ((theta ix) x (target|spread) x (branch)); a table
replaces the per-sentence Expr walk. Prior, family, predictives all
unchanged — the law's exact shape, pinned extensionally.

    F1 fast route == observeS/predictMassS route, EXACT ==, tick 10
       and tick 68 (probe21 world): True
    no-rho cost world (walks excluded = 0.5% of the full population,
    residual printed):
    K=6  models 7965:  ev 40.06 -> 4.54 ms/tick (x8.8)
         readout K-vector 244.75 -> 72.55 ms (x3.4), exact ==: True
    K=10 models 14337: ev 103.51 -> 6.07 (x17.1)
         readout 980.14 -> 122.20 (x8.0), exact ==: True

[REPAIRED at r3, 2026-08-05, the r2 verdict's finding — this
paragraph closed with the falsified sentence "The constant factor
alone exceeds the naive family's multiplier, and it composes with
P3/P4." At the measured 39.8% walk share (XI.3) the composed
full-world ceiling is ~x2.14 against the naive family's matched-depth
x3.64 — it does NOT exceed it. What stands: the factor is real ON THE
CONST/GUARD SUBSET (x8.8/x17.1, extensionally exact), it composes
with P3/P4 on that subset, and the walk residual bounds the whole —
P5 is banked in exactly that reduced form.]

## V. The decision table (K=6 = the consumer's 8005-sentence operating point)

Every cell a measurement except rows marked (proj) — arithmetic over
measured parts, never a measurement of an unbuilt implementation.

| design                      | models          | ev+ro ms/tick | multiple (ev+ro) | wire (proj)      | K=10 behavior      |
|-----------------------------|-----------------|---------------|------------------|-------------------|--------------------|
| shipped one-vs-rest (P0)    | 8005            | 488           | x1.00            | 1870 measured     | x3.4 (measured)    |
| naive pairs (P1)            | 39685 (x4.96)   | 1569          | x3.22            | ~9100 (~x4.9)     | x8.9 pop, ev x5.8  |
| + null face (P2)            | +1601 (x1.20)   | ~+20% (proj)  | ~x1.2            | ~x1.2             | x1.11 and shrinking|
| declared, |S|=2 (P3)        | 11173 (x1.40)   | 532           | x1.09            | ~2590 (~x1.38)    | FLAT (family 3168) |
| quotient, 2 live (P4)       | full prior      | ev x1.95 saved| —                | —                 | reps FLAT: ev x4.85 saved |
| fast-eval (P5)              | unchanged       | ev x8.8, ro x3.4 | constant factor | —              | ev x17.1, ro x8.0  |

Wire projections decompose the measured 1870 into ev 75 + readout
413 + EU/render 1382 and scale the population-proportional parts.

[Bracketed at r2, 2026-08-05: the declared row's x1.09 was OVERTURNED
by the sitting's ordered evidence — a fold-depth confound between
cells, not noise and not nonlinearity. The matched-depth multiple is
x1.26 at |S|=2, per-pair cost 0.132 of base, LINEAR in |S|. Part XI
carries the measurement; this table stands as what the sitting read.]

## VI. The sitting docket (the author's calls; recommendations are the builder's)

1. **Scope: which faces land.** Both compose (P1/P2); the null-rate
   face is the consumer's M4 blocker AND the cheap one (x1.2 at
   K=6); the pair face is the expensive one the caution rider was
   written for. RECOMMENDATION: both faces behind one declared key
   (P3's shape), the null face's K=2 exclusion explicit (P2's
   duplication measurement is the reason).
2. **The design horn.** Declared-key (forced by the frozen pins;
   VIII.4's doctrine shape) with the quotient (P4) and/or fast path
   (P5) as optimisation-law fast paths IN THE SAME INCREMENT only if
   the consumer's declared sets are large; at |S|=2 the measured
   x1.09 needs neither. RECOMMENDATION: declared-key alone for the
   heir; P4/P5 banked as measured designs with their transcripts,
   landed later under their own pins if demand names them. NOTE: the
   sitting may take this together with #19's 1a-or-doctrine ruling —
   VIII.4 named exactly this unification ("declared resolution,
   priced by mention bits, is world data"), and the declared-pair
   key is that doctrine's second instance after the theta grid.
3. **Name the multiple** — and its two coordinates: WHICH baseline
   (P0's HEAD rows; the 219 kept as history — F-2) and WHICH class
   (ev+ro library or wire; the consumer's demand is wire-class,
   and P0 shows the two agree at the operating points).
   The measured envelope the bar would admit: declared-|S|=2 is
   x1.09 (ev+ro); naive-both-faces is ~x3.9 (x3.22 pairs x1.2
   null). A multiple of 2 admits the declared design with room for
   larger declared sets and excludes the naive family; the one
   number stays the author's.
4. **The ms/tick row form** (rebuilding the deleted instrument's
   law): population pins as exact-integer GATES; absolute ms as
   REPORT rows; the bar itself as a RATIO gate (heir-route /
   shipped-route, same process, same stream) <= the named multiple.
   Re-home OB-3's "run each freeze" half in the new suite.
5. **The riders' discharge plans** (Part VII): OB-26 L8, OB-27
   triptych scope, OB-28 lint hardening, OB-29 kit step-0 live
   signature.
6. **OB-31 rides or re-routes.** The heir's oracle reads the
   readout (p0 is b4's subject), so this IS a readout-touching
   oracle boundary. RECOMMENDATION: rides, as one independent
   entropy_bits row (from posterior masses, never entropyAgent) with
   M8 promoted into the declared pool as its kill.
7. **The filer's routed question** (partitioned-replay workaround,
   VII.1's interim note): dispose or defer explicitly —
   "economics, never epistemics" is the criterion on record.

## VII. The five flagged obligations, dispositioned for the sitting

- **OB-26 (L8)**: lands in the heir's freeze kit phase. The lint row:
  every `[0-9a-f]{7,}` cited in a pack repair row resolves AND its
  commit touches the file the row names; two-sided demo (true
  citation passes, seeded stale citation fails). The builder
  constraint from the scheduling sitting binds the kit ORDER: the
  manifest re-hash comes AFTER the new lint rows exist.
- **OB-27**: the CLAUDE.md triptych clause gains its harness-gate
  scope sentence in the same CLAUDE.md touch as the heir's other
  canon lines (one boundary, one touch).
- **OB-28**: the three lint hardenings ride the same L8 touch —
  L9 detects `--message`/`--message=`/`-am`; L9's exemption
  hardened to `git cat-file -t` = tag; L5's pack selection made
  fresh-clone-stable. Each with its two-sided demo.
- **OB-29**: the heir's kit step 0 performs a LIVE throwaway
  signature (sign a nonce, verify) before any tree mutation; red
  demonstrated with a refused key.
- **OB-31**: Part VI item 6 (recommendation: rides here).
- **OB-25**: its state string still reads LANDED@readout-freeze
  although both readout tags exist; advancing it is a one-line
  ledger touch for the author's key at this sitting.
- **JP2-d6 / pwLadderCap**: NOT here — its RETIRE-UNTIL-N return row
  is the #19 sitting's opening checklist (docket item three), stated
  again so this sitting cannot silently absorb it.

## VIII. Frozen-layer inventory, pre-seeded

1. **`src/PropLang/Host.hs:387`'s wait comment** (routed by the
   readout close, VII.3 there): the no-utility branch `Left o0` is
   the EXTERNAL arm, and its comment `-- wait: the option space's
   head` contradicts the legend three lines above (Left = external
   fires). One comment line; repairs under the author's key at this
   sitting, in-place.
2. **OB-19's row text** (F-1): drafted amendment, for the author's
   key, the falsified words quoted inside their own repair:
   "...the increment's oracle carries a ms/tick row from the
   existing test-measure instrument [AMENDED at the heir opening,
   2026-08-05: `test-measure/Measure.hs` was deleted at the Phase-2
   close (0460b9a), so 'the existing instrument' names nothing at
   HEAD; the heir's oracle REBUILDS the instrument to the deleted
   file's law — population pins gate, absolute timings report,
   setup/steady separated — and the bar binds as a ratio gate
   against the P0 baseline of the opening pack]..."
3. **dispositions-pack VIII.3's "the shipped 219"** — historical
   record, needs only a dated bracket noting F-2 (measured at
   9790089, pre-exact, pre-readout; the HEAD denominator is this
   pack's P0), never an in-place rewrite: it is a close-date
   document.

## IX. Under-determination register

- The pair mention charge: pA ordered-pair (1/((K-1)(K-2))) vs pB
  two-mention (1/(K-1)^2) vs 1/|S| on the declared codebook (P3's
  form; RECOMMENDED — it is the doctrine's own pricing). Kraft
  measured safe under all three.
- The declared key's wire syntax and refusal surface (bad pair,
  out-of-range atom, K=2-with-null-flag) — design work for the
  oracle phase; the K=2 refusal is REQUIRED by P2's duplication
  measurement.
- a==b pair cells (same theta both branches, different atoms):
  excluded by the shipped a/=b convention in every P1/P3 cell;
  whether the declared family admits them is a design choice the
  oracle must state either way.
- The nu grid's source: the theta codebook (P2's choice) vs a
  dedicated declared grid — the declared-key shape admits either;
  the theta-codebook choice adds no new declaration surface.
- Which tick class the bar names (Part VI item 3).
- The walk-family's null/pair variants (a walk latent over nu):
  counted in no cell here; the oracle phase must include or exclude
  them explicitly.

## X. What was deliberately NOT done here

No oracle rows drafted, no src touched, no frozen file edited, no
tag cut. The red-team mandate round and the pre-freeze lint belong
to the heir's freeze boundary, not this ruling sitting (the
dispositions precedent). Prototypes are discarded with the session
scratchpad; their full transcripts ride this pack's Part IV and the
session record. The satisfiability-transcript obligations (R-D21)
for the heir's future red rows are oracle-phase work and remain
entirely owed — nothing here pre-discharges them.

## XI. The sitting's verdict, and the ordered evidence (r2, 2026-08-05)

The sitting OPENED on Parts I-X and ruled. This part records the
verdict's rulings, executes its ordered evidence, and corrects the
one number the verdict declined to believe. Everything below ran at
HEAD 0766ebe on the pack's own worlds; the ordered probe carries the
sitting's new BUILD-STAMP discipline (XI.5), and its transcript
header reads:

    RUNNER: sha256(binary)=e497213a...dee1d00a2  HEAD=7b765fa  2026-08-05T09:02:27+03:00
    BUILD-STAMP exe=.../recon size=3335024 mtime=2026-08-05 06:02:15 UTC ghc-9.10.3 linux-x86_64

### XI.1 Continuity from r1 — verified in the tree (the check Part
VIII should have carried; its absence was the verdict's finding)

Both conferral conditions on the r1 signature were EXECUTED at the
close, and the signed artifacts are clean:

- **Parity**: the signed tag message ITSELF records the measurement —
  "shell PARSED the command - quote parity is EVEN (2, measured at
  the ...)" — and carries the first draft's "could never have
  parsed" only as a QUOTED, CONVICTED sentence ("was convicted at
  the conferral"), the standing conviction being argument-boundary:
  "The message reviewed could never have been the message MINTED,
  and the tag owed could never have been minted, on any run." No
  falsified sentence sits asserted under the key. No amendment owed.
- **r1a carriers**: `test-readout/Readout.hs` (the frozen suite)
  names them in place — "the p1 clause's VALUE is carried by r7a -
  M70's unique killer in the frozen matrix ... The entropy clause's
  VALUE is carried by NO STANDING ROW ... that absence is OB-31."
- **Manifest arithmetic, named not presumed**: 139 (at 493e2f2) ->
  146 (at 0766ebe) is exactly seven rows: `4-close.sh`,
  `lint-l9.patch`, `obligations.patch`, `r1a-presence-pin.patch`,
  `r1-gate5-run.txt`, `r1-tag-msg.txt`, `tag-message-file.patch`.
  This pack is NOT a manifest row (builder layer, pre-freeze) — the
  verdict's "presumably the pack" presumption is corrected.

### XI.2 The x1.09, overturned by the ordered measurement

The ordered cells (K=6 ev+ro, per-tick series printed, steady =
ticks 6..30, one process):

    |S|=0  models  8005  median 417.95  mean 423.59  stddev 24.97
    |S|=2  models 11173  median 528.20  mean 532.28  stddev 29.30
    |S|=6  models 17509  median 754.24  mean 758.07  stddev 46.00
    |S|=20 models 39685  median 1520.76 mean 1544.88 stddev 94.63
    per-pair cost (median over base): 0.1319 | 0.1341 | 0.1319

**The per-pair cost is UNIFORM and LINEAR in |S|: 0.132 of base per
ordered pair.** The verdict's third hypothesis (the routes evaluate
different sentences) is excluded by construction — the |S|=20 cell
IS the naive pA population and charges, and it reproduces P1's naive
cell. The real mechanism was a FOLD-DEPTH CONFOUND, visible in every
per-tick series: per-tick cost GROWS with fold depth (base drifts
365 -> 463 ms across 30 ticks — the posterior's Rational
denominators grow as the fold deepens), and Part V compared P3's
30-tick cell (steady window = ticks 6-30) against P0's 60-tick base
(window = ticks 11-60, deeper, costlier). At matched depth every
cross-run number reconciles: today's S2 median 528 vs P3's 532;
today's S20 1521-1545 vs P1's 1569; today's base first-ticks vs
P0's first10 382.

Consequences, in the verdict's order:
- The declared design's honest multiple at |S|=2 is **x1.26**, not
  x1.09. Naive-all-pairs is x3.6 at this window (x1 + 20 x 0.132).
- **Headroom at a bar of 2 is |S| ~ 7 ordered pairs**, not ~22. The
  Part VI item-3 sentence "room for larger declared sets" survives
  only in that reduced form.
- A NEW instrument constraint for the b6 row, bought by the drift:
  a ms/tick quantity is a function of FOLD DEPTH, so the ratio gate
  must take numerator and denominator from the SAME stream at the
  SAME window — matched-depth ratio, or the gate wobbles with
  whichever route was measured deeper. (The ratio form already folds
  both routes over one stream; this names WHY that is load-bearing.)

### XI.3 The remaining ordered measurements

- **Walk-time share (the P5 Amdahl question)**: full world 64.35 ms
  ev median vs no-rho 38.73 — **39.8% of ev time from 40 walk
  sentences, 0.50% of the population** (walks carry 9-point latents
  and a move kernel; ~130x the per-sentence cost). P5's banked x8.8
  is hereby RE-SCOPED: an upper bound on the const/guard subset;
  the composed full-world ev ceiling without walk treatment is
  ~x2.1. The bank keeps the transcripts and this rider.
- **Item 7's transcript (partitioned replay)**: minority-only
  session B vs shipped-full A vs declared-pairs-full C, exact ==:
  B==A False, B==C False (B: P(3)=0.848; A: 0.212; C: 0.757). The
  workaround reproduces NO lawful single-agent computation on the
  declared world — on the verdict's own criterion the disposition is
  **DEFER**, the economics reading unearned.

### XI.4 The rulings, recorded as received

1. **Scope**: both faces, one key, SEPARATELY DECLARABLE within it;
   independent pricing; and the free K=2 row canonized as an
   exact-integer gate: at K=2 the heir is byte-identical to shipped
   whatever is declared (pair family empty by T3; null family
   refused, else the P2 duplication).
2. **Design horn**: declared-key alone; P4/P5 banked (P5 now with
   XI.3's walk rider).
3. **The class**: GATE ON ev+ro, REPORT wire — the gate must not be
   relaxable by unrelated EU/render slowdowns. The NUMBER remains
   the author's; the corrected envelope it prices: |S|=2 = x1.26,
   per-pair 0.132, naive x3.6, headroom at bar 2 = |S| ~ 7.
4. **Row form**: approved; ratio on ev+ro at matched depth (XI.2's
   constraint); OB-3's standing half re-homed in the new suite.
5. **Riders OB-26/27/28/29**: discharge plans approved as drafted.
6. **OB-31**: rides here; independent entropy row, M8 promoted as
   its kill.
7. **Partitioned replay**: DEFERRED on XI.3's executed transcript.

### XI.5 New obligations and settled register items

- **The build-stamp obligation** (drafted for the author's mint at
  this sitting; the ledger is not the builder's to touch): every
  measurement probe and the heir's ms/tick instrument PRINT THEIR
  OWN BUILD IDENTITY (binary hash or mtime+size, HEAD, compiler
  version) into the transcript they produce, so a stale run is
  self-convicting. Provenance: the Part IV header's stale-binary
  incident, where byte-identical reproduction was offered as
  evidence of soundness in the one environment where it is the
  signature of the failure — the verdict's finding, verbatim in
  spirit. First discharge: the XI probe's stamp above.
- **G2 stanza row** (`test-writeup/check.sh`, dated red-by-design):
  docketed for the author — derive the stanza count from the cabal
  file (scriptable) or retire the row; a permanent red has no
  discriminating power (a green-that-cannot-fail wearing red).
- **Settled from Part IX by the verdict**: the nu grid rides the
  THETA CODEBOOK (a dedicated grid would turn P2's exact K=2
  duplication into an undetectable near-degeneracy — exact equality
  is the tell); anchors are minted on BOTH sides of the Double
  parse with the delta itself (6.9e-5 at p1) pinned as a REPORT row.
- **P4's residual re-classed**: orbit-splitting on live-set growth
  is ENGINEERING, not epistemics — while members were dead they
  emitted identically, so the representative's posterior copies to
  each member under the multiplicity; recorded so no later sitting
  reopens it as soundness.
- **The two-coordinate observation, registered**: the faces' compute
  and Kraft orderings are OPPOSED — the null face is x1.2 in
  population but 13.7x the pair face in prior mass (0.0637 vs
  0.0046 Kraft added); the pair face is x4.96 in population and
  almost free in bits. A named compute multiple prices one
  coordinate; both are now on the record.

### XI.6 What remains before the oracle phase opens

The author's: the multiple's NUMBER (envelope above), the G2
disposition, the build-stamp obligation's mint, OB-25's state
advance, and the frozen-layer repairs of Part VIII (the Host.hs:387
comment, the OB-19 row amendment, the VIII.3 dated bracket). The
builder's, after those: the test-breadth/ oracle under Parts VI/XI
as ruled — oracle-first, R-D21 transcripts, kills with rows.

## XII. The r2 verdict's orders, executed (r3, 2026-08-05)

XI was accepted; this part executes what the acceptance ordered: the
confound swept as a CLASS, the drift curve and the ratio-travel cell
run, the manifest chain named upstream, P5's falsified sentence
repaired in place (Part IV now carries the repair with the words
quoted), the stamp's first conviction written out, and the
walk-exclusion gate row adopted. The ordered probe's stamp — now
extended to SOURCE-TREE state per the verdict, since HEAD is
precisely what a builder branch moves:

    RUNNER: sha256(binary)=593f0775...c46d2f7f  HEAD=daa7a7b
      src-tree=ecfd3102ddca43df4846f74109837967079def85  src-dirty=0
      date=2026-08-05T10:20:12+03:00

### XII.1 The confound swept as a class: every cell's window, named

The steady windows behind every Part IV/V cost cell (1-based tick
indices; "amortized" = total/ticks including setup):

    P0  ev, ev+ro:  K in {2,4,6} ticks 11-60 | K=10 ticks 11-30
    P0  wire:       K in {2,4,6} ticks 6-30  | K=10 ticks 6-15
    P1  ev, ev+ro:  K in {3,4,6} ticks 6-30 | K=8 ticks 6-8 | K=10 tick 6
    P3  ev, ev+ro:  K in {4,6} ticks 6-30 | K=8 ticks 6-10 | K=10 ticks 6-8
    P4  ev:         amortized 1-30 (K=6) | 1-12 (K=10)
    P5  ev:         amortized 1-30 (K=6) | 1-12 (K=10)
    XI  ev+ro:      all four |S| cells ticks 6-30, one process

SOUND (matched-window, same-process ratios): P4 naive-vs-quotient,
P5 shipped-vs-fast, XI's |S| cells, XII.3's ratio. UNRECONCILED and
so marked: **Part V's cross-K scaling column** — the x3.4 shipped
K10/K6, P1's x5.8 ev, and the wire x3.7 all divide deep small-K
cells by shallow large-K cells, so the K-scaling is UNDERSTATED by
an unmeasured amount (population factors are counting and stay
exact). Part V's table stands as read with this part as its window
column. Corroboration the pack had and had not noticed, now noticed:
the consumer's own 8005 row reads p50 1237 against mean 1760 — a 42%
median-mean gap is a right tail, and drift of XII.2's shape is
precisely what produces one; the production shadow was showing the
drift all along, and the P0 wire "agreement" (1870 CPU vs p50 1237)
was never as tight as it read.

### XII.2 The drift curve (the verdict's "add P6"; runs as P7 — the
name P6 was already worn by the recon probe, renamed here, not
silently renumbered)

K=6 ev+ro, ONE process, ONE stream, 300 ticks:

    per-tick ms (every 10th): 380 410 446 481 520 549 614 624 660
      703 737 777 813 861 892 951 993 1038 1087 1140 1184 1232 1283
      1329 1384 1429 1493 1566 1587 1660
    windows: [6-30] 437.6 | [50-80] 607.1 | [100-130] 794.4 |
             [150-180] 1012.7 | [250-280] 1512.1
    LS slope [6-300] = 4.444 ms/tick-index
    half-slopes: [6-150] 3.725 vs [151-300] 5.095  (ratio 1.37)

**The verdict's fork resolves to the second branch: the growth is
WORSE THAN LINEAR** — the slope itself grows 37% between halves
(window-to-window marginal slopes 3.6 -> 3.8 -> 4.4 -> 5.0). At
depth 300 a tick costs 3.5x its depth-30 cost; cumulative cost is
worse than quadratic in session length. Per the fork's own words,
the heir's oracle has a different problem than breadth — recorded
here as a STANDING FINDING with its own docket line, not absorbed
into the multiple: exactness was chosen deliberately, its price is
now measured rather than felt, and ACCEPTING that price is an
explicit author act still owed (the verdict's "an accepted cost
discovered by accident is not yet accepted"). Drafted REPORT row for
the heir's instrument: the five windowed means and the half-slope
pair, re-printed each run — a moved slope is then a tell, never a
mystery. Residuals printed by the probe: one stream shape (two
distinct evidence values — richer streams could grow denominators
faster), ev+ro class only, K=6 only.

### XII.3 The ratio travels: the matched-depth gate is sound

    |S|=2 / base: window [6-30] = 1.258 | window [100-130] = 1.261

Depth-invariant to 3 parts in 1000. Two consequences: the
matched-depth ratio gate holds at ANY depth (a declared window is
good hygiene, not a soundness need), and — the load-bearing one —
**the drift multiplies both routes proportionally, so the breadth
decision is ISOLATED from the drift problem.** The multiple can be
named on the ratio; the drift cannot be policed by a ratio gate and
does not need to be.

### XII.4 The manifest chain, named upstream (nothing wrong survives
under a signature)

The full accounting: X.8's kit brief planned SIX rows, "139 -> 145"
— and that six CORRECTLY included the kit-generated
`r1-gate5-run.txt` (139 + 4-close.sh + r1-tag-msg.txt + three
patches + gate5-run = 145). It was the CONFERRAL VERDICT's own
five-row list that missed gate5-run (and necessarily predated
`obligations.patch`); the conferral's amendment added
obligations.patch as the seventh row, 145 -> 146. The reconciliation
is recorded in-tree at 4c56dac ("the verdict's five missed
r1-gate5-run.txt and predated obligations.patch") and X.6's
historical bracket ("added obligations.patch, and moved the manifest
to 146"); the signed tag message carries 146. So the surviving "145"
sits only in X.6's BRACKETED HISTORICAL transcript and X.8's brief
— both true of the pre-conferral kit they describe. The r2 verdict's
guess (the brief forgot gate5-run) is corrected: the brief counted
it; the conferral's list dropped it.

### XII.5 The stamp's first conviction, written out

The XI RUNNER line read `HEAD=7b765fa`; the prose above it said the
evidence ran at HEAD 0766ebe. The sentence the pack owes: the probe
ran on the builder commit 7b765fa, which sits ATOP the tag and
touches only this pack file — the SOURCE TREE is byte-identical
(`git rev-parse <commit>:src` = `ecfd3102...` at 0766ebe, 7b765fa,
and daa7a7b alike), so every measurement is of the sealed engine and
the prose's "at HEAD 0766ebe" was sloppy about WHICH ref it named,
not about what was measured. Per the verdict, the stamp now records
what a builder branch cannot move: XII's runner line carries
`src-tree=` (the src tree object hash) and `src-dirty=0` alongside
HEAD. The obligation's drafted text (XI.5) gains that clause.

### XII.6 The walk-exclusion gate row, adopted as ruled

Walks cost ~130x per sentence (39.8% of ev time from 0.50% of
population, XI.3); walk variants of the declared families would
multiply the expensive 39.8%, not the cheap 60%. As ruled: **the
heir's declared family contains NO walk variants, canonized as a
gate row in the heir's oracle** (declared-family population is a
closed form over consts and guards only), reopenable solely on a
measured cell of their own. Part IX's last under-determination is
thereby closed, not left "either way".

### XII.7 Where item 3 now stands

The depth-invariance cell came back tame (XII.3); the drift cell did
not (XII.2), but its non-tameness is orthogonal to the ratio by
XII.3's own measurement. On the record for the naming: |S|=2 =
x1.26 at any depth, per-pair 0.132, naive x3.64, bar-2 headroom
seven ordered pairs — and, separately docketed, the superlinear
session-depth growth awaiting the author's explicit acceptance (or
further order). The number, the drift's acceptance, G2, the
build-stamp mint (now with the src-tree clause), OB-25's advance,
and the Part VIII frozen-layer repairs remain the author's; the
test-breadth/ oracle opens after them.
