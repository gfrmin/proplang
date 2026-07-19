# WIRE_PLAN — the wire boundary (roadmap re-open, 2026-07-20)

Opened against the 14 GitHub issues filed 2026-07-19/20 (external audit
of `7da274b` `reflexive-freeze-r0` + demand registrations from live
would-be hosts). The step-10 roadmap terminated; this document is the
new roadmap boundary that CLAUDE.md's termination clause requires for
further scope. Custody: drafted by the builder under the author's
fresh instruction of 2026-07-20 — "open boundary and implement" —
recorded here and in the opening tag verbatim; every delegated freeze
under this boundary carries R-D22's obligation (the boundary does not
close until the author's own signed tags cover it).

## 0. The issues, triaged and verified

All eight audit findings verified against HEAD before this boundary
opened (builder triage 2026-07-20; greps and line references in §7).

| issue | finding | class |
|---|---|---|
| #1 | said@1 utility priced at zero; no parameter latent; membrane-wire §3 false | implement (W4) + doc truth (W2) |
| #2 | VoI non-negativity homed at step 9, never landed, no live register | owed law (W2) |
| #3 | Div/Log/Exp/Neg priced, wire-unreachable | implement (W4) |
| #4 | theta grid host-hard-wired; wire p1 capped at 0.9 | implement (W3) |
| #5 | flat-p1 never re-measured post-re-derivation | measured at opening (W1) — **does not reproduce** |
| #6 | no perf number; "build only if slow" unfalsifiable | measured at opening (W1) — instrument lands |
| #7 | four stale docs unmarked | frozen-layer sitting (W2) |
| #8 | wire ships myopic; ladder is oracle-only | implement (W4) + doc truth (W2) |
| #9 | demand: K-ary observations (answer-brain) | implement (W3, joint with #4) |
| #10 | ruling: mid-episode K growth | author ruling (§5) |
| #11 | demand: increment B, two-stream inverted polarity | author gate reading (§5) |
| #12 | demand: routing (governor boot blocker) | author ruling (§5) |
| #13 | demand: continuous carriers, expecting wontfix | author ruling (§5) |
| #14 | demand: coupled utility latents | registered; #4 prerequisite (§5) |

## 1. W1 — the opening measurement (EXECUTED before this document froze)

Per the evidence-program clause: criteria pre-stated numerically, run on
a throwaway prototype against the shipped wire path (`serveLine`, zero
src diff), before any ruling froze. Pre-statement and prototype ride the
boundary pack; transcript:

**Program 1 — contrast-context p1 (issue #5).** World: namespace
`[t, risk, m]`, guard `risk@[0.5]`, menu `m@[0.0]`. 60 ticks, evidence
perfectly correlated with `risk` (alternating). Probes after training:

```
p1(attack risk=1) = 0.8970592646390182
p1(benign risk=0) = 0.1029407353609769
p1(empty)         = 0.10294073536097696
S = 0.794119   (pre-stated gates: C1 discrimination S >= 0.4;
                C2 flat-defect replication S < 0.05; C3 ceiling <= 0.9)
```

- **C1 PASS at 0.794** (theoretical max on the shipped grid: 0.8). The
  re-derived engine is a genuine function of context when the signal
  is present. SCOPE (the mandate-5 guard, ruled at the sitting like
  the timing non-comparability): the attack/benign/empty names here
  are SYNTHETIC risk-bit contexts, not the govhost corpora — what
  this refutes is the STRUCTURAL half of the flat-p1 finding ("the
  engine is a near-constant function of context"), the half
  measurable host-free. A host-corpus differential re-run on real
  governance features remains unmeasured and is not claimed. Issue
  #5's oracle ask (contrast streams asserting discrimination) closes
  with the pinned row; its corpus question re-opens with a host.
- **C3 PASS at 0.897** — issue #4's structural cap confirmed by
  measurement: posterior concentrates on the risk-guard family at
  theta = 0.9/0.1 and can go no further. The W3 change is therefore
  load-bearing, not cosmetic.
- p1(empty) == p1(benign) to 1e-15: a missing feature reads as 0.0
  (`Eval.hs:80` `fromMaybe 0.0`) — the empty stream is extensionally
  the all-zeros stream at the predictive. Pinned as declared semantics
  (test-measure g1), not left as folklore.

**Program 2 — ms/tick at the pinned populations (issue #6).**
Wire-inclusive (JSON parse + reply print through `serveLine`), 100
observed ticks, -O2:

| population | pin source | hello | ms/tick |
|---|---|---|---|
| 1169 | Enumerate.hs:329 | 0.0 ms | 9.4 |
| 1241 | Sentence.hs:288 | 0.3 ms | 10.3 |
| 1529 | Unify.hs:125 | 0.3 ms | 14.4 |
| 1601 | Unify.hs:126 | 0.4 ms | 14.6 |

Same order as the demolished engine's 8.26 ms/tick at 1241 (recorded to
prevent accidental comparison — different engine, not comparable).
Within an interactive governance budget (low tens of ms). **The "build
only if slow" gate is now falsifiable and does not fire at current
populations.** The instrument lands as test-measure g2 (report rows +
population-pin assertions, run at every freeze).

## 2. Root causes — why the issues arose (author's question, answered)

Four failure classes, investigated by three independent researchers at
the opening (full reports: wire-author-pack.md Part III). Each ends in
a remedy that binds this boundary.

- **RC-1 — incorrect documentation (issues #1, #7).** The repo's only
  doc-repair mechanism — the frozen-layer inventory (step 7) — is
  scoped THREE ways too narrowly: FROZEN-only (AGENT_PLAN.md and
  HOSTS_H_REPORT.md are unfrozen, so its register and stale
  classifications had zero coverage), INCREMENT-LOCAL (WRITEUP honesty
  #4 was falsified at step 1, four boundaries before the clause
  existed, so no later sitting owned it), and RULING-NAMED (a
  falsification no ruling names is invisible). The step-8/9
  anti-staleness instruments police TEST FILES — a false `.md`
  sentence builds against nothing. Sharpest instance: membrane-wire's
  said@1 pricing claim NEVER held — it landed at step 8 already false,
  vocabulary carried over from the retired `latent@1` engine and
  asserted as a property of a path that never built it. A silent
  overload compounded it: "arithmetic-free" shifted meaning (no
  operators → no formula meta-language) across the same window.
  **Remedy:** the whole-corpus doc audit — at every boundary sitting
  the inventory sweeps the ACCUMULATED corpus (frozen and unfrozen)
  against the shipped code, not just what this increment's rulings
  touched. First execution: this opening's W2 sitting (seven repairs).
- **RC-2 — the g4Self disease (issue #2).** The VoI non-negativity
  obligation was carried CORRECTLY to step 9's opening checklist —
  then dissolved there, because it was a parenthetical inside a
  three-property COMPOSITE row whose other two members were already
  satisfied at step 6; the composite read "mostly done", the step-9
  pack promoted the row's own caveat ("a pin written to die") into
  its disposition, and no per-obligation discharge accounting forced
  the miss visible: no D-f ruling, no oracle row, no deferral mark.
  g4Self survived its identical journey because it had all three
  things VoI lacked: a register ruling at the retiring freeze, a
  standalone bold checklist row, an explicit "DISCHARGED here" event.
  **Bundling is what killed it — atomic obligations with their own
  discharge marks survive; sub-clauses of a satisfied composite
  evaporate invisibly.** **Remedy:** OBLIGATIONS.md, the atomic
  obligations ledger (one row per obligation, greppable states), plus
  the OB-row in tools/boundary-audit.sh: every SCHEDULED@X or
  RETIRE-UNTIL-X row whose target tag exists must have resolved —
  run at step 9's close this fires instantly on the VoI row.
- **RC-3 — the grid ceiling (issue #4).** NOT mere staleness. The
  classification ("frozen alphabet-data change", HOSTS_H_REPORT of
  2026-07-09) was TRUE when written and went half-stale two days
  later when `0170a40` parameterized the enumeration — but the
  parameter was built for the AGENT (boundary R's re-enumeration
  primitive), and the author's directive of 2026-07-11
  (METAREASONING_PLAN.md:30, :216) then CONDEMNED the host-declared
  emission grid as a category error — "precision is the agent's
  resource… purchased, not declared"; "No emission grid key. No
  vocabulary declaration of any kind." The sanctioned lift path —
  agent-purchased refinement, V→R — was then closed twice: V
  formally cancelled (2026-07-15), R never built, roadmap terminated.
  So the ceiling stands because a deliberate refusal outlived the
  roadmap that was supposed to provide its alternative, while the
  stale classification HID the refusal from the audit (issue #4
  argues against the classification, not against the condemnation it
  concealed). **Remedy:** the conflict goes to the author as this
  boundary's FIRST RULING (§5 R-W1) — the builder implements neither
  side of a standing author condemnation on delegation.
- **RC-4 — the myopic wire (issue #8).** Deliberate, documented, and
  then orphaned. Myopia was ruled on the record (HOSTS_PLAN register
  item 12: engine-swap parity with a myopic incumbent; "the myopic
  case is the ladder's chosen rung, not a branch; depth is bought by
  measurement") and membrane-wire DOES name the rule myopic — at
  :214-224, inside the sections bracketed HISTORICAL at step 7, which
  is why the live wire spec reads silent. Both upgrade routes were
  formally closed (D0 skipped by R-D2; boundary V cancelled), and
  step 10 proved the ladder sayable as a PIN through `evalx` — zero
  src diff, driver never in frame. **The cross-cutting spine of RC-3
  and RC-4: boundary V's cancellation orphaned both remedies.**
  **Remedy:** the live-section myopia statement landed at W2 (the
  §3 bracket); shipping the ladder is §5 R-W2, the V-question
  re-put to the author with the step-10 composition now in hand.

## 3. The steps

Each step follows the increment protocol in CLAUDE.md unchanged
(oracle-first, R-D20/21/22, SAT transcripts flag-faithful, pre-freeze
lint, boundary audit + red-team mandates at each freeze, frozen-layer
inventory at each sitting).

**W1 — measure (this opening).** The evidence program above, pinned as
`test-measure/`: g1 the contrast-discrimination rows (S >= 0.4 on the
exact stream; empty == all-zeros semantics; ceiling row), g2 the timing
instrument (population pins asserted; ms/tick reported, no gate).
Pin-freeze form: the capability pinned (context discrimination) is
already shipped; red demonstrated by seeded defect (fragment restricted
to drop FGuardHead → flat p1 → g1 red).

**W2 — owed laws + the frozen-layer sitting.**
(a) VoI non-negativity lands law-grade over the surviving
Expect-composition (the step-9 owed row, AGENT_PLAN.md:1121-1126),
plus the two decision-side properties already partially enforced
re-checked at the same sitting.
(b) The frozen-layer inventory executes over the WHOLE doc corpus (not
only increment-touched files — RC-1's remedy): WRITEUP.md honesty #4
in-place repair with the falsified sentence quoted; AGENT_PLAN.md
progress register corrected; dated historical brackets on
HOSTS_PLAN.md, HOSTS_H_REPORT.md, boundary-queue.md; membrane-wire.md
§3 repaired to state what ships (said@1 point mass today; the shipped
decision rule is myopic one-step EU) — repaired FIRST, then W4 makes
the stronger sentences true again and re-repairs.

**W3 — the handshake extension (#9; #4's half CONDITIONAL on ruling
R-W1).** The unconflicted half: observation arity declarable at the
handshake (carrier/space sized per world, default binary — increment
A's fired gate; world-structure data like the namespace and guards,
which the hello already accepts, NOT latent fineness, so outside the
METAREASONING condemnation's terms). Population pins re-pinned at the
default in the same increment (the optimisation law). The emission-
grid half (OB-4) executes here IFF the author rules R-W1 open —
mechanically it is the same hello-field pattern, one additional
optional key, default `thetaPoints` bit-identical.

**W4 — wire completeness (#1, #3; #8's half CONDITIONAL on ruling
R-W2).**
(a) `parseSaid` extended to the full priced grammar (Div/Log/Exp/Neg;
`<` composes as swapped Gt — NOT a new form unless ruled).
(b) said@1 priced: the declared program's `bits` charged against the
declared grids and returned in the hello reply; constants priced
against a declared constant grid rather than fresh singletons — the
grid-priced parameter latent lands per membrane-wire §2's original
promise, or that promise is narrowed at the sitting if the latent
proves to want an alphabet change (stop-and-report if so).
(c) IFF R-W2 rules it open: the deliberation composition ships behind
the wire — host-side assembly of the step-10 composed sentences
(Push-iterated, priced per rung, argmax across rungs), zero new
productions (step 10's theorem), the myopic case remaining the
ladder's chosen rung at depth-1 prices; membrane-wire.md then
re-states the shipped rule truthfully.

**Rulings register (§5) travels with every sitting.**

## 4. What this boundary does NOT open

Increments B (two-stream), routing, continuous carriers, coupled
latents, mid-episode K growth: registered in §5, opened only by their
own author rulings. The Cromwell frontier stays the declared open
research boundary. P5's single-site alphabet-constant clause binds
throughout: W1-W4 move ZERO alphabet productions (W3 moves enumerator
data and space data; W4c is composition only). Any step that finds
itself needing a production stops and reports.

## 5. The demand/rulings register

**The two conflicts surfaced by the opening's root-cause work — the
boundary's first ruling requests, evidence assembled, builder
recommendation stated, decision the author's:**

- **R-W1 — the emission grid vs the METAREASONING condemnation
  (issue #4 / OB-4).** Standing directive (author, 2026-07-11,
  METAREASONING_PLAN.md:30, :216): host-declared latent fineness is a
  category error; "No emission grid key." Standing facts against
  holding it unchanged: the sanctioned alternative (V→R,
  agent-purchased refinement) was cancelled/never built and the
  roadmap terminated; every registered live host binds at 0.9+
  thresholds (0.95/0.96/0.9942); W1 measured the ceiling at 0.897 on
  a perfectly-informative stream. Three coherent outcomes: (i) HOLD
  the condemnation and OPEN R (agent-purchased refinement — the
  principled path, real research scope); (ii) REPEAL at this boundary
  (a world's emission grid re-read as world-structure data, like its
  guards; the condemnation's "category error" reading amended by
  measured demand); (iii) HOLD both (high-threshold hosts declared
  out of scope, stated once, cited thereafter). Builder
  recommendation: (ii) — the condemnation's own frame ("precision is
  the agent's resource") presumed a purchase mechanism the project
  then chose never to build; a stated fineness on the world's OWN
  emission channel is a claim about the world, not about the agent's
  precision. But (i) is the deeper language; the choice is exactly
  the kind the two-key discipline reserves.
- **R-W2 — the wire's decision rule (issue #8 / OB-9): the V-question
  re-put.** Boundary V ("the single decision rule at the wire") was
  formally cancelled 2026-07-15 because its subject (the VoI verbs)
  died; step 10 then proved the ladder is a COMPOSITION of the
  shipped grammar — the capability exists with zero alphabet motion,
  which V never had. Myopia-at-the-wire was ruled for engine-swap
  parity with a myopic incumbent (HOSTS_PLAN register 12) — a reason
  about the H-era differential gate, not about the language. Outcomes:
  (i) ship the ladder behind the wire (W4c; the doctrine "depth is
  bought by measurement" now has its measurement — the composition
  and its prices are pinned); (ii) keep the wire myopic, the W2
  bracket becomes the permanent statement, hosts compose deliberation
  host-side. Builder recommendation: (i), the myopic case remaining
  the chosen rung at depth-1 prices — the ladder's arrival changes no
  default behavior, only reachability.

**The demand register (issues #9-#14):**

| issue | demand | status at opening |
|---|---|---|
| #9 | K-ary observations (answer-brain K+1 categorical; favourable shape) | increment A's gate HAS FIRED per its own terms (demand registered from a live consumer); scheduled as W3 |
| #10 | mid-episode K growth | RULING REQUESTED — options: open as research / permanently out / bounded (reserved-tail, the step-7 namespace shape). Builder note: option 3 matches the namespace precedent; no work scheduled pending ruling |
| #11 | increment B (governor harm overlay; unblocks the bar-less FBR_safety line, R-D14) | demand registered; gate reading is the author's; if read as fired, B schedules AFTER W4 with its own oracle |
| #12 | routing (governor hard boot blocker) | RULING REQUESTED — in-scope-eventually vs dual-engine-declared; either unblocks governor architecture |
| #13 | continuous carriers (rssfeed exact Kalman) | RULING REQUESTED — the filing itself recommends wontfix; a wontfix WITH rssfeed as the named consumer converts the cut into a citable decision |
| #14 | coupled utility latents (life-agent) | registered; shape may dissolve under §2a (families abolished); #4/W3 is its hard prerequisite regardless; no work scheduled pending demand re-statement post-W3 |

## 6. Custody and closure

W1 and W2 were executed AT the opening (evidence programs first, pins
after — both pin-freeze-form increments, nothing owed beyond their
oracles), so the opening lands as ONE commit carrying TWO single-tag
closes (the step-2 precedent): `wire-open-r0` (the boundary opening +
W1) and `wire-w2-r0` (W2: the owed law + the frozen-layer sitting).
Both tags: builder key, the delegation recorded verbatim in the tag
message. W3/W4 follow the ordinary two-phase cadence under their own
tags once R-W1/R-W2 are ruled. R-D22: the boundary and each increment
reach CLOSED only when the author's own signed tag covers them; until
then every tag under this boundary is a delegated act awaiting
countersignature, listed in §8.

## 7. Verification trail (the triage's evidence rows)

The greps behind §0's "verified" column, re-runnable:

- #1: `grep -n 'pE (JArr \[JStr "c"' src/PropLang/Host.hs` → :363
  singleton; `grep -n bits src/PropLang/Host.hs` → response strings only.
- #2: `grep -rn 'non-negativ' --include='*.hs' .` → one comment
  (Stream.hs:41, the step-6 register naming step 9 as home).
- #3: `sed -n '358,382p' src/PropLang/Host.hs` (nine forms) vs
  `sed -n '505,515p' src/PropLang/Syntax.hs` (Div/Log/Exp/Neg priced).
- #4: `Enumerate.hs:118-119` grid; `:344` the exported grid-taking
  enumerator; `Host.hs:261` the fixing call site.
- #5/#6: absence rows — `grep -rn '"p1"' test*/` (goldens only);
  `grep -rniE 'benchmark|ms/tick' *.md` (HOSTS-era only). Both now
  SUPERSEDED by W1's measurement (§1).
- #7: WRITEUP.md:389-402; AGENT_PLAN.md:855-862; boundary-queue.md
  (last entry 2026-07-06); HOSTS_* unmarked vs membrane-wire.md:175-183
  bracketed.
- #8: `Host.hs:288-352` single-shot EU argmax vs
  `test-reflexive/Reflexive.hs:119-126` the composition.

## 8. Delegated-tag register (running)

| tag | commit | delegation | author re-tag |
|---|---|---|---|
| wire-open-r0 | the opening commit (this file's landing) | "open boundary and implement... also understand why these issues arose", author, 2026-07-20, recorded verbatim in the tag message | OWED (R-D22) |
| wire-w2-r0 | same commit (the step-2 single-tag-close precedent; W2 executed at the opening) | same delegation | OWED (R-D22) |

The author's own signed tag over the opening commit discharges both
rows and makes the six frozen-file repairs and the two new oracle
suites law. R-W1 and R-W2 (§5) await the same sitting.
