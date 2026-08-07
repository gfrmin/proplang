# The breadth oracle freeze — the kit's sitting sheet

Authority: **breadth-sitting-r0** (author key over 197269b). Every
install this kit applies was ROUTED to this boundary by that tag; the
kit adds no new ruling. The author's acts here are review + the key
acts; everything else is mechanics the kit executes and records.

## Run order

1. `bash test-breadth/freeze/1-verify.sh` — read-only; the patch
   list is extracted from 2-freeze's own apply lines; sequential
   apply on a temp copy; every frozen mint literal traced to
   mint-run.txt mechanically.
2. Read `SITTING.md` (this sheet), `tag-msg.txt` (the attestation
   text — edit freely, then re-run 1-verify: the manifest hashes it
   at 2-freeze, so edits must precede 2-freeze).
3. `bash test-breadth/freeze/2-freeze.sh` — keyless mechanics: live
   signature probe (OB-29) BEFORE any mutation; the six patches;
   gate 5 with the breadth suite's EXACT frozen red set asserted;
   manifest extension + re-sign AFTER the lint rows (OB-26's order);
   the L8/L9/L5 two-sided demo; the pre-freeze lint at 0 FAIL.
4. `bash test-breadth/freeze/3-sign.sh` — the freeze commit (-S,
   your key; or delegated per the membrane precedent, R-D22 re-tag
   then owed within the increment).
5. `bash test-breadth/freeze/4-close.sh` — the tag, by -F from the
   committed message file; minted == file verified byte-wise.

## What the six patches install (2-freeze's order)

| patch | target | authority |
|---|---|---|
| stanza.patch | proplang.cabal — the breadth stanza | draft-stanza precedent |
| claude-prose-gate.patch | CLAUDE.md — OB-27 scope line + the prose-claim gate (XV.2 as widened, copied) + the one-generator law | the tag's rulings 1–2; the freeze-review verdict (2026-08-07) |
| lint-l8-hardening.patch | tools/prefreeze-lint.sh — L8 + L9/L5 hardened | OB-26 + OB-28 |
| obligations-heir.patch | OBLIGATIONS.md — advances + OB-32 + OB-19 amendment | the tag's ledger routings |
| fl-repairs.patch | boundary-audit.sh:136 + Host.hs:387 + dispositions VIII.3 bracket | pack XVII + VIII (routed) |
| membrane-breadth.patch | membrane-wire.md — the breadth key's section-2 bullet + the R-D23 heir-landed pointer | the mandate round (F8); the sibling increments' membrane-install form |

## What stays owed after this freeze (Phase 3, the implementation)

- The stub becomes the implementation (Enumerate.hs `Breadth` family
  + the Host breadth key with its refusal surface); gates 1–7 green;
  anchors byte-stable (movement = stop-and-report).
- The kill matrix vs the grown pool; M8 promoted as b7's kill
  (OB-31/OB-19 discharge at the close tag); the seeded-defect shapes
  d1-d10 (lowercase, the pack's naming; ten of them — d10 the freeze
  review's constructed ratio kill) are the drafted pool candidates.
- The close-out pack, the author's countersign (r1), publication on
  the author's call.

## The freeze review (2026-08-07) and the delegation

The author's freeze-review verdict ruled the phase "fit to freeze,
subject to two corrections that touch the mint text itself," plus
three smaller items and one record note — all EXECUTED at r11 (the
record: pack Part XIX):

- the ENVELOPE measured with the null face on (the ordered cell,
  opening/envelope-null-run.txt) and restated in the tag message —
  the sitting's "headroom six" was pairs-only and the heir ships
  both faces behind one key;
- the BAND restored to the sitting's +/-0.03 (U7's third ruling;
  the interim +/-0.06's premise collapsed post-climb), with the
  kit's own cabal build class measured FIRST
  (opening/cabal-drift-probe.txt) and a licensed re-mint
  PRE-DECLARED at the implementation's close;
- the wire cell reconciled (832.7 is the mint; the prose had cited
  the pre-mint placeholder), the 0.5%->0.8% arithmetic corrected;
- the ONE-GENERATOR LAW canonized (the CLAUDE.md touch grew its
  third clause under the verdict's authority);
- U12 DISPOSED (round-label repair rows now carry commit hashes;
  L8's population over this pack is nonempty), U9's
  pin-preservation note recorded.

THE KEY ACTS RAN ON DELEGATION, recorded verbatim from the verdict:
"Correct the envelope, settle the band, reconcile the wire cell.
Then 1-verify, SITTING.md and the tag message have my review, and
the key acts are yours." Builder key, per the membrane precedent;
R-D22's author re-tag is a condition of the increment's closure.

## The rehearsal record

The kit was rehearsed two-sided from a fresh clone before this sheet
reached the author: greens sealed end-to-end, and every KIT GUARD
RED fired (the kit's own four guards - refused key, orphan patch,
surviving [MINT] marker, perturbed literal - distinct from the
oracle rows' seeded-defect reds d1-d9, which ride opening/defect-*).
The rehearsal transcript rides test-breadth/opening/rehearsal.txt.
