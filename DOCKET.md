# DOCKET — standing demand entries, in-tree

**What this file is.** The issue tracker holds no standing entries. The
author's ruling of 2026-09-19, verbatim: *"what is the point of an open
issue? standing entries for demands will have to be elsewhere... ALL open
issues must be closed when dealt with"*. So when a consumer's demand has
been dealt with but not granted, the issue closes and the demand is
recorded here as one row. The row says what was asked, what measurement
came with it, which gate it waits behind, and where the record lives. A
closed issue is still the citable record, and each row points at its
issue.

**Custody.** The builder maintains this file. It is NOT in
`MANIFEST.sha256`, and it rules nothing. It is a register of what was
asked, never a schedule. A row folds into `OBLIGATIONS.md` only at a
boundary, under the author's key. The first boundary that receives this
file decides whether DM rows fold there (see the inventory below). Rows
are append-only. A row leaves the table only by a state change: GRANTED
(the capability landed; cite the commit), LAPSED (the demanding consumer
withdrew it; cite where), or FOLDED (it became an `OBLIGATIONS.md` row;
cite the id).

**Row form.** `DM-n | issue | the demand | the measurement attached | the
gate it waits behind | state`. The two-sided gate governs every row. A
demand re-enters only with a measurement. A new production also needs its
executed failed composition, per the primitivity clause (a) in
`CLAUDE.md`.

| id | issue | the demand | the measurement attached | the gate it waits behind | state |
|---|---|---|---|---|---|
| DM-1 | #15 (life-agent) | Fold a recorded act with its evidence without the engine deliberating. At HEAD the door leaves exactly one evidence-tick shape that folds. The act published as a feature is refused (`feature/assignment collision`). A menu-less tick is refused (`tick refused: missing declared ["act"]`). The shape that remains carries a menu, so it runs the chooser. Under a declared clock the chooser includes the preposterior, and the consumer discards the act it picks. | The #15 thread, and life-agent r45, which names it the engine-side twin of JP5 reading B. `issues-2026-09-19/reconfirm-15-17-25.txt` has the four door replies at `571b589`. The cost face was measured 2026-09-19 in `issues-2026-09-19/transcript-29-clock.txt`: on life-agent's categorical world, each evidence tick under the clock costs about K+1 clockless ticks. | The door (the host's `tick` handler). Any change is a wire change under its own increment. | RECORDED; issue closed 2026-09-19 |
| DM-2 | #17 (nethack-beater) | `observe_batch` / `observe_counts`, the warm channel. | #17's scaling measurement. `f4-standing-issues-transcript.txt` records that its cost model predates the exact re-founding of 2026-07-25. Both verbs are still refused at `571b589` (`expected tick`; reconfirm transcript). | `membrane-wire.md` §6.3: increment D's design layer, under a D-scoped increment and its own gate. | RECORDED; issue closed 2026-09-19 |
| DM-3 | #25 (life-agent) | A bounded folded state: per-tick cost that does not grow with t. | F11 (`chooseeu-sitting/r2-f11-state-bits.txt`): the folded state's qbits grow LINEARLY in t on both profiles. `observeS` is unchanged since `94fd4eb` (reconfirm transcript). The local record is `chooseeu-sitting/drafts/brain-seam-demand.md`. | The gate owner's act, per `brain-seam-demand.md`. | RECORDED; issue closed 2026-09-19 |
| DM-4 | #26 (life-agent) | Per-cell tracking of more than two cells, which needs a model that cuts on two guards. The wire's corpus is `enumerateWith`, where every guard model has exactly one `Get` and one `If`. So the posterior picks ONE cut, and every cell off that cut reads the winning model's other arm. | r49 S4 and r51b on the consumer's side. `issues-2026-09-19/transcript-26.txt` on ours: a constructed stream at r49's cell counts on the release binary and on HEAD, with in-process p1 equal to the wire's p1 bit-for-bit. That transcript also carries the per-cut posterior mass and leg C, the two-cut sentence under two pricings. | TWO gates, both measured. (i) The door deferral, which is lint L10 and the #19 doctrine's named heir: nested-`If` sentences exist only in `corpusBodies`, and the wire never routes them. (ii) The price. Under the grammar's own weight (`weightIn`, R17's normative prior), a two-cut sentence starts 92.4 bits behind a constant, against about 46 bits of likelihood gain. On this stream it is not bought, and neither is a single cut: the constants keep 0.99993 of the mass. So landing the door with the normative prior would not by itself deliver the tracking. Only a two-cut priced like the selector's single cut, 22.5 bits behind a constant, is bought: 88% of the mass, and three cells track. That price is the builder's extension (leg C-x): nothing shipped or ruled prices it. | RECORDED; issue closed 2026-09-19 |
| DM-5 | #29 ask 2 (life-agent) | The two-layer episode: a channel rate learned ACROSS episodes, with an atom posterior kept per episode. | The 605-decision K distribution, and the filer's test shape (N episodes, K in {1..8}, one true channel rate). Both are recorded in the disposition, #29 comment 5741262497. | Primitivity clause (a). The composition attempt is named in the disposition and is ARGUED-NOT-EXECUTED: one session at K = max+1 with OB-11's reserved tail, atoms re-bound per question by the host, and the shipped atom-switching guard family keyed on a question-id feature. Its cheapest falsifier is that run. | RECORDED; issue closed 2026-09-19 |
| DM-6 | #29 ask 5 (life-agent) | Utility revised within an episode: the per-tick-utility face of the mid-episode declaration-change class. | The boot `u_wrong` drift over 20 boots, −8.83 to −5.13. This is a field measurement, cited beside OB-11. | OB-11 is DISCHARGED (the disposition sitting of 2026-07-22). The wire does not yet say what OB-11's one answer means for the utility face; see inventory item 1. | RECORDED; issue closed 2026-09-19 |
| DM-7 | #29 ask 3 (life-agent) | Latency of a categorical episode as k grows. | The filer's `models` column (344·k enabled, 1601·k in arm A; #29 comment 5741297010). `issues-2026-09-19/transcript-29-clock.txt` has the clocked/clockless ratio per tick measured on the filer's own episode function. The clock multiplies EVERY menu-bearing tick, evidence ticks included, by about K+1. That is roughly ×5 at k=3, against the ×45 per-model gap between the filer's arms. The rest of that gap is not the clock (see the transcript). | Residue with measured designs in the breadth pack (P4, the quotient route; P5, fast-eval), and DM-1's door. | LAPSED on the consumer's side: the filer retires the categorical world at J1 (#29 comment 5741297010). Re-enters if a clocked K-ary world returns. |

## Owed at the next boundary: the frozen-layer inventory

These are findings for the next boundary's sitting. None is an edit now.
The builder touches frozen text only at a boundary, under an inventory
brought to the sitting.

1. `membrane-wire.md`, the per-tick-utility bullet (the dated repair of
   the W4 freeze, 2026-07-21). It says "OB-11's ruling-pending family ...
   when that ruling comes it answers both faces at once". OB-11 was
   DISCHARGED at the disposition sitting of 2026-07-22 ("mid-episode
   declaration change has one answer wherever it appears"). The bullet
   names as pending a ruling that has come, and the wire never states what
   that one answer means for the utility face. #29 inherited the stale
   pointer. First recorded in the #29 disposition.
2. `OBLIGATIONS.md`: whether DM rows fold into the ledger, and in what
   state category. This is the author's call. Until then this file is the
   register.
3. `membrane-wire.md` §6.3's UNSHIPPED bracket cites issue #17, which is
   now closed. This is a pointer note, not a falsification: the closed
   issue is still the record, and DM-2 is the standing entry.
