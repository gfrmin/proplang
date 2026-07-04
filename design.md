# proplang (Proposition Language): a minimal language in which a Bayesian agent is a program

Design document. Companion files: `proplang.py` (reference implementation),
`tests_acceptance.py` (the four acceptance tests; all pass). All measured
numbers quoted below are reproduced by `python3 tests_acceptance.py`.

---

## 1. What was derived, not assumed

The brief's central claim is that an adaptive Bayesian decision-theoretic
agent needs no adaptation machinery: if hypotheses are programs and the prior
is `2^(-|program|)` under a grammar, then adaptation, laziness, and
consultativeness are posterior dynamics, not control flow. The deliverable is
therefore an *alphabet* — because the alphabet **is** the prior — plus the
minimum verb set that closes the loop from belief to action and back through
the agent's own computations.

The result: **four nouns** (Space, Prevision, Event, Kernel), **three verbs**
(push, cond, argmax), **five structural terminals** (`if`, `>`, `get`, priced
constants `c`, and named composition `call`), and **two emission combinators**
for the demonstration domain (`bern`, `rw`). Every terminal survives an
executed deletion audit (§8, test 4). Nothing else survived review.

---

## 2. The grammar

Programs are S-expressions. There are two fragments of one program space: the
**model fragment** (sentences about the world, enumerated and priced) and the
**policy fragment** (sentences about what to do, including about the agent's
own inference). They share all structural terminals; the policy fragment
additionally utters the verbs.

```
-- model fragment (enumerated; each sentence is a hypothesis) --
MODEL ::= ('bern', PARAM)              emission with a sayable parameter
        | ('hmm',  CONST_rho)          latent walk (rw) at a sayable rate
PARAM ::= CONST_theta
        | ('if', TEST, PARAM, PARAM)
TEST  ::= ('>', ATOM, ATOM)
ATOM  ::= ('get', NAME) | CONST_tau
CONST ::= ('c', grid, k)               k-th point of a priced grid

-- policy fragment (adds the verbs as terminals) --
EXPR  ::= ('argmax', OPTIONS, VALUE)   choice by expected utility
        | ('push', BELIEF, KERNEL)     pushforward
        | ('expect', BELIEF, FN)       push-to-R
        | ('cond', BELIEF, EVIDENCE)   Bayesian update
        | ('call', name, EXPR...)      stdlib named composition
        | ('if'|'>'|'get'|'c' forms)   as above
```

Per-terminal deletion proofs (one line each; the executed versions with
measured losses are in §8):

| terminal | what dies with it |
|---|---|
| `push` | prediction, expectation, expected utility, and marginal likelihood are all push; without it belief cannot touch the world or a value |
| `cond` | belief never moves; the agent is a prior forever (measured: 160 vs 97 bits of log-loss on the shifted world) |
| `argmax` | belief still moves but nothing can choose; there is no exit from probability into action |
| `if` | conditional structure is unsayable; no change-point sentence exists (103 vs 97 bits) |
| `>` | `if` has no test; equivalent to deleting `if` |
| `get` | programs cannot read the world; the loop opens, closed-loop policies and time-indexed hypotheses vanish (103 vs 97 bits) |
| `c` (grids) | no sayable constants; the model fragment enumerates zero programs |
| `call` | compositions cannot be named; sugar only — its deletion costs brevity, not capability, and it is therefore the one terminal that is *stdlib boundary*, not language (kept because names are how case law accrues) |
| `bern` | no emission vocabulary; zero programs can assign likelihood to data |
| `rw` | drift is unsayable; on the drifting world, log-loss 211 vs 207 bits |

`call` deserves the honesty flag: it is the only terminal whose deletion
proof fails the strict test. It is retained as the *stdlib boundary marker*
— the language's answer to "VoI" and "ask the user" being names, not verbs.
A stricter minimalist deletes it and inlines every composition; we record the
choice and its cost (readability of precedent) rather than hide it.

---

## 3. The nouns, and the Event/Kernel decision (recorded decision 1)

`Space` is a set of possibilities. `Belief` is a **prevision** — expectation
is primitive, probability is derived as the prevision of an indicator
(`prob(E) = expect(1_E)`), following de Finetti and Whittle. The reference
implementation makes this literal: `prob` is a one-line call to `expect`.

**Decision: Event and Kernel are peers of Space and Prevision (the
four-type arrangement), not derived sugar.**

Argument. Both reductions are available in the finite case: an Event is the
two-point Kernel of its indicator; a Kernel is a parameterized family of
conditionings. But each reduction leans on machinery the language does not
otherwise need — the first makes `cond`'s simplest use route through a
detour object; the second requires disintegration, which is not defined for
arbitrary carriers, and a language spec that relies on an undefined reduction
in the general case is borrowing against theorems it has not proved. The
reference implementation is finite precisely so that no such debt is hidden
in code; the *language* decision must hold when carriers grow.

Acknowledged cost. Two extra type-terminals in the alphabet, hence a
constant number of extra bits charged against every program that mentions
them, and two type constructors to maintain. The type system also gains: the
invariant that evidence declares its algebra (§9, I2) is only expressible
because evidence has a type — an `Event` or a `(Kernel, observation)` pair,
never a closure.

---

## 4. The verbs, and where argmax fires (recorded decision 2)

Exactly three verbs. `push` moves belief forward along a Kernel (prediction)
or along a function to the reals (expectation — and the marginal likelihood
is push too, exposed as `logpredict` so no consumer ever needs weights).
`cond` moves belief backward through evidence; it is the unique diachronically
coherent update, so there is one update rule in the entire system, at both
levels — the same `cond` filters a drift hypothesis's latent state and
reweighs the hypothesis space above it. `argmax` exits belief into choice.

Candidate fourth verbs, adjudicated as the brief requires:
**value-of-information** = push of the utility of the post-conditioning
argmax, minus push of the utility of the immediate argmax — a composition
(implemented as one in test 2, expansion in §7). **"Ask the user"** = an
ordinary action whose payoff routes through the world; the changing-world
agent consults without any consult machinery (test 1). **Sampling** is not
a verb at all (§9). The stdlib may *name* these (`call`); the language does
not know them.

**Decision: `argmax` is sayable in the grammar; it fires at the host
boundary.**

Argument. Sayability is non-negotiable — it is the difference between agent
and calculator (the brief's reflexive-closure requirement), and test 2's
policy program literally contains `('argmax', ...)` over an option whose
value expression contains `cond`. But *firing* — the irreversible
transaction with the world — is effectful, and the language is pure: the
evaluator returns the chosen option; the host performs it. This keeps every
program a total function from features to (belief, choice) and confines
irreversibility to one audited surface.

Acknowledged cost. A host loop (the polling executor, §5) that the language
cannot see and therefore cannot optimize over; the boundary between "choose"
and "do" is machinery, and it is machinery we accept as part of the clock
residue (§10). Staleness risk — a fired action reflecting a belief that new
evidence has outdated — is mitigated by polling execution, not eliminated.

---

## 5. The complexity measure: fineness charged once

The description length of a program is the sum, over the derivation's choice
points, of `log2(alternatives)` at that point; a constant drawn from an
n-point grid costs `log2(n)`. The prior over the enumerated model fragment is
`2^(-|program|)`, normalized — constructed in exactly one place
(`Belief.from_bits`), which is the only prior-source in the system.

Worked costs under the current grids (theta: 9 points, tau: 16, rho: 8):
a constant-world sentence `bern(theta)` costs 1 + 1 + 3.17 = **5.17 bits**;
a drift sentence `hmm(rho)` costs 1 + 3 = **4 bits** (the RATE slot is a
bare constant, not a PARAM choice point, so no alternative bit is charged
there); a change-point
sentence costs 1 + 1 + (1+0) + (1+4) + 2·(1+3.17) = **16.3 bits**. These
prices are visible in the data: on the shifted world the change-point family
must out-predict the drift family by ~12 bits of evidence before it takes
the posterior — and by t=160 it has (posterior 0.64 on the exact sentence
`if t > 60 then 0.1 else 0.9`).

Fineness is charged **exactly once**, and by the prior route: a finer theta
grid raises `log2(n)` per constant, and that is the entire charge. There is
no separate fineness-penalty axis, and the marginal likelihood route is not
double-dipping: the ensemble's `logpredict` compares *hypotheses*, and
refining a grid redistributes nearly the same predictive mass over more,
individually costlier sentences. The two routes coincide only at the
marginal likelihood, which is the quantity the agent actually maximizes
through `cond`. Point-parameterized hypotheses do mean each single sentence
is a point estimate; the *agent* is the mixture, so its predictive is a
genuine marginal and Bayesian Occam operates at the ensemble level.

The feature namespace is priced the same way: `('get', NAME)` costs
`log2(|FEATURE_NAMES|)`. With one name the charge is 0 bits; every name the
growing world adds raises the price of mentioning any name. Absent features
evaluate to 0.0, so a sentence about a sensor that does not exist yet is
sayable today, dormant, and priced.

---

## 6. Operational semantics: programs as options under polling execution

A program never runs open-loop. The executor is:

```
loop (one world tick):
    features <- world's named observation Dict     (absent names read 0.0)
    choice   <- evalx(program, env[features])       pure: no effects inside
    fire choice at the host boundary; observe outcome y
    belief   <- belief.cond(evidence(y))            the polling re-entry
```

Formally, `evalx` is a big-step evaluator over S-expressions whose
environment carries features, belief handles, and the stdlib; the verbs are
its terminals. A program is thus a *closed-loop option* in the
Sutton–Precup–Singh sense: a policy re-evaluated against the current belief
every tick, with termination itself decided by `argmax` (test 2's option
terminates when acting beats thinking). "Do X for six ticks" is only sayable
as a policy that keeps choosing X while the belief keeps recommending it.

**The self-referential fragment**, worked example (test 2's policy, verbatim
from the test file):

```
('argmax', 'METAACTS',
  ('if', ('call', 'is_act', 'option'),
         ('call', 'v_act',   'B'),
         ('call', 'v_think', 'B', ('get', 'price'))))
```

where `v_think` expands, through the stdlib boundary, into pure verb
composition: for each outcome of the next evidence batch, `cond` a copy of
the belief, push the acting value to R, average under the predictive
(`logpredict`, itself push-to-R), then subtract the world's price of the
tick. The sentence "condition again, then decide" is a term, and `argmax`
ranges over it. That is the reflexive closure: deliberation is an option in
the same action space as acting, valued by the same push, chosen by the same
argmax.

---

## 7. The two moves of the generator, one currency, two fidelities

The hypothesis generator has exactly two moves, both priced in Δ
log-evidence. **Compression** acts through the prior: a shorter sentence
with the same likelihood gains posterior; on the shifted world this is
visible as the drift sentence (4 bits) holding the posterior against
change-point sentences (16.3 bits) until the evidence gap exceeds the
prior gap. **Exploration** acts through the likelihood: an action is worth
taking partly for the evidence it buys. The reference implementation prices
exploration by the myopic preposterior surrogate (Russell–Wefald: expected
best-value-after-conditioning minus cost) — declared here as the **cheap
fidelity**; exact expected Δ log-evidence over policies is the expensive
fidelity, and pricing it exactly is one of the named open problems (§10).
Test 2 exhibits the surrogate's known bias honestly: with a linear utility,
myopic VoI is zero whenever no next-batch outcome can flip the decision, so
the agent can stop before the buffer is dry even at price 0; deeper
lookahead would sometimes disagree. The surrogate is a recorded
simplification, not a hidden one.

Enumeration is depth-1 in `if` (one change-point per sentence, vacuous
equal-branch change-points excluded; 1169
hypotheses under current grids). This truncation is the reference
implementation's **Cromwell frontier**: the sentences beyond it currently
receive probability zero, which is a vice the brief names rather than a
feature. The frontier is a parameter of the implementation, not of the
language; moving it is the generator's job in a fuller system.

---

## 8. Adaptation dissolved: the measured results

**Changing world** (θ = 0.9 until t=60, then 0.1). The agent is confident
(`predict1`) through [30,60); after the shift its predictive collapses
toward 0.5, meta-entropy re-disperses from 3.15 (t=59) to a peak of 3.95 bits, and `consult`
— an ordinary action, utility 0.35 supplied by the world — becomes argmax
for several ticks; by t=76 it is confidently `predict0`, and the MAP program
is the exact change-point sentence with τ=60 at posterior 0.64. The test
then greps the language module's code (comments and strings excluded) for
{detect, forget, window, decay, sliding, reset, trigger, temper, anneal,
throttle}: clean. The consultative turn is Bayes through an honest utility;
no humility subsystem exists.

**Lazy genius** (θ_true = 0.52, 36-observation buffer, batches of 3). Same
agent, same code; only the world's per-tick opportunity price differs:
price 0.3 → 1 thinking tick; 0.05 → 3; 0.005 → 12; 0 → 12 (information runs
dry before the clock bites). The loop is `while argmax([act, think]) ==
think`; there is no iteration cap and no threshold constant — the regress
terminates in the clock, and only in the clock.

**Forgetting-factor trap.** A Beta tracker with forgetting factor γ was
deliberately built — quarantined in the test file. On a drifting world the
agent (which contains no forgetting anything) scores 339.8 bits against the
*oracle-tuned* best forgetter's 340.9; on a stationary world, 351.1 against
the best forgetter's 350.3 (γ=1.0, i.e. the forgetter wins only by not
forgetting), inside a 2% margin both ways, with every γ<1 strictly worse.
The agent's MAP program on the drifting world is `hmm(rho=0.1)`: the drift
rate was *inferred, as content*. The forgetting factor is then deleted; the
language module never contained it.

**Deletion audit.** Executed for every terminal; table in §2 with measured
losses. Two terminals' proofs are constructive-degenerate rather than
comparative — `push` and `argmax` deletions make the system unutterable
rather than worse, demonstrated by the evaluator raising on their use — and
`call` is recorded as sugar (§2).

---

## 9. Invariants and case law

**I1 — single reasoner.** `Belief` is an opaque handle; log-weights are
private, and every consumer routes through `expect / prob / push / cond /
logpredict`. No second reasoner can exist because no one else can do
arithmetic on belief state. **I2 — declared structure.** Evidence is an
`Event` or a `(Kernel, obs)` pair; the engine never receives a closure it
cannot analyze. **I3 — single responsibility.** Programs are syntax; `evalx`
is semantics; weights are private state behind accessors.

Purity: `draw` exists only at the host boundary, is not in the evaluator's
vocabulary, and is used only to simulate worlds in tests. Mixed strategies,
when needed, are argmax over the policy space (a policy that randomizes is a
sentence; a language that randomizes is a leak).

Case-law registry (precedents accrued during this build):
**CL-1** `entropy_bits` / `top` are read-only diagnostics for display; the
day a diagnostic feeds action selection it must be re-derived through the
verbs or die. **CL-2** randomness enters only through host-side `draw`,
after the language has finished constructing the belief. **CL-3** `argmax`
tie-breaks deterministically by option order; preferring randomization there
would smuggle a coin into the language (see purity above).

---

## 10. Residues and open problems

Three residues remain, named as the brief requires, plus the recorded
simplifications of this reference implementation.

**The alphabet.** `bern` and `rw` are choices; a different domain needs
different emission combinators, and the invariance constant between two
reasonable alphabets is real and unpriced. The defense is not that the
alphabet is canonical but that it is *small, printed in §2, and every entry
carries an executed deletion proof*.

**The clock.** Bit-costs, the world's opportunity price, and the polling
executor's tick are physical inputs. The metareasoning regress terminates
here by design — test 2 is the demonstration — but the language cannot say
its own executor, and that boundary is machinery.

**The pointer.** Whose utility? The tests supply utilities from the world
(the consult payoff, the ±(2θ−1) stakes); this is the shallow end of the
problem. The committed design is utility-as-latent (CIRL): the agent holds a
belief over the utility parameter and human acts are evidence through
`cond`, making deference-while-uncertain a theorem (the off-switch result)
rather than a constraint. This is scoped to design here, not implemented —
recorded, with its consequence: **corrigibility earned this way vanishes at
convergence**, since a posterior over utility that has concentrated no
longer pays for deference. Open.

**Open problems**, named: (1) exact exploration pricing — replacing the
myopic Russell–Wefald surrogate (§7) with expected Δ log-evidence over
policies, at a computable fidelity; (2) corrigibility at convergence, above;
(3) revealed versus idealized preference — `cond` on human acts learns what
the human *does*, and the gap to what they would endorse is not a modeling
error the update rule can fix; (4) reflective closure against equal-power
peers — the grammar can say another agent's argmax, but a hypothesis space
containing hypotheses about a reasoner of equal power reintroduces
self-reference at the space level, and depth-limited enumeration (our
Cromwell frontier) is a truncation of that problem, not a solution.

**Recorded reference-implementation simplifications:** finite spaces and
grids throughout (so the Event/Kernel peer decision is defended at the
language level, §3, not exercised in the continuous case); prior
truncated-and-normalized at the enumeration frontier; drift hypotheses
initialize their latent uniformly rather than paying grid bits for an
initial condition; utilities world-supplied in all tests (pointer residue
above); value of computation myopic (§7).
