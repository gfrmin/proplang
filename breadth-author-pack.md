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

    [BRACKET r8, 2026-08-06: the transcript's "note:" line above is
    a faithful quote of tools/boundary-audit.sh:136 — and the note
    itself is FALSE of the tree: G2 has been a green RECORD row
    since the step-7 unify freeze, and the check runs 33/33. The
    quote is honest; the tool lies. See XI.5's bracket and Part
    XVII; the tool's repair rides the oracle freeze's kit.]

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
      [BRACKET r8, 2026-08-06: FALSE OF THE TREE, falsified by
      EXECUTING the instrument this item names — test-writeup/
      check.sh runs 33/33 green, and its G2 row has been a RECORD
      form since the step-7 unify freeze (2026-07-17; the in-file
      comment at check.sh:141-147 records the retirement, two-sided
      N8 form): it pins the close-date QUOTE in WRITEUP.md and
      PRINTS the live count (12), asserting nothing about 8. The
      derive-vs-retire question this item dockets was ruled and
      executed a month before it was asked; the item DISSOLVES.
      The false framing's source is tools/boundary-audit.sh:136,
      which hard-prints the note Part II faithfully quoted — a
      frozen tool, so its repair rides the oracle freeze's kit as
      an FL-inventory row (Part XVII). Register row 22.]
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

    [BRACKET r6, 2026-08-06, from the Part XV register sweep: the
    parenthesis "(a declared window is good hygiene, not a
    soundness need)" is FALSIFIED by later measurement. The
    3-parts-in-1000 figure was true of the |S|=2 window pair
    above; P9 (XIV.2) measured the |S|=6 ratio traveling
    1.781 -> 1.807 -> 1.844 across [6-30]/[100-130]/[250-280] —
    35 parts in 1000, linear, no saturation. The declared window
    IS a soundness need; the gate as drafted in XIII.5/XIV.6 pins
    depth AND window accordingly. The load-bearing consequence
    (breadth isolated from drift; the multiple named on a
    matched-window ratio) survives and is the form the mints
    carry.]

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

[CORRECTED at r4, per the r3 verdict, the falsified words quoted:
this section wrote "It was the CONFERRAL VERDICT's own five-row list
that missed gate5-run", and 4c56dac's parenthetical reads the same
way — both MIS-STATE what the conferral did. The conferral listed
five and ASKED for the sixth precisely because five did not
reconcile; it asserted no completeness. The accurate sentence, which
this bracket now lodges against 4c56dac's wording as well (a commit
message being uneditable, the correction lives here): the verdict
named five of six and asked for the missing row, and its later guess
at that row's identity was wrong. Both facts, neither flattering nor
otherwise.]

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

### XII.7 Where item 3 now stands [superseded by Part XIII's cells]

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

## XIII. The r3 verdict's closing orders, executed (r4, 2026-08-05)

The ordered probe (P8; stamp with the src-tree clause):

    RUNNER: sha256(binary)=ca3616eb...d4347c  HEAD=0341a57
      src-tree=ecfd3102...  src-dirty=0  date=2026-08-05T10:57:30+03:00

### XIII.1 The drift measured on the richest stream this world admits

The order said eight distinct evidence values; at K=6 the declared
world's evidence alphabet IS six (atoms 0..5) — stated, not silently
substituted. The cell: all six atoms cycling plus 196 distinct
guard-feature pairs (both guards swept across their 11 cut-points),
K=6 ev+ro, 300 ticks, one process:

    windows: [6-30] 418.1 | [50-80] 581.6 | [100-130] 759.4 |
             [150-180] 961.8 | [250-280] 1448.7
    LS slope 4.226 | halves 3.575 vs 4.890 (ratio 1.37)

**Richness does not move the curve.** The cleanest comparison is
same-process: the rich stream's [6-30] mean (418.1) against the
standard two-value stream's (418.3, cell XIII.3's base) — 0.05%
apart; the deep windows sit within the known ~5% cross-run spread of
P7's; the curvature ratio is identical (1.37). The mechanism, now
evident: every tick's per-sentence masses are drawn from the SAME
small set fixed by the theta codebook whichever atom or branch the
tick selects, so denominator growth is CODEBOOK-bounded, not
stream-bounded. The r3 verdict's lower-bound concern is answered by
measurement: the P7 curve is not a friendly-stream artifact, and the
acceptance binds to the real number. (Residual, printed: both
streams are periodic; no aperiodic real corpus was replayed.)

    [BRACKET r6, 2026-08-06, from the Part XV register sweep: the
    mechanism sentence above — "every tick's per-sentence masses
    are drawn from the SAME small set fixed by the theta codebook
    whichever atom or branch the tick selects" — is exact for the
    expfam fragment (7965/8005 rows) and LOOSE for the 40 walk
    rows, whose per-tick factors are rho-weighted sums over an
    evolved state (not members of a fixed small set), though their
    ACCUMULATED masses stay inside the same P*D^t envelope. This
    sentence is the parent of XIV.5's r5 falsehood; the corrected
    mechanism is XIV.5-as-repaired, claim 2. The cross-run-spread
    wording was separately convicted and repaired at XIV.1. The
    measured cells above are untouched.]

### XIII.2 The wire-class drift: EU/render DRIFTS, and the consumer
sentence is measured

300 combined serveLine ticks on the same rich stream:

    wire windows: [6-30] 1832.3 | [50-80] 2537.9 | [100-130] 3271.1 |
                  [150-180] 4110.3 | [250-280] 6093.2
    LS slope 17.54 | halves 15.02 vs 20.03 (ratio 1.33)
    EU/render (wire minus ev+ro, per window):
      1414.2 | 1956.3 | 2511.7 | 3148.5 | 4644.5

The r3 verdict's unmeasured cell resolves to its second branch:
**EU/render drifts with the posterior** (x3.28 shallow-to-deep,
proportional to ev+ro's x3.46 — EU reads predictive masses, so it
inherits their arithmetic), and the depth-300 wire tick lands at
~6.6 s — the verdict's 7.1 estimate for the drifting case, nearly
exact. The sentence a consumer can hold, first-crossing on the
measured series:

    At K=6 over 8005 sentences, the wire tick crosses 2 s at depth
    ~30, crosses 5 s at depth ~209, and stays under 10 s through
    depth 300.

That sentence — not the slope — is what the drift acceptance
accepts; drafted as the acceptance's operative clause in XIII.6.

### XIII.3 Ratio travel at |S|=6 (the insurance cell): tame

    |S|=6 / base: [6-30] 1.804 | [100-130] 1.828
    (and 1.804 == 1 + 6 x 0.132 to within noise — the per-pair
    constant reproduced a third way)

The gate's depth-invariance now holds at both measured |S| points;
travel spread 1.3%.

### XIII.4 The containment, asserted

No ruling in this pack rests on the unreconciled cross-K column:
item 3's envelope rests on XI/XII/XIII matched-window cells at K=6;
item 1's scope on population counts, Kraft sums, and semantics
cells (window-free); P4's and P5's verdicts on same-window
same-process ratios; OB-31, item 7, and every rider on no timing
cell at all. The cross-K column is descriptive only — a marked
defect AND a contained one, now said rather than left to a reader's
audit.

### XIII.5 The gate hardened in its other direction (as ordered)

The b6 ratio gate's denominator composition is PINNED: the gate row
records, beside the ratio, the base's measured composition at the
mint — at this opening's operating point (K=6, 8005 sentences,
window [6-30]): ev 64.4 ms of which walks carry 25.6 (39.8%),
readout 353.7, EU/render 1414.2 at the wire class. A
base-composition change (the standing example: a future walk
optimisation collapsing the 39.8% — P5's banked table points
straight at it) is a LICENSED RE-MINT of the gate, never a breadth
failure: the first person to speed up walks must not be told they
broke breadth. And the drift row is GATED, not printed: the five
windowed means and the half-slope ratio are FROZEN at the oracle's
mint, each run recomputes and FAILS outside tolerance — drafted at
+/-15% per windowed mean and +/-0.15 absolute on the half-slope
ratio (observed cross-run spread ~5%, a 3x margin; the final
numbers are the freeze's call). A permanently-printing row is a
green that cannot fail wearing a different colour — the r3 verdict's
words, adopted as the row's design.

### XIII.6 The two mints, prepared for the author's key

**The bar** (item 3; the number is the author's — the slot is left):

    GATE b6: (heir-route ev+ro ms/tick) / (base-route ev+ro ms/tick),
    same stream, same process, matched depth and window,
    <= [ THE AUTHOR'S MULTIPLE ].
    Measured envelope beneath it: |S|=2 = 1.26 and |S|=6 = 1.80,
    both depth-invariant; per-pair 0.132, linear; naive-all-pairs
    3.64, excluded; a bar of 2 admits |S| <= 7 ordered pairs.
    Denominator composition pinned per XIII.5.

**The drift acceptance** (its operative clause now measured on the
richest admissible stream and expressed in the class the consumer
feels):

    ACCEPTED as exactness's price: per-tick cost grows superlinearly
    with session depth (half-slope ratio 1.37, stream-shape-robust,
    codebook-bounded); at K=6 over 8005 sentences the wire tick
    crosses 2 s near depth 30 and 5 s near depth 209. The drift row
    rides the heir's oracle as a GATED diff-vs-frozen (XIII.5), and
    any depth-mitigation work is its own future increment under its
    own demand gate — never a silent change to the exact semantics.

Both slots await the author's key at the sitting's close; everything
beneath them is measurement.

## XIV. The r4 verdict's riders, executed (r5, 2026-08-06)

The verdict: sign both mints, with four riders — one touching the
bar's boundary, settled before the number goes in the slot — plus
one residual disposable by argument. The two measurement riders
share one probe (P9; one process, three cells; every window mean
the probe computes, it prints — the defect rider 1 convicts,
repaired in the instrument first):

    RUNNER: sha256(binary)=20f0d5ea...d059d94  HEAD=c91f30b
      src-tree=ecfd3102...  src-dirty=0  date=2026-08-06T04:15:44+03:00

### XIV.1 Rider 1 — the unprinted number, printed

The convicted sentence (XIII.1): "the deep windows sit within the
known ~5% cross-run spread of P7's." Falsified as a
characterisation: a uniform signed offset across four windows is a
process-level difference, not spread — and P8's (c) cell had
computed the same-process deep base and printed only the ratio.
P9 measures it directly, one process:

    standard base [100..130] = 792.0 | rich [100..130] = 765.9
    rich/standard at depth = 0.967

The verdict's FIRST branch: the standard base comes back beside
P7's cross-process 794.4 (0.3% apart) — P7 never ran on a warmer
machine; **the rich stream is genuinely ~3.3% cheaper at depth in
the same process**, and here is the explanation rather than the
dismissal. The codebook bound is an ENVELOPE on the denominators;
the reduced denominators inside it depend on which GCD reductions
fire, and that depends on the hit/miss mix the stream deals each
hypothesis — the numerators' 2-adic content varies with which
atoms arrive how often. A stream moves the LEVEL within the
envelope; it cannot leave the envelope class (XIV.5 states this as
the corollary; P9 instantiates it at 3.3%). XIII.1's headline
survives with its noun made precise: richness does not move the
ENVELOPE — curvature 1.37 both streams, slopes alike — while the
deep LEVEL is weakly stream-dependent at the few-percent scale.

One load-bearing consequence, stated rather than left to a
reader's audit: the acceptance's crossing depths were measured on
the RICH (cheaper-at-depth) stream, so on the standard stream the
crossings arrive a few ticks EARLIER — ~3% of the wire level at
the 5 s crossing is ~165 ms, about ten ticks at the measured
slope. "Near depth 209" holds, with "near" now doing measured
work; the amended acceptance (XIV.6) carries the shift explicitly.

### XIV.2 Rider 2 — the boundary, settled by measurement

The travel was one-directional in two independent cells with
magnitude scaling in |S| — systematic, not noise. The verdict's
arithmetic, reproduced before measuring: |S|=7 enters at 1.924
shallow; under linear |S|-scaled travel its excess reaches ~1.005
by depth 300 and the ratio passes 2.00. The ordered window, |S|=6
same-process at [250..280] (P9 cell iii):

    |S|=6 / base: [6..30] 1.781 | [100..130] 1.807 | [250..280] 1.844
    excess: 0.781 | 0.807 | 0.844   per-pair: 0.1301 | 0.1345 | 0.1407
    implied |S|=7 (1 + 7*per-pair): 1.911 | 1.941 | 1.985

**The travel is LINEAR, not saturating**: per-depth excess growth
0.00027 across the first gap, 0.00025 across the second — constant
pace, no relief at depth. On that pace |S|=7's implied ratio
crosses 2.00 near depth ~315: the stated headroom's first value
fails at achievable session depth, exactly as the verdict's
extrapolation warned.

    [BRACKET r7, 2026-08-06, a verdict conviction disposed: the
    words "constant pace, no relief at depth" over-read the
    figures beside them — 0.000268 then 0.000247 is an 8% decline
    across the gaps, so the honest characterisation is
    APPROXIMATELY LINEAR, MILDLY DECELERATING. The conclusion
    survives the correction (on the second gap's pace the |S|=7
    crossing moves from ~315 to ~317, still achievable depth;
    HEADROOM SIX stands), and "not saturating" remains true — an
    8% deceleration over 150 ticks does not rescue |S|=7. The
    characterisation, not the ruling, was wrong.] XIII.6's drafted envelope line — "a bar of 2
admits |S| <= 7 ordered pairs" — was shallow-only and is
WITHDRAWN; **the headroom statement is SIX**. |S|=6 itself holds
through depth: 1.844 at [250..280], ~1.85 projected at 300, margin
0.15 under a bar of 2. (Cross-process note: P9's shallow ratio
1.781 sits 1.3% under P8's 1.804 — the known process-level spread;
the travel is read within one process and is untouched by it.)

### XIV.3 Rider 3 — the half-slope band retuned to its reproducibility

The convicted draft (XIII.5): "+/-0.15 absolute on the half-slope
ratio." A red that cannot fire: the ratio reproduced at 1.3678
against 1.3678 to FOUR decimals across two structurally different
streams (P7 standard, P8 rich) — the pack's most reproducible
number carried its most generous band, an alarm calibrated to the
noisier of the two quantities. Retuned as ordered, tolerance
placed where the reproducibility is: **+/-0.03 absolute on the
half-slope ratio**; **+/-15% stays on the five windowed means**,
where the ~5% process-level noise actually lives. The final
numbers remain the freeze's call; the draft is now two bands, not
one uniform generosity.

    [BRACKET r7, 2026-08-06, a verdict conviction disposed: the
    justification "where the ~5% process-level noise actually
    lives" cites a number this pack has since disowned — XIV.1
    established the deep-window offset was a STREAM effect, and
    the actual same-stream cross-process spreads are 0.3%
    (792.0 vs 794.4) and 0.85% (765.9 vs 759.4). The band's REAL
    justification, adopted from the verdict: the drift row is a
    diff against FROZEN values re-run over time and possibly on
    different hardware, and a machine change moves a windowed
    mean by far more than run-to-run noise ever will. +/-15% on
    the means is the HARDWARE-TOLERANT band, and a move beyond
    it is a LICENSED RE-MINT of the frozen values — the same
    pattern XIII.5 gives a base-composition change, an instance,
    not a new rule. The ratio's +/-0.03 is tight for the mirror
    reason: a dimensionless ratio of same-process quantities
    survives a hardware change, so nothing wide is owed to it.]

### XIV.4 Rider 4 — the acceptance scoped to its operating point

The drafted clause named K=6/8005 but read as if it covered the
consumer's own pain: the live curve's worst row is K=10 (16010
sentences, p50 6881 ms), where the base is several times larger
and every crossing arrives correspondingly earlier — "crosses 5 s
near depth 209" would be nowhere near true there. The clause is
scoped explicitly (XIV.6): measured at K=6 over 8005 sentences;
the K=10 envelope UNMEASURED and expected substantially tighter.
No K=10 wire run is spent on it (the verdict's own economy); the
scope line keeps the signature from promising what no cell
measured.

### XIV.5 The aperiodicity residual, closed by argument
    [REPAIRED at r6, 2026-08-06: claim 1 as drafted at r5 was
    FALSE. It read "each hypothesis's unnormalized mass after t
    ticks is its prior weight times the PRODUCT of its per-tick
    factors, and multiplication commutes — the posterior after t
    ticks is a function of the tick MULTISET only. No permutation
    of any stream, periodic or not, changes a single denominator."
    The corpus's 40 walk rows (rw — the alphabet's one non-expfam
    combinator, non-exchangeable BY DESIGN) are path-sums through
    the Pos-index rollforward, not commuting products. The claim
    was the builder's STRENGTHENING of the verdict's own correctly
    scoped argument (the divisibility bound) by parallel
    re-derivation — R-D20-i's disease carried from formulas to
    arguments — and it reached the r5 acceptance draft as the word
    "order-invariant". Falsified by execution: P10
    (p10-permute-transcript.txt), 16 ticks vs their reversal,
    Rational ==: the FULL corpus (8005 rows) differs at every
    probe mass; the WALK-FREE corpus (7965 rows) is
    byte-identical. Two-sided — the false claim fired false, the
    correctly scoped claim fired true. The author caught it by
    reading; Part XV is the process repair.]

XIII.1's residual line — "both streams are periodic; no aperiodic
real corpus was replayed" — closes without a measurement, on the
divisibility argument alone (claim 2; the verdict's own scope):

1. EXCHANGEABILITY, scoped and executed: for the expfam fragment
   (7965 of 8005 rows) the unnormalized mass IS a product of
   per-tick factors and products commute, so that fragment's
   posterior is a function of the tick multiset — P10 cell (b),
   byte-identical under reversal. The walk fragment (40 rows) is
   order-dependent BY DESIGN — P10 cell (a), every probe mass
   moved. Order-invariance of the POSTERIOR is therefore not
   available as a premise, and the closure below does not use it.
2. CONTENT- AND ORDER-ROBUSTNESS of the ENVELOPE: for ANY stream
   over the declared world — aperiodic real corpora included, in
   any order — every unnormalized mass after t ticks is a
   POLYNOMIAL whose monomials are products of at most t PER-TICK
   CONTRIBUTIONS, each drawn from a finite codebook-determined
   set: for an expfam row the tick's selected mass (features
   enter only through guard comparisons, which select among
   codebook-constant expressions), for a walk row a
   transition-emission product. Walk masses are sums of such
   products, and sums keep common denominators. With D the lcm
   of the per-tick contribution sets' denominators and P the
   prior's, every denominator divides P * D^t: bit-size <=
   log2(P) + t*log2(D), linear in t with a codebook-determined
   constant, whatever the order and whatever the content.
   (Normalization takes quotients of linear-bit-size rationals,
   which stay linear-bit-size.)
       [BRACKET r7, 2026-08-06: the r6 draft of this clause read
       "products of at most t VALUES drawn from the finite sets
       the declared codebooks fix" — LOOSE for walks, whose
       monomials carry up to 2t+1 codebook values (prior, t
       transitions, t emissions). Caught by the builder while
       DERIVING P11's envelope constant — the gate's naming
       discipline working as designed: preparing the named
       falsifier's arithmetic is what surfaced the loose count.
       The bound's carrier is the per-tick CONTRIBUTION, not the
       value count; the envelope was never in danger (D = 256
       covers the walk contribution) and the clause above is the
       corrected form. EXECUTED at r7: P11
       (p11-bitsize-transcript.txt) measures max denominator
       bits 306/1478/2950 at depths 30/150/300 — linear at
       9.77/9.81 bits per tick (0.4% slope agreement), inside
       the pre-stated 512+16t envelope at every depth; T1 PASS,
       T2 PASS. The claim is now two-route: argued above,
       measured beside it. Corroboration for the acceptance:
       bit-size LINEAR while per-tick cost is superlinear
       (half-slope 1.37) is exactly rational arithmetic on
       linearly-growing operands over a fixed population — the
       drift's mechanism confirmed from a second direction.]

A stream — aperiodic, or the same ticks reordered — can move the
LEVEL within the envelope: which values arrive (and, for the walk
rows, in which order) decides which GCD reductions fire; XIV.1's
3.3% is that effect measured across content, and P10 cell (a) is
the same effect measured across order. It cannot leave the
envelope class the acceptance binds to. The residual closes as a
corollary of claim 2 alone.

### XIV.6 The two mints, as amended (supersedes XIII.6's drafts)

**The bar** (the number is the author's — the slot is left):

    GATE b6: (heir-route ev+ro ms/tick) / (base-route ev+ro ms/tick),
    same stream, same process, matched depth and window,
    <= 2.
    Measured envelope beneath it: |S|=2 = 1.26 and |S|=6 = 1.78-1.80
    shallow; per-pair 0.132, linear; naive-all-pairs 3.64, excluded.
    AT DEPTH (P9): the ratio's travel is linear at ~0.00026/tick of
    excess; |S|=6 holds through depth 300 (1.844 at [250..280],
    margin 0.15 under a bar of 2); |S|=7 crosses 2.00 near depth
    ~315 — a bar of 2 admits |S| <= 6 ordered pairs, stated at
    depth, not shallow.
    Denominator composition pinned per XIII.5; drift row bands per
    XIV.3 (means +/-15%, half-slope ratio +/-0.03).

**The drift acceptance** (operative clause measured, now scoped):

    ACCEPTED as exactness's price: per-tick cost grows superlinearly
    with session depth (half-slope ratio 1.37, stream-shape-robust,
    codebook-bounded, the divisibility envelope order- and
    content-invariant per XIV.5 as repaired — and EXECUTED at r7:
    P11 measures denominator bit-size linear at ~9.8 bits/tick,
    inside the derived envelope, T1/T2 PASS); MEASURED AT K=6
    OVER 8005 SENTENCES, the wire tick crosses 2 s near depth 30 and
    5 s near depth 209 (rich-stream cell; the standard stream's deep
    level is 3.3% higher at ev+ro — its wire-class effect an
    EXTRAPOLATION, unmeasured — shifting the 5 s crossing ~10 ticks
    earlier; the 2 s crossing sits at shallow depth, where the
    streams coincide). The K=10 envelope (16010 sentences, the live curve's
    worst row) is UNMEASURED and expected substantially tighter —
    this acceptance does not cover it. The drift row rides the
    heir's oracle as a GATED diff-vs-frozen (XIII.5, bands per
    XIV.3), and any depth-mitigation work is its own future
    increment under its own demand gate — never a silent change to
    the exact semantics.

Both slots await the author's key; everything beneath them is
measurement or corollary.

## XV. The prose-claim gate (r6, 2026-08-06): drafted for the
sitting, first-fired on this pack

### XV.1 The incident and the gap it names

XIV.5's claim 1 (repaired above, falsified words quoted in its
bracket) entered the pack as the builder's STRENGTHENING of the
verdict's own correctly scoped argument, carried a 30-second
falsifier that was never run, and was caught by the author's
reading. The structural gap: every executable artifact in this
repo has a transcript obligation — R-D21 for oracle rows, clause
(a) for primitivity, SAT overlays for fixtures, the triptych for
greens and reds — and PACK PROSE HAS NONE. An argument-closed
residual is the one deliverable whose entire substance is prose,
and that is exactly where the false claim landed. The second
mechanism is a known disease in a new tissue: strengthening a
supplied argument is R-D20-i's copy-not-reconstruct carried from
formulas to arguments.

### XV.2 The clause, drafted for the author's key (one CLAUDE.md
touch at this increment's freeze, riding OB-27's)

    AN UNWITNESSED ASSERTION OUTSIDE THE MEASURED REGION IS
    EXECUTED OR MARKED. The class has two species: a UNIVERSAL
    CLAIM quantifying over the shipped corpus, its streams, or
    their orderings ("every", "no", "any", "cannot"); and an
    EXTRAPOLATION asserting behavior at depths, K values,
    populations, streams, or hardware beyond what a cell
    measured — the commoner species in a measurement pack.
    Either kind carries an executed witness — a falsification
    attempt against the shipped surface, transcript beside it,
    R-D21's discipline carried from oracle rows to pack prose —
    or is marked ARGUED-NOT-EXECUTED with its cheapest falsifier
    NAMED; naming the falsifier is the load-bearing act, because
    a named-but-unrun falsifier is visibly absurd where an
    unnamed one is invisible. An argument-closed residual closes
    only through its own attempted refutation. AND: A
    STRENGTHENING IS A NEW CLAIM — when the author or a frozen
    text supplies an argument, the pack copies its scope; any
    builder extension beyond that scope is labeled as the
    builder's addition and arrives with its own witness.
    Provenance: the r5 exchangeability incident (pack XIV.5,
    this file) — the author's divisibility bound needed no
    exchangeability; the builder's "improvement" assumed it; the
    corpus's 40 walk rows (rw, non-exchangeable BY DESIGN)
    falsified it; P10 executed the owed falsifier in one minute,
    two-sided. The second species and the sweep-universe line
    below were added at r7, on the verdict's finding that two of
    the three convictions still standing after r6's sweep
    quantified over NOTHING — they asserted apparatus noise and
    depths beyond 280 — so the r6 trigger was aimed at one
    species of a two-species disease.

    THE REGISTER'S UNIVERSE IS QUANTIFIER HITS UNION VERDICT
    CONVICTIONS. A reviewer's written conviction is a custody
    record; the sweep-universe law already derives every sweep's
    domain from custody records, and a register sweep is no
    exception. Every conviction row receives an explicit
    disposition — REPAIRED, BRACKETED, or ARGUED-AND-DECLINED;
    declining a conviction is legitimate, declining it silently
    is not. Provenance: the r7 verdict — three of the four r5
    convictions survived a sweep that grepped for quantifiers
    and never read the verdicts.

### XV.3 The scriptable half, and a candidate seventh mandate

- THE CLAIMS REGISTER: each new pack part carrying universal
  claims lists them as register rows tagged EXECUTED(transcript)
  / ARGUED(falsifier named) / QUOTED(whose words). The register
  is to prose what the satisfiability transcript is to a red row.
- THE AUDIT ROW (tools/boundary-audit.sh candidate): grep new
  pack sections for bare universal quantifiers outside a
  register — a TRIAGE INPUT for the human sweep, never a verdict
  (the M5/H row pattern; the mathematics stays the reviewer's).
- CANDIDATE SEVENTH RED-TEAM MANDATE: "is any universal claim
  executed nowhere?" — whether the mandate list grows is the
  author's call; the six were canonized at step 6 and the list
  has not moved since.

### XV.4 The gate's first firing: the retroactive register over
Parts I-XIV

Swept by quantifier grep plus contextual read; rows are the
genuinely universal claims about the shipped system (law quotes
and verdict quotes excluded as QUOTED by construction). Verdict
of the firing up front: TWO sentences convicted and bracketed in
place (XII.3's window parenthesis; XIII.1's mechanism wording —
the PARENT of XIV.5's falsehood), one row superseded by later
measurement (XIII.3), and NO recorded ruling moved: the r4/r5
rounds had already corrected the substance both times, so the
sweep caught the RECORD lagging the rulings, not the rulings
being wrong. Precedent holds: the lint's first firing convicted
frozen oracles; this gate's first firing convicted its own pack.

    1  I/IV   "nothing frozen touched; every prototype throwaway"
              EXECUTED — manifest 146/146 + porcelain at every
              builder commit (the per-commit checks).
    2  P0     "O(K x population) predictMassS work on every
              decide reply" — EXECUTED: Host.hs readout loop
              (code-cited) + P0's measured wire/ev split.
    3  P3     "reproduces the shipped family EXACTLY" — EXECUTED:
              P3 transcript, 9/9 grid points, Rational ==.
    4  P3     "the declared key is the only design that opens the
              gate" — ARGUED: forced by the frozen pins (test-pin
              ARITY ==; test-readout reference agents through
              enumerateWithArity). Falsifier named: exhibit a
              non-key design green on both frozen suites; the
              pins refuse byte-identity by construction.
    5  P3     "declared family CONSTANT ... at every K" —
              EXECUTED at K in {3,4,6,8,10} (P3) + closed form
              (the population formula carries no K term).
    6  P4     "every orbit member emits identically" — EXECUTED
              on the measured worlds (P4, exact ==); the general
              case ARGUED (dead-atom permutation symmetry).
              Banked design; not riding this increment.
    7  V      "every cell a measurement except rows marked
              (proj)" — pack-self claim, verified by the (proj)
              marks in the table itself.
    8  XII.1  "every Part IV/V cost cell's window, named" —
              EXECUTED: the XII.1 table is the enumeration.
    9  XII.3  "the gate holds at ANY depth (a declared window is
              ... not a soundness need)" — FALSIFIED by P9
              (XIV.2's 35-parts-in-1000 linear travel);
              BRACKETED in place this round.
    10 XII.5  "every measurement is of the sealed engine" —
              EXECUTED: src-tree hash identical across all
              builder commits (the runner stamps).
    11 XIII.1 "every tick's per-sentence masses ... SAME small
              set fixed by the theta codebook" — PARTIAL: exact
              for expfam (7965 rows), loose for walks (40);
              BRACKETED in place this round; corrected mechanism
              = XIV.5-as-repaired claim 2.
    12 XIII.3 "depth-invariance now holds at both measured |S|
              points" — SUPERSEDED by XIV.2: true of the window
              pair then measured; the three-window travel is the
              standing record.
    13 XIII.4 "no ruling in this pack rests on the unreconciled
              cross-K column" — VERIFIED BY ENUMERATION: XIII.4
              itself lists every ruling's basis; the enumeration
              is the witness.
    14 XIV.4  "at K=10 ... every crossing arrives correspondingly
              earlier" — ARGUED, and marked UNMEASURED inside the
              mint itself; falsifier named: the K=10 wire run the
              verdict's economy declined.
    15 XIV.5  claim 2 as repaired: "whatever the order and
              whatever the content, denominators divide P*D^t" —
              ARGUED with the premise code-cited (all factor
              values lie in declared codebook sets, theta AND
              rho); its exchangeability half EXECUTED (P10 cell
              b); falsifier named: a denominator bit-size print
              exceeding the linear envelope at any depth.
    16 XIV.1  "a stream cannot leave the envelope class" — rests
              on row 15; the level half EXECUTED (XIV.1's 3.3%
              across content, P10 cell a across order).

### XV.5 A candidate oracle row, registered (the author rules its
home)

P10 cell (b) is an exact identity with a natural oracle form: THE
WALK-FREE EXCHANGEABILITY ROW — the expfam sub-corpus's posterior
byte-identical (Rational ==) under stream reversal. Cheap (16
ticks), exact, and it pins the walk/expfam partition itself: a
mutant that makes an expfam factor order-dependent (reads a tick
index, threads state) or that mis-tags a walk row breaks it. If
ruled in, it rides test-breadth as b8 WITH its kill per the
forward half; if not, P10 stays a banked transcript. The builder
does not pre-empt the seat.

The r6 round closes here. Standing after it: the two mints
(XIV.6, wording as repaired this round) await the author's key;
the Part XV clause, register row, mandate 7, and b8's seat await
the sitting's ruling; G2, the build-stamp mint, OB-25's advance,
and the Part VIII frozen-layer repairs are unchanged from r4's
list. The builder's next act after the sitting is the
test-breadth/ oracle-first freeze.

## XVI. The r7 verdict's orders, executed (2026-08-06)

The verdict: canonize XV (with its trigger widened), rule b8 in,
decline mandate 7 — and dispose the three r5 convictions still
standing, which the r6 sweep missed because it grepped for
quantifiers and never swept the verdicts. All orders executed
this round; one additional loose sentence self-caught in the
process.

### XVI.1 The standing convictions, disposed

- XIV.3's band justification ("where the ~5% process-level noise
  actually lives" — a number the pack had disowned at XIV.1):
  BRACKETED in place, and the band REFRAMED per the verdict — the
  means' +/-15% is the HARDWARE-TOLERANT band for a diff against
  frozen values re-run over time, a move beyond it a LICENSED
  RE-MINT (XIII.5's pattern, an instance not a new rule); the
  ratio's +/-0.03 is tight because a dimensionless same-process
  ratio survives a hardware change.
- XIV.2's "constant pace, no relief at depth" (an 8% decline
  read as constancy): BRACKETED in place — approximately linear,
  MILDLY DECELERATING; the crossing moves ~315 -> ~317; HEADROOM
  SIX stands. The characterisation, not the ruling, was wrong.
- The acceptance's plural ("moves the crossings") and its
  unmarked wire-class extrapolation: REPAIRED in the mint —
  singular (the 5 s crossing; the 2 s crossing sits at shallow
  depth where the streams coincide), and the 3.3% is stated as
  ev+ro-measured with its wire-class effect marked
  EXTRAPOLATION, unmeasured.
- SELF-CAUGHT while deriving P11's envelope constant: XIV.5
  claim 2's r6 wording "products of at most t values" is loose
  for walks (2t+1 codebook values per monomial); REPAIRED in
  place to the per-tick-contribution form, loose words quoted,
  the envelope never in danger.

### XVI.2 The register amended: universe and addendum rows

XV.2 now carries both amendments in its drafted clause text: the
trigger widened to BOTH species (universals AND extrapolations
beyond the measured region — two of the three standing
convictions quantified over nothing), and THE REGISTER'S UNIVERSE
IS QUANTIFIER HITS UNION VERDICT CONVICTIONS, every conviction
row carrying an explicit disposition (REPAIRED / BRACKETED /
ARGUED-AND-DECLINED — declining is legitimate, declining
silently is not). The addendum rows:

    17 XIV.5 claim 1 (r5 conviction) — REPAIRED at r6, P10
       two-sided.
    18 XIV.3 band justification (r7 conviction) — BRACKETED at
       r7; band reframed hardware-tolerant + licensed re-mint.
    19 XIV.2 "constant pace" (r7 conviction) — BRACKETED at r7;
       ruling stands at headroom six.
    20 the acceptance's plural crossings + unmarked wire
       extrapolation (r7 conviction) — REPAIRED at r7 in the
       mint text.
    21 XIV.5 claim 2 "at most t values" (self-caught at r7) —
       REPAIRED at r7; EXECUTED same round (P11).
    15 (updated) the divisibility envelope — ARGUED -> EXECUTED:
       P11, T1/T2 PASS.

### XVI.3 Row 15's falsifier, executed (P11)

    RUNNER: sha256(binary)=543eb900...  HEAD=3173b7f
      src-tree=ecfd3102...  src-dirty=0  date=2026-08-06T06:21:24+03:00
    depth 30:  max den bits 306   (envelope 992)
    depth 150: max den bits 1478  (envelope 2912)
    depth 300: max den bits 2950  (envelope 5312)
    slopes 9.77 / 9.81 bits per tick (0.4% agreement)
    T1 envelope PASS | T2 linearity PASS

Criteria pre-stated in the probe header before the run (T1: under
512+16t at every depth, the constant derived by hand from the
declared codebooks; T2: slope agreement within 20%, superlinear
fails). The acceptance's central mechanism is now a TWO-ROUTE
claim: argued in XIV.5-as-repaired, measured beside it. Free
corroboration: bit-size LINEAR while per-tick cost is superlinear
(half-slope 1.37) is exactly rational arithmetic on
linearly-growing operands over a fixed population — the drift's
mechanism confirmed from a second, independent direction.

### XVI.4 The rulings, recorded as received

- MANDATE 7: DECLINED. Six stands. The failure mode is prose
  written between sittings; the claims register plus the audit
  row catch it as a standing artefact re-derived each pack, and
  a freeze-time human sweep is the wrong instrument. "Mandate
  lists that grow by one per incident become checklists nobody
  executes" — recorded as the reason, quotable at any future
  proposal to grow the list.
- b8: RULED IN. The walk-free exchangeability identity rides
  test-breadth as an oracle row — sixteen ticks, exact equality,
  two-sided, the only row pinning the walk/expfam partition
  itself; kills in both directions (state threaded through an
  expfam factor; a walk row mis-tagged). It arrives WITH its
  kill per the forward half, at the oracle freeze.

### XVI.5 Standing after r7

The two mints (XIV.6, wording as repaired through r7, the
envelope clause now EXECUTED) await the author's key. The XV.2
clause — trigger widened, register universe amended — is ready
for the freeze's one CLAUDE.md touch alongside OB-27's line. b8
is in the oracle row set; the mandate list stays six. G2, the
build-stamp mint, OB-25's advance, and the Part VIII
frozen-layer repairs are unchanged. The builder's next act after
the mints is the test-breadth/ oracle-first freeze, now carrying
b1-b8.

## XVII. The G2 finding (r8, 2026-08-06): a docket item dissolved
by running the instrument it named

Asked to recommend values for the sitting's two slots, the builder
read G2's actual row before recommending — and the tree
contradicts the docket. test-writeup/check.sh:141-147 records
G1/G2 RETIRED TO RECORD at the step-7 unify freeze (2026-07-17,
the two-sided N8 form): the row pins the close-date quote
("across the eight suites") intact in WRITEUP.md and PRINTS the
live stanza count. Executed now: 33/33 green, G2's own line
reading "RECORD: close-date quote intact; live: 12". The row is
neither red nor an assertion of 8; the derive-vs-retire
disposition this pack docketed for the author was ruled and
executed a month before it was asked. THE DOCKET ITEM DISSOLVES.

The false claim's source is not pack prose. tools/
boundary-audit.sh:136 HARD-PRINTS "test-writeup/check.sh G2
asserts 8 cabal stanzas; the cabal now has N (dated red-by-design
instrument, recorded)" — an unwitnessed assertion about a SIBLING
INSTRUMENT baked into a frozen tool as a courtesy note, stale
since step 7 retired the row, reprinted into every boundary-audit
transcript since (the readout opening's frozen transcript carries
it; this pack's Part II quoted it; XI.5 docketed from it; the
author was one script-argument away from ruling a question
answered a month prior). Two lines ride the record:

- THE GATE'S THIRD TISSUE. r5's falsehood lived in pack prose;
  r7 widened the trigger to extrapolations; this one lived in a
  TOOL'S NOTE about another tool's state — an unwitnessed
  assertion wearing transcript clothes, printed inside evidence
  blocks and quoted faithfully downstream. The kit's candidate
  repair shape: the note DERIVES from the instrument (run the
  row, quote its live output) or is dropped — a tool never
  narrates a sibling's state from memory.
- FL-INVENTORY ROW, added for the oracle freeze's kit:
  tools/boundary-audit.sh:136 (manifest row 144), falsified words
  quoted above, repair under the author's key at the boundary —
  the builder touches the frozen layer only there.

Register row 22: the tool's note / Part II's quote / XI.5's
docket framing — FALSIFIED BY EXECUTION (bash
test-writeup/check.sh: 33/33, G2 PASS as record, live 12). The
gate's third firing, and the first outside pack prose.

Standing after r8: the sitting's fill-in slots reduce to ONE —
the bar's number. G2 needs no ruling. The drift acceptance, the
XV.2 clause, b8, the routed kit work (now including the
boundary-audit note repair), and everything else stand as at r7.
The close script and tag message are amended to match.

## XVIII. The oracle phase (r9, 2026-08-06): test-breadth/ built
red-first under the sitting's authority

The sitting closed at breadth-sitting-r0 (author key over 197269b);
this part is the builder's record of the oracle phase it authorized.
Everything here is builder work product awaiting the author's freeze
review; nothing frozen was touched (the kit stages every frozen edit
as a patch, applied only by 2-freeze under the freeze's own checks).

### XVIII.1 The type surface (the stub commit, 4b6c9f7)

`src/PropLang/Enumerate.hs` gains `Breadth` (declared ordered pair
list + null-face flag; the type-audit derivation line rides the
declaration: world-declaration data, deletable-and-declarable, no new
production — the declared families are If/Gt/catBody sentences, so no
primitivity clause is owed) and `enumerateWithBreadth`, stubbed
wrong-but-total (delegates to `enumerateWithArity`, ignores its
Breadth). `Host.hs` is deliberately UNTOUCHED in the oracle phase:
`hello` ignores unknown world keys, so a breadth-bearing hello is
accepted-and-ignored at HEAD — the wire rows run red naturally, and
the refusal surface is owed entirely to the implementation. All 12
frozen suites ran green against the stub (cabal test all, exit 0,
12/12 PASS) before the oracle was written against it.

### XVIII.2 The oracle as built (20 rows, 9 groups)

Groups b1-b8 plus the gated drift row, per the ratified row set. The
as-built decisions, each stated so the freeze review can refuse it:

- THE WIRE SYNTAX (register U1): `"breadth": {"pairs": [[jHi, jLo],
  ...], "null": true|false}` inside `world`; both keys optional;
  `{}` and the explicit empty declaration are BYTE-IDENTICAL to the
  absent key (b4d). Refusals (b4c, all fail-closed as bad hello):
  a==b, atom outside [1..K-1] (0 included — the null atom is not a
  positive atom), any pair at K=2, null at K=2 (the P2
  exact-duplication law), duplicate pairs (a codebook is a set;
  register U2), malformed values.
- THE ANCHOR-SIDE LAW applied: wire-facing worlds are SIXTEENTHS
  (n/16 exact in Double — declared decimal == exact rational by
  construction); the probe21 world (exact tenths) is library-only.
  Stated per row in the suite header.
- ONE GENERATOR: every wire tick DERIVES from streamC (the
  probe-discipline law; the first draft carried a parallel
  hand-written tick list and a hand-written probe assignment — both
  replaced by derivation from streamC before anything ran; the
  two-lists drift shape made unsayable).
- THE #21 SEMANTICS (b3): the red fires on the TIE-STRENGTH margin,
  not on argmax — the rehearsal transcript shows the exact engine
  already resolving the double-render tie to argmax 3 by 4e-32 at
  the stub, exactly as pack IV P1 recorded; the discriminating
  criterion is P(3) > 1/2 (R-RED: the margin is the #21 tie itself).
- b5a CARRIES AN ASYMMETRIC CELL (S = [(3,2)], null on) beside the
  #21 operating point, because [(3,2),(2,3)] is CLOSED under
  per-pair swap — a door-side swap defect is structurally invisible
  to the symmetric set, and falsifiability demanded a cell where
  that defect class fires (defect-d7 fires there and nowhere else).
- b6 rebuilds the deleted test-measure law: population pins as
  exact-integer GATES (8005 with its closed form re-derived from the
  declared grids beside it), absolute ms as REPORT rows, the ratio
  GATE <= 2 at matched depth AND window [6..30] (the mint's cell,
  XIII.5), the composition RECORDED beside it (a composition change
  = licensed re-mint, quoted in the row), the walk-exclusion census
  (b6d: the partition by tag is exhaustive and walk-count-preserving),
  and OB-3's run-each-freeze half re-homed (the suite rides gate 5).
- b7's independent entropy: computed from `metaPosterior` directly
  in the suite; `entropyAgent` appears ONLY inside the ev+ro class
  definition (P0's executed shape, copied byte-wise) — the class
  definition and the pin are different rows, stated in the suite.
- THE MINT MODE: BREADTH_MINT=1 makes frozen-value rows PRINT and
  never gate — the instrument's own mint law (XIII.5), so the mint
  and the gates share one code path (no parallel mint program to
  drift). The standing form (no env var) is what gate 5 runs.

### XVIII.3 The mint (XIII.5's law, executed)

The official mint (the SECOND mint — the first, under the LS
half-slope statistic, stands superseded by U7's ruling; its values
are U7's data): one quiet build-stamped run of the final suite
text, mint mode, transcript test-breadth/opening/mint-run.txt:

    BUILD-STAMP sha256=21a21d9e... HEAD=4b6c9f7
      src-tree=bb62e9789d68c5e17ab053b33c8eb7c477e978c8 src-dirty=0
    windows [6..30]/[50..80]/[100..130]/[150..180]/[250..280]:
      437.8 / 599.9 / 786.4 / 999.6 / 1500.6 ms
    deep/shallow mean ratio 1.9964 (the drift cell first-in-suite)
    composition at [6..30]: ev 66.7, of which walks 24.9;
      ev+ro 435.5; wire (in-process combined tick) 824.2
    b7 entropy delta 0.000e0; 12 out of 20 red (the stub set)

(This run sat ~3-4 percent warmer across the board than its
predecessor — box-state variance of exactly the kind the +/-15
percent mean bands absorb and the ratio statistic cancels.)

The frozen literals in Breadth.hs derive from that transcript and
from nothing else (1-verify checks the derivation MECHANICALLY:
every frozen literal must appear in mint-run.txt). One reading note:
the transcript's own "(frozen ...)" parentheticals show the
PRE-MINT placeholder values the run was born with — the mint mode
exists precisely so those never gate; the REPORT numbers are the
mint. The wire composition cell (824.2) sits well under the opening
P0's 1870: the two worlds differ in menu width (this suite's
single-point forced-act menu vs P0's four options) and in utility
shape, so the cells are DIFFERENT INSTRUMENTS, not a drift —
ARGUED-NOT-EXECUTED that the menu width carries the difference;
cheapest falsifier: one wire run of this suite's world with a
four-option menu (claims register row 9). What is load-bearing is
narrower and holds by construction: the gate's denominator
composition is THIS suite's own cell, recorded at its own mint
(XIII.5's law binds the row to its mint, not to a sibling probe's
world).

THE QUIET-BOX FINDING (no-silent-caps; register U6). The windowed
MEANS reproduce to ~0.6 percent across runs, contended or not. The
HALF-SLOPE RATIO does not: under a parallel compile load it read
1.3565 and 1.3120 in two runs; quiet back-to-back runs read 1.3681
and 1.3562 (spread 0.012, and the first quiet value reproduces P7/
P8's canonical 1.3678). The minted +/-0.03 band therefore holds with
roughly 2.5x margin ON A QUIET BOX and can false-fire under heavy
contention — the instrument inherits the deleted test-measure's
implicit law that a measurement run owns its box. RESIDUAL, stated:
gate-5 runs at future freezes should not share the box with heavy
parallel load; the band itself is the sitting's mint and is not
retuned here.

entropyTol (b7): measured floor 0.0 — bit-identical Doubles, by
IEEE negation symmetry the two summation forms coincide exactly —
so the gate is 1e-12, the repo's smallest standing gate class above
an exact-zero floor (the CL-4 precedent; a zero-width gate would
re-fail on any innocuous refactor of summation order, which is a
rendering change, not an entropy change).

### XVIII.4 The red side (the triptych's first run)

At the stub, the recorded red set is EXACTLY the partition in the
suite header — opening/red-run.txt (the FINAL run, post-U7, final
bytes), gating mode, quiet box, exit 1:

    RED (12): b1b b2a b2b b2c b2d b3a b3b b4a b4c b5a b5c b6d
    GREEN (8): drift-a b1a b1c b4d b7a b8a b6a b6b
    "12 out of 20 tests failed (361.68s)"

and the drift row GATED green against the minted literals in the
same run (deep/shallow mean ratio 1.9939 vs frozen 1.9964,
|delta| 0.0025 — the re-stated statistic behaving as designed;
means inside +/-15). The run history is stated, not collapsed
(the readout precedent): the FIRST final-bytes red run, under the
superseded half-slope statistic, came back 13/20 when that gate
FALSE-FIRED on quiet-box noise — preserved as
opening/halfslope-falsefire.txt, U7's evidence. Every FAIL prints
its expected side in normal form (tasty's comparison output) — the
transcript IS the forcing record for the frozen side of each
comparison row (the step-1 deepseq clause's discharge shape,
stated rather than left to inference).

The eight green-at-stub rows' reds are SEEDED-DEFECT demonstrations
(the pin-freeze clause's form), one named minimal defect per shape,
compiled as overlay variants and run against the exact frozen text:

    defect  seeded shape                          fired (transcript)
    d1      empty declaration injects a family    b1a, b1c (2/2 lib
            (library side)                        rows; defect-d1.txt)
    d2      arity atom dropped (posAtoms K-2)     b6a (defect-d2.txt)
    d3      naive pair family default-on          b6b: ratio MEASURED
            (all ordered pairs, unpriced)         3.704 > bar 2 - the
                                                  R-RED constructed
                                                  crossing, beside
                                                  the pack's 3.64
                                                  record
    d4      entropy sign dropped (M8's shape)     b7a: wire -3.891 vs
                                                  independent +3.891,
                                                  delta 7.78 bits
    d5      walk row mis-tagged ("wexp")          b8a (defect-d5.txt)
    d6      readout fold duplicated (a lost       drift row: all five
            fast path's shape)                    means blown (~+96%,
                                                  856.4 vs 437.8 at
                                                  the first window);
                                                  the mean ratio
                                                  little moved
                                                  (1.9364) - a
                                                  proportional cost
                                                  defect fires the
                                                  MEANS, exactly as
                                                  the shape predicts;
                                                  the ratio gate's
                                                  own kill is the
                                                  depth-differential
                                                  class
    d7      pair swapped at the door (wire-only,  b5a's ASYMMETRIC
            count-preserving)                     cell (the symmetric
                                                  #21 cell cannot see
                                                  it - the cell
                                                  exists for exactly
                                                  this)
    d8      the door's empty-object null          b4d: the {} hello
            defaults ON (asymmetric door defect)  grew a null face
                                                  (models 9598) while
                                                  absent stayed 8005

ATTRIBUTION NOTE, recorded as found: d1 was first pointed at b4d
too, and b4d stayed GREEN under it — CORRECTLY. Both of b4d's hello
routes pass through the same enumeration call, so a library-side
injection moves them TOGETHER; b4d pins the EQUALITY (empty
declaration == absent key), never the absolute (the absolute wire
count is the standing corpus's pin). The r1a both-sides-move-
together lesson, met inside the oracle's own red battery and
answered by d8: the b4d red must be a DOOR-side asymmetry, and is.

These EIGHT shapes are the DRAFTED KILL-POOL CANDIDATES for the
close matrix (the forward half; M8 = d4 promotes as b7's kill per
OB-31's row).

### XVIII.5 The SAT side (R-D21, overlay form, flag- and
package-faithful)

The overlay realization — the implementation's prophecy: the real
`enumerateWithBreadth` (dpair family per Declared.hs's recorded
shape; null faces per NullRate.hs's; `allowed`-gated like its
siblings) and the Host breadth key (parse, validation, refusals,
`pop` routed through `enumerateWithBreadth`; the plain no-arity
route untouched). The oracle's exact frozen text compiles against
it UNCHANGED and runs ALL 20 TESTS PASSED (opening/sat-run.txt,
the FINAL run, exit 0, 366.98s, quiet box; the transcript
reproduces P2's exact prices — nullconst 7.17 bits, guarded-null
15.92 bits — and prints dpair 14.92 bits; the heir's
operating-point ratio measures 1.394 under the bar of 2; the drift
cell reads 2.0323 — the cross-build shift, stable at ~+0.036
across two SAT runs, inside the ruled +/-0.06). The compile is the
stanza's dependency closure and flag set verbatim:

    cabal exec -- ghc -Wall -Werror -Wincomplete-patterns
      -Wincomplete-uni-patterns -XGHC2021 -hide-all-packages
      -package base -package containers -package directory
      -package process -package proplang(/overlay: -i<overlay>)
      -package tasty -package tasty-hunit -O1

(the -package containers rides only the overlay compile, where the
library's own closure is inlined — the jp package-faithful clause).
The overlay is discarded with the session scratchpad (R-D21); its
diff against src rides as test-breadth/opening/prophecy.diff (the
readout precedent: Phase 3 applies the prophecy byte-for-byte or
reports why not). The flag-faithfulness paid immediately: the
overlay Host's first compile FAILED on a redundant import under
-Werror (the step-5 incident's class, caught by the discipline that
exists to catch it).

### XVIII.6 The R-D20-i copy table (anchors: commit + binding name)

    quantity                    copied from
    8005 (b6a pin)              pack IV P0 at 7b765fa (the K=6
                                models cell); closed form re-derived
                                beside it from the declared grids
    catBody/eqE family shapes   src/PropLang/Enumerate.hs at 4b6c9f7,
    (the overlay's dpair/null)  bindings `catBody`, `eqE`; via the
                                probes' recorded byte-shape copies
                                (pack IV P2/P3)
    dpair tag+charge form       pack IV P3 (Declared.hs transcript),
                                binding `declaredFamily`
    nullconst/nullguard forms   pack IV P2 (NullRate.hs transcript),
                                bindings `nullConsts`/`nullGuarded`
    refVecAt reference route    test-readout/Readout.hs at 0766ebe,
                                binding `refVecAt act ag`
    rD rendering                Host.hs rendering via test-readout's
                                `rD` (COPY note in both suites)
    D2 MAP tag ("dpair",        pack IV P3 D2's transcript line
    [3,2,0,7,8])
    P2 S1/S2 criteria + MAP     pack IV P2's pre-stated criteria
    ("nullconst",[0,6])
    the bar 2, the bands        breadth-sitting-r0's tag message /
    (+/-15%, +/-0.03)           pack XIV.6 as minted
    drift + composition         test-breadth/opening/mint-run.txt
    literals                    (the transcript itself; checked
                                mechanically by 1-verify)

### XVIII.7 The freeze kit (test-breadth/freeze/)

1-verify (read-only: patch list extracted from 2-freeze's own apply
lines, orphan check, sequential apply on a temp copy, mint-literal
trace, [MINT]-marker guard) / 2-freeze (keyless: OB-29 live probe
BEFORE any mutation; the five patches; gate 5 asserting the EXACT
frozen red set beside 12 green standing suites; manifest extension +
re-sign AFTER the lint rows exist — OB-26's order, honored by
construction; the L8/L9/L5 two-sided demo in a whole-tree copy; the
lint at 0 FAIL) / 3-sign (the freeze commit; the -m is a
kit-authored constant, the attestation rides the tag) / 4-close (the
tag by -F from the COMMITTED message file, minted == file verified
byte-wise — the r1 record-row form). The five patches and their
authorities are tabled in freeze/SITTING.md. The kit's own sig-probe
tags ride -F nonce files (no -m anywhere in the kit; L9 scans it
like any kit).

Rehearsal (opening/rehearsal.txt, fresh clone, discarded after; the
readout precedent — the tag minted in-clone with the BUILDER key):
GREEN SEALED END-TO-END — 1-verify, 2-freeze (the gate-5 run
asserting the EXACT frozen red set beside twelve green standing
suites; the six-sided lint demo "ALL SIX SIDES DEMONSTRATED"; the
manifest extended and re-signed AFTER the lint rows; the pre-freeze
lint at 0 FAIL 0 WARN with L8 and the hardened L9/L5 live),
3-sign, 4-close with breadth-freeze-r0 minted by -F, verifying,
and the minted message BYTE-IDENTICAL to the committed file. ALL
FOUR KIT REDS FIRED first, each reverted before the green path:
R1 the refused key aborts 2-freeze at step 0 with the tree
untouched (OB-29's red); R2 an orphan patch stops 1-verify; R3 a
surviving [MINT] marker aborts 2-freeze; R4 a frozen literal
absent from the mint transcript stops 1-verify's mechanical trace.

### XVIII.8 The under-determination register (for the freeze review)

- U1 the wire syntax as drafted (XVIII.2); absorb or amend.
- U2 duplicate pairs REFUSED (a codebook is a set; re-pricing by
  repetition would make |S| a mention-count, not a codebook size).
- U3 the null face's price keeps P2's EXECUTED form (constCharge/
  guardCharge x arityMass on the theta codebook). The alternative —
  no atom-mention factor, on the reading that the flag names atom 0
  uniquely — is REGISTERED, NOT CHOSEN: choosing it would re-derive
  where the probes executed; the author may amend at the freeze (it
  moves null prices by log2(K-1) bits and no oracle row pins the
  absolute price — b2c pins independence, b2a pins Kraft).
- U4 K=2 semantics are UNIFORM, no special case: any nonempty
  declaration refuses by range/duplication/the null law; the empty
  declaration is the shipped route (b1c/b4d). Breadth never couples
  to whether obs_arity was declared.
- U5 the ratio gate's matched cell is window [6..30] (the mint's
  own cell, XIII.5); depth travel stays the sitting's record.
- U6 the quiet-box operational assumption (XVIII.3's residual).
- U7 STOP-AND-REPORT, the half-slope band's REALIZED margin. The
  sitting minted +/-0.03 absolute on the four-decimal cross-stream
  reproduction (1.3678 vs 1.3678, P7/P8 — same session, back to
  back). The oracle phase measured the statistic's RUN-TO-RUN
  spread on a quiet box: 1.3681, 1.3562, 1.3716 (the mint), 1.3477
  (the gating red-run, which PASSED with 0.006 of band left) —
  peak deviation from the minted value 0.0239 on four runs. The
  band as minted will pass most quiet runs but sits within noise
  of firing spuriously; a red that fires on noise is the mirror
  defect of a red that cannot fire. NOT retuned by the builder
  (the band is the sitting's number). STRENGTHENED BY THE SAT RUN:
  its half-slope read 1.3450 (|delta| 0.0266, 0.0034 of band left)
  — five quiet measurements now span 0.0266, and BOTH gating runs
  passed within 0.007 of firing. As frozen, the row should be
  expected to false-fire within a few freezes. Two candidate
  remedies for the freeze review, either under the author's key at
  the boundary: widen the band to clear the measured spread (e.g.
  +/-0.05, ~2x the observed peak), or re-state the statistic to
  the windowed-MEAN ratio mean[151..300]/mean[6..150] (the means
  reproduce to ~0.6 percent same-shape; note the PROCESS-SHAPE
  effect below) and re-mint from the standing transcript. The five
  windowed-mean gates are unaffected in kind but see a
  PROCESS-SHAPE offset: the SAT process (heir populations live in
  earlier rows) ran its drift means ~+7 percent over the mint
  (448.6 vs 417.8 at [6..30]) — the heap the suite's earlier rows
  leave behind is part of the cell; at the implementation's
  process shape the +/-15 band retains ~8 percent margin. Recorded
  so the Phase-3 gate-5 reader is not surprised.

  U7 RULED AND EXECUTED (the author, 2026-08-06, in-session:
  "Re-state the statistic to the windowed-mean ratio"). Before the
  ruling arrived, the prediction had already fired: the final-bytes
  red run's half-slope read 1.3339 (|delta| 0.0377 > 0.03) on a
  quiet box and the drift gate FALSE-FIRED — 13/20 red against the
  frozen 12; the transcript is PRESERVED as
  opening/halfslope-falsefire.txt (the U7 evidence run; seven
  measurements, realized span 0.0439). EXECUTION, two halves:
  (1) the statistic is now the DEEP/SHALLOW MEAN RATIO
  mean[151..300]/mean[6..150], the band value kept at +/-0.03
  absolute; (2) the drift cell MOVED FIRST-IN-SUITE. The second
  half was forced by a discovery made while executing the first:
  the process-shape inflation is DEPTH-DEPENDENT (+7.4 percent
  shallow vs +1.5 percent deep at the SAT run), so a mean ratio
  measured after the heir populations would shift ~-0.06 across
  the stub-to-implementation boundary and the re-stated gate would
  false-fire at Phase 3 through a different door. A first-in-suite
  cell owns a fresh heap in BOTH suite shapes; the two standalone
  quiet drift runs (fresh-process, the same cell shape) put the
  proxy mean-ratio spread at 0.002. The re-mint, red and SAT runs
  below all postdate the re-statement.

  U7's SECOND RULING (the author, 2026-08-06, in-session, on the
  presented measurement): THE BAND IS +/-0.06. The first
  re-statement run pair measured the statistic's two noise scales:
  WITHIN a library build +/-0.0012 (red run 1.9976 vs mint 1.9964)
  — but ACROSS builds +0.037 (the SAT/overlay build read 2.0334).
  [AUDITABILITY REPAIR, the mandate round (mandate-3 F1): that
  interim pair's transcripts had been OVERWRITTEN by the final pair
  — the ruling's cited numbers survived only in prose. Rescued:
  opening/interim-pair-record.txt carries the interim pair's
  numbers verbatim from the session task log, and
  opening/sat-run-prior.txt is the preserved half-slope-era SAT
  transcript (its mean-ratio line reads 2.0334). The FINAL
  preserved pair reproduces the same structure: red 1.9939
  (|delta| 0.0025 within-build), SAT 2.0323 (+0.0359 cross-build)
  — the ruling's conclusion holds on the preserved record.]
  The mechanism:
  the overlay module's added code moves GHC's codegen
  differentially by regime, the overhead-bound shallow windows
  ~-5 percent against the bignum-bound deep windows' ~-3 percent,
  and the implemented library at Phase 3 inherits exactly that
  shift. A +/-0.03 band minted stub-side would have false-fired at
  the first implementation-side gate 5 — the same trap through a
  third door, caught by the SAT run before the freeze. +/-0.06
  covers the measured cross-build shift with margin; real shape
  defects (the d6 class, leaks, superlinear regressions) move the
  means and the ratio far beyond it. The alternative (keep
  +/-0.03, pre-declare a licensed re-mint at the implementation's
  close) was presented and declined in favor of the
  self-contained band.

- U8 THE OUTPUT TAG VOCABULARY (mandate-4 F9): the freeze pins the
  (String,[Int]) hypothesis tags dpair/[jHi,jLo,kt,a,b],
  nullconst/[0,k], nullguard/[0,kt,a,b] — the slot meanings are
  stated at their oracle uses and in the membrane bullet's family
  description; the vectors are functions of the declared grid order
  (a grid edit moves them; the rows fail closed). Absorb or amend.
- U9 THE theta=1/K SCOPING (mandate-1 F4): the K=2 refusal's
  mechanism is theta = 1/K family-WIDE duplication; at K >= 3 the
  shipped corpus already carries POINTWISE duplicate emitters at the
  grid point theta = 1/K (executed census at the mandate round:
  four const rows + the nu = 1/5 null face emit one identical
  vector on the probe21 world) — prior-mass structure, not family
  duplication; no frozen row sits on the duplicate point. The
  unstated converse ("K >= 3 is clear") is hereby stated as SCOPED:
  clear of FAMILY-wide duplication only.
- U10 b8a'S SCOPE (the d9 dead ends, both executed): the reversal
  identity detects IRREVERSIBLE threaded state; a reversible-chain
  latent (symmetric kernel, uniform prior) passes it, and a row
  whose likelihood cannot vary on the stream hides any kernel. b8a
  pins the walk/expfam partition plus irreversible-state exclusion;
  it is not a universal no-state row. Recorded at the row's kill
  (defect-d9.txt).
- U11 THE AUDIT ROW'S OWN BLIND SPOTS (mandate-2's scope
  observation, a NEXT-boundary candidate, not this kit's scope):
  tools/boundary-audit.sh's M5 row scans top-level *.md only (the
  suites, patches and tag messages are outside it) and its ID regex
  cannot match R-RED; candidate hardening rides the next
  boundary-audit touch under its own ruling.
- U12 L8 AND ROUND-LABEL REPAIRS (mandate-5 adjacent): this pack's
  repair rows anchor to ROUND labels ([REPAIRED at r6]) rather than
  commit hashes, so L8 runs green-by-vacuity against it (0 pairs;
  the two-sided demo carries the row's teeth). The recorded-repairs
  rider binds hash-citing rows; whether round-label rows OWE hashes
  is a register question for the close.

### XVIII.9 The claims register (LIVE — the gate's first
post-canonization firing, over this part and the suite header)

    1  "hello ignores unknown world keys" — EXECUTED: the rehearsal
       and mint transcripts show breadth-bearing hellos ACCEPTED at
       the stub (b4c/b5a red messages quote the ok:true replies).
    2  "n/16 is exact in Double" — ARGUED (dyadic representability
       within the mantissa); falsifier named: a sixteenth failing
       round-trip show/read against its Rational.
    3  "the two entropy forms coincide bit-identically" — a THEOREM,
       not a measurement (mandate-1 F2: the independent form is
       entropyOf's expression rearranged, same traversal order;
       IEEE negation symmetry closes it); the executed prints
       (delta 0.000e0 at every run) are its instances. The row's
       real content is the posterior route — restated in the suite
       and the OB-31 ledger row; the gate is exact ==.
    4  "[(3,2),(2,3)] is closed under per-pair swap" — ARGUED (set
       equality of the comprehension under (jHi,jLo) exchange);
       falsifier named: enumerate both families and compare by ==;
       defect-d7's non-firing on the symmetric cell is the same
       fact's executed shadow.
    5  "the walk rows are the only order-dependent rows" — EXECUTED:
       P10 cell (a) vs (b) at r6, re-executed as b8a's SAT green
       over the heir corpus (declared rows included).
    6  "means reproduce ~0.6%, half-slope spread 0.012 quiet /
       -0.056 contended" — EXECUTED: the four recorded runs
       (XVIII.3; transcripts in the session record, the official
       mint in opening/).
    7  "every world declared on ONE side of the parse" — VERIFIED BY
       ENUMERATION: two worlds; sides stated at their definitions.
    8  "the stub is wrong-but-total; 12 frozen suites green against
       it" — EXECUTED: cabal test all exit 0 at 4b6c9f7.
    9  "the wire cell's gap to P0's 1870 is the menu width" —
       ARGUED-NOT-EXECUTED (XVIII.3); falsifier named there. The
       load-bearing half (the gate binds to its own mint cell) holds
       by construction and needs no measurement.
    10 "a symmetric kernel with the uniform prior is reversal-
       invariant" — EXECUTED the hard way: the first d9 draft built
       exactly that kernel and b8a correctly stayed green
       (U10; the theory reading beside the run).
    11 "the fold-order bias is systematic and anti-conservative" —
       EXECUTED: -1.3 percent across three independent stub runs
       (0.986/0.985/0.990 where the stub's true ratio is exactly
       1.000); the b6b warm-ups are its repair.
    12 "the b6b/drift [6..30] literals are one quantity at two
       process positions" — EXECUTED: both minted in one transcript,
       0.5 percent apart; stated at the b6b comment (mandate-5 F3).

### XVIII.10 Mandates, audit, standing

THE MANDATE ROUND (six fresh-context reviewers, one mandate each;
full reports in the session record; every disposition executed
BEFORE the freeze, in the repair wave this section closes):

MANDATE 1 (theorem-as-definition) — 5 findings, headline a
RE-CONVICTION: b4a re-installed the p0<=cap theorem the readout's
r5a had already convicted under this same mandate, with min-theta
hand-written and the frozen 1/(K-1) silently strengthened.
REPAIRED: cap derived from the named list; the two cap forms
separated (frozen premise vs builder's witnessed tighter form);
both relabeled RECORD; the witness executed (max p0 over the whole
probe21 corpus == the tight cap exactly, walk-free and walk-live —
the reviewer's own throwaway probes, R-D21 discipline). F2 (the
entropy floor is a theorem and the "independence" is nominal):
REPAIRED — gate to exact ==, comments and OB-31's row restated to
the posterior route. F3 (b8a's second kill direction unexecuted):
REPAIRED — defect-d9 built and fired, two dead ends recorded (U10).
F4 (theta=1/K scoping): REGISTERED as U9 with the reviewer's
executed duplicate-emitter census. F5 (additivity/count anchors):
REPAIRED in the copy table; b2b's provenance now cites the frozen
mentionMass binding.

MANDATE 2 (asserted-never-derived) — no strict instance; 4 naming/
custody defects. REPAIRED: the "draft-stanza precedent" glossed in
the tag message (its only definition site was nowhere); the bare
VII.1 anchor in the suite now names dispositions-pack.md; the mint
law's citation sharpened to "XIII.5's gating clause, executed at
XVIII.3"; and THE CUSTODY FINDING — the drift band's operative
authority — is now stated in the tag message in its own words:
signing breadth-freeze-r0 IS the act that amends the sitting's
minted band. The M5-row scope observation: REGISTERED as U11
(next-boundary candidate).

MANDATE 3 (load-bearing quantity defined nowhere) — 5 findings +
one vacuity observation. F1 (the band ruling's cited numbers in no
preserved transcript): REPAIRED — the interim pair rescued into
opening/ (interim-pair-record.txt, sat-run-prior.txt), U7 amended
with the auditability bracket, and the preserved final pair
reproduces the ruling's structure. F2 (the mint-fixpoint identity):
REPAIRED STRUCTURALLY — the final sequence commits the pre-fill
text FIRST, mints against committed bytes (the stamp's HEAD then
proves the identity), fills, and commits again, so the two commits'
diff IS the literal fill; stated below at the run record. F3
(entropyTol's dead precedent): REPAIRED — the gate is exact ==; the
convicted citation is quoted inside the suite's own repair. F4 (the
rD anchor): REPAIRED to the rQ binding. F5 (nullguard coordinates
unsourced): REPAIRED — layout + arbitrary-member note at the row,
copy-table row added. F6 (SITTING.md's seven-for-eight): REPAIRED
(d1-d9, lowercase). The L8-vacuity observation: REGISTERED as U12.

MANDATE 4 (type without derivation) — 9 findings; the sharp one
RULED by the author: THE LADDER CLIMBED — Breadth is abstract,
mkBreadth the one validator, the door its caller, the oracle
constructing through it. F1-F4/F6 (the derivation line's unadopted-
doctrine citation, the one-clause two-field derivation, the
type-vs-value slip, the unstated placement, the present-tense
refusal): ALL REPAIRED in the rewritten derivation block. F7 (Tick):
line added. F8 (no membrane install): REPAIRED — membrane-breadth
.patch joins the kit (the sibling increments' form) with the R-D23
heir-landed pointer. F9 (output tag vocabulary): REGISTERED as U8.
The adjacent stale-header conviction (the band comment one ruling
behind): REPAIRED in the header rewrite.

MANDATE 5 (silently overloaded conventions) — 10 findings.
REPAIRED: the three "mint" senses DECLARED in the suite header with
the re-mint's authority stated (an author act at a boundary,
executed through an instrument run); the dup-list comment renamed
off "drift" (the two-lists disease); the register-sense
disambiguation added inside the prose-gate clause; SITTING.md's
D1-D7 -> d1-d9 and the kit-guard-reds wording; the b4a test name
carries "criteria S1/S2"; the b6b comment states GATE b6 == row
b6b; the same-quantity-two-positions note at b6b (with claims row
12). REGISTERED: the r-numbering collision (bare r1 = the readout
tag vs this pack's rounds — the convention note rides here: THIS
pack's bare rN names its own rounds, and every cross-increment rN
is qualified by its increment's name), the "null":null JSON seam
(disposed as malformed -> refused, now stated rather than implied).

MANDATE 6 (what is it a function of) — 11 findings on the
instrument's unstated dependencies. REPAIRED: NumThreads 1 pinned
in code with the dependency stated (F1); the MINT-MODE marker's
ABSENCE asserted by 2-freeze's gate-5 check (F2 — the two
frozen-literal gates were silently disarmable by ambient
environment); b6b warm-up folds with the measured bias quoted (F3);
the position dependency and same-quantity note at b6b (F4); the
build-driver dependency stated in the residuals with the freeze's
gate5-run.txt named as the cabal-built record (F5); the entropy
dependencies stated at the == gate (F6); the closed forms' full
input list stated (F7); nullCap derived from the named source list
(F8); the red-set list named ONCE in 2-freeze with the count
derived and the -A6 budget documented (F9); 1-verify's PAIRED
literal trace (F10); the wire column's base-route-by-design note
printed by the row itself (F11).

The reviewers' executed probes (Cap.hs, Dup.hs — mandate 1's
witness programs) ran as throwaway R-D21 prototypes in the session
scratchpad; their findings are quoted above and in U9.

THE BOUNDARY AUDIT (opening/boundary-audit.txt, run on the PRE-KIT
tree by design): M5=0 H=0 BF=0, OB=2 — the two flags are OBLIGATIONS
lines 54,55 (OB-26/27, open against closed readout-freeze-r0) and
56,57,59 (OB-28/29/31, open against closed readout-freeze-r1):
EXACTLY the rows this kit's obligations-heir.patch advances. The
audit is the triage input that says the kit is aimed at the right
rows; applying the kit clears both flags. The transcript's standing-
observations note still prints the STALE G2 sentence — as it must:
the transcript documents the pre-repair tool, and the fl-repairs
patch is what retires that sentence (pack XVII's routing).

Standing after r9: the oracle and kit await the author's freeze
review (1-verify, SITTING.md, tag-msg.txt); the freeze's key acts
are the author's (or delegated with R-D22's re-tag owed). After the
tag: Phase 3 — the prophecy applied, gates 1-7, the kill matrix
against the grown pool, the close-out pack, the countersign, then
publication and #19.
