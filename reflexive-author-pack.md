# reflexive-author-pack.md — step 10: reflexive closure (A7)

> Builder pack, opened 2026-07-18 (the day after elim-freeze-r0). Step 10
> is brief §2's headline — *the policy enters the action space; computation
> cost is a MEASURED feature; heuristics emerge as optimal acts.* Its
> roadmap charter (AGENT_PLAN §7 step 10) carries THREE unconditional
> return rows (g1d, VPre's preposterior identity, VThinkK — D-f4 cluster),
> the deferred PilotEU §1b classification (step-6 r2), and the horizon —
> *depth-as-priced-choice lands here or nowhere* (D-e7, step 8).
>
> Rulings R-D20/21/22 and every CLAUDE.md clause bind. The measurement
> below is R-D21 throwaway (prototypes discarded; transcribed here). The
> discipline is measure-before-design (the step-8 r1 carry, honored):
> numbers first, design after.

---

## Part I — the measurement, FIRST (E-g1): is the world-rollforward sayable now?

### §1. Why this measurement, and why now

Step 8 banked a case file (outcome-author-pack §9) whose verdict grounded
two later rulings — D-e7 ("the horizon lands at step 10 as depth-as-priced-
choice, a production with a price") and D-f4 (step 9's three return rows,
"requires the world-rollforward endo-kernel ... the `Real a` wall"). That
verdict, verbatim:

> "The fuse dynamics need the body to INSPECT the bound state ... Only
> constant and identity-dispatch kernels inhabit `K Features Features`.
> The demonstrated failure the primitivity gate demands is on the record."
> (outcome-author-pack §9, Part B)

**Two facts make that verdict a HYPOTHESIS to re-test, not a settled
fact, at the step-10 boundary:**

1. The step-8 composition attempt (CompAttemptB.hs, §9) tried exactly two
   body forms — `Get "pending" (Var Z)` and `Gt (Var Z) (gk 0.5)` — and
   **never tried `Pos`** (`Pos :: Eq a => Space a -> Expr env a ->
   Expr env Double`, Syntax.hs:259), which projects a bound value of ANY
   Space'd type — including a `Features` state — to a `Double` index.
   `Pos`, full arithmetic (`Add`…`Neg`), and the `eqE` composition
   (`If`/`Gt` over `Double`s) were ALL shipped by step 1 and present at
   step 8.
2. Step 9 changed the alphabet underneath the verdict — deleted `IsEq`
   (the "only Features eliminator" the verdict named), landed `Expect`,
   `SawE`, `ElimJ`, `Code`.

So the measurement is executed against the SHIPPED post-step-9 `src/`
(commit c98e74c), three throwaway compile witnesses under `ghc -isrc`
(the L7 form), flags as the future gate demands.

### §2. The three witnesses (executed 2026-07-18; discarded per R-D21)

**WitnessA — the `Pos`-index transition endo-kernel (COMPILES CLEAN).**
`Code stateSpace stateSpace body` over `K Features Features`, with the
body reading both bound Features points via `Pos` and computing the
transition code-length by arithmetic + `eqE`:

```haskell
transBodySucc =                       -- "y is x's index-successor"
  If (eqE (Pos stateSpace (Var Z))    -- codomain point y  -> its index
          (Add (Pos stateSpace (Var (S Z))) one))  -- x's index + 1
     (Sub one one)                    -- 0 bits: the successor
     (Add hundred hundred)            -- large: everything else
transKernelSucc = Code stateSpace stateSpace transBodySucc
  :: Expr env (Maybe (K [(Name,Double)] [(Name,Double)]))
```
`ghc -isrc WitnessA.hs` → exit 0. **The endo-kernel is inhabited by far
more than "constant and identity-dispatch" — every `Pos`-index kernel is
sayable.** The step-8 verdict is TOO STRONG as a general claim.

**WitnessB — named-component projection of a bound state (EXACT TYPE
ERROR).** Reading a NAMED sub-feature of a bound Features value:
```haskell
compBody = If (Gt (Get "pending" (Var Z)) ...) ...
```
```
error: [GHC-83865]
  The function 'Get' is applied to two visible arguments,
    but its type 'Name -> Expr env Double' has only one
  In the first argument of 'Gt', namely '(Get "pending" (Var Z))'
```
`Get` reads the AMBIENT environment; there is no projection
`Name -> Expr env Features -> Expr env Double`. **This half of the step-8
finding STANDS, re-confirmed against the post-step-9 grammar** — it is
the genuine, narrow limit.

**WitnessC — end-to-end depth-k deliberation-and-choose (COMPILES
CLEAN).** Belief over a scalar latent (env-bound), an action-dependent
transition kernel SELECTED by the contemplated action, `Push`ed forward
k times, `Expect` at the horizon, `Argmax` over actions:
```haskell
deliberate k = Argmax (Var Z) (Expect (rollforward k) utilBody)
  where trans = If (eqE (Var Z) one) transA transB   -- action-dependent
        rollforward n = iterate (`Push` trans) belief0 !! n
d1, d3, d5 :: Expr PolEnv Double      -- all compile
```
`ghc -isrc WitnessC.hs` → exit 0. **Arbitrary-depth deliberation is a
COMPOSITION of the shipped alphabet.** The `Real a` wall on `Expect` is
satisfied because the latent axis is scalar (`Real Double`); depth-
unrolling is not the obstacle (proof (i), re-confirmed with the horizon
binder).

**Corroboration from the frozen corpus (not a prototype):** the shipped,
frozen `t3MoveGolden` (test-sentence/Sentence.hs:520 — the random-walk
MOVE code) IS ALREADY a `Pos`-index rollforward kernel: it reads
`('pos',('var',0))` and `('pos',('var',1))`, does arithmetic on the
positions (the drift rate `('c','rho',3)`), and emits a code length. A
model rolled forward, expressed as a sentence, frozen since step 1.
WitnessA is not hypothetical; its exact shape ships.

### §3. The synthesis (the finding that reshapes the step)

The step-8 banked verdict — "the world-rollforward needs an endo-kernel
the type surface refuses" — is **false as a general claim.** Precisely:

| carrier of the rolled-forward state | rollforward | status |
|---|---|---|
| scalar latent axis (`B Double`) — the walk, test-2 lazy-genius, the preposterior belief | `Push` + `Pos`/`ToR`/arithmetic + `Expect` + `Argmax` | **fully sayable, shipped machinery** (WitnessC; t3MoveGolden) |
| any Space, whole-state index transition (`K a a` via `Pos`) | `Pos` index + arithmetic + `eqE` | **sayable** (WitnessA); short iff the successor is an index formula, else a long index-map (a description-length matter, not expressibility) |
| structured Features state, SHORT component-wise transition | needs `GetV :: Name -> Expr env Features -> Expr env Double` | **inexpressible** (WitnessB) — the one genuine, narrow gap |

**Consequences for the step's charter:**

- **The horizon (depth-as-priced-choice) lands as a COMPOSITION.** Under
  the primitivity two-sided gate, clause (a) (a demonstrated FAILED
  composition) does not fire for the horizon — the composition SUCCEEDS
  (WitnessC) — so NO codeword is licensed. `prodExpr` stays 20; no
  alphabet motion. D-e7's "a production with a price (0.0740 bits/node)"
  expectation is resolved in the composition direction.
- **The three return rows (g1d, VThinkK, VPre) re-compose with no
  alphabet motion**, over the scalar latent axis where the machinery is
  complete.
- **The only open primitivity question** is component-projection
  (`GetV`), needed ONLY for the SHORT transition of a genuinely
  structured multi-dimensional state — and even there the index-map form
  is expressible. WitnessB IS the demonstrated failed composition (gate
  clause (a) discharged); what clause (b) and the demand-gate ask is
  whether any world in the brief NEEDS it.

---

## Part II — the opening register (D-g1..), recommendations from §1

| id | question | builder recommendation |
|---|---|---|
| D-g1 | **THE HORIZON: production or composition?** §2/§3 measured the depth-k deliberation as a composition (WitnessC). | LAND IT AS A COMPOSITION. prodExpr stays 20; no alphabet motion. The step-8 D-e7 "production with a price" expectation is overturned BY MEASUREMENT — the composition attempt SUCCEEDS, so the gate licenses no codeword. Oracle = a test-10 depth-k deliberation-and-choose suite + the numeric race (below). |
| D-g2 | **THE THREE RETURN ROWS (D-f4).** g1d (test-2 lazy-genius tick counts), VPre's preposterior identity, VThinkK's verb/worker identity. | RE-COMPOSE all three over the scalar latent axis (the WitnessC shape), as fresh shipped-composition oracles (the test-elim form). No un-retirement of test-prepost/test-ladder; the primitives stay DISCHARGED-PERMANENT, only the CAPABILITY returns. |
| D-g3 | **THE COMPONENT-PROJECTION BINARY** — the one genuine open primitivity question (§3). | **THE AUTHOR'S CALL (the D-e7/N4 shape).** (A) horizon-as-composition is the WHOLE of step 10; the structured-state SHORT transition is printed as a scope limit (the N4 scope-line default), the index-map form noted as its expressible-but-long fallback; OR (B) ALSO land `GetV` (component projection) — clause (a) is discharged (WitnessB), so this needs clause (b) (in-increment ablation) AND a demand: a brief-required world that genuinely needs structured-state SHORT transitions. Builder recommendation: **(A)** — no brief world demonstrated to need (B); the fuse (step 8's) was a deliberately structured falsifier whose myopia was already printed as a scope limit (N1/g3). (B) stays banked with its license, exactly as the kernel-composition production was banked at step 8. |
| D-g4 | **THE PilotEU §1b CLASSIFICATION** (deferred step-6 r2). Is the step-6 selector sayable in-language now? | The per-candidate `predictive (feats ++ a)` read is a read of the agent's OWN meta-state (reflexivity); WitnessC's deliberation reads an ENV-BOUND belief, not the live agent. So the selector's re-read is STILL not sayable → membrane-side general route, printed PERMANENT (retire-until-N discharged). g2 (frozen since stream-freeze-r0) stands as its two-route pin. TO BE CONFIRMED against the as-built oracle before the verdict freezes. |
| D-g5 | **THE NUMERIC RACE** — does the composition BEHAVE, not just type-check? | Pre-state criteria BEFORE any run (the 6b discipline): a scalar-latent world where depth-k lookahead beats the myopic rule; deliberation acts where myopia refrains; regret vs an oracle floor. Executed as an oracle-phase evidence program (R-D21), criteria numeric and committed at the design commit. (Drafted in Part III, next.) |
| D-g6 | **FROZEN-LAYER INVENTORY** (standing boundary event). | `AGENT_PLAN.md:1245` still says V is "DEAD — AND DANGLING ... must be formally CANCELLED" — FALSIFIED by `v-cancelled` (ea891f0, author-signed 2026-07-15; §8b OPEN 12 already marks it discharged). Repair in-place at the sitting under the boundary key, the falsified sentence quoted inside its repair. Full inventory sweep rides the sitting. |

### §4. What runs next (before the sitting)

- Part III — the numeric evidence program (D-g5), criteria pre-stated,
  executed on a throwaway prototype (R-D21), on the SCALAR case where the
  composition is complete.
- Part IV — the full frozen-layer inventory sweep (D-g6) and the boundary
  audit's triage (M5: D-f4 cited 6× / 0 def lines — a pack-homed ruling;
  H: gauss/observe_batch/residuals — forward-declared B/C surface, unbuilt).
- The sitting: D-g1..D-g6 ruled; the red-team mandates (six fresh-context
  reviewers) and the boundary audit ride the sitting per CLAUDE.md.

**THE INFLECTION THIS PACK REPORTS:** step 10 as chartered expected to
LAND A PRODUCTION for the horizon (D-e7). The measurement overturns that:
the horizon is a COMPOSITION, the alphabet does not move, and the one
genuine open production (component projection) has no demonstrated brief
demand. If the author concurs (D-g1 + D-g3(A)), step 10 is the SMALLEST
possible closing of the brief's headline — the language was already big
enough, and the proof is that its own frozen walk-code has been rolling a
model forward since step 1.

---

## Part III — the behavioral proof (E-g2), executed 2026-07-18

The type-level measurement (Part I) said the deliberation composes. Part
III proves it BEHAVES — reproduces the frozen lazy-genius anchor — against
the shipped engine. R-D21 throwaway (scratchpad/step10/Delib.hs), discarded;
the transcript is here and the FROZEN form is test-reflexive/Reflexive.hs.

### §5. The composition (no Call/stdlib — deleted at step 9)

- `v_act(b) = max_a E_th[util(a,th)]` = `If (Gt eR eL) eR eL`, where
  `eR = Expect b (2th-1)`, `eL = Expect b (1-2th)` (util(R,th)=2th-1,
  util(L,th)=1-2th; tests_acceptance.py:146-148).
- `v_think(b) = sum_s max_a E_th[ P(s|th)*util(a,th) ] - price` — the
  COND-FREE PULL-THROUGH of the preposterior. The identity, exact:
  `contrib(s) = P(s)*max_a E[util(a,.|s)]` (Python: `exp(lp)*v_act(cond..)`)
  `= max_a sum_th P(th) P(s|th) util(a,th) = max_a E_th[P(s|th)*util]`,
  since P(s) is constant over the max. So NO cond / SawE / ElimJ / Obs-Int:
  `P(s|th) = prod_i (th if s_i==1 else 1-th)` is a Double factor in the
  Expect body, and the 8-way (2^3) sum is eight `If/Gt` maxes added.
- **The clock is a FEATURE, not a constant** (`Get "price"`), exactly as
  A7 demands (AGENT_PLAN:382-385: "the cost of a computation must be
  MEASURED and published as a feature — never declared as a constant");
  this is the Python POLICY's own `("get","price")` (tests_acceptance.py:177).

### §6. The transcript (both routes, vs the frozen anchor t2Rows)

```
price  | (R) reference | (S) sentence  | anchor t2Rows
-------+---------------+---------------+--------------
0.3    | (1,"L")       | (1,"L")       | (1,"L")  OK
0.05   | (3,"L")       | (3,"L")       | (3,"L")  OK
0.005  | (12,"L")      | (12,"L")      | (12,"L") OK
0.0    | (12,"L")      | (12,"L")      | (12,"L") OK

vActS vs vActR  : BIT-EXACT on every trajectory belief.
vThinkS vs vThinkR (batchN=3): max relative residue 7.58e-17 (sub-ulp) --
  the pull-through is algebraically exact, float-reassociated only because
  the worker divides by P(s) in cond and the composition never divides.
  The anchor's decision margin is 1.5e-3 (min |v_act - v_think|), eleven
  orders above the residue: no decision can flip.
```

- (R) = the reference route (Belief-API worker: `expect`/`cond`/`logPredict`
  — the semantics the deleted verbs wrapped).
- (S) = the sentence route (the composition, via the shipped `evalx`).
- Both reproduce t2Rows exactly. **The three return rows (D-f4) are ONE
  re-composition seen three ways, all discharged:** g1d = the end-to-end
  tick counts; VPre's preposterior identity = `vThinkS` IS the preposterior
  value; VThinkK's verb/worker identity = the sentence == the sealed-engine
  worker (g3). The primitives stay DISCHARGED-PERMANENT; the CAPABILITY
  returns as a composition.

### §7. The oracle (test-reflexive/, 9 rows, GREEN on shipped src)

Step 10 is a PIN-FREEZE (the step-2 clause): an already-shipped capability,
no implementation owed. The oracle is GREEN against the shipped src with
NO src diff — which IS the proof of D-g1 (the horizon is a composition; the
language was already big enough). The red-run clause is satisfied by
seeded defect (g4), not a runtime-red implement cycle. Groups: g1 (anchor
reproduction), g2 (the form: render golden + cond-free structural pins),
g3 (verb/worker two-route identity), g4 (two seeded defects, two faces).

### §8. SAT / flag-faithfulness (L5)

The oracle runs under the frozen `warnings` common stanza — the exact
gate-1 set: `-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns`
(proplang.cabal `common warnings`), GHC2021, GHC 9.10.3. `test-reflexive`
builds and passes under this set (two -Werror lints caught and fixed in
the build window: a redundant `Name` import and a partial `head`). The
overlay-build lint (L7) builds every test .hs — test-reflexive included —
against the shipped src: PASS.

---

## Part IV — the boundary events (frozen-layer, audit, register)

### §9. The frozen-layer inventory (D-g6; repairs under the sitting key)

Falsified frozen NORMATIVE prose the step-10 measurement convicts. Repairs
execute at the sitting under the boundary key, the falsified sentence
quoted inside its repair (the FROZEN-LAYER INVENTORY clause).

| id | site | falsified text | repair form |
|---|---|---|---|
| J1 | AGENT_PLAN.md:1245 | V "DEAD — AND DANGLING RIGHT NOW ... V must be formally CANCELLED by the author at this boundary" | FALSE since v-cancelled (ea891f0, author-signed 2026-07-15; §8b OPEN 12 already `DISCHARGED`). In-place, quote-inside-repair. |
| J2 | AGENT_PLAN.md:1140-1150 (step-10 charter, D-e7) | "THE HORIZON LANDS HERE ... depth-as-priced-choice ... its price 0.0740 bits/node" — the horizon expected as a PRODUCTION | OVERTURNED by E-g1/E-g2 (Part I/III): the horizon is a COMPOSITION, prodExpr stays 20. Repair records the measurement's verdict per D-g1's ruling. |
| J3 | test-sentence/Sentence.hs:454-458 (g1d retirement) | "the deliberation POLICY needs ... the world-rollforward endo-kernel and sentence-level expectation over structured carriers — the 'Real a' wall" | FALSE: the endo-kernel is sayable (WitnessA); the composition works over the SCALAR latent where Real holds (WitnessC, Delib). This is a FROZEN test comment — repaired only at the sitting, dated bracket. |
| J4 | test-actions/Actions.hs:83-85 (g3 retirement) | "the verb/worker identity is the D-f4 step-10 preposterior re-composition cluster ('Real a' wall)" | The cluster LANDED as a composition (g3); the 'Real a' wall was never the obstacle. Dated bracket at the sitting. |
| J5 | AGENT_PLAN.md:1383-1385 | "Not sayable: the world-rollforward. A hypothesis is context -> Obs, not an endo-kernel on features, so pushing it five times is not type-correct. There is no kernel-composition ... among the 21." | FALSE AS A BLANKET: WitnessA compiles a Pos-index endo-kernel and WitnessC pushes an env-bound K five times, type-correct; the frozen walk move-code IS a shipped endo-kernel. TRUE only in the NARROW structured-component case (WitnessB). NB the SAME section already says the right thing at :1381-1382 (depth-unrolling sayable) and :1386-1389 (horizon is O(k) nodes, depth is a priced act) -- the repair corrects :1383-1385 to the narrow limit and lets the section's own reasoning stand. In-place, quote-inside-repair. |
| J6 | design.md:248 | "the 'Real a' wall -- world-rollforward endo-kernel + sentence-level expectation over structured carriers" (inside a dated bracket) | The re-composition LANDED without the wall being the obstacle (the scalar axis satisfies Real). Dated supersession note appended inside the existing bracket. |

Note J3/J4 are frozen TEST comments (manifest-covered); by the inventory
clause they are touched ONLY at the boundary, under the key, as dated
brackets — never a standing license.

### §10. The boundary audit triage (ran 2026-07-18, rides the sitting)

`tools/boundary-audit.sh`: **M5=1, H=5.** Triage inputs, not verdicts:
- M5 FLAG `D-f4` cited 6x / 0 definition lines — a PACK-HOMED ruling
  (elim-author-pack §11 draft + §13 register — NOT §17, which is
  D-f13/f14; pointer corrected per red-team mandate 2), cited forward
  into AGENT_PLAN §7. Its
  definition site is the elim pack, not a normative doc; benign, but the
  human sweep confirms the pack home is real (it is — the three return
  rows this step discharges ARE D-f4).
- H FLAGS `gauss / observe_batch / residual_mean / residuals /
  sensitivity` — forward-declared wire surface of the UNBUILT HOSTS_PLAN
  increments B (reliability) and C (arithmetic). Declared, not
  load-bearing; expected. No step-10 symbol is unresolved.

### §11. The as-built register (D-g1..D-g6 answered by the increment)

| id | as-built answer |
|---|---|
| D-g1 | HORIZON = COMPOSITION. Confirmed: test-reflexive green on shipped src, NO src diff, prodExpr 20 unmoved. The step-8 D-e7 production expectation is overturned by measurement. |
| D-g2 | THREE RETURN ROWS re-composed (g1/g3), reproduce t2Rows; primitives DISCHARGED-PERMANENT. |
| D-g3 | THE BINARY — awaits the author. Evidence for (A): the composition BEHAVES (§6), and no brief world needs component-projection (GetV). (B) stays banked with clause (a) discharged (WitnessB). Builder recommendation: (A). |
| D-g4 | PilotEU §1b: the composition reads an ENV-BOUND belief (Var Z), never the live agent — the selector's reflexive re-read stays UNSAYABLE; membrane-side PERMANENT; g2 (frozen) the pin. Confirmed vs as-built. |
| D-g5 | THE NUMERIC RACE: executed (§6). Composition reproduces 1/3/12/12 through evalx; residue 7.58e-17 vs the worker, margin 1.5e-3. |
| D-g6 | FROZEN-LAYER INVENTORY: J1-J4 (§9), repairs at the sitting under the key. |

### §12. What needs the author (the sitting + the key)

1. **Rule D-g1/D-g2/D-g4** (the measurement's verdicts) and **D-g3** (the
   one genuine binary — (A) recommended). 
2. **The frozen-layer repairs J1-J4** (§9) — under the boundary key.
3. **Confirm the freeze naming** (`reflexive-freeze-r0`, this pack) and the
   **red-team mandates** (§13, six fresh-context reviewers — findings ride
   this pack).
4. **Extend and re-sign MANIFEST.sha256** to cover proplang.cabal (the
   reflexive stanza) and test-reflexive/ — gate 6 is expected-RED until
   then (NOT papered). From that signature the oracle is frozen.
5. **The author's signed `reflexive-freeze-r0` tag** — the attestation.

**THE SHAPE OF THE CLOSE:** if the author concurs with (A), step 10 closes
the brief's HEADLINE (reflexive closure, A7) as a PIN-FREEZE with ZERO
alphabet growth and ZERO src diff — the deliberation the whole roadmap was
built toward turns out to be a sentence the language could already say. The
horizon, the preposterior, and the lazy genius are all `Expect`, `If/Gt`,
and arithmetic over an env-bound belief, with the clock priced as a
published feature exactly as A7 demands.

---

## Part V — the red-team mandates (six, fresh-context, executed 2026-07-18)

Six INDEPENDENT reviewers (fresh state, one mandate each — the CLAUDE.md
execution mode). Findings ride this pack; the actionable ones were fixed
IN THE WINDOW (the oracle is not yet frozen), the rest ride to the sitting.

| # | mandate | verdict | finding / action |
|---|---|---|---|
| 1 | theorem-as-definition (Savage) | CLEAR | the pull-through identity is MEASURED not asserted; g3's two routes are genuinely independent (nonzero 7.58e-17 residue proves distinct code paths — divide vs no-divide); t2Rows frozen-imported (no R-D20-i violation). Caveat: g1 is the sole pin to frozen EXTERNAL truth; g3 is a builder-vs-builder algebraic cross-check (adequate — g1 anchors correctness, g3 adds identity confidence). |
| 2 | ruling cited / derived 0 (M5) | NO DEFECT | D-g1..D-g6 each defined + as-built; D-f4 has a real home (elim-pack §11 draft + §13 register) — the boundary-audit flag is a regex blind spot, not a phantom. One minor: the pack mis-cited D-f4's home as §17; **FIXED** (§11/§13, pack §10). |
| 3 | load-bearing quantity defined nowhere (H) | ONE FINDING, FIXED | g3 re-declared the price grid `[0.3,..]` instead of projecting the imported `t2Rows` (R-D20-i / probe-discipline). **FIXED** (`[ p | (p,_,_) <- t2Rows ]`). Two magic constants de-scattered: `batchCap` named with provenance; the cap-12 assertion now `length buffer36 \`div\` batchCap`. The 1e-12 gate (frozen repaired-CL-4) and the render golden (captured) both cleared. |
| 4 | type without derivation (Util) | PASS | git-confirmed: NO src .hs changed, NO new type declared, prodTable 20/1 unmoved. The pin-freeze claim survives — no type arrives, so the §8c trigger never fires. |
| 5 | convention silently overloaded | TWO ITEMS | F1: a vacuous `assertBool ... True` whitelist no-op — **FIXED** (now a genuine positive-coverage check + the "only" is the cond-free negative test). F3: the novel pull-through had no seeded defect — **FIXED** (g4 now has a third defect: a corrupted likelihood factor breaks g3's identity). g4's red-run confirmed genuine + partitioned; the `cond` boundary, price-as-feature, and g3 "worker" naming all honest. F2 (below) rides the sitting. |
| 6 | what is it a function of? | PASS (stronger) | vActS = f(belief, grid constants), reads NO features; vThinkS = f(belief, feature "price", host batchN, grid constants). D-g4 CONFIRMED and STRONGER: no reflexive read is expressible STRUCTURALLY — `Env` carries no agent (Eval.hs:65), so the absence is a property of the evaluator type, not just this composition. Note folded into `batchCap`: the batch SIZE is host-chosen (world-structural), the DEPTH is the priced think/act choice IN the sentence. |

### §13. For the sitting's ratification list (F2)

**PIN-FREEZE, extended.** The step-2 clause defines a PIN-FREEZE as pinning
an already-shipped **fast path**. Step 10 pins an already-shipped
**capability** (the deliberation composition), no implementation owed — the
same structure (pin the shipped thing to the reference route + seeded-defect
for red), applied to a capability rather than an optimisation. The
invocation is explicit, not silent (mandate 5, F2). **The author ratifies
(or amends) this reading of the clause at the sitting** — it is the one
convention this increment stretches.

### §14. The manifest delta (turnkey, for the freeze re-sign)

Gate 6 is expected-RED until the author's re-sign (NOT papered). The delta
over the frozen MANIFEST.sha256 (64 rows) is exactly two entries:

```
CHANGE  proplang.cabal
  from  183a01f4907159095b7e1953fdca77230a4639f358700934181d9e35b34a7ddf
  to    af04b51de73ecd80853902a97d7516209ee37894ae9c209dc118f51be4bf67b8
ADD     test-reflexive/Reflexive.hs
        1e8f848263e4efd406f57063a8395c1b43483950274618ec615fba947d206b00
```

(reflexive-author-pack.md is working material, not manifest-covered; the
scratchpad witnesses are R-D21 throwaway, discarded.) After the re-sign,
`sha256sum -c MANIFEST.sha256` passes at 65 rows and the oracle is frozen.

---

## Part VI — the sitting (2026-07-18): rulings received, repairs executed

The author ruled the full register at the sitting and directed the frozen
edits with verbatim text. The builder executed the content edits (builder
key, this section the record); the author reserves the manifest re-sign and
the `reflexive-freeze-r0` tag ("I'll re-sign to 65 rows and the tag
follows"). The rulings, operative:

- **D-g1 — the horizon is a composition; ruled as measured.** No codeword
  licensed, prodExpr stays 20. Depth-as-priced-choice delivered literally:
  depth = the number of `Push` iterations in the sentence, each a different
  price in bits and clock cost; the 1/3/12 tick counts are the agent buying
  deliberation at the posted price. A7's "heuristics emerge as optimal
  acts" closed by transcript. (The author's own step-8 "not one production
  but a complex" sizing is overturned along with the builder's; the
  capability was zero productions, and the deferral bought the boundary at
  which the re-measurement became possible.)
- **D-g2 — approved.** The three return rows as one re-composition seen
  three ways; the unconditional-return obligation honoured in full; the
  primitives stay in their graves while the capability walks.
- **D-g5 — verified.** The pull-through is exact (P(s) constant over the
  max; the cond-free form never divides — which is WHY the residue is
  sub-ulp reassociation). Mandate 1's observation kept: the nonzero
  7.58e-17 is itself the proof the two routes are distinct code paths.
- **D-g3 — ruled (A).** WitnessB banked as clause (a)'s discharged license;
  `GetV` waits as the kernel-composition production waited at step 8, with
  its transcript attached. No brief world demands the structured SHORT
  transition; the index-map fallback being expressible-but-long is the
  CORRECT state under the complexity prior — a structural shortcut no world
  has demanded costs description length until demand licenses its codeword.
  The scope line prints the narrow limit with the fallback named.
- **D-g4 — approved, permanent, mandate 6's strengthening in the ruling
  text.** The selector's re-read of the live posterior stays unsayable
  BY THE EVALUATOR'S TYPE — `Env` carries no agent — so the absence of
  reflexive self-reading is a structural property of the language, not a
  gap in a sentence. Reflexive closure is delivered as the policy in the
  action space with a measured, published clock; sentences deliberate over
  env-bound beliefs; the membrane owns the live read with g2 the standing
  two-route pin. The deeper §11 open problem (hypotheses that mention the
  policy — the quine face) remains open and is named, not closed.
- **F2 — ratified**, and the reading goes into the CLAUSE not the pack:
  the pin-freeze text is amended to "fast path OR CAPABILITY" (step 10 the
  provenance), and a NEW clause is canonized — **a banked composition-
  failure expires when the alphabet moves** (a negative result is a
  hypothesis at any boundary whose terms changed underneath it,
  re-executed before relied upon; E-g1 its provenance). Both landed in
  CLAUDE.md at this boundary's touch.
- **J1–J6 approved**; executed as ruled (J1/J2 in-place quote-inside-repair;
  J3/J4 dated brackets under the key; J5 the surgical three-line correction
  letting the section's own correct reasoning stand; J6 a dated supersession
  note inside the existing bracket). Mandate fixes and audit triage accepted.

### §15. The frozen edits, executed (builder key; author re-signs + tags)

Content edits made this sitting (the manifest-affecting set):
- **CLAUDE.md** — F2 amendment (pin-freeze "fast path or capability") + the
  new clause (banked-failure-expires-when-the-alphabet-moves).
- **AGENT_PLAN.md** (unfrozen — not manifest-covered) — J1 (V resolved),
  J2 (horizon-as-composition), J5 (the "not type-correct" line corrected).
- **design.md** — J6 (dated supersession note).
- **test-sentence/Sentence.hs**, **test-actions/Actions.hs** — J3/J4 dated
  brackets (comment-only; both suites stay green, 13/13 corpus).

### §16. The manifest delta, FINAL (turnkey for the re-sign; 65 rows)

Gate 6 expected-RED until the re-sign (NOT papered). Over the frozen
MANIFEST.sha256 (64 rows):

```
CHANGE  proplang.cabal                af04b51de73ecd80853902a97d7516209ee37894ae9c209dc118f51be4bf67b8
CHANGE  CLAUDE.md                     00d3c8c3f3af3ba7137061d5c8cf2739cb3c1d14cd3c35003e034e6118e5084b
CHANGE  design.md                     e7c74358b2729b44ea9d20b70370531e636456d39a822ddb287587ede2cb793c
CHANGE  test-sentence/Sentence.hs     ec0b622a82f5f335f0a36ccb815f576dec6ae07d2e4fa3d93967bb3a482317d2
CHANGE  test-actions/Actions.hs       04872eb6ae6a16bcd99b324bdedf0db5e70585a819ea87c88c1d8e57555cc29b
ADD     test-reflexive/Reflexive.hs   1e8f848263e4efd406f57063a8395c1b43483950274618ec615fba947d206b00
```

(AGENT_PLAN.md is not manifest-covered; reflexive-author-pack.md is working
material; the scratchpad witnesses are R-D21 throwaway, discarded.) Five
existing rows change hash, one row is added → 65 rows. After the re-sign,
`sha256sum -c MANIFEST.sha256` passes and the oracle is frozen; the
`reflexive-freeze-r0` tag is the attestation.

**THE BRIEF IS DISCHARGED.** Steps 0–10: a calculator convicted and an
agent derived; the alphabet at twenty productions and one kernel form;
every survivor carrying an executed proof; the final step a pin-freeze with
zero src diff because the language was already big enough. The deliberating
agent the roadmap was built toward is a sentence — `Expect`, `If`/`Gt`,
arithmetic, an env-bound belief, and a clock read from the world like any
other fact. The residue is printed and homed: `GetV` banked with its
license, the quine face of §11 open, HOSTS_PLAN B and C unbuilt — an honest
completion, smaller than planned, sounder than hoped, its remaining
questions named rather than forgotten.
