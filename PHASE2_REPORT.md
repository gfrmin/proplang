# PHASE 2 REPORT — the implementation

Phase 2 of the CLAUDE.md protocol is complete through porting-order step
5 (Python parity). `audit/run-gates.sh --phase 2` is green: gates 1–7
all PASS. Nothing frozen was touched — the diff is exactly the five
`src/PropLang/*.hs` modules (verify: `git status`, `sha256sum -c
MANIFEST.sha256`). Step 6 (ExpFam basis, membrane, self-features,
fidelity ladder) was deliberately NOT begun, per the kickoff instruction
and the porting order's STOP line.

## 1. Gate matrix

| gate | check | state |
|---|---|---|
| 1 | `-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns` clean build of src/ | PASS |
| 2 | `PropLang.Belief` exports exactly the frozen 21-item list, `Belief` abstract | PASS |
| 3 | no `IO` token in Belief/Syntax/Eval/Enumerate | PASS |
| 4 | forbidden tokens (audit/forbidden.txt) absent from src/ code | PASS |
| 5 | acceptance (4/4) and properties (3/3) suites pass | PASS |
| 6 | `sha256sum -c MANIFEST.sha256` | PASS |
| 7 | code-level ablation: push/argmax unutterable under `-DDROP_*`, errors name the constructor | PASS |

All four acceptance tests and all three properties passed on the first
complete build — no anchor was approached iteratively, and no tolerance
was touched (they are frozen and were not needed: see §2).

## 2. Measured parity margins (external readout, not part of the suite)

A scratchpad program recomputed oracle quantities through the built
library against the frozen anchors:

| quantity | \|delta\| | tolerance | headroom |
|---|---|---|---|
| t4 full-grammar log-loss (160 ticks) | 7.1e-14 | 1e-4 | ~10^9 |
| t4 frozen-agent log-loss | 5.7e-14 | 1e-4 | ~10^9 |
| t3 agent log-loss, drift400 | 0.0 | 1e-4 | exact |
| t3 agent log-loss, flat400 | 1.1e-13 | 1e-4 | ~10^9 |
| t1 MAP posterior | 1.7e-15 | 1e-6 | ~10^9 |
| t1 / t3 MAP rendered programs | byte-identical | exact | — |

This is the payoff of porting the reference's float arithmetic operation
for operation: the same log-sum-exp shape, the same left-to-right
summation from zero, the same skip rules on zero-mass points, the same
normalize-at-construction, the same stable descending sort in `top`.
Both runtimes round through the same libm on this machine, so agreement
is at the accumulation-of-ulps level.

## 3. Decisions on the unfrozen surface (src/ internals)

1. **Hypotheses are programs of the real grammar.** `Model` is
   `MBern (Expr '[] Double) | MHmm Ix`: a Bernoulli sentence's parameter
   is a closed `Expr` built from `If`/`Gt`/`Get`/`C`, and the agent
   evaluates it with the real `evalx` under the tick features — no
   parallel model encoding. The hmm rate is a grid index rendered as
   `('c', 'rho', k)`; its description length is charged as the amended
   design.md §5 prices it (1 MODEL bit + log2 8, no PARAM-alternative
   bit), which is why it is stored as an index rather than reusing the
   generic `Expr` price of a constant.
2. **`Grid` is a name plus a nonempty point list.** `PropLang.Syntax`
   gains four exports — `mkGrid`, `gridName`, `gridSize`, `gridLookup`
   — needed by Enumerate (construction, rendering) and Eval (lookup).
   Gate 2 constrains only `PropLang.Belief`'s export list, which is
   untouched.
3. **`C` out of range reads 0.0** — the recorded partiality of `C`
   (Phase 1 report §4.6) is resolved by totality, not by a validated
   smart constructor: an off-grid index is sayable and dormant, the
   exact convention `Get` already has for absent names. `evalx` is
   total with no error site.
4. **CPP ablation extends to semantics.** The `DROP_PUSH`/`DROP_ARGMAX`
   flags guard not only the two grammar constructors but their `evalx`,
   `bits`, and render cases, so all of src/ compiles under each flag
   and only the frozen fixtures fail — deletion removes the verb and
   its semantics together.
5. **Policy-fragment pricing is a documented placeholder.** `bits` is
   total structural recursion; the model fragment carries the reference
   prices exactly (one choice bit per two-alternative nonterminal,
   log2 n per grid mention, the sole-alternative TEST free). Verb nodes
   are priced one choice bit and `Var` zero — unfrozen (no frozen test
   utters a priced policy sentence), flagged here for the step-6 review
   where the ladder makes these prices load-bearing.
6. **Residual partiality, named.** The frozen signatures
   `fromBits`/`point`/`push`/`mkAgent` admit no failure value, so
   zero-total-mass inputs (all-infinite bits, a point off its space, an
   empty enumeration) call `error` exactly where the Python reference
   raises `ValueError`. Every such site is unreachable from the frozen
   suites; `cond`'s `Maybe` remains the one designed totality boundary,
   and `observe` inherits it.
7. **`draw` samples through the sealed API.** Host-side `draw` walks
   the cumulative probabilities of `top b maxBound` — the public CL-1
   diagnostic — so even the host cannot see a log-weight; the walk
   order differs from the reference's space order but the categorical
   distribution is identical. Entropy comes from `/dev/urandom` (src/
   depends on base only, so there is no in-process generator and no
   seed anywhere in src/); this is Linux-specific and used by no test.
8. **VThink** implements the recorded fold-order contract (Phase 1
   report §4.4) verbatim: binary-counting sequence order over the given
   alphabet, `logPredict` before `cond` per outcome, `Nothing` ⇒ weight
   0, world price subtracted last.

## 4. Alphabet and protocol deltas

None. No `Evidence` constructor added, no `StdName` member added, no
`Fn` constructor introduced (`Fn` stays uninhabited; the evaluator
discharges `Expect` by empty case), no frozen file modified, no
tolerance widened, no numeric literal beyond the grid data and the
grammar's alternative-counts that the reference itself carries.

## 5. What remains (step 6, post-parity, separate reviewed increments)

`ExpFam` basis with `bern`/`rw` re-derived as stdlib names; the
membrane (interface.md §1–§3); self-features; the full fidelity ladder
with acceptance test F. Each lands as its own reviewed increment per
the porting order; the policy-fragment prices of §3.5 should be fixed
as part of the first of those reviews.
