# Step-3 author pack, Part I — a hypothesis becomes a sentence (the scoping sitting)

Builder draft, oracle phase, PRE-ORACLE. This is the step-1 rhythm (the E1–E7
programs → the §6.10 sitting → the amended oracle), applied as the now-frozen
protocol line demands: the evidence programs run first, the rulings land on
their numbers, and only then does the oracle draft. **Nothing here binds; no
frozen file has moved; the oracle directory does not exist yet.**

Controlling texts: `AGENT_PLAN.md` §7 step 3 (as amended through the step-2
freeze), §2a, §5, §8's PORT-the-anchors ruling and amendment schedule;
`code-task2-author-pack.md` §6.10 ruling 4 and §6.4's filter measurements;
CLAUDE.md as canonized at `optlaw-freeze-r0`.

Repo state: HEAD `aa279be`, tag `optlaw-freeze-r0` verified, manifest 85/85,
twelve suites green.

---

## 1. The step as ruled

**Core:** `Model` → `Expr env (K a Obs)`; `Terminal` → the fragment's
production table. Delete `Bern`, `THmm`, `Model`, `Terminal`
(`AGENT_PLAN.md:866-867`).

**Obligation rows already bound to this step:**

| row | source |
|---|---|
| silence never refutes — falsifier (a): ill-formed at t=0, lawful at t≥1 ⇒ dead from tick 0 (eval half pinned, test-code group 7 rows 6a/6b); falsifier (b): channel SILENT at t ⇒ survives t regardless of denotation there | code-freeze-r0 review, `AGENT_PLAN.md:869-878` |
| the fragment table DECLARED through `bitsAt` from day one — no interim hand-counted bits | decision 8, `:879-881` |
| increment-local ablation fixtures for `Code`/`Pos`/`ToR` (hooks wired `Syntax.hs:38-44`; fixtures missing); every NEW production with its in-increment ablation thereafter | decision 9, `:881-886` |
| **the optimisation law's first scheduled application**: the enumeration filter arrives with its pin in this increment | the step-2 rider, `:887-893` |
| amendment schedule due here: `test-expfam` group 6 retirement (KEEP E7); `interface.md` T1; `EXPFAM_PLAN.md` T1/E9; `design.md`/`typed-port-spec.md` prodTable prose (alphabet moves) | §8 re-open table + schedule (decision 10) |

**Ruling 4 verbatim (the filter's charter, `code-task2-author-pack.md:394-401`):**
"Validation happens at kernel construction each tick; a hypothesis whose code
fails to denote at an observed tick asserted the impossible there and is
refuted PERMANENTLY (an evidence-shaped zero). Dormancy remains reserved for
absent NAMES. **Filtering tick-independent codes at enumeration stays legal
as an optimisation — it exploits structure and never lives in the prior
(§1b's law; §6.4 measured the mechanisms bit-identical where both apply).**
Binds step 3's integration; group 7 pins the eval-level half now." §6.4's
numbers: bit-identical posteriors/predictives at all 9 checkpoints; filter
cost 2.9 µs/candidate, 3.3 ms per 1,169-sentence enumeration.

---

## 2. THE SCOPING CRUX — the deletion's falsification wave (measured, per file)

Deleting `Model`/`Terminal`/`enumerateModels`/`renderModel` breaks, **at
compile**, every frozen artifact that imports them. The schedule's own rule
(decision 10): "amend at the step that falsifies — never before (premature
staleness), never after (red suites, dead evidence)." The wave arrives at
step 3, earlier than the schedule's parenthetical guessed ("first: step 5" —
a prediction about by-construction breaks, now superseded by this
inventory).

| artifact | evidence (symbols, file:line) | falsified at 3? | disposition proposed |
|---|---|---|---|
| **`test/Acceptance.hs`** (Phase-1 frozen) | `runWorld :: [Terminal] -> …` (:69), `enumerateModels` (:71,112,318,345,368,372), `renderModel` (:78), `allTerminals`, restricted lists `[TBern, THmm, TC, TGet, TGt]` (:339-340) — **test 4 IS Terminal-ablation** | **YES — compile** | **PORT the anchors** (§8's own ruling: it was already measured false as a survivor). Tests 1–4 re-pin in the step-3 oracle over the sentence surface; the file retires at this freeze |
| `test-hygiene/Hygiene.hs` | `enumerateModels allTerminals` (:94); plus the ×6 alphabet-constant pins (they pin STDNAME = 7, which moves — §3 below) | YES — compile + price | author re-open: the one call ported; the STDNAME pin re-priced (P5's mandated pin re-pricing, the step-1 10→19 precedent) |
| `test-membrane/Membrane.hs` | 28 hits: the model-fragment rows (`enumerateModelsIn ns0 []` renders/dls/order; the 1241/1529 counts; M1 re-pricing) | YES — compile (model rows) | model-fragment rows PORT into the step-3 oracle (they are degeneracy pins by another name); action rows stay for step 5 — author re-open of the file at this freeze |
| `test-d/D.hs` + `test-govhost/GovHost.hs` + `host-governor/{Wire,WireU}.hs` + the govhost exe | `Model` in import lists; `enumerateUModels :: … -> [Model]`; `mkAgent (enumerateModels …)` (D.hs:794; GovHost.hs:566; Wire.hs:435; WireU.hs:406-433) | **YES — compile** | **RETIRE at this boundary** (they are on §8's retired list — "they pin a calculator"; the schedule's rule fires now, not at 5). The govhost executable and both wire drivers retire with them; `membrane-wire.md`'s step-5 amendments become moot for the v1/v2 drivers |
| `test-cirl/Cirl.hs` | imports only `Obs, emit, obsCarrier, thetaSpace` — no doomed name | no | stays green through 3 (retires when falsified, later) |
| `test-ladder`, `test-prepost`, `test-code`, `test-optlaw`, `test/Properties.hs`, `test/Anchors.hs`, `test/Streams.hs` | zero doomed references | no | stay green throughout |

**The staging decision this forces (register D1).** Option A — the clean
demolition: delete the four names at this step; port every falsified anchor
into the step-3 oracle; the author's freeze retires the falsified files and
stanzas in the same signature. Option B — a two-boundary interregnum: land
sentences beside `Model`, pin degeneracy, delete at a later boundary. **The
builder recommends A, on three grounds:** (i) it is what the step text says
and what the schedule's rule produces; (ii) B leaves two live representations
of the same hypotheses — a second route with the pin problem the optimisation
law exists to forbid — through at least one boundary; (iii) the port is
cheaper than it looks, because the anchors that matter are
representation-independent (§4).

---

## 3. The alphabet delta (P5, declared before it moves)

- **`Bern` leaves `StdName`: STDNAME 7 → 6.** The §1b refund, lg 7 − lg 6 =
  0.222 bits on every stdlib mention. Every frozen pin whose value reads
  STDNAME's size moves — mechanism: P5's pin re-pricing at the freeze
  (the step-1 precedent), starting with test-hygiene's alphabet-constant
  pins. `bernFast` survives untouched (the E7-pinned evaluator fast path —
  zero speed lost; the law's row 1).
- **`ExpFam` SURVIVES this step.** The §8 re-open table keeps E7 as "the
  model of the law," and E7 pins `bernFast` against the ExpFam expansion;
  the node dies with the basis at its own later boundary (E9's schedule).
  Only group 6 (sufficiency-as-guarantee) retires now, as already ruled.
- `THmm`/`Model`/`Terminal` are engine types, not alphabet productions —
  their deletion moves no production table.
- `prodExpr` stays 19; the EXPR sort is untouched at this step.

---

## 4. The port design (register D2) — what an anchor IS, once the representation moves

The frozen anchors worth their name are representation-independent, and the
two that could have moved were measured immune at step 1 (§6.7: the
fragment's 1,169 dl values and the top-5 posterior after 20 ticks are
bit-identical under prodTable changes — "the fragment's derivation charges
never read prodTable"). The port therefore pins:

1. **dl multiset, bit-exact** — all 1,169 charges of the frozen enumeration,
   now derived from the DECLARED table (E-s1 below proves this is exactly
   attainable), plus the counts 1169/1241/1529 (membrane's rows ported).
2. **Posterior/predictive trajectories over the frozen streams** — tests
   1–3's quantities: the consult window and the tau=60 change-point flip,
   tick counts 1/3/12/12 at the four prices, the agent-vs-forgetter
   log-loss relations, all against `test/Streams.hs` (untouched, frozen).
3. **Test 4, the deletion table** — restricted enumeration becomes
   production-subset enumeration: each old `[Terminal]` list maps to a
   declared subset of the fragment table; the frozen counts and log-loss
   orderings port as values.
4. **MAP identity WITHOUT render strings** — the old pin was
   `renderModel (agentModels ag !! ix)` string equality (Acceptance:78).
   Render strings are representation; the ported pin is enumeration
   POSITION + dl + posterior mass (the gConsult precedent: shape pins, and
   the pinned-literal rule forbids re-derived strings). **Register D2 asks:
   is position+dl+mass sufficient MAP identity, or must the new sentence
   renders be pinned as fresh goldens too?** (Builder: both — position+dl+
   mass for continuity with the frozen values, fresh render goldens for the
   new surface's own stability; the strings are new artifacts, frozen at
   this boundary, never claimed equal to the old ones.)

---

## 5. E-s1, EXECUTED — the declared table reproduces the frozen charges bit-for-bit

(`scratchpad/step3/TableRepro.hs`, throwaway; transcript
`es1-transcript.txt` attached. Frozen side byte-copied from
`Enumerate.hs:304-313` at the frozen grids and the frozen enumeration
structure; provenance for the sum pin: `code-task2-author-pack.md:299-301`.)

The frozen comment block (`Enumerate.hs:294-303`) already names the table it
was hand-rolling: model bit, constant-choice bit, if bit, Get bit, no
param-alternative bit on the rate. Declared:
**MODEL: 2 (bern | hmm) · THETA: 2 (c | if) · HEAD: 2 · RATE: 1**, plus
index charges lg|grid| and the namespace charge lg|ns|.

```
counts: frozen=1169 tree=1169 naive=1169
tree-matched: bit-mismatches vs frozen = 0 / 1169
naive-fold  : bit-mismatches vs frozen = 0 / 1169
per-family hex (frozen | tree | naive):
  const: 4014ae00d1cfdeb4 | 4014ae00d1cfdeb4 | 4014ae00d1cfdeb4
  walk : 4010000000000000 | 4010000000000000 | 4010000000000000
  guard: 4030570068e7ef5a | 4030570068e7ef5a | 4030570068e7ef5a
frozen dl-sum hex = 40d27582567af28a   (code-task2-author-pack.md:300 pins 40d27582567af28a)
```

**Findings:** (i) decision 8's row is executable — the table can be declared
from day one with ZERO anchor movement; (ii) the reproduction is
association-robust at these grids (both folds bit-exact), so the pricer is
not forced into a fold shape by the anchors — the derivation-tree shape
(bitsAt's own) remains the right discipline and costs nothing; (iii) the
sum-hex closes the provenance chain to the step-1 pack's pinned value.

---

## 6. The oracle plan (drafted AFTER the sitting; recorded now for review)

Directory `test-sentence/` + `stanza.cabal.draft` (suite `sentence`).
Genuine runtime-red here — implementation is owed (the pin-freeze clause
does not apply). Groups:

- **g1 degeneracy** — the ported anchors of §4: dl multiset (from the
  DECLARED table), counts, tests 1–4's values over the frozen streams,
  MAP position+dl+mass, fresh render goldens.
- **g2 the silent-tick pair** — falsifier (a): ill-formed at t=0, lawful at
  t≥1, dead from tick 0 (integration half; eval half already frozen in
  test-code group 7); falsifier (b): channel silent at t ⇒ survives t
  regardless of denotation there.
- **g3 the filter pin (the law's first scheduled application)** —
  filter-at-enumeration ≡ carry-plus-per-tick-refutation, extensionally on
  posterior and predictive over the frozen worlds; residue measured BEFORE
  any tolerance (the step-2 discipline; §6.4's scratch said bit-identical —
  if the fresh measurement agrees, the pin is bit-exact, `==`).
- **g4 the declared table** — the E-s1 table frozen as data; the 1,169
  charges recomputed through the real pricer, bit-exact; the Cromwell
  consonance row (a certainty kernel is sayable; Cromwell lives in the
  mixture — the author's recorded consonance, `AGENT_PLAN.md:873-878`).
- **g5 ablation fixtures** — `DROP_CODE`/`DROP_POS`/`DROP_TOR` compile-red
  fixtures (decision 9), each red proven to be the missing constructor.

R-D21 transcripts in the canonized deepseq form for every row; R-D20-i
byte-copies with provenance for every frozen quantity; ASCII names.

---

## 7. The under-determination register (the sitting's decision sheet)

| # | decision | builder's recommendation | evidence |
|---|---|---|---|
| D1 | staging: clean demolition (A) vs interregnum (B) | **A** — the schedule's rule, no two-route interregnum | §2's inventory; the law |
| D2 | MAP-identity port: position+dl+mass, fresh render goldens as new artifacts | **both, as stated** | §4; gConsult precedent |
| D3 | the retirement list at this freeze: `test/Acceptance.hs` (ported), `test-d`, `test-govhost`, the govhost exe + `Wire.hs`/`WireU.hs`; re-opens: `test-hygiene` (port + re-price), `test-membrane` (model rows ported, action rows stay), `test-expfam` (group 6, as already ruled) | **as listed** | §2 per-file evidence |
| D4 | the STDNAME 7→6 re-pricing lands as P5 mandates, at the freeze, delegated like the step-1 10→19 | **yes** | §3 |
| D5 | does the sentence type land as `Expr '[] (Maybe (K Double Obs))` per the shipped `Code` codomain (R-C1 iii), with `Agent` carrying sentences + filtered latents where the old `HypState` carried shapes? | **yes — the shipped Code IS the hypothesis form; no new type** | §2a; Eval.hs:147-155 |
| D6 | the utility fragment (`MUConst`/`MUWalk`, `enumerateUModels`): dies with `Model` at this boundary (its consumers all retire in D3), or is re-based onto sentences now? | **dies with its consumers** — re-basing it now rebuilds apparatus that steps 6–8 re-derive properly (utility as priced `Expr` over features); keeping a sentence-based MU shim alive would be dead code with no consumer | §2; §8b supersession map |
| D7 | `wait`/membrane scope check: nothing in this step touches actions, echo, or the membrane's action rows | **confirm** — pure likelihood-side step | §1 |

**None of the oracle's rows are drafted until D1–D6 are ruled** — every one
of them changes shape under a different D1/D2/D3/D6.

---

## 8. Custody

Part I is a builder draft; the sitting's rulings will be recorded verbatim
here (the §6.10 pattern) and the oracle drafted against them. The freeze
that eventually binds this step carries: the oracle + stanza; the D3
retirements/re-opens; the STDNAME re-pricing; the schedule's prose
amendments (`interface.md` T1, `EXPFAM_PLAN` T1/E9, `design.md`/
`typed-port-spec.md` prodTable prose); the manifest re-sign; the author's
tag. Deletion-audit note for gate 7: `audit/ablation.sh` carries NO
`Terminal` rows (verified by grep — it ablates by CPP flags only) and is
untouched by this step; the Terminal-ablation lives inside Acceptance's
test 4 and ports as §4 item 3 (frozen audit scripts never grow rows; the
increment-local runner carries the new ones).

*Part I ends here. The next act is the author's sitting on D1–D7.*
