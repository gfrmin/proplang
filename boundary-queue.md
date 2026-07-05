# Boundary queue — items awaiting the next freeze boundary's author pack

Unfrozen working document. Items here are queued rulings and corrections
that touch frozen text; per the increment protocol they land only at a
freeze boundary, only by the author, via that boundary's author pack.
Queued at the ExpFam increment's acceptance (2026-07-05).

## 1. Red-runner flag fidelity → CLAUDE.md increment protocol (author, ruled)

The ExpFam re-open's root cause, stated at full strength for the
protocol text: **a red run proves nothing unless it is bit-faithful to
the future gate conditions — same flags, same invocation, not merely
"compiles and fails at runtime."** The E10 runner compiled the oracle
without the stanza's `-Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns`, so the oracle froze compile-red under its
own stanza (`4c7b49d`). Absorb into CLAUDE.md's increment protocol
item 2 (oracle-first, runtime-red).

## 2. Layer absence as the ablation standard → typed-port-spec (author, ruled)

The E9 as-built pattern is stronger than the plan's EmptyCase sketch
and should be the spec's standard, not a recorded deviation: deleting a
basis deletes the dependent layer's *existence* (under `DROP_EXPFAM` or
`DROP_CARRIER_OBS`, everything from `emit` down does not exist —
sentences stay sayable, but "nothing can assign likelihood and no agent
can be built" is literal, not behavioral). Absorb into the spec's
ablation/deletion-audit language.

## 3. Pack §3 relocation (author's nit)

The T1 impossibility record sits at the end of typed-port-spec §4 as
the ExpFam pack addressed it; relocate if §3 or §5 was intended.
One-line author edit.

## 4. Candidate: two-key custody scheme → CLAUDE.md (author to decide)

The mechanism below (adopted 2026-07-05, see next section) replaces the
in-person signing rule. Whether its statement belongs in CLAUDE.md's
protocol text is the author's call at the boundary.

---

## Record: two-key custody scheme (adopted 2026-07-05, in effect now)

Author's ruling at the ExpFam acceptance: rather than re-issue the
in-person rule that convenience beat twice (`658f07c`, `4c7b49d`), the
mechanism now matches reality — two keys, two truthful attestations.

- **Builder key**: `/home/g/.ssh/proplang-builder` (ed25519, no
  passphrase — it attests builder-process-on-this-machine, which is
  exactly its claim). Fingerprint
  `SHA256:fPqrWnQhp0Ds+8MkMIDMUZzdRGviyfwt2BjsSaXAmgc`. The builder
  signs every commit it makes:
  `git -c user.signingkey=/home/g/.ssh/proplang-builder.pub commit -S ...`
- **Author key**: `/home/g/.ssh/id_ed25519.pub` (unchanged), fingerprint
  `SHA256:Sfh8OBG9CtkTF/y8rch4Cf6wv1rCpJ8ymEtKilUucsY`. The repo-local
  `user.signingkey` still points here, so the author's countersignature
  needs no flags: **a signed tag on each freeze commit**
  (`git tag -s <increment>-freeze <commit>`), run by the author in
  their own shell. The tag is the attestation of author approval; it is
  the thing that is rare and meaningful.
- Both keys verify under the committer principal in
  `.git/allowed_signers`. The informative log line is
  `git log --format='%G? %GF %h %s'` — signature status plus which key.
- History note: the five manifest commits through `4c7b49d` predate
  this scheme; their signatures attest key access plus the custody
  notes in their messages (not retroactively re-attested).
