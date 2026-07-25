# AGENT_PLAN_REVIEW — the post-step-1 design-review pass

> Builder, 2026-07-14. **Untracked draft; binds nothing until the author's ruling**
> (the `EXTERNAL_REVIEW_RESPONSE.md` precedent: re-verify against the tree, no citation
> from memory). Tree state at review: HEAD `ea891f0` = `code-freeze-r1` (tag verified),
> manifest **83/83**, eleven suites green, `git status` clean. Every verdict below
> carries file:line evidence (R-D20 — grep-checkable). **Nothing frozen moves in this
> pass**; where a finding touches a frozen artifact it is a report, never a fix.
>
> The author's question, verbatim (2026-07-14): *"given that we just massively
> refactored the core of the agent to have a smaller alphabet etc, is it worth making
> one more pass at the design and that it matches the brief and axioms exactly, and
> that the roadmap is rigorous and otherwise optimal?"*

---

## Verdict up front

**The design conforms to the brief and the axioms — as a trajectory, not yet as an
as-built.** No step contradicts an axiom; every rider's scope propagated into a step
obligation; every DEBT names a discharging step **except the ones listed in finding
R6** (an amendment schedule exists but is unassigned). **The roadmap is rigorous. It
is not yet optimal in three orderings** (findings R3, R4, R5), and it carries **two
author-actionable custody items** the plan itself assigns to the author (§9 OPEN 11,
OPEN 12 — `v-open` verified still dangling) plus **four stale-prose rows** (S1–S4).

Nothing found here blocks step 2. Three findings are **cheapest to rule before step 2
opens** (D-2, D-9, and Appendix A ride step 2's own freeze); the rest are plan
amendments rulable at the same gate.

---

## 0. The state of the re-derivation (the question's premise, corrected)

The question says "we just massively refactored the core ... to have a smaller
alphabet." **The refactor is in progress, not complete — and the alphabet is currently
at its LARGEST, by design.**

- Step 1 **added** `Code`/`Pos`/`ToR`/arithmetic; nothing old has been deleted.
  `Bern` (`src/PropLang/Syntax.hs:391`), `EU`/`VAct`/`VThink`/`VThinkK`
  (`Syntax.hs:349-361`), `ExpFam`, `Util`, `Model`, `Terminal` all still stand.
- The intermediate alphabet is `ProdTable 19 2 1 2 7 1` (`Syntax.hs:447`) —
  **32 productions across 6 sorts**, versus the 22/6 the plan started from and the
  22/2 it targets (AGENT_PLAN §5b table, `AGENT_PLAN.md:631-638`).
- The deletions land at steps 3 (`Bern`/`THmm`/`Model`/`Terminal`), 5 (the five
  action types + the sentinel), and 9 (VOI primitives + the FN/UTIL sorts).
  Reflexive closure is step 10 (*"steps 1-9 stand without it"*, `AGENT_PLAN.md:884`).
- Boundaries closed: step 0 (`agent-boundary` on `f46e08c`, `agent-boundary-r1`
  R-D22 re-tag) and step 1 (`code-freeze-r0` on `1027398`, `code-freeze-r1` on
  `ea891f0`). **2 of 11.**

The old/new coexistence is lawful — each deletion lands with its own oracle — but it
has a review consequence recorded in finding R5: **deletion-audit coverage is at its
historic low exactly while the alphabet is at its historic high.**

---

## 1. Brief conformance — brief.md §0–§13 vs the plan and the as-built at ea891f0

Verdict vocabulary from BRIEF_AUDIT.md:9-10: **CONFORMANT** · **RESIDUE-PRINTED** ·
**DEBT** (a violation with a named discharging step). "Discharge" below always names
a roadmap step; a DEBT without one is a finding, not a verdict.

| brief § | claim audited | verdict | evidence |
|---|---|---|---|
| §0/§8 | adaptivity sayable, not handled; no forgetting | **CONFORMANT** as-built | BRIEF_AUDIT D1 stands (test 1 redispersal `test/Anchors.hs:51`; agent beats oracle-tuned forgetter `test/Anchors.hs:84-95`); gate 4's forbidden tokens are the standing grep; nothing in step 1 touched it |
| §1/§5 | "the alphabet IS the prior" — everything priced | **DEBT → steps 5–7** | the action space is still priced at zero (AGENT_PLAN §0 link 5, `AGENT_PLAN.md:41`); step 1's additions ARE priced (`prodTable`, `Syntax.hs:447`; 47 pins re-priced at code-freeze-r0); `Bern` still charges a codeword until step 3 (§1b, `AGENT_PLAN.md:111-116`) |
| §2 | agent, not calculator; reflexive closure | **DEBT → step 10** | the plan's own central diagnosis (§0); closure is the terminal step, correctly last — everything before it is what the verbs must be able to quote |
| §3 | nouns; Event/Kernel peer decision **recorded** | **DEBT → step 9** (assignment is finding D-3) | the four-noun arrangement stands (`AGENT_PLAN.md:459-460`); but brief §3 (brief.md:53) demands the argument be *recorded*, and §9 OPEN 1 holds it with **no due step**. Step 9's deletion audit is the natural adjudicator (`FnInd`-as-`If`-indicator makes `prob` derivable — `AGENT_PLAN.md:1013-1015`) |
| §4 | exactly three verbs; fourth = composition or rejected | **CONFORMANT trajectory**; one recording owed → step 9 | proof (i): VOI is a composition, 45 rows, 1 ulp (`AGENT_PLAN.md:388-398`) — the brief's own named example discharged; `Push` vs `Expect` two-codeword cost (OPEN 3) still unrecorded, falls due when `Expect` gains its binder at step 9 (finding D-3) |
| §5 | no prior object; fineness charged once | **CONFORMANT** | `fromBits` the only prior source (`Belief.hs:133-135`, quoted `AGENT_PLAN.md:160-161`); the charge-once tripwire frozen (`test/Properties.hs:110-155`; BRIEF_AUDIT A8) — still green at r1 |
| §6 | generator = belief-aware costed decision; two kinds, one currency | **RESIDUE-PRINTED** (open research) | §9 OPEN 7 holds it honestly; step 3's declared depth-bounded fragment carries the tripwire *"if the bounded enumeration cannot reproduce a working hypothesis space, stop and report"* (`AGENT_PLAN.md:1055-1059`) |
| §7 | metareasoning terminates in the clock; lazy-genius | **DEBT → step 5** (the pointable line) | proof (iii) passes with zero agent-side constants (`AGENT_PLAN.md:410-441`) but is RIDER-1-scoped (hazard folds the future into the present tick); the brief §12 grep-test still FAILS as-built — the sentinel is pointable at `membrane-wire.md:131` and `Wire.hs:419` until step 5 deletes it (`AGENT_PLAN.md:443-445`) |
| §8 | change families sayable | **CONFORMANT trajectory** | §8b: change families re-based to code sentences with latents (`AGENT_PLAN.md:943`); the per-tick refutation ruling + silent-tick clause binds step 3's integration (`AGENT_PLAN.md:838-852`) |
| §9 | features named; utility latent; **no baked constants**; purity | **CONFORMANT / DEBT → step 8 / see finding R7** | named features + dormancy as-built (BRIEF_AUDIT E1); utility latent = step 8; purity holds (gate 3). **The founding grids** (`thetaPoints`/`tauPoints`/`rhoPoints`, BRIEF_AUDIT A4–A6 DEBT rows) had discharges at R and K — §8b re-based R and discharged K **without assigning the grids a new home** (finding R7) |
| §10 | single reasoner; declared structure; single-responsibility | **CONFORMANT** | `Belief` opaque (gate 2; `spacePoints` leaks points, never weights — reviewed at code-freeze-r0); `Code` carries its algebra as *data* (the body `Expr`), which is §10.2 satisfied more strongly than `ExpFam` ever did; syntax/eval split intact |
| §11 | residues named, not closed | **CONFORMANT** | alphabet/clock/pointer all named; F1–F5 tracked (BRIEF_AUDIT F); the deference-floor measurement (rd14) honestly recorded against F2 |
| §12 | deliverables: per-terminal deletion proofs; the four acceptance tests | **DEBT → step 9, with finding R5** | as-built ablation = `push` + `argmax` only (`audit/ablation.sh:63-66`); step 1 wired the CPP hooks (`#ifndef DROP_CODE`/`DROP_POS`/`DROP_TOR`, `Syntax.hs:38-44`) but **no fixture exercises them** (grep over `test-code/`, `audit/`, `test/`, this review) — the deletion proofs are §5b *arguments* plus the group-4 disagreement pin, not demonstrated ablations. Coverage: **2 of 32 productions** |
| §13 | the disposition | no finding | the step-1 increment declined every bribe on record (the §6 evidence program; the 6.14 stop-and-report) |

**Dimension-1 summary: no contradiction found.** Every DEBT is on the roadmap; the
two §12-class gaps (deletion-proof coverage, the grids' re-based home) are findings
R5 and R7, not conformance failures.

---

## 2. Axiom conformance — A1–A7 as rider-amended, traced into step obligations

| axiom (as amended) | rider scope | propagated to | verdict |
|---|---|---|---|
| A1 — value is `E[ΔU]`, one term | RIDER 1: one tick's Δ; t+5 invisible to choice | §9 OPEN 8; step 8b's falsifier; proof (iii) scoped (`AGENT_PLAN.md:447-450`) | ✅ propagated; **ordering finding R4** on 8b's placement |
| A2 — consequences believed, never known | — | transition model = hypothesis; steps 3 (codes) + 6 (latent memory) | ✅ |
| A3 — only observations; `s` not in the ontology | — | `PureWorld s` scaffolding only; OPEN 11's recommended disposition leans on A3 (Appendix B) | ✅ |
| A4 — actions are features | — | step 6; `last_action`/`lastActionCode`/`ticks_spent_thinking` deleted (`AGENT_PLAN.md:311-328`) | ✅ |
| A5 — structural availability (amended by RIDER 4) | totality, NOT inaction | §5c; §9 OPEN 11 (author-actionable NOW) | ✅ propagated; ruling owed |
| A6 — causation is a hypothesis (epistemic only) | RIDER 3: no decision-theoretic license; RULED → OPEN | §3 rewritten; §9 OPEN 9; step 6b | ✅ propagated; **the critical check passes**: step 6's text says *"the scoring RULE is OPEN"* (`AGENT_PLAN.md:861`) — the plan does not presuppose what 6b must falsify. **But see finding R3**: as *sequenced*, step 6 still lands push-at-assignment before 6b measures it |
| A7 — heuristics may be optimal | dl ≠ runtime; cost MEASURED (`AGENT_PLAN.md:375-378`) | step 10; CL-1-at-the-echo ruling (author-endorsed, kept verbatim) | ✅ |

**Dimension-2 summary: every rider scope is propagated; no step silently assumes an
un-ruled OPEN in its *text*.** The one residual risk is sequencing, not text — R3/R4.

---

## 3. Register hygiene — the nine OPENs, dispositioned into three bins

**Bin A — correctly parked, falsifier/adjudicator owed, but the due step should be
NAMED in the register** (today four of them have none):

| OPEN | subject | due step (recommended) | why there |
|---|---|---|---|
| 1 | Event as peer noun | **step 9** | the deletion audit + type-derivation audit is where `prob`'s derivability (via `If`-indicator under `Expect`-binder) is executed, not argued |
| 2 | the gauge (scale of `E[ΔU]`) | **step 8** | the scale question is CIRL's own (whose utility, in what units); the as-built answer (zero + dollar-slope, R-D7, BRIEF_AUDIT E5) dies with the step table at step 8 |
| 3 | `Push` vs `Expect` two-codeword cost | **step 9** | `Expect` is re-typed (gains its binder) exactly there; record the cost choice in the same freeze |
| 7 | the generator / Cromwell frontier | stays **open research** | step 3 carries its tripwire (bounded-fragment reach; stop-and-report) — correctly not a due step |
| 8 | multi-step value (myopia) | step 8b (assigned) | see finding R4 on placement |
| 9 | `do()` / evidential scoring | step 6b (assigned) | see finding R3 on placement |
| 10 | `ElimJ`'s `Nothing` branch | **step 9** | `ElimJ` lands there; the totality story must be IN its landing oracle, not after |

**Bin B — author-actionable NOW (the plan's own §12 list; both verified live):**

- **OPEN 11 — A5's delegation.** Ruling owed: accept that inaction semantics is
  delegated to world authors, or make the membrane owe a declared inaction row.
  **Recommendation: ACCEPT the delegation** — under the author's own standing
  criterion (deletable-and-declarable ⇒ world data, the deletion-test ruling,
  2026-07-11), "what inaction looks like on this lever" is physics, i.e. world
  content; and under A3 the agent has no ontology in which "nothing happened" is a
  distinguished event. The agent's guarantees (argmax totality, termination in the
  clock) are structural and need no inaction semantics (`AGENT_PLAN.md:67-77`,
  §5c). A declared inaction row would re-introduce exactly the convention §5c
  deleted. Cost to record: worlds CAN make the first grid point a launch — that is
  the world author's declaration, visible in the hello, priced like everything else.
- **OPEN 12 — CANCEL `v-open`.** Verified this review: `v-open` exists
  (annotated, R1–R7 in its message), **no `v-freeze`, no cancellation** — the
  custody defect §8b surfaced is still live. **Recommendation:** the author, from
  his own shell, signs a cancellation tag —
  `git tag -s v-cancelled ea891f0 -m "V cancelled: its subject (VThink/VThinkK/VPre) is deleted by AGENT_PLAN proof (i); the boundary closes without a freeze (§8b, OPEN 12)"`
  — the tag is the attestation, per the custody doctrine. *(Session memory has
  recorded V as "cancelled" since 2026-07-12; the repo's custody record does not.
  This is precisely why the formal act matters.)*

**Bin C — re-dispositionable on step-1 evidence: checked, and the answer is NO for
both.** OPEN 1: `Code`'s landing does not touch Event's peer status (likelihood
assignment never routed through `Event`). OPEN 3: step 1 added arithmetic to `Expr`,
not verbs; the two-constructor encoding question is unchanged. Both stay open with
their Bin-A due steps. *(Recorded so nobody re-checks; the check was made.)*

---

## 4. Roadmap rigor and ordering — findings

**R1 — the 2-before-3 ordering is correct; its proof is now RECORDED (it was
folklore).** Step 3 deletes the old hypothesis representations on bit-for-bit
reproduction claims. The instrument that adjudicates such claims is the optimisation
law, whose enforcement today is (a) CL-4 at `1e-9` — 360,000× wider than the noise
floor (§2b; post-step-1 re-measure 2.971e-15 Saw / 1.191e-15 Is over 200k cases,
pack §7, satisfying the author's re-measure rider) — and (b) **nothing at all** for
`observeCounts` (`Enumerate.hs:680-682`; its only test is wire syntax,
`test-d/D.hs:1041` per §1b's audit table). And `observeCounts`' correctness
*guarantee* (sufficiency from the alphabet) is exactly what step 3 destroys — the
pin must pre-exist the demolition. **Harden the instrument, then certify the
demolition. Step 2 is correctly next.**

**R2 — step 2's scope should be PINNED to the §1b audit table, or "generalise E7
from a one-off to the rule" invites scope creep.** The audit table
(`AGENT_PLAN.md:118-129`) has exactly three rows: `bernFast` (already pinned by E7),
the `cond` engine (CL-4 — tighten to `1e-12`), `observeCounts` (pin to repeated
`observe`). **Recommendation: step 2 = those three rows + the law's text into frozen
CLAUDE.md + Appendix A's canonization riding the same author edit. Nothing else.**
Note the CL-4 repair mechanics: `test/Properties.hs` is Phase-1-frozen; the repair is
an author re-open (named and signed at step 2's boundary, per §2b's own words
"named here and signed, never slipped in") with the manifest row recomputed.

**R3 — 6b should run as the ORACLE-PHASE EVIDENCE PROGRAM of step 6, not as a
post-landing step.** As sequenced (`AGENT_PLAN.md:860-867`), step 6 lands
push-at-assignment scoring and 6b then measures whether it is dominated. That is
falsifier-after-commitment — if 6b fires, step 6's landed rule re-opens. The house
already has the better pattern, proven at step 1: the §6 evidence program (E1–E7,
throwaway prototypes, R-D21) ran BEFORE the rulings, and the rulings were made on
executed evidence. The confounded-payoff world needs only a prototype scorer, not a
frozen one. **Recommendation: fold 6b into step 6's oracle phase** — the falsifier
executes on a throwaway prototype first; whichever scoring rule survives is what the
step-6 oracle pins; the freeze then never encodes a rule the falsifier convicts.

**R4 — same for 8b, with one asymmetry acknowledged.** 8b
(`AGENT_PLAN.md:876-879`) is placed after step 8 lands. Its outcome is a ruling
fork (kernel-composition production WITH deletion proof, or myopia printed as scope
limit) — running the payoff-at-t+5 world pre-freeze on a prototype means step 8's
oracle already encodes the ruled outcome instead of amending it afterwards. The
asymmetry: unlike 6b, 8b's falsifier is *expected* to fire (the myopia is a known
live defect, OPEN 8) — but that strengthens the case: a freeze that already knows
its scope line is cleaner than a freeze followed by its own conviction.
**Recommendation: 8b becomes step 8's oracle-phase evidence program.**

**R5 — deletion-proof coverage is at its historic LOW while the alphabet is at its
historic HIGH; from step 3 onward, new productions should carry their ablations
in-increment.** Verified: gate 7 ablates `push` and `argmax` only
(`audit/ablation.sh:63-66`). Step 1 wired the ablation HOOKS — the new constructors
sit behind CPP flags (`Syntax.hs:38-44`, `:199-238`), gate 7's own mechanism — but
**no fixture exercises any of them** (no `DROP_CODE`/`DROP_POS`/`DROP_TOR` token in
`test-code/`, `audit/`, or `test/`, grep this review): 2 of 32 productions
demonstrated, against brief §12's per-terminal standard. The plan defers the full
audit to step 9.
Two lawful dispositions: accept as transitional debt (the plan as written), or amend
practice so each step's NEW productions land with increment-local ablations
(CLAUDE.md increment protocol already houses them: *"increment-local ablations carry
their own fixtures and runner inside the increment's oracle directory"*).
**Recommendation: the latter, from step 3 onward** — cheap (the hooks are already
wired; only fixtures are missing), and it is exactly the class of check that caught
§5d's conflation. Step 1's gap is recorded here, not retro-fixed (its proofs exist
as §5b arguments plus the group-4 pin; re-opening test-code to add fixtures is not
worth an oracle amendment). The `Code`/`Pos`/`ToR` fixtures can instead land inside
step 3's oracle directory, where the alphabet they ablate is next touched.

**R6 — the frozen-prose amendment schedule is unassigned, and only one item of it
has actually happened.** §8 lists prose "to amend at this boundary"
(`AGENT_PLAN.md:917-921`); verified by `git diff f46e08c..HEAD`: **only
`typed-port-spec.md` moved** (the spacePoints export line, at code-freeze-r0).
`interface.md`, `EXPFAM_PLAN.md`, `HOSTS_PLAN.md`, `membrane-wire.md`,
`host-governor/Wire.hs`, `CLAUDE.md`, `design.md` — none amended, and no step is
assigned to any of them. The amendments are in fact being paid per-step (correct —
R-C3 cuts both ways: prose must not go stale, but amending M5's text before M5's
repeal lands would *make* it stale). **Recommendation — adopt the assignment
table:**

| frozen prose | amend at | why there |
|---|---|---|
| `CLAUDE.md` — the optimisation law + Appendix A | **step 2** | step 2 IS the law's boundary |
| `test-expfam/ExpFam.hs` group 6 retirement (§8's re-open table row 2) | **step 3** | sufficiency's guarantee dies when arbitrary codes become enumerable, not before (group 6 still green as-built, `test-expfam/ExpFam.hs:247-255`) |
| `interface.md` (T1, load-bearing clause scope), `EXPFAM_PLAN.md` (T1, E9) | **step 3** | hypotheses become sentences there |
| `design.md` / `typed-port-spec.md` (`prodTable` prose) | **each alphabet-moving step** | the P5 clause's own rhythm |
| `membrane-wire.md` + `Wire.hs` (sentinel, `missing-internal-row`) | **step 5** | the sentinel dies there |
| suite retirements (`ladder`, `prepost`, `cirl`, `govhost`, `test-d`, membrane's action parts) | **the step that falsifies each** (first: step 5 — the M5 guardian `Membrane.hs:340-350` and the t1 parity world `:156-159` break by construction) | retiring before the falsifying step deletes live evidence; after, keeps a red suite |
| `HOSTS_PLAN.md` (M5) | **step 7** | the repeal lands there |

**R7 — three re-based items of the supersession map have no scheduled home; say
where they live.** §8b re-bases R (vocabulary purchase → grid refinement over code
constants), change families (→ code sentences with latents), and notes A and B
survive demand-gated — but none appears in steps 1–10, and CLAUDE.md's roadmap text
still carries the old HOSTS_PLAN sequence. Not a defect (demand-gated work lives
outside the roadmap by design), but the map should end with one line: **R-rebased,
change families, A, and B are POST-ROADMAP demand-gated boundaries, each opening
oracle-first under its own tag when its gate fires; the founding grids' DEBT rows
(BRIEF_AUDIT A4–A6) transfer to R-rebased.** Otherwise the repo again carries
program items whose custody home is nowhere written — the exact "M5 of process"
RIDER 5 was about.

**R8 — one live ambiguity between steps 6 and 7: WHEN do action names join the
priced namespace?** Step 6 puts actions in the feature stream and lets hypotheses
mention them; step 7 has writable names "join the namespace" with RIDER 2's
immutable-membership pin. If action-name mentions are priced only at step 7, then
for one whole increment step 6 ships model sentences whose action mentions are
either unpriced or priced against a namespace that then changes — **path-dependent
prices for one increment, the exact incoherence RIDER 2 names**
(`AGENT_PLAN.md:779-785`). **Recommendation: RIDER 2's declaration binds at step 6**
— the hello's namespace includes writable names from step 6's freeze onward, so
mention prices are over the completed namespace from the first increment that can
utter them; step 7 keeps M5's repeal, the value-pricing of assignments (the action
space entering the prior), the wire sentence, and the byte-stability fixture.
Alternative: merge 6+7 into one boundary. Either resolves it; ruling owed at or
before step 6's oracle. *(Why the fixture stays at 7: before step 6 no hypothesis
mentions a writable name, so the mid-episode-publication fixture is vacuous
earlier.)*

---

## 5. Stale prose — amendment candidates (author-gated; AGENT_PLAN is tag-covered)

- **S1 — §12 item 2** (`AGENT_PLAN.md:1160`): *"The builder has made no tag"* — stale
  since `agent-boundary`/`agent-boundary-r1` (both verify). Item 1 (OPEN 11/12)
  remains genuinely outstanding. Amend to reflect item 2 done, item 1 open.
- **S2 — §5d's custody paragraph** (`AGENT_PLAN.md:739-742`): *"R-D22 therefore
  obliges an author RE-TAG ... The builder has ... made no tag"* — discharged by
  `agent-boundary-r1` (its message records the R-D22 re-tag). Mark discharged.
- **S3 — the header** (`AGENT_PLAN.md:6`): *"manifest 81/81, as of this draft"* —
  correct as dated; an "as of code-freeze-r1: 83/83" line could ride any amendment.
  Cosmetic.
- **S4 — no progress register.** Steps 0 and 1 read as future work. One line per
  closed step (step 0 ✓ `agent-boundary`/`-r1`; step 1 ✓ `code-freeze-r0`/`r1`,
  pack §7) makes the plan carry its own ledger — the cheapest defense against the
  next stale-prose row.
- **S5 — BRIEF_AUDIT.md's stale prices** (named by §8b itself: `nodeB = lg 10`,
  `ProdTable 10 2 1 1 7 1`, `Bern` at `lg 10 + lg 5`). BRIEF_AUDIT is a dated audit
  record, not an oracle — **do not rewrite its rows**; prepend a dated supersession
  header pointing at AGENT_PLAN §8b and this review. An audit that silently edits
  its own history is worse than one that cites dead prices.

*(Line-number drift noted en route: §1b cites `observeCounts` at `Enumerate.hs:649`;
it sits at `:680-682` at r1. Update whenever the section is next touched; not worth
an amendment alone.)*

---

## Appendix A — the R-D21 sharpening: canonization draft for CLAUDE.md

Queued at step 1's close (pack §7 item 4; the group-3 re-open, `code-freeze-r1`).
Proposed text, to be appended to CLAUDE.md's increment-protocol item 2 where R-D21
is stated — **author edit, at step 2's boundary, riding the same edit as the
optimisation law:**

> A transcript proves only the row text ACTUALLY FROZEN (the step-1 group-3
> re-open): before the freeze seals a red row, its exact drafted expression — never
> the prototype's own variant of it — is executed once against the prototype; and
> the transcript must force the frozen side of every comparison row to normal form,
> independently of the stub side (one `deepseq` per row), proving the red is
> attributable to the missing implementation rather than to a defect the stub
> happens to shadow.

*(Second clause restated mechanically per the author's ruling, decision 4,
2026-07-15 — "lifting the stub one layer" invited litigation over what a layer is;
the `deepseq` form is unambiguous and grep-checkable.)*

And the pattern the gate adopted as protocol (decision 6's closing observation),
drafted for the same CLAUDE.md edit:

> An increment whose step carries a falsifier runs it as an ORACLE-PHASE EVIDENCE
> PROGRAM: executed on throwaway prototypes (R-D21), success criteria pre-stated
> numerically, before any ruling freezes — so a freeze never encodes what its own
> falsifier convicts (the step-1 §6 evidence program, made protocol rather than
> precedent).

Provenance for the author's review: the drift the first clause canonizes against is
recorded in pack §6.14 (group 3 froze with `point thetaSpace (logit θ)` — massless
always — while the §2 transcript had executed the eta-domain idiom the drafted row
lacked).

---

## Appendix B — the decision sheet

Rulings requested, each with the recommended option and its evidence pointer.
Items 1–2 are the author's own §12 list; items 3–4 are cheapest before step 2 opens;
the rest are plan amendments rulable at the same gate and applied under the recorded
delegation pattern with an author re-tag (`agent-boundary-r2`) or riding step 2's
freeze tag (R-D22 either way).

| # | ruling | recommendation | evidence |
|---|---|---|---|
| 1 | **OPEN 11** — A5's inaction delegation | **accept the delegation** (inaction semantics is world data; agent guarantees are structural) | §3 Bin B; §5c; A3; the deletion-test criterion |
| 2 | **OPEN 12** — cancel `v-open` | **sign `v-cancelled` from your own shell** (command drafted in §3 Bin B) | §8b V row; proof (i); tag state verified this review |
| 3 | step 2's scope | **pin to the §1b audit table + CLAUDE.md law text + Appendix A** | finding R2 |
| 4 | R-D21 sharpening canonization | **adopt Appendix A's text at step 2's boundary** | pack §6.14/§7 |
| 5 | due-step assignments for OPEN 1→9, 2→8, 3→9, 10→9 | **adopt** (register amendment) | §3 Bin A |
| 6 | 6b and 8b as oracle-phase evidence programs of steps 6 and 8 | **adopt** (the step-1 precedent: evidence before rulings, R-D21 prototypes) | findings R3, R4 |
| 7 | RIDER 2's namespace declaration binds at **step 6** (M5 repeal + fixture stay at 7), or merge 6+7 | **bind at step 6** | finding R8 |
| 8 | step-3 obligation row: the model-fragment table is DECLARED through `bitsAt` from day one (no interim hand-count) | **adopt** | §7 step 4's own complaint about hand-rolled literals (`AGENT_PLAN.md:853-857`) |
| 9 | in-increment ablations for new productions, step 3 onward | **adopt**; step 1's gap recorded, not retro-fixed | finding R5 |
| 10 | the frozen-prose amendment schedule | **adopt the R6 table** | finding R6; `git diff f46e08c..HEAD` |
| 11 | §8b closing line: R-rebased / change families / A / B are post-roadmap demand-gated boundaries; grids' DEBT transfers to R-rebased | **adopt** | finding R7 |
| 12 | stale-prose amendments S1–S4 + BRIEF_AUDIT supersession header (S5) | **adopt** | §5 |

**None of these blocks step 2.** With items 3–4 ruled, step 2 can open oracle-first
immediately; the remainder can land in the same amendment commit the step-2 freeze
countersigns.

---

## Appendix C — the author's rulings (2026-07-15), verbatim, and the enactment ledger

All twelve adopted; decisions 3, 4, 6, 7, and 9 with additions. The full message
(R-D20 — copied, not reconstructed; this is also the delegation the enactment commit
executes under):

> Rulings on all twelve, the two priority items at depth. Everything here is
> advisory; the tags are yours.
>
> **Decision 3 — adopt, with one addition and one pre-emption.** Pinning step 2 to
> the §1b audit table is right — "generalise E7 to the rule" is exactly the phrase
> scope creep loves — but the table was compiled *before* step 1's implementation
> landed, and freezing it as the law's enforcement surface presumes it is still
> exhaustive. So the scope should be: the three rows, the law's text into CLAUDE.md,
> Appendix A — *plus a one-time completeness sweep of the r1 tree for unpinned fast
> paths*, recorded in the step-2 pack. If the sweep finds nothing, the table freezes
> as exhaustive-at-r1, and "the rule" thereafter means: every future fast path
> arrives with its pin in-increment (the CLAUDE.md clause), never by appending to
> step 2. That closes the generalisation ambition without opening the scope. The
> pre-emption: the `observeCounts` pin will face CL-4's own tolerance question —
> batch collapse versus sequential conditioning is exact in ℝ and only approximately
> so in the machine — so measure the residue over the frozen worlds *before*
> choosing bit-exact or toleranced, per the tolerance protocol. Do not let the pin
> be born with a round number; that is how the `1e-9` happened.
>
> **Decision 4 — adopt, with the second clause restated mechanically.** The first
> clause (execute the exact drafted row text, never the prototype's variant) is
> precisely the §6.14 defect made unrepeatable — canonize as written. The second
> clause is right in intent and too informal to freeze: "lifting the stub one layer"
> invites litigation over what a layer is. The defect it targets — a lazy thunk
> masking a both-sides crash as a clean red — has a mechanical kill: *the transcript
> must force the frozen side of every comparison row to normal form, independently
> of the stub side*. One `deepseq` per row, unambiguous, grep-checkable, and it
> proves the red is attributable to the missing implementation rather than to a
> defect the stub happens to shadow. Ride it on the same CLAUDE.md edit as the law,
> one author re-tag.
>
> The remainder, for the step-2 amendment commit:
>
> **1 — accept the delegation.** The reasoning is the one that survives: under A3
> the agent has no ontology in which "nothing happened" is distinguished, and a
> declared inaction row would re-install the convention §5c deleted. Record the cost
> line verbatim (a world can make its first grid point a launch; visible in the
> hello, priced) — that sentence is the register's protection against someone later
> "fixing" it.
>
> **2 — sign `v-cancelled`.** The drafted message is correct and cites the right
> evidence. Session memory asserting what the custody record doesn't is exactly the
> divergence the tag discipline exists to prevent; the fact that it sat undetected
> for two days is the argument for S4's progress register.
>
> **5 — adopt** the due-step assignments as recommended. All four land where their
> adjudicating machinery lives; OPEN 10's placement (totality story *in* ElimJ's
> landing oracle, not after) matches the original rider.
>
> **6 — adopt**, with two riders. For 6b: pre-state the falsifier's success criteria
> numerically — what counts as dominated, over what horizon exploration must rescue
> the choice — or the evidence program adjudicates by eyeball, which the step-1
> E-programs never did. For 8b: the fork's first arm (kernel-composition production)
> must be *priced* in the prototype, not merely demonstrated — prodExpr moves again,
> P5 fires again — so the ruling sees the bit cost beside the capability.
>
> **7 — adopt "bind at step 6".** R8's hole is real and it is RIDER 2's incoherence
> wearing a sequencing hat. One obligation to name: step 6's oracle must contain no
> assignment-priced row — mention prices bind at 6, value prices at 7 — else the
> pins pay R-C4's double-repricing a second time.
>
> **8 — adopt.** No hand-counted bits; the plan's own step-4 complaint rules it.
>
> **9 — adopt the in-increment practice**, and name the `Code`/`Pos`/`ToR` fixture
> row in step 3's opening checklist *now* — an adopted practice without a named row
> is R6's disease, and the hooks being already wired makes the fixtures the cheapest
> audit coverage this project will ever buy.
>
> **10 — adopt the R6 table as written.** Its central discipline — amend at the step
> that falsifies, never before (premature staleness) nor after (red suites, dead
> evidence) — is correct on both edges, and the suite-retirement row states it
> exactly.
>
> **11 — adopt.** Demand-gated with a written custody home and the grids' DEBT
> transferred to R-rebased is honest; the DEBT rows staying printed under S5's
> supersession header is what keeps "no deadline" from decaying into "forgotten".
>
> **12 — adopt**, and S5's principle deserves its sentence in CLAUDE.md eventually:
> a dated audit is a record, not an oracle — prepend, never rewrite.
>
> One observation across the whole sheet: the review's best structural finding is
> R3/R4's inversion — falsifier-before-freeze as the house pattern rather than a
> step-1 accident. Adopting decision 6 quietly makes the §6 evidence program the
> *protocol*, not a precedent, which is worth a line in the same CLAUDE.md edit so
> the pattern survives the builder that discovered it.

### The enactment ledger (all edits 2026-07-15, one builder-key commit)

| decision | enacted |
|---|---|
| 1 | `AGENT_PLAN.md` §9 OPEN 11 → RULED; the cost line recorded verbatim in the row |
| 2 | **✅ discharged same day**: the author signed `v-cancelled` on `ea891f0` from his own shell (verified: good ED25519 signature, the author key); §9 OPEN 12 closed — no dangling boundary tag remains |
| 3 | §7 step 2 scope pinned: three rows + CLAUDE.md edit + completeness sweep (exhaustive-at-r1 on empty) + the `observeCounts` residue-before-tolerance pre-emption |
| 4 | Appendix A clause 2 restated to the `deepseq` normal-form rule (above); rides step 2's CLAUDE.md edit |
| 5 | §9 due steps: OPEN 1 → 9, OPEN 2 → 8, OPEN 3 → 9, OPEN 10 → 9 (in ElimJ's landing oracle) |
| 6 | §7: 6b → step 6's oracle-phase evidence program (numeric criteria pre-stated); 8b → step 8's (kernel-composition arm PRICED); the protocol line drafted in Appendix A for step 2's CLAUDE.md edit |
| 7 | §7 steps 6/7: membership declaration binds at 6; value prices at 7; step 6's oracle carries NO assignment-priced row |
| 8 | §7 step 3: model-fragment table DECLARED through `bitsAt` from day one |
| 9 | §7 step 3: `Code`/`Pos`/`ToR` ablation fixtures named in the opening checklist; in-increment ablations the rule from step 3 on |
| 10 | §8: the amendment schedule table replaces "at this boundary" |
| 11 | §8b: custody-home closing paragraph; grids' DEBT → R-rebased |
| 12 | S1 (§12 rewritten), S2 (§5d discharge line), S3 (header status block), S4 (§7 progress register); S5 (BRIEF_AUDIT supersession header prepended). The "prepend, never rewrite" CLAUDE.md sentence: **queued, no due boundary** ("eventually" — not added to step 2's pinned scope, which decision 3 closed) |

Custody: these edits are delegated freeze-edits to a tag-covered document, executed
under the delegation quoted above; **the R-D22 re-tag rides step 2's freeze** (the
author's "for the step-2 amendment commit"). The builder commits with the builder
key and makes no tag.

*— review delivered 2026-07-14; rulings received and enacted 2026-07-15 (this
appendix); nothing manifest-frozen touched.*
