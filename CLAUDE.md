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
   formula copies it byte-wise with file:line provenance, quoted in
   the pack, reviewable by grep, never re-derived in parallel; the
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
   an increment that pins an already-shipped fast path, where no
   implementation is owed — the red-run clause is satisfied by a
   seeded-defect demonstration: every row's red reachable, attribution
   partitioned (the step-2 precedent).
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
   window, fixed, re-witnessed, re-sealed).
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
