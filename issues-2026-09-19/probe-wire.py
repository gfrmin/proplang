#!/usr/bin/env python3
"""#26 witness, wire leg: life-agent's world, a CONSTRUCTED count-exact stream, held-out p1
per cell -- on a named host binary.

Every wire line is built by the CONSUMER'S OWN functions (the one-generator law): the
handshake by `lattice_replay.handshake_for`, each evidence tick by
`lattice_replay.evidence_tick_for` (which binds `session.evidence_tick_body`), each decide
tick by `lattice_replay.features_for` with `"menu": ["act"]` -- exactly the shape
`p3_gate.probe_heldout` sends.  The theta codebook comes from `world.theta_grid(U_BAR)`; the
run ASSERTS it equals r49's rung list, so the Ū below cannot silently be the wrong one.

No owner data: the stream is constructed (the author's ruling of 2026-09-19).  Its cell
counts are r49 S4's published (n, realised) table; the p-none assignment is the
construction (R-RED: the window between the p-none cut's gain and the ge90 cut's gain is
measured below, and the construction sits inside it).

Usage: probe-wire.py [--dump DIR] <proplang-host binary> [legs...]
       legs: A B Bp D Dp (default all).  --dump writes DIR/leg-<X>.world: the leg's declared
       world, every evidence tick and every probe WITH the wire's p1 -- the ONE stream
       probe-mass.hs reads (it re-declares nothing and asserts its p1 equals the wire's).
"""
import hashlib, math, pathlib, sys

LIFE_AGENT = pathlib.Path.home() / "git" / "life-agent"
sys.path[:0] = [str(LIFE_AGENT / "src"), str(LIFE_AGENT / "archive" / "scripts")]
from life_agent.membrane import world as W                 # noqa: E402
from life_agent.membrane.client import MembraneClient      # noqa: E402
import membrane.lattice_replay as LR                       # noqa: E402

# r49's boot Ū (r49-s18-bars.md S8: u_wrong, u_abstain, u_correct) plus the gather split
# r48-reearn-measurement.md quotes from the same declaration (kappa_att).  Asserted below
# against r49's published rung list and clock price.
U_BAR = {"u_wrong": -5.130990272278651, "u_abstain": 0.0, "u_correct": 1.0,
         "kappa_att": 0.048057099794822}
R49_RUNGS = [0.04805755615234375, 0.05000019073486328, 0.18000030517578125,
             0.33899974822998047, 0.8570003509521484, 0.8640003204345703,
             0.9499998092651367, 0.9906339645385742]
assert W.theta_grid(U_BAR) == R49_RUNGS, W.theta_grid(U_BAR)
assert abs(W.clock_price(U_BAR) - 7.130990272278651) < 1e-12
# r49's deployed commit bar, as r49-s18-bars.md defines it: p* = (u_abstain - u_wrong) /
# (u_correct - u_wrong) = 0.836894 at this Ū (respond vs abstain).  Asserted to r49's digits.
BAR = (U_BAR["u_abstain"] - U_BAR["u_wrong"]) / (U_BAR["u_correct"] - U_BAR["u_wrong"])
assert abs(BAR - 0.8368942119315517) < 1e-15

# One representative raw value per bucket, bucketed by world.py's own rules and asserted.
LC = {"lt50": 0.40, "50to70": 0.60, "70to80": 0.75, "80to90": 0.85, "ge90": 0.95}
PN = {"lt20": 0.10, "ge50": 0.60}
for b, v in LC.items(): assert W._credence_bucket(v) == b
for b, v in PN.items(): assert W._p_none_bucket(v) == b

# The constructed stream: (leader bucket, p-none bucket, n, correct).  Leader marginals are
# r49 S4's (n, realised): lt50 46/32, 50to70 68/44, 70to80 15/12, 80to90 40/32, ge90 69/69.
# The p-none=ge50 cell (20 ticks / 4 correct) sits inside the two low-credence cells.
CELLS = [("lt50", "ge50", 12, 2), ("lt50", "lt20", 34, 30),
         ("50to70", "ge50", 8, 2), ("50to70", "lt20", 60, 42),
         ("70to80", "lt20", 15, 12), ("80to90", "lt20", 40, 32),
         ("ge90", "lt20", 69, 69)]
R49_S4 = {"lt50": (46, 32), "50to70": (68, 44), "70to80": (15, 12),
          "80to90": (40, 32), "ge90": (69, 69)}
for lc, (n, k) in R49_S4.items():
    assert (sum(c[2] for c in CELLS if c[0] == lc), sum(c[3] for c in CELLS if c[0] == lc)) == (n, k)


def summary(lc, pn):
    return W.DecideSummary(n_candidates=3, leader_credence=LC[lc], p_none=PN[pn], n_obs=5,
                           era_split=False, owner_scoped=False, grow_pass=False)


def stream():
    """Round-robin over the cells, each cell's outcomes correct-first-then-wrong spread
    evenly.  Every model in this world is exchangeable (no rho codebook, so no walks), so
    order does not move the posterior; a fixed order keeps the transcript reproducible."""
    queues = []
    for lc, pn, n, k in CELLS:
        ys = [1 if (i * k) // n != ((i + 1) * k) // n else 0 for i in range(n)]
        assert sum(ys) == k
        queues.append([(summary(lc, pn), y) for y in ys])
    out = []
    while any(queues):
        for q in queues:
            if q:
                out.append(q.pop(0))
    return out


LEGS = {
    "A":  (["leader-credence"], None),
    "B":  (["leader-credence", "p-none"], None),
    "Bp": (list(LR.ALL_FAMILIES), None),
    "D":  (["leader-credence"], "complement"),
    "Dp": (list(LR.ALL_FAMILIES), "complement"),
}


def complement_rate():
    n = sum(c[2] for c in CELLS if c[0] != "ge90")
    k = sum(c[3] for c in CELLS if c[0] != "ge90")
    return k / n


def handshake(fams, extra):
    hs = LR.handshake_for(U_BAR, fams)
    if extra == "complement":
        # Leg D's declared knob: ONE added rung at the ge90-complement's realised rate,
        # snapped to the consumer's own lattice (world._snap_to_lattice).
        th = hs["world"]["codebooks"]["theta"]
        hs["world"]["codebooks"]["theta"] = W._snap_to_lattice(sorted(th + [complement_rate()]))
    return hs


def dump(path, hs, fams, rows):
    w = hs["world"]
    act0 = w["menu"][0]["grid"][0]
    def fl(fs): return " ".join(f"{k}={float(v)!r}" for k, v in fs.items())
    with open(path, "w") as f:
        f.write("ns " + " ".join(w["namespace"]) + "\n")
        for g in w["guards"]:
            f.write(f"guard {g['name']} " + " ".join(repr(float(x)) for x in g["grid"]) + "\n")
        f.write("theta " + " ".join(repr(float(x)) for x in w["codebooks"]["theta"]) + "\n")
        f.write(f"act {W.ACT_NAME} {float(act0)!r}\n")
        t = 0
        for s, y in stream():
            f.write(f"ev {y} " + fl(LR.features_for(s, float(t), fams)) + "\n")
            t += 1
        for lc, pn, n, k, p1 in rows:
            f.write(f"probe {lc} {pn} {n} {k} {p1!r} "
                    + fl(LR.features_for(summary(lc, pn), float(t), fams)) + "\n")


def run_leg(engine, leg):
    fams, extra = LEGS[leg]
    c = MembraneClient.spawn([engine], log=lambda _m: None, read_timeout_s=300.0)
    try:
        hs = handshake(fams, extra)
        ok = c.request(hs)
        assert ok.get("ok"), ok
        t = 0
        for s, y in stream():
            r = c.request(LR.evidence_tick_for(s, float(t), fams, y))
            assert r.get("observed") == y, r
            t += 1
        rows = []
        for lc, pn, n, k in CELLS:
            dec = c.request({"tick": {"features": LR.features_for(summary(lc, pn), float(t), fams),
                                      "menu": [W.ACT_NAME]}})
            rows.append((lc, pn, n, k, LR._p1(dec)))
        return hs, ok, rows
    finally:
        c.shutdown()


def arm_bits(n, k, rungs):
    """max over declared rungs of the cell's log-likelihood, in bits, and the argmax rung."""
    def ll(th): return k * math.log2(th) + (n - k) * math.log2(1 - th)
    return max((ll(th), th) for th in rungs)


def window():
    """The construction's window (R-RED): each single cut's best-arm likelihood gain over the
    best constant, in bits, at r49's rungs.  The guard family's prior deficit per model is
    log2(64*|ns|*|tg|*|theta|^2 / (4*|theta|)) -- read off the wire's own reply below as the
    ratio it implies, not re-declared here."""
    N = sum(c[2] for c in CELLS); K = sum(c[3] for c in CELLS)
    base, th0 = arm_bits(N, K, R49_RUNGS)
    print(f"  best constant: rung {th0:.4f} on {K}/{N} ({K/N:.4f})")
    cuts = {"leader-credence=ge90": lambda c: c[0] == "ge90",
            "p-none=ge50": lambda c: c[1] == "ge50",
            "leader-credence=lt50": lambda c: c[0] == "lt50",
            "leader-credence=50to70": lambda c: c[0] == "50to70"}
    for name, on in cuts.items():
        n1 = sum(c[2] for c in CELLS if on(c)); k1 = sum(c[3] for c in CELLS if on(c))
        a, ta = arm_bits(n1, k1, R49_RUNGS)
        b, tb = arm_bits(N - n1, K - k1, R49_RUNGS)
        print(f"  cut {name:24s} on {k1:3d}/{n1:3d} -> {ta:.4f}   off {K-k1:3d}/{N-n1:3d} -> {tb:.4f}"
              f"   gain {a + b - base:6.2f} bits")


def main():
    args = sys.argv[1:]
    out = None
    if args[:1] == ["--dump"]:
        out, args = pathlib.Path(args[1]), args[2:]
    engine = args[0]
    legs = args[1:] or list(LEGS)
    h = hashlib.sha256(pathlib.Path(engine).read_bytes()).hexdigest()
    print(f"engine {engine}\nengine sha256 {h}")
    print(f"life-agent world @ Ū {U_BAR}\ntheta {R49_RUNGS} (asserted == r49)")
    print(f"stream: {len(stream())} evidence ticks; cells (leader, p-none, n, correct): {CELLS}")
    print("window (declared-rung arithmetic, best arm per side):")
    window()
    for leg in legs:
        hs, ok, rows = run_leg(engine, leg)
        if out:
            dump(out / f"leg-{leg}.world", hs, LEGS[leg][0], rows)
        w = hs["world"]
        print(f"\n--- leg {leg}: families {LEGS[leg][0]}  |ns|={len(w['namespace'])}"
              f"  |guards|={len(w['guards'])}  |theta|={len(w['codebooks']['theta'])}"
              f"  hello -> {ok}")
        if LEGS[leg][1]:
            print(f"    theta {w['codebooks']['theta']}")
        print(f"    {'leader':8s} {'p-none':6s} {'n':>3s} {'real':>6s} {'held-out p1':>12s}  p1 > bar {BAR:.6f}")
        for lc, pn, n, k, p1 in rows:
            print(f"    {lc:8s} {pn:6s} {n:3d} {k/n:6.3f} {p1:12.8f}  {p1 > BAR}")


if __name__ == "__main__":
    main()
