> **[DRAFT — builder-authored, not frozen. The step-5 capstone (the
> demonstration tier, `EXACT_PLAN.md` §13.0). It becomes normative only when
> the author reviews it, extends and re-signs `MANIFEST.sha256` to cover this
> file and `test-paper/check.sh`, and mints the terminus tag; that tag
> terminates the roadmap. Until then this is an unfrozen draft like
> `WRITEUP.md` was before `writeup-freeze`.]**
>
> **Relationship to `WRITEUP.md`.** `WRITEUP.md` is the Double-era close-date
> record (*SUPERSEDED IN PART* at the exact re-founding). This paper is the
> EXACT-era capstone: its anchors are the exact oracle (`test/Anchors.hs`,
> `test_output.txt`), not the Double archive. Where the two could disagree the
> frozen source wins and the disagreement is a defect here — which is what
> `test-paper/check.sh` exists to catch, byte-for-byte.

# proplang — the demonstration

*The smallest language in which an agent's adaptivity, bounded rationality, and
inductive bias are consequences of the grammar rather than modules bolted onto
it. This paper states the finished claim and points every sentence of it into
the repository: each number below is quoted from the frozen artifact that
generates it, and the closing reviewer block (§11) re-verifies the chain from a
clean shell.*

## 0. The thesis, and the claim set

The brief (`brief.md`) sets one headline requirement — *the agent must adapt to
the world even as it changes* — and states the thesis the project set out to
demonstrate:

> The central and slightly deflating thesis of this document is that
> adaptivity is not a thing you build. It is a thing you make sayable, whereupon
> a single learning rule handles it for free.
> If at any point you find yourself writing a subroutine called `adapt`,
> `forget`, or `detect_change`, stop: you have misunderstood the task.

The claim set the finished artifact stands on, per `EXACT_PLAN.md` §13.0 — six
claims, each closed by an executed artifact, no partial credit:

1. **Necessity** — by executed deletion (§3).
2. **Sufficiency** — by executed interpolation (§4).
3. **Soundness** — by four gates (§2).
4. **Exactness** — by `==` (§5).
5. **Closure** — metareasoning, by E4 (§6).
6. **A live host** — agents in the world, not oracle worlds (§7).

And, honestly bounded by the cost the language actually pays: the fold-depth
benchmark (§8), whose reading is the owner's, not this paper's.

## 1. The language as it ships

The reasoner is sealed (`src/PropLang/Belief.hs`): the `Belief` constructor is
never exported, so no host can forge a posterior or read one except through the
declared operations. The grammar (`design.md`, `typed-port-spec.md`) is a
first-order, defunctionalized syntax priced in bits; the membrane
(`interface.md`, `membrane-wire.md`) is the only channel between a host and the
reasoner. The full priced grammar the wire parses is nine forms:

```
var c + - * get if > =
```

**Three levels, named once — the paper uses these names and no others.**

- **The wire surface**: the nine forms above, what `parseSaidWith` in
  `src/PropLang/Host.hs` accepts. Two of the nine are *derived names*, not
  terminals — `+` parses to the `addM` macro and `=` to an `If`/`Gt`
  composition, each priced at its expansion. `/ log exp neg` fail closed (they
  left the alphabet at the exact boundary), and `<` has no codeword at all,
  because `Lt x y` **is** `Gt y x` by argument swap and a codeword for it would
  be pure prior distortion.
- **The terminal alphabet**: the ten `Expr` constructors in
  `src/PropLang/Syntax.hs` — seven structural atoms (`Var`, `MkC` — the `c`
  form —, `Sub`, `Mul`, `Get`, `If`, `Gt`) and three verbs (`Cond`, `Expect`,
  `Code`). **This is the set "remove any terminal" quantifies over in §3.**
- **The fragment productions**: the generative families the enumerator utters
  (`bern`, `rw`/`hmm`, `const`). These are what a *hypothesis* is made of, not
  what the *syntax* is made of.

Everything an agent does — represent a changing world, weigh how much to reason,
choose an action — is a sentence of that grammar over the sealed reasoner. There
is no `adapt`, no `forget`, no `detect_change`; the deletion audit (§3) shows
those words are absent, not hidden.

## 2. Soundness — the four gates

Soundness is the claim that the language *can only* be used for EU-maximal
decisions, and that its adaptivity is content, not machinery. Four acceptance
tests witness it (`test/Acceptance.hs`, anchored in `test/Anchors.hs`, transcript
in `test_output.txt`). Each is one world; each conclusion is a program the agent
inferred, printed and checked against a frozen anchor.

**T1 — the changing world.** A 160-tick world emits 1 with probability 0.9 up to
tick 60 and 0.1 from tick 60 on (`test/Streams.hs`: `y_t = [rng.random() < (0.9 if t<60 else 0.1)]`).
The agent is never told that a shift exists, let alone when. It grows confident,
*consults* — asks for a costly look — and recovers, with no change-detector in
the loop. Its MAP program is a change-point *sentence*:

```
MAP program: ('bern', ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)))  (posterior 0.64)
t1MapIndicesX = (11,0,8)
```

Those indices are positions on the world's own declared grids
(`test/OracleWorld.hs`, `test/ExactReference.hs`), so the sentence needs one
bridge to be readable:

```
tauG = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]
thetaG = [1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10, 6 % 10, 7 % 10, 8 % 10, 9 % 10]
```

`tau` index 11 is **60**; `theta` indices 0 and 8 are **0.1** and **0.9**. The
MAP sentence therefore reads *if t > 60 then 0.1 else 0.9*: both rates exactly
right, and the change point as close as the grammar permits.

**As close as it permits, not exact — and the residue is worth naming in a paper
that boasts about `1169` not "about a thousand".** The guard is a strict `Gt`
(`src/PropLang/Eval.hs`: `Gt a b -> evalx a env > evalx b env`), so the sentence
predicts 0.9 for `t ≤ τ` and 0.1 for `t > τ`, while the world switches *at* 60.
A perfect sentence would need `τ = 59` — and 59 is **not on the declared `tau`
grid**, which offers 55 and 60. So:

- `τ = 60` is wrong at exactly one tick, `t = 60`, where it says 0.9 and the
  world emits 0.1;
- `τ = 55` would be wrong at four, `t = 56…59`.

The agent picks the **closest sayable sentence**, and its one tick of residue is
declared-grid coarseness meeting a strict `>`, not an inference error. That is
the more interesting claim anyway: what the agent recovers is bounded by what the
world made sayable, which is §1's whole point about declared structure and §9's
about the limits of a declared support.

The consult ticks are **not** the ticks around the shift. They are wherever the
posterior is uncertain, which turns out to be two places:

```
t1ConsultTicksX = [0,1,3,4,65,66,67,68,69,70]
```

**at startup** (ticks 0–4, before any evidence has narrowed the hypothesis
space) and **again across the change** (ticks 65–70; the lag past the shift at
60 is the evidence accumulating) — **and nowhere else**. That is the stronger
claim and the one the anchor actually supports: consultation tracks posterior
uncertainty wherever it lives. A change-detector would have had nothing to say
at tick 0, where half this window is.

Adaptation is visible in the posterior and invisible in control flow. Gate 4
scans `src/` for the forbidden semantic tokens — `audit/forbidden.txt` lists
`detect`, `forget`, `window`, `decay`, `sliding`, `reset`, `trigger`, `temper`,
`anneal`, `throttle`, code tokens not comments — and returns `CLEAN (9 file(s)
scanned)`. Note the honest limit: `adapt` is not on that list, so its absence is
a separate one-line grep, also clean, and not something gate 4 enforces.

**T2 — the lazy genius.** Same agent, same code; only the world's *price of a
tick* changes. A dearer clock buys strictly fewer thinking ticks — 1, 3, 12, 12
at prices 0.3, 0.05, 0.005, 0:

```
t2RowsX = [(3 % 10,1,"L"),(1 % 20,3,"L"),(1 % 200,12,"L"),(0 % 1,12,"L")]
```

There is no throttle to point at. The deliberation loop is

```
while argmax([act, think]) == think: condition on a batch
```

— no iteration cap, no threshold constant. Delay is priced by an opportunity
cost the world supplies as a feature; the clock, and only the clock, terminates
the regress.

**T3 — the forgetting-factor trap.** A scripted "forgetting factor" tracker is
tuned across `g = 0.8 … 1.0` and pitted against the agent on a drifting world and
a stationary one. Log-loss; lower is better; each forgetter row is
`(g, drift, flat)`. The agent carries a *latent drift-rate*, not a decay knob:

```
agent (latent drift-rate):     drift 339.78242360387446   flat 351.1061771452692
forgetting factor g=0.8:       (4 % 5,369.7929712967314,396.6021006870599)
forgetting factor g=0.95:      (19 % 20,340.88263044835253,359.3527535371698)
forgetting factor g=1.0:       (1 % 1,397.92621119190125,350.330276640413)
agent's MAP on the drifting world: ('hmm', ('c', 'rho', 3))
```

**On drift the agent beats every forgetter, including the best one.** `g=0.95`
is the drift-optimal setting of the knob, at 340.88; the agent is at 339.78. It
does not merely match an oracle-tuned baseline — it beats it, and the tuner had
to be handed the sweep while the agent inferred the rate.

**On the stationary world the agent loses, and this is the row that says so.**
`g=1.0` — the *no-forgetting* limit, which simply accumulates — scores 350.33
against the agent's 351.11, winning by 0.78 nats. A stationary world is exactly
where never discounting is correct, and the agent pays a small permanent premium
for carrying a drift hypothesis it does not need. That premium is the honest
price of adaptivity-as-content, and it is bounded: the same `g=1.0` row is the
*worst of all* on drift, at 397.93, some 58 nats behind the agent.

So the whole trade is legible in one table. The tuned knob wins only in the
world it was tuned for; the agent — one program, no knob, nothing told to it —
is best where it matters and 0.78 nats behind where it does not.

The forgetting factor is then *deleted*: it exists only in the test file, as the
trap. Adaptation is content (a latent drift-rate), not mechanism.

**T4 — the deletion audit.** Every terminal's removal costs a capability
(detailed in §3); the summary counts are exact:

```
t4CountsX = (1169,0,0)   -- full enumerable, none after deleting c, none after deleting bern
```

All four tests pass together (`test_output.txt`: *ALL FOUR ACCEPTANCE TESTS
PASS*). Soundness is not asserted; it is the reason these four programs are the
ones the agent inferred.

## 3. Necessity — executed deletion

Necessity is the claim that the alphabet — the ten `Expr` terminals named in §1
— has no dead weight: remove any one and a capability the agent needs becomes
unsayable. This is not argued. It is a code-level ablation per terminal (a GADT
constructor behind a CPP flag, or a restricted enumeration), the frozen gate 7.

**Ten terminals, ten ablation seats, one each.** `audit/ablation.sh` runs both
halves:

| terminals | ablation fixtures |
|---|---|
| `Var` `MkC` `Sub` `Mul` `Get` `If` `Gt` | `test-pin/ablation/Use{Var,C,Sub,Mul,Get,If,Gt}.hs` |
| `Cond` `Expect` `Code` | `audit/ablation-exact/Use{Cond,Expect,Code}.hs` |

Each fixture must **compile** against the shipped surface *and* must **fail** to
compile under its own `-DDROP_<seat>` flag. Compiling proves the seat is real;
failing proves the deletion bites. Neither half alone is evidence — this is the
two-sided discipline the whole repository is built on, applied to its alphabet.

Separately, T4 measures what each deletion *costs*, in bits, on the acceptance
worlds. Its table is quoted verbatim from the frozen transcript
(`test_output.txt`), which carries the **Double-era wording**: there `push` is
the terminal now called `Expect`, and `argmax` is now `Code`; and two of its
rows (`rw`/`hmm`, `bern`) are fragment productions rather than `Expr` terminals.
Stated once, here, so the seat table above and the cost table below can be read
against each other:

| terminal | capability lost on deletion | log-loss |
|---|---|---|
| `cond` | no learning at all | 160 vs 97 bits |
| `if` | abrupt change unsayable | 103 vs 97 bits |
| `get` | no feature access, no conditional structure | 103 vs 97 bits |
| `rw`/`hmm` | drift unsayable | 211 vs 207 bits |
| `c` (grids) | hypothesis space empties | 0 programs enumerable |
| `bern` | no emission vocabulary | 0 programs generate data |
| `push` | no prediction, expectation, or marginal likelihood | every EU routes through it |
| `argmax` | belief moves but nothing can choose | the exit into action is gone |

The `cond` row costs 160 vs 97 bits (learning itself); the drift row costs
211 vs 207 bits. Ten terminals, ten seats, eight measured capability losses;
nothing is content dressed as a primitive.

## 4. Sufficiency — executed interpolation

Sufficiency is the claim that the grammar can *create* Bayesian-optimal agents —
not just the four the acceptance tests exhibit, but the family between them. Four
worked examples witness four points; the completeness suite
(`test-battery/Battery.hs`) witnesses the interpolation, walking the family the
four tests corner and checking that the agent is the Bayes-optimal sentence at
each interior point **it walks**. The four acceptance tests are the corners; the
battery is the fill.

This is a witness over a walked family, not a proof over all worlds, and the
suite prints its own residual — the axes and ranges it does not span — rather
than absorbing it. §9 states the bound, and §9 is the operative statement.

## 5. Exactness — by `==`

The reasoner carries no tolerance and no approximation: beliefs are exact
`Rational`, and every anchor in this paper is an exact value with the Double
shown only at the reporting edge. The kernel states the rule (`KERNEL.md`): no
tolerance, no log-space — `Rational` has none of the round-off those would paper
over. The consequence is that correctness is checkable by `==`, not by a
threshold: the property suite (`test/Properties.hs`) pins the conjugacy and
fineness laws by exact equality, and `test/Anchors.hs` carries the exact
posteriors (thousand-digit rationals) from which every displayed number is
derived. Exactness is why the deletion counts are `1169`, `0`, `0` and not
"about a thousand."

## 6. Closure — metareasoning, by E4

Closure is the claim that *thinking about how much to think* is not a special
faculty but an ordinary sentence of the same grammar. The trampoline increment
(E4; `test-trampoline/Trampoline.hs`) makes deliberation sayable and pins it: the
world declares a `clock` — a name, a price, a batch depth — and the engine's
preposterior at that depth, minus the price, enters the *same one policy
sentence* as any ordinary option. The agent choosing to think is the argmax
picking the internal act over the external one, at a crossing the price alone
sets. Metareasoning is not automatic and not bolted on; it is sayable, and the
trampoline pins it to the one policy rule. This is the same mechanism T2 exhibits
from the outside.

## 7. A live host

The four tests are worlds inside the test harness; the sixth claim is that the
*same* reasoner serves a real client over the wire. This one is executed, not
argued: `test-paper/hello9.sh` drives the shipped `proplang-host` binary over
stdin/stdout and records what comes back in
`test-paper/hello9-transcript.txt`. Three legs.

**A hello whose utility is written in all nine wire forms is accepted, and the
agent then adapts over the wire.** The utility exercises every one of
`var c + - * get if > =` and is extensionally the t2-lineage utility
`move*(2y-1)`. The reply is `{"ok": true, ..., "models": 9, ...}`, and then
across eight ticks observing 0:

```
{"act": {"move": 1}, "p1": 0.5, ..., "loss_bits": 1.0}
{"act": {"move": -1}, "p1": 0.36666666666666664, ..., "loss_bits": 0.6589630821649332}
...
{"act": {"move": -1}, "p1": 0.16178501749598567, ..., "loss_bits": 0.2546077860279184}
```

The chosen act **flips** from `move = 1` to `move = -1` and stays there, and the
per-tick loss falls from 1.0 to 0.25. The flip is the argmax over a moving
posterior: no threshold, no detector, no adapt call — §2's T1 and T2, happening
live to a client that is not a test.

**And tick 0 is where §5 stops being a boast about arithmetic hygiene.** The
readout says `p1: 0.5`, which invites the reading that the options tie and some
convention breaks it. They do not tie. The nine declared decimals `0.1 … 0.9`
cross the wire as **Doubles**, so their exact mean is not `1/2` but

```
1/2 + 1/324259173170675712
```

making `E[2y-1] = 1/162129586585337856`, about `6.2e-18` — strictly positive,
invisible in a float readout, and decisive under an exact `Gt`. Leg 1b proves it
two-sidedly by inverting the utility's sign, which flips the act; a tie-break
would have been unmoved. Leg 1b then shows the frozen tie convention *is* intact
where a genuine tie exists: under a utility constant in `move`, the
**first-listed** grid entry survives, in declared order and not by value.

So a float host would show `0.5`, tie, and fall back on a convention; the exact
host decides on a quantity eighteen orders of magnitude below what it prints.
Correctness by `==` is not fastidiousness here — it is the reason this act is
determinate at all.

**The refusals are as load-bearing as the acceptances.** Each of these is the
same hello with a different utility, and each is fail-closed:
`neg`, `/`, `log`, `exp` (they left the alphabet at the exact boundary);
`expect`, `cond`, `code` (belief-scoped heads — no wire codeword);
`<` (no codeword, since `Lt x y` **is** `Gt y x`); `["var", 2]` (off the
declared arity). Nine forms parse, and only nine.

**And one hole, found by this very witness and closed before the freeze.** The
transcript's third leg exists because when it was first run, it failed. An
undeclared name inside a hello's *utility* passed the door and reached the
partial `Get` case in `evalx` — a host-process crash rather than a wire error,
and a **latent** one, since Haskell's laziness spares an untaken branch: the same
malformed declaration was a crash or a success depending on which way a guard
fell at run time. Menu and guard names had always been namespace-checked; the
utility's reads had not.

The repair puts the check at the door, where a declaration is well-formed or not
independently of the data, and applies the *same* predicate the guard and menu
names already went through — so the refusal is the one those names already got:

```
{"error": "names outside namespace"}
```

Its oracle is `test-wire` — ten rows, of which
`w1`/`w2`/`w5` were red against the shipped pre-increment surface and `w3`/`w4`
are the controls that keep the repair from over-refusing (a patch that rejected
every utility would turn the first three green and the controls red). Leg 3 now
guards it, and `w5` pins the part that matters most on a real wire: a refusal is
served like any other bad hello, so the session survives it instead of taking
every other client's decisions down with it.

It is recorded here rather than quietly fixed because the finding is the point:
the claim in this section was `ARGUED` in draft, and the act of demoting an
argument to an execution is exactly what turned up a defect that argument had
been hiding.

`draw` and the polling loop live only in the host; no `IO` reaches the
reasoner's types, and the host fold routes every decision through the sealed
reasoner.

## 8. The measured cost — the benchmark

Honesty requires stating what §5's exactness costs. The fold-depth benchmark
(`bench/bench-fold-depth-r01.md`) measures per-tick cost as the belief state
deepens: per-tick cost grows as `c(t) = c0 + a·t^α`, with exponents across the
dyadic profiles in a band of

```
1.43–1.60
```

The temptation is to report that band as the cost of exactness and stop. The
benchmark's own falsifier, ordered before any acceptance band was filled, makes
that reading untenable — and not only for the outlier. It found that **the
folded state carries O(t) bits**. On the real declaration that is decisive:

```
`alpha_3p` = 2.44
```

measured an *arithmetic representation* — denominator growth in the exact
posterior — and not the decision problem. But the same mechanism is present in
the dyadic profiles too, merely with a smaller coefficient. P1 is *already fully
dyadic* and its folded state still grows at

```
19.8 bits/tick
```

against an O(log t) sufficient-statistic control. Snapping a declaration to
dyadic rationals shrinks the coefficient — the `81x collapse`, ~101k bits/tick
at the real declaration against ~20 on the dyadic profile — but the linearity
survives, because the growth lives in the exact fold's likelihood product and
not in the grid's number format.

So the honest statement is stronger than "the real-declaration cell was
contaminated". **Every measured exponent partially reads the fold's
representation rather than the decision problem, the dyadic ones least and the
real one most; and the intrinsic per-tick cost at bounded state is unmeasured.**
That — not the outlier alone — is why the acceptance band stays **blank for a
measured reason and not an absent input**: a cutover gate read against any of
these exponents is reading a quantity that is partly about denominators.

One correction to the natural slogan while we are here. This is not "the cost of
never rounding": dyadic snapping *is* rounding, at declaration time, and it
bought an 81× coefficient collapse without touching the growth rate. It is **the
cost of never consolidating** — of carrying an exact fold whose sufficient
statistics are never re-based. Naming it that way points straight at the banked
door: a const-family fold has bounded sufficient statistics and need not carry
O(t) bits. That observation is banked as measurement only and re-enters
post-terminus through the two-sided gate with a consumer's registered demand
(issue #25). **The seam-swap judgement is the owner's; this paper does not make
it.**

## 9. What is not claimed

The six claims are what the artifact demonstrates; this section is what it does
not, so the demonstration is not read wider than it is measured.

- The benchmark's acceptance band is unfilled by design (§8); no pass/fail is
  claimed from it. Every measured exponent is partly a reading of the fold's
  representation, and the intrinsic per-tick cost at bounded state is
  **unmeasured**.
- Sufficiency is witnessed over the completeness suite's walked family, not
  proven for every conceivable world; the residual is the suite's, printed not
  absorbed.
- The wire is fail-closed on every surface this paper exercised, but "every
  surface exercised" is the honest scope. §7's leg 2 walks the retired forms,
  the belief-scoped heads, `<` and off-arity `var`; leg 3 walks undeclared reads;
  separate probes cover empty and malformed codebooks, grids, namespaces,
  `obs_arity`, evidence range and tick menus. That is a walked set, not a proof
  of totality, and the §7 defect is precisely what a walked set finds and an
  argument does not.
- A named research programme remains, *named not scheduled*, re-entering only
  through the two-sided gate with a measurement: the quine face, the two-stream
  polarity demand (`OB-15`, `OB-19`), continuous carriers (foreclosed), the
  bounded-representation demand (#25), and the brief's §6 self-compression — the
  agent buying its own macros. None is owed; each is a door.

Every universal claim in this paper ("every terminal", "no change-detector",
"can only") is discharged in the claims register below, against an executed
witness or a named falsifier.

## 10. The terminus

With this paper the demonstration tier closes and, per `EXACT_PLAN.md` §13.0,
**the roadmap terminates.** The three parts of step 5, as they stand: the A-gate
reading was executed (OB-12's differential run, 95k live events) and ruled at the
X.5 sitting — *A stays closed, B stays out* — and posted to its consumer; the
benchmark is landed and its band is measured-blank (§8); this paper is the third.
After the terminus, everything is demand-gated residue (§9). Custody is unchanged:
this is a builder draft; the author's review, MANIFEST re-sign, and terminus tag
are the attestation, and no frozen file was touched in writing it.

## 11. Closing reviewer block

Run from a clean checkout at the repo root; the chain re-verifies every claim
above from its frozen source.

```
sh test-paper/check.sh                 # thesis fidelity, all 30 pins, pointers, register
cabal test exact-acceptance            # §2  the four gates (T1–T4)
sh audit/ablation.sh                   # §3  necessity — all ten terminals, both halves
cabal test battery                     # §4  sufficiency — the interpolation
cabal test lawful && cabal test dyadic # §5  exactness — the == laws
cabal test trampoline                  # §6  closure — E4
cabal test wire                        # §7  the wire's fail-closed conformance
cabal build proplang-host              # §7  a live host: build it, then
sh test-paper/hello9.sh                #     drive it with the all-nine-form hello
sh audit/run-gates.sh                  # §1,§2  gate 4's forbidden-token scan, and the rest
# §8  the cost: bench/bench-fold-depth-r01.md (the band stays the owner's)
sha256sum -c MANIFEST.sha256           # the frozen layer is intact
sh test-paper/check.sh --close         # freeze state: manifest covers this paper, terminus tag verifies
```

`sh test-paper/hello9.sh` regenerates `test-paper/hello9-transcript.txt`; that
regeneration is the standing identity row for §7 under the generator exemption,
and `test-paper/check.sh`'s `G1` row enforces it.

`test-paper/check.sh --close` is red until the author's close completes; base
mode is green the moment this paper's pins agree with the oracle.

---

## Claims register

Every headline claim, tagged **EXECUTED** (a run witnesses it, transcript
named), **ARGUED** (no run; cheapest falsifier named), or **QUOTED** (a frozen
text's own words). The unwitnessed-assertion law: nothing universal stands here
unwitnessed.

<!-- claims-register-begin -->

| claim | witness | tag |
|---|---|---|
| §0 thesis: adaptivity is made sayable, not built | `brief.md` §0, byte-exact quote | QUOTED(brief.md) |
| §1 the wire speaks nine forms, two of them derived names | `membrane-wire.md`; `parseSaidWith` in `src/PropLang/Host.hs` | EXECUTED(sh test-paper/hello9.sh, leg 2) |
| §1 the alphabet is ten `Expr` terminals, each with one ablation seat | `src/PropLang/Syntax.hs`; `test-pin/ablation/`, `audit/ablation-exact/` | EXECUTED(sh audit/ablation.sh) |
| §1,§2 no `detect`/`forget`/`window`/… token in `src/` | gate 4 over `audit/forbidden.txt` | EXECUTED(sh audit/run-gates.sh — `CLEAN (9 file(s) scanned)`) |
| §2 T1 the MAP is the closest SAYABLE change-point sentence, both rates right | `test_output.txt`; `test/Anchors.hs`; grids in `test/ExactReference.hs` | EXECUTED(cabal test exact-acceptance) |
| §2 T1 it is wrong at exactly one tick (t=60), because tau=59 is off the grid and `Gt` is strict | `test/ExactReference.hs` `tauG`; `test/Streams.hs`; `src/PropLang/Eval.hs` `Gt` | ARGUED(falsifier: a declared tau grid containing 59, on which the residue must vanish) |
| §2 T1 consultation happens at startup and across the change, and nowhere else | `test/Anchors.hs` `t1ConsultTicksX` | EXECUTED(cabal test exact-acceptance) |
| §2 T2 a dearer clock buys strictly fewer ticks (1/3/12/12) | `test/Anchors.hs` t2RowsX | EXECUTED(cabal test exact-acceptance) |
| §2 T3 the agent beats every forgetter on drift, including drift-optimal `g=0.95` | `test/Anchors.hs` t3 rows | EXECUTED(cabal test exact-acceptance) |
| §2 T3 the agent LOSES on flat to `g=1.0` by 0.78 nats | `test/Anchors.hs` `(1 % 1,397.92621119190125,350.330276640413)` | EXECUTED(cabal test exact-acceptance) |
| §3 every terminal's deletion costs a capability | `audit/ablation.sh`; `test_output.txt` deletion table | EXECUTED(sh audit/ablation.sh) |
| §4 sufficiency: the agent is Bayes-optimal at each interior point the suite walks | `test-battery/Battery.hs` | EXECUTED(cabal test battery) |
| §4,§9 sufficiency is NOT proven for every conceivable world | the suite's printed residual | ARGUED(falsifier: a world in the declared family where the walked agent is not the Bayes-optimal sentence) |
| §5 correctness is decidable by `==`, no tolerance | `KERNEL.md`; `test/Properties.hs` | EXECUTED(cabal test lawful, dyadic) |
| §5,§7 exactness DECIDES a live act: tick 0 is a strict argmax at ~6.2e-18, not a tie | `test-paper/hello9-transcript.txt` leg 1b (sign inversion flips the act) | EXECUTED(sh test-paper/hello9.sh) |
| §7 the frozen tie convention is intact: on a genuine tie the FIRST-LISTED entry survives | `test-paper/hello9-transcript.txt` leg 1b (constant utility, four grid orders) | EXECUTED(sh test-paper/hello9.sh) |
| §6 metareasoning is sayable and pinned to the one policy rule | `test-trampoline/Trampoline.hs` | EXECUTED(cabal test trampoline) |
| §7 the same reasoner serves a live wire client, and adapts over the wire | `test-paper/hello9-transcript.txt` leg 1 (act flips, loss 1.0 → 0.25) | EXECUTED(sh test-paper/hello9.sh) |
| §7 the wire refuses retired forms, belief-scoped heads, off-arity `var` | `test-paper/hello9-transcript.txt` leg 2 | EXECUTED(sh test-paper/hello9.sh) |
| §7 an undeclared read in a utility is refused at the door, latent branch included | `test-wire/Wire.hs` w1, w2; transcript leg 3 | EXECUTED(cabal test wire — 10/10, w1/w2/w5 red pre-increment) |
| §7 a refused hello leaves a live session, not a dead host | `test-wire/Wire.hs` w5 | EXECUTED(cabal test wire) |
| §7,§9 fail-closed is witnessed over a WALKED set of wire surfaces, not proven total | legs 2–3; the door probes | ARGUED(falsifier: a declaration the door accepts that no `Expr` can evaluate totally) |
| §8 every measured exponent partly reads the fold representation; dyadic too | `bench/bench-fold-depth-r01.md` r02.4 (19.8 bits/tick, the 81x collapse) | EXECUTED(ProbeStateBits; `chooseeu-sitting/r2-f11-state-bits.txt`) |
| §8 the intrinsic per-tick cost at bounded state is unmeasured | no cell measures it | ARGUED(falsifier: a fold with bounded sufficient statistics, benchmarked on the same profiles) |
| §9 the residue is named, not scheduled; nothing owed | `EXACT_PLAN.md` §13.0 | QUOTED(EXACT_PLAN.md) |

<!-- claims-register-end -->
