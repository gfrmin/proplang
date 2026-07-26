# x5-author-pack.md — the X.5 sitting pack (builder-authored, unfrozen)

Prepared 2026-07-26 against HEAD = `0460b9a` (exact-freeze-r1, author
tag VERIFIED). Session-opening verification, all four checks clean:
the three-tag chain r0/r0a/r1 each `git tag -v` GOOD under the author
key (SHA256:Sfh8OBG9...); MANIFEST 56/56 OK; gate 5 `cabal test all`
exit 0, six suites PASS; prefreeze-lint 0 FAIL / 0 WARN (L7 green).
Nothing frozen touched this session; every commit builder-key.

Contents: Track 1 = the five X.5 residue items (item 3 leads) + two
tidy items; Track 2 = OB-12's differential corpus run; Track 3 =
EXACT_PLAN §13 drafted (the trampoline charter — opens NOTHING until
your ruling). The decision sheet closes the pack.

---

## Track 1, item 3 — THE LEAD ITEM: the dyadic lattice coordinate (the R-R1 re-open)

This item gates the trampoline (the think/refine rungs live in
Lattice/Purchase; §13's charter records the dependency). Three
grounds, EACH RE-EXECUTED against HEAD this session (probes in the
session scratchpad `x5/`; GroundA reads only declared exports —
rootNode/childrenOf/nodeTheta/gammaBits/mkOwned/scoreOwned and the
Belief views; GroundB runs two verbatim copies of Lattice.hs whose
diffs from HEAD are the module line plus, in one, the single
truncation literal `2000 -> 60000`).

### 3.1 Ground A7 (irrationality) — REPRODUCED

    k=1 gap node theta (shipped Double): 0.585786437626905
    k=2 gap thetas (shipped Double):     [0.5432136168629449,0.627115119175411]
    matches II.A7's k=1 record: True          (copy-not-reconstruct row)
    realToFrac embed: denominator = 2^53
    (embed odds)^2 == exact power of 2: False

Every depth>=1 node's theta is irrational (lambda = p/2^k rational
in LOG-ODDS forces odds = 2^(p/2^k), and 2^(1/2^k) is irrational for
k >= 1); the shipped `scoreOwned` operates on the binary64 embed — a
2^53-denominator rational that is NOT the mathematical node. The
lattice is the last module whose semantics run on a lie about its
own points.

### 3.2 Ground M3 (the +2000 truncation is anti-conservative) — REPRODUCED, SHARPENED

    dropped frontier subtree mass (+60000 vs +2000): 4.914e-4
    counts (3,0)..(20,3):   pess@60000 > pess@2000  (conservative side)
    counts (0,5),(1,8),(0,20): pess@2000 > pess@60000 (ANTI-conservative)
    FLIP WITNESS at stakes (1, -0.0497478...), counts (1,8):
      pess@2000  = +4.76e-6   (shipped: the act is robust)
      pess@60000 = -5.07e-5   (the longer chain: it is NOT)
      straddles: shipped = False, +60000 = True

The sharpening the mandate flag lacked: the direction is
EVIDENCE-SIDED. When the data favors the interior/upper tail the
truncation is conservative; when the data favors the tail the chain
cuts (n0-heavy counts, the low-theta side), the dropped regions
carry near-unit sup-likelihood and the shipped pessimistic guard
sits ABOVE the truth — and a straddle verdict FLIPS (the executed
witness above: the shipped guard certifies robustness the rectangle
law denies). The guard's whole purpose is the adversarial case; the
truncation fails it exactly there.

### 3.3 Ground M6 (theta saturation collision) — REPRODUCED, QUANTIFIED

    smallest extent with nodeTheta == 1.0 (Double): j = 53
    owned chain to extent 70: 71 nodes, 54 distinct thetas
    collided at theta == 1.0: EIGHTEEN nodes, lawful prices SPANNING
      octaves: ten at 13.0 bits, eight at 15.0 bits
    scoreOwned: all 18 receive the IDENTICAL posterior weight
      (the theta-keyed dyadicAt lookup takes the FIRST match) —
      the 15-bit nodes over-weighted 4x, and the Space carries the
      duplicated point 18 times (mass inflation)

### 3.4 A DISCREPANCY FOUND IN PASSING (report, not workaround)

Pack X.3's mandate-3 row records "kLadder = 16 ... REPAIRED: deleted
from src, now pwLadderCap, WORLD ECONOMICS the caller declares." THE
TREE DISAGREES: HEAD (the commit your r1 tag seals) still ships
`kLadder = 16` at Purchase.hs:84-85 and PurchaseWorld has no
pwLadderCap; the close commit never touched Purchase.hs. The repair
was RECORDED as executed and never landed — the stale-green disease
on a repair record. Not silently fixed this session (your scope was
preparation only); the staged diff below carries it, and the
decision sheet asks whether it lands with the dyadic diff or alone.
The same file carries the last live log-space sentinel:
`negInf = -1/0` (Purchase.hs:108/111/123) — candidate 5's one live
code pin, likewise carried by the staged diff.

### 3.5 The R-R1 re-derivation, drafted under the dyadic coordinate

R-R1's three grounds (r-author-pack.md:322-341), re-argued:

1. **Coordinate consistency INVERTS.** The original ground: the
   lattice's geometry is dyadic in log-odds (the founding ruling),
   so the code must respect that coordinate. Under exactness the
   founding choice itself is what A7 convicts: the SORT is Rational
   — theta is what C-mentions say, what walk steps add, what
   fromWeights weighs — and every log-odds node is UNSAYABLE (no
   Rational mention can name it). The coordinate-consistency
   argument now runs the other way: the lattice must live where the
   language lives. Dyadic-in-theta is an AXIOM CHOICE within an
   admissible family, elected for stated reasons — NOT a derived
   unique optimum; no such theorem exists (Kraft's converse gives
   non-unique code assignments, and universal-code non-uniqueness —
   omega* beating Elias omega — denies a canonical rational code;
   the signing-review repair, 2026-07-26). The axioms: exact-rational
   SAYABILITY (compile-level — this one ground convicts log-odds AND
   the arcsine/Jeffreys warp alike, both irrational-noded), Kraft
   EXACTLY 1, MIRROR symmetry theta <-> 1-theta, and
   INTERVAL-REFINEMENT (the guard's rectangle law needs region
   spans). These select a family — dyadic and Stern-Brocot/Farey its
   serious members — and dyadic is ELECTED within it: depth k holds
   the 2^k points odd/2^(k+1); root 1/2; mirror is positional (same
   depth, same price) — the founding symmetry survives exactly; and
   the extreme-theta economics are the family's CHEAP end (1/2^k at
   ~k + 2 lg k bits dyadic vs ~2^k Stern-Brocot mediant steps —
   reasoning strength, a two-line probe on demand).
2. **Universality TRANSFERS, with its object renamed.** The original
   ground priced INTEGER EXTENTS by the universal integer code.
   Dyadic-in-theta has no extents (theta is bounded); the object
   priced is the MENTION of a dyadic rational of depth k, and its
   universal price is gamma(k+1) + k position bits — Elias-gamma on
   the one remaining integer (depth) times uniform position within
   the level. gammaBits stays integer-valued; Kraft over the tree is
   an EXACT closed form (the extent chain — and with it the +2000
   truncation, ground M3's entire apparatus — ceases to exist).
3. **The economics CHANGE MATERIALLY at the extremes, and the table
   is executed, not argued** (GroundA, matched tolerance 0.005):

       theta*   shipped log-odds price   dyadic-in-theta price
       0.5      3 bits                   1 bit
       0.75     12 bits                  4 bits
       0.9      10 bits                  11 bits
       0.96     9 bits                   11 bits
       0.9942   9 bits                   11 bits

   The dyadic ladder is CHEAPER in the interior (the root costs 1
   bit, not 3) and taxes the governor's deep-threshold territory by
   ~2 bits at these tolerances. Asymptotically the tax grows: theta
   within 2^-k of an extreme costs ~k + 2 lg k dyadic vs ~2 lg k in
   log-odds — the price of an extreme theta becomes LINEAR in its
   exponent. This is the honest cost of exactness and it is also
   Cromwell strengthened (the cumulative price along any path to
   certainty diverges linearly, not logarithmically). YOUR RULING:
   whether that prior re-weighting is acceptable. The alternative —
   keeping log-odds — keeps the lattice a Double island with all
   three convicted pathologies (3.1-3.3).

### 3.6a THE BEHAVIORAL DIFFERENTIAL (added at the position-sheet review: the ruling's one open judgment, measured)

The forwarded position sheet rested ruling 1's residual judgment on
"nothing in the packs suggests those thresholds are price-sensitive
at that margin" — an unexecuted claim, so it was executed (GroundC:
the staged 3.6 diff realized as a throwaway dyadic prototype whose
purchase mirror keeps the SHIPPED fold semantics exactly — kLadder
16, value-based candidate, straddle trigger, strict > — so the
comparison isolates the COORDINATE; pre-stated materiality: a cell
where the engines differ on whether respond ever fires or on the
terminal act; refine count/timing = coordinate-structural, reported).
Eight cells: governor-threshold streams (0.96, 0.9942), moderate,
adversarial, dear-refine, and three DEEP-VOCAB cells with pre-owned
coordinate-native chains to ~0.984 resolution.

    every cell: MATERIAL DIVERGENCE = False  (same acts, same
      terminal act; the moderate cell matches to the TICK —
      wait 2 / respond 35 / refine 3, first respond @5, both sides)
    the one number that moves — DEEP t96-allcorrect (chains to
      ~0.984, stakes (1,-24), 60x1):
        shipped: first respond @12   (respond x48)
        dyadic:  first respond @45   (respond x15)

Reading: the ACT SET is coordinate-insensitive on the whole battery
— wherever respond fires at all, it fires on both sides, same
terminal act. The tax's real face is EVIDENCE-TO-ACT LATENCY at
deep-threshold territory: the dyadic depth-6 node costs 11 bits
where the shipped extent-6 costs 7, the deficit compounds along the
owned chain's posterior weights, and the pessimistic guard needs
~33 more all-correct ticks to clear at stakes (1,-24). THAT is the
prior re-weighting you are ruling on, as a number: ~3.75x the
evidence latency on this cell, zero act changes anywhere. (Also
banked from the run, coordinate-INDEPENDENT so not ruling-1
material: from root-only vocabulary at deep-threshold stakes, the
shipped value-based candidate deadlocks on BOTH coordinates — the
max-0-clamped single-step gain is zero when no one purchase crosses
the guard to positive, so refine never fires; the R1-era success
anchor must have cleared its 0.96 stream with richer machinery.
An observation about the purchase law, recorded for whichever
boundary next touches it. And one free fact: the dyadic ladder's
Kraft sum is EXACTLY 1 — gamma is complete over depths — where the
shipped lattice carries a printed deficiency.)

### 3.6 The concrete diff the ruling would force (STAGED, not landed)

`PropLang.Lattice` (every change downstream of `nodeTheta ::
Node -> Rational`):

- `Node` = (index i, depth k), theta = (2i+1)/2^(k+1), constructor
  unexported; `rootNode` = depth 0. `childrenOf` = the two dyadic
  refinements (2p-1)/2^(k+2), (2p+1)/2^(k+2) — no extent/gap split,
  `parentOf` total on non-root.
- `nodeTheta :: Node -> Rational` EXACT (injectivity provable:
  odd/2^(k+1) is a canonical form — ground M6 dies structurally).
  `nodeLambda` retires to the Report edge if any display wants it.
- `gammaBits n = gammaLen(depth+1) + depth` — integer, mirror-safe;
  the sign bit dies (no signed extents).
- `kraftSubtree` = the exact telescoping closed form over the dyadic
  tree (Rational; gammaTail's octave sum exact) — `extChain`, the
  +2000 literal, and ground M3's truncation die structurally.
- `Region { rLo, rHi, rMass :: Rational }`; `spanOf` the exact dyadic
  interval; `guardE`/`straddles`/`supLike`/`likeAt`/`uOf` all
  Rational (the Bernoulli sup's clip point n1/(n1+n0) is rational;
  stakes arrive as wire rationals). Exact comparisons; the guard
  becomes a THEOREM-grade bound instead of a float estimate.
- `scoreOwned` keys on the Node (or exact theta — now injective),
  `Belief Rational`, no realToFrac, no Double ==.

`PropLang.Purchase`:

- `pwStakes :: (Rational, Rational)`; `pwLadderCap :: Double` becomes
  `pwLadderCap :: Rational` IN PurchaseWorld — landing the X.3 repair
  the record already claims (3.4).
- `refineV`'s `negInf` sentinel dies: the refine option is a `Maybe`
  arm in the fold (absent when no refine row / no straddle) — the
  last skip-on-negInf shape leaves src (candidate 5's live pin).
- `purchasePredictive`: the bern column via exact thQ (no binary64
  embed).

Consumers: Lattice/Purchase are leaves at HEAD (no src module
imports them; their 17 suites retired at R11) — the diff breaks no
frozen row. The R1-era pins (g5 closed-form-vs-enumerated, the g9/
g12 purchase rows) were retired with their suites; the dyadic
increment re-derives its own oracle rows under the increment
protocol when you open it (oracle-first; the kill matrix's
reasoner-pool gap in T1.2 is the same lesson).

---

## Track 1, item 1 — the five process-deletion candidates (IX.6), pin lists executed

Universe discipline: every pin list below is grep-derived at HEAD
(commands in the session record), never hand-enumerated. Frozen-doc
pins execute only under your key at the sitting (the frozen-layer
inventory law); unfrozen pins are enumerated for the same sitting so
the retirement LISTS ITS PINS in one place.

**Candidate 1 — the NaN-door case law (R-C1's reading; the step-9
NaN guard rows).** Vacuous over Rational (no NaN is constructible —
a compile fact, the ladder's top rung). PIN LIST: Syntax.hs:176
(comment "no NaN boundary" — historical note, stays as provenance);
KERNEL.md:46 ("no NaN" — a TRUE sentence, stays); design.md:410
(historical, frozen); EXACT_PLAN.md rows 25/177/237/256 (the
retirement's own record, unfrozen). THE TWO-SIDED RECORD ROW the
clause demands: the RED that cannot fire is "a NaN reaches the
door" (unconstructible — type-level); its mirror GREEN that still
CAN fail is the surviving refusal law — fromWeights refuses signed
and no-mass declarations, pinned LIVE by lawful-independence's
"signed L3-witness cannot be a measure" + "fromWeights REFUSES the
signed assignment" rows (both in the kill matrix's UNREACHED set —
candidates for the reasoner mutant pool, T1.2). DISPOSITION
RECOMMENDED: retire DISCHARGED-PERMANENT with the record row above;
no fixture exists to delete (prose-only instrument).

**Candidate 2 — the float-order/tree-shape law (step 4's "the tree
shape IS the float order"; the E-s1 mirror pins).** Vacuous: CMul
over Rational is associative. PIN LIST: Syntax.hs:255-256 (comment
already says "the step-4 float-order apparatus retires" — the code
knew); EXACT_PLAN.md rows 26/35/159 (record); design.md:49 (E-s1
mention, frozen historical); typed-port-spec.md (frozen, historical
by the S2 re-binding). The pricing-tree DATA stays (Charge trees in
Enumerate.hs:62-83 — declared shapes, pinned by the properties
pricing row "a hand-computable sentence at node 1/9"). TWO-SIDED
face: the red that cannot fire is "association changes a price";
the green that can is the pricing row itself (UNREACHED by the
current pool — the enumeration-pool gap again). DISPOSITION
RECOMMENDED: retire; the law's one true residue ("prices are
products of declared widths") is already the corpus-law row.

**Candidate 3 — the tolerance case law (CL-4 1e-12's lineage;
tolProb/tolBits).** PIN LIST: audit/capture_oracle.py:256-268 (the
FROZEN Python-side generator still EMITS tolProb/tolBits — it
generated the Double-era anchors now at archive/Anchors-double.hs;
frozen, historical, correctly so under the generator exemption);
OBLIGATIONS.md OB-7 (1e-12 delta gate of the RETIRED test-said
suite — historical record); WRITEUP.md:180 (close-date doc,
historical); EXACT_PLAN.md:29 (the retirement's record). LIVE
tolerance constants in src/test at HEAD: NONE (grep clean — the
exact floor's header says it: "no tolerance constant exists in this
file"). DISPOSITION RECOMMENDED: trim the clause to R7's residue
exactly as IX.6 drafted — display-edge == under the pinned
toolchain (Report.hs), libm motion = re-measurement event. The case
law's teaching (a gate is born from a measurement) is already
canonized at [[cl4-tolerance-is-wrong]]'s lesson and needs no
standing clause.

**Candidate 4 — the dormancy-as-wait convention (mandate-5's
overload).** The door killed dormancy; wait is structural (the
option space's head). PIN LIST — the live half is already clean:
Host.hs:21, Eval.hs:36, Membrane.hs:26, Enumerate.hs:395 all state
the DEATH ("the 0.0-dormancy default is dead"; "no default, no
dormancy"), and acceptance pins it twice (both door rows). The
frozen half: membrane-wire.md:346 STILL SAYS "absent names read 0.0
(dormancy is free...)" — inside §4, which the step-7 SCOPE BRACKET
marks historical ("binding on nothing current"), so it is not live
drift, but it is exactly why item 4's full re-derivation (T1.4)
should supersede rather than bracket-and-keep; brief.md:133 mandates
the 0.0 default AS DOCTRINE — the brief itself carries the falsified
sentence, and only you can rule how the founding document takes an
inventory repair; design.md:197 ("sayable today, dormant, and
priced") same class. DISPOSITION RECOMMENDED: retire the convention;
the brief/design sentences go on the frozen-layer inventory for THIS
sitting with the quoted-falsified-sentence form.

**Candidate 5 — the lse/log-space riders (skip-on-negInf).** PIN
LIST: ONE LIVE CODE PIN — Purchase.hs:108/111/123 (`negInf = -1/0`,
the refine-unavailable sentinel: a Double -Infinity in shipped src);
EXACT_PLAN.md:27/35/129/143 (the retirement's record; :129 already
says "no skip-on-negInf: a 0 weight contributes 0, exactly").
DISPOSITION RECOMMENDED: retire the rider class; the live pin's
destination is the staged Purchase diff (3.6) — the Maybe-arm
restructure — which makes this candidate's retirement CONDITIONAL on
(or concurrent with) the dyadic ruling; if the dyadic ruling is
deferred, the negInf excision stands alone as a two-line repair.

---

## Track 1, item 4 — the membrane-wire re-derivation (STAGED; the doc is manifest row 25, untouched)

Scope: the doc's normative surface is sections 1-3 as amended (the
step-7 scope bracket makes 4-6 historical). The staged text below
derives every load-bearing sentence from the SHIPPED dispatch, with
its definition site — greppable identities, per your instruction.
Installing it is the sitting's act, under your key.

### 4.1 What the re-derivation CHANGES (each a falsified-or-drifted sentence)

1. **The handshake example is DEAD ON THE SHIPPED WIRE.** hello
   REQUIRES `world.codebooks.theta` (Host.hs:12-13, :252 —
   `oGet "codebooks" w` with theta mandatory, rho optional; absent
   => `{"error": "bad hello"}`). The frozen §2 example declares
   namespace/guards/menu/utility and NO codebooks key — the doc's
   own canonical example is refused by the code it documents. The
   re-derived example adds
   `"codebooks": {"theta": [0.1, ..., 0.9], "rho": [0.01, ...]}`
   (the world's declaration of the emission and walk codebooks —
   E3's other face: the baked point-set left src, so the world must
   say it).
2. **The said-form census: THIRTEEN -> NINE.** The frozen sentence
   ("thirteen forms (if > + - * / log exp neg c var get)") was
   already the F5 drift exhibit (lists 12, `=` missing) and is now
   doubly false: the shipped parser (Host.hs:395-432, greppable as
   the `JStr` patterns of parseSaidWith) accepts EXACTLY
   `var c + - * get if > =` — nine forms; `+` parses to the addM
   MACRO and `=` to the If/Gt composition (both priced at
   expansion); `/ log exp neg` FAIL CLOSED (they left the alphabet
   at the exact boundary); `<` still has no codeword (W4's ruling
   stands, argument-swap).
3. **utility_bits is the GRAMMAR weight now.** The reply's
   `utility_bits` = `bitsView (weightIn ns prog)` (Host.hs:300-302)
   — the exact 9/1 weight rendered at the display edge; the frozen
   sentence's `bitsIn` (the Double pricer) died at the re-founding.
4. **The door enters section 3.** A tick's features must cover the
   declared namespace EXACTLY: missing name / undeclared name /
   duplicate name are three NAMED refusals (Eval.mkEnvIn, the sole
   env constructor; pinned by both acceptance door rows). No default
   read exists anywhere on the wire — the sentence replaces the old
   silence (and buries §4:346's historical "absent names read 0.0"
   one bracket deeper).
5. **Evidence integrality.** A non-integral evidence value is
   refused as `"non-integral evidence"` BEFORE the observation-space
   check (the mandate-6 fail-open repair) — new sentence beside the
   impossible-evidence bullet (whose "agent UNCHANGED" semantics
   observeS enforces by refusing WITHOUT update, Enumerate.hs:413).
6. **The rendering law gains its cliff.** Canonical rendering's
   "integral renders without a decimal point" holds below 2^53
   (rNum, Host.hs:182-183 — binary64's integral bound, the
   mandate-3 repair); above it e-notation is honest.
7. **The choice sentence names its route.** "argmaxEU" is dead
   (bracket already applied at :62); the re-derived sentence:
   selection is `Membrane.chooseEU` — the binary If/Gt-over-Expects
   pick sentence iterated under CL-3, pinned by the SELECTION row
   (EARNED, unique kill M7) — and wait is the option space's head
   by construction.
8. **K-ary is SERVED.** obs_arity K >= 2 runs the exact K-ary route
   (Host.hs:292-296: absent = plain route; declared K = arity
   route; declared-2 vs absent = the g2 coincidence pinned == in
   test-pin, never a branch on 2) — with R-D23's declared
   limitation sentence kept verbatim.

### 4.2 The greppable-identity table (the "described table" cure)

| normative sentence | definition site | pinned by |
|---|---|---|
| nine said-forms, exact list | Host.hs parseSaidWith `JStr` patterns | transport t2 (said on the wire); fail-closed forms refuse |
| hello requires codebooks.theta | Host.hs:252 | transport t1 (hello over pipes) |
| three door refusals, named | Eval.mkEnvIn `Left` strings | acceptance door rows (2) |
| impossible evidence refuses WITHOUT update | Enumerate.hs:413-417 | properties R1 rider (now REACHED, M10) |
| choice = chooseEU sentence route | Membrane.hs:138-161 | pins SELECTION (EARNED, M7) |
| K=2 arity == plain route | Host.hs:292-296 | pins ARITY K=2 (==) |
| K=4 categorical law | Enumerate.hs catBody | pins K=4 (EARNED, M14) |
| p1 = P(atom 1) at any arity | Host.hs reply builder | acceptance probe rows |
| utility_bits = bitsView (weightIn ns prog) | Host.hs:300-302 | (unpinned — candidate oracle row for the install increment) |
| rendering cliff 2^53 | Host.hs:182-183 | transport t4 (parity partition) |

One row is honestly UNPINNED (utility_bits) — the install increment
adds its row per the forward half of the unique-kill clause (a new
row arrives with its kill).

---

## Track 1, item 5 — the M5 replacement + the matrix re-run (T1.5)

**The defect:** the r0 M5 patch (`lo = Sub xv step`) deleted `minT`'s
only use; `-Werror -Wunused-local-binds` killed it at COMPILE — a
compiler kill, not the walk-law row's (pack X.4's pool-repair item).

**The replacement (audit/mutants/M5-walk-unreflected.patch, r1):**
the reflection guard INVERTED — `lo = If (Gt minT xv) (addM xv step)
(Sub xv step)`. `Gt` is strict and `minT <= xv` always, so the
reflection arm exists, well-typed, every binding used, and never
fires: the boundary down-move walks off the codebook while the
interior is untouched. Both walk sites (enumerateWith,
enumerateWithArity) patched, as in r0. Compile-checked in isolation:
COMPILES.

**The kill, verified through tools/oracle-audit.sh** (r2 run,
transcript below): 11 kill lines, all SEMANTIC — the walk-law row
fires (`the walk law from the SHIPPED move sentences ... FAIL`) plus
eight acceptance anchor rows. The honest finding: a boundary walk
defect NECESSARILY moves the anchors (the walk family's boundary
states carry posterior mass in every anchor episode), so the
walk-law row is killed by its own mutant but not UNIQUELY — its
value is diagnostic precision (it names the broken law; the anchor
rows only say "something moved"), which is a row-VALUE argument for
your sitting, not a unique-kill fact.

**The two tidy items, disposed:** (1) test-exact/ held only stale
.hi/.o build debris from the pre-swap oracle staging (no tracked
files; the R13 swap moved the sources to test/) — DELETED. (2) The
mutant numbering gap: no M3 ever existed in-tree or in the session
transcript — the close's pool simply skipped the number. Disposed by
ASSIGNMENT: M3 now names the frozen-agent-learns mutant (below), so
the registry is contiguous M1-M14 with no renumbering of recorded
names.

## Track 1, item 2 — the oracle-row verdict sheet (T1.2)

### The pool after growth (14 mutants, every patch a named minimal
### semantic change, each compile-checked in isolation)

| id | shape (provenance) | target question |
|---|---|---|
| M1 | Gt non-strict (CL-3/eq incident class) | the close's pool |
| M2 | condK unnormalized (CL-4's subject) | the close's pool |
| M3 | the FROZEN agent silently learns (quarantine breach, R10's discipline) | fills the numbering gap; the 2^-160 row |
| M4 | prior flattened (alphabet-is-the-prior class) | the close's pool |
| M5 | walk boundary unreflected, guard-inverted (r1 replacement) | the walk-law row |
| M6 | addM closed form mis-spelled (the Add-deletion bank) | the close's pool |
| M7 | CL-3 inverted at ties (challenger wins) | the close's pool |
| M8 | entropy sign dropped (R7 display class) | the display rows |
| M9 | MAP inverted (argmax secretly argmin) | the MAP row |
| M10 | Cond's Nothing arm bypassed, PRIOR bound (fail-open, mandate 6) | the Nothing-arm rows |
| M11 | tick marginal unnormalized, update lawful | the stream-marginal cluster |
| M12 | predictMass unnormalized | the p1-driven rows |
| M13 | condV unnormalized (M2's shape at the FUSED verb) | the Cond-sentence rows |
| M14 | K-ary km1 dropped (invisible at K=2, fatal at K>2) | the K=4 pin |

### The verdict sheet (matrix universe: 5 suites, 50 rows; the
### transport suite's 4 rows run over real pipes OUTSIDE the runner —
### a recorded universe boundary, growth candidate for the sitting)

**EARNED (nonempty unique-kill set) — FOUR rows, three of them earned
by THIS session's pool growth (a verdict is pool-relative and moves
when the pool does):**

| row | unique kill |
|---|---|
| acceptance: frozen agent 2^-160 | M3 (killed by this row ALONE) |
| acceptance: MAP change-point | M9 (alone) |
| pins: K=4 CatBody vector | M14 (alone) — the K-ary live-regression caution, now a pinned unique kill |
| pins: SELECTION (CL-3 ties) | M7 (alone) — the close's exemplar, replicated |

**SHADOWED — every one now carries an EXECUTED pool-coarseness
answer (the finer candidate was written and run, per your order):**

| row | kill set | the executed answer |
|---|---|---|
| probe rows (p1, action, H) | M1 M4 M5 M6 M8 M12 | the row BUNDLES three assertions: M8 pairs its H-half with the entropy row, M12 pairs its p1-half with consult; SPLIT CANDIDATE — as three rows, two would be earned |
| consult ticks | M1 M4 M6 M12 | M12 isolates the p1-driven pair {probe, consult} from the marginal cluster; the residual overlap is the shared p1 path (structural) |
| entropy pre/post | M1 M4 M5 M6 M8 | M8 (display-only defect) still kills probe's H-half too — same entropyOf path, data-indexed twice; the overlap is real |
| tick counts (t2 prices) | M1 | reached by exactly ONE mutant, the coarsest; none of the eight finer candidates touch the t2 price path — the THINNEST shadow in the matrix, and the sheet's honest gap: a t2-price-path mutant was not found this session |
| cumulative marginal | M1 M4 M5 M6 M11 | M11 (marginal unnormalized, update lawful) kills EXACTLY the four stream-marginal rows — the cluster moves together under every marginal-path mutant (three prior executions + this one); rows differing only in STREAM DATA cannot be separated by a test-blind src mutant (structural, demonstrated) |
| drift400 / no-if+no-get / drift250 | M1 M4 M5 M6 M11 | same cluster, same executed answer |
| batch-1 / batch-3 preposteriors | M6 M13 | M13 (condV unnormalized) kills exactly the Cond-sentence trio {batch-1, batch-3, g5'} — the fused verb's rows travel together; real by-design overlap |
| walk law | M1 M5 M6 | killed by its OWN mutant (M5) but never uniquely — a boundary walk defect moves anchors; the row's seat is diagnostic precision, a row-VALUE question |
| eq-THEOREM | M1 | M1 IS the one-token minimal mutant of this row's subject (Gt's strictness); no finer patch exists in the universe — executed-minimal |
| choice sentences CL-3 | M1 | same: the subject IS evalx's comparison semantics |
| g6' Nothing arm | M1 M10 | M10 pairs it with the R1 rider — both assert the Nothing arm; the pair travels together (same evalx case) |
| R1 rider (off-codebook) | M10 | REACHED for the first time (was UNREACHED at the close); paired with g6' |
| g5' fused round trip | M13 | REACHED for the first time; the Cond-trio |
| properties CL-4' | M2 | twin faces with lawful T3: same condK path, different stanza — a test-blind src mutant reaches both or neither (structural; the two-stanza redundancy is the standing ruling's own design) |
| lawful T3 | M2 | same |

**UNREACHED (28 rows — the pool convicts itself first, per the
drafted clause; growth candidates from the operator list, a sitting
item, NOT auto-deletions):** lawful L1/L2/L3/L4'/T1/T2/T4;
independence all 7; properties L4'-introducer, Kraft 55/72, corpus
law, fineness-charged-once, pricing-1/9; pins small-frontier,
membership-1169, fragment-table, K=2 coincidence; acceptance both
door rows, enumeration count, forgetter relations, deletion counts.
Reading: the unreached mass is concentrated on (a) the lawful floor
and independence suites — whose subjects are the sealed reasoner's
axioms, untouched by this pool's engine-level shapes — and (b) the
count/membership pins, whose subjects are the enumeration's
combinatorics. Both need their own operator classes (a reasoner
mutant pool; an enumeration-gating pool) before any row-deletion
verdict on them is honest.

**No live mutants: all 14 killed.** Full r2 transcripts:
scratchpad oracle-audit-r2/*.kills, reproduced by
`tools/oracle-audit.sh <outdir>` at HEAD+patches (the .kills files
quoted in T1.5 and here are the run's verbatim output).

### The unique-kill clause, drafted for your key (IX.6's text plus
### this run's two amendments)

The IX.6 draft stands as written (AN ORACLE ROW EARNS ITS SEAT BY A
UNIQUE KILL ... FORWARD HALF: a new oracle row arrives WITH its
kill). Two amendment lines this run purchased:

> A VERDICT IS POOL-RELATIVE AND A POOL IS GROWN, NEVER ASSUMED:
> three rows moved SHADOWED-or-UNREACHED -> EARNED at the first pool
> growth (frozen/M3, MAP/M9, K=4/M14); a deletion verdict read off a
> single pool is the two-run triptych's mistake wearing the matrix's
> hat. And STRUCTURAL SHADOWING IS AN ANSWER, NOT A FAILURE: rows
> differing only in test-side data (stream-indexed marginal rows;
> two-stanza twin faces) cannot be separated by a test-blind src
> mutant — for such rows the pool-coarseness question closes by
> demonstration, and the residual question (is the redundancy
> wanted?) is a row-VALUE ruling, never a pool obligation.

---

## Track 2 — OB-12: the differential corpus run

### T2.1 The protocol (PRE-STATED; committed before any outcome was computed)

The evidence-program clause binds: success criteria stated numerically
BEFORE outcomes are read. This section was committed builder-key ahead
of the execution transcript (T2.2, a later commit — the git order is
the proof of pre-statement).

**The measurement named by the ledger.** OB-12 (OBLIGATIONS.md row,
frozen): increment B's gate "conditions on A's differential corpus
(life-agent vs the credence brain) and that measurement does not
exist"; the run is "cited by TWO pending readings (this gate's
re-entry and the A-gate exit-from-shadow, R-D14) — the single
highest-leverage unexecuted measurement in the programme."
The A-gate (archive/HOSTS_PLAN.md §9, frozen): "gate: life-agent
differential vs the credence brain." The roadmap's operational face
(credence-governor docs/governance-roadmap.md Phase 2/3): "a shadow
window long enough to compare engines on the registered metric, plus
the ask-rate reading"; A opens iff the differential surfaces "menus
beyond {ask, block, proceed} ... or K-ary evidence the binary verdict
carrier cannot express ... measured."

**The corpus (definition, not outcome).** `~/.credence-governor/
observations.jsonl` (indefinite retention, R-D16) — the evidence of
record. Record types present (schema recon, field names and counts
only): tool-proposed 143,036 / decision 143,035 / membrane-shadow
190,106 / outcome 171,261 / user-responded 8. A corpus event = one
event_id having (a) a tool-proposed record, (b) a decision record
(the credence brain's fired answer), and (c) >= 1 membrane-shadow
record (the life-agent's recorded answer; forms table@1 and latent@1
read separately). Grounding joins outcome records by event id. The
window is the dual shadow's own lifetime (deployed 2026-07-10, daemon
0.11.0; RETIRED 2026-07-22 by the author's ruling — no membrane-shadow
record since). The records carry no timestamps; the shadow linkage IS
the window. Both engines' answers were RECORDED LIVE against the same
traffic, so the run is pure log analysis — no engine is re-run, no
answer reconstructed.

**Reading R1 — the registered exit-from-shadow metric (R-D14; the
A-gate citation).** Per engine (julia, table@1, latent@1):
FBR_waste = falsified blocks / grounded blocks, where a block is
falsified when its grounded outcome completed with reverted = false
(shadow mode: every call proceeded, so every block decision is
outcome-checkable). Criteria (the REGISTERED bars, not new ones):
pass iff FBR_waste <= 0.05% AND grounded-block n >= 1000. The
30d-rolling clause is STRUCTURALLY unmeetable (the shadow lived 12
days and is retired) — reported as such; a bar the corpus cannot
reach is a finding about the corpus, never rounded to a pass.
Secondary: ask-rate per membrane form (the Phase-2 exit criterion's
other half), against the recorded priors (table@1 over-asks ~100% on
the early cells; latent@1 constant-block, ask-rate 0).

**Reading R2 — the A-gate demand shapes (HOSTS_PLAN §9).**
(a) Menu demand: census of decision-action values (both engines) —
demand MEASURED iff any value outside {proceed, block, ask} occurs
(count > 0), enumerated. (b) K-ary evidence demand: the grounded
outcome record is multi-level (completed x reverted x retries>0 x
error) while the wire's evidence carrier is binary; census the
distinct outcome shapes — K-ary demand MEASURED iff > 2 shapes each
occur with >= 1% corpus frequency (builder-proposed threshold, marked
as such). (c) Routing/options: any decision record whose action names
a route/candidate selection — count > 0 measures it.

**Reading R3 — the B-gate shape (OB-12's own citation:
correlated-evidence / two-stream inverted polarity).** The corpus's
two verdict streams per event: the human stream (user-responded) and
the structural stream (grounded outcome). (i) Inverted-polarity
subcorpus: events with both streams present and opposed (human
approves / outcome reverted, or human rejects / outcome clean).
POWERED iff n_inv >= 30 (builder-proposed floor, marked as such);
B's shortfall FIRED iff on a powered subcorpus one engine's grounded
error rate >= 2x the other's with each losing case enumerated and
attributable to reliability-blindness. Schema recon already shows
user-responded = 8 total, so n_inv <= 8: if that holds through
execution, the honest verdict is UNDERPOWERED — B stays un-fired by
measured insufficiency (not by adjacent evidence), and the thinness
of the second stream (8 human verdicts in 143k decisions) is itself
the recorded demand shape. (ii) Engine-disagreement adjudication:
on corpus events where julia and a membrane form disagree and
grounding adjudicates, report each engine's adjudicated error rate
and whether the loser's errors cluster on a common evidence shape
(enumerated, no threshold — a triage input).

**Execution plan.** One Python reader over observations.jsonl
computing exactly the tables above; transcript lands in T2.2
verbatim; whichever way the numbers fall, they are the pack's record
(OB-12's ruling refused adjacent evidence — this run is the direct
kind).

### T2.2 The execution transcript (verbatim; run after commit b4753bf)

    corpus events (decision AND >=1 shadow record): 95074
      shadow-form coverage ['latent@1', 'table@1']: 95030
      shadow-form coverage ['latent@1']: 43
      shadow-form coverage ['table@1']: 1
    grounded corpus events: 89210

    === R1: registered exit-from-shadow metric ===
    julia:    action census {proceed: 88789, block: 5152, ask: 1133}
    julia:    grounded blocks n=5077, falsified=4311, FBR_waste=84.91% -> bar: FAIL
    julia:    ask-rate = 1133/95074 = 1.2%
    table@1:  action census {ask: 95031, None: 43}
    table@1:  grounded blocks n=0 -> bar: FAIL (n < 1000: UNDERPOWERED)
    table@1:  ask-rate = 95031/95031 = 100.0%
    latent@1: action census {block: 95073, None: 1}
    latent@1: grounded blocks n=89209, falsified=67036, FBR_waste=75.14% -> bar: FAIL
    latent@1: ask-rate = 0/95073 = 0.0%

    === R2: A-gate demand shapes ===
    (a) julia action values:    {proceed, block, ask}
    (a) membrane action values: {ask, block}
    (a) values outside {proceed, block, ask}: NONE -> menu demand NOT MEASURED
    (b) grounded outcome shapes (completed, reverted, retries>0, error):
        (True,  False, False, False): 67037 (75.1%)
        (False, False, False, False): 22152 (24.8%)
        (True,  True,  False, False): 13   (0.0%)
        (False, False, True,  False): 7    (0.0%)
        (False, True,  False, False): 1    (0.0%)
    (b) shapes at >= 1% frequency: 2 -> K-ary demand NOT MEASURED
    === R3: B-gate shape ===
    (i) events with BOTH streams: 0; n_inv = 0 -> UNDERPOWERED (floor 30)
        (user-responded records in the whole file: 8)
    (ii) engine-disagreement adjudication (form, julia-right, membrane-right):
        (latent@1, False, False): 760
        (latent@1, False, True):  21407
        (latent@1, True,  False): 61965
        (table@1,  False, False): 25468
        (table@1,  True,  False): 62695

### T2.3 The reading (for the two pending consumers)

**The measurement OB-12 named now EXISTS** — 95k live events, both
engines recorded, 94% grounded. What it says:

1. **The A-gate (R-D14 / exit-from-shadow):** NO measured demand. In
   95,074 live decisions no engine ever needed an action outside
   {proceed, block, ask}, and the grounded outcome space is binary at
   the 1% floor (clean-complete 75.1% / not-completed 24.8%; reverted,
   retried, and error shapes all < 0.1%). Per the roadmap's own text
   ("Phase 2's differential either surfaces that shortfall, measured,
   or it doesn't. If it does, the author opens A ... if not, A stays
   closed and the stack ships as-is") this corpus reads: A STAYS
   CLOSED. On the registered loss bar no engine passes: the incumbent
   fails on the waste face (84.91% of its grounded blocks were clean
   completions under this protocol's pre-stated falsification
   definition — NOTE this operationalization differs from the R-D14
   reading's 6.5%, a different denominator; both are two-plus orders
   above the 0.05% bar, the direction is not in doubt), and both
   membrane forms are action-degenerate on the full window exactly as
   the recorded priors predicted (table@1 asks 100.0%; latent@1
   blocks 100.0%). The 30d-rolling clause is structurally unmeetable
   on a retired 12-day shadow — exit-from-shadow as registered cannot
   fire without the author resuming the shadow with a Phase-3
   (stake-bearing said + learned theta_ask) form worth measuring.
2. **The B-gate (OB-12 proper):** UNDERPOWERED BY MEASUREMENT, not by
   argument — the two-stream subcorpus is EMPTY (n_inv = 0; the
   entire evidence file holds 8 human verdicts against 143k
   decisions). B stays un-fired, and the thinness of the second
   stream is itself the recorded demand shape: there is no
   reliability channel to learn because the corpus carries no second
   verdict stream to be unreliable. The engine-disagreement
   adjudication quantifies the recorded degeneracies (julia right in
   74% of latent@1 disagreements — the constant-blocker loses to
   grounding at the base rate, as predicted before the field run).

Both pending readings now cite an executed measurement. The pack
records the results; the RULINGS (A stays closed; B stays out;
whether to resume a Phase-3 shadow) are yours at the sitting.

---

---

## Track 3 — EXACT_PLAN §13 drafted (the trampoline charter)

Landed at EXACT_PLAN.md §13 (unfrozen; this session's commit). It
opens NOTHING — your ruling opens it. Contents, as ordered: §13.0 THE
DESTINATION MAP installed verbatim as charter preamble (steps 1-5,
the reasoning, the termination clause, the named demand-gated
residue), with a dated status annotation (X.5 prepared; OB-12
EXECUTED — the two annotations this session's work added to the
map); §13.1 the explicit dependency on X.5 item 3 (the lattice
coordinate gates the trampoline — the internal rungs live in
Lattice/Purchase, all three grounds executed in this pack's lead
item); §13.2 the charter body — the standing POLICY sentence (one
derived macro, the agent's own belief bound in its env, priced at
expansion), think/refine STANDING on the menu priced by the world's
clock (metareasoning never invoked, never excludable), the host as
decision-free polling trampoline (constructor tags and wire input
only), gate E4 THE SINGLE CHOOSER with its scriptable half specified
beside E1-E3 (token grep over stripped source with the
validation-site allowlist; seeded-defect red per the pin-freeze
clause), and THE FLOOR named as the fourth residue (one
un-deliberated policy evaluation per tick — the brief's
laws-of-thought residue, operational face; KERNEL.md's RESIDUES line
gains it at that boundary's freeze under your key); §13.3 what dies
(the last host folds); §13.4 the closed-loop lazy-genius oracle
shape — the price-only differential (SAME trampoline, worlds
differing only in declared prices, think-counts move with zero code
diff, both count vectors asserted exactly), E4's grep row, the
single-evaluation row, and the composition rows (old chooseEU as the
new sentence's special case by ==; R1's buy/stay shapes returning as
trampoline rows under the new coordinate). Oracle-first binds when
the boundary opens; the section is a charter, not an oracle.

---

## The decision sheet (your rulings; recommendations marked, evidence cited)

| # | decision | evidence | recommendation |
|---|---|---|---|
| 1 | **The dyadic coordinate** (R-R1 re-open): rule dyadic-in-theta / keep log-odds / defer | all three grounds re-executed (pack 3.1-3.3: unsayable points, a FLIPPED straddle verdict, an 18-node price-collided cluster); re-derivation 3.5; staged diff 3.6; economics table executed | RULE DYADIC-IN-THETA — it is the only exact option and it gates the trampoline; the extreme-theta tax (~2 bits at governor thresholds, linear asymptotically) is the honest cost, on the table |
| 2 | **The X.3/tree discrepancy** (3.4): pwLadderCap recorded-as-repaired but never landed | Purchase.hs:84-85 at HEAD; close commit never touched the file | land it WITH the dyadic diff (one Purchase surface motion); the pack records the stale-green so the record stops over-claiming either way |
| 3 | **Process deletions, per candidate** (item 1): NaN case law / float-order law / tolerance case law / dormancy convention / lse riders | pin lists grep-derived per candidate; two-sided record rows drafted; candidate 5 has ONE live code pin (negInf), destination = the Purchase diff | retire 1, 2, 5 (5 conditional on ruling 1 or as a standalone two-line repair); trim 3 to R7's residue; retire 4 WITH the brief/design sentences on this sitting's frozen-layer inventory |
| 4 | **Oracle-row verdicts** (item 2): the sheet's EARNED x4 / SHADOWED x16 / UNREACHED x28 | the 14-mutant matrix, every SHADOWED row's finer candidate EXECUTED; three rows earned by pool growth alone | NO row deletions this sitting (the pool convicts itself on the unreached mass — reasoner + enumeration operator classes owed first); consider the probe-row SPLIT (three assertions, two would earn) |
| 5 | **The unique-kill clause** — canonize into CLAUDE.md (IX.6 text + the two amendment lines this run purchased) | pool-relativity demonstrated (3 verdict moves); structural shadowing demonstrated (marginal cluster, twin faces) | CANONIZE with both amendments |
| 6 | **The membrane-wire re-derivation** (item 4): install the staged sections 1-3 under your key | 8 falsified-or-drifted sentences enumerated (the handshake example is DEAD on the shipped wire; thirteen forms are nine); greppable-identity table drafted; one honestly-unpinned row named | INSTALL at this sitting; the unpinned utility_bits row lands with its kill at the next oracle-bearing increment |
| 7 | **OB-12's readings** (Track 2): the A-gate and B-gate consumers | the run EXISTS: 95k events, A-demand NOT MEASURED, B UNDERPOWERED (n_inv = 0), no engine passes the loss bar; 30d-rolling structurally unmeetable on a retired shadow | A STAYS CLOSED and B STAYS OUT on this evidence; the real decision is whether to resume a Phase-3 shadow (stake-bearing said + learned theta_ask) — without it the exit-from-shadow bar can never be read again |
| 8 | **Open the trampoline boundary** (§13) — or hold until ruling 1 lands | charter drafted; dependency on ruling 1 recorded; oracle shape drafted | RULE 1 FIRST; open the trampoline at the ruling's freeze or the sitting after |

Two tidy items, disposed (no ruling needed): test-exact/ stale .hi/.o
DELETED (untracked debris); the mutant numbering gap FILLED by
assignment (M3 = frozen-agent-learns; registry contiguous M1-M14).

Session custody: every commit builder-key signed; nothing frozen
touched; the OB-12 protocol's pre-statement is commit b4753bf,
its execution the commit after.

---

## The X.5 sitting record (RULED 2026-07-26; binds at the author's signed tag `x5-sitting-r0` over the commit carrying this record)

All eight rulings are RULED. Rulings 2-6 and 8 seal as drafted per
the position sheet with its riders folded in; ruling 7 seals its two
evidence-decided halves and formally defers (a)/(b)/(c) to a governor
sitting; ruling 1 was ruled by the author in-session on 2026-07-26
(ADOPT, with one recorded caveat). Verdicts are the author's, stated
in-session and transcribed by the builder; the attestation is the
author's signed tag, never this text or its commit signature (the
custody rule — the tag, not any commit signature, is the attestation
of author review and approval).

**Ruling 1 — the lattice coordinate (R-R1 re-open).**
DRAFT: *Dyadic-in-theta is ADOPTED. The three grounds (unsayable
points; the executed straddle-flip; the 18-node price collision)
convict the log-odds coordinate; the re-derivation stands
(consistency inverts under exactness, universality transfers to the
dyadic mention, Kraft exactly 1). The prior re-weighting is owned
with its measured face: zero act changes across the battery, ~3.75x
evidence-to-act latency at deep-threshold territory (3.6a) — the
linear extreme-theta price is Cromwell strengthened, and the latency
is the honest cost of saying what the lattice means. The deciding
asymmetry (the position-sheet review's framing, adopted): the two
coordinates fail in OPPOSITE directions — the dyadic tax DELAYS
confidence at the extremes, the shipped truncation MANUFACTURES it
(the flipped straddle, 3.2). A guard whose failure mode is
slower-to-trust is on the right side of its own purpose; one whose
failure mode is falsely-certifies is not.*
RULED: **ADOPTED**, 2026-07-26. One caveat owned at signature,
recorded here so it is owned rather than discovered later: the
zero-act-change result is scoped to the eight-cell battery (3.6a) —
the right battery (governor-threshold streams and adversarial cells
included), but if the live governor ever operates sustained at
deep-threshold stakes, the latency face is the one to watch.

ADDENDUM AT THE SIGNING REVIEW (2026-07-26, pre-tag; three review
rounds folded in — the canonicity memo, the metareasoning
assessment, the floor exchange — so the record carries its own
claim-strength audit):

- CLAIM STRENGTH REPAIRED AT SOURCE (3.5 ground 1): the dyadic
  ladder is an axiom choice within an admissible family, elected
  for stated reasons, never a derived unique optimum. The verdict
  is untouched; the label is corrected (the Savage-shape
  discipline: a chosen thing may not wear a proven thing's name).
- O(1)-EQUIVALENCE AND GUARD SAFETY, AT HONEST STRENGTH: any two
  admissible floors differ by O(1) bits per theta-mention against
  data terms growing with n; and no Kraft-complete floor can make
  the guard anti-conservative (the Ville/mSPRT shape — the prior
  moves latency and power, never validity). NEITHER is canonized
  by assertion (mandate 2's shape). The executable core is
  SCHEDULED instead: a property row in the dyadic increment's
  oracle — pessimistic guard <= exact mixture value <= optimistic
  guard on every battery cell, under a region system of Kraft mass
  exactly 1 with nothing dropped. Its violation is precisely
  GroundB's flipped straddle: the +2000 truncation dropped mass,
  so no proper-prior guarantee ever applied to the shipped guard.
  The sequential (anytime-validity) strengthening stays at
  reasoning strength until derived or executed.
- KT/SNML CHARTERED as a named future entry-gate candidate: the
  one-part sequential code for estimated theta (exact rational
  recurrence, predictive (2*n1+1)/(2n+2); minimax-regret theorem
  behind it; structurally the rw family — count-dependent, non-
  expfam). It is ALPHABET MOTION, so it enters only through the
  two-sided gate: clause (a) = the executed demonstration that no
  finite grid mixture reproduces the KT predictive at every count
  vector; clause (b) = its ablation fixture. Demand-gated; it can
  never arrive as an optimisation (it changes the prior). Every
  use it absorbs is a use where the ladder choice has zero stakes.
- THE ASSERTED-THETA CENSUS registered as an owed evidence item
  (execution increment): universe derived from the declared
  corpora and World declarations, never hand-enumerated; counts
  sites where a theta constant is ASSERTED against sites where
  theta is estimated from outcomes. If assertion is rare, the
  residue is institutionally trivial and the dyadic freeze is
  permanent at near-zero stakes.
- THE LADDER MIXTURE (a priced posterior over coordinate systems)
  CONSIDERED AND DECLINED: alphabet motion with the entry gate
  unmet; O(1) savings exactly where the O(1) is the decision
  margin (deep-threshold, evidence-poor territory — where 12
  ticks became 45); and the lattice is the guard's SOUNDNESS
  apparatus, so the coordinate must be one fixed public fact — a
  robustness certificate depending on a posterior over coordinates
  is unauditable by construction.
- ONE NAMED CONTINGENCY, stated against the shipped system: TODAY
  a non-dyadic constant (1/3) remains sayable via a World-declared
  grid at grid price — the lattice prices the GUARD's region
  vocabulary, not hypothesis constants. IF mention-pricing ever
  unifies onto the dyadic ladder, non-dyadic rationals become
  linearly expensive to assert; the census sizes that demand, and
  the remedy is a demand-gated rational-constant seat under the
  door discipline — never a floor redesign.

**Ruling 2 — the stale-green repair (pwLadderCap).**
RULED (as drafted): *Lands WITH the dyadic diff — one Purchase surface motion.
RIDER (process line, for CLAUDE.md at this sitting or the next
freeze): a repair recorded in a pack CITES ITS COMMIT HASH in the
repair row; the pre-freeze checklist verifies every cited hash
touches the file the row names — recorded repairs are verified
against the tree, mechanically, so this class dies structurally.*

**Ruling 3 — the five process deletions.**
RULED (as drafted): *Candidates 1 (NaN case law) and 2 (float-order law):
RETIRED, vacuous over Rational, two-sided record rows as drafted.
Candidate 3 (tolerance case law): TRIMMED to R7's display-edge
residue. Candidate 5 (lse/negInf riders): RETIRED; the one live pin
(negInf) leaves with ruling 2's diff. Candidate 4 (dormancy-as-wait):
RETIRED; brief.md:133 and design.md:197 take the
quoted-falsified-sentence INVENTORY form — the brief itself stays
untouched (the founding document is never edited; its falsified
sentence is marked from outside, the project's standing treatment of
frozen prose).*

**Ruling 4 — oracle-row verdicts.**
RULED (as drafted): *NO deletions this sitting: 28 rows unreached where the pool
has no operator classes — a deletion now would convict rows for the
pool's gaps. The PROBE SPLIT is ORDERED (three rows: p1 / action /
H-display; two earn immediately on the existing pool) as the next
oracle-bearing increment's mechanical item, oracle-first discipline
applying. TWO NAMED OWED ITEMS registered on the ledger: the
reasoner mutant pool (Belief-level operator class — the lawful and
independence suites' shapes) and the enumeration mutant pool
(gating/combinatorics class — the count and membership pins); each
enters OBLIGATIONS.md at this sitting under the author's key.*

**Ruling 5 — the unique-kill clause.**
RULED (as drafted): *CANONIZED into CLAUDE.md with both amendment lines
(pool-relativity; structural-shadowing-is-an-answer) — every
sentence of the clause carries an executed exhibit from the r2 run.*

**Ruling 6 — the membrane-wire re-derivation.**
RULED (as drafted): *INSTALLED at this sitting under the author's key: sections
1-3 replaced by the staged re-derivation (pack item 4) — the
current example is refused by the shipped code and the form census
is wrong twice; waiting makes the doc more wrong. The one unpinned
row (utility_bits) arrives with its kill at the next oracle-bearing
increment, per ruling 5's forward half. Manifest row 25 re-signs.*

**Ruling 7 — OB-12's consumers.**
RULED, the two evidence-decided halves: *A STAYS CLOSED (demand
not measured on 95k live events); B STAYS OUT (underpowered by
measurement, n_inv = 0).* The three remaining decisions are FORMALLY
DEFERRED to a governor sitting; the docket rides with the deferral,
with its one new fact: (a) build the Phase-3 form (stake-bearing
said + learned theta_ask)? — a governor-programme priority call
committing field work; if NO, the honest companion act is retiring
the exit-from-shadow apparatus rather than keeping a permanently
unreadable bar. (b) re-register the 0.05% FBR bar? — every engine
misses it by two-plus orders under BOTH recorded operationalizations
(6.5% R-D14-era; 84.91% this run's pre-stated definition); a
re-registration needs a definition first (the two differ in
denominator), and re-registering honestly is not rounding failure to
pass. (c) the verdict stream: user-responded records exist ONLY via
explicit /feedback calls (daemon.py:479-501 — no passive stream), so
NO resumed shadow can power B by running longer; powering B requires
first deploying a second verdict source (an LLM-judge or reviewer
channel) — which is exactly the evidence shape B itself would model.
(c) is therefore upstream of (a), and both are upstream of any
shadow resumption. SEQUENCING SEALED WITH THE DEFERRAL: the governor
sitting rules (c) before (a), both before any shadow resumption;
(a) is the only item on this sheet committing future field work, and
it is ruled there, not here.

**Ruling 8 — the trampoline.**
RULED (as drafted): *Rule 1 first; the boundary OPENS AT THE SITTING AFTER the
dyadic freeze, not at it — one boundary at a time, and the
trampoline's rungs live in exactly the modules the dyadic diff
rewrites. The charter (EXACT_PLAN section 13) loses nothing by
waiting; it opens nothing until ruled open.*

---

## The execution order (triggered by the seal; builder work, next increment)

1. The dyadic + Purchase diff lands (ruling 1), carrying the
   pwLadderCap repair (ruling 2) and the negInf departure (ruling 3
   candidate 5) — one Purchase/Lattice surface motion, oracle-first
   under the increment protocol. Before EXACT_PLAN §13 relies on it,
   the banked GroundC deadlock observation re-executes against the
   shipped dyadic Lattice (§13.3's expiry rider).
2. Frozen-layer installs under this sitting's key: membrane-wire
   §§1-3 replaced (ruling 6; manifest row 25 re-signs), the
   unique-kill clause canonized into CLAUDE.md with both amendment
   lines plus ruling 2's recorded-repairs rider (rulings 5, 2), the
   two owed mutant pools entered in OBLIGATIONS.md (ruling 4), the
   candidate-4 inventory brackets on brief.md:133 / design.md:197
   (ruling 3).
3. The probe-row SPLIT (ruling 4) rides the next oracle-bearing
   increment as its mechanical item, its two earned kills with it.
4. The trampoline WAITS: it opens at the sitting AFTER the dyadic
   freeze (ruling 8). The governor docket — 7(a)/(b)/(c) — waits for
   a governor sitting, (c) before (a).
5. From the signing-review addendum: the guard-safety two-sided-
   bound property row rides the dyadic increment's ORACLE; the
   asserted-theta census rides the execution increment as an owed
   evidence item, universe script-derived.

## Post-sitting verification checklist (mechanical; the next session opens here, pass/fail, no re-read)

At the seal (before any execution):

- [ ] `git tag -v x5-sitting-r0` — Good signature, AUTHOR key
      (ED25519 SHA256:Sfh8OBG9CtkTF/y8rch4Cf6wv1rCpJ8ymEtKilUucsY).
- [ ] `sha256sum -c MANIFEST.sha256` — 56/56 OK (the seal itself
      moves nothing frozen).
- [ ] Every post-r1 commit verifies under the BUILDER key
      (SHA256:fPqrWnQhp0Ds+8MkMIDMUZzdRGviyfwt2BjsSaXAmgc).

After the execution increment (each row names its ruling; greps
pinned against HEAD at sitting time):

- [ ] `grep -n pwLadderCap src/PropLang/Purchase.hs` nonempty AND
      `grep -n "kLadder" src/PropLang/Purchase.hs` empty — the
      stale-green repair finally landed (rulings 1+2; today:
      kLadder=16 at Purchase.hs:84-85, no pwLadderCap).
- [ ] `grep -rn negInf src/` empty — the last log-space sentinel
      left with the diff (ruling 3 candidate 5; today: three sites,
      all Purchase.hs).
- [ ] membrane-wire §§1-3 = the pack item-4 staged text; its
      greppable-identity rows all hold against the shipped parser
      (nine forms derived from the parse table, not prose); manifest
      re-signed, row count still 56 (ruling 6).
- [ ] CLAUDE.md carries the unique-kill clause with BOTH amendment
      lines and the recorded-repairs rider, quoted against the pack
      text (rulings 5, 2).
- [ ] OBLIGATIONS.md carries the two owed pool rows: the reasoner
      mutant pool and the enumeration mutant pool (ruling 4).
- [ ] brief.md:133 and design.md:197 wear the dated inventory
      brackets; the brief's own sentence untouched (ruling 3).
- [ ] The GroundC deadlock re-execution transcript rides the dyadic
      increment's pack (§13.3's expiry rider).
- [ ] The dyadic increment's oracle carries the guard-safety
      two-sided-bound property row (pess <= exact <= opt, Kraft
      mass exactly 1) — the signing-review addendum's scheduled
      row.
- [ ] The asserted-theta census transcript rides the execution
      increment's pack, universe script-derived (addendum).
- [ ] `cabal test all` exit 0; `tools/prefreeze-lint.sh` 0 FAIL.
