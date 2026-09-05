DRAFT — the step-5 terminus frozen-layer inventory. Builder-authored, NOT
FROZEN, NOT APPLIED. This is the inventory brought to the paper-freeze sitting
(the frozen-layer-inventory law, step-7 unify freeze): the builder touches the
frozen layer only at a boundary, under an inventory the author installs with
their own key. Each row quotes the falsified sentence byte-wise with its anchor
(commit hash + binding/quoted text, R-D20-i), and names the repair FORM the
text class demands. The author installs at the close; nothing here binds.

Anchor commit for the "current text" quotes below: b5e1193 (HEAD at drafting).
Terminus tag anticipated: paper-freeze-r0.

================================================================
FL-P1 — CLAUDE.md, the Porting-order §, the repaired #24 pointer paragraph
Class: NORMATIVE PROSE → repair in-place, falsified sentence quoted in its repair
================================================================

Current text (b5e1193), the binding sentence:

  "Its steps 1-4 are closed (the X.5 sitting; OB-12's run; the trampoline
   boundary, the last language increment; the completeness suite).  ONE ITEM
   REMAINS: step 5, the demonstration tier -- the A-gate reading with OB-12's
   result in hand, the benchmark, and the paper.  AFTER 5 THE ROADMAP
   TERMINATES, and everything else is named demand-gated residue re-entering
   only through the two-sided gate with a measurement."

Why falsified: at paper-freeze-r0 step 5's three parts are all closed — the
A-gate reading executed and posted (#11 CLOSED, 2026-09-02); the benchmark
landed with its band measured-blank (bench r02.5); the paper frozen (PAPER.md).
"ONE ITEM REMAINS" is no longer true.

Repair FORM (in-place, the falsified clause quoted inside its own repair):

  "Its steps 1-4 are closed ... [ROADMAP TERMINATED at paper-freeze-r0,
   2026-09-05. This paragraph read 'ONE ITEM REMAINS: step 5, the
   demonstration tier -- the A-gate reading ..., the benchmark, and the
   paper.  AFTER 5 THE ROADMAP TERMINATES', and that was true until this
   freeze. Step 5's three parts are now closed: the A-gate reading was posted
   (#11), the benchmark landed (band measured-blank, bench r02.5), and the
   paper is PAPER.md, frozen here. The roadmap has terminated exactly as the
   quoted clause said it would. Everything beyond is the named demand-gated
   residue, re-entering only through the two-sided gate with a measurement.]"

================================================================
FL-P2 — EXACT_PLAN.md §13.0 (THE DESTINATION MAP), the step-5 clause + footnote
Class: HISTORICAL/RECORD prose → dated terminus bracket (not an in-place rewrite)
================================================================

Current text (b5e1193), the step-5 clause (§13.0, ~line 673):

  "(5) The demonstration tier — A-gate reading with OB-12's result in hand,
   the benchmark, the paper; the paper's claim set is then: necessity by
   executed deletion, sufficiency by executed interpolation, soundness by four
   gates, exactness by ==, closure by E4, and a live host. AFTER 5 THE ROADMAP
   TERMINATES."

And the status footnote (§13.0, ~lines 683-686):

  "(Status annotations as of this draft: the X.5 sitting is PREPARED —
   x5-author-pack.md; OB-12's run is EXECUTED ...)"

Why falsified: the step-5 clause is a charter preamble installed verbatim from
the author's 2026-07-26 directive — it PRESCRIBES the destination and should be
kept verbatim as the record of the charter. What is stale is the STATUS: the
footnote still says X.5 "PREPARED" (it is sealed, x5-sitting-r0) and frames
step 5 as pending. The clause's own body correctly predicts the terminus.

Repair FORM (a dated terminus bracket appended to §13.0; the charter clause and
the original footnote kept verbatim as record):

  "[TERMINATED 2026-09-05 at paper-freeze-r0. Step 5's three parts are closed:
   the X.5 sitting sealed (x5-sitting-r0), OB-12's reading posted (#11); the
   benchmark landed with its acceptance band measured-blank (bench r02.5, the
   O(t)-bits falsifier); and the demonstration paper is PAPER.md, frozen here
   with test-paper/check.sh. The roadmap terminates at this line exactly as the
   step-5 clause above prescribes. The status footnote's 'X.5 is PREPARED' is
   the draft-time annotation, superseded by x5-sitting-r0. Everything after is
   named demand-gated residue: the quine face, OB-15, OB-19, continuous
   carriers (foreclosed), brief §6 self-compression — a research programme,
   named not scheduled.]"

Note: EXACT_PLAN.md is NOT manifest-covered (per the selection-freeze-r1 FL-3
precedent, which added a supersession note to the same file without a MANIFEST
re-sign). Confirm at the sitting; if unchanged, this bracket rides without a
re-hash of EXACT_PLAN.md, but PAPER.md and test-paper/check.sh DO enter MANIFEST.

================================================================
FL-P3 — new-file MANIFEST coverage (the key act, author only)
================================================================

Not a prose repair — the close's MANIFEST motion. At paper-freeze-r0 the author
extends and re-signs MANIFEST.sha256 to cover the new files. The set is
ENUMERATED ONCE, in test-paper/freeze/pre-close-check.sh's ADD array, which
close.sh SOURCES rather than re-declares (the one-generator law applied to the
kit itself); this list is a reader's copy, not a second generator:

  PAPER.md                              the capstone
  test-paper/check.sh                   its machine check
  test-paper/terminus-inventory.md      this file
  test-paper/hello9.sh                  the live-host generator (section 7)
  test-paper/hello9-transcript.txt      the artifact it generates
  test-paper/freeze/*                   the close kit (7 files)

and mints the terminus tag paper-freeze-r0 by -F <file> (the tag-message-is-a-
file law). `test-paper/check.sh --close` then verifies the coverage, the
manifest, and the tag. That tag is the attestation and the terminus.

Expected manifest size afterwards: 255 rows (243 + 12 ADD; CLAUDE.md is
re-hashed in place under FL-P1, not added).

================================================================
FL-P4 — A STOP-AND-REPORT, RULED AND CLOSED
Class: NOT A FROZEN-LAYER REPAIR — a docket item, now discharged
================================================================

DISPOSITION: the author ruled "never freeze a known bug or hole" — branch (b)
below. The defect is FIXED, under the test-wire increment, and the terminus now
waits behind a wire that is fail-closed in fact and not only in most cases. The
fork below is kept as the record of what was decided and why; the ruling line
is the last paragraph of this row.


Recorded here because it reached the increment after the inventory was first
drafted, and the sitting must see it beside the rest.

Executing the live-host witness the author's freeze review asked for (promote
claim 6 from ARGUED to EXECUTED) found a REAL DEFECT in the shipped host. An
undeclared name inside a hello's UTILITY is not validated at hello time: the
hello is ACCEPTED, and the failure surfaces only when the utility is evaluated
— as a HOST-PROCESS CRASH at evalx's Get case, not as a wire error. Menu and
guard names ARE namespace-checked; the utility's Get names are not. A one-option
menu never evaluates the utility, so the defect stays latent; with two or more
options it fires on the first decision tick. The error site's own comment calls
itself "door-unreachable" — the wire reaches it, so that comment is falsified as
well.

Reproduced in test-paper/hello9-transcript.txt, leg 3.

NOT FIXED HERE, and deliberately so: the repair moves src/, which is a language
surface motion, and this is a document boundary. Nothing under src/ was touched.
PAPER.md section 9 states it as a bound on the refusal claim; the claims register
carries it as its own EXECUTED row (the defect FIRES, so the row is executed, not
argued); leg 3 is expected to stay red, and a green there would mean the defect
was fixed without this paper being updated.

THE RULING WAS THE AUTHOR'S, and it was a genuine fork:
  (a) MINT THE TERMINUS as drafted — the hole is known, stated, bounded and
      witnessed, and the paper is more honest for carrying it than for not; the
      fix then re-enters as demand-gated residue like everything else past the
      terminus.
  (b) RE-OPEN for a wire increment first — validate utility Get names against
      the declared namespace at hello time, so the terminus is minted over a
      wire that is fail-closed in fact and not only in most cases.

RULED: (b), on the author's line "never freeze a known bug or hole".

AS EXECUTED (the test-wire increment, oracle-first):
  - test-wire/Wire.hs, a new cabal test-suite stanza, written and run RED
    against the shipped pre-increment surface FIRST: w1a/w1b/w1c, w2a/w2b and
    w5a red (6 rows), w3a/w3b and w4a/w4b green (4 control rows). The controls
    are part of the assertion: a repair that refused every utility would turn
    the six green and the four red, so only the correct repair is all-green.
  - The fix: the hello door's existing namespace gate — which always checked
    guard and menu names — now checks the utility's reads with THE SAME
    predicate at THE SAME site (src/PropLang/Host.hs), using a new total
    traversal readNames in Enumerate.hs beside inCorpus. No constructor, no
    production, no type on a frozen surface; no primitivity gate and no
    ablation fixture is owed, because no terminal enters or leaves. This is a
    CONFORMANCE REPAIR: membrane-wire.md section 2 already declared the
    behaviour ("Unparseable or unpriceable declarations are validation
    failures — FAIL-CLOSED"), and src did not honour it for one surface.
  - Green: cabal test wire 10/10. Gates 2, 3 and 4 re-run clean.
  - The refusal is the one the sibling names already got, so the wire grew no
    new error vocabulary: {"error": "names outside namespace"}.

MANIFEST CONSEQUENCE: test-wire/Wire.hs joins the ADD set (13 rows now), and
proplang.cabal joins CLAUDE.md in the RE-HASH set, since the stanza edits a
manifest-covered file. Both are derived by close.sh from sha256sum -c.

================================================================
FL-P5 — THE DRIFT-A RATIO IS NOT BOX-INVARIANT, MERELY LESS BOX-SENSITIVE
Class: NORMATIVE + RECORD prose falsified by measurement → repair in place
       (normative) and bracket (record); AUTHOR INSTALLS, all four are
       manifest-covered
================================================================

Raised by the author at the paper-freeze-r0 sitting, on evidence this increment
produced. Recorded per programme norm: a construction argument that measurement
has falsified is corrected on the record, at the boundary, under the key.

WHAT WAS CLAIMED. The selection-freeze-r1 ruling installed the drift-a gate in
RATIO form on the argument that the ratio is box-INVARIANT by construction.
Current texts (all manifest-covered, so each is a re-hash at whatever boundary
installs the repair):

  selection-close-pack.md, section 5, "drift-a ratio re-mint":
    "The frozen drift-a gate's absolute-ms bands false-red under box load
     (measured at r0 impl: window means ~1.64x inflated, but the box-invariant
     deep/shallow RATIO 2.0012 vs frozen 2.0092 IN BAND)."

  test-selection/freeze/do-close.sh, the step-1 banner:
    "# ---- step 1: measure the box-invariant drift ratio ----"

  test-selection/freeze/CLOSE-RUNBOOK.md, step 1:
    "# 1. measure the box-invariant drift ratio (quiet box; a few min; prints
       ONE number)"

  test-breadth/Breadth.hs, the drift-a cell's comment, states the weaker and
  still-true version ("FAR more load-robust ... load still nudges it") and is
  NOT falsified. It is listed here only so the sweep is complete; no repair.

WHAT MEASUREMENT SAYS. At the paper boundary, load average ~13.5 on 8 cores
(a julia process pinning a core for 4d21h, plus clickhouse, uvicorn and two
Claude sessions), two consecutive runs of the SAME cell on the SAME box gave:

    run 1   ratio 1.4956     window means +95% to +200% over frozen
    run 2   ratio 2.3020     window means +101% over frozen
    frozen  1.9078           gate band +/-0.03

A spread of ~0.81 against a band of 0.06, STRADDLING the frozen value. The r0
observation that bought the construction argument (ratio moving ~3.6% while
means inflated ~97%) held at ITS load; it does not hold at this one, because
scheduling noise at saturation is not multiplicative across the deep and
shallow windows and so does not divide out.

THE HONEST STATEMENT: the ratio is LESS box-sensitive than the absolute-ms
band, not box-invariant. The construction argument was too strong; the
measurement has now said so.

REPAIR FORM. Normative/instructional prose (the two kit lines) is repaired IN
PLACE, striking "box-invariant" for "load-robust (not load-invariant -- see
FL-P5)". The pack's section 5 is CLOSE-DATE RECORD, so it takes a dated
bracket quoting the falsified clause, not a rewrite.

THE NAMED RESIDUAL (post-terminus, demand-gated, but NAMED HERE so it is not
lost): either (a) a QUIET-BOX PRECONDITION that REFUSES TO RUN rather than
fails -- the two-sided-instrument law applied to a timing gate, since a cell
that cannot be measured should decline to report, not report noise as a
verdict -- or (b) a band RE-MINTED from measured quiet-box VARIANCE rather
than from a single quiet afternoon, which is where +/-0.03 came from.
Whichever is chosen re-enters through the two-sided gate with a measurement.

NOTE ON SCOPE: this row does NOT gate paper-freeze-r0. It records a falsified
claim at the boundary where the falsifying evidence arrived, which is the
frozen-layer-inventory law working as intended. The author may install it here
or route it to whichever boundary next touches those files.

================================================================
CUSTODY
================================================================

The builder drafted PAPER.md, test-paper/check.sh, and this inventory (all
unsigned, no frozen file touched). The author installs FL-P1/FL-P2 under their
key at the sitting, extends and re-signs MANIFEST (FL-P3), and mints
paper-freeze-r0. A turnkey do-close.sh-style kit for this freeze (the author's
standing preference) is a follow-on once this draft is reviewed — not part of
this drafting pass.
