"""proplang (Proposition Language) — reference implementation of a minimal
adaptive Bayesian decision-theoretic agent.

Nouns (4, peer arrangement per design doc S3):
    Space, Prevision (Belief), Event, Kernel
Verbs (3, terminals of the grammar per design doc S4):
    push (incl. push-to-R, i.e. expect), cond, argmax

Invariants enforced here:
    I1 single reasoner  — Belief log-weights are private; every consumer
       goes through expect / prob / push / cond / logpredict.
    I2 declared structure — evidence is an Event or a (Kernel, obs) pair,
       never an opaque closure handed to the engine.
    I3 single-responsibility — programs are syntax (S-expressions);
       evaluation is a separate interpreter (evalx); log-weights private
       behind probability accessors.

Deliberately ABSENT from this module (grep and see):
    no change detection, no forgetting factor, no sliding window,
    no decay, no deliberation throttle. Adaptation and laziness are
    posterior dynamics, not control flow.

Case-law registry (design doc S10): CL-1, CL-2, CL-3 referenced inline.
"""

import math

LN2 = math.log(2.0)
NEG_INF = float("-inf")


def _lse(xs):
    m = max(xs)
    if m == NEG_INF:
        return NEG_INF
    return m + math.log(sum(math.exp(x - m) for x in xs))


# ---------------------------------------------------------------------------
# NOUNS
# ---------------------------------------------------------------------------

class Space:
    """A set of possibilities. Finite in the reference implementation."""
    __slots__ = ("points",)

    def __init__(self, points):
        self.points = tuple(points)

    def __len__(self):
        return len(self.points)


class Event:
    """A declared proposition over a Space. Peer primitive (design S3)."""
    __slots__ = ("space", "pred")

    def __init__(self, space, pred):
        self.space, self.pred = space, pred

    def ind(self, x):
        return 1.0 if self.pred(x) else 0.0


class Kernel:
    """A Prevision-valued arrow between Spaces. Peer primitive (design S3)."""
    __slots__ = ("dom", "cod", "f")

    def __init__(self, dom, cod, f):
        self.dom, self.cod, self.f = dom, cod, f

    def at(self, x):
        return self.f(x)


class Belief:
    """A coherent prevision on a finite Space.

    OPAQUE HANDLE (invariant I1): the log-weights are private. No consumer
    is ever handed weights; the consumer physically cannot do arithmetic
    on belief state. All probability/utility arithmetic in the whole
    system lives in the five methods below.
    """
    __slots__ = ("space", "_logw")

    def __init__(self, space, logw):
        z = _lse(list(logw))
        if z == NEG_INF:
            raise ValueError("belief conditioned on an impossible evidence")
        self.space = space
        self._logw = [w - z for w in logw]

    # -- constructors -------------------------------------------------------
    @staticmethod
    def uniform(space):
        return Belief(space, [0.0] * len(space))

    @staticmethod
    def point(space, x):
        return Belief(space, [0.0 if p == x else NEG_INF for p in space.points])

    @staticmethod
    def from_bits(space, bits):
        """The prior 2^{-|program|}: description lengths in, prevision out.
        This is the ONLY place a prior comes from (design S5)."""
        return Belief(space, [-b * LN2 for b in bits])

    # -- verb: push ---------------------------------------------------------
    def expect(self, f):
        """push to R: the prevision of a test function. Prediction,
        expected utility, and marginal likelihood are all this."""
        return sum(
            math.exp(w) * f(x)
            for x, w in zip(self.space.points, self._logw)
            if w > NEG_INF
        )

    def prob(self, event):
        """Probability derived from prevision: E[indicator] (design S3)."""
        return self.expect(event.ind)

    def push(self, k):
        """Pushforward along a Kernel: belief over the codomain."""
        acc = {y: [] for y in k.cod.points}
        for x, w in zip(self.space.points, self._logw):
            if w == NEG_INF:
                continue
            b = k.at(x)
            for y, wy in zip(b.space.points, b._logw):
                if wy > NEG_INF:
                    acc[y].append(w + wy)
        return Belief(k.cod, [_lse(acc[y]) if acc[y] else NEG_INF
                              for y in k.cod.points])

    # -- verb: cond ---------------------------------------------------------
    def _loglik(self, evidence):
        """Evidence carries its algebra in its type (invariant I2):
        an Event, or a (Kernel, observation) pair. Never a closure."""
        if isinstance(evidence, Event):
            return [0.0 if evidence.pred(x) else NEG_INF
                    for x in self.space.points]
        k, obs = evidence
        hit = Event(k.cod, lambda y, o=obs: y == o)
        out = []
        for x in self.space.points:
            p = k.at(x).prob(hit)
            out.append(math.log(p) if p > 0.0 else NEG_INF)
        return out

    def logpredict(self, evidence):
        """log marginal likelihood of the evidence: log E[likelihood].
        This is push-to-R; it exists so no consumer needs the weights."""
        ll = self._loglik(evidence)
        return _lse([w + l for w, l in zip(self._logw, ll)])

    def cond(self, evidence):
        """The Bayesian update: the unique diachronically coherent rule."""
        ll = self._loglik(evidence)
        return Belief(self.space, [w + l for w, l in zip(self._logw, ll)])

    # -- diagnostics --------------------------------------------------------
    def entropy_bits(self):
        """Posterior entropy in bits. Case-law CL-1: a read-only diagnostic
        for logging/plots. It must never feed action selection; anything
        that steers behaviour goes through the verbs."""
        return -sum(math.exp(w) * w for w in self._logw if w > NEG_INF) / LN2

    def top(self, n=3):
        """CL-1 diagnostic: the n highest-posterior points with probs."""
        pairs = sorted(zip(self.space.points, self._logw),
                       key=lambda t: -t[1])[:n]
        return [(x, math.exp(w)) for x, w in pairs]


# ---------------------------------------------------------------------------
# VERB: argmax — the one verb that is not about belief (design S4).
# Deterministic tie-break by option order: nothing may select an action
# but expected utility; there is no coin here (design S9, purity).
# ---------------------------------------------------------------------------

def argmax(options, value):
    best, bv = None, NEG_INF
    for o in options:
        v = value(o)
        if v > bv:
            best, bv = o, v
    return best, bv


# ---------------------------------------------------------------------------
# THE GRAMMAR
#
# Programs are S-expressions (nested tuples). Model fragment:
#
#   MODEL ::= ('bern', PARAM)                        emission, param sayable
#           | ('hmm', CONST_rho)                     latent walk at rate rho
#   PARAM ::= CONST_theta
#           | ('if', TEST, PARAM, PARAM)             closed-loop branching
#   TEST  ::= ('>', ATOM, ATOM)
#   ATOM  ::= ('get', NAME) | CONST_tau
#   CONST ::= ('c', grid, k)                         k-th point of a grid
#
# Policy fragment (same terminals plus the three verbs, which are
# sayable so a program can optimise over its own inference):
#
#   EXPR  ::= ('argmax', OPTIONS, VALUE_EXPR)
#           | ('push', BELIEF_EXPR, KERNEL_EXPR)
#           | ('cond', BELIEF_EXPR, EVIDENCE_EXPR)
#           | ('expect', BELIEF_EXPR, FN)            push-to-R
#           | ('call', name, EXPR...)                stdlib named composition
#           | ('if' ...) | ('>' ...) | ('get' ...) | ('c' ...) | var | literal
#
# Description lengths are charged at derivation choice points; grids are
# charged log2(n) — once, and only once (design S5).
# ---------------------------------------------------------------------------

GRIDS = {
    "theta": [round(0.1 * k, 1) for k in range(1, 10)],          # 9 points
    "tau":   [5 * k for k in range(1, 17)],                      # 16 points
    "rho":   [0.01, 0.02, 0.05, 0.1, 0.2, 0.3, 0.4, 0.5],        # 8 points
}

FEATURE_NAMES = ["t"]   # the growing world adds names here; existing
                        # programs do not notice (design S9)


def bits_const(e):
    return math.log2(len(GRIDS[e[1]]))


def bits_atom(e):
    # ATOM has 2 alternatives: 1 bit, plus the content of the alternative
    if e[0] == "get":
        return 1 + (math.log2(len(FEATURE_NAMES)) if len(FEATURE_NAMES) > 1 else 0.0)
    return 1 + bits_const(e)


def bits_param(e):
    # PARAM has 2 alternatives: 1 bit, plus content
    if e[0] == "c":
        return 1 + bits_const(e)
    if e[0] == "if":
        test = e[1]
        return (1
                + bits_atom(test[1]) + bits_atom(test[2])
                + bits_param(e[2]) + bits_param(e[3]))
    raise ValueError(e)


def bits_model(e):
    # MODEL has 2 alternatives: 1 bit, plus content
    if e[0] == "bern":
        return 1 + bits_param(e[1])
    if e[0] == "hmm":
        return 1 + bits_const(e[1])
    raise ValueError(e)


def enumerate_models(allowed=("bern", "hmm", "if", "c", "get", ">")):
    """Enumerate the model fragment to depth 1 (one 'if').  The depth
    bound is the Cromwell frontier of the reference implementation
    (design S6/S11): the truncation is named, not hidden."""
    models = []
    consts = [("c", "theta", k) for k in range(len(GRIDS["theta"]))]
    if "bern" in allowed and "c" in allowed:
        for c in consts:
            models.append(("bern", c))
    if "hmm" in allowed and "c" in allowed:
        for k in range(len(GRIDS["rho"])):
            models.append(("hmm", ("c", "rho", k)))
    if all(x in allowed for x in ("bern", "if", "c", "get", ">")):
        for kt in range(len(GRIDS["tau"])):
            test = (">", ("get", "t"), ("c", "tau", kt))
            for c1 in consts:
                for c2 in consts:
                    if c1 != c2:
                        models.append(("bern", ("if", test, c1, c2)))
    return models


# ---------------------------------------------------------------------------
# THE EVALUATOR (invariant I3: programs are syntax; this is semantics)
# ---------------------------------------------------------------------------

def evalx(e, env, disabled=()):
    """Evaluate an S-expression. The verbs are TERMINALS here — a program
    can say 'condition again, then decide' (design S4, S7).  `disabled`
    exists only for the deletion audit."""
    if isinstance(e, tuple):
        op = e[0]
        if op in disabled:
            raise NameError(f"terminal '{op}' deleted from the grammar")
        if op == "c":
            return GRIDS[e[1]][e[2]]
        if op == "get":
            # a feature not yet present evaluates to 0.0 and lies dormant
            # until its connection appears (design S9)
            return env.get("features", {}).get(e[1], 0.0)
        if op == "if":
            return evalx(e[2], env, disabled) if evalx(e[1], env, disabled) \
                else evalx(e[3], env, disabled)
        if op == ">":
            return evalx(e[1], env, disabled) > evalx(e[2], env, disabled)
        if op == "expect":
            b = evalx(e[1], env, disabled)
            return b.expect(evalx(e[2], env, disabled))
        if op == "push":
            return evalx(e[1], env, disabled).push(evalx(e[2], env, disabled))
        if op == "cond":
            return evalx(e[1], env, disabled).cond(evalx(e[2], env, disabled))
        if op == "argmax":
            if "argmax" in disabled:
                raise NameError("terminal 'argmax' deleted from the grammar")
            opts = evalx(e[1], env, disabled)
            choice, _ = argmax(
                opts, lambda o: evalx(e[2], {**env, "option": o}, disabled))
            return choice
        if op == "call":
            fn = env["stdlib"][e[1]]
            return fn(*[evalx(a, env, disabled) for a in e[2:]])
        raise KeyError(op)
    if isinstance(e, str):
        return env[e] if e in env else e
    return e


# ---------------------------------------------------------------------------
# HYPOTHESES AS PROGRAMS
# ---------------------------------------------------------------------------

OBS = Space((0, 1))
THETA_SPACE = Space(tuple(GRIDS["theta"]))


def bern_belief(th):
    th = min(max(th, 1e-9), 1 - 1e-9)
    return Belief(OBS, [math.log(1 - th), math.log(th)])


EMIT = Kernel(THETA_SPACE, OBS, bern_belief)


def rw_kernel(rho):
    """Reflected random walk on the theta grid at rate rho. A decision-free
    combinator: total, domain-independent, its one slot (rho) filled by
    data from a priced grid (design S9, no baked constants)."""
    n = len(THETA_SPACE)
    idx = {p: i for i, p in enumerate(THETA_SPACE.points)}

    def f(x):
        i = idx[x]
        logw = [NEG_INF] * n
        lo = i - 1 if i > 0 else i + 1
        hi = i + 1 if i < n - 1 else i - 1
        acc = {i: 1 - rho}
        acc[lo] = acc.get(lo, 0.0) + rho / 2
        acc[hi] = acc.get(hi, 0.0) + rho / 2
        for j, p in acc.items():
            logw[j] = math.log(p)
        return Belief(THETA_SPACE, logw)

    return f


class Hyp:
    """A hypothesis: a program plus its filtered internal state.
    Its description length is its ONLY prior contribution (design S5)."""

    def __init__(self, expr):
        self.expr = expr
        self.dl = bits_model(expr)
        if expr[0] == "hmm":
            rho = GRIDS["rho"][expr[1][2]]
            self.latent = Belief.uniform(THETA_SPACE)
            self.trans = Kernel(THETA_SPACE, THETA_SPACE, rw_kernel(rho))
        else:
            self.latent = None
        self._pred_latent = None

    def predictive(self, features, disabled=()):
        if self.expr[0] == "bern":
            th = evalx(self.expr[1], {"features": features}, disabled)
            return bern_belief(th)
        self._pred_latent = self.latent.push(self.trans)      # verb: push
        return self._pred_latent.push(EMIT)                   # verb: push

    def absorb(self, y):
        if self.expr[0] == "hmm":
            self.latent = self._pred_latent.cond((EMIT, y))   # verb: cond


class Agent:
    """The agent: a belief over programs, moved only by the verbs.
    There is no adaptation code below — read it and check."""

    def __init__(self, models, disabled=()):
        self.hyps = [Hyp(m) for m in models]
        self.space = Space(range(len(self.hyps)))
        self.meta = Belief.from_bits(self.space, [h.dl for h in self.hyps])
        self.t = 0
        self.disabled = disabled

    def _step_kernel(self):
        feats = {"t": self.t}
        preds = [h.predictive(feats, self.disabled) for h in self.hyps]
        return Kernel(self.space, OBS, lambda i, P=preds: P[i])

    def predictive(self):
        return self.meta.push(self._step_kernel())            # verb: push

    def observe(self, y):
        k = self._step_kernel()
        lp = self.meta.logpredict((k, y))                     # push-to-R
        if "cond" not in self.disabled:
            self.meta = self.meta.cond((k, y))                # verb: cond
            for h in self.hyps:
                h.absorb(y)
        self.t += 1
        return lp


# ---------------------------------------------------------------------------
# THE HOST BOUNDARY (design S9: purity, randomness at the boundary)
# ---------------------------------------------------------------------------

import random as _random


def draw(belief, rng=None):
    """CL-2: the sole source of randomness, host-side, called AFTER the
    language has built the belief. Not in the evaluator's environment;
    no program can utter it. Used only to simulate worlds in tests."""
    rng = rng or _random
    u, acc = rng.random(), 0.0
    for x, w in zip(belief.space.points, belief._logw):
        if w == NEG_INF:
            continue
        acc += math.exp(w)
        if u <= acc:
            return x
    return belief.space.points[-1]
