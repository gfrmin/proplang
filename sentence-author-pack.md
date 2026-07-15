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

---

# Part II — the sitting's rulings (2026-07-15) and the D6 sweep, resolved

## 9. The rulings, recorded

- **D1 — RULED A, ground corrected (the author):** the law does not forbid a
  pinned second route — it *requires pins for* second routes; an interregnum
  with a degeneracy pin would be legal. The decisive ground: **the
  falsification wave is invariant to staging** — B defers it, never avoids
  it, and pays twice; B's only purchase (insurance against anchor
  non-reproduction) is already half-retired by E-s1 + the §6.7 immunity
  measurement, and the trajectory half is exactly what g1's genuine red
  adjudicates. Part I §2's ground (ii) stands corrected accordingly.
- **D2 — ADOPTED, plus one row, minus one ambiguity:** *position* is a fresh
  coordinate of the NEW enumeration (nothing guarantees order preservation);
  continuity is carried by dl + mass. And because the dl multiset has
  symmetry collisions, the collision-proof identity is added: **the MAP
  component's predictive at frozen checkpoints, computed from the old route
  NOW, before the demolition** — executed, §11 below.
- **D3 — ADOPTED, three riders** (§12 below): the §8 schedule's formal
  amendment (Wire.hs's step-5 row discharged early by retirement); the
  host-less window stated; lineage headers on the ported rows.
- **D4 — ADOPTED, delegated as at step 1,** carrying the classified-exception
  discipline: the SayableP `lg 10` that was a variable count, not a
  production count — re-pricing is adjudication, never grep.
- **D5 — ADOPTED,** with the sitting's check recorded for the type-surface
  phase: the filtered-latents slot in `Agent` must cover what `THmm` carried
  (a `Belief Double` latent per state-carrying sentence) — the one place a
  quiet new type could slip in.
- **D6 — HELD by the author pending the extended sweep; the sweep is now
  resolved, §10.** The branch obtains: **test-optlaw is NOT clean.**
- **D7 — CONFIRMED,** with the host-less window recorded against it.
- **g3 gains a row (the author):** the reverse orientation — a code lawful
  early and ill-formed late (per-tick refutation kills it at its tick; the
  filter must neither pre-kill it nor keep it past that tick) — so the
  extensional pin spans the domain boundary in both directions; gBoundary's
  lesson applied to the law's first scheduled application. And if the fresh
  residue measurement reproduces §6.4's bit-identity, **the pin freezes at
  `==` without regret** — a bit-exact pin born from a measurement is not a
  round number.

## 10. The D6 sweep (extended deletion set, file list DERIVED FROM THE MANIFEST)

Method correction first, recorded plainly: Part I §2's inventory was
hand-enumerated and **omitted the very file the builder froze a week ago** —
the author caught it from provenance alone (the optlaw pack's own §2 cites
`test-d/D.hs:588-589` as a byte-copy source). The sweep now derives its file
list from `MANIFEST.sha256` (34 `.hs` rows) plus the non-manifest host files;
the extended set = the four step-text names ∪ the u-fragment
(`MUConst`/`MUWalk`/`enumerateUModels`/`UFamily`/`allUFamilies`/`TauSpec`/
`mkTauSpec`/`verdictKernel`/`latent*`/`UPilot`/`membraneTickU`/
`runMembraneU`/`UTickState`/`UTickTrace`/`uChoose`). Every file with a
nonzero count:

| file | core | ufrag | disposition |
|---|---|---|---|
| `test/Acceptance.hs` | 15 | 0 | PORT (ruled, Part I) |
| `test-hygiene/Hygiene.hs` | 1 | 0 | re-open: port + STDNAME re-price (D4) |
| `test-membrane/Membrane.hs` | 28 | 0 | re-open: model rows port; action rows stay for 5 |
| **`test-expfam/ExpFam.hs`** | 4 | 0 | **NEW CATCH: E7 itself routes through the dying name** — `propExpansion`'s fast side is `nameAt` = `Call (Bern obsCarrier) …` (`:106,:224`). The KEEP-E7 ruling forces the port: fast side becomes `bernFast` directly — value-invariant BY DEFINITION today (`applyStd (Bern car) = bernFast car`, `Eval.hs:206`). The `:137` "stdname choice of 7" pricing row and the `:189` render golden retire with the name; group 6 retires as already ruled |
| `test-expfam/ablation/UseBern.hs` | 2 | 0 | the Bern deletion FIXTURE: its ablation row retires as **discharged-permanent** — the deletion it proved possible becomes the deletion that happened |
| `test-govhost/GovHost.hs` + `ablation/UseDriver.hs` | 10+2 | 0 | retire (D3) |
| `test-d/D.hs` + `ablation/UseUPilot.hs` + `ablation/UseUWalk.hs` | 17+3+0 | 69+23+7 | retire (D3) |
| **`test-optlaw/OptLaw.hs`** | **3** | **18** | **THE BRANCH OBTAINS: NOT clean — joins D3 as a re-open.** core: `worldAgent0 = mkAgent (enumerateModels allTerminals)`; ufrag: `uAgent0`/`pointerAgent0` through `enumerateUModels`/`verdictKernel`/`mkTauSpec`. Generators port to extensional twins over the sentence surface; **values untouched** (the 49/49 transcript quantities re-executed against the ported generators under the sharpened R-D21 at the re-freeze — bit-agreement expected: the step-1 pins made code-vs-`walkOn` 567/567 and code-vs-`bernFast` 18/18 bit-exact, and `verdictKernel`'s σ-mixture is post-step-1 sayable arithmetic) |
| `host-governor/{Wire,WireU,Main}.hs` | 2+3+0 | 0+21+3 | retire (D3; not manifest-covered — the custody note rides the retirement) |

Zero-hit (stay green through 3): `Properties`, `Anchors`, `Streams`,
`ladder`(+fixture), `prepost`(+`SayableP`), `cirl`(+fixtures), `code`,
`audit/ablation/{UseArgmax,UsePush}`, membrane's action-side ablations,
hygiene's FN ablations.

**Consequence for D6, awaiting the author's word:** the u-fragment's frozen
consumers are exactly {test-d(+2 ablations), WireU, Main, test-optlaw} —
the first three retire, optlaw re-opens with ported generators. The
recommended D6 (dies with its consumers; utility re-derived from the axioms
at steps 6–8, never rebuilt from nostalgia) stands on the sweep's numbers;
**the enlarged D3 gains: optlaw (re-open), expfam's E7 port + UseBern
retirement.**

## 11. The D2 capture, EXECUTED (pre-demolition, old route, public surface only)

(`scratchpad/step3/MapCapture.hs`, throwaway; transcript
`d2-capture-transcript.txt`. Idioms byte-copied: `stepAgent`
Acceptance:61-65, the fold :69-73, the MAP route :76-79; streams frozen in
`test/Streams.hs`. Component predictive read via a SINGLETON agent on the
MAP model, replayed over the same stream — filtered latents advance exactly
as the mixture component's did.)

```
shifted160: MAP = ('bern', ('if', ('>', ('get','t'), ('c','tau',11)), ('c','theta',0), ('c','theta',8)))
  mass 0.6383157408996509 (3fe46d1521f5f3cc)
  P(y=1|t=0,59,60) = 0.8999999999999999 (3feccccccccccccc)
  P(y=1|t=61,159,160) = 0.10000000000000002 (3fb999999999999b)
drift400:  MAP = ('hmm', ('c','rho',3))       <- STATE-CARRYING: the case dl+mass cannot fingerprint
  mass 0.401010555353298 (3fd9aa282d25f732)
  filtered P(y=1) = 0.39474402402583364 (3fd9437c705edf8a), all checkpoints
    ^^^ CONVICTED by the author's verification (Part III §14): this row
    read the t=400 filtered predictive six times under six labels. The
    corrected checkpoint values are §14's; g1 pins THOSE.
flat400:   MAP = ('bern', ('c','theta',6))
  mass 0.946333003921794 (3fee485c26df0683)
  P(y=1) = 0.7 (3fe6666666666666), all checkpoints
```

The old renders are provenance LABELS here, never ported pins (D2's
ambiguity resolved: position is fresh; continuity = dl + mass + these
component predictives).

## 12. D3's riders, drafted

1. **The §8 schedule amendment (for the freeze):** the step-5 row
   "`membrane-wire.md` + `host-governor/Wire.hs` (the sentinel,
   `missing-internal-row`)" is amended — `Wire.hs` **discharged early by
   retirement at step 3**; the sentinel's remaining pointable site is
   `membrane-wire.md:131` (the think row; prose at `:57`), which keeps its
   step-5 date.
2. **The host-less window, stated:** from this freeze until the step-5/7
   host rework, the repo has **no runnable host** — both wire drivers and
   the govhost executable retire with their consumers. A substrate
   mid-re-derivation; a stated consequence, not a discovery.
3. **Lineage headers:** every ported row group in `test-sentence/` names the
   brief §12 deliverable it descends from (test 1 = the changing-world
   deliverable; test 2 = lazy-genius; test 3 = agent-vs-forgetter; test 4 =
   the deletion table), so the four acceptance tests survive the death of
   the file that housed them as NAMED deliverables.

## 13. Register status after Part II

D1 ✅ A (ground corrected) · D2 ✅ (+capture executed) · D3 ✅ (+three riders;
enlarged by §10: optlaw re-open, expfam E7 port, UseBern retirement) ·
D4 ✅ (delegated, SayableP discipline) · D5 ✅ (+the filtered-latents check) ·
D7 ✅ (window recorded) · **D6 — the sweep the author demanded is resolved,
the branch recorded; his word adopts it.** With that word the oracle drafts:
g1–g5 as planned, g2 + g3's two orientations, the optlaw generator port
riding the same boundary.

*Part II ends here. D6's word arrived 2026-07-15 with one condition (E-s2)
and one conviction (the drift400 row); Part III enacts both.*

---

# PART III — the author's verification, enacted (2026-07-15)

## 14. The D2 capture defect — convicted, characterized, corrected

The author's verification of §11 refused the drift400 row: six checkpoints
t=0..400 bit-identical on a drifting stream, for a state-carrying
component, is not a thing the machine does. The demanded falsifier ran
before anything froze (`scratchpad/step3/Falsify.hs`, transcript
`falsify-transcript.txt`):

```
(i)   as-captured read, t=0 : 3fd9437c705edf8a
      as-captured read, t=1 : 3fd9437c705edf8a     <- labels are fiction
(ii)  prior predictive      : 3fe0000000000000     <- 0.5, NOT the captured hex
(iii) perturbed-y0 read t=0 : 3fd9437c705edf6c     <- the state DID absorb the stream
```

**The defect, characterized:** the capture replayed the FULL stream once
and then queried that one final agent at six values of the t FEATURE —
which the hmm model never reads. Every checkpoint label reported the t=400
filtered predictive. So the mechanism differs from the suspected one in
detail — the state was not non-advancing ((ii) refutes that: the prior is
0.5, and (iii) shows the state moved with the data); it advanced all the
way and was READ once, at the end, under six names. The defect class is
exactly as charged: a satisfiable capture measuring the wrong quantity,
caught by review — and it is the R-D23-post-mortem class ("only review
catches it"), caught this time BEFORE the golden froze, which is the
system working.

**The fix** (`MapCapture.hs` r1, transcript `d2-capture-transcript-r1.txt`):
the checkpoint-t read replays the PREFIX y_0..y_{t-1} into a fresh
singleton and queries `predictive` there — the one-tick-ahead component
predictive AT t. Corrected values:

```
shifted160, flat400: BIT-IDENTICAL to §11 (t-deterministic components,
                     no latents — the labels were harmless exactly there)
drift400 (the corrected checkpoint row g1 pins):
  P(y=1|t=0)   = 0.5                 (3fe0000000000000)  <- the prior, lawful
  P(y=1|t=59)  = 0.6916884643800074  (3fe6224fd8b10b00)
  P(y=1|t=60)  = 0.6504317073177599  (3fe4d05627e6c256)
  P(y=1|t=61)  = 0.6707499803272403  (3fe576c8a9a98a5e)
  P(y=1|t=399) = 0.35587201797761275 (3fd6c69b6db19fad)
  P(y=1|t=400) = 0.39474402402583364 (3fd9437c705edf8a) <- §11's one true value,
                                                            now correctly labeled
MAP identities and masses: unchanged (the mixture replay was never at issue)
```

**The method ground, for the oracle header as instructed:**
per-hypothesis latent filtering is independent of the mixture weights —
`observe` advances each hypothesis's filtered state on its own and the
meta-belief only reweights — so a singleton agent on the MAP model,
prefix-replayed to t, carries exactly the mixture component's filtered
state at t. The ground was always true; the first implementation failed
to read the state at the checkpoint it claimed.

## 15. E-s2 — the u-fragment's floats through the sentence route, MEASURED

The condition on D6's word, verbatim: "the ported extensional twins
executed against the old route on the 49 row-instances' quantities,
bit-compared — and the ==-versus-tolerance decision for the re-frozen
optlaw rows made on those numbers."

(`scratchpad/step3/Es2.hs` + `twin/PropLang/EnumerateTwin.hs`, throwaway;
transcript `es2-transcript.txt`.)

**Design — substitution at every float source the demolition moves:**

- The u-channel is a PUBLIC parameter of `enumerateUModels`, so the 39
  exchangeable gPin rows substitute through the real src surface:
  **`codeVerdict`** — the σ-mixture said as a `Code` sentence (the
  u-fragment's missing 567-analogue, measured here for the first time) —
  and the code-routed `emit`. Float-order discipline: the frozen
  `pApprove` (Enumerate.hs:586-588, quoted in the program) folds
  `sum` left from 0, and `0 + x == x` bit-exactly for `x > 0`, so the
  sentence's tree is `Add (Add t1 t2) t3` both numerator and denominator;
  `negate`↔`Neg`, `exp`↔`Exp`, `logBase 2 y`↔`Div (Log y) (Log 2)`
  (Eval.hs:177-183; test-code group 5).
- The state-carrying gBoundary rows need the INTERNAL walk/bern sites,
  unreachable publicly: `PropLang.EnumerateTwin` is a scratch copy of
  `Enumerate.hs` (the step-2 seeded-defect precedent for scratch src
  copies) with `walkOn`/`emit`/`stepHyp`'s bern re-routed through the
  frozen test-code sentences — byte-copies of `codeWalk` (:198-210) and
  `codeBernV` (:252-259), each delta declared at the copy site
  (instantiation space, value-carrying singleton grids, n−1).
- Priors held identical by construction (same enumeration, same
  `modelBits`): E-s2 isolates the kernel-route floats. The prior side is
  E-s1's (world table bit-for-bit) plus, at the re-freeze, the u-agents'
  dl values re-entering as DECLARED world data — a float-free step (same
  dl values, same 2^-dl), stated here so the oracle's continuity row
  covers both halves.

**Result: zero bit-mismatches in 13,992 floats, max |diff| 0.0.**

```
PART A (kernel cells, the 567-analogue for every substituted kernel): 1,332 cells, 0 mismatch
  verdict σ-mixture as a code:   18/18 bit-exact  <- UNPINNED BEFORE NOW
  emit via codeBernV:            18/18 bit-exact  (the frozen pin re-run)
  walk cells, world grid:       8 ρ × 81 bit-exact
  walk cells, u grid:           8 ρ_u × 81 bit-exact (unpinned rates, now measured)
PART B (the 49 row-instances; lpB + full posteriors + lpS + full posteriors,
        old vs twin): 12,660 floats, 0 mismatch — including worldAgent0's
        five 2,340-float rows (1,169-hypothesis posterior vectors, twice each)
spot (pointer, corpus pair (30000,9314), batch lp): old c0d505a97aa7712b | twin c0d505a97aa7712b
```

**The decision, made on the numbers:** the re-frozen optlaw generators'
continuity pins freeze at `==` — bit-equality, the "without regret"
standard, met by measurement, not expectation. The step-2 gates
`tolEv = tolPost = 1e-11` keep their provenance untouched: they gate
batch-vs-sequential WITHIN a route, and the port moves the route's
inputs, which E-s2 just measured stationary.

## 16. D6 CLOSED; the queue for the freeze

**D6 — the word is given, its condition discharged by §15.** The
u-fragment dies with its consumers ({test-d + 2 ablations, WireU, Main}
retire; test-optlaw re-opens with ported generators, continuity at `==`);
utility is re-derived from the axioms at steps 6–8, never rebuilt from
nostalgia. The register is now fully ruled: D1–D7 ✅.

Two canonization items join the freeze-edit queue (the next CLAUDE.md
touch, delegated like the others, R-D22):

1. **The sweep-universe line, the author's wording:** "a sweep's universe
   derives from the custody record plus declared non-manifest surfaces —
   never hand-enumeration."
2. **`discharged-permanent` as a named register category:** the terminal
   state of an ablation fixture — the deletion it proved possible becomes
   the deletion that happened (UseBern the first instance; every ablation
   fixture ends there eventually if the roadmap is honest).

*Part III ends here. The oracle drafts on this ground: g1–g5, g2 + both
g3 orientations, the optlaw generator port and expfam's E7 port riding
the same boundary; g1's drift400 MAP rows pin §14's corrected checkpoint
values.*

---

# PART IV — the oracle, drafted and prototype-verified (2026-07-15)

Commits: `bbdc3f7` (type surface + oracle draft, red 18/25),
`cbf7ac7` (goldens filled from the prototype, g3 restructured on the
measured residue; red 19/26, proto 26/26 SAT).

## 17. The type surface (src, the increment-D stub pattern)

Landed in `Enumerate.hs` (unguarded — sentences are sayable without
the scoring layer, exactly as the fragment is): `FragSort`/`FragProd`
with `fragWidth` = the E-s1 table {MODEL 2, THETA 2, HEAD 2, RATE 1}
(HEAD: one enumerable production under a declared width of 2 — a
classified exception in the SayableP lg-10 sense); transparent
`Hyp { hypBits, hypSpace, hypEmit :: Expr '[] (Maybe (K Double Obs)),
hypMove :: Maybe (Expr '[] (Maybe (K Double Double))) }` (D5 as ruled:
this slot plus the agent's filtered `Belief` covers what `THmm`
carried; no new type — the shipped `Code` IS the hypothesis form;
stateless sentences declare a SINGLETON latent axis so uniform init is
a point mass and no mixture arithmetic touches a degenerate axis);
`enumerateSentences/In/Grid :: … [FragProd] -> [Hyp]` (the deletion
table's subsets stay declarable — D2 part 3); `filterTickFree`;
`sentenceAgent` — GUARDED with the scoring layer, a defect the
deletion audit itself caught live: unguarded, the stub stole the
`carrier-obs` ablation's attribution from `obsCarrier` and test-expfam
went red; the fix is the design being honest (an agent cannot exist
without the carrier — E9). Gate-1 clean; twelve frozen suites green.

## 18. test-sentence/ — 26 rows; red 19/26 attributable, proto 26/26 SAT

Groups as planned (§6) plus the sitting's additions. The seven
green-at-birth rows, each lawful by name: the audit-grep row and the
push/argmax rows (frozen scripts, verbatim — nothing owed); test 2
(verbatim port — the deliberation ladder touches no doomed name; only
its housing file dies); the g4 table-declaration row (declared data,
landed with the surface); g5's three rows (the CPP hooks shipped at
step 1 — the PIN-FREEZE fourth clause applies: red-reachability by
seeded defect, demonstrated in the reviewer block by running a fixture
against a hook-less flag). Every one of the 19 red rows dies at a
NAMED step-3 stub (`red-run-final.txt`) — attribution total.

**R-D21, in the strongest form this project has produced:** the
prototype is an OVERLAY module with the real module's name
(`scratchpad/step3/proto/PropLang/Enumerate.hs`), so the oracle's
EXACT FROZEN TEXT compiles against it unchanged — no transcript
harness re-derivation, no row-text variant. The full suite runs
**26/26 SAT in 29.5 s** (`rd21-proto-transcript.txt`); every frozen
side is forced to normal form by the assertion that consumes it, which
subsumes the per-row deepseq (nothing is lazily skipped in a PASSING
assertEqual/assertBool over Doubles and Strings), and the red run's
19 named-stub exceptions partition attribution exactly.

What the prototype run PROVED (the port-design vindication, all
through the sentence route): test 1's full timeline — probe rows,
exact consult ticks, entropies — against the frozen Python anchors;
test 3's losses and the forgetter table; test 4's whole deletion table
over declared production subsets (including the old no-TGet/no-TGt
coincidence, both mapping to drop-FGuardHead — the frozen anchors
t4LlNoif == t4LlNoget agree); the 1,169 charges bit-exact FROM THE
DECLARED TABLE (dl multiset, family hexes, the step-1 sum hex); the
membrane counts 1241/1529 and the M1 re-pricing as order-free
value-count rows (position is fresh); the MAP identities with §11's
mass hexes and §14's CORRECTED prefix-replay component predictives,
bit-for-bit; both silence rows; Cromwell's consonance row. The fresh
render goldens carry their lineage on their faces: the t1 golden
contains the old tau-11 guard as its theta subtree, the t3 move golden
shows `('c','rho',3)` three times.

## 19. TWO SITTING ITEMS (the oracle does not freeze past them)

1. **D8 — the positive-mass-refuser predictive.** A sentence that
   refuses to denote at prediction time while holding positive meta
   mass: the mixture predictive needs a semantics, and it is language
   content, not builder discretion. Implemented in the prototype (and
   registered here as the candidate): **condition on denotation** —
   the refusers' mass is conditioned away by the same public `cond`
   arithmetic the evidence path uses; their placeholder rows then
   carry weight exactly 0. Grounds: it is the only public-verb-
   expressible option found; "asserted the impossible there
   presupposes a there" — at prediction time there is no there, so
   the mass backs no observation and P(y | the sentence speaks) is
   what the mixture can honestly say. Measured consequence: the two
   g3 routes bit-agree at the t=0 checkpoint under it. The only
   shipped-population effect is NONE (all 1169 sentences always
   denote); this semantics is reachable only through declared worlds
   with refusing sentences.
2. **The g3 fixture-population gates.** The author's pre-ruling asked
   for == only if bit-identity reproduced. It did not, and the reason
   is structural, not sloppy: construct-time exclusion and
   carry-plus-refute normalize over different candidate counts —
   algebraically identical, float-perturbed. Measured on the
   prototype (`g3-residue-transcript.txt`): max relative predictive
   residue **1.2115e-16** (5 ulps, at t=80; most checkpoints
   bit-exact), max absolute posterior residue **1.4433e-15**; the
   dropped sentence's carried-route posterior is exactly 0 from the
   first observed tick. Proposed gates, the repaired-CL-4 idiom:
   **1e-14 relative (predictive, headroom ×83); 1e-13 absolute per
   posterior point (headroom ×69)**; posterior rows start at the
   first OBSERVED checkpoint (pre-observation the dropped sentence
   holds prior mass BY DESIGN — a comparison there is a category
   error). The SHIPPED population row is untouched by any of this:
   the filter drops nothing there and pins ==.

## 20. Freeze items (Phase B, on the author's word; delegated, R-D22)

1. Oracle freeze: `test-sentence/{Sentence.hs, stanza.cabal.draft,
   ablation/run.sh, ablation/Use{Code,Pos,Tor}.hs}` → manifest
   APPEND (rider-2 form); stanza merged into proplang.cabal.
2. D3 retirements at the same signature: `test/Acceptance.hs` (ported
   — the four deliverables live in g1 with lineage headers), `test-d/`
   (+2 ablations), `test-govhost/` (+UseDriver), the govhost exe,
   `host-governor/Wire.hs`, `WireU.hs`; their stanzas leave the cabal.
   The host-less window (D3 rider 2) begins here, stated.
3. Re-opens, delegated-edit specs: **test-optlaw** — generators to the
   sentence route (executable draft: E-s2's twins, §15; continuity at
   `==` on E-s2's 13,992-float measurement; tolEv/tolPost untouched);
   **test-expfam** — E7's fast side `nameAt` → `bernFast`
   (value-invariant by definitional equation, Eval.hs:206), the :137
   pricing row and :189 render golden retire, group 6 retires,
   `UseBern.hs` discharged-permanent; **test-hygiene** — the :94 call
   ported, the STDNAME 7→6 re-pricing (D4, adjudication not grep;
   P5's single site `prodTable` moves 7→6 in the same edit);
   **test-membrane** — model-fragment rows retire in favor of g1's
   ports, action rows stay for step 5.
4. CLAUDE.md canonization riders (§16): the sweep-universe line and
   the `discharged-permanent` register category.
5. Schedule prose amendments (decision 10, D3 rider 1): `interface.md`
   T1, `EXPFAM_PLAN` T1/E9, `design.md`/`typed-port-spec.md` prodTable
   prose, the §8 step-5 row (Wire.hs discharged early; the sentinel's
   surviving site `membrane-wire.md:131` keeps its step-5 date).
6. Phase C (post-tag): implement the surface (the prototype is the
   executable design), DELETE `Bern`/`THmm`/`Model`/`Terminal` and the
   u-fragment, `mkAgent` dies with `Model`; all gates green, anchors
   byte-stable, then the as-built report.

## 21. Reviewer verification block

```sh
export PATH="$HOME/.ghcup/bin:$PATH"; export LANG=C.UTF-8
# red: 19/26 fail, every exception a named step-3 stub
cabal exec -- ghc -Wall -Werror -Wincomplete-patterns \
  -Wincomplete-uni-patterns -isrc -itest -itest-sentence \
  -outputdir /tmp/s3red -o /tmp/s3red/oracle test-sentence/Sentence.hs
/tmp/s3red/oracle; grep -c "step-3 stub" <(/tmp/s3red/oracle 2>&1)
# SAT: 26/26 against the prototype overlay (ask the builder for the
# scratch path, or re-create from pack §17's design)
# g5 seeded-defect red-reachability (pin-freeze clause): break a hook
# and watch attribution fail —
sh test-sentence/ablation/run.sh code   # PASS as shipped
GHC="ghc -DDROP_POS" sh test-sentence/ablation/run.sh code || true
# suites + custody
cabal test all          # twelve suites green
sha256sum -c MANIFEST.sha256   # 85/85 (extends only at the freeze)
```

**The step stops here for the sitting: D8 and the g3 gates (§19), then
the freeze tag over §20.** The builder's recommendation on both §19
items is in their rows; nothing proceeds on recommendation alone.
