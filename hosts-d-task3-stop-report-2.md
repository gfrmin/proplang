# increment D Task-3 STOP-AND-REPORT #2 — CONSOLIDATED: the full-
# oracle satisfiability audit, the complete defect inventory, and the
# one outstanding repair

**§0 (added after the author's process objection, same day): the audit
covers EVERY remaining red row, so this is the LAST re-open request
this increment can generate — one ruling closes the inventory.**

| red row(s) | audited by | verdict |
|---|---|---|
| gLedger (1) | EXECUTED through the driver's routing (audit.hs): θ_ask marginal after the verdict+outcome episode = 0.25 / 0.25 / 0.25 / 0.25 exactly | SATISFIABLE (the O1 identity holds through the real routing) |
| gO3 (1) | EXECUTED (audit.hs): both-streams mean 0.2178 < verdict-only 0.6526, margin 0.4347 | SATISFIABLE, robust |
| gDriver (2) | EXECUTED (drv.hs / drv2.hs): frozen fixture Fire 4 ≠ pin's Fire 3 (faces 0.39 / 0.49); repair verified (margins §3) | **UNSATISFIABLE as frozen — the one outstanding repair** |
| gWire (7) | STATIC audit: goldens well-formed; render rules consistent with Wire's canonical renderer (0.5 / 3.25 / 0.42 non-integral → show; 1241 / 1 / 3 integral → undotted); models = 1241 measured green (gBudget decomposition row); ulatents = 3 = pointer + 2 residuals; MUCounts fields match the golden's reads; the v2 handshake constructible over the v1 world block | SATISFIABLE |

Green rows (37) executed at or before the r1 re-freeze and need no
audit. Total defect inventory for increment D's oracle, final:
FIVE rows — three repaired at r1 (tag d-freeze-r1), two below.

**The systematization (so this never again depends on builder
judgment about which rows "need" checking):** proposed protocol
amendment, for the pack now and CLAUDE.md at a future author
boundary — *the oracle phase ends only when every red row's asserted
quantity has been executed once against a prototype realization,
recorded as a satisfiability TRANSCRIPT in the author pack;
prototypes are discarded; a red row without a transcript line cannot
freeze.* R-D20-ii becomes a phase GATE with an artifact, not a rule
applied row-by-row at discretion.

---

Builder → author, 2026-07-09, after the r1 re-open. Untracked. The
satisfiability rule you adopted an hour ago did its job: before
implementing `membraneTickU`, I prototyped the driver's decision rule
against gDriver's two frozen fixtures (the R-D20-ii artifact:
job-tmp drv.hs / drv2.hs, outside the repo). The rule is sound; the
FIXTURE cannot exhibit the phenomenon.

## 1. The defect (2 rows, gDriver; gLedger and gO3 are unaffected)

pilotD declares `upSaid = Var (S Z)` — utility = the latent, for
EVERY action. Under an action-degenerate payload, information about
ū cannot change any decision (all terminal values move together), so
the verdict-ask can never strictly beat the comparison affordance:
measured faces in the world-bound fixture are ask 0.39 vs compare
0.49 — Fire 4, pin expects Fire 3. Implementation-independent: any
value-based rule prices ask's −E[θ_ask] against information worth
exactly zero. (Same defect class as gHeadline: a red row whose
expected side never executed; drafted before the rule existed.)

A second, subtler layer: even with a stake in the payload, the
world-bound fixture's FRESH pointer cannot be flipped by one verdict
(the τ-mixture's likelihood ratio is ≤1.43 per tick), so ask's VoI
(≈0) still loses to its θ-cost (0.1): measured −0.11 vs −0.01.

## 2. The rule (prototype-verified; implementation-ready)

Pair belief = pointer-marginal × first-residual-marginal (public
verbs). Each affordance is valued as a vPre face at depth
`rungDepth upDepth`, n = 1, the world's measured tick price
(upPrice) outside the max; fired choice = menu-order argmax (CL-3).
Bindings are NAME-KEYED — rider 1's own upPrice mechanism, the
wire's binding surface throughout:

- an affordance named `ask` opens `applyChan upVerdict` at its code
  (upVerdict's documented routing) and is charged the residual
  named `theta_ask` as object-level uD (the extended ledger's
  permitted row);
- an affordance named `compare` opens the first residual's declared
  channel (the wire-v2 comparison payload's driver realization —
  recorded as a name-keyed simplification of the payload mechanism);
- every other affordance opens upVerdict at its code (worlds route
  non-ask codes to noise);
- terminal utility uT(a,(ū,θ)) = evalx upSaid (code a, ū) − θ·1[a
  named ask].

Two small internal Enumerate accessors carry the declarations the
agents already hold: the residual's grid NAME and carried CHANNEL
(world data the agent was built from — observability of
declarations, not belief internals; Belief exports untouched, I1/I2
intact).

## 3. The repair (drafts; verified by execution — margins below)

1. **pilotD's payload gains a real stake (sayable, frozen grammar
   only):** u(a, ū) = if a = proceed-code then (ū > 0.5 ? +1 : −1)
   else 0 —

       upSaid = If (Call IsEq (Var Z :* cProceed :* ANil))
                   (If (Gt (Var (S Z)) cHalf) cOne cMinusOne)
                   cZero

   with cProceed/cHalf/cOne/cMinusOne/cZero grid constants via mkC
   over fixture-declared grids (a "code" grid and a "stake" grid
   −1|0|1 — priced data like every fixture grid). gLedger/gO3 use
   pilotD but assert only marginals/means — verified unaffected.
2. **World-bound row:** pointer = pointerAgent0 fed ONE approving
   verdict (the near-boundary belief a single verdict can flip);
   askSharp's grid = {0.01} (a small measured exchange rate, not
   0.1).
3. Pins unchanged in form: Fire (mkAffId 4) [] / Fire (mkAffId 3) [].

**Measured margins (the R-D20-ii execution):** residual-bound faces
ask 0.7786 / compare 0.9661 / proceed 0.9661 → Fire 4 (compare wins
the tie by menu order — R1's own doctrine, and menuD lists it
before proceed); world-bound faces ask 0.0332 / compare −0.01 /
proceed −0.01 → Fire 3, margin 0.043. Both robust at 1e-3
tolerances.

## 4. What I need

One ruling: apply §3's repair as drafted (or amend). Same mechanics
as r1 — frozen D.hs edit + manifest re-hash + tag r2, by your hand
or by fresh per-instance delegation. After it: the driver and wire
implement against a fully-satisfiable oracle; no further red row
carries an unexecuted expected side (gLedger/gO3 execute the same
machinery the prototype just did; gWire's rows are codec goldens +
the handshake, verified constructible).
