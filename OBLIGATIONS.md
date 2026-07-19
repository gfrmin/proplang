# OBLIGATIONS — the atomic obligations ledger

Installed at the wire boundary opening (2026-07-20), RC-2's remedy
(wire-author-pack.md Part III). The rule this file enforces: **one row
per ATOMIC obligation, each with its own state and its own discharge
event — a composite row must decompose into atomic members before it
enters.** Provenance: VoI non-negativity was carried to step 9's
opening checklist as a parenthetical inside a three-property composite
row, two of whose members were already satisfied; the composite read
as "mostly done" and the parenthetical evaporated with no register
ruling, no oracle row, no discharge mark — while g4Self, a standalone
row with an explicit discharge event, survived its deferral window
(the full anatomy: wire-author-pack.md Part III RC-2).

States (greppable, one per row): `SCHEDULED@<tag-prefix>` (owed at the
boundary whose freeze tag starts with the prefix) · `RULING-PENDING`
(no work scheduled until the author rules) · `LANDED@<tag-prefix>`
(oracle row exists, boundary not yet closed) · `DISCHARGED@<tag-prefix>`
(done, with provenance) · `RETIRE-UNTIL-<tag-prefix>` (retired, returns
at that boundary). tools/boundary-audit.sh row 3 flags every
`SCHEDULED@X` and `RETIRE-UNTIL-X` row whose target tag already exists
— the exact shape that killed the VoI row, mechanized.

| id | obligation (atomic) | state | provenance / notes |
|---|---|---|---|
| OB-1 | VoI non-negativity property over the Expect-composition | DISCHARGED@wire-open | the step-9 owed row (AGENT_PLAN.md:1121-1126), landed test-law/ g1, gate -1e-13 from measured floor; issue #2 closes |
| OB-2 | contrast-context p1 discrimination pinned on the wire | DISCHARGED@wire-open | test-measure/ g1; issue #5 closes (S = 0.794, defect does not reproduce) |
| OB-3 | ms/tick instrument at the pinned populations, run each freeze | DISCHARGED@wire-open | test-measure/ g2; issue #6 closes; the run-each-freeze half is standing (gate 5 absorbs the suite) |
| OB-4 | emission grid declarable at the handshake, default bit-identical, populations re-pinned | RULING-PENDING | issue #4; CONFLICTS with the METAREASONING_PLAN.md:30/:216 condemnation (author, 2026-07-11) — ruling R-W1 (WIRE_PLAN §5); executes at W3 iff ruled open |
| OB-5 | observation arity declarable at the handshake (K-ary carrier/space), default binary | SCHEDULED@wire-w3 | issue #9 / increment A's fired gate; one wire change with OB-4 |
| OB-6 | parseSaid extended to the full priced grammar (Div/Log/Exp/Neg) | SCHEDULED@wire-w4 | issue #3; author ruled implement (2026-07-20) |
| OB-7 | said@1 declarations priced; bits in the hello reply | SCHEDULED@wire-w4 | issue #1 half 1; membrane-wire bracket of 2026-07-20 binds this oracle |
| OB-8 | said@1 grid-priced parameter latent (or the narrowed ruling, stop-and-report if alphabet motion needed) | SCHEDULED@wire-w4 | issue #1 half 2; membrane-wire section 2's promised sentence |
| OB-9 | deliberation ladder shipped behind the wire (composition only, zero new productions) | RULING-PENDING | issue #8; the cancelled boundary V's question re-put with step-10's composition in hand — ruling R-W2 (WIRE_PLAN §5); executes at W4 iff ruled open |
| OB-10 | membrane-wire.md brackets of 2026-07-20 (utility bullet + section 3 head) replaced by sentences true of the as-ruled wire | SCHEDULED@wire-w4 | the W2 sitting's re-repair obligation; whichever way R-W1/R-W2 rule, the brackets must not outlive W4's close |
| OB-11 | mid-episode K growth disposition | RULING-PENDING | issue #10; options open/out/bounded-reserved-tail (namespace precedent) |
| OB-12 | increment B gate reading (two-stream inverted polarity; unblocks bar-less FBR_safety) | RULING-PENDING | issue #11; if read fired, B schedules after W4 |
| OB-13 | routing disposition (in-scope-eventually vs dual-engine-declared) | RULING-PENDING | issue #12 |
| OB-14 | continuous carriers disposition (rssfeed named consumer; filing recommends wontfix) | RULING-PENDING | issue #13 |
| OB-15 | coupled utility latents: demand re-statement post-W3, then disposition | RULING-PENDING | issue #14; #4/W3 is its prerequisite |
| OB-16 | GetV banked composition-failure: RE-EXECUTE before reliance if the alphabet moves (banked-failure expiry clause) | RULING-PENDING | step-10 residue; the clause canonized at reflexive-freeze-r0 |
