# bench-fold-depth-r01 — fold-depth cost measurement (proplang; the gating datum for the credence→proplang seam swap)

Session brief: "fold-depth cost measurement" (owner, 2026-08-18). This report is the
session's whole output; the seam-swap judgement is the owner's, against the pre-stated
band, and is NOT taken here.

## STATE

- **Repo / HEAD:** `proplang` at `94fd4eb` (the #19 sitting commit), working tree clean
  under `src/` throughout (`src-dirty=0` in every build stamp); no file outside `bench/`
  touched; freeze-kit, r1-kit, batteries, audit, register, `proplang.cabal`,
  `MANIFEST.sha256` untouched (`sha256sum -c MANIFEST.sha256` passes at HEAD, verified
  before any file was written).
- **Machine:** `thinkpad` — Intel Core i5-10210U @ 1.60 GHz (4 cores / 8 threads, turbo to
  4.2 GHz), 15.7 GB RAM (≈9 GB used, ≈7.5 GB swap in use by other processes at start),
  cpufreq governor `powersave`, Arch Linux kernel 7.1.8-arch1-3.
- **Competing load (verbatim from the dispatcher, then observed):** "this machine will be
  running pytest suites and possibly one `docker run` (podman) of a Julia container
  concurrently with your benchmark — that is COMPETING LOAD". Observed at wave starts
  (`bench/results/machine.txt`): a `qemu-system-x86` VM at ~5 % CPU, several `claude`
  agent processes at 3–5 % each, `tailscaled`; load average 1.8–2.6 before the bench
  started its own processes. The bench itself ran ≤4 single-threaded cells concurrently
  under `nice -n 10` (one physical core each on a 4-core box, hyperthread siblings
  shared with the competing load). **Absolute per-tick times therefore carry a
  contention factor — MEASURED by the wave-E solo controls at ×1.20 for three concurrent
  cells and ×1.37 for four (P1@10^4: 21.4 ms solo vs 25.6–25.9 vs 29.3–29.4); the
  within-session slopes (α) are what the protocol relies on, and CPU time is recorded beside
  wall time in every route-1 CSV (it tracks wall within 1 %: the cells were CPU-bound, never
  descheduled for long).**
- **Toolchain:** GHC 9.10.3 (ghcup), cabal 3.16.1.0, GMP-backed `ghc-bignum` (the
  Integer/Rational implementation whose cost curve is measured in
  `bench/results/gmp-ops.txt`); Python 3 (stdlib only) for the fits.
- **Build:** plain `ghc -O1 -Wall -Werror -isrc -ibench` against the shipped `src/`
  (the frozen ablation runner's `ghc --make -isrc` form; `-O1` is cabal's default
  optimisation, i.e. what the served `proplang-host` is built with). Every cell CSV
  begins with the OB-32 build stamp (exe sha256, HEAD, `src-tree` hash, `src-dirty`,
  compiler). No cabal file was edited (proplang.cabal is manifest-frozen), so the bench
  is not a cabal stanza; see PROPOSED.

## DONE — the protocol as executed

### Files (all new, all under `bench/`)

| file | what |
|---|---|
| `bench/BenchLib.hs` | the instrument's library half: seed-pinned synthetic worlds (P1/P2/P3 + sanity S0/S1 + calibration variants), wire-line generators, the route-2 MIRROR, window sampler, reply parsing, build stamp |
| `bench/BenchFoldDepth.hs` | the executable: `--route 1` (timed wire session) / `--route 2` (wire session + mirror, bits at windows, per-tick pin) |
| `bench/BenchTest.hs` | the instrument's tests (34 rows, all green — `bench/results/bench-test.txt`) |
| `bench/NormBitsProbe.hs` | the executed witness for PROPOSED 4(i): unnormalised vs normalised meta-weight bits at depth (`bench/results/normalized-bits.txt`) |
| `bench/GmpOps.hs` | the arithmetic-cost model: µs per Integer gcd / Rational multiply / Rational add at 1.7 k … 518 k-bit operands (`bench/results/gmp-ops.txt`) |
| `bench/run-cells.sh` | the runner: build, tests, then the cells in waves A–D of ≤4 concurrent processes and the solo-control wave E; verbatim commands below |
| `bench/analyze.py` | the pre-stated analysis over `bench/results/*.csv` (fits, bootstrap CIs, operating point, sanity criterion, reconciliation) |
| `bench/results/solo/*.csv` | the wave-E solo controls (S1@10^5 ×2, S0@10^5, P1@10^4, one process at a time) + `analysis-solo.txt` |
| `bench/results/*.csv` | one CSV per cell (windowed medians for route 1; bit-size samples for route 2), build-stamped, with the hello line, the argv, `models`, and the summary/truncation lines |
| `bench/results/{bench-test,gmp-ops,machine,analysis,normalized-bits}.txt` | the test transcript, the cost-model table, the machine/load record at each wave boundary, the full analysis printout, the normalisation witness |

### Reproduction (verbatim)

```
cd ~/git/proplang
bench/run-cells.sh A B C D E        # build + tests + every cell (≈4.5 h wall as budgeted) + the solo controls
python3 bench/analyze.py | tee bench/results/analysis.txt
python3 bench/analyze.py bench/results/solo | tee bench/results/solo/analysis-solo.txt
ghc -O1 -Wall -Werror -isrc -ibench -outputdir ~/.cache/proplang-bench/build-probe -o ~/.cache/proplang-bench/nbp bench/NormBitsProbe.hs && ~/.cache/proplang-bench/nbp | tee bench/results/normalized-bits.txt
# one cell by hand (route 1 timed / route 2 bits), from the repo root so the stamp reads git:
ghc -O1 -Wall -Werror -isrc -ibench -outputdir ~/.cache/proplang-bench/build -o ~/.cache/proplang-bench/bench-fold-depth bench/BenchFoldDepth.hs
~/.cache/proplang-bench/bench-fold-depth --profile P2 --ticks 1000 --seed 1 --route 1 --out bench/results
~/.cache/proplang-bench/bench-fold-depth --profile P2 --ticks 1000 --seed 1 --route 2 --out bench/results
```

### Workload — the wire as a host drives it

Every cell is ONE `serveLine` pure session: a hello declaring the world (namespace,
guards, menu, codebooks, `said@1` utility, optional `obs_arity`), then T ticks each
carrying `features` + `menu` + `evidence` (decide-then-fold, the wire's own order:
`chooseEU` over the menu's assignments, the readout, then `observeS` at
`features ++ act`). Codebook values are declared as the Doubles the wire is sent
(`show` → the wire's `reads`), and the mirror embeds them by the same `realToFrac`
the door uses (`Host.hs jQ`). The synthetic world's randomness is a bench-side
SplitMix64 seeded per cell (the tick stream is deterministic and prefix-stable per
seed — test t1); the host `draw` door (`/dev/urandom`, unseedable) is never on the
served decision path (exact argmaxes) and is not called.

| profile | namespace / guards / menu | theta | rho | K | population (`models`) | why |
|---|---|---|---|---|---|---|
| **P1 minimal** | `x` (binary feature, guard at 0.5), menu `act ∈ {0,1}` | 3 dyadic points {4,8,12}/16 | — | 2 | 9 | one binary feature, one conditioning per tick, one `chooseEU` between two sentences |
| **P2 representative** | `s` (binary tag, guard 0.5), `c` (4-level covariate, guards {4,8,12}/16), `act ∈ {0,1,2}` (guards 0.5, 1.5) | 9 dyadic points {1,3,5,7,8,9,11,13,15}/16 | 4 dyadic {1,2,4,8}/16 (walk family declared) | 2 | 445 | the consumer's utility-fold SHAPE as recorded proplang-side (HOSTS_PLAN §6.1–6.2: const + walk families over a grid, one-bit verdicts, an interior menu of three) — see DEVIATIONS 2 |
| **P3 adversarial** | `x` (guard 0.5), `act ∈ {0,1}` | 5 NON-dyadic tenths {0.1,0.3,0.5,0.7,0.9} | 1 non-dyadic {0.3} | **6** | 130 | the levers ranked by bits/fold: (i) non-dyadic decimals embed as 2^-55-denominator rationals with 52-bit odd numerators (~107 bits per weight per fold vs ~4–8 for sixteenths); (ii) K=6 (the breadth suite's recorded consumer operating point) puts 5^t in every denominator and makes every predictive a 6-vector; (iii) walk latents mixed and re-normalised every tick. Grid WIDTH is not a per-weight denominator lever, only a population multiplier, so it is kept small enough to run (DEVIATIONS 3) |
| S1 sanity | P1's world, ticks carry `menu` but no `evidence` | as P1 | — | 2 | 9 | decisions over a belief that never moves: known-constant cost |
| S0 sanity | P1's world, ticks carry features only (`{"ok": true}`) | as P1 | — | 2 | 9 | pure serve |
| P2nw (calibration) | P2 without `rho` | as P2 | — | 2 | 441 | attribution of P2's cost to the walk latents |
| P3wide (calibration) | P3's first draft: theta 9 tenths, rho 3 | | | 6 | 420 | the pilot that re-parameterised P3 (DEVIATIONS 3) |

Utility (all decide profiles): `said@1` = `act * (2*y - 1)` (the trampoline fixture's
form). Worlds: P1 `y ~ Bern(0.75 if x else 0.25)`; P2 `y ~ Bern(0.8 | s=1; 0.3 | c>0.5;
0.55 else)`; P3 a 6-atom categorical (atom 3 at 0.5 when x=1, atom 1 at 0.5 when x=0,
0.1 elsewhere). Windows: 100 ticks each, starts at 1, 2, 3, 5, 7 × 10^k and the last
window ending at the last tick; the fitted `t` is the window mid-point.

### Route 2 — exactly what was measured

The engine's state (`AgentS`) is opaque on the wire, so route 2 MIRRORS it from the
host side through the exported verbs alone: the enumerated `Hyp` list
(`enumerateWith` / `enumerateWithBreadth`, the wire's own call shape), and per tick the
steps of `Enumerate.observeS`/`tickPred` re-executed with `Eval.evalx`,
`Belief.push/predictMass/condK` (a copy at `94fd4eb`, cited by binding name). Rational
values are canonical (`Data.Ratio` reduces at every operation), so a value-identical
mirror has a bit-identical representation. Two pins make that identity checked, not
argued: (a) every tick, the mirror's marginal rendered exactly as the wire renders it
(`show (bitsView m)`) must equal the reply's `loss_bits` string — every route-2 cell
reports `pins_checked = ticks_done`, and a mismatch aborts the cell; (b) test t5c: the
mirror's normalised meta weights `==` (Rational) the engine's `metaPosterior` of an
`AgentS` folded through `observeS` on the same stream, for P1/P2/P3/P2nw. The measured
quantity is then **b(t) = Σ over the meta weight vector of bits(numerator)+bits(denominator)
(the UNNORMALISED weights the engine carries) + Σ over every walk latent's weight vector
of the same** — the belief state's exact serialised size in bits — plus the max
per-hypothesis size and the marginal's size, sampled at every window start and end.
"Count of rational operations per tick" was NOT obtainable from the host side without
touching `src/`; the arithmetic-cost model (`GmpOps`) plus the structural pass counts
below stand in for it (DEVIATIONS 7).

Structural pass count per decide+evidence tick (from the wire's code path, for a menu
of m assignments over K obs atoms and N hypotheses): `predictiveBelief` per candidate = K
`predictMassS` passes (m·K), the readout K+1 passes, `entropyAgent` one `metaPosterior`
(N divisions), `observeS` one pass — i.e. (m·K + K + 3) passes of N big-rational
multiply+add each: P1 7, P2 9, P3 21 passes.

### Cells — the matrix as run

Wall budgets: wave B (P2@10^4 ×3, P3@10^3 s1) 7200 s per cell; wave C (P1@10^5 ×3, P2@10^4
route 2) 4500 s; wave D (P3@10^3 s2/s3, P1@10^5 route 2, P3@10^3 route 2) 2700 s; wave E =
SOLO controls (one process at a time). "done/req" = ticks completed / requested; a cell with
done < req carries a `# TRUNCATED at tick N: wall budget …` line. Population = the hello's
`models` (route 2's mirror population equals it in every cell). Full inventory with wall
seconds and peak RSS: `bench/results/analysis.txt` (CELL INVENTORY).

| profile | scale | seeds | route 1 (timed) done/req | route 2 (bits) done/req, pins | note |
|---|---|---|---|---|---|
| P1 (9) | 10^2 | 1,2,3 | 100/100 ×3 | 100/100 ×3, 100 pins each | |
| P1 | 10^3 | 1,2,3 | 1000/1000 ×3 | 1000/1000 ×3 | |
| P1 | 10^4 | 1,2,3 | 10000/10000 ×3 (106 s each, 3 concurrent) | 10000/10000 ×3 (128 s each) | operating-point cell |
| P1 | 10^5 | 1,2,3 | **39532 / 39317 / 39614 of 100000** (4500 s budget each, 4 concurrent) | **33392 of 100000** (seed 1, 2700 s), 33392 pins | truncated; the deepest P1 cells |
| P2 (445) | 10^2 | 1,2,3 | 100/100 ×3 (6 s) | 100/100 ×3 | |
| P2 | 10^3 | 1,2,3 | 1000/1000 ×3 (362 s each, 4 concurrent) | 1000/1000 ×3 (357 s) | |
| P2 | 10^4 | 1,2,3 | **3437 / 3433 / 3432 of 10000** (7200 s budget each, 4 concurrent) | **2561 of 10000** (seed 1, 4500 s), 2561 pins | truncated; the deepest P2 cells |
| P2 | 10^5 | — | not launched | — | dropped by projection (DEVIATIONS 4) |
| P3 (130) | 10^2 | 1,2,3 | 100/100 ×3 (≈80 s each) | 100/100 ×3 (86 s) | |
| P3 | 10^3 | 1,2,3 | s1: **598/1000** (7200 s); s2/s3: **407 / 407 of 1000** (2700 s each) | **397 of 1000** (seed 1, 2700 s), 397 pins | truncated; the deepest P3 cells |
| P3 | 10^4, 10^5 | — | not launched | — | dropped by projection |
| S1 sanity (9) | 10^4, 10^5 | 1 | 10000/10000, 100000/100000 (in wave A, 4 concurrent) + solo re-runs (wave E: seeds 1,2 @10^5) | — | |
| S0 sanity (9) | 10^4, 10^5 | 1 | same | — | |
| P2nw calib. (441) | 10^2, 10^3 | 1 | 100, 1000 | 1000 | attribution: P2 without walks |
| P3wide calib. (420) | 10^2 | 1 | — | 100/100 (594 s) | the first-draft adversarial world |
| P1@10^4 solo control | 10^4 | 1 | 10000 (wave E, alone on the box) | — | the concurrency factor |

Every route-2 cell reports `pins_checked == ticks_done`: **the mirror's marginal rendered as
`loss_bits` agreed with the wire's on every one of the 74 350 evidence ticks across
all route-2 cells; no cell aborted on a pin.** Peak RSS: 12–42 MB across every cell (P2@3400
ticks: 41.6 MB; P1@39 500 ticks: 66.5 MB) — memory is not a factor at these depths; the state
is bits, not bytes.

### Sanity seed

Pre-stated criterion (in `analyze.py`, before any protocol cell ran): the constant-cost cell
is FLAT iff the log-log slope over all its windows satisfies |α| ≤ 0.10 AND the ratio of the
largest to the smallest window median is ≤ 1.5. Two constant-cost workloads were run on P1's
world: **S1** (decision ticks, `menu` but no `evidence` — the wire evaluates the two-sentence
`chooseEU`, the readout and the entropy display every tick over a belief that never moves,
≈150 µs/tick of real work) and **S0** (features only, `{"ok": true}`, ≈4 µs/tick — the
harness's own floor).

| cell | windows: median µs (start→) | α (all windows) | max/min | verdict by the criterion |
|---|---|---|---|---|
| S1@10^5, wave A (4 concurrent) | 267 (t=1–60) → 156–175 (t=70–7000) → 126–145 (t≥10^4) | −0.095 | 2.13 | NOT FLAT (ratio) |
| S1@10^4, wave A | 267 (t≤50) → 151–171 → 146 | — | 1.8 | NOT FLAT (ratio) |
| S1@10^5 SOLO, wave E (seed 1) | 144 (t=1) → 141–143 (t≤5000) → 128–143 (t≥7000) | −0.006 | 1.13 | **FLAT** |
| S1@10^5 SOLO, wave E (seed 2) | 143 (t=1) → 126–135 (t≥200) | −0.010 | 1.14 | **FLAT** |
| S0@10^5, wave A | 6.0 (t≤70) → 3.5 → 4.1 | −0.054 | 2.20 | NOT FLAT (ratio) |
| S0@10^5 SOLO, wave E | 6.1 (t≤70) → 3.5–3.8 (t≥200; one 5.3 at t=70 000) | −0.071 | 1.75 | NOT FLAT (ratio; the ≈70-tick / ≈0.4-ms warm-up at the 4-µs scale) |

**Reading, without smoothing.** By the letter of the pre-stated criterion: **S1 SOLO (both
seeds) is FLAT** — |α| ≤ 0.010, max/min 1.13–1.14 over 10^5 ticks of ≈140 µs each; the SAME S1
workload run inside wave A alongside three sibling cells FAILS the ratio half (2.13) with a
NEGATIVE slope; S0 fails the ratio in both settings. What the failing cells show, tick by tick,
is not growth but two environmental effects: (i) sibling-cell contention at launch — wave A's
S1 ran at 267 µs while its two 10^4-tick siblings were alive (S0@10^4 finished at 0.1 s,
S1@10^4 at 1.9 s ≈ S1@10^5's tick 12 000), then 155–175 µs while S0@10^5 was alive, then
126–145 µs alone, which is the SOLO level (126–144); the per-window MINIMUM drops from 247 to
141 µs at exactly the first sibling's exit; and (ii) a start-up transient at the microsecond
scale — S0's first ≈70 ticks (≈0.4 ms of wall) run at 6.1 µs against 3.5 µs thereafter, in
solo and in-wave alike (a fresh heap and a `powersave` core coming up); S1 SOLO shows no such
transient at its 140-µs scale (144 → 141 µs). No sanity cell shows a positive slope: the harness
does not measure itself as a function of fold depth, and its own per-tick floor is 3.5 µs
(S0 solo steady state), 60× below P1's smallest per-tick cost and 10^4× below P2's. The
environment moves absolute per-tick cost by ×1.2–1.4 under concurrency (measured, STATE) and by
×1.7 for the first ≈0.4 ms of a process. **The run is therefore reported as valid for its
slopes and for absolute costs at the stated concurrency, with the in-wave ratio-criterion
failures recorded as they stand and the solo control as the criterion's clean pass**; the
reviewer may take the stricter reading (QUESTIONS 5 and 7).

### Fits (α from time, β from bits, γ = cost against bits) and the operating point

Three readings of α are printed for every profile (`bench/results/analysis.txt`): the
protocol's `alpha_raw` (pure power law over the top two decades of the deepest cells, window
mid-points, bootstrap over seeds); `alpha_excess` (first-window median subtracted, same
range); and `alpha_3p` (the three-parameter model c(t) = c0 + a·t^α over ALL windows of the
deepest cells, relative-weighted least squares, α on a 0.005 grid, bootstrap over seeds) —
the last is the one whose residuals are small (rel-RMSE 1–6 % on undisturbed cells, 9–16 % on the two cells with recorded load disturbances) and whose c0 is the tick's
fold-independent cost. `alpha_raw` is biased low wherever c0 is not yet negligible;
`alpha_excess` is biased high because the first window already carries fold cost; the
truth sits between them and `alpha_3p` locates it.

| profile | deepest cells (depth) | α_raw [CI] | α_excess | **α_3p [CI]**, c0 | β (bits) [CI], bits/tick | measured c at 10^4 | 3p projection at 10^4 |
|---|---|---|---|---|---|---|---|
| **P1** | 3 × 10^5 (39 317–39 614 reached) | 1.470 [1.457, 1.490] | 1.657 [1.591, 1.767] | **1.595 [1.580, 1.650]**, c0 0.294 ms | 0.999 [0.999, 0.999], 19.8 bits/tick (594 643 bits at t = 30 099; max weight 96 011) | 29.4 / 29.3 / 29.4 ms at [10000, 10099] (4 concurrent); 25.6 / 25.9 / 25.8 ms in the 10^4 cells (3 concurrent); **21.4 ms SOLO** | 29.1 ms |
| P1 (10^4 cells) | 3 × 10^4 | 1.091 [1.086, 1.096] | 1.487 [1.467, 1.517] | **1.565 [1.565, 1.575]**, c0 0.282 ms | 0.996 [0.996, 0.996], 19.8 bits/tick (2.2 per weight; max weight 3.2/tick) | 25.6–25.9 ms | 26.8 ms |
| **P2** | 3 × 3432–3437 | 1.138 [1.129, 1.144] | 1.590 [1.580, 1.600] | **1.525 [1.485, 1.540]**, c0 71.2 ms | 0.998, 3168 bits/tick (deep route-2 cell to t = 2561: 5.67 Mbit at t = 2099; 10^3 cells: meta 2693 = 6.1 per weight, max weight 17/tick; latents 469 = 13 per weight; marginal 16/tick) | not reached (4.80 / 4.81 / 4.82 s/tick at t≈3400) | c(10^4) ≈ 71 + 0.0195·10^4^1.525 ms ≈ **24.6 s/tick** |
| **P3** | 598 / 407 / 407 | 1.429 [1.407, 1.466] | 2.403 [2.218, 2.643] | **1.430 [1.400, 1.540]** (seed 1 alone 1.540, c0 146 ms; c0 is not identifiable on P3 — growth dominates from tick ≈5) | 0.996, 20 582 bits/tick to t = 300 (6.18 Mbit; max weight 98 752 at t = 300; 100-tick cells: 20 584 bits/tick — meta 12 446 = 96 per weight, max weight 329/tick; latents 8 138 = 326 per weight; marginal 327/tick) | not reached (25.6 s/tick at t≈550) | c(10^4) ≈ 146 + 1.517·10^4^1.54 ms ≈ **2.2·10^3 s/tick (≈37 min per tick)** with seed 1's fit, 1.5·10^3 s with the pooled fit (a 1.3-decade extrapolation) |
| P2nw (calib.) | 1 × 10^3 | 0.732 | 1.865 | 1.570, c0 18.1 ms | 0.991, 2642 bits/tick (max weight 7.1/tick; marginal 6.3/tick) | — | 5.6 s/tick |

**The operating point, stated as the brief defines it: 10^4 ticks accumulated (≈ one month of
always-on operation at ~300 events/day).** Measured where reached, projected by the 3p fit where
not; every absolute number carries the concurrency factor of its wave (STATE; the wave-E solo
control puts it at ×1.20 for three concurrent cells and ×1.37 for four, on P1@10^4).

- **P1 minimal: 21.4 ms/tick SOLO, 25.6–25.9 ms/tick at three concurrent cells, 29.3–29.4 ms/tick at four** (measured; three seeds; the 10^5 sessions' [10000, 10099] windows and the 10^4 cells' last windows agree once the concurrency factor is applied). Tick 1 costs 0.28 ms; the fold-depth share at 10^4 is 99 %.
- **P2 representative: ≈ 24.6 s/tick projected** (3p fit on the three 3400-tick sessions at four concurrent cells; the last measured window is 4.80–4.82 s/tick at t ≈ 3400, ×68 the tick-1 cost; ÷1.37 for a solo box gives ≈18 s/tick). A 10^4-tick P2 session at this growth is ≈ 27 h of wall at this concurrency, ≈ 20 h solo.
- **P3 adversarial: ≈ 1.5–2.2·10^3 s/tick projected** (pooled vs seed-1 fit) from sessions of 598 / 407 / 407 ticks whose last windows are 25.6 / 13.1 / 13.1 s/tick; per-weight growth 96–329 bits per fold, 30–100× P1's. A 10^4-tick P3 session at this growth is of the order of 10^2 days.

α per scale (`alpha_raw`, pooled seeds; how the slope steepens with depth as the operands enter GMP's super-linear regime): P1 0.36 (10^3) → 1.09 (10^4) → 1.47 (3.9·10^4); P2 0.76 (10^3) → 1.14 (3.4·10^3); P3 1.43 (4–6·10^2). β is 0.99–1.00 in every cell: the belief state's bit-size grows LINEARLY in fold depth (each fold multiplies every unnormalised weight by a fixed-size rational and re-normalises each walk latent), with per-weight rates set by the declared values — 2–3 bits/fold for P1's sixteenths, 6–17 for P2's, 96–329 for P3's non-dyadic decimals (13–100× — the value-embedding lever, QUESTIONS 3).

### Two-route reconciliation

The two routes tell ONE story, and the arithmetic-cost model links them quantitatively:

1. **Route 2 (bits):** b(t) is linear (β ≈ 1.0 in every profile and seed; CI width ≤ 0.003).
2. **Route 1 (time):** the fold-depth part of the per-tick cost grows as t^α with α_3p in a
   narrow band, 1.43–1.60, across P1 (1.565 at 10^4, 1.595 at 4·10^4), P2 (1.525), P2nw (1.570)
   and P3 (1.43 pooled; 1.54 on its deepest seed, where c0 is best identified) — one arithmetic
   on worlds whose per-weight growth rates differ by 100× and whose populations differ by 50×.
3. **The link:** with linear bits, α = β·γ where γ is the exponent of per-tick cost against
   operand size. Fitting c = c0 + a·b^γ directly on the joined windows gives **γ_3p = 1.570 for P1** (the 10^5 cells; the
   wave-A intermediate analysis over the 10^4 cells read 1.535, off-repo), 1.345 for P2 (seed 1, the only deep route-2 seed; rel-RMSE 10 % because of the disturbed [300, 399] window) and 1.27 for P3 (a poor fit: c0 is unidentifiable on P3 — reported, not relied on). The measured per-operation
   cost of the Integer/Rational primitives on this box (`bench/results/gmp-ops.txt`) has
   log-log slope 1.05 at 1.7–5 kbit operands, 1.14–1.5 at 5–17 kbit, **1.41–1.58 at 17–520
   kbit** for `gcd` and `Rational` multiply (the fold's `reduce` is one gcd of the products), and
   1.15–1.53 for `Rational` add (the marginal's sums: a denominator multiply plus a gcd at
   double size). P1's largest weight is 32 kbit at t = 10^4 and 96 kbit at t = 3·10^4 (marginals 24 / 72 kbit),
   P2's 17 kbit per 10^3 ticks (36 kbit at t = 2100), P3's ≈99 kbit at t = 300 and ≈180 kbit at t = 550 — all in the range where GMP's
   gcd is between Lehmer's quadratic regime and its sub-quadratic HGCD, i.e. slope ≈1.4–1.6.
   **γ_3p ≈ 1.5 measured on the wire is that slope; α ≈ β·γ ≈ 1.0 × 1.5 is the fits' α_3p.**
   The routes agree with each other and with the primitive-cost curve, and the mirror pin
   holds on every tick, so there is no disagreement to report.
4. **What the model predicts and the data show at the edges:** (a) `alpha_raw` per scale
   rises with depth (P1: 0.36 → 1.09 → 1.47) — not a change in the mechanism but the constant
   c0 fading out of a pure power fit as t^α overtakes it, and GMP's slope steepening from ≈1.05
   toward ≈1.5 as operands cross ~10 kbit; the 3p fit is flat across scales. (b) The walk
   family costs far more than its share of the population: P2's four walk hypotheses (of
   445) are 78 % of P2's tick at t = 1000 (P2 723 ms vs P2nw 161 ms, both in wave A) and 77 %
   at t = 1 (84 vs 19 ms) — their
   latents are re-normalised every tick and their predictive masses are sums, so the marginal's
   size grows 2.6× faster (16 vs 6 bits/tick) and every `predictMassS` pass pays gcds on
   sums. (c) Population multiplies the constant, not the exponent: P2nw (441 hyps, no walks)
   has α_3p 1.570 with c0 18.1 ms; P1 (9 hyps) 1.565 with c0 0.28 ms — a 64× constant for 49×
   the population and 1.3× the passes (9 vs 7), the same exponent.
5. **Not smoothed:** the seed-1 P2@10^4 window [300, 399] reads 382 ms against 222 ms for the
   other two seeds and against its own neighbours (158 → 382 → 354 ms) — a ≈30-s external
   disturbance during that window (its mean 329 ms and min 181 ms show the mixture); it is
   the reason seed 1's 3p residual is 9.8 % against 1.8 % for seeds 2–3, and it is left in
   the data and the fits.

## DEVIATIONS

Every departure from the brief's protocol, however small, with why.

1. **Acceptance band unfilled.** The brief's blanks ("≤ ____ ms at the operating point and
   α ≤ ____ on P2") were not filled by the owner as delivered. Per the brief's own
   instruction the measurement ran anyway and **no acceptance judgement is made
   anywhere in this report**; the numbers await the owner's band (PROPOSED states this
   again in the required place). No band was invented, and the prose is not coloured
   toward pass or fail.
2. **P2's parameters are the builder's reconstruction, not the consumer's numbers.** The
   brief says to read the evidence arity and grid widths from "the life-agent design
   doc's §3 table if in doubt"; the dispatcher permitted exactly
   `~/git/life-agent/docs/unified-ledger-design.md` §3 and nothing else from that repo.
   That §3 ("Ordering and the merge rule") is a table of per-fold MERGE ORDERS
   (sources, declared order) and carries no arity or grid width. Under the permission
   as granted, P2 was parameterised from what the proplang side itself records about
   the consumer: `archive/HOSTS_PLAN.md` §6.1–6.2 (the utility posterior IS an Agent:
   `UConst` + `UWalk` families over a grid, one-bit owner verdicts, the interior menu
   {ask-owner, act-now, think-deeper}) and `test-breadth/Breadth.hs`'s consumer note
   (K = 6 as the K-ary operating point, used for P3). P2 = two features with guards, a
   3-option menu, 9-point theta grid, 4-point rho grid, K = 2, population 445. **If the
   consumer's utility world differs (fewer or more grid points, no guards, a different
   menu), P2 must be re-run at the owner's numbers — one command per cell — before its
   α or its operating-point cost is read against the band.** See QUESTIONS 1.
3. **P3 was re-parameterised ONCE, before any protocol cell ran, on a calibration pilot,
   and the pilot is recorded.** The first draft (`P3wide`: theta 9 tenths, rho 3 rates,
   K = 6, population 420) reached tick 30 at ~1 s/tick in the route-2 pilot
   (`bench/results/P3wide-T100-s1-route2.csv` is the 100-tick calibration cell that
   survives from it) — unmeasurable past a few hundred ticks. Population is not a
   per-weight denominator lever (each weight's factors are its own theta's; the
   population multiplies the constant), so P3 as frozen keeps the three growth levers
   (non-dyadic embedding, K = 6, walks) and shrinks the population to 130 (theta 5
   points, one rate, one guard). The pre-stated protocol is the frozen P3; P3wide is a
   calibration variant only.
4. **Scales dropped or truncated (no silent caps — every cell states `ticks_done`,
   `ticks_requested` and, when budgeted out, `# TRUNCATED at tick N: wall budget …`).**
   Wall budgets per timed cell: P2@10^4 and P3@10^3 seed 1: 7200 s; P1@10^5: 4500 s;
   P3@10^3 seeds 2–3: 2700 s; route-2 deep cells 4500 s / 2700 s. Dropped by projection
   (never launched): P2@10^5, P3@10^4, P3@10^5 — the measured growth (see the fits)
   prices P2's 10^4-tick session alone at ≈27 h at four concurrent cells (≈20 h solo) on this
   box and P3's 10^3-tick session at ≈6.5 h; a 10^5-tick P2 session at the measured α is of
   the order of 10^3–10^4 h. The
   truncated cells keep every completed window; the "top two decades" of a truncated
   cell are the top two decades of the depth it reached (stated per fit). Route 2 at
   the deepest scale ran for seed 1 only (bits are a near-deterministic function of
   depth: the three-seed spread at 10^3 is printed in the tables); route 2 for every
   scale ≤ 10^3 (all profiles) and P1@10^4 ran for all three seeds.
5. **"the host `draw` door as the only randomness" — read as a constraint on the language,
   not as the stream generator.** `draw` reads `/dev/urandom` and is not seed-pinnable,
   and nothing on the served decision path calls it (selection is an exact argmax); the
   brief's "seed-pinned" workloads therefore use a bench-side SplitMix64 (constants in
   `BenchLib.hs`) for the synthetic world, and the language sees only the wire lines.
   Recorded here in case the owner meant something else by the phrase.
6. **Concurrency and load.** Cells ran ≤4 concurrent single-threaded processes under
   `nice -n 10` on a 4-core/8-thread laptop with the dispatcher's competing load (STATE);
   the breadth suite's own drift row documents +7–10 % on "loud box" runs of the same
   arithmetic; the P2@10^3 cells read 718 ms/tick at 4-way concurrency against 555 ms/tick
   in a solo pilot (×1.29), and the wave-E solo controls measure ×1.20 (three concurrent)
   and ×1.37 (four) on P1@10^4. **Absolute costs in this report are therefore upper bounds
   by a factor 1.2–1.4 for a solo run on this box; the slopes are not affected in kind.** CPU time is recorded beside wall time in every route-1 CSV (`median_cpu_ns`)
   and tracks wall within 1 % everywhere, i.e. the processes were CPU-bound, not
   descheduled.
7. **Route 2's "count of rational operations per tick" was NOT measured** — it is not
   obtainable from the host side without instrumenting `src/`, which the brief forbids.
   In its place: (a) the structural pass count per tick (DONE, derived from the wire's
   code path: 7 / 9 / 21 N-wide passes for P1 / P2 / P3), and (b) the arithmetic-cost
   model measured on this box (`bench/results/gmp-ops.txt`: µs per gcd / Rational
   multiply / Rational add against operand bits), which is what the two-route
   reconciliation uses.
8. **What route 2 measures is the mirror's state, pinned to the wire.** `AgentS` is
   opaque; the bit-size is read off a bench-side mirror of the engine's exact state
   (DONE, "Route 2 — exactly what was measured"), pinned per tick to the wire's
   `loss_bits` and, in test t5c, to the engine's `metaPosterior` by Rational equality.
   This is stronger than the brief's "state serialisation size at the wire" proxy, but
   it is a mirror, and the pins are what license the reading.
9. **The fits — two readings added AFTER the first data were seen.** `t` for a window is
   its mid-point (start + 49.5); the top two decades of a cell are the windows with start ≥
   depth/100. The protocol's α (`alpha_raw`, a pure power law) is printed as pre-stated.
   Two further readings were ADDED to `analyze.py` after the wave-A cells (10^3/10^4) had
   been looked at and before the deep cells finished: `alpha_excess` (first-window median
   subtracted) and the three-parameter `alpha_3p` (c(t) = c0 + a·t^α over all windows,
   with c0 the tick's fold-independent cost). They were added because the pure power fit
   visibly does not describe the data (a 0.28-ms constant under P1's 10^2–10^3 windows, a
   71-ms one under P2's) and its α depends on which decades are fitted; that is a post-hoc
   analysis choice and is labelled so. All three are printed side by side; the report's
   headline uses `alpha_3p` (QUESTIONS 5). The bootstrap over seeds with n = 3 has 10
   distinct resamples — its CI is a coarse spread, printed as such.
10. **The harness measured itself once and was fixed before the protocol run.** In the
    first pass, per-tick timings were accumulated in boxed Haskell lists; the S0 sanity
    cell (4 µs/tick) showed the late windows drifting up by ~0.6 µs over 10^5 ticks and
    the first two windows 1.8× the rest (a warm-up transient), so the criterion
    `max/min ≤ 1.5` failed on S0 while S1 (160 µs/tick) passed. Timings were moved to
    unboxed arrays and **every cell was re-run from scratch with the fixed binary**
    (the first pass is archived off-repo at `~/.cache/proplang-bench/pass1/`, not
    committed); the sanity result reported below is the re-run's. The warm-up transient
    is a property of the first ≈70–200 ticks at the microsecond scale and is invisible at
    every measured profile's cost (≥ 250 µs/tick).
11. **The bench is not a cabal stanza.** `proplang.cabal` is manifest-frozen (cabal edits
    only at freeze boundaries), so the instrument builds with plain `ghc -O1 -isrc
    -ibench` — the frozen ablation runner's form — rather than through the repo's `cabal
    test`; the commands are recorded verbatim (DONE). PROPOSED names the stanza as the
    thing a freeze boundary could add.
12. **`machine.txt`'s first wave-A record lacks the hostname** — `hostname(1)` is not
    installed on this box and the runner's first cut called it; corrected to `uname -n`
    before the protocol run (the pass-1 record is off-repo).
13. **The SOLO controls (wave E) were added after the in-wave sanity cells had failed the
    ratio criterion** — S1@10^5 ×2, S0@10^5 and P1@10^4 run one process at a time on the box
    (`bench/results/solo/`). They are a diagnostic addition to the pre-stated protocol
    (which said "one cell with a known-constant-cost workload"), made so that the sanity
    failure could be attributed (contention vs. growth) and the concurrency factor
    measured rather than guessed; they are not used in any α fit.

## REFUSED

- Filling, guessing, or "reading off" an acceptance band from the numbers — the brief
  reserves it to the owner.
- Touching `src/PropLang` for route 2 ("even just for instrumentation"): the mirror
  through exported verbs is the instrument instead.
- Editing `proplang.cabal` (manifest-frozen) to add a bench stanza; touching any
  freeze-kit, r1-kit, battery, audit, register, or `MANIFEST.sha256` file.
- Reading anything in `~/git/life-agent` beyond the one permitted `§3` table (see
  DEVIATIONS 2) — including the docs that probably DO carry the utility model's numbers.
- Making 10^4/10^5-tick P2/P3 cells "feasible" by restarting sessions, thinning ticks,
  or sampling windows from separate shorter sessions — fold depth is the object; the
  cells were truncated by wall budget and say so instead.
- Committing or pushing: the series is prepared below; the owner commits.

## QUESTIONS (owner vs reviewer)

1. **(owner)** P2's numbers: which document/table carries the example utility model's
   evidence arity and grid widths, and what are they? The permitted `unified-ledger-
   design.md §3` does not. If the consumer's fold has no guards (pure `UConst`+`UWalk`
   over one grid, population ≈ |grid_u| + |grid_ρ|), P2's constant is an
   over-estimate by roughly the population ratio while its α is the same arithmetic;
   re-run is `bench-fold-depth --profile P2 …` after editing `profileP2` in
   `bench/BenchLib.hs` — or, better, add a `--world FILE` door (PROPOSED).
2. **(owner)** The operating point: the brief defines it as 10^4 ticks accumulated (≈ one
   month at ~300 events/day). Is a tick on THIS wire one event (decide+fold), or does the
   consumer's fold see several ticks per event? The number is reported per tick as
   defined; the mapping is the owner's.
3. **(owner)** Does the consumer's hello declare its grids as decimals (`0.1`, `0.3`, …)
   or as binary-exact values (`n/16`, `n/2^k`)? P3's dominant lever is exactly this
   host-side choice (a 2^-55 denominator per declared decimal), and it is a one-line
   hygiene fix on the consumer side that changes the fold's growth rate by an order of
   magnitude — see the reconciliation. The breadth suite already learned this lesson
   for wire-facing test worlds ("binary-exact SIXTEENTHS").
4. **(reviewer)** Is the mirror's pin (per-tick `loss_bits` string equality + the t5c
   `metaPosterior` Rational equality) accepted as sufficient license to call route 2's
   number "the belief state's bit-size", or should a further pin (e.g. `mapS` per
   window) ride the next round?
5. **(reviewer)** Should the two-decade fit be re-stated on the three-parameter model
   (`alpha_3p`, c(t) = c0 + a·t^α) rather than the pure power law, given the constant
   offset visibly bends every curve in its lower decade and the 3p residuals are 1–6 %? All
   three are printed; the protocol's number is `alpha_raw`, and the report's headline is
   `alpha_3p` — flagged as the builder's choice, not the brief's.
6. **(owner)** The wall budgets truncated P2 short of 10^4 ticks. Is a dedicated solo
   overnight run of P2@10^4 (three seeds, sequential, ≈20 h each solo at the measured
   growth) wanted before the swap decision, or is the fitted projection with its CI
   enough decision input?
7. **(reviewer)** The sanity criterion (|α| ≤ 0.10 AND max/min ≤ 1.5) was pre-stated for "the
   sanity cell" without saying whether it binds the in-wave run or a solo run; the solo S1
   passes and the in-wave S1 fails on contention alone. Which reading governs the "run is
   invalid" clause of the brief? This report takes the solo reading and says so.

## PROPOSED

**No acceptance judgement is possible from this report: the owner's band (per-tick cost at
the operating point ≤ ____ ms; α ≤ ____ on P2) was not filled in the brief as delivered.
The numbers await the band; nothing here is coloured toward pass or fail.** What the numbers
imply for the next measurement or decision input:

1. **The datum, as measured.** Per-tick cost under exact rational arithmetic grows as
   c(t) = c0 + a·t^α with α_3p = 1.43–1.60 on all three profiles (1.53–1.60 where c0 is
   identifiable), because the belief state's
   bit-size grows linearly in fold depth (β ≈ 1.0) and the per-operation cost of GMP's
   gcd/multiply at 10^4–10^5-bit operands grows as bits^1.4–1.6 (γ ≈ 1.5). Session cost is
   ∫c ~ t^2.5. At the brief's operating point (10^4 ticks accumulated) the wire serves P1 at
   ≈21 ms/tick solo / 26–29 ms/tick under 3–4 concurrent cells (measured), the P2 world at ≈25 s/tick
   (projected from 3400 measured ticks; 4.8 s/tick measured there; ≈18 s/tick solo), and the P3 world at ≈1.5–2.2·10^3 s/tick (projected from
   598 ticks; 25 s/tick measured there). Whether any of these is inside the band is the
   owner's reading.
2. **P2 must be re-run at the consumer's actual world before its number is read against the
   band** (DEVIATIONS 2, QUESTIONS 1): the α is the arithmetic's and will not move; the constant
   scales with population × passes × per-weight bit rate, all three of which the consumer's
   declaration fixes. Proposed instrument change (one small increment, bench-local): a
   `--world FILE` door on `bench-fold-depth` that reads the hello JSON and the world's
   generative parameters from a file, so the consumer's exact hello can be replayed without
   editing `BenchLib.hs`.
3. **Two host-side levers change the constant by an order of magnitude and are decision
   inputs, not language changes:** (a) declare grid values that are binary-exact
   (`n/2^k`) — the breadth suite's own "sixteenths" rule — instead of decimals: P3's
   dominant lever is the 2^-55 embedding of `0.1`, worth 100× in bits per fold per weight
   and correspondingly in cost (QUESTIONS 3); (b) the walk family (`rho`) is 78 % of P2's tick
   at t = 1000 with 4 of 445 hypotheses — if the consumer's `UWalk` analogue can be carried
   with fewer latent points or fewer rates, the constant drops almost proportionally.
   Neither touches `src/`; both are declarations.
4. **The next measurement, if the band is not met by re-declaration alone:** the growth is a
   property of unnormalised exact weights that never re-normalise (`observeS` multiplies;
   only `metaPosterior`/`predictMassS` divide) and of Data.Ratio's per-operation `reduce`. The
   candidate remedies are language/design decisions above this session's remit and are
   named only so the owner can weigh them: (i) periodic exact re-normalisation of the meta
   weights — EXECUTED WITNESS, not assumed (`bench/NormBitsProbe.hs` →
   `bench/results/normalized-bits.txt`): the normalised weights `w/z` (the `metaPosterior`
   view) carry 0.90–0.93× the bits of the unnormalised vector on P1 and **2.6× (P2) and 3.4×
   (P3) MORE**, because dividing by the running sum puts the sum's numerator into every
   weight; exact re-normalisation does not bound the state and mostly enlarges it; (ii) log-space or
   bounded-precision weights — expressly outside the exact reasoner's charter (KERNEL: "no
   tolerance, no log-space") and therefore a PRINCIPLES-level question, not a fast path;
   (iii) session restarts (fold-depth reset), which is forgetting by another name and is
   what the acceptance stories refuse ("beats the forgetter it refuses to become"); (iv) a
   host fold that carries only what the served route needs (e.g. no per-tick
   `entropyAgent`/readout, which are display: P1's tick makes 7 N-wide passes of which 3
   are the decision and fold, 4 are readout/display) — a fast path that would need its pin
   under the optimisation law. Measuring how much of the constant is display vs decision is
   a cheap next cell (route 1 with the readout suppressed is not possible without touching
   `src/`; the structural count above is the estimate).
5. **Instrument follow-ups (bench-local):** the `--world FILE` door (item 2); a solo, sequential
   overnight P2@10^4 run if the owner wants the operating point MEASURED rather than projected
   (≈20 h per seed solo at the measured growth; DEVIATIONS 4 / QUESTIONS 6); and, if the
   bench is to ride gate 5, a `bench` cabal stanza spliced into `proplang.cabal` at a freeze
   boundary under the author's key (the bench today builds with plain `ghc -isrc`; the
   commands are recorded and the tests are green).

### Prepared commit series (owner commits; nothing committed or pushed by this session)

1. `bench: the fold-depth cost instrument (bench r01) — BenchLib/BenchFoldDepth/BenchTest/GmpOps, run-cells.sh, analyze.py`
   — `bench/BenchLib.hs`, `bench/BenchFoldDepth.hs`, `bench/BenchTest.hs`, `bench/GmpOps.hs`,
   `bench/NormBitsProbe.hs`, `bench/run-cells.sh`, `bench/analyze.py`. No file outside `bench/`.
2. `bench(results): fold-depth r01 cells — every cell CSV, the test transcript, the cost model, the machine record, the analysis`
   — `bench/results/*.csv`, `bench/results/solo/*.csv`, `bench/results/{bench-test,gmp-ops,machine,analysis,normalized-bits}.txt`, `bench/results/solo/analysis-solo.txt`.
3. `bench: bench-fold-depth-r01.md — the fold-depth cost report (STOP; the seam-swap judgement is the owner's)`
   — `bench/bench-fold-depth-r01.md`.

`git status` at the end of the session shows exactly these paths under `bench/` as untracked
and nothing else modified; `sha256sum -c MANIFEST.sha256` still passes.

**STOP.** The seam-swap judgement is the owner's, against the pre-stated band.

---

# r02 — the #24 sitting's additions (2026-09-01/02)

*Everything in this section was produced during the #24 sitting (rounds
r1–r2); the full findings, register, and transcripts ride
`chooseeu-author-pack.md` and `chooseeu-sitting/`. Recorded here is what
changes how THIS report is read. The prepared series above landed at this
r02 (commits 1–2 carry the sources and cells; this file rides commit 3);
the membership deviations from the prepared lists are recorded in the
commit messages.*

## r02.1 — P2 was a reconstruction; `P2real` is the owner's declaration

The r01 P2 profile was reconstructed from merge orders and got six
structural things wrong (the sitting's F5 names them; the largest: no
`clock` field at all, where the owner declares one — the single biggest
per-decide multiplier — and dyadic-vs-decimal grid values, worth ~100x in
bits per fold). `bench/P2Real.hs` + `gen-p2real.py` now carry the owner's
declaration verbatim with THREE independent derivations of its population
(python-side, haskell-side, and the engine's own `models` reply) checked
against each other in BenchTest t8 and at every cell start. The
reconstruction stays in the record beside the real profile so the delta is
visible. **Any r01 number quoted for "P2" is the reconstruction's;
operating-point readings belong to `P2real` cells only.**

## r02.2 — the two selection routes, A/B at the real declaration

Measured on steel (idle, performance governor, matched toolchain), OB-32
build stamps, dirty split 9/9:

| menu width | `chooseEU` median | `policyPick` median | B/A |
|---|---|---|---|
| 4 (the owner's real count) | 167.84 ms | 168.31 ms | 1.003 |
| 8 | 265.14 ms | 274.02 ms | 1.034 |
| 16 | 458.88 ms | 2876.98 ms | **6.27** |
| 32 | 847.67 ms | UNREACHED (stopped at 17 min; printed, not absorbed) | — |

Population held at 960 at every width (the menu is the action space).
Dyadic mechanism probe: snapping theta to `2^-10` gives A 4.4x, B 6.6x;
B/A falls 6.27 → 4.16 and does not vanish.

## r02.3 — the width cliff diagnosed statically (`ProbeTermSize.hs`)

The r02.2 cliff is **expression duplication, not substitution**: the
`chooseKS` expansion re-embeds the winner subtree per comparison, so the
built term is ~14.5·2^w tree nodes under a tree-walking `evalx` while the
heap DAG stays ~28·w; the substituting per-comparison term is a
width-independent 22 nodes — equal to `chooseEU`'s own pick constant.
Counts at widths 4–64 in the probe's transcript
(`chooseeu-sitting/r2-f10-term-size.txt`) and reproducible by running the
probe. Consequence for readers of r02.2: the `policyPick` column measures
the expansion's artefact, not the price of substitution semantics.

## r02.4 — the folded state carries O(t) bits, and THE BAND MUST WAIT (`ProbeStateBits.hs`)

The sitting ordered this falsifier run before any acceptance band is
filled. Result: **linear, on both profiles.** P1 (dyadic): total qbits of
the meta weights 2,015 → 31,648 across t = 100 → 1600 (~19.8 bits/tick)
against an O(log t) sufficient-statistic control (19 → 31). The real
declaration (`P2realNC`): **10,142,238 bits at t=100, 20,268,405 at
t=200** — ratio 1.999, ~101k bits of representation growth per tick,
control 20 → 22. Transcript: `chooseeu-sitting/r2-f11-state-bits.txt`.

**Consequence:** this report's `alpha_3p` = 2.44 on the real declaration
measured an ARITHMETIC REPRESENTATION (denominator growth in the folded
posterior), not the decision problem — corroborated by r01's own dyadic
snap collapsing the growth coefficient 81x. **The acceptance band should
not be filled against this exponent**, and a cutover gate read against it
is read against the wrong quantity. What replaces that reading is the
owner's question. (The engineering observation — a const-family fold has
bounded sufficient statistics and need not carry O(t) bits — is banked as
measurement only; post-terminus it re-enters through the two-sided gate
with a consumer's registered demand, exactly as #24 did.)

**The dyadic lever does not touch this** (said plainly here because GD-15
is scheduled for r46, and the grid should not be expected to buy what only
the fold representation can): P1 is *already fully dyadic* and still grows
~19.8 bits/tick. Snapping a declaration to dyadic rationals shrinks the
**coefficient** — the 81x collapse above; ~101k bits/tick at the real
declaration versus ~20 on the dyadic profile — but the **linearity
survives**, because the growth lives in the exact fold's likelihood
product, not in the grid's number format. No declaration-side change
rescues the operating point; only a change in how the folded state is
represented (the bounded-sufficient-statistics observation above) changes
the class. [Added at the r3 ruling round, 2026-09-02.]

## r02.5 — status

The band stays blank (now for a measured reason, not an absent input).
The seam-swap judgement remains the owner's. The r01 STOP above stands.
