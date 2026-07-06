# Research brief: a minimal language for an adaptive Bayesian decision-theoretic agent

**To:** the researcher taking this on
**Deliverable:** the design of a small executable language in which a Bayesian decision-theoretic agent can be *written down* — grammar, complexity measure, operational semantics, and the accompanying arguments — together with a reference implementation sufficient to demonstrate the acceptance tests in §12.
**Register:** this is a design-and-derivation task, not an engineering ticket. Where the brief asserts something, treat the assertion as a claim you are expected to reconstruct or refute, not a specification to implement on trust.

---

## 0. The one-sentence version

Build the smallest language in which an agent can represent a changing world, reason about how much to reason, and act — such that its adaptivity, its bounded rationality, and its inductive bias are all *consequences* of the language rather than modules bolted onto it. The governing brief is your headline requirement: *the agent must adapt to the world even as it changes.* The central and slightly deflating thesis of this document is that adaptivity is not a thing you build. It is a thing you make **sayable**, whereupon a single learning rule handles it for free. If at any point you find yourself writing a subroutine called `adapt`, `forget`, or `detect_change`, stop: you have misunderstood the task, and the rest of this brief explains why.

---

## 1. Why a language, and why minimal

The obvious approach — a library of Bayesian primitives called by hand-written agent code — is wrong for a reason that is easy to miss and, once seen, is decisive. The agent's hypotheses are *programs*, and the agent's prior over hypotheses is going to be the description length of those programs under whatever grammar you choose. That is the Solomonoff construction: the prior is `2^{-|program|}`, and it is the unique prior that dominates all computable priors up to a multiplicative constant (Solomonoff 1964; see Li & Vitányi for the modern treatment). The immediate corollary is uncomfortable and load-bearing:

> **The alphabet of the language *is* the prior.** Every terminal you admit costs one bit against every hypothesis that uses it. A bloated language is therefore not merely inelegant — it is a mis-specified inductive bias.

This converts minimality from a matter of taste into a correctness property, and it gives you your design method. You do not design the language by choosing features you'd like. You design it by proposing a kit and then attempting to *delete* each element, asking: does a required capability leave with it, one that would then have to be supplied by an external hand? What survives deletion is the language. What does not was content masquerading as vocabulary, stealing bits from the prior to inject an answer you were not entitled to inject.

The pleasing consequence, which you should aim for as a sign you have done it correctly, is that a language built this way is never really *designed*. It is **cornered** — reduced until it cannot be made smaller. If your final grammar feels like a set of choices, you have stopped too early.

---

## 2. The distinction that defines the task: decision theory versus an *agent*

There is a language for Bayesian decision theory, and there is a language for a Bayesian decision-theoretic *agent*, and the gap between them is the entire difficulty. Get this distinction wrong and you will build the first while believing you have built the second.

A language for decision theory is a calculator: *you* write the agent in it, and it computes over a fixed world. A language for an agent is one in which the agent writes itself, over a world that includes the agent. The noun-and-verb *count* is identical between the two — the same handful of types and operations. What differs is a single structural property:

> **The agent language must be closed under self-reference.** Its inference operations must be terminals of the grammar, so that a program can condition, predict, and optimise *over the agent's own inference as costed actions within itself.*

Everything distinctive about an agent — that it generates its own hypotheses, reasons about its own reasoning, and pays for its own thinking — is a form of this reflexive closure. None of it adds a verb. All of it requires that the verbs can take the agent's own machinery as their object. When you feel the pull to add capability, check first whether you are actually being asked to add *reflexivity*: the ability to quote an operation you already have.

---

## 3. The ontology: how few nouns?

Work in the expectation-first tradition (Whittle, *Probability via Expectation*; de Finetti, *Theory of Probability*). Take the **prevision** — a coherent expectation functional — as the atom, and derive probability from it as the prevision of an indicator. This is not a stylistic choice; it buys you the correct warrant. The justification for Bayesian updating is *coherence*, not measure theory: an agent whose credences admit a Dutch book must update by conditioning (de Finetti; sharpened for the sequential case by Lewis 1999), and finite additivity suffices for the whole argument (Regazzini 1985). σ-additivity is machinery you may reach for when a continuous carrier wants Radon–Nikodym densities; it is never the *reason* the update rule is the update rule. Keep that separation crisp, because it tells you which parts of the ontology are foundational and which are implementation convenience.

The mathematically irreducible noun-set is then **two**:

- **Space** — a set of possibilities.
- **Prevision** — a coherent linear functional on a declared space of test functions over a Space.

Two further candidates want to be primitive, and adjudicating them is your first genuine design decision — do not inherit an answer:

- **Event** — a declared proposition over a Space. In the expectation-first view this is derivable (the prevision of an indicator), and you may be tempted to leave it so.
- **Kernel** — a Prevision-valued arrow between Spaces; the agent's theory of how hypotheses generate data. In the Markov-category framing (Fritz 2020; Cho & Jacobs) this is the natural morphism, and inference is arrows composing.

Here is the tension you must resolve explicitly. Conditioning on an event and conditioning on a kernel-plus-observation are provably the same operation *for deterministic observations* (Di Lavore, Román & Sobociński, *Partial Markov Categories*, arXiv:2502.03477, Prop. 4.9). But for a stochastic kernel on a **continuous** observation space, the event "the kernel emitted exactly this value" has Lebesgue measure zero, so reducing the kernel form to the event form there requires **disintegration** — a genuine and non-trivial operation. You therefore have a real choice: either treat Event and Kernel as *peer primitives* (four types, no undefined reduction, at the cost of a slightly larger alphabet), or commit to disintegration and keep two. The honest default is the four-type peer arrangement, because shipping sugar over a mathematically undefined reduction is precisely the kind of smuggled shortcut this whole exercise exists to prevent. But make the argument yourself and record which cost you chose to pay.

---

## 4. The operations: how few verbs?

The verbs reduce harder than the nouns. In the Markov-category picture the whole of *inference* is two operations:

- **push** — compose a kernel forward; the pushforward of a belief along an arrow. Prediction is `push` into ℝ (this is the operation you will elsewhere call `expect`); the marginal likelihood is `push` too.
- **condition** — invert against evidence; the Bayesian update. This is the *unique* rule under diachronic coherence, and the unique rule under which updating and predicting commute (Amarante 2022). Everything the update needs internally — a kernel's density at a point, say — is machinery, not a user-facing primitive.

Neither of these ever produces an *action*. They only move belief around. The exit from probability into choice is a third operation, and it is categorically **not** a Markov-category arrow at all:

- **argmax** — select the action of greatest expected utility. This is the expected-utility commitment in its true form: the one verb that is not about belief. Its normative standing is Savage's representation theorem (1954; P3 shown redundant by Abdellaoui & Wakker 2020) — an agent with coherent preferences acts *as if* maximising expected utility — and its *completeness* is Wald's complete-class theorem (1950): every admissible decision rule is a Bayes rule against some prior and utility. You are not choosing EU-maximisation among options; you are implementing the only admissible family.

So the operational core is exactly **three**: push, condition, argmax. Impose the following discipline on yourself and on anyone who proposes to extend the language: *any fourth verb must be proved to be a composition of these three, or rejected.* Value of information, for instance, is not a primitive — it is the expected utility of observe-then-act minus the expected utility of act-now, a composition. "Ask the user" is not a primitive — it is an action in the action space whose expected utility happens to be high when the belief is uncertain. If a proposed verb *is* a composition, then admitting it as a primitive steals bits from the prior to privilege one derived quantity over all the others, which is content injection by another route. The stdlib may of course name these compositions for convenience; the *language* must not.

One consequence you must confront rather than defer (it recurs in §7): for the agent to reason about its own thinking, these three verbs cannot live only in the host. They must be **terminals the grammar can utter**, so that a program can write "condition again, then decide." The host still *fires* the final action and still owns all sampling (see §9); but the verbs must be *sayable*, or reflexive closure is a dead letter and you have built the calculator.

---

## 5. The prior is not an object

This is the most frequently smuggled shortcut in the entire genre, so it gets its own section. Do **not** write a prior. There must be no `prior` object, no scoring function you install over hypotheses. You write three things — a grammar, a per-terminal bit-cost, and an enumeration order — and the prior *emerges* as `2^{-|program|}`. If your researcher (that is, you) produces a module whose job is "assign prior probability to hypotheses," you have misunderstood: the prior is an accounting property of the alphabet, and any explicit prior is content injected past the grammar.

Two riders, both of which you must handle correctly:

**Fineness is already priced.** A threshold drawn from an *n*-point grid costs `log₂ n` bits to say *which* point — so description length already rises with grid fineness under this prior. A finer partition is not free; you must *not* introduce a separate "fineness penalty" axis, because you would be charging twice. Equivalently, you may let the predictive marginal likelihood do the charging — Bayesian Occam is the parameter integration, and a split that merely fits noise fails to improve the predictive. The two routes coincide *only for the marginal likelihood*; a point estimate has no Occam term and will chase refinement to infinity, at which point the prior route becomes mandatory. Know which route your implementation is on and why it is sound.

**The universality is real but not total.** The invariance theorem licenses not fretting excessively over the exact terminal encoding — change the reference machine and the prior shifts by at most a constant. But the constant is real and finite. This is the first of three irreducible residues (§10): the *alphabet* is chosen, grammar growth erodes the arbitrariness but never eliminates it, and you should name this honestly rather than pretend the encoding is canonical.

---

## 6. The hypothesis generator: the shortcut that hides inside the word "enumerate"

A calculator enumerates a fixed program space and weights it. An agent must *grow* its space, and this is where the subtlest error lives. The generator cannot be a passive `next_program()` iterator, for a reason that is genuinely deep: **you cannot price the value of a hypothesis you have not yet entertained from the prior alone.** The value of a new thought lives on the *Cromwell frontier* — the un-entertained region the prior deliberately truncates so that the tower of models-of-models does not regress — and it is visible only against the **predictive residual**, i.e. where your current posterior-weighted ensemble mispredicts the data. A generator that proposes from the prior is blind exactly where proposing is valuable.

The generator is therefore a *belief-aware decision*, made by the same `argmax` as everything else, about whether to spend compute discovering a hypothesis whose value can only be *estimated* from your own ignorance. And it comes in two irreducibly distinct kinds, which your language must keep apart or it will conflate a prior effect with a likelihood effect:

- **Compression** — re-describe hypotheses you already hold more compactly (promote a frequent subprogram to a grammar nonterminal). This is a *prior* effect: it changes description lengths, not which hypotheses exist. Its value is exactly priceable at depth one, from the grammar and a subprogram-frequency count, with no re-conditioning.
- **Exploration** — change what is *sayable* (add a feature, refine a threshold, extend the alphabet). This is a *likelihood* effect over programs not currently in the ensemble. Its value cannot be seen from the prior; it must be measured by re-enumeration and re-conditioning against the residual — the very forward inference the meta-level is deciding whether to afford.

If your design has a single "modify the grammar" primitive, it is wrong: the two draw their value from different places. But — and this is the reconciling insight — they nonetheless share **one currency**: change in log-evidence (Δ log-evidence). Compression and exploration are not two currencies; they are one currency at **two fidelities** — a cheap prior-only surrogate and an expensive re-conditioned exact lookahead. The choice of fidelity is itself an expected-utility decision on the cost of evaluation. Get this right and the generator stops being a source of programs and becomes what it should be: a costed decision about the purchase of knowledge, priced in the same units as everything else.

A named open problem sits here (see §11): pricing exploration exactly, rather than by surrogate, against arbitrary computable peer-hypotheses. It is deferrable; do not let it block the design.

---

## 7. Metareasoning: reasoning about reasoning, under a real budget

This is your headline intellectual requirement — that the agent reason about its reasoning under time, compute, and opportunity cost — and it is the reason §4 forced the verbs into the grammar. The framework is Russell & Wefald's *rational metareasoning* (1991): computations are actions in a meta-level decision problem, valued by expected improvement in decision quality. Concretely, "run condition," "enumerate deeper," "call the language-model prosthetic," and "act now" are all **terms in one action space**, valued by a single net-value functional, `E[Δvalue | action] − cost(action)`, and selected by the same `argmax` as domain actions. There is no separate meta-level machinery; there is the same `optimise` pointed at the agent's own computations. "Think more or act now" is one argmax.

For this to be *expressible*, a deliberative program must be able to quote push/condition/argmax and optimise over them — hence the decision-complete, self-referential core of §4. A program that conditions inside itself and asks whether conditioning again is worth the wait is the smallest non-trivial specimen of an agent as opposed to a calculator.

Now the part that should reassure you the regress is finite rather than turtles all the way down. **The metareasoning regress must terminate in the clock, not in a threshold.** A tuned scalar that stops the agent thinking is smuggled content — the exact failure this brief exists to prevent. Termination must instead be *physical*: the world interrupts, events arrive, opportunity cost accrues, and the anytime computation is cut off from below because *waiting has a price the world sets, not the designer.* The agent thinks exactly as long as thinking beats acting, and "beats" is well-defined precisely because the environment, not a parameter, sets the cost of delay. Metareasoning about metareasoning is just another meta-action with its own cost; it stops being worth it before it regresses, for the same reason the object level does. The tower is finite because compute is dear and the world is impatient.

Hold yourself to a specific acceptance test here, stated fully in §12: given a hard problem and a short deadline, the agent should *choose* to think less — and you should be **unable to point to the line of code that made it lazy.** If you can point to the mechanism, the mechanism is the shortcut and the agent is not reasoning about its reasoning at all; you have merely moved the smuggling up one level. The exercise succeeds when there is nowhere left to point.

---

## 8. Adaptation: the headline requirement, dissolved

Now the thing you actually asked for. An agent that adapts to a changing world does **not** get an adaptation mechanism. It gets a grammar expressive enough to *state* that the world changes, and the one update rule of §4 then learns the change like anything else. This is the whole answer, and it is worth stating in its strongest form because the temptation to violate it is relentless:

> **There is no forgetting.** Decay, likelihood tempering, sliding windows, and forgetting factors are all a *second learning mechanism* in disguise, and a second mechanism is a first mechanism mistrusted — it lets the implementation disagree with itself, which is exactly what coherence forbids. If the world drifts, the drift-rate belongs *in the hypothesis space* as a latent variable, so that `condition` infers it from data. Non-stationarity is content, not machinery.

The behaviour you want falls out of posterior dynamics with nothing added. When the world (or the user's preferences) shifts, the agent's predictions begin to fail, marginal likelihood drops, the posterior disperses, and an agent that was acting confidently becomes consultative again — *because the mathematics disperses it*, not because a monitor fired. Programs that carry temporal structure ("the world changes at rate ρ," a change-point at an unknown time, a regime-switch) will out-predict stationary programs exactly when change is real, and lose to them under the complexity prior when it is not. The complexity prior does the model selection; you do nothing.

So the design demand adaptation places on the language is purely one of **expressiveness**: the grammar must be *exactly* rich enough that non-stationarity is a sentence you can write. Not richer — a bespoke change-point subsystem would be content injection. Not poorer — a grammar that cannot say "ρ drifts" cannot adapt, and no runtime cleverness will rescue it. This is the single sharpest test of whether you have understood the brief: **you were asked to make change *sayable*, not *handled*.** If your language handles change, you have failed; if it can merely say it, you have succeeded, and the agent adapts.

(A caveat to log rather than solve: enumeration depth bounds which temporal structures are reachable, and Time-Varying CIRL (Mayer 2024) shows the θ-evolution case is under-explored. This is a limit on *reach*, not a licence to bolt on a mechanism.)

---

## 9. The remaining commitments the language must encode

These are not optional colour; each is forced by the same coherence-or-completeness logic as the core, and each constrains your grammar and type system concretely.

**Programs are options, not action sequences.** A program is a closed-loop policy in the sense of Sutton, Precup & Singh (1999): re-evaluated against the world at every step (polling execution), which they prove dominates committing to a plan. There is no sequencing primitive that fires actions open-loop; a plan that does not look at each step is not a policy but a hope. Branching (`if` on features) gives you closed-loop structure; that is all you need. Corollary: there are no "stages." Reactive, conditional, and deliberative programs are merely different *depths* in one program space, and depth is explored under the same prior that governs everything. The designer never chooses a depth.

**Features are named, not indexed.** The agent's observations are a `Dict{name → ℝ}`, not a vector. The brain must know that `:urgency` is urgency, because named, typed, factored state is what makes generalisation possible — factored MDPs (Boutilier, Dearden & Goldszmidt 2000), object-oriented MDPs (Diuk, Cohen & Littman 2008), and Konidaris's skill-symbol loop (2018), in which the symbols required for planning are *determined by* the agent's actions rather than designed. Two operational payoffs follow, and both must be true of your implementation: adding a new sensor merely adds new keys (no index shifting, nothing breaks, existing programs do not notice); and **a program referring to a feature not yet present evaluates against a default of 0.0** — it lies dormant, harmlessly false, until its connection appears, whereupon it wakes and competes. Adaptivity to a *growing* world is thus, once again, not a mechanism but a default value.

**Utility is latent and inferred; this is what makes it an agent that serves.** The agent's utility *is* the user's, unknown, inferred from behaviour — the CIRL formulation (Hadfield-Menell, Russell, Abbeel & Dragan 2016), which Shah et al. (2020) reduce to a POMDP with the preference-belief as sufficient statistic. Two things you get *for free* and must not re-implement: corrigibility is a *theorem*, not a rule — the off-switch result (Hadfield-Menell, Dragan, Abbeel & Russell 2017) shows an agent uncertain about the utility it serves treats interference as evidence and defers, with the incentive to defer proportional to belief variance; and re-elicitation after preference change is the same posterior-dispersion dynamics as §8. Two things you must flag as unsolved rather than paper over: the off-switch protection *vanishes at convergence* (a confidently-wrong agent acts confidently and wrongly), and the agent learns *revealed* preferences by default (whether to launder them into idealised ones is an observation-model choice, philosophically unresolved). Record both; do not pretend they are closed.

**No baked constants.** Every terminal must be a *decision-free combinator*: total, domain-independent, and either parameter-free or carrying a free slot the data fills, priced by the grid it is drawn from (§5). A primitive that bakes in a numeric threshold, coefficient, or decision injects an answer rather than a prior and must be rejected. Learnable constants are data-derived candidates the complexity prior charges for; they are never literals in the alphabet.

**Purity, with randomness at the boundary.** The language constructs posteriors; it does not sample. `draw` — the sole source of randomness — lives host-side, called *after* the DSL has built the belief, and is not in the language's evaluation environment. "Construct the posterior in the DSL, sample in the host" is the canonical shape. This matters beyond hygiene: nothing may select an action but expected utility. Where a mixed strategy is optimal (a zero-sum game against a peer that models you), it must be *selected* by an argmax over policies — the mixed policy strictly dominates the pure ones in security value, by the minimax theorem — never *injected* by a randomising rule. Thompson sampling, ε-greedy, and UCB are permissible only if they *emerge* as expected-utility-optimal once computation is priced; they may never be hard-coded as mechanisms alongside the argmax. (The subtlety: apparent randomisation in equilibrium is an argmax over the policy space, not a coin the agent tosses. Ranging the argmax over *policies* rather than *acts* is what recovers the mixed equilibrium without any injected noise.)

---

## 10. Three implementation invariants for the type system

These translate the philosophy into constraints a compiler can partly enforce, and a language designer needs them because they shape the types.

1. **Single reasoner.** All arithmetic on probabilities and utilities happens through the three verbs and their named compositions — nowhere else, in no host, in no application. The answer to "I need to compute X from the posterior" is *always* "declare X as a functional and call push-to-ℝ." An application that multiplies two weights to steer behaviour has become a second, uncanalised reasoner. The cleanest enforcement is architectural: if belief state is only ever held behind an opaque handle and never handed to the consumer, the consumer *physically cannot* do arithmetic on it, and the invariant holds by construction rather than by discipline. Design for that.

2. **Declared structure.** A function handed to an axiom operation must carry its algebra *in its type* — projection, linear combination, per-component dispatch, and so on — never as an opaque closure. This is a correctness requirement, not a performance one: inferred structure misfires on legitimate edge cases (probing a kernel's output to guess it is "flat" fails at genuine zero-density points), and an opaque integrand forces the engine to fall back to generic computation and to *guess*. Make the type system carry the algebra so dispatch is exact.

3. **Single-responsibility representations.** One datum, one role. The representation used for *evaluating* a program (a compiled closure) must be distinct from the one used for *analysing* it (its syntax tree); conflating them produces silent drift between a cached closure and its tree. Likewise, keep private numeric representations (log-weights) behind public accessors (probabilities) so that consumers cannot make normalisation assumptions only the belief type is entitled to make.

A related governance point, worth adopting from the outset: treat the grey-zone judgements (what counts as "arithmetic that steers behaviour" versus "arithmetic for a log line") as **case law**. Maintain a registry of precedents with stable identifiers, require any exception to name the precedent that sanctions it, and treat a new exception as an amendment made in the same change that relies on it. A constitution that hides its exceptions is a prospectus.

---

## 11. What cannot be learned, and what remains open

Be honest in the design document about the boundary of autonomy. Three residues are irreducible, and — this is the point — each is *physics rather than tuning*, which is why their presence does not compromise the claim that everything else is learned:

- **The alphabet** — the encoding the prior is relative to (§5). Grammar growth erodes its arbitrariness; the invariance constant means it never vanishes.
- **The clock** — the world's interruptions and accruing costs, which terminate the metareasoning regress from below (§7). Not a scalar you set; a rhythm the environment imposes.
- **The pointer** — the designation of *whose* utility (§9). This is the one wire that genuinely cannot be inferred from its own signal: an agent cannot deduce from behaviour *which* behaviour it should be inferring from without first being pointed at a principal.

Plus the operations themselves, trivially: laws of thought cannot be learned without a learner already in possession of them.

Genuinely open problems, to be *named* in the design document rather than silently closed (naming them is a deliverable, not an admission of failure): exact rather than surrogate pricing of exploration against arbitrary computable peers (§6); the convergence-safety gap where corrigibility evaporates as the posterior sharpens (§9); revealed-versus-idealised preference laundering (§9); and reflective closure of the hypothesis space against peers of equal computational power. On this last, note for the record that it does **not** obviously require a new axiom: the clean cases dissolve into the act-to-policy-level argmax upgrade — zero-sum by minimax, cooperative-twin by an *earned* diagonal reduction (licensed outright under identical source code, and under approximate correlation ρ only when ρ exceeds `(T−S)/[(R−P)+(T−S)]`). Treat it as a deferred open problem with a plausible dissolution, not a gap in the foundation. Your discipline throughout should be: *falsify in the engine, stall honestly at the boundary, amend the foundations only when derivation actually fails* — and never read a green experiment as a proof about the foundations, since a repository full of passing runs would mask precisely the hole the runs cannot detect.

---

## 12. Deliverables and acceptance tests

**Deliverables.**

- The **grammar**: terminals, production rules, and — for *each* terminal — a one-line proof that its deletion costs a capability that would then need external supply. Terminals without such a proof are cut.
- The **complexity measure**: the per-terminal bit-cost and the resulting `2^{-|program|}`, with the fineness accounting of §5 shown to charge once and only once.
- The **operational semantics**: programs as closed-loop options under polling execution, including the self-referential fragment in which push/condition/argmax appear as terminals and a program optimises over its own computations.
- The **decision on Event/Kernel primitivity** (§3) and the **decision on where the action verb fires** (§4), each with its argument and its acknowledged cost.
- A **reference implementation** adequate to run the tests below.
- A **residues-and-open-problems section** that names, rather than hides, everything in §11.

**Acceptance tests.** The implementation is correct when it passes these, and — equally — when the *design* survives them:

- *The changing-world test.* Present a world whose statistics shift at an unknown time. The agent must re-disperse its posterior and become consultative **without** any change-detection code in the loop. Grep the source for the mechanism; there must be none. Adaptation must be visible in the posterior and invisible in the control flow.
- *The lazy-genius test.* Give the agent a hard problem and a short deadline. It must *choose* to think less and act sooner, and you must be unable to identify the line of code that made it do so. If you can point to the throttle, it is a shortcut; remove it and try again.
- *The forgetting-factor trap.* Attempt, deliberately, to improve tracking of a drifting quantity by adding a forgetting factor. Confirm that the principled route — a latent drift-rate the update rule infers — matches or beats it, and delete the forgetting factor. This test exists to build the reflex that adaptation is content, not mechanism.
- *The deletion audit.* For every terminal, execute its deletion proof: remove it and demonstrate the lost capability. Any terminal whose removal breaks nothing was content, and its continued presence is a standing bug against the prior.

---

## 13. The disposition to bring to it

The recurring temptation across every section above is the same one, wearing different clothes: to add a primitive that *helps*. A change-detector that helps the agent track drift. A throttle that helps it stop thinking. A prior that helps it start in the right place. Every such help is a bribe paid out of the prior's pocket and a decision confiscated from the agent. The craft of this task is to keep declining the bribe until what remains cannot be made smaller — at which point you will find you have a language that adapts to a changing world, reasons about its own reasoning under a real budget, and acts optimally for its situation, and that you cannot quite say where any of those capabilities were *put*, because none of them were. They were left as the only thing that could remain once everything addable had been refused.

That is the target. Not a clever agent, but a cornered one.
