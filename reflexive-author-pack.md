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
