# paper-freeze-r0 — the conferral brief

**READING COPY.** Nothing here is applied and nothing is signed. The
authoritative artifacts are named at each section head and live in the repo;
this file inlines them so the sitting can be read and ruled on a phone with no
repo access. Where this brief and the repo disagree, the repo is right and this
file is the defect.

**Who wrote this:** the builder — the interested party. That is the whole reason
it is going to a second agent who did not build it.

---

## What is being ruled

`paper-freeze-r0` is **the terminus**. It closes step 5 of `EXACT_PLAN.md` §13.0,
the demonstration tier, and with it the roadmap installed verbatim from the
author's directive of 2026-07-26. After it there is no scheduled work: everything
remaining is named demand-gated residue re-entering only through the two-sided
gate with a measurement.

Step 5 had three parts. Two were already closed before this sitting:

| part | state |
|---|---|
| (a) the A-gate reading | **closed.** OB-12's differential run, 95k live events, ruled at the X.5 sitting (ruling 7: *A stays closed, B stays out* at `n_inv = 0`); posted to its consumer 2026-09-02. |
| (b) the benchmark | **landed, band measured-blank.** r02.4's falsifier found the folded state carries O(t) bits. The seam-swap judgement is the owner's and is **not** made by this tag. |
| (c) the paper | **this sitting.** `PAPER.md` + `test-paper/check.sh`. |

---

## The five questions

A second reader's job is these. Everything after this section is evidence for
them.

### Q1 — Does `PAPER.md` earn the terminus?

The paper stands on six claims, each meant to be closed by an *executed*
artifact, no partial credit: necessity by executed deletion, sufficiency by
executed interpolation, soundness by four gates, exactness by `==`, closure by
E4, and a live host.

*What to look for:* a claim that is asserted rather than witnessed; a number in
the prose that no pin covers; a universal ("every", "no", "cannot") with no
claims-register row. The paper's own checker enforces 27 pins, the thesis quote,
pointer resolution and register completeness — **but it cannot check the
sentences around the numbers**, and that is exactly where the author's own
review found four defects (see "The review, and what it cost" below).

### Q2 — Was the wire defect handled correctly?

Executing the witness for claim 6 broke the shipped host. The sequence was:
found → reported without a workaround → author ruled *"never freeze a known bug
or hole"* → fixed oracle-first under a new suite.

*What to look for:* whether the repair is really a *conformance* repair (the
frozen membrane already declared the behaviour) rather than a language change
smuggled in at a document boundary; whether the oracle was genuinely written
before the fix and genuinely red; whether the control rows are real controls.

### Q3 — Is gate 5 acceptable as attested?

Gate 5 is `cabal test all -j1`. Thirteen of fifteen suites are green, `selection`
passes, and `breadth` fails **one** row: the `drift-a` timing cell.

Two runs gave ratios **1.4956** and **2.3020** against a frozen **1.9078** with a
gate band of **±0.03** — bracketing the frozen value from *both* sides. Absolute
window means ran +95% to +200% over frozen. The box was at load average ~13.5 on
8 cores, with a `julia` process pinning a core for 4 days 21 hours alongside
`clickhouse`, `uvicorn` and two other Claude sessions.

The builder's attribution argument: `drift-a` builds its agent from
`sentenceAgent` directly and **never calls `serveLine`**, which is where the
entire repair lives — so the increment cannot reach it.

**A withdrawn claim, on the record.** The builder also wrote "straddles, so noise
not regression" from two samples. That was premature and is withdrawn. It was
replaced by measurement — eight samples of the cell alone:

```
1.7575 1.8504 1.9204 1.9638 2.0568 2.1121 2.1672 2.2391
median 2.0103  mean 2.0084  stdev 0.1644   frozen 1.9078, band ±0.03
inside the band 1 of 8       stdev / half-band 5.5×
95% CI of the mean [1.8710, 2.1459] — CONTAINS the frozen value
```

So: **the gate cannot resolve its own band under this load** (decisive), and
**the centre has not been shown to move** (no regression indicated, no clean bill
of health claimed).

*What to look for:* note what that measurement does **not** answer. It answers
"can the gate resolve under load?" — no. It does not answer "must gate 5 be
skipped?" The honest alternatives remain (i) quiet the box and re-measure, or
(ii) `RUN_GATE5=0` with an attestation quoting both distributions. Only (ii)
licenses the skip, and only after (i) has been *attempted and shown insufficient*
— "the box cannot be quieted" is a premise that must be demonstrated, not
asserted. **The builder does not rule on which branch is taken.**

> **[BRACKET ADDED 2026-09-06 — BOTH BRANCHES ABOVE ARE NOW DEAD.]** This
> brief is the record of what was put to the sitting and is not rewritten. But
> the quiet-box attempt it calls for was executed, and it falsified the fork:
> quiet (units stopped and verified, load ~1.5, n=3) gives stdev **0.0087** =
> **0.29×** the half-band, so **the cell resolves its band fine** — branch (ii)'s
> "unresolvable" wording is now a false statement. And its 95% CI
> `[1.9258, 1.9691]` **excludes** frozen `1.9078`, so branch (i) fails the gate.
> A re-mint is not licensed either: the attribution run decomposes the shift
> into **(A)** the wire increment's real but band-inward `-0.0241` and **(B)** an
> unexplained `+0.0737` that survives without it, and Breadth.hs's pre-declared
> clause covers only (A). The close is **blocked** pending the author's ruling
> on (B). Transcripts: `drift-quiet.txt`, `wire-attribution.txt`.

### Q4 — Are the two frozen-layer repairs in the right form?

- **FL-P1** (`CLAUDE.md`) is *normative prose*, so the repair is **in place with
  the falsified clause quoted inside its own repair**.
- **FL-P2** (`EXACT_PLAN.md` §13.0) is *historical record*, so it gets a **dated
  terminus bracket** and both the charter clause and its draft-time status
  annotation are kept verbatim.

*What to look for:* whether the class of each text was read correctly, and
whether FL-P1 genuinely quotes what it falsifies rather than merely describing
it.

### Q5 — Is anything being frozen that should not be?

The standing law the author has now stated twice in different words: *never
freeze a known bug or hole*, and *a green that cannot fail is the mirror image of
the red that cannot fire*.

*What to look for:* anything in the paper stated more strongly than its witness
supports; any check that passes for a reason other than the thing being true.

---

## The review, and what it cost

The author reviewed the first draft and found **four instances of the exact
disease the programme exists to prevent: prose a frozen anchor falsifies** —
precisely the defects the checker could not catch, because it pinned the numbers
and not the sentences around them.

| finding | repair | now pinned by |
|---|---|---|
| T1's prose contradicted its own anchor — "the consult window is exactly the ticks around the shift", above an anchor half of which is startup | replaced with the stronger true claim: consultation happens at startup **and** across the change **and nowhere else** — it tracks posterior uncertainty wherever it lives; the tau→tick bridge is now stated | N17, N18 (the grids themselves), N19 (the world's true shift) |
| T3 quoted the winning row and asserted the loss unwitnessed | the losing row is quoted: on flat, `g=1.0` (the *no-forgetting* limit) beats the agent 350.33 to 351.11 — and is worst of all on drift at 397.93 | N20, N21 |
| claim 6 was ARGUED when its witness already existed; and its named falsifier belonged to the *refusal* claim, not the live-host claim | executed (see below); the register now splits acceptance from refusal so neither witnesses the other | N24–N27 |
| the alphabet was named three inconsistent ways | §1 maps three levels once — wire surface (nine forms, `+`/`=` derived names), terminal alphabet (ten `Expr` constructors — the set §3 quantifies over), fragment productions; §3 states T4's table is Double-era wording (`push` = `Expect`, `argmax` = `Code`) | — |

Two framing corrections the author also made, both **against the paper's own
interest**:

- **§8 gave the dyadic band an honesty exemption it had not earned.** The draft
  invalidated only `alpha_3p`. But P1 is *already fully dyadic* and still grows
  ~19.8 bits/tick — same mechanism, smaller coefficient (the 81x collapse), the
  linearity surviving. The honest statement is the wider one: **every** measured
  exponent partly reads the fold's representation, and the intrinsic per-tick
  cost at bounded state is **unmeasured**. And the slogan was wrong: dyadic
  snapping *is* rounding at declaration time, so this is not "the cost of never
  rounding" but **the cost of never consolidating** — which points at the banked
  door (#25) instead of away from it.
- **§4 said "proving"; §9 said "witnessed, not proven".** §9 was right.

*A second reader may reasonably ask: if four such defects survived the builder's
own two-sided verification, what else did?* That question is the point of this
conferral and should not be treated as rhetorical.

---

## The defect the paper's own witness found

Promoting claim 6 from ARGUED to EXECUTED meant actually driving the shipped host.
It broke.

An undeclared name inside a hello's **utility** was not validated at hello time.
The hello was **accepted**, and the failure surfaced only when the utility was
evaluated — as a **host-process crash** at `evalx`'s `Get` case, not a wire
error. Menu and guard names had always been namespace-checked; the utility's
reads had not. The error site's own comment called itself *"door-unreachable"*;
the wire reached it.

**And it was latent.** Haskell's laziness spares an untaken branch, so one and the
same malformed declaration crashed or succeeded depending on which way a guard
fell at run time — a hello accepted today would crash on the tick the guard
flipped.

The builder reported it and did **not** work around it; no `src` file was touched
while the fork was open. The author ruled **(b): never freeze a known bug or
hole.**

### The repair, and why it is a conformance repair

`membrane-wire.md` §2 already declares the law: *"Unparseable or unpriceable
declarations are validation failures — FAIL-CLOSED."* `src` did not honour it on
one surface. So nothing about the language changed: no constructor, no
production, no type on a frozen surface — which is why **no primitivity gate and
no ablation fixture is owed**, because no terminal enters or leaves.

The fix extends the hello door's *existing* namespace gate — which always checked
guard and menu names — to the utility's reads, with the **same predicate at the
same site**, over a new total traversal `readNames` beside `inCorpus`.

The door is the right site *because* the latent case exists: a check inside
`evalx` would only ever have been a better-worded crash, and would never have
seen the untaken branch at all.

### The oracle, written before the fix

`test-wire/Wire.hs` was written and run against the shipped **pre-increment**
surface first. Its red partition was declared in the suite header and observed
exactly:

```
RED    w1a/w1b/w1c   an undeclared read: bare, nested, under a guard
RED    w2a/w2b       the LATENT case: the untaken branch, and the same
                     sentence with the guard flipped
RED    w5a           the session survives the refusal (it crashed instead)
GREEN  w3a/w3b       control: a declared namespace read still works
GREEN  w4a/w4b       control: a declared MENU-name read still works, and
                     the paper's own all-nine-form hello still parses
```

6 red / 4 green before; **10/10 after**.

The control rows are part of the assertion, not decoration: **a patch that
refused every utility would turn the six green and the four red**, so only the
correct repair is all-green. `w4b` is the paper's own §7 hello, which makes §7's
witness a control on its own fix.

*For the second reader:* the claim "the oracle was written first and was red" is
the one claim in this brief that a reader cannot verify from the artifacts alone
— the red run is gone once the fix lands. What **is** verifiable is the git
history (two commits: oracle+stanza, then fix) and whether the declared red
partition is the one the suite's structure would actually produce.

---

## What this tag deliberately does NOT do

- It does **not** make the benchmark's seam-swap judgement. The acceptance band
  stays measured-blank; that call is the owner's and is explicitly outside the
  tag.
- It does **not** schedule anything. After the terminus every remaining item —
  the quine face, OB-15, OB-19, continuous carriers (foreclosed), the
  bounded-representation demand (#25), brief §6 self-compression — is
  demand-gated residue. Named, not scheduled.

---

## Custody, and what remains the author's

Everything in this sitting was written by the builder in **unsigned** commits;
the builder key is on no box, by design. Still owed, and the author's alone:

1. install FL-P1 and FL-P2 under the author's key;
2. extend and re-sign `MANIFEST.sha256` — the ADD count is **not written here**;
   `pre-close-check.sh` prints it (`EXPECTED POST-CLOSE MANIFEST SIZE`), computed
   from its own array. *[This line read "**13 ADD rows**" when the brief was
   sent; that was the third hand copy of a generated number and it went stale
   twice more (17, then 21) as the sitting's evidence files entered custody. The
   literal is retired here rather than corrected, per the one-generator law.]*
   Two rows are re-hashed, not added (`CLAUDE.md` for FL-P1, `proplang.cabal`
   for the `test-wire` stanza), both *derived* by `close.sh` from
   `sha256sum -c`, never hand-listed;
3. mint `paper-freeze-r0` by `-F <file>` (the tag-message-is-a-file law);
4. ~~resolve Q3 — a quiet-box gate 5, or `RUN_GATE5=0` with an attestation.~~
   *[2026-09-06: both branches falsified — see the bracket at Q3. What is owed
   instead is a ruling on (B), the unexplained baseline shift.]*

The turnkey path is `bash test-paper/freeze/do-close.sh`, which stops at a review
gate and waits for the author to type `reviewed`. **The tag, not any commit
signature, is the attestation.**

---

## Reading order for the appendices below

1. **`PAPER.md`** — the artifact being frozen. Read §7 and §9 with Q1 and Q5 in
   mind.
2. **the tag register** (`r0-tag-msg.txt`) — the answers as they would be signed.
3. **the terminus inventory** — the frozen-layer repairs (Q4) and the defect's
   docket row (Q2).
4. **the live-host transcript** — the executed witness, all three legs.
5. **`test-wire/Wire.hs`** — the oracle (Q2).
6. **the frozen-layer patch** — exactly what FL-P1/FL-P2 change (Q4).
7. **the checker** — what the 27 pins actually pin (Q1).
