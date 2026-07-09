# increment D Task-2 author pack (HOSTS_D_PACK as reviewed 2026-07-09, riders absorbed)

Builder → author at the oracle-phase STOP (HOSTS_D_PACK §15.2b). Untracked,
like its predecessors. Nothing here binds until your acts: the rulings in §5,
the freeze edits in §6, the tag from your own shell — and, per rider 3, the
freeze additionally gates on Track A (§7).

Revision 2 (2026-07-09): absorbs `UTILITY_RESEARCH_CROSSAUDIT.md` (the
foundations-research cross-audit) per your instruction — one candidate
oracle group added (`gOffPath`, expressly accept-or-strike), one proposed
register line (R-D18), and annotation language on two open rulings; §5a
below carries the cross-audit's decision list. The oracle evidence in §1
is re-run and re-verified at the new counts.

Revision 3 (2026-07-09, after your verdict round): all rulings RECEIVED
and recorded (HOSTS_D_PACK revision 5, §0/§12 — R-D6/7/8/10/12/13 ruled,
R-D7 amended per the gauge argument, R-D18 adopted with the sharpening,
R-D19 added, gOffPath kept, §5a items disposed). The two gating items
are DELIVERED: the budget decomposition (§4, measured — your ~24-minute
arithmetic confirmed) and its consequence `observe_counts` drafted into
the v2 goldens before the vocabulary freezes; the gauge goldens amended
to zero + dollar-slope (the placeholder string is gone from the wire).
§5/§5a survive below as the record of what was asked; nothing in them
remains open. What remains before Task 3 is exclusively your §6 acts.

## 1. Oracle-phase evidence (Task 1, complete)

`test-d/` exists and runs under the EXACT gate flags (`red-run.sh` carries
`-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns` verbatim,
compiling suite + driver out-of-cabal): **compiles clean; 49 tests, 22 green
/ 27 red — exactly the split declared in D.hs's header**, every red a
runtime `unimplemented (oracle phase)` (or the driver's honest
`unsupported utility form: latent@1`), never a compile failure. (Count
history: first delivery 44 / 20 / 24; revision 2 added `gOffPath`'s two
rows — both red via `enumerateUModels: unimplemented`, verified — for
46 / 20 / 26; revision 3 added the two GREEN decomposition rows and the
RED `observe_counts` golden for 49 / 22 / 27, and amended the gauge
golden to zero + dollar-slope per your R-D7 ruling.)

- GREEN (frozen surface only): `g0` (7 rows — the two mandatory fixtures,
  NON-TRIVIALLY: an 8-hypothesis bit-probe world, 4-decision interior menu,
  depths 1/2/3, menu STRICTLY above every singleton face at depths ≥ 2, all
  fifteen hand-derived pins with derivations in comments, first-run green);
  `gCensus` (8 rows: the six per-sort price pins re-run byte-for-byte, the
  1169 count, the TauSpec validating door); `gRouting` (3 rows: the
  routing-closure VALUE pins over pair beliefs — zero-VoI, residual-bound
  0.49 vs −0.01, world-bound 0.39 vs −0.16, rider 1's measured cost in the
  arithmetic); `gBudget`'s world side (§4).
- RED: `gDegeneracy` (bk reproduction at k∈{0,2,4,12}×9 points; the k=1
  asking-death; listening k∈[0..3]/k=4; VoI ≤ 1e-12 at {4,6,12} — expected
  sides recomputed with frozen verbs in Cirl.hs's exact shape), `gHeadline`
  (the falsifiable floor: VoI(k=12) ≥ 1e-6 with UWalk vs ≤ 1e-12 static),
  `gConsult` (t=60 flip; 20-tick resumption window; MAP shape pins),
  `gTauMix` (the τ-owner DEFINED: Σ wᵢ σ(u/τᵢ), weights normalized, 1e-12
  pointwise), `gLedger` (the O1 empty-row family: θ_ask at its dl-prior
  after a verdict+outcome episode — R-D13's identity), `gOffPath` (the
  bit-price identity, cross-audit G2 — ACCEPT-OR-STRIKE, §5a), `gO3` (the bad-code
  paired world: strict pointer-mean ordering), `gDriver` (the routing rows
  live: fires id 4 residual-bound, id 3 world-bound), `gWire` (six latent@1
  codec/process goldens — wire v2's syntax is DEFINED by these), `gBudget`'s
  utility-side count pins (9 / 17).

**Ablation** (`test-d/ablation.sh`, the canonized 4-check shape): 2 rows
PASS — `upilot`/DROP_UPILOT (layer dies whole; error names `UPilot`) and
`uwalk`/DROP_UWALK (error names `UWalk`). **All nine frozen suites PASS**
with the stubs in tree; **manifest 75/75 untouched throughout** (src is
behaviorally frozen, not manifest-frozen — the prepost 2bf6c72 pattern).

## 2. What exists on disk (all builder-side, nothing frozen touched)

- `test-d/`: `D.hs` (the oracle, ~870 lines), `stanza.cabal.draft`,
  `red-run.sh`, `ablation.sh`, `ablation/UseUPilot.hs`,
  `ablation/UseUWalk.hs` — the six files your freeze extends the manifest
  over.
- src type-surface stubs behind `#ifndef DROP_UPILOT` (+`DROP_UWALK` on the
  drift constructor): `Enumerate.hs` — `TauSpec`/`mkTauSpec` (validating
  door, implemented — trivial total surface), `UFamily = UConst | UWalk`,
  `allUFamilies`, `enumerateUModels`, `verdictKernel`, `latentMarginal`
  (error stubs); `Membrane.hs` — `UPilot{upSaid, upVerdict, upOutcome,
  upDepth, upPrice}`, `UTickState`, `UTickTrace`, `membraneTickU`,
  `runMembraneU` (error stubs). Complete data declarations, minimal
  imports, −Werror-clean.
- `host-governor/WireU.hs`: wire v2's parallel module (types real, parsers
  stubbed). Parallel BY NECESSITY: `Wire.WorldDecl` is sealed against
  additive fields by the frozen suite's record construction
  (GovHost.hs:243) — recorded as the increment's first sealing discovery.
  Stays out of the manifest like Wire.hs (H-7).

## 3. Drafting decisions (the as-built register — each now oracle-bound)

1. `enumerateUModels` takes the EMISSION KERNEL (world data), not a
   TauSpec: the degeneracy pins run through the CIRL worlds' own `emit`;
   `verdictKernel valueGrid tauSpec` is the canonical instance.
2. `verdictKernel :: Grid -> TauSpec -> Kernel Double Obs` — a kernel
   without a declared domain is unconstructible (the mkC discipline).
3. **Per-latent agents in the type** (rider 2 / R-D13): the driver takes
   `NonEmpty Agent` — pointer first, residual components after. Product
   form is architecture, not estimation.
4. `membraneTickU` (threaded `UTickState`) + `runMembraneU` (its episode
   fold): register 8.9's answer built in from birth; the wire drives n=1
   with no counter resets, episodes compose from the same function.
5. The stream tag rides as a world-published FEATURE `("stream", c)`:
   0=report, 1=verdict, 2=outcome, 3=comparison — one evidence flow,
   "explained" a role (HOSTS_PLAN 6.2's convention realized).
6. `upOutcome :: Kernel Double Obs` — outcome ticks' declared pointer
   emission. FOUND BY WRITING gO3 (the oracle phase closing the hole the
   implementation would otherwise have invented silently).
7. Canonical renders committed: `('uconst', ('c', '<valuegrid>', k))`,
   `('uwalk', ('c', '<rategrid>', j))`. gConsult's MAP pins are SHAPE pins
   (prefixes) — the rate index is emergent, and pinning an underived
   literal would violate the pinned-literal rule; recorded, not hidden.
8. gDegeneracy's scope: belief/value level + the death schedule. The CIRL
   realized-net pins (−0.02/−1.02, the u=0.8 tie) stay where they are
   frozen (test-cirl) and are not duplicated through new surface.
9. The gHeadline floor is 1e-6 — conservative, six orders above the static
   twin's ceiling, falsifiable in both directions.
10. Wire v2 syntax DEFINED by gWire's goldens: the `latent@1` block
    (said / residuals / tau / price / gauge), stream tags, `observe_batch`,
    the v2 decision reply (`residual_mean` + `sensitivity`,
    observability-only), and the v2 handshake reply (v1's shape +
    `"ulatents"`).
11. (Revision 2) `gOffPath`'s realization avoids every over-commitment:
    the on-path-indistinguishable rivals are manufactured with a
    latent-CONSTANT emission kernel, so the identity holds regardless
    of UWalk's internal semantics (only drafting decision 1 — emission
    factors through the declared kernel — is assumed); the cross-family
    prior odds are READ FROM the t=0 agent (the frozen prior is 2^-dl
    via fromBits), never pinned as a hand literal, so the group commits
    NOTHING about the new sorts' absolute prices; the within-family
    odds-1 pin rides the frozen grid-pricing rule (one mention cost for
    any index). It does bind the canonical render strings the header
    already committed.
12. (Revision 3) `observe_counts` wire shape:
    `{"observe_counts":{"stream":...,"features":{...},"counts":{"1":n1,"0":n0}}}`
    → one `RUObserved` reply for the whole collapse. Its semantics are
    declared IN the type's documentation, not left to implementation:
    per-hypothesis likelihood exponentiation — exact for iid-emission
    families, the printed warm-flattening approximation for
    state-carrying ones. And the gauge block is now
    `{"zero":"status-quo","scale":"usd"}` (R-D7 as amended): the scale
    names the measured unit whose slope is declared 1; there is no
    second anchor to carry and no placeholder string left on the wire.

## 4. The §10.11 budget, measured — and DECOMPOSED (your gating demand)

- World side (the dominant term, measured on frozen surface): the
  governor-sized world enumerates **3,977** models; **50 driver ticks cost
  1.795 s CPU ≈ 36 ms/tick** (GHC 9.10.3, this machine, `gBudget` prints
  it each run).
- Utility side (pinned counts through the enumerator): **additive, not
  multiplicative** — 9 UConst + 8 UWalk = 17 hypotheses per component;
  three components ≈ 51 models beside the world's 3,977 (~1.3%).
- **The decomposition (revision 3; two new GREEN gBudget rows, same
  1241-model world — the frozen govhost suite's — driven both ways):**
  engine-only in-process **6.5 ms/tick**; over the wire through the v1
  driver **8.6 ms/tick** (200 ticks, spawn amortized). So spawn + codec
  + IPC ≈ **2.1 ms/tick (~24%)** and the engine is ~76% of the wire
  cost. Your arithmetic confirmed: 39,314 warm ticks × ~35 ms engine at
  the governor-sized world ≈ **23 minutes of pure engine CPU per cold
  start**, of which `observe_batch` (IPC only) removes ≈ 83 seconds.
- **Revision 3 conclusion (supersedes the earlier one honestly):** the
  binding cold-start cost is ENGINE REPLAY, not round-trips — the
  earlier "observe_batch answers it" claim was wrong for the warm
  channel and is corrected here, not papered over. The answer is
  **`observe_counts`** (drafted into the v2 goldens): per-hypothesis
  likelihood exponentiation from (n1, n0) — O(contexts × grid), not
  O(ticks); exact for exchangeable families, the declared
  warm-flattening approximation for drift-carrying ones. Count-collapse
  the exchangeable, replay only the drift-carrying. Live-path per-tick
  costs are unaffected (8.6 ms/tick is far under any decision cadence).

## 5. Rulings the freeze needed (ALL RECEIVED at the verdict round,
2026-07-09 — kept as the record of what was asked; dispositions in
HOSTS_D_PACK §12)

- **R-D6**: the elicitation cost values (measured units, rider 1) + the
  initial question inventory.
- **R-D7**: the gauge anchors — **including the operational referent of
  "reference-bad"** (the review's dangling symbol; the wire golden carries
  the placeholder string until your ruling names the referent).
- **R-D8**: the residual grid geometries (the fixtures use theta_ask
  {0.05, 0.1, 0.2, 0.4} and value/rate grids mirroring theta/rho — your
  call whether these stand as the reference geometry).
- **R-D12**: wire v2 error semantics as drafted (unknown stream tag,
  gauge violation, comparison on a non-comparison item).
- **R-D13**: confirm the independence declaration (realized in the
  driver's type, §3.3).

## 5a. The cross-audit's decision list (UTILITY_RESEARCH_CROSSAUDIT.md §6
— ALL DISPOSED at the verdict round: 1 adopted-with-sharpening, 2 kept,
3 adopted-both-faces, 4 adopted, 5 confirmed for the report; kept as
the record of what was asked)

1. **R-D18 — the act-independent-drift declaration (G1)**: adopt or
   decline. Drafted in HOSTS_D_PACK §7 (item 1's neighbourhood) + §12;
   one register sentence, no code. Declining leaves the assumption true
   by construction but unprinted — the vacancy-behind-a-name shape.
2. **`gOffPath` — keep or strike (G2)**: the bit-price identity is NOW
   DRAFTED in the oracle (2 rows, red via the enumerator stub) so your
   ruling is over a concrete artifact. Striking is coherent (the
   identity follows from the same frozen verbs the O1 pins exercise);
   keeping makes it a regression instead of a theorem-on-paper. If
   struck, the builder removes the group and re-delivers the counts
   before your manifest extension.
3. **R-D8 ruling language (G3)**: record positivity (payload signs +
   positive grids) as deletion-proof-bearing — the charity restriction
   itself. Grids already comply; language only.
4. **R-D10 wording (G5)**: "revealed vs idealized vs CONSTRUCTED" —
   same open posture, one word added.
5. **KSV caveat (G4)**: one line in the increment report locating the
   ledger against Karni–Schmeidler–Vind (components with neither
   measured units nor a comparison route sit under KSV
   non-identifiability; the empty-row pins are what keep such a
   component from silently pretending otherwise). Builder includes it
   in the Task-3 report unless you decline.

## 5b. Queued for the Task-3 increment report (per your verdicts;
included unless you strike them)

- The **KSV caveat** (G4): components with neither measured units nor a
  comparison route sit under Karni–Schmeidler–Vind non-identifiability;
  the empty-row pins are what keep such a component from silently
  pretending otherwise.
- The **WireU sealing consequence, forward-looking**: record
  construction sealing the write side means every wire version forks a
  module and v3 will fork again — "additive-field extensibility" is a
  named candidate for the next wire boundary, not a per-increment
  surprise.

## 6. The freeze commit's edit list (author-applied, drafts enclosed)

1. `proplang.cabal`: merge `test-d/stanza.cabal.draft` verbatim (the
   TENTH suite; no new executable).
2. `CLAUDE.md` porting-order sentence: D before A, D0 subsumed — your
   words (R3).
3. `HOSTS_PLAN.md`: §8.12 resolved (D0 skipped), §9 reordered, §6
   observation space outcome-first.
4. `membrane-wire.md`: the v2 `latent@1` section (gWire's goldens are the
   normative examples), or a successor doc frozen beside it.
5. `MANIFEST.sha256`: extend over test-d/'s six files + the amended texts;
   re-sign; tag from your own shell.

## 7. The rider-3 gate (Track A) — LANDED

Outcome-capture plumbing is COMPLETE on `feat/membrane-adapter` (local,
unpushed — the push/PR is yours), four commits atop the data audit:

- `a033f3e` daemon: the `outcome` record + `POST /result` (+ the
  openclaw `tool-completed` linkage; `report()` aggregation revives the
  session summary's honest subset). Replay-inert, proved by test.
- `5d5ff13` Claude Code: PostToolUse result hook + the Pre/Post
  correlation stash (O_EXCL, FIFO on collision, pruned; best-effort —
  never blocks a tool).
- `8899db7` grounding promoted into the library + the `ground_capture`
  backfill CLI (event_id-keyed reverted/completed/retries; incremental).
- `567d145` openclaw: `in_response_to` = the governance eventId on
  tool-completed and turn-cost; README documents the enabling config.

Full governor suite **311 passed, 2 skipped** (was 289); openclaw TS
**56 pass** + clean tsc. Builder-verified independently: `membrane.py`'s
decide path diff is ZERO lines (consumer discipline held); no label
assignment anywhere. Two honest refusals recorded in the commits:
per-call `spend_usd` on the Claude Code path is SKIPPED (per-turn usage
is not attributable to one call by wall-clock window — faking the
attribution would be a silent assumption; turn-cost + grounding still
feed `total_usd`), and the session summary's savings-estimate keys stay
unfabricated. Both belong on R-D5's ruling table: spend attribution on
the hook path is OPEN, not solved.

## 8. Reviewer verification block (run by the author)

proplang (repo root):

    export PATH="$HOME/.ghcup/bin:$PATH"
    sh test-d/red-run.sh          # compiles clean; 22 green / 27 red
                                  # (prints the decomposition ms/tick)
    sh test-d/ablation.sh all     # 2 rows PASS, attribution named
    cabal test all                # nine suites PASS (stubs in tree)
    sha256sum -c MANIFEST.sha256  # 75/75 — nothing frozen touched
    git status --short            # untracked test-d/, WireU.hs, packs;
                                  # modified: src Enumerate/Membrane only

credence-governor (rider 3):

    git -C ~/git/credence-governor log --oneline feat/membrane-adapter
    uv run --project packages/governor_core pytest -q   # full suite green

After your rulings + freeze + tag: builder implements to green (Task 3),
anchors byte-stable, increment report, your verification block re-run.
The builder never owns a live oracle at the moment it becomes binding.
