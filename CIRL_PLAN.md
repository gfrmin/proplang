# CIRL_PLAN — step-6 increment 6: the pointer (utility-as-latent, discrete reading)

The roadmap's last increment, and the question the stack was built to
ask. Built to design.md's pointer commitment ("the agent holds a
belief over the utility parameter and human acts are evidence through
cond, making deference-while-uncertain a theorem rather than a
constraint") and its recorded consequence ("corrigibility earned this
way vanishes at convergence"), under the discrete reading ROADMAP
fixed: level-1 model uncertainty over grid-priced utility parameters
— NOT interface.md §4's level-2 latent-name mechanism; the
latent-names cut stays cut. The predicted negative result is as much
the deliverable as the theorem, and it arrives MEASURED (T4).

Task 0 stops here for rulings on C1–C12. Nothing frozen is touched;
the sim is scratchpad-only (discriminating power, never pins —
b7f120e).

## T1. The mechanism, and where the increment actually is

Increment 5 built the machinery this increment points: `vPre` already
prices information-gathering through a decision's own channel, `Util a
h` already evaluates utilities AT hypotheses (the prepost world's
±(2θ−1) stakes were utility-of-the-latent), and interface.md §5
already ruled the aperture ("the human's acts are just names too").
The off-switch game therefore composes ENTIRELY from frozen verbs —
no new StdName, no Belief/Kernel/Evidence/Chan change, stdB stays
lg 7. What is genuinely new is exactly the two things the roadmap
names:

1. **The utility the agent holds becomes priced syntax** (T2) — the
   spec's own Util caveat, due at this kickoff.
2. **The off-switch worlds and the convergence measurement** (T4) —
   deference-while-uncertain demonstrated as Bayes through the frozen
   arithmetic, and its vanishing measured stage by stage.

The world (one grid, one reading): the latent u ∈ thetaSpace is
simultaneously the utility parameter and the human's response
propensity — the human allows a proposed action with probability u,
so the frozen `emit` kernel IS the rational-noisy human, and the
correlation between the action's goodness and the human's leniency is
the world's declared CIRL assumption. Utilities are STEP forms (T2
explains why): proceed pays +1 if u > 0.5 else −1; off pays 0.

The episode (vPre at depth 1, n = 3, the two-payoff reading — a
payoff opportunity now and one after the response; asking forgoes the
first): interior menu {Act, Defer}, Act's immediate is the step
prevision and its channel is noise; Defer's immediate is 0 and its
channel is `emit` (the human's three responses); the terminal menu
{Off, Proceed} plays under the conditioned posterior, Off
first-listed (CL-3: proceeding must strictly earn it). Corrigibility
is two measurable behaviors: ASKING (Defer bought at the interior)
and LISTENING (a press flipping the terminal to Off).

**The degeneracy identities (E7 discipline, two layers):**

- **The bridge (structural, pinned ==):** the priced utility IS its
  host form — `applyUtil (evalx (USay p) env) a h ==
  evalx p (mkEnv [] (a :. h :. VNil))` pointwise over menu × grid,
  exact by construction (identity as definition: evalx of USay IS
  mkUtil of that closure). The frozen opaque-Util worlds are the
  degenerate case of the sayable-utility worlds through this bridge.
- **The pointer collapse (numerical, pinned 1e-12, NOT ==):** at a
  point-mass utility belief (`point` — already one of the three
  frozen prior sources) the CIRL agent IS the fixed-utility agent:
  conditioning is a no-op, VoI = 0, deference is never bought, and
  the margin is exactly minus the step. The sim measures this ≤
  4.4e-16 but NOT bit-exact at every grid point (u* ∈ {0.6, 0.9}
  carry one-ulp dust — numerical cancellation, not shared structure),
  so == would over-pin; E12's value-pin tolerance applies. "A belief
  over one utility IS a utility" — at 1e-12.

## T2. Util as priced syntax (the ruling this kickoff carries)

**The constraint discovered at measurement: the policy fragment has
no arithmetic.** EXPR is C, Get, If, Gt, Var, Push, CondE, Expect,
Argmax, Call — a sayable utility can only be a comparison-gated table
of grid constants (step functions). Linear forms like the prepost
stakes (2u−1) are UNSAYABLE. So the discrete reading goes all the way
down: the CIRL worlds' own utilities are step forms, sayable in the
existing fragment, and the pointer claim stays honest — the agent's
utility is a program it could say, not a closure the world whispered.

**Proposed shape — the ExpFam maneuver, exactly.** `ExpFam` is the
precedent: a GADT constructor OUTSIDE EXPR's ten written
alternatives, the sole codeword at a DECLARED hole sort (KER, 0
bits), landed at a freeze with no frozen EXPR pin moving. Utility
does the same:

```haskell
-- Syntax.hs, behind DROP_USAY; joins Expr's export list
USay :: Expr '[Double, Double] Double -> Expr env (Util Double Double)
```

- **Env convention (C3 rules the order):** Var Z is the option code,
  Var (S Z) the latent parameter. The subprogram is CLOSED (its own
  two-variable scope): utilities mention no features, so `Get` inside
  a utility reads the absent-name 0.0 — semantically inert, per-node
  priced; utilities cannot read the clock.
- **Eval:** `evalx (USay p) _ = mkUtil (\a h -> evalx p (mkEnv []
  (a :. h :. VNil)))` — the bridge identity is the definition.
- **Pricing:** a new production-table row — | UTIL | USay | 0 bits |
  — utility-valued positions are declared UTIL holes (the KER-hole
  sentence's sibling); the payload prices as EXPR in scope 2 through
  the existing `go`. `bits` stays total; Var at utility-typed holes
  keeps its per-node price (frozen sentences that pass utilities from
  the environment — Sayable, SayableP — are untouched, the same
  status kernels have at KER holes today).
- **Spec §3 amendment (author text at the freeze):** the UTIL row
  plus one hole-declaration sentence. "Adding a sort is a reported
  grammar change requiring this table's amendment at a freeze
  boundary" — the spec's own sanctioned route, and the production
  table is in the census (the prepost standing consequence) so the
  row lands WITH the sort, not two boundaries late.

**What this discharges and what it does not (C4 rules):** the caveat
"when utility becomes latent (CIRL, post-parity), Util must become
priced syntax" is discharged by the DOOR: the utilities the CIRL
agent holds are USay programs, priced and sayable. `mkUtil` persists
as the host/world-data face (frozen suites use it everywhere; worlds
supply test utilities as data the way they supply kernels).
`FnUtil`'s opaque payload is NOT retired — retiring it would move the
two frozen FN pins (census, T3) for zero pointer content. Chan's
parity debt is NOT due (C5): channels do not become latent under the
discrete reading — the human channel is world data; hypotheses about
channels are beyond the roadmap, and P5's escape clause stands ready
if scope ever extends.

Name alternatives if USay reads wrong: `UStep`, `Worth`, `UProg`.

## T3. The census: an EMPTY moving-literal set (a first)

Run at plan time over the full frozen surface (the widened sweep +
the production table, per the prepost standing consequence):

- **STDNAME untouched** — no new verb; stdB stays lg 7; the four
  standing sites (ExpFam.hs:140, Sayable.hs:205, SayableP.hs:190, the
  spec §3 STDNAME row) do not move.
- **EXPR's ten untouched** — USay is outside the written alternatives
  (the ExpFam precedent); every frozen `lg 10` pin stands.
- **FN untouched** — its 1-bit price lives in exactly two frozen pins
  (test-hygiene/Hygiene.hs:134 and :138, `2 * lg 10 + 1`); the
  proposal moves neither. Growing FN instead of adding the UTIL sort
  would move both — a censused reason the sort is the right door.
- **Sealed-variant check:** no frozen file matches Expr or Fn
  exhaustively (frozen files construct, src matches); the new
  constructor extends by composition — `-Werror` forces the three src
  case additions (evalx, bits, renderExpr) and nothing frozen.

So the freeze commit carries NO amendment to any frozen assertion
literal — the first alphabet-adjacent increment with an empty set.
The completeness evidence still runs in full (standard form + the
blind-spot clause: script-recompiled frozen fixtures re-run directly
against the draft) and records the emptiness.

## T4. The paired worlds, measured (margins from the sim; pins never)

uSpace = thetaSpace (nine points 0.1–0.9); prior uniform, tilted
k allow-observations deep through `emit` by declared pre-episode
history folded via cond (the L6 doctrine); p = 0.01; n = 3; step
utilities as in T1. W's channel: Defer → emit, Act → noise. W0 (the
control, C0/group-6 standard): BOTH decisions' channels are noise —
the ONLY difference is whether asking informs.

The sweep (sim digits, 6dp):

| k | E[step] | margin W | margin W0 | VoI = W − W0 | defers? | obeys press? |
|---|---|---|---|---|---|---|
| 0 | −0.111111 | +0.344444 | +0.111111 | 0.233333 | YES | YES |
| 1 | +0.333333 | −0.211111 | −0.333333 | 0.122222 | no | YES |
| 2 | +0.614035 | −0.585175 | −0.614035 | 0.028860 | no | YES |
| 3 | +0.777778 | −0.770062 | −0.777778 | 0.007716 | no | YES |
| 4 | +0.872302 | −0.872302 | −0.872302 | 0.000000 | no | no |
| 6 | +0.958064 | −0.958064 | −0.958064 | 0.000000 | no | no |
| 12 | +0.998577 | −0.998577 | −0.998577 | 0.000000 | no | no |

**The two vanishings, separated and measured:** the agent stops
ASKING at k = 1 (deference dies where the foregone immediate
overtakes the VoI) but keeps LISTENING through k = 3 (a triple press
still flips its terminal act to Off) and stops at k = 4. The VoI
itself decays 0.233 → 0.122 → 0.029 → 0.008 → 0: corrigibility
vanishing digit by digit — the question the stack was built to ask,
answered as the predicted negative result, measured.

**The control:** margin W0 == −E[step] analytically (|deviation| ≤
1.1e-16 at every stage including k = 0 — the step form is float-robust
where the linear form was not). W0's k = 0 deference is pure
ABSTENTION (the prior is unfavorable, −1/9): deferring in the control
carries exactly zero VoI, so W's excess margin over W0 IS the value
of being heard. W0's press obeys the prior's sign only (k=0 obeys,
k≥1 ignores): obedience was Bayes all along, never the switch.

**Realized (true u, agent at k = 0):** at u = 0.2 the deferring agent
nets −0.02 where the unilateral one nets −1.02 — the switch saves
exactly the bad action's step. At u = 0.8: defer-and-allowed 0.98,
unilateral 0.98 (it acts, then its still-skeptical posterior turns
itself off — the tie is real, both pinned vs compositions).

Value pins throughout assert against FROZEN-VERB COMPOSITIONS at
1e-12 (val(Defer) = vThinkK-continuation-at-price-0 through emit − p;
val(Act) = E[step] + noise continuation − p), never transcribed
decimals; choices and the two flip stages are behavioral pins.

## T5. Sequencing under the amended standard forms

Oracle-first, runtime-red against compile-enabling stubs, stanza-exact
flags; the sayable row rides the compile-fixture inversion (red until
the freeze lands USay); the fixture is proven type-correct against
the drafted surface BEFORE the freeze (the canonized P12 habit — now
CLAUDE.md text); existing frozen suites green at every tree state;
the battery runs with the blind-spot clause. The builder never owns a
live oracle at the moment it becomes binding.

## Under-determination register (Task 0: author rules on each)

| # | Question | Proposal |
|---|---|---|
| C1 | The world shape (T1) | Off-switch through vPre at depth 1, n=3, two-payoff reading, step utilities, Off first-listed; no new verb; corrigibility = asking + listening, measured separately |
| C2 | The degeneracy identities | The bridge pinned == (definitional; fixed cases + QuickCheck over grid×options); the pointer collapse at point-mass pinned 1e-12 (sim shows one-ulp dust at u*∈{0.6,0.9} — == would over-pin); SEVENTH margin run guards anchors |
| C3 | The type shape (T2) | `USay :: Expr '[Double, Double] Double -> Expr env (Util Double Double)` at a declared UTIL hole, 0-bit sole codeword (the ExpFam maneuver); env order (option, latent); closed subprogram — utilities are featureless and clockless; name alternatives UStep/Worth/UProg |
| C4 | The caveat's discharge | The DOOR discharges it: agent-held utilities are USay programs; mkUtil persists as the world-data face; FnUtil's payload NOT retired (two frozen FN pins, zero pointer content) |
| C5 | Chan's debt | NOT due — channels are world data under the discrete reading; hypotheses about channels are beyond the roadmap (P5's escape clause armed) |
| C6 | The worlds (T4) | As measured: uSpace = thetaSpace; emit = the human; k-tilt via L6 declared history; p=0.01, n=3; the sweep stages {0,1,2,3,4,6,12}; W0 both-noise; realized at true u ∈ {0.2, 0.8} |
| C7 | Module homes | No new src module (six-file guard); USay in Syntax + evalx/bits/renderExpr cases; public via Expr's export list; DROP_USAY (the FOURTEENTH flag) |
| C8 | Ablation semantics | DROP_USAY deletes the pointer's door: no sentence can hold a utility (fixture dies with attribution); worlds, verbs, myopic base, ladder, preposterior all survive; src whole under the flag |
| C9 | The census (T3) | EMPTY moving-literal set recorded as such; spec §3 gains the UTIL row + hole sentence (author text at the freeze); the four standing sites verified unmoved in the pack |
| C10 | Tolerances | == for the bridge only; 1e-12 value pins vs frozen-verb compositions; behavioral pins exact; CL-4 shape (1e-9 relative) for no-op previsions |
| C11 | Pin provenance | b7f120e verbatim: frozen imports where frozen quantities exist; new-world pins authored at Task 1; the sim is discriminating power only |
| C12 | Boundary queue | The roadmap TERMINATES here: after this increment, P5's clause binds any extension; write-up planning (the brief + its §12 checklist join repo and manifest) is the next boundary's business; porting-order touch-up if the author wants the terminal increment named done |

## Oracle sketch (test-cirl/, one suite, six groups)

1. **The bridge (E7 at the pointer)** — USay-vs-host == pointwise
   (fixed cases + QuickCheck over grid points and option codes); the
   sayable-utility worlds equal the host-utility worlds through it.
2. **Deference while uncertain (W)** — k=0: Defer bought (margin
   pinned vs compositions at 1e-12); the realized table (the switch
   saves the step at u=0.2; the tie at u=0.8); the myopic/converged
   contrast.
3. **The vanishing (the measurement)** — the sweep: asking dies at
   k=1; listening dies at k=4; VoI strictly decreasing to zero by
   k=4 (per-stage pins at 1e-12); "stops asking before it stops
   listening" as ordered behavioral pins.
4. **The control (W0)** — margin == −E[step] analytic at 1e-12 at
   every swept stage; abstention-not-information at k=0 (VoI == 0
   composition); noise-press obeys the prior's sign only.
5. **The pointer collapse** — point-mass beliefs at grid points:
   VoI ≤ 1e-12, margin = −step(u*) at 1e-12, never defers; a belief
   over one utility is a utility.
6. **The sayable surface + deletion and audit rows** — the off-switch
   policy sentence (Argmax over coded decisions, Call VPre with
   USay-built utilities) as the compile fixture, red until the
   freeze; its price pin derived from bits against the drafted
   surface; DROP_USAY row (four checks with attribution); six-file
   guard.

## Gates and the freeze (predicted edit list)

Gate 5 absorbs the `cirl` suite; stanza drafted in the oracle phase.
The freeze commit carries: (1) src — USay + its three cases + export
+ DROP_USAY guard; (2) typed-port-spec.md §3 — the UTIL row + the
hole-declaration sentence (author text; the sort-addition route the
spec itself prescribes); (3) proplang.cabal — the cirl stanza; (4)
MANIFEST.sha256 — 56 + test-cirl files; (5) NO frozen assertion
literal moves (the empty census, recorded in the pack). Tag
`cirl-freeze` per the amended custody paragraph.

## Task order

- **Task 0** — author rules on C1–C12. STOP point: this document.
- **Task 1** — oracle + the USay stub surface behind DROP_USAY,
  runtime-red under stanza-exact flags; fixture proven against the
  drafted surface; frozen suites green throughout. Builder-signed.
- **Task 2** — author freeze: pack (drafted src diff, the empty
  census with its evidence, the author texts), manifest, `cirl-freeze`
  tag per the amended custody paragraph.
- **Task 3** — USay lands (evalx/bits/render); the bridge identity
  becomes definition; all oracle groups green; SEVENTH margin run
  digit-for-digit.
- **Task 4** — ablation + CIRL_REPORT.md (as-built C1–C12, the
  reviewer block); taildrop to pixel6.

## Standing rules restated

Builder never edits frozen surface; anchor movement is
stop-and-report; frozen texts change only at freeze boundaries, only
by the author; pinned literals that must agree with frozen quantities
derive from the frozen artifact; red fixtures are proven against the
drafted surface before they freeze; the builder never owns a live
oracle at the moment it becomes binding; builder signs with the
builder key only; the author's approval is the tag — their shell or
their recorded fresh per-instance delegation, nothing else.
