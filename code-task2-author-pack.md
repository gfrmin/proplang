# Step 1 author pack — "the likelihood is a code"

**Boundary:** `agent-boundary-r1` (author-signed).
**Increment:** step 1 — `Code`, `Pos`, `ToR`, arithmetic. **ADDITIVE** (author's sequencing
ruling, 2026-07-12: *"additive first, subtractive later"*).
**Status:** oracle phase COMPLETE. **The builder does not own a live oracle.** Awaiting the
author's review, amendments, and freeze.

---

## 1. State of the gates, right now

| | |
|---|---|
| **gate 1** (`-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`) on `src/` | ✅ **clean** |
| **gate 5** — all **ten** frozen suites | ✅ **PASS** (the oracle-phase requirement: *"existing frozen suites stay green throughout"*) |
| **gate 6** — `sha256sum -c MANIFEST.sha256` | ✅ **81/81** — no frozen file has moved |
| **`test-code`** (the new oracle) | 🔴 **38/38 FAIL — runtime-red, as required** |
| oracle compiles under the **stanza's exact flags** | ✅ (*"a red run under weaker flags proves nothing"* — the ExpFam re-open, 4c7b49d) |

**The red is the missing implementation, and nothing else.** Groups 1–5 hit the `Eval.hs`
type-surface stubs; group 6 fails **numerically** (`expected 6.2479, got 4.3219`) because
`prodTable` is still `10 2 1 1 7 1` while the oracle asserts the new counts. Two distinct,
correct kinds of red.

---

## 2. THE FALSIFIER DID NOT FIRE

Step 1 was stated with a kill-switch, before the fact:

> *"`rw` is the falsifier — **if a code cannot express the reflected walk, stop and report.**"*

**It can.** R-D21 satisfiability transcript — every asserted quantity executed once against a
throwaway prototype, **against the frozen artifacts themselves** (R-D20-i), prototypes now
discarded:

| pin | vs the FROZEN artifact | result |
|---|---|---|
| **`rw`** | `walkOn`, 7 ρ × 81 cells | **567/567 BIT-EXACT** |
| **`bern`** | the shipped `emit` kernel | **9/9 BIT-EXACT** |
| **`expfam`** | `ExpFam` at η = logit θ | **9/9 BIT-EXACT** |
| the walk's **hard zero** | a non-neighbour cell | `L = Infinity` ⇒ weight **exactly 0** |
| `logBase 2 y` vs `Div (Log y) (Log 2)` | GHC.Float's own definition | **9/9 BIT-EXACT** |

**T1 is dissolved by execution, not by argument.** Its proof — *an expfam's support is the base
measure's, fixed for the family* — is **true and irrelevant to this engine, which never used an
exponential family.** `walkOn` has always computed `2^(-L)` through `fromBits`; its own comment
says so. **Codifying it is a rename, not a re-derivation** — and the bit-exactness is the proof,
which is why `test-code` asserts **bit-equality and not a tolerance.**

*(The last row deletes `logBase` from the alphabet before it was ever proposed.)*

---

## 3. What the AUTHOR must do at the freeze

**Frozen texts change only at freeze boundaries, only by the author.** Four items:

1. **Apply the cabal stanza** — `test-code/stanza.cabal.draft` → `proplang.cabal`.
   (`proplang.cabal` is manifest-frozen; the builder never edits it. This is the recorded
   pattern — `proplang.cabal:76-78`, the expfam increment.)
2. **Absorb the `prodTable` amendment** — `ProdTable 10 2 1 1 7 1` → **`ProdTable 19 2 1 2 7 1`**
   (`prodExpr` 10 → 19: `Pos`, `ToR`, `Add`, `Sub`, `Mul`, `Div`, `Log`, `Exp`, `Neg`;
   `prodKer` 1 → 2: `Code` **beside** `ExpFam`).
3. **Re-price the frozen pins** — P5's own clause makes this **mandatory, not optional**
   (`Syntax.hs:355-361`): *"A count change edits exactly this value **plus the enumerated frozen
   pins of the changed sort** — the P5 forward ruling's **mandatory boundary item**."*
   **39 `lg 10` hits across 8 suites.** Mechanical, and the builder will do it on instruction —
   but it is a frozen edit, so **R-D22 then obliges an author re-tag within the increment.**
4. **Re-sign `MANIFEST.sha256`** to cover `test-code/` + the amended cabal + the re-priced pins.

**Sequencing note (why the pins are not already re-priced):** flipping `prodTable` reds all 39
pins instantly, and the oracle phase requires the frozen suites to **stay green throughout**. So
`prodTable` stays at 10/1 until your freeze. That is why group 6 is red today and will go green
the moment the amendment lands.

---

## 4. Register — the author rules; the builder does not

### R-C1 — **`fromBits`'s hazards are UNGUARDED, and this increment makes both reachable. BLOCKING.**

AGENT_PLAN OPEN 4. Today `L` is hardcoded, so neither can fire. Under `Code`, an arbitrary `L`
can, and **`test-code` deliberately contains NO row for this, because the guard's SHAPE is the
author's to choose and the builder will not pre-empt it by writing a test that assumes one.**

- **(a)** `L = +∞` at *every* point ⇒ `mkBelief` → `Nothing` ⇒ `error "fromBits: belief has no
  mass"`. **A live `error` site — and `fromBits`'s signature admits no failure value.**
- **(b)** `L = −∞` or `NaN` ⇒ weight `+∞` ⇒ `lse` gives `NaN` ⇒ the `z == negInf` test is `False`
  ⇒ **a silently invalid `Belief` of NaNs.** **There is no `isNaN` check anywhere in
  `Belief.hs`.** (b) is the worse one: it is silent.

The candidate readings, none of them free:
- **(i)** change `fromBits`'s signature to `Maybe` — but it is a **frozen** signature and this is
  a Phase-1 re-open;
- **(ii)** `error` — but CLAUDE.md says *"totality is the point"*;
- **(iii)** rule that a code with no mass **means the impossible**, and give `Code` a
  `Maybe (Kernel a b)` codomain — pushing the partiality into the type, where the project's own
  doctrine says it belongs.

**The builder's reading is (iii), and the builder is not acting on it.**

### R-C2 — `Neg` vs `Sub k0`: the sign of zero (OPEN 5)

`0 − 0` is `+0.0`; `negate 0` is `−0.0`. That IEEE-754 fact is the **only** reason `Neg` is its
own production rather than sugar. `test-code` group 5 pins it. **If the author rules the sign of
zero irrelevant, that row must be RETIRED — and retiring it is then a recorded alphabet change
(prodExpr 19 → 18), not a quiet edit.**

### R-C3 — **§8's survivor list is FALSE, and the correction is bigger than the boundary said**

AGENT_PLAN §8: *"SURVIVE — inference was always right: `hygiene`, acceptance test 1,
`test/Acceptance.hs` entirely."* **Measured, and false for all three:**

| suite | why it cannot survive the DELETIONS |
|---|---|
| `test/Acceptance.hs` | uses `Util` (×5), `EU`/`VAct`/… (×4), `Terminal` |
| `test-hygiene/Hygiene.hs` | uses **`FnInd` (×21)** and `lg 10` (×6) |
| `test-expfam/ExpFam.hs` | `ExpFam`/`SId`/`Carrier` (×40) |
| every other suite | all break |

**The only genuine survivor of the whole re-derivation is `test/Properties.hs`** — the one file
carrying the `1e-9` defect (§2b). *This does not touch step 1* (which is additive and breaks
nothing) but it **falsifies §8's scope statement**, and the author ruled the disposition already:
**PORT the anchors — they ARE the proof.** §8 should be amended to say so at this freeze.

### R-C4 — the intermediate alphabet is a real alphabet

Step 1's counts (**EXPR 19 / KER 2**) are **not** §5b's end state (**EXPR 21 / KER 1**), which is
reached only after the deletions of steps 3 and 9. Prices therefore move **twice**. That is the
declared cost of the author's additive-first ruling, and it is recorded rather than smoothed over:
**an intermediate alphabet is still an alphabet, and it still IS the prior.**

---

## 5. Evidence that the audits work

**The deletion audit caught the builder during this increment.** `walkOn` was exported for the
oracle to compare against (R-D20-i: check against the artifact, never a transcription) — but
`walkOn`'s *definition* sits inside `#if !defined(DROP_EXPFAM) && !defined(DROP_CARRIER_OBS)`, so
an **unconditional** export made the `DROP_CARRIER_OBS` ablation fail on `walkOn` instead of
`obsCarrier`, breaking the audit's **attribution** check. `test-expfam` went red immediately and
named the cause. Fixed by guarding the export exactly as its definition is guarded.

**Nobody had to notice. The audit noticed.** That is the whole argument for the type-derivation
audit (§8c) — the deletion audit polices the alphabet, and until now *nothing policed the types.*
