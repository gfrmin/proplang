# dyadic-author-pack.md — the dyadic increment's oracle phase (builder-authored, unfrozen)

The X.5 execution increment, opened on the author's word 2026-07-26
under the sealed sitting (tag `x5-sitting-r0` over a72f45c, author
key VERIFIED at opening; MANIFEST 56/56 OK). Scope = the sitting's
execution order items 1, 2, 3 and 5: the dyadic + Purchase diff
(oracle-first), the frozen-layer installs staged for your key, the
probe split staged, the guard-safety oracle row and the
asserted-theta census executed. Custody: builder key on every
commit; NOTHING FROZEN TOUCHED — every frozen-file motion is staged
under `test-dyadic/freeze/` and applies only in the freeze commit
you seal.

## 1. What exists at this commit

- `test-dyadic/Dyadic.hs` — the increment oracle, 24 rows in six
  groups (d1 coordinate, d2 price, d3 regions, d4 guard, d5 guard
  safety, d6 purchase). Provenance per row: sealed-pack COPIES cite
  x5-author-pack.md by section (3.5 economics table, 3.6a purchase
  quantities); new rows are hand derivations from the staged diff's
  frozen formulas, shown in row comments (the pricing-row
  precedent). One force per comparison row (the `pin` helper).
- `test-dyadic/stanza.cabal.draft` — the suite stanza, staged (the
  transport precedent, manifest row 34's form; proplang.cabal is
  frozen and untouched).
- `test-dyadic/freeze/` — every frozen-layer install, staged:
  `membrane-wire-install.md` (ruling 6: the eight ruled edits +
  identity table + amendment head; two stale-pin repairs FLAGGED
  F-a/F-b for accept-or-strike), `claude-md-clause.txt` (ruling 5 +
  ruling 2's rider, insertion point named), `obligations-rows.md`
  (ruling 4: OB-20 reasoner pool, OB-21 enumeration pool; state
  letters for your ruling), `acceptance-probe-split.diff` (ruling
  4's mechanical item against frozen test/Acceptance.hs),
  `inventory-entries.md` (ruling 3 candidate 4: brief.md:133 and
  design.md:197 marked FROM OUTSIDE, both files untouched),
  `freeze-commands.txt` (the freeze commit's mechanical sequence).
- `src/PropLang/Lattice.hs`, `src/PropLang/Purchase.hs` — the
  drafted TYPE SURFACE with stub semantics (total, deliberately
  wrong, seeded-defect refine arm) so the oracle runs red. src is
  unfrozen; the six frozen suites are LEAVES over this pair and
  stay green (verified below).

## 2. The two-run record (R-D21, overlay form, flag-faithful)

Both compiles used the stanza's exact flag set:
`-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`
+ GHC2021, via `cabal exec ghc -- -isrc` (red) and
`-i<overlay> -isrc` (SAT) on the oracle's IDENTICAL text.

**RED — 24/24 rows FAIL against the stub surface** (exit 1;
transcript `scratchpad/dyadic-red/red-run.txt`). Attribution
partitioned by stub design: nodeTheta stubs to the non-dyadic 1/3
(fires d1, d6.5, d6.6), gammaBits to the constant 2 (d2.1/2/5,
d5.1's coarse half), kraftSubtree to 0 (d2.3/4, d3.1), spanOf to
the inverted interval (d3.2), guardE to a size-decreasing pair that
VIOLATES nesting (d4, d5.2), and the refine arm carries a seeded
defect — offered without a refine row, straddle unconsulted, biased
large — so the static-vocabulary and cap rows (d6.1-d6.4)
demonstrably fire. Every row's red is attributable; no row is a
green-that-cannot-fail at birth.

    d1.1 root theta is exactly 1/2: FAIL
    d1.2 root children thetas are exactly 1/4 and 3/4: FAIL
    d1.3 injectivity to depth 6: 127 nodes, 127 thetas: FAIL
    d1.4 sayability: every theta is odd/2^(depth+1): FAIL
    d1.5 mirror is positional: theta <-> 1-theta, same price: FAIL
    d2.1 prices at depths 0..3 are 1, 4, 5, 8: FAIL
    d2.2 the economics table (COPY: x5 pack 3.5, sealed): FAIL
    d2.3 Kraft over the whole tree is EXACTLY 1: FAIL
    d2.4 the Kraft recursion: subtree = own + children: FAIL
    d2.5 level masses: FAIL
    d3.1 root-only regions (0,1/2,1/4),(1/2,1,1/4): FAIL
    d3.2 region i brackets frontier candidate i: FAIL
    d4.1 pess -1/4, opt 1/4: FAIL
    d4.2 that instance straddles: FAIL
    d4.3 all-positive stakes: guard 1, no straddle: FAIL
    d4.4 counts (1,0): pess -1/5, opt 2/5: FAIL
    d5.1 nothing dropped: owned + region mass == 1: FAIL
    d5.2 the guard interval NESTS under refinement: FAIL
    d6.1 moderate cell wait 2/respond 35/refine 3 @5: FAIL
    d6.2 DEEP t96 first respond @45, respond x15: FAIL
    d6.3 no refine row: STATIC vocabulary: FAIL
    d6.4 cap 0 kills refine, cap 16 buys: FAIL
    d6.5 scoreOwned exact posterior: FAIL
    d6.6 purchasePredictive exact P(1) = 21/40: FAIL

**SAT — 24/24 rows PASS against the overlay** (exit 0; transcript
`scratchpad/dyadic-sat/sat-run.txt`; overlay =
`scratchpad/dyadic-overlay/PropLang/{Lattice,Purchase}.hs`, real
dyadic semantics wearing the shipped module names, DISCARDED per
R-D21 — the generator exemption does not apply). Two findings the
SAT run purchased:

1. **The 3.6a quantities reproduced from scratch.** The overlay was
   written from the staged diff's text, not from GroundC's
   prototype, and the sealed purchase numbers reproduced exactly —
   moderate wait 2 / respond 35 / refine 3, first respond @5; DEEP
   t96 first respond @45, respond x15. An independent second
   realization of ruling 1's measured cost.
2. **The guard-safety row's nesting form HOLDS on the real
   semantics** (d5.2: 20 battery cells, coarse-vs-depth<=5
   intervals, pess rises and opt falls under refinement, exact
   Rational comparisons). The scheduled row from the signing-review
   addendum is therefore SATISFIABLE as drafted — the two-sided
   bound with nothing dropped (d5.1: owned mass + region mass == 1
   EXACTLY on both systems) plus interval nesting. The sequential
   (anytime-validity) strengthening stays at reasoning strength, as
   the addendum records.

Frozen suites at this commit: `cabal test all` exit 0, six suites
PASS over the stub surface (transcript
`scratchpad/dyadic-gate5-stub.txt`) — Lattice/Purchase are leaves,
as the sealed pack's 3.6 recorded.

## 3. The asserted-theta census (the addendum's owed evidence item)

Universe SCRIPT-DERIVED (git ls-files + the declaration greps; the
sweep-universe law): the in-tree World declarations
(test/OracleWorld.hs:31-35 and test-pin/Pins.hs — identical grids),
the Python executable spec (proplang.py:217-221 GRIDS), and the
wire fixtures (Transport.hs helloLine grids, which are feature
thresholds, not theta).

    theta grid (both worlds + python): 9 points, 8 NON-dyadic
      (1/10, 1/5, 3/10, 2/5, 3/5, 7/10, 4/5, 9/10 — only 1/2 dyadic)
    rho grid (both worlds + python):   8 points, 7 NON-dyadic
      (only 1/2 dyadic)
    lattice-node overlap with ANY declared grid: exactly {1/2}

READING. Asserted theta constants are ubiquitous in the declared
grids and overwhelmingly non-dyadic (15/17 in-tree), and the
lattice's vocabulary shares exactly ONE point with them. Today that
is SAFE: grid constants price at log2|grid| through the constant
door, lattice nodes at gamma through the guard — two vocabularies,
no double pricing, no conflict (the addendum's contingency stated
precisely). The census's teeth are for the future: any
mention-pricing unification onto the dyadic ladder would reprice
15/17 of the shipped corpus's asserted constants linearly — the
demand-gated rational-constant seat would fire on the first corpus
it met. The floor freeze stands at near-zero cost on TODAY's
architecture, exactly as the addendum predicted.

## 4. The under-determination register (your freeze rules these)

R1. **gammaBits changes export type** Double -> Integer (the staged
    diff's "integer, mirror-safe"). No consumer exists (leaf
    module); the derivation line rides the module header.
R2. **nodeLambda leaves the export list** (staged diff: "retires to
    the Report edge if any display wants it" — none does). Export
    surface shrinks by one; flag if you want it kept.
R3. **Region fields rename** rLoTheta/rHiTheta -> rLo/rHi (the
    staged diff's spelling).
R4. **The identity table's transport-t1 pin is refusal-side**: the
    shipped transport helloLine (Transport.hs:70-74) declares NO
    codebooks and a fail-closed `neg` form, so t1 pins the hello
    route's REFUSAL content, not a positive handshake. A
    positive-hello pin is OWED and rides beside the utility_bits
    row at the next oracle-bearing increment.
R5. **OB-20/21 state letters**: staged as SCHEDULED@x5-sitting-r0
    with named discharge events; accept or re-letter.
R6. **Membrane F-a/F-b**: two stale-pin citations (test-unify :55,
    test-arity :84-85 — both suites retired) found while staging
    ruling 6's eight edits; staged repairs attached, accept or
    strike.
R7. **The forward half's kills are an in-increment debt**: the 24
    new rows owe kills, and mutant patches can only be written
    against IMPLEMENTED src. Drafted pool (lands with
    implementation, matrix run at the increment's close): M15
    gammaBits drops the +depth position term; M16 kraftSubtree
    halves the tail; M17 guard endpoint extrema swapped
    (pess/opt inverted); M18 supLike clip dropped (midpoint); M19
    pwLadderCap ignored (baked 1); M20 internal act ordered before
    respond; M21 mkOwned drops parent closure; M22 refine arm
    ignores the straddle. The increment DOES NOT CLOSE until the
    matrix run records the new rows' kills.
R8. **The GroundC re-execution** (banked deadlock observation,
    EXACT_PLAN 13.3's expiry rider): post-implementation
    obligation, transcript owed in this pack before the trampoline
    boundary relies on it.
R9. **Gate-5 form during the red phase**: the dyadic stanza enters
    proplang.cabal at YOUR freeze and is red-by-design until
    implementation (the exact oracle's own precedent,
    proplang.cabal:59-62); freeze-commands.txt item 7 records the
    running form.

## 5. The drafted freeze record (prepared after the freeze review of 2026-07-26; binds at your `dyadic-freeze-r0` tag)

The independent freeze review verified the chain (custody, the red
run reproduced flag-faithfully from the oracle's identical text,
every hand derivation re-derived, the R-D20 copies checked against
the sealed pack) and recommended verdicts; the two substantive
additions are FOLDED INTO THE STAGED KIT (OB-22/23; the R7
pre-ruling below). Nothing binds until your tag.

- **R1 ACCEPT**: `gammaBits :: Integer` — the honest sort for a
  bit-length; no consumer exists.
- **R2 ACCEPT**: `nodeLambda` leaves the exports; no display
  demands it; Report-edge re-entry if one ever does.
- **R3 ACCEPT**: `rLo`/`rHi`/`rMass` per the staged diff.
- **R4 ACCEPT, CONVERTED**: the owed positive-hello pin is an
  OBLIGATIONS row at this freeze (OB-22, with the utility_bits
  row), not a pack parenthetical — the parenthetical-evaporation
  shape refused.
- **R5 ACCEPT as staged**: SCHEDULED with named discharge events;
  no new state letter minted.
- **R6 ACCEPT both**: F-b's repair cites the live test-pin row;
  F-a's owed pin is OB-23.
- **R7 ACCEPT, PRE-RULED**: a new row's unique kill is measured
  against the STANDING (pre-increment) corpus; sibling shadowing
  within the new suite is recorded as verdicts at the next matrix
  run, never a close-blocker. The M15-M22 pool lands with
  implementation; the increment does not close without the matrix
  run recording the new rows' kills.
- **R8 ACCEPT**: the GroundC re-execution transcript rides this
  pack before the trampoline boundary relies on the observation
  (banked-failure expiry, applied as canonized).
- **R9 ACCEPT**: the exact oracle's precedent; freeze-commands.txt
  item 7 the running form.

**The seal**: the freeze commit executes `freeze-commands.txt`
(stanza + five frozen files + OB-20..23 + manifest extension over
test-dyadic/), and the attestation is your signed tag
`dyadic-freeze-r0` — in person, or executed by the builder on
fresh, explicit, per-instance delegation recorded verbatim in the
tag message (the membrane precedent; R-D22's re-tag obligation
then binds within the increment). From that tag: implementation
(the overlay semantics land in src), gates 1-7 green, the mutant
pool + matrix run, the GroundC re-execution, and the increment
report close it out.

## 6. THE FREEZE EXECUTED AND THE IMPLEMENTATION CLOSED (2026-07-26, on the recorded delegation)

**The freeze**: commit `1b8827d` landed the five frozen installs +
the stanza + manifest 64/64; tag `dyadic-freeze-r0` made with the
BUILDER key, the delegation ("you write everything, i just sign —
execute the freeze on delegation") recorded verbatim in the tag
message. Gate state at the tag: six standing suites PASS (the probe
split green), dyadic FAIL red-by-design 24/24, prefreeze-lint
0 FAIL / 0 WARN.

**The implementation** (commit `4d20083`): the stub bodies replaced
by the SAT-proven semantics. ALL SEVEN SUITES PASS — dyadic 24/24
green; audit/gates-exact.sh exit 0 with E1/E2/E3 clean (the last
Double island in core is gone); prefreeze-lint clean. One
sequencing incident, recorded: the first mutant-cutting attempt ran
BEFORE the implementation was committed, and the runner's
git-checkout revert wiped the uncommitted implementation — nothing
lost (re-applied from the SAT-proven text), and the lesson is
mechanical: MUTANTS ARE CUT AGAINST A COMMITTED GREEN BASELINE,
never a working tree.

**The forward half discharged — 13 mutants, 24/24 rows reached, no
survivors.** The pool (audit/mutants/M15-M27, each a named minimal
semantic patch, each compile-checked in isolation): M15 gamma
position dropped, M16 kraft tail halved, M17 guard extrema swapped,
M18 supLike clip to midpoint, M19 ladder cap baked to 1, M20 wait
tie surrendered, M21 canonical order inverted, M22 straddle gate
inverted, M23 theta denominator tripled, M24 children collide, M25
regions reversed, M26 stake sign flipped, M27 no-refine world buys
free. The first eight reached 16 rows and left the coordinate rows,
the zip contract, d4.3 and d6.3 unreached — the pool grew five
mutants ON THAT FINDING (the pool-is-grown amendment applied to the
pool's own increment) to 24/24. STANDING-CORPUS UNIQUENESS IS
STRUCTURAL: zero standing test files import PropLang.Lattice or
PropLang.Purchase (grep count 0, in the matrix transcript), so no
standing row can fire under any of these mutants — every dyadic
kill is unique against the standing corpus, per R7's pre-ruling.
Per-mutant kill sets: scratchpad dyadic-matrix/*.kills. Sibling
shadowing within the suite (e.g. the d6.1/d6.2 pair killed by every
purchase-path mutant) is recorded as R7 provides, for the next full
matrix run — tools/oracle-audit.sh's declared universe now includes
the dyadic suite for that run.

**The GroundC re-execution (13.3's expiry rider, DISCHARGED)**: the
banked deadlock observation re-executed against the SHIPPED dyadic
Lattice — root-only vocabulary, cap 16, surcharge 1/20:

    t96  (1,-24),  60x1: wait 60 respond 0 refine 0
    t994 (1,-171), 60x1: wait 60 respond 0 refine 0

The max-0 clamp deadlock REPRODUCES on the shipped module exactly
as banked: from root-only vocabulary at deep-threshold stakes,
refine never fires. The trampoline boundary may now rely on the
observation (its design choice: rung ladder sees multi-step value,
or the deadlock documented as the myopic candidate's honest
behavior).

**What remains for this increment's close**: your countersigning
tag `dyadic-freeze-r1` over the implementation-green history — the
R-D22 re-tag obligation, the discharge event for the delegated r0
(the w3/w4 precedent: the author's r1 over the green commit).

Session custody: builder key on every commit; manifest 64/64 green
from the freeze commit forward; all transcripts on disk in the
session scratchpad and quoted here.
