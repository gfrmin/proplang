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
not pin them — no edit to the freeze file is required, but the freeze
sitting should confirm the resolved versions ride the boot set).

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
   15(c) probe's product; draft in Part VI.4).
4. tools/boundary-audit.sh — the OB-16 banked-failure row (flag every
   banked clause-(a) failure whose increment postdates the alphabet
   motion it assumed; the step-10 clause's scriptable half).
5. CLAUDE.md — the triptych clause (Part V, adopted at the sitting).
6. proplang.cabal — append test-transport/stanza.cabal.draft verbatim.
7. MANIFEST.sha256 — re-sign rows for membrane-wire.md, CLAUDE.md,
   tools/boundary-audit.sh, proplang.cabal; add rows for
   test-transport/Transport.hs, test-transport/stanza.cabal.draft,
   test-transport/red-run.sh.
8. tools/prefreeze-lint.sh run; transcript below rides this pack.

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
