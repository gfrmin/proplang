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

The brief's one-sentence version asked for the smallest language in
which an agent can represent a changing world, reason about how much
to reason, and act — with adaptivity, bounded rationality, and
inductive bias arriving as *consequences* of the language rather than
modules bolted onto it. Its central thesis: adaptivity is not a thing
you build but a thing you make sayable, whereupon one learning rule
handles it for free; if you ever write a subroutine called `adapt`,
`forget`, or `detect_change`, you have misunderstood the task.

The answer, measured: the thesis held. The delivered language is four
nouns (Space, Prevision, Event, Kernel), three verbs (push, cond,
argmax), five structural terminals (`if`, `>`, `get`, priced
constants, named composition), and two emission combinators for the
demonstration domain — `design.md` §1 — and in it a world that shifts
at an unknown time makes the agent consultative with no detector in
the loop (test 1), a dearer clock makes it think less with no
throttle to point at (test 2), a deliberately-built forgetting factor
is matched or beaten by a latent drift-rate and deleted (test 3), and every
terminal survives an executed deletion proof (test 4). The port then
carried the same claim through a type system: the words the brief
forbids are not merely absent from `src/` — they are *unwritable*,
because a frozen gate greps for them on every run (§3). Where the
thesis needed growth — deliberation as data, the membrane, the
exponential-family basis, the preposterior, the priced utility — each
extension entered as a reported, priced alphabet change at an
author-signed freeze boundary, never as machinery (§2).

## 2. The language as built

Two fragments of one program space (`design.md` §2): the **model
fragment** — sentences about the world, enumerated and priced, whose
description length *is* the prior — and the **policy fragment** —
deliberation as syntax, priced but not enumerated. The port's policy
fragment, `typed-port-spec.md` §3, closes at ten EXPR alternatives
(`C`, `Get`, `If`, `Gt`, `Var`, `Push`, `CondE`, `Expect`, `Argmax`,
`Call`) plus declared hole sorts — FN's two inhabitants at 1 bit;
STATS, KER, and UTIL each a sole codeword at 0 bits — with the
standard-name production carrying the named compositions the brief's
§4 licenses the stdlib to have:

```
| STDNAME | EU, IsEq, VAct, VThink, Bern, VThinkK, VPre | log2 7 |
| UTIL | USay | 0 bits |
```

The table grew only at freeze boundaries, every change **reported and
priced**: the FN inhabitants (`FnInd`, `FnUtil`) at the
grammar-hygiene freeze, the `ExpFam` basis (with `bern` re-derived as
a stdlib name and `rw` recorded as the alphabet's one proven
non-expfam combinator), `VThinkK` at the ladder, `VPre` at the
preposterior, `USay` — the priced utility, the pointer's door — at
the CIRL freeze; the STDNAME row itself was repaired at the prepost
boundary under the frozen-text-states-no-falsehood standard, and the
production table joined the census for every future change. Nouns as decided:
Event and Kernel are peer primitives (recorded decision 1,
`design.md` §3); `Belief` is sealed — constructors never exported
(gate 2), so no consumer can do arithmetic on belief state, and the
brief's single-reasoner invariant holds by construction rather than
discipline. The membrane (`interface.md` §1–§3) narrows the boundary
to names: observations are named features, a program mentioning an
absent name evaluates against 0.0 and lies dormant until its sensor
appears — adaptivity to a growing world as a default value, exactly
as the brief's §9 required.

## 3. The enforcement architecture

The build's premise (`CLAUDE.md`): the type system is the adversary's
handcuffs, and the builder is treated as the adversary. Everything
that can be a compile fact is one; everything that cannot is a frozen
oracle the builder does not control.

- **Two phases, frozen oracle.** The acceptance tests were ported
  first, with worlds and observation streams reproduced from the
  Python bit-for-bit; the human signed `MANIFEST.sha256` over
  `test/`, `audit/`, and the protocol itself before any
  implementation existed. From that signature, any diff under a
  frozen path — even whitespace, even to fix a wrong test — is a
  protocol violation; a wrong frozen test is a stop-and-report.
- **Seven gates, no partial credit:** `-Wall -Werror` clean; the
  export-list check (`Belief(..)` never leaves); no `IO` outside
  `Host.hs`; the forbidden-token grep (`audit/forbidden.txt` — the
  unsafe escapes plus the semantic list: detect, forget, window,
  decay, sliding, reset, trigger, temper, anneal, throttle); the full
  test battery; the manifest; and the deletion audit as code-level
  ablation.
- **The increment protocol.** Post-parity growth is one oracle
  directory per increment, oracle-first and runtime-red under the
  stanza's exact flags, an author freeze extending the manifest, then
  implementation to green with an as-built report. The builder never
  owns a live oracle at the moment it becomes binding.
- **Custody.** Two keys, two truthful attestations: the builder key
  signs every builder commit; the author's approval is a signed tag
  from their own shell (or a fresh, explicit, per-instance delegation
  recorded verbatim in the tag). The manifest's history is the
  custody chain, every signature verifiable in place.
- **Case law.** The brief's §10 asked that grey-zone judgements be
  precedent with stable identifiers; each increment's rulings
  register (stable identifiers, ruled at Task 0), the boundary queue,
  and the freeze packs are that registry — and each incident that
  exposed a gap became protocol text at the next boundary (§8).

## 4. The measured record

The four §12 tests, pinned. The frozen anchors (`test/Anchors.hs`,
re-derived from the Python streams at Phase 1 and untouched since):

```haskell
-- test 1: the MAP program after the shift IS the change-point sentence
t1MapProgram = "('bern', ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)))"
t1MapPosterior = 0.6383157408996493

-- test 2: (price of a tick, thinking ticks, final act) — exact
t2Rows = [ (0.3, 1, "L")
         , (0.05, 3, "L")
         , (0.005, 12, "L")
         , (0.0, 12, "L") ]

-- test 3: (gamma, drift-world log-loss, stationary log-loss) for the
-- quarantined forgetter; first row
  (0.8, 369.7929712967316, 396.60210068705993)
```

Test 1: confident action in [30,60), consultation inside [60,80) after
the unannounced shift at t=60, recovery by [130,160) — and the
posterior's own MAP sentence names the change-point. Test 2: thinking
ticks fall 12 → 3 → 1 as the clock dearens, the loop carrying no cap
and no threshold. Test 3: the latent drift-rate agent —
owning no forgetting machinery — matches or beats the best
oracle-tuned forgetter on the drifting world (within the test's 2%
band) and every forgetter on the stationary one, and its MAP program
on the drifting world names the drift rate: inferred, as content.
Test 4: the deletion table, executed.

Above parity, each increment closed with its own measured
demonstration, frozen in its suite and recorded in its report:
the membrane's tests A–C and the slot row (`test-membrane/`,
MEMBRANE_REPORT.md); the ladder's test F — depth is a rung the argmax
buys, a near-zero-price world sometimes buys depth and beats fixed
myopia, and test 2's counts reproduce as *chosen* behavior
(`test-ladder/`, LADDER_REPORT.md); the preposterior's paired worlds —
information-gathering beats the myopically-better action exactly when
the action-dependent VoI says so, and correctly does not in the
control (`test-prepost/`, PREPOSTERIOR_REPORT.md); and the pointer's
sweep (`test-cirl/`, CIRL_REPORT.md) — asking dies at k=1, listening
survives to k=3 and dies at k=4, the value of deference decaying
0.233 → 0.122 → 0.029 → 0.008 → ≤1e-12 (the decimals are the report's
measured record; the frozen pins are the behavioral deaths, the
strict decrease, and the 1e-12 tail), the control charging deference
exactly its sacrifice at every stage. Through all six increments the
Phase-1 margin readout stayed digit-for-digit identical across seven
runs — the deepest frozen anchors never moved by an ulp. The battery
stands at 127 frozen tests across the eight suites, re-run whole by
gate 5 on every verification.

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

**Status: DONE**

### D2 — the complexity measure, fineness charged once

> - The **complexity measure**: the per-terminal bit-cost and the resulting `2^{-|program|}`, with the fineness accounting of §5 shown to charge once and only once.

- Python reference: `design.md` §5 states which charging route the
  implementation is on and why it is sound.
- Haskell port: `bits` in `src/PropLang/Syntax.hs` is the total
  pricing function — grids are priced data, `log2 n` for an n-point
  grid, and no other numeric literal in `src/` steers deliberation
  (a frozen protocol clause); `test/Properties.hs` pins "fineness charged
  once: predictive mass invariant under grid refinement"; the hygiene
  suite (`test-hygiene/`) froze the policy-fragment prices.

**Status: DONE**

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

**Status: DONE**

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

**Status: DONE**

### D5 — the reference implementation

> - A **reference implementation** adequate to run the tests below.

- Python reference: `proplang.py` + `tests_acceptance.py`, all four
  tests passing, output frozen in `test_output.txt`.
- Haskell port: `src/` under gates 1–7 (`audit/run-gates.sh`); 127
  frozen tests across the eight suites of `proplang.cabal`; parity
  anchors re-derived from the Python observation streams
  bit-for-bit (`test/Anchors.hs`).

**Status: DONE**

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

**Status: DONE**

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

**Status: DONE**

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

**Status: DONE**

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

**Status: DONE**

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

**Status: DONE**

<!-- S12-audit-end -->

## 6. The honesty section (five sentences)

What cannot be learned and what remains open, stated the way the
brief's §11 demanded — physics rather than tuning, named rather than
hidden. Three residues, printed at their proven minima, and two more
sentences the build itself discovered.

1. **The alphabet.** The encoding the prior is relative to is chosen,
   and the invariance constant between two reasonable alphabets is
   real and unpriced. The residue is now sharper than the brief left
   it — the exponential-family basis plus `rw`, the one member
   *proven* non-expfam, plus the namespace law making growth
   incremental — but sharper is not zero, and it never will be.
2. **The clock.** Bit-costs, opportunity prices, and the executor's
   tick are physical inputs; the metareasoning regress terminates in
   them, not in a threshold. The fidelity ladder prices every rung of
   deliberation above the induction base — but the base itself
   (unexamined estimates are used as-is) survives, and the language
   still cannot say its own executor.
3. **The pointer.** Whose utility cannot be inferred from its own
   signal. The committed design was measured to its edge: deference
   while uncertain is a theorem the agent enacts, and its vanishing
   at convergence is now a number, not a warning — the agent stops
   asking (k=1) before it stops listening (k=4), and a
   confidently-wrong agent acts confidently and wrongly. Revealed
   versus idealised preference stays open, exactly as the brief
   flagged it.
4. **The arithmetic-free boundary.** The policy fragment has no
   arithmetic — a discovered expressiveness boundary of the language,
   found at the CIRL kickoff: sayable utilities are comparison-gated
   step tables over grid constants, and linear forms like 2u−1 are
   unsayable. Both faces, as ruled: it is recorded debt — arithmetic
   nodes are a future reported alphabet change, priced like
   everything else — and it was an accidental virtue, the step form
   holding the control identity at 1.1e-16 where the linear form
   carried one-ulp cancellation dust. A limitation found by
   measurement and recorded rather than patched is what the residue
   discipline was for.
5. **The frontier.** The hypothesis space is enumerated to a fixed
   depth; the generator that should move that frontier under
   posterior pressure — the brief's §6, the belief-aware purchase of
   new hypotheses — is the project's declared boundary, named open
   research rather than an increment (cut item 5). Every result above
   holds *within* that frontier, and the reader cannot weigh the
   results without this sentence.

## 7. The cut list (recorded debt)

Declared at the roadmap, priced, not silently regrowable — ROADMAP.md's
five items verbatim, each with the record that files its debt:

- **Conjugate fast path**: semantic license frozen as oracle (CL-4 +
  sufficiency); build only if something is actually slow. Test D is
  thereby discharged in its load-bearing form — a STANDING TRIPWIRE
  that binds automatically the day any fast path lands, not a vacuous
  green. *Filed:* `test/Properties.hs` (CL-4 stated extensionally).
- **Continuous carriers and the gauss pair**: no remaining claim needs
  them; the continuous debt stays where the Event/Kernel peer decision
  filed it. *Filed:* `design.md` §3, recorded decision 1.
- **Latent names in parameter expressions**: served only expfam
  transitions; rw is proven non-expfam and stays primitive; CIRL uses
  the discrete reading (above). *Filed:* `typed-port-spec.md` §4 (the
  T1 impossibility record); `interface.md` §4.
- **Second domain / invariance-constant measurement**: appendix
  science. *Filed:* the alphabet sentence, §6.1.
- **Generator-as-a-program (the moving Cromwell frontier)**: the
  project's declared boundary — named open research, not an
  increment. *Filed:* the frontier sentence, §6.5; `design.md` §7.

## 8. The process record

The brief's §10 asked for case law: exceptions as named precedents,
amendments made in the same change that relies on them. The build ran
that way, and its incidents are the registry — each one became
protocol text at the next freeze boundary, so the protocol the
project ends with is the one its own failures wrote:

- **The ExpFam re-open**: an oracle froze compile-red because its red
  run used weaker flags than its own stanza. Became protocol text — a
  red run proves nothing unless bit-faithful to the future gate
  conditions.
- **The membrane pre-tag re-open**: a pinned literal derived from a
  parallel simulation instead of the frozen artifact. Became protocol
  text — pins derive from the frozen artifact itself; simulations
  establish discriminating power, never values.
- **The ladder's Argmax-environment bug**: caught before freeze by
  proving a compile-red fixture type-correct against the drafted
  surface. Became protocol text — a fixture's red must be
  demonstrated to be the missing constructor, not assumed.
- **The locale incident**: a test name that changed bytes under the
  environment's locale. Became protocol text — increment-oracle test
  names are ASCII-only.
- **Custody**: the in-person signing rule was beaten twice by
  convenience, and rather than re-issue it the scheme was changed to
  match reality — two keys, two truthful attestations, the tag the
  rare and meaningful act. Every attestation scheme the project tried
  is represented in its history, and the history is part of the
  record.
- **The empty census**: the CIRL freeze amended no frozen assertion
  literal — the first alphabet-adjacent increment to move nothing —
  and the emptiness was recorded *with evidence under three
  instruments*, because an unverified "nothing moved" is exactly the
  kind of green the protocol distrusts.
- **The §10 erratum**: the closing block's own run exposed the block's
  four-tag expectation as false — membrane-freeze carries the builder
  key under its recorded delegation, not the author's key — and its
  gate line as not runnable verbatim. Repaired at the re-made
  writeup-freeze. The one sentence of the block drafted from memory
  instead of derived from the frozen artifacts was the one that went
  wrong: the pin-provenance rule, confirmed on prose.
- **The post-close review**: an adversarial sweep of src/, the eight
  suites, and the audit scripts, run after the close. No smuggled
  content in src/ — no seeds, no test-aware branches, no steering
  constants; every literal traced to declared data or the production
  table. Two paths of the one deliberation arithmetic have no frozen
  row that can falsify them: the interior-menu max (every vPre call
  site in the repository passes a singleton interior menu) and the
  action-dependent recursion above depth 1. The identity pins that
  once covered such paths (Prepost g1, Ladder g1, Membrane's
  registry and generator rows, the sayable fixtures' bridge checks)
  became definitional the moment the rulings' required
  identity-as-definition landed; the correctness burden migrated to
  the literal anchors, which hold. The audit scripts' textual checks
  (gate 1's flag grep, the ablation runners' attribution greps)
  discriminate only under the pinned toolchain and manifest-frozen
  cabal file — contained, and named here. Recorded, not patched:
  the residue discipline applied to the oracle itself. Any future
  increment under P5's route opens its oracle with these as its
  first fixtures.

## 9. The close

The brief's §13 named the target: not a clever agent, but a cornered
one — a language reduced until what remains cannot be made smaller,
whose capabilities cannot be pointed at because none of them were
put anywhere. The measured record is that target, hit: the agent
becomes consultative when the world shifts because the posterior
disperses; it thinks less when the clock dearens because argmax says
so; it defers exactly while it is uncertain, stops asking before it
stops listening, and its corrigibility fades as its posterior
concentrates — the predicted negative result delivered as a
measurement. There is no line of code to point to, and that absence
is not an accident of style: the pointable lines are forbidden tokens
under a frozen gate, so the claim "nothing made it adapt" is checked
by machine on every run, in a repository where the tests were frozen
before the implementation existed and every relaxation of that
discipline is a signed, public act.

The roadmap terminates here. Any further scope binds P5's single-site
alphabet-constant clause and requires a new roadmap boundary, by the
author, at a freeze — the lawful re-opening route, kept narrow on
purpose.

## 10. The closing reviewer block

Run by the human, from the repo root, after the `writeup-freeze` tag
is made; closes the write-up boundary and with it the project.

```
export PATH="$HOME/.ghcup/bin:$PATH"
sha256sum -c MANIFEST.sha256                # expect: 68/68 OK
env -i PATH="$PATH" HOME="$HOME" LC_ALL=C.UTF-8 sh audit/run-gates.sh --phase 2
                                            # expect: gates 1-7 PASS, exit 0
git log --format='%G? %GF %h %s' -- MANIFEST.sha256
                                            # expect: 13 commits, all G —
                                            # 7 author-key, 6 builder-key
sh test-writeup/check.sh --close            # expect: every check PASS,
                                            # quote fidelity included
git tag -v membrane-freeze ladder-freeze prepost-freeze cirl-freeze
                                            # expect: good signatures —
                                            # membrane's and ladder's carry
                                            # their recorded delegations,
                                            # the others the author's key
git tag -v brief-freeze                     # expect: good author-key
                                            # signature — the brief entered
                                            # by the hand that wrote it
git tag -v writeup-freeze                   # expect: good author-key
                                            # signature — the last thing
                                            # the protocol asks of anyone
```
