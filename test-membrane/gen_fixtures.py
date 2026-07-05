#!/usr/bin/env python3
"""Fixture generator + pre-freeze sanity simulation for the membrane
oracle (MEMBRANE_PLAN Task 1). Deterministic: every stream below is
seeded, and the oracle's Haskell literals are this script's output —
provenance for test-membrane/Membrane.hs, in the style of
audit/capture_oracle.py.

The simulation half is the ExpFam group-6 lesson applied in advance:
before the oracle freezes, every discriminating assertion is checked to
discriminate BOTH ways (the self-signature world's MAP must mention
last_action; the exogenous control's MAP must not; the dormant sentence
must ride at its prior ratio until its sensor speaks, then win). The
model math here mirrors the reference implementation: reflected-walk
latent filter (proplang.py / PropLang.Enumerate.walkKernel), Bernoulli
emissions on the theta grid, prior 2^-dl normalized, and the
namespace-relative description lengths of MEMBRANE_PLAN T1/M1:

    mention(g)      = 1 + log2 |g|
    dlConst         = 1 + mention(theta)
    dlWalk          = 1 + log2 |rho|
    dlGuard(ns, g)  = 1 + ((1 + log2 |ns|) + mention(g))
                        + mention(theta) + mention(theta)

Guard families enumerate threshold-outermost, (k1, t1) x (k2, t2) with
k1 /= k2, the built-in ("t", tau) family first, then the declared
extras in order — the frozen fragment is the |ns| = 1, no-extras
special case (identity pinned by the oracle).
"""

import math
import random

LG = lambda n: math.log2(n)

THETA = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
TAU = [5.0 * k for k in range(1, 17)]
RHO = [0.01, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5]

MENTION_THETA = 1 + LG(len(THETA))


def dl_const():
    return 1 + MENTION_THETA


def dl_walk():
    return 1 + LG(len(RHO))


def dl_guard(ns_size, grid):
    return (1 + ((1 + LG(ns_size)) + (1 + LG(len(grid))))
            + MENTION_THETA + MENTION_THETA)


def enumerate_models(ns_size, extras):
    """[(dl, kind, payload)] in the Haskell enumeration order.
    kind 'bern': payload = render-able param ('const', th) or
    ('guard', name, c, th1, th2); kind 'hmm': payload = rho."""
    ms = []
    for th in THETA:
        ms.append((dl_const(), 'bern', ('const', th)))
    for rho in RHO:
        ms.append((dl_walk(), 'hmm', rho))
    for name, grid in [('t', TAU)] + extras:
        d = dl_guard(ns_size, grid)
        for c in grid:
            for k1, t1 in enumerate(THETA):
                for k2, t2 in enumerate(THETA):
                    if k1 != k2:
                        ms.append((d, 'bern', ('guard', name, c, t1, t2)))
    return ms


def walk_step(lat, rho):
    n = len(lat)
    out = [0.0] * n
    for i, p in enumerate(lat):
        lo = i - 1 if i > 0 else i + 1
        hi = i + 1 if i < n - 1 else i - 1
        out[i] += p * (1 - rho)
        out[lo] += p * (rho / 2)
        out[hi] += p * (rho / 2)
    return out


def bern_param(payload, feats):
    if payload[0] == 'const':
        return payload[1]
    _, name, c, t1, t2 = payload
    return t1 if feats.get(name, 0.0) > c else t2


def render(payload):
    if payload[0] == 'const':
        k = THETA.index(payload[1])
        return f"('bern', ('c', 'theta', {k}))"
    _, name, c, t1, t2 = payload
    return (f"('bern', ('if', ('>', ('get', '{name}'), c={c}), "
            f"theta{THETA.index(t1)}, theta{THETA.index(t2)}))")


class Sim:
    def __init__(self, ns_size, extras):
        self.models = enumerate_models(ns_size, extras)
        z = sum(2.0 ** -dl for dl, _, _ in self.models)
        self.meta = [2.0 ** -dl / z for dl, _, _ in self.models]
        self.prior = list(self.meta)
        self.lat = [[1.0 / len(THETA)] * len(THETA)
                    if kind == 'hmm' else None
                    for _, kind, _ in self.models]

    def p1(self, feats):
        tot = 0.0
        for m, (dl, kind, pay), lat in zip(self.meta, self.models, self.lat):
            if kind == 'bern':
                tot += m * bern_param(pay, feats)
            else:
                pred = walk_step(lat, pay)
                tot += m * sum(p * th for p, th in zip(pred, THETA))
        return tot

    def observe(self, feats, y):
        liks = []
        for i, (dl, kind, pay) in enumerate(self.models):
            if kind == 'bern':
                th = bern_param(pay, feats)
                liks.append(th if y == 1 else 1 - th)
            else:
                pred = walk_step(self.lat[i], pay)
                py1 = sum(p * th for p, th in zip(pred, THETA))
                liks.append(py1 if y == 1 else 1 - py1)
                post = [p * (th if y == 1 else 1 - th)
                        for p, th in zip(pred, THETA)]
                s = sum(post)
                self.lat[i] = [p / s for p in post]
        self.meta = [m * l for m, l in zip(self.meta, liks)]
        s = sum(self.meta)
        self.meta = [m / s for m in self.meta]

    def map_ix(self):
        return max(range(len(self.meta)), key=lambda i: self.meta[i])


def hs_ints(name, xs, per=20):
    rows = [xs[i:i + per] for i in range(0, len(xs), per)]
    body = "\n  , ".join(", ".join(str(v) for v in r) for r in rows)
    return f"{name} =\n  [ {body}\n  ]"


def hs_dbls(name, xs, per=5):
    rows = [xs[i:i + per] for i in range(0, len(xs), per)]
    body = "\n  , ".join(", ".join(repr(v) for v in r) for r in rows)
    return f"{name} =\n  [ {body}\n  ]"


# --- world A: the dormant sensor (interface.md §8 A) -----------------
# T = 120; sensor s2 exists from tick K = 40. Pre-K the explained name
# is a fair coin; post-K it follows s2 (0.85 / 0.15), and s2 itself is
# a fast fair coin (too fast for any walk to track).
def world_a():
    K, T = 40, 120
    rng = random.Random(101)
    s2 = [rng.random() < 0.5 and 1 or 0 for _ in range(T)]  # used from K on
    y = []
    for t in range(T):
        if t < K:
            y.append(1 if rng.random() < 0.5 else 0)
        else:
            p = 0.85 if s2[t] == 1 else 0.15
            y.append(1 if rng.random() < p else 0)
    sim = Sim(2, [('s2', [0.5])])
    # dormancy: the s2-guard (c=0.5, t1=th_i, t2=th_j) reads 0.0 pre-K
    # -> else-branch th_j; its pre-K twin is const-bern(th_j)
    n_const = len(THETA)
    n_walk = len(RHO)
    n_tguard = len(TAU) * 72
    s2_base = n_const + n_walk + n_tguard
    pairs = []
    for k1 in range(9):
        for k2 in range(9):
            if k1 != k2:
                pairs.append((k1, k2))
    ratio_dev = 0.0
    for t in range(T):
        feats = {'t': float(t)}
        if t >= K:
            feats['s2'] = float(s2[t])
        if t < K:
            for pi, (k1, k2) in enumerate(pairs):
                g = s2_base + pi
                pr = sim.prior[g] / sim.prior[k2]
                po = sim.meta[g] / sim.meta[k2]
                ratio_dev = max(ratio_dev, abs(po - pr) / pr)
        sim.observe(feats, y[t])
    mi = sim.map_ix()
    dl, kind, pay = sim.models[mi]
    print(f"A: models={len(sim.models)} (expect 1241)")
    print(f"A: pre-K max relative ratio deviation = {ratio_dev:.3e}")
    print(f"A: end MAP = {render(pay) if kind == 'bern' else ('hmm', pay)}"
          f"  posterior={sim.meta[mi]:.6f}")
    print(f"A: MAP mentions s2: {kind == 'bern' and pay[0] == 'guard' and pay[1] == 's2'}")
    g_best = max(range(s2_base, s2_base + 72), key=lambda i: sim.meta[i])
    print(f"A: best s2-guard posterior {sim.meta[g_best]:.6f} vs its prior {sim.prior[g_best]:.6f}")
    return s2, y


# --- world C: the self-signature (interface.md §8 C) ------------------
# T = 160; z ~ U(0,1); the pilot fires affordance 2 when z > 0.5 else
# affordance 1; the echoed last_action (0 at t=0) drives the explained
# name: y ~ bern(0.9 if last_action == 2 else 0.1). Control world C0:
# identical namespace, pilot and z, but y is the frozen shifted160
# stream (a REAL changepoint at t=60) — the competitor must win there.
def world_c(shifted160):
    T = 160
    rng = random.Random(202)
    z = [rng.random() for _ in range(T)]
    la = [0.0] * T
    for t in range(1, T):
        la[t] = 2.0 if z[t - 1] > 0.5 else 1.0
    y = [1 if rng.random() < (0.9 if la[t] == 2.0 else 0.1) else 0
         for t in range(T)]
    extras = [('z', [0.25, 0.5, 0.75]), ('last_action', [0.5, 1.5])]
    for tag, ys in (('C', y), ('C0', shifted160)):
        sim = Sim(3, extras)
        for t in range(T):
            feats = {'t': float(t), 'z': z[t], 'last_action': la[t]}
            sim.observe(feats, ys[t])
        mi = sim.map_ix()
        dl, kind, pay = sim.models[mi]
        r = render(pay) if kind == 'bern' else f"('hmm', rho={pay})"
        has_la = kind == 'bern' and pay[0] == 'guard' and pay[1] == 'last_action'
        has_t = kind == 'bern' and pay[0] == 'guard' and pay[1] == 't'
        print(f"{tag}: models={len(sim.models)} (expect 1529); MAP = {r}"
              f"  posterior={sim.meta[mi]:.6f}")
        print(f"{tag}: MAP mentions last_action: {has_la}; mentions t: {has_t}")
    return z, la, y


# --- world B: the growing menu (interface.md §8 B) --------------------
# T = 20, all-ones evidence over the FROZEN fragment (namespace ["t"]:
# menu growth is NOT namespace growth — ruling M5). Affordance "move"
# (id 2, slot speed in {0.2,0.4,0.6,0.8}) appears at tick 10. Utility
# B1: hold pays 0.2, move pays speed on y=1 / -speed on y=0, think -2
# -> move(0.8) adopted at tick 10 iff p1 then exceeds 0.625. B2: hold
# pays 0.9 > max move EU -> never adopted (analytic).
def world_b():
    T, m = 20, 10
    y = [1] * T
    sim = Sim(1, [])
    print(f"B: models={len(sim.models)} (expect 1169)")
    adopt = []
    for t in range(T):
        feats = {'t': float(t)}
        p1 = sim.p1(feats)
        eu_move = 0.8 * (2 * p1 - 1)
        if t >= m:
            adopt.append((t, round(p1, 6), round(eu_move, 6),
                          eu_move > 0.2))
        sim.observe(feats, y[t])
    print("B: (t, p1, EU(move@0.8), adopted?) from tick 10:")
    for row in adopt:
        print(f"   {row}")
    return y


if __name__ == '__main__':
    # shifted160 verbatim from test/Streams.hs (rng seed 11 provenance)
    shifted160 = [int(c) for c in
                  "11011111111111110011"
                  "11111111111111110011"
                  "11111111011101011111"
                  "10000001000000000000"
                  "00000000000000011000"
                  "00000000000000000000"
                  "10000000001000000010"
                  "01000000000001100010"]
    print("=" * 70)
    s2, ya = world_a()
    print("=" * 70)
    z, la, yc = world_c(shifted160)
    print("=" * 70)
    yb = world_b()
    print("=" * 70)
    print("--- Haskell literals ---")
    print(hs_ints("s2A", s2))
    print(hs_ints("yA", ya))
    print(hs_dbls("zC", z))
    print(hs_ints("yC", yc))
