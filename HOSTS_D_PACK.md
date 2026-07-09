# HOSTS_D_PACK — increment D: utility as latent, outcome-grounded (the governor as host)

Status: UNTRACKED builder draft, 2026-07-08, awaiting author review. Nothing
in this document binds until the author's own acts — the rulings in §12, the
frozen-text amendments in §11, the freeze commit and its signed tag (R3: the
drafted sentence is a convenience, not the act). The proplang manifest stands
at 75/75 untouched; this file is not in it and must not be until the author
freezes it.

**Author review, 2026-07-09 (recorded; revision 1 absorbs it):** R-D1
through R-D5 RULED as recommended, with three binding riders —

- **Rider 1 (elicitation cost).** The elicitation cost is fixed in
  MEASURED UNITS only (owner-seconds, tokens), entering utility through the
  same accounting layer as spend — never denominated in θ_ask. A comparison
  question is itself an interruption; had its cost been θ_ask-denominated,
  the VoI of buying information about θ_ask would depend on θ_ask (the
  bootstrap circularity), and the retired constant `q` would have re-entered
  wearing a false moustache. The Ramsey numeraire move, made explicit. (§4,
  §7 item 4 as revised.)
- **Rider 2 (the O1 pin's standing).** Marginal==prior under a
  comparison-free stream is NOT automatic: it holds only under a
  product-form joint prior over (world hypotheses × residual components). A
  joint complexity prior over composite programs would let world evidence
  move residual marginals through prior correlation. The independence is
  therefore DECLARED as apparatus (the per-latent-agent architecture,
  HOSTS_PLAN §6.2's own move), making the pin a derivable identity — or, if
  the author later prefers joint enumeration, the pin demotes to falsifiable
  at a coarser tolerance. Declared-apparatus is this pack's realization;
  R-D13 carries the confirmation. (§2 as revised.)
- **Rider 3 (outcome capture gates the freeze).** The outcome channel today
  carries one-class data (reverted = 0 of 2,946; "accepted" is structurally
  blind to the bad-code case — developers work past bad output constantly).
  Until richer observables land, ū would learn from a channel with NO
  negative examples. Outcome-capture plumbing (§13 item 1) is therefore
  pulled forward: it lands governor-side BEFORE the freeze, and the freeze
  is gated on it. (§13, §15 as revised.)

Further review items absorbed: the ledger's verdict row corrected to
prior-driven cardinality (not "ordinal simpliciter"); the `sensitivity`
readout bound by consumer discipline (§8); "reference-bad" flagged as a
dangling symbol until operationally defined (R-D7); the enumeration
blow-up made a measured oracle-phase obligation (§10.11); the interregnum
named (R-D14); the 30 test-session refusals RULED excluded outright
(R-D15); the raw capture's retention liability made a policy item (R-D16);
the grounding replay's coding rules recorded as declared apparatus (§7
item 3).

Two follow-on process findings by the author, same day, both absorbed
into §7: the residue discipline repaired (named ≠ printed; the extended
ledger's stratification rule; the retired-constant call-site audit), and
**residue as last resort** — every bucket-three item now carries a
promotion proof and a grade (I by-theorem / II shrinkable / III
by-ruling-with-demand-gate); the grading exercise itself re-classified
τ-frozen and the rod's declared value as Grade III (rulings, not
necessities), each with its reopening gate.

A third review input, same day: an external research report supplied by
the author ("The Foundations of Utility Learning: An Audit of
Irreducibility and Sufficiency..."), cross-audited against this pack in
`UTILITY_RESEARCH_CROSSAUDIT.md` (untracked, non-binding). The
cross-audit confirms the architecture at every overlap and its
proposals enter this pack as PROPOSED items, none binding until the
author's rulings: **R-D18** (the act-independent-drift declaration, §7
+ §12), the **gOffPath candidate pin** (the bit-price identity, §10
item 12 — drafted in the oracle, expressly accept-or-strike at the
freeze), annotation language on **R-D8** (positivity as
deletion-proof-bearing) and **R-D10** (revealed vs idealized vs
constructed), and the **KSV caveat** for the increment report (G4).

**Author review 2 (the verdict round), 2026-07-09 — recorded; revision
5 absorbs it.** The rider absorption is confirmed, with one addition:
rider 2's product-form architecture ALSO bought the additive budget —
the independence declaration and the tractability claim are the same
fact, now a register line (**R-D19**) so no one later relaxes
independence without noticing they have re-multiplied the enumeration.
The cross-audit dispositions are RULED: **R-D18 ADOPTED with a
sharpening** — "true by construction" undersold it; the WORLD contains
the act→preference edge (ask-fatigue is real) even though the wire
cannot express it, so UWalk ABSORBS endogenous annoyance escalation as
exogenous drift: benign for inference, fatal for management (the agent
can never learn "my asking causes the drift" and so can never
economise it); the gate falls due when that absorption becomes
DECISION-RELEVANT, not merely when a wire edge appears. **gOffPath
KEPT** ("regressions exist for the day an edit invalidates a
derivation someone remembered as a theorem"). **G3 ADOPTED with both
faces printed**: positivity is the charity restriction AND a content
commitment — a 0.05 floor on θ_ask is a substantive prior claim about
the owner's annoyance wearing an anti-degeneracy guard's uniform; it
also excludes an owner for whom asks are nearly free or actively
welcome. **G4, G5 ADOPTED as drafted.** Two corrections, one
load-bearing:

- **The second gauge anchor is not gauge (R-D7 AMENDED — the
  load-bearing one).** Affine freedom is two degrees: the accounting
  layer's `−spend(y)` term in measured dollars spends the SCALE, and
  status-quo = 0 spends the ZERO — both gone before "reference-bad"
  enters the room. u(reference-bad) = −1 was either a tautology (a $
  referent) or a hand-set θ_bad exchange rate for the very component
  this boundary makes latent (a non-$ referent). The doctrine's
  two-anchor sentence predates the accounting conversion and was not
  re-derived after it. RULED: gauge = (status-quo = 0, dollar-slope =
  1); the second anchor DELETED — permitted back only as a redundancy
  check, never as a fixing declaration; the wire golden's placeholder
  string never acquires a referent. §5, §7 item 2, §8's gauge block,
  and the gWire goldens are amended accordingly.
- **The budget conclusion decomposed before belief (gating the
  manifest extension).** `observe_batch` removes only IPC; the
  decomposition (gBudget's two new rows, same 1241-model world driven
  engine-only and over the wire) measures engine 6.5 ms/tick vs wire
  8.6 ms/tick — the engine dominates, so 39,314 warm ticks ≈ 23
  minutes of pure engine CPU per cold start at the governor-sized
  world and batching removes only ~6% of it. The better answer for
  exchangeable components enters the v2 vocabulary before the goldens
  freeze: **`observe_counts`** (§8) — count-collapse by per-hypothesis
  likelihood exponentiation, O(contexts × grid) not O(ticks); exact
  for iid-emission families, and for drift-carrying ones it IS the
  declared warm-flattening approximation, printed.

Also ruled in the same round: R-D6, R-D8, R-D12, R-D13 as recommended
(R-D8 with both faces; R-D12's drafted vocabulary now includes
`observe_counts`); R-D5 gains the spend-grain statement; R-D14 noted
as surviving revision 2 untouched — the register's only faith-run; the
WireU sealing observation and the KSV caveat queued for the increment
report ("additive-field extensibility" is a named candidate for the
next wire boundary, not a per-increment surprise).

Companions delivered with this pack:

- the **data audit** (`~/.credence-governor/data-audit/report.md` +
  `dossiers.json`; module committed governor-side at `1ed04a3` on
  `feat/membrane-adapter`): 17 descriptive dossiers, zero labels assigned,
  every count reconciled. The label rulings it feeds are §12 R-D3.
- **H's as-built report** (`HOSTS_H_REPORT.md`): the grid-ceiling finding and
  the retirement of agreement-% — the measured demand this boundary answers.

---

## 0. Why D, why now, and what changed since HOSTS_PLAN

H closed on a real result: the membrane is host-drivable, and the differential
gate measured the enumerated engine against the incumbent — 0.724, every
disagreement julia=proceed vs membrane=ask, mechanism exact (thetaGrid ceiling
0.9 < the *declared* proceed threshold 0.96). The author then ruled, in
conversation on 2026-07-08:

1. **Credence is retired as a yardstick.** Agreement-% was H's
   control-experiment scaffolding; its job is done. Julia's one surviving
   role is the frozen closed-form test oracle (govhost g4).
2. **The governor's declared utility constants are retired.** No `c`, `λ`,
   `q` driving decisions or scoring. (This dissolves H's ceiling finding
   *as stated*: 0.96 only exists relative to declared constants.)
3. **Utility becomes latent** — HOSTS_PLAN §6's machinery — grounded in the
   original datasets of real openclaw and Claude Code use.
4. Three objections to the builder's first migration draft, adopted as
   doctrine: **O1** exchange rates are unidentifiable from approve/refuse
   data alone; **O2** unlabeled capture is inadmissible as evidence (never
   benign-by-assumption); **O3** verdicts are a noisy myopic proxy — ground
   truth is outcomes (the bad-code example: the user proceeds, then doesn't
   get what they really wanted).
5. **The utility doctrine** (§1 below, verbatim) — the method this pack
   realizes section by section.

D therefore comes **before A** (a §9 ladder amendment, §12 R-D1): A's
life-agent demand never materialized; the governor's demand for D is measured
and live. And **D0 is skipped** (§12 R-D2): register 8.12's world-supplied-
utility stepping stone contradicts ruling 2 — there is no longer a declared
utility to supply.

What the data audit established (the boundary's factual floor):

- Owner verdicts are **sparse**: 38 total (8 live yes + 30 test-session no)
  against 26k decisions. The verdict channel cannot carry this boundary.
- An **outcome channel already exists** governor-side: `outcomes.py`'s
  structural session replay — accepted 1798 / reverted 0 / ambiguous 1148
  over the 2,946 cached calls. It is the one signal with **no responder
  model** between record and truth.
- The warm counts (39,314) are **machine-issued** (harness auto-approvals +
  loop-denials), provenance `ClawsBench@e7c45cc9` — verdict-shaped but not
  owner verdicts.
- The raw capture measures **25,095 records** (the inventory's ~89.8k was a
  sampled-average estimate; the audit's count corrected it) — unlabeled,
  policy-selected, admissible today only as context distribution and
  active-labeling pool (O2).

---

## 1. The author's utility doctrine (recorded verbatim, 2026-07-08)

> The proplang-native answer starts by refusing the usual framing. "Model
> the user's utilities" normally means: pick a parametric family, pick a
> rationality model, fit. Every one of those picks is a silent constant. The
> language's discipline turns each into one of three things — *a sentence*
> (priced, competed over by evidence), *a measurement* (world data through
> the membrane), or *a printed residue* (an assumption you couldn't remove,
> named). The method is to push as much as possible into the first two
> buckets and be exact about what's left in the third.
>
> **First, the identifiability ledger — before any grammar.** A utility
> component moves only through channels whose likelihood it touches; that's
> O1 generalized, and it should be the *first* artifact, not a discovered
> embarrassment. There are exactly four channel types: choices/verdicts
> (which, even from a perfectly rational user, reveal only *ordinal*
> structure filtered through a responder model); outcomes in measured units
> (cardinal, and — this is O3's deep value — they bypass the responder model
> entirely); elicited comparisons; and deference behavior itself. Write the
> table: which component can each channel move. Components no channel
> touches stay at prior *exactly* — and the honest system pins that as a
> test rather than hoping estimation smears over it.
>
> **Second, convert utility into accounting wherever possible.** The most
> principled utility model is mostly not a utility model — it's measurement.
> Wasted spend, retries, reverts, latency, task completion are commensurate
> observables; a `USay` program over (action, outcome-vector) whose
> coefficients are *measured features* is world data, not latent belief.
> What remains genuinely preferential after this conversion is a
> low-dimensional residual — the exchange rates between incommensurables
> ($-per-unit-annoyance, risk attitude). That residual is where the actual
> inference problem lives, and shrinking it before inferring it is most of
> the work.
>
> **Third, cardinal structure needs gambles — that's a theorem, not a
> modeling choice.** Even assuming full rationality and coherence,
> deterministic choices identify utility only ordinally; von
> Neumann–Morgenstern cardinality comes from preferences over *lotteries*.
> So minimal-assumption elicitation is Ramsey's method made sayable:
> preference questions that are lotteries over measured outcomes ("certain
> small interruption vs. 10% chance of $X wasted"), each an ordinary priced
> affordance in the menu, bought by argmax exactly when VoI justifies it —
> which, by your own sensitivity scalar, is exactly when the decision flips
> across the residual's support. Note the pleasing closure: the O1 pin
> proves verdict-asks carry zero VoI about the residual, so a correctly
> built agent will *spontaneously route* its information-buying to the
> elicitation channel when the residual matters and nowhere else. The
> unidentifiability theorem becomes the elicitation policy.
>
> **Fourth, name the gauge and the entanglement, because they're not
> learnable and pretending otherwise is the classic sin.** Utility is
> identified only up to positive affine transformation — harmless for
> decisions, so fix it by declaration (u(status quo)=0, u(reference-bad)=−1)
> and record it as *gauge*, the way physics does, not as an estimate. And
> τ-u entanglement (Armstrong–Mindermann): from behavior alone you cannot
> distinguish "the user wants X" from "the user errs often" — no simplicity
> prior rescues this in general. Proplang's honest posture: the responder
> model is a minimal declared sentence with τ never updated where the
> theorem forbids it, and outcomes — responder-free evidence — break the
> degeneracy exactly where they can and nowhere else.
>
> **Fifth, coherent doesn't mean constant.** UWalk makes preference change a
> sentence rather than noise, which does double duty: it's the truthful
> model of an owner who might change their mind, and it's why the deference
> floor never reaches zero — corrigibility funded by the standing
> possibility that the current posterior is about to be wrong. Even under
> your "assume coherent" premise, coherence-per-time with sayable drift
> across time is the right reading; the alternative (coherence-for-all-time)
> is an assumption you'd have to print.
>
> What's irreducibly left in bucket three, printed: the utility fragment's
> *alphabet* (which observables exist, which grid geometries — the
> invariance constant, now over value-space); the gauge; the channel
> likelihood family; the elicitation cost model; and — deepest — the
> *pointer's boundary*: whose reactions count, the in-the-moment user or the
> reflective one they'd endorse (open problem 3; revealed vs. idealized
> preference is not a modeling error, and no update rule fixes it).
> Savage's theorem is the right consolation here: for a coherent agent,
> (p, u) is jointly a *representation* of their preferences over acts, so
> "learning the user's utility" can only ever mean learning that
> representation up to its invariances — and a system that names its
> invariances exactly has, in a real sense, no external assumptions left,
> only declared ones.

---

## 2. The identifiability ledger (the first artifact)

**Named utility components** (after §3's accounting conversion; these are the
only candidates for latent status):

| id | component | what it bridges |
|---|---|---|
| ū(x) | call-value: the owner's value of wanted work in context x | wantedness itself (the CIRL latent proper) |
| θ_ask | interruption exchange rate | one ask ↔ $ (replaces declared `q`) |
| θ_bad | unwanted-effect exchange rate, non-$ part | security/trust damage ↔ $ (replaces declared `λ·c`/`harm_cost`; the *$-measurable* part of a bad call — wasted spend — is accounting, not preference) |
| ρ_u | preference drift rate | UWalk's rate (sentence content, like `hmm`'s ρ) |
| (curvature) | risk attitude over $ | **not yet sayable** — the frozen alphabet has step tables and (post-C) linear rows only; recorded under bucket-three item 1, NOT smuggled as a constant |

**The four channels and what sits between record and truth:**

| channel | evidence today (audit) | responder | reach |
|---|---|---|---|
| verdict | 8 organic owner verdicts (the 30 test-session refusals are EXCLUDED, R-D15); warm counts are machine-issued (R-D4) | τ-owner (declared, τ never updated) | **prior-driven cardinal** in ū: cardinality conditional on the declared τ prior — the entanglement stated correctly, not ordinality simpliciter (§5); never a route to the residual |
| outcome | grounding replay 1798/0/1148; coding_grid $ + pass/fail; spend, retries, reverts, latency | **none** — O3's deep value | **cardinal** in every $-measured component |
| comparison | none yet (this boundary designs the channel) | the owner answering a lottery question | any component the question addresses — the only route to θ_ask |
| deference | override/timeout patterns in the decision log (thin) | the owner's attention | weak, corroborative only |

**Stated plainly (rider 3's premise):** the outcome channel's field data is
today ONE-CLASS — reverted = 0 of 2,946, and "accepted" cannot see the
bad-code case (a developer working past bad output scores accepted). Until
the plumbed observables land (completed, test results, spend attribution),
ū would learn from a channel with no negative examples. That is why
outcome capture gates the freeze, and why the O3 oracle pin — which passes
on its synthetic paired world — says nothing about the field until then.

**The ledger** (component × channel; "—" = the likelihood does not touch it):

| component | verdict | outcome | comparison | deference |
|---|---|---|---|---|
| ū(x) | prior-driven cardinal, via declared τ | **cardinal** (revert/completion/spend) | yes | weak |
| θ_ask | **—** | — (no measured annoyance proxy exists) | **yes (only route)** | timeout rates, weak |
| θ_bad (non-$) | **—** | — (by definition of non-$) | **yes (only route)** | — |
| ρ_u | via time-structure of any stream above | same | same | same |

**Channel operating costs — the ledger's missing row-class (the rider-1
post-mortem, 2026-07-09).** Using a channel costs something, and that cost
is itself a quantity in utility-space; the ledger as first drafted analyzed
components as OBJECTS of inference but never listed the costs of OPERATING
the channels — the exact vacancy through which θ_ask slipped into the
apparatus. The missing rows, with the stratification rule that governs
them:

> **For every channel k and latent φ: if k is an information route to φ
> (the φ-row, k-column ledger cell is non-empty), then cost(k) must be
> independent of φ.** Self-referential information pricing is forbidden;
> everything else is ordinary decision theory.

| channel | operating cost | bucket, under the rule |
|---|---|---|
| verdict (an ask) | the interruption — θ_ask | latent, PERMITTED: the verdict channel is no route to θ_ask (its ledger cell is empty — the zero-VoI pin), so no bootstrap arises; θ_ask prices ask DECISIONS as ordinary object-level utility |
| outcome | passive capture; storage/retention (R-D16) | measured / declared |
| comparison | the question: measured owner-seconds + tokens, declared conversion to the numeraire (rider 1) | measurement + declared rod; any residual latent FORBIDDEN — the comparison channel is the residual's only route |
| deference | passive observation | — |

The rule is checkable mechanically on this extended ledger (cross-reference
each cost's dependencies against that channel's column), and run against
the pack's first draft it flags rider 1's bug automatically. The oracle
carries it as a frozen row: the routing-closure pins' VoI arithmetic is
computed with each channel's declared cost and re-checked for latent
independence where the rule demands it.

**The O1 pin family — a theorem GIVEN declared apparatus, not an automatic
fact (rider 2).** Marginal==prior under a comparison-free stream holds only
if the joint prior over (world hypotheses × residual components) is
product-form; a joint complexity prior over composite programs would let
world-stream evidence move the θ_ask marginal through prior correlation
even though no likelihood touches it. This pack REALIZES product form as
declared apparatus: each residual component is its own Agent (the
per-latent-agents-under-independence architecture, HOSTS_PLAN §6.2), the
pair belief composed per tick by public verbs — so independence is
architectural, not estimated, and it is PRINTED (§7 item 1's
neighbourhood, confirmed at R-D13). Under that declaration the pin is a
derivable identity and 1e-12 is a regression tolerance on an identity:
`latentMarginal` projected to the component's grid equals the dl-prior on
that grid, on a D-world whose stream carries no comparison ticks — one
frozen test per empty ledger row. Should the author ever prefer joint
enumeration of composite (world × residual) programs, the pin demotes to
falsifiable and the tolerance must be re-derived; that alternative is
named here so it cannot happen silently.

---

## 3. Utility as accounting (bucket two before bucket one)

The **outcome vector** is world data — measured features on outcome ticks, in
their own units: `spend-usd`, `retries`, `reverted` (0/1), `latency-s`,
`completed` (0/1). The initial set is §12 R-D5 (the author picks; candidates
from the audit's existing signals).

The **USay payload** is a priced sentence over (action-code, outcome-vector)
whose coefficients are measured features and whose only latent mentions are
the residual components:

    u(a, y) = −spend(y) − θ_ask·1[a=ask] − θ_bad·badness(y)

— schematically; the exact payload is drafted against the sayable surface at
oracle time (step tables now; linear rows if/when C lands; anything richer is
C-gated and the pack does not assume it). What matters structurally: **the
payload is world-declared syntax, the measured coefficients are features, and
the residual is 2–3 grid-priced latents** — nothing else. Each residual grid
is priced data (`mkGrid` precedent); its geometry is the invariance constant
over value-space, §12 R-D8, and the P5 single-site clause stands armed over
any new production-table constant (none is expected: empty census, §9).

`UConst | UWalk` ranges over each residual component and over ū — the exact
`MBern | MHmm` analogue HOSTS_PLAN §6.1 records.

---

## 4. Elicitation, designed (the routing closure)

Lottery-shaped preference questions are **ordinary priced affordances** in
the world's menu — Ramsey's method made sayable. A comparison affordance
carries: the lottery payload (two acts over measured outcomes, one with
declared probability p — e.g. "one certain interruption" vs "p chance of $X
wasted"), and its own measured cost (it interrupts too). The owner's answer
arrives as a `comparison`-tagged evidence tick; its likelihood is the τ-owner
channel applied to the lottery's utility difference — which **does** touch
θ_ask/θ_bad (the question is *about* them), unlike a verdict.

**The routing-closure pins (paired worlds, frozen):**

1. **Zero-VoI pin:** VoI(verdict-ask → residual marginal) == 0 at 1e-12 —
   the ledger's empty row, stated preposteriorly.
2. **Routing pin:** in the paired world where the decision flips across the
   residual's support but the world posterior is sharp, `vPre`-valued argmax
   buys the **comparison** affordance, not the verdict-ask.
3. **Converse pin:** in the twin where the world is uncertain and the
   residual is sharp, it buys the **verdict-ask**, not the comparison.

**The cost of asking (rider 1 — the circularity, named and closed).** A
comparison question is itself an interruption. If its cost were denominated
in θ_ask, the VoI of buying information about θ_ask would depend on θ_ask —
a bootstrap circularity, and the retired `q` re-entering as a latent's
shadow. Ramsey escapes by making one question the numeraire; this boundary
does the equivalent explicitly: **the elicitation cost is fixed in measured
units only** (owner-seconds, tokens — logged per question) **and enters
utility through the same accounting layer as spend**, with its conversion
to the gauge's numeraire DECLARED, printed apparatus (§7 item 4 as
revised). It is never a function of θ_ask or any residual latent. VoI over
the comparison affordance is thereby computable from the world posterior
and the declared cost alone — no residual self-reference.

The rod's own price, stated: if the owner's true annoyance at comparison
questions differs from the declared conversion, the agent systematically
over- or under-buys elicitation — the misdeclaration's ENTIRE impact, since
θ_ask (learned through the rod) still prices every ordinary ask correctly.
A fixed rung buys the whole ladder at the cost of possibly mismeasuring
itself; that trade is the numeraire, and it is printed, not hidden.

The unidentifiability theorem becomes the elicitation policy, and the oracle
catches any agent that fails to route. What stays for the author: the
declared measured-unit cost values and the initial **question inventory**
(§12 R-D6, as re-ruled) — user-facing choices, never the builder's.

The **per-decision sensitivity scalar** (does argmax flip across the
residual's support?) is computed by the driver from public verbs and exposed
on the wire (§8); it is the live counterpart of pin 2.

---

## 5. Gauge and entanglement, printed

**Gauge (declared, not estimated — R-D7 AS AMENDED, 2026-07-09 second
review):** affine freedom is two degrees, and both are spent before any
second anchor could enter: the accounting layer's `−spend(y)` term in
measured dollars spends the SCALE (utility is dollar-denominated by
declaration of the payload), and u(status-quo) = 0 spends the ZERO. The
gauge is therefore **(status-quo = 0, dollar-slope = 1)**, recorded in
the wire's world declaration as a `gauge` block naming the zero and the
measured unit. The doctrine's original second anchor (u(reference-bad)
= −1) predated the accounting conversion and was not re-derived after
it: with both degrees already spent it was either a tautology (a $
referent) or a hand-set θ_bad exchange rate for the very component this
boundary makes latent (a non-$ referent). DELETED by the author's
ruling; it may return only as a redundancy check, never as a fixing
declaration — which also discharges the review's dangling-symbol item
the simplest way: the "reference-bad" placeholder never acquires a
referent because the symbol is gone.

**τ-u entanglement (Armstrong–Mindermann, honored by construction):** the
responder model is a minimal declared sentence — `verdictKernel :: TauSpec ->
Kernel Double Obs`, the τ-marginalised logistic owner, finite grid-τ mixture,
**τ never updated** (HOSTS_PLAN §6.2 verbatim; the τ grid exists frozen —
`tauGrid`, Enumerate.hs:89). Outcomes are responder-free and break the
degeneracy exactly where the ledger's outcome column is non-empty, and
nowhere else. The channel likelihood *family* (logistic; τ grid geometry) is
bucket-three item 3, §12 R-D9.

---

## 6. UWalk = coherence-per-time

Preference change is a sentence, not noise: `UWalk` at grid rate ρ_u is the
hmm move on the pointer, enumerated as content. It funds the deference
floor — a posterior containing "the owner's preferences can change" never
fully concentrates, so asking retains value forever. The headline pin (§10)
makes this falsifiable, exactly like increment 6's decay. The alternative
reading (coherence-for-all-time) would itself be a printed assumption; this
boundary declines to print it.

---

## 7. The printed residue (bucket three — a CLOSED list)

1. **The utility fragment's alphabet**: which outcome observables exist,
   which residual components are named, which grid geometries price them
   (the invariance constant over value-space). Risk curvature's current
   unsayability lives here.
2. **The gauge**: the declared zero (status-quo = 0) plus the
   dollar-slope (= 1, spent by the accounting layer's measured unit) —
   one anchor and one unit, not two anchors (R-D7 as amended, 2026-07-09;
   the erstwhile second anchor deleted, §5).
3. **The channel likelihood/measurement apparatus**: logistic τ-owner
   (τ grid, marginalised, never updated) for verdicts; and the grounding
   replay's CODING RULES for outcomes — accepted/reverted/ambiguous is
   declared apparatus (what counts as "working past it" is a rule, not a
   pure measurement), recorded here so it cannot pass as raw data.
4. **The elicitation cost**: declared in measured units (owner-seconds,
   tokens) with a declared conversion to the gauge's numeraire, entering
   via the accounting layer — NEVER via θ_ask (rider 1: the reincarnated-`q`
   failure, named and closed).
5. **The pointer's boundary**: whose reactions count — the in-the-moment
   user or the reflective one they'd endorse. Recorded as the open problem
   it is (revealed vs idealized preference); **no update rule fixes it**, and
   the register carries it as standing, not as resolved.

Item 1's neighbourhood additionally carries the **declared independence**
of rider 2: product-form prior between world hypotheses and residual
components, and between residual components — architectural (per-latent
Agents), printed, confirmed at R-D13.

RULED at the second review (R-D18, ADOPTED with the author's
sharpening): item 1's neighbourhood also prints that **UWalk's drift
is declared act-independent — and that this declaration is an
ABSORPTION, not merely an absence**. The wire cannot express the
act→preference edge, but the WORLD contains it: ask-fatigue is real,
and UWalk will absorb the agent's own endogenous annoyance escalation
as exogenous drift. That absorption is benign for inference and fatal
for management — the agent can never learn "my asking causes the
drift" and so can never economise it. The gate, as sharpened: a CAUSAL
path-specific guard falls due when the absorption becomes
DECISION-RELEVANT (endogenous preference effects material to what the
agent should choose), not merely when a wire edge appears — and never
as a syntactic non-mention rule, which is neither necessary nor
sufficient (Carroll et al.; Farquhar–Carey–Everitt). Grade II:
irreducible in kind today, gate named.

**The residue discipline, repaired (2026-07-09 — the author's process
finding).** Three of the review's four catches (the θ_ask-denominated
elicitation cost; the O1 pin's unprinted independence; the dangling
reference-bad) were one failure mode: an item NAMED on this list and
therefore counted as printed, its content left free to default to whatever
lay nearest — and what lay nearest was the freshly-minted latent, because
retiring a constant leaves call-sites that its latent successor fills by
default. The closure test ("no silent sixth") catches only additions; it
cannot see a vacancy behind a name. Three rules now bind, and §14 checks
them:

1. **Named ≠ printed.** A residue item is printed only when operationally
   grounded: a concrete referent, unit, and value — or a declared
   procedure for obtaining one. Items pending grounding are marked PENDING
   with the ruling that grounds them (today: item 2's reference-bad at
   R-D7; item 4's unit values at R-D6).
2. **Stratification (the extended ledger's rule, §2).** No channel's
   operating cost may depend on a latent that channel is a route to.
3. **The retired-constant call-site audit.** When a declared constant is
   retired in favour of a latent, every call-site is enumerated and
   classified: object-level (the latent belongs there — that is the point)
   or apparatus-level (the latent is forbidden there; the site needs its
   own measured/declared replacement). Run for this boundary: `q` had two
   site-classes — the decision table's ask row (object-level → θ_ask,
   correct) and the pricing of preference-elicitation itself
   (apparatus-level → rider 1's measured rod); `c` and `λ`'s sites are all
   object-level (decision utility only). The audit reruns at any future
   retirement.

**Promotion proofs — residue as last resort, demonstrated (2026-07-09,
the author's second process finding).** The alphabet earns every terminal
by a deletion proof (design.md §2), honesty flag included (`call`, kept by
convention with its cost printed). The residue list now carries the
symmetric obligation: **an item enters bucket three only with a promotion
proof** — the attempted conversion into a sentence and into a measurement,
and the graded reason the attempt fails:

- **Grade I — fails by theorem.** No channel's likelihood can move it, or
  the conversion is a category error.
- **Grade II — fails today, shrinkable.** Irreducible in kind but its
  extent shrinks as the language or the measurement apparatus grows; the
  entry names the shrinkage route.
- **Grade III — residue by RULING.** A conversion exists in principle; it
  is declined for a stated reason, with a named demand-gate that reopens
  it. Grade III items are choices, and are never presented as necessities.

The five items, graded (this exercise re-classified two of them —
the finding that motivated the rule):

| item | promotion attempt | grade |
|---|---|---|
| 1 alphabet | sentence: fails by regress (the hypothesis space cannot be a hypothesis; the moving-frontier open problem). BUT content shrinks per increment (C's arithmetic converts declared utility forms into sentences) | I (core) / II (content) |
| 2 gauge | sentence: posterior==prior forever (every likelihood is affine-invariant — the O1 logic run on the gauge itself); measurement: category error (a coordinate, not a quantity) | **I** |
| 3a τ-owner frozen | **a conversion EXISTS**: where outcomes cardinally anchor ū(x), verdict scatter identifies τ (Armstrong–Mindermann forbids joint (τ,u) inference from behavior ALONE; outcome-anchored contexts are the escape). Declined: a τ-updating agent can explain away inconvenient refusals as owner error instead of moving ū (responder-gaming). Demand-gate: a measured outcome-anchored context set + an oracle pin that τ-updates cannot discount refusals in anchored contexts | **III** |
| 3b grounding coding rules | not sentence-able (they define a measurement); improvable and validatable (LLM adjudication, human spot-check — §13.3) | II |
| 4 elicitation rod | the rod's EXISTENCE: fails by theorem (the bootstrap — no fixed rung, no ladder). The rod's declared VALUE: a conversion exists in principle — a rod-value latent calibrated through the DEFERENCE channel (response rates/timeouts, passive, costless; the §2 stratification rule already permits it, since comparison is not that latent's route). Declined at this boundary: the deference channel is today the thinnest of the four. Demand-gate: recorded deference volume sufficient to move a rod-value posterior | I (existence) / **III** (value) |
| 5 pointer's boundary | all data is generated by the in-the-moment responder; preferring the reflective one is a normative choice no likelihood arbitrates | **I** |

No silent sixth, no hollow fifth — and no Grade III wearing Grade I's
clothes. The pack's self-check (§14) tests closure, groundedness,
stratification, and promotion-grading, not closure alone.

---

## 8. Observation space and wire v2

**Streams.** Evidence ticks carry a world-published `stream` tag:
`report | verdict | outcome | comparison` — HOSTS_PLAN §6.2's two-stream
convention generalized by two values. World hypotheses explain report ticks;
utility hypotheses explain verdict, outcome, and comparison ticks, each
through its declared channel. "Explained" stays a role, not a type
(interface.md §2): one evidence flow, no new flow.

**Wire v2 — `utility.form: "latent@1"`** (v1's `table@1` remains valid; the
form string is the dispatch seam, Wire.hs:314, and membrane-wire.md:14-16
already provides ignore-unknown-keys degradation):

- world declaration gains: `said` (the USay payload, S-expr), `residual`
  (named grids), `tau` (grid + declared prior weights), `channels` (routing:
  ask→verdict kernel, act→noise), `price` (the tick-price feature name —
  measured cost as world data), `gauge` (zero + dollar-slope; R-D7 as
  amended — no second anchor).
- menu items gain an optional `comparison` payload (the lottery: two acts,
  declared p, measured outcome stakes).
- evidence ticks gain `stream`; outcome ticks carry the measured outcome
  vector as ordinary features.
- replies gain `residual_marginal` (the `latentMarginal` readout, summarised
  per component) and `sensitivity` (§4). **Consumer discipline, binding:**
  both are OBSERVABILITY-ONLY, `structure_expect`'s discipline exactly —
  routing to the elicitation affordance happens ENGINE-SIDE, via argmax over
  the declared menu; the adapter never branches on the exposed scalars.
  An adapter that reads `sensitivity` and decides to ask has re-created the
  host-side decision-forking the wire ruling already forbids (HOSTS_PLAN
  §8.12(b)); the governor-side tests pin the adapter's decide path as a
  pure choice-relay.
- new verb `observe_batch` (an array of evidence ticks, one reply each) —
  H's measured cost finding (39k warm ticks × one round-trip each); a wire
  addition, not an alphabet change. Note it fixes ROUND-TRIPS, not
  model-count: the enumeration budget is §10.11's measured obligation.
- new verb `observe_counts` (stream tag + context features + the (n1, n0)
  outcome counts) — the second review's budget ruling. The decomposition
  showed the per-tick cost is ENGINE, not IPC, so batching alone leaves
  ~23 minutes of cold-start replay; a grid posterior under an
  exchangeable likelihood is computable from counts by per-hypothesis
  likelihood exponentiation, O(contexts × grid) not O(ticks). EXACT for
  iid-emission families; for state-carrying ones (hmm / UWalk) it IS the
  declared warm-flattening approximation, printed rather than smuggled —
  count-collapse the exchangeable, replay only the drift-carrying.
  Drafted in the gWire goldens before the v2 vocabulary freezes.

Exact JSON shapes are drafted at oracle time against `Wire.hs`'s parser the
way H's were; error semantics (unknown stream tag, gauge violation,
comparison on a non-comparison menu) are §12 R-D12.

**The driver.** `runMembraneU` threads its per-tick state **explicitly from
birth** (register 8.9's lesson — H's n=1 re-entry works only because echo is
all-false): it takes and returns the pair of Agents plus the tick counters,
so the wire drives it one tick at a time with no counter resets and full
episodes compose from the same function. Sibling to `runMembrane`, recorded
honestly (HOSTS_PLAN §6.2); `Pilot`, `runMembrane`, `TickTrace` untouched.

---

## 9. New src surface, census, ablation

Per HOSTS_PLAN §6.2, confirmed absent by exploration, each with a frozen
analogue:

| new name | module | analogue |
|---|---|---|
| `UFamily = UConst \| UWalk` | Enumerate.hs | `Model = MBern \| MHmm` (:104-106) |
| `enumerateUModels` | Enumerate.hs | `enumerateModelsIn` (:194) |
| `verdictKernel` | Enumerate.hs | `emit` + test-cirl's hand kernels; `tauGrid` exists |
| `latentMarginal` | Enumerate.hs | `agentMeta` (:367), public verbs only — no new Belief export, I1 intact |
| `UPilot {upSaid, upVerdict, upDepth, upPrice}` | Membrane.hs | `Pilot` (:254-258); `upSaid` is exactly `USay`'s payload type; `upVerdict :: Chan Double Double Obs` is the existing wrapper |
| `runMembraneU` (+ `UTickTrace`) | Membrane.hs | `runMembrane` (:300), sibling with threaded state |

Reused as-is, frozen: `USay` (Syntax.hs:187, priced at `utilB` + payload),
`Chan`/`mkChan`/`applyChan` (:334-340), `VPre`/`vPre`, `Util`, `Rung`,
`tauGrid`, grid pricing, `affIdCode`, `enumerateModelsIn`, `mkAgent`,
`predictive`, `observe`.

**Census: EMPTY.** New sorts, new faces, new grids — nothing frozen
reprices. Witnessed the H way: gP5-style identity pins re-run (bits moves
nowhere), plus `mkAgent`/`enumerateModels` byte-stability on the frozen
acceptance streams.

**Ablation** (increment-local fixtures + runner in test-d/, per protocol):

- `DROP_UPILOT` triple-guard: the six names die together; `PilotEU`'s
  world-supplied utility is all that remains — deference unbuyable,
  measured. Attribution rows name the actual dying identifiers (H-11's
  lesson: attribution is what the compiler says).
- `DROP_UWALK` restricted enumeration: the VoI floor collapses to the frozen
  decay — drift is the floor's sole source.

---

## 10. The oracle sketch (`test-d/`, frozen at D's freeze)

Opens, as every post-close oracle must, with the two mandatory fixtures —
here exercised **non-trivially** (multi-decision interiors, depth ≥ 2 are
D's ordinary worlds), discharging the post-close review's named gap with
real rows:

1. Interior-menu max above singleton; vPreAt recursion above depth 1.
2. **Degeneracy pins**: `UConst`-only enumeration on the frozen CIRL worlds
   reproduces `bk`/`val`/`marginD` and the k=1 asking-death / k=4
   listening-death digit-for-digit (1e-12; derived from the frozen
   artifact, never a parallel derivation).
3. **THE HEADLINE PIN (falsifiable, author-ruled at HOSTS_PLAN §6.3):**
   VoI(k=12) ≥ floor > 0 with UWalk enumerated; ≤ 1e-12 in the paired
   static world. If the pin is wrong, the oracle catches it and that is a
   result too.
4. **Consult window**: the verdict stream flips at t=60; the drift-carrying
   agent resumes deference within a bounded window, the static agent never;
   MAP utility hypothesis becomes the walk, rate inferred, render pinned.
5. **τ-mixture identity**: verdict likelihoods equal the finite τ-mixture
   computed independently (1e-12).
6. **O1 ledger pin family** (§2): one pin per empty ledger row — identity
   regressions GIVEN the declared per-latent-agent independence (rider 2,
   R-D13); each pin's world carries no comparison ticks.
7. **Routing-closure pins** (§4): the three paired worlds — pin 2's VoI
   arithmetic uses the measured-unit elicitation cost (rider 1), never a
   residual-denominated one.
8. **O3 pin — the author's bad-code example**: a paired world where
   verdicts approve but outcomes are bad (spend high, reverts, no
   completion). The outcome-first agent's ū posterior downweights the
   context; the verdict-only agent is fooled; strict posterior ordering
   pinned. This is the boundary's second falsifiable headline.
9. **Identity pins** (empty census witnesses, §9).
10. **Wire v2 goldens**: codec vectors for the latent@1 handshake, stream
    tags, comparison affordance, `observe_batch`; a scripted small latent
    session end-to-end (g5's pattern).
11. **The enumeration budget, MEASURED (author review item; before the
    freeze)**: the joint model count (3,977 world hypotheses × UFamily over
    each residual grid × ρ_u grid) and the per-tick wall cost over the wire
    are measured in the oracle phase and reported in the Task-2 pack.
    `observe_batch` fixes round-trips, not model-count; if the budget is
    unworkable the correct output is stop-and-report (grid coarsening is a
    priced-alphabet decision, the author's), never a silent cap.
    **DECOMPOSED (second review's gating demand — delivered)**: the
    same 1241-model world measured engine-only (6.5 ms/tick) and over
    the wire (8.6 ms/tick) shows the cost is ENGINE, not IPC — hence
    `observe_counts` (§8), which removes the ticks, not the round-trips.
12. **The bit-price identity (cross-audit G2; drafted in the oracle
    AFTER the Task-2 pack's first delivery; RULED KEEP at the second
    review)**: utility hypotheses whose
    likelihoods agree on every emitted observation hold their posterior
    odds at prior odds forever — only the alphabet's pricing ranks
    them. Realized as `gOffPath` with a latent-constant emission
    kernel: the within-family equal-length pair's odds pinned at 1
    (A&M's harmful-pair case — the prior does no work), the
    cross-family pair's odds pinned at their t=0 value (read from the
    agent, whose prior IS 2^-dl — never a hand literal), both after 12
    blind ticks at 1e-12. The identity half of the research's
    bit-price deference floor; the behavioural-frequency half is a
    bench-bed item (§13.4's successor), not an oracle pin.

Runtime-red discipline exactly as H: stanza.cabal.draft with the gate flags
verbatim, red proven to be the missing constructors, ASCII-only test names,
existing frozen suites green throughout.

---

## 11. Frozen-text amendments at D's freeze (author-applied; drafts only)

All three documents are manifest-frozen (75/75); each amendment enters only
by the author's hand at the freeze commit, and only if the author adopts it:

- **CLAUDE.md** porting-order sentence: reorder the hosts ladder — "...then
  D (the latent-utility pilot, outcome-grounded, brought before A by
  measured demand; D0 subsumed), then A (options-as-data), then demand-gated
  B, then C..." — author's words if changed (R3).
- **HOSTS_PLAN.md**: §8.12 resolved (D0 skipped by author ruling; the regret
  metric survives as the outcome-scoring discipline); §9 ladder reordered;
  §6 observation space amended outcome-first (report | verdict | outcome |
  comparison).
- **membrane-wire.md**: the v2 `latent@1` section (or a successor doc frozen
  beside it — author's choice of vehicle).
- **proplang.cabal**: the test-d stanza (drafted as
  `test-d/stanza.cabal.draft` in the oracle phase, per the manifest-covers-
  build-files rule).
- **MANIFEST.sha256**: extended over test-d/ and the amended texts, re-signed.

---

## 12. The under-determination register (rulings for the author)

| id | ruling | status / recommendation on the record |
|---|---|---|
| R-D1 | D before A (§9 amendment) | **RULED 2026-07-09** as recommended |
| R-D2 | D0 skipped | **RULED 2026-07-09** as recommended |
| R-D3 | **per-source label rulings**: which of the audit's 17 sources may enter which channel, and as what | **RULED 2026-07-09** as recommended (dossiers are the ballot), with R-D15 carved out by the author's own hand |
| R-D4 | ClawsBench warm counts | **RULED 2026-07-09** as recommended: excluded from the verdict channel (machine-issued); loop-denials at most a separately-tagged waste signal |
| R-D5 | initial outcome-observable set | **RULED 2026-07-09** as recommended (spend-usd, retries, reverted, latency-s, completed) — and by rider 3 the plumbing that captures them GATES the freeze. **Spend-grain addendum (second review):** the flagship dollar observable arrives at SESSION grain on the main deployment (per-call attribution honestly refused — a wall-clock window cannot attribute per-turn usage to one call), so per-call cardinal signal rests on reverted / completed / retries, which Track A captures per-call, event-id-keyed. The O3-blindness objection is thereby answered rather than promised |
| R-D6 | elicitation cost values + initial question inventory | **RULED 2026-07-09 (second review)** as recommended: cost in measured units only (owner-seconds, tokens) via the accounting layer with a declared conversion (rider 1 binding); the fixtures' declared constants stand as reference values; the doctrine's worked lottery ("one certain small interruption vs p chance of $X wasted") is inventory entry 1 |
| R-D7 | the gauge | **RULED 2026-07-09 (second review), AMENDED — the load-bearing correction**: gauge = (status-quo = 0, dollar-slope = 1). Affine freedom's two degrees are spent by the accounting layer's measured-dollar term (scale) and the status-quo declaration (zero) BEFORE any second anchor could enter; u(reference-bad) = −1 was a tautology or a hand-set θ_bad exchange rate, and the two-anchor sentence predated the accounting conversion. Second anchor DELETED (permitted back only as a redundancy check, never as a fixing declaration); the wire placeholder never acquires a referent — the dangling-symbol item discharged by deletion (§5) |
| R-D8 | residual grid geometries | **RULED 2026-07-09 (second review)**: the fixture geometries stand as reference; positivity recorded with BOTH faces printed — (i) the charity restriction, deletion-proof-bearing (admit negative scaling and the Armstrong–Mindermann sign-flip twin re-enters as an utterable sentence no prior can exclude), AND (ii) a content commitment: the 0.05 floor on θ_ask is a substantive prior claim about the owner's annoyance wearing an anti-degeneracy guard's uniform — it excludes an owner for whom asks are nearly free or actively welcome. Both faces on the record, neither hiding behind the other |
| R-D9 | τ-owner family + τ grid | logistic over the frozen tauGrid; τ never updated |
| R-D10 | the pointer's boundary | recorded OPEN; **wording RULED 2026-07-09 (second review, G5 adopted)**: "revealed vs idealized vs CONSTRUCTED" — an owner inferring their own θ at elicitation time is neither drift (UWalk) nor error (τ-owner); same open posture, one word added; no update rule fixes it; mitigation-by-design (lotteries over measured outcomes) is not identification and is not recorded as such |
| R-D11 | runMembraneU threads per-tick state explicitly | yes — register 8.9's lesson built in from birth |
| R-D12 | wire v2 error semantics + form name | **RULED 2026-07-09 (second review)** as drafted — the vocabulary additionally gains `observe_counts` (the count-collapse verb, §8), drafted into the gWire goldens before the freeze per the budget ruling; error semantics as drafted (unknown stream tag, gauge violation, comparison on a non-comparison item) |
| R-D13 | **the independence declaration (rider 2)**: product-form prior between world hypotheses and residual components (per-latent Agents) is printed apparatus; the O1 pins are identity regressions under it | **CONFIRMED 2026-07-09 (second review)**; the joint-enumeration alternative is named in §2 and demotes the pins to falsifiable if ever taken — and by R-D19 it also re-multiplies the enumeration budget |
| R-D14 | **the interregnum, named (author review item)**: between the retirement of agreement-% and the outcome-scored bench (which needs observables that do not exist yet), the membrane has NO acceptance metric at all | recorded as a standing register line; the interregnum closes when rider 3's plumbing + §13 item 4 land; until then the membrane's only claims are its frozen oracle and its measured costs. **Second-review note:** survives revision 2 untouched — the behavioural half of the bit-price floor is deferred to the bench bed, so this line is the one place the programme currently runs on faith; kept on the register by the author's instruction |
| R-D15 | the 30 test-session refusals | **RULED 2026-07-09, by the author, past the audit's neutrality: EXCLUDED OUTRIGHT** — admitted to the verdict channel they would teach the τ-owner a 79% refusal rate; poison, not evidence |
| R-D16 | raw-capture retention policy | **author review item**: 56 GB of full session transcripts is a retention and hygiene liability independent of any channel ruling; wants a policy (retention window, truncation, at minimum an inventory of what the transcripts contain), governor-side, author to set |
| R-D17 | **the Event payload's strict I2 reading (post-review addition, 2026-07-09, from the external review — awaiting the author's acknowledgment at the freeze)**: the Evidence variant is closed (`Is`/`Saw`) but `Event`'s payload is an opaque predicate `a -> Bool` — `Belief.hs`'s "the engine can never receive an opaque closure" claims more than the implementation delivers, and the gap opens exactly on the continuous-carrier class recorded decision 1 cited as I2's justification | recorded as a precedent line, not a defect at D: harmless on finite carriers (the engine enumerates the space, so the predicate is fully observable), no consumer needs more (continuous carriers are a cut item); falls due if a carrier-growth boundary ever opens; whether the one-line comment precision in `Belief.hs:61-63` lands with D's freeze commit is the author's call. Filed: `EXTERNAL_REVIEW_RESPONSE.md` |
| R-D18 | **the act-independent-drift declaration (cross-audit G1)**: UWalk's drift is declared EXOGENOUS — printed as apparatus under item 1's neighbourhood, beside R-D13's independence declaration | **RULED ADOPTED 2026-07-09 (second review), with the author's sharpening**: the declaration is an ABSORPTION, not an absence — the world contains the act→preference edge (ask-fatigue) even though the wire cannot express it, and UWalk absorbs endogenous annoyance escalation as exogenous drift; benign for inference, FATAL for management (the agent can never learn "my asking causes the drift" and so can never economise it). Gate: the causal path-specific guard falls due when the absorption becomes DECISION-RELEVANT, not merely when a wire edge appears. Grade II, gate named (§7) |
| R-D19 | **independence buys the budget (second review, 2026-07-09)**: rider 2's per-latent product form is ALSO the tractability claim — utility hypotheses are additive (9 + 8 per component beside the world's 3,977), not multiplicative, BECAUSE of the per-latent factoring; the independence declaration and the budget result are one fact with two faces | **RULED as ordered**: recorded so no one later relaxes independence without noticing they have re-multiplied the enumeration; any future joint-enumeration ruling (R-D13's named alternative) re-opens the §10.11 budget measurement in the same breath |

---

## 13. The data roadmap (governor-side successors; ordinary PRs, no freeze)

Ordered by the author, gated on R-D3/R-D5:

1. **Outcome capture plumbing — FREEZE-GATING (rider 3)**: log the chosen
   observables per governed call; turn ON the openclaw adapter's
   resolution/latency capture (it already emits allow/deny/timeout with
   timestamps — none reach disk today). Not "plumbing": until this lands,
   the doctrine's cardinal channel has no negative examples (§2), so it
   lands governor-side BEFORE the author's freeze, and the freeze is gated
   on it.
2. **Active labeling**: a CLI over the 25,095-record capture, ranked by
   context-frequency × decision-sensitivity (the wire's p1/entropy — and,
   post-D, the sensitivity scalar), so labels land where they matter.
   O2 applied to ourselves: model-ranked labeling is MODEL-SELECTED data;
   the selection rule is recorded with every labeled batch so the bias is
   named (and conditionable) rather than silent — the same discipline the
   audit applied to the policy-selected capture.
3. **Grounding, hardened**: extend `outcomes.py` (OUTCOMES.md's own "next
   rigor layer": adjudicate the 1,148 ambiguous calls; the corpus-hygiene
   filter for the capture's own synthetic attack fixtures).
4. **The outcome-scored bench bed**: `governor_compare` re-run where both
   error costs are measured in commensurate units — the eval that replaces
   agreement-% for good.

---

## 14. Protocol conformance self-check

- Oracle-first, runtime-red, exact gate flags, ASCII names: §10. ✓
- The two mandatory fixtures open the oracle, non-trivially: §10.1. ✓
- Ablation rows with attribution named: §9. ✓
- Census stated (empty) + witnesses: §9. ✓
- Register present, every silent constant surfaced as ruling or residue:
  §12, §7. ✓
- Doctrine traceability: part 1 → §2 + pins §10.6; part 2 → §3; part 3 →
  §4 + pins §10.7; part 4 → §5; part 5 → §6 + pins §10.3-4. O1 → §2/§10.6;
  O2 → §0 (audit) + R-D3; O3 → §8 streams + §10.8. ✓
- Rider traceability: rider 1 → §4 + §7.4 + §10.7; rider 2 → §2 + §7.1's
  annexe + §10.6 + R-D13; rider 3 → §2 (stated plainly) + §13.1 + §15. ✓
- Bucket-three list closed at five: §7 (item 4 re-scoped by rider 1 — the
  moustache removed; the independence declaration lives under item 1's
  neighbourhood, not as a sixth). ✓
- **Residue well-foundedness (the repaired discipline, §7):** every item
  operationally grounded or marked PENDING with its grounding ruling
  (item 2 → R-D7; item 4 → R-D6; items 1, 3, 5 grounded in §3/§5/§10 —
  item 5 is grounded as OPEN, which is its honest ground); the extended
  ledger's stratification rule checked (one row per channel cost, §2 —
  comparison's cost latent-free, verdict's θ_ask-pricing permitted by the
  empty-cell condition); the retired-constant call-site audit run for
  q/c/λ (§7 rule 3). ✓
- **Promotion proofs (residue as last resort, §7):** every item carries
  its attempted conversions and its grade; the two Grade III items
  (τ frozen; the rod's declared value) each carry the declined
  alternative, the stated reason, and the demand-gate that reopens them;
  no Grade III presented as Grade I. ✓
- Builder touches nothing frozen; every binding act enumerated as the
  author's: §11, §12, R3 throughout. ✓

---

## 15. The sequence (as re-ruled 2026-07-09)

1. ~~Author rules on R-D1..R-D5~~ **DONE** (2026-07-09, with the three
   riders; recorded in §0).
2. Builder, in parallel and neither blocking the other:
   a. **Outcome-capture plumbing** (governor-side, ordinary PRs): the R-D5
      observables logged per governed call; openclaw resolution/latency
      capture ON. **The freeze is gated on this landing (rider 3).**
   b. The **oracle phase**: `test-d/` + `stanza.cabal.draft` + red-run +
      ablation fixtures, runtime-red under the exact gate flags, frozen
      suites green throughout; the §10.11 enumeration budget measured.
      STOP at the Task-2 pack.
3. Author freeze — gated on 2a landed and the Task-2 pack reviewed: applies
   §11's amendments in their own words, rules R-D6/R-D7 (with the
   reference-bad referent named) /R-D8/R-D12/R-D13, extends and re-signs
   the manifest, tags from their own shell.
4. Builder implements to green; anchors byte-stable; increment report;
   reviewer verification block.

The builder never owns a live oracle at the moment it becomes binding.
