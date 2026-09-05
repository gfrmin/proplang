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

Everything an agent does — represent a changing world, weigh how much to reason,
choose an action — is a sentence of that grammar over the sealed reasoner. There
is no `adapt`, no `forget`, no `detect_change`; the deletion audit (§3) proves
those words are absent, not hidden.

## 2. Soundness — the four gates

Soundness is the claim that the language *can only* be used for EU-maximal
decisions, and that its adaptivity is content, not machinery. Four acceptance
tests witness it (`test/Acceptance.hs`, anchored in `test/Anchors.hs`, transcript
in `test_output.txt`). Each is one world; each conclusion is a program the agent
inferred, printed and checked against a frozen anchor.

**T1 — the changing world.** A world shifts at an unknown time. The agent grows
confident, then *consults* across the change, then recovers — with no
change-detector in the loop. Its MAP program is a change-point *sentence*, and
the consult window is exactly the ticks around the shift:

```
MAP program: ('bern', ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)))  (posterior 0.64)
t1MapIndicesX = (11,0,8)
t1ConsultTicksX = [0,1,3,4,65,66,67,68,69,70]
```

Adaptation is visible in the posterior and invisible in control flow: a grep of
the language module for change-detection machinery comes back CLEAN.

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
a stationary one. The agent — carrying a *latent drift-rate*, not a decay knob —
matches or beats the best oracle-tuned forgetter on drift, and loses only where a
stationary world rewards a tuned `g`:

```
agent (latent drift-rate):     drift 339.78242360387446   flat 351.1061771452692
forgetting factor g=0.8:       (4 % 5,369.7929712967314,396.6021006870599)
agent's MAP on the drifting world: ('hmm', ('c', 'rho', 3))
```

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

Necessity is the claim that the alphabet has no dead weight: remove any terminal
and a capability the agent needs becomes unsayable. This is not argued — it is a
code-level ablation per terminal (a GADT constructor behind a CPP flag, or a
restricted enumeration), run by `audit/ablation.sh` and `audit/ablation-exact/run.sh`,
with per-terminal fixtures in `test-pin/ablation`. The deletion table
(`test_output.txt`), each row a measured loss:

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
211 vs 207 bits. Every terminal's deletion costs a capability; nothing is
content dressed as a primitive.

## 4. Sufficiency — executed interpolation

Sufficiency is the claim that the grammar can *create* Bayesian-optimal agents —
not just the four the acceptance tests exhibit, but the family between them. Four
worked examples witness a point; the completeness suite (`test-battery/Battery.hs`)
witnesses the interpolation, walking the family the four tests corner and
proving the agent is the Bayes-optimal sentence at each interior point. The four
acceptance tests are the corners; the battery is the fill.

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
*same* reasoner serves a real client over the wire. `src/PropLang/Host.hs` and the
membrane (`membrane-wire.md`) run the polling loop and the nine-form wire against
live hellos — the agent runs in the world, not only in oracle worlds. The wire's
refusals are as load-bearing as its acceptances: belief-scoped heads do not
parse, `var` is closed to the declared namespace, and the host fold routes every
decision through the sealed reasoner. `draw` and the loop live only in the host;
no `IO` reaches the reasoner's types.

## 8. The measured cost — the benchmark

Honesty requires stating what the exactness of §5 costs. The fold-depth benchmark
(`bench/bench-fold-depth-r01.md`) measures per-tick cost under exact rational
arithmetic as the belief state deepens. Per-tick cost grows as `c(t) = c0 + a·t^α`
with an exponent in a narrow band, 1.43–1.60, across the dyadic profiles — the
cost of never rounding.

The benchmark's own falsifier (ordered before any acceptance band is filled)
found the load-bearing fact: the folded state carries **O(t) bits**, so on the
real declaration `alpha_3p` = 2.44 measured an *arithmetic representation* —
denominator growth in the exact posterior — not the decision problem. The
benchmark therefore rules its own acceptance band **blank, for a measured reason,
not an absent input**: a cutover gate read against that exponent reads against the
wrong quantity. The engineering observation that removes it — a const-family fold
has bounded sufficient statistics and need not carry O(t) bits — is banked as
measurement only and re-enters, post-terminus, through the two-sided gate with a
consumer's registered demand. **The seam-swap judgement is the owner's; this
paper does not make it.**

## 9. What is not claimed

The six claims are what the artifact demonstrates; this section is what it does
not, so the demonstration is not read wider than it is measured.

- The benchmark's acceptance band is unfilled by design (§8); no pass/fail is
  claimed from it.
- Sufficiency is witnessed over the completeness suite's family, not proven for
  every conceivable world; the residual is the suite's, printed not absorbed.
- A named research programme remains, *named not scheduled*, re-entering only
  through the two-sided gate with a measurement: the quine face, the two-stream
  polarity demand (`OB-15`, `OB-19`), continuous carriers (foreclosed), and the
  brief's §6 self-compression — the agent buying its own macros. None is owed;
  each is a door.

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
sh test-paper/check.sh                 # thesis fidelity, all 16 pins, pointers, register
cabal test exact-acceptance            # §2  the four gates (T1–T4)
sh audit/ablation.sh                   # §3  necessity — per-terminal deletion
sh audit/ablation-exact/run.sh         # §3  the exact ablations (cond/expect/code)
cabal test battery                     # §4  sufficiency — the interpolation
cabal test lawful && cabal test dyadic # §5  exactness — the == laws
cabal test trampoline                  # §6  closure — E4
# §7  a live host: start src/PropLang/Host.hs, send one nine-form hello
# §8  the cost: bench/bench-fold-depth-r01.md (the band stays the owner's)
sha256sum -c MANIFEST.sha256           # the frozen layer is intact
sh test-paper/check.sh --close         # freeze state: manifest covers this paper, terminus tag verifies
```

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
| §1 the wire speaks nine forms and no belief-scoped head | `membrane-wire.md`; grep of the parser | EXECUTED(test/Acceptance.hs; membrane suite) |
| §2 T1 the MAP is a change-point sentence, consult window pinned | `test_output.txt`; `test/Anchors.hs` t1 rows | EXECUTED(cabal test exact-acceptance) |
| §2 T2 a dearer clock buys strictly fewer ticks (1/3/12/12) | `test/Anchors.hs` t2RowsX | EXECUTED(cabal test exact-acceptance) |
| §2 T3 agent matches/beats the best oracle-tuned forgetter on drift | `test/Anchors.hs` t3 rows; `test_output.txt` | EXECUTED(cabal test exact-acceptance) |
| §3 every terminal's deletion costs a capability | `audit/ablation.sh`; `test_output.txt` deletion table | EXECUTED(sh audit/ablation.sh) |
| §4 sufficiency: the agent is Bayes-optimal across the family, not just the corners | `test-battery/Battery.hs` | EXECUTED(cabal test battery) |
| §5 correctness is decidable by `==`, no tolerance | `KERNEL.md`; `test/Properties.hs` | EXECUTED(cabal test lawful, dyadic) |
| §6 metareasoning is sayable and pinned to the one policy rule | `test-trampoline/Trampoline.hs` | EXECUTED(cabal test trampoline) |
| §7 the same reasoner serves a live wire client | `src/PropLang/Host.hs`; nine-form hello | ARGUED(falsifier: a belief-scoped head that parses over the wire) |
| §8 fold cost grows 1.43–1.60; real-declaration α measures representation | `bench/bench-fold-depth-r01.md` r01/r02.4 | EXECUTED(bench/results; ProbeStateBits) |
| §9 the residue is named, not scheduled; nothing owed | `EXACT_PLAN.md` §13.0 | QUOTED(EXACT_PLAN.md) |

<!-- claims-register-end -->
