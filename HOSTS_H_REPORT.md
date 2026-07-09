# HOSTS increment H — as-built report (the governor host)

Builder → author, at H's implementation close. Untracked, like the
pack. The freeze (`f989c42`, tag `govhost-freeze`) and the
implementation (`65015f2`) are done; this reports the as-built
register answers and the differential gate's measured result — which
is a STOP-AND-REPORT, not a pass.

## 1. What shipped

- **The wire driver** (`host-governor/`, proplang, builder commit
  `65015f2`): `Wire.hs` (the canonical JSON-subset codec, the
  validated world builder, `step` as one pass of the frozen
  `runMembrane` at n=1) and `Main.hs` (read-step-write-flush; IO
  nowhere else). The frozen oracle `test-govhost/` is **40/40**; all
  nine suites green under `cabal test all`; ablation attributes;
  manifest 75/75; anchors byte-stable.
- **The governor adapter** (`credence-governor`, branch
  `feat/membrane-adapter`, `6f78d71`): `MembraneSession` — a
  `BrainSession`-shaped session over the membrane wire, selected by
  `CREDENCE_MEMBRANE_COMMAND`; `training/membrane_diff.py` — the
  differential gate; `test_membrane.py` — 12 tests (hermetic +
  end-to-end). The full governor suite is **169 passed, 2 skipped**;
  nothing else touched. Local branch only — not pushed; the PR is the
  author's to open.

## 2. The differential gate — RED, and why (the finding)

Both engines, same red-team + benign corpora, waste-only, decision
agreement:

    agreement 21/29 = 0.724   (proposed gate 0.95; exit 1)

Every one of the 8 disagreements is the SAME shape: **julia=proceed,
membrane=ask**. The membrane never proceeds and never blocks — it
asks on all 29 cases. That uniformity is the finding, and its
mechanism is exact (measured, not inferred):

- proplang's `thetaGrid` tops out at **0.9** (`thetaPoints =
  0.1..0.9`, Enumerate.hs:78-79 — frozen data). No single hypothesis
  predicts approve above 0.9, so the BMA predictive is **≤ 0.9 for
  every context**. Probe (warm-capped 1500 for tractability; the
  ceiling is grid-structural, magnitude-independent): p1 = 0.8978 /
  0.8975 / 0.8982 / 0.8993 across benign, attack, and empty contexts
  — pinned just under the ceiling and barely moving.
- the governor's step-table utility makes proceed win only when
  **p > 1 − q/c = 1 − 0.02/0.5 = 0.96** (EU(proceed) = −c(1−p) >
  −q). Since p ≤ 0.9 < 0.96 always, **proceed is structurally
  unreachable** on the membrane; block needs p < 0.04, which
  approval-heavy warm data never produces. Hence: ask, uniformly.
- the adapter is faithful. The wire's p1 IS the frozen engine's
  `prob (predictive …)` (pinned in the govhost oracle g2); the
  divergence is the ENGINE's, transmitted exactly.

This is the grids-vs-conjugate tradeoff, measured: Julia's
Beta-Bernoulli posterior concentrates toward 1 and clears 0.96 on
confident-benign cases (→ proceed); proplang's grid-enumerated
posterior is ceilinged at the grid's top point (→ can't). Neither
engine's own green suite could surface this; the differential gate is
what made it visible. Direction of divergence: the membrane is
uniformly MORE conservative (asks where Julia proceeds) — the
fail-safe direction for a gate, at the cost of more interruptions
(the q the governor economizes).

**Not tuned away (register 8.4/8.5).** The gap is the measurement.
Three levers could close it, none the builder's to pull:
1. **the theta grid** (reach 0.95/0.98/0.99): a frozen alphabet-data
   change — Enumerate.hs is manifest-frozen and the grid is pinned by
   the 1169 count and the dl anchors, so this needs a new boundary,
   not an edit. (It is also the honest place a "governor-grade"
   confidence ceiling would be declared — a candidate register item
   for a future increment, priced like the frontier.)
2. **the governor's utility constants** (raise q, or lower c): the
   host's declared data — the governor's call, and "never tuned to
   pass the gate" applies here most sharply.
3. **discrimination** (p1 ≈ 0.90 flat across wildly different
   contexts): approval-heavy warm data + single-indicator guards move
   the posterior little; a richer guard family (depth-2, the deferred
   §2 widening) is the designed lever, itself gated on exactly this
   evidence.

The author reviews the enumeration; the deployment decision (does the
membrane ever go primary for waste?) was always the author's, and
shadow mode means Julia stays primary regardless. On this evidence
the honest recommendation is: **membrane stays shadow; H's value is
the measurement, not a cutover** — and the grid-ceiling finding is
the first concrete demand-signal for a future boundary (grid-as-data
revision), exactly the gated-minimal ladder working as designed.

## 3. As-built register (HOSTS_PLAN §8)

- **R1** (ruled ask,block,proceed): carried as normative on the wire
  and in the adapter; the oracle's tie-break test and the adapter's
  menu-order test both pin it. Note the ceiling finding makes the
  tie-break moot in practice for now (proceed unreachable), but the
  ordering is correct against the day the ceiling lifts.
- **8.1 fail-open severance**: transport fail-open (driver EOF/error)
  is the adapter's `MembraneError`; the tie-break polarity is the
  wire's — kept distinct, as ruled.
- **8.2 arrival order / the t-convention**: refined as-built. The
  `BrainSession` surface carries no event id, so `t` is the
  EVIDENCE-STREAM INDEX (the hmm clock, one step per conditioned
  verdict); a decision tick reads the current index, an evidence tick
  advances it. Live == replay because both fold in arrival order.
  This is the faithful realization of "the original t re-sent" on a
  surface without event ids.
- **8.3 warm counts**: flattened to pseudo-evidence ticks (n1 approve
  then n0 refuse, contexts in file order); exact for the exchangeable
  families, a declared approximation for hmm. **Cost finding:** 39,314
  warm ticks × one subprocess round-trip each is slow (the full
  replay did not finish inside 5 min in a probe; the gate ran it in
  the background). `CREDENCE_MEMBRANE_WARM_CAP` is the adapter knob;
  a batched-observe wire verb is the obvious future optimization
  (a wire addition, not an alphabet change) if the membrane ever
  goes primary.
- **8.4 the ask row**: the myopic PI-VOI derivation shipped verbatim;
  its gap to Julia is exactly what §2 measured.
- **8.6 namespace**: 39 waste indicators + t; harm keys projected out
  by `onehot`. Confirmed the 40-name world enumerates 3,977
  hypotheses over the wire (handshake reply `models: 3977`).
- **8.9 echo**: all-false, validated at the handshake; the n=1 driver
  forbids echo, as designed.
- **H-7**: `host-governor/` stayed out of the manifest (implementation
  surface); gate 5 catches any drift by failing to compile the frozen
  oracle. Confirmed intact.

## 4. Reviewer verification block (author, from each repo root)

proplang:

    export PATH="$HOME/.ghcup/bin:$PATH"
    cabal test all                 # nine suites incl. govhost 40/40
    sha256sum -c MANIFEST.sha256   # 75/75
    git tag -v govhost-freeze      # Good, author key

credence-governor (needs both engines — pinned Julia image + the
built proplang-govhost):

    uv run --project packages/governor_core pytest \
        packages/governor_core/tests/test_membrane.py -q      # 11 (+1 e2e)
    CREDENCE_MEMBRANE_COMMAND=<path/to/proplang-govhost> \
      uv run --project packages/governor_core \
      python -m credence_governor_core.training.membrane_diff  # the gate

## 5. What remains, and whose it is

- **The author's**: review the enumeration; rule on the grid-ceiling
  finding (open a future grid-as-data boundary, or record it as the
  membrane's declared operating point for waste); decide whether to
  push `feat/membrane-adapter` and open the PR. H's increment is
  otherwise closed: frozen oracle, implementation, adapter, and the
  measured gate all exist and are reproducible.
- **NOT the builder's**: no grid edit, no utility retune, no cutover —
  each is either frozen surface or the host's declared data.

H set out to make proplang host-drivable and to measure it against the
incumbent. Both are done. The measurement says the enumerated engine,
as frozen, cannot express the confidence the governor's proceed
threshold demands — a true, precise, and previously invisible fact,
which is exactly what the gate was for.

## 6. Author review addendum (2026-07-09) — recorded, not patched

The author reviewed this report and accepted it as sound, with one
reframing and two caveats that now carry the record:

- **The flat p1 is the graver finding, not the ceiling.** p1 ≈ 0.898
  across benign, attack, and empty contexts alike means the engine is
  (on this evidence) a near-constant function of context. Lift the
  ceiling to 0.99 tomorrow and you would have a constant function with
  a higher constant. Non-discrimination is the disease; the ceiling
  merely made it visible. §2's lever 3 (the guard family) is therefore
  the load-bearing lever, not lever 1.
- **"More conservative = fail-safe" earns a raised eyebrow.** For a
  governor whose product case is economising interruptions, ask-always
  is fail-safe with respect to harm and dead on arrival with respect
  to purpose — a confirmation dialog with a Haskell dependency. The
  fail-safe framing in §2 stands only for the harm axis.
- **Caveat for the record: the flatness was probed under the
  1,500-tick warm cap.** The ceiling conclusion is cap-independent
  (grid-structural); the flatness conclusion strictly is not — a
  full-warm measurement remains owed (queued behind the batched-
  observe wire verb, HOSTS_D_PACK §10.11's neighbourhood).

The retirement of agreement-% (this report's §2 metric) was ruled the
same day; the successor discipline is HOSTS_D_PACK.md.
