# The selection oracle's FREEZE KIT (author acts; nothing here is the builder's to run)

The oracle phase is complete: suite red at HEAD (red-run.txt), SAT
against the prophecy (sat-run.txt), the birth pool separated
(defect-sweep.txt), the register beside it (register.md).  The freeze
makes the oracle binding.  Four acts, all the author's:

1. **Review** — the suite (test-selection/Selection.hs), the register
   (strike or amend any row), the prophecy (freeze/prophecy.diff — the
   implementation you are licensing), and the transcripts.

2. **Splice the stanza** — append stanza.cabal.draft's stanza block to
   proplang.cabal (manifest-covered; your edit).  `cabal test
   selection` then runs the suite red (skip-heavy note: bare cabal
   runs the heavy rows — they hang at the PRE-increment expansion, so
   between splice and implementation run the suite standalone with
   --skip-heavy, or splice at the same sitting the implementation
   lands, which is the trampoline precedent).

3. **Extend and re-sign MANIFEST.sha256** — new rows:
     test-selection/Selection.hs
     test-selection/stanza.cabal.draft
     test-selection/freeze/red-run.txt
     test-selection/freeze/sat-run.txt
     test-selection/freeze/defect-sweep.txt
     test-selection/freeze/gate5-rehearsal.txt
     test-selection/freeze/register.md
     test-selection/freeze/prophecy.diff
     test-selection/freeze/freeze-kit.md
     test-selection/freeze/r0-tag-msg-draft.txt
   plus the RE-HASH of proplang.cabal (the splice changes it).
   From your signature these are as frozen as test/.

4. **The tag** — `git tag -s selection-freeze-r0 -F <the message
   file>` over the freeze commit (the tag-message-is-a-file law; the
   drafted message is r0-tag-msg-draft.txt beside this kit, yours to
   amend).  Fast-forward publish; never the merge button.

THE DRIFT-A SEQUENCING (gate5-rehearsal.txt): breadth's drift-a
timing band cannot pass on this hardware (the control reds it on
clean HEAD too — box load, not the overlay).  Its ratio-form re-mint
is a clause-6 close rider (r1 register R8) and is what makes gate 5
green at the implementation phase.  ORDERING: the re-mint (a frozen
test-breadth/ edit, the author's key) precedes or accompanies the
implementation's gate-5 run; until then gate 5 is 19/20-with-the-
timing-instrument-pending, exactly as the rehearsal records.  The
real gate 5 also runs on a QUIET box.

WHAT THE FREEZE OPENS: the implementation phase — prophecy.diff
applied byte-for-byte (any deviation is a stop-and-report), gates 1-7
green with the selection suite absorbed by gate 5, anchors
byte-stable, then the close (OB-33's kill matrix with d1-d7 landing
in audit/mutants/, the six mandates, the FL repairs, L5 rev 2, the
OBLIGATIONS rows, drift-a's ratio re-mint, the close tag under
selection-freeze-r*).

CUSTODY: the oracle-phase tree is a builder commit, unsigned by
design; the builder never touches proplang.cabal or MANIFEST.sha256 —
steps 2-3 are what makes this a freeze rather than a suggestion.
