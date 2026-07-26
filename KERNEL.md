# KERNEL.md — proplang on one page

*Drafted at the repair sitting of 2026-07-25 (builder; blessed by the
author's freeze tag). The standing test: any future state of this repo
in which this page stops being writable is the alarm.*

proplang is a language in which only Bayesian-optimal decisions are
expressible: the alphabet IS the prior, deliberation is a sentence, and
the world — never the language — supplies every constant.

```
SORTS      Rational (exact), Bool, B a (belief), K a b (kernel)
DECLARED   Space, Grid (a codebook), Carrier, Namespace — bundled as
           World: the world's data, never the language's

TERMINALS  (9 EXPR at 1/9 each; 1 KER at 1/1 — the prior weight of a
            sentence is the exact product of its choice-widths)
  leaves      C (a codebook mention, priced by its grid)
              Get (a declared feature, door-served — no default)
              Var (a binder reference)
  structure   If · Gt · Sub · Mul
  verbs       Expect (prevision = push-to-R)
              Cond (Bayes: belief, kernel, outcome, Just-arm, Nothing-arm)
            | Code (a likelihood, said as a mass sentence)

NOT TERMINALS (executed compositions, priced at their expansions)
  zero/neg/add   Sub x x · Sub (Sub b b) b · Sub a (Sub (Sub b b) b)
  equality       If/Gt              choice/argmax  If/Gt over Expects
  VoI            Expect-composition deliberation   the composed
                                                   preposterior sentence
  Is-evidence    an indicator kernel, said as a Code
  adaptation     a sentence about a changing world — the update rule
                 does the rest

SEATS      every terminal holds against an EXECUTED attempt to compose
           it away (Sub: monotonicity — 1−θ uncoverable; Mul: the
           preposterior's mass×value products are bilinear, outside
           the piecewise-affine closure; If/Gt/Code: sole
           eliminator/introducer, compile facts; Get: feature contact;
           Var: binder infrastructure; C: the only constant door;
           Expect: the only scalar exit from a belief; Cond: the one
           sentence-reachable conditioning division)

REASONER   sealed; fromWeights the SOLE introducer (uniform and point
           are its definitions); laws L1–L3 (Riesz) + L4' (prob·Z == w),
           all by ==; conditioning is Bayes by ==; no NaN, no
           tolerance, no log-space — Rational has none of the
           pathologies the old machinery existed to survive
DOOR       a tick covers the declared namespace exactly, or it is
           refused by name (missing / undeclared / duplicate) — env
           construction is door-only; no 0.0 default exists
EDGE       one reporting module renders displays (entropy, bits) from
           exact views; the core never renders a Double
HOST       fires actions, owns randomness — after the language has
           built the belief; a host fold is legal only as a fast path
           pinned to the sayable route (the agent criterion)
RESIDUES   the alphabet, the clock, the pointer, the floor — physics,
           named, not hidden; the floor is the ONE un-deliberated
           policy evaluation per tick (the trampoline must evaluate
           the standing sentence to learn what the agent wants,
           including whether to deliberate, and THAT evaluation is
           not itself deliberated — else regress; priced at zero by
           construction, removable only by removing the agent)
```

The anchors that pin all of this are generated from an in-tree exact
reference (test/ExactReference.hs after the swap), the streams are
byte-identical to the original Python oracle's, and the acceptance
stories are unchanged from the first frozen oracle: the agent consults
when the world shifts, thinks less when the clock is dear, beats the
forgetter it refuses to become, and loses every capability exactly when
the terminal that carries it is deleted.

---

# Page 2 — the as-built architecture (Phase 2; one line per module)

*The module-derivation table (§12 step 5): a module without a line is
collapsed, not documented.*

| module | one-line derivation |
|---|---|
| `PropLang.Belief` | the sealed exact reasoner: `fromWeights` the sole introducer (`uniform`/`point` its definitions), `expect`/`prob` the eliminator, `condK`/`condV` the Bayes step (the system's one division), `push` engine machinery, `points`/`weights`/`top` exact read-only views |
| `PropLang.Syntax` | the 9+1 grammar as a GADT, its codebooks (`Grid`/`Carrier`/`Namespace`/`World`), the one constant door (`mkC`), the derived name `addM`, and the exact pricer (`weightIn`, CMass/CMul, prodTable 9/1) |
| `PropLang.Eval` | door-only env construction (`mkEnvIn`, three named refusals) and total big-step `evalx` |
| `PropLang.Enumerate` | THE CORPUS AS A DERIVATION (R17): `corpusBodies`/`inCorpus` the intension; `enumerate`/`enumerateWith`/`enumerateWithArity` the pinned family selectors; the sentence-driven engine (`AgentS`, `observeS`, `predictMassS`, `metaPosterior`) |
| `PropLang.Report` | the reporting edge — the ONLY Double module: entropy and bits displays of exact views, `==` under the pinned toolchain |
| `PropLang.Membrane` | the boundary layer: menus as codebooks, assignments, `reindexUtility`, and THE SENTENCE-ROUTE SELECTION (`chooseEU` — CL-3 as the binary If/Gt-over-Expects sentence iterated; no host fold survives) |
| `PropLang.Host` | the wire: `serveLine` pure sessions (hello declares the World's codebooks; ticks pass the door; K-ary served), `draw` the one randomness door, `hostMain` the loop |
| `PropLang.Lattice` | R1's refinement lattice in weight form (dyadic `2^-gamma` priors exact; binary64-embedded thetas pending the dyadic-coordinate re-ruling) |
| `PropLang.Purchase` | the joint purchase law over the lattice (caller-declared carrier; weight-form emissions) |
