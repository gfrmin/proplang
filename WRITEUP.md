# proplang — the write-up

The record's face. This document consolidates `design.md` (the
language), `interface.md` (the membrane), and the measured record
against the original brief's §12, per the write-up boundary's rulings
(W1–W9, WRITEUP_PLAN.md). The frozen texts stay normative — where
this document and a frozen source could ever disagree, the source
wins and the disagreement is a defect here, which is what
`test-writeup/check.sh` exists to catch. The assumed reader has the
repo: every claim below is a pointer into it, and the closing
reviewer block (§10) re-verifies the whole chain from a clean shell.

The brief is `brief.md` — in this repository verbatim and unannotated,
entered by the author's own commit under the `brief-freeze` tag, per
W1's custody ruling: the one oracle the builder never owned enters by
the hand that wrote it.

## 1. The claim, and the answer

*(Task 3.)*

## 2. The language as built

*(Task 3.)*

## 3. The enforcement architecture

*(Task 3.)*

## 4. The measured record

*(Task 3.)*

## 5. The §12 audit

One row per §12 line, the line quoted byte-for-byte from `brief.md`
(the machine check verifies every quote). Statuses are drawn from a
closed set — DONE, RECORDED DEBT, NAMED OPEN — and a line fitting
none would be a stop-and-report finding, not a prose problem. Rows
carry dual pointers where a line was discharged twice: once by the
Python reference, once by the Haskell port under the frozen-oracle
protocol.

<!-- S12-audit-begin -->

### D1 — the grammar, with per-terminal deletion proofs

> - The **grammar**: terminals, production rules, and — for *each* terminal — a one-line proof that its deletion costs a capability that would then need external supply. Terminals without such a proof are cut.

- Python reference: `design.md` §2 prints the grammar — terminals,
  productions, and the one-line deletion proof beside each terminal;
  §8 reports the executed audit; `tests_acceptance.py` test 4 runs
  it, output frozen in `test_output.txt`.
- Haskell port: `typed-port-spec.md` §3 is the priced production
  table as grown (every alphabet change reported at a freeze
  boundary, provenance-noted); `test/Acceptance.hs` test 4 re-runs
  the audit; gate 7 makes each removal a code-level ablation — the
  fourteen `DROP_` CPP flags across `src/` — with per-increment
  attribution runners (e.g. `test-cirl/ablation.sh`).

**Status: —**

### D2 — the complexity measure, fineness charged once

> - The **complexity measure**: the per-terminal bit-cost and the resulting `2^{-|program|}`, with the fineness accounting of §5 shown to charge once and only once.

- Python reference: `design.md` §5 states which charging route the
  implementation is on and why it is sound.
- Haskell port: `bits` in `src/PropLang/Syntax.hs` is the total
  pricing function — grids are priced data, `log2 n` for an n-point
  grid, and no other numeric literal in `src/` steers deliberation
  (a frozen review gate); `test/Properties.hs` pins "fineness charged
  once: predictive mass invariant under grid refinement"; the hygiene
  suite (`test-hygiene/`) froze the policy-fragment prices.

**Status: —**

### D3 — the operational semantics, self-reference included

> - The **operational semantics**: programs as closed-loop options under polling execution, including the self-referential fragment in which push/condition/argmax appear as terminals and a program optimises over its own computations.

- Python reference: `design.md` §6 — programs as options under
  polling execution, no sequencing primitive, no stages.
- Haskell port: gate 3 confines `draw` and the polling loop to
  `src/PropLang/Host.hs` — the language constructs beliefs and
  cannot fire actions or sample; the self-referential fragment is
  real syntax: `Push`, `CondE`, `Expect`, `Argmax` are EXPR terminals
  (`typed-port-spec.md` §3), and `runDeliberation` in
  `test/Acceptance.hs` is a program optimising over its own
  conditioning — the loop runs while argmax says think. Deliberation
  itself is priced data: the fidelity ladder (`interface.md` §6,
  `test-ladder/`) and the preposterior (`test-prepost/`).

**Status: —**

### D4 — the two recorded decisions

> - The **decision on Event/Kernel primitivity** (§3) and the **decision on where the action verb fires** (§4), each with its argument and its acknowledged cost.

- Recorded decision 1, `design.md` §3: Event and Kernel as peer
  primitives — four types, no undefined reduction, the larger
  alphabet acknowledged as the cost paid.
- Recorded decision 2, `design.md` §4: the verbs are sayable
  terminals; the final action fires host-side; randomness enters only
  through host-side `draw` after the belief is built (CL-2). Carried
  into types: `Belief` sealed behind an opaque handle (gate 2),
  `Evidence` a closed variant, actions fired from
  `src/PropLang/Host.hs` only.

**Status: —**

### D5 — the reference implementation

> - A **reference implementation** adequate to run the tests below.

- Python reference: `proplang.py` + `tests_acceptance.py`, all four
  tests passing, output frozen in `test_output.txt`.
- Haskell port: `src/` under gates 1–7 (`audit/run-gates.sh`); 127
  frozen tests across the eight suites of `proplang.cabal`; parity
  anchors re-derived from the Python observation streams
  bit-for-bit (`test/Anchors.hs`).

**Status: —**

### D6 — the residues-and-open-problems section

> - A **residues-and-open-problems section** that names, rather than hides, everything in §11.

- `design.md` §10 names everything §11 requires: the three residues
  (alphabet, clock, pointer) and the open problems (exact exploration
  pricing, corrigibility at convergence, revealed-versus-idealised
  preference, reflective closure against equal-power peers).
- Movement since, recorded honestly: the alphabet residue sharpened
  to the expfam basis + `rw` proven non-expfam (`typed-port-spec.md`
  §4) + the namespace law; the clock demonstrated at its minimum by
  the ladder (test F, `test-ladder/`); the pointer MEASURED
  (`test-cirl/`) including the brief's own convergence warning;
  exploration pricing surrogate-priced by the ladder and preposterior
  increments, exact pricing still open. The five honest sentences are
  §6 of this document.

**Status: —**

### T1 — the changing-world test

> - *The changing-world test.* Present a world whose statistics shift at an unknown time. The agent must re-disperse its posterior and become consultative **without** any change-detection code in the loop. Grep the source for the mechanism; there must be none. Adaptation must be visible in the posterior and invisible in the control flow.

- Python reference: test 1; Haskell parity: `test/Acceptance.hs`
  test 1 — confident in [30,60), consulting inside [60,80), recovered
  in [130,160); the MAP program is the exact change-point sentence,
  pinned with its posterior in `test/Anchors.hs` (quoted in §4).
- The grep is itself a frozen gate: `audit/forbidden.txt` bans
  `detect`, `window`, `reset`, `trigger`, ... as code tokens in
  `src/`, enforced by gate 4 on every run. Adaptation is visible in
  the posterior and absent from the control flow by construction.

**Status: —**

### T2 — the lazy-genius test

> - *The lazy-genius test.* Give the agent a hard problem and a short deadline. It must *choose* to think less and act sooner, and you must be unable to identify the line of code that made it do so. If you can point to the throttle, it is a shortcut; remove it and try again.

- Both sides: test 2 — thinking ticks 1/3/12/12 as the tick price
  falls through 0.3/0.05/0.005/0, pinned exactly in
  `test/Anchors.hs` (quoted in §4). The deliberation loop carries no
  cap and no threshold; the clock, and only the clock, terminates the
  regress — and `throttle`, `temper`, `anneal` are gate-4 forbidden
  tokens, so the line of code that made it lazy cannot exist in
  `src/`.
- The fidelity ladder closes the loophole a fixed myopic depth would
  have left: depth is a priced rung the same argmax buys (test F,
  `test-ladder/`), so thinking-about-thinking is bought, not
  configured.

**Status: —**

### T3 — the forgetting-factor trap

> - *The forgetting-factor trap.* Attempt, deliberately, to improve tracking of a drifting quantity by adding a forgetting factor. Confirm that the principled route — a latent drift-rate the update rule infers — matches or beats it, and delete the forgetting factor. This test exists to build the reflex that adaptation is content, not mechanism.

- Both sides: test 3 — the forgetting factor was built deliberately
  and QUARANTINED in the test file (`test/Acceptance.hs`, its only
  home); its log-losses are pinned across five gammas in
  `test/Anchors.hs` (first row quoted in §4); the latent drift-rate
  agent matches or beats it on the drifting world and beats it
  soundly on the stationary one.
- The deletion is enforced, not remembered: `forget`, `decay`,
  `sliding`, `window` are gate-4 forbidden tokens in `src/`.

**Status: —**

### T4 — the deletion audit

> - *The deletion audit.* For every terminal, execute its deletion proof: remove it and demonstrate the lost capability. Any terminal whose removal breaks nothing was content, and its continued presence is a standing bug against the prior.

- Python reference: the full deletion table, test 4, output frozen in
  `test_output.txt`.
- Haskell port: gate 7 requires each terminal's removal to be a
  code-level ablation, not a mock — the fourteen `DROP_` CPP flags
  and restricted enumerations across `src/`, `audit/ablation.sh` plus
  the per-increment runners, each row failing with attribution (the
  error names the deleted terminal) and `src/` compiling whole under
  every flag.

**Status: —**

<!-- S12-audit-end -->

## 6. The honesty section (five sentences)

*(Task 3.)*

## 7. The cut list (recorded debt)

*(Task 3.)*

## 8. The process record

*(Task 3.)*

## 9. The close

*(Task 3.)*

## 10. The closing reviewer block

*(Task 3.)*
