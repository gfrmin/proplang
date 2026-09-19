#!/usr/bin/env python3
"""#29 ask 3 falsifier: what the clock row costs on life-agent's categorical world.

The episode is driven by the CONSUMER'S OWN function, `categorical.decide_categorical`
(handshake from `handshake_decl_cat`, one evidence tick per code, one decide tick -- every
tick carrying `"menu": ["act"]`, as the door requires).  A pipe client stands in for
`MembraneClient` (same `request_json` serialisation) so it can read the host's CPU time
from /proc per request.  The clockless arm differs in ONE thing: the proxy deletes the
handshake's "clock" key before sending.  Arms interleave per rep, so load is shared; CPU
time (utime+stime of the host process, 1/CLK_TCK resolution) is the measure, wall time
rides beside it.

The engine-side reading this tests (Host.hs at 571b589, the `tick` handler): a tick with a
menu and a declared utility runs the chooser; with a clock row declared the chooser is
`thinkValue` + `pickWire` -- a preposterior over every observation atom -- and evidence
ticks are NOT exempt.  Prediction: a clocked tick costs ~(K+1) clockless ticks, K = k+1
atoms, on EVERY tick of the episode.

Usage: probe-clock-29.py <proplang-host binary> [reps] [--binary-only]
"""
import hashlib, json, os, pathlib, statistics as st, subprocess, sys, time

LIFE_AGENT = pathlib.Path.home() / "git" / "life-agent"
sys.path[:0] = [str(LIFE_AGENT / "src")]
from life_agent.membrane import categorical as CAT          # noqa: E402
from life_agent.membrane import world as W                  # noqa: E402
from life_agent.membrane.client import request_json         # noqa: E402
from life_agent.membrane.session import evidence_tick_body  # noqa: E402

# the same boot Ū as the #26 witness (r49 S8 + r48's gather split)
U_BAR = {"u_wrong": -5.130990272278651, "u_abstain": 0.0, "u_correct": 1.0,
         "kappa_att": 0.048057099794822}
TCK = os.sysconf("SC_CLK_TCK")


class TimedPipe:
    """The `_Client` protocol decide_categorical takes: request + shutdown."""

    def __init__(self, engine, clock):
        self.clock = clock
        self.p = subprocess.Popen([engine], stdin=subprocess.PIPE, stdout=subprocess.PIPE,
                                  text=True, bufsize=1)
        self.log = []                       # (kind, cpu_s, wall_s, reply)

    def cpu(self):
        f = open(f"/proc/{self.p.pid}/stat").read().rsplit(")", 1)[1].split()
        return (int(f[11]) + int(f[12])) / TCK     # utime + stime

    def request(self, obj):
        if "membrane" in obj and not self.clock:
            obj = json.loads(json.dumps(obj))
            del obj["world"]["clock"]
        kind = ("hello" if "membrane" in obj else
                "evidence" if "evidence" in obj["tick"] else "decide")
        c0, w0 = self.cpu(), time.perf_counter()
        self.p.stdin.write(request_json(obj) + "\n")
        reply = json.loads(self.p.stdout.readline())
        self.log.append((kind, self.cpu() - c0, time.perf_counter() - w0, reply))
        return reply

    def shutdown(self):
        self.p.stdin.close()
        self.p.wait()


def episode(engine, k, clock, codes):
    s = CAT.CatSummary(k=k, obs_codes=codes, n_obs=len(codes), n_obs_unmapped=0,
                       daemon_map_index=0, era_split=False, owner_scoped=False,
                       grow_pass=False)
    c = TimedPipe(engine, clock)
    try:
        choice = CAT.decide_categorical(c, U_BAR, s)
    finally:
        c.shutdown()
    return c.log, choice


def binary_episode(engine, clock, n):
    """life-agent's BINARY world (world.handshake_decl, 960 models, K = 2): n evidence ticks
    in the consumer's one declared body (session.evidence_tick_body), then one decide tick."""
    c = TimedPipe(engine, clock)
    try:
        ok = c.request(W.handshake_decl(U_BAR))
        assert ok.get("ok"), ok
        s = W.DecideSummary(n_candidates=3, leader_credence=0.95, p_none=0.1, n_obs=5,
                            era_split=False, owner_scoped=False, grow_pass=False)
        for t in range(n):
            r = c.request({"tick": evidence_tick_body(W.shadow_features(s, float(t)), t % 5 != 0)})
            assert "error" not in r, r
        c.request({"tick": {"features": W.shadow_features(s, float(n)), "menu": [W.ACT_NAME]}})
    finally:
        c.shutdown()
    return c.log


def main():
    engine = sys.argv[1]
    reps = int(sys.argv[2]) if len(sys.argv) > 2 and sys.argv[2].isdigit() else 3
    print(f"engine {engine}\nengine sha256 "
          f"{hashlib.sha256(pathlib.Path(engine).read_bytes()).hexdigest()}")
    print(f"life-agent {subprocess.run(['git','-C',str(LIFE_AGENT),'rev-parse','HEAD'],capture_output=True,text=True).stdout.strip()}"
          f"  CLOCK_BATCH={CAT.W.CLOCK_BATCH}  clock price {CAT.W.clock_price(U_BAR)}"
          f"  CLK_TCK={TCK}  loadavg {open('/proc/loadavg').read().split()[:3]}")
    print(f"{'k':>2} {'K':>2} {'models':>6} {'arm':8s} {'ev cpu ms/tick':>15s} {'decide cpu ms':>14s}"
          f" {'episode cpu s':>13s} {'episode wall s':>14s}  choice")
    for k in (() if "--binary-only" in sys.argv else (1, 2, 3, 4, 5)):
        codes = tuple(([1, 1, 2, 0, 1, 3, 1, 2] * 2)[:8])
        codes = tuple(min(x, k) for x in codes)        # codes must lie in 0..k
        res = {True: [], False: []}
        for _ in range(reps):
            for clock in (True, False):
                res[clock].append(episode(engine, k, clock, codes))
        rows = {}
        for clock in (True, False):
            ev = [c for log, _ in res[clock] for kind, c, _, _ in log if kind == "evidence"]
            de = [c for log, _ in res[clock] for kind, c, _, _ in log if kind == "decide"]
            ep = [sum(c for kind, c, _, _ in log if kind != "hello") for log, _ in res[clock]]
            wl = [sum(w for kind, _, w, _ in log if kind != "hello") for log, _ in res[clock]]
            models = res[clock][0][0][0][3].get("models")
            choice = res[clock][0][1].action
            rows[clock] = (st.median(ev), st.median(de), st.median(ep), st.median(wl))
            print(f"{k:2d} {k+1:2d} {models:6d} {'clock' if clock else 'no clock':8s}"
                  f" {1000*rows[clock][0]:15.1f} {1000*rows[clock][1]:14.1f}"
                  f" {rows[clock][2]:13.3f} {rows[clock][3]:14.3f}  {choice}")
        r = [a / b if b else float("nan") for a, b in zip(rows[True], rows[False])]
        print(f"{'':2s} {'':2s} {'':6s} {'ratio':8s} {r[0]:15.2f} {r[1]:14.2f} {r[2]:13.2f}"
              f" {r[3]:14.2f}  (prediction K+1 = {k+2})")
    print("\nbinary world (world.handshake_decl, K = 2), 20 evidence ticks + 1 decide, same Ū:")
    rows = {}
    res = {True: [], False: []}
    for _ in range(reps):
        for clock in (True, False):
            res[clock].append(binary_episode(engine, clock, 20))
    for clock in (True, False):
        ev = [c for log in res[clock] for kind, c, _, _ in log if kind == "evidence"]
        ep = [sum(c for kind, c, _, _ in log if kind != "hello") for log in res[clock]]
        models = res[clock][0][0][3].get("models")
        rows[clock] = (st.median(ev), st.median(ep))
        print(f"   {'clock' if clock else 'no clock':8s} models {models}  evidence tick cpu ms"
              f" {1000*rows[clock][0]:8.1f}   episode cpu s {rows[clock][1]:7.3f}")
    print(f"   ratio  evidence tick {rows[True][0]/rows[False][0]:.2f}   episode"
          f" {rows[True][1]/rows[False][1]:.2f}   (prediction K+1 = 3)")


if __name__ == "__main__":
    main()
