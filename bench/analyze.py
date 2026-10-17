#!/usr/bin/env python3
"""bench/analyze.py — the pre-stated analysis over bench/results/*.csv.

Reads every route-1 and route-2 cell CSV written by bench-fold-depth and
prints, per profile:

  * the per-tick cost table (window start, median wall ns) per seed and scale;
  * the fit c(t) ~ t^alpha over the TOP TWO DECADES of the deepest cells
    (window mid-points t with t >= depth/100), per seed and pooled, with a
    bootstrap CI over seeds (resample the seeds with replacement, refit on
    the pooled points; 2000 resamples; 2.5/97.5 percentiles);
  * the same for the belief-state bit-size b(t) ~ t^beta (route 2: meta
    weight bits + walk-latent bits);
  * cost-vs-bits: c ~ b^gamma over the same windows (route 1 x route 2 joined
    on window start), the two-route reconciliation number;
  * the operating point: the measured median per-tick cost at the window
    starting at tick 10^4 (or the deepest cell's last window if shallower),
    plus the pooled fit's prediction at t = 10^4;
  * the sanity cells (S0/S1): alpha and the max/min window-median ratio,
    against the pre-stated flatness criterion |alpha| <= 0.10 and
    max/min <= 1.5.

Only the standard library is used. Deterministic: the bootstrap RNG is
seeded (12345).
"""
from __future__ import annotations

import glob
import math
import os
import random
import re
import sys
from collections import defaultdict

RESULTS = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(__file__), "results")
OP_POINT = 10_000
BOOT_N = 2000
BOOT_SEED = 12345
SANITY_ALPHA = 0.10
SANITY_RATIO = 1.5


def parse_cell(path):
    meta = {"path": path, "truncated": None}
    rows = []
    with open(path) as fh:
        for line in fh:
            line = line.rstrip("\n")
            if line.startswith("#"):
                m = re.match(r"# cell=(\S+) profile=(\S+) ticks=(\d+) seed=(\d+) route=(\d)", line)
                if m:
                    meta.update(cell=m.group(1), profile=m.group(2), ticks=int(m.group(3)),
                                seed=int(m.group(4)), route=int(m.group(5)))
                m = re.match(r"# models=(\d+)", line)
                if m:
                    meta["models"] = int(m.group(1))
                m = re.match(r"# summary (.*)", line)
                if m:
                    for kv in m.group(1).split():
                        k, v = kv.split("=")
                        meta[k] = float(v) if "." in v else int(v)
                m = re.match(r"# TRUNCATED at tick (\d+): (.*)", line)
                if m:
                    meta["truncated"] = int(m.group(1))
                    meta["truncated_why"] = m.group(2)
                if "PIN FAILED" in line:
                    meta["pin_failed"] = True
                continue
            if not line:
                continue
            rows.append([float(x) for x in line.split(",")])
    meta["rows"] = rows
    return meta


def fit_loglog(points):
    """least squares of log y on log x; returns (alpha, intercept)."""
    xs = [math.log(x) for x, y in points]
    ys = [math.log(y) for x, y in points]
    n = len(xs)
    mx, my = sum(xs) / n, sum(ys) / n
    sxx = sum((x - mx) ** 2 for x in xs)
    if sxx == 0:
        return float("nan"), float("nan")
    sxy = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    a = sxy / sxx
    return a, my - a * mx


def fit_offset_power(points, lo=0.0, hi=3.0, step=0.005):
    """c = c0 + a * x^alpha by a grid over alpha with weighted (relative)
    linear least squares for (c0, a) at each alpha; returns
    (alpha, c0, a, rel_rmse). Weights 1/c^2 so every decade counts alike."""
    best = None
    xs = [x for x, y in points]
    ys = [y for x, y in points]
    ws = [1.0 / (y * y) for y in ys]
    k = int(round((hi - lo) / step))
    for i in range(k + 1):
        al = lo + i * step
        zs = [x ** al for x in xs]
        sw = sum(ws)
        sz = sum(w * z for w, z in zip(ws, zs))
        sy = sum(w * y for w, y in zip(ws, ys))
        szz = sum(w * z * z for w, z in zip(ws, zs))
        szy = sum(w * z * y for w, z, y in zip(ws, zs, ys))
        det = sw * szz - sz * sz
        if det <= 0:
            continue
        c0 = (szz * sy - sz * szy) / det
        a = (sw * szy - sz * sy) / det
        if a < 0 or c0 < 0:
            continue
        sse = sum(w * (y - c0 - a * z) ** 2 for w, z, y in zip(ws, zs, ys))
        if best is None or sse < best[3]:
            best = (al, c0, a, sse)
    if best is None:
        return float("nan"), float("nan"), float("nan"), float("nan")
    al, c0, a, sse = best
    return al, c0, a, math.sqrt(sse / len(points))


def bootstrap_offset_power(per_seed_points, rng, nboot=200):
    seeds = sorted(per_seed_points)
    vals = []
    for _ in range(nboot):
        pick = [rng.choice(seeds) for _ in seeds]
        pts = [p for s in pick for p in per_seed_points[s]]
        al, _, _, _ = fit_offset_power(pts)
        if not math.isnan(al):
            vals.append(al)
    if not vals:
        return float("nan"), float("nan")
    vals.sort()
    return vals[int(0.025 * (len(vals) - 1))], vals[int(0.975 * (len(vals) - 1))]


def gmp_ops_slopes(path):
    """local log-log slopes of the measured per-op cost against operand bits."""
    rows = []
    try:
        with open(path) as fh:
            for line in fh:
                parts = line.split()
                if len(parts) >= 4 and parts[0].isdigit():
                    rows.append((int(parts[0]), float(parts[1]), float(parts[2]), float(parts[3])))
    except OSError:
        return []
    out = []
    for (b0, g0, m0, a0), (b1, g1, m1, a1) in zip(rows, rows[1:]):
        lb = math.log(b1 / b0)
        out.append((b0, b1, math.log(g1 / g0) / lb, math.log(m1 / m0) / lb, math.log(a1 / a0) / lb))
    return out


def bootstrap_alpha(per_seed_points, rng):
    seeds = sorted(per_seed_points)
    alphas = []
    for _ in range(BOOT_N):
        pick = [rng.choice(seeds) for _ in seeds]
        pts = [p for s in pick for p in per_seed_points[s]]
        a, _ = fit_loglog(pts)
        if not math.isnan(a):
            alphas.append(a)
    if not alphas:
        return float("nan"), float("nan")
    alphas.sort()
    lo = alphas[int(0.025 * (len(alphas) - 1))]
    hi = alphas[int(0.975 * (len(alphas) - 1))]
    return lo, hi


def top_two_decades(rows, depth, tcol=0):
    """rows with window start >= depth/100 (window mid used as t)."""
    out = []
    for r in rows:
        s = r[tcol]
        if s >= depth / 100.0:
            out.append(r)
    return out


def main():
    cells = [parse_cell(p) for p in sorted(glob.glob(os.path.join(RESULTS, "*.csv")))]
    cells = [c for c in cells if "profile" in c]
    if not cells:
        print("no cells under", RESULTS)
        return
    by_profile = defaultdict(list)
    for c in cells:
        by_profile[c["profile"]].append(c)
    rng = random.Random(BOOT_SEED)

    print("=" * 78)
    print("CELL INVENTORY")
    print("=" * 78)
    for c in cells:
        done = c.get("ticks_done", "?")
        extra = ""
        if c.get("truncated") is not None:
            extra = f"  TRUNCATED at {c['truncated']} ({c.get('truncated_why','')})"
        if c.get("pin_failed"):
            extra += "  PIN FAILED"
        wall = c.get("total_wall_s", float("nan"))
        rss = c.get("peak_rss_kb", "")
        pins = c.get("pins_checked", "")
        print(f"{c['cell']:<28} models={c.get('models','?'):<5} done={done:<7} wall_s={wall:>10.1f} "
              f"peak_rss_kb={rss} pins={pins}{extra}")

    for prof in sorted(by_profile):
        pc = by_profile[prof]
        r1 = [c for c in pc if c["route"] == 1]
        r2 = [c for c in pc if c["route"] == 2]
        print()
        print("=" * 78)
        print(f"PROFILE {prof}")
        print("=" * 78)

        # ---- route 1 tables
        for c in sorted(r1, key=lambda c: (c["ticks"], c["seed"])):
            print(f"-- {c['cell']} (models={c.get('models')}, done={c.get('ticks_done')}, "
                  f"peak_rss_kb={c.get('peak_rss_kb')})")
            print("   start      end   median_ms    mean_ms     p90_ms   median_cpu_ms  rss_kb")
            for r in c["rows"]:
                print(f"   {int(r[0]):>6} {int(r[1]):>8} {r[2]/1e6:>11.4f} {r[3]/1e6:>10.4f} "
                      f"{r[4]/1e6:>10.4f} {r[6]/1e6:>15.4f} {int(r[7]):>7}")

        # ---- alpha fits on the deepest cells (largest requested scale)
        if r1:
            max_scale = max(c["ticks"] for c in r1)
            deepest = [c for c in r1 if c["ticks"] == max_scale]
            per_seed = {}
            per_seed_excess = {}
            depth_used = {}
            for c in deepest:
                depth = c.get("ticks_done", c["ticks"])
                depth_used[c["seed"]] = depth
                pts = [(r[0] + 49.5, r[2]) for r in top_two_decades(c["rows"], depth)]
                if len(pts) >= 3:
                    per_seed[c["seed"]] = pts
                base = c["rows"][0][2] if c["rows"] else float("nan")
                ptsx = [(r[0] + 49.5, r[2] - base) for r in top_two_decades(c["rows"], depth)
                        if r[2] - base > 0]
                if len(ptsx) >= 3:
                    per_seed_excess[c["seed"]] = ptsx
            print()
            print(f"-- alpha fit (route 1): c(t) ~ t^alpha over the top two decades of the deepest cells "
                  f"(requested T={max_scale}; depth reached per seed: {depth_used})")
            if per_seed:
                for s in sorted(per_seed):
                    a, _ = fit_loglog(per_seed[s])
                    print(f"   seed {s}: alpha_raw = {a:.3f}  ({len(per_seed[s])} windows, "
                          f"t in [{per_seed[s][0][0]:.0f}, {per_seed[s][-1][0]:.0f}])")
                pooled = [p for s in per_seed for p in per_seed[s]]
                a, b = fit_loglog(pooled)
                lo, hi = bootstrap_alpha(per_seed, rng)
                print(f"   POOLED alpha_raw = {a:.3f}   bootstrap-over-seeds 95% CI [{lo:.3f}, {hi:.3f}] "
                      f"(seeds={sorted(per_seed)}, {BOOT_N} resamples)")
                pred = math.exp(b) * OP_POINT ** a
                print(f"   fit prediction at t={OP_POINT}: {pred/1e6:.3f} ms/tick")
            else:
                print("   (not enough windows in the top two decades to fit)")
            if per_seed_excess:
                for s in sorted(per_seed_excess):
                    a, _ = fit_loglog(per_seed_excess[s])
                    print(f"   seed {s}: alpha_excess (first-window median subtracted) = {a:.3f}")
                pooled = [p for s in per_seed_excess for p in per_seed_excess[s]]
                a, _ = fit_loglog(pooled)
                lo, hi = bootstrap_alpha(per_seed_excess, rng)
                print(f"   POOLED alpha_excess = {a:.3f}   bootstrap 95% CI [{lo:.3f}, {hi:.3f}]")
            # the three-parameter model c(t) = c0 + a t^alpha over ALL windows of the deepest cells
            per_seed_all = {}
            for c in deepest:
                pts = [(r[0] + 49.5, r[2]) for r in c["rows"]]
                if len(pts) >= 4:
                    per_seed_all[c["seed"]] = pts
            if per_seed_all:
                print(f"-- alpha_3p: c(t) = c0 + a*t^alpha over ALL windows of the deepest cells "
                      f"(relative-weighted LS; alpha on a 0.005 grid)")
                for s in sorted(per_seed_all):
                    al, c0, a, rr = fit_offset_power(per_seed_all[s])
                    print(f"   seed {s}: alpha_3p = {al:.3f}  c0 = {c0/1e6:.3f} ms  a = {a/1e6:.3e} ms  "
                          f"rel-rmse {rr:.3f}")
                pooled = [p for s in per_seed_all for p in per_seed_all[s]]
                al, c0, a, rr = fit_offset_power(pooled)
                lo, hi = bootstrap_offset_power(per_seed_all, rng)
                print(f"   POOLED alpha_3p = {al:.3f}   bootstrap 95% CI [{lo:.3f}, {hi:.3f}]   "
                      f"c0 = {c0/1e6:.3f} ms  a = {a/1e6:.3e} ms  rel-rmse {rr:.3f}")
                pred = c0 + a * OP_POINT ** al
                print(f"   3p prediction at t={OP_POINT}: {pred/1e6:.3f} ms/tick "
                      f"(fold-depth share {(pred - c0)/pred*100:.0f}%)")

            # ---- alpha per scale (pooled over seeds), the growth of the growth
            print()
            print("-- alpha_raw per scale (pooled over that scale's seeds; top two decades of each cell's depth):")
            for scale in sorted({c["ticks"] for c in r1}):
                cs = [c for c in r1 if c["ticks"] == scale]
                per = {}
                for c in cs:
                    depth = c.get("ticks_done", c["ticks"])
                    pts = [(r[0] + 49.5, r[2]) for r in top_two_decades(c["rows"], depth)]
                    if len(pts) >= 3:
                        per[c["seed"]] = pts
                if per:
                    pooled = [p for sd in per for p in per[sd]]
                    a, _ = fit_loglog(pooled)
                    lo, hi = bootstrap_alpha(per, rng)
                    depths = sorted({c.get("ticks_done", c["ticks"]) for c in cs})
                    per_all = {c["seed"]: [(r[0] + 49.5, r[2]) for r in c["rows"]] for c in cs
                               if len(c["rows"]) >= 4}
                    a3, c0, _, rr = fit_offset_power([p for sd in per_all for p in per_all[sd]]) \
                        if per_all else (float("nan"),) * 4
                    print(f"   T={scale:<7} depth reached {depths}: alpha_raw = {a:.3f}  CI [{lo:.3f}, {hi:.3f}]  "
                          f"({len(per)} seeds, {len(pooled)} points);  alpha_3p (all windows) = {a3:.3f}  "
                          f"c0 = {c0/1e6:.3f} ms  rel-rmse {rr:.3f}")
                else:
                    print(f"   T={scale:<7}: fewer than 3 windows in the top two decades (no fit)")

            # ---- operating point
            print()
            print(f"-- operating point: measured median per-tick cost at the window starting at tick {OP_POINT}")
            for c in sorted(r1, key=lambda c: (c["ticks"], c["seed"])):
                for r in c["rows"]:
                    if int(r[0]) == OP_POINT or (c["ticks"] == OP_POINT and int(r[1]) == OP_POINT):
                        print(f"   {c['cell']}: window [{int(r[0])},{int(r[1])}] median {r[2]/1e6:.3f} ms  "
                              f"mean {r[3]/1e6:.3f} ms  p90 {r[4]/1e6:.3f} ms  cpu-median {r[6]/1e6:.3f} ms")
            # ---- sanity criterion
            if prof.startswith("S"):
                for c in deepest:
                    meds = [r[2] for r in c["rows"]]
                    ratio = max(meds) / min(meds) if meds and min(meds) > 0 else float("nan")
                    pts = [(r[0] + 49.5, r[2]) for r in c["rows"]]
                    a, _ = fit_loglog(pts) if len(pts) >= 3 else (float("nan"), 0)
                    verdict = "FLAT" if abs(a) <= SANITY_ALPHA and ratio <= SANITY_RATIO else "NOT FLAT"
                    print(f"   SANITY {c['cell']}: alpha over all windows = {a:.3f}, max/min window median = "
                          f"{ratio:.3f}  -> {verdict} (criterion |alpha|<={SANITY_ALPHA}, ratio<={SANITY_RATIO})")

        # ---- route 2 tables and beta fits
        if r2:
            print()
            for c in sorted(r2, key=lambda c: (c["ticks"], c["seed"])):
                print(f"-- {c['cell']} (population={c.get('models')}, done={c.get('ticks_done')}, "
                      f"pins_checked={c.get('pins_checked')})")
                print("     tick  meta_bits_total  meta_bits_max  meta_n  latent_bits  latent_n  marginal_bits")
                for r in c["rows"]:
                    print(f"   {int(r[0]):>6} {int(r[1]):>16} {int(r[2]):>14} {int(r[3]):>7} "
                          f"{int(r[4]):>12} {int(r[5]):>9} {int(r[6]):>14}")
            max_scale2 = max(c["ticks"] for c in r2)
            deepest2 = [c for c in r2 if c["ticks"] == max_scale2]
            per_seed_b = {}
            for c in deepest2:
                depth = c.get("ticks_done", c["ticks"])
                pts = [(r[0], r[1] + r[4]) for r in top_two_decades(c["rows"], depth) if r[0] > 0]
                if len(pts) >= 3:
                    per_seed_b[c["seed"]] = pts
            print()
            print(f"-- beta fit (route 2): b(t) ~ t^beta, b = meta bits + latent bits, top two decades of T={max_scale2}")
            if per_seed_b:
                for s in sorted(per_seed_b):
                    a, _ = fit_loglog(per_seed_b[s])
                    print(f"   seed {s}: beta = {a:.3f}   b(t) at deepest sample = {per_seed_b[s][-1][1]:.0f} bits "
                          f"(t={per_seed_b[s][-1][0]:.0f})")
                pooled = [p for s in per_seed_b for p in per_seed_b[s]]
                a, b = fit_loglog(pooled)
                lo, hi = bootstrap_alpha(per_seed_b, rng)
                print(f"   POOLED beta = {a:.3f}   bootstrap-over-seeds 95% CI [{lo:.3f}, {hi:.3f}]")
                for s in sorted(per_seed_b):
                    pts = per_seed_b[s]
                    rate = (pts[-1][1] - pts[0][1]) / (pts[-1][0] - pts[0][0])
                    print(f"   seed {s}: mean growth {rate:.1f} bits/tick over the fitted range")

            # ---- reconciliation: cost vs bits, joined on window start
            if r1:
                joined = defaultdict(list)
                for c1 in r1:
                    for c2 in r2:
                        if c1["seed"] != c2["seed"] or c1["ticks"] != c2["ticks"]:
                            continue
                        depth = min(c1.get("ticks_done", c1["ticks"]), c2.get("ticks_done", c2["ticks"]))
                        b_at = {int(r[0]): r[1] + r[4] for r in c2["rows"]}
                        for r in top_two_decades(c1["rows"], depth):
                            s = int(r[0])
                            if s in b_at and b_at[s] > 0:
                                joined[c1["seed"]].append((b_at[s], r[2]))
                joined = {s: v for s, v in joined.items() if len(v) >= 3}
                if joined:
                    print()
                    print("-- reconciliation: c ~ b^gamma (per-tick cost against belief-state bits, same windows, "
                          "deepest cells)")
                    for s in sorted(joined):
                        g, _ = fit_loglog(joined[s])
                        print(f"   seed {s}: gamma = {g:.3f}")
                    pooled = [p for s in joined for p in joined[s]]
                    g, _ = fit_loglog(pooled)
                    lo, hi = bootstrap_alpha(joined, rng)
                    print(f"   POOLED gamma_raw = {g:.3f}   bootstrap 95% CI [{lo:.3f}, {hi:.3f}]  (pure power law)")
                    # the offset model in bits: c = c0 + a b^gamma over ALL joined windows
                    joined_all = defaultdict(list)
                    for c1 in r1:
                        for c2 in r2:
                            if c1["seed"] != c2["seed"] or c1["ticks"] != c2["ticks"] or c1["ticks"] != max_scale:
                                continue
                            b_at = {int(r[0]): r[1] + r[4] for r in c2["rows"]}
                            for r in c1["rows"]:
                                sidx = int(r[0])
                                if sidx in b_at and b_at[sidx] > 0:
                                    joined_all[c1["seed"]].append((b_at[sidx], r[2]))
                    joined_all = {s: v for s, v in joined_all.items() if len(v) >= 4}
                    if joined_all:
                        pooled = [p for s in joined_all for p in joined_all[s]]
                        g3, c0, a, rr = fit_offset_power(pooled)
                        lo, hi = bootstrap_offset_power(joined_all, rng)
                        print(f"   POOLED gamma_3p (c = c0 + a*b^gamma, all windows) = {g3:.3f}   "
                              f"bootstrap 95% CI [{lo:.3f}, {hi:.3f}]   c0 = {c0/1e6:.3f} ms  rel-rmse {rr:.3f}")
                    print("   reading: the fold-depth cost c - c0 ~ b^gamma; alpha_3p ~= beta * gamma_3p; "
                          "the arithmetic-cost model (bench/results/gmp-ops.txt) gives, per operand size:")
                    for b0, b1, sg, sm, sa in gmp_ops_slopes(os.path.join(RESULTS, "gmp-ops.txt")):
                        print(f"     bits {b0:>7} -> {b1:<7}: gcd slope {sg:.2f}   mulQ55 slope {sm:.2f}   addQQ slope {sa:.2f}")


if __name__ == "__main__":
    main()
