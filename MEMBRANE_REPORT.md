# Membrane Increment Report (step-6 increment 3)

Built to interface.md §1–§3, §5 (with §8's tests A, B, C and E's slot
row) under typed-port-spec.md as amended at the Task 2 freeze (the
namespace law; layer absence as the ablation standard), per the
CLAUDE.md increment protocol — the first increment run end-to-end
under the two-key custody scheme, and the first whose freeze bound by
tag. This is the as-built record against MEMBRANE_PLAN.md's register;
the increment ends when the author runs the reviewer verification
block at the bottom.

Commit chain: `f02d03a` Task 0 absorbed → `a6682a7` Task 1 (oracle
runtime-red, 18/30) → `e6b5ca1` author pack → `573dd44` freeze-review
amendments (M5 separation guardian; C0 structure pin; 18/31) →
`fd70162` Task 2 freeze applied → `b7f120e` pin-provenance re-open
(amended freeze) → **membrane-freeze tag** (builder-signed on explicit
delegation) → `53e5bb5` Task 3 (namespace law at both sorts) →
`b37460a` Tasks 4+5 (the driver; all 31 green).

## 1. Gate matrix at completion

`env -i PATH HOME LC_ALL=C.UTF-8 sh audit/run-gates.sh --phase 2` →
all seven gates PASS, exit 0 (the locale pin is new and is incident
§4.4). Gate 5 now runs five suites: acceptance 4/4, properties 3/3,
hygiene 15/15, expfam 22/22, **membrane 31/31**. Manifest 42/42.
`audit/ablation.sh`, `test-hygiene/ablation.sh`,
`test-expfam/ablation.sh`, `test-membrane/ablation.sh` all green with
attribution. All of src/ compiles under each of the ELEVEN ablation
flags (8 inherited + slot-grid, affordance, echo). Frozen-surface
diff since the membrane-freeze tag: empty. Working tree clean.

## 2. Margin readout (same scratchpad program, FOURTH digit-for-digit run)

| quantity | \|delta\| | Phase 2 / hygiene / expfam value |
|---|---|---|
| t4 full-grammar log-loss | 7.105e-14 | 7.105e-14 |
| t4 frozen-agent log-loss | 5.684e-14 | 5.684e-14 |
| t3 agent log-loss, drift400 | 0.0 | 0.0 |
| t3 agent log-loss, flat400 | 1.137e-13 | 1.137e-13 |
| t1 MAP posterior | 1.665e-15 | 1.665e-15 |
| t1 / t3 MAP renders | byte-identical | byte-identical |

The namespace-law refactor rebuilt both pricers around shared workers
(`bitsAt`; the one guard-family generator) and the model-fragment
floats did not move by one ulp — the frozen dl trees were preserved
parenthesis-for-parenthesis with the namespace charge as data (0.0 at
the singleton).

Beyond the inherited anchors, the load-bearing new result is parity
group 1: the frozen t1 and t3 worlds re-expressed THROUGH the membrane
reproduce their anchors — including one exact identity, membrane fold
== frozen fold at Double ==, and t1's full probe table (P(y=1),
chosen action, meta-entropy at every probe tick), end MAP, and
posterior. Interface.md §7(1)'s "replacing the tests' hand-built
loops" is discharged the only protocol-compatible way: the loops stay
frozen; the membrane is proven a zero-cost layer over them.

## 3. As-built answers (M1–M10, Q1–Q5 highlights)

**M1 (the namespace law, normative).** Landed in spec §3 at the
freeze; implemented at both priced sorts: `bitsIn` charges
log2 |ns| at Get sites (`bits` = the frozen-registry case of the one
worker), `enumerateModelsIn` charges (1 + log2 |ns|) inside every
guard head (`enumerateModels` = the singleton/no-extras case of the
one generator). Pinned at both sorts, plus the cross-world
re-pricing pin (lg 3 − lg 2 exactly; +1 vs frozen).

**M2 (stable identity).** `AffId`, world-owned; the echo speaks ids,
never menu positions; 0 = none-yet, −1 = the host's internal act.

**M3/M9.** `InternalAct` has one written inhabitant and no depth
field anywhere; the ladder's depth arrives additively at its own
boundary (ROADMAP increment 4).

**M4/Q1 (slot pricing).** The charge sits at the C node: slot
instantiation enumerates the slot's grid through `mkC` then the real
evaluator, so an unpriceable point is unofferable; pinned with the
grid-size monotonicity.

**M5 (two priced surfaces, load-bearing).** In the spec's law text;
asserted in construction by the group-3 guardian (B's menu growth
adds action vocabulary only — the author's freeze-review consistency
requirement).

**M10/T2 (parity worlds).** As approved — t3 drift (loss ==, anchor,
MAP) and t1 (probe table, MAP, posterior), namespace ["t"], empty
echo; t1's menu is three slotless affordances valued by the frozen
util1 spoken over the whole option space, chosen by the same
argmaxEU program shape the frozen suite evaluates.

**Q2/CL-6 (the echo).** `echoFeatures` appends world-configured
last_action / tick / ticks_spent_thinking after the world's features;
echo names price like weather names (group 5) and delete like them
(the DROP_ECHO row).

**Q3 + the Task-0 requirement (two-sided self-signature).** World C's
MAP is the true self-sentence — mentions ('get', 'last_action') at
posterior > 0.5 (sim 0.947) — while control C0, same hypothesis
space, same pilot, same echo, hands MAP BY STRUCTURE to the
changepoint program, byte-identical to the frozen t1 anchor sentence
(the author's structure-pin ruling, ExpFam group-6 standard).

**Q4/M6/M7 (grep clauses).** Increment-local rows: the
no-subscription token scan over all six src modules; gate-3 and
gate-4 mirrors for the new module — the gate-4 mirror closes a hole
this increment opened (the frozen scan names five files, so a new src
module would otherwise escape the forbidden-token list entirely).

**Q5/E9-standard (layer absence).** The external action layer dies
with its slot grids or with affordance publication; the self dies
with the echo and takes the polling driver with it; the driver also
dies with the agent layer and with Argmax (nothing may select an
action but expected value — CL-3 at the membrane). All of src
compiles under every flag.

## 4. Incidents and rulings on the record

1. **Pin-provenance re-open (pre-tag; the named precedent).** The
   oracle froze at `fd70162` internally inconsistent: the group-6
   guard-dl literals omitted the if-node bit that the frozen
   `dlChange` charges, while the identity test demanded exact
   agreement with the frozen fragment — mutually unsatisfiable,
   caught by the builder BEFORE executing the delegated tag, proven
   against the artifact (frozen t-guard modelBits = 16.339850002884624
   = the with-if-bit formula exactly). Root cause: pins transcribed
   from gen_fixtures.py (a parallel derivation) instead of the frozen
   artifact. The corrected sanity sim preserved every discriminating
   conclusion (uniform +1 bit halves every guard's prior; C 0.947082
   unchanged, C0 0.635→0.627 same MAP, A 0.4326→0.4323, B analytic).
   Fixed at `b7f120e` as approved; the lesson is now CLAUDE.md
   protocol text. The author named the stop-and-report "the protocol
   at its best."
2. **Custody: the first tag.** The freeze bound by the
   `membrane-freeze` tag on `b7f120e`, created by the builder with
   the BUILDER key on the author's fresh explicit delegation ("i
   delegate this tag to you on my behalf" — the prior delegation
   died with fd70162 by the author's ruling). The custody paragraph's
   letter ("from their own shell") is deviated from on the record,
   inside the tag message itself; under the two-key scheme the
   signature stays truthful — it attests builder action under that
   recorded instruction, and cannot mint an author attestation. The
   manifest log is now informative: five author-key signatures, two
   builder-key, one `git log --format='%G? %GF'` apart.
3. **The increment's own grep clause caught its own implementation.**
   Task 3's first draft named a binding `registryBits`; the frozen
   no-subscription list scans the substring `registr`; the suite went
   red until the rename (`frozenNameBits`). Recorded with some
   satisfaction.
4. **Gate 5 is locale-sensitive (new).** The frozen oracle carries
   '§' in one test name; under `env -i` (POSIX locale) tasty dies
   encoding it after 30 OKs — an I/O error, not an assertion. The
   clean-shell verification convention now pins `LC_ALL=C.UTF-8`
   alongside PATH; all seven gates PASS under it. Candidate lesson
   for a future boundary: ASCII-only test names in increment oracles.
5. **Task 4/5 merged.** The plan put worlds A/B/C in Task 5, but they
   were all oracle-side data — the driver alone turned groups 1–4
   green, so Tasks 4 and 5 are one commit (`b37460a`), declared.
6. **Pack §7 counting slip.** The pack predicted 43 manifest entries;
   test-membrane/ has 9 files, so 42 — the delta itself verified
   exactly right (9 additions + 3 re-hashes at fd70162, then 3
   re-hashes at b7f120e). A worksheet arithmetic error, recorded.
7. **The corrected runner earned its keep.** test-membrane/red-run.sh
   carried the stanza's exact ghc-options from the first compile (the
   ExpFam correction's first application); the oracle compiled
   warning-clean on the first attempt and the stanza landed with no
   surprise.

## 5. Reviewer verification (run yourself; the builder's word is not load-bearing)

```
export PATH="$HOME/.ghcup/bin:$PATH"
sha256sum -c MANIFEST.sha256                        # 42/42 OK
env -i PATH="$PATH" HOME="$HOME" LC_ALL=C.UTF-8 \
    sh audit/run-gates.sh --phase 2; echo $?        # gates 1-7 PASS, exit 0
cabal test all                                      # 4/4, 3/3, 15/15, 22/22, 31/31
git tag -v membrane-freeze                          # Good signature, BUILDER key, delegation record in the message
git log --format='%G? %GF %h %s' -- MANIFEST.sha256 # exactly 7: d03bb10 db34a9a b1c8e00 658f07c 4c7b49d (author key), fd70162 b7f120e (builder key)
git diff --name-only membrane-freeze..HEAD -- test test-hygiene \
    test-expfam test-membrane audit CLAUDE.md proplang.py \
    tests_acceptance.py test_output.txt typed-port-spec.md interface.md \
    design.md proplang.cabal cabal.project.freeze   # empty
sh test-membrane/ablation.sh all; echo $?           # three rows, exit 0
```

Personal eyeballs (mechanically unchecked): the tag message's custody
record against your own recollection of the delegation; the
pin-provenance comments in the frozen oracle against `dlChange` in
src/PropLang/Enumerate.hs (the artifact they cite); `bits` =
`bitsAt frozenNameBits` and `enumerateModels` =
`enumerateModelsIn ns0 []` (one arithmetic each, the E7 doctrine at
both sorts); and incident §4.4's locale pin, which is now part of the
clean-shell run conditions.
