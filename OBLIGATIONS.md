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
| OB-4 | emission grid declarable at the handshake, default bit-identical, populations re-pinned | DISCHARGED@wire-rulings | discharged BY RULING, not by landing: R-W1 ruled 2026-07-20 outcome (i)+(iii) — condemnation HELD, no emission grid key ever, from anyone; the obligation as written is ruled not-to-be; issue #4's answer is boundary R (purchased refinement, R_SCOPE.md); interim = `thetaPoints` as bracketed operating point, high-threshold hosts out of scope until R |
| OB-5 | observation arity declarable at the handshake (K-ary carrier/space), default binary | DISCHARGED@w3-freeze-r1 | issue #9 / increment A's fired gate; arity ONLY (OB-4 ruled out 2026-07-20 — W3 has no grid half); oracle landed 2026-07-21: test-arity/ 21 rows (e1ea38e), frozen at the W3 sitting on the author's six rulings (wire-author-pack.md VII.7), sealed 27ba095 (delegated tag w3-freeze-r0), implementation green 6450b5c (17/17 suites, gates 1-7, ablation fires); discharge event fired 2026-07-21: the author's own tag w3-freeze-r1 over 6450b5c (author key, verified) — the R-D22 chain complete; issue #9's arity half shipped |
| OB-6 | parseSaid extended to the full priced grammar (Div/Log/Exp/Neg) | DISCHARGED@w4-freeze-r1 | issue #3; author ruled implement (2026-07-20); oracle test-said/ g1 (four forms + composite + fail-closed + the `<` refusal with its swap composition live in g1d-ii, ruling 3: bit-identical argument swap), frozen 4d709a8 (delegated tag w4-freeze-r0), implementation green 0bc32ed (18/18 suites, ablation fires, thirteen forms on the wire); discharge event fired 2026-07-21: the author's own tag w4-freeze-r1 over 0bc32ed (author key, verified) — issue #3 shipped |
| OB-7 | said@1 declarations priced; bits in the hello reply | DISCHARGED@w4-freeze-r1 | issue #1 half 1; oracle test-said/ g2 (utility_bits byte-pinned to the frozen bitsIn, chained through test-pricing; absent-key route byte-identical; delta gate 1e-12 from floor 0.0) + g3 (the D-f8 door, parsed-value identity per ruling 4's single-door clause); frozen 4d709a8, green 0bc32ed; discharge event fired 2026-07-21: w4-freeze-r1 (author key, verified) — issue #1's pricing half shipped |
| OB-8 | said@1 grid-priced parameter latent — NARROWED (ruling 2, 2026-07-21): W4 delivers the DEGENERATE latent (point-mass over declared shape, parameter on the declared cgrid); the OPEN parameter latent's wire form is REFUSED (world-declared P(evidence\|utility-parameter) = authored deference, the manipulation shape CIRL exists to exclude); its lawful in-language form (the test-outcome g5 composition) is FUTURE DEMAND under its own gate | DISCHARGED@w4-freeze-r1 | issue #1 half 2; membrane-wire §2's promised sentence narrowed in place at the W4 freeze (the ruling quoted in the §2 bracket); the refusal is the alignment statement's third application ("the world declares WHAT it values, never HOW evidence about its values must be read"); the DEGENERATE latent shipped green at 0bc32ed; discharge event fired 2026-07-21: the author's own tag w4-freeze-r1 over 0bc32ed (author key, verified) |
| OB-9 | deliberation depth chosen by the agent under prices (the ladder's successor obligation, re-homed) | DISCHARGED@r1-freeze-r1 | issue #8; R-W2 ruled 2026-07-20: depth is an in-language purchase delivered at boundary R; LANDED 2026-07-21 at R1 implementation green (the joint law: think-deeper an internal act beside refine, one option space, one clock, the rung ladder inside runPurchase; oracle rows g9 — recurring-stakes buys, one-tick world stays myopic as the CHOSEN rung — and g12's order pin; 16/16 suites, gates 1-7); discharge event fired 2026-07-21: r1-freeze-r1 (author key, verified); issue #8's answer shipped |
| OB-10 | membrane-wire.md brackets of 2026-07-20 (utility bullet + section 3 head) replaced by sentences true of the as-ruled wire | DISCHARGED@w4-freeze-r1 | the W2 sitting's re-repair obligation, discharged in halves exactly as ruled: the utility bullet's bracket DIED at the W4 freeze (4d709a8 — §2 re-stated to the shipped truth, the 2026-07-20 bracket superseded by the W4 bracket carrying rulings 1/2 verbatim); the §3 head's re-repair already states the RULED truth (myopic until R, the 2026-07-20 conditional-RESOLVED note) and STANDS until R's freeze re-states that section — that residue is R's, not this row's; closed under w4-freeze-r1 |
| OB-11 | mid-episode K growth disposition | RULING-PENDING | issue #10; options open/out/bounded-reserved-tail (namespace precedent) |
| OB-12 | increment B gate reading (two-stream inverted polarity; unblocks bar-less FBR_safety) | RULING-PENDING | issue #11; if read fired, B schedules after W4 |
| OB-13 | routing disposition (in-scope-eventually vs dual-engine-declared) | RULING-PENDING | issue #12 |
| OB-14 | continuous carriers disposition (rssfeed named consumer; filing recommends wontfix) | RULING-PENDING | issue #13 |
| OB-15 | coupled utility latents: demand re-statement post-W3, then disposition | RULING-PENDING | issue #14; #4/W3 is its prerequisite |
| OB-16 | GetV banked composition-failure: RE-EXECUTE before reliance if the alphabet moves (banked-failure expiry clause) | RULING-PENDING | step-10 residue; the clause canonized at reflexive-freeze-r0 |
| OB-17 | boundary R opened by the author's own signed tag over R_SCOPE.md (as amended by the author) | DISCHARGED@r1-freeze-r1 | R opened 2026-07-20 on delegation (r-open-r0) and author-attested same day (r-open-r1); the tag over R_SCOPE AS AMENDED (R-R1/R-R2/R-R3) authorized 2026-07-21 and executed as the delegated r1-freeze-r0 under the sitting's recorded delegation; R_SCOPE.md enters the manifest at this freeze per r-open-r1's message; discharge event fired 2026-07-21: the author's own tag r1-freeze-r1 over 5bc1686 (verified, author key), covering the freeze commit through its history |
| OB-18 | METAREASONING_PLAN.md design conclusions re-executed against the shipped grammar before R relies on them (banked-failure expiry — the plan predates the step-8/9 alphabet motion) | DISCHARGED@r1-freeze-r1 | R_SCOPE.md §3; sibling of OB-16, same clause; DISCHARGED BY R0 ITSELF (r-author-pack Part I: the mechanical sweep, the referent audit, both mandatory programs executed with pre-stated criteria) — the audit convicted three stale referents, expired the myopia line, and re-grounded the guard; sealed under the r1 chain, closed by r1-freeze-r1 |
