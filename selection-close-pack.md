# The selection increment — CLOSE PACK

Assembled by the builder for the author's close (chooseeu-sitting-r0
clause 6 + OB-33).  The increment landed the third shape (policyPick =
the pairwise-substituting fold, pinned to policyPickKS), then re-opened
at r0a to migrate runEpisode (mandate 5).  This pack gathers the
boundary review, the kill matrix, the frozen-layer inventory, and the
obligation dispositions, so the author's close acts (frozen edits,
MANIFEST re-sign, close tag `selection-freeze-r1`, #24) ride one review.

Chain at close: ... -> 87f5066 (r0 impl) -> b841e8a (r0a amendment) ->
a90f9c7 (selection-freeze-r0a, author) -> 36ca59f (r0a impl green).

================================================================
## 1. The six red-team mandates (fresh-context reviewers over 87f5066)
================================================================

Run as six independent fresh-context agents, one mandate each, over the
implementation.  FIVE CLEAN; mandate 5 found a real gap, RESOLVED by the
r0a re-open.

- **M1 Savage (theorem-as-definition): CLEAN.**  The fold==sentence pin
  is EXECUTED, not asserted — `refCheck` (`expectEq "policyPick vs
  policyPickKS"`) runs on s2-s6 and is non-vacuous (two independent
  implementations).  C56 (third shape == policyPick universally) is
  honestly ARGUED with a named falsifier, its finite instances the
  frozen family.  Nit: `Membrane.hs` policyPick's comment drops the
  ruling's "ARGUED until pinned" qualifier — accurate (the refCheck row
  exists) but a future-reader risk.

- **M2 M5 (asserted-N, derived-zero): CLEAN.**  Every ruling/clause ID
  in the increment's artifacts resolves to a definition site (R-SHAPE ->
  shape-ruling.md; OB-33 -> OBLIGATIONS.md:61; C56 -> the claims
  register; the R1-R9 register; FL/L5/R-D21 -> CLAUDE.md).  The
  clause-4/clause-6 cross-reference reconciles (both name the same rider
  set).

- **M3 H (load-bearing quantity defined nowhere): CLEAN.**  Every
  quantity resolves — the fold's 0/1 are option tag-codes via
  reMint/mintQ (byte-identical to frozen chooseEU), not steering
  constants; the w=16/w=32 widths and the cost figures trace to probe
  A1's transcript, printed as residuals.  Nit: s10's wire expectation
  hardcodes `"act": 17` (a second hand-copy of the world's `m` arg, a
  mild wire-side one-generator bend, JSON-text-match; defined, not
  floating).

- **M4 Util (type without derivation): CLEAN.**  policyPickKS's §8c
  derivation survives in the MANIFEST-frozen prophecy.diff; the type is
  policyPick's exact already-audited signature.  Nit: the shipped src
  comment dropped the explicit "§8c" wording (documentation-locus).

- **M5 overloaded convention: FINDING -> RESOLVED at r0a.**  runEpisode
  (the exported library episode runner) still called the act-blind
  chooseEU at Membrane.hs:460, so the #24 repair was WIRE-ONLY and the
  ruling's "zero src consumers" was false (F7 measured one wire call
  site).  The author ruled RE-OPEN; r0a migrated runEpisode to
  policyPick (pinned by the new s11 row) and demoted chooseEU's colliding
  "THE SELECTION" title.  chooseEU now has zero src consumers IN TRUTH —
  the finding is resolved on the record, not bracketed.

- **M6 function-of: CLEAN.**  Every new object's dependencies match
  intent — the fold's incumbent side reads `Var (S Z)`/iFeats, the
  challenger `Var Z`/cFeats (the #24 repair, correctly wired, no swap);
  pickWire's think value nets price exactly once.  One implicit
  precondition noted (env-independence relies on all candidates sharing
  the writable-key set; guaranteed by menuAssignments, guarded
  fail-closed by mkEnvIn) — not a defect.

The three CLEAN-with-nit comment items (M1/M3/M4) are documentation-
locus, non-blocking; listed for the author's disposition (REPAIR or
ARGUED-AND-DECLINE per the frozen-layer-inventory discipline).

================================================================
## 2. The OB-33 kill matrix (selection pool)
================================================================

DONE — `audit/mutants/M82-M89` (8 patch files, all apply clean, format
matches the standing pool) + the matrix transcript
`test-selection/close-kill-matrix.txt`.  d1-d7 (the birth pool, RE-RUN
against the committed baseline 36ca59f — not read off the overlay) +
M89 the runEpisode mutant, against the full frozen suite.

  row                              M82 M83 M84 M85 M86 M87 M88 M89
  s1  wire24-clockless-argmax       X   X   X   .   X   X   .   .
  s2  lib24-fold-eq-ks              X   X   X   .   X   X   .   .
  s3  lib24-tie-head                .   .   .   X   .   X   .   .
  s4  lib-w8                        X   X   X   .   X   X   .   .
  s5  lib-w16                       X   X   X   .   X   X   .   .
  s6  lib-guarded-eq                .   .   X   .   X   X   .   .
  s7  lib-w32-fold-argmax           X   X   X   .   X   X   .   .
  s8  wire24-clock-highprice        X   X   X   .   X   X   .   .
  s9  wire24-clock-price0-tie       X   X   X   .   X   X   X   .
  s10 wire-w32-clock-argmax         X   X   X   .   X   X   .   .
  s11 episode24-runEpisode          X   X   X   .   X   X   .   X

READINGS: every mutant killed (no empty column); every row fires.
THREE UNIQUE SEATS — s3 alone kills M85 (tie-flip), s9 alone kills M88
(Ge-at-think), **s11 alone kills M89 (runEpisode-uses-chooseEU)**: the
r0a row earns its seat against the standing pool, the third seat added
to the birth pool's two, exactly as predicted.  Sibling shadowing
(s1/s2/s4/s5/s7/s8/s10 share a signature; M82==M83 and M84==M86 shadow
pairwise) is RECORDED per the dyadic R7 pre-ruling — an answer, not a
failure; the residual "is the redundancy wanted?" is a row-VALUE ruling
for the sitting.

DONE (OB-33's named breadth half): the four breadth mutant classes cut as
`audit/mutants/M90-M98` (9 patches, all apply in-place, generated by
`audit/mutants/breadth_matrix_driver.py` -- the one-generator, landed in-tree
per the generator exemption) + the matrix transcript with the seven-row
re-triage `test-breadth/close-kill-matrix.txt`.  Run against the committed
r0a baseline 36ca59f, the 17 library/in-process-door rows (the three
timing/spawn cells drift-a/b6b/b5c excluded as the printed residual -- no
mutant targets timing or the spawn path).

  class          mutants (kills)
  pricing/Kraft  M90 declmass-unpriced (b2b) | M91 aritymass-couples-pairs
                 (b2c) | M92 declmass-zeroed (b2d,b3a,b3b)
  tie-break      M93 dpair-branches-swapped (b3b)
  null-cap       M94 breadth-adds-no-family (broad, 10 rows -- the b2a
                 reachability witness) | M95 null-face-dropped (b1b,b2c,b2d,
                 b4a,b5a,b6d) | M96 nullconst-mispredicts (b4a, narrow)
  door-refusal   M97 okpair-allows-equal (b4c) | M98 null-k-guard-dropped (b4c)

RE-TRIAGE: all seven now REACHED, zero UNREACHED -- OB-33's hypothesis
(class-deficient pool, not greens-that-cannot-fail) CONFIRMED.  FOUR earn a
unique seat: b2b(M90), b2c(M91), b4a(M96), b4c(M97/M98); plus b3b earns M93.
THREE are SHADOWED, each ARGUED (dyadic R7 -- the row-value question is the
sitting's): b2a (a whole-enumeration Kraft invariant, structurally
un-isolable by a single-family edit), b2d (a three-price positivity
conjunction), b3a (PROVABLY robust to the tie-break DIRECTION mutants M93 and
a probe M99 -- the declared set [(3,2),(2,3)] is swap-symmetric, so atom 3
stays argmax at P=0.757; b3a falls only to family PRESENCE, the R-RED
honest-decline recorded in the matrix).  ONE INSTRUMENT BUG caught and fixed
before the trusted run: the naive "<name>: FAIL" parser silently dropped
every REPORT row (b2c/b3a/b4a) -- the impossible "M94 kills b2b not its twin
b2c" exposed it; the parser now keys on tasty's per-failure rerun hint (a
green-that-cannot-fire in the instrument, the triptych's harness-gate law).

================================================================
## 3. Frozen-layer inventory (for the author's install)
================================================================

Drafts ready in `chooseeu-sitting/drafts/FL-repairs.txt`:
- **FL-1** (membrane-wire.md §2 menu bullet): installs as a dated
  HISTORY bracket — under the third shape the frozen sentence is now
  TRUE (clockless routes policyPick), so the bracket records the period
  it was false (trampoline-freeze -> this close) and the #24 checkpoint
  lost to it.  Amended for option (3); one reading only.  Manifest-
  covered; author edit + re-sign.
- **FL-2** (CLAUDE.md Porting order last para): repoint the roadmap from
  the self-declared-historical archive/HOSTS_PLAN.md to EXACT_PLAN.md
  §13.0.  Manifest-covered; author edit + re-sign.
- **FL-3** (EXACT_PLAN.md status header): dated supersession note.  Not
  manifest-covered; cheapest.

Dates need finalizing at install (drafts carry 2026-09-01; the close is
2026-09-03) and FL-1's historical citation should point at the pre-r0a
commit.  The r0a change makes the "zero src consumers" wording TRUE, so
NO extra record correction is owed (mandate 5 resolved by migration).

================================================================
## 4. Obligation dispositions (OBLIGATIONS.md — author edits)
================================================================

- **OB-24** (Get-of-writable utility; substitution normative): DISCHARGE
  at this boundary — the third shape + runEpisode migration make
  substitution the executable route everywhere the agent selects;
  chooseEU frozen-in-place, zero consumers, g2 pin retained.
  -> DISCHARGED@selection-freeze-r1.
- **OB-33** (breadth pool classes + 7-row re-triage): its STANDING-
  CONDITIONAL trigger ("the next increment that runs a kill matrix")
  FIRES now, and BOTH halves are done — the selection matrix (§2,
  audit/mutants/M82-M89) and the breadth matrix + re-triage (§2,
  audit/mutants/M90-M98 + test-breadth/close-kill-matrix.txt): the four
  named classes cut, the seven rows re-triaged (all REACHED, 4 EARNED /
  3 SHADOWED-and-argued / 0 UNREACHED), the hypothesis confirmed.
  -> DISCHARGED@selection-freeze-r1 (both the selection and breadth
  mutant patches + the driver ride the author's MANIFEST re-sign, as
  M73-M81 did at the heir close).
- **OB-30** (reviewed prose never through a shell-word parser): stays
  STANDING-CONDITIONAL; record this increment's instances — freeze.sh
  and freeze-r0a.sh both route the tag message through -F (a file),
  never -m; the tag-message-is-a-file law honored twice more.
- **R5** (the tick's two-arrow geometry): the published-record row, per
  clause 6.

  > [CORRECTED 2026-09-04 at the #24 sitting's close.  The label above --
  > "R5 (the tick's two-arrow geometry)" -- misnames the ruling.  R5 is NOT the
  > tick's geometry; per chooseeu-sitting/CONFERRAL.md it is the PUBLISHED-RECORD
  > inventory row: "standing, ONE row, BOTH arrows (our record re-read at HEAD;
  > the filer's repo fetched before any disposition), triage-only."  It lands as
  > OB-34, not a note beside OB-30 (R6's discipline).  Appended, not silently
  > fixed -- this pack is of-record.]

================================================================
## 5. drift-a ratio re-mint (test-breadth — author edit)
================================================================

The frozen drift-a gate's absolute-ms bands false-red under box load
(measured at r0 impl: window means ~1.64x inflated, but the box-invariant
deep/shallow RATIO 2.0012 vs frozen 2.0092 IN BAND).  r1 register R8 /
chooseeu-sitting-r0 clause 6 schedule the re-mint to RATIO form.  After
it, the real gate 5 (cabal test all) runs quiet+serial for the full-green
close.  Unaffected by r0a (runEpisode is not on the base route).

================================================================
## 6. The author's close checklist
================================================================

1. Push the r0a chain (`git push origin master --follow-tags`) if not done.
2. Land audit/mutants/M82-M89 (+ any breadth-class mutants) — builder-
   authored, MANIFEST re-sign covers them.
3. Install FL-1/2/3 under the inventory (§3); dispose the M1/M3/M4 nits.
4. OBLIGATIONS rows (§4); L5 rev 2.
5. drift-a ratio re-mint (§5); run the full gate 5 quiet+serial.
6. MANIFEST re-sign; close tag `selection-freeze-r1` by -F.
7. Close #24 citing the freeze (the wire AND library episode path now
   select the declared argmax).
