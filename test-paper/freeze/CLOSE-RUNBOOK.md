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

> ### Gate 5 and the `drift-a` cell — read this before choosing a path
>
> **The fact.** `breadth`'s `drift-a` timing cell reds under load. Measured
> n=8, the cell alone (`test-paper/sitting/drift-distribution.txt`):
> median 2.0103, mean 2.0084, stdev 0.1644, **1 of 8 inside the ±0.03 band**,
> stdev/half-band **5.5×**, 95% CI of the mean `[1.8710, 2.1459]` — which
> **contains** the frozen 1.9078.
>
> So **the gate cannot resolve its own band under this load** (decisive), and
> **the centre has not been shown to move** — no regression indicated, *no clean
> bill of health claimed*. Neither licenses a re-mint, which would bake today's
> contention into the frozen layer.
>
> **The mechanism.** Not scheduling starvation: `timedFold` uses `getCPUTime`
> and a timed run shows `user` ≈ `real` (9m49s of 9m53s), so the process gets
> its core. It is **cache and memory-bandwidth contention**, which inflates real
> cycles and hits a deep fold's larger working set differently from a shallow
> one — so it does not divide out of a ratio. A precondition keyed on *load
> average* would be the wrong instrument.
>
> **Not attributable to this increment:** `drift-a` builds its agent from
> `sentenceAgent` and never calls `serveLine`, where the whole repair lives.
>
> **What n=8 does NOT settle.** It answers *"can the gate resolve under load?"* —
> no. It does **not** answer *"must gate 5 be skipped?"* Those are different
> questions, and "the box cannot be quieted" is a premise to be **demonstrated,
> not asserted**. Co-residents suspend losslessly:
>
> ```sh
> kill -STOP <pid>     # suspends; days of computation are kept
> kill -CONT <pid>     # resumes exactly where it was
> ```
>
> A stopped process stops touching memory, which is the contention channel named
> above. The gate's own design premise — per `measure-drift.sh`'s header,
> *stability between mint and re-measure on the same box* — is restorable in half
> an hour.
>
> ### So: two branches, and only one licenses the skip
>
> **(1) Quiet-box attempt (do this first).** Suspend the co-residents, then take
> three samples of the cell alone:
>
> ```sh
> sh test-paper/sitting/drift-distribution.sh 3
> ```
>
> **In band → run gate 5 LIVE and close clean.** No attestation needed.
>
> **(2) Still unresolvable → the skip is now *demonstrated*, not assumed.** The
> attestation quotes **both** distributions, and a full `cabal test all -j1`
> transcript for the other suites is **mandatory**, not optional:
>
> ```sh
> cabal test all -j1 2>&1 | tee /tmp/gate5.txt      # the record for the attestation
> RUN_GATE5=0 GATE5_ATTEST="drift-a unresolvable: LOADED n=8 median 2.0103 stdev 0.1644, 1/8 in band, CI [1.8710,2.1459] contains 1.9078; QUIET n=3 <ratios> at load <L>. Centre not shown to move. Not attributable (never calls serveLine). All other suites green, /tmp/gate5.txt." \
>   bash test-paper/freeze/do-close.sh
> ```
>
> `close.sh` refuses the skip without `GATE5_ATTEST`, and writes it into the
> close commit.
>
> The second-order finding — the ratio row is **not box-invariant, merely less
> box-sensitive** — is **FL-P5** in `test-paper/terminus-inventory.md`, with the
> falsified texts quoted and the residual named.

It runs, in order: the readiness gate → a **live throwaway signature probe**
(the key is proven usable *before* the manifest moves — a key act that fails
after the rewrite is the worst ordering) → gate 5 (`cabal test all -j1`) →
MANIFEST re-hash (the edited set **derived** from `sha256sum -c`, never
hand-listed; the ADD set **sourced** from `pre-close-check.sh`, one generator) →
`prefreeze-lint` 0 FAIL → the MANIFEST-only commit → `git tag -s paper-freeze-r0
-F r0-tag-msg.txt` → `git tag -v` → the **byte-identity record** (the minted
message is compared byte-for-byte against the file) → `test-paper/check.sh
--close`.

Expected manifest size afterwards: **260 rows** (243 + 17 ADD). Two
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
