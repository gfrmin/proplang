# LADDER_PLAN — step-6 increment 4: the fidelity ladder (interface.md §6; test F)

Status: PLAN ONLY. Task 0 (author rulings on the register L1–L12) has
not happened; nothing below is built, no oracle exists, no frozen text
is touched. Scope as recorded in ROADMAP.md increment 4: **interface.md
§6 and §7(5), acceptance test F** — estimator fidelity becomes a priced
option in the internal menu; test 2's 1/3/12/12 reproduce as *chosen*
behavior; a near-zero-price world sometimes buys depth and beats fixed
myopia; the clock residue is demonstrated at its proven minimum (the
induction base survives, per §6's own text). M9's reserved additive
change comes due at this boundary. Out of scope, explicitly: the
conjugate fast path (test D stays the armed tripwire), action-dependence
in the preposterior (ROADMAP increment 5 — vThink's kernel stays
action-independent here), CIRL (increment 6), continuous carriers.

Protocol: the canonized increment protocol (CLAUDE.md) under the
two-key custody scheme; the author countersigns the Task 2 freeze with
a signed tag (`ladder-freeze`). At this freeze, per ROADMAP: the
author's one-line CLAUDE.md porting-order edit naming increments 5–6.

> **Task 0 rulings (author, 2026-07-06 — verbatim intent, binding on
> this increment):**
> - **L1 APPROVED: reading (c)**, with two recorded riders. (1) The
>   macro-act is reconciled with the polling clause as an **option
>   with declared termination** — firing `think(k)` is one choice
>   whose k-tick span is declared menu data, not a mid-flight
>   re-evaluation exemption. (2) Interface.md's test-F sentence is
>   **AMENDED at the freeze** (author text in the pack) rather than
>   discharged by a strained reading of "the chosen rung must be the
>   myopic one." Shallow-first menu order is recorded as **CL-3 at
>   the menu**.
> - **L6 CORRECTED.** The F-world's tilt arrives as **declared
>   pre-episode history folded through `cond` by the host** — never
>   as a world-supplied belief; `fromBits`/`uniform`/`point` stay the
>   only prior sources in the system.
> - **L3 APPROVED**, and the **one-pin-completeness grep** (the claim
>   that ExpFam.hs:140 is the only stdB-bearing frozen pin) joins the
>   freeze checklist as a verified command, not an assertion.
> - **L2, L4, L5, L7–L11 APPROVED as proposed.**
> - **L12 APPROVED** with the interface.md test-F amendment as item
>   (5), and **ASCII-only test names canonized** (author text at the
>   freeze).
> - Proceed to Task 1; stop at Task 2 with the pack.

---

## T1. The rung: three candidate readings, measured before ruling

§6's sentence — "the internal menu contains `think(depth=k)` for k in
a priced grid; the value of `think(k)` is estimated at fidelity k−1;
every rung costs ticks the world prices" — under-determines two axes:
what firing `think(k)` physically does, and how the rung is valued.
Any concretization must satisfy three constraints at once:

- **C1**: the k=1 rung's arithmetic is the frozen `VThink` *exactly*
  (test 2 must reproduce as chosen behavior, bit-for-bit);
- **C2**: test F's letter at the four frozen price points (t2Rows:
  ticks 1/3/12/12, act L, at 0.3/0.05/0.005/0);
- **C3**: test F's second direction (near-zero price, adversarial
  buffer: a deeper rung is bought and beats fixed myopia).

A sanity sim (scratchpad, discriminating power only — pins never come
from it, the b7f120e precedent) drove the candidates through the REAL
frozen verbs (`evalx (Call VThink ...)` / `(Call VAct ...)`, the same
call shape as frozen policyThink) on the frozen `buffer36`:

- **(b′) recursive-max, virtual estimator ticks.** `V_k = E over
  next-batch branches of max(vAct, V_{k−1}) − p`, `V_1 ≡ VThink`; menu
  value `V_k − (k−1)·p`; firing any rung conditions one batch, one
  tick. Measured: **ticks/acts reproduce at all four prices**; rung
  myopic at 0.3 and 0.05, deep ([3,3,...]) at 0.005 and 0. Wart: the
  (k−1)·p surcharge is charged in value while the clock advances one —
  a price paid to no tick.
- **(b″) recursive-max, physical estimator ticks** (counter +k per
  fire). Measured: **ANCHORS BREAK** at 0.005 (31 ≠ 12) and 0
  (36 ≠ 12). Excluded by measurement.
- **(c) macro-act commitment.** `think(k)` = consult k batches over k
  real ticks, then re-decide; valued by the straight k-step
  preposterior: `Est_0 = vAct` (level-0 at face value — the induction
  base), `Est_k(b) = E_batch[Est_{k−1}(b′)]` minus `k·p`. `Est_1` is
  the frozen `VThink` verbatim (C1 exact, same verb call). Measured:
  **ticks/acts reproduce at all four prices** (0.005/0 reach dry as
  [3,3,3,3] — 12 thinking ticks either way); rung myopic at 0.3 and
  0.05, deep at 0.005 and 0.

The sharp measured fact: **no honest reading gives the myopic rung at
all four price points.** At 0.005/0 the deeper rungs' values strictly
dominate (at p=0: think1=0.337, think2=0.369, think3=0.398) — fidelity
is cheap there, and the ladder buys it; making rung 2 lose at 0.005
would need a non-price penalty exceeding 0.024 ≫ p, i.e. a tuned
steering constant, which is a forbidden move. At 0.3 the recursive
family ties *exactly* (every continuation stops, so the k=2 arithmetic
collapses to k=1's), which is where CL-3's shallow-first tie-break
earns its keep; at 0.05 the stop decision holds with margin (act
0.0909 vs best rung 0.0759 after three batches).

**Recommendation: reading (c).** It makes every §6 clause literal:
every priced tick is a real tick (no virtual cost, no fourth flow
through the pricing door); the rung-k estimator IS the rung-(k−1)
estimator pushed through one preposterior expectation (fidelity k−1,
letter-exact); the induction base is `Est_0` used as-is; and the
termination clause is a theorem in exactly §6's form — value bounded
and `Est_k ≤ Vmax − k·p`, so at p > 0 rungs beyond `(Vmax − V0)/p` can
never beat acting, independent of any depth cap.

**Ruling requested with L1**: how F's "the chosen rung must be the
myopic one" binds. Proposal: it binds where the clock bites — the
price points at which the frozen run stopped clock-bound (0.3, 0.05;
rung sequences pinned [1] and [1,1,1]) — while at the information-bound
points (0.005, 0) the pin is behavioral identity (ticks, acts, batch
order) plus the *pinned deep rung sequence*, recorded as the ladder
buying fidelity exactly where fidelity is cheap: §6 working, not
failing. Interface.md is frozen; this is a recorded ruling on how its
letter is discharged (the membrane-rulings pattern), not a text edit —
unless the author prefers to amend test F's sentence at the freeze.

## T2. The one frozen pin that moves (STDNAME growth)

If the rung valuation is sayable (T3), STDNAME grows 5 → 6 and the
Call choice price `stdB` moves lg 5 → lg 6. Grep across all frozen
suites finds exactly ONE stdB-bearing pin: test-expfam/ExpFam.hs:140,
`(lg 10 + lg 5 + (lg 10 + lg 4))` — the Bern call-price pin. The
Bern precedent (STDNAME 4 → 5 at the expfam freeze) moved no frozen
pin only because no earlier suite had pinned a Call price; this
increment is the first to hit the collision the sort-local coding
convention always implied: **a reported alphabet change re-prices
every Call sentence.**

Proposal: the author amends the one frozen literal (lg 5 → lg 6) at
the Task 2 freeze boundary — frozen texts change only at freeze
boundaries, only by the author; the amendment is drafted in the pack,
lands in the freeze commit, and the manifest re-hash covers it. The
alternative — housing the new verb in a new sort to leave STDNAME's
count untouched — dodges the pin by construction and is exactly the
"elegant workaround" CLAUDE.md names a defect. Everything else is
measured stationary: no new EXPR production (nodeB stays lg 10), no
model-fragment dl touches stdB (the enumerator's dlGuard tree is
independent), so t1/t3/membrane anchors cannot move.

## T3. Sayability, and the oracle-phase sequencing it forces

Test 2's doctrine is the policy as a sentence (`policyThink` says
`v_think` in syntax). A ladder whose rung values are computed by
unsayable harness machinery would be the system's first unsayable
decision surface — a regression against reflexive closure. Proposal:
**`VThinkK` joins StdName** (contract: the Est_k recursion; Est_1 ≡
VThink, oracle-pinned with ==), implemented in Eval as one arithmetic
with the frozen `vThink` as its base case — the E7/bitsAt doctrine:
the frozen form IS the k=1 case of the parameterized worker, no drift
possible.

Sequencing wrinkle, named honestly: the constructor is oracle-phase
type surface, but adding it moves the frozen expfam pin (T2), and
frozen suites must stay green throughout the oracle phase. Resolution:
the Task 1 oracle references `VThinkK` only through **compile-fixture
shellRows** (the deletion audit's inversion: a tiny fixture module
that fails to compile while the constructor is absent = runtime-red,
main oracle module compiles, frozen suites green); the constructor
plus the one-literal amendment land TOGETHER in the Task 2 freeze
commit via the pack (the fd70162 pattern: builder applies the
author-approved pack diff, the author's tag binds it). No tree state
ever holds a red frozen suite: before the freeze the alphabet is
5-member and the old literal holds; from the freeze commit both are
6-member. Behavioral tests (loops, identity pins on the exported
plain function) run against runtime stubs, red the normal way.

## T4. Where the rung lives (M9 comes due) and what it does

M9 reserved "an ADDITIVE constructor or slot at its own boundary."
Proposal:

- `InternalAct` gains `ThinkK` (depth ≥ 2) behind `DROP_LADDER`;
  `Think` stays the one written base act and IS rung 1 — one spelling
  per rung, the frozen membrane oracle keeps compiling, and
  `lastActionCode (InternalFired Think) = −1` stays byte-identical.
  `ThinkK` echoes −1 too (internal is internal; duration is already
  visible as `ticks_spent_thinking`). The only edit to a
  frozen-pinned function is the new total case (gate 1's
  incomplete-patterns would catch its absence).
- Depth values come from a **priced depth grid** through a door
  (`mkC` discipline: off-grid rungs unconstructible); the grid is menu
  data, priced log2|grid| at the menu layer per M4's rule ("the charge
  lives where the constant is named"). In policy sentences the depth
  argument arrives as a typed env value, the frozen test 2 precedent
  (batchN arrives unpriced in the env; the priced surface is the
  menu). M5 holds: no rung name enters the Get namespace.
- `internalMenu` stays the frozen `Think` singleton (host default);
  the ladder menu is an additive constructor-function over the depth
  grid. Frozen membrane worlds see an unchanged menu by construction —
  no frozen membrane pin (B1's exact choice sequence, lastActionCode)
  can move.
- Firing `ThinkK k` in the F-loop consumes k batches over k real
  ticks, then re-decides (reading c). Rungs are offered only up to
  the remaining buffer (the dryness clause, test 2's `metaacts`
  precedent, world/menu-side).
- `runMembrane` needs no change for test F (the F-episode loop is
  oracle-local in the frozen-test-2 shape, built from src parts);
  `nThink`'s wildcard already counts any `InternalFired`.

## T5. The F-world (direction 2), from design.md's own sentence

design.md §7 records the bias test F must cash: "with a linear
utility, myopic VoI is zero whenever no next-batch outcome can flip
the decision... deeper lookahead would sometimes disagree." Sim-proven
existence: prior = uniform-over-theta conditioned on four 1s (net +4:
no single 3-outcome batch can flip the R decision — myopic VoI
measured at exactly 0, float-dust −1.1e-16), stream of zeros (true
theta at the bottom of the grid), price 0.0005: myopic acts
immediately (R, net −0.8000); the ladder buys depth, flips to L, net
+0.7985 — **LADDER-WINS** under both (b′) and (c); (c) wins already at
p=0.001 with one committed rung-3.

Construction rulings requested (L6): the prior tilt should arrive as
world data — proposal: the world hands the initial belief (the agent
"arrives with history"; the alternative, a tilted prefix inside the
buffer, interacts badly with batch boundaries — measured note). The
oracle runs direction 2 at positive price only (the VoI-0 tie is
float-dust; margins printed in the pack, the membrane-margins
standard). Fixture stream seeded and generated at Task 1 with the
sanity margins, the membrane gen_fixtures pattern.

## Under-determination register (Task 0: author rules on each)

| # | Question | Proposal |
|---|---|---|
| L1 | Rung semantics (T1) | Reading (c), macro-act commitment; Est_1 ≡ frozen VThink; ruling on how F's "chosen rung is myopic" binds (clock-bound points; deep sequences pinned at the cheap points) |
| L2 | Rung syntax home (M9 due; T4) | Additive `ThinkK` behind DROP_LADDER; `Think` = rung 1, one spelling per rung; ThinkK echoes −1; depth via priced grid + door |
| L3 | Sayable valuation (T2/T3) | `VThinkK` as STDNAME 5→6; one frozen literal (ExpFam.hs:140) amended lg 5→lg 6 by the author at the freeze; constructor + amendment land together in the freeze commit |
| L4 | Oracle-phase sequencing (T3) | VThinkK-dependent pins as compile-fixture shellRows in Task 1; frozen suites green throughout; behavioral tests red against runtime stubs |
| L5 | What firing ThinkK does | k batches over k real ticks, then re-decide; rung availability capped by remaining buffer (dryness clause) |
| L6 | F-world construction (T5) | World-supplied initial belief (net +4 tilt); zero stream, true theta 0.1; direction 2 at p=0.0005 (positive only); seeded fixtures + margins in the pack |
| L7 | Depth pricing in sentences | Depth arg = typed env value (test 2's batchN precedent, unpriced); the priced surface is the menu's depth grid (M4's rule); M5 untouched |
| L8 | Ablation row | DROP_LADDER: ThinkK/VThinkK/ladder menu die, behavior = fixed myopia — the induction base is what cannot be deleted (§6's honest minimum as the row's attribution); tokens ThinkK, VThinkK |
| L9 | Module homes | No new src module (the frozen six-file scans stay exhaustive); VThinkK beside VThink in Syntax/Eval; rung/menu in Membrane.hs; naming discipline per the frozen token lists (the registryBits incident) |
| L10 | Tolerances | E12 verbatim; behavioral pins exact (Int ticks, act names, rung sequences as Int lists); price pins 1e-12; identity pins == |
| L11 | Pin provenance | t2 anchors IMPORTED from frozen test/ (Anchors.t2Rows, Streams.buffer36 — the ladder stanza's hs-source-dirs includes test/, the membrane precedent), never transcribed; new-world pins authored at Task 1 from seeded fixtures |
| L12 | Freeze-boundary author edits, enumerated | (1) ExpFam.hs:140 literal (if L3 approved); (2) CLAUDE.md porting-order line naming increments 5–6 (ROADMAP commitment); (3) proplang.cabal ladder stanza; (4) manifest extension over test-ladder/; ASCII-only test names adopted for this oracle (canonizing the membrane's candidate lesson: author's call) |

## Oracle sketch (test-ladder/, one suite, groups)

1. **Rung-1 identity (C1)** — the exported worker at depth 1 ≡ frozen
   `VThink` through the real evaluator, == on Doubles, fixed cases +
   property over beliefs/prices; the ladder loop at kMax=1 ≡ the
   myopic loop behaviorally.
2. **Test F direction 1** — t2's world through the ladder loop at the
   four frozen price points, anchors imported from frozen Anchors.hs:
   ticks/acts ==; rung sequences pinned per the L1 ruling ([1] at 0.3,
   [1,1,1] at 0.05; the deep sequences at 0.005/0 pinned as fixtures).
3. **Test F direction 2** — the F-world at p=0.0005: myopic (ticks=0,
   act=R) pinned; myopic VoI = vAct analytically at tolerance; ladder
   rung sequence pinned, act L, net-utility comparison (ladder >
   myopic) with the margin printed.
4. **Termination as a test** — at p > 0, menu values of rungs beyond
   the (Vmax − V0)/p bound never beat acting, checked across a belief
   family; extending the depth grid beyond the bound leaves the argmax
   fixed.
5. **Prices** — VThinkK call-price pin under the six-member alphabet
   (compile-fixture row until the freeze; 1e-12 after); depth-grid
   monotonicity (membrane g7 pattern).
6. **Ablation + audit rows** — DROP_LADDER row with attribution;
   gate-1/3/4 mirrors for the touched surface; the frozen six-file
   scans confirmed still exhaustive (no new module).
7. **Frozen-battery guardian** — all existing suites green through
   `cabal test all`; the freeze-review checklist states the ONLY
   frozen diffs at the boundary are L12's enumerated edits.

## Gates and the freeze

Gates 1–7 unchanged; gate 5 absorbs the `ladder` suite via
`cabal test all`; stanza drafted in the oracle phase
(`test-ladder/stanza.cabal.draft`), lands in the freeze commit.
Manifest extends over `test-ladder/` and re-hashes proplang.cabal,
test-expfam/ExpFam.hs (the amended literal), and CLAUDE.md (the
porting-order line). The pack carries: the L-register as ruled, the
sim's margin tables (all three readings, both directions, the exact-tie
mechanism at 0.3, the p=0.05 stop margin), the enumerated frozen
diffs, and the freeze-sequence checklist. The author freezes by
reviewing, extending and re-signing MANIFEST.sha256, and
countersigning with the `ladder-freeze` tag from their own shell (or
by fresh explicit per-instance delegation, the b7f120e precedent).

## Task order

- **Task 0** — author rules on L1–L12. STOP point: this document.
- **Task 1** — oracle + type-surface stubs (exported worker stub,
  ThinkK surface per L2, compile-fixture rows per L4), runtime-red
  under the stanza's exact flags; frozen suites green throughout;
  seeded F-world fixtures + sanity margins. Builder-signed.
- **Task 2** — author freeze: pack applied (including the two frozen
  amendments L12(1)(2)), stanza + manifest, signed tag.
- **Task 3** — VThinkK semantics (one arithmetic over the vThink base
  case) + prices: groups 1 and 5 green; expfam suite green under the
  amended pin.
- **Task 4** — ladder menu + F-loop machinery: groups 2–4 green
  (anchor movement is stop-and-report).
- **Task 5** — ablation wiring: groups 6–7 green; full gate run;
  LADDER_REPORT.md with as-built answers and the reviewer block;
  taildrop to pixel6.

## Standing rules restated

Builder never edits frozen surface; anchor movement is
stop-and-report, never a fix; frozen texts change only at freeze
boundaries, only by the author; pinned literals that must agree with
frozen quantities derive from the frozen artifact itself (b7f120e);
the builder never owns a live oracle at the moment it becomes binding;
builder signs with the builder key only; the author's approval is the
tag, not any commit signature.
