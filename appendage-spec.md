# Appendage spec — external reach as a host declaration

**Status:** specification. No implementation. Companion to `membrane-wire.md`.
**Provenance:** this document records decisions D-1 … D-4 of life-agent's
`archive/docs/SESSION-RECORD-2026-09-05.md` — the host/language division, the
withdrawal of the oracle primitive, the 0h re-estimate, and universality as a separate
goal. That record also carries the corrections and open questions this spec depends on.
Cited by permalink, not by relative path (the file moved once already, at life-agent's
J0 reset):
<https://github.com/gfrmin/life-agent/blob/cab7d32/archive/docs/SESSION-RECORD-2026-09-05.md>.
Since that reset the record is **archived and no longer governs life-agent**; read D-1 … D-4
as a historical record of the division being built to, not as a live ruling.

[CLASS AND CUSTODY, declared 2026-09-06 at the paper-freeze-r0 close. This file is
**not manifest-covered**, and is not normative. Its covered siblings — `design.md`,
`interface.md`, `membrane-wire.md`, `typed-port-spec.md`, `KERNEL.md`, `brief.md` —
are frozen surfaces; this is a RECORD of a withdrawn proposal plus a gap analysis,
the author-pack class, which rides outside the manifest by the `EXACT_PLAN.md`
precedent. It is deliberately outside because its own Citation note declares its
line numbers may already disagree with the tree: freezing a document that says that
about itself would manufacture exactly the stale-green this repo spends its effort
killing. Nothing here binds; the gap table G1-G5 is named demand-gated residue in
the terminus's sense, re-entering only through the two-sided gate with a
measurement, and G5 is refused outright above.]

## The correction this records

An earlier proposal (2026-09-05, external review) suggested adding an *oracle
primitive* to the language — a terminal meaning "call an external service at cost c".
That proposal is **withdrawn as a category error**, and this document records why, so
the same mistake is not made again.

proplang is a Bayesian language with primitives. A host app provides *appendages* over
the wire and reports the utilities of world states. Calling an external service is
therefore **external to the language by construction**: it is a menu name the host
declares and prices. The language does not need to know that an action reaches the
network, any more than it needs to know that `respond` reaches a human.

Verified against the protocol, not assumed:

- `type Menu = [(Name, Grid)]` (`Membrane.hs:80`), declared at `hello`
  (`Host.hs:255-257`), option space = the full cartesian product of the published
  grids (`menuAssignments`, `Membrane.hs:110-113`).
- **No fixed action count and no cap.** No length check exists in `hello` or `tick`.
- life-agent's "four-action affordance grid" is **one name × four grid points**
  (`world.py:35-38`), entirely its own choice. `categorical.py:208-211` already
  publishes a K-dependent action count on the same unmodified wire.

So the affordance grid is host-declared, and always was.

## What the protocol already supports

**A priced appendage needs zero protocol change today.** Cost is expressible two ways
in the existing `said@1` utility sentence:

1. subtract a constant — `Sub (Expect ...) (C cost)`; `Sub` and `C` are already
   sayable (`parseSaidWith`, `Host.hs:593`; the `c` form at `:599`);
2. publish the cost as an ordinary namespace feature and read it with `get`, which is
   the documented doctrine — prices "are features, names like any other, read by
   `get`" (`interface.md:24-26`).

**A hard prohibition has a coarse form today:** a host may withhold a menu name from a
tick, and publication toggles availability (`membrane-wire.md:66-70`). For an
appendage whose use must sometimes be forbidden outright — see the privacy constraint
in life-agent's `DR-UTILITY-1` — this is the correct and sufficient mechanism, because
the constraint belongs to the host's preferences, not to the agent's inference.

**Reliability is learnable without any change.** Declare a guard on the writable name;
"the guard family over it is exactly the hypothesis family *the outcome depends on
what I did*" (`membrane-wire.md:363-383`), with measured posterior growth
9.09e-3 → 1.02e-1 recorded at `:386`. An appendage's reliability is then *posterior-earned
rather than asserted*, which is strictly better epistemics than a host-declared
constant and costs nothing to build.

## Gaps, by locus of change

Ordered by whether they touch the language. **None of the first three do.**

| # | Want | Locus | Est. |
|---|---|---|---|
| G1 | Explicit per-row `cost` field on a menu declaration | wire + `Host.hs` + `Membrane.hs` (wrap each row `Sub (Expect …) (mintQ cost)`) | 2–3 wk |
| G2 | Per-grid-point prohibition (`{"name":"act","points":[1,3]}`) filtered before `menuAssignments` | wire + `Host.hs` | 1 wk |
| G3 | In-language feasibility predicate (a second Bool program) | wire + `Host.hs` + `policyPick` filter | 2 wk |
| G4 | Host-**declared** reliability kernel | `Host.hs` (`kernel@1` parser) + `Enumerate.hs` (kernel enters as a `Hyp`) + `Membrane.hs` — **and a ruling**, since R-W1 / OB-8 hold that the world "never declares HOW evidence about its values must be read" | 6–8 wk + ruling |
| G5 | Multi-attribute (vector) utility | **LANGUAGE** — `Expr` has no product sort; needs `Syntax.hs`, `Eval.hs`, `weightIn` pricing, `Enumerate.hs` | large |

G1–G3 are ergonomics: they make explicit what a host can already encode by hand.
**G4 is optional and probably unwanted** — learned reliability is better, and the
ruling it needs exists for a reason.

**G5 is the one to refuse.** The wire carries a scalar and should keep carrying a
scalar. Multi-attribute preferences (money / time / privacy) belong to the host, which
scalarises them before the tick. That is not a workaround; it is the correct division —
**the host owns preferences, the language owns inference.** See `DR-UTILITY-1`.

## Re-estimate

Previously budgeted at **160h** for an "oracle primitive". Correct figure for the
capability actually wanted — escalation as a priced appendage:

> **0h of proplang change.** It is a menu name and a constant in the utility sentence.

The 160h is freed. If any of it is spent here, spend it on **G1 + G2 (3–4 weeks)**,
which buy legibility rather than capability: a host that declares
`{"name": "escalate", "grid": [...], "cost": [...]}` states its intent on the wire
instead of hiding it inside an arithmetic expression.

## Does this change the universality question?

**No — it strengthens the existing answer.** Appendages are the mechanism for
real-world reach, and they are host-side. `Lam` / `App` / `Fix` buy a larger space of
*sayable hypotheses*; appendages buy a larger space of *reachable actions*. Only the
second is on the critical path for a system that decides when to use an external
model.

Restating the estimate unchanged: `Lam`/`App` ≈ 1 week (de Bruijn + host closures give
capture-avoidance free); `Fix` is a rewrite of the semantic core — `evalx`'s total
signature `Expr env t -> Env env -> t` (`Eval.hs:62`) becomes fuel-indexed across ~36
call sites, `Code` admission goes from decidable to semi-decidable, and
`prodTable 9 → 12` invalidates every price literal in-tree. 10–14 engineer-months, and
**a deliberate aesthetic choice, not a capability need.**

## The one thing worth building here

Not a primitive — a **ladder**. See `DR-UTILITY-1` §3: a single oracle at a single
price is a point, and the useful object is a cost-quality frontier (cheap model /
strong model / extended sampling / human research). On this protocol that is
*literally one menu name with several grid points*, each priced in the utility
sentence, with reliability learned per point via a guard.

The protocol supports it today. The work is entirely in the host.


## Citation note

Line numbers in this document were verified against local `master` on 2026-09-05. An
independent audit reading **public master** found three that did not match — the
`Sub`/`C` parse, `interval_options`, and the wire's posterior-growth figure — which
means the two trees differ or the numbers have drifted since.

**Policy, adopted as a result: cite the symbol, and treat the line number as a hint.**
A citation of the form `parseSaidWith, Host.hs:593` survives a refactor; `Host.hs:597-615`
does not. Every line number here should be re-verified against whichever tree a reader
is holding, and any that disagrees should be reported against the symbol, not silently
corrected.
