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

### §21. ORDERED at this drafting: the type-derivation audit installs at THIS freeze

The author's order (2026-07-16, verbatim): *"Install the
type-derivation audit now, not at step 9. This is a live gap I
verified: §8c ruled it 'goes into frozen CLAUDE.md at this boundary'
— and it is not in CLAUDE.md today. It exists only as signed
AGENT_PLAN prose plus a step-9 execution row. But steps 6–8 change
types (the confound channel, utility-as-Expr, the belief over utility
programs) before the retrospective audit runs. The rule created to
prevent the next 86-commit silence should be binding before the next
types land — one line in the step-6 freeze's CLAUDE.md touch."*

Gap verified by the builder: `grep -i "type-derivation\|derivation
audit" CLAUDE.md` returns nothing; AGENT_PLAN.md §8c carries the
ruling with its rationale ("it was a type, not a terminal, that hid
the calculator for 86 commits"). The rule has been honored in spirit
at recent freezes (PolSort's derivation was recorded at step 4 "for
the typing-audit rule's letter") but binds nowhere frozen.

**The drafted line for the step-6 freeze's CLAUDE.md touch** (the
rule text is §8c's own, copied not re-derived; the edit is
author-only or delegated per R-D22 with the re-tag obligation):

> One line canonized at the step-6 boundary (the stream freeze),
> installing AGENT_PLAN §8c's ruling of 2026-07-12, which until this
> boundary bound only as signed prose: THE TYPE-DERIVATION AUDIT —
> every TYPE on a frozen surface carries a one-line derivation from
> the brief, exactly as every terminal carries a one-line deletion
> proof; a type without one is cut, or the brief is amended to
> license it (the `Util a y` incident its provenance: it was a type,
> not a terminal, that hid the calculator for 86 commits — the
> deletion audit polices the alphabet, this polices the types).

**The binding division, stated so step 9's row is not double-counted:**
from this freeze the rule binds FORWARD — every new type on a frozen
surface arrives WITH its derivation line, in the same increment that
lands it (steps 7 and 8 are exactly the steps the author names).
Step 9's execution row is the RETROSPECTIVE audit over the standing
stock (§7 step 9: "the TYPE-derivation audit (§8) — its complement"),
unchanged. Rule now, retrofit at 9.

Step 6 itself lands NO new type (Part III §16: no type-surface edit
exists), so this step's own audit obligation is vacuously discharged
— which is precisely the right moment to install the rule: it costs
this freeze nothing and binds the next two steps, which are the
expensive ones.

Freeze-checklist consequence: the step-6 freeze's CLAUDE.md touch
list now carries exactly one line (above). No other canonization is
queued; the 6b label-symmetry lesson (signed posterior means are
vacuous over latent-labeled classes — use label-invariant moments) is
offered in Part II as an observation for the sitting, canonized only
if the author wants it.

---

## Part IV — the process-order batch (eight orders at one sitting), enacted and drafted

The author issued eight further orders during this drafting (§21's was
the first). Under the pacing order the builder enacted everything
builder-legal — two tools built and fired, every claimed gap verified
— and drafted everything that needs the key. Each section: the order
verbatim, the verification, the disposition.

### §22. The primitivity two-sided entry gate

Verbatim: *"Make primitivity a two-sided entry gate. Landing a
production should require both: (a) an executed failed composition
attempt — write the candidate as a sentence of the existing grammar;
only demonstrated failure (extensional or type-level) licenses the
codeword — and (b) the in-increment ablation fixture (already law
since the design-review gate). ToR is the model citizen: its
primitivity was established by a pinned disagreement case, by
construction. Had (a) been law at the prepost boundary, all five VOI
primitives and Bern are blocked at entry, and steps 3 and 9 mostly
never need to exist. This is the single highest-leverage change on
both axes."*

Provenance verified: (b)'s law is AGENT_PLAN.md:888-890 ("every NEW
production lands with its in-increment ablation"); ToR's pinned
disagreement case is test-code/Code.hs:321-332 (the carrier where Pos
and ToR DISAGREE, by construction; AGENT_PLAN.md:608-612 the one-line
proof). The counterfactual checks out: EU/VAct/VThink/VThinkK entered
at the membrane boundary, VPre at prepost, Bern at ExpFam — none with
a composition attempt; proof (i) later wrote vThink as an ordinary
sentence (2.2e-16 max deviation), which is exactly the composition
attempt SUCCEEDING, five boundaries late.

**Drafted CLAUDE.md line (the freeze touch):**

> One clause canonized at the step-6 boundary: PRIMITIVITY IS A
> TWO-SIDED ENTRY GATE. A production enters the alphabet only with
> BOTH (a) an executed FAILED composition attempt — the candidate
> written as a sentence of the existing grammar, its failure
> demonstrated extensionally or at the type level, transcribed in the
> increment's pack (only demonstrated failure licenses the codeword;
> ToR's pinned disagreement case, test-code group 4, is the standard)
> — and (b) the in-increment ablation fixture (the design-review
> gate's law). Five VOI primitives and Bern entered without (a) and
> cost two demolition steps; that purchase is this clause's
> provenance.

Binding note for step 8: 8b's kernel-composition arm is now
explicitly under this gate — the payoff-at-t+5 falsifier IS the
composition attempt, and the production lands only if the sentence
form demonstrably fails (with its price, per 8b's existing rider).

### §23. Standing boundary audits (brief-vs-as-built + the two greppable rows)

Verbatim: *"Schedule global re-derivation audits. BRIEF_AUDIT had the
highest yield-per-cost of any artifact in the repo; make
brief-vs-as-built a standing event at every roadmap boundary rather
than a thing that happens when suspicion accumulates. Give it
standing rows for the greppable shapes of the two worst defects: the
M5 pattern (asserted N times, derived zero — count citations vs.
derivations for every ruling) and the H pattern (a load-bearing
quantity defined nowhere — every symbol in wire/membrane docs needs a
definition site or a world-declaration marker; test-writeup's
doc-linter is already the right infrastructure for this)."*

ENACTED: `tools/boundary-audit.sh` built (reusing
test-writeup/check.sh's check shapes — P: cited paths exist, N:
literal in both doc and source — without touching the frozen script)
and FIRED for the first time at this boundary. First-firing results,
with triage:

- **M5-row** (threshold: cited >= 4, zero definition-shaped lines —
  the 4 is M5's own number, AGENT_PLAN.md:49): 7 flags after one
  regex tuning; ALL spot-checked flags are definition-FORM misses,
  not ghosts (R-D23 defines at HOSTS_D_PACK.md:835 in
  register-vocabulary "registered/recorded"; R-C2 at
  code-task2-author-pack.md:104 as a ### heading; CL-6 at
  interface.md:184 as a "(proposed):" line; D-p3 at
  pricing-author-pack.md:121 as a register TABLE row). Verdict: the
  M5 class is EMPTY on the current corpus — mechanically checked for
  the first time. Tuning backlog recorded: table-row, heading, and
  register-vocabulary definition shapes.
- **H-row**: 4 flags after excusing in-doc definition sentences; all
  four spot-checked (observe_batch, residuals, residual_mean,
  sensitivity — membrane-wire.md:238/:186/:274/:275) carry in-doc
  definition sentences in forms the regex missed. Verdict: the H
  class is EMPTY on the current corpus. (H itself was fixed at the
  boundary that caught it; the wire doc now consistently defines its
  fields.)
- Standing observation: test-writeup/check.sh's G2 asserts 8 cabal
  stanzas; the cabal has 11 (a dated red-by-design instrument, not a
  live gate — recorded so no future reader mistakes it for one).

**Drafted CLAUDE.md line (the freeze touch):**

> One clause canonized at the step-6 boundary: THE BOUNDARY AUDIT.
> Brief-vs-as-built re-derivation is a STANDING EVENT at every
> roadmap boundary — run scheduled, never on accumulated suspicion
> (BRIEF_AUDIT, the highest yield-per-cost artifact in the repo, ran
> once and on suspicion; that is the provenance). Its greppable rows
> run first (tools/boundary-audit.sh: the M5-row — every ruling ID's
> citations counted against definition sites; the H-row — every
> wire/membrane symbol resolves to a definition site or a
> world-declaration marker) and their flags are triage inputs for
> the human sweep, never verdicts. The audit output rides the
> boundary's author pack.

### §24. The question function distributed (the six-mandate red team)

Verbatim: *"Distribute your question function. Your questions now
have a taxonomy: theorem-installed-as-definition (Savage, committed
twice by the same reflex); asserted-but-never-derived (M5);
defined-nowhere (H); type-without-derivation (Util); overloaded
convention (dormancy-as-wait); and the universal opener, 'what is X a
function of?' Encode these as standing red-team mandates run by
independent reviewers at each boundary — the 2026-07-11 external
review proved the pattern yields real findings (D1–D8). This won't
replace taste, but it raises the floor so your attention is spent on
the genuinely novel questions rather than re-deriving the known
failure shapes."*

**Drafted CLAUDE.md line (the freeze touch; can stand alone or fold
into §23's clause — both forms drafted, the author picks):**

> One clause canonized at the step-6 boundary: THE RED-TEAM MANDATES.
> At every roadmap boundary, six standing questions are put to the
> increment by reviewers INDEPENDENT of the builder's context — one
> mandate each: (1) is any theorem installed as a definition (the
> Savage shape, committed twice by the same reflex)? (2) is any
> ruling asserted N times and derived zero (M5)? (3) is any
> load-bearing quantity defined nowhere (H)? (4) does any type on a
> frozen surface lack its derivation (Util)? (5) is any convention
> silently overloaded (dormancy-as-wait)? (6) for every new object:
> WHAT IS IT A FUNCTION OF? Findings ride the boundary's author pack
> beside the audit rows. The floor, not the ceiling: taste asks the
> novel questions; the mandates stop the known shapes recurring.

Recommended execution mode (the register asks you to confirm):
fresh-context independent reviewer agents, one mandate each, at every
boundary — upgradeable to true external review at your election (the
2026-07-11 pattern, D1-D8 the yield). Fold-in alternative: §23's
clause gains one sentence ("The human sweep runs the six red-team
mandates: ...").

### §25. The pre-freeze lint (mechanized clauses) — BUILT, FIRED, AND IT FOUND A VIOLATION

Verbatim: *"Mechanize the mechanical clauses. CLAUDE.md's
incident-bought law is accumulating as prose the builder must
remember, and roughly half is scriptable: flag-faithfulness of
overlay compiles, ASCII test names, probe re-declaration of
importable values, forbidden tokens by glob rather than the frozen
5-file list (a future module escapes gate 4 today; the membrane
mirror-row is the workaround, a lint is the fix), manifest and tag
verification. A pre-freeze lint converts remembered law into enforced
law — 'enforced, never trusted' applied to the process itself — and
it deletes the re-open classes (the ExpFam flag incident, the locale
incident) that were the actual schedule slips."*

ENACTED: `tools/prefreeze-lint.sh` built and fired. Rows: L1
forbidden-tokens-by-glob (the frozen list, the frozen stripper, every
src file); L2 ASCII test names; L3 manifest; L4 tag signatures; L5
SAT flag-faithfulness (the pack's transcript must record all four
stanza flags); L6 (ADVISORY) grid re-declaration heuristic.

**Gate-4 gap VERIFIED as claimed**: audit/run-gates.sh:78-82 names
exactly five files — src/PropLang/Membrane.hs is not among them and
escapes the frozen gate today; the workaround is test-membrane's
gate-4 mirror row (Membrane.hs:546-553, which says so in its own
comment). L1 closes the class: 6 src files scanned, all clean.

**First-firing FINDING (the order's thesis, demonstrated same-day):
the ASCII-test-names clause is VIOLATED IN FOUR FROZEN ORACLES.**
Em-dash characters in test names at test-optlaw/OptLaw.hs:103,
test-pricing/Pricing.hs:66 and :117, test-sentence/Sentence.hs:136,
:785, :805, and test-actions/Actions.hs:73 — every one frozen AFTER
the clause canonized (2026-07-05), across four consecutive freezes,
masked in every run by LANG=C.UTF-8 in the environment (the latent
failure mode — a C-locale host crashing on encode — is exactly the
membrane locale incident's). Remembered law, violated four times,
caught the day it became enforced. The frozen files are
STOP-AND-REPORT: the builder fixed only the unfrozen test-stream
draft (its own em dash, same class — SAT re-verified 10/10 after the
rename) and touched nothing frozen. The fix — an ASCII normalization
of seven test-name strings under a named re-open, or a ruling
narrowing the clause — is yours at a freeze boundary. Until then the
lint's L2 row stays red on the frozen four, printing the debt.

**Drafted CLAUDE.md line (the freeze touch):**

> One clause canonized at the step-6 boundary: THE PRE-FREEZE LINT.
> tools/prefreeze-lint.sh runs before every freeze tag and its
> transcript rides the pack — remembered law converted into enforced
> law ("enforced, never trusted", applied to the process itself). Its
> rows are the scriptable halves of standing clauses (forbidden
> tokens by glob over ALL of src — the frozen gate 4 names five files
> and the membrane escaped it; ASCII test names; manifest; tag
> signatures; SAT flag-faithfulness); a clause's non-scriptable half
> stays law as prose. Its first firing found the ASCII clause
> violated in four frozen oracles the day it became enforced — that
> is the provenance.

### §26. EU-layer law-grade properties — the step-9/10 assignment

Verbatim: *"Give the EU layer law-grade properties (from my previous
assessment, and it belongs in this frame): VoI non-negativity,
utility affine-invariance, generative argmax-optimality, an
executable Dutch-book check. The inference layer's enforcement would
catch a subtly wrong implementation; the decision layer's pins would
not. Natural home: the step-9/10 oracles."*

Disposition: this SUPERSEDES §15's Dutch-book-at-7 recommendation —
the full law-grade suite (all four properties) homes at the step-9/10
oracles, drafted as a register row on step 9's opening checklist. The
two properties already landed in this step's g6 (affine-invariance,
argmax-optimality — 100 QuickCheck cases each over the public scoring
arithmetic, bridged to runMembrane by g2) stand as EARLY PARTIAL
enforcement unless you strike them at the sitting; the step-9/10
suite is the law-grade home where the surviving decision layer is
final (VOI verbs deleted, Expect-composition in place, reflexive
closure landing).

### §27. The IsEq register row (step 9) — the gate's one retrospective application

Verbatim: *"IsEq is the one survivor whose primitivity rests on an
assertion, not a pinned case. It's slated to survive step 9 on the
claim 'not derivable from Gt, which is Double-only.' That was
airtight pre-arithmetic. Post-step-1, with Sub/Mul in the grammar and
options now being Features over a declared menu, an equality test may
be compositionally sayable (per-name difference arithmetic over a
known name set). Maybe it still fails — but that's now a question
with a ToR-style answer owed, not a comment. One register row at
step 9."*

Verified: IsEq survives step 9 per AGENT_PLAN.md:568 ("IsEq —
option dispatch") and :638 (the EXPR census keeps it); its Eq-witness
signature is src/PropLang/Syntax.hs:354.

**Drafted step-9 opening-checklist row (AGENT_PLAN §7 step 9, the
delegated-edit batch):**

> OPENING-CHECKLIST ROW (ordered at the step-6 sitting): IsEq's
> primitivity gets the two-sided gate retrospectively — the one
> surviving production whose primitivity is an assertion, made
> pre-arithmetic. The composition attempt: an equality test written
> as per-name difference arithmetic (Sub/Mul, Gt both ways) over the
> declared name set, options being Features over a declared menu.
> Either the attempt FAILS pinned (a ToR-style disagreement case, by
> construction) and IsEq keeps its codeword with a real proof, or it
> succeeds and IsEq is deleted at this step with the others.

### §28. The first type-derivation pass (at 6, not 9) — the classification table

Verbatim: *"Scaffolding types in src are exactly what the §8c audit
exists to classify — and it hasn't run. PilotThreshold Name Double
Features Features (Membrane.hs:100) is a scripted competitor policy
carrying a raw Double, living in src/ alongside PureWorld and
TickTrace. It's never on the agent path (PilotEU is), so it's not
sentinel-class — but note the precedent asymmetry: the Python
forgetter, the analogous scripted competitor, was deliberately
quarantined in the test file, while this one ships in the language's
own module tree behind CPP. A type-derivation pass would force each
of these to either a derivation line or an explicit 'simulator
scaffolding, outside the language' fence. Concrete instance of why
recommendation 1 shouldn't wait for step 9."*

ENACTED: the pass ran over the COMPLETE current src type surface (34
types, 6 modules; inventory by grep '^data |^newtype |^type '). The
table below is the builder's classification for your ruling; the
derivation/fence comments land in src at implementation time (src is
unfrozen), and step 9 keeps the RE-audit row.

| type (module:line) | verdict | the line |
|---|---|---|
| Bits (Belief:35) | DERIVE | description length is the prior's only currency (brief: 2^-L) |
| LogProb (Belief:41) | DERIVE | observe returns the log marginal — the polling contract's only score |
| Space (Belief:47) | DERIVE | belief is over DECLARED finite carriers, never invented points |
| Belief (Belief:51) | DERIVE | probability is the logic (brief S4); the sealed reasoner's one object |
| Event (Belief:54) | DERIVE | a query is a prevision of an indicator (CL-1 read-only diagnostics) |
| Kernel (Belief:59) | DERIVE | conditional belief as data — transition/emission kernels (interface) |
| Evidence (Belief:64) | DERIVE | Saw is the ONLY door a belief changes through (brief S6) |
| B, K, Ev, Name, Ix (Syntax:77-88) | DERIVE | synonyms of the above; Name = a published feature name (interface S1) |
| Grid (Syntax:93) | DERIVE | grid definitions are data with prices (CLAUDE.md forbidden-moves list) |
| Carrier (Syntax:124) | DERIVE | the declared observation carrier (ExpFam basis, plan E9) |
| Stats (Syntax:148) | DERIVE | defunctionalized sufficient statistics — no host lambdas in Expr |
| Idx, Expr, Args (Syntax:154-332) | DERIVE | the priced language itself: programs as data (brief S2) |
| Fn (Syntax:315) | DERIVE | defunctionalized function forms (the Fn/Stats mandate, CLAUDE.md) |
| StdName (Syntax:352) | DERIVE | the stdlib alphabet: derived names with prices (brief S9) |
| Util (Syntax:396) | DERIVE-AS-DEBT | the S8c archetype — utility on (act,obs) pairs; DIES AT STEP 8 (utility-on-outcomes); its derivation line IS the debt note |
| Chan (Syntax:413) | DERIVE | the CIRL channel (increment 6, utility-as-latent under the discrete reading); step-8 subject beside Util |
| ProdTable (Syntax:441) | DERIVE | the DECLARED production table — prices are data, never hand counts |
| Charge, PolSort (Syntax:455/491) | DERIVE | step 4's mechanism: the float order as declared data; PolSort the policy sorts it prices |
| Namespace (Syntax:623) | DERIVE | mention pricing over the completed namespace (M1; RIDER 2) |
| Features (Eval:62) | DERIVE | the tick's public stream (interface S1) — and at 6, actions join it |
| Vals, Env (Eval:65/72) | DERIVE | the typed evaluator environment — totality of evalx demands it |
| Obs (Enumerate:208) | DERIVE | the declared obs carrier's synonym |
| FragSort, FragProd (Enumerate:241/256) | DERIVE | the fragment's declared sort/production tables (step 3) |
| Hyp (Enumerate:324) | DERIVE | a hypothesis IS a sentence: price + space + emission/move codes |
| HypState (Enumerate:508) | DERIVE | a sentence with its latent posterior — state-carrying scoring |
| Agent (Enumerate:511) | DERIVE | the meta-belief over sentences (brief S4's mixture, S9's prior) |
| Menu (Membrane:67) | DERIVE | the world's declared writable names (step 5; AGENT_PLAN S5's one new name) |
| Pilot (Membrane:98) | SPLIT — the author's instance | PilotEU: DERIVE ("nothing may select an action but expected value" — the doctrinal arm). PilotIdle, PilotThreshold: FENCE — scripted competitor policies, simulator scaffolding, outside the language; the raw Double is a script parameter, not a priced quantity; never on the agent path. The Python forgetter's analog, shipped in src where the forgetter was quarantined in tests — the asymmetry the author flagged. Options for the ruling: (i) fence comment on the two arms, stays in src (harness pragmatics); (ii) split the type — PilotEU stays, the scripted arms move to a test-side harness module. Builder recommendation: (i) at 6 with (ii) noted as a step-7 candidate (the membrane is re-opened there anyway). |
| PureWorld (Membrane:117) | FENCE | simulator scaffolding: the pure test-world shape; the real boundary is the wire (host conformance binds to membrane-wire.md, never GHC artifacts) — the engine needs SOME world to fold against in-process; this is that harness |
| TickTrace (Membrane:129) | DERIVE (borderline) | the tick's public record mirrors the wire's readouts (p1, entropy, act, loss — interface S1 observables); if the author reads it as harness, FENCE costs nothing |

The pass's yield beyond the author's named instance: zero additional
sentinel-class types; the FENCE class is exactly the membrane harness
trio, concentrated where the author pointed.

### §29. Two standing reminders, one orphan CONFIRMED

**(a) The founding oracle pins the old ontology** (verbatim): *"The
founding oracle still pins the calculator's definition.
tests_acceptance.py's R(a,s) = u(a(s)) and its Haskell port remain
frozen and green — the corpus deliberately pins both ontologies at
once until step 8's amendment schedule fires. Written down and
reconciled, but worth remembering that every acceptance run currently
re-confirms the old utility ontology."*
Disposition: a drafted step-8 opening-checklist row — the amendment
schedule must name every acceptance-lineage row (the test-sentence g1
ports and the test-membrane t1 utility rows) whose green currently
re-confirms R(a,s) = u(a(s)), and re-derive or retire each at the
boundary that changes the ontology.

**(b) The A2-K worlds obligation — ORPHAN CONFIRMED BY GREP.**
Verbatim: *"One obligation may have died with its boundary: A2's row
demanded non-self-licensed worlds at K, 'or the atoms' rows inherit
this row's offense.' K was discharged by construction (§8b) — and I
can't find that worlds obligation re-homed anywhere. The
GENERIC/SELF-LICENSED provenance column exists only in BRIEF_AUDIT.
Suggestion: make provenance a standing field of step 9's full
deletion audit, so the re-run doesn't quietly earn its bits on worlds
authored in the family's own image."*
Verification: BRIEF_AUDIT.md:72-75 carries the obligation ("K's scope
INCLUDES authoring non-self-licensed worlds, or the atoms' rows
inherit this row's offense... at least one non-self-licensed world
making a newly sayable molecule earn its bits, else the atoms are
decoration"); AGENT_PLAN.md:1021 discharged K BY CONSTRUCTION and
closed A2's DEBT at S2a — and `grep -rl "non-self-licensed" *.md`
returns ONLY BRIEF_AUDIT.md. The obligation was never re-homed: the
orphan is real, the ninth incident of the retire-until-N disease
class, caught by the author's read.
Disposition: a drafted step-9 audit-spec field — **the full deletion
audit's world column is STANDING: every deletion-proof world is
labeled GENERIC or SELF-LICENSED, and a terminal's survival cannot be
earned exclusively on SELF-LICENSED worlds** (the A2-K obligation
re-homed at last, as a field instead of a boundary's scope note).

### §30. The consolidated freeze checklist (what your key now covers)

The step-6 freeze's CLAUDE.md touch carries FOUR drafted lines: the
type-derivation audit (§21), the primitivity gate (§22), the boundary
audit (§23 — with §24's red-team mandates folded in or standing
alone, your pick), and the pre-freeze lint (§25). The AGENT_PLAN
delegated-edit batch carries: the step-8 rows (acceptance-lineage
ontology; 8b under the primitivity gate), the step-9 rows (IsEq; the
EU law-grade property suite; the deletion-audit provenance field;
VoI non-negativity), and the g4Self row's completion mark at 6. The
frozen-oracle ASCII violations (§25) are a named re-open for your
ruling. The lint itself runs pre-tag as its own first scheduled
application; tools/ joins the manifest at this freeze.

**Appendix IV-A — prefreeze-lint first firing (verbatim):**

```
=== prefreeze-lint (tools/, unfrozen; first ordered at the step-6 sitting) ===
PASS  L1 forbidden-tokens-by-glob: 6 src files clean (frozen gate 4 names 5)
FAIL  L2 non-ASCII test name at test-actions/Actions.hs:73
FAIL  L2 non-ASCII test name at test-optlaw/OptLaw.hs:103
FAIL  L2 non-ASCII test name at test-pricing/Pricing.hs:117
FAIL  L2 non-ASCII test name at test-pricing/Pricing.hs:66
FAIL  L2 non-ASCII test name at test-sentence/Sentence.hs:136
FAIL  L2 non-ASCII test name at test-sentence/Sentence.hs:785
FAIL  L2 non-ASCII test name at test-sentence/Sentence.hs:805
PASS  L3 MANIFEST.sha256: 71 rows verified
PASS  L4 all 27 tags verify
PASS  L5 stream-author-pack.md records the four stanza flags (incl. -Werror)
WARN  L6 test/Anchors.hs carries thetaPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test/Properties.hs carries thetaPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-membrane/gen_fixtures.py carries thetaPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test/Anchors.hs carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test/Properties.hs carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-expfam/stanza.cabal.draft carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-membrane/gen_fixtures.py carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-membrane/stanza.cabal.draft carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-stream/gen_fixtures.py carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-writeup/check.sh carries tauPoints-like leading literals without importing Enumerate (advisory)
WARN  L6 test-membrane/gen_fixtures.py carries rhoPoints-like leading literals without importing Enumerate (advisory)
=== prefreeze-lint: 7 FAIL, 11 WARN ===
```

**Appendix IV-B — boundary-audit first firing (verbatim):**

```
=== boundary-audit (screening; first firing = the step-6 boundary) ===
--- M5-row: ruling citations vs definition sites ---
FLAG  CL-2     cited   4 times, candidate definition lines: 0
FLAG  CL-6     cited   5 times, candidate definition lines: 0
FLAG  D-a2     cited   6 times, candidate definition lines: 0
FLAG  D-a5     cited   4 times, candidate definition lines: 0
FLAG  D-b4     cited   4 times, candidate definition lines: 0
FLAG  D-b6     cited   4 times, candidate definition lines: 0
FLAG  D-p3     cited   4 times, candidate definition lines: 0
M5-row: 7 flagged (IDs cited >=4 with no definition-shaped line)
--- H-row: wire/membrane doc symbols resolve outside those docs ---
FLAG  symbol `observe_batch` appears only in wire/membrane docs, no resolution site
FLAG  symbol `residual_mean` appears only in wire/membrane docs, no resolution site
FLAG  symbol `residuals` appears only in wire/membrane docs, no resolution site
FLAG  symbol `sensitivity` appears only in wire/membrane docs, no resolution site
H-row: 4 flagged (of 36 symbols scanned)
--- standing observations ---
note: test-writeup/check.sh G2 asserts 8 cabal stanzas; the cabal now has 11 (dated red-by-design instrument, recorded)
=== boundary-audit done: M5=7 H=4 ===
```
