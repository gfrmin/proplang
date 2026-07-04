# PHASE 1 REPORT — the frozen oracle

Phase 1 of the CLAUDE.md protocol is complete. This report is the review
artifact for the human before signing `MANIFEST.sha256`. It lists every
embedded anchor and its provenance, the tolerance policy, every place the
spec was under-determined and how it was resolved (with the approval
rulings), and the exact toolchain.

**State at hand-off:** `cabal test` compiles, runs, and FAILS all four
acceptance tests and all three properties (src/ is signature stubs —
`Prelude.undefined` bodies). Gate matrix (`audit/run-gates.sh --phase 1`):
gates 1/2/3/4/7 PASS, gate 5 = expected-fail confirmed, gate 6 PENDING
human signature.

## 1. Toolchain (recorded; a change is a re-open trigger for gate 7's rows)

| component | version | note |
|---|---|---|
| GHC | 9.10.3 | ghcup "recommended"; user-local `~/.ghcup` |
| cabal-install | 3.16.1.0 | test deps pinned in `cabal.project.freeze` |
| ghcup | 0.2.6.2 | bootstrap; `~/.bashrc` deliberately untouched — add `export PATH="$HOME/.ghcup/bin:$PATH"` or invoke via full path |
| Python (oracle) | 3.14.6 | `python3 tests_acceptance.py` reproduces `test_output.txt` byte-identically on this machine (verified before and after seeding) |

The ablation attribution check (gate 7c) greps GHC's error for the bare
constructor token (`Push` / `Argmax`); the error wording is GHC-version-
sensitive, so a toolchain bump requires re-validating that row (and is a
documented re-open trigger, not a silent tolerance edit).

## 2. Streams (test/Streams.hs — port the stream, not the RNG)

All four streams were captured by `audit/capture_oracle.py` (frozen,
idempotent — re-runs are byte-identical) from generators copied verbatim
out of `tests_acceptance.py`, and are embedded as `[Int]` literals:

| stream | length | provenance |
|---|---|---|
| `shifted160` | 160 | seed 11; `y_t = [rng.random() < (0.9 if t<60 else 0.1)]`. Shared verbatim by tests 1 and 4 (`_shifted_world_logloss` uses the same seed and same one-draw-per-tick pattern — verified equal) |
| `buffer36` | 36 | seed 14; `[rng.random() < 0.52]` × 36 (test 2) |
| `drift400` | 400 | seed 5; per tick: y-draw at `grid[i]`, drift-check draw, conditional `rng.choice((-1,1))`; start `i=6` (test 3). Test 4's 250-tick drift world is `drift400[:250]` — asserted at capture time |
| `flat400` | 400 | `[rng.random() < 0.7]` × 400 CONTINUING the same seed-5 RNG after the drift generation (stream order is load-bearing) |

Python 3's Mersenne-Twister `random()`/`getrandbits` are stable across
CPython versions, and the shipped `test_output.txt` reproduced
byte-identically here — but the embedded streams, not the RNG, are the
oracle: the Haskell side never re-derives them.

## 3. Anchors (test/Anchors.hs) — value, provenance, and how asserted

Floats are embedded at full `repr` (shortest-round-trip) precision, so the
Haskell `Double` is the identical IEEE-754 value. "Instr." = captured by
`audit/capture_oracle.py` running the identical arithmetic as the named
Python test with the captured stream; every value was cross-checked
against the printed `test_output.txt` at its printed precision.

**Tolerance protocol (frozen into the test headers):** counts, actions,
tick counts, and rendered programs are asserted EXACTLY; probabilities and
entropies within `tolProb = 1e-6`; cumulative log-losses within
`tolBits = 1e-4`. The Python tests' own inequality assertions are kept
verbatim on top. **A Phase-2 failure of any pinned anchor is
stop-and-report and a human-signed Phase-1 re-open; tolerances are part of
the oracle and are never widened in place.**

Safety margins measured before pinning exacts: min top-2 argmax margin in
test 1 is 1.17e-2 (over all 160 ticks); min |v_act − v_think| margin in
test 2 is 1.49e-3 — both ≥ 9 orders of magnitude above cross-language
float noise.

### Test 1 — the changing-world test (`test_changing_world`, seed-11 world)

| anchor | value | source |
|---|---|---|
| `t1ProbeRows` | 17 rows of (t, P(y=1), action, H) at the ticks the Python test prints (t mod 20 = 0, even t ∈ [58,76]) | instr.; the printed table rows of `test_output.txt` lines 5–21 at full precision |
| `t1ConsultTicks` | [0,1,3,4,65,66,67,68,69,70] | instr.; consistent with printed consult rows at t=0,66,68,70 |
| `t1HPre` / `t1HPostMax` | 3.1489671033557265 / 3.9528542433140568 | instr.; printed as "max post 3.95 vs pre 3.15" (line 25) |
| `t1MapProgram` | `('bern', ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)))` | printed verbatim, line 28; = "if t > 60 then 0.1 else 0.9", the CLAUDE.md "tau=60" anchor |
| `t1MapPosterior` | 0.6383157408996493 | instr.; printed "(posterior 0.64)" |

Python's six assertions are reproduced verbatim (confident predict1 in
[30,60); consult ∈ [60,80); recovers to predict0 in [130,160);
H_post > H_pre + 0.5; change-point MAP — strengthened to the exact
rendered string per the approval ruling; forbidden-token grep clean — run
via `audit/strip_comments.py` over all five src modules).

### Test 2 — the lazy-genius test (`run_deliberation`, seed-14 buffer)

| anchor | value | source |
|---|---|---|
| `t2Rows` | (0.3, **1**, L), (0.05, **3**, L), (0.005, **12**, L), (0.0, **12**, L) | instr. = printed lines 37–40; tick counts are the CLAUDE.md "1/3/12/12" anchor |

Plus Python's own assertion `t_hi < t_mid < t_lo <= t_none` verbatim.

### Test 3 — the forgetting-factor trap (seed-5 worlds)

| anchor | value | source |
|---|---|---|
| `t3ForgetterRows` | γ=0.8: (369.7929712967316, 396.60210068705993) · γ=0.9: (345.5037265510021, 370.0335776855678) · γ=0.95: (340.88263044835253, 359.3527535371701) · γ=0.98: (348.93795719904125, 353.28252431117664) · γ=1.0: (397.9262111919014, 350.33027664041333) | instr. (`forgetter_logloss`, ported quarantined into the test file exactly as Python quarantines it) = printed table lines 56–60 at 1 dp |
| `t3AgentDrift` / `t3AgentFlat` | 339.7824236038744 / 351.1061771452692 | instr. (`agent_logloss`) = printed line 61 |
| `t3MapProgram` | `('hmm', ('c', 'rho', 3))` | printed line 63 — the drift rate 0.1 inferred as content |

Plus Python's own 2%-margin assertions verbatim.

### Test 4 — the deletion audit

| anchor | value | source |
|---|---|---|
| `t4LlFrozen` | 160.00000000000003 | instr. (Python `disabled=("cond",)` agent); printed "160" (line 75). Analytically exact 160: the enumeration is symmetric under θ↔1−θ, so the prior predictive is exactly ½ per tick |
| `t4LlFull` | 96.682771822417 | instr. = printed "97" |
| `t4LlNoif` / `t4LlNoget` | both 103.44568113917315 | instr. = printed "103"; identical by construction — both ablations collapse the space to the same 17 models |
| `t4LlFullD` / `t4LlNohmm` | 207.09758316305718 / 211.05494026245512 | instr. = printed "207"/"211" (250-tick drift world) |
| `t4NFull` / `t4NNoc` / `t4NNobern` | 1169 / 0 / 0 | instr. = `len(enumerate_models(...))` |

Plus Python's own inequality assertions verbatim (cond > +10 bits; if,
get, hmm each > +3 bits). The `push`/`argmax` rows ("raises-by-type") are
compile-time facts checked by `audit/ablation.sh` (invoked both by the
frozen test 4 and by gate 7 — single source): (a) fixture compiles
against the real grammar, (b) fails under `-DDROP_PUSH`/`-DDROP_ARGMAX`,
(c) the error names the deleted constructor. All three checks pass today
against the stub grammar.

### Properties (test/Properties.hs)

* **CL-4 / conjugacy equivalence**, stated extensionally against the
  public Belief API only: `cond` must agree with Bayes' theorem computed
  via `expect`/`prob`/`push`/`point` (both `Saw` and `Is` evidence),
  tolerance 1e-9 relative. Any Phase-2 conjugate fast path behind the
  opaque handle is legal iff this stays green.
* **Fineness charged once**: 9-pt vs midpoint-refined 17-pt theta grid,
  bern-constant ensembles priced 1+1+log2 n bits through `fromBits`,
  random Bernoulli streams (T ∈ [50,200]): |Δ cumulative predictive
  log-loss| ≤ **0.02·T bits**. δ calibrated against the Python oracle:
  observed max 0.0025 bits/obs (shifted-world and iid streams) — 8×
  headroom. δ is part of the oracle (no widening in place).

Count note (reviewer item, 2026-07-04): the plan specified **two**
properties; the suite reports **three** `testProperty` cases because CL-4
is stated once per `Evidence` constructor — `propCl4Saw` (kernel
observation, likelihood recovered publicly as
`lik x = prob (push (point sp x) k) (is osp o)`) and `propCl4Is`
(declared event ≙ renormalized restriction) — plus `propFineness`.
Two invariants, three cases; nothing else is in the suite.

## 4. Under-determination register (dispositions from the approval rulings)

1. **`Argmax` over `NonEmpty o`** (spec §3 sketch said `[o]`): totality-
   forced; APPROVED. CL-3 tie-break (first-listed wins on ties) is
   preserved by NonEmpty order; both tests list the Python-first option
   first ("act" / "predict1" / "L").
2. **`Bits`/`LogProb`**: OVERRIDDEN by the spec author — exported
   newtypes with derived numeric instances, per the amended
   typed-port-spec §2 export list (now 21 items; gate 2 updated
   accordingly via `audit/belief-exports.txt`).
3. **Env-value discipline**: utilities enter as opaque `Util` values
   (`mkUtil`/`applyUtil` — same pattern as `event`/`kernel`/`expect`,
   which already accept host functions at the value layer); likelihoods
   enter ONLY as `Evidence`. APPROVED, **parity-scoped**: when utility
   becomes latent (CIRL, post-parity), `Util` must become priced syntax.
4. **StdName alphabet frozen as {`EU`, `IsEq`, `VAct`, `VThink`}**, with
   the recorded VThink contract: enumerate length-n outcome sequences in
   binary-counting order over the given alphabet, `logPredict` BEFORE
   `cond` per outcome, weight `exp(Σ logPredict)`, `Nothing` ⇒ weight 0,
   minus price. Any addition is a reported alphabet change.
5. **`observe :: Features -> Obs -> Agent -> Maybe (LogProb, Agent)`**
   (natural-log LogProb); the clock externalized as the feature `"t"`
   (interface.md §5 tick echo); Python's `disabled=` knob DELETED from
   the port — the cond-deletion row is computed by re-folding the
   initial agent (verified equivalent to Python's frozen agent
   line-by-line: meta stays prior, hmm latents stay uniform,
   time-indexed sentences still vary with the passed tick). APPROVED.
6. **`C :: Grid -> Ix -> Expr env Double` with `Ix = Int`** is partial
   against total `evalx`; left unfrozen (no test constructs `C`) with a
   validated smart constructor recommended for Phase 2. APPROVED.
7. **MAP assertions strengthened** from Python's shape-check to exact
   rendered strings (`renderModel` = Python `repr` format), per the
   CLAUDE.md named anchors. APPROVED; strings confirmed against the live
   Python run at capture time (asserted inside `capture_oracle.py`).
8. **Minor**: `Obs = Int`; `mkSpace :: NonEmpty a -> Space a`;
   `is :: Eq a => Space a -> a -> Event a` and
   `event :: Space a -> (a -> Bool) -> Event a` (spec gave names only).
   APPROVED.
9. **Doc discrepancies RESOLVED AT SOURCE** (not outstanding): design.md
   originally said 1313 hypotheses and 5 bits for `hmm(rho)`; the code
   computes 1169 (vacuous equal-branch change-points excluded) and 4.0
   bits (the RATE slot is a bare constant, no PARAM-alternative bit).
   The spec author's amended design.md (in the seed commit) now matches
   the code, including the ~12-bit prior gap.

Also recorded: `bern_belief`'s 1e-9 clamp in the Python reference never
binds (grid θ ∈ [0.1, 0.9]), so Phase 2 may implement `emit` with or
without it — no behavioral difference on any oracle input.

## 5. What is frozen vs. flexible

To be hashed by the human (everything under): **`test/`** (Acceptance.hs,
Properties.hs, Streams.hs, Anchors.hs), **`audit/`** (forbidden.txt,
ablation.sh, ablation/UsePush.hs, ablation/UseArgmax.hs, run-gates.sh,
strip_comments.py, check_exports.py, belief-exports.txt,
capture_oracle.py), **`CLAUDE.md`**, and — reviewer-directed hardening,
2026-07-04 — the Python oracle itself: **`proplang.py`**,
**`tests_acceptance.py`**, **`test_output.txt`**. Rationale: the frozen
`capture_oracle.py` reads those three files; hashing them closes the
provenance chain (a post-signing edit to `proplang.py` would otherwise
silently break capture idempotency with no gate noticing). This is a
strict superset of the protocol's Phase-1 list (`test/`, `audit/`,
`CLAUDE.md`) — an added constraint, not a protocol change.

`src/` stubs are NOT frozen: Phase 2 owns them, constrained only by what
the frozen tests utter (the de-facto surface: the Belief export list, the
`Expr`/`StdName`/`Args`/`Idx`/`Vals` constructors, `Util`, `mkEnv`,
`evalx`, and the Enumerate API above), by gates 1–4, and by the CPP
ablation points `DROP_PUSH`/`DROP_ARGMAX` that gate 7 compiles against.
Deliberately absent from the stubs: `ExpFam`/`Carrier`/`Stats` (porting
order step 6, post-parity — src is unfrozen, so adding them later is
legal). `bits`, `featureNames`, `Grid`'s representation, and `Fn` are
stub-only and Phase-2-flexible (no test constructs them).

## 6. Reviewer checklist and signing

Worth personal eyeballs (everything else is checked mechanically by the
gates): this report's §3 provenance table against `test_output.txt`, and
the two ablation fixtures `audit/ablation/UsePush.hs` /
`UseArgmax.hs` (a few lines each; they must utter only PropLang.Syntax).

Then sign:

```
{ find test audit -type f; echo CLAUDE.md; echo proplang.py;
  echo tests_acceptance.py; echo test_output.txt; } | sort |
  xargs sha256sum > MANIFEST.sha256
```

(and countersign MANIFEST.sha256 by your usual means — e.g. a signed git
commit). From that point, any diff under `test/`, `audit/`, `CLAUDE.md`,
or `MANIFEST.sha256` is a protocol violation; Phase 2 builds `src/` until
`audit/run-gates.sh --phase 2` is green, in the porting order of
CLAUDE.md.
