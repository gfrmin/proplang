# proplang interface design: the membrane

Design document 2. Companion to `design.md`. This document specifies how a
program in the language touches anything that is not itself: sensors,
actuators, prices, other agents, and — through the same aperture — the
agent's own past. It also revises two residues from `design.md` in light of
review: the emission-combinator alphabet (§4) and the fixed myopic fidelity
(§6). Nothing here is implemented yet; §8 names the acceptance tests that
would make each claim executable, in the same currency as before.

---

## 1. One membrane, three flows, one namespace

The interface is a single typed boundary — the membrane — crossed by exactly
three flows:

```
world -> agent   FEATURES   Dict{name -> R}, published every tick
world -> agent   EVIDENCE   the subset of features some hypothesis explains
agent -> world   CHOICE     one option, selected by argmax, fired by host
```

There is deliberately no fourth flow. Prices (opportunity cost, hazard,
deadlines) are not a separate channel: they are features, names like any
other, read by `get`. The clock does not get a private wire into the agent;
it must speak the same language as every other fact about the world. This is
what made test 2 honest — the price of a tick arrived as `('get','price')` —
and it is now the rule.

The polling contract, per tick:

```
1. world publishes features F_t                (absent names read 0.0)
2. host evaluates the policy program on F_t    (pure; no effects inside)
3. the returned choice fires at the boundary   (the one irreversible step)
4. consequences arrive inside F_{t+1}          (there is no return value)
```

Step 4 is the load-bearing clause: **actions have no return values.** An
action's effect is whatever the next tick's features say it is, explained by
whatever hypothesis assigns it likelihood. A language with action return
values has two evidence channels and therefore, eventually, two reasoners;
this one has one.

## 2. Observations: explained names and context names

A feature name is *explained* by a hypothesis if some sentence in the
hypothesis emits it (assigns it likelihood); otherwise it is *context* —
read by `get` inside parameter expressions, conditioned on but not
generated. The same name can be context to one hypothesis and explained by
another, and the posterior arbitrates: a hypothesis that explains more of
the stream earns evidence on more names. This dissolves the
features-versus-observations question from the original design: there is one
namespace, and "observation" is a *role* a name plays relative to a
hypothesis, not a type.

Dormancy and graceful degradation come free and symmetric. A sentence about
a sensor that does not exist yet reads 0.0, sits inert, and costs only its
bits; when the sensor appears, evidence flows with no registration step
(grep clause: there must be no subscription machinery). When a sensor dies,
its name reads 0.0 again, hypotheses leaning on it bleed evidence, and the
posterior migrates — sensor failure is handled by Bayes, not by exception
handling.

Pricing: mentioning a name costs `log2(|visible namespace|)` at the mention
site. Every sensor added to the world raises the price of every sentence
that mentions any name. This makes the alphabet residue *incremental and
measurable*: the invariance constant between two instrumentations of the
same world is a bit-count you can print, not a philosophical apology.

## 3. Actions: affordances as data, one menu

The action alphabet is not compiled into the agent. The world publishes
**affordances** — schemas with typed, grid-priced slots — as data:

```
affordances = [ ('predict', {bit: grid{0,1}}),
                ('consult', {}),
                ('move',    {speed: grid_8}) ]
```

The agent's option space each tick is the published affordances,
instantiated (slot instantiation priced by the slot's grid, same rule as
every constant in the language), **plus the internal actions** — think,
think-deeper, generate — in the same menu, valued by the same push, chosen
by the same argmax. This is the §4/§7 doctrine of `design.md` extended to
its conclusion: there is one action space, and deliberation merely happens
to be an action whose effects are on belief rather than on the world.

Three consequences worth recording. First, a *growing world* can add an
affordance mid-episode and the agent uses it exactly when expected utility
justifies it — no re-enumeration, no version negotiation (§8, test B).
Second, parameterized affordances give continuous control through the
existing grid discipline; nothing new is priced ad hoc. Third, staleness has
a clean statement: a fired choice reflects the belief at evaluation time,
and the polling loop bounds the damage to one tick — the membrane's tick
*is* the agent's reaction time, a physical constant of the clock residue.

## 4. The emission basis, revised: one constructor

`design.md` §2 carried `bern` and `rw` as domain terminals and flagged the
arbitrariness as the alphabet residue. Review pressure (likelihoods are
themselves uncertain; conjugacy tempts us to privilege particular families)
yields a smaller, more rigorous basis: **a single kernel constructor**, the
exponential family,

```
KER ::= ('expfam', CARRIER, STATS, PARAM...)
```

where CARRIER declares the output space, STATS the sufficient-statistic
expressions (drawn from the same ATOM grammar as everything else), and the
PARAMs are ordinary parameter expressions. Then:

- `bern(p)`   = expfam over {0,1}, stats T(y)=y — a stdlib *name* (`call`)
- `gauss(m,s)` = expfam over a real carrier, stats (y, y^2) — stdlib name
- `rw(rho)`   = the unification: a *transition* kernel is just an expfam
  whose parameter expression reads a **latent name** rather than a world
  feature — `expfam(THETA, id, mean=('get','theta_prev'), scale=rho)`.
  Emission versus transition is not a type distinction; it is which names
  the parameter expression mentions.

The alphabet residue shrinks from "a list of combinators per domain" to "one
constructor plus each domain's carrier declarations," and the deletion audit
tightens: delete `expfam` and *nothing* can assign likelihood to anything.

**Likelihoods of likelihoods, both levels, no new mechanism.** Level 1 —
uncertainty over the likelihood *function* — already exists: the posterior
over programs is a distribution over likelihood functions, discrete, priced
by bits, scored by `logpredict`. Choosing between a Bernoulli story and a
different emission story was always model uncertainty. Level 2 —
uncertainty *within* a family — is a latent parameter owned by the
hypothesis: the parameter expression reads a latent name whose belief is
filtered by the same push/cond that filters everything else. What conjugacy
buys is now stated exactly:

> **CL-4 (proposed): conjugacy is an implementation of `cond`, never a
> semantic primitive.** An expfam emission with its canonical conjugate
> latent admits an O(1) sufficient-statistic update. The fast path lives
> behind the opaque Belief handle (I1 makes it invisible), and is legal iff
> extensionally equal to the generic update on the same family — enforced by
> a property test, not by trust.

So the speed of conjugate updating is real and captured, but it purchases
zero semantic privilege: a conjugate family outcompetes a non-conjugate one
only by evidence per bit, never by being cheaper to *say*. The cost of this
whole revision is measure-theoretic honesty on continuous carriers (base
measures; densities), which lands exactly where the Event/Kernel peer
decision (design §3) said the continuous debt would land.

## 5. The self through the membrane

The host echoes the agent's own signature into the next tick's features:
`last_action`, `tick`, `ticks_spent_thinking`, and any physical telemetry
(energy, temperature) the substrate exposes. No self-port, no introspection
API: **the agent reaches itself the way it reaches everything else, as
names.** A hypothesis about "my actions move this feature" is an ordinary
sentence mentioning `('get','last_action')`; a self-model is a hypothesis
that happens to explain the echoed names well; the CIRL pointer fits the
same aperture, since the human's acts are just names too.

This buys self-knowledge with zero new machinery and marks precisely where
it runs out: a hypothesis space rich enough to contain a reasoner of the
agent's own power reintroduces self-reference at the space level — open
problem 4 is not dissolved by the membrane, only given a clean address.
From outside, "agent" is a region of the world whose features happen to be
well explained by sentences mentioning its own echo; the membrane is where
we chose to draw it, and that choice is part of the pointer residue.

> **CL-6 (proposed): self-features are ordinary.** No name is privileged for
> being about the agent; sentences about `last_action` are priced, scored,
> and deleted like sentences about the weather.

## 6. Metareasoning, revised: the fidelity ladder

`design.md` §7 fixed the myopic Russell–Wefald surrogate as *the* cheap
fidelity. Review pressure: that was a larger a-priori commitment than the
architecture requires — the metareasoning can be trusted with the choice.
Revision: **estimator fidelity becomes an option.** The internal menu (§3)
contains `think(depth=k)` for k in a priced grid; the value of `think(k)` is
estimated at fidelity k−1; every rung costs ticks the world prices. The
ladder terminates for structural reasons — value is bounded, every rung
costs a strictly positive amount whenever the world's price is positive —
which is a termination *theorem* rather than a tuned depth cap.

What survives at the bottom, and cannot be eliminated: **the induction
base — level-0 estimates are taken at face value.** Estimating the value of
an estimate is itself a computation whose value would need estimating; the
regress must ground in a default that costs nothing, and "act on the current
number" is that default. The residue in `design.md` §10 is hereby narrowed:
not "myopia is assumed" but "unexamined estimates are used as-is." That is
the honest minimum; no amount of metareasoning removes it, because removing
it is a computation too.

## 7. What changes in the reference implementation

In dependency order: (1) the membrane object — features echo (`last_action`,
`tick`) and affordance publication, replacing the tests' hand-built loops;
(2) `expfam` with discrete carriers, `bern`/`rw` re-derived as stdlib names,
their old deletion-audit rows retargeted at `expfam` and at the carrier
declarations; (3) latent names in parameter expressions (unifying transition
kernels); (4) the conjugate fast path behind the Belief handle plus the
CL-4 property test; (5) the fidelity ladder in the internal menu, test 2
re-run unchanged — its result must reproduce, since myopia is now the
*chosen* rung at that price point, not the built-in one.

## 8. Acceptance tests for the membrane (proposed, same currency)

**A. Dormant sensor.** Write a sentence mentioning a name before its sensor
exists; assert bit-for-bit identical behavior until the name appears, then
evidence flows with no code change. Grep the language module for
subscription/registration machinery: none.

**B. Growing menu.** The world adds an affordance at mid-episode; the agent
adopts it if and only if expected utility justifies it, without restart.
Grep for menu-handling special cases: none.

**C. Self-signature.** A feature is secretly a function of the agent's own
last action; assert the MAP program comes to mention
`('get','last_action')` — the agent discovers itself as content, through
the ordinary posterior.

**D. Conjugacy equivalence (CL-4).** Property test: fast-path `cond` equals
generic `cond` on randomized cases within the family, to numerical
tolerance, or the fast path is rejected.

**E. Basis deletion.** Delete `expfam`: zero programs can assign likelihood
to any name. Delete a carrier declaration: that name becomes context-only,
measured evidence loss. Delete slot grids: affordances unpriceable, menu
empties.

**F. Ladder honesty.** With the fidelity ladder enabled, re-run the
lazy-genius world: at test 2's price points the chosen rung must be the
myopic one and the tick counts must reproduce (1/3/12/12); at prices near
zero with an adversarial buffer, the agent must sometimes *buy* a deeper
estimate and outperform the fixed-myopia agent — the estimator choice
earning its keep by evidence, like everything else here.
