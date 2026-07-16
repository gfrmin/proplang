# stream-author-pack.md — step 6: actions in the feature stream, no lag

Builder pack for the author. Part I is SCOPING: nothing frozen moves,
no oracle exists yet, and — by the author's own rider on decision 6 —
**the 6b falsifier's success criteria are stated in §6 of this Part and
committed BEFORE the world runs**. The commit that lands this file is
the provenance that pre-stated means pre-stated. Parts II+ (the E-b1
and 6b transcripts, the oracle draft, the register as-executed) follow
in later commits.

Repo at opening: HEAD e61faa8 (actions-freeze-r1, signed + verified,
"the sentinel stays buried"), eleven suites green, gates 1–7 PASS,
MANIFEST.sha256 71/71 OK.

---

## Part I — scoping, wave, design, the register

### §1. The step, verbatim (controlling texts, with provenance)

**AGENT_PLAN.md:905 (the step):**

> 6. **Actions in the feature stream, no lag.** Latent-carrying
>    hypotheses do the memory.

**AGENT_PLAN.md:906–911 (the opening-checklist row, scheduled at the
step-5 freeze):** the g4Self self-signature deliverable RETURNS here —
"the C-world re-declared with its action in the feature stream, the
competitor control intact."

**AGENT_PLAN.md:912–915 (the re-sequenced decision 6):**

> The scoring RULE is OPEN (RIDER 3), and **6b runs INSIDE this step's
> oracle phase** … whichever scoring rule survives the falsifier is
> what the step-6 oracle pins — the freeze never encodes a rule its
> own falsifier convicts.

**AGENT_PLAN.md:918–923 (RIDER 2 binds here):**

> the hello's namespace includes every writable name from this step's
> freeze onward, so mention prices are over the completed namespace
> from the first increment that can utter them. **Obligation: this
> step's oracle contains NO assignment-priced row — mention prices
> bind at 6, value prices at 7 — else the pins pay R-C4's
> double-repricing a second time.**

**AGENT_PLAN.md:924–931 (6b, with the author's rider):**

> **A confounded-payoff world; measure whether AND WHEN exploration
> pressure rescues the choice** — and at what regret. If evidential
> scoring is dominated for as long as the confound persists, *"the
> posterior arbitrates"* is a consolation, not a design. **Stop and
> report if it is.** **Rider (the author, decision 6): the success
> criteria are PRE-STATED NUMERICALLY — what counts as dominated, and
> over what horizon exploration must rescue the choice — before the
> world runs; no adjudication by eyeball.**

**AGENT_PLAN.md:350–356 (RIDER 3, the mechanism on trial):**

> "Push-at-assignment is **evidential** scoring: nothing stops the
> enumerator producing hypotheses with action–latent correlation (**it
> must**, to model the confound §3 honestly names), and then
> conditioning on a contemplated action updates latents **through the
> back-channel** — **smoking-lesion territory, where the agent manages
> the news rather than the world.** 'The posterior arbitrates,
> exploration escapes' is an **asymptotic** defence; **the transient
> can be dominated for as long as the confound persists.**"

**AGENT_PLAN.md:406–414 (proof (ii), what already stands):** over
namespace `{t, action}` the shipped enumerator produces 1241 models of
which 72 are action models; after 60 ticks of ordinary `cond` the
agent learns P(obs=1|action) to (0.103, 0.897) against truth (0.1,
0.9). Proof (ii) shows the agent LEARNS its action's effect; it does
not show the evidential scoring rule is correct (the plan's own note
at :916–917).

### §2. What the step is, in one paragraph

At step 5 an action became an assignment of values to declared
writable names; the world moved (`wStep`) but the hypotheses never saw
what the agent did. At step 6 the chosen assignment's (name, value)
pairs JOIN THE TICK'S FEATURE STREAM: hypotheses whose namespaces
include writable names read the agent's own actions exactly as they
read sensors — dormancy semantics, no new mechanism — and
consequence-knowledge flows back into choice by scoring each candidate
assignment through the hypotheses (push-at-assignment). "No lag" means
the assignment taken at tick t is visible to the hypotheses at tick t;
delayed consequences are carried by latent-carrying hypotheses
(interface.md's transition kernels reading an action name), so how far
back the past matters is learned and priced, never hard-coded. The
scoring RULE — what "scoring a candidate through the hypotheses"
means when hypotheses correlate action with latent — is the open
question 6b exists to settle, and it is settled by measurement before
the oracle pins anything.

### §3. The falsification-wave census

Universe: the 71-row MANIFEST.sha256 (custody record) plus the
declared non-manifest surfaces (`src/`, the governing docs), per the
sweep-universe clause. Method: grep over the manifest's artifacts for
the surfaces this step touches (`runMembrane`, `interpretPilot`,
`argmaxEU`, `wMenu`, menu-bearing worlds), then classification.

**Surfaces that move (implementation, after the freeze):**

- `src/PropLang/Membrane.hs` — the only src file with owed edits:
  1. `runMembrane`: `observe` sees `feats ++ c` (the append; §4 D-b1).
  2. `interpretPilot` (`PilotEU` arm): per-assignment scoring — the
     predictive is computed per candidate, not once (§4 D-b4); the
     rule inside it is whatever 6b's survivor is (§6).
  Both edits live inside the existing agent-facing CPP guard
  (`!DROP_EXPFAM && !DROP_CARRIER_OBS && !DROP_ARGMAX`); the deletion
  coupling recorded at step 5 carries forward unchanged.
- `src/PropLang/{Belief,Syntax,Eval,Enumerate}.hs` — **no edits
  owed.** No alphabet change at 6: mention prices need no new code
  (`bitsIn` is already namespace-relative; test-membrane g5 pins
  lg 19 + lg k per mention), and `enumerateSentencesIn` already takes
  `extras :: [(Name, Grid)]`, so action-mentioning hypothesis spaces
  are a fixture-side declaration, not an engine change. (If 6b's
  surviving rule turns out to REQUIRE an action-emission production —
  see §6 outcome (c) — that is an alphabet question and comes back to
  you priced, at a new register row, before any freeze.)
- `src/PropLang/Host.hs` — untouched (the host-less window holds;
  exit at step 7).

**Frozen suites at risk — the behavioral rows whose worlds run
menu-bearing `runMembrane` (the complete list, by grep):**

| frozen row | world | why it survives (the claim E-b1 measures) |
|---|---|---|
| test-membrane/Membrane.hs:264,275 (t1 probes ×2) | predWorld + t1Menu, PilotEU util1M, 160 ticks | agent is ns0 (`enumerateSentences fragFull`); no code Gets "opt" |
| test-membrane/Membrane.hs:390,399 (B1, B2) | bWorld + bMenuAt, PilotEU utilB, 20 ticks | ns0 agent; no code Gets "move" |
| test-actions/Actions.hs:131,140,147 (tie, all-tied, idle) | predW + menus, 20/3/3 ticks | ns0 agent; no code Gets "lever" |
| test-actions/Actions.hs:155 (menuless) | predW, no menu, 10 ticks | the append is `feats ++ []` — identity by construction |

The survival mechanism is DORMANCY, already law: `Eval.hs:87` reads
`Get nm -> fromMaybe 0.0 (lookup nm feats)` — a present name unread by
any code changes nothing; and per-assignment scoring collapses to the
shipped single-predictive scoring when every candidate's appended
names are unread (all candidate rules coincide on ns0 worlds, for the
same reason — stated in §5, measured by E-b1). All other manifest
rows (pricing, sentence, code, optlaw, expfam, hygiene, prepost, cirl,
properties) never enter `runMembrane` with a menu; unaffected.

**New artifacts:** `test-stream/` (the twelfth suite) + its
stanza.cabal.draft; the g4Self return rows live THERE — the frozen
test-membrane file never grows.

**Docs:** membrane-wire.md is NOT touched at 6 (the wire sentence
lands at 7, AGENT_PLAN:933–937 — RIDER 2's semantics binds engine-side
from this step's freeze, its wire text is step 7's). CLAUDE.md only if
this step buys a new canonized line (author-only, at the freeze).

The wave is SMALL and the risk is concentrated: one src file, five
behavioral rows surviving on a measured claim, and the design risk is
6b itself.

### §4. The design (the register's rows, recommendations marked)

**D-b1 — the tick geometry.** Where in the tick does the assignment
join the stream? The tick's order is frozen behavior: features →
predictive/entropy (recorded) → options → choice → observe → wStep.
The choice does not exist when `ttP1`/`ttEntropy` are computed, so
they stay records of the agent's PRE-CHOICE state at the world's bare
features. The append lands at `observe`: the evidence at tick t is
scored against `feats ++ c` — the hypotheses see what the agent did at
the tick it did it (no lag), and the sensor reading they explain
arrives at the same tick. `wStep` is unchanged (the world already
receives `c` whole). RECOMMENDATION: as stated; the trace type does
not change.

**D-b2 — the collision rule.** `Get` is first-occurrence-wins
(Eval.hs:87), so the append ORDER is the collision semantics. A
conforming world never collides (a name is a sensor or writable, not
both — the disjointness sentence belongs to the wire text at step 7,
beside RIDER 2's namespace sentence). For the engine at 6 the order
must still be picked: RECOMMENDATION `feats ++ c` (world-first) — the
stream remains the world's document, and on a nonconforming collision
the world's published reading wins, which is CL-1-at-the-echo's
spirit (the world may measure and publish the agent however it likes;
its publication is authoritative). The alternative (`c ++ feats`,
agent-first: "the agent cannot be lied to about its own act") is
coherent; the register asks you to pick. Either way the choice is
behavior only for worlds that violate a rule the wire will state.

**D-b3 — THE SCORING RULE: OPEN, pinned only after 6b.** By the
re-sequenced decision 6, no recommendation is made here — §6 specifies
the candidates and the world that races them, and the criteria that
pick. What CAN be stated now, engine-fact, is the expressiveness
asymmetry: the exogenous-read rule is what the engine already says
(the D8 read at augmented features — a per-query conditioning on
denotation, meta weights untouched); the evidential rule is NOT
expressible in the shipped engine at all, because conditioning the
joint on "action = a" needs per-hypothesis likelihoods OF THE ACTION,
and no fragment production emits actions — codes read features. 6b
therefore builds the back-channel by hand in the prototype (R-D21
permits any throwaway realization), and one of its possible verdicts
is that the inexpressible rule is also the wrong one — in which case
the engine's poverty is a design fact worth printing, not fixing.

**D-b4 — the per-assignment scoring surface.** `argmaxEU` today takes
ONE predictive (`Expr '[NonEmpty o, B y, Util o y] o`). Step 6's
scoring needs a belief PER candidate. Two shapes:
  (a) **options-as-data**: the option type instantiates at pairs —
  the pilot builds `(a, predictive (feats ++ a) ag)` per candidate
  and the SAME argmaxEU program selects over the pairs, the utility
  reading the pair. No new alphabet, no new Expr form; the program
  that selects is still the doctrinal argmax-EU expression.
  (b) a new first-order StdName (a kernel-applying EU) — an ALPHABET
  change, priced, P5 fires.
RECOMMENDATION: (a). Step 6 owes no alphabet change (§3), and (a)
keeps "nothing may select an action but expected value, as a program"
true with the existing program. If the author prefers the selection
arithmetic itself to be sayable as one sentence (the kernel from
option to belief inside the Expr), that is (b) and it arrives priced
at a named boundary — the register asks.

**D-b5 — RIDER 2 engine-side at 6.** No engine change owed: prices
are already namespace-relative per mention. The binding lands
FIXTURE-SIDE: every step-6 oracle world with a menu declares its
COMPLETED namespace (sensors + every writable name) and enumerates
with the writable names' grids among the extras — so action-mentioning
guards exist, counts/nsB move for those worlds (new population
arithmetic, fixture-side only), and the frozen ns0 worlds are
untouched. THE NEGATIVE OBLIGATION, stated where it will be checked:
**this step's oracle contains NO assignment-priced row** — mention
prices at 6, value prices at 7 (AGENT_PLAN:921–923).

**D-b6 — the g4Self return (the scheduled checklist row).** The
C-world re-declared with its action in the stream, competitor control
intact: features `[t, z]`; ONE writable name (the step-5 D-a2 shape),
menu `[("a", two-point grid)]`; the scripted threshold pilot on `z`
(the test's claim is the posterior's, not the policy's — the original
g4's own words); hypothesis space `enumerateSentencesIn` over ns
`{t, z, a}` with extras `[("z", zGrid), ("a", aGrid)]`; the yC stream
correlated with the ACTION so the MAP mentions `('get', "a")`
decisively, and the shifted160 control world hands the MAP to the
changepoint story BY STRUCTURE (the retired rows' standard,
2f524e3:test-membrane/Membrane.hs:429–452). Fixtures regenerated by a
gen_fixtures.py descendant, sanity-simulated, committed with the
oracle. The rows live in test-stream/; the retired fixture streams
remain reconstructible from test-membrane history as recorded.

**D-b7 — silent ticks.** `observe` is skipped when `wEvidence` is
`Nothing`, so a silent tick's action is never folded into beliefs —
there is no mechanism to condition on features without an
observation, and fabricating one would be refutation-by-prediction's
sibling. RECOMMENDATION: observation-gated, printed as a scope note
on `runMembrane`'s haddock (a world that wants the agent's silent
actions remembered publishes a sensor on them — CL-1-at-the-echo
again).

### §5. E-b1 — the name-blindness two-route (the wave's measurement)

CLAIM (the §3 table's survival column): on every frozen menu-bearing
world, the step-6 loop shape — append at observe AND per-assignment
scoring — produces traces Double-exactly equal to the shipped loop's,
because the agents are ns0 (no code Gets a writable name), dormancy
reads appended-but-unread names as absent, and per-assignment
predictives collapse to the single predictive for the same reason.
COROLLARY stated before measuring: on ns0 worlds ALL candidate scoring
rules coincide (evidential conditioning is vacuous where no hypothesis
carries an action channel), so E-b1's verdict is rule-independent and
6b's outcome cannot retroactively move it.

PROGRAM (R-D21 throwaway, two-route): a prototype Membrane carrying
the step-6 loop, run beside the shipped `runMembrane` on the §3
table's six rows' worlds (t1-menu ×1 world, B ×2 pilots, tie,
all-tied, idle, menuless; plus one no-menu control — aWorld/PilotIdle
— where the append is vacuous by construction). Diff the full traces
(`ttT, ttP1, ttEntropy, ttAct, ttLossBits`) and the final MAP/meta.
EXPECTATION, pre-stated: zero differences, `==` on Double, every row.
Any nonzero diff is a wave-census failure: stop, re-scope §3, no
freeze.

E-b1 is not criteria-adjudicated (nothing is on trial; it verifies a
mechanism the engine already pins as dormancy) and runs immediately
after this Part commits. Transcript lands in Part II.

### §6. 6b — THE FALSIFIER (the register's heart)

**What is on trial.** The evidential scoring rule: score a candidate
assignment by conditioning the agent's JOINT posterior — hypothesis
weights and within-hypothesis latents — on the contemplated action
itself, through hypotheses that model the action's own generating
process. RIDER 3's mechanism: where hypotheses carry action–latent
correlation, that conditioning moves the latent through the
back-channel, and the agent manages the news rather than the world.

**Why the world must be episodic.** The back-channel bites only while
the latent is UNCERTAIN at decision time. In a single-episode world
any latent worth −10/tick is pinned down by its own harm history long
before the transient can be measured; the confound must be re-armed.
So: the latent is drawn FRESH each episode; what persists across
episodes is the learned action–latent correlation (the disposition
parameters) — which is exactly RIDER 3's confound, and its persistence
is measurable as a posterior quantity.

**The world (locked here; numbers are design arithmetic, not tuning):**

- Episodes e = 1..E, E = 60, each T = 10 ticks. Per episode a hidden
  lesion L_e ~ Bernoulli(0.5), never directly observed.
- One writable name: a ∈ {0, 1} per tick ("smoke"; menu grid `0 :| [1]`,
  wait = 0 by §5c).
- Per tick, a harm event c_t ~ Bernoulli(0.3) if L_e = 1, else c_t = 0.
  **c is causally independent of a** — that is the world's whole point.
- Per-tick payoff (utility, and the observation stream the agent
  learns from): u_t = a_t·(+1) − c_t·10. The agent observes (a_t, c_t)
  — its own action is in its stream (this IS step 6's semantics) —
  and updates every tick.
- Phase 1 (episodes 1..E0, E0 = 10): the action is WORLD-SCRIPTED by
  disposition — a_t ~ Bernoulli(0.9) if L_e = 1 else Bernoulli(0.1).
  This is the habituation record every rule inherits: in it, smoking
  genuinely correlates with harm, without causing any.
- Phase 2 (episodes 11..60, = 500 decision ticks): the raced rule
  chooses a_t each tick.
- ORACLE (the regret floor): a_t = 1 always — +1 unconditionally,
  harm unaffected. On matched randomness the per-tick regret of any
  rule is therefore EXACTLY 1[a_t = 0]: **regret = the count of
  refrain-ticks.** Deterministic given choices; no variance argument
  needed on the regret side.

**The hypothesis class (hand-built; the fragment cannot utter
action-emitting models — that inability is register fact D-b3, and
R-D21 lets the prototype carry what the grammar cannot yet say).**
All weights uniform at birth; exact Bayes throughout (per-hypothesis
within-episode filtering over L_e, episodic marginal likelihoods
folded into weights — no approximations at this scale).

- DISP(δ1, δ0, h1, h0): latent L_e ~ Bern(0.5) per episode;
  P(a=1|L) = δ_L (the action channel — models the HISTORICAL action
  process, phase-blind, exactly as an enumerator would);
  P(c=1|L) = h_L; **c does not read a.**
  δ1, δ0 ∈ {0.1, 0.5, 0.9}; h1, h0 ∈ {0, 0.15, 0.3} → 81 hypotheses.
  The TRUTH is in the class: DISP(0.9, 0.1, 0.3, 0).
- DIRECT(γ): no latent; P(a=1) = 0.5 flat; P(c=1|a=1) = γ,
  P(c=1|a=0) = 0 ("smoking directly harms").
  γ ∈ {0.15, 0.3} → 2 hypotheses. 83 total.

**The rules raced (all three see identical streams; all update on
every realized (a_t, c_t), including their own phase-2 choices —
hypotheses model the record, and at step 6 the record contains the
agent's actions; that self-referential fold is not a bug but the
question):**

1. EVIDENTIAL: for candidate a, condition the joint on a_t = a
   through the action channels (w_h · P_h(L|episode history) ·
   P_h(a|L), renormalized), then E[u] = a − 10·E[P_h(c|L, a)].
2. EXOGENOUS-READ (the engine's shape, D8): the joint at CURRENT
   weights, the candidate entering only as an input to channels that
   read it: E[u|a] = a − 10·Σ_h w_h Σ_L P_h(L|history)·P_h(c|L, a).
   (Only DIRECT's c-channel reads a; DISP's does not.)
3. ORACLE: a = 1, always.

Ties break to the first-listed option (= wait = 0), the frozen CL-3
rule — deliberately adversarial to the rules on trial.

**The confound-persistence indicator (pre-stated, a posterior
quantity of the evidential agent itself):** at tick t, gap_t =
E[δ1] − E[δ0] under the evidential agent's own posterior over DISP
(DIRECT's mass excluded from the mean; its mass reported separately).
The confound PERSISTS at t iff gap_t ≥ 0.2. (0.2 = one quarter of the
true gap 0.8; below it the back-channel moves P(L_e) by less than the
harm channel's single-observation resolution — a dead confound by
construction, not by eyeball.)

**r1 AMENDMENT (after the first run; the defect, the theorem, and the
fix — committed before the re-run, exactly as r0 was committed before
the first).** The r0 persistence indicator (gap_t = E[δ1] − E[δ0])
is IDENTICALLY ZERO by a symmetry of the design, proven not measured:
the latent's label is unidentified — DISP(δ1, δ0, h1, h0) and its
label-swap DISP(δ0, δ1, h0, h1) assign the same likelihood to every
stream (P(L)=0.5 is symmetric), so the posterior splits evenly
between mirror modes and the SIGNED mean cancels. Diagnostic (seed 0
after phase 1): the truth and its mirror at 0.4483 each; signed gap
+0.0000; label-invariant E[|δ1−δ0|] = 0.8000 (the correlation is
fully learned); cross-moment E[(δ1−δ0)(h1−h0)] = +0.2276 against
truth's 0.24. The first run therefore returned N1 vacuously false
(zero confounded ticks) while the pathology was plainly present
(evidential refrain 16.7% of phase-2 ticks, mean regret 83.4 vs
exogenous-read's 0.0) — the committed test could not fire N3 under
ANY behavior, which is a defect in the indicator, not a verdict.
THE FIX, and the only change: the persistence indicator becomes the
label-invariant cross-moment κ_t = E[(δ1−δ0)(h1−h0)] (DISP mass
renormalized; DIRECT mass reported separately) — invariant under the
label swap because both factors flip sign, and it measures exactly
what drives the back-channel: the posterior's belief that the action
associates with the harm-bearing latent value. Threshold: κ_t ≥ 0.06
= one quarter of the true cross-moment 0.24 — the same
quarter-of-truth discipline the r0 threshold used. **Every other
number and clause below stands byte-unchanged; both runs' transcripts
go to the sitting.**

**THE CRITERIA (pre-stated numerically; N = 200 seeded runs; phase-2
= 500 ticks/run; run before nothing — this section is committed
before any execution):**

- **N1 (DOMINATED).** Evidential is dominated-while-confounded iff,
  restricted to its confounded ticks (r1: κ_t ≥ 0.06), its refrain rate
  ≥ 0.5 while exogenous-read's refrain rate over its OWN phase-2
  ticks is ≤ 0.1, in ≥ 90% of seeds. (Per-tick regret is exactly the
  refrain indicator, so this is "evidential pays ≥ 0.5/tick where the
  confound lives, exogenous-read pays ≤ 0.1/tick" — a ≥ 0.4/tick gap,
  ~27 standard errors of the N·500 tick mean at worst-case choice
  variance, so no noise argument can rescue a failure.)
- **N2 (RESCUE).** Exploration/learning rescues evidential iff there
  is an episode e* ≤ 40 (i.e., ≤ 30 phase-2 episodes in) such that
  from e* onward evidential's smoke rate is ≥ 0.95 (mean over seeds),
  AND its mean total phase-2 regret is ≤ 100 (≤ 0.2/tick averaged
  over the 500). Both legs; a rescue that arrives after paying half
  the act gap forever is not a rescue.
- **N3 (STOP-AND-REPORT).** N1 holds AND N2 fails ⇒ evidential
  scoring is dominated for as long as the confound persists ⇒ the
  RIDER 3 clause fires: **stop and report.** The step-6 oracle does
  not pin evidential; the transcript, not the builder, carries the
  verdict to the sitting.
- **N4 (the survivor's own bar).** Exogenous-read is vindicated only
  if its mean phase-2 per-tick regret is ≤ 0.1 in ≥ 90% of seeds. If
  BOTH rules fail their bars, the world has convicted the DESIGN, not
  a rule — that too is stop-and-report, with the transcript.

**The possible outcomes, named before the run:**
(a) N3 fires → stop-and-report; the sitting decides (the plan's canon:
manipulation-shaped problems need path-specific objectives, not
alphabet rules — what that means for step 6 is the author's ruling,
not the builder's).
(b) N1 fails or N2 holds with N4 also holding → the surviving rule(s)
go to the sitting with the transcript; the oracle pins the survivor.
(c) Any outcome in which the WINNING rule requires machinery the
fragment cannot utter (an action-emission production) is an ALPHABET
question and comes back priced at a named boundary before any freeze.
Note the engine-fact asymmetry (D-b3): the engine as built can only
say exogenous-read; if evidential WINS, (c) fires necessarily.

### §7. The under-determination register (summary for the sitting)

| row | question | recommendation | status |
|---|---|---|---|
| D-b1 | tick geometry of the append | observe at `feats ++ c`; trace records stay pre-choice | REC |
| D-b2 | collision rule / append order | world-first (`feats ++ c`); disjointness = wire text at 7 | REC, author picks |
| D-b3 | THE SCORING RULE | none — 6b decides (§6); engine-fact: evidential is inexpressible as built | OPEN by order |
| D-b4 | per-assignment scoring surface | options-as-data; no alphabet change at 6 | REC |
| D-b5 | RIDER 2 engine-side | fixture-side only; NO assignment-priced oracle row | REC (obligation) |
| D-b6 | g4Self return shape | C-world re-declared, one writable name, control intact, rows in test-stream/ | REC |
| D-b7 | silent ticks | observation-gated; scope note printed | REC |

### §8. What runs next, and what waits for the key

Immediately after this Part commits: E-b1 (§5), then 6b (§6) — both
R-D21 throwaway prototypes, transcripts appended as Part II in the
same builder-signed custody. Then the sitting: the register above +
the 6b verdict; then the oracle draft (test-stream/, runtime-red,
satisfiability transcripts, stanza draft); then the freeze gate. The
only stops are the sitting's rulings and your key — per the standing
pacing order, everything between them proceeds.

---

## Part II — the evidence, executed (E-b1 and 6b transcripts, verbatim)

### §9. E-b1 — the name-blindness two-route: 8/8 IDENTICAL

Prototype: the step-6 loop (observe at `feats ++ c` AND per-assignment
exogenous-read scoring through the public EU verb, mirroring the
Argmax evaluator's exact tie discipline) raced against the shipped
`runMembrane` on every frozen menu-bearing behavioral world plus two
no-menu controls. One substitution against §5's list: the no-menu
control is the t3 parity world (predWorld, PilotIdle, 400 ticks,
drift400 — longer and load-bearing) in place of aWorld, whose fixture
streams would have needed copying; same class, stronger control.
Verdict per row = full-trace `==` (every `ttT/ttP1/ttEntropy/ttAct/
ttLossBits` Double) AND final meta-entropy `==`:

```
OK   t1 probes world (membrane g1: predWorld+t1Menu, PilotEU util1M, 160, shifted160)  ticks=160  traces==: True  finalMetaEntropy==: True
OK   B1 world (membrane g3: bWorld, PilotEU (utilB 0.2), 20)  ticks=20  traces==: True  finalMetaEntropy==: True
OK   B2 world (membrane g3: bWorld, PilotEU (utilB 0.9), 20)  ticks=20  traces==: True  finalMetaEntropy==: True
OK   tie world (actions g2: predW+tieMenu, PilotEU utilTie, 20, shifted160)  ticks=20  traces==: True  finalMetaEntropy==: True
OK   all-tied world (actions g2: predW+ea2Menu, PilotEU constU, 3, shifted160)  ticks=3  traces==: True  finalMetaEntropy==: True
OK   idle world (actions g2: predW+ea2Menu, PilotIdle, 3, shifted160)  ticks=3  traces==: True  finalMetaEntropy==: True
OK   menuless world (actions g2: predW, PilotIdle, 10, drift400)  ticks=10  traces==: True  finalMetaEntropy==: True
OK   no-menu control (membrane g1 t3 parity world: predWorld, PilotIdle, 400, drift400)  ticks=400  traces==: True  finalMetaEntropy==: True
E-b1 VERDICT: 8/8 rows identical — the frozen behavioral rows survive the step-6 loop, measured
```

The §3 census's survival column is now measured. The pre-stated
expectation (zero differences, every row) held exactly; the wave is
what the census said: one src file, five surviving rows, no frozen
movement.

### §10. 6b, first run — against the r0 criteria as committed at b721bb2

```
6b — the confounded-payoff falsifier (criteria committed at b721bb2)
seeds=200  episodes=60 (scripted 10)  ticks/episode=10  phase-2 ticks/seed=500

confound persistence: 0.0% of phase-2 ticks have gap>=0.2 (seed-mean gap ep11=-0.000, ep60=0.000); seeds with NO confounded tick: 200
evidential : mean phase-2 refrain rate 0.167  mean total regret 83.4
exogenous  : mean phase-2 refrain rate 0.000  mean total regret 0.0
evid smoke rate by episode (11..60):
  0.65 0.66 0.68 0.70 0.73 0.72 0.75 0.77 0.78 0.80 0.80 0.82 0.83 0.84 0.84 0.84 0.85 0.85 0.85 0.85 0.85 0.85 0.86 0.86 0.86 0.87 0.86 0.86 0.86 0.87 0.87 0.86 0.87 0.87 0.87 0.87 0.87 0.88 0.87 0.87 0.87 0.88 0.88 0.87 0.88 0.88 0.87 0.88 0.87 0.88
confound gap by episode (11..60):
  -0.00 -0.00 -0.00 -0.00 -0.00 -0.00 -0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00 0.00

N1 (dominated-while-confounded): FAILS (0.0% of seeds; bar >=90%)
N2 (rescue): FAILS (e*=None; bar e*<=40 AND mean total regret 83.4 <= 100)
N3 (stop-and-report): does not fire
N4 (exogenous-read vindicated): HOLDS (100.0% of seeds at <=0.1/tick; bar >=90%)

VERDICT: the surviving rule(s) go to the sitting with this transcript.
```

The run exposed the r0 indicator's label-swap symmetry (the §6 r1
amendment records the theorem and the seed-0 diagnostic: truth and
mirror at 0.4483 each, signed gap +0.0000, E[|δ1−δ0|] = 0.8000,
cross-moment +0.2276). N1 was vacuously unfireable; the behavior
itself already showed the pathology (refrain 16.7%, regret 83.4 vs
0.0). The amendment (16de2c0) swapped ONLY the indicator, committed
before the re-run.

### §11. 6b, r1 run — against the amended indicator, all else byte-unchanged

```
6b — the confounded-payoff falsifier (criteria committed at b721bb2)
seeds=200  episodes=60 (scripted 10)  ticks/episode=10  phase-2 ticks/seed=500

confound persistence: 97.8% of phase-2 ticks have kappa>=0.06 (seed-mean kappa ep11=0.218, ep60=0.107); seeds with NO confounded tick: 0
evidential : mean phase-2 refrain rate 0.167  mean total regret 83.4
exogenous  : mean phase-2 refrain rate 0.000  mean total regret 0.0
evid smoke rate by episode (11..60):
  0.65 0.66 0.68 0.70 0.73 0.72 0.75 0.77 0.78 0.80 0.80 0.82 0.83 0.84 0.84 0.84 0.85 0.85 0.85 0.85 0.85 0.85 0.86 0.86 0.86 0.87 0.86 0.86 0.86 0.87 0.87 0.86 0.87 0.87 0.87 0.87 0.87 0.88 0.87 0.87 0.87 0.88 0.88 0.87 0.88 0.88 0.87 0.88 0.87 0.88
confound gap by episode (11..60):
  0.22 0.22 0.21 0.21 0.20 0.19 0.18 0.17 0.16 0.15 0.14 0.14 0.13 0.13 0.13 0.12 0.12 0.12 0.12 0.12 0.12 0.12 0.12 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11 0.11

N1 (dominated-while-confounded): FAILS (0.0% of seeds; bar >=90%)
N2 (rescue): FAILS (e*=None; bar e*<=40 AND mean total regret 83.4 <= 100)
N3 (stop-and-report): does not fire
N4 (exogenous-read vindicated): HOLDS (100.0% of seeds at <=0.1/tick; bar >=90%)

VERDICT: the surviving rule(s) go to the sitting with this transcript.
```

Sitting-grade distribution diagnostics (same run):

```
evidential confounded-tick refrain rate over seeds: min 0.044  median 0.178  mean 0.171  max 0.317
seeds with rate >= 0.5: 0 / 200
evidential per-seed total regret: min 13  median 89  max 112
```

### §12. The builder's read (the verdict, and what it is not)

**What the criteria say.** The confound PERSISTS for essentially the
whole run (κ ≥ 0.06 on 97.8% of phase-2 ticks; seed-mean κ decays
0.22 → 0.11 and plateaus — it never dies). Against that persistent
confound: N1 FAILS (no seed's confounded-tick refrain rate reaches
even 0.35, against the 0.5 bar — evidential pays a steady leak, not
domination); N2 FAILS on its rescue leg (the smoke rate asymptotes at
~0.88 and never reaches 0.95 — THERE IS NO e*; the regret leg alone,
83.4 ≤ 100, cannot carry it); N3 therefore does not fire; N4 HOLDS at
full strength (exogenous-read pays ZERO regret in 100% of 200 seeds).
Outcome (b) of §6: the surviving rule goes to the sitting.

**What the measurement showed beyond the criteria (observations, not
adjudication).** RIDER 3's mechanism is real and now has numbers: the
back-channel produces sustained news-managing refrains — the
evidential agent re-pays the fresh-episode transient EVERY episode
(~1.2 refrain-ticks per 10, forever), and the asymptotic defence
("the posterior arbitrates, exploration escapes") measurably fails as
an escape: no exploration pressure exists in the myopic argmax, the
confound self-sustains partly through the agent's own
disposition-scored actions, and the rescue never arrives. Evidential
was not DOMINATED at the pre-stated bar — but it has nothing to
recommend it in this world class: it can only lose here (0 seeds
where it beats exogenous-read; median 89 regret against uniform 0),
and it is inexpressible in the shipped fragment anyway (D-b3's
engine-fact). The falsifier did not convict evidential of
catastrophe; it convicted it of being strictly worse, permanently,
while the rule the engine already speaks was exactly right.

**The builder's recommendation for D-b3, now evidence-backed:** pin
EXOGENOUS-READ as step 6's scoring rule — per-assignment predictive
at the D8 read (the candidate as feature input; meta and latents at
current weights; conditioning happens only at observe). The pin is
extensional and oracle-borne: the step-6 oracle's behavioral rows are
computed under this rule, and any future rule change moves pinned
anchors — stop-and-report by construction. RIDER 3's OPEN status
resolves to: A6 stands epistemic; "no do()" is now MEASURED policy at
this boundary, not a definition — the falsifier and both transcripts
are the provenance, and the door stays open exactly as §6 outcome (c)
wrote: any future rule needing action-emission productions is an
alphabet question, priced, at a named boundary.

### §13. The decision sheet (the sitting's rulings, each with its evidence)

| ruling | question | recommendation | evidence |
|---|---|---|---|
| D-b1 | tick geometry | observe at `feats ++ c`; trace records pre-choice | E-b1 8/8 under exactly this geometry |
| D-b2 | append order / collisions | world-first; disjointness = wire text at 7 | design argument §4 (CL-1-at-the-echo); behavior identical for conforming worlds |
| D-b3 | THE SCORING RULE | **exogenous-read** (the D8 shape) | 6b r1: N4 100%, evidential 0-for-200 with no rescue; both transcripts |
| D-b4 | scoring surface | options-as-data; no alphabet change | §4; E-b1 ran this shape through the public EU verb |
| D-b5 | RIDER 2 at 6 | fixture-side; NO assignment-priced oracle row | AGENT_PLAN:921-923 (obligation, not preference) |
| D-b6 | g4Self return | C-world re-declared, one writable name, control intact, rows in test-stream/ | 2f524e3 provenance; fixtures regenerated at oracle drafting |
| D-b7 | silent ticks | observation-gated; scope note printed | §4 (no mechanism without an observation) |

### §14. Next

The oracle draft (test-stream/): runtime-red behavioral rows under
the recommended rulings (action-mentioning worlds where the append
moves MAP and losses; the g4Self return rows; the tick-geometry and
name-blindness pins), satisfiability transcripts per R-D21 (overlay
form, flag-faithful), stanza draft — brought to the sitting with this
pack per the step-5 precedent. The sitting's rulings and your key are
the only stops.

---

## Part III — the oracle draft, its transcripts, and the author's mid-drafting note

### §15. The author's note (received at this drafting), dispositioned

The note, verbatim: *"Two enforcement soft spots, both on the decision
side: EU/VoI behavior is validated by pins on self-authored worlds
rather than universal properties (VoI non-negativity, utility
affine-invariance, and generative argmax-optimality are checked
nowhere), and Dutch-book coherence is grounding prose, not an executed
check. These would be cheap future oracle rows."*

Disposition, by where each row binds:

- **Utility affine-invariance** and **generative argmax-optimality**
  land NOW, in this step's oracle (g6): both are universal properties
  of exactly the scoring rule 6b just selected, stated as QuickCheck
  properties over the PUBLIC scoring arithmetic (random utilities,
  random affine maps, 100 cases each) — and composed with g2's bridge
  row (runMembrane's choice == that public arithmetic, extensional)
  they hold of the loop's own decisions, not merely of a parallel
  formula.
- **VoI non-negativity** — registered to STEP 9's boundary: the VOI
  verbs are deleted there in favor of the Expect-composition, and the
  property belongs to the surviving composition (pinning a verb the
  same increment deletes would be a pin written to die). Recorded on
  the step-9 opening checklist by this pack (the retire-until-N
  discipline's sibling: a scheduled row, not a comment).
- **The executed Dutch-book check** — registered to STEP 7 (pricing
  unified, M5 repealed): that is the boundary where odds and prices
  become the increment's subject, and where D8's coherence ground
  ("a deficient mixture prices a Dutch book") should become an
  executed row over random refuser patterns rather than haddock
  prose. Recorded for step 7's opening checklist likewise.

### §16. The oracle draft (test-stream/, ten rows, six groups)

Drafted on the register's recommended rulings and 6b's surviving rule;
CONTINGENT on the sitting. No new library exports were needed — the
step-6 surface is a behavior change behind the existing exports, so
there is no Phase-A type-surface edit at all; the oracle compiles
against the SHIPPED library and is runtime-red on behavior (the
simplest oracle shape any step has had).

- **g1 the append** (D-b1): runMembrane's per-tick losses AND acts ==
  an IN-ROW second route (a hand fold through public verbs observing
  at `feats ++ c`) on the re-declared C-world — no captured golden
  anywhere in the row; plus the ns0 name-blindness continuity row
  (E-b1's mechanism, now enforced by a frozen row forever).
- **g2 the scoring rule** (D-b3): after a 100-tick sticky-scripted
  training phase (shared, public verbs), runMembrane's 60 PilotEU
  choices on an action-RESPONSIVE world == the public exogenous-read
  arithmetic (per-candidate predictive at `feats ++ candidate`,
  current weights, the EU verb, the Argmax tie discipline), tick for
  tick. Extensional and enforced: an evidential implementation fails
  this row (conditioning the trained state on the candidate moves the
  a-family's weights; the fold's choices don't).
- **g3 the self-signature returns** (D-a6/D-b6): the C-world with its
  action in the stream — MAP mentions `('get', 'a')` AND the
  action-mentioning FAMILY carries the posterior majority (> 0.5,
  measured 0.600); the exogenous control's MAP is byte-equal to the
  frozen changepoint render (t1RenderGoldenM, copied with provenance
  test-membrane/Membrane.hs:172-173 per R-D20-i) with the a-family
  DEAD (< 1e-12, measured 5.2e-21).
- **g4 RIDER 2, fixture-side**: the completed-namespace population is
  1529 (the retired C-world's own arithmetic, now under a writable
  name); an action-guard's hypBits == chargeBits of the DECLARED
  guardCharge tree (both sides imported — R-D20-i with zero copies);
  and the obligation stands negatively: NO assignment-priced row
  exists in the suite.
- **g5 silent ticks** (D-b7): a 20-tick world silent on odd ticks —
  silent losses are exactly 0, observed ticks score at the appended
  features (== a fold that skips the silent ones).
- **g6 the decision-side universal properties** (§15): affine
  invariance and argmax-optimality, 100 QuickCheck cases each over a
  deterministic 40-tick-trained state.

Fixtures: test-stream/gen_fixtures.py (seed 20260716 inline), sanity
line printed and reproduced in the oracle's fixture banner
(n(a=1.5)=75/160, P(y=1|a=1.5)=0.880, P(y=1|a=0.5)=0.165, action
crossings=76 — the action is not a cheap function of time). The
control stream is the frozen test/Streams.hs shifted160, IMPORTED
(probe-discipline). Stanza: test-stream/stanza.cabal.draft (tasty +
tasty-quickcheck; hs-source-dirs reaches test/ for Streams only).

### §17. The satisfiability transcript (R-D21, overlay form, flag-faithful)

The overlay: a prototype PropLang.Membrane wearing the real module's
name, carrying exactly the two owed edits (the append at observe;
per-assignment exogenous-read scoring in interpretPilot's PilotEU
arm). The oracle's exact text compiled against it UNCHANGED, under the
stanza's exact flag set (-Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns — the step-5 flag-faithful amendment
honored), then ran:

```
stream — actions in the feature stream (step 6)
  g1 the append: observe sees feats ++ assignment
    the tick's losses ARE the appended-features losses (in-row second route):                        OK (4.47s)
    name-blindness continuity: an ns0 agent's losses ignore the append (E-b1's mechanism, enforced): OK (2.84s)
  g2 the scoring rule: exogenous-read, pinned to the public arithmetic
    runMembrane's choices == per-assignment predictive EU at current weights, every tick:            OK (3.44s)
  g3 self-signature (C): the action-in-stream story wins only when it should
    C: MAP mentions ('get', 'a'), decisively:                                                        OK (1.68s)
    C0 control: the exogenous story wins, BY STRUCTURE:                                              OK (1.59s)
  g4 RIDER 2: the completed namespace, mention prices only
    the 3-name population is 1529 (9 + 8 + (16+3+2)*72):                                             OK
    an action-guard's charge IS the declared tree through the one mechanism:                         OK
  g5 silent ticks: nothing folds without an observation
    silent ticks lose 0 bits; observed ticks score at the appended features:                         OK (0.25s)
  g6 decision-side universal properties
    utility affine-invariance: argmax(alpha*u + beta) == argmax(u), alpha > 0:                       OK (2.52s)
      +++ OK, passed 100 tests.
    generative argmax-optimality: the choice attains the max, first-listed among ties:               OK (3.35s)
      +++ OK, passed 100 tests.

All 10 tests passed (20.13s)
```

Every asserted quantity in every row executed once against the
prototype; comparison rows print both sides on failure and force both
sides to normal form through == on fully-evaluated Double lists (the
red transcript below witnesses full-value printing on the frozen
side).

### §18. The red run (the same text against the SHIPPED library) — 4 red / 6 green, every red attributed

```
grep of the verdict lines:
    the tick's losses ARE the appended-features losses:               FAIL
    name-blindness continuity (ns0):                                  OK
    runMembrane's choices == per-assignment predictive EU:            FAIL
    C: MAP mentions ('get', 'a'), decisively:                         FAIL
    C0 control: the exogenous story wins, BY STRUCTURE:               OK
    the 3-name population is 1529:                                    OK
    an action-guard's charge IS the declared tree:                    OK
    silent ticks / observed ticks at appended features:               FAIL
    utility affine-invariance:                                        OK (100 cases)
    generative argmax-optimality:                                     OK (100 cases)
```

Attribution, row by row (the full transcript with both sides printed
in full is the scratch red-transcript; its diagnostic content quoted
here):

- **g1 RED at exactly t=5** — the first 5 losses agree bit-for-bit,
  the divergence begins at the script's FIRST ACTED tick (z_5 = 0.919
  > 0.5): the red is the append and nothing else.
- **g2 RED totally and legibly** — the shipped loop waits all 60
  ticks (scoring the a-trained state at bare features reads the
  a-guards' else-branch); the fold acts all 60 (per-assignment
  scoring reads the learned P(y|a=1.5) ≈ 0.9). The exact divergence
  6b's arithmetic predicted.
- **g3 RED with the smoking gun**: under the shipped loop the MAP is
  the Z-GUARD proxy story (`('get', 'z')` at zc 1) — the agent that
  cannot see its own actions credits the sensor that drove them. The
  append exists to displace exactly this.
- **g5 RED at t=14** — the first OBSERVED acted tick (t=5's action is
  on a silent tick); silent zeros hold under both routes.
- The six greens are the rows DESIGNED green under both routes:
  continuity (g1b), the control (g3b), enumeration arithmetic (g4),
  and the universal properties (g6, public arithmetic only).

### §19. What the oracle phase caught (three row revisions, all pre-freeze)

The SAT/red discipline earned its keep three times in one drafting:

1. **g3's "decisively" bar was wrong in the right way**: the MAP
   mentions the action but its SINGLE-sentence posterior is 0.384 —
   the story's mass splits among sibling a-guards. Measured: the
   a-family carries 0.600 (self) vs 5.2e-21 (control). The row now
   pins the FAMILY majority — the decisive unit — with the control's
   family-death bar at nine orders of margin.
2. **g2's first world could not red**: the script made the action a
   deterministic function of z, so bare-features scoring proxied
   per-assignment scoring through the z channel and the row passed
   against the SHIPPED loop. Redesigned onto an action-responsive
   world (evidence answers the previous tick's action; sticky blocks
   make the appended action the only explanation) — red is now total.
3. **g5's 8-tick window could not red**: every acted tick in the
   window happened to be silent. Widened to 20 ticks (t=14, 16 are
   observed acted ticks).

None of these are implementation bugs — they are exactly the class of
oracle defect ("a red row whose red is assumed, not demonstrated")
the step-2 clauses were canonized to catch, caught by the clauses.

### §20. Where this stops

Committed in this state: the pack (Parts I–III), test-stream/
(Stream.hs, gen_fixtures.py, stanza.cabal.draft) — all BUILDER
DRAFTS, nothing frozen touched, MANIFEST 71/71 intact, the eleven
frozen suites untouched. The prototypes (overlay, E-b1 harness, 6b
falsifier) are scratch and die there per R-D21.

The sitting owes: rulings D-b1..D-b7 (§13's sheet — D-b3 now
evidence-backed by 6b's two transcripts), the §15 dispositions
(g6-now / VoI-at-9 / Dutch-book-at-7), and the g3 family-mass row
form (§19.1). Then the freeze: manifest extension over test-stream/
+ the stanza merge under the delegation pattern, and your signed tag
(likely `stream-freeze-r0`). Implementation after that is the
overlay's two edits transcribed — the falsifier-before-freeze
economics one more time.
