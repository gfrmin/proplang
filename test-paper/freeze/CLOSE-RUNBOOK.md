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

> ### Gate 5 and the `drift-a` cell — THE CLOSE IS CURRENTLY BLOCKED HERE
>
> **Read this before choosing a path. The two-branch protocol that stood in
> this block until 2026-09-06 was falsified by its own measurement, and both
> of its branches are now dead.**
>
> **What was measured.** The sitting licensed `RUN_GATE5=0` only after a
> quiet-box attempt had been *made* and shown insufficient. The attempt was
> made — `test-paper/sitting/drift-quiet.txt`, co-resident units verified
> stopped and verified restarted — and it came out the other way:
>
> | condition | n | stdev | vs half-band | mean | in band |
> |---|---|---|---|---|---|
> | loaded (load 12–20 on 8 cores) | 8 | 0.1644 | **5.48×** | 2.0084 | 1/8 |
> | quiet (load ~1.5, units stopped) | 3 | **0.0087** | **0.29×** | 1.9474 | 1/3 |
>
> So **the cell resolves its band fine on a quiet box** — a red from it here is
> informative and cannot be set aside as noise — and its 95% CI
> `[1.9258, 1.9691]` **excludes** the frozen `1.9078`. Gate 5 will red on
> `drift-a`, legitimately.
>
> **Branch 1 (run it live, close clean) fails the gate. Branch 2 (skip with an
> attestation) is now a false statement** — any wording of the form "drift-a
> unresolvable" is falsified, and putting it under the terminus signature is
> the precise act the Q3 ruling forbids.
>
> **And a re-mint is not licensed either.** `test-breadth/Breadth.hs`
> pre-declares one for "a module addition reintroduc[ing] a cross-build
> divergence … never a silent widening". Exactly one commit touched `src/`
> since the `1.9078` mint (`54e7884`, the wire repair), so the clause was
> tested directly by building its parent and interleaving the arms
> (`test-paper/sitting/wire-attribution.txt`):
>
> | arm | n | mean | stdev | vs frozen |
> |---|---|---|---|---|
> | PRE (`113d29a`, no wire repair), fresh build | 3 | 1.9815 | 0.0012 | **+0.0737** |
> | HEAD (wire repair present), incremental build | 2 | 1.9573 | 0.0074 | +0.0495 |
> | HEAD, **fresh build** — the confound control | 2 | 1.9533 | 0.0029 | +0.0455 |
>
> The third row exists because the first two differed in build provenance as
> well as in code, which the interleave did not control. HEAD-fresh agrees with
> HEAD-incremental to within 0.0041 and both are far from PRE-fresh, so **the
> confound is excluded**: (A) is a real code effect, not a build artifact.
>
> Decomposed: **(A)** the increment's own shift is `-0.0241`, 4.5× the pooled
> within-arm scatter and 80% of the band — *real*, and the clause's case, but
> it moves **toward** frozen; **(B)** a baseline gap of `+0.0737` survives
> **without** the increment. The clause licenses absorbing (A). A re-mint
> would silently absorb (B) as well, and (B) is the larger term and the
> unexplained one.
>
> **The mint is not stale-from-elsewhere.** `1.9078` was minted on *this* box
> on 2026-09-04 (`83e29ec`, selection-freeze-r1, "box-robust: measure on the
> gate's own box"), and `2-freeze.sh` aborts if gate 5 ran in mint mode, so
> mint and gate were separate runs. (B) is a real change in this box over two
> days, not an artifact of how the value was taken.
>
> ### So: the close does not proceed until the author rules on (B)
>
> Under the author's own standing law — **never freeze a known bug or hole** —
> a red gate 5 is a hole, and this one is not noise. The open question is what
> moved on this box between 2026-09-04 and 2026-09-06. These data do not answer
> it; the builder has not guessed at it.
>
> The second-order finding stands and is sharpened: the ratio row is **not
> box-invariant, merely less box-sensitive** (FL-P5 in
> `test-paper/terminus-inventory.md`), and this episode is its demonstration —
> the cell's *resolution* and its *centre* are both functions of box state.

It runs, in order: the readiness gate → a **live throwaway signature probe**
(the key is proven usable *before* the manifest moves — a key act that fails
after the rewrite is the worst ordering) → gate 5 (`cabal test all -j1`) →
MANIFEST re-hash (the edited set **derived** from `sha256sum -c`, never
hand-listed; the ADD set **sourced** from `pre-close-check.sh`, one generator) →
`prefreeze-lint` 0 FAIL → the MANIFEST-only commit → `git tag -s paper-freeze-r0
-F r0-tag-msg.txt` → `git tag -v` → the **byte-identity record** (the minted
message is compared byte-for-byte against the file) → `test-paper/check.sh
--close`.

Expected manifest size afterwards: **no number is written here.**
`pre-close-check.sh` PRINTS it (`EXPECTED POST-CLOSE MANIFEST SIZE: N rows`),
computed from the live manifest plus its own ADD array — read it off the
dashboard you have just run. A literal stood in this paragraph until
2026-09-06 and went stale **twice** (12 ADD, then 17, now 19) as the close
absorbed the sitting's evidence files; the one-generator law's own words are
that a hand copy tracking a generated value is correct at birth and wrong at
the first regeneration, and this sentence was the third paid instance.

Two manifest-covered files are **re-hashed in place**, not added: `CLAUDE.md`
(the FL-P1 repair) and `proplang.cabal` (the `test-wire` stanza the wire
increment adds). Re-hashes do not change the row count; only ADDs do. Both are
derived by `close.sh` from `sha256sum -c`, never hand-listed.

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
