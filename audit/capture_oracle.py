#!/usr/bin/env python3
"""capture_oracle.py — port the STREAM, not the RNG (CLAUDE.md Phase 1).

Re-runs the Python reference oracle (proplang.py / tests_acceptance.py at
the repo root) and regenerates, deterministically and idempotently:

    test/Streams.hs   the four observation streams, bit-for-bit
    test/Anchors.hs   every measured anchor at full (repr) precision

Every emitted constant carries a provenance comment naming the Python
code that produced it. Floats are emitted with Python's repr (shortest
round-trip), so the embedded Haskell Double is the identical IEEE-754
value. Run from the repo root:

    PYTHONDONTWRITEBYTECODE=1 python3 audit/capture_oracle.py

This file is part of the frozen audit surface (MANIFEST.sha256).
"""

import math
import os
import random
import sys

sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

import proplang as al                                    # noqa: E402
from proplang import Agent, enumerate_models            # noqa: E402
import tests_acceptance as ta                           # noqa: E402

LOG2 = math.log(2.0)
THETA_GRID = list(al.THETA_SPACE.points)


# ---------------------------------------------------------------------------
# The four streams (generators copied VERBATIM from tests_acceptance.py;
# the streams, not the RNG, are what the Haskell tests embed)
# ---------------------------------------------------------------------------

def stream_shifted160():
    """tests_acceptance.test_changing_world: rng = random.Random(11);
    y = 1 if rng.random() < (0.9 if t < 60 else 0.1) else 0, t in 0..159.
    Identical call pattern in _shifted_world_logloss (same seed, one
    rng.random() per tick), so tests 1 and 4 share this stream."""
    rng = random.Random(11)
    return [1 if rng.random() < (0.9 if t < 60 else 0.1) else 0
            for t in range(160)]


def stream_buffer36():
    """tests_acceptance.test_lazy_genius: rng = random.Random(14);
    buffer = [1 if rng.random() < 0.52 else 0 for _ in range(36)]."""
    rng = random.Random(14)
    return [1 if rng.random() < 0.52 else 0 for _ in range(36)]


def streams_seed5():
    """tests_acceptance.test_forgetting_trap: rng = random.Random(5);
    400 drifting-world draws (y-draw, drift-check draw, conditional
    rng.choice), THEN 400 stationary draws from the SAME rng.
    _drift_world_logloss re-seeds Random(5) with the identical call
    pattern for 250 ticks, so test 4's drift stream is drift400[:250]
    (asserted below)."""
    rng = random.Random(5)
    i, ys_drift = 6, []
    for _ in range(400):
        ys_drift.append(1 if rng.random() < THETA_GRID[i] else 0)
        if rng.random() < 0.2:
            i = max(0, min(len(THETA_GRID) - 1, i + rng.choice((-1, 1))))
    ys_flat = [1 if rng.random() < 0.7 else 0 for _ in range(400)]
    return ys_drift, ys_flat


def stream_drift250():
    rng = random.Random(5)
    i, ys = 6, []
    for _ in range(250):
        ys.append(1 if rng.random() < THETA_GRID[i] else 0)
        if rng.random() < 0.2:
            i = max(0, min(len(THETA_GRID) - 1, i + rng.choice((-1, 1))))
    return ys


# ---------------------------------------------------------------------------
# Anchors
# ---------------------------------------------------------------------------

def capture_test1(shifted):
    """Instrumented replica of test_changing_world's timeline loop
    (identical arithmetic; world draws replaced by the captured stream)."""
    def util(a, y):
        if a == "consult":
            return 0.35
        return 1.0 if (a == "predict1") == (y == 1) else -1.0

    agent = Agent(enumerate_models())
    timeline = []
    for t, y in enumerate(shifted):
        pred = agent.predictive()
        p1 = pred.prob(al.Event(al.OBS, lambda y_: y_ == 1))
        act = ta.evalx(ta.POLICY_ACT,
                       {"ACTS": ["predict1", "predict0", "consult"],
                        "stdlib": {"EU": ta.make_eu(pred, util)}})
        H = agent.meta.entropy_bits()
        timeline.append((t, p1, act, H))
        agent.observe(y)

    probe_ticks = [t for t in range(160)
                   if t % 20 == 0 or (58 <= t <= 76 and t % 2 == 0)]
    probe = [(t, timeline[t][1], timeline[t][2], timeline[t][3])
             for t in probe_ticks]
    consult_ticks = [t for t, _, a, _ in timeline if a == "consult"]
    h_pre = timeline[59][3]
    h_post_max = max(h for t, _, _, h in timeline if 60 <= t < 90)
    idx, top_p = agent.meta.top(1)[0]
    map_prog = repr(agent.hyps[idx].expr)
    return dict(probe=probe, consult_ticks=consult_ticks, h_pre=h_pre,
                h_post_max=h_post_max, map_prog=map_prog, map_p=top_p)


def capture_test2(buffer):
    prices = [0.3, 0.05, 0.005, 0.0]
    ticks, finals = [], []
    for p in prices:
        tk, act = ta.run_deliberation(price=p, buffer=buffer)
        ticks.append(tk)
        finals.append(act)
    return dict(prices=prices, ticks=ticks, finals=finals)


def capture_test3(ys_drift, ys_flat):
    gammas = [0.8, 0.9, 0.95, 0.98, 1.0]
    f_drift = [ta.forgetter_logloss(ys_drift, g) for g in gammas]
    f_flat = [ta.forgetter_logloss(ys_flat, g) for g in gammas]
    la_d, agent_d = ta.agent_logloss(ys_drift)
    la_f, _ = ta.agent_logloss(ys_flat)
    map_prog = repr(agent_d.hyps[agent_d.meta.top(1)[0][0]].expr)
    return dict(gammas=gammas, f_drift=f_drift, f_flat=f_flat,
                agent_drift=la_d, agent_flat=la_f, map_prog=map_prog)


def capture_test4(shifted, drift250):
    def run(models, ys, disabled=()):
        agent, ll = Agent(models, disabled=disabled), 0.0
        for y in ys:
            ll += -agent.observe(y) / LOG2
        return ll

    full = enumerate_models()
    return dict(
        ll_frozen=run(full, shifted, disabled=("cond",)),
        ll_full=run(full, shifted),
        ll_noif=run(enumerate_models(
            allowed=("bern", "hmm", "c", "get", ">")), shifted),
        ll_noget=run(enumerate_models(
            allowed=("bern", "hmm", "c", "if", ">")), shifted),
        ll_full_d=run(full, drift250),
        ll_nohmm=run(enumerate_models(
            allowed=("bern", "if", "c", "get", ">")), drift250),
        n_full=len(full),
        n_noc=len(enumerate_models(allowed=("bern", "hmm", "if", "get", ">"))),
        n_nobern=len(enumerate_models(allowed=("if", "c", "get", ">"))),
    )


# ---------------------------------------------------------------------------
# Haskell emission
# ---------------------------------------------------------------------------

def hs_double(x):
    r = repr(float(x))
    return r if ("." in r or "e" in r or "inf" in r or "nan" in r) else r + ".0"


def hs_int_list(xs):
    return "[" + ",".join(str(x) for x in xs) + "]"


def hs_double_list(xs):
    return "[" + ", ".join(hs_double(x) for x in xs) + "]"


def hs_string_list(xs):
    return "[" + ", ".join('"%s"' % x for x in xs) + "]"


def hs_int_list_block(xs, per_line=20):
    """A [Int] literal wrapped at per_line elements, leading-comma style."""
    chunks = [xs[i:i + per_line] for i in range(0, len(xs), per_line)]
    lines = []
    for i, ch in enumerate(chunks):
        prefix = "  [ " if i == 0 else "  , "
        lines.append(prefix + ",".join(str(x) for x in ch))
    lines.append("  ]")
    return lines


def emit_streams(shifted, buffer, drift, flat, path):
    lines = []
    w = lines.append
    w("-- GENERATED by audit/capture_oracle.py — DO NOT EDIT.")
    w("-- Frozen under MANIFEST.sha256. The streams are ported bit-for-bit")
    w("-- from the Python oracle (port the stream, not the RNG); provenance")
    w("-- for each stream is on its definition.")
    w("module Streams")
    w("  ( shifted160")
    w("  , buffer36")
    w("  , drift400")
    w("  , flat400")
    w("  ) where")
    w("")
    w("-- tests_acceptance.test_changing_world / _shifted_world_logloss:")
    w("-- rng = random.Random(11); y_t = [rng.random() < (0.9 if t<60 else 0.1)],")
    w("-- t = 0..159. Shared verbatim by tests 1 and 4 (same seed, same")
    w("-- one-draw-per-tick call pattern).")
    w("shifted160 :: [Int]")
    w("shifted160 =")
    lines.extend(hs_int_list_block(shifted))
    w("")
    w("-- tests_acceptance.test_lazy_genius: rng = random.Random(14);")
    w("-- 36 draws of [rng.random() < 0.52].")
    w("buffer36 :: [Int]")
    w("buffer36 =")
    lines.extend(hs_int_list_block(buffer))
    w("")
    w("-- tests_acceptance.test_forgetting_trap: rng = random.Random(5);")
    w("-- 400 drifting-world draws (theta random-walks on the 9-point grid,")
    w("-- start index 6; per tick: y-draw, drift-check draw, conditional")
    w("-- rng.choice(-1,1)). Test 4's 250-tick drift world is drift400's")
    w("-- prefix (verified at capture time).")
    w("drift400 :: [Int]")
    w("drift400 =")
    lines.extend(hs_int_list_block(drift))
    w("")
    w("-- tests_acceptance.test_forgetting_trap: 400 draws of")
    w("-- [rng.random() < 0.7] CONTINUING the same seed-5 RNG after the")
    w("-- drift generation (stream order is load-bearing).")
    w("flat400 :: [Int]")
    w("flat400 =")
    lines.extend(hs_int_list_block(flat))
    w("")
    with open(path, "w") as fh:
        fh.write("\n".join(lines))


def emit_anchors(t1, t2, t3, t4, path):
    L = []
    w = L.append
    w("-- GENERATED by audit/capture_oracle.py — DO NOT EDIT.")
    w("-- Frozen under MANIFEST.sha256. Every constant below is a measured")
    w("-- anchor from the Python oracle (proplang.py / tests_acceptance.py),")
    w("-- captured at full repr precision; provenance on each definition.")
    w("--")
    w("-- TOLERANCE PROTOCOL (frozen): counts, actions, tick counts and")
    w("-- rendered programs are asserted EXACTLY; probabilities and")
    w("-- entropies within tolProb; cumulative log-losses within tolBits.")
    w("-- A Phase-2 failure of any pinned anchor is stop-and-report and a")
    w("-- human-signed Phase-1 re-open; tolerances are part of the oracle")
    w("-- and are never widened in place.")
    w("module Anchors where")
    w("")
    w("-- absolute tolerance for probabilities and entropies (bits)")
    w("tolProb :: Double")
    w("tolProb = 1e-6")
    w("")
    w("-- absolute tolerance for cumulative log-losses (bits)")
    w("tolBits :: Double")
    w("tolBits = 1e-4")
    w("")
    w("-- TEST 1 — the changing-world test ----------------------------------")
    w("")
    w("-- (t, P(y=1), action, meta-entropy bits) at the printed probe ticks")
    w("-- (t mod 20 == 0 or even t in [58,76]); from the timeline loop of")
    w("-- tests_acceptance.test_changing_world.")
    w("t1ProbeRows :: [(Int, Double, String, Double)]")
    w("t1ProbeRows =")
    rows = ["  ( (%d, %s, \"%s\", %s)" % (t, hs_double(p), a, hs_double(h))
            if i == 0 else
            "  , (%d, %s, \"%s\", %s)" % (t, hs_double(p), a, hs_double(h))
            for i, (t, p, a, h) in enumerate(t1["probe"])]
    rows[0] = rows[0].replace("( (", "[ (", 1)
    L.extend(rows)
    w("  ]")
    w("")
    w("-- every tick whose chosen action is consult (exact; min argmax")
    w("-- margin over the whole run is ~1.2e-2, far above float noise)")
    w("t1ConsultTicks :: [Int]")
    w("t1ConsultTicks = " + hs_int_list(t1["consult_ticks"]))
    w("")
    w("-- meta-entropy at t=59 (timeline[59]) and max over t in [60,90)")
    w("t1HPre, t1HPostMax :: Double")
    w("t1HPre = " + hs_double(t1["h_pre"]))
    w("t1HPostMax = " + hs_double(t1["h_post_max"]))
    w("")
    w("-- agent.meta.top(1) after 160 ticks: the exact change-point sentence")
    w("-- (tau grid index 11 = 60) and its posterior")
    w("t1MapProgram :: String")
    w('t1MapProgram = "%s"' % t1["map_prog"].replace('"', '\\"'))
    w("")
    w("t1MapPosterior :: Double")
    w("t1MapPosterior = " + hs_double(t1["map_p"]))
    w("")
    w("-- TEST 2 — the lazy-genius test -------------------------------------")
    w("")
    w("-- (world price of a tick, thinking ticks, final act), from")
    w("-- tests_acceptance.run_deliberation on the seed-14 buffer; ticks and")
    w("-- final act asserted EXACTLY (min |v_act - v_think| margin 1.5e-3)")
    w("t2Rows :: [(Double, Int, String)]")
    w("t2Rows =")
    prow = ["  %s (%s, %d, \"%s\")" % ("[" if i == 0 else ",",
                                       hs_double(p), tk, f)
            for i, (p, tk, f) in enumerate(zip(t2["prices"], t2["ticks"],
                                               t2["finals"]))]
    L.extend(prow)
    w("  ]")
    w("")
    w("-- TEST 3 — the forgetting-factor trap -------------------------------")
    w("")
    w("-- (gamma, drift-world log-loss, stationary log-loss) for the")
    w("-- quarantined Beta tracker, tests_acceptance.forgetter_logloss")
    w("t3ForgetterRows :: [(Double, Double, Double)]")
    w("t3ForgetterRows =")
    frow = ["  %s (%s, %s, %s)" % ("[" if i == 0 else ",", hs_double(g),
                                   hs_double(d), hs_double(f))
            for i, (g, d, f) in enumerate(zip(t3["gammas"], t3["f_drift"],
                                              t3["f_flat"]))]
    L.extend(frow)
    w("  ]")
    w("")
    w("-- tests_acceptance.agent_logloss over drift400 / flat400")
    w("t3AgentDrift, t3AgentFlat :: Double")
    w("t3AgentDrift = " + hs_double(t3["agent_drift"]))
    w("t3AgentFlat = " + hs_double(t3["agent_flat"]))
    w("")
    w("-- the agent's MAP program on the drifting world: drift rate 0.1")
    w("-- inferred as CONTENT (rho grid index 3)")
    w("t3MapProgram :: String")
    w('t3MapProgram = "%s"' % t3["map_prog"].replace('"', '\\"'))
    w("")
    w("-- TEST 4 — the deletion audit ---------------------------------------")
    w("")
    w("-- cumulative predictive log-loss (bits) on the shifted world:")
    w("-- frozen agent (cond deleted; exactly 160.0 — the enumeration is")
    w("-- symmetric under theta <-> 1-theta so the prior predictive is")
    w("-- exactly 1/2 every tick), full grammar, no-if, no-get")
    w("t4LlFrozen, t4LlFull, t4LlNoif, t4LlNoget :: Double")
    w("t4LlFrozen = " + hs_double(t4["ll_frozen"]))
    w("t4LlFull = " + hs_double(t4["ll_full"]))
    w("t4LlNoif = " + hs_double(t4["ll_noif"]))
    w("t4LlNoget = " + hs_double(t4["ll_noget"]))
    w("")
    w("-- drifting world (250 ticks = drift400 prefix): full grammar vs")
    w("-- hmm/rw deleted")
    w("t4LlFullD, t4LlNohmm :: Double")
    w("t4LlFullD = " + hs_double(t4["ll_full_d"]))
    w("t4LlNohmm = " + hs_double(t4["ll_nohmm"]))
    w("")
    w("-- enumeration counts: full grammar; c (grids) deleted; bern deleted")
    w("t4NFull, t4NNoc, t4NNobern :: Int")
    w("t4NFull = %d" % t4["n_full"])
    w("t4NNoc = %d" % t4["n_noc"])
    w("t4NNobern = %d" % t4["n_nobern"])
    w("")
    with open(path, "w") as fh:
        fh.write("\n".join(L))


def main():
    root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    os.chdir(root)
    os.makedirs("test", exist_ok=True)

    shifted = stream_shifted160()
    buffer = stream_buffer36()
    drift400, flat400 = streams_seed5()
    drift250 = stream_drift250()

    assert drift250 == drift400[:250], \
        "drift250 is not a prefix of drift400 — stream invariant broken"
    assert len(shifted) == 160 and len(buffer) == 36
    assert len(drift400) == 400 and len(flat400) == 400

    t1 = capture_test1(shifted)
    t2 = capture_test2(buffer)
    t3 = capture_test3(drift400, flat400)
    t4 = capture_test4(shifted, drift250)

    # sanity against the shipped printed output
    assert t2["ticks"] == [1, 3, 12, 12], t2["ticks"]
    assert t2["finals"] == ["L", "L", "L", "L"], t2["finals"]
    assert t1["map_prog"] == ("('bern', ('if', ('>', ('get', 't'), "
                              "('c', 'tau', 11)), ('c', 'theta', 0), "
                              "('c', 'theta', 8)))"), t1["map_prog"]
    assert t3["map_prog"] == "('hmm', ('c', 'rho', 3))", t3["map_prog"]
    assert round(t4["ll_frozen"]) == 160 and round(t4["ll_full"]) == 97
    assert t4["n_full"] == 1169 and t4["n_noc"] == 0 and t4["n_nobern"] == 0

    emit_streams(shifted, buffer, drift400, flat400, "test/Streams.hs")
    emit_anchors(t1, t2, t3, t4, "test/Anchors.hs")
    print("wrote test/Streams.hs and test/Anchors.hs")
    print("consult ticks:", t1["consult_ticks"])
    print("MAP posterior:", repr(t1["map_p"]))


if __name__ == "__main__":
    main()
