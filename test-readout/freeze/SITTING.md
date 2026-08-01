# The readout sitting — command sheet (#20, the K-ary readout)

Everything here is run by **you**, from your own shell. The tag is the
attestation and the protocol vests it in the author; nothing in this
increment mints one on your behalf.

Run from the worktree the branch is checked out in:

```bash
cd ~/git/worktrees/proplang/readout
```

## Preconditions — already set on thinkpad, verify anyway

```bash
git config --get user.signingkey     # /home/g/.ssh/proplang-author-thinkpad
git config --get gpg.format          # ssh
git config --get gpg.ssh.allowedSignersFile   # allowed_signers
git log --oneline -1                 # e6ca692 or later
```

Worktrees share `.git/config` with `~/git/proplang`, so these hold in either
checkout. A **fresh clone has none of them** — `1-verify` will stop and say
so rather than letting you find out after the tree is mutated.

---

## Step A — see what you are signing (read-only, mutates nothing)

```bash
bash test-readout/freeze/1-verify.sh
```

Expect, in order: manifest OK · **live 19/19** under the stanza's dependency
closure · as-built == the prophecy · the recorded red/green/matrix figures ·
boundary audit · three patches apply clean · **signing key OK**.

---

## Step B — THE DECISION POINT. Everything you want to change, change now.

`2-freeze.sh` hashes `test-readout/freeze/*.sh` into the manifest, and
`3-sign.sh` re-checks that manifest before touching a key. **An edit made
after step C is refused at step D** — by design, and rehearsed.

The register exists in **two** forms. Rule from the table — it states the
question each CW answers; the tag message states only the answer.

```bash
sed -n '/^### 15.4 /,/^| CW8 /p' EXACT_PLAN.md            # the table: question | drafted answer
sed -n '/^CW1 THE FULL/,/r1 catch-net\./p' \
        test-readout/freeze/3-sign.sh                    # the text you actually sign (16 lines)
$EDITOR test-readout/freeze/3-sign.sh                    # decline by editing
$EDITOR test-readout/freeze/2-freeze.sh                  # or drop a [RULING] patch line
```

The earlier form of the first command was `/^CW1/,/^CW8/p`, which never
terminates: `CW8` occurs mid-line, so sed ran to end of file and printed 120
lines while its comment promised eight defaults. Recorded rather than quietly
swapped — a command that dumps everything reads as if it isolated something.

Running the kit intact **accepts CW1–CW8 as drafted**. Open items you are
being asked to rule on:

| | |
|---|---|
| CW1–CW8 | drafted defaults, `EXACT_PLAN.md` §15.4 |
| the one ruling sought | line-number provenance in pre-implementation oracles |
| V.4's UNREACHED rows | triage input, not deletions (`opening/readout-kill-matrix.txt` has per-row verdicts) |
| CW5 | if you rule the readout *does* ride the think reply, **a row is owed** and this sitting should not close |

---

## Step C — the keyless mechanics

```bash
bash test-readout/freeze/2-freeze.sh
```

Splices the stanza, applies the three `[RULING]` patches, runs gate 5 on the
spliced tree, extends the manifest **109 → 136**, re-signs, lints. Expect it
to end on `prefreeze-lint: 0 FAIL, 0 WARN` and
`FREEZE MECHANICS DONE - nothing signed.`

### If step C dies part-way

It has no undo script and its own guard refuses a second run against an
already-spliced `proplang.cabal`. To reset the tree and retry:

```bash
git checkout -- proplang.cabal membrane-wire.md OBLIGATIONS.md CLAUDE.md MANIFEST.sha256
rm -f test-readout/freeze/gate5-run.txt test-readout/freeze/lint-transcript.txt
git status --short          # expect clean
```

Then fix whatever it complained about and re-run step C.

---

## Step D — the key act. Yours alone.

```bash
bash test-readout/freeze/3-sign.sh
```

Makes the signed freeze commit and `git tag -s readout-freeze-r0`, both with
`SHA256:vxt+FccnN/4Z/6kmg0v/rvNWe1qK4jtVTzGsM8ogeX0` (thinkpad, registered at
`8b85edb`).

```bash
git tag -v readout-freeze-r0        # expect: Good "git" signature
```

---

## Step E — land it on master. **Fast-forward only.**

`master` has zero merge commits in its whole history and this branch is cut
from its HEAD, so a fast-forward always applies.

```bash
cd ~/git/proplang
git checkout master
git merge --ff-only claude/next-steps-2x26hs
git push origin master --follow-tags
```

**Do not use GitHub's merge button.** Squash- and rebase-merge both rewrite
the commit hash, so the tag would point at an orphaned object and the
attestation would cover nothing on `master`. PR #22 closes itself as merged
once `master` contains the commits.

---

## Step F — the r1 catch-net (CW8)

CW8 keeps the two-tag form: `readout-freeze-r0` is the seal, and a post-tag
review pass closes as `readout-freeze-r1`. Post-tag findings that do not
belong in r1 route to the **wire docket's next frozen-layer inventory** —
which already has one row waiting: `Host.hs:387`'s "wait" comment (pack
VII.3).

Then the docket's item two: **the OB-19 heir**. #20 is that ruling's
instrument, not the ruling; `EXACT_PLAN.md` §15.2 firewalls this sitting
against drifting into it.
