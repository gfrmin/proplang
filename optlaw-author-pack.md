# Step-2 author pack — the optimisation law, enforced (AGENT_PLAN §7 step 2)

Builder draft, oracle phase (Phase A). Binds nothing until the author's freeze
tag. Scope as PINNED (ruled 2026-07-15, decision 3; the controlling text is
`AGENT_PLAN.md:847-861`): the §1b audit table's three rows, the law's text into
frozen CLAUDE.md (one author edit, carrying the R-D21 canonization and the
evidence-program protocol line), and the one-time completeness sweep of the r1
tree. **Nothing else enters this step.**

Repo state at the oracle phase: HEAD `0b20495`, manifest 83/83 verifies,
`src/` unchanged since `ea891f0` (`code-freeze-r1`).

The three rows' dispositions, up front:

| §1b row | disposition at this boundary |
|---|---|
| `bernFast` | **already pinned** (E7 `propExpansion`, `test-expfam/ExpFam.hs:208`); no new artifact — the sweep re-verified the pin exists and executes |
| the `cond` engine / CL-4 | **author re-open of frozen `test/Properties.hs`**: `1e-9` → `1e-12` at `:85` and `:107` + the provenance paragraph (drafted verbatim in §5.2) |
| `observeCounts` | **the new pin**: `test-optlaw/` (this increment's oracle), tolerance measured-then-chosen per the residue ruling (§2, §3) |

---

## 1. The completeness sweep of the r1 tree (one-time; ruled in with decision 3)

**Question.** Does any fast path exist in the r1 tree beyond the §1b audit
table's three rows? If none, the table freezes exhaustive-at-r1, and thereafter
"the rule" means every future fast path arrives with its pin in-increment (the
CLAUDE.md clause) — never by appending to step 2.

**Sweep boundary.** The nine Haskell files of the engine and its host:
`src/PropLang/{Belief,Syntax,Eval,Enumerate,Membrane,Host}.hs` +
`host-governor/{Main,Wire,WireU}.hs`, at HEAD `0b20495` (src identical to
`ea891f0`). Test suites are out of scope: a fast path is an implementation
property.

**Method (each step grep-reproducible).**

1. *Marker grep*: `grep -n -i "fast|doctrine|shortcut|collaps|sufficien|O(hyp|cache|memo"`
   over the nine files — every hit read in context.
2. *The structural argument that bounds the search space*: invariant I1 seals
   log-weights inside `Belief.hs` (constructor never exported, gate 2), so a
   semantic fast path can exist only as (a) an alternative arithmetic inside
   `Belief.hs` itself, or (b) a composition of public verbs claimed
   extensionally equivalent to another composition. Form (b) was swept by
   `grep -n "fromBits|maximum|exp (|logBase 2|/ ln2|synth"` over the non-Belief
   files — every synthetic-kernel/rescaling site read in context.
3. *Full read* of `Belief.hs` (213 lines), `Eval.hs` (346), `Enumerate.hs`
   (755), the engine-touching sections of `Membrane.hs`, `Host.hs` (48), and
   the wire layer's engine call sites (`stepU`, `countsU`, the v1 tick step).

**Findings — every candidate dispositioned:**

| site | what it is | disposition |
|---|---|---|
| `Belief.hs` (whole module) | the general route itself: the reference's own lse max-scaling, left-to-right `sumL`, zero-mass skip rules, mirrored operation-for-operation from proplang.py | not a fast path; CL-4's domain (§1b row 2) |
| `bernFast` (`Eval.hs:235-238`) + its name-layer execution `applyStd (Bern car)` (`Eval.hs:206`) | the Bernoulli fast form of the expfam basis | **§1b row 1** — pinned by E7 `propExpansion` (`test-expfam/ExpFam.hs:208`); enforced |
| `vThink`/`vThinkK`/`vPre` = `vThinkAt`/`vPreAt` faces (`Eval.hs:287-345`) | one-arithmetic identities, pinned with `==` by the frozen ladder/prepost oracles | not fast paths — definitional sharing (the anti-drift discipline); no second route exists to diverge from |
| `emit` (`Enumerate.hs:361`) | `bernFast` spread over the theta grid | pinned — test-expfam groups 4 and 7 pin the identity (its own comment records this) |
| `walkOn` (`Enumerate.hs:373-389`) | the general route (its code form pinned 567/567 by the step-1 oracle) | not a fast path |
| `observe` / `observeVia` (`Enumerate.hs:476,722`) | the sequential general routes | not fast paths |
| `predictive`, `latentMarginal`, `mkAgent`, `verdictKernel`, `uChoose` | public-verb compositions with no equivalence claim to any other route | not fast paths |
| **`observeCounts` (`Enumerate.hs:680-712`)** | sufficiency collapse: per-hypothesis likelihood exponentiation from (n1, n0), one synthetic evidence, max-scaling re-added to the returned `LogProb`; latents NOT advanced | **§1b row 3 — the one unpinned fast path.** Only existing coverage is wire syntax (`test-d/D.hs:1041-1050`). The §1b cite `Enumerate.hs:649` is stale; as-built `:680`. |
| `bits` = `bitsAt frozenNameBits`, `bitsIn` = `bitsAt …` (`Syntax.hs:459-471,609-610`) | one arithmetic, one tree, BY DEFINITION (doctrine sighting 3); the `bitsIn`/`bits` identity pinned with `==` | not a fast path |
| `Membrane.hs` `negate lp / ln2` sites (`:341,476-483`) | nats→bits units conversion on readouts | not semantics |
| `Host.hs` `draw` (via `top`) | host sampling through sealed diagnostics | not engine semantics |
| wire layer (`Wire.hs`, `WireU.hs`, `Main.hs`) | parse/render + public-verb dispatch; the only engine fast path it exercises is `observeCounts` (`WireU.hs:502-528`); `bernFast` used as a kernel constructor (`WireU.hs:416-423`) uses the pinned name | no wire-side re-computation of engine quantities |

**Conclusion. The sweep finds nothing beyond the three rows. The §1b audit
table freezes exhaustive-at-r1** (subject to the author's tag). The law's
future tense is the CLAUDE.md clause: every new fast path arrives with its pin
in-increment.

---

## 2. The observeCounts residue, measured before the tolerance was chosen

(the author, decision 3: "measure the residue over the frozen worlds BEFORE
choosing bit-exact or toleranced — the pin must not be born with a round
number; that is how the 1e-9 happened")

**Program.** Throwaway prototype (`scratchpad/step2/Residue.hs`, discarded;
full transcript `scratchpad/step2/residue-transcript.txt`, quoted below).
Every generator a byte-wise copy from the frozen corpus (R-D20-i): `uGridD`
(test-d/D.hs:435-436), `rhoUGrid` (:438-439), `tauSpecD` (:754-758), `uAgent0`
(:588-589), `worldAgent0` (:793-794), `pointerAgent0` (:796-799); features and
the corpus count pair from the frozen observe_counts row (test-d/D.hs:1042-1049:
features `{"t":1,"x":1}`, counts `(30000, 9314)`). Sequential reference order:
n1 ones THEN n0 zeros — the frozen sentence's order (`AGENT_PLAN.md:135`).
Count ladder: 13 pairs from (0,0) up to the corpus pair. Batch =
`observeCounts`; measured: `dEv` = |batch lp − sequential lp sum| in nats,
`dEv_rel` = dEv / max 1 |lp|, `dPost` = max over model indices of the posterior
probability difference, read through the public surface only.

**Exchangeable agents (the pin's claimed-exact domain):**

```
A1 pointerAgent0, verdict route (Nothing; carried channel) (models=9)
      n1       n0       dEv_nats       dEv_rel     dPost_max
       0        0     0.000000e0    0.000000e0    0.000000e0
       1        0   1.110223e-16  1.110223e-16  2.775558e-17
       0        1   2.220446e-16  2.067574e-16  5.551115e-17
       1        1   2.220446e-16  1.463669e-16  5.551115e-17
       3        2     0.000000e0    0.000000e0  1.110223e-16
      10        7   3.552714e-15  2.997955e-16  2.775558e-16
      31       10     0.000000e0    0.000000e0  6.938894e-16
     100       31   1.421085e-14  1.949103e-16  2.664535e-15
     314      100   2.842171e-14  1.233452e-16  2.442491e-15
    1000      314   2.273737e-13  3.138330e-16  9.403589e-14
    3000      931   7.321432e-11  3.398913e-14  5.784262e-14
   10000     3141   7.958079e-10  1.100771e-13  9.038451e-16
   30000     9314    1.182343e-9  5.492463e-14  1.551985e-28
A2 uAgent0 [UConst], Nothing route (gDegeneracy generator) (models=9)
   ... (full ladder in the transcript file; maxima below)
   30000     9314    6.129994e-9  2.826600e-13 9.357083e-109
A3 pointerAgent0, outcome route (Just emit vs observeVia emit) (models=9)
   ... bit-identical to A2's columns, every row
```

*(A2 ≡ A3 exactly is itself a consistency check: `uAgent0 [UConst]`'s carried
channel IS `emit`, so the two routes compute the same floats.)*

**State-carrying agents (the DECLARED warm-flattening approximation,
Enumerate.hs:667-670; R-D23):**

```
A4 worldAgent0 (9 MBern + 8 MHmm), report route (models=1169)
       1        0   1.110223e-16  ...  2.775558e-17     <- exact at N <= 1
       1        1    2.029117e-1  ...   9.091177e-3     <- diverges at the FIRST collapsed pair
       3        2    3.259548e-1  ...   1.803581e-2
   30000     9314    1.713049e4   ...    1.000000e0     <- posterior fully moved at corpus scale
A5 uAgent0 allUFamilies (9 UConst + 8 UWalk): same shape (0.2063 nats at (1,1))
```

**The findings that decide the tolerance:**

1. **Bit-exact is REFUTED.** Residue 1.110223e-16 nats already at (1,0). The
   author's either/or resolves to **toleranced**.
2. **Measured maxima over the frozen worlds, exchangeable domain:** relative
   evidence residue **2.8266e-13** (A2/A3 at the corpus pair); posterior
   residue **9.40e-14** (A1 at (1000,314)). The residue grows with collapsed
   length (a ~N-term summation-order difference), so the corpus pair is the
   distribution's own worst case; the pin's generators are frozen, so the
   distribution cannot drift.
3. **The flattening boundary is sharp and measured:** state-carrying agents
   are batch-exact at n1+n0 <= 1 (1.11e-16 — no latent advance is collapsed
   away) and diverge from the first genuinely collapsed pair (0.2029 nats at
   (1,1)), reaching total posterior displacement at corpus scale (dPost 1.0).
   The pin's exchangeable-domain restriction is load-bearing — and R-D23's
   segmentation ruling ("collapse the FIXED WARM CORPUS, replay everything
   live per-tick") is quantitatively vindicated by the A4 corpus-pair row.

**Chosen gates (recommended; the author rules the numbers at the freeze):**
evidence `abs (lpB - lpS) <= 1e-11 * (1 + abs lpS)` — CL-4's own relative
form, headroom ×35 over the measured max; posterior `<= 1e-11` absolute per
point — headroom ×106. Measured floor plus documented headroom, the
repaired-CL-4 idiom. If the author re-sets either value at the freeze, the
R-D21 transcript re-executes with the final row text (§4; the sharpened rule —
a transcript proves only the text actually frozen).

---

## 3. The increment oracle: test-optlaw/

**Files (Phase A, untracked until the freeze):** `test-optlaw/OptLaw.hs`
(7 rows in two groups), `test-optlaw/stanza.cabal.draft` (suite `optlaw`, the
`warnings` import — the exact gate flags).

- **gPin (3 rows × 13-pair ladder):** the §1b required property, copied
  byte-wise into the header ("observeCounts == n1 then n0 repeated observe's",
  AGENT_PLAN.md:135): `pointerAgent0` carried-channel, `uAgent0 [UConst]`
  carried-channel, `pointerAgent0` supplied-emission (`Just emit` vs
  `observeVia emit`). Both gates asserted per pair.
- **gBoundary (4 rows):** on the state-carrying frozen agents, the SAME pin
  predicate must HOLD at n1+n0 <= 1 and be REFUTED (the predicate negated —
  no new literal is born) at (1,1) and (3,2). The domain restriction is
  thereby enforced in both directions: if the flattening ever silently
  vanished (the batch verb quietly advancing latents), gBoundary goes red
  with "the domain boundary moved; stop and report".

**Status against r1: GREEN AT BIRTH — 7/7, suite wall-clock 1.72 s** under the
stanza's exact flags (`-Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns`, zero warnings), compiled via `cabal exec ghc` from
the project's pinned environment.

**The red-run clause, addressed head-on (register item §6.1).** This is the
roadmap's first PIN-FREEZE increment: the fast path shipped at increment D;
step 2 pays its pin late, per the ruled scope. There is no missing
implementation for a red run to attribute — the red-run clause's premise
("before any implementation") is vacuous here. In its place, the
discriminating power of every row was DEMONSTRATED by seeded defect
(`scratchpad/step2/red-demonstration.txt`, prototypes discarded):

| seeded defect (scratch copy of src) | red rows |
|---|---|
| 1. drop the max-scaling re-add (`LogProb (lp + m)` → `LogProb lp`, Enumerate.hs:712 — the docstring's own warned artifact) | 5/7: all three gPin rows + both gBoundary hold-rows (evidence gate) |
| 2. swap the counts in the collapsed log-likelihood (`term n1 lg1 + term n0 lg0` → `term n0 lg1 + term n1 lg0`, :700) | 5/7: same rows — conviction routes through the POSTERIOR gate where symmetric evidence hides the swap (e.g. (1,0): dEv 1e-16, posterior flipped) — both gates are load-bearing |
| 3. the batch verb silently becomes the sequential fold (the flattening vanishes) | exactly the 2 gBoundary refute-rows |

Every row's red condition is reachable and attributable to its designed defect
class; the row partition is exact (defects 1-2 leave refute-rows green,
defect 3 leaves everything else green). This is the pin-freeze analogue of
"its red must be demonstrated to be the missing constructor."

---

## 4. The R-D21 satisfiability transcript (the ruled deepseq form)

`scratchpad/step2/rd21-transcript.txt` — generated by a harness derived
MECHANICALLY from `test-optlaw/OptLaw.hs` (generators, gates, and predicates
byte-identical; only tasty's `main` replaced by a printing runner — the
copy-not-reconstruct discipline applied to the transcript itself). Per row:
the REFERENCE side — the sequential evidence sum and every posterior point —
is forced to normal form by **one `deepseq` per row, independently of the fast
side**, before the row's exact drafted predicate (`pinHolds` /
`not . pinHolds`) is evaluated (decision 4's mechanical form).

**Result: 49/49 row-instances SAT** (3 routes × 13 pairs + 2 agents × 3
hold-pairs + 2 agents × 2 refute-pairs). The transcript's dEv/dPost columns
reproduce §2's residue measurements exactly — two independently-written
harnesses, same floats. Excerpt (full file alongside this pack):

```
gPin/pointerAgent0-carried  ( 30000,  9314) refLp=-21526.64811121154300000 dEv=1.182343e-9   dPost=1.551985e-28  pinHolds -> SAT
gBoundary/worldAgent0-hold  (     1,     0) refLp=-0.69314718055994500     dEv=1.110223e-16  dPost=2.775558e-17  pinHolds -> SAT
gBoundary/worldAgent0-refute(     1,     1) refLp=-1.68585044948067340     dEv=2.029117e-1   dPost=9.091177e-3   not.pinHolds -> SAT
```

If the author re-sets a tolerance at the freeze, this transcript is re-run
against the amended row text before the tag (the sharpened R-D21: a transcript
proves only the row text actually frozen).

---

## 5. Freeze items for the author (Phase B — nothing here is builder-executable)

### 5.1 The ONE CLAUDE.md edit (author's own hand; frozen text)

Three insertions, one edit, one re-tag:

**(a) THE OPTIMISATION LAW** — proposed as a new titled paragraph in the
increment-protocol section (placement at the author's discretion):

> **THE OPTIMISATION LAW** (canonized at the step-2 boundary; AGENT_PLAN §1b):
> any evaluator fast path is legal iff a property pins it, extensionally, to
> the general route — enforced, never trusted. It buys speed, never semantics,
> and it never enters the alphabet, so it never touches the prior. The §1b
> audit table is exhaustive-at-r1 (the step-2 sweep); every future fast path
> arrives with its pin in the same increment that lands it — never by
> appending to the step-2 oracle.

**(b) the R-D21 sharpening** — appended to increment-protocol item 2 where
R-D21 is stated; text as drafted and adopted, `AGENT_PLAN_REVIEW.md` Appendix A:

> A transcript proves only the row text ACTUALLY FROZEN (the step-1 group-3
> re-open): before the freeze seals a red row, its exact drafted expression —
> never the prototype's own variant of it — is executed once against the
> prototype; and the transcript must force the frozen side of every comparison
> row to normal form, independently of the stub side (one `deepseq` per row),
> proving the red is attributable to the missing implementation rather than to
> a defect the stub happens to shadow.

**(c) the evidence-program protocol line** — same Appendix:

> An increment whose step carries a falsifier runs it as an ORACLE-PHASE
> EVIDENCE PROGRAM: executed on throwaway prototypes (R-D21), success criteria
> pre-stated numerically, before any ruling freezes — so a freeze never
> encodes what its own falsifier convicts.

### 5.2 The test/Properties.hs re-open (author's own hand; Phase-1 frozen text)

The named repair (AGENT_PLAN §2b; a known-wrong frozen test): at `:85` and
`:107`, `1e-9` → `1e-12` in place:

```
-  (abs (lhs - rhs) <= 1e-9 * (1 + abs rhs))
+  (abs (lhs - rhs) <= 1e-12 * (1 + abs rhs))
```

and the provenance paragraph, proposed for the CL-4 header block (near
`test/Properties.hs:57-63`):

```haskell
-- TOLERANCE PROVENANCE (repaired at the step-2 boundary, the optimisation-law
-- freeze; an author re-open of Phase-1 frozen text — AGENT_PLAN section 2b):
-- the original 1e-9 was chosen before any measurement and stood 360,000x
-- wider than the machine's noise floor, on the very property that enforces
-- the optimisation law. Measured floors: 2.76e-15 (2026-07-12, 100k cases);
-- re-measured as-built at step 1's close: 2.971229e-15 (Saw) / 1.190530e-15
-- (Is) over 200k cases (code-task2-author-pack.md section 7). The repaired
-- gate 1e-12 carries documented headroom x336.6 / x840.0 over the measured
-- floors -- a gate is born from a measurement, never from a round guess.
```

Verification before the tag: `cabal test properties` green at 1e-12 (the
step-1 re-measure predicts ×336-840 headroom; a red here is stop-and-report).

### 5.3 The stanza (delegated or author's hand; manifest-frozen proplang.cabal)

`test-optlaw/stanza.cabal.draft` inserted after the last test-suite stanza —
the recorded pattern (expfam precedent; step 1's stanza landed under recorded
delegation at the freeze).

### 5.4 The manifest re-sign (author)

83 → 85 rows: add `test-optlaw/OptLaw.hs`, `test-optlaw/stanza.cabal.draft`;
re-hash the three changed frozen files (`CLAUDE.md`, `test/Properties.hs`,
`proplang.cabal`). E.g.:

```
{ cut -c67- MANIFEST.sha256; echo test-optlaw/OptLaw.hs; echo test-optlaw/stanza.cabal.draft; } \
  | sort -u | xargs -d '\n' sha256sum > MANIFEST.new && mv MANIFEST.new MANIFEST.sha256
```

*(sort -u changes row order from the historical grouping — if order is wanted
stable, append the two rows instead. The author's call; gate 6 only checks
membership+hashes.)*

### 5.5 The freeze tag (author, own shell; the attestation)

One signed tag on the freeze commit (suggested name: `optlaw-freeze-r0`).
**Riders (R-D22):** the tag message records that it also countersigns the two
delegated design-review-gate commits — `5fa305d` (the twelve rulings applied)
and `0b20495` (v-cancelled recorded) — closing the re-tag obligation carried
since 2026-07-15.

### 5.6 After the tag (Phase C, builder)

No implementation exists in this step by construction. Phase C is
verification only: the eleven frozen suites + `optlaw` green under `cabal test all`,
`sha256sum -c` 85/85, anchors byte-stable, then the increment report (the
as-built register) and the reviewer block. If every gate is already green at
r0, the step closes on the same tag — the author's choice.

---

## 6. The under-determination register (as-built answers wanted at the gate)

| # | item | builder's position | author rules |
|---|---|---|---|
| 6.1 | **green-at-birth oracle** — the red-run clause's premise is vacuous for a pin-freeze (no implementation owed) | the seeded-defect demonstration (§3) substitutes: every row's red reachable and attributable; propose recording this as the pin-freeze reading of the red-run clause, not an exception to it | accept / re-open the clause |
| 6.2 | **tolerance values** 1e-11 / 1e-11 (headroom ×35 / ×106 over §2's maxima) | recommended; derivation documented in the oracle header; the transcript re-runs if re-set | set the numbers |
| 6.3 | **gBoundary in scope?** "Nothing else enters this step" vs the pin's domain must be stated to be enforceable | gBoundary IS the pin's domain statement, asserted with the same predicate negated — no new quantity, no new scope; without it the pin overclaims (the satisfiable-pin-measuring-the-wrong-quantity defect class, the D post-mortem) | keep / drop |
| 6.4 | **the §1b stale cite** (`Enumerate.hs:649`; as-built `:680`) | plan prose; fix rides the step-2 amendment commit under the standing delegation | ack |
| 6.5 | **hyp-state non-advancement** (batch leaves latents untouched) is unobservable through the public surface beyond the meta | documented here, not pinned; the sealed surface cannot express the assertion, which is I1 working as designed | ack |
| 6.6 | **suite runtime** — optlaw adds 1.72 s to gate 5 | acceptable | ack |

---

## 7. Reviewer verification block (run from the repo root)

```sh
export PATH="$HOME/.ghcup/bin:$PATH"; export LANG=C.UTF-8
git status --short                     # expect: only the step-2 Phase-A files
sha256sum -c MANIFEST.sha256 | grep -cv ': OK$'   # expect 0 (83 rows, pre-freeze)
# the oracle under the stanza's exact flags, from the pinned environment:
cabal exec -- ghc -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
  -O1 -isrc -outputdir /tmp/optlaw-check -package tasty -package tasty-hunit \
  test-optlaw/OptLaw.hs -o /tmp/optlaw-check/runner && /tmp/optlaw-check/runner
                                       # expect: 7/7 green, ~2 s
cabal test all 2>&1 | tail -3          # the eleven frozen suites: green, untouched
# the sweep's greps (section 1) are reproducible verbatim from this file
```

Transcripts alongside this pack (scratch, quoted here, discarded after review):
`residue-transcript.txt`, `red-demonstration.txt`, `rd21-transcript.txt` under
`scratchpad/step2/` — copies attached to the Taildrop send.

---

*Phase A ended here (commit `8f0330c`). Sections below record the Phase-B
enactment under the author's rulings of 2026-07-15.*

---

## 8. Phase B enacted (2026-07-15, delegated; the tag is the countersignature)

**The delegation (the author, verbatim, this increment, per-instance):**
"Enact Phase B. Rulings on the register, then three riders." — with the
rulings 6.1 ("accept, with the reading canonized, not packed... Append a
fourth clause to the same CLAUDE.md edit"), 6.2 ("set the numbers as
recommended"), 6.3 ("keep gBoundary, emphatically"), 6.4/6.5/6.6 ack (6.5
amended, below), and the riders quoted where enacted. Closing: "Tag when
ready; the step can close on the same signature if Phase C's gates are
green." Every file edit below is builder action under this recorded
instruction; the author's signed tag is the R-D22 countersignature.

**Register outcomes:**

| # | ruling | enacted as |
|---|---|---|
| 6.1 | ACCEPTED; the pin-freeze reading CANONIZED, not packed | CLAUDE.md increment-protocol item 2 gains the fourth clause: for a pin-freeze the red-run clause is satisfied by a seeded-defect demonstration — every row's red reachable, attribution partitioned |
| 6.2 | numbers SET as recommended (1e-11 / 1e-11) | row text unchanged — the R-D21 transcript stands as run (49/49). The headroom asymmetry with CL-4 (×35/×106 vs ×336/×840) ruled not-an-inconsistency: this residue is an N-term summation-order artefact at N = 39k, a different animal from cond's per-operation noise; fixed generators + the frozen toolchain make the distribution undriftable. Sentence added to the oracle header (comment only) |
| 6.3 | gBoundary KEPT, emphatically | recorded for the increment report: the refute rows are a **declared-limitation pin in the R-D23 sense** — they assert the approximation's continued existence, so making `observeCounts` exact for state-carrying agents someday is a deliberate boundary act with the pin re-drawn, never a silent drive-by improvement |
| 6.4 | ack | the §1b stale cite fixed in AGENT_PLAN (`:649` → `:680`, dated) |
| 6.5 | ack, AMENDED by the author | the latent-non-advancement is not unpinnable after all: **gBoundary's refute rows are its observable shadow** — batch differs from sequential on state-carrying agents precisely because latents don't advance, so the sealed surface expresses the assertion extensionally |
| 6.6 | ack | — |

**The riders, discharged:**

1. **`v-cancelled` verified BEFORE the tag** (the OPEN-12 lesson, not
   repeated): `git tag -v v-cancelled` → Good "git" signature, ED25519
   SHA256:Sfh8OBG9CtkTF/y8rch4Cf6wv1rCpJ8ymEtKilUucsY, object `ea891f0`.
   The §5.5 rider text stands: the tag countersigns `5fa305d` + `0b20495`.
2. **Manifest APPENDED, not re-sorted** (S5's principle applied to the
   manifest's own history): existing 83 rows re-hashed in historical order
   (exactly three hashes moved: `CLAUDE.md`, `test/Properties.hs`,
   `proplang.cabal`), two rows appended (`test-optlaw/OptLaw.hs`,
   `test-optlaw/stanza.cabal.draft`). 85/85 verify; the diff vs HEAD is
   two-row-plus-three-refresh, reviewable.
3. **The law's first future case PRE-REGISTERED**: AGENT_PLAN §7 step 3
   gains the row (the author's sentence quoted verbatim): step 3's
   enumeration filter — legalised as an optimisation by step-1 ruling 4 on
   a measured equivalence in a discarded scratch — arrives with its pin in
   the same increment; an opening-checklist item of step 3's oracle,
   scheduled rather than remembered.

**Freeze edits landed (each exactly as drafted in §5, plus the ruled fourth
clause):** CLAUDE.md (the law as a titled paragraph after the increment
protocol; the four clauses appended to item 2); `test/Properties.hs`
(`1e-9` → `1e-12` at both CL-4 sites + the provenance paragraph — the named
author re-open, enacted under this delegation); `proplang.cabal` (the
`optlaw` stanza from the draft, with a dated provenance comment);
`MANIFEST.sha256` (83 → 85 as above); AGENT_PLAN (rider 3 + the 6.4 cite).

## 9. Phase C verification (gates; results recorded at enactment)

**All seven gates PASS** (`audit/run-gates.sh --phase 2`, exit 0) with every
freeze edit in place — gate 5 now runs twelve suites including `optlaw`,
gate 6 verifies the 85-row manifest. Targeted confirmation of the two risk
suites: `properties` PASS at the tightened `1e-12` (CL-4 both forms, 100
QuickCheck cases each — the step-1 re-measure predicted ×336/×840 headroom
and it held); `optlaw` PASS 7/7 (1.63 s). The step closes on the author's
single tag (his ruling: "the step can close on the same signature if Phase
C's gates are green").

## 10. CLOSED

**`optlaw-freeze-r0` signed on `66a48f1` from the author's own shell,
2026-07-15, and verified**: Good "git" signature, ED25519
SHA256:Sfh8OBG9CtkTF/y8rch4Cf6wv1rCpJ8ymEtKilUucsY — the single-tag close the
author's ruling anticipated (oracle, freeze edits, and all seven gates green
on one signature). The tag message records the R-D22 riders verbatim: the
delegated Phase-B freeze edits of this increment, and the delegated
design-review-gate commits `5fa305d` and `0b20495` — **the re-tag obligation
carried since the design-review gate is DISCHARGED.** From this signature
`test-optlaw/` is as frozen as `test/`; the §1b table is exhaustive-at-r1 as
law; and step 3 opens with the optimisation law's first scheduled application
already on its checklist.
