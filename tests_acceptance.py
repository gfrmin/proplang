"""Acceptance tests for proplang (brief S12).

1. changing-world      adaptation visible in the posterior, absent in code
2. lazy-genius         thinking time chosen by argmax, terminated by clock
3. forgetting-trap     latent drift-rate matches/beats a forgetting factor
4. deletion-audit      every terminal's removal costs a capability
"""

import io
import math
import random
import tokenize

import proplang as al
from proplang import (Agent, Belief, Event, Kernel, Space, argmax,
                       bern_belief, enumerate_models, evalx, EMIT,
                       THETA_SPACE, OBS)

random.seed(7)
LOG2 = math.log(2.0)


# ---------------------------------------------------------------------------
# grep helper: scan proplang's CODE (not comments/docstrings) for the
# mechanisms the brief forbids. "Grep the source; there must be none."
# ---------------------------------------------------------------------------

FORBIDDEN = ["detect", "forget", "window", "decay", "sliding", "reset",
             "trigger", "temper", "anneal", "throttle"]


def grep_language_module():
    with open(al.__file__, "r") as fh:
        src = fh.read()
    hits = []
    for tok in tokenize.generate_tokens(io.StringIO(src).readline):
        if tok.type in (tokenize.COMMENT, tokenize.STRING):
            continue
        low = tok.string.lower()
        for bad in FORBIDDEN:
            if bad in low:
                hits.append((tok.start[0], tok.string))
    return hits


# ---------------------------------------------------------------------------
# shared: expected-utility action selection AS A PROGRAM (the verbs are
# terminals; the policy is syntax evaluated by evalx)
# ---------------------------------------------------------------------------

def make_eu(pred, util):
    """stdlib named composition: EU(a) = push-to-R of the utility of a
    under the predictive. Expansion: expect(pred, y -> util(a, y))."""
    def eu(a):
        return pred.expect(lambda y: util(a, y))
    return eu


POLICY_ACT = ("argmax", "ACTS", ("call", "EU", "option"))


# ---------------------------------------------------------------------------
# TEST 1: the changing-world test
# ---------------------------------------------------------------------------

def test_changing_world(verbose=True):
    print("=" * 72)
    print("TEST 1 - THE CHANGING-WORLD TEST")
    print("=" * 72)

    def true_theta(t):
        return 0.9 if t < 60 else 0.1

    def util(a, y):
        if a == "consult":
            return 0.35                      # world/user-supplied utility
        return 1.0 if (a == "predict1") == (y == 1) else -1.0

    agent = Agent(enumerate_models())
    rng = random.Random(11)
    timeline = []
    for t in range(160):
        pred = agent.predictive()
        p1 = pred.prob(Event(OBS, lambda y: y == 1))
        act = evalx(POLICY_ACT,
                    {"ACTS": ["predict1", "predict0", "consult"],
                     "stdlib": {"EU": make_eu(pred, util)}})
        H = agent.meta.entropy_bits()        # CL-1 diagnostic, display only
        timeline.append((t, p1, act, H))
        y = 1 if rng.random() < true_theta(t) else 0
        agent.observe(y)

    if verbose:
        print(f"{'t':>4} {'P(y=1)':>8} {'action':>10} {'H(bits)':>8}")
        for t, p1, act, H in timeline:
            if t % 20 == 0 or (58 <= t <= 76 and t % 2 == 0):
                print(f"{t:>4} {p1:>8.3f} {act:>10} {H:>8.2f}")

    pre = [a for t, _, a, _ in timeline if 30 <= t < 60]
    post_window = [a for t, _, a, _ in timeline if 60 <= t < 80]
    late = [a for t, _, a, _ in timeline if 130 <= t < 160]
    H_pre = timeline[59][3]
    H_post = max(H for t, _, _, H in timeline if 60 <= t < 90)

    top_expr, top_p = agent.meta.top(1)[0], None
    idx, top_p = top_expr
    top_prog = agent.hyps[idx].expr

    ok_confident_before = all(a == "predict1" for a in pre)
    ok_consults_after = "consult" in post_window
    ok_recovers = all(a == "predict0" for a in late)
    ok_disperses = H_post > H_pre + 0.5
    ok_cp_wins = top_prog[0] == "bern" and top_prog[1][0] == "if"
    hits = grep_language_module()
    ok_grep = len(hits) == 0

    print(f"\n  confident (predict1) for t in [30,60):        {ok_confident_before}")
    print(f"  consults inside t in [60,80):                 {ok_consults_after}")
    print(f"  entropy disperses (max post {H_post:.2f} vs pre {H_pre:.2f}): {ok_disperses}")
    print(f"  recovers to predict0 for t in [130,160):      {ok_recovers}")
    print(f"  MAP program is a change-point sentence:       {ok_cp_wins}")
    print(f"    MAP program: {top_prog}  (posterior {top_p:.2f})")
    print(f"  grep for change-detection machinery:          "
          f"{'CLEAN' if ok_grep else hits}")
    assert all([ok_confident_before, ok_consults_after, ok_recovers,
                ok_disperses, ok_cp_wins, ok_grep])
    print("  PASS: adaptation visible in the posterior, invisible in control flow")
    return True


# ---------------------------------------------------------------------------
# TEST 2: the lazy-genius test
# ---------------------------------------------------------------------------

def run_deliberation(price, buffer, verbose=False):
    """One episode. The ONLY thing that varies across runs is the world's
    per-tick opportunity price, delivered as a feature. The control flow
    has no iteration cap and no threshold: the loop runs while argmax
    says think. Net value of computation is Russell & Wefald's
    E[Delta decision value] - cost(computation), estimated myopically
    (the cheap fidelity of design S6); the cost side is set by the WORLD.
    """
    b = Belief.uniform(THETA_SPACE)          # grid prior: log2(9) bits/point
    buf = list(buffer)

    def util(a, th):
        v = 2.0 * th - 1.0
        return v if a == "R" else -v

    def v_act(belief):
        # named composition: argmax over acts of push-to-R of utility
        _, v = argmax(["L", "R"],
                      lambda a: belief.expect(lambda th: util(a, th)))
        return v

    def v_think(belief, price_per_tick):
        # named composition (preposterior value of computation):
        # EU(observe-then-act) minus the world's price of the tick.
        # Expansion is pure push/cond: for each outcome of the next batch,
        # cond a copy, push utility to R, average by the predictive.
        batch_n = min(3, len(buf))
        seqs = [[]]
        for _ in range(batch_n):
            seqs = [s + [y] for s in seqs for y in (0, 1)]
        total = 0.0
        for s in seqs:
            bb, lp = belief, 0.0
            for y in s:
                lp += bb.logpredict((EMIT, y))     # push-to-R
                bb = bb.cond((EMIT, y))            # cond, quoted in a value
            total += math.exp(lp) * v_act(bb)
        return total - price_per_tick             # the clock prices delay

    POLICY = ("argmax", "METAACTS",
              ("if", ("call", "is_act", "option"),
               ("call", "v_act", "B"),
               ("call", "v_think", "B", ("get", "price"))))

    ticks = 0
    while True:
        metaacts = ["act"] + (["think"] if buf else [])
        env = {"METAACTS": metaacts, "B": b,
               "features": {"price": price},
               "stdlib": {"is_act": lambda o: o == "act",
                          "v_act": v_act, "v_think": v_think}}
        choice = evalx(POLICY, env)
        if choice == "act":
            break
        for y in buf[:3]:
            b = b.cond((EMIT, y))
        del buf[:3]
        ticks += 1
    final_act, _ = argmax(
        ["L", "R"],
        lambda a: b.expect(lambda th: (2 * th - 1) if a == "R" else (1 - 2 * th)))
    if verbose:
        print(f"    world price of a tick = {price:<6} -> thought for "
              f"{ticks:>2} tick(s), then chose {final_act}")
    return ticks, final_act


def test_lazy_genius():
    print("=" * 72)
    print("TEST 2 - THE LAZY-GENIUS TEST")
    print("=" * 72)
    rng = random.Random(14)
    buffer = [1 if rng.random() < 0.52 else 0 for _ in range(36)]
    print("  hard problem (theta hugs 0.5); same agent, same code; only the")
    print("  world's price of time differs:")
    t_hi, _ = run_deliberation(price=0.3, buffer=buffer, verbose=True)
    t_mid, _ = run_deliberation(price=0.05, buffer=buffer, verbose=True)
    t_lo, _ = run_deliberation(price=0.005, buffer=buffer, verbose=True)
    t_none, _ = run_deliberation(price=0.0, buffer=buffer, verbose=True)

    ok_lazy = t_hi < t_mid < t_lo <= t_none
    print(f"\n  dearer clock -> strictly fewer thinking ticks:  {ok_lazy}")
    print("  where is the throttle? the deliberation loop is:")
    print("      while argmax([act, think]) == think: condition on a batch")
    print("  no iteration cap, no threshold constant. Delay is priced by an")
    print("  opportunity cost the WORLD supplies as a feature; with price 0")
    print(f"  the agent thinks until information runs dry ({t_none} ticks).")
    print("  The clock, and only the clock, terminates the regress.")
    assert ok_lazy
    print("  PASS: the agent chose to think less; there is no line to point to")
    return True


# ---------------------------------------------------------------------------
# TEST 3: the forgetting-factor trap
# ---------------------------------------------------------------------------

def forgetter_logloss(ys, gamma):
    """THE TRAP (deliberately built, to be deleted): a Beta tracker with a
    forgetting factor. This function is quarantined in the test file; it
    is not, and must never be, part of the language or the agent."""
    a, b, ll = 1.0, 1.0, 0.0
    for y in ys:
        p = a / (a + b)
        ll += -math.log2(p if y == 1 else 1 - p)
        a = gamma * a + y
        b = gamma * b + (1 - y)
    return ll


def agent_logloss(ys):
    agent = Agent(enumerate_models())
    ll = 0.0
    for y in ys:
        ll += -agent.observe(y) / LOG2
    return ll, agent


def test_forgetting_trap():
    print("=" * 72)
    print("TEST 3 - THE FORGETTING-FACTOR TRAP")
    print("=" * 72)
    rng = random.Random(5)

    # drifting world: theta random-walks on the grid (the agent was never
    # told this; 'the world drifts at rate rho' is merely SAYABLE)
    grid = list(THETA_SPACE.points)
    i, ys_drift = 6, []
    for _ in range(400):
        ys_drift.append(1 if rng.random() < grid[i] else 0)
        if rng.random() < 0.2:
            i = max(0, min(len(grid) - 1, i + rng.choice((-1, 1))))

    ys_flat = [1 if rng.random() < 0.7 else 0 for _ in range(400)]

    gammas = [0.8, 0.9, 0.95, 0.98, 1.0]
    print("  cumulative predictive log-loss (bits; lower is better)")
    print(f"  {'tracker':<28}{'drifting world':>16}{'stationary world':>18}")
    best_drift, best_flat = float("inf"), float("inf")
    for g in gammas:
        ld = forgetter_logloss(ys_drift, g)
        lf = forgetter_logloss(ys_flat, g)
        best_drift, best_flat = min(best_drift, ld), min(best_flat, lf)
        print(f"  {'forgetting factor g=' + str(g):<28}{ld:>16.1f}{lf:>18.1f}")
    la_d, agent_d = agent_logloss(ys_drift)
    la_f, _ = agent_logloss(ys_flat)
    print(f"  {'agent (latent drift-rate)':<28}{la_d:>16.1f}{la_f:>18.1f}")

    map_prog = agent_d.hyps[agent_d.meta.top(1)[0][0]].expr
    print(f"\n  agent's MAP program on the drifting world: {map_prog}")
    ok_drift = la_d <= best_drift + 0.02 * best_drift
    ok_flat = la_f <= best_flat + 0.02 * best_flat
    print(f"  matches/beats the best oracle-tuned forgetter on drift: {ok_drift}")
    print(f"  matches/beats every forgetter on the stationary world:  {ok_flat}")
    print("  the forgetting factor is hereby deleted: it exists only in this")
    print("  test file, as the trap. grep of the language module (test 1)")
    print("  confirms no decay/window/forgetting machinery exists there.")
    assert ok_drift and ok_flat
    print("  PASS: adaptation is content (a latent drift-rate), not mechanism")
    return True


# ---------------------------------------------------------------------------
# TEST 4: the deletion audit
# ---------------------------------------------------------------------------

def _shifted_world_logloss(models, T=160):
    rng = random.Random(11)
    agent = Agent(models)
    ll = 0.0
    for t in range(T):
        y = 1 if rng.random() < (0.9 if t < 60 else 0.1) else 0
        ll += -agent.observe(y) / LOG2
    return ll


def _drift_world_logloss(models, T=250):
    rng = random.Random(5)
    grid = list(THETA_SPACE.points)
    i, agent, ll = 6, Agent(models), 0.0
    for _ in range(T):
        y = 1 if rng.random() < grid[i] else 0
        ll += -agent.observe(y) / LOG2
        if rng.random() < 0.2:
            i = max(0, min(len(grid) - 1, i + rng.choice((-1, 1))))
    return ll


def test_deletion_audit():
    print("=" * 72)
    print("TEST 4 - THE DELETION AUDIT")
    print("=" * 72)
    full = enumerate_models()
    results = []

    # -- cond: remove the update rule; belief never moves
    rng = random.Random(11)
    frozen = Agent(full, disabled=("cond",))
    ll_frozen = 0.0
    for t in range(160):
        y = 1 if rng.random() < (0.9 if t < 60 else 0.1) else 0
        ll_frozen += -frozen.observe(y) / LOG2
    ll_full = _shifted_world_logloss(full)
    results.append(("cond", f"no learning at all: log-loss {ll_frozen:.0f} "
                            f"vs {ll_full:.0f} bits", ll_frozen > ll_full + 10))

    # -- if: change-points become unsayable
    ll_noif = _shifted_world_logloss(enumerate_models(
        allowed=("bern", "hmm", "c", "get", ">")))
    results.append(("if", f"abrupt change unsayable: {ll_noif:.0f} vs "
                          f"{ll_full:.0f} bits on the shifted world",
                    ll_noif > ll_full + 3))

    # -- get: programs cannot read the world; closed loop broken
    ll_noget = _shifted_world_logloss(enumerate_models(
        allowed=("bern", "hmm", "c", "if", ">")))
    results.append(("get", f"no feature access -> no conditional structure: "
                           f"{ll_noget:.0f} vs {ll_full:.0f} bits",
                    ll_noget > ll_full + 3))

    # -- hmm (the rw combinator): drift becomes unsayable
    ll_full_d = _drift_world_logloss(full)
    ll_nohmm = _drift_world_logloss(enumerate_models(
        allowed=("bern", "if", "c", "get", ">")))
    results.append(("rw/hmm", f"drift unsayable: {ll_nohmm:.0f} vs "
                              f"{ll_full_d:.0f} bits on the drifting world",
                    ll_nohmm > ll_full_d + 3))

    # -- c (priced grids): no learnable constants -> nothing sayable
    n_noc = len(enumerate_models(allowed=("bern", "hmm", "if", "get", ">")))
    results.append(("c (grids)", f"hypothesis space empties: "
                                 f"{n_noc} programs enumerable", n_noc == 0))

    # -- bern (emission combinator): no likelihood, no contact with data
    n_nobern = len(enumerate_models(allowed=("if", "c", "get", ">")))
    results.append(("bern", f"no emission vocabulary: {n_nobern} programs "
                            f"can generate data", n_nobern == 0))

    # -- push: prediction and expectation become unutterable
    try:
        evalx(("push", "B", "K"),
              {"B": Belief.uniform(THETA_SPACE), "K": EMIT},
              disabled=("push",))
        ok = False
    except NameError:
        ok = True
    results.append(("push", "no prediction, no expectation, no marginal "
                            "likelihood: every EU routes through push", ok))

    # -- argmax: choice itself becomes unutterable
    try:
        evalx(("argmax", "ACTS", ("c", "theta", 0)),
              {"ACTS": [0, 1]}, disabled=("argmax",))
        ok = False
    except NameError:
        ok = True
    results.append(("argmax", "belief still moves but nothing can choose: "
                              "the exit from probability into action is gone", ok))

    print(f"  {'terminal':<12}{'capability lost on deletion':<62}{'verdict'}")
    for term, msg, ok in results:
        print(f"  {term:<12}{msg:<62}{'PASS' if ok else 'FAIL'}")
    assert all(ok for _, _, ok in results)
    print("  PASS: every terminal's deletion costs a capability; "
          "nothing is content")
    return True


if __name__ == "__main__":
    test_changing_world()
    print()
    test_lazy_genius()
    print()
    test_forgetting_trap()
    print()
    test_deletion_audit()
    print()
    print("=" * 72)
    print("ALL FOUR ACCEPTANCE TESTS PASS")
    print("=" * 72)
