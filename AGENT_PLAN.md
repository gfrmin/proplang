# AGENT_PLAN — the re-derivation boundary

**Status: DRAFT by the builder. Binding only on the author's signed tag.**
Nothing under `test/`, `audit/`, `CLAUDE.md`, `MANIFEST.sha256`, `membrane-wire.md`,
`HOSTS_PLAN.md`, `interface.md`, `typed-port-spec.md`, or any `test-*/` moves until that
tag exists. Repo clean, manifest 81/81, as of this draft.

**Everything below is quoted from the author, copied from the repository, or executed and
measured. Nothing is asserted.** Where the builder was wrong, the reversal is marked and the
old claim is left visible.

**The author must rule on three things before signing:**

| | | |
|---|---|---|
| **§1b** | **THE OPTIMISATION LAW** — new ruling, 2026-07-12. The repo already calls it *"the doctrine"* in three places and never made it a law. It convicts `Bern`. | ruling |
| **§2a** | **The likelihood is a CODE.** `T1` dissolves; `ExpFam`/`Stats`/`Carrier`/`Bern`/`rw` are shapes, not primitives. **Sufficiency dies as a guarantee** — the one real casualty. | ruling |
| **§2b** | **STOP AND REPORT: a frozen test is wrong.** CL-4's `1e-9` is 360,000× wider than the machine's noise floor, on the very property that enforces §1b. **Phase-1 re-open.** | re-open |

---

## 0. The verdict

`brief.md` §2 predicted this failure in the author's own words:

> "There is a language for Bayesian decision theory, and there is a language for a
> Bayesian decision-theoretic *agent*, and the gap between them is the entire difficulty.
> **Get this distinction wrong and you will build the first while believing you have built
> the second.** A language for decision theory is a **calculator**."

That is what was built. **The design was right; the implementation lost the ontology.**

### The chain, each link with provenance

| # | fact | where |
|---|---|---|
| 1 | Savage's **theorem** `R(a,s) = u(a(s))` installed as the **definition** of EU | `tests_acceptance.py:51-56`, seed commit `c245c00` |
| 2 | ⇒ utility indexed by ACT ⇒ `Choice` is its domain ⇒ **totality demands a number for `think`** | `Syntax.hs:317`; `HOSTS_PLAN.md:355` *"so the table must cover it"* |
| 3 | ⇒ a number was invented. **`H` is defined nowhere in this repository.** | `membrane-wire.md:131`; `:56` *"give it a dominated sentinel row"* |
| 4 | ⇒ its float residue became the decision signal — VOI computed **negative**; Jensen violated in the machine | measured, 2026-07-11 |
| 5 | **The action space is priced at ZERO.** `Membrane.hs` never imports `bits`; **no `Choice`/`Affordance`/`Slot`/`AffId` value has a description length anywhere.** The policy costs the same for 1 affordance or 10,000. | whole-repo sweep, 2026-07-12 |
| 6 | ⇒ head-on violation of brief §5 — *"**The alphabet of the language IS the prior.**"* **There is no Kraft budget over actions at all.** | brief §5 |
| 7 | **Ruling M5** — forbidding the two priced surfaces from EVER unifying — is **asserted four times and derived zero times.** *"Stops a fourth flow entering through the pricing door"* is never unpacked. | `MEMBRANE_PLAN.md:34-38`, `typed-port-spec.md:196-202`, ×2 more |
| 8 | VOI became **three priced primitives** — the brief's own named example of the forbidden move — at **+0.4854 bits on every stdlib call** | `VThink`/`VThinkK`/`VPre` |
| 9 | …and on the production wire **they are never called**. `think` is decided by the constant. | `BRIEF_AUDIT.md:159-163` *"reached by test harnesses only"* |

**The silence.** Across 86 commits, ~40 documents, two signed external reviews, a
brief-conformance audit that stamped the sentinel **CONFORMANT**, and a cross-audit citing
Savage three times — **no one, on any date, asked what utility is a function of.** The
apparatus was pointed at everything downstream of `data Util a y`. Never at that line: it
arrived on day zero as a *port*, and the increment protocol only scrutinises *changes*.

---

## 1. The author's axioms (2026-07-12)

- **A1** — an action's value is `E[ΔU]`: the change in the utility of the world state.
  One term. *"Affordances don't have utilities; world states do."*
  **⚠️ SCOPED BY RIDER 1**: as built, `E[ΔU]` is **one tick's Δ**. A consequence landing at
  `t+5` is **visible to learning and invisible to choice.** See §9 OPEN 8.
- **A2** — the consequence of an action can never be **known**, only **believed**. The
  transition model is a **hypothesis**: priced, updated by `cond`, learned.
- **A3** — *"all we get are observations/features anyway."* The world's state `s` is **not
  in the agent's ontology**; `PureWorld s` is simulator scaffolding.
- **A4** — *"the actions taken are just more features (although unlike most features
  they're known because you took them)."*
- **A5** — **AMENDED BY RIDER 4 (2026-07-12), to its structural form.** As first worded —
  *"doing nothing must ALWAYS be available"* — **it overclaimed, and §5c does not deliver it.**
  What §5c delivers, and all it delivers, is:
  > **Some act is ALWAYS structurally available, with no sentinel and no world handshake** —
  > so **`argmax` is total** and the metareasoning regress terminates in **the clock, not a
  > threshold**. *That* is the load-bearing property, and it holds.
  **What is NOT delivered: that the always-available act means *nothing happens*.** A world
  declaring `fire :| [stand_down]` makes the first grid point a **launch**. **Inaction semantics
  is delegated to world authors** — lawful (world content is physics; cf.
  [[deletion-test-core-vs-world]]) but **a convention relocated across the membrane, not
  abolished.** Named in §9 OPEN 11, not quietly narrowed.
- **A6** — *"we can never know an action CAUSED something; that's also a hypothesis."*
  **⚠️ RIDER 3 SCOPES ITS CONSEQUENCE**: A6 stands as an **epistemic** axiom. The inference the
  builder drew from it — *"therefore no `do()`, and push-at-assignment is the right scoring
  rule"* — is a **decision-theoretic** claim A6 does not license. **Downgraded RULED → OPEN**;
  see §3 and §9 OPEN 9.
- **A7** — **heuristics may be optimal actions** under Bayesian decision theory, once
  computation is priced.

A2 is what makes metareasoning automatic — and it is precisely what `interface.md`'s
load-bearing clause forbade. Both A1 and A2 are already in brief §7, in symbols:
`E[Δvalue | action] − cost(action)`. The port **flattened** that into one table
`u(action, state)`, and once fused, `think` needs a fabricated payoff. That is the defect.

---

## 1b. THE OPTIMISATION LAW (author, 2026-07-12)

> *"Optimisations can exploit structure but never live in the prior."*

**The repository already calls this "the doctrine" — in three places — and never made it a law.**

| # | where | words |
|---|---|---|
| 1 | `test-expfam/ExpFam.hs:206-209` | *"expansion agreement — **CL-4 for the basis** (plan E7): the **executed fast form is legal iff extensionally equal to the generic family** … **enforced here, not trusted**"* |
| 2 | `Syntax.hs:304-306` | *"Executed semantics is the recorded **fast form**; the expfam expansion is the **property-enforced contract** (E7 — **CL-4's doctrine at the name layer**)"* |
| 3 | `Syntax.hs:386-388` | *"the **E7 doctrine at the pricer** — `bits` and `bitsIn` are one arithmetic, one tree, no drift"* |

Stated as law:

> **Any evaluator fast path is legal iff a property pins it, extensionally, to the general
> route. Enforced, never trusted. It buys speed, never semantics — and it never enters the
> alphabet, so it never touches the prior.**

**`Bern` is the law's one live violation, and its own comment convicts it.** Sighting 2 says in
so many words that the *fast form* is what **executes** and the general family is merely the
*contract* — and then `Bern` sits **in `StdName`**, charging a codeword, **inside the prior**.
It grew `STDNAME` 4 → 5 (now **7**). Under the law: **`bernFast` (`Eval.hs:179`) survives as an
evaluator fast path — zero speed lost — and `Bern` leaves the alphabet.** E7 is already its pin.
Refund: **lg 7 − lg 6 = 0.222 bits on every stdlib mention, forever.**

### Audit of every fast path in the engine

| fast path | exploits | pinned by | verdict |
|---|---|---|---|
| `bernFast` (`Eval.hs:179`) | the logit/expfam shape | **E7 `propExpansion`** (`test-expfam/ExpFam.hs:208`) | ✅ **the model** — pinned, enforced |
| the `cond` engine (`Belief.hs:158-188`) | — (it **is** the general route) | **CL-4** (`test/Properties.hs:64-107`) | ⚠️ **gate ~360,000× too wide** — §2b |
| `observeCounts` (`Enumerate.hs:649`) | **sufficiency** (batch collapse) | **nothing.** `test-d/D.hs:1041` tests only that the *wire syntax parses* | ❌ **trusted, not enforced** |

**`observeCounts` is a semantic fast path with a syntax test.** It collapses a batch to
`(n₁, n₀)` — legal only because the bern code *happens* to have a sufficient statistic. Today
that is guaranteed by the alphabet. Under §2a it will not be, so the pin stops being optional:
**`observeCounts` ≡ `n₁` then `n₀` repeated `observe`s becomes a REQUIRED property.**

---

## 2. What survives, and what was right all along

**WITHDRAWN — these clauses STAND, and the audit's first pass was wrong to attack them:**

- **`interface.md:37-43`, the load-bearing clause.** *"Consequences arrive inside F_{t+1};
  there is no return value."* **Correct.** Consequences *are* observations. **The error was
  never the channel — it was that nothing valued lived at the other end of it.**
- **CL-6, "the self arrives as names like any other."** Right and sufficient. It was simply
  never switched on.
- **`test/Acceptance.hs` in its entirety.** Its `argmaxEU` is polymorphic and never mentions
  `Choice`. **The inference side of this project is excellent and is not in question.**

---

## 2a. The likelihood is a CODE — and the engine has always been one

The author asked for something *"more general / principled / foundational"* than the exponential
family. There is exactly one floor, and **the engine is already standing on it without knowing.**

> **A likelihood is a CODE.** `P(y | x) ∝ 2^{−L(x,y)}` — where `L` is an ordinary priced
> expression: **the code length of outcome `y` in context `x`. The same principle as the prior.**

**Nothing is more foundational, by Kraft**: every distribution *is* a code and every code *is* a
distribution, **bijectively**. This is not a restriction — it is a **reparameterisation**, and no
generality is ever lost. That is what makes it the floor rather than a choice.

**Every likelihood in the engine already routes through `fromBits`** — declared at
`Belief.hs:133-135` as *"the prior `2^(-|program|)` … **This is the ONLY place a prior comes
from**"*. `ExpFam` (`Eval.hs:116-119`) is nothing but `fromBits` fed a **hardcoded shape of code
length**; its own comment admits *"fromBits absorbs the log-partition A(η) in its
normalization."*

And the decisive one. **`walkOn` (`Enumerate.hs:342-358`) — the record's "one recorded non-expfam
member" — IS ALREADY `2^{−L}`**, hard zeros and all, and **its own comment says so**:

> *"a point with no position has mass 0, i.e. **infinite description length through `fromBits` —
> the measure's own off-support statement**"*

**Somebody wrote the general solution, called it a special case, and shelved it.**

### T1 dissolves

`EXPFAM_PLAN.md:68-80` proved that `rw` is **not** an exponential family: *"an expfam's support is
the base measure's, **fixed for the family**; the reflected walk has source-dependent hard zeros."*
**That proof is true about exponential families and irrelevant to this engine, which never used
one.** A code assigns **∞ bits** to what it does not cover — not a special case, **the
definition**. Verified end to end: `Bits (1/0)` → `fromBits` → `−∞` → `lse` short-circuits
(`Belief.hs:86-88`) → weight **exactly 0**; `orImpossible` fires only when *all* mass is zero,
which is the correct error. **There is no base measure to fight, because there is no base
measure.**

### Why the generality is not frightening

An arbitrary finite kernel is expressible as a code **table** — `O(|x|·|y|)` bits. A licence for
nonsense? **No: the prior handles it.** A structured code costs `O(1)`. **`bern` wins over the
table because it is SHORTER, not because we forbade the table.** That is brief §8's method —
*"the complexity prior does the model selection; **you do nothing**"* — applied to **likelihoods**
for the first time.

**Cut, each a shape of a code, not a primitive:** `ExpFam`, `Stats`, `SId`, `Carrier`, **`Bern`**
(§1b), **`rw` / `THmm` / `MHmm`**, `Terminal`, `Model`. **A hypothesis becomes a sentence** — now
possible at last, *because `rw` is finally sayable.*

**The one honest casualty: sufficiency dies as a GUARANTEE.** `test-expfam` group 6
(`propSufficiency`) is **false for an arbitrary code**. Under §1b this is the right trade and
**costs no speed**: sufficiency survives as *structure the evaluator may recognise* — so
`observeCounts` keeps collapsing bern-shaped batches — but never as an *alphabet guarantee*. The
price of the trade is that it must now be **pinned**, and today it is not.

---

## 2b. STOP AND REPORT — the `1e-9` in CL-4 (a frozen test is wrong)

`test/Properties.hs:85` and `:107`, **frozen since Phase 1**:

```haskell
(abs (lhs - rhs) <= 1e-9 * (1 + abs rhs))
```

**It is the only tolerance of its magnitude in the repository.** Every value pin in every later
suite is `1e-12`; `test-govhost/GovHost.hs:132` names it — *"C10's standard for value pins over
frozen-verb compositions."* `test/Anchors.hs`'s `1e-6` / `1e-4` each carry a written margin. And
**the `0.02` in this very file carries a five-line provenance paragraph** (*"observed maximum
0.0025 bits/obs … **8x headroom** … delta is part of the oracle and **is never widened in
place**"*).

**The `1e-9` carries nothing.** It is the one tolerance in the repo that never went through the
file's own tolerance protocol. So it was **measured** — frozen generators and bodies copied
byte-wise (R-D20-i), reporting the quantity the predicate bounds instead of asserting it
(`scratchpad/agent/Cl4Residue.hs`, throwaway per R-D21):

```
CL-4 RESIDUE  |lhs - rhs| / (1 + |rhs|)   over 200000 deterministic cases

CL-4 Saw (Properties.hs:85)    max residue = 2.7560e-15   bit-exact  54277/200000
                               frozen bound 1e-9   ==>  HEADROOM = 362,847 x
                               house standard 1e-12  ==>  WOULD PASS
CL-4 Is  (Properties.hs:107)   max residue = 1.6212e-15   bit-exact 112618/200000
                               frozen bound 1e-9   ==>  HEADROOM = 616,844 x
                               house standard 1e-12  ==>  WOULD PASS
```

**The float noise is 3e-15. The gate is set at 1e-9.** It is not absorbing noise. **It is a round
number.**

**And it is the gate on the law of §1b.** CL-4's own header, `Properties.hs:9-11`:

> *"Any Phase-2 conjugate fast path behind the opaque `Belief` handle is **legal iff this property
> still passes**: the fast path **buys speed, never semantics**."*

**CL-4 IS the optimisation law's enforcement mechanism** — the single gate standing between a fast
path and a semantic change. It is currently **~360,000× wider than the noise floor**: a "fast
path" wrong by `1e-10` — a hundred million ulps — would be **certified as semantics-preserving**.

**CL-4 must NOT become exact.** Its two sides are *deliberately different routes* (`lhs`
normalises once in log-space through `lse`; `rhs` divides two linear expectations, recovering the
likelihood by round-tripping `push` / `prob`). **That difference is the property's mechanism** —
make them cancel syntactically and CL-4 becomes a **tautology**. Unlike the float floor — where a
two-route residue became a **decision signal**, a real bug — **here the residue is noise, and
tolerating it is correct.** CL-4 needs a tolerance. It needs the **right** one.

> **REPAIR: `1e-9` → `1e-12`** — the house standard, at **363× measured headroom** (against the
> 8× the file's own other tolerance documents) — **plus the provenance paragraph the protocol
> demands.**

⚠️ **`test/Properties.hs` is FROZEN.** CLAUDE.md: *"If a frozen test IS wrong, stop and report;
the human re-opens Phase 1."* **This section is that report.** The repair may ride on this
boundary — which is already an author re-open — but it must be **named here and signed**, never
slipped in.

---

## 3. The derivation

### What IS an action

Each tick, some names are set by the world and read by the agent; some are set by the agent
and read by the world. That is the whole membrane. The design already dissolved every other
channel into this one — evidence is *"a role a name plays relative to a hypothesis, **not a
type**"*; prices are *"features, names like any other"*; *"the clock does not get a private
wire."* **Choice is the last private wire.**

> **An action is an assignment of values to the names the agent controls.**

Minimal and forced: you need the **names** (else you cannot learn from what you did, nor
price it) and the **grids** (else the action space is unpriceable). Nothing else. And an
assignment `[(Name, Double)]` **is** `Features`.

**The code already agrees.** `Slot` **is** `(Name, Grid)` (`Membrane.hs:138`) — verbatim,
the exact shape `enumerateModelsIn :: Namespace -> [(Name, Grid)] -> ...` takes. On the wire
`pSlot` and `pGuard` are **the same function**. `choiceJson` emits
`{"slots": {<name>: <value>}}` — literally `[(Name, Double)]`, the type of `Features`.
**The wire already transmits a written feature vector. It just labels it "slots".**

### What IS `wait` (A5)

Bayesian decision theory does not let you *choose* whether to update — coherence **forces**
conditioning on everything you know. **Inference is not an action.** Metareasoning exists
for exactly one reason: **inference consumes time, and while you compute, the world moves.**
Remove the clock and the question evaporates. So the decision is never *"should I think?"*
It is **"commit now, or not yet?"**

> **`wait` needs no construct whatsoever.** It is **every action name at the FIRST POINT of its
> grid** — see **§5c**, which supersedes the builder's first answer.

*(The first answer was "`wait` = the empty assignment", resting on the dormancy default —
absent names read `0.0`. The author rejected it: **"conventions scare me, we shouldn't use
conventions."** He was right, and §5c records why: dormancy exists for exactly one job, and
overloading it makes "unset" and "set to zero" indistinguishable. The replacement is
**structural, not conventional** — `mkGrid` takes a `NonEmpty`, so the first point **always
exists**, in every world, with no handshake.)*

Either way the load-bearing property is the same, and it is the one that matters:
**`argmax` stays total without a sentinel, because doing nothing is always in the menu.**

**The world sets the PRICE of waiting, never its availability** (brief §7: *"waiting has a
price the world sets, not the designer"*).

### No `last_action`. No lag. No window. (A4)

**`last_action` is a window of size one — and `window` is on CLAUDE.md's own
forbidden-token list.** Nothing justifies lag-1; a consequence can land five ticks later. A
hardcoded one-tick memory is a designer-chosen sufficient statistic: content injection
wearing a name.

Correct, with machinery that already exists: **the action is a feature of the tick in which
it is taken**, and arbitrary-lag dependence is carried by **latent state in hypotheses** —
the same `cond`-filtered latents that already do drift, change-points and walks.
`interface.md:118-124` already says a transition kernel is *"an expfam whose parameter
expression reads a **latent name** rather than a world feature"*; it need only also read an
**action** name. How far back the past matters is then **learned and priced**, never
declared.

Also kills `ticks_spent_thinking` (a designer-chosen sufficient statistic) and
`lastActionCode` — which is **lossy**: it discards every slot binding, so **no model today
could ever learn what a *parameterised* action does.**

### No `do()`? — ⚠️ **OPEN, NOT RULED** (A6; downgraded by RIDER 3, 2026-07-12)

**The builder recorded this as settled. The author has falsified that, and he is right.**

What the builder wrote: *"No intervention calculus, and none is needed. Scoring an action is
evaluating the predictive with that feature set to that value — plain `push`. Whether that has
causal force is itself a hypothesis; the posterior arbitrates."* And: *"if the agent always does A
when Z is high, 'A did it' and 'Z did it' are observationally identical. The only escape is to
vary the action independently — to explore — and exploration is an action with high VOI, which the
argmax selects exactly when the information is worth buying."* (brief §9: *"Thompson sampling,
ε-greedy, and UCB are permissible only if they **emerge** as expected-utility-optimal."*)

**Why that does not survive.** The author, verbatim:

> *"Push-at-assignment is **evidential** scoring: nothing stops the enumerator producing hypotheses
> with action–latent correlation (**it must**, to model the confound §3 honestly names), and then
> conditioning on a contemplated action updates latents **through the back-channel** —
> **smoking-lesion territory, where the agent manages the news rather than the world.** 'The
> posterior arbitrates, exploration escapes' is an **asymptotic** defence; **the transient can be
> dominated for as long as the confound persists.** Your own canon says manipulation-shaped
> problems need **path-specific objectives, not alphabet rules.**"*

**The error is exactly the one this whole document was written to diagnose, committed again.**
A6 is an **epistemic** axiom — *we cannot know that an action caused something*. The builder let
it license a **decision-theoretic** rule — *therefore score evidentially* — which it does not.
**That is the Savage move: a true theorem installed as a definition.** Twice in one repository,
by the same reflex.

**Status: OPEN.** A6 stands. "No `do()`" does not. **Falsifier owed before any ruling** (§9 OPEN 9):

> **a confounded-payoff world; measure whether and when exploration pressure rescues the choice.**

Not *whether it does asymptotically* — **when**, and **at what regret**, and whether the transient
is dominated. If evidential scoring loses money for as long as the confound persists, "the
posterior arbitrates" is a consolation, not a design.

### Heuristics are optimal actions (A7)

If computation were free the agent would always compute the exact posterior. It is not free.
So the EU-maximising move may be **run the cheap approximation and commit** — a heuristic is
not a degradation; under a dear clock it is *the Bayes-optimal act*.

- **The policy must therefore enter the action space** — brief §2's reflexive closure:
  *"a program can condition, predict, and optimise over the agent's own inference **as costed
  actions within itself**."*
- **WARNING: description length is NOT runtime.** Occam and the clock happen to point the
  same way, but a short program can be slow. **The cost of a computation must be MEASURED and
  published as a feature** — never inferred from bit-length, never declared as a constant.
  *This is exactly where a fabricated number would creep back in.*

---

## 4. EXECUTED — proofs, not proposals

All against the **shipped** engine. Throwaway prototypes (R-D21), discarded at freeze. A fourth —
`Cl4Residue.hs`, the 200,000-case measurement behind §2b — is reported there rather than here,
because it measures a **defect**, not a capability.

**(i) Value of information is a COMPOSITION.** `scratchpad/agent/VoiSentence.hs`.
`vThink` written as an **ordinary sentence** — `push`, `cond`, `argmax`, nothing else —
against the frozen `vThinkK` **primitive**:

```
rows: 45   max |sentence - primitive|: 2.220e-16   bit-exact: 21/45
```

⇒ `VThink`, `VThinkK`, `VPre`, `EU`, `VAct` and the whole `FN` sort are **deletable**.
The residual ulp is the two-derivations seam; **on deletion only one derivation remains, so
the seam ceases to exist.**

**(ii) The agent learns what its own actions do — with ZERO alphabet change.**
`scratchpad/agent/ActionModel.hs`. Over namespace `{t, action}` the *shipped* enumerator
produces 1241 models of which **72 are action models**. After 60 ticks of ordinary `cond`:

```
P(obs=1 | action=0) = 0.102941      P(obs=1 | action=1) = 0.897059
prior:                0.5                                 0.5
true world:           0.1                                 0.9
```

**(iii) THE LAZY-GENIUS TEST PASSES.** `scratchpad/agent/LazyGenius.hs`. Actions as
features; utility reads a **feature** (`payoff`); scoring is `E[ΔU]`; the world's opportunity
shrinks while you deliberate.

*(This prototype predates §5c and encodes `wait` as the empty assignment. **The result does not
depend on it**: what the test exercises is that doing nothing is **in the menu, scored by the same
argmax as everything else**, and §5c changes only how that option is spelled — from an absent name
to a first grid point. Re-running it under §5c is a step-5 oracle row, not a re-proof.)*

```
hazard  | waited (ticks) | then         | stake left
0.000   | 11             | commit-HIGH  | 1.0000
0.020   |  8             | commit-HIGH  | 0.8508
0.050   |  5             | commit-HIGH  | 0.7738
0.100   |  2             | commit-HIGH  | 0.8100
0.400   |  1             | commit-HIGH  | 0.6000
0.700   |  1             | commit-HIGH  | 0.3000
```

**A dearer clock buys MONOTONICALLY fewer deliberating ticks — never more** — and it still gets
the answer right every time. The **only** thing that varied is `hazard`, a *world feature*.

**"Strictly" was the builder's word and it is FALSE — RIDER 4's sibling, caught by the author
against this table.** At hazard **0.400 and 0.700 the count is the same: 1 tick.** The relation is
**monotone, not strict**, and the tie is printed here rather than hidden behind an adverb. *(The
one-tick floor is not a knob: it is where one more observation stops being worth its hazard, on an
integer tick grid.)*

Audited, literal by literal: the sole numbers on the decision path are the **dormancy zero**,
the **world's own decision boundary**, the **observation space**, and the **clock's terminal
zero**. **There is not one agent-side constant.** No price, no sentinel, no cap, no depth
knob. All ten forbidden semantic tokens absent from the code.

> brief §12: *"you must be **unable to identify the line of code** that made it lazy."*
> Today it is pointable: `membrane-wire.md:131`, and `Wire.hs:419` **mandates** it.
> **In the corrected ontology there is nothing to point at.**

⚠️ **RIDER 1 scopes what this test proves.** It passes **because `hazard` folds the future into the
present tick** — the world shrinks the stake *now*, so a one-step `E[ΔU]` sees the whole cost of
waiting. **It therefore does not exercise the myopia**, and must not be cited as evidence against
it. A payoff landing at `t+5` is invisible to this agent's choice. **§9 OPEN 8.**

---

## 5. The minimal type system — "minimal, but not less"

**Net: eleven types deleted, none added — the only new name is a SYNONYM.**

```haskell
-- SURVIVE untouched: the four nouns + evidence (brief §3 — always right)
Space, Belief, Event, Kernel, Evidence
Name, Grid                                  -- data with prices
type Features = [(Name, Double)]            -- THE one carrier.  Already exists.
Namespace                                   -- pricing

-- the ONLY new thing, and it is a SYNONYM, not a type:
type Menu = [(Name, Grid)]                  -- writable names + their grids
                                            -- (identical to enumerateModelsIn's extras)

-- an ACTION is a Features fragment: a partial assignment over the menu.
-- `wait` = every action name at the FIRST POINT of its grid (S5c).  NOT the
-- dormancy default -- grids are nonempty by CONSTRUCTION, so `wait` is
-- available STRUCTURALLY, in every world, with no convention and no handshake.
```

**DELETED — 11 types, ~12 functions.**
*The action apparatus (5):* `Choice`, `Affordance`, `AffId`, `Slot`, `InternalAct` — with
`internalMenu`, `lastActionCode`, `EchoSpec`, `echoFeatures`, `uDescribe`, `Rung`,
`PureWorld.wMenu`'s `[Affordance]`, `Pilot`'s `Choice` mentions, and the
`ticks_spent_thinking` counter.
*The value apparatus (2):* `Util` (§5's utility ruling), `Chan` (its recorded twin debt,
`Syntax.hs:325-341`).
*The likelihood apparatus (4):* `Carrier`, `Stats`, `Terminal`, `Model` — **all four are shapes
of a code** (§2a).

**DELETED from the alphabet** (each proven a composition or a shape ⇒ each was content, brief §12):
`EU`, `VAct`, `VThink`, `VThinkK`, `VPre`, **`Bern`** (§1b), `ExpFam` (→ `Code`), `SId` (→ `Pos`)
— **and with them the whole `FN`, `UTIL`, `STDNAME` and `STATS` sorts.** `IsEq` survives, folded
into `EXPR` beside `Gt`; `Call` has nothing left to call.

**ADDED to the alphabet** (each with its deletion proof):

| production | what is lost if removed |
|---|---|
| `Expect` **binds** its carrier variable, as `Argmax` already does | Without it **no `Argmax` can sit inside an expectation** — *precisely* why `VThink` had to be a primitive. |
| `SawE :: Eq b => Expr env (K a b) -> Expr env b -> Expr env (Ev a)` | Without it **no program can condition at all.** Today there is **no `Expr env (Ev a)` constructor whatsoever** — `CondE` is unreachable from any sentence. **This is the hole `VThink` papered over.** |
| `ElimJ` | Without it a conditioned belief cannot be **consumed** by a sentence. |
| **`Code`** (§2a; replaces `ExpFam` in the KER sort, 1 → 1) | Without it **no enumerated sentence can assign likelihood** — E9's proof, corrected in §5b and now *stronger*, because `Code` is the **sole** route where `rw` used to be a second one. |
| **`Pos`** (§5b; subsumes `Stats`/`SId`, so the STATS sort deletes) | Without it **`walkOn`'s adjacency is unsayable**: the shipped grids are FP-nonuniform, so adjacency is **not a function of the values**, and the boundary reflection *doubles* a neighbour's mass. |

**ARITHMETIC IS REQUIRED. (RE-CORRECTED 2026-07-12 — this reverses the builder's previous
correction, which was wrong.)**

The builder first called arithmetic blocking, then withdrew it on the grounds that a utility over
features is a **decision tree with grid-priced leaves** and that `E[ΔU]`'s subtraction cancels in
the argmax. **Both of those remain true, and they are beside the point.** Arithmetic is forced
not by *utility* but by **§2a — the likelihood.**

`Expr` has **no arithmetic at all** (`prodExpr = 10`: `MkC Get If Gt Var Push CondE Expect Argmax
Call`). A Double-valued sentence today can only be nested `If`/`Gt` over grid constants — it is
**piecewise constant**. It cannot express `−log₂ θ`, nor `η·T(y)/ln2`, nor `walkOn`'s `mass`.
**A code length is an arithmetic expression, and there is no way to say one.**

| forced | by |
|---|---|
| `Sub`, `Add` | `bernFast`'s `1 − θ`; `walkOn`'s three-term `mass`; `σ`'s `1 + exp _` |
| `Mul`, `Div` | `ExpFam`'s `η·T(y)/ln2`; `pApprove`'s `w · σ(u/τ)`; **and `logBase x y = log y / log x`** |
| **`Log`** | every `logBase 2` — bern, walkOn, verdict |
| **`Exp`** | **`verdictKernel`'s σ — and it calls `bernFast` at a COMPUTED, OFF-GRID θ, so no lookup table can stand in.** This is the one that admits no escape. |
| `Neg` | ubiquitous, and `0 − x` differs from `negate x` at `−0.0` |

**REFUTED en route — "grid the code lengths, so one constant suffices."** `fromBits`'s
normalisation is shift-invariant **in ℝ but not in IEEE-754**: measured against the shipped theta
grid, the one-constant form and `bernFast` are bit-identical for θ ∈ {0.1, 0.2, 0.3, 0.5} and
**differ for {0.4, 0.6, 0.7, 0.8, 0.9}** — **5 of 9**. Gridding does **not** buy away the
arithmetic. The claim was true in ℝ and false in the machine.

**This is the largest blast radius in the re-derivation, and it was always going to be paid** —
because **the engine already computes every one of these in Haskell, behind the alphabet's back.**
The arithmetic is not being *added* to the language. It is being **confessed**.

**Utility**: an ordinary `Expr env Double` reading `Get`, and **latent** — a belief over
utility programs (brief §9, CIRL). `Util a y` dies. Repeals `typed-port-spec.md:172-177`'s
*"utilities are featureless and clockless"*, which is backwards: **utility must read
features, because features ARE the consequences.**

---

## 5b. The primitivity audit — brief §12, discharged for the first time

> *"The **grammar**: terminals, production rules, and — for **each** terminal — a one-line
> proof that its deletion costs a capability that would then need external supply.
> **Terminals without such a proof are cut.**"*

**The deletion audit covers 2 of ~22 productions.** Gate 7 (`audit/ablation.sh`) ablates
exactly **`push`** and **`argmax`**. **`condition` — one of the three verbs — has never been
ablated.** Nor have `Get`, `If`, `Gt`, `Var`, `MkC`, `Expect`, `Call`, `EU`, `IsEq`, `VAct`,
`VThink`, `VThinkK`. By the brief's own rule, every one of them is *"a standing bug against
the prior."*

And one is self-convicting — `Syntax.hs:299`, the author's own comment:
> `-- the derived name (EXPFAM_PLAN E6): bern re-derived over the expfam basis`

**`Bern` is recorded as DERIVED and sits in the priced alphabet charging bits.** brief §4's
forbidden move, written down and shipped.

### Truly primitive (each deletion costs a capability)

`Push`, `CondE`, `Argmax` (the three verbs) · `Expect` (the *prevision* — brief §3's atom) ·
`Get` (delete ⇒ the agent is blind) · `MkC` (delete ⇒ no threshold or grid point is sayable)
· `If` (brief §9: *"branching gives you closed-loop structure; that is all you need"*) ·
`Gt` (the only ordering predicate) · **`IsEq`** (**option dispatch** — used on the
argmax-bound option, `Acceptance.hs:205`; delete it and a policy cannot branch on *which act
it is scoring*, and it is **not** derivable from `Gt`, which is Double-only) · `Var` (forced
by the binders) · `SawE`, `ElimJ` (proofs above) · **`Code`** and **`Pos`** and the
**arithmetic** (below).

**`Code`** — the sole likelihood production (§2a):

```haskell
Code :: Space a -> Space b -> Expr (b ': a ': env) Double -> Expr env (K a b)
--       domain    codomain   the CODE LENGTH of y (Var Z) given x (Var (S Z))
-- eval:  kernel dom cod (\x -> fromBits cod (\y -> Bits (evalx body (y :. x :. vals))))
--        Space payloads priced 0 — the opaque-payload convention ExpFam already uses
```

**`Pos`** — ONE production, TWO problems:

```haskell
Pos :: Eq a => Space a -> Expr env a -> Expr env Double   -- position in the DECLARED space
```
- **(i)** `walkOn`'s adjacency. The shipped grids are **FP-nonuniform**
  (`0.2 + 0.1 = 0.30000000000000004 ≠ 0.3`), so **adjacency is not a function of the values** —
  and the boundary reflection *doubles* a neighbour's mass, which no value-difference predicate
  reproduces. It needs `elemIndex`.
- **(ii)** the carrier → Double reader — which **subsumes `Stats` / `SId`**, so the whole STATS
  sort deletes.

### E9's deletion proof, CORRECTED

E9 claimed *"delete `expfam` and **nothing** can assign likelihood."* **That was already false.**
`Evidence.Is` and the exported `kernel` / `fromBits` are unfenced routes, and **`test/Properties.hs`
itself builds arbitrary code likelihoods with zero grammar involvement.** The deletion proof was a
**CPP fence, not a type.** Stated correctly it is **true, and now stronger**:

> **Delete `Code` ⇒ no enumerated sentence can assign likelihood** — and `Code` is the **sole**
> route, where `rw` used to be a second one.

### Cut (each a composition, or a shape ⇒ content ⇒ stealing bits from the prior)

`EU`, `VAct`, `VThink`, `VThinkK`, `VPre` (**proven**: 45 rows, 1 ulp) · **`Bern`** (§1b — the
law's one live violation) · `ExpFam`, `Stats`, `SId`, `Carrier`, `rw`/`THmm`/`MHmm`, `Terminal`,
`Model` (§2a — shapes of a code) · `FnInd`, `FnUtil` (subsumed by `Expect`-with-binder) · `USay`
(utility is an ordinary `Expr`).

### The result: FOUR WHOLE SORTS vanish — and the honest cost is exactly one bit per node

| sort | today | after | |
|---|---|---|---|
| EXPR | 10 | **20** | 9 kept (`Call` drops) + `IsEq` + `SawE` + `ElimJ` + `Pos` + 7 arithmetic |
| KER | 1 | **1** | `ExpFam` → `Code` |
| FN | 2 | **—** | subsumed by `Expect`-with-binder |
| UTIL | 1 | **—** | utility is an ordinary `Expr` |
| STDNAME | 7 | **—** | every member proven a composition or a shape |
| STATS | 1 | **—** | subsumed by `Pos` |
| **total** | **22 productions, 6 sorts** | **21 productions, 2 sorts** | |

**`prodExpr` 10 → 20 is exactly `+1.0` bit per node** (`lg 20 − lg 10 = 1`, since 20 = 2 × 10).
**State it plainly: every sentence in the language gets one bit dearer per node.** That is the
price of confessing the arithmetic, and **the prior is where it belongs.**

Against it: every `Call` stops paying `stdB` (**lg 7 = 2.81 bits**), every `Expect` stops paying
the FN bit (**1.0**), and the VOI primitives stop being reachable at all. **Real sentences get
cheaper; vocabulary nobody earned stops being subsidised.** `prodTable` drops from six fields to
two, and **every price literal in nine test files reprices** — the P5 single-site alphabet
constant firing exactly as designed.

---

## 5c. `wait` without a convention (corrected 2026-07-12)

The builder first built `wait` on the **dormancy** default (*absent names read 0.0*). That
was an **overload**: dormancy exists for exactly one job (brief §9 — a sentence about a
sensor that does not exist **yet** is inert until it appears), and pressing it into service
as *"I did not act"* makes "unset" and "set to zero" indistinguishable. **Conventions are
what this whole re-derivation is deleting.**

> **`wait` = every action name at the FIRST point of its grid**, and the world declares what
> that value is.

`mkGrid :: Name -> NonEmpty Double -> Grid` — *"Grids are nonempty by construction"*
(`Syntax.hs:81`). So the first point **always exists**: `wait` is available **structurally,
in every world, with zero new machinery and no handshake.** It is also *more honest* — it
forces a world to **say what inaction looks like on its own lever**, which is information
the agent needs anyway. And CL-3's first-listed-wins then hands ties to it automatically:
**the safe default falls out of a rule we already have.**

Dormancy goes back to doing only its one job.

---

## 6. Pricing: the action space enters the prior, for the first time

One namespace. A writable name is mentioned at `log₂|ns|` like any name; a value is drawn
from its grid at `log₂|grid|` like any constant. **M5 is repealed** — it carved the action
vocabulary out of a law whose own rationale covers it (*"a richer world makes every sentence
about it more surprising. **This is a semantic commitment**"*), to protect a "fourth flow"
that is nowhere derived. Publishing an affordance now **costs the prior something**.
**brief §5 is satisfied on the action side for the first time.**

### ⚠️ RIDER 2 — the repeal opens a coherence hole, and M5 was clumsily guarding it

The author, verbatim:

> *"Mention price is log₂|ns|, and the world grows the namespace at runtime by publishing
> affordances. If sentence prices are fixed at enumeration time, **two identical sentences
> enumerated either side of a publication carry different priors — path dependence**, and your own
> tripwire property should red on it… implementers will freeze enumeration-time prices and **ship
> the incoherence M5 was clumsily guarding against.**"*

**He is right, and the plan as written did not pin it.** M5 was the wrong answer to a real
question. Repealing it without answering that question ships the bug M5 was blocking.

### The pin (his own doctrine, and the wire already has the shape)

> *"treat writable names exactly like appearing sensors — the ideal prior is over the **completed
> namespace**, owned posterior **odds** are invariant under mid-episode publication, new sentences
> price at the enlarged alphabet."*

**This is the DORMANCY doctrine applied to actions** — brief §9's *sentence about a sensor that
does not exist yet is inert until it appears*, verbatim. And the wire is **already shaped for it**:
the v1/v2 hello carries the namespace and the menu **side by side** —

```json
{"world":{"namespace":["t","x"],"guards":[…],"menu":[…]}}      -- test-d/D.hs:1000-1008
```

so the fix costs one sentence of protocol, and it makes odds byte-stable **by construction rather
than by luck**:

> **NAMESPACE MEMBERSHIP IS DECLARED AT HANDSHAKE AND IS IMMUTABLE. Publication toggles
> AVAILABILITY, not membership.**

Prices are then over the completed namespace **from tick zero**, so **nothing ever re-prices**, so
owned posterior odds cannot move. *(Note why the naive reading fails and this one does not: if
`|ns|` grew mid-episode, two carried sentences with **different mention-counts** would take
**different** dl increments — so their odds WOULD shift. Invariance is not automatic; it is bought
by making the namespace immutable.)*

**WIRE CONSEQUENCE, which must be stated and is a `membrane-wire.md` change:** the hello's
`namespace` **must include every writable name, including those not yet in the menu.** A world may
not conjure a name mid-episode.

**FIXTURE (the author's, owed at step 7):** *publish an affordance mid-episode; **existing
posterior odds byte-stable**.*

---

## 7. Build order

Oracle-first per CLAUDE.md; the builder never owns a live oracle.

0. **This document, signed.** (Author.) **Nothing frozen moves until the tag exists.**
1. **`Code` + `Pos` + arithmetic** (§2a, §5). Oracle: pin the code forms of `bern`, `expfam`
   and `rw` against the engine's own `bernFast` / `ExpFam` / `walkOn`. **`rw` is the
   falsifier** — if a code cannot express the reflected walk, **stop and report.** (It can:
   it already *is* one.) Guard `fromBits` against `NaN` / `−∞` (§9 OPEN 4).
2. **The optimisation law, enforced** (§1b). Generalise E7 from a one-off to the rule.
   **Pin `observeCounts` to repeated `observe`.** **Tighten CL-4 to `1e-12`** (§2b).
3. **A hypothesis becomes a sentence.** `Model` → `Expr env (K a Obs)`; `Terminal` → the
   fragment's production table. Delete `Bern`, `THmm`, `Model`, `Terminal`.
4. **One pricing mechanism, two declared tables.** R4's derivation-relative dl **stands and is
   correct** (`GRAMMAR_HYGIENE_PLAN.md:168`; the builder's "two priors" claim was wrong) — but
   its literals (`dlConst = 1 + mention eg`, …) are `bitsAt` **with a hand-rolled table**. One
   mechanism, two **declared** production tables (policy fragment, model fragment). **No
   hand-counted bits.**
5. **Actions become features.** `Menu = [(Name, Grid)]`; `wait` = the first grid point (§5c);
   delete the five types, the echo path, and **the sentinel**.
6. **Actions in the feature stream, no lag.** Latent-carrying hypotheses do the memory.
   Scoring = `push` at an assignment — **but see step 6b: the scoring RULE is OPEN.**
   *(Proof (ii) stands: it shows the agent LEARNS its action's effect. It does not show the
   evidential scoring rule is correct — RIDER 3.)*
6b. **RIDER 3's falsifier, before any `do()` ruling.** **A confounded-payoff world; measure
   whether AND WHEN exploration pressure rescues the choice** — and at what regret. If evidential
   scoring is dominated for as long as the confound persists, *"the posterior arbitrates"* is a
   consolation, not a design. **Stop and report if it is.**
7. **Pricing unified.** Writable names join the namespace; **M5 repealed**; the action space
   enters the prior for the first time. **RIDER 2's pin lands here: namespace membership is
   declared at handshake and IMMUTABLE (publication toggles availability, not membership).**
   **Fixture: publish an affordance mid-episode; existing posterior odds byte-stable.**
   **`membrane-wire.md` gains the requirement that the hello's `namespace` include writable names
   not yet in the menu.**
8. **Utility on world states, latent.** `Util a y` dies; utility becomes a priced `Expr` over
   features, and a belief over utility programs (CIRL).
8b. **RIDER 1's falsifier and scope line.** **A payoff-at-t+5 world where one-step `E[ΔU]`
   provably selects the dominated act.** Then EITHER a kernel-composition / recursion production
   lands **with its deletion proof**, OR **the myopia is printed as a scope limit** (§9 OPEN 8).
   **A horizon CONSTANT is forbidden — it is the sentinel's disease returning.**
9. **`Expect`-binder, `SawE`, `ElimJ`; delete the VOI primitives and the FN/UTIL sorts.**
   *(Proof (i).)* **Re-run the deletion audit against the smaller alphabet — with a proof for
   EVERY terminal** (today: 2 of ~22). **And the TYPE-derivation audit (§8) — its complement.**
10. **Reflexive closure (A7).** The policy enters the action space; computation cost is a
    **measured** feature; heuristics emerge. *brief §2's headline. Steps 1-9 stand without it.*

The sentinel and the `price` parameter are never "deleted" — after step 8 there is
**nowhere left to write them.**

---

## 8. Frozen corpus

**SURVIVE — inference was always right:** `hygiene`, acceptance test 1, `test/Acceptance.hs`
entirely.

**RE-OPENED, minimally and by name** (each is a *frozen text is wrong* report, not a convenience):

| file | change | why |
|---|---|---|
| `test/Properties.hs` | **`1e-9` → `1e-12`** + the provenance paragraph | **§2b.** Measured: float noise is 3e-15; the gate was 360,000× too wide, on the very property that enforces §1b's law. |
| `test-expfam/ExpFam.hs` | **retire group 6** (sufficiency-as-guarantee); **KEEP E7** | **§2a.** Sufficiency is false for an arbitrary code. E7 survives as **the model of the law**. |

**RETIRED — they pin a calculator:** `ladder`, `prepost`, `cirl`, `govhost`, `test-d`, and
the action-dependent parts of `membrane`. Two are hard blockers *by construction*:
`test-membrane/Membrane.hs:340-350` (the M5 guardian, which asserts menu growth ≠ namespace
growth) and `:156-159` (the t1 parity world, which publishes three affordances while pricing
against a singleton namespace).

**Frozen prose to amend at this boundary:** `interface.md` (T1, the load-bearing clause's scope),
`design.md` / `typed-port-spec.md` (the outcome sort; `prodTable`), `EXPFAM_PLAN.md` (T1, E9),
`HOSTS_PLAN.md` (M5), `membrane-wire.md` + `host-governor/Wire.hs` (the sentinel and
`missing-internal-row`), `CLAUDE.md` (**the optimisation law**), and `MANIFEST.sha256` re-signed
(81 rows today).

Every description length moves — the P5 alphabet-constant clause firing as designed. The
author has ruled the cost acceptable.

---

## 8b. RIDER 5 — the SUPERSESSION MAP (else "the M5 of process")

> *"§2a dissolves the substrate under the standing program without saying what becomes of it…
> Map each — **discharged by construction, re-based, or dead** — or the repo carries **two live
> roadmaps under one custody regime, which is the M5 of process.**"*

The standing chain is **V → R → K → change families** (`BRIEF_AUDIT.md:284-287`), plus HOSTS_PLAN's
**A / B / C**. Every one of them is touched. Mapped, with citations:

| standing item | scope, as written | disposition under §2a/§5 |
|---|---|---|
| **K — kernel decomposition** (`BRIEF_AUDIT.md:285`; A2's DEBT row `:29`) | *"`rw` becomes a stdlib name over utterable, individually priced, individually deletion-proven kernel atoms `mix`/`step`/`id`"* (`:57-60`). Census-bearing, demand-gated. | **DISCHARGED BY CONSTRUCTION.** A code sentence **is** that decomposition — priced, utterable, deletion-provable, atom by atom. **A2's DEBT row (*"molecule recorded as an atom — SELF-LICENSED"*) closes at §2a, not at K.** K's separate census never falls due. |
| **the KER sort "becoming generative after decomposition"** (`BRIEF_AUDIT.md:62`) | K's census scopes *"the kernel-enumeration frontier"* | **DEAD AS WORDED.** KER stays a **1-production sort** (`ExpFam` → `Code`); it is `Code`'s **body** that is generative, priced by the ordinary EXPR table. The frontier is the enumerator's, and it stays **open research** (§9 OPEN 7). |
| **R — vocabulary purchase / refinement** (`METAREASONING_PLAN.md:284`) | *"`refine` as the second internal act valued by V's machinery"*; *"**R buys PRECISION, not adaptation**"* (`:37`) | **RE-BASED, and SIMPLER.** Vocabulary purchase becomes **grid refinement over code constants** — one law for all mentions, no per-family special case. |
| **the "natural-parameter amendment"** — the author's own (`METAREASONING_PLAN.md:372-373`) | *"the alphabet law is stated in criterion form: the dyadic lattice in **the family's NATURAL PARAMETER**, or the feature's canonical coordinate — log-odds is the Bernoulli instance, not the law"* | **DISSOLVES — exactly as the author said, and the text convicts itself.** It says *"the family's"*. **§2a abolishes families.** There is no natural parameter to take a lattice in; there is a **code length in bits**, and the lattice is over *that*. The amendment was a correct generalisation **of a substrate that is being deleted.** |
| **change families** (`BRIEF_AUDIT.md:208-212`, D2/D3) | *"is BOCPD already utterable as mix-over-regime-kernels with a hazard weight from **K's atoms**? … The brief's method applied to its own roadmap."* | **RE-BASED — and D3's own collapse-check now answers YES.** The question was posed *"after K"*, against K's atoms. §2a supplies them. **Change families become code sentences with latents** — a hypothesis is a sentence, so a regime mixture is one too. |
| **C — arithmetic** (`HOSTS_PLAN.md:798-801`) | *"the census-bearing boundary, **last**"*; **GATE**: *"C is built only if D's oracle demonstrates step-table underfit"* | **RE-BASED, AND ITS GATE IS DEAD.** §5: arithmetic is forced **by the likelihood**, not by utility underfit. **C's demand-gate was watching the wrong quantity** and would never have fired for the reason that actually forces it. **C moves from LAST-and-conditional to FIRST-and-unconditional** (step 1). |
| **A — K-ary observations** (`HOSTS_PLAN.md:509-513`) | *"K-ary observation is **NOT a grammar change**"*; demand-gated on the life-agent differential | **SURVIVES, UNCHANGED.** Orthogonal to §2a — it is about the observation *space*, not the likelihood's *form*. Still demand-gated. |
| **B — reliability / noisy channel** (`HOSTS_PLAN.md:583-587`) | conditional on A's differential showing a reliability shortfall | **SURVIVES, and gets EASIER.** A noisy channel is **a code** (§2a) — a finite mixture, no longer a special family needing its own boundary. If it lands at all, it lands as a sentence. |
| **V — the single decision rule at the wire** (`METAREASONING_PLAN.md:10-11`) | tag **`v-open` EXISTS; there is NO `v-freeze`.** | ⚠️ **DEAD — AND DANGLING RIGHT NOW.** Its entire subject (`VThink`/`VThinkK`/`VPre`) is **deleted** by proof (i). **This is a live custody defect the map surfaces: an OPEN boundary tag with no freeze and no cancellation.** **V must be formally CANCELLED by the author at this boundary**, or the repo carries an open boundary whose subject no longer exists. |

**Also stale and named:** `BRIEF_AUDIT.md:143-147` prices nodes at `nodeB = lg 10` and quotes
`ProdTable 10 2 1 1 7 1` verbatim; `:21-22` prices `Bern` at `lg 10 + lg 5`. **Both go stale the
moment `prodExpr` moves 10 → 20 and four sorts vanish.** They are *audit* rows, not oracle pins —
but an audit that cites dead prices is not an audit.

---

## 8c. RIDER 5's process rule → **CLAUDE.md**

The author, on the silence paragraph:

> *"every **type** on a frozen surface gets a one-line derivation from the brief, **the typing
> complement of §5b's deletion audit** — **it was a type, not a terminal, that hid the calculator
> for 86 commits.**"*

**This is the single most valuable process output of the episode, and it goes into frozen
`CLAUDE.md` at this boundary.**

> **THE TYPE-DERIVATION AUDIT.** Every **type** on a frozen surface carries a one-line derivation
> from the brief, exactly as every **terminal** carries a one-line deletion proof (§5b). A type
> without one is cut, or the brief is amended to license it.

**Why it is the exact fix for the exact failure.** §0's silence paragraph: the increment protocol
scrutinises **changes**, and `data Util a y` arrived **on day zero, as a port**. Eighty-six
commits, forty documents, two external reviews and a brief-conformance audit all pointed at
everything downstream of that line and never at the line. **The deletion audit polices the
alphabet. Nothing policed the types.** `Util a y` was not a terminal — it was a *type* — and it
carried the entire calculator.

---

## 9. Under-determination register

**RULED.** The world's determinism is moot (A3) — `s` is not in the agent's ontology.
CL-3 first-listed-wins stands. `wait` is core, always available (A5).

**RULED 2026-07-12 (author):**

- **THE OPTIMISATION LAW.** *"Optimisations can exploit structure but never live in the
  prior."* See **§1b** — the repo already calls it "the doctrine" in three places and never
  made it a law. It costs no speed and it convicts `Bern`.
- **Arithmetic IS blocking. (This REVERSES the builder's own correction of two days ago,
  which was wrong.)** Not because of utility — the decision-tree argument stands — but because
  **a code length is an arithmetic expression** (§2a) and **`verdictKernel` calls `bernFast` at
  a computed, off-grid θ**, which no table can stand in for. See **§5**.
- **No conventions.** `wait` is the first grid point, world-declared — not the dormancy
  default. See §5c.
- **CL-1 at the echo.** The criterion is **the membrane itself**: *is it observable from
  outside?* Your **actions** are (the world watched you). Your **posterior entropy** is not.
  **Measured runtime** is (the clock ran). So actions and measured compute-cost may be
  features; `entropyBits` and `top` may not — and the value of waiting is re-derived
  **through the verbs**, which is CL-1's own escape clause satisfied explicitly rather than
  by assertion. `ticks_spent_thinking` is deleted regardless (a designer-chosen sufficient
  statistic). **No document in this repo had ever cited CL-1 at the echo. This is that
  ruling.**
  ✅ **ENDORSED BY THE AUTHOR (2026-07-12)**: *"the cleanest piece of new law in the document,
  and it is exactly how 'measured compute cost' enters without a fabricated number."* **Kept
  verbatim; no rider touches it.**
- **Primitivity.** Every surviving production gets a deletion proof — including the ones
  that never had one. See §5b. **RIDER 5 adds its complement: every TYPE on a frozen surface
  gets a one-line derivation from the brief (§8c).**

**OPEN.**

1. **Does `Event` survive as a peer noun?** With `Expect` binding its variable, `FnInd` is
   just an `If`-indicator, so `prob` is derivable. brief §3 left this open deliberately
   (*"make the argument yourself and record which cost you chose to pay"*).
2. **The gauge.** `E[ΔU]` is gauge-free in the additive constant but not the scale. What
   fixes the scale — the principal's revealed indifference, or a declared unit?
3. **`Push` vs `Expect`.** brief §4 calls them **one verb** (*"prediction is `push` into ℝ —
   the operation you will elsewhere call `expect`"*). In the typed port they are two
   constructors because the codomains differ (a `Belief` vs a scalar). The builder's reading:
   that is an **encoding artifact, not a fourth verb** — but the prior charges two codewords
   for it, so the author should record which cost was chosen.
4. **`fromBits` has two unguarded hazards, and §2a makes both reachable.** Today `L` is
   hardcoded, so neither can fire; under `Code` an arbitrary `L` can.
   **(a)** `L = +∞` at *every* carrier point ⇒ `mkBelief` ⇒ `Nothing` ⇒
   `error "fromBits: belief has no mass"` — **a live `error` site, and `fromBits`'s FROZEN
   signature admits no failure value.** Totality story, or a signature change at this boundary?
   **(b)** **Negative-infinite / NaN code lengths are entirely unguarded**: `Bits (−1/0)` ⇒
   weight `+∞` ⇒ `lse` gives `NaN` ⇒ the `z == negInf` test is `False` ⇒ **a silently invalid
   `Belief` of NaNs.** **There is no `isNaN` check anywhere in `Belief.hs`.**
5. **The minimal arithmetic set.** §5 lists seven (`Add Sub Mul Div Log Exp Neg`), each with the
   likelihood that forces it. **The step-1 oracle confirms the set; the builder does not assert
   it.** (`Neg` is separate from `Sub` only because `0 − x ≠ negate x` at `−0.0` — a real IEEE
   distinction, but the author may rule the sign-of-zero irrelevant and save a production.)
6. **`Pos`: index or value?** On **every carrier shipped today they coincide**
   (`obsCarrier = 0 :| [1]`). That is a **coincidence of the declarations, not a theorem** —
   `mkCarrier "c" (2 :| [5])` separates them instantly. Which one `Pos` returns is a semantic
   commitment. **The oracle decides; the builder does not.**
7. **The generator stays open.** The Cromwell frontier is **named open research**
   (`design.md:244`, `WRITEUP.md:414`). This boundary does **not** solve it and does not pretend
   to: the enumerator will produce codes from a **declared, depth-bounded fragment**, and today's
   three families must fall out of it. **If the bounded enumeration cannot reproduce a working
   hypothesis space, stop and report.**

**OPENED BY THE AUTHOR'S RIDERS (2026-07-12) — the four that were not open before:**

8. **⚠️ MULTI-STEP VALUE — the myopia (RIDER 1).** `E[ΔU]` as built is **one tick's Δ**. §3 convicts
   `last_action` because *"a consequence can land five ticks later"* — and latent-carrying
   hypotheses duly **learn** arbitrary lag — **but a consequence at `t+5` is then visible to
   learning and INVISIBLE TO CHOICE.** The lazy-genius test **does not catch this**: `hazard` folds
   the future into the present tick.
   - **Already sayable:** depth-unrolling. Proof (i)'s `sPre m` builds a depth-`m` lookahead from
     `Push`/`Cond`/`Expect`/`Argmax` alone.
   - **Not sayable:** the **world-rollforward**. A hypothesis is `context → Obs`, **not an
     endo-kernel on features**, so pushing it five times **is not type-correct.** There is no
     kernel-composition and no recursion production among the 21.
   - **The horizon must never be a CONSTANT** — *"the sentinel's disease returning"* (the author).
     Nor need it be: **a depth-`k` unrolled sentence costs `O(k)` nodes, so deeper lookahead is
     DEARER IN THE PRIOR.** The bound is already paid in bits; *choosing* the depth is an **act**,
     priced by the clock (A7).
   - **RULED (author): print the myopia as a scope line + the falsifier** — *a payoff-at-`t+5`
     world where one-step `E[ΔU]` provably selects the dominated act* (step 8b). The
     kernel-composition production stays the **named alternative**, to land only with its deletion
     proof. **No production lands on the builder's judgement.**
9. **⚠️ `do()` / EVIDENTIAL SCORING — downgraded RULED → OPEN (RIDER 3).** Push-at-assignment is
   **evidential** scoring. The enumerator **must** produce action–latent-correlated hypotheses (to
   model the confound §3 itself names) — and then conditioning on a *contemplated* action updates
   latents **through the back-channel**: **smoking-lesion territory, the agent managing the news
   rather than the world.** *"The posterior arbitrates, exploration escapes"* is an **asymptotic**
   defence; **the transient can be dominated for as long as the confound persists.** The author:
   *"manipulation-shaped problems need **path-specific objectives, not alphabet rules**."*
   **Falsifier owed (step 6b): a confounded-payoff world; measure whether AND WHEN exploration
   pressure rescues the choice — and at what regret.**
10. **`ElimJ`'s `Nothing` branch — a totality story is owed (RIDER 5's sibling; OPEN 4's).** `cond`
    returns `Maybe`, so `ElimJ` must answer for the impossible-evidence case. **In proof (i) the
    default sat under a weight-zero predictive, so its VALUE was inert — that is an accident of the
    preposterior, not a general licence.** In a general sentence the default is **load-bearing**.
    Branches: a **sentence-level arm** (both arms supplied by the program), or a **world-declared
    grid point** (§5c's discipline). **Never a baked constant.**
11. **A5's delegation (RIDER 4).** §5c gives **`argmax` totality**, not **inaction**. A world
    declaring `fire :| [stand_down]` makes the first grid point a **launch**. **Inaction semantics
    is delegated to world authors** — lawful (world content is physics) but **a convention
    relocated across the membrane, not abolished.** Recorded, not narrowed. Does the author accept
    the delegation, or does the membrane owe a *declared* inaction row?
12. **V is DANGLING (RIDER 5's map, §8b).** Tag **`v-open` exists; there is no `v-freeze`** — and
    proof (i) **deletes V's entire subject** (`VThink`/`VThinkK`/`VPre`). **The author must
    formally CANCEL V at this boundary**, or the repo carries an open boundary whose subject no
    longer exists. *(A live custody defect, surfaced by the map rather than by anyone noticing.)*

---

## 10. Custody

Builder signs with the builder key (`/home/g/.ssh/proplang-builder.pub`), never the
author's. This boundary binds when the author countersigns with a signed tag from the
author's own shell. The tag, not any commit signature, is the attestation.

**RULED BY THE AUTHOR, 2026-07-12: the author tags this boundary HIMSELF.** CLAUDE.md's delegation
route (*"the builder then tags with the BUILDER key and records the delegation verbatim"*) **was
available and was declined.** No delegated tag exists on this boundary; **R-D22's re-tag obligation
never arises, because the builder makes no delegated edit to a frozen surface.** The builder
commits the riders with the builder key and **stops.**

---

## 11. The author's riders (2026-07-12) — recorded verbatim

> *"This is the strongest document in the sequence, and the diagnosis is correct… **Sign it — with
> the following riders, ranked.**"*

The author's verdict on the rest: the chain from **Savage-as-definition to the fabricated sentinel**
is *"evidenced link by link"*; the silence paragraph *"identifies the real process lesson: **day-zero
ports evade an increment protocol, and a conformance audit checks the laws you thought to write,
never the types you inherited**"*; and **proof (i) is *"the quiet star"*** — *"VOI reproduced as an
ordinary sentence to one ulp retroactively vindicates 'the generator is just the one argmax' and
discharges the brief's own named forbidden move."*

| # | rider | disposition |
|---|---|---|
| **1** | **A1 fixes the model side's lag problem and leaves it standing on the value side.** *"a consequence landing at t+5 is visible to learning and invisible to choice… The lazy-genius test dodges this because hazard folds the future into the present tick… **Any horizon constant, note, would be the sentinel's disease returning.**"* | **ACCEPTED — LIVE DEFECT.** §9 OPEN 8; step 8b; A1 scoped; proof (iii) scoped. **RULED: scope line + falsifier.** |
| **2** | **M5's repeal opens a coherence hole the plan doesn't pin.** *"two identical sentences enumerated either side of a publication carry different priors — path dependence… implementers will freeze enumeration-time prices and **ship the incoherence M5 was clumsily guarding against.**"* | **ACCEPTED — LIVE DEFECT.** §6 gains the **immutable-namespace pin** + the **wire consequence** + the author's fixture. Step 7. |
| **3** | **"No do()" is an OPEN row, not a ruling.** *"conditioning on a contemplated action updates latents through the back-channel — **smoking-lesion territory** … 'the posterior arbitrates, exploration escapes' is an **asymptotic** defence; **the transient can be dominated**."* | **ACCEPTED — DOWNGRADE.** §3 rewritten **RULED → OPEN**; §9 OPEN 9; step 6b. **This is the Savage move committed twice, by the same reflex.** |
| **4** | **§5c delivers totality, not inaction — say so.** *"a world listing `fire :| [stand_down]` makes your 'wait' a launch… otherwise the axiom overclaims."* | **ACCEPTED.** **A5 amended to its structural form**; the delegation named in §9 OPEN 11. |
| **5** | **The plan needs a supersession section.** *"…or the repo carries **two live roadmaps under one custody regime, which is the M5 of process.**"* | **ACCEPTED.** **§8b** — the full map (K/R/C/A/B/V/change-families/the natural-parameter amendment/BRIEF_AUDIT's stale rows), each cited. **§8c** — the type-derivation rule → CLAUDE.md. **It surfaced a live custody defect: `v-open` dangles.** |

**The smaller riders — all four accepted:**

| rider | disposition |
|---|---|
| *"`ElimJ`'s Nothing branch needs a totality story"* | §9 OPEN 10. **The proof-(i) default was inert only because it sat under a weight-zero predictive — an accident, not a licence.** |
| *"the CL-4 headroom was measured on today's engine, so **re-measure post-step-1** as an oracle row before freezing 1e-12"* | **ACCEPTED WITHOUT RESERVATION.** Step 1. `Code` + arithmetic changes the arithmetic; the 363× margin is not transferable. |
| *"'strictly fewer deliberating ticks' fails between hazard 0.4 and 0.7 — **delete 'strictly'**"* | **ACCEPTED — the document's own table refutes the document's own adverb.** 0.400 → 1 and 0.700 → 1. §4 now says **monotone (never more)** and **prints the tie**. |
| *"the silence paragraph deserves its generalised rule in CLAUDE.md: **every type on a frozen surface gets a one-line derivation from the brief** … it was a **type, not a terminal**, that hid the calculator for 86 commits"* | **ACCEPTED — §8c.** The typing complement of the deletion audit, into frozen `CLAUDE.md`. **The single most valuable process output of this episode.** |

**Endorsed, untouched:** the **CL-1-at-the-echo** ruling — *"the cleanest piece of new law in the
document, and it is exactly how 'measured compute cost' enters without a fabricated number."*

---

## 12. What the author must still do

1. **Rule on §9 OPEN 11** (A5's delegation) and **§9 OPEN 12 (CANCEL `v-open`** — a dangling
   boundary tag whose subject proof (i) deletes).
2. **Sign** — `git tag -s` from the author's own shell. **The builder has made no tag.**
