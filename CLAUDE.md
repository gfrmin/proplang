# CLAUDE.md — build protocol for the proplang typed port

You are implementing the Haskell port of proplang. Read, in order:
`design.md` (the language), `interface.md` (the membrane),
`typed-port-spec.md` (the type-level spec you are building to). The Python
files `proplang.py` and `tests_acceptance.py` are the executable
specification of intended behavior. This file is the protocol; it is not
negotiable and not editable by you.

## The premise you are working under

The type system is the adversary's handcuffs, and in this protocol you are
treated as the adversary. This is not an insult; it is the design. Every
invariant that can be a compile fact must be one, and everything that
cannot be a compile fact is a frozen oracle you do not control. If you find
yourself needing an escape hatch, the design is wrong or your plan is —
stop and report, do not hatch.

## Two-phase build (the frozen oracle)

**Phase 1 — oracle first.** Port `tests_acceptance.py` to
`test/Acceptance.hs` and write `test/Properties.hs` (CL-4 conjugacy
equivalence; fineness-charged-once) against the signatures in
`typed-port-spec.md` S2-S3, before writing any implementation. Reproduce
the Python tests' worlds exactly: same generative parameters, and seeds
re-derived so the observation streams match the Python streams
bit-for-bit (port the stream, not the RNG). Expected anchors: test 1's
consult window and MAP change-point sentence at tau=60; test 2's tick
counts 1/3/12/12 at prices 0.3/0.05/0.005/0; test 3's agent-vs-forgetter
log-loss relations; the full deletion table. Phase 1 ends with human
review; the human runs `sha256sum` over `test/`, `audit/`, and this file
into `MANIFEST.sha256` and signs it.

**Phase 2 — implementation.** Build `src/` until the gates pass. From this
point, any diff under `test/`, `audit/`, `CLAUDE.md`, or `MANIFEST.sha256`
is a protocol violation, even a whitespace fix, even if a test is wrong. If
a frozen test IS wrong, stop and report; the human re-opens Phase 1.

## Gates (definition of done — all of them, no partial credit)

1. `ghc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`
   clean on all of `src/`.
2. Export-list check: `Belief(..)` never exported; `PropLang.Belief`
   exports exactly the list in typed-port-spec S2.
3. Effect check: no `IO` in any type in `src/PropLang/{Belief,Syntax,
   Eval,Enumerate}.hs`; `draw` and the polling loop live in `Host.hs` only.
4. Forbidden imports/tokens in `src/` (this list is also `audit/forbidden.txt`
   and frozen): `unsafePerformIO`, `unsafeCoerce`, `Debug.Trace`,
   `System.IO.Unsafe`, `IORef`, `unsafeInterleaveIO`, plus the semantic
   list from the Python audit: detect, forget, window, decay, sliding,
   reset, trigger, temper, anneal, throttle (code tokens, not comments).
5. `test/Acceptance.hs` and `test/Properties.hs` pass.
6. `sha256sum -c MANIFEST.sha256` passes.
7. The deletion audit runs against the real grammar: each terminal's
   removal is a code-level ablation (a GADT constructor behind a CPP flag
   or a restricted enumeration), not a mock.

## Forbidden moves (each one is a way to cheat that the compiler alone
cannot catch; that is why it is written down)

- Editing anything frozen (see Phase 2).
- Weakening compiler flags, adding `-fdefer-type-errors`, or moving code
  out of `src/` to dodge a gate.
- Hardcoding expected outputs, seeds inside `src/`, or test-aware branches
  (`if testing then ...`).
- Adding a constructor to `Evidence` or exporting the `Belief` constructor
  "temporarily."
- Embedding host lambdas in `Expr` where the spec says defunctionalized
  syntax (`Fn`, `Stats`): if you need a new function form, add a first-order
  constructor with a bit-price and report it as an alphabet change.
- Introducing any numeric literal into `src/` that steers deliberation or
  adaptation. Grid definitions are data with prices; anything else is a
  baked constant and fails review.
- Catching exceptions to paper over partiality: totality is the point;
  use the types (`Maybe`, closed variants).

## Porting order

1. `Belief.hs` (sealed reasoner) — smallest surface, everything depends on it.
2. `Syntax.hs` + `bits` (total pricing) — then `Eval.hs`.
3. `Enumerate.hs` (Cromwell frontier as a parameter) — test 1 and 3 green.
4. Deliberation via the menu (`Think` as data) — test 2 green at depth=1
   prices; the myopic case must be the ladder's chosen rung, not a branch.
5. Deletion audit wiring — test 4 green. STOP: this is parity with Python.
6. Only after parity, in separate reviewed increments: `ExpFam` basis with
   `bern` re-derived as a stdlib name and `rw` recorded as the alphabet's
   one non-expfam combinator (EXPFAM_PLAN T1; the original "bern/rw
   re-derived" promise was half-impossible without an anchor re-open and
   is amended here, at a freeze boundary, by the author), then the
   membrane (interface.md S1-S3), self-features, the full fidelity ladder
   with acceptance test F, then action-dependence in vThink's
   preposterior (increment 5) and utility-as-latent under the discrete
   reading (increment 6, CIRL). Completed through increment 6 (the
   pointer). The roadmap terminates here; any further scope binds P5's
   single-site alphabet-constant clause and requires a new roadmap
   boundary.
   The roadmap re-opens at the hosts boundary (HOSTS_PLAN, c65a386):
   increment H (the host driver and the single-site alphabet
   constant), then D (the latent-utility pilot, outcome-grounded,
   brought before A by the governor's measured demand; D0 subsumed
   by ruling R-D2), then A (options-as-data observations), then
   demand-gated B (the reliability channel), and C (arithmetic, the
   census-bearing change) — each its own oracle-first freeze, each
   gated as HOSTS_PLAN section 9 records.

## When to stop and report instead of proceeding

A frozen test appears wrong; a gate conflicts with another gate; the spec
under-determines a type you need; parity with a Python number cannot be
achieved within tolerance and you believe the Python is the bug. In every
such case the correct output is a report with the smallest reproducing
detail, not a workaround. An elegant workaround here is a defect.

## Increment protocol (post-parity; canonized at the grammar-hygiene freeze)

Every step-6+ increment follows the recursive two-phase discipline:

1. **One oracle directory per increment** (`test-hygiene/`,
   `test-expfam/`, ...), each a cabal test-suite stanza. The frozen
   gate 5 (`cabal test all`) absorbs each new suite with no edit to any
   frozen audit script. Increment-local ablations carry their own
   fixtures and runner inside the increment's oracle directory — frozen
   audit scripts never grow rows.
2. **Oracle first, runtime-red.** The builder writes the increment
   oracle before any implementation, red against compile-enabling
   type-surface stubs (type surface is oracle-phase work; a
   compile-failing oracle proves nothing). The oracle-phase runner
   must be bit-faithful to the future gate conditions — the stanza's
   exact compiler flags and warning set; a red run under weaker flags
   proves nothing (the ExpFam re-open, 4c7b49d). A pinned literal that
   must agree with a frozen quantity is derived from the frozen
   artifact itself, never from a parallel derivation — sanity
   simulations establish discriminating power, not pin values (the
   membrane pre-tag re-open). A compile-red fixture is proven
   type-correct against the drafted future surface before the freeze
   seals it — its red must be demonstrated to be the missing
   constructor, not assumed (the ladder's Argmax-environment bug,
   caught by exactly this proof). Existing frozen suites stay green
   throughout. Increment-oracle test names are ASCII-only (the
   membrane's locale incident, 2026-07-05).
   Three rulings from D bind every future increment oracle
   (R-D20/21/22, canonized here at the R-D14 boundary):
   copy-not-reconstruct (R-D20-i) — an oracle row claiming a frozen
   formula copies it byte-wise with provenance, quoted in
   the pack, reviewable by grep, never re-derived in parallel.
   AMENDED at the readout boundary (2026-08-02): this clause read
   "byte-wise with FILE:LINE provenance" until the readout increment
   measured that a bare line number is stale BY CONSTRUCTION in the
   one place R-D20-i most binds. An oracle frozen BEFORE the
   implementation it prophesies carries absolute lines that rot the
   instant that implementation lands, so the clause as written
   mandated an anchor its own timing guarantees would falsify. THE
   ANCHOR IS THE COMMIT HASH PLUS THE BINDING NAME — e.g.
   `src/PropLang/Host.hs` at `bd0d70c`, the binding
   `p1 <- predictMassS full 1 ag`. Where the citation must point at
   an ANONYMOUS expression, the quoted expression text IS the anchor.
   A line number may accompany as a convenience and is never the
   referent. This is R-D20-i's own discipline carried from WHAT is
   copied to HOW IT IS ADDRESSED: a binding name survives the motion
   a line number does not. Its provenance is a live instance in the
   increment that asked for the rule — the readout pack's own Part
   I.2 cited `Host.hs:425`/`:516`, true of `bd0d70c` and false of
   HEAD, so the PROSE carried the disease the oracle beside it had
   already been cured of. The scriptable half is a boundary-audit
   candidate and is deliberately NOT written at this freeze; it
   routes with FL-3. The
   satisfiability-transcript gate (R-D21) — the oracle phase ends
   only when every runtime-red row's asserted quantity has been
   executed once against a throwaway prototype realization, recorded
   as a satisfiability transcript in the author pack, prototypes
   discarded; a red row without a transcript line cannot freeze; and
   the delegated-edit re-tag obligation (R-D22) — any delegated
   freeze-edit obliges an author re-tag WITHIN the increment: the
   increment does not close until the author's own signed tag covers
   the oracle as amended; the countersignature is a condition of
   closure, never a courtesy afterwards.
   Four clauses canonized at the step-2 boundary (the optimisation-law
   freeze, 2026-07-15). A transcript proves only the row text ACTUALLY
   FROZEN (the step-1 group-3 re-open): before the freeze seals a red
   row, its exact drafted expression — never the prototype's own
   variant of it — is executed once against the prototype; and the
   transcript must force the frozen side of every comparison row to
   normal form, independently of the stub side (one deepseq per row),
   proving the red is attributable to the missing implementation
   rather than to a defect the stub happens to shadow. An increment
   whose step carries a falsifier runs it as an ORACLE-PHASE EVIDENCE
   PROGRAM: executed on throwaway prototypes (R-D21), success criteria
   pre-stated numerically, before any ruling freezes — so a freeze
   never encodes what its own falsifier convicts. For a PIN-FREEZE —
   an increment that pins an already-shipped fast path OR CAPABILITY,
   where no implementation is owed — the red-run clause is satisfied by a
   seeded-defect demonstration: every row's red reachable, attribution
   partitioned (the step-2 precedent). The "or capability" is AMENDED at
   the step-10 boundary (reflexive-freeze-r0, 2026-07-18): step 10 pinned
   the deliberation composition — an already-shipped CAPABILITY, no
   implementation owed — with the same structure as a fast-path pin (pin
   the shipped thing to the reference route; seeded defects for the red),
   so the clause covers a capability composition as well as an
   optimisation; step 10 is that reading's provenance.
   Three lines canonized at the step-3 boundary (the sentence freeze,
   2026-07-15). A sweep's universe derives from the custody record
   plus declared non-manifest surfaces — never hand-enumeration (the
   D6 sweep incident). DISCHARGED-PERMANENT is a named register
   category: the terminal state of an ablation fixture, reached when
   the deletion it proved possible becomes the deletion that happened
   (UseBern the first instance; every ablation fixture ends there
   eventually if the roadmap is honest). And the OVERLAY form of
   R-D21 — the prototype wearing the real module's name, so the
   oracle's exact frozen text compiles against it unchanged — is the
   preferred transcript form wherever the prototype can carry the
   module interface.
   Two lines canonized at the step-5 boundary (the actions freeze,
   2026-07-16). A PROBE READS DECLARED DATA — exports, tables — and
   never re-declares a value it could import (the tauPoints incident:
   the remedy existed in the same increment's own surface and the
   probe hand-wrote the leaf anyway; sibling to the sweep-universe
   line, and the same discipline: probes are subject to it exactly as
   sweeps are). And RETIRE-UNTIL-N is a named register category: a
   retirement whose obligation returns at a scheduled boundary puts
   its return row on that boundary's opening checklist AT THE
   RETIRING FREEZE — a deferred obligation living only in a retired
   file's comment is the R6 disease wearing a new hat (g4Self the
   first instance). And the overlay-form clause is AMENDED: the
   overlay SAT compile uses the stanza's EXACT flag set, -Werror
   included — bit-faithful means FLAG-faithful (the step-5 incident:
   the reorder's first red run caught the r0 overlay compile without
   -Werror carrying two redundant imports; caught inside the freeze
   window, fixed, re-witnessed, re-sealed). AND, amended at the jp
   close (2026-07-28, the containers incident): bit-faithful means
   PACKAGE-faithful as well — an overlay SAT compile runs under the
   stanza's DEPENDENCY CLOSURE (-hide-all-packages plus the declared
   build-depends), because plain ghc exposes every GHC boot package
   while cabal hides the undeclared; a dependency gap in the frozen
   build file is invisible to every plain-ghc compile BY
   CONSTRUCTION, and the jp prophecy's Data.Map import reached the
   implementation phase unseen through exactly that gap (the
   library stanza's base-only decision amended to
   GHC-boot-libraries-only under the author's key, the falsified
   words quoted inside the repair, the frozen ablation audit 6/6 on
   the amended surface).
   One line canonized at the step-4 boundary (the pricing freeze,
   2026-07-15): A RETIREMENT LISTS ITS PINS — a retirement
   disposition enumerates every pin the retiring file carries and
   names each one's destination (re-homed, ported, or
   discharged-permanent) in the same freeze; step 3's lineage headers
   did this for the acceptance deliverables, and the gP5 pin —
   re-homed one step late because the govhost retirement never
   enumerated what the file carried — is the incident that bought the
   rule.
   Five clauses canonized at the step-6 boundary (the stream freeze,
   2026-07-16; each drafted in the step-6 pack Part IV and approved
   at the sitting, §24's standing alone by the author's ruling).
   One line, installing AGENT_PLAN §8c's ruling of 2026-07-12, which
   until this boundary bound only as signed prose: THE
   TYPE-DERIVATION AUDIT — every TYPE on a frozen surface carries a
   one-line derivation from the brief, exactly as every terminal
   carries a one-line deletion proof; a type without one is cut, or
   the brief is amended to license it (the `Util a y` incident its
   provenance: it was a type, not a terminal, that hid the calculator
   for 86 commits — the deletion audit polices the alphabet, this
   polices the types). The rule binds FORWARD from this freeze (a new
   type arrives WITH its derivation line, in the landing increment);
   step 9 keeps the retrospective audit over the standing stock.
   One clause: PRIMITIVITY IS A TWO-SIDED ENTRY GATE. A production
   enters the alphabet only with BOTH (a) an executed FAILED
   composition attempt — the candidate written as a sentence of the
   existing grammar, its failure demonstrated extensionally or at the
   type level, transcribed in the increment's pack (only demonstrated
   failure licenses the codeword; ToR's pinned disagreement case,
   test-code group 4, is the standard) — and (b) the in-increment
   ablation fixture (the design-review gate's law). Five VOI
   primitives and Bern entered without (a) and cost two demolition
   steps; that purchase is this clause's provenance.
   One clause: THE BOUNDARY AUDIT. Brief-vs-as-built re-derivation is
   a STANDING EVENT at every roadmap boundary — run scheduled, never
   on accumulated suspicion (BRIEF_AUDIT, the highest yield-per-cost
   artifact in the repo, ran once and on suspicion; that is the
   provenance). Its greppable rows run first (tools/boundary-audit.sh:
   the M5-row — every ruling ID's citations counted against
   definition sites; the H-row — every wire/membrane symbol resolves
   to a definition site or a world-declaration marker) and their
   flags are triage inputs for the human sweep, never verdicts. The
   audit output rides the boundary's author pack.
   One clause: THE RED-TEAM MANDATES. At every roadmap boundary, six
   standing questions are put to the increment by reviewers
   INDEPENDENT of the builder's context — one mandate each: (1) is
   any theorem installed as a definition (the Savage shape, committed
   twice by the same reflex)? (2) is any ruling asserted N times and
   derived zero (M5)? (3) is any load-bearing quantity defined
   nowhere (H)? (4) does any type on a frozen surface lack its
   derivation (Util)? (5) is any convention silently overloaded
   (dormancy-as-wait)? (6) for every new object: WHAT IS IT A
   FUNCTION OF? Findings ride the boundary's author pack beside the
   audit rows. The floor, not the ceiling: taste asks the novel
   questions; the mandates stop the known shapes recurring.
   Execution mode, confirmed at the sitting: fresh-context reviewer
   agents, one mandate each — fresh context is independence of STATE,
   not of priors, so true external review remains explicitly
   available at the author's election (the 2026-07-11 pattern).
   One clause: THE PRE-FREEZE LINT. tools/prefreeze-lint.sh runs
   before every freeze tag and its transcript rides the pack —
   remembered law converted into enforced law ("enforced, never
   trusted", applied to the process itself). Its rows are the
   scriptable halves of standing clauses (forbidden tokens by glob
   over ALL of src — the frozen gate 4 names five files and the
   membrane escaped it; ASCII test names; manifest; tag signatures;
   SAT flag-faithfulness); a clause's non-scriptable half stays law
   as prose. Its first firing found the ASCII clause violated in four
   frozen oracles the day it became enforced — that is the
   provenance.
   One line canonized at the step-7 boundary (the unify freeze,
   2026-07-17): THE FROZEN-LAYER INVENTORY. Every boundary sitting
   receives an inventory of frozen prose the increment's rulings or
   measurements have falsified; repairs execute under that boundary's
   key, in the form the text class demands — in-place with the
   falsified sentence quoted inside its own repair for normative
   prose, a dated bracket for historical record, a dated supersession
   note for close-date documents, two-sided record rows for
   instruments (a green that cannot fail is the mirror image of the
   red that cannot fire). NEVER a standing license: the builder
   touches the frozen layer only at a boundary, under an inventory
   brought to the sitting (the step-7 sweep its provenance — the
   directive was per-sitting and verbatim-quoted).
   One clause canonized at the step-9 boundary (the elimination freeze,
   2026-07-18): THE FULL-CORPUS OVERLAY BUILD. tools/prefreeze-lint.sh
   (row v / L7) derives the corpus BY GLOB — every test .hs under
   test*/ — and BUILDS each against the shipped src: stanza'd suites
   through cabal, standalone fixtures through `ghc -isrc`, so no test
   file escapes the replacement-surface build. Its provenance is the
   step-8 seal, where the census enumerated seven suites and the wave
   had twelve members: a naive "cabal test before freezing" proves
   NOTHING while the corpus is red BY DESIGN until implementation, and
   a file in no stanza is built by nothing — all five misses would have
   failed this row instantly ("the enumeration is what the census can
   get wrong; the corpus is what the build cannot"). A retired fixture
   left in-tree fails the row — which is why DISCHARGED-PERMANENT means
   the file is DELETED, not kept as dead code. Its transcript rides the
   boundary's pack.
   One clause canonized at the step-10 boundary (the reflexive freeze,
   2026-07-18): A BANKED COMPOSITION-FAILURE EXPIRES WHEN THE ALPHABET
   MOVES. A negative result — a demonstrated failed composition banked
   under the primitivity gate's clause (a) — is a HYPOTHESIS at any later
   boundary whose terms changed underneath it, and must be RE-EXECUTED
   against the shipped grammar before it is relied upon. Its provenance
   is step 10's opening measurement (E-g1): step 8 banked "the
   world-rollforward needs an endo-kernel the type surface refuses" as
   the license for a horizon PRODUCTION; step 9 then moved the alphabet
   (deleted IsEq, landed Expect/SawE/ElimJ/Code), and the step-10
   re-execution found the verdict too strong — the step-8 attempt had
   never tried `Pos`, and the frozen walk move-code had been a Pos-index
   rollforward kernel since step 1. Re-testing the banked verdict as a
   hypothesis is exactly what stood between step 10 and landing a
   needless production on a stale negative. The scriptable half is a
   boundary-audit candidate (flag every banked clause-(a) failure whose
   increment postdates the alphabet motion it assumed); the
   non-scriptable half stays law as prose.
   One clause canonized at the disposition sitting of 2026-07-22 (the
   two-run triptych, named at the W4 sitting; the okPrefix conviction
   its provenance): A GREEN THAT CANNOT FAIL IS THE MIRROR IMAGE OF
   THE RED THAT CANNOT FIRE — and a helper too strict on the GREEN
   side is invisible in red, so the row fails once for the right
   reason and then forever for the wrong one. An increment oracle's
   two-run structure is load-bearing in BOTH directions: the red run
   proves every row CAN fire; the SAT run proves every row CAN pass;
   neither run alone certifies a helper, and a freeze relies on both.
   AMENDED at the heir oracle freeze (breadth-freeze-r0, 2026-08-06;
   OB-27, riding breadth-sitting-r0's routed authority): the clause's
   scope names HARNESS GATES as within it. The triptych's reasoning
   applies to the INSTRUMENT as well as to the rows it runs — a kit
   or gate check that cannot fail (the readout pre-tag finding (d):
   `diff ... && echo` under set -e, where a mismatch prints its diff
   and falls through to "ALL CHECKS PASSED") is the same defect
   wearing the harness's coat, and every kit gate arrives with its
   red demonstrated exactly as every oracle row does.
   One clause canonized at the dyadic freeze under the X.5 sitting's
   rulings 5 and 2 (x5-sitting-r0, 2026-07-26; drafted at the exact
   close, first run r2 at the X.5 pack; delegated edit, the dyadic
   freeze kit). AN ORACLE ROW EARNS ITS SEAT BY A UNIQUE KILL. The
   mutant pool is DECLARED — audit/mutants/, each mutant a named
   minimal patch instantiating a recorded failure shape, the pool
   derived from the incident case law plus a declared operator list
   (the sweep-universe law; hand-enumeration is the disease). The
   audit runs the frozen suites against every mutant and records the
   KILL MATRIX. Verdicts are triage inputs for the sitting, never
   auto-deletions: EARNED — a nonempty unique-kill set; SHADOWED —
   every kill covered by other rows; UNREACHED — no mutant kills it
   (either the pool is deficient or the row is a
   green-that-cannot-fail; both convict something, and which one is
   the sitting's question). Deletions execute only at a boundary
   under the author's key, pins listed. FORWARD HALF: a new oracle
   row arrives WITH its kill — the triptych proves a row CAN fire;
   the kill proves it fires for a reason no standing row covers; a
   new row's unique kill is measured against the STANDING
   (pre-increment) corpus, and sibling shadowing within a new suite
   is recorded as verdicts at the next matrix run, never a
   close-blocker (the dyadic R7 pre-ruling). Two amendment lines
   purchased by the r2 run: A VERDICT IS POOL-RELATIVE AND A POOL IS
   GROWN, NEVER ASSUMED — three rows moved to EARNED at the first
   pool growth; a deletion verdict read off a single pool is the
   two-run triptych's mistake wearing the matrix's hat. And
   STRUCTURAL SHADOWING IS AN ANSWER, NOT A FAILURE — rows differing
   only in test-side data cannot be separated by a test-blind src
   mutant; for such rows the pool-coarseness question closes by
   demonstration, and the residual question (is the redundancy
   wanted?) is a row-VALUE ruling, never a pool obligation. And THE
   RECORDED-REPAIRS RIDER (ruling 2, the pwLadderCap stale-green's
   purchase): a repair recorded in a pack CITES ITS COMMIT HASH in
   the repair row, and the pre-freeze checklist verifies every cited
   hash touches the file the row names — recorded repairs are
   verified against the tree, mechanically, so the stale-green class
   dies structurally. AND, amended at the trampoline r1 sitting
   (2026-07-27, F6's canonization): AN ENGINE-LEVEL RE-LAND COLLAPSES
   KILL GEOMETRY BY DESIGN — when a re-land routes standing suites
   through the very macro the new rows pin, shadowing is the EXPECTED
   verdict shape for engine-level mutants, and the honest uniqueness
   reading is per-ROW against the pool, never per-suite against the
   corpus (the trampoline close, F6, its provenance).
   One line canonized at the trampoline r1 sitting (2026-07-27, the
   E4 stop-and-report its provenance): E-GATE ALLOWLISTS ARE
   ENUMERATED AGAINST THE SAT OVERLAY, not the stub surface alone —
   the overlay is the implementation's prophecy, and a token gate
   whose allowlist saw only stubs has a one-sided green; the gate's
   oracle-phase run executes against the overlay exactly as the SAT
   compile does (flag-faithful, surface-faithful).
   One line canonized at the battery boundary (2026-07-30; mandate
   2's finding its provenance — "the no-silent-caps law" cited three
   times, defined nowhere): NO SILENT CAPS — a suite that bounds its
   own coverage (a walked family's axes and ranges, a top-N, a
   sampled subset) PRINTS the residual as a row, never absorbs it.
   The substance is EXACT_PLAN 14.1's discipline ("the RESIDUAL —
   the axes and ranges the family does not span — is PRINTED by the
   suite, never absorbed"); this line is the citation's definition
   site.
   One line canonized at the battery boundary (2026-07-30; the
   author's ruling of 2026-07-28 on g-b2.2's owed red — "never owe
   a red if possible"), CITABLE AS **R-RED** (the ID was in use at
   the battery's freeze kit and nowhere in this file, so a greppable
   audit for it found only the kit - the readout increment's mandate
   round, 2026-07-31): A RED IS CONSTRUCTED, NEVER OWED. An
   invariance row's red lives only at a decision margin, and
   generic streams and pools jump over margins — so when a row's
   red does not fire under the pool, the increment computes the
   exact margin or window and CONSTRUCTS the crossing
   world/stream/parameter (measure the window first, place a
   declared parameter strictly inside it, confirm the seeded
   defect fires) in the same increment. Only a demonstrated
   impossibility licenses an owed red, and then it rides to the
   sitting as a named docket item. Provenance: g-b2.2's
   structural-cap discovery — the pessimism guard bounded by
   (1-s)/2, so the discriminating window was unreachable at the
   standing stakes on ANY stream; the stakes axis was the free
   variable, and the constructed triple fired the red the pool
   could not. THE HONEST-DECLINE PATH IS PART OF THE LAW: where no
   red is CONSTRUCTIBLE, the row is disposed as a RECORD row with
   the impossibility argument stated (the battery residual row,
   under the F6 precedent, its precedent) — never fabricated into
   an artificial cell. The law demands the window computation, not
   a red by any means.
   One clause canonized at the readout close (readout-freeze-r1,
   2026-08-04; the r0 key act's hang its provenance): THE TAG
   MESSAGE IS A FILE, NEVER A SHELL STRING. A freeze kit passes
   its drafted register to `git tag` by -F <file>, the message
   file itself a manifest row — never by -m "<prose>", which puts
   a shell parser between the reviewed register and the key act.
   Inside the -m quotes a backtick span is EXECUTED, not quoted
   (the r0 sitting hung for hours: `git apply --check`, cited as
   prose in the register, ran as a command substitution and read
   the terminal for a patch), and an unescaped inner quote is an
   argument boundary (the register's quoted phrase "every kill
   readout-unique" split the message into extra arguments, so the
   key act as drafted could never have parsed — the kit could not
   have minted its own tag on ANY run; the tag was minted true by
   extracting the register to a file and signing with -F, the
   minted message byte-identical to the drafted one, the identity
   now the r1 kit's standing record row). The class is structural,
   not a typo: the key act is the ONE line no rehearsal executes —
   a rehearsal has no key — so a defect in the tag command's DATA
   is unreachable by the two-sided rehearsal BY DESIGN, and the
   repair shrinks the unrehearsable surface to a constant command
   whose data rides in a file the manifest hashes and diff can
   check. The scriptable half is lint row L9: a git tag -m in a
   freeze kit whose tag does not yet exist FAILS; executed kits
   derive their exemption from their tag's existence, never from
   a hand list (L9 not L8: OB-26 named its own future row L8 at
   scheduling, and that seat stays reserved for the OB-19 heir).
   One clause canonized at the heir oracle freeze (breadth-freeze-r0,
   2026-08-06; drafted as pack XV.2, widened at r7, ratified by the
   breadth-sitting-r0 tag — the clause text copied from the pack, not
   re-derived): AN UNWITNESSED ASSERTION OUTSIDE THE MEASURED REGION
   IS EXECUTED OR MARKED. The class has two species: a UNIVERSAL
   CLAIM quantifying over the shipped corpus, its streams, or their
   orderings ("every", "no", "any", "cannot"); and an EXTRAPOLATION
   asserting behavior at depths, K values, populations, streams, or
   hardware beyond what a cell measured — the commoner species in a
   measurement pack. Either kind carries an executed witness — a
   falsification attempt against the shipped surface, transcript
   beside it, R-D21's discipline carried from oracle rows to pack
   prose — or is marked ARGUED-NOT-EXECUTED with its cheapest
   falsifier NAMED; naming the falsifier is the load-bearing act,
   because a named-but-unrun falsifier is visibly absurd where an
   unnamed one is invisible. An argument-closed residual closes only
   through its own attempted refutation. AND: A STRENGTHENING IS A
   NEW CLAIM — when the author or a frozen text supplies an argument,
   the pack copies its scope; any builder extension beyond that scope
   is labeled as the builder's addition and arrives with its own
   witness. Provenance: the r5 exchangeability incident
   (breadth-author-pack.md XIV.5) — the author's divisibility bound
   needed no exchangeability; the builder's "improvement" assumed it;
   the corpus's 40 walk rows (rw, non-exchangeable BY DESIGN)
   falsified it; P10 executed the owed falsifier in one minute,
   two-sided. THE REGISTER'S UNIVERSE IS QUANTIFIER HITS UNION
   VERDICT CONVICTIONS. A reviewer's written conviction is a custody
   record; the sweep-universe law already derives every sweep's
   domain from custody records, and a register sweep is no exception.
   Every conviction row receives an explicit disposition — REPAIRED,
   BRACKETED, or ARGUED-AND-DECLINED; declining a conviction is
   legitimate, declining it silently is not (the r7 verdict: three of
   the four r5 convictions survived a sweep that grepped for
   quantifiers and never read the verdicts — two of them quantified
   over NOTHING). The scriptable halves: the per-pack CLAIMS REGISTER
   (rows tagged EXECUTED(transcript) / ARGUED(falsifier named) /
   QUOTED(whose words)) and the boundary-audit's bare-quantifier
   triage row — triage inputs for the human sweep, never verdicts
   (the M5/H pattern). The claims register rides BESIDE the
   increment's under-determination register and does not replace it:
   "as-built answers to its register" in the increment protocol's
   close continues to name the under-determination register. Mandate
   7 was DECLINED at the same sitting: six red-team mandates stand.
   One clause canonized at the same freeze under the author's
   freeze-review verdict of 2026-08-07 ("The one-generator law has
   now been paid for three times... It should be canon for any pair
   of artefacts required to agree - harnesses and kit drivers
   included, because the third instance nearly cost you a rehearsal,
   and the next one will be somewhere the clean-tree gate is not
   watching"): THE ONE-GENERATOR LAW. Any two artefacts required to
   agree share ONE generator, or one of them DERIVES from the other
   and ASSERTS the derivation at run time - never two hand-maintained
   copies. The law was already the probe-discipline's shape for
   declared data (step 5) and the breadth pack's XVIII.2 statement
   for wire ticks; this clause carries it to EVERY paired artefact,
   harnesses and kit drivers included, because the third instance
   lived in the rehearsal driver - outside every suite, where no
   clean-tree gate watches. The three paid instances, named: the
   breadth oracle draft's parallel hand-written tick list (caught
   before anything ran); the dup-list comment; and the rehearsal
   driver's hand-copied ratio literal, which went stale one mint
   later, no-oped its own seed, and silently ran a full 2-freeze in
   a red leg (the r10d two-lists incident) - the repaired driver
   derives-and-asserts: grep the literal from the frozen file, assert
   nonempty, assert the seed took. A hand copy tracking a generated
   value is correct at birth and wrong at the first regeneration.
   One clause canonized at the #19 sitting (doctrine-sitting-r0,
   2026-08-08; the 1a-or-doctrine fork's D2 ruling, the wire docket's
   last scheduled item, executed on the author's recorded delegation
   with the author's r1 re-tag the close condition): DECLARED
   STRUCTURE IS WORLD DATA, PRICED BY MENTION BITS; HARD-WIRED
   STRUCTURE IS A LIMITATION WITH A NAMED HEIR. Three landed
   instances — the theta codebook (E3), obs_arity, the breadth key —
   heterogeneous by design (resolution and family selection), which
   is why the clause says STRUCTURE. The ruling's consequence,
   written down as it is: canonizing the doctrine CANONIZES A
   LIMITATION AND DEFERS THE ONLY MACHINERY THAT REMOVES IT. The
   limitation is two-sided: a finite declared support bounds the
   achievable predictive by its extremes (the benign half), AND the
   posterior concentrates on the declared rung KL-nearest the true
   rate — in the limit, exchangeable stream, const family — which
   can sit on the PERMISSIVE side of a consumer's threshold: a false
   clear that evidence SHARPENS rather than repairs, the one error
   mode in this repo that grows under data (#19's legs C/D/E, the
   witness record; the consumer's mitigation is declared density
   near its operating rate, priced by mention mass, and its
   diagnostic is the empirical-frequency check — a consumer-side
   comparison, never a data-dependent adjustment to the declared
   prior). The named heir — a support that grows with evidence —
   stays demand-gated behind the door deferral, whose scriptable
   half is lint L10 (the frontier-symbol grep over the pinned
   wire-door universe); the boundary that lands the door retires
   the row.
3. **Author freeze.** The author reviews the oracle and the increment's
   under-determination register, absorbs any spec amendments (frozen
   texts change only at freeze boundaries, only by the author), then
   extends and re-signs MANIFEST.sha256 to cover the increment oracle.
   From that signature the increment oracle is as frozen as test/.
4. **Implementation** until all gates are green, anchors byte-stable.
   Any pinned-anchor movement is stop-and-report. The increment ends
   with a report (as-built answers to its register) and the reviewer
   verification block run by the human.

The builder never owns a live oracle at the moment it becomes binding.

THE OPTIMISATION LAW (canonized at the step-2 boundary; AGENT_PLAN
§1b): any evaluator fast path is legal iff a property pins it,
extensionally, to the general route — enforced, never trusted. It
buys speed, never semantics, and it never enters the alphabet, so it
never touches the prior. The §1b audit table is exhaustive-at-r1 (the
step-2 sweep); every future fast path arrives with its pin in the
same increment that lands it — never by appending to the step-2
oracle.

Custody: the builder signs its own commits with the builder key and
never touches the author's; a freeze becomes binding when the author
countersigns the freeze commit with a signed tag from their own
shell. The tag, not any commit signature, is the attestation of
author review and approval. A tag made on delegation is legal only
when the delegation is fresh, explicit, and per-instance; the builder
then tags with the BUILDER key and records the delegation verbatim in
the tag message - the signature truthfully attests builder action
under recorded instruction and cannot mint an author attestation (the
membrane precedent).

## The exact boundary's clauses (canonized at exact-freeze-r0, 2026-07-25)

THE MINIMALITY CRITERION. A primitive exists only under a demonstrated
failed composition (clause (a), applied to the standing stock — a
boundary that moves the alphabet expires every bank) plus its ablation
fixture (clause (b)). Everything else is a derived name: a macro whose
expansion is a sentence of the primitive grammar, priced at its
expansion — convenience, never probability. Every invariant climbs the
enforcement ladder as high as it goes: unsayable at compile; derived
at build from declared data; a frozen oracle row; prose only for what
provably cannot climb. "Derive" means syntactic macro expansion
(decidable, mechanical); primitivity claims are extensional and are
earned by executed transcript, never by argument.

THE AGENT CRITERION. A deletion is legal only if the agent capability
it served remains SAYABLE, and the executable route runs through the
sentence — a host fold is legal only as a fast path pinned to the
sayable route by the optimisation law. Provenance: the author's
directive of 2026-07-25 ("a bayesian AGENT, not a calculator"); the
wire selection fold's re-homing is its first enforcement.

THE GENERATOR EXEMPTION (amends R-D21's discard convention). A
generator of frozen data is not a prototype: it lands in-tree with the
artifact it generates, and regenerating the artifact from it is a
standing identity row (audit/capture_oracle.py the precedent;
ExactReference.hs the second instance).

R17 — THE AGENT IS A DERIVATION. The agent layer's normative
definition is four derivations over the sealed reasoner: the corpus
from the grammar under a declared frontier; the agent as fromWeights
over it; the tick as Cond; prediction as Expect; choice as the If/Gt
family (CL-3-pinned). Engine code implementing any of these is a fast
path under the optimisation law, pinned extensionally to the
derivation in the same increment; the fragment table derives from the
frontier-parameterized enumeration or carries a pin — it cannot remain
a second hand-declared shape of the hypothesis space.
