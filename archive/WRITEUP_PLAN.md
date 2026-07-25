# WRITEUP_PLAN — the write-up boundary (the roadmap's close)

The last boundary ROADMAP names, opened on the author's instruction at
the CIRL close. Its business, per the roadmap's own words: consolidate
design.md + interface.md + the measured record against the original
brief's §12; surface the brief into the repo (and the manifest) at
planning, "making the definition of done auditable in place"; declare
the cut list as recorded debt. Boundary-queue item 5 — the
arithmetic-free expressiveness boundary — lands in the honesty section
as the fourth honest sentence, both faces stated.

Task 0 stops here for rulings on W1–W9. Nothing frozen is touched;
nothing joins the manifest until the author acts at a freeze boundary.
One fact shapes everything below: **the brief is not in the
repository.** Only the author holds its text. The builder cannot draft
the §12 audit, or even fix the audit's method beyond a proposed shape,
until the brief lands — and it must land verbatim from the author's
hand, because it is about to become the frozen document against which
the whole record is judged. This boundary has a custody symmetry worth
naming: for every prior increment the builder wrote the oracle and the
author froze it; here the oracle — the §12 checklist — was written by
the author before the project began. The builder never owns it live
because the builder never owns it at all.

## T1. What the boundary produces

Four artifacts, in dependency order:

1. **The brief** (`brief.md`, name per W1) — enters the repo verbatim
   and joins the manifest. It is the project's origin document and its
   definition of done; after this boundary, "did the port do what was
   asked" is answerable by anyone with `sha256sum` and `git tag -v`.
2. **The §12 audit** — one row per checklist line: the line verbatim;
   the discharging artifact(s), each a frozen, verifiable pointer
   (file:§, tag, suite/test name, report §); a status from a closed
   set {DONE, RECORDED DEBT, NAMED OPEN}. Every DONE points at
   something frozen; every RECORDED DEBT points at the cut list or the
   boundary queue's disposition record; every NAMED OPEN points at
   design.md §10's open-problems list. A §12 line that fits none of
   the three is a stop-and-report, not a prose problem — the audit is
   allowed to fail, and a failed row would be the finding.
3. **The write-up** (`WRITEUP.md`) — the consolidation: the claim, the
   language as built, the enforcement architecture, the measured
   record, the §12 audit, the honesty section, the close. Shape per
   W3; it cites the frozen texts rather than duplicating them — they
   stay normative, the write-up is the record's face.
4. **The closing freeze** — whatever W2 rules into the manifest, under
   an author-signed tag (W8), with a final report and reviewer block
   (W9) if the author wants this boundary closed the way the six
   increments were.

## T2. The artifact record (the audit's ground truth, enumerated)

What the §12 rows have to point at — inventoried here so the audit
drafts against a fixed list, not a memory:

- **Frozen texts:** design.md, interface.md, typed-port-spec.md,
  CLAUDE.md, proplang.py, tests_acceptance.py, test_output.txt,
  proplang.cabal, cabal.project.freeze — all under the 63-entry
  MANIFEST.sha256.
- **Frozen suites:** eight, 127 tests — acceptance 4, properties 3,
  hygiene 15, membrane 31, expfam 22, ladder 20, prepost 15, cirl 17
  — plus each increment's ablation runner and fixtures, all frozen.
- **Deletion audits:** the Phase-2 audit rows plus the increments'
  rows; FOURTEEN ablation flags, src/ whole under every one.
- **Custody:** ten manifest signatures (5 author-key, 5 builder-key,
  the split recorded in boundary-queue's custody section); four
  author-attested freeze tags — membrane-freeze, ladder-freeze
  (delegated, delegation recorded verbatim in the tag), prepost-freeze,
  cirl-freeze; the hygiene and expfam boundaries predate the tag
  scheme and are attested by their manifest commits' custody notes.
- **Reports:** PHASE1, PHASE2, HYGIENE, EXPFAM, MEMBRANE, LADDER,
  PREPOSTERIOR, CIRL — each with its as-built register answers,
  incident record, and reviewer block run green.
- **The measured record:** tests A–F (A/B/C membrane; D the standing
  tripwire; E's slot row; F the ladder); the margin readout stable
  digit-for-digit across seven runs; the CIRL sweep (asking dies at
  k=1, listening at k=4, VoI 0.233 → 0.122 → 0.029 → 0.008 → ≤1e-12);
  the three residues printed at their proven minima (ROADMAP's
  definition-of-done section, filled).
- **Debts and boundaries:** the cut list (five items); the boundary
  queue's dispositions; Chan's recorded debt (CIRL C5); the
  arithmetic-free boundary (item 5).

## T3. The audit method (proposed; final only after the brief lands)

The table lives inside WRITEUP.md (not a separate file) so the
document and its evidence cannot drift apart, unless W2 rules a
separate checklist file. Method: for each §12 line, the row is drafted
RED — status column empty — and flips only when its artifact pointers
are verified in place (the file exists at the quoted section, the tag
verifies, the test name appears in the suite, the number matches the
frozen source byte-for-byte). Pinned numbers quoted in the write-up
are DERIVED from the frozen artifacts (b7f120e discipline), never
retyped from memory.

**The machine check (W6):** proposed as a small runner in the audit
convention — `sh`-level, no new cabal stanza — that (a) resolves every
artifact pointer in the audit table (paths exist, tags `git tag -v`
clean, suite counts match `cabal test` output), and (b) greps every
pinned number the write-up quotes against its named frozen source.
Runtime-red analog: the runner is written against the drafted table
before WRITEUP.md's rows flip, and is red while any row is. This is
the reduced form of the increment protocol's oracle — the full form
(a test-writeup/ stanza under gate 5) is available if the author
prefers the write-up held to exactly the increments' standard.

## T4. The honesty section (the four sentences)

The section carries, at minimum:

1. **Alphabet** — expfam basis + rw the one proven non-expfam
   combinator + the namespace law; the invariance constant real and
   unpriced (design.md §10's sentence, now with the expfam and
   membrane increments' sharpening).
2. **Clock** — the induction base survives; the ladder prices every
   rung above it (test F); the language still cannot say its own
   executor.
3. **Pointer** — deference measured while uncertain, its vanishing at
   convergence measured too; the predicted negative result delivered
   as a measurement, not an apology.
4. **The arithmetic-free boundary** (item 5, both faces, per the
   author's ruling at the CIRL close): as recorded debt — arithmetic
   nodes are a future reported alphabet change, priced like everything
   else — and as the accidental virtue it proved to be — the step form
   held the control identity at 1.1e-16 where the linear form carried
   one-ulp dust. A limitation found by measurement and recorded rather
   than patched is what the residue discipline was for.

Proposed placement for the build's incident record (the ExpFam
re-open, the membrane pre-tag re-open, the locale incident, the
Argmax-environment bug caught by the fixture proof): a separate
process-record subsection, NOT among the honest sentences — the
sentences are about the language; the incidents are about the build
and are already carried by the reports. Author's call (W5).

## T5. Protocol shape and sequencing

ROADMAP fixes one thing: the brief joins repo and manifest **at
planning** — i.e., at this boundary's first freeze act, before the
write-up is drafted, so the write-up is written against a frozen
target it cannot bend. That implies the two-stage shape:

- **Task 1 (the brief's entry — author act):** the author supplies
  brief.md verbatim; manifest extended over it (63 → 64, or +2 if the
  §12 checklist is a separate file); one freeze commit; author-signed
  tag (W8). From that signature the definition of done is frozen.
- **Task 2 (the audit, red):** builder drafts the §12 table with
  artifact pointers, all rows red; the machine check written and red.
  Stop-and-report if any §12 line is undischargeable.
- **Task 3 (the write-up):** WRITEUP.md drafted; rows flip as pointers
  verify; machine check green; taildrop to pixel6 for review.
- **Task 4 (the close — author act):** author review; whatever W2
  rules joins the manifest under the closing tag; final report and
  reviewer block per W9.

## Register (W1–W9, for author rulings)

- **W1 — the brief's entry.** Only the author holds the text. Does it
  enter by the author's own commit from their shell (cleanest: the
  document that judges the work enters by the hand that wrote it), or
  handed to the builder for a builder-signed commit verified verbatim
  at the tag? Filename (`brief.md` proposed). And: verbatim as
  originally written — warts, stale predictions, and all — or with any
  annotation? Proposed: verbatim, unannotated; it is entering as a
  historical document and the audit is where it meets reality.
- **W2 — what joins the manifest.** Certain per ROADMAP: the brief +
  its §12 checklist. To rule: does WRITEUP.md itself freeze at the
  close (proposed YES — it quotes frozen numbers; unfrozen it could
  drift from them silently)? The machine-check runner (proposed YES,
  with the audit scripts)? Do ROADMAP.md and boundary-queue.md finally
  freeze, archive, or stay working documents?
- **W3 — the write-up's shape.** Standalone-readable consolidation
  (paper-shaped, citation-heavy, frozen texts stay normative) vs a
  thin audit document that mostly points. Proposed: the former.
  Audience assumption: a reader with the repo, not a conference.
- **W4 — the audit method.** The three-status closed set, rows red
  until pointers verify, failure is stop-and-report. Table inside
  WRITEUP.md or a separate frozen checklist file?
- **W5 — the honesty section.** The four sentences as T4; incidents
  to a process-record subsection rather than sentence rank. Any
  further candidate the author wants raised to sentence rank?
- **W6 — the machine check.** Reduced form (sh runner, audit
  convention, no stanza) vs full increment form (test-writeup/ under
  gate 5) vs none (the reviewer block alone). Proposed: reduced.
- **W7 — the cut list's form.** ROADMAP's five items verbatim as the
  recorded-debt section, each with a pointer to where its debt was
  filed (peer decision, T1 record, C5, M-rulings)? Proposed: yes.
- **W8 — tags.** Two boundary acts, so: one tag at each
  (`brief-freeze`, `writeup-freeze`)? Or fold Task 1 into an untagged
  manifest commit and tag only the close? Proposed: two tags — the
  brief's entry is the definition of done becoming binding, which is
  exactly the kind of moment the tag scheme exists for.
- **W9 — the close.** Does the boundary end with a WRITEUP_REPORT (or
  a closing section inside WRITEUP.md) and a final reviewer block —
  the project's last — covering manifest, gates, custody chain, all
  tags, and the machine check? Proposed: a closing reviewer block
  inside WRITEUP.md itself, so the document that consolidates the
  record also closes it.

## Predicted freeze footprint

Task 1: manifest 63 → 64 (65 if the checklist is a separate file);
no src/, no test*/ change; no frozen-text edit beyond the manifest
itself. Task 4: + WRITEUP.md, + the runner (per W2/W6). No pinned
anchor can move at this boundary — the write-up quotes, it does not
compute; any disagreement between a quoted number and a frozen source
is a defect in the write-up by definition, which is what the machine
check enforces.

## Task order

0. This plan; taildrop; STOP for W1–W9.
1. The brief's entry (author act; manifest extension; tag per W8).
2. The §12 audit drafted red + machine check red. Stop-and-report on
   any undischargeable line.
3. WRITEUP.md until the rows flip and the check is green; taildrop.
4. Author review; closing freeze per W2; the last reviewer block.
