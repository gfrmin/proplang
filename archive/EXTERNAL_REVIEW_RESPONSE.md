# EXTERNAL_REVIEW_RESPONSE — verified assessment of the 2026-07-09 external review

Status: UNTRACKED builder draft, 2026-07-09. Binds nothing; the manifest
stands at 75/75 untouched and this file must not enter it. The review
arrived out-of-band (no copy exists in the repo); its full text is
Appendix A, so this document is self-contained for the record. Every
verdict below was re-verified against the working tree at `65015f2`
before writing — no citation is carried from memory (the §10-erratum
rule, applied to this prose).

One process note up front: the review's load-bearing quotes about the
project live in FROZEN files (design.md, WRITEUP.md, HOSTS_PLAN.md,
test/), so the reviewer read the record the manifest protects. The two
errors found are both about `src/` internals — the one place the
reviewer had to reconstruct rather than quote.

---

## 1. Claim-by-claim verdicts

| # | claim | verdict | evidence |
|---|---|---|---|
| 1 | `call` fails its deletion proof, retained as "stdlib boundary marker" with an honesty flag | VERIFIED | `design.md:66,70-74` (frozen); `src/PropLang/Syntax.hs:252-253` |
| 2 | The STDNAME table is `{EU, VAct, VThink, VThinkK, VPre, USay}` | **REFUTED** (membership) — see §2.1 | actual: `{EU, IsEq, VAct, VThink, VThinkK, VPre, Bern}`, `src/PropLang/Syntax.hs:266-310` |
| 3 | STDNAME priced at log₂7; grew at the ladder (VThinkK), prepost (VPre), CIRL (USay) freezes | PARTIAL — count and price right; growth history wrong at CIRL — see §2.1 | `Syntax.hs:366` (`prodStdName = 7`), `:401`; pinned frozen at `test-govhost/GovHost.hs:217-221`, `test-expfam/ExpFam.hs:137-140` |
| 4 | Honest sentence 4: policy fragment has no arithmetic; `2u−1` unsayable | VERIFIED | `WRITEUP.md:376-386` (frozen) |
| 5 | `vPreAt` = legitimate composition of the three verbs (`expect`, `logPredict`, `cond`) + `foldl'` max + price subtraction | VERIFIED | `src/PropLang/Eval.hs:207-226` (`est`/`pick`/`branch`/`walk`) |
| 6 | Post-close sweep: two `vPreAt` paths (interior-menu max; action-dependent recursion above depth 1) have no falsifying frozen row; identity pins became definitional when `vThinkAt` was re-based as `vPreAt` at the mute singleton | VERIFIED | `WRITEUP.md:459-471` (frozen); the re-base at `Eval.hs:241-249` |
| 7 | `Event a = Event (a -> Bool)`; `event :: Space a -> (a -> Bool) -> Event a`; comment claims the engine can never receive an opaque closure | VERIFIED — and the overclaim reading is accepted, see §4(a) | `src/PropLang/Belief.hs:54,61-63,120-121` |
| 8 | No structured event hierarchy (TagSet/FeatureEquals/FeatureInterval lineage) | VERIFIED | zero grep hits repo-wide |
| 9 | Cromwell frontier: fixed depth-1 `if`, 1169 sentences, named a "vice"; no `add_rule`; generator deferred | VERIFIED | `design.md:244-250` (frozen); `src/PropLang/Enumerate.hs:5-9`; `WRITEUP.md:387-393`; `add_rule`: zero hits |
| 10 | Test 2's low-price rows are buffer-bound (36 obs / batches of 3 / 12 batches; 1/3/12/12), conceded on record | VERIFIED | `test/Anchors.hs:71-77`, `test/Acceptance.hs:229,236,251-257` (frozen); `design.md:238-242` |
| 11 | Census: four nouns, three verbs | VERIFIED (noun 2 is "Prevision", realized in code as `Belief`) | `design.md:19-23,109-115` (frozen) |
| 12 | Agreement-% / results shape (stationary premium 0.8 bits vs γ=1.0; CIRL k=1 ask-death, k=4 listen-death, deference ~1e-12) | VERIFIED against the frozen record | WRITEUP results sections; not re-derived here |

---

## 2. Corrections

### 2.1 The STDNAME table (claims 2–3)

The actual table (`src/PropLang/Syntax.hs:266-310`) is seven members:
`EU, IsEq, VAct, VThink, VThinkK, VPre, Bern`. The reviewer omitted
`IsEq` and `Bern` and wrongly included `USay`.

`USay` is not a StdName. It is an `Expr` constructor in the **UTIL
sort** (`Syntax.hs:187`), the sole codeword at declared utility-valued
holes, priced by `utilB = log₂(prodUtil) = log₂(1) = 0` (`Syntax.hs:366,
404,434`) — it never touches the STDNAME choice. The CIRL freeze grew
the UTIL sort, not the log₂7 table. The actual STDNAME growth history:
**Bern 4→5** at the expfam freeze (`Syntax.hs:298-300`), **VThinkK 5→6**
at the ladder freeze (`Syntax.hs:271-274`), **VPre 6→7** at the prepost
freeze (`Syntax.hs:284-288`).

This correction cuts both ways for the reviewer's argument. It weakens
the specific growth narrative ("each time a demonstration needed a new
species of thinking" — Bern was a *derivation*, not a new species of
thinking, and USay's growth was Kraft-free). It leaves the substantive
point fully intact: the deliberation arithmetic (`applyStd`, `vAct`,
`vThinkAt`, `vPreAt` in `Eval.hs`) is named, not sayable, and
`design.md:70-74` records exactly that as `call`'s honesty flag. The
"same wound, two faces" reading (call's honesty flag ↔ honest sentence
4) is accurate.

### 2.2 "Makes VThink a sentence rather than a name" (the increment-C framing)

Increment C (HOSTS_PLAN §7, `:792-844`, adjudicated design C-II) adds
`Add, Mul :: StdName '[Double, Double] Double` behind `DROP_ARITH`,
moving `stdB` lg 7 → lg 9 at the single P5 site. That makes utility
*payloads* like `2u−1` sayable
(`Call Add (Call Mul (c₂ :* Var (S Z)) :* c₋₁)`, `HOSTS_PLAN.md:834`)
and discharges honest sentence 4 as item 5 promised
(`HOSTS_PLAN.md:840-844`). It does **not** convert `VThink` into a
sentence — `VThink` remains a primitive StdName, and no planned
increment de-primitivizes the deliberation verbs. The reviewer's
destination ("closes the metalevel under the agent's composition") is
not what C buys; C buys arithmetic under the price system. What would
close the metalevel is the generator, which the reviewer separately —
and correctly — notes cannot be a name-table proposer either.

---

## 3. The three recommendations against the record

### (i) "Arithmetic nodes in the policy fragment, first and by a distance"

This is increment C, already fully designed (C-II, HOSTS_PLAN §7) — and
deliberately **gated and last**. The gate is normative: "C is built only
if D's oracle demonstrates step-table underfit — a measured,
ablation-grade justification. The terminal earns its keep BEFORE it
exists" (`HOSTS_PLAN.md:794-797`). The one hard sequencing rule in the
ladder is "never merge C with a large surface: the census-bearing
change ships alone so the moving literals stay attributable"
(`HOSTS_PLAN.md:950-952`).

The state of play makes the disagreement smaller than it looks:
**D is in flight now** (pulled ahead of A by measured demand — R-D1
ruled 2026-07-09, `HOSTS_D_PACK.md:94-98,651`; Task-1 type-surface
stubs in the working tree), and D's oracle is precisely the instrument
that produces or refutes C's gate evidence. The current ladder is
therefore the fastest protocol-legal route to the reviewer's own first
recommendation. Doing C *first* would mean building the terminal before
the measurement that justifies it — the exact move the gate exists to
forbid. Whether the review's judgment ("by a distance") warrants
re-ordering anyway is the author's to rule; nothing needs ruling to
keep moving.

### (ii) The generator

Declared open research, not an increment — cut item 5
(`ROADMAP.md:84-85`; `WRITEUP.md:387-393,414-416`). The reviewer's own
caveat concedes the record's position: "a generator that proposes from
a designer-fixed name table is not the generator either." The record
goes further — `brief.md §6` (`:88-95`) rules that a single "modify the
grammar" primitive is *wrong* (compression is a prior effect priceable
at depth one; exploration is a likelihood effect requiring
re-conditioning against the residual; one currency, two fidelities). So
"there is no `add_rule`" is true and is partly doctrine, not only debt:
the missing piece is the two-fidelity costed decision, and it stays
named open research. The reviewer's sequencing (generator second, after
arithmetic) is noted; it binds nothing while the item stays off the
ladder.

### (iii) Continuous carriers + structured Event hierarchy

Continuous carriers are a cut item with no consumer ("no remaining
claim needs them; the continuous debt stays where the Event/Kernel peer
decision filed it", `ROADMAP.md:77-79`; `WRITEUP.md:405-407`), and
HOSTS_PLAN reaffirms twice that nothing on the current ladder buys
them. The recommendation is therefore a proposal for a future boundary,
not a correction of the current one. The narrower observation inside it
— the I2 comment's overclaim — is accepted and filed; see §4(a). One
framing note: the record holds I2 (evidence declares its algebra,
`design.md:294-299`) as a defended invariant, not a filed weakness; the
reviewer's finding is that the *comment's claim* is stronger than the
*implementation*, on exactly the carrier class recorded decision 1
(`design.md:85-103`) cited as its justification. That is an honest hit,
and the irony ("kept as peer precisely to avoid borrowing against
disintegration, then implemented as the one structure that won't
survive carrier growth") is fairly earned.

---

## 4. Accepted findings and their disposition

**(a) The I2 comment overclaim — the review's one genuinely new
finding.** `Belief.hs:61-63` says "the engine can never receive an
opaque closure"; strictly, the Evidence *variant* is closed (`Is`/`Saw`)
while `Event`'s *payload* is an opaque predicate `a -> Bool`
(`Belief.hs:54`). Harmless on finite carriers — the engine enumerates
the space, so the predicate is fully observable by evaluation — which is
why no frozen test catches it and none should. Filed as
**HOSTS_D_PACK.md §12 R-D17** (post-review addition, awaiting the
author's acknowledgment at the D freeze). Whether the one-line comment
precision lands in `Belief.hs` with D's freeze commit is the author's
call: the file is editable but sits outside D's declared surface, and
the discipline is record-don't-patch.

**(b) Test 2's buffer bound.** Already conceded in frozen text
(`test/Acceptance.hs:251-253`; `design.md:238-242`). "Enlarge the buffer
and the test gets its dynamic range back" is correct and would require
re-opening frozen `test/Streams.hs` + `test/Acceptance.hs` — a future
boundary's business if ever justified; the ladder increment already
partially repaired the price-0 blind spot by making depth a bought
rung. Noted, no action.

**(c) The vPreAt definitional-pins point.** Already recorded at
`WRITEUP.md:459-471`; the reviewer's gloss ("a refactor converting
tests into tautologies... the audit caught it and recorded it") matches
the record, including the caution that it only stays caught if someone
keeps looking. The correctness burden sits on the literal anchors,
which held again at H (byte-stable, `65015f2`). Noted, no action beyond
this acknowledgment.

---

## 5. Actions taken with this document

1. This file written (untracked; not in git, not in the manifest).
2. `HOSTS_D_PACK.md` §12: **R-D17** appended, clearly marked as a
   post-review addition — the pack is an unfrozen builder draft and the
   author re-reviews before the freeze (§15), so a marked addition is
   legal.
3. Nothing else touched: no frozen file, no `src/` file, no test suite,
   no commit, no manifest edit. The D Task-1 stubs in
   `Enumerate.hs`/`Membrane.hs` are byte-identical to before this
   document.

Open for the author (no ruling needed to proceed with D):
- whether the review changes the C ordering (§3(i) — the record says
  the gate holds; the ladder already runs through D toward C);
- whether the `Belief.hs:61-63` comment precision lands at the D freeze
  (§4(a) / R-D17);
- whether this document should be preserved beyond the working tree
  (e.g., alongside the D pack at its freeze) or remain ephemeral.

---

## Appendix A — the review, verbatim (as received 2026-07-09)

> It held. That's the headline, and it deserves stating before the criticism: a world that shifts at an unannounced time makes the agent consultative with no detector anywhere in the loop; a dearer clock makes it think less with nothing to point at; a deliberately-built forgetting factor gets matched on the drifting world and beaten on the stationary one by an agent that infers `hmm(rho=0.1)` as *content*, and is then deleted. Four nouns, three verbs, and the thing you asked for — adaptation as posterior dynamics rather than control flow — is measured rather than asserted.
>
> Two things the researcher did that I did not ask for and should have. First, **gate 4 promotes an acceptance test into a compile fact**: the forbidden-token grep means `detect`, `forget`, `window`, `throttle`, `temper`, `anneal` are not merely absent from `src/` but *unwritable*. My T1 said "grep the source; there must be none," which is a request that the author be honest. The gate makes honesty structural. Second, the **frozen-oracle protocol** — tests ported and manifest-signed before any implementation existed, a wrong frozen test being a stop-and-report rather than a fix — closes the failure mode where the test quietly learns to pass. Adversarial construction applied to the builder is the same move the brief applied to the agent, and the fact that the builder was an LLM makes it more than decoration.
>
> The results also have the right *shape*, which is a subtler success than passing. On the stationary world the agent loses to the best forgetter by 0.8 bits, and the best forgetter is γ=1.0 — that is, plain conjugacy. That 0.8 bits is exactly the insurance premium the complexity prior charges for entertaining change-point sentences it does not need. A result where the mixture *beat* exact conjugacy on a genuinely stationary world would have been evidence of a bug. And the CIRL sweep delivers the predicted negative: asking dies at k=1, listening survives to k=3 and dies at k=4, deference decaying to 1e-12. Corrigibility's evaporation at convergence stopped being a warning in §11 and became a number.
>
> Now the three places where it is cornered against a wall the designer built.
>
> **`call` is a self-declared standing bug, and it is not a small one.** The design doc is admirably straight about this: `call` fails its deletion proof, is retained as "stdlib boundary marker," and the honesty flag is raised. But look at what `call` carries. The STDNAME table — `EU`, `VAct`, `VThink`, `VThinkK`, `VPre`, `USay` — *is* the deliberation arithmetic and the utility. I read `vPreAt`: it is a legitimate composition of the three verbs (`expect`, `logPredict`, `cond`) plus a `foldl'` max and a price subtraction, so §4's rule is satisfied. But the language cannot *say* its body. The consequence is precise: the agent chooses among deliberations the designer named; it cannot compose a deliberation the designer did not name. Reflexive closure is achieved at the level of quoting inference, not of composing it. And the table *grew* — `VThinkK` at the ladder freeze, `VPre` at prepost, `USay` at CIRL — each time a demonstration needed a new species of thinking. Priced at log₂7, reported at a signed boundary, which is the honest version of the sin. It is still the sin. The repo names this from the other side as honest sentence 4: the policy fragment has no arithmetic; `2u−1` is unsayable. Same wound, two faces.
>
> **The generator was cut.** §6 of the brief — the belief-aware purchase of hypotheses, compression and exploration as two moves of one currency at two fidelities — is declared open research, and the Cromwell frontier is a fixed depth-1 `if` over 1169 sentences. Design §7's account of compression as "the drift sentence holding the posterior against change-point sentences until the evidence gap exceeds the prior gap" is compression *observed as posterior dynamics*, which is not the same animal as compression *as a costed meta-action*. There is no `add_rule`. The record says this plainly and calls the frontier a vice rather than a feature, so no one is being deceived; but a reader should not come away thinking the hypothesis-generation half of the brief was answered. It was deferred, and it is the half that was hard.
>
> **I2 is weaker than specified, and weakest exactly where recorded decision 1 said it mattered.** `Event a = Event (a -> Bool)`, with `event :: Space a -> (a -> Bool) -> Event a`. The module comment claims the engine can never receive an opaque closure; strictly, the *variant* is closed (`Is` versus `Saw`) while its payload is a predicate closure. In a finite space this costs nothing — you can enumerate — which is why no frozen test catches it. But my I2's justification was correctness on continuous carriers, where probing a kernel's output to infer structure misfires at genuine zero-density points. So: Event and Kernel were kept as peer primitives precisely to avoid borrowing against disintegration when carriers grow, and then the finite implementation made Event the one structure that will not survive that growth. The irony is tidy enough to be worth a precedent entry.
>
> Two smaller notes for the record. Test 2's low-price rows are **buffer-bound, not clock-bound**: 36 observations at batches of three is twelve batches, and price 0.005 and price 0 both yield twelve ticks. The doc concedes the information runs dry before the clock bites. The clock therefore demonstrably binds at two of the four rows, and at price 0 the thing that terminates the regress is the myopic surrogate's blind spot — no next-batch outcome flips the decision, so VoI is zero — rather than physics. The ladder increment partly repairs this by making depth a bought rung. Enlarge the buffer and the test gets its dynamic range back. And the post-close adversarial sweep admits that two paths of `vPreAt` (the interior-menu max, and action-dependent recursion above depth 1) have no frozen row that can falsify them, because the identity pins that once covered them became *definitional* when `vThinkAt` was re-based as `vPreAt` at the mute singleton. That is a refactor converting tests into tautologies. The audit caught it and recorded it rather than patching it, which is the discipline working — but it is the sort of thing that only stays caught if someone keeps looking.
>
> **Where I'd send the next increment.** Arithmetic nodes in the policy fragment, first and by a distance: that discharges honest sentence 4, makes `VThink` a sentence rather than a name, and closes the metalevel under the *agent's* composition rather than the designer's. Only then is the generator worth building, because a generator that proposes from a designer-fixed name table is not the generator either. Continuous carriers plus a structured Event hierarchy — your `TagSet`/`FeatureEquals`/`FeatureInterval` lineage from Credence is exactly the stronger I2 proplang lacks — come third, and they are what finally makes recorded decision 1 pay for itself. The traffic runs both ways: proplang's forbidden-token gate is a bright-line enforcement that Credence's precedent-based lint could adopt tomorrow.
>
> The §10 erratum is my favourite thing in the repository, and I suspect it will be yours: the closing block was wrong in exactly one sentence, and that sentence was the one drafted from memory rather than derived from the frozen artifacts. The project's own epistemology, tested on its own prose, and it failed in the predicted place. You asked for a cornered agent. What you got is cornered in most directions and honest about the three walls it built itself — which is, in the only sense that survives contact with reality, the same thing..
