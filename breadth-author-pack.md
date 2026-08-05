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

The constant factor alone exceeds the naive family's multiplier, and
it composes with P3/P4.

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
