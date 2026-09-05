# CLOSE-RUNBOOK — paper-freeze-r0, THE TERMINUS

The close of step 5 (the demonstration tier), and with it the roadmap of
`EXACT_PLAN.md` §13.0. Builder-authored; **every act below is the author's.**

**The short path:** `bash test-paper/freeze/do-close.sh` — it chains the whole
thing and stops at two human gates (the reviewed diff, and close.sh's own
abort window). The long path below is the same steps by hand, for when you
want to see each one, or when something reds and you need to resume from the
middle.

---

## What is being closed

| part | state entering this close |
|---|---|
| (a) the A-gate reading | **executed and posted** — OB-12's differential run, 95k live events, X.5 ruling 7 (*A stays closed, B stays out*, n_inv = 0); consumer posting 2026-09-02. Nothing owed. |
| (b) the benchmark | **landed, band measured-blank** — r02.5's O(t)-bits falsifier. The seam-swap judgement is yours and is *not* made by this tag. |
| (c) the paper | **`PAPER.md`**, frozen here with `test-paper/check.sh`. |

## The kit

| file | what it is | who runs it |
|---|---|---|
| `frozen-layer.patch` | FL-P1 (`CLAUDE.md`) + FL-P2 (`EXACT_PLAN.md`), as a patch | applied by the next row |
| `install-close-edits.sh` | applies the patch, gates the substance, commits nothing | author |
| `pre-close-check.sh` | read-only readiness dashboard **and** close.sh's ADD generator | author or builder (rehearsal) |
| `close.sh` | **the key act** — readiness, sig probe, gate 5, MANIFEST, lint, tag | author only |
| `do-close.sh` | the turnkey chain over all of the above | author only |
| `r0-tag-msg.txt` | the tag message — passed by `-F`, never `-m` (OB-30 / lint L9) | read by `close.sh` |

---

## The long path

### 0. Review the drafts

```sh
git show 88dcd94                 # the paper, its checker, the inventory
sh test-paper/check.sh           # expect: 24 passed, 0 failed
bash test-paper/freeze/pre-close-check.sh   # expect NOT READY — see below
```

Before your edits land, `pre-close-check.sh` **should** report NOT READY: the
FL-P1 rows red and the FL-P2 advisory reads ABSENT. That is the rehearsal —
the dashboard's red side, demonstrated rather than assumed. If it reported
READY here, the instrument would be the defect.

Read `test-paper/terminus-inventory.md`: it is the inventory this sitting
receives, and `frozen-layer.patch` is its executable form.

### 1. Publish the builder commits

```sh
git push origin master --follow-tags
```

### 2. Install the frozen layer

```sh
bash test-paper/freeze/install-close-edits.sh
git --no-pager diff              # READ IT — this repairs CLAUDE.md, the protocol
```

- **FL-P1 — `CLAUDE.md`**, the Porting-order paragraph. Normative prose, so the
  repair is **in place with the falsified clause quoted inside its own repair**:
  the paragraph read *"ONE ITEM REMAINS: step 5 … AFTER 5 THE ROADMAP
  TERMINATES"*, which was true until this freeze; the repair records that the
  antecedent has occurred and the consequent has fired. Manifest-covered — it is
  re-hashed in step 4.
- **FL-P2 — `EXACT_PLAN.md` §13.0.** Historical record, so a **dated terminus
  bracket** is appended and both the charter clause and its draft-time status
  annotation are kept verbatim. Not manifest-covered (the `selection-freeze-r1`
  FL-3 precedent for this file), so it rides without a re-hash.

If the patch refuses to apply, the frozen text moved under the draft: **stop and
report.** Do not hand-edit toward it.

### 3. Commit the frozen layer (your identity)

```sh
git commit -am "paper-freeze-r0: frozen-layer installs (FL-P1 CLAUDE.md, FL-P2 EXACT_PLAN.md) (author)"
bash test-paper/freeze/pre-close-check.sh    # now expect READY
```

### 4. The key act

```sh
bash test-paper/freeze/close.sh              # RUN_GATE5=0 to skip gate 5
```

> **Gate 5 needs a genuinely quiet box, and this one was not.** Measured
> 2026-09-05 while preparing this kit: `breadth`'s `drift-a` cell failed twice
> with ratios **1.4956** and **2.3020** against a frozen **1.9078** and a gate
> band of **±0.03** — bracketing the frozen value from *both* sides, which is
> noise and not regression (a regression moves one way). The absolute window
> means ran +95% to +200% over frozen, and `uptime` showed load average ~13.5 on
> 8 cores, with a `julia` process pinning a core for 4d21h alongside
> `clickhouse`, `uvicorn` and two other Claude sessions. Every other row of
> `breadth` passed in both runs, and all thirteen other suites passed.
>
> `drift-a` is not attributable to the wire increment: it builds its agent from
> `sentenceAgent` directly and never calls `serveLine`, where the whole repair
> lives. Re-run it on a quiet box before the close, or set `RUN_GATE5=0` and
> attest — but do not read a red `drift-a` on a loaded box as a regression.

It runs, in order: the readiness gate → a **live throwaway signature probe**
(the key is proven usable *before* the manifest moves — a key act that fails
after the rewrite is the worst ordering) → gate 5 (`cabal test all -j1`) →
MANIFEST re-hash (the edited set **derived** from `sha256sum -c`, never
hand-listed; the ADD set **sourced** from `pre-close-check.sh`, one generator) →
`prefreeze-lint` 0 FAIL → the MANIFEST-only commit → `git tag -s paper-freeze-r0
-F r0-tag-msg.txt` → `git tag -v` → the **byte-identity record** (the minted
message is compared byte-for-byte against the file) → `test-paper/check.sh
--close`.

Expected manifest size afterwards: **256 rows** (243 + 13 ADD). Two
manifest-covered files are **re-hashed in place**, not added: `CLAUDE.md` (the
FL-P1 repair) and `proplang.cabal` (the `test-wire` stanza the wire increment
adds). Both are derived by `close.sh` from `sha256sum -c`, never hand-listed.

### 5. Publish

```sh
git push origin master --follow-tags
```

**Fast-forward only — never GitHub's merge button; it orphans the tag.**

---

## Resuming from the middle

The steps are idempotent in the ways that matter:

- `install-close-edits.sh` detects an already-applied patch and exits 0.
- `do-close.sh` skips the review gate and the commit when the tree is clean
  because the frozen layer is already committed.
- `close.sh` refuses to run twice (`pre-close-check.sh` reds on an existing tag),
  and refuses to double-add a manifest row.

If `close.sh` dies **after** the MANIFEST rewrite but **before** the tag:
`git checkout -- MANIFEST.sha256` (if uncommitted) or `git reset --hard HEAD~1`
(if the MANIFEST commit landed), then re-run. Nothing is signed until the tag.

## What this close does NOT do

- It does **not** make the benchmark's seam-swap judgement. The acceptance band
  stays measured-blank; that call is the owner's and is explicitly outside the
  tag.
- It does **not** schedule anything. After the terminus every remaining item —
  the quine face, OB-15, OB-19, continuous carriers (foreclosed), brief §6
  self-compression — is demand-gated residue, re-entering only through the
  two-sided gate with a measurement. Named, not scheduled.
