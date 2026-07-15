# Step-5 author pack, Part I — actions become features (the scoping sitting)

Builder draft, oracle phase, PRE-ORACLE. Opened 2026-07-15 at the
step-4 close under the standing pacing order; nothing binds before
the tag, and the register below goes to the author with its evidence
executed. The author forecast this one correctly: it is the first
action-side step since the axioms were rewritten, and the register is
correspondingly heavier than step 4's.

Controlling texts: `AGENT_PLAN.md` §7 step 5, §3 (an action IS an
assignment; wait; no last_action), §5 (the deleted five + the Menu
synonym), §5c (wait without a convention), §6 + RIDER 2 (membership
binds at 6, mention prices at 6, value prices at 7); `membrane-wire.md`
(the sentinel row :131 keeps its step-5 date; the wire's affordance/
internal rows); the host-less window (exit at 5/7); CLAUDE.md as
canonized through the step-4 boundary. Queued rider landing at this
step's CLAUDE.md touch: THE PROBE-DISCIPLINE CLAUSE (step-4 r1).

Repo state at opening: HEAD `b0f3b4b`, `pricing-freeze-r0`/`r1` both
verified, eleven suites green, gates 1–7 PASS, manifest 80/80.

## 1. The step as written

"**Actions become features.** `Menu = [(Name, Grid)]`; `wait` = the
first grid point (§5c); delete the five types, the echo path, and
**the sentinel**." The five (§5's action apparatus): `Choice`,
`Affordance`, `AffId`, `Slot`, `InternalAct` — with `internalMenu`,
`lastActionCode` (lossy — discards every slot binding), `EchoSpec`,
`echoFeatures`, the `Rung` machinery, `wMenu`'s `[Affordance]`,
`Pilot`'s `Choice` mentions, and `ticks_spent_thinking`.

**The step split, verified against the corpus (census below):** the
sentinel that dies here is the MEMBRANE's internal think row
(`InternalAct`/`Think`, the wire's `{"internal": "think"}` row,
`PilotEU`'s `InternalFired` arm) — NOT the deliberation verbs.
`VThink`/`VThinkK`/`VPre` live until step 9; the frozen g1d
(lazy-genius) deliverable runs entirely through the verb layer and
carries ZERO doomed names. Actions enter the FEATURE STREAM at step
6, not here; the scoring rule is 6b's falsifier; pricing enters at
6 (mentions) and 7 (values). **Step 5 is the representation change
alone, and its oracle prices nothing action-side** (RIDER 2's
obligation, honored by construction).

## 2. The falsification wave (census manifest-derived,
   `scratchpad/step5/census.txt`; the sweep-universe line)

| artifact | hits | class | disposition proposed |
|---|---|---|---|
| `test-ladder/` (+fixture, ablation, sayable.sh) | 4+3+2 | REAL — consumes `baseRung`/`ladderRungs`/`mkRung`/`rungDepth`; `Rung` is on §5's list | **RETIRE at this freeze** (AGENT_PLAN §8: "the step that falsifies each; first: step 5"). THE RETIREMENT LISTS ITS PINS — §3 below enumerates all six with destinations (the step-4 clause's first scheduled application) |
| `test-membrane/Membrane.hs` | 66 | REAL — every row through `runMembrane` (its signature carries Pilot + menus); the M5 guardian; the echo rows | author re-open: action rows PORT to the Menu/assignment surface (anchors representation-independent — the third touch of this file, measured port per E-a1); echo rows and the M5 guardian RETIRE (their subjects die); g4Self's action rows RETIRE-UNTIL-6 (self-signature needs actions visible, which is step 6's stream); pricing/grep rows survive |
| `test-membrane/ablation/{UseSlotGrid,UseAffordance,UseEcho}.hs` | 4+4+3 | the deletion fixtures | **DISCHARGED-PERMANENT ×3** (the deletions they proved possible become the deletions that happened) |
| `src/PropLang/Membrane.hs` | 76 | implementation | the action layer rebuilds around `Menu`/assignments (§4) |
| `membrane-wire.md` | prose | the wire's affordance/slot/internal rows; the sentinel row :131 | step-5 prose amendments at the freeze (delegated); the sentinel row's date arrives |
| `test-sentence` (2), `test-pricing` (2) | STRING-ONLY | the `"last_action"` fixture NAME inside nsC namespace arithmetic | frozen pins survive mechanically (3-name-world arithmetic is name-blind); register D-a5: rename or keep as historical |
| `test-prepost`, `test-cirl` (+fixtures) | 0 | verified clean | fall at their OWN steps (8/9), not here |
| `test-sentence` g1d | 0 | verified clean | survives untouched (verb-layer deliberation) |

## 3. THE LADDER'S RETIREMENT LISTS ITS PINS (the new clause, applied)

1. **The rung-sequence pins** (Ladder.hs "NEW-WORLD intended-behavior
   pins"): depth-ladder behavior — SUPERSEDED at this boundary (the
   rung IS the dying representation; deliberation-depth behavior
   returns as verb-layer content, already pinned by g1d's tick
   counts, and reflexive closure is step 10). DISCHARGED with the
   representation; g1d is the surviving behavioral pin.
2. **The VThinkK price pin** (fixture Sayable.hs:205, `lg 19 + lg 6 +
   8*(lg 19 + lg 8)`, re-priced at step 3): the constructor lives
   until step 9 — the pin RE-HOMES into the step-5 oracle as a row
   (copy, with this provenance) until 9 retires the name itself.
3. **The verb/worker identity pins** (verb == exported worker at
   depths 1..3; degenerate == VThink): verb-layer facts, not rung
   facts — RE-HOME into the step-5 oracle beside the price pin.
4. **The sayable.sh red-run machinery + DROP_LADDER hook +
   UseLadder.hs**: the hook guards `VThinkK` (Syntax) and the Rung
   exports — the STDNAME half lives until 9; UseLadder's compile-red
   claim splits: the Rung half DISCHARGED-PERMANENT now, the VThinkK
   half re-homes as a step-5 oracle fixture (or DROP_LADDER keeps
   only its Syntax site until 9 — register D-a4).
5. **The doctrine row** ("the sentence-driven episode reproduces the
   pins"): episode behavior through rungs — DISCHARGED with the
   representation (g1d carries the doctrine).
6. **Anchors consumed** (t2Rows via Streams/Anchors): untouched —
   they live in the frozen test/Anchors.hs and g1d.

## 4. The design (builder's recommendation)

**Menu and assignment.** `type Menu = [(Name, Grid)]` lands in
Membrane.hs beside `PureWorld` (the membrane owns the action surface;
the shape is already `enumerateSentencesIn`'s extras — one shape, two
readers). An ACTION is a FULL assignment over the menu — one value
per writable name per tick, `Features` by type. `wait` = every name
at its grid's FIRST point (§5c, structural). The option space of a
menu is the Cartesian product of its grids in declaration order,
`wait` first by construction (the first product element IS the
all-first-points assignment), so CL-3's first-listed-wins hands ties
to inaction with zero new rules.

*Why FULL assignments (register D-a1):* a partial assignment
re-introduces exactly the unset-vs-set ambiguity §5c killed; a full
assignment forces the world to say what every lever reads when
untouched (the honest form — §5c's own argument, applied per name).
Combinatorial size is the world's own declaration cost, and the
shipped worlds are tiny (t1: one 3-point name).

**Pilot.** Keeps its three shapes, Choice deleted: `PilotIdle` (wait
every tick), `PilotEU (Util Features y)` (argmax EU over the option
space — `Util` survives until step 8; its first parameter simply
becomes the assignment), `PilotThreshold` (feature test → declared
assignment). The internal act is GONE from the option space — the
sentinel dies; `argmaxEU` stays total because `wait` is always
options' head (§5c's load-bearing property).

**The tick.** `runMembrane w n s ag`: features from the world; the
pilot chooses an assignment from `wMenu s`'s options; the assignment
goes to `wStep` (as the old Choice did); `TickTrace` carries the
assignment (`Features`), not a Choice. NO echo (the path dies whole:
no last_action, no tick echo, no ticks_spent_thinking); actions do
NOT enter the tick's feature stream (step 6). EchoSpec leaves the
signature.

**The worlds, ported:** t1 = menu `[("act", grid [1,0,2])]`-shaped
(one name, three points, publication order preserved so CL-3
tie-breaks are unchanged — E-a1 verifies the full choice sequence);
B = hold/move with move's speed a second name... (B's two affordances
with one slotted: as names, `[("move", speedGrid-with-a-first-point-
meaning-hold)]` — the B-world port is the least mechanical; register
D-a2). C's action rows retire until 6.

**Deleted from src:** the five types + internalMenu + menuOptions +
lastActionCode + EchoSpec/mkEchoSpec/noEcho/echoFeatures + Rung/
baseRung/mkRung/ladderRungs/rungDepth + the DROP_SLOT_GRID/
DROP_AFFORDANCE/DROP_ECHO hooks (their fixtures discharge) —
DROP_LADDER per D-a4.

**Alphabet delta: NONE.** No production, sort, width, or price moves.
(The menu's grids are world data; their prices bind at 6/7 by RIDER
2's schedule, not here.)

## 5. The under-determination register (recommendations attached;
   evidence rides Part II)

| item | question | recommendation |
|---|---|---|
| D-a1 | the option space: full assignments (Cartesian product, wait = all-first-points, first by construction) vs partial assignments vs per-name single-writes | **full assignments** (§4's ground: §5c applied per name; ties to CL-3) |
| D-a2 | the B-world port: the hold/move pair with a slotted speed as ONE name whose first point means hold, vs two names | **one name** (`hold` IS `move`-at-its-first-point — the world says what inaction looks like on its own lever, §5c verbatim); E-a1 measures the adoption rows both ways if the sitting wants the comparison |
| D-a3 | `Menu`'s home: Membrane vs Syntax | **Membrane** (the membrane owns the action surface; the synonym's shape is shared with the enumerator by construction, not by import) |
| D-a4 | DROP_LADDER's split (the hook guards VThinkK in Syntax AND Rung in Membrane): keep the Syntax half until 9 vs discharge whole and re-hook at 9 | **keep the Syntax half** (the VThinkK ablation claim stays enforceable through 5–8; the Membrane half discharges with Rung) |
| D-a5 | the `"last_action"` fixture NAME in frozen nsC fixtures (string-only, arithmetic-blind) | **keep as historical** (a rename is a frozen-file edit buying nothing; the name is world-declared data, and worlds may name features anything) |
| D-a6 | g4Self's retirement form: rows retire-until-6 (the self-signature deliverable returns when actions enter the stream) vs port now against a stream that cannot yet carry actions | **retire-until-6**, stated in the file (a port now would pin vacuous behavior — the confound 6b exists to falsify) |

## 6. Evidence programs (before any ruling freezes)

- **E-a1 — the port is behavior-neutral, two-route from birth:**
  prototype the rebuilt membrane (overlay form); run the t1/B/C
  worlds tick-for-tick against the SHIPPED route (still live
  pre-demolition): choices, loss bits, posteriors — bit-compared.
  The sentinel's death is predicted neutral (the frozen probe rows
  never choose think — util1M's internal arm is dominated at −2.0;
  verified against Anchors.hs before this pack was written); E-a1
  proves it over every tick of both anchor worlds. Success criteria:
  choice sequences identical, loss bits ==, final posteriors ==.
- **E-a2 — the wait structure:** a world whose menu's first points
  are NOT zero (killing any residual dormancy conflation): the
  all-first-points assignment is chosen by PilotIdle, available in
  every world, ties resolve to it under CL-3. Executed on the
  prototype; becomes oracle rows.

## 7. Obligation rows bound to this step

1. The silence-never-refutes and filter pins are untouched (no
   likelihood-side change).
2. RIDER 2's negative obligation: NO assignment-priced row, NO
   writable-name mention-priced row in this step's oracle.
3. The wire's step-5 amendments (sentinel row :131; the affordance/
   slot rows become names+grids) — delegated prose at the freeze;
   the host-less window persists (no driver returns until 7).
4. The CLAUDE.md touch carries the queued probe-discipline clause.
5. Every retirement lists its pins (§3 discharges this for the
   ladder; the membrane ablation fixtures are enumerated in §2).

*Part I ends here. Next: E-a1/E-a2 executed, then the oracle draft
(test-actions/), then the pack returns for the sitting and the key.*
