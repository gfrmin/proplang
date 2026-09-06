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
  test-wire/Wire.hs                     the wire oracle
  test-paper/sitting/*                  the brief, its generator, the drift evidence
  test-paper/freeze/*                   the close kit (7 files)

and mints the terminus tag paper-freeze-r0 by -F <file> (the tag-message-is-a-
file law). `test-paper/check.sh --close` then verifies the coverage, the
manifest, and the tag. That tag is the attestation and the terminus.

Expected manifest size afterwards: NO NUMBER IS WRITTEN HERE. pre-close-check.sh
prints it ("EXPECTED POST-CLOSE MANIFEST SIZE: N rows"), computed from the live
manifest plus its own ADD array. TWO manifest-covered files are re-hashed IN
PLACE, not added: CLAUDE.md (FL-P1) and proplang.cabal (the test-wire stanza);
re-hashes do not move the count, only ADDs do.

  [This paragraph is a CROSS-CHECK, not a source. The ADD set's one generator is
  pre-close-check.sh's array, which close.sh sources; these numbers are here to
  be compared against it and to fail loudly if they disagree. They already did
  once: this row read "255 rows (243 + 12 ADD)" while an FL-row below read 13/256,
  a stale reader's copy inside the very inventory that hunts them. Corrected
  2026-09-05 at the sitting's finding. If you are reading this and the counts
  disagree with pre-close-check.sh, THE ARRAY IS RIGHT.]

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

    run 3   ratio 2.1128     window means +103% over frozen
    frozen  1.9078           gate band +/-0.03

The builder's earlier "straddles, so noise not regression" was a two-sample
reading and is WITHDRAWN as premature. It was measured instead, eight samples
of the cell alone (test-paper/sitting/drift-distribution.txt, the transcript;
the frozen value and band are READ from Breadth.hs, never re-typed):

  samples  1.7575  1.8504  1.9204  1.9638  2.0568  2.1121  2.1672  2.2391
  median   2.0103   mean 2.0084   stdev 0.1644   spread 0.4816
  frozen   1.9078   band +/-0.0300
  inside the band: 1 of 8  (2 below, 5 above)
  stdev / half-band = 5.5x
  95% CI of the mean: [1.8710, 2.1459]  -- CONTAINS the frozen value

TWO FINDINGS, and only the first is decisive.

(1) THE GATE CANNOT RESOLVE ITS OWN BAND ON THIS BOX. Run-to-run scatter is
5.5x the band's half-width and one run in eight lands inside it. A single
sample of this cell is not a measurement of the quantity the gate names,
whatever that quantity's true value. This holds independently of (2).

(2) THE CENTRE HAS NOT BEEN SHOWN TO MOVE. The mean sits +0.1006 above frozen
with SEM 0.0581, and the 95% CI contains 1.9078. So these data do NOT
establish a stale mint. NO REGRESSION IS INDICATED, AND NO CLEAN BILL OF
HEALTH IS CLAIMED — both readings stay open, and what is closed is that this
gate cannot tell them apart here.

NEITHER FINDING LICENSES A RE-MINT. A value re-minted from a box that cannot
resolve it would bake today's contention into the frozen layer. And note the
residual's own arithmetic: a median of k runs has SEM 0.0581 at k = 8, still
outside a +/-0.03 band, so "gate on a median" would need a far larger k or a
wider band — the statistic and the band have to be chosen together.

WHAT THIS MEASUREMENT DOES NOT ANSWER (the sitting's correction). It answers
"can the gate resolve its band UNDER LOAD?" — no. It does NOT answer "must
gate 5 be skipped?" Those are different questions, and the eight loaded
samples cannot license the skip on their own. The co-residents suspend
LOSSLESSLY (kill -STOP, resumed by -CONT: a four-day computation is kept, and
a stopped process stops touching memory, which is the very contention channel
this row identifies), so the gate's own design premise — stability between
mint and re-measure on the same box — is restorable in half an hour. The
quiet-box attempt is therefore OWED BEFORE the skip, and its result is
recorded under "THE QUIET-BOX ATTEMPT" below.

CUSTODY OF THE EVIDENCE (the sitting's third finding; silence was the one
wrong option). The signed attestation quotes drift-distribution.txt, so the
evidence a tag leans on must have a declared custody. DECLARED: BOTH
test-paper/sitting/drift-distribution.sh AND test-paper/sitting/
drift-distribution.txt ENTER THE ADD SET and are manifest-covered at this
close, alongside the sitting brief and its generator. They are not "sitting
record riding unfrozen": an attestation in a signed tag citing an unfrozen
transcript would let the cited evidence change under the signature, which is
the stale-green class with the tag's own weight behind it. The generator ships
with the artifact it generates (the generator exemption), and re-running
--summarise over the recorded runs is its standing identity check.

THE KIT ALREADY KNEW. test-selection/freeze/measure-drift.sh's header says it
in terms: "load STILL nudges it past the +/-0.03 band, so it is NOT invariant.
What makes the gate pass is that the frozen value IS this box's own
measurement and gate 5 re-measures on the SAME box: keep the box quiet/stable
between this read and gate 5 and the delta is ~0." So the gate's design
premise is STABILITY BETWEEN MINT AND RE-MEASURE, the mint was taken
2026-09-04 (83e29ec), and that premise has since been violated. The
"box-invariant" claims below were therefore contradicted by a file in their
own kit at the moment they were written — this row is not new information
defeating an old argument so much as one half of the kit convicting the other.

THE MECHANISM, SHARPENED. `timedFold` measures CPU time (`getCPUTime`), not
wall clock, and a timed run shows `user` ~= `real` (9m49s of 9m53s) — so the
process is NOT being starved of a core, and the inflation is not scheduling
wait, which CPU time excludes by construction. What inflates it is CACHE AND
MEMORY-BANDWIDTH CONTENTION: co-resident jobs evict working sets, so the same
logical work costs more real cycles. That is also WHY it does not divide out
of a ratio — a deep fold has a larger working set than a shallow one, so
contention hits the two windows DIFFERENTLY and the effect is depth-dependent
by construction. The r0 observation that bought the construction argument
(ratio moving ~3.6% while means inflated ~97%) held at ITS contention level
and does not hold at this one.

This also refines the residual: a precondition keyed on LOAD AVERAGE would be
the wrong instrument, because load average does not measure memory
contention. A cell whose gate depends on cache behaviour must either measure
a statistic the box can resolve, or decline to report.

THE HONEST STATEMENT: the ratio is LESS box-sensitive than the absolute-ms
band, not box-invariant. The construction argument was too strong; the
measurement has now said so.

REPAIR FORM. Normative/instructional prose (the two kit lines) is repaired IN
PLACE, striking "box-invariant" for "load-robust (not load-invariant -- see
FL-P5)". The pack's section 5 is CLOSE-DATE RECORD, so it takes a dated
bracket quoting the falsified clause, not a rewrite.

THE NAMED RESIDUAL (post-terminus, demand-gated, but NAMED HERE so it is not
lost). Drafted as two options and MERGED AT THE SITTING into one, because the
row's own arithmetic already pointed there: a precondition that only refuses
(option a) still leaves the band unjustified, and a re-minted band (option b)
still leaves a single sample gating a quantity it cannot resolve. THE ONE
FORM: at gate time the cell TAKES k QUICK SAMPLES, MEASURES ITS OWN SCATTER,
and REPORTS ONLY WHEN IT CAN RESOLVE THE BAND, DECLINING OTHERWISE. Statistic
and band chosen together; resolution MEASURED rather than proxied. That last
clause retires the load-average idea for the reason this row itself gives --
load average does not measure memory contention, and the thing to test is
whether the instrument can see, not whether the box looks busy. It is the
two-sided-instrument law applied to a timing gate: a cell that cannot measure
should decline to report, and it should be the one that knows.

NOTE ON SCOPE: this row does NOT gate paper-freeze-r0. It records a falsified
claim at the boundary where the falsifying evidence arrived, which is the
frozen-layer-inventory law working as intended. The author may install it here
or route it to whichever boundary next touches those files.

  [BRACKET ADDED 2026-09-06, after the quiet-box attempt this row itself
  declared OWED was executed. THREE clauses above are falsified by it, and
  each is quoted inside its own repair rather than edited away.

  FALSIFIED: "(1) THE GATE CANNOT RESOLVE ITS OWN BAND ON THIS BOX." True
  UNDER LOAD, and false as an unconditional claim about the box. Quiet (both
  co-resident units stopped and verified, load ~1.5, n=3,
  test-paper/sitting/drift-quiet.txt): stdev 0.0087, which is 0.29x the
  half-band, against 5.48x loaded. THE CELL RESOLVES ITS BAND FINE ON A QUIET
  BOX. The repaired statement: the cell's RESOLUTION is a function of box
  state, and this row's decisive finding holds for the loaded state it
  measured, not for the box as such.

  FALSIFIED: "(2) THE CENTRE HAS NOT BEEN SHOWN TO MOVE." It has now. Quiet
  n=3: mean 1.9474, 95% CI [1.9258, 1.9691], which EXCLUDES the frozen
  1.9078. The loaded CI contained it only because the loaded scatter was too
  wide to exclude anything -- the earlier reading was an artifact of the very
  unresolvability finding (1) reports.

  FALSIFIED, AND THE MOST IMPORTANT OF THE THREE: "this row does NOT gate
  paper-freeze-r0." IT NOW DOES. Gate 5 reds on drift-a, the cell resolves,
  and the red is therefore informative -- so under the author's standing law,
  NEVER FREEZE A KNOWN BUG OR HOLE, the close is BLOCKED here.

  ATTRIBUTION, MEASURED RATHER THAN ARGUED
  (test-paper/sitting/wire-attribution.txt). Breadth.hs pre-declares a
  LICENSED RE-MINT for "a module addition reintroduc[ing] a cross-build
  divergence ... never a silent widening". Exactly one commit touched src/
  since the mint (54e7884, the wire repair), so its parent 113d29a was built
  and the arms interleaved:

    PRE  (no wire repair)  n=3  mean 1.9815  stdev 0.0012  vs frozen +0.0737
    HEAD (wire repair)     n=2  mean 1.9573  stdev 0.0074  vs frozen +0.0495

  DECOMPOSED, because a bare verdict hides half of this:
    (A) the increment's own shift, -0.0241: REAL (4.5x the pooled within-arm
        scatter, 80% of the band), and precisely the clause's case -- but it
        moves TOWARD frozen, not away.
        [CONFOUND TESTED AND EXCLUDED, same day. The PRE arm was a FRESH
        worktree build while the HEAD arm was the existing incremental
        dist-newstyle, so (A) had a second candidate cause the interleave did
        not control: build provenance. A third arm built HEAD fresh and
        measured 1.9533, agreeing with HEAD-incremental's 1.9573 to within
        0.0041 -- inside the within-arm scatter -- against PRE-fresh's 1.9815.
        Pooling every HEAD sample across both build routes gives 1.9553 vs
        PRE 1.9815, a shift of -0.0262. (A) is a real code effect. This
        SHARPENS (A) and leaves (B) untouched.]
    (B) a baseline gap of +0.0737 that survives WITHOUT the increment.
  The clause licenses absorbing (A). A re-mint would silently absorb (B) as
  well, and (B) is the larger term and the unexplained one. SO NO RE-MINT IS
  LICENSED HERE.

  AND THE MINT IS NOT STALE-FROM-ELSEWHERE: 1.9078 was minted on THIS box on
  2026-09-04 (83e29ec, "box-robust: measure on the gate's own box"), and
  test-breadth/freeze/2-freeze.sh aborts if gate 5 ran in mint mode, so mint
  and gate were separate runs. (B) is a real change in this box across two
  days. WHAT changed is NOT answered by these data, and the builder has not
  guessed at it. That question is the open item the close now waits on.

  ONE BUILDER CLAIM WITHDRAWN. The runbook and the conferral both said the
  shift was "not attributable to this increment" because drift-a "never calls
  serveLine". That reasoning is about the CALL GRAPH and does not cover a
  codegen shift across the whole library, which is the mechanism Breadth.hs's
  own clause names. The conclusion survives -- (A) does not explain the gap --
  but it survives BY MEASUREMENT, not by that argument, and the argument
  should not have been stated as settled.

  THE RESIDUAL NAMED ABOVE IS UNCHANGED AND STRENGTHENED. "At gate time the
  cell takes k quick samples, measures its own scatter, and reports only when
  it can resolve the band, declining otherwise" now has a second demonstration:
  the same cell that could not resolve at load 14 resolves at 0.29x when
  quiet, so a cell that measured its own scatter would have DECLINED in the
  first case and REPORTED in the second -- exactly the discrimination the gate
  currently cannot make.]

================================================================
CUSTODY
================================================================

The builder drafted PAPER.md, test-paper/check.sh, and this inventory (all
unsigned, no frozen file touched). The author installs FL-P1/FL-P2 under their
key at the sitting, extends and re-signs MANIFEST (FL-P3), and mints
paper-freeze-r0. A turnkey do-close.sh-style kit for this freeze (the author's
standing preference) is a follow-on once this draft is reviewed — not part of
this drafting pass.
