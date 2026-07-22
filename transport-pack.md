# transport-pack.md — the #18 transport micro-increment (oracle phase)

Builder-maintained, unfrozen. The increment the 2026-07-22 disposition
sitting scheduled ("fix-it, oracle-first ... the first process-level
suite"), opened on the author's go-ahead of 2026-07-22. Scope:
per-line reply delivery over plain pipes — zero semantics, zero
alphabet. `observe_batch` does NOT ride: the sitting's #17 ruling made
its ride conditional ("rides the transport micro-increment [if ruled
with #18]") and no explicit ruling followed; bundling an unruled wire
form would be scope creep. It remains available as its own follow-on.

## 1. The defect (from dispositions-pack.md Part II, #18)

GHC's runtime block-buffers stdout when not attached to a terminal, so
`proplang-host` under `CreatePipe` transports never delivers a reply
line until the buffer fills or the process exits. membrane-wire
promises synchronous JSON-lines over stdio; the first exchange
deadlocks. Confirmed at HEAD at the sitting (probe transcript in the
pack); hosts currently must allocate a PTY (issue #18's workaround).

## 2. The oracle: test-transport/ — the first process-level class

Design law applied: the suite is SEMANTICS-BLIND. Every expected reply
byte is computed at runtime by folding the identical request lines
through the frozen pure core (`serveLine` from `hostStart`) — R-D20's
copy-not-reconstruct taken to its limit: the frozen artifact itself is
the expectation, so no literal can drift and transport is the only
thing the suite can convict. Fixtures are byte-copies with provenance
(worldHead <- test-said/Said.hs:81-84; utility block <- Said.hs:171;
tickDec <- Said.hs:117). Binary resolution is by PATH
(`findExecutable`), supplied by `build-tool-depends:
proplang:proplang-host` under cabal and by the runner's
TRANSPORT_HOST_DIR for standalone runs — the suite never hardcodes a
path. Reply window 5s per line, pre-stated (a passing exchange is
milliseconds; the HEAD deadlock is indefinite).

Rows:
- t1 hello-over-pipes-replies-per-line — RED at HEAD
- t2 lockstep-decision-evidence-silent — RED at HEAD
- t3 error-reply-also-delivered-per-line (fail-closed refusals must
  also be delivered per-line) — RED at HEAD
- t4 eof-flush-parity — GREEN at HEAD: send all four lines, close
  stdin, read to EOF; the exit-flush replies match the serveLine
  composition byte-for-byte. t4 is the ATTRIBUTION PARTITION: the pure
  core's replies are already correct at HEAD and only per-line
  delivery is missing, so t1-t3's red is attributable to buffering
  alone (the pin-freeze precedent's partition discipline, applied to a
  fix-increment).

Runner: test-transport/red-run.sh — the membrane red-run precedent
(`cabal exec -- ghc` against the project package environment) carrying
the STANZA'S EXACT flag set `-Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns`, GHC2021 (flag-faithful, the step-5
amendment). Stanza drafted at test-transport/stanza.cabal.draft
(new build-depends: `process`, `directory` — both GHC boot libraries;
flagged for the author because cabal.project.freeze is frozen and does
not pin them — no edit to the freeze file is required; the resolved
versions are recorded as rider (ii) in section 5 rather than left to
the freeze file's silence).

## 3. The red run (2026-07-22, HEAD binary, exact flags)

    transport (#18): per-line delivery over pipes
      t1-hello-over-pipes-replies-per-line:      FAIL (5.00s)
        hello: no reply line within 5s (the #18 deadlock)
      t2-lockstep-decision-evidence-silent:      FAIL (5.01s)
        {hello line}: no reply line within 5s (the #18 deadlock)
      t3-error-reply-also-delivered-per-line:    FAIL (5.01s)
        bad line: no reply line within 5s (the #18 deadlock)
      t4-eof-flush-parity-attribution-partition: OK (0.11s)
    3 out of 4 tests failed (15.13s)

Compile clean under -Werror; the red is the runtime timeout, the
partition exactly as pre-stated.

## 4. The satisfiability transcript (R-D21, OVERLAY form)

Prototype: a throwaway copy of src/PropLang/Host.hs wearing the real
module name, differing by exactly the intended fix —
`hSetBuffering stdout LineBuffering` as hostMain's first action (plus
the System.IO import extension). The prototype executable was built
from app/Main.hs with the overlay shadowing src, EXACT flag set
-Werror included (the step-5 flag-faithfulness amendment); the
suite's exact drafted text (unchanged) then ran against it via
TRANSPORT_HOST_DIR:

    transport (#18): per-line delivery over pipes
      t1-hello-over-pipes-replies-per-line:      OK
      t2-lockstep-decision-evidence-silent:      OK (0.14s)
      t3-error-reply-also-delivered-per-line:    OK
      t4-eof-flush-parity-attribution-partition: OK (0.07s)
    All 4 tests passed (0.22s)

Every red row's asserted quantity executed once against the prototype;
prototype discarded after the run. Note the implementation is not
landed: src is untouched at this writing (the red run above is against
the HEAD binary and still red).

## 5. The freeze package (one sitting, one tag)

The author accepted custody in its second form: THIS freeze's
countersign carries the sitting record's tag — the tag converts the
sitting's `@dispositions-sitting` discharge marks into custody facts
and seals this oracle in the same signature. The edits, all under the
author's key or fresh per-instance delegation:

1. membrane-wire.md — the Part III.1 var0 repair, approved verbatim
   at the sitting (falsified sentence quoted inside its own repair).
2. membrane-wire.md §6.3 — the UNSHIPPED bracket (Part III.2, adopted).
3. membrane-wire.md §3 — the combined-tick capability sentence (the
   15(c) probe's product). RIDER (i) AT THE KEY: this is the only
   package edit not yet seen verbatim, so it is presented in the same
   form III.1 and III.2 received. Insertion point: immediately after
   the §3 bullet "A tick MAY carry both menu and evidence; semantics
   are the frozen loop's order ... The reply is the union of the two
   shapes." (membrane-wire.md:211-213), as its continuation. Draft:

   > **[Added at the transport freeze, 2026-07-22 — the capability
   > issue #15's probes surfaced, documented here so it is not
   > rediscovered.]** THE COMBINED TICK IS THE ACTION-CONDITIONAL
   > CHANNEL. Evidence folds at `features ++ act` (the step-6
   > geometry), so on a tick carrying BOTH a menu and evidence the
   > chosen assignment is part of the observation's context. A guard
   > declared on a WRITABLE name is therefore NOT inert: D-b2 bars a
   > world from PUBLISHING a writable name as a tick feature, but the
   > engine's own act supplies that name at the fold, and the guard
   > family over it is exactly the hypothesis family "the outcome
   > depends on what I did" — learned P(evidence | action, context).
   > The conditional is over EVIDENCE ATOMS, not outcomes: the wire
   > folds what the channel emitted, and whether that atom IS the
   > outcome or a signal about it is the world's encoding, outside
   > this sentence (R-W1's line — the wire may declare the codomain
   > of observation, never the support of belief about the channel's
   > law). The scare-quoted family name is an informal gloss, not the
   > formal claim.
   > Evidence-only ticks do not feed it (no act is bound to fold
   > against), so a host wanting the capability declares the guard on
   > the menu name and sends combined decision+evidence ticks.
   > Measured at this freeze (dispositions-pack.md VI.5.2): over 60
   > rounds with evidence contingent on the act, the family's
   > posterior mass grows 9.09e-3 -> 1.02e-1 and the act holds for 58
   > consecutive rounds; over an act-independent stream the same
   > family unlearns to 1.89e-9. Hosts should expect the act to
   > alternate while the contingency is untrained — the myopic rung
   > exploring the untried branch — and to settle when the evidence
   > breaks the symmetry.
4. tools/boundary-audit.sh — the OB-16 banked-failure row (flag every
   banked clause-(a) failure whose increment postdates the alphabet
   motion it assumed; the step-10 clause's scriptable half).
5. CLAUDE.md — the triptych clause (Part V, adopted at the sitting).
6. proplang.cabal — append test-transport/stanza.cabal.draft verbatim.
7. OBLIGATIONS.md — OB-19, the K-ary richer-family heir class (the
   #21 cross-citation the sitting owes; draft at section 7 below).
8. MANIFEST.sha256 — re-sign rows for membrane-wire.md, CLAUDE.md,
   tools/boundary-audit.sh, proplang.cabal, OBLIGATIONS.md; add rows
   for test-transport/Transport.hs, test-transport/stanza.cabal.draft,
   test-transport/red-run.sh.
9. tools/prefreeze-lint.sh run; transcript below rides this pack.

**RIDER (ii) AT THE KEY — the boot-library flag, resolved and
recorded.** The stanza's two new build-depends resolve against the
GHC 9.10.3 global package database, NOT against cabal.project.freeze
(which pins neither): `process-1.6.26.1`, `directory-1.3.8.5` (with
`filepath-1.5.4.0`, `unix-2.8.7.0` beneath them). Both ship with the
compiler the frozen gate 7 pins, so the freeze file needs no edit —
but per the rider this is recorded as a DOCUMENTED FACT rather than
an assumption riding a frozen file's silence: the versions above are
what the L7 overlay build and the red/SAT runs actually resolved, and
any future divergence is a gate-7 toolchain change, visible as such.

After the tag: the builder lands the one-line implementation in
src/PropLang/Host.hs (unfrozen; gate 3 places the loop's IO exactly
there), runs all gates + the new suite green, and closes with the
as-built report.

## 6. Pre-freeze lint transcript (2026-07-22, oracle-ready tree)

    PASS  L1 forbidden-tokens-by-glob: 8 src files clean (frozen gate 4 names 5)
    PASS  L2 ASCII test names across test*/
    PASS  L3 MANIFEST.sha256: 79 rows verified
    PASS  L4 all 48 tags verify
    PASS  L5 wire-author-pack.md records the four stanza flags (incl. -Werror)
    WARN  L6 x12 (advisory literal scan; pre-existing class)
    PASS  L7 full-corpus overlay build: every test .hs builds against new src
    === prefreeze-lint: 0 FAIL, 12 WARN ===

Two of the twelve L6 advisories are new and belong to this increment
(test-transport/Transport.hs, red-run.sh): the flagged literals are
the world fixture's grid points and the runner's ghc version path —
the fixture is a byte-copy of the frozen test-said world (that copy IS
its provenance, R-D20), and the runner's path is overridable data, not
a steering constant. Both advisory, neither actionable. L7 confirms
the new suite is inside the full-corpus overlay build's glob — the
step-9 clause's guarantee that no test file escapes the
replacement-surface build, now covering the first process-level suite.
The lint will be re-run at the freeze itself (its transcript is a
condition of the tag); this run establishes the oracle-ready tree is
already clean.

## 7. OB-19 draft — the K-ary richer-family heir class (#21's home)

The cross-citation the author called owed at the countersign: #21 is
the FIRST FIELD DEMAND on the W3 sitting's fifth scoping line
(wire-author-pack.md:511-522, ruling 1 of 2026-07-21), which printed
the one-vs-rest family's structural limit and named "the richer family
— a second, null-rate parameter" as its demand-gated heir. #21's
atom-switching guard family (branches selecting the distinguished atom
as well as theta) and that null-rate parameter are SIBLINGS in one
heir class: both are the same enumeration-breadth extension of the
same family, and both are gated on demand. One row so the gate
accumulates in one place. Draft:

| OB-19 | the K-ary richer family (enumeration breadth beyond one-vs-rest): the null-rate parameter and the atom-switching guard family, one heir class, one demand gate | RULING-PENDING | the W3 sitting's FIFTH SCOPING LINE named the heir (wire-author-pack.md:511-522, ruling 1, 2026-07-21: the null's predictive mass structurally capped at 1/(K-1), "no good hypothesis in this family and never will"); issue #21 is its FIRST FIELD DEMAND, arriving from the other side — guards move theta, never the distinguished atom, so a minority-context cell ties at (1-theta)/(K-1) while its own evidence in isolation is decisive (confirmed at 68 ticks, dispositions-pack.md VII.1); the atom-switching sentence COMPOSES from shipped constructors today (MAP 0.9996, minority P(y=3)=0.8997), so this is enumeration breadth, NOT alphabet and NOT inference; the two demands cite each other here rather than accumulating separately. CAUTION FOR THE HEIR INCREMENT (the author's rider at the transport countersign): the fix multiplies the guard family by the atom-pair choice — at arity 5 an order-of-magnitude population growth, priced lawfully by the mention bits but PAID AT EVERY TICK'S EU EVALUATION — so the increment's oracle carries a ms/tick row from the existing test-measure instrument alongside its semantics rows. Priced breadth must be MEASURED breadth. THE LAW'S REACH EXTENDED (marked at the transport countersign): the optimisation law was written for SPEED — a fast path is legal iff a property pins it to the general route — and this clause applies its discipline to the PRIOR'S GROWTH instead. A family that multiplies is a family that costs EU-evaluation time at every tick, so a demand that grows the alphabet's BREADTH must measure the tick it lengthens. Not merely an instance of the law; a small extension of where it reaches. |


## 8. The freeze executed (2026-07-22)

All nine package items applied under the author's per-instance
delegation of 2026-07-22 ("correct the one conditional in freeze item
3, and turn the key"), the builder tagging with the BUILDER key and
recording the delegation verbatim in the tag message (the membrane
precedent; the signature attests builder action under recorded
instruction and does not mint an author attestation).

Item 3 carries the author's correction at the key: the formal
conditional reads P(evidence | action, context), not P(outcome | ...)
— the wire folds EVIDENCE ATOMS, and whether an atom is the outcome or
a signal about it is the world's encoding (R-W1's line). The
scare-quoted family name stays as the informal gloss it always was.
The looser phrase would have invited a host to read the channel as
delivering ground-truth outcomes — the tabular-likelihood confusion
R-W1 refused.

Applied: membrane-wire.md x3 (var0 repair; §6.3 UNSHIPPED bracket; §3
combined-tick sentence as corrected); tools/boundary-audit.sh (the
banked-failure row — alphabet motion read from prodTable's last
touching commit, banked clause-(a) rows without a re-execution note
flagged; fires 0 today, BF row now in the summary line);
CLAUDE.md (the triptych clause); proplang.cabal (the transport stanza
with its provenance comment); OBLIGATIONS.md (OB-19, 19 rows);
MANIFEST.sha256 (5 re-signs + 3 new rows = 82, verified).

Lint at the tag: 0 FAIL, 12 WARN (the advisory literal class),
L3 82 rows, L7 full-corpus overlay build clean.
