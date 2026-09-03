# The selection increment's under-determination register (oracle phase)

For the author at the freeze.  Each row: what the ruling left open, what
the builder chose, and where the choice is visible.  Nothing here
amends the ruling; everything here is strikeable at the freeze.

1. **The reference's name: `policyPickKS`.**  The ruling fixes the seat
   (in the library, exported, pinned) but not the name.  Chosen to read
   as "policyPick's chooseKS form"; the stub, its export, and the
   prophecy all carry it.  Rename at the freeze is a two-file edit
   (Membrane + suite) plus prophecy regeneration.

2. **The heavy-row form: `--skip-heavy`, printed.**  Rows s7/s10 are
   infeasible at the PRE-increment expansion by measurement (A1/F9),
   so the oracle-phase red run passes `--skip-heavy` and the suite
   prints the skip and its reason; the stanza runs bare (heavy rows
   included) so gate 5 exercises them from the implementation onward.
   Their reds ride the defect-overlay transcript.  Alternative the
   author may prefer: two stanzas (light/heavy).  The builder chose
   one suite + a printed flag as the smaller surface.

3. **The s6 theta departure from profileP2** (documented in the suite
   header and defect-sweep.txt reading 5): symmetric theta made the
   guarded cell a hidden tie cell; the frozen grid is asymmetric.
   The copy is a WORLD (data), so no generator is violated; the
   departure is stated where the copy is.

4. **The d1 mutant's `_iFeats` rider** (defect-sweep.txt spec d1):
   the both-challenger rewiring orphans a binder under -Werror; the
   minimal mutant carries the rename.  audit/mutants (landing at the
   close, OB-33) inherits the rider.

5. **Sibling shadowing recorded**: s4/s5/s7 and s8/s10 share kill
   signatures within the birth pool (defect-sweep.txt reading 4);
   verdicts at OB-33's matrix run, per the dyadic R7 pre-ruling.

6. **The think-side scope**: the clock path's think-VALUE machinery
   (thinkValue's preposterior recursion) is untouched by the ruling
   and unpinned here beyond s8/s9/s10's outcome rows; its standing
   pins are the trampoline crossing rows (green against the overlay,
   sat-run.txt).  The builder read clause 5's "pickWire routed
   through the family" as outcome-level, not as a new preposterior
   oracle.

7. **The wire hellos are generated, not quoted**: helloFor derives
   every cell's hello from the same value list that builds its
   library utility (the one-generator law); #24's cell uses the
   issue's values 10/100/50 and the f1 transcript's reply substring
   as its expected value.  The issue body's verbatim JSON is NOT
   embedded — the generated hello declares the same world (same
   namespace/guards/theta/menu/said composition, whitespace aside).
   If the author wants the issue's exact bytes as a second fixture,
   it is one more wireRow.

8. **The INVALID first gate-5 rehearsal** (an instrument incident,
   recorded honestly): the first `cabal test all -j1` rehearsal ran
   in the background WHILE the defect sweep and the SAT
   re-verification ran cabal in the SAME dist-newstyle — so mid-run
   library rebuilds (defect-patched ones included) could land under
   a suite's feet.  It reported breadth 19/20 with the failing row's
   identity lost to a tail-truncated capture whose exit line read
   the PIPE'S tail status besides (the close.sh SIGPIPE class,
   recommitted the same day in a new coat).  That run is EVIDENCE OF
   NOTHING and is not in this directory; gate5-rehearsal.txt is the
   SECOND run — clean overlay, solo, serialized, pipefail-honest
   capture.  The lesson generalizes the #19 sitting's serialization
   law from "same box" to "same build dir": a shared dist-newstyle
   is a shared instrument.  The REAL gate 5 at implementation runs
   serialized alone.

---

## r0a re-open — the runEpisode migration (added 2026-09-03)

The six red-team mandates over the implementation (87f5066) returned
five-clean; **mandate 5** found the frozen prophecy migrated only the
WIRE selection, leaving `runEpisode` (the library episode runner,
exported) on the act-blind `chooseEU` at `Membrane.hs:460`.  The author
ruled **RE-OPEN**.  These rows are the s11 row's under-determination,
strikeable at the r0a freeze exactly as 1-8 were at r0.

9. **s11 hand-rolls World/PureWorld/Pilot** — nothing in the repo
   constructs any of the three (verified by exploration).  s11 builds
   the FIRST `PureWorld` in the codebase (four functions: `const
   feats24`, `const Nothing`, `const [("act",[1,2,3])]`, `\s _ -> s`)
   and a minimal #24 `World`.  The one-generator law is honored at the
   level that drives the pick: `vals24`/`uFromValues` (utility), the
   act grid, `feats24`, the obs carrier — all reused verbatim.

10. **The belief-invariance argument (why the World's tau/rho are
    free)**: runEpisode routes through `enumerate w`, which guards
    EVERY name and forces walks — so its agent is NOT `agent24`.  But
    `uFromValues` is belief-blind (each arm's `Mul (Var (S Z)) (mintQ
    0)` zeroes the belief), so each candidate's EU equals its raw
    value regardless of the agent, and the selected act is invariant
    to tau/rho.  Stated in the `world24E` comment; executed both ways
    (RED act 1 under chooseEU; SAT act 2 under policyPick).

11. **The chooseEU title demotion bundled into prophecy-r0a.diff**:
    mandate 5's second half — chooseEU's `Membrane.hs:159` "THE
    SELECTION" title collided with policyPick's.  After r0a chooseEU
    has zero src consumers; its title is demoted to "THE ACT-BLIND
    BINARY PREDECESSOR".  A comment-only hunk beside the migration —
    strikeable if the author wants the one-line migration alone.

12. **s11's unique kill (for OB-33)**: nothing else exercises
    runEpisode, so a `runEpisode-uses-chooseEU` mutant is killed ONLY
    by s11 — the seat is earned against the standing pool.  Lands in
    the close matrix beside d1-d7.

The r0a transcripts: `r0a-red-run.txt` (s1-s10 PASS, s11 FAIL, EXIT=1)
and `r0a-sat-run.txt` (all 11 PASS via cabal against the migrated
overlay, EXIT=0; the R-D21 satisfiability is the overlay form, folded
in — the sat-run precedent).
