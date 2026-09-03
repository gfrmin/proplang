# selection-freeze-r1 — the author's close runbook

The builder close-prep is complete (`b0ceb5f` pt.1, `c3ba64d` pt.2, and the
close kit pt.3). Every remaining act below is the **author's** — the frozen
edits, the measurement, the MANIFEST re-sign, and the tag. The builder wrote
this runbook and the two scripts and **never runs `close.sh`** (it mints the
tag; the key act is the author's alone).

Run `bash test-selection/freeze/pre-close-check.sh` at any time — it is
read-only and tells you exactly what is still owed. When it reports **READY**,
`close.sh` will run cleanly.

---

## Step 0 — publish the r0a chain (optional, any time)

The local `master` is 7 ahead of origin. Land it (fast-forward, never the
merge button):

    git push origin master --follow-tags

## Step 1 — install the frozen-layer edits (author's hand)

Drafts are ready; install each verbatim from its source, then commit.

| edit | file | source draft |
|------|------|--------------|
| FL-1 | `membrane-wire.md` §2 menu bullet — dated HISTORY bracket | `chooseeu-sitting/drafts/FL-repairs.txt` (FL-1, the AMENDED reading) |
| FL-2 | `CLAUDE.md` Porting-order last para — repoint to EXACT_PLAN §13.0 | `chooseeu-sitting/drafts/FL-repairs.txt` (FL-2) |
| FL-3 | `EXACT_PLAN.md` status header — dated supersession note | `chooseeu-sitting/drafts/FL-repairs.txt` (FL-3) — *not manifest-covered* |
| OB-24 | `OBLIGATIONS.md` — `DISCHARGED@selection-freeze-r1` | `selection-close-pack.md` §4 |
| OB-33 | `OBLIGATIONS.md` — `DISCHARGED@selection-freeze-r1` (both halves) | `selection-close-pack.md` §4 |
| OB-30 | `OBLIGATIONS.md` — record this increment's instances | `selection-close-pack.md` §4 |
| R5 | `OBLIGATIONS.md` — the published-record row | `selection-close-pack.md` §4 |
| L5 rev 2 | `tools/prefreeze-lint.sh` lines 68–85 | `chooseeu-sitting/drafts/L5-repair-option-b.txt` |
| M1/M3/M4 | `src/PropLang/Membrane.hs` comment nits — REPAIR or DECLINE | `selection-close-pack.md` §1 |

The advisory rows in `pre-close-check.sh` grep for a stable marker in each of
the manifest-covered files (FL-1 `REPAIRED at the #24 sitting`, FL-2
`EXACT_PLAN.md section 13.0`, OB `DISCHARGED@selection-freeze-r1`, L5
`SAT-SECTION`) — they flip to `[ OK ]` as you install.

## Step 2 — re-mint the drift-a ratio (author's hand + a measurement)

The frozen gate `driftFrozenMeanRatio = 2.0092` in `test-breadth/Breadth.hs`
is an absolute-ms mint that false-reds under box load. On a **quiet** box:

1. Run the drift cell serialized and read the fresh **deep/shallow mean
   ratio** (the box-invariant quantity; `chooseeu-sitting/r0-tag-msg.txt`
   and register R8 schedule this re-mint to RATIO form).
2. Edit `driftFrozenMeanRatio` to the re-measured value (and its band, per
   the existing comment convention at that line).

`pre-close-check.sh` confirms only that the literal has **moved off** 2.0092
— the value itself is your measurement, not the builder's.

**Commit Steps 1–2 as one author commit** (`close.sh` commits only MANIFEST,
so the tree must be clean when it runs):

    git commit -am "selection-freeze-r1: frozen-layer installs + drift-a re-mint (author)"

## Step 3 — run the close (author's key)

    bash test-selection/freeze/pre-close-check.sh     # expect: READY
    bash test-selection/freeze/close.sh               # the key act

`close.sh` will: OB-29 live signature probe → gate 5 (`cabal test all -j1`,
quiet + serial, ~10–13 min for the drift walks — set `RUN_GATE5=0` to skip if
you just ran it green) → re-hash the MANIFEST rows your edits moved (derived
from `sha256sum -c`, not a hand-list) and add the new files (mutants, driver,
matrices, pack, kit) → `prefreeze-lint` 0 FAIL → commit MANIFEST → mint
`selection-freeze-r1` by `-F` → byte-identity record.

## Step 4 — publish and close #24

    git push origin master --follow-tags
    gh issue close 24 --comment 'Fixed at selection-freeze-r1: runEpisode migrated to policyPick; clockless + library episode paths both select the declared argmax.'

---

### Custody note

The builder key is on no box in this session; the builder's commits are
unsigned by design. The attestation of author review is the **signed tag**,
minted by the author from the author's shell. If you delegate the tag to the
builder for a specific instance, that is legal only when the delegation is
fresh, explicit, and per-instance, and the builder then tags with the
**builder** key and records the delegation verbatim in the message (the
membrane precedent) — it cannot mint an author attestation.
