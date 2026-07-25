# increment D Task-3 STOP-AND-REPORT: three frozen oracle rows are wrong

Builder → author, 2026-07-09, mid-Task-3. Untracked. CLAUDE.md's clause
governs: "If a frozen test IS wrong, stop and report; the human
re-opens" — implementation is PAUSED at the state described in §4;
nothing frozen was touched (manifest verifies 81/81 throughout).

## 1. What happened

Task 3 implementation of the Enumerate utility layer turned 13 oracle
rows green on first compile (bk reproduction digit-for-digit at
k∈{0,2,4,12}×9 points; asking-death; VoI-decay; the full consult
window; the τ-mixture identity; both gOffPath rows; both utility-side
counts). Three of the remaining red rows then proved to be defects in
the frozen oracle itself — each implementation-INDEPENDENT, verified
by executing the frozen expected side directly.

## 2. Defect 1 — gDegeneracy "listening survives to k=3, dies at k=4"
(D.hs:607-614, one row)

The oracle's predicate is a MIS-TRANSCRIPTION of the frozen CIRL
formula. Frozen test-cirl/Cirl.hs:138-139:

    obeys kk n = e2u1 (condBatch kk (bk n) [0, 0, 0]) <= 0
    -- "after the agent defers at stage k and the human presses three
    --  times, does the terminal act flip to Off?"

The oracle wrote instead (D.hs, gDegeneracy's local reimplementation):

    obeysB b = contVia emit b > e2u1 b + contVia noiseC b

— which is the SHAPE of Cirl.hs's value-DECOMPOSITION pin (its lines
167-170), not its obeys predicate. Smallest reproducing detail: at
k=1, bk1 == lmConst1 exactly (all nine masses bit-identical, measured),
and obeysB bk1 computes 0.4556 > 0.3333 + 0.3333 = FALSE — the row
fails ON THE FROZEN EXPECTED SIDE. Since the row is a pure function of
a belief that the (passing) bk-reproduction row pins to bk, NO honest
implementation can make it pass.

Verified positive control: with the CORRECT Cirl formula, the
implementation reproduces the frozen death schedule exactly —
k∈[0..3] obeys, k∈[4..5] ignores, identical on lm and bk.

## 3. Defect 2 — gHeadline's floor and gap rows (D.hs:634-644, two rows)

The pin: voiB(latentMarginal(drift agent at k=12)) ≥ 1e-6, and
strictly > the static twin's. Measured, exhaustively:

    k:            0        1        2        3        4    5..12
    voi drift   0.2333   0.1226   0.0293   0.0080    0.0    ~0
    voi static  0.2333   0.1222   0.0289   0.0077    0.0    ~0

Through the voiB composition (a 3-outcome batch at depth 1, price
0.01, over a STATIC SNAPSHOT of the marginal), BOTH families die at
k=4: after twelve approvals the posterior is so concentrated that no
3-observation sequence flips the terminal act, so the preposterior
max equals the prior max exactly, for every mixture. The one legal
implementation freedom (the const↔walk FAMILY price ratio — within a
family, equal dl is forced by sentence structure) cannot help: the
α→1 walk-side-only limit measures voiB = -1e-15 (float zero). The
floor is arithmetically unsatisfiable; so is "drift > static" at
k=12 (0 > 0).

The mechanism the pin wanted — drift funds re-opened deference — is
REAL and ALREADY PINNED GREEN by gConsult: the drift agent resumes
deference within 20 ticks of the t=60 flip, the static agent never
does, MAP flips to the walk sentence. Drift's VoI lives at the FLIP,
not in a same-stream snapshot at k=12. My oracle-phase derivation
declared the 1e-6 floor "conservative" without executing it — exactly
the failure the pinned-literal rule exists to catch, and I failed it
at drafting; recorded, not excused. (The pack §3.9 called the floor
"falsifiable in both directions" — it was, and it just fell in the
direction nobody expected: against the oracle.)

## 4. Where things stand (nothing frozen touched)

- Oracle run: 35/49 green — 14 red = the 3 defective rows + 11
  ordinary pending-implementation rows (gLedger, gO3, gDriver, gWire)
  whose meaning is untouched by the defects.
- src/PropLang/Enumerate.hs carries the landed utility layer
  (UConst/UWalk model sorts with carried declared channels; the
  reflected walk generalized onto the value grid; verdictKernel as
  the τ-mixture; latentMarginal via public verbs; observeVia — the
  outcome channel's verb). Uncommitted, awaiting the re-open ruling.
- Membrane driver and wire v2 implementation are paused.
- MANIFEST 81/81 verifies; the nine pre-D suites pass with the layer
  in tree.

## 5. The re-open you would need to rule (drafts, R3 — yours to adopt,
adapt, or reject; each is an edit to the frozen test-d/D.hs, so it is
a freeze-boundary act: amend by your hand, re-hash D.hs in the
manifest, re-tag)

1. **Listening row (mechanical fix, verified green against the
   current implementation):** replace obeysB's body with the frozen
   formula —

       obeysB b = e2u1 (condBatch emit b [0, 0, 0]) <= 0

   (and its comment: "listening = does a triple press flip the
   terminal act"). Nothing else in the group changes; the row then
   pins the frozen death schedule through the new readout, which is
   what it always meant to do.

2. **Headline rows (two honest options, both measured):**
   - (a) RE-SCOPE: replace the two rows with the measured, falsifiable
     drift edge where it exists — "voiB drift > voiB static, strictly,
     at k ∈ {1, 2, 3}" plus "both are ≤ 1e-12 at k = 12" — and let
     gConsult carry the headline (it already does: resumption-at-flip
     IS corrigibility funded by drift, pinned green).
   - (b) DELETE the two rows and promote gConsult to the named
     headline in the pack's language at the next document boundary.
   Option (a) keeps a numeric drift-vs-static discriminator in the
   oracle; I recommend it.

## 6. Reviewer verification block

    export PATH="$HOME/.ghcup/bin:$PATH"
    sh test-d/red-run.sh            # 35 green / 14 red today
    sh test-d/red-run.sh -p gConsult   # the real headline: 4/4 green
    sha256sum -c MANIFEST.sha256    # 81/81 — nothing frozen touched
    # the diagnostics that ground §2-§3 (builder scratch, outside the
    # repo): /home/g/.claude/jobs/ffddc677/tmp/diag.hs, diag2.hs

After your ruling + amended freeze (manifest re-hash over D.hs +
re-tag from your shell), the builder resumes Task 3 to 49/49 against
the repaired oracle.

---

## 7. Resolution (recorded, not patched — 2026-07-09, same day)

The author ruled, verbatim: **"adopt both rules; apply the §5 fixes
as recommended."** Applied under that fresh, explicit, per-instance
delegation (the membrane precedent — builder key, delegation recorded
verbatim in the commit and in tag `d-freeze-r1`):

- obeysB repaired to the frozen Cirl formula (§5.1); gDegeneracy 4/4
  green.
- gHeadline re-scoped per §5.2(a) — the strict drift edge at
  k ∈ {1,2,3} plus both-families-dead at k = 12; 2/2 green, both
  rows' expected sides verified by execution before the re-freeze.
- The oracle is now 48 rows: 37 green / 11 red (the 11 = gLedger,
  gO3, gDriver, gWire — ordinary pending implementation).
- The two drafting rules (copy-not-reconstruct; satisfiability proof
  for red pins) enter the register as R-D20 and bind every future
  increment oracle.
- MANIFEST re-hashed over the repaired D.hs, 81/81.

Task 3 resumes against the repaired oracle.
