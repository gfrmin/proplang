# PREPOSTERIOR_PLAN — step-6 increment 5: action-dependence in the preposterior

Status: PLAN ONLY. Task 0 (author rulings on the register P1–P12) has
not happened; nothing below is built, no oracle exists, no frozen text
is touched. Scope as kicked off (ROADMAP increment 5, sharpened):
**vThink's kernel becomes action-dependent** — a deliberating agent
anticipates that its own action changes what it will see; that one
mechanism makes exploration priceable and is the true CIRL
prerequisite. That mechanism, nothing else. Out of scope, explicitly:
CIRL (increment 6 — utility stays a value-layer opaque here), rungs in
the membrane driver, and the frozen worlds' arithmetic — their kernels
are action-independent and must reproduce as the DEGENERATE CASE of
the new worker (the exact identity is T1's, stated E7-style).

Protocol: the canonized increment protocol under two-key custody; the
author countersigns the Task 2 freeze with a signed tag
(`prepost-freeze`) from their own shell or by fresh per-instance
delegation under the truthful-delegation amendment. This plan arrives
WITH its paired control world and the sim margins for both (the
kickoff's condition); pins never come from the sim (b7f120e).

---

> **Task 0 rulings (author, 2026-07-06 — verbatim intent, binding on
> this increment):**
> - **P1, P2 APPROVED as stated.** The leaf/interior menu separation
>   (ds/uD interior, acts/u terminal) noted as understood and
>   correct; the identity-as-definition is the REQUIRED form; == pins
>   at the verb layer; the sixth margin run guards the anchors.
> - **P3 APPROVED** — Chan as the opaque named wrapper beside Util;
>   the lookup-table alternative correctly rejected; Evidence/Kernel/
>   Belief/InternalAct untouched. The parity-scoped debt comes due in
>   the CIRL neighborhood alongside Util's.
> - **P4 RULED — the verb is VPre.** Signature as proposed.
> - **P5 APPROVED with a forward ruling recorded:** the amendment set
>   grows by one frozen price-pin literal per alphabet change
>   (increment 6 will carry three). Accepted as BOUNDED — the roadmap
>   terminates at increment 6 — and recorded so it cannot silently
>   become unbounded: any scope extension beyond the roadmap makes a
>   single-site frozen alphabet constant a MANDATORY boundary item.
> - **P6 APPROVED as measured**, including the two stale comment
>   lines in the author amendment (the test-name precedent).
> - **P7–P11 APPROVED as proposed.**
> - **P12: the fixture-proof author text, provided now** for the pack
>   (CLAUDE.md increment protocol, appended after the pin-provenance
>   sentence): "A compile-red fixture is proven type-correct against
>   the drafted future surface before the freeze seals it — its red
>   must be demonstrated to be the missing constructor, not assumed
>   (the ladder's Argmax-environment bug, caught by exactly this
>   proof)." Porting-order needs no touch-up (the ladder freeze
>   already names increments 5–6).
> - Proceed to Task 1; stop at Task 2 with the pack. Custody per the
>   amended paragraph; the tag is `prepost-freeze`.

## T1. The mechanism, the recursion, and the exact degeneracy identity

The frozen worker (`vThinkAt`, Eval.hs) is the one deliberation
arithmetic: Est_0(b) = the value of acting now; Est_j(b) = the
next-batch preposterior of Est_{j−1} minus the tick's price — and its
imagined evidence flows from ONE kernel, regardless of anything the
agent does. The gap (ROADMAP): an agent valuing its own candidate
actions cannot anticipate that firing a CHANGES the channel it will
see next.

**The mechanism.** One generalization, one new parameter: the
preposterior's evidence channel becomes a function of the decision
under evaluation, and each level's value takes the best decision —
immediate prevision plus that decision's own continuation:

```
W_0(b) = vAct b uLeaf actsLeaf                      -- the frozen leaf, verbatim:
                                                    -- the induction base survives untouched
W_j(b) = max over d in ds of
           [ expect b (uD d)                        -- the decision's immediate prevision
             + sum over length-n seqs from ch(d) of
                 w(seq | ch d) * W_{j-1}(b | seq) ] -- ITS OWN channel, weighting AND conditioning
           - price                                  -- outside the max: the tick costs whoever fires
```

The fold shape at every level is the frozen one verbatim (logPredict
before cond per outcome, binary-counting order, impossible branches
weight 0, strict-improvement max).

**The degeneracy identity (E7-style, the kickoff's requirement).**
With a SINGLETON decision menu whose immediate utility is identically
zero and whose channel is constant, the max collapses, the immediate
term is exactly 0.0, and W_j IS Est_j term for term:

```
vThinkAt d b k ys u acts n price
  == vPreAt d b (\_ -> k) (mkUtil (\_ _ -> 0)) (() :| []) ys u acts n price
```

and implementationally the LEFT side IS the right side — `vPreAt`
lands as the new private unconditional worker and `vThinkAt` is
re-based as this degenerate application (the bitsAt pattern, third
application: bits/bitsAt, vThink/vThinkAt, now vThinkAt/vPreAt — the
chain reads `vThink = vThinkAt 1 = vPreAt at the mute singleton`).
The frozen worker IS the action-independent case of the new one; the
oracle pins the identity with == at the verb layer, and the frozen
battery plus a SIXTH digit-for-digit margin run guard the anchors.
Float notes, recorded: `0.0 + x` is exact in IEEE for all x, and the
strict-improvement fold over a singleton returns its value unchanged —
the degenerate path adds no operation that can move a bit. Sim
spot-check (independently-written recursion vs the real exported
`vThinkK`): delta 0.0e0 at all six (depth 1..3) x (price 0.05, 0)
points.

## T2. Where action enters the kernel's type (the honest type question)

The worker needs `d -> Kernel h y`. Three facts bound the answer:

- **Compose, don't widen (the sealed-variant lesson, spec §5).**
  `Evidence` is the closed variant (I2) and stays closed: conditioning
  is untouched — `Saw (ch d) y` composes existing opaque values.
  `Kernel` itself is untouched. `Belief`'s export list is gate-2
  frozen and gains nothing. Census: no frozen suite matches `StdName`
  exhaustively (only src's `applyStd`/`stdNameStr`, both editable), so
  the alphabet is widenable — the seal bit `InternalAct`/`Choice`, and
  we touch neither.
- **The value layer already accepts host functions** (`Util`,
  `expect`, `kernel`, `event` — the recorded precedent), and the
  sanctioned shape is the OPAQUE NAMED WRAPPER: propose
  `data Chan d h y = Chan (d -> Kernel h y)` with `mkChan`/`applyChan`
  in Syntax beside `Util`, priced 0 as an opaque payload, and
  **parity-scoped, recorded**: when channels become latent (learned
  world-models; the CIRL neighborhood), `Chan` must become priced
  syntax — the same recorded debt `Util` already carries for
  increment 6.
- The first-order alternative (a lookup table `[(d, Kernel h y)]`) is
  registered and rejected: it trades a total type for partiality
  (missing decision → Maybe pollution through the worker), and the
  doctrine's line is host LAMBDAS IN EXPR, not host functions behind
  opaque value-layer names.

The PRIVATE worker takes the bare function (private code, no doctrine
surface); `Chan` is the sayable boundary's wrapper only.

## T3. The alphabet change and its two moving literals

The mechanism must be sayable (the reflexive-closure doctrine the
ladder held: selection among decisions is a sentence). STDNAME grows
6 → 7 (propose `VPre`; P4 registers the name) and stdB moves
lg 6 → lg 7, so every frozen Call-price literal moves. Census (the
recorded standard form, run at plan time):

- exactly TWO frozen assertion literals carry stdB:
  `test-expfam/ExpFam.hs:140` (lg 6, amended once already at the
  ladder freeze) and `test-ladder/fixture/Sayable.hs:205` (lg 6);
- two frozen COMMENT lines state "six-member alphabet"
  (`Sayable.hs:11`, `sayable.sh:9`) — proposed for the same author
  amendment so frozen text states no falsehood (the ladder's
  test-name precedent); one historical narrative mention
  (`stanza.cabal.draft:16`) records the PAST edit and stays.

The standard-form completeness run (full battery against the drafted
seven-member surface) is expected to show exactly two suites red, one
row each: expfam's Bern price pin and the ladder's sayable row. Both
amendments are the author's, drafted in the pack, landing in the
freeze commit with the constructor. OBSERVATION, recorded (T3 of the
ladder plan, now with data): the price-pin amendment set grows by one
frozen literal per alphabet change — each sayable-fixture price pin
joins the next increment's amendment list. The census is the control;
the alternative (pins that read the live alphabet) would un-pin the
prices and is rejected.

## T4. The paired worlds, measured (the plan arrives with them)

**World W (exploration pays).** Two decisions, one tick apart, price
p = 0.01 per tick. The belief starts at uniform-over-theta folded
through declared pre-episode history `[1]` BY THE HOST (the L6
doctrine; `uniform`/`point`/`fromBits` stay the only prior sources):
E[2θ−1] = 0.266667, so the uninformed decision-2 act is R. Decision 1
menu: `safe` pays s immediately through an h-independent Util, shows
the NOISE channel; `probe` pays 0, shows the frozen `emit` channel
(3 outcomes). Decision 2: the frozen stakes ±(2θ−1) over {L, R},
terminal. The noise channel is world data built from the exported
surface only — `kernel thetaSpace (carrierSpace obsCarrier)
(\_ -> bernFast obsCarrier 0.5)` — theta-independent, so conditioning
on it is a posterior no-op (measured: 1.665e-16).

**Control world W0 (the C0/group-6 standard).** Identical in every
respect except probe's channel is ALSO the noise channel: the
information-gathering action buys no information.

Sim (through the real frozen verbs; discriminating power only):

| world | s | W1(safe) | W1(probe) | chooses | margin |
|---|---|---|---|---|---|
| W | 0.05 | 0.306667 | 0.327067 | **probe** | 0.020400 |
| W | 0.40 | 0.656667 | 0.327067 | **safe** | 0.329600 |
| W0 | 0.05 | 0.306667 | 0.256667 | **safe** | 0.050000 (analytic: s exactly) |

VoI(probe in W) = 0.070400 > s = 0.05: exploration priced and bought;
at s = 0.40 the VoI does not cover the sacrifice and the agent
correctly declines — the iff inside one world. In W0 the same code
path declines because the CHANNEL is worthless, by exactly the
sacrifice — the iff across the pair. Realized episodes (true theta
0.1, probe reveals zeros): W — the action-dependent agent nets +0.78,
the myopic (immediate-argmax) agent picks safe, acts R uninformed,
nets −0.77; W0 — safe nets −0.77, a forced probe nets −0.82
(exploring in the control loses exactly the sacrifice). Both
directions of test-world behavior AND both realized comparisons carry
healthy margins (min 0.0204, ~1e14 x float noise).

Pins at Task 1 (never from the sim): decision choices, realized nets
(analytic arithmetic at 1e-12), the identity ==, with frozen
quantities imported where they exist (thetaSpace, emit, the stakes
shape re-declared oracle-side as in the frozen suites).

## T5. Sequencing and the canonized habit

The ladder's shape, with the boundary-queue item landed: the oracle
references `VPre` only through the compile-fixture inversion
(sayable-style row, red on exactly the missing constructor); every
frozen suite stays green on every pre-freeze tree state; the
constructor + the two literal amendments land together in the freeze
commit. **The fixture-proof habit is canonized at this boundary
(author text at the pack)**: a compile-red fixture is PROVEN
type-correct against the drafted future surface before the freeze
seals it — the ladder's §4.3 incident (the Argmax outer-environment
bug, caught by exactly this proof) is the motivating record.

## Under-determination register (Task 0: author rules on each)

| # | Question | Proposal |
|---|---|---|
| P1 | The recursion (T1) | W_j as stated: frozen leaf verbatim, price outside the max, per-decision immediate prevision + own-channel continuation; depth-general for symmetry with vThinkAt (worlds use depth 1) |
| P2 | The degeneracy identity | Stated in T1 exactly; implemented as definition (vThinkAt := vPreAt at the mute singleton — the bitsAt pattern); == pins at verb layer; sixth margin run guards anchors |
| P3 | Where action enters the type (T2) | Opaque `Chan d h y` wrapper in Syntax beside Util (mkChan/applyChan), parity-scoped debt recorded; Evidence/Kernel/Belief/InternalAct untouched — compose, don't widen |
| P4 | The verb | `VPre`, STDNAME 6→7, args '[Int, B h, Chan d h y, [y], Util d h, NonEmpty d, Util a h, NonEmpty a, Int, Double] — depth first, frozen leaf args (u, acts) verbatim in the tail; name alternatives: VForesee, VActK |
| P5 | The two moving literals (T3) | Author amends ExpFam.hs:140 and Sayable.hs:205 (lg 6 → lg 7) + the two stale comment lines, in the freeze commit; census + standard-form battery in the pack |
| P6 | The worlds (T4) | As measured: declared history [1]; noise channel from exported surface; s ∈ {0.05, 0.4}; p = 0.01; true theta 0.1, zeros stream; W0 differs in probe's channel only |
| P7 | Module homes | Worker private unconditional in Eval (vPreAt); vThinkAt re-based; `Chan` in Syntax; public `vPre` + verb + Chan behind DROP_VPRE; NO new src module; no Membrane change |
| P8 | Ablation | DROP_VPRE: Chan/vPre/VPre die, exploration unpriceable (behavior = immediate argmax), myopic base AND ladder survive; src compiles under all THIRTEEN flags; fixture + attribution |
| P9 | Sequencing (T5) | Compile-fixture inversion; fixture proven against the drafted surface (the canonized habit); frozen suites green throughout |
| P10 | Tolerances | E12 verbatim: == identities; behavioral pins exact; nets 1e-12; the control's analytic margin (s exactly) pinned at 1e-12; CL-4 shape for prevision comparisons |
| P11 | Pin provenance | Frozen imports where frozen quantities exist; new-world pins authored at Task 1; the sim is discriminating power only (b7f120e) |
| P12 | Boundary queue | Fixture-proof habit canonized (author text); porting-order touch-ups (author's); the growing amendment-set observation recorded (T3) |

## Oracle sketch (test-prepost/, one suite, groups)

1. **Degeneracy (E7)** — worker-vs-frozen identity with == (fixed
   cases + QuickCheck over prefixes/prices/depths); verb-layer
   identity behind the compile fixture; frozen-battery guardian via
   gate 5; sixth margin run in the report.
2. **Exploration priced (W)** — decision values and choices pinned at
   s = 0.05 (probe) and s = 0.40 (safe); realized nets pinned
   (AD +0.78 vs myopic −0.77 at 1e-12); the sayable episode in the
   fixture reproduces the same pins.
3. **The control (W0)** — same code path, noise probe: chooses safe;
   margin == s at 1e-12 (the analytic pin); forced-probe realized net
   worse by exactly the sacrifice.
4. **The channel's no-op honesty** — conditioning on the noise
   channel is a posterior no-op (CL-4-shape comparison of previsions);
   the probe/noise asymmetry is the ONLY difference between W and W0
   (structural assertion on the world data).
5. **Prices** — Call VPre price pin under lg 7 (compile fixture);
   existing depth-grid pins unmoved.
6. **Deletion and audit rows** — DROP_VPRE row (four checks with
   attribution); six-file guard; the frozen scans cover the src edits.

## Gates and the freeze (predicted edit list)

Gate 5 absorbs the `prepost` suite; stanza drafted in the oracle
phase. The freeze commit carries: (1) src — VPre member + stdB lg 7 +
applyStd/stdNameStr cases + Chan + vPre export + vThinkAt re-based;
(2) the author's two frozen literal amendments + two comment lines;
(3) proplang.cabal stanza; (4) CLAUDE.md — the fixture-proof habit
canonized + any porting-order touch-up (author text); (5) manifest
extension over test-prepost/ (49 + its files) with re-hashes of the
amended frozen files. Tag `prepost-freeze` per the amended custody
paragraph.

## Task order

- **Task 0** — author rules on P1–P12. STOP point: this document.
- **Task 1** — oracle + type-surface stubs (Chan surface, vPre stub,
  worlds as fixtures), runtime-red under the stanza's exact flags;
  compile fixture proven against the drafted surface; frozen suites
  green throughout. Builder-signed.
- **Task 2** — author freeze: pack (with the drafted src diff, the
  census, the standard-form battery, the author texts), manifest,
  signed tag.
- **Task 3** — vPreAt lands, vThinkAt re-based, verb wired: identity
  and world groups green; sixth margin run digit-for-digit.
- **Task 4** — ablation + report (PREPOSTERIOR_REPORT.md with the
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
