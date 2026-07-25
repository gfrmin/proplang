# MEMBRANE_PLAN — step-6 increment 3: the membrane (interface.md §1–§3, §5)

Status: PLAN ONLY. Task 0 (author rulings on the register M1–M10) has
not happened; nothing below is built, no oracle exists, no frozen text
is touched. Scope as ruled at the ExpFam acceptance: **interface.md
§1–§3 and §5** — affordances as data, the features echo,
self-signature — the first increment whose oracle tests the
agent-world boundary. Out of scope, explicitly: the fidelity ladder
(§6, test F), the conjugate fast path (§4 CL-4 fast path — named debt,
T3), latent names in parameter expressions (§7 item 3, inheriting the
ExpFam T1 record), continuous carriers. Oracle currency: interface.md
§8 tests **A** (dormant sensor), **B** (growing menu), **C**
(self-signature), and E's **slot-grid row**; D and F stay with their
owners.

Protocol: the canonized increment protocol (CLAUDE.md), under the
two-key custody scheme (boundary-queue.md) — builder signs its commits
with the builder key throughout; the author countersigns the Task 2
freeze with a **signed tag** (the scheme's first tag exercise). The
boundary-queue items 1–4 land in this boundary's author pack.

> **Task 0 rulings (author, 2026-07-05 — verbatim intent, binding on
> this increment):**
> - **M1 APPROVED.** The pricing law goes in the pack NORMATIVELY:
>   description length is namespace-relative; 2^-|program| normalizes
>   per-world; publishing a name raises every name-mention's cost and
>   re-weights the prior. A recorded semantic commitment (richer world
>   = more surprising names), not an implementation detail.
> - **M2 APPROVED WITH CORRECTION.** `last_action` echoes a STABLE
>   per-affordance identity (world-owned stable ordering/id), NOT the
>   mutable published-menu index — otherwise B's growing menu and C's
>   self-signature collide (the integer's meaning would shift
>   mid-episode). 0 = none-yet stands.
> - **M5 APPROVED, load-bearing.** Namespace = Get-mentionable feature
>   names only; action vocabulary prices through slots/argmax. Keeping
>   the two priced surfaces separate is what stops a "fourth flow"
>   entering through the pricing door. A later increment must not
>   unify them.
> - **M3/M9 APPROVED**, M9 tightened to a compile fact: the ladder's
>   depth field arrives as an ADDITIVE constructor/slot at its own
>   boundary — no dormant Maybe-depth placeholder now.
> - **M4, M6, M7, M8, M10, Q1–Q5 APPROVED as written.** M6's
>   structural same-call form for B endorsed as the executable form of
>   "no special case."
> - **REQUIRED (group 4 / test C — the ExpFam group-6 lesson):** the
>   self-signature world must present the `last_action` mention IN
>   COMPETITION with a plausible non-self hypothesis (a
>   drift/changepoint story that fits a world where the feature is
>   exogenous), so the MAP mentioning `last_action` SELECTS
>   self-explanation over a real alternative rather than uttering the
>   only available sentence. The competitor is explicit in the oracle.
> - **Boundary-queue items 1–4 confirmed** for this pack; item 1 (the
>   red-runner flag-fidelity correction) applies to THIS increment's
>   runner at Task 1.
> - Proceed to Task 1; stop at Task 2 for the freeze + signed tag.

---

## T1. The namespace hazard (why pricing must be per-world)

Interface.md §2: mentioning a name costs `log2(|visible namespace|)`
at the mention site. As built in Phase 2, that is a **static registry**
(`featureNames = ["t"]`, Syntax.hs) and the singleton makes
`nameBits = 0`; the frozen hygiene suite pins `bits (Get "t") = lg 10`
(Hygiene.hs:122) and every frozen dl anchor (t1/t3 MAP programs and
posteriors) folds that zero. The membrane introduces worlds that
publish more names (`last_action`, `tick`, sensors, prices). If those
join the registry, `nameBits` jumps to `log2 k` and **every frozen
anchor moves** — a protocol violation by repricing.

Resolution (and it is the spec's own semantics, not a workaround): the
"visible namespace" is a property of the *world*, so the namespace
becomes a **parameter**, exactly the Cromwell-frontier pattern from
Phase 2. The frozen call surface does not change:

- `bits :: Expr env t -> Double` keeps its signature and its meaning
  (the frozen registry's pricing); the membrane adds an **additive**
  export `bitsIn :: Namespace -> Expr env t -> Double` with
  `bits = bitsIn (namespace-of featureNames)` as the definitional
  identity (property-pinned, not trusted).
- Enumeration likewise: existing entry points untouched; a
  namespace-parameterized entry point added for membrane worlds.
- Frozen tests keep compiling and keep their prices bit-for-bit; the
  membrane oracle pins `bitsIn` under k-name namespaces.

## T2. "Replacing the tests' hand-built loops" under a frozen test/

Interface.md §7 item (1) says the membrane object replaces the tests'
hand-built loops. `test/` is frozen; its hand-built loops are
untouchable. The claim is discharged the only protocol-compatible way:
the **membrane oracle re-expresses a frozen world through the membrane
and reproduces its anchors bit-for-bit** (same stream, same fold ⇒
identical floats; same MAP render bytes). The frozen loops stay as the
reference; the parity group proves the membrane is a zero-cost layer
over them. This is the increment's load-bearing oracle group, the
analog of ExpFam's margin table.

## T3. One menu, no fourth flow (shape of the data)

§3: the world publishes affordances — schemas with typed, grid-priced
slots — as data; the option space is their instantiations **plus the
internal actions** in the same menu; §1: the fired choice has **no
return value** (consequences arrive only inside F_{t+1}). As data:

```haskell
-- pure, first-order, no lambdas (defunctionalization doctrine)
data Slot       = Slot Name Grid            -- typed, grid-priced hole
data Affordance = Affordance Name [Slot]    -- world-published schema
data MenuEntry  = External Affordance | Internal InternalAct
data Choice     = Fire Name [(Name, Double)]  -- instantiated slots
                | InternalFired InternalAct
```

The pure membrane step (oracle-facing; the IO polling loop is Host.hs
and out of the oracle): a world is a pure value publishing
`(Features, Namespace, [Affordance])` per tick and consuming a
`Choice`; the step's type returns the next world state only — no
channel exists for a return value, which makes §1's clause a compile
fact rather than a discipline.

Internal actions this increment: exactly the existing myopic think
(deliberation via the menu, as in Phase 2 step 4); the ladder is out
of scope, so `InternalAct` has one written inhabitant and its sort
prices 0 bits (log2 1) under the frozen sort-local production rule —
no frozen pin is touched.

## Q1. Where are slot-instantiation bits charged?

§3: "slot instantiation priced by the slot's grid, same rule as every
constant in the language." Proposal: the charge lives where every
constant's charge lives — in the **description length of the sentence
that names the constant** (a `C` node against the slot's grid, mkC's
rule, verbatim). The menu itself is world data and carries no dl (the
world's publications are not the agent's descriptions); a *policy
program* that names an instantiation pays `log2(gridSize)` per named
slot at its `C` nodes. The oracle pins this with a priced policy
fragment over a slotted affordance. Consequence, per §8 E: delete the
slot grids and affordances are unpriceable — no policy sentence can
name an instantiation — and the menu's external instantiations are
unenumerable (the row's attribution).

## Q2. What is the echo, exactly?

§5: the host echoes `last_action`, `tick`, `ticks_spent_thinking`,
plus whatever telemetry the substrate exposes — so the echo set is
**world data, per world**, not language machinery (which is also what
lets T2's parity world echo nothing and keep the frozen namespace).
Encoding proposal (M2): `("tick", fromIntegral t)`,
`("ticks_spent_thinking", fromIntegral n)`, and
`("last_action", fromIntegral i)` where `i` is the fired entry's index
in the published menu order (0 reserved for "no action yet"); an
unfired first tick reads 0.0 like every absent name. CL-6 is then
literal: echo names enter the namespace like sensor names, price like
them (`log2 |ns|` via `bitsIn`), are explained-or-context like them,
and their sentences delete like sentences about the weather.

## Q3. What does test C (self-signature) minimally require?

A world where one feature is secretly a function of the agent's own
last action, and enumeration over the membrane namespace such that the
MAP program comes to mention `('get','last_action')`. No new syntax:
such sentences are ordinary `Get` sentences; the enumeration is the
namespace-parameterized entry point (T1) over the existing grammar.
The oracle asserts the MAP render **contains** the echo mention (a
substring/structure pin on the rendered program, the t1-anchor
pattern), not a full byte-pin — the world is new, so the exact
program is the oracle author's to fix at Task 1 and freeze.

## Q4. Grep clauses as audit rows

§8 A and B each carry a grep clause ("no subscription/registration
machinery"; "no menu-handling special cases"). These become
**increment-local** audit rows in test-membrane's own runner (frozen
audit scripts never grow rows): a token list over `src/` in the
spirit of audit/forbidden.txt — proposed list: `subscribe`,
`register`, `listen`, `callback`, `notify`, `onAdd`, `hook` for A;
for B, the check is structural — the menu path has no branch on menu
size or on "new since last tick" (no such token exists to grep; the
row asserts the adoption test passes with the SAME evaluation call
before and after the menu grows, which is the executable form of "no
special case"). Code tokens, not comments, per the frozen convention.

## Q5. Module home and the effect gate

Host.hs's own header pre-declares: "The membrane, polling loop, and
affordances land here post-parity." Proposal that honors both that
comment and gate 3: the **types and pure step** (Slot, Affordance,
MenuEntry, Choice, Namespace, echo composition, the pure world-step
used by the oracle) live in a new pure module `src/PropLang/Membrane.hs`
— no IO in any type; the **IO polling loop** (the only part that fires
anything) lands in Host.hs where gate 3 already confines effects.
Gate 3's frozen scan covers Belief/Syntax/Eval/Enumerate and cannot
grow; the increment adds its own no-IO scan of Membrane.hs to the
membrane runner (M7), the same increment-local pattern as every other
row.

## Under-determination register (Task 0: author rules on each)

| # | Question | Proposal |
|---|---|---|
| M1 | Namespace pricing without moving frozen pins | Per-world `Namespace` parameter; `bits` frozen, additive `bitsIn`; identity `bits = bitsIn ns0` property-pinned (T1) |
| M2 | Echo encoding as Doubles | Menu-index for `last_action` (0 = none yet); counters for `tick`/`ticks_spent_thinking`; echo set is world data (Q2) |
| M3 | Menu shape; internal actions in the same menu | First-order data per T3; one internal inhabitant (myopic think); internal sort prices log2 1 = 0 this increment |
| M4 | Where slot bits are charged | In sentence dl at `C` nodes against the slot's grid (Q1); menus are world data, unpriced |
| M5 | Does the namespace include affordance/slot names? | No — namespace = feature names (sensors + echoes), the things `Get` can mention; affordances price through slots (M4), selection through argmax |
| M6 | Grep clauses | Increment-local token row (list in Q4) + the structural same-call form for B |
| M7 | Effect/no-IO coverage for Membrane.hs | Increment-local no-IO scan in the membrane runner; gate 3's frozen scan untouched (Q5) |
| M8 | Tolerances | Parity group: bit-for-bit (== on Doubles, byte-equal renders); EU/adoption comparisons: 1e-9 relative in the CL-4 shape; price pins: 1e-12 absolute — the E12 conventions verbatim |
| M9 | Out-of-scope guard for §6 | `InternalAct` carries no depth field this increment; adding the ladder later is an alphabet change with its own boundary |
| M10 | Parity worlds (T2) | t3's drift world (agent log-loss identical) + t1's MAP render byte-identical, both driven through the membrane with namespace `["t"]` and empty echo/menu |

## Oracle sketch (test-membrane/, one suite, groups)

1. **Membrane parity (T2)** — frozen worlds through the membrane;
   anchors bit-for-bit. Load-bearing.
2. **Dormant sensor (A)** — sentence mentions a name before its sensor
   exists: behavior bit-identical to the sensor-free world until the
   name appears, then evidence flows, no code change, no registration.
3. **Growing menu (B)** — affordance added mid-episode; adopted iff EU
   justifies (both directions: a world where it is, a world where it
   is not); same evaluation call before/after.
4. **Self-signature (C)** — MAP program mentions `('get','last_action')`
   (structure pin per Q3).
5. **CL-6 ordinariness** — echo-name sentence priced `nodeB + log2 |ns|`
   via `bitsIn` (1e-12 absolute), scored, and deletable like any other;
   `bits = bitsIn ns0` identity property.
6. **Slot pricing (Q1/M4)** — policy fragment naming an instantiation
   pins its dl; grid-size monotonicity property.
7. **Ablation rows (E's slot row + coupling)** — increment-local
   ablation.sh: drop slot grids (affordances unpriceable, menu's
   external half empties), drop affordance publication (menu = internal
   only), drop echo (self-signature world's MAP loses the mention —
   measured evidence loss, the §8 E currency). Flags:
   `DROP_SLOT_GRID`, `DROP_AFFORDANCE`, `DROP_ECHO`.
8. **Audit rows (Q4/M6/M7)** — subscription-token scan; Membrane.hs
   no-IO scan.

Red/green split at Task 1: groups 5–6's pure pins and group 8 are
green-from-start (they touch only stubs' total surface); groups 1–4
and 7 are runtime-red against compile-enabling type-surface stubs in
Membrane.hs. The runner carries the stanza's **exact ghc-options**
(`-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`) —
the ExpFam process correction's first application, before it lands in
CLAUDE.md at this freeze.

## Gates and the freeze

Gates 1–7 unchanged; gate 5 absorbs the `membrane` suite through
`cabal test all`; the stanza is drafted in the oracle phase
(`test-membrane/stanza.cabal.draft`) and lands in the freeze commit.
Manifest at Task 2 extends by strict superset over `test-membrane/`
(pack §-command pattern; proplang.cabal re-hashed for the stanza).
This boundary's author pack carries, besides the membrane items:
boundary-queue item 1 (red-runner flag fidelity → CLAUDE.md), item 2
(layer absence as the spec's ablation standard), item 3 (pack §3
relocation), item 4 (two-key custody statement, author's call). The
author freezes by reviewing the oracle + this register's rulings,
extending and re-signing MANIFEST.sha256, and **countersigning the
freeze commit with a signed tag** (`membrane-freeze`), the scheme's
first tag.

## Task order

- **Task 0** — author rules on M1–M10 (and Q1–Q5 proposals). STOP
  point: this document.
- **Task 1** — oracle + type-surface stubs (`Membrane.hs` surface,
  `bitsIn` signature), runtime-red under the corrected runner; frozen
  suites green throughout. Builder-signed.
- **Task 2** — author freeze: pack applied, manifest extended,
  signed tag. Author's hands (tag) + delegated mechanics as ruled.
- **Task 3** — Membrane data + `bitsIn` + namespace-parameterized
  enumeration: groups 5–6 green.
- **Task 4** — pure membrane step + parity: group 1 green
  (bit-for-bit; any anchor movement is stop-and-report).
- **Task 5** — worlds A/B/C: groups 2–4 green.
- **Task 6** — ablation wiring: groups 7–8 green; full gate run;
  MEMBRANE_REPORT.md with as-built register answers and the reviewer
  block; taildrop to pixel6 + pixel4a.

## Standing rules restated

Builder never edits frozen surface; anchor movement is stop-and-report,
never a fix; frozen texts change only at freeze boundaries, only by the
author; the builder never owns a live oracle at the moment it becomes
binding; builder signs with the builder key only, never the author's;
the author's approval is the tag, not a delegated commit.
