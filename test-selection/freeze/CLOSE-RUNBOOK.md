# selection-freeze-r1 — the author's close runbook (turnkey)

The builder close-prep is complete and committed. Every remaining act below is
the **author's**: the frozen-layer install, the drift measurement, the MANIFEST
re-sign, and the tag. The builder wrote every script here and **never runs
`close.sh`** (it mints the tag; the key act is the author's alone).

`bash test-selection/freeze/pre-close-check.sh` is read-only and can be run at
any time — it prints exactly what is still owed. When it says **READY**,
`close.sh` will run cleanly.

---

## The whole close — one command

    bash test-selection/freeze/do-close.sh

That orchestrator runs every step below in order: it auto-captures the drift
ratio from `measure-drift.sh`, installs the frozen edits, runs the L5 demo, then
**PAUSES and prints the diff — you type `reviewed` to proceed** (the reviewed
diff is the attestation), commits under your identity, and runs the key act
(`close.sh`: sig probe → gate 5 → MANIFEST re-sign → tag), then pushes and closes
#24. It performs no key act itself. Knobs: `SKIP_PUSH=1`, `RATIO=<val>` (skip the
measurement), `RUN_GATE5=0` (skip gate 5 only if you just ran it green).

### Or step by step — six commands and one number to read

    # 0. publish the r0a chain + the builder commit (fast-forward; NEVER the merge button)
    git push origin master --follow-tags

    # 1. measure the box-invariant drift ratio (quiet box; a few min; prints ONE number)
    bash test-selection/freeze/measure-drift.sh

    # 2. install every frozen edit + set the ratio, then REVIEW the printed diff
    bash test-selection/freeze/install-close-edits.sh <ratio-from-step-1>
    git diff                                    # read it
    bash test-selection/freeze/l5-demo.sh       # optional: expect 7/7

    # 3. commit the frozen layer (your identity; the diff you just reviewed)
    git commit -am "selection-freeze-r1: frozen-layer installs + drift-a re-mint (author)"

    # 4. the key act — sig probe -> gate 5 (serial) -> MANIFEST re-sign -> tag
    bash test-selection/freeze/close.sh

    # 5. publish + close the issue
    git push origin master --follow-tags
    gh issue close 24 --comment 'Fixed at selection-freeze-r1: runEpisode migrated to policyPick; clockless + library episode paths both select the declared argmax.'

---

## Step 2 — what `install-close-edits.sh` installs

It applies `frozen-layer.patch` (a single reviewed diff) and sets the one
measured value, then STOPS after printing the diff — no commit, no MANIFEST, no
tag.

| edit | file | form |
|------|------|------|
| L5 rev 2 | `tools/prefreeze-lint.sh` | SAT-flag check DERIVED from the tree (`# L5-BEGIN`..`# L5-END`), replacing the word-grep the #19 sitting's own prose flipped |
| FL-1 | `membrane-wire.md` §2 | dated HISTORY bracket (the third shape makes the frozen sentence true; the bracket records the period it was not, and #24 the checkpoint lost) |
| FL-2 | `CLAUDE.md` Porting order | roadmap re-pointed to EXACT_PLAN §13.0, the falsified pointer quoted |
| FL-3 | `EXACT_PLAN.md` header | dated supersession note (not manifest-covered) |
| OB-24, OB-33 | `OBLIGATIONS.md` | → `DISCHARGED@selection-freeze-r1` (both halves of OB-33) |
| OB-30 | `OBLIGATIONS.md` | instances recorded (freeze.sh / freeze-r0a.sh / close.sh all `-F`) |
| OB-34 | `OBLIGATIONS.md` | NEW: R5's published-record inventory row |
| drift-a | `test-breadth/Breadth.hs` | body → RATIO-form gate; the abs-ms means printed as a residual (absolute-cost regression lives in `bench/`); ratio literal set from step 1 |

**The M3 decision (yours).** M3 is NOT a comment fossil like M1/M4 (those are
repaired in the builder commit). It is a hardcoded `17` in FROZEN
`test-selection/Selection.hs:319`; the close pack itself calls it "defined, not
floating" (not a defect). Recommended: **ARGUED-AND-DECLINE**. If you want it
repaired, that is your own frozen edit + a gate-5 re-run; the installer does not
touch it either way.

## Step 4 — what `close.sh` does

OB-29 live signature probe → gate 5 (`cabal test all -j1`, quiet+serial, ~10–13
min for the drift walks; `RUN_GATE5=0` skips it only if you just ran it green) →
re-hash the MANIFEST rows your edits moved (DERIVED from `sha256sum -c`, never a
hand-list) and add the new files (mutants, driver, matrices, pack, kit) →
`prefreeze-lint` 0 FAIL → commit MANIFEST → mint `selection-freeze-r1` by `-F`
→ byte-identity record.

---

## Fallback — hand-install (if you prefer review-as-you-type)

Skip step 2's installer and install verbatim, then commit yourself:
- **FL-1/2/3** from `chooseeu-sitting/drafts/FL-repairs.txt` (dates → 2026-09-04;
  FL-1 as the AMENDED history-bracket reading).
- **L5 rev 2**: the `# L5-BEGIN`..`# L5-END` hunk of `frozen-layer.patch`.
- **OB-24/30/33/34** and the **drift-a** body: the other hunks of the patch.
- set `driftFrozenMeanRatio` by hand to the step-1 measurement.

The installer is strictly additive; nothing depends on it. `measure-drift.sh`
and `close.sh` are unchanged either way.

---

### Custody note

The builder key is on no box in this session; the builder's commits are unsigned
by design. The attestation of author review is the **signed tag**, minted by the
author from the author's shell. The builder authored `frozen-layer.patch`,
`install-close-edits.sh`, `measure-drift.sh`, and the close scripts (the
FL/OB/L5/drift drafts in applyable form); the author's run + reviewed diff +
frozen commit + MANIFEST re-sign + signed tag are the key acts. This is the
`close.sh` precedent, which already re-signs the frozen MANIFEST and mints the
tag under the author's key. If you delegate the tag to the builder for a
specific instance, that is legal only when the delegation is fresh, explicit,
and per-instance, and the builder then tags with the **builder** key and records
the delegation verbatim in the message (the membrane precedent) — it cannot mint
an author attestation.
