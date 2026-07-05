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
   `bern`/`rw` re-derived as stdlib names, the membrane (interface.md S1-S3),
   self-features, the full fidelity ladder with acceptance test F.

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
   compile-failing oracle proves nothing). Existing frozen suites stay
   green throughout.
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
