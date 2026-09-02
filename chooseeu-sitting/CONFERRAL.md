# chooseeu-author-pack — the #24 sitting (OB-24's unnamed boundary), round r1

*Builder-authored opening round, 2026-09-01, at HEAD `94fd4eb`
(`doctrine-sitting-r0` + `doctrine-sitting-r1`). **Nothing frozen is touched
by this round.** No ruling is taken, no obligation minted, no frozen or
manifest-covered file edited, no tag minted. Every repair below rides as a
DRAFT for the author's key. The sitting is the author's.*

---

## I.1 Why this sitting exists, and the docket it owes

The `doctrine-sitting-r1` tag closed the record with: *"The wire docket's
three scheduled items stand closed; further scope binds the roadmap-terminus
clause."* There was no open docket and no scheduled next increment. Three
things have arrived against that terminus, and re-reading the standing record
turned up a fourth that nobody has been watching.

| row | substance | state |
|---|---|---|
| **F1** | Issue **#24** (filed 2026-09-01): a consumer registers measured demand against `OB-24`'s deferral. `OB-24` is `RULED@trampoline-freeze` — *"chooseEU keeps its shipped fold this increment and migrates, with its own pin row, only at a named boundary"* — and **no boundary was ever named.** | EXECUTED at HEAD |
| **F2** | `tools/prefreeze-lint.sh` reports **4 FAIL** at HEAD where the #19 pack records *"0 FAIL 1 WARN"* at these exact bytes. A **self-falsifying lint row**: writing down the WARN converted it into four FAILs. | EXECUTED, chronology proven by git |
| **F3** | The frozen-layer inventory: three pieces of frozen or of-record prose the code has falsified. | EXECUTED |
| **F4** | The five standing open issues (#11, #14, #15, #16, #17) were all disposed at ONE sitting, 2026-07-22 — **three days before the alphabet last moved.** Re-executed at HEAD under the banked-failure-expiry clause. **One of the author's own posted comments is now false and is actively misinstructing a consumer.** | EXECUTED at HEAD |
| **F5** | `bench/`: the fold-depth measurement's P2 profile was a *reconstruction*; the consumer's real declaration is now readable and differs structurally in **six** ways, and the two levers the report ranked highest **both flip**. Re-run at the real numbers. | EXECUTED (cells running) |
| **F6** | The boundary audit and the lint at the opening. | EXECUTED |
| **F7** | The filer's sharpened question — *is the frozen `chooseEU` pin what makes un-deferring boundary-sized?* — **answered from the frozen oracle: no.** | EXECUTED |

Transcripts, all re-runnable at these bytes, in `chooseeu-sitting/`:

- `opening-lint.txt`, `opening-boundary-audit.txt` — F6
- `f1-issue24-transcript.txt` — F1
- `f2-l5-transcript.txt` — F2
- `f4-standing-issues-transcript.txt` — F4
- `f5-dyadic-lever.txt`, `f5-ab-result.txt` — F5's lever arithmetic and the A/B
- `f7-pin-scope-transcript.txt` — F7
- `drafts/` — the L5 repair with its two-sided demo, the three FL repairs, the issue postings

---

## I.2 F1 — issue #24, and OB-24's unnamed boundary (EXECUTED)

### What #24 is, and is not

It is **not** a complaint about the ruling. `OB-24` already rules
SUBSTITUTION IS NORMATIVE and the filer says so explicitly: *"This issue asks
nothing about the ruling ... we agree."* It is not a request for a softened
bar or a fix on the consumer's schedule; the filer states that *"the boundary
is still the right one, wait for it"* **is a complete answer** and will be
recorded as such.

What it supplies is the one input the register cannot derive for itself:
**measured demand against a deferral**. A ruled deferral is a judgement about
demand; demand is exactly what a downstream consumer can contribute and a
ledger cannot.

### The repro, re-executed at HEAD

Full transcript: `chooseeu-sitting/f1-issue24-transcript.txt`.

The world is #24's, verbatim. Its utility is constant in `y` — every arm
multiplies `["var",1]` by `0.0` — so beliefs are identical across options BY
CONSTRUCTION. Nothing depends on learning, evidence, or the prior.

| arm | reply |
|---|---|
| no `clock` row | `{"act": {"act": 1}, ...}` — the menu **head**, worth 10 |
| `clock` priced 1000 | `{"act": {"act": 2}, ...}` — the declared **argmax**, worth 100 |

`models: 25` matches the issue's table exactly. `{"batch": 0}` →
`{"error": "bad hello"}`, so the preposterior is **not opt-out-able** for a
consumer that wants substitution.

### The mechanism, read at HEAD rather than inferred

`src/PropLang/Host.hs` @ `94fd4eb`, in `actOrThink` — the routing fork:

```
              Nothing -> chooseEU (swNs w) feats (swAtom w) u scored
              Just (price, d) -> thinkValue ... >>= pickWire ...
```

`src/PropLang/Membrane.hs` @ `94fd4eb`, `chooseEU`'s `step` — **one** env,
built from the **challenger**:

```
    step acc chal@(cFeats, bC) = do
      inc@(_, bI) <- acc
      env <- mkEnvIn ns (feats' cFeats) (bC :. bI :. VNil)
```

with `pick = If (Gt (Expect (Var Z) uB) (Expect (Var (S Z)) uB)) 1 0`. Both
`Expect` terms are evaluated in that single env, so a `get` on the menu name
inside the utility reads the **challenger's** assignment on **both** sides of
the comparison. Per-action levels cancel; only beliefs can differ; a world
whose beliefs are act-blind ties every pair, the incumbent survives every
step, and the fold returns the option-space head.

This is `OB-24`'s own sentence. **#24 adds no new mechanism** — which is
precisely why it is a demand row and not a bug row.

### What the consumer is paying

`Host.hs` reaches the substituting chooser **only** through the clock, and
`thinkValue` takes its preposterior branch whenever `batch >= 1`, which the
wire enforces. So the lookahead is not optional for a consumer that wants
substitution and does not want deliberation. The consumer's published
figures, on their own world (960 models, 4 affordances): **297 ms vs 135 ms
per decide, ~2.2x, structural**; on the 25-model repro world, 1.0 ms → 3.6 ms.

**A note on scope, in the filer's own words:** this is on their *migration*
path, not in production — the membrane shadow is env-disabled and has not
accrued since 2026-08-10. What makes it blocking is not a degraded policy but
**an unreadable measurement**: a frozen adoption bar read in this state
compares the incumbent engine's utility-driven policy against a constant
`abstain` and books the gap to the migration.

### The three answers #24 itself offers, in ascending order of engine work

1. **Nothing — confirm the boundary.** Name the boundary `OB-24`'s migration
   row is scheduled at; the consumer holds the clock workaround until it, with
   the price recorded. *The filer states this is a complete answer.*
2. **A documentation amendment** to `membrane-wire.md` section 2's `menu`
   bullet. See F3 row 1 — this row is substantiated and, in the builder's
   reading, is owed regardless of how (1)/(3) are ruled.
3. **Un-defer the migration** — route clockless worlds through `policyPick`
   with no think row. *This is the ask proper.* The filer's actual question is
   narrower and sharper than the ask: **is the frozen `chooseEU` pin what
   makes this a boundary-sized change rather than a routing change?** That is
   information only the register holds.

The filer explicitly declines to propose a `batch: 0` escape hatch, recording
it only as the shape they would otherwise have asked for, because it would
contradict the availability-from-pricing law and the trampoline's termination
argument.

---

## I.3 F2 — L5 is a self-falsifying lint row (EXECUTED)

Full transcript with every command and output:
`chooseeu-sitting/f2-l5-transcript.txt`.

### The finding

`tools/prefreeze-lint.sh` at HEAD reports **4 FAIL, 0 WARN**. The #19 pack's
own verification item 8 records, *at these exact bytes*:

> Verification at the final bytes: prefreeze-lint **0 FAIL 1 WARN** with L10
> live ... the WARN is L5's nothing-to-check branch — this pack carries no
> SAT/overlay section because no oracle was cut, correct for a rulings sitting

`git diff HEAD` is empty for both `tools/prefreeze-lint.sh` and
`doctrine-author-pack.md`. **The tree has not moved.**

### The mechanism

L5 selects the current author pack from git history, then decides whether that
pack has a satisfiability/overlay section by a bare case-insensitive word
grep:

```
pack=$(git log -1 --pretty= --name-only -- '*author-pack.md' 2>/dev/null | head -1)
if [ -n "${pack:-}" ] && grep -qi "satisfiability\|overlay" "$pack"; then
```

The sentence recording the WARN **contains the trigger word**. So the row left
its correct nothing-to-check branch, entered the check branch, and failed all
four flag rows against a pack that correctly has no SAT section at all (`grep
-c` for each of the four `-W` flags returns **0**).

### The chronology, proven by git rather than argued

| commit | date | trigger hits in the pack | L5 branch |
|---|---|---|---|
| `8096c4b` (r1) | 2026-08-08 | **0** | WARN — *the recorded result* |
| `f79d7a4` (r2) | 2026-08-08 | **0** | WARN — *the recorded result* |
| `94fd4eb` (r3, HEAD) | 2026-08-08 | **1** | CHECK → **4 FAIL** |

The single hit is the r3 commit's own verification prose. **The commit's
record of its verification falsified the verification it records.**

### Why this is load-bearing right now

L5 greps whichever author pack was committed last. **This pack** documents the
defect, so this pack necessarily contains the trigger words — and being a
rulings pack with no oracle cut, it will fail the same four rows the moment it
is committed. *The act of reporting the bug reproduces the bug.* Per the
honest-incident discipline, that red is recorded here rather than dodged by
avoiding the words; the repair is what removes it, and the repair is the
author's key.

### The class, and its second occurrence in the same row

This is **L5's second hardening**. The first (`a371e17`, OB-28 iii) fixed pack
*selection* — `ls -t` by mtime, which in a fresh clone is checkout order,
replaced by "the last commit that touched an author pack names it." This one
is in pack *detection*, and it is the **same shape**: a property INFERRED from
an ambient signal where a DECLARATION was wanted. The repo's own doctrine
already names the cure — DECLARED STRUCTURE IS WORLD DATA — and the
one-generator law names the discipline.

### Three drafted repair shapes (the author chooses; none applied)

**(a) The declared marker.** Every author pack carries one line-anchored
marker, `^SAT-SECTION: none|present`, and L5 asserts it exists (a missing
marker FAILS — the declaration is enforced, not optional), then checks flags
only when it says `present`. Converts inference into declaration.
*Weakness: a pack quoting the marker as an example at column 0 re-triggers it —
the same disease one level up.*

**(b) The one-generator form — RECOMMENDED.** Derive both halves instead of
inferring either. SAT-bearing-ness comes from **the tree**: did the increment's
commit touch `test*/` or add a cabal stanza? The flag list comes from **the
cabal stanza itself**, read at lint time, rather than the four flags currently
hand-listed inside the lint — which kills a second latent bug in the same row,
since a stanza whose flags changed would leave that hand-list stale and silently
green. Prose can then say anything at all without moving the row.

**(c) Delimited scope.** L5 reads only a fenced, explicitly delimited section
of the pack. Cheapest; still keyword-triggered, so it narrows the surface
rather than removing the class.

The builder recommends **(b)**, with **(a)**'s marker as its declaration half
where a pack must override the tree-derived answer. Whichever is ruled, the kit
law applies: **the row arrives with its red demonstrated on both sides** — a
pack that should check and fails, and a pack that should not check and passes.

### It may fire a standing obligation

**OB-30** is `STANDING-CONDITIONAL` on the trigger *"a lintable form exists"*,
for REVIEWED PROSE NEVER REACHES A COMMAND THROUGH A SHELL-WORD PARSER. L5's
defect is reviewed prose reaching a **lint predicate** through a word parser —
the same disease with a different consumer.

And this round produced a **second, independent live instance**: generating F1's
transcript, the internal act's name written inside backticks in a double-quoted
shell string was **executed** (`/bin/bash: line 21: think: command not found`).
That is the readout r0 hang's exact shape, in a transcript generator rather
than a tag kit. Two consumers in one round is the generalisation OB-30 was
waiting for. Whether it satisfies the trigger is the author's call — register
question **R6**.

---

## I.4 F3 — the frozen-layer inventory (EXECUTED)

Per the FROZEN-LAYER INVENTORY clause: every boundary sitting receives an
inventory of frozen prose the increment's rulings or measurements have
falsified; repairs execute under that boundary's key, in the form the text
class demands, and **never as a standing licence**. Three rows, all DRAFTS.

### FL-1 — `membrane-wire.md` section 2, the `menu` bullet (FROZEN, manifest-covered)

This is #24's item (2), and it is substantiated. The bullet reads:

> selection runs through ONE standing policy sentence (the trampoline
> boundary): `Membrane.policyPick` expands the whole published menu into a
> single chooseKS tournament — every candidate's belief bound in one env, each
> option's utility reading **the option's OWN assignment by expansion** (the
> substitution semantics, pinned by trampoline g2.3 ...; ruling R4/OB-24) ...
> `Membrane.chooseEU` (Membrane.hs) is the binary special case, retained and
> pinned

A consumer plans against that. It describes `policyPick` as **the** selection
route, unconditionally, and demotes `chooseEU` to "the binary special case."
At HEAD a **clockless** world does not reach `policyPick` at all — it reaches
`chooseEU`, which does not substitute. The correction exists, but 27 lines
later (the bullet ends at line 95; the correction is at line 122), inside the
OPTIONAL `clock` bullet, as *"ABSENT means the shipped
selection, byte-identically"* — decodable only if the reader already knows
that "the shipped selection" means the non-substituting one. Nobody reading
about menus finds it.

**The builder's reading: this row is owed regardless of how the sitting rules
(1) or (3).** If the boundary is confirmed and the consumer waits, the doc is
what every other consumer plans against meanwhile; if the migration lands, the
sentence becomes true and the bracket becomes history. The filer's draft is
adequate: *"a clockless world selects through `chooseEU`, whose comparison does
not substitute."* Form: in-place at the `menu` bullet, falsified reading quoted
inside its own repair. Cf. issue #7.

### FL-2 — `CLAUDE.md`, the roadmap re-opening clause (FROZEN, manifest-covered)

The Porting order's last paragraph reads:

> The roadmap re-opens at the hosts boundary (HOSTS_PLAN, c65a386) ... each its
> own oracle-first freeze, each gated as **HOSTS_PLAN section 9 records**.

`HOSTS_PLAN` now lives at `archive/HOSTS_PLAN.md` and **opens by declaring
itself dead**:

> **[HISTORICAL from the wire boundary opening, 2026-07-20 — the engine this
> document describes was DEMOLISHED at the step-3 sentence freeze.]** This plan
> and its conformance surface ... **bind on nothing current**

So the protocol file routes the live roadmap through a self-declared-historical
document and names its section 9 as gating authority. The live roadmap is
`EXACT_PLAN.md` section 13.0, the destination map, installed verbatim from the
author's directive of 2026-07-26 *"so the roadmap lives in the tree, never in a
transcript"* — whose one remaining item is step 5, the demonstration tier,
after which "THE ROADMAP TERMINATES".

This is issue #7's disease recurring **inside the protocol file itself**, the
one document that cannot afford it. Form: in-place, falsified sentence quoted
inside the repair, pointing at the live map.

### FL-3 — `EXACT_PLAN.md`, the status header (NOT manifest-covered)

> *Builder-authored. Status: **PROPOSAL**. It opens nothing by itself ... until
> then it is unfrozen design material, like AGENT_PLAN / WIRE_PLAN / HOSTS_PLAN.*

EXACT_PLAN was executed — `exact-freeze-r0` / `r0a` / `r1` — and grew into the
live boundary record: section 12 the Phase-2 work order, 13 the trampoline
boundary and the destination map, 14 the completeness suite, 15 the wire
docket. It is the opposite of a proposal that opens nothing. Being outside the
manifest this is the cheapest of the three; it is listed because leaving it is
what let FL-2 sit unnoticed. Form: a dated supersession note, superseded words
kept.

---

## I.5 F4 — the five standing open issues, re-executed at HEAD (EXECUTED)

Full transcript: `chooseeu-sitting/f4-standing-issues-transcript.txt`.

### Why this row is not routine housekeeping

All five were disposed at ONE sitting, **2026-07-22**. The boundary audit's own
banked-failure row reports the alphabet last moved at `c2ca82c`, **2026-07-25**
— the exact re-founding, three days later, which took `prodTable` from 20/1 to
9/1, deleted four `said@1` forms, and installed the door. Two further
boundaries followed.

CLAUDE.md's canonized clause is explicit: **A BANKED COMPOSITION-FAILURE
EXPIRES WHEN THE ALPHABET MOVES** — a negative result is a HYPOTHESIS at any
later boundary whose terms changed underneath it, and must be RE-EXECUTED
before it is relied upon. No pack since — x5, exact, dyadic, trampoline, f5,
jp, battery, readout, breadth, doctrine — mentions #15, #16 or #17 at all.
**These five have been running on expired verdicts for five weeks.**

### #16 — the author's own posted comment is now FALSE, and is misinstructing

The comment posted 2026-07-22 told the filer:

> the wire now speaks **thirteen** forms (`/`, `log`, `exp`, `neg` landed at
> W4, `w4-freeze-r1` — your sweep predates it; **all four now ACCEPT**)

Executed at HEAD, one hello per form, everything else identical:

```
["/",["c",1.0],["c",2.0]]     -> {"error": "bad hello"}
["log",["c",2.0]]             -> {"error": "bad hello"}
["exp",["c",1.0]]             -> {"error": "bad hello"}
["neg",["c",1.0]]             -> {"error": "bad hello"}
["*",["get","act"],["var",1]] -> {"ok": true, ... "models": 9 ...}
```

All four **REFUSE**. They left the alphabet at the re-founding, three days
after the comment was posted. `membrane-wire.md` records the truth — "NINE
forms ... `/ log exp neg` FAIL CLOSED" — but **the issue thread does not**, and
the thread is what the consumer reads. A client that adopted those four on the
strength of that comment is broken at HEAD.

Note the irony precisely: that comment was itself a *correction* of the filer's
stale sweep. The expiry clause bit the author's own re-verification exactly as
it bit the filer's original.

**#16's literal claim SURVIVES** — no belief-scoped head parses; `["var",N]`
still closed to `N ∈ {0,1}`; all six candidates (`expect`, `cond`, `push`,
`argmax`, `var 2`, `var -1`) refuse. **Its operative conclusion does not.** Its
body enumerates three routes and closes "None of these exist today"; route (c)
was *"some other wire-level hook that changes how much computation the engine
spends per decision based on a declared value."* That is the trampoline `clock`
row, shipped 2026-07-27 — five days after the ruling.

Demonstrated, and demonstrated **properly**. The first attempt (utility
`act*y`, prices 0 and 5) did **not** fire the contrast: under `act*y` the acts
are not tied, and information that cannot change the choice has no decision
value, so no price makes deliberation worth buying. Per **R-RED** — a red is
CONSTRUCTED, never owed — the margin was computed and the crossing built: under
`act*(2y-1)` the acts tie exactly at p1 = 0.5, and sweeping the price gives

```
price 0.0, 0.1, 0.2, 0.21 -> {"internal": "think"}
price 0.22, 0.25, 1.0     -> {"act": {"act": 2}, ...}
```

**The crossing is between 0.21 and 0.22**, by bisection. A declared value
changes how much computation the engine spends per decision. Route (c) ships.

Also dissolved: the residue #16 was parked in ("host-wire integration: `choose`
still serves the wire") — `Host.hs` now records "the host fold is dead".

### #17 — still true at HEAD, verbatim; a re-confirmation, not a repair

```
{"observe_batch": [...]}   -> {"error": "expected tick"}
{"observe_counts": {...}}  -> {"error": "expected tick"}
```

Exactly as #17 reports and as #24 asserts in passing. Unshipped **by decision**
— the transport half was affirmatively declined ("bundling an unruled wire form
would be scope creep") and `membrane-wire.md` section 6.3 carries an honest
UNSHIPPED bracket naming the issue. One thing did move underneath it: the cost
model it argues from. `observe_counts` was justified by engine-dominant
per-tick cost measured on the pre-exact engine, and the re-founding changed the
enumeration wholesale — the decomposition #17 cites predates 2026-07-25. **F5
is the measurement that now speaks to it.**

### #11 — its disposition is already determined by an executed measurement, unposted

The 2026-07-22 ruling rested on a stated premise:

> the gate conditions on A's differential corpus ... and **that measurement
> does not exist**

**It was executed four days later.** 95k live events, both engines recorded,
94% grounded, read at the X.5 sitting (ruling 7) as *"A STAYS CLOSED (demand
not measured on 95k live events); B STAYS OUT (underpowered by measurement,
n_inv = 0)."* `OB-12` is `DISCHARGED`. The X.5 sitting further established that
B **cannot** be powered by running the shadow longer — verdicts exist only via
explicit `/feedback` calls, so powering B requires deploying a second verdict
source first, *"which is exactly the evidence shape B itself would model."*

The filer's own comment says the same from the demand side: *"14 verdicts total
in five weeks."* **None of this was ever posted to #11**, whose newest comment
still says the precondition does not exist. This is the most actionable row on
the docket and costs no engine work.

### #15 — a bookkeeping divergence

Its filer withdrew the engine-side ask on 2026-07-22 (*"we're treating #15's
engine-side ask as closed by this comment"*), the repo records it closed
(*"#15 closed the sitting's loop"*), and it is absent from the transport pack's
open-registers list — yet it is still OPEN on GitHub. Separately, every repro
recipe in its thread is now refused by the door. Nothing technical is owed.

### #14 / OB-15 — the solicited re-statement never arrived, and nobody re-asked

The ruling was SOLICIT. Forty days, no re-statement, no reminder. Meanwhile the
engine it was to be re-stated against moved three times, hardest at the
re-founding; the issue's own concession — *"the shape may dissolve on
translation"* — applies more strongly now than when written; and the roadmap
has demoted the target to post-terminal demand-gated residue. `OB-15` remains
the ledger's **only** `RULING-PENDING` row, blocked on an input nobody has
requested since 2026-07-22.

### The class this raises

The FL clause covers **frozen prose**. Nothing covers **published record** —
GitHub comments that were true when posted and are false now. #16 is the live
instance, and the failure mode is worse than a stale doc, because a consumer
reads the thread as the authoritative answer to their own question and the repo
has no sweep that ever looks there. Register question **R5**.

---

## I.6 F5 — bench: P2 was a reconstruction, and it was wrong in six ways (EXECUTED)

### The standing state

`bench/` holds a complete fold-depth cost measurement against this same HEAD:
7 sources, 68 result artifacts, its own green test suite, a 13-item deviations
register, an executed witness for its own speculative remedy, and a prepared
3-commit series. It is **blocked, not incomplete**, on one owner input — the
brief shipped with the acceptance band as literal blanks (`<= ____ ms`,
`alpha <= ____`). Its own last line is **STOP.** *"the seam-swap judgement is
the owner's, against the pre-stated band."*

It also names its own worst weakness, and this row executes it:

> P2 must be re-run at the owner's numbers ... before its alpha or its
> operating-point cost is read against the band

because the session was permitted exactly one life-agent file, and that file
carried merge orders rather than arities and grid widths.

### The real declaration, and how it was obtained

`~/git/life-agent` is reachable at `ebc5941` — a merge of the very
`r43-upstream-demand` branch that produced #24. The declaration was **not
hand-transcribed**. Per the ONE-GENERATOR LAW and the probe-discipline law (a
probe reads declared data and never re-declares a value it could import),
`bench/gen-p2real.py` imports the consumer's own `handshake_decl` and emits
`bench/P2Real.hs`. Regenerating is a standing identity row under the GENERATOR
EXEMPTION:

```
$ python3 bench/gen-p2real.py --check
IDENTITY OK  P2Real.hs regenerates byte-identical from life-agent @ ebc5941...
```

### What the reconstruction got wrong

| | `profileP2` (reconstruction) | **the real declaration** |
|---|---|---|
| namespace | 3 names | **19** |
| guard rows | 3 rows, mass G = 6 | **17 rows, every arity 1, G = 17** |
| menu | 3 options | **4 affordances** |
| `theta` | 9 **dyadic** sixteenths | **8 NON-dyadic decimals** |
| walk family (`rho`) | 4 points **declared** | **ABSENT — none at all** |
| `clock` | *no field existed in the harness* | **declared: `think`, price 11.0, batch 1** |
| population | 445 | **960** |

**The two levers the r01 report ranked highest both FLIP, one each way.** The
report named (a) dyadic-vs-decimal grid values, worth ~100x in bits per fold,
and (b) the walk family, 78% of P2's tick at t = 1000. The real world is
**decimal** — so lever (a) applies, where the reconstruction assumed it did
not — and declares **no walk family at all** — so lever (b) has no counterpart.
That is exactly why only a re-run settles it, and why neither the old number
nor a hand correction to it would have been honest.

### Three independent derivations of the population, all agreeing

The bench now carries an enumerator and refuses to trust it:

```
models = (K-1) * (n_theta + n_rho + G * n_theta * (n_theta - 1))
```

- derived in **Python** by the generator from the consumer's declaration → 960
- recomputed in **Haskell** by `predictedModels` from the profile → 960
- reported by the **engine** in its own hello reply → 960

The first two are checked against each other in `BenchTest` (t8); all three are
checked against the engine by a **population assertion the driver runs at every
cell start**, for every profile — so a profile that drifts from the declaration
it means to measure now dies loudly instead of writing a plausible number for
the wrong world. The assertion holds across the whole corpus (P1 9, P2 445,
P2nw 441, **P2real 960**, P3 130, P3wide 420, S1 9, S0 9), and the formula was
independently checked by hand against the shipped host on five points before
being written down.

### The measurement

Cells run **serialized**, one process at a time (wave R), never concurrent —
P2real is the most expensive profile in the corpus and r01 measured 7–9%
shallow-window inflation under sibling load.

**A load caveat, recorded because it is real.** The machine record for wave R
shows this box was carrying a competing `julia` process at ~97% of a core,
plus `clickhouse-server` and `mbsync`, loadavg ~4. Absolute ms/tick below is
therefore an **upper bound**, and the transferable quantities are the *ratio*
to the reconstruction (measured on the same box under comparable load) and the
growth exponent. This is recorded in the same spirit as r01's own loud-box
incident, not buried.

First window (ticks 1–100), median wall per tick, all three on this box:

| profile | population | median ms/tick | vs reconstruction |
|---|---|---|---|
| P1 minimal | 9 | 0.249 | — |
| **P2 (reconstruction)** | 445 | **56.0** | 1.0x |
| **P2real (the real world)** | 960 | **660.6** | **11.8x** |

**The reconstruction under-reported the consumer's real world by an order of
magnitude at the shallowest window measured.** Peak RSS 25.3 MB vs 13.8 MB.

### The growth curve

The T = 300 cell completed **300/300 ticks in 2078 s, no truncation**, giving
13 log-spaced windows:

| window centre (fold depth) | median ms/tick |
|---|---|
| 50.5 | 765 |
| 99.5 | 1 959 |
| 149.5 | 4 264 |
| 249.5 | **14 954** |

**The exponents come from `bench/analyze.py` — r01's own analyser, not a hand
fit** (the one-generator law; the builder's hand fit is discarded). It reports
three estimators, and they do not tell one story, so all three are given:

| profile | `alpha_raw` | `alpha_excess` | `alpha_3p` | `c0` | `a` |
|---|---|---|---|---|---|
| **P2real** | **1.840** | 3.349 | **2.440** | 510.6 ms | 1.98e-2 |
| P2realDy (dyadic) | **0.861** | 3.691 | 2.790 | 377.9 ms | 2.44e-4 |
| P2 (reconstruction) | 1.138 | 1.590 | **1.525** | 71.2 ms | 1.95e-2 |
| P1 | 1.470 | 1.657 | **1.595** | 0.29 ms | 1.20e-5 |

**Like-for-like on r01's headline estimator, `alpha_3p`: the real world is
2.440 against 1.525 for the reconstruction and 1.595 for P1** — steeper than
anything r01 measured, which was the claim and it holds.

**Where the estimators disagree, and it matters.** On `alpha_raw` the dyadic
world looks dramatically flatter (0.861 vs 1.840 — the "removes a power of `t`"
reading). On `alpha_3p` it looks *steeper* (2.790 vs 2.440). Both describe the
same measured curve: `alpha_3p` separates a constant, and the dyadic world's
cost is mostly **constant** (c0 = 378 ms) with a tiny growth coefficient
(`a` = 2.4e-4, **81x smaller** than the real world's 1.98e-2), whereas the real
world carries a large growing term. So the honest summary is *"the growth
coefficient falls by ~81x"*, not *"the exponent falls by one"* — the latter is
true only of `alpha_raw`.

**The claim that needs no estimator at all** is the measured ratio: at every
depth the dyadic world is cheaper, 1.9x at depth 50 rising to 9.6x at 250. That
is a direct reading, and it is what the A/B is for.

**Thinness, stated:** these are one seed and 11 windows over a 5x depth range,
where r01's own figures pool three seeds over depths to 39 000. The bootstrap
CIs above are degenerate for exactly that reason.

**No operating-point projection is stated.** The brief's operating point is
10^4 ticks; the measured region ends at 250. Extrapolating two orders of
magnitude past the data is exactly the class the canonized clause names
(AN UNWITNESSED ASSERTION OUTSIDE THE MEASURED REGION IS EXECUTED OR MARKED),
and the number such a fit produces here is visibly absurd — which is the
clause working, not a result. **What can be said honestly: the real world's
cost grows FASTER with fold depth than any profile r01 measured, and is
already at 15 s/tick at depth 250.**

### A cut, recorded rather than absorbed

The T = 1000 cell was **started and then CUT by the builder** in favour of the
dyadic A/B below, which answers a decision question where a longer lever arm on
alpha only refines one. Its partial CSV was removed rather than left as a
header-only file. The remaining planned cells — **route 2 at T = 100/300 (the
mirror's bit-level pin, so the real declaration has NO route-2 validation this
round) and a second seed at every depth** — were not run.

Stated plainly because the no-silent-caps law binds the sitting's own reporting
as much as a suite's. **Coverage bought this round: one profile plus its
counterfactual, one seed, depths 100 and 300, route 1 only.** The r01 protocol's
grid is three seeds, four depths and both routes; this is a slice of it, chosen
for the two decision questions in front of the sitting, and the alpha figures
inherit that thinness.

### The one declaration-side lever the consumer has left

Transcript: `chooseeu-sitting/f5-dyadic-lever.txt`.

The r01 report names its two levers as *"decision inputs, not language
changes"*. The real declaration shows **the consumer has already taken one and
not the other**: they declare no walk family at all (lever b, taken), and their
theta grid is decimal (lever a, untaken). So (a) is the only declaration-side
lever they have left, and nothing in the corpus measured it on their world.

Computed at the door's own embedding, their eight rungs cost **856 bits** of
exact numerator+denominator. Snapped to the nearest `n/2^k`:

| grid | bits | reduction | worst rung shift |
|---|---|---|---|
| as declared (decimal) | 856 | — | — |
| `2^-8` | 122 | 7.0x | 0.00168 |
| **`2^-10`** | **142** | **6.0x** | **0.00047** |
| `2^-12` | 184 | 4.7x | 0.00011 |

Two checks make `2^-10` safe on their own terms:

- **Their own tolerance.** Their frozen rule declares `_GRID_COLLISION = 5e-4`
  — two rungs closer than that are one. The worst `2^-10` shift, 0.00047, is
  inside it.
- **#19's placement finding.** The posterior concentrates on the declared rung
  KL-nearest the true rate, which can false-clear a threshold with an error
  that *sharpens* under data. The two rungs carrying that risk here sit 0.007
  apart — 0.857, the measured operating rate, and 0.864, the shadow p95 — and
  they stay **distinct** at `2^-8`, `2^-10` and `2^-12`.

So the lever is available without moving the KL-projection past the consumer's
own declared tolerance, and it needs no engine work, no wire change and no
ruling — it is a declaration.

**Status:** the bits arithmetic is EXECUTED; its cost consequence is ARGUED,
because rung denominator bits are not the same quantity as the folded state's
bits (though the r01 model makes the growth constant a function of exactly
these denominators). The falsifier is queued as a cell: `profileP2realDyadic`
is the real declaration with theta snapped to `2^-10` and **nothing else
changed**, derived from `profileP2real` by record update so it cannot drift.

### The A/B result — what the lever is actually worth

Transcript: `chooseeu-sitting/f5-ab-result.txt`. Two cells, run **serialized**,
same box, same recorded load, same seed and stream. Controlled: identical
population (960, both asserted against the engine's own reply), identical
namespace, guards, menu, clock and utility. **The only difference is theta's
binary representation.**

| fold depth | P2real ms/tick | dyadic ms/tick | speedup |
|---|---|---|---|
| 50 | 765 | 395 | 1.9x |
| 100 | 1 959 | 450 | 4.4x |
| 150 | 4 264 | 725 | 5.9x |
| **250** | **14 954** | **1 560** | **9.6x** |

| | P2real | dyadic |
|---|---|---|
| `alpha_raw` (analyser) | 1.840 | **0.861** |
| growth coefficient `a` (analyser) | 1.98e-2 | **2.44e-4** (81x smaller) |
| whole session (300 ticks) | 2 078 s | **275 s** (7.6x) |
| peak RSS | 58.1 MB | **26.3 MB** (2.2x) |

**The speedup is not a constant — it grows with fold depth**, 1.9x at depth 50
to 9.6x at depth 250. That ratio is a direct measurement and needs no fitting.

**On the mechanism, stated carefully.** Under `alpha_raw` the dyadic grid looks
like it removes a full power of `t` (1.840 → 0.861). Under `alpha_3p` it does
not — it looks slightly *steeper*. Both fit the same curve: the dyadic world's
cost is mostly a **constant** (c0 = 378 ms) with a growth coefficient **81x
smaller** than the real world's, where the real world carries a large growing
term. **The defensible statement is that the growth coefficient collapses, not
that the exponent drops by one** — and either way the consequence is the same
and is measured: the gap widens with depth, which is the regime the consumer
operates in and the regime the whole fold-depth question is about.

**What it costs them: nothing in the engine, nothing on the wire, no ruling.**
It is a declaration change, and the r01 report already classified this lever as
*"a decision input, not a language change"*. Both safety checks hold: every
rung moves less than their own declared `_GRID_COLLISION` of 5e-4, and the two
rungs carrying #19's placement risk stay distinct.

**Scope, stated rather than assumed.** This is a ratio at identical depths on
the same hardware, so the box load largely cancels here in a way it does not
for the absolute figures. Alpha is a two-point estimate over depths 50–250, one
seed, one profile; the 1.00 difference is clean but is not claimed as an exact
law, and its falsifier — a second seed and a deeper cell — was not run. And
nothing here reads a band: this says what the lever is worth, not whether the
result is good enough.

### A connection between F5 and F1 worth putting in front of the filer

#24 publishes the clock workaround's cost as **~2.2x per decide, structural**,
and is careful to say it *"is a real cost, not a blocker on its own"* — the
blocker they name is an unreadable measurement, not the price.

F5 measures something they do not appear to know: **their declared theta grid
is costing them more than the workaround does, and unlike the workaround the
gap grows.** The dyadic lever is worth 1.9x at fold depth 50 and **9.6x at
depth 250**, because it removes a full power of `t` rather than a constant
factor. At the depths a long session reaches, the workaround's 2.2x is the
second-order term.

This does not touch their complaint — an unreadable adoption bar stays
unreadable however fast the engine runs, and #24's ask is unaffected. It is
offered because it is a **declaration change they can make today**, needs no
ruling from this sitting, and is inside their own declared collision tolerance.
It belongs in whatever gets posted to #24 regardless of how R1 is ruled.

### An incident the identity row caught (recorded)

Transcript: `chooseeu-sitting/f5-provenance-incident.txt`.

The closing `python3 bench/gen-p2real.py --check` came back **red**:
life-agent's HEAD moved while this round was running (`ebc5941` → `6f28bf2`, a
merge landing GD-15 and doc changes), so the generated module no longer matched
its generator's output.

**Verified, not assumed, that the measurement stands:** `git diff` between the
two commits is **empty for `world.py` and empty for every `.py`** — the merge
touched only four markdown files — and the regenerated module is byte-identical
apart from the two provenance lines. The declaration the cells ran against is
unchanged; every figure stands; `P2Real.hs` has been regenerated and the row is
green.

**Why it earns a transcript.** The identity row did exactly what the GENERATOR
EXEMPTION gives it to do: a derived artifact drifted from its source and a
mechanical check caught it at the close, where a human reading the file would
have seen nothing wrong — the declaration *looked* right, and *was* right. Had
`world.py` actually moved, the identical red would have fired for a reason that
**did** invalidate the cells, and the two cases are indistinguishable without
running the diff.

**And a gap it exposes:** a cell's build stamp records *proplang*'s HEAD and
src-tree, not the consumer's. A consumer-side declaration change is invisible
in the stamp, so this identity row is the only thing between a moved
declaration and a measurement quietly attributed to the wrong world. If the
bench series lands, that argues for running `--check` inside the cell runner
rather than only at a close. Recorded as an observation; not proposed as a row.

### What is NOT done here, and will not be

**No acceptance judgement is made.** The band is still blank, and filling it is
the owner's act, not the builder's. This row makes the number *readable*; it
does not read it. The reconstruction's cells stay in the corpus unchanged
beside the real ones, so the delta is visible rather than overwritten.

### A harness defect found and fixed in passing

The r01 runner aborted **silently** on its first r02 invocation. Cause:
`machine()`'s `ps | grep | head` pipeline returns 141 under `set -o pipefail`
whenever `head` closes the pipe before `grep` finishes writing — a **race**, so
the wave died only sometimes, after writing the machine record, before the
first cell, with no error line in the log. It is a harness gate that fails
invisibly, which is the class OB-27's amendment names (a kit gate that cannot
fail is the same defect wearing the harness's coat). Fixed with `|| true` and
the reasoning recorded at the site. `bench/` is untracked and unfrozen, so this
is a builder-legal edit; it is reported here because the defect predates this
round and sits in work the owner has not yet committed.

---

## I.7 F6 — the opening audit (EXECUTED)

`chooseeu-sitting/opening-boundary-audit.txt` — **M5=0 H=0 OB=0 BF=0**, clean.
Note its banked-failure row: *"alphabet last moved at c2ca82c
(2026-07-25)"* — the date F4 turns on.

`chooseeu-sitting/opening-lint.txt` — **4 FAIL, 0 WARN**, all four F2's false
positives; L1/L2/L3/L4/L6/L7/L8/L9/L10 all PASS. `sha256sum -c
MANIFEST.sha256` passes 196/196. L4 reads 70 tags against the 68 recorded at
the sitting: `doctrine-sitting-r0` and `-r1` are the two new ones. Expected.

---

## I.8 F7 — the filer's sharpened question, ANSWERED (EXECUTED)

Full transcript: `chooseeu-sitting/f7-pin-scope-transcript.txt`.

#24's actual question is narrower and sharper than its ask:

> If the frozen `chooseEU` pin is what makes that a boundary-sized change
> rather than a routing change, **that is exactly the information we are
> missing.**

That is answerable from the frozen oracle, and the builder answered it.

**(1) The two functions have identical type signatures.** `chooseEU` and
`policyPick` are `Namespace -> Features -> Grid -> Expr '[Rational,
Rational] Rational -> [(Features, Belief Int)] -> Either String (Maybe
(Features, Belief Int))` — byte-identical apart from the name. The clockless
call site is one line:

```
              Nothing -> do
                picked <- chooseEU (swNs w) feats (swAtom w) u scored
```

**The migration is one identifier.** No new plumbing, no think row, no price.

**(2) g2 pins the functions, not the routing.** `test-trampoline/Trampoline.hs`
imports both and pins them against each other directly. It never routes, so a
routing change leaves every g2 row passing unchanged. And the pin's own scope
note already excludes the case at issue:

> The pin's SCOPE is the wire's utility convention ... A utility reading a
> WRITABLE name is a fold artifact under the shipped `chooseEU` ... — the
> finding, its demonstration, and the one-sentence route's repair are the
> boundary pack's register item, **not an oracle row**.

**(3) Nothing frozen pins the fork.** `grep -rn 'swClock' test*/ --include='*.hs'`
returns nothing.

**(4) The decisive sweep — could any frozen WIRE row change?** Universe derived,
not enumerated (the sweep-universe law): every test `.hs` declaring **both** a
menu and a utility, since only such a world can distinguish the routes. Four
files, five sentences. Exactly **two** read a writable name, and both are
immune for different reasons:

- `Trampoline.hs` `helloClock` reads writable `"move"` — but **declares a
  clock**, so it already routes through `policyPick`. The clockless arm cannot
  reach it. Its own comment carries the mandate-2 sitting flag saying every
  assertion is insensitive to the R4 ruling.
- `Breadth.hs` `helloB` reads writable `"skill"` and **is** clockless — but its
  menu is `"grid": [1]`, a **single point**. `chooseEU`'s fold is
  `foldl' step (Right c0) rest` with `rest` empty: no env is built and no
  comparison happens. The two routes are indistinguishable on one option.

Every other clockless wire row's utility reads only the outcome or a
non-writable feature — **exactly g2's pinned scope, where the two are
extensionally equal by the frozen pin itself.**

**The sweep tightens by one.** `Transport.hs` is in the universe but its frozen
`helloLine` is **refused** at HEAD (`{"error": "bad hello"}`) — it uses `neg`,
one of the four deleted forms, and declares no `codebooks.theta`, required
since the same boundary. Its world never reaches selection, so it cannot
distinguish the routes: the universe that could is **three**, not four.

The suite is green anyway, correctly, and for a reason worth recording: its
expectation is *derived* — `expectedReplies = snd (mapAccumL serveLine
hostStart requests)`, with the comment *"the frozen pure core itself, folded
over the same lines (R-D20 — never a hand-copied literal)"*. Subprocess and
library refuse identically, so the row passes and the suite keeps measuring
per-line delivery, which is what it exists for. **This is the one-generator law
paying for itself:** a hand-copied expected reply would have gone red at the
re-founding and sent someone hunting a transport bug that did not exist. The
world is a fossil of the pre-exact wire; harmless, and recorded as an
observation rather than a defect.

### The exact size of the change in `src/`

`policyPick` is **already imported** by `Host.hs`. `chooseEU` occurs four times
there and only **one is code**: line 26 a comment, line 58 the import, line 377
a comment, line 426 the call. So the migration is (a) one identifier at the
call site, (b) dropping `chooseEU` from the import list or `-Werror` flags an
unused import, (c) two stale comments this repo would not leave.

**And then `chooseEU` has zero `src` consumers** — while staying exported and
still pinned, since `test-pin`'s SELECTION row calls it by direct import and
`test-trampoline`'s g2 pins it against `policyPick`. It is not deleted; it
becomes an in-library function the frozen oracle pins and the host no longer
routes through.

**That disposition already has a precedent, one boundary old.** The #19
sitting's D3 ruled `pwLadderCap`/`Purchase.hs` FROZEN-IN-PLACE with its pins
dispositioned at the pin site, deletion **declined** because its proof was not
run and not claimed. Same shape, same reasoning, set by the sitting immediately
preceding this one.

### The reading

**The frozen `chooseEU` pin is not what makes un-deferring boundary-sized.**
No frozen wire row can change outcome under the re-route.

### The falsifier was run, and it did NOT come back clean

Transcript: `chooseeu-sitting/f7-gate5-prototype.txt`. The two-line change was
applied in a throwaway worktree and `cabal test all -j1` executed against it.

**Result: EXIT=1.** Twelve of thirteen suites pass; breadth passes 19 of 20.
**One row went red** — `drift-a`, an absolute timing band, measuring 1532.5 ms
against a frozen 431.1.

**The builder's stated expectation was falsified and is recorded as such.**
C24 predicted no frozen row could change under the re-route. A row went red.

**And the falsifier exposed a hole in F7's reasoning that is real regardless of
how this instance resolves.** The sweep above asked *can any frozen row's
OUTCOME change* and swept the corpus for utilities that could read a writable
name. **It never asked whether any row's COST could change.** `chooseEU` does a
pairwise fold; `policyPick` expands the whole published menu into a tournament.
On a multi-option menu those are extensionally equal (that is what g2 pins) but
not necessarily equally *fast* — and this repo has a frozen row that measures
speed. F7's universe was derived correctly for the question it asked, and the
question was too narrow. That is a defect in the analysis, not in the sweep.

**The control settled it: the red is environmental.** The same row was run on
the **unmodified** tree, same box, same load — and it **failed by more**:

| window | prototype | control (unmodified) | frozen |
|---|---|---|---|
| [6..30] | 1532.5 | **1562.8** | 431.1 |
| [250..280] | 5073.9 | 5000.9 | — |
| deep/shallow ratio | 2.1113 | 1.9110 | 2.0092 |

The unmodified tree is slower in three of five windows and faster in two, and
the frozen ratio 2.0092 sits **between** the two runs — two draws from one
distribution. **The prototype is exonerated: the two-line re-route did not
cause the red.** This was already visible inside the prototype run alone:

- `b6b` **passed** at ratio 1.366 against a bar of 2.0 — it is a *ratio* row,
  base against heir on the same box, and ratios are load-invariant where
  absolute bands are not.
- `b6b`'s own composition report shows **uniform** inflation: `ev` 247.6 vs
  frozen 66.2 (3.74x), `walks` 90.1 vs 23.8 (3.79x), `ev+ro` 1554.2 vs 434.5
  (3.58x), `wire` 3266.1 vs 832.7 (3.92x). **The decisive column is `ev`** —
  evidence folding, which the selection change cannot execute at all, inflated
  by the same factor as everything else.
- The box carried three processes near 100% CPU (julia plus two `dbt`) on four
  cores.
- This class has bitten the repo twice before and both are recorded.

**What the exoneration does NOT prove**, stated because a clean result invites
overreading: it does **not** show that `policyPick` costs the same as
`chooseEU`. It shows only that this red is not the change's. Under a load
inflating every column ~3.6x, the drift row has no power to detect a modest
cost difference either way. **The cost question F7's falsifier opened stays
open and unmeasured**, and what would close it is a quiet-box A/B of the two
routes at matched depth — not run.

**A standing observation for the sitting.** Gate 5 currently cannot pass on
this machine under its owner's ordinary workload, and that is a property of the
row's *form*, not of the tree. `drift-a` is an absolute band minted on a quiet
box; `b6b` is a ratio against a bar, and `b6b` passed in **both** runs. A ratio
cancels a uniform load factor; an absolute band cannot. The repo has now paid
for this three times — the `a2d35d9` loud-box incident, the #19 sitting's
contended probe, and today — and each time the diagnosis was right and the row
stayed absolute. Whether that is worth changing is the author's, and it is
raised as an observation, not a docket row.

**What this still does NOT establish:** that the kill matrix is unaffected
(OB-33 fires if this lands, R3); or that the change *should* be made.

---

## I.9 The roadmap, as it actually stands (EXECUTED against the record)

The live roadmap is `EXACT_PLAN.md` section 13.0, the destination map — not
`archive/HOSTS_PLAN.md`, which `CLAUDE.md` still points at (FL-2). Its five
steps:

| step | status |
|---|---|
| 1. the X.5 sitting | **CLOSED** (`x5-sitting-r0`) |
| 2. OB-12's differential run | **EXECUTED** — a measurement, not a boundary |
| 3. the trampoline boundary, *"the LAST language increment"* | **CLOSED** (`trampoline-freeze-r1`) |
| 4. the completeness suite | **CLOSED** (`battery-freeze-r0`) |
| 5. **the demonstration tier** | **the one item left** — *"AFTER 5 THE ROADMAP TERMINATES."* |

Step 5 has three named parts, and **this round moved two of them**:

- **"the A-gate reading with OB-12's result in hand."** The result is in hand
  and was read at the X.5 sitting: *A STAYS CLOSED, B STAYS OUT.* What is
  missing is not the reading but its **posting** — F4's #11 row. Arguably this
  part is complete and simply unrecorded where its consumer can see it.
- **"the benchmark."** `bench/` is that benchmark. Before this round its
  representative profile was a reconstruction wrong in six structural ways;
  F5 replaced it with the consumer's own declaration, added three-way-checked
  population assertions across the corpus, and measured the real world for the
  first time. It remains blocked on one owner input — the acceptance band.
- **"the paper."** Not started, and nothing in this round touches it.

**So the honest roadmap statement is:** the language is finished, four of five
destination steps are closed, and the fifth is one posting, one blank band, and
a paper away from terminating. That is worth saying plainly at this sitting,
because it also frames R1: **if the roadmap terminates after step 5, then
"name the boundary" (R1 option 1) needs to name a boundary that will actually
exist** — or say that none will, which is a different answer and an honest one.

---

## I.10 The register — the sitting's questions, with the builder's drafted defaults

*Defaults are the builder's reading, not rulings. Each is a default because it
is what the record already implies; each is overridable, and where the builder
has low confidence that is said.*

### R1 — OB-24's boundary. **The question #24 was filed to ask.**

`OB-24` is `RULED@trampoline-freeze`: *"chooseEU keeps its shipped fold this
increment and migrates, with its own pin row, only at a named boundary."* No
boundary has been named in the five weeks since, and **none of the six
boundaries that have closed since claimed it** — f5, jp, battery, readout,
breadth, doctrine.

**The filer's sharpened form of the question:** *is the frozen `chooseEU` pin
what makes routing clockless worlds through `policyPick` a boundary-sized
change rather than a routing change?* That is answerable from the frozen
oracle, and **F7 answers it: no.** The pin is not the obstacle — `chooseEU` and
`policyPick` have identical signatures, the call site is one identifier, g2
pins the functions rather than the routing, nothing frozen pins the fork, and
every frozen row's OUTCOME survives the re-route (12/13 suites green, breadth
19/20 on an executed prototype).

**The falsifier was run and controlled.** Gate 5 on the prototype returned
EXIT=1 on one row — `drift-a`, an absolute *timing* band. The same row on the
**unmodified** tree, same box, same load, **failed by more** (1562.8 vs
1532.5 ms). **The red is environmental and the change is exonerated.**

**But the falsifier opened a question F7 had not asked, and that question
stands.** F7 swept for outcome changes and never asked whether any frozen row's
**cost** could change; `policyPick` expands the whole menu into a tournament
where `chooseEU` folds pairwise. The control proves this red was not the
change; it does **not** prove the two routes cost the same, and under a load
inflating every column ~3.6x the drift row could not have detected a modest
difference either way. **The pin question is answered; a cost question is open
and unmeasured**, and the sitting should rule knowing both. The measurement
that would close it — a quiet-box A/B of the two routes at matched depth — is
cheap, and the builder recommends it before any ruling on option (3).

**Drafted default: (1) — NAME THE BOUNDARY — but held only weakly, and F7
weakens it further.** The case for (1): the roadmap has one item left and
terminates after it; #24 is explicitly content with this answer; the consumer
is not in production and has a working, priced workaround. The case against,
which the builder finds substantial: **naming a boundary that the terminus
clause may never open is not naming a boundary — it is a deferral wearing a
name**, and that is what the last five weeks already were. If no boundary is
actually scheduled, the honest answers are to say so plainly, or to take (3),
whose measured cost F7 has now bounded. The builder does not hold a confident
default here and says so rather than manufacturing one.

### R2 — FL-1, independent of R1.

**Drafted default: REPAIR, whatever R1 rules.** The `menu` bullet is what every
consumer plans against, the correction is one sentence, and #24 documents a
checkpoint lost to exactly this. In-place, falsified reading quoted inside its
own repair.

### R3 — does un-deferring (R1 option 3) move the alphabet?

Bears on two standing rows. **OB-16** is `STANDING-CONDITIONAL` and its
condition *"RESETS for the next motion"*; **OB-33** fires on *"the next
increment that runs a kill matrix"*, and carries the four missing mutant
classes plus re-triage of the seven unreached breadth rows.

**Drafted default: NO — a routing change is not an alphabet motion** (no
production added or removed; `prodTable` unmoved). But it IS a kill-matrix
increment if it lands, so **OB-33 fires on option (3) and not on option (1)**.
Confidence moderate; the author's reading governs.

**And a row option (3) would owe that this round surfaced:** if `policyPick` is
measurably slower than `chooseEU` on the clockless path, the drift row's frozen
band is a LICENSED RE-MINT question, not a pass/fail — the breadth suite
already carries that concept explicitly (*"a composition change is a LICENSED
RE-MINT, never a breadth failure"*). Whether the re-route is such a change is
measurable and unmeasured; the control now running settles only whether THIS
red was load.

### R4 — the L5 repair shape (F2). Three drafts in I.3.

**Drafted default: (b), the one-generator form** — derive SAT-bearing-ness from
the tree and the flag list from the cabal stanza, with (a)'s declared marker as
the override. It removes the class rather than narrowing it, and kills a second
latent bug (the hand-listed four flags going stale against a changed stanza) in
the same edit. Two-sided demo owed at install per the kit law.

**This row is close-blocking in a way the others are not:** this pack trips L5
by existing. Whatever is ruled, the sitting cannot close green without it.

### R5 — does the FL inventory extend to PUBLISHED RECORD? (F4)

The FL clause covers frozen prose. #16 carries a posted author comment that was
true when written and is false now, and it is actively instructing a consumer
to use four forms the wire refuses. Nothing in the protocol ever looks at issue
threads.

**Drafted default: YES, as a narrow standing row** — at every boundary, any
issue thread carrying an executed claim about the shipped surface is re-read
against HEAD, and falsified claims are corrected **in the thread**, since the
thread is where the consumer reads. Scriptable half: flag open issues whose
newest comment predates the last alphabet motion (mechanical, triage-only,
never a verdict — the M5/H pattern). Confidence moderate on the standing half;
**high that #16 and #11 need posting now**, which needs no new clause.

### R6 — does F2 plus the backtick incident satisfy OB-30's trigger?

**OB-30** is `STANDING-CONDITIONAL` on *"a lintable form exists"* for REVIEWED
PROSE NEVER REACHES A COMMAND THROUGH A SHELL-WORD PARSER. This round produced
two live instances in two different consumers: L5 (prose reaching a lint
predicate through a word grep) and the transcript generator (prose reaching
`bash` through a backtick, executed). The tag-message instance is already canon;
these generalise it past tag kits.

**Drafted default: PARTIALLY — mint the lint for the L5 class under R4 and
record these as OB-30's second and third instances, but do NOT discharge
OB-30.** The general principle still lacks a general lint; what exists is one
more specific one. Discharging on a specific instance is how the row would be
forgotten, which is what it was minted to prevent.

### R7 — the four standing-issue dispositions.

**Drafted defaults, each a posting, none an engine change:**

- **#11** — post OB-12's executed reading (A closed, B out, n_inv = 0, and B
  cannot be powered by running longer) and dispose. *The record already decided
  this; only the posting is missing.* Highest value per unit cost on the docket.
- **#16** — post the correction-of-the-correction (nine forms, not thirteen;
  those four refuse), re-dispose against the shipped clock row (route (c)
  ships; the literal claim survives), and note the residue it was parked in is
  dissolved.
- **#15** — close, citing the filer's own withdrawal and the repo's record.
- **#17** — confirm still-true; keep open as the `observe_counts` demand gate's
  standing entry, with the note that its cost argument now has F5's measurement
  to be re-read against.
- **#14 / OB-15** — either re-solicit the re-statement against the *current*
  engine (naming the re-founding as what changed) or dispose it into
  post-terminal residue. **Builder declines a default**: this is a demand
  judgement, and the row has sat 40 days precisely because nobody made it.

### R8 — bench: is F5 enough to unblock, and does the series land?

The band is still blank. F5 makes P2's number readable at the real declaration;
it does not read it.

**Drafted default: land the prepared series plus the r02 additions as record,
band still explicitly unfilled, no acceptance judgement.** The A/B strengthens
this: the bench has now produced a finding a consumer can act on without any
ruling, which is what a benchmark is for. The measurement is
green, self-consistent and now carries three-way-checked population assertions;
leaving it untracked is the larger risk. **Whether the band gets filled is a
separate act and remains the owner's.** If the bench is ever to ride gate 5, a
`bench` stanza must be spliced into the manifest-frozen `proplang.cabal` at a
boundary under the author's key — not proposed here.

### R9 — is this sitting a roadmap boundary?

If yes, the six red-team mandates fire (fresh-context reviewers, one mandate
each) and the boundary audit is a standing event (already run, clean).

**Drafted default: NO for r1, YES if R1 rules option (3).** An opening round
that touches nothing frozen is not a boundary; an increment that re-routes
selection is. The mandates would then ride the close, not this round.

---

## I.11 The claims register (live, per the canonized gate)

*Every claim this pack makes about the shipped surface, tagged EXECUTED (with
its transcript), ARGUED (with its cheapest falsifier NAMED), or QUOTED (whose
words). An unwitnessed assertion outside the measured region is executed or
marked. This register rides BESIDE the under-determination register (I.12) and
does not replace it.*

| # | claim | tag | witness / falsifier |
|---|---|---|---|
| C1 | A clockless world returns the menu head; the same world with a clock row returns the declared argmax; `models: 25`. | **EXECUTED** | `f1-issue24-transcript.txt`, both arms, this HEAD |
| C2 | `batch: 0` is refused `bad hello`, so the preposterior is not opt-out-able. | **EXECUTED** | same transcript |
| C3 | `chooseEU`'s `step` builds one env from the challenger and evaluates both `Expect` terms in it. | **QUOTED** | `src/PropLang/Membrane.hs` @ `94fd4eb`, binding `chooseEU`, quoted byte-wise |
| C4 | `Host.hs` routes clockless → `chooseEU`, clocked → `thinkValue`/`pickWire`. | **QUOTED** | `src/PropLang/Host.hs` @ `94fd4eb`, binding `actOrThink`, quoted byte-wise |
| C5 | The consumer's 297 ms vs 135 ms (~2.2x) figure. | **QUOTED** | the filer's, from #24 and life-agent's r44; **NOT re-executed here** — falsifier: re-run both arms on the 960-model world on a quiet box |
| C6 | The lint reports 4 FAIL at HEAD where the #19 pack records 0 FAIL 1 WARN, tree unmoved. | **EXECUTED** | `opening-lint.txt` + `f2-l5-transcript.txt` (a) |
| C7 | The trigger word has 0 hits at r1/r2 and 1 at r3, and that hit is the sitting's own verification prose. | **EXECUTED** | `f2-l5-transcript.txt` (d)(e) — proven by git across three commits |
| C8 | The doctrine pack contains no SAT section: zero occurrences of each of the four `-W` flags. | **EXECUTED** | `f2-l5-transcript.txt` (f) |
| C9 | This pack will itself trip L5 once committed. | **ARGUED** | falsifier: commit it and re-run the lint — it becomes EXECUTED at the close, and is expected to FAIL until R4 lands |
| C10 | `/`, `log`, `exp`, `neg` all refuse at HEAD; the four W4 forms left the alphabet. | **EXECUTED** | `f4-standing-issues-transcript.txt`, #16 sweep |
| C11 | All six belief-scoped candidates still refuse; `["var",N]` closed to N∈{0,1}. | **EXECUTED** | same sweep, 6 rows |
| C12 | A declared clock price changes how much computation the engine spends per decision; the crossing is between 0.21 and 0.22 on the constructed world. | **EXECUTED** | same transcript, ATTEMPT 2 — margin computed, crossing constructed per R-RED, first attempt's non-firing recorded |
| C13 | `observe_batch` / `observe_counts` both refuse `expected tick`. | **EXECUTED** | same transcript, #17 section |
| C14 | The consumer's real declaration is 19 names / 17 guards / 4 affordances / 8 non-dyadic theta / no rho / a clock row / 960 models. | **EXECUTED** | `bench/gen-p2real.py` reads life-agent's own `handshake_decl`; `--check` identity row; engine's hello reply reads 960 |
| C15 | The population enumerator `(K-1)(n_th + n_rho + G·n_th·(n_th−1))` holds. | **EXECUTED** | hand-checked on 5 points against the shipped host, then asserted for all 8 profiles by `BenchTest` t8 and by the driver at every cell start |
| C16 | P2real is 660.6 ms/tick vs the reconstruction's 56.0 at ticks 1–100 (11.8x). | **EXECUTED** | `bench/results/P2real-T100-s1-route1.csv` vs `P2-T100-s1-route1.csv` — **load caveat recorded**: competing `julia` at ~97% of a core, so absolutes are an upper bound |
| C17 | The two levers r01 ranked highest both flip direction on the real declaration. | **EXECUTED** for both declaration halves and for lever (a)'s cost consequence; **ARGUED** for lever (b)'s | declaration halves read off the generator (decimal theta; no rho). Lever (a)'s cost measured by the A/B (C27). Lever (b)'s cost consequence is NOT measured — no counterfactual adding a walk family to the real world was run; falsifier named: a `P2real+rho` cell against `P2real` at equal ticks |
| C18 | The r01 runner aborts silently on a `pipefail` race in `machine()`. | **EXECUTED** | observed live: wave died after the machine record with no log line; fixed and relaunched, cells now running |
| C19 | No pack after 2026-07-22 mentions #15, #16 or #17. | **EXECUTED** | `git grep -lE '#1[567]\b' -- '*-author-pack.md'` returns **nothing**; per-pack counts are 0 for x5, exact, dyadic, trampoline, readout, breadth and doctrine |
| C20 | OB-12 is DISCHARGED and its executed reading was never posted to #11. | **QUOTED** | `OBLIGATIONS.md` row; `x5-author-pack.md` Track 2 and ruling 7; #11's comment list ends 2026-07-22 |
| C21 | `chooseEU` and `policyPick` have identical type signatures; the clockless call site is one identifier. | **QUOTED** | `src/PropLang/Membrane.hs` @ `94fd4eb`, both signatures; `src/PropLang/Host.hs` @ `94fd4eb`, binding `actOrThink` — quoted byte-wise |
| C22 | g2 pins the two functions against each other by direct import and never routes; its scope note excludes writable-name utilities. | **QUOTED** | `test-trampoline/Trampoline.hs` @ `94fd4eb`, the `g2` group and its preceding scope comment |
| C23 | No frozen oracle references the clockless routing fork. | **EXECUTED** | `grep -rn 'swClock' test*/ --include='*.hs'` returns nothing |
| C24 | No frozen wire row can change outcome under the re-route. | **EXECUTED for OUTCOMES** — every semantic row passed (12/13 suites, breadth 19/20), and the one red is **proven environmental** by control. **The claim as originally worded was still too broad**: it did not cover COST | falsifier RUN and CONTROLLED (`f7-gate5-prototype.txt`): prototype `drift-a` 1532.5 ms; **unmodified tree, same box, same load: 1562.8 ms — fails by more**. Frozen ratio 2.0092 sits between the two runs. Cost parity of the two routes remains **unmeasured**; falsifier named: a quiet-box A/B at matched depth |
| C25 | The consumer's 8 theta rungs cost 856 bits as embedded; a `2^-10` grid costs 142 (6.0x fewer) with worst shift 0.00047. | **EXECUTED** | `f5-dyadic-lever.txt`, exact `Fraction` arithmetic over the generated grid |
| C26 | `2^-10` keeps 0.857 and 0.864 distinct and shifts no rung past the consumer's own `_GRID_COLLISION = 5e-4`. | **EXECUTED** | same transcript, both checks |
| C27 | Taking the dyadic lever reduces per-tick cost by a factor that GROWS with fold depth — 1.9x at depth 50 to 9.6x at 250 — via an ~81x collapse in the growth coefficient. | **EXECUTED** (upgraded from ARGUED; the queued falsifier was run). The mechanism wording was CORRECTED: 'removes a power of t' holds only under `alpha_raw`, not `alpha_3p` | `f5-ab-result.txt` plus `bench/analyze.py`'s own estimators; the two cells serialized, controlled to identical population and stream |
| C28 | The T=300 cell completed 300/300 with no truncation; median cost rises 765 ms → 14 954 ms between fold depths 50 and 250, a two-point alpha of 1.86 — steeper than r01's 1.43–1.60 on every synthetic profile. | **EXECUTED** | `bench/results/P2real-T300-s1-route1.csv`, 13 windows |
| C29 | No operating-point cost is projected for the real world. | **DECLINED, deliberately** | the measured region ends at depth 250 and the brief's operating point is 10^4 — a two-order extrapolation. Marked rather than stated, per the unwitnessed-assertion clause |
| C30 | The dyadic counterfactual is a controlled A/B: identical population (960), identical namespace, guards, menu, clock and utility; only theta's binary representation differs. | **EXECUTED** | both cells' `hello` and `models-assert=OK predicted=960` lines; grids `[1.953125e-2, ...]` vs `[2.0e-2, ...]` |
| C31 | `test-transport`'s frozen `helloLine` is refused at HEAD (deleted `neg` form; no required `codebooks.theta`), and the suite is green anyway because its expectation is derived from the pure core rather than hand-copied. | **EXECUTED** | the hello run against the shipped host; `Transport.hs`'s `expectedReplies` binding quoted |
| C32 | life-agent's HEAD moved mid-round (`ebc5941` → `6f28bf2`) and the identity row caught it; the declaration is unchanged, so every measured figure stands. | **EXECUTED** | `f5-provenance-incident.txt`: `git diff` empty for `world.py` and for every `.py`; generated module byte-identical apart from two provenance lines |

**Scope note (a strengthening is a new claim).** Where this pack extends an
author's or a consumer's argument, the extension is the builder's and is marked
as such: C9, C17's cost half, and every "drafted default" in I.10 are the
builder's readings, not the record's — C24's negative and F7's conclusion above all.

---

## I.12 The under-determination register

1. **Whether naming a boundary that the terminus clause may never open counts
   as naming one.** R1's default assumes it does. The builder is not confident.
2. **Whether the frozen `chooseEU` pin blocks a routing change.** The filer
   asks this directly; it is a reading of the frozen oracle and the builder
   does not own it.
3. **#14's demand judgement.** Deliberately no default (R7).
4. **The r02 growth exponent and operating point.** Cells running; the
   addendum lands them. Nothing in this pack reads a band.
5. **Whether F5's ratio survives a quiet box.** The 11.8x is measured under
   recorded load on both sides; the builder expects it to survive (an order of
   magnitude against a 7–9% effect) but has not executed it.

---

## I.13 Custody, and what this round did NOT do

**Nothing frozen was touched.** No file under `test/`, `audit/`, no
`CLAUDE.md`, no `MANIFEST.sha256`, no manifest-covered file — `membrane-wire.md`,
`OBLIGATIONS.md`, `tools/prefreeze-lint.sh` all unmodified. `sha256sum -c
MANIFEST.sha256` passes 196/196 at these bytes. No obligation minted, no ledger
row flipped, no ruling taken, no tag minted, nothing posted to any issue.

Written this round, all new or untracked-and-unfrozen:

- `chooseeu-author-pack.md` (this file) and `chooseeu-sitting/*.txt`
- `bench/gen-p2real.py`, `bench/P2Real.hs` (generated), and additions to
  `bench/BenchLib.hs`, `bench/BenchFoldDepth.hs`, `bench/BenchTest.hs`,
  `bench/run-cells.sh`, plus new `bench/results/P2real-*.csv`

The three FL repairs, the L5 repair, and every issue posting ride as DRAFTS for
the author's key. **The sitting is the author's.**

---

# ADDENDUM r1a — two findings that postdate the pack's own sweep

*Written after the pack was conferred to pixel-9a. Both items are new
evidence, not re-readings: F8 arrived on a branch pushed after the r1 sweep
ran, and F9 is the measurement R1 named as missing. **F8 REVERSES a drafted
default in I.10 R7** — that is the reason this addendum exists rather than
riding to the next round.*

## I.14 F8 — the consumer pre-registered a dependency on #15 while this sitting was open (EXECUTED)

The author's standing instruction to keep the sibling repos current is what
surfaced this: `~/git/life-agent` on the measurement box was **50 commits
behind** `origin/master`, and fetching brought down a branch that did not
exist when I.5 swept the issue record.

**`origin/r45-evidence-path`** (`99fa6c7`, one file, 104 lines,
`docs/unification/reports/r45-evidence-path.md`), titled *"r45
pre-registration — the evidence path and P1: options, ten criteria and three
branches, frozen before any probe"*. Its owner scope ruling is dated
**2026-09-01** — the same day #24 was filed and the same day this sitting
opened.

### What it says that bears on this docket

**(i) It pre-registers a dependency on #15 being OPEN.** Consequence branch 2,
quoted verbatim:

> **No option preserves the recorded act** → item 3 is an **engine** blocker,
> not a declaration one. P1 accrues **live-only**: no historical backfill, the
> gap is a boundary, and the historical stream is published as **unfoldable on
> this wire**. Cite upstream **#15**, which is the engine-side twin and is
> already OPEN — **file nothing new** (`M-23`).

**The citation is accurate.** #15 is `OPEN`, titled *"wire: no mechanism for
action-conditional outcome hypotheses (writable names cannot be
guarded/evidenced)"*, last touched 2026-07-22. And its subject is real at
HEAD — **verified in this repo, not taken from the consumer**:

```
src/PropLang/Host.hs @ 94fd4eb, binding `tick`, lines 397-399:
      if any ((`elem` writable) . fst) feats
        then Left "feature/assignment collision"
        else do
```

A writable (menu) name may never appear in a tick's features. So a replay
cannot supply a *recorded* act as a feature; it must come through the menu,
and then **the engine picks the act the fold conditions on**. That is exactly
what #15 names.

**THIS REVERSES R7's DRAFTED DEFAULT FOR #15.** The pack drafted *"close,
citing the filer's own withdrawal and the repo's record."* That default rested
on a withdrawal dated 2026-07-22. **The withdrawal is superseded by demand
dated 2026-09-01**, and the consumer has explicitly declined to file a
replacement *because #15 is open*. Closing it would delete the engine-side
record their branch 2 points at and would invite the duplicate issue `M-23`
exists to prevent.

**Corrected default: #15 STAYS OPEN.** The useful act is not a close but a
comment recording that the 2026-07-22 withdrawal is superseded, that the
collision guard is confirmed live at `94fd4eb` with its file-and-binding
anchor, and that the issue is now the engine-side entry for r45's item 3.

**Where the pack was wrong, and why:** I.5 read the issue *thread* and the
repo's own record, and both said withdrawn. Neither could see a branch pushed
afterwards. This is the published-record inventory problem of R5 with the
arrow reversed — R5 asks whether *our* published claims go stale; F8 shows the
*consumer's* record moves too, and a disposition drafted against a thread is
drafted against a snapshot. **A cheap scriptable half exists**: before
disposing any issue, fetch the filer's repo and diff its branch list. It cost
one `git fetch` here and it overturned a close.

**(ii) It schedules the grid-precision lever this pack measured.** Carried to
r46: *"the `act` guard row (r43: `models` 2393 → 2681, **not** free on the
control) and `GD-15`'s grid precision, each with its own bar and its own
reading."*

`GD-15`'s grid precision **is F5's dyadic lever** (I.6, claims C25/C26). The
consumer has it scheduled and, by their own words, unread — *"none has been
read."* This pack already carries the measurement: their 8 theta rungs cost
**856 bits as embedded, 142 at `2^-10` (6.0x fewer)**, worst rung shift
0.00047, inside their own declared `_GRID_COLLISION = 5e-4`, and the two rungs
that matter for #19's placement finding (0.857, 0.864) stay distinct. **This is
deliverable to them today and needs no ruling from anyone** — it is a
measurement of their declaration against our engine, which is what the bench
is for.

**Convention, which must ride with the figure if it is posted:** "856 bits"
is this repo's `qbits` — *numerator plus denominator* bits — the convention
pinned by the frozen row `t3 qbits 3/8 = 2 + 4`. Re-derived independently
from `bench/P2Real.hs` at this addendum: **856 embedded → 142 at `2^-10`,
6.0x**, reproducing C25 exactly. Counting denominator bits alone (a natural
misreading) gives 438 → 81, **5.4x** — same conclusion, different number. A
consumer handed the bare figure without the convention cannot reproduce it.

**(iii) Scope they declare, which bounds what this sitting must anticipate:**
*"The declaration is not touched here — no change to `world.handshake_decl`.
That is r46"*, and *"The proplang repo is read and executed, never written,
and no new upstream issue is filed."* So **#24 remains the live demand**; no
second one is coming this round.

**(iv) An engine-side reading worth the author's eye.** Their option 2 —
folding on the engine's chosen act rather than the recorded one — they name
*"a corruption, to be named as one and priced, not measured around"*, and
gate at `C3` (≥95% match on ≥100 replayed rows). That is a consumer holding
*our* semantics to a bar we never stated. It is not a defect report and they
have not filed it as one, but it is the sharpest external statement of what
#15 costs that exists, and it postdates every ruling in the record.

## I.15 F9 — the A/B R1 asked for: the two selection routes cost the same (EXECUTED)

I.8's falsifier left one question open and named it: F7 swept for **outcome**
changes and never asked whether any frozen row's **cost** could change, since
`policyPick` builds a whole-menu tournament where `chooseEU` folds pairwise.
That question is now measured.

**Why it could not be measured on thinkpad:** load average 5.2 with `julia`
and a `python` both pinned near 100%, `powersave` governor. The author offered
**steel**, and it is the better instrument by every axis that matters:

| | thinkpad | steel |
|---|---|---|
| CPU | i5-10210U @ 1.60GHz | Ryzen 5 5600X |
| governor | **powersave** | **performance** |
| load at run | **5.24** | **0.02 – 0.35** |
| GHC / cabal | 9.10.3 / 3.16.1.0 | **9.10.3 / 3.16.1.0 (identical)** |

Toolchain parity is exact, so codegen is not a confound. And the engine's
**semantics** are box-independent by measurement, not assumption: `BenchTest`
passes all rows on steel including the four `t5c` exact-equality pins
(`mirror normalized meta == engine metaPosterior`, `Rational ==`). Only timing
differs between boxes.

### The world: the consumer's real declaration, clock removed

P2real as declared **carries a clock row** and therefore routes through
`thinkValue`/`pickWire` — it never takes the path in question and cannot
measure it. `profileP2realNoClock` is P2real with `pClock = Nothing` and
nothing else changed: **#24's exact situation**, a consumer who declines the
preposterior (and `{"batch": 0}` is refused `bad hello`, so declining is the
only option) and is routed to the non-substituting fold. Population **960**,
asserted against the engine's own hello reply.

### The arms, and a change-size claim the compiler now enforces

| arm | tree | selection verb | `src-dirty` |
|---|---|---|---|
| **A** | `~/git/proplang` clean | `chooseEU` | **0** |
| **B** | prototype worktree | `policyPick` | **1** |

The stamp runs `git` in the CWD, so each arm runs from its own tree and every
B cell **self-announces as dirty** in its own header.

**The total prototype diff is 2 lines in 1 file** — and the second line is not
optional. I.8 claimed the change was "one identifier plus one import-list
entry"; that is now *mechanically enforced*, because dropping `chooseEU`'s
call site makes its import redundant and `-Werror` refuses to build:

```
src/PropLang/Host.hs:58:27: error: [GHC-38856] [-Wunused-imports, Werror=unused-imports]
    The import of `chooseEU' from module `PropLang.Membrane' is redundant
```

### The result

Four reps per arm, **alternating A/B/A/B** so drift falls on both equally,
T100, seed 1:

| metric | A (`chooseEU`) | B (`policyPick`) | B/A |
|---|---|---|---|
| wall, mean of medians | **169.065 ms** (sd 0.578) | **169.391 ms** (sd 0.497) | **1.00193** (+0.19%) |
| cpu, mean of medians | **168.616 ms** (sd 0.583) | **168.948 ms** (sd 0.494) | **1.00197** (+0.20%) |

**Within-arm spread is 0.79% (A) and 0.67% (B) — larger than the 0.19%
between-arm difference, which is smaller than two standard errors.** The two
routes are **indistinguishable in cost** on the consumer's real world.

**R1's open cost question is answered: re-routing clockless selection through
`policyPick` is not a cost regression, and the drift row's band is not put at
risk by it.** Combined with I.8 (outcomes unchanged, pin not the obstacle),
**no measured obstacle to option (3) remains.** The ruling is still the
author's; the objection I raised against my own default is discharged.

### Scope, and the falsifier still running

**The width-4 result does not generalise, and the sweep proves it.** A
pairwise fold and a whole-menu tournament are both O(menu); width is the axis
on which they diverge, and width 4 is too narrow to separate them. Per
**R-RED** a red is constructed rather than owed, so the sweep was built:
widths 4/8/16/32, population held at **960 at every width** (asserted against
the engine's own hello reply — the menu is the action space, not the
hypothesis space), so every difference below is SELECTION cost.

| menu width | A `chooseEU` median | B `policyPick` median | **B/A** | B/A by total wall |
|---|---|---|---|---|
| 4 (the consumer's real count) | 167.84 ms | 168.31 ms | **1.003** | 1.000 |
| 8 | 265.14 ms | 274.02 ms | **1.034** | 1.036 |
| 16 | 458.88 ms | **2876.98 ms** | **6.27** | 6.29 |
| 32 | 847.67 ms | **UNREACHED** | — | — |

**This is a CLIFF, not a slope.** Between widths 8 and 16 the ratio moves from
1.03 to 6.27 while arm A grows smoothly (1.73x for the same doubling). Arm B
grows **10.5x** across one doubling. Nothing about "both are O(menu)" predicts
that shape, which is why it had to be measured rather than argued.

**The width-32 B cell is an UNREACHED RESIDUAL, printed not absorbed** (the
no-silent-caps law). Arm A completed (847.67 ms); arm B had run **17 minutes**
against arm A's 98 seconds when the sweep was capped, and the cell carries its
headers with no data row. **The cap was the builder's deliberate choice** —
width 64 would have cost hours for a shape already established at 16 — and it
is recorded as a choice, not reported as a completed sweep. Anyone reading
this table should read width 32 as "arm B exceeded 10x and was stopped", not
as a measurement.

**What this does to R1.** The answer is now two-sided and the sitting should
have both halves:

- **At the consumer's declared width of 4, re-routing is free** (+0.19%, inside
  noise). Option (3) costs them nothing today, and the drift row's band is not
  at risk.
- **The equivalence is a property of width 4, not of the two verbs.** A
  consumer who widens their menu past 8 pays sharply for `policyPick`. If
  option (3) makes `policyPick` the universal clockless route, that cost lands
  on every future consumer with a wider menu, silently — the wire declares no
  width limit and nothing warns them.

### The mechanism, probed two-sidedly

A cliff invites a story, and a story is not a measurement. `policyPick` builds
a comparison tree over all *n* candidates and evaluates it in one env
(`src/PropLang/Membrane.hs` @ `94fd4eb`, binding `policyPick`), and this engine
is exact-`Rational` throughout — so evaluation cost is driven by **denominator
size**, not node count. The consumer's theta grid is decimal (~2^-55
denominators, F5/C25), which would compound through a wider tree. **That is a
hypothesis with a cheap decisive test**: snap theta to `2^-10` and re-run the
same width. If the cliff flattens, the mechanism is arithmetic; if it
survives, the mechanism is tree shape.

Both arms, menu width **16**, population **960**, only the grid changed:

| | decimal (the consumer's real grid) | dyadic `2^-10` | grid lever worth |
|---|---|---|---|
| A `chooseEU` | 458.88 ms | **104.16 ms** | **4.4x** |
| B `policyPick` | 2876.98 ms | **433.55 ms** | **6.6x** |
| **B/A** | **6.27** | **4.16** | — |

**The answer is BOTH, and neither alone.** The dyadic grid removes a large
constant from each arm — 4.4x on the shipped route, 6.6x on the tournament
route — so denominator size drives the absolute magnitude. But the A-vs-B gap
**survives the fix at 4.16x**, so the tournament's structural cost is real and
not an artifact of the consumer's grid. Had I stopped at the arithmetic story
the pack would have carried a tidy, half-wrong explanation.

**This also strengthens F8(ii) considerably.** The grid lever the consumer has
scheduled for r46 and not yet read is worth **4.4x on their own world** at
width 16 — measured, not extrapolated — and it is worth more, not less, if
they ever adopt the substituting route. F5 measured the lever in *bits*; this
measures it in *time*, on their declaration, on both routes.

**The builder's revised reading:** the pin was never the obstacle (I.8) and
cost is not an obstacle at the width in evidence (above) — but "un-defer and
route everything through `policyPick`" acquires a **width caveat that did not
exist in the register when R1 was drafted**, and the honest form of option (3)
now carries it. This is exactly what the falsifier was for.

### Two operational incidents, recorded

1. **The first width sweep died after one cell.** Launched over `ssh` under a
   local `timeout`; the timeout killed the ssh and the remote script went with
   it, leaving a start line and no error. The **T100 wave was unaffected** (it
   completed inside its window). Re-launched under `nohup setsid` and detached.
   This is the third instance in this increment's family of *a harness that
   fails invisibly* (after wave R's `pipefail` race).
2. **A false alarm I raised and corrected in the same minute:** `pgrep -f
   bench-` reported a surviving process, which would have meant two waves
   contending. It was matching **its own command line** — the string `bench-`
   was in the `pgrep` invocation. No contention occurred; the timings stand.
   Recorded because a self-matching process check is a green that cannot fail.

## I.16 Claims register — addendum rows

| # | claim | tag | witness / falsifier |
|---|---|---|---|
| C33 | `origin/r45-evidence-path` exists at `99fa6c7`, one file, 104 lines, and postdates the r1 sweep. | **EXECUTED** | `git fetch` on the measurement box; `git diff --stat master...origin/r45-evidence-path` |
| C34 | Its branch 2 cites #15 as the engine-side twin and declines to file a new issue. | **QUOTED** | the consumer's words, `docs/unification/reports/r45-evidence-path.md` @ `99fa6c7` |
| C35 | #15 is OPEN and its title names the writable-name limitation. | **EXECUTED** | `gh issue view 15` — state OPEN, updated 2026-07-22 |
| C36 | The `feature/assignment collision` guard is live at HEAD, so a recorded act cannot enter as a feature. | **EXECUTED** | `src/PropLang/Host.hs` @ `94fd4eb`, binding `tick`, lines 397-399, read in THIS repo |
| C37 | R7's drafted close of #15 is falsified by demand dated after the pack's sweep. | **EXECUTED** | C33+C34+C35 together; falsifier would be the consumer withdrawing branch 2 |
| C38 | Toolchain is identical on both boxes (GHC 9.10.3, cabal 3.16.1.0) and engine semantics are box-independent. | **EXECUTED** | `BenchTest` ALL PASSED on steel incl. 4 exact `t5c` `Rational ==` pins |
| C39 | The prototype diff is exactly 2 lines in 1 file, the second enforced by `-Werror`. | **EXECUTED** | `git diff --stat` in the worktree; the quoted `-Wunused-imports` error |
| C40 | `policyPick` costs +0.19% wall / +0.20% cpu vs `chooseEU` at menu width 4, inside within-arm spread. | **EXECUTED** at width 4 | 4 alternating reps per arm, T100, seed 1, steel quiet |
| C40b | The equivalence is a property of WIDTH 4, not of the verbs: B/A is 1.003 / 1.034 / **6.27** at widths 4 / 8 / 16. | **EXECUTED** | the width sweep, 1 rep per arm per width, alternating, steel quiet, population asserted 960 at every width |
| C43 | At width 16 the dyadic grid is worth 4.4x on `chooseEU` and 6.6x on `policyPick`; the B/A cliff falls 6.27 -> 4.16 but does NOT vanish. | **EXECUTED** | `ab-mech` probe, both arms, same width and population, only the grid changed; two-sided by construction — either outcome was informative |
| C44 | The cliff's mechanism is BOTH denominator size (magnitude) and tree shape (residual gap), not either alone. | **EXECUTED** | C43's surviving 4.16x is the falsifier of the pure-arithmetic story; the 4.4x/6.6x drops falsify the pure-tree-shape story |
| C40c | Width 32 arm B exceeded 10x arm A and was **stopped, not measured**. | **UNREACHED RESIDUAL** | arm A completed at 847.67 ms; arm B ran 17 min vs 98 s and its cell has headers with no data row. Printed per the no-silent-caps law; the falsifier is simply to run it to completion |
| C41 | Population is 960 at every swept menu width. | **EXECUTED** | `BenchTest` t8 population assertion, 5 widths, against the engine's own hello reply |
| C42 | The consumer has scheduled `GD-15` grid precision for r46 and has not read it. | **QUOTED** | their "Carried obligations" section and *"none has been read"* |

---

# THE r2 ROUND — the verdict received, its two probes executed, the delegated acts done

*Round r2 opened 2026-09-02 on the sitting's verdict and closed the same
day. Everything below was executed at HEAD `94fd4eb` with nothing frozen
touched; the bench series landed as three builder commits on the verdict's
R8 ruling and the author's confirmed scope.*

## II.1 The verdict (QUOTED — the author's words, received 2026-09-02)

The round's charter, quoted in full per the QUOTED discipline:

> Read in full, r1a included. Verdict first: **R1 should be (3)**, and the
> pack's own evidence has already carried it there — the drafted default of
> (1) survived only because it was written before F7 and F9. But "route
> clockless worlds through `policyPick`" is not the right shape of (3), and
> the pack missed the shape that is.
>
> The case for (3) is not #24's demand. It is that step 5 terminates the
> roadmap, and you do not terminate a decision-theoretic language with a
> shipped argmax that returns the menu head against a utility declaring
> another option worth ten times as much. `chooseEU` evaluating both
> `Expect` terms in the challenger's env is not "the non-substituting
> fold"; on a writable name it is a wrong argmax with a pin dignifying it.
> Option (1) names a boundary the terminus clause guarantees will never
> open. The builder is right that this is a deferral wearing a name; do not
> sign it.
>
> Two things the pack did not consider.
>
> **The fork is not binary.** The pack poses `chooseEU` (pairwise,
> non-substituting, linear) against `policyPick` (tournament, substituting,
> cliff at 16). The third shape is pairwise *and* substituting: the fold
> `chooseEU` already does, with one env per side of the comparison rather
> than one env for both. Argmax over numeric EU is a total preorder, so a
> pairwise fold with per-side substitution yields the tournament's winner
> up to tie convention, at O(width) evaluations. That makes the frozen
> `menu` bullet true as written — `chooseEU` becomes the binary special
> case of `policyPick` — so FL-1 installs as history rather than
> correction, and you keep one entry point instead of acquiring a third.
>
> **The cliff is diagnosable statically, and nobody has looked.** Arm B
> grows 10.5x on one doubling and survives the dyadic snap at 4.16x.
> Denominator size does not produce a step at a particular width;
> expression duplication does. If `policyPick` builds the tournament as
> nested `If`s with the winner subtree re-embedded in each successive
> comparison, term size is exponential in width and sharing loss dominates
> precisely around 16. The probe is a node count of the built expression at
> widths 4/8/16/32 — no timing, no box, ten minutes. Linear: the cliff is
> intrinsic to substitution and (3) owes a cost row. Exponential: it is an
> implementation artefact, the pairwise-substituting fold removes it, and
> the width caveat in the post-ruling plan evaporates. Run this before
> ruling; it decides the shape of (3). And whatever the answer, do not
> declare a width cap — that is a hardcoded threshold, which the
> constitution forbids for exactly this kind of reason.
>
> **A kill-law point on the pin row (3) owes.** The plan says the new route
> is "pinned extensionally to the old on the clockless corpus". F7
> established that corpus contains three worlds able to distinguish the
> routes, two of them immune. Equality-pinning on a corpus where old and
> new agree is a green that cannot fail. The pin row must pin the *new*
> behaviour on #24's world — head loses, argmax wins — with the seeded
> defect being reversion of the identifier. If that mutant does not go red,
> the row is not installed.
>
> The rest of the register:
>
> **R2** — repair regardless; mind the inversion trap, and under the third
> shape above the original sentence is simply true.
> **R3** — agree: not an alphabet motion; OB-33 fires on (3).
> **R4** — (b) with (a)'s override. Add a third red to the demo: the marker
> occurring twice (once quoted in a fence) must FAIL as ambiguous —
> "exactly one occurrence" removes the weakness the pack names in (a) for
> free. And the flag list must derive from every test stanza in the cabal
> file, not from a stanza name hand-listed in the lint, or it is the same
> disease one level up.
> **R5** — yes, as one row with both arrows: our published record re-read
> against HEAD, and the filer's repo fetched before any disposition. F8
> overturned a close for the price of one `git fetch`. Triage-only, never a
> verdict.
> **R6** — agree: record the second and third instances, do not discharge.
> **R7** — #11 and #16 post today; #15 stays open per r1a; #17 confirm. On
> #14: dispose into post-terminal residue with an explicit re-open
> condition (a re-statement against the current engine). Re-soliciting an
> input nobody has requested for forty days is R1's option (1) in
> miniature, and the form of your rulings should not differ across rows of
> the same shape.
> **R8** — land the series, band blank. The `drift-a` observation deserves
> a ruling rather than a footnote: an absolute band has produced three
> environmental reds and the ratio row passed every time. A gate that
> reddens under load teaches people to read red as weather. Licensed
> re-mint to ratio form at the next boundary that touches the oracle.
> **R9** — as drafted.
>
> One thing on the bench before any band is filled. `alpha_3p` of 2.44 on
> the real declaration, with the dyadic snap collapsing the growth
> coefficient 81x while leaving the exponent *steeper*, says the growth is
> denominator growth in the folded posterior, not model count — the
> exponent is measuring an arithmetic representation, not the decision
> problem. Seventeen arity-1 guard rows over a theta grid have bounded
> sufficient statistics: counts, O(log t) bits, exact. If the fold
> multiplies per-tick likelihoods into the posterior as rationals, it
> carries O(t) bits it does not need. Falsifier: `qbits` of the folded
> state against t, one cell, any profile. Linear in t means the band should
> not be filled at all, because it would be a band on an artefact, and the
> Credence brain-seam cutover gate is being read against the wrong
> quantity. Logarithmic means I am wrong and the exponent is real — worse
> news, but at least news about the problem.

**The delegation scope, confirmed by the author the same day** (the
builder asked three questions before executing; answers verbatim): post
**"All five"** drafted comments; close **"#11, #16, #14"**; on the series,
**"Commit and push"**.

## II.2 The register after the verdict

| row | state |
|---|---|
| R1 | **(3)**, in direction; the SHAPE left open pending probe A1 — now executed, II.3. The shape ruling itself remains the author's. |
| R2 | RULED: repair; under the third shape FL-1 installs as HISTORY (original sentence true). Draft amended. |
| R3 | RULED: not an alphabet motion; **OB-33 fires on the (3) increment**. |
| R4 | RULED: (b) with (a)'s override + two modifications (exactly-one marker; per-test-stanza flags). Draft at REV 2. |
| R5 | RULED: standing, ONE row, BOTH arrows (our record re-read at HEAD; the filer's repo fetched before any disposition). Triage-only. |
| R6 | RULED: record OB-30's second and third instances; do NOT discharge. |
| R7 | RULED, all five; executed II.6. #14 → post-terminal residue with the re-open condition named. |
| R8 | RULED: series landed (II.6), band blank, **drift-a licensed re-mint to RATIO form at the next oracle-touching boundary**, and the qbits falsifier ordered before any band — executed, II.4. |
| R9 | As drafted: r1 no; the (3) increment yes (six mandates at its close). |

Plus two standing lines from the verdict: the (3) pin row pins the NEW
behaviour on #24's world with reversion as the seeded defect (never
equality on the agreeing corpus); and **no width cap, ever** — a width cap
is a hardcoded threshold the constitution forbids.

## II.3 F10 — probe A1, the static term count (EXECUTED)

Transcript: `chooseeu-sitting/r2-f10-term-size.txt`. Instrument:
`bench/ProbeTermSize.hs` (persists; landed in the series). Method: build
the selection term EXACTLY as `policyPick` builds it — through the exported
doors `withRows`/`substW`/`chooseKS`/`mkGrid`/`mkC`, the construction
quoted with R-D20-i provenance — on the F9 width worlds' own menus
(`BenchLib.profiles` by name, one generator), and count two things in one
DAG-memoized pass: the TREE (what the tree-walking `evalx` walks) and the
DAG (what the heap shares).

| width | tournament tree | dag | per-comparison, shipped pick | per-comparison, third shape |
|---|---|---|---|---|
| 4 | 180 | 50 | 22 | **22** |
| 8 | 3,628 | 106 | 22 | **22** |
| 16 | 950,124 | 218 | 22 | **22** |
| 32 | 62,277,025,516 | 442 | 22 | **22** |
| 64 | 267,477,789,068,788,497,900 | 890 | 22 | **22** |

**The verdict's hypothesis is confirmed, exactly.** `chooseKS`'s fold
(`Syntax.hs:252` at `94fd4eb`) re-embeds the winner term twice per step —
`step (cw, vw) (c, v) = (If (Gt v vw) c cw, If (Gt v vw) v vw)` — and
`evalx` (`Eval.hs:62`) walks the tree with no memoization. Tree fits
**~14.5·2^w**; DAG fits **~28·w**. The cliff is EXPRESSION DUPLICATION —
an implementation artefact of the expansion, not intrinsic to
substitution — and the third shape's per-comparison term is a
width-independent **22 nodes, equal to chooseEU's own shipped pick
constant**. Substitution itself costs nothing per comparison; only the
tournament's materialization did. **The width caveat evaporates under the
third shape, and no cost row is owed.**

(Why F9 measured 6.27x at width 16 rather than the ~2,900x node ratio:
`evalx`'s `If` evaluates one branch, so the walked subtree is the
win/loss-pattern-dependent realization of the static tree. The static
count is the structure; the timing is one path through it. Both say the
growth is the expansion's.)

## II.4 F11 — probe A2, qbits of the folded state against t (EXECUTED)

Transcript: `chooseeu-sitting/r2-f11-state-bits.txt`. Instrument:
`bench/ProbeStateBits.hs` (persists; landed in the series). The fold is
BenchTest t5's own (mirror == engine `metaPosterior`, Rational ==, by the
frozen t5c row), so the weights measured ARE the engine's state.

**LINEAR. The verdict's hypothesis is confirmed on both profiles.**

- **P1** (dyadic sixteenths): total qbits 2,015 → 3,990 → 7,944 → 15,845 →
  31,648 at t = 100/200/400/800/1600 — doubling with t, ~19.8 bits/tick —
  against an ss-control (per-outcome counts + t) of 19 → 22 → 25 → 28 → 31,
  O(log t). At t=1600 the state carries **~1,000x** the bits the decision
  problem needs, growing without bound.
- **P2realNC** (the owner's real declaration, decimal grids): total qbits
  **10,142,238 at t=100 → 20,268,405 at t=200** (ratio 1.999), ss-control
  20 → 22. The real declaration pays ~101k bits per tick of pure
  representation growth — the state is ~1.3 MB of exact rationals at
  t=100. The t=400 cell's own runtime is the cost made visible: the
  per-tick arithmetic slows as the state grows (the probe's first run was
  killed at 10 minutes for silent buffering, repaired to line-buffered,
  re-run; its wall time is printed in the transcript).

**Consequence, per the verdict's own reading, now measured rather than
conditional:** `alpha_3p` = 2.44 measured an ARITHMETIC REPRESENTATION,
not the decision problem — **the band is not to be filled against it**,
and the Credence brain-seam cutover gate is being read against the wrong
quantity. This rides the r02 report section (landed, II.6) where the
owner reads. The engineering observation that follows (the fold could
carry bounded sufficient statistics for const families — counts, exact,
O(log t)) is BANKED AS MEASUREMENT ONLY: post-terminus, it re-enters
through the two-sided gate when a consumer registers the demand, exactly
as #24 did. The measurement half now exists; the demand half is not the
builder's to invent.

## II.5 F12 — the third shape, prototyped and demonstrated (EXECUTED)

Transcript: `chooseeu-sitting/r2-f12-pairsub-proto.txt`. Prototype
`ProtoPairSub.hs`: R-D21 throwaway, compiled clean under the bench flag
set, **deleted after its transcript**. Total wall: 2.9 s.

- **D1 — #24's world** (the issue body's declaration verbatim; its said
  sentence parsed rule-for-rule per `parseSaidWith` at `94fd4eb`):
  shipped `chooseEU` → the menu head (`act=1`, worth 10) — F1's wire
  result reproduced at the library route; the third shape → the declared
  argmax (`act=2`, worth 100); `policyPick` agrees.
- **D2 — the kill-law red, demonstrated:** reverting the comparison to the
  challenger-env form flips #24's world back to the head. The future pin
  row's seeded defect fires.
- **D3 — agreement 14/14** with `policyPick` across P2 (act GUARDED, so
  beliefs differ per action) and the real-declaration width worlds at
  4/8/16; w=32 `policyPick` SKIPPED (printed, with A1's reason);
  `chooseEUsub` at w=32 is instant. Live detail: on the real declaration
  the two substituting routes pick the top-value act while `chooseEU`
  picks the head — the #24 mechanism on the consumer's own world shape.
- **D4 — tie convention identical** (first-listed incumbent, strict Gt) —
  expected, since `chooseKS` folds the same convention.
- **D5 — env-independence:** after `substW` the served writable assignment
  is dead; asserted per comparison under both covers, no violation.

## II.6 The delegated acts — the record

**Postings** (posted FROM the draft file mechanically; every posted body
verified byte-identical to its draft modulo GitHub's trailing-newline
normalization):

| issue | comment | state after |
|---|---|---|
| #11 | issuecomment-5503109933 | **CLOSED** |
| #14 | issuecomment-5503110137 | **CLOSED** (post-terminal residue, re-open condition in the comment) |
| #15 | issuecomment-5503110320 | OPEN (the r45 supersession recorded) |
| #16 | issuecomment-5503110507 | **CLOSED** |
| #17 | issuecomment-5503110711 | OPEN (the standing `observe_counts` entry) |

**The bench series, landed and pushed** (R8; builder commits, unsigned,
delegation in each message):

1. `85d5825` — the instrument (11 files; membership deviation from the
   prepared list recorded in the message: P2Real.hs/gen-p2real.py needed
   for the build, plus the two r2 probes).
2. `4946477` — the result artifacts (107 files; results/ + results-ab/).
3. `8d7e1c0` — the report with the r02 section appended (covers
   F5/F9/F10/F11 where the owner reads; the band gated by the qbits
   finding).

Pushed: `origin/master` advanced `94fd4eb..8d7e1c0` on the author's
confirmed "Commit and push".

## II.7 The drafts revised this round (all unfrozen, all awaiting the key)

- `L5-repair-option-b.txt` → **REV 2**: exactly-one marker (RED 3), flags
  derived from every TEST-SUITE stanza by awk block-scoping with **no
  hand fallback** — an empty derivation FAILS (RED 4). Demo grows both
  reds.
- `post-ruling-plan.md`: pin-row bullet REPAIRED in place (old words
  quoted) per the kill-law point; the width-cap option STRUCK (old words
  quoted) — resolved by measurement, no cap ever; drift-a re-mint and
  R5's two-arrow row added to the close list.
- `FL-repairs.txt`: FL-1 amended — installs as a dated HISTORY bracket
  under the third shape (the drafted correction becomes the bracket's
  body), one reading only, at the (3) increment's close.
- `issue-postings.md`: the #14 draft added (posted, II.6).

## II.8 Claims register — r2 rows

| # | claim | status |
|---|---|---|
| C45 | chooseKS re-embeds the winner term twice per step; evalx walks trees unmemoized | EXECUTED (source quoted in r2-f10; the probe's counts are the witness) |
| C46 | tournament tree ~14.5·2^w, DAG ~28·w, widths 4–64 | EXECUTED (r2-f10) |
| C47 | third-shape per-comparison term = 22 nodes = chooseEU's pick constant, width-independent | EXECUTED (r2-f10) |
| C48 | the F9 cliff is expression duplication, not substitution | EXECUTED (r2-f10; the dyadic residual 4.16x of F9 is the same conclusion from the other side) |
| C49 | folded state qbits LINEAR in t on P1 (~19.8 bits/tick) vs O(log t) ss-control | EXECUTED (r2-f11) |
| C50 | folded state qbits LINEAR on the real declaration (~101k bits/tick; 2.000x at the doubling) | EXECUTED (r2-f11; t=400 cell disposition printed in the transcript) |
| C51 | alpha_3p measured representation growth, not the decision problem; the band must not be filled against it | EXECUTED (C49+C50 are the witness; the verdict's conditional made actual) |
| C52 | third shape returns #24's declared argmax; policyPick agrees; chooseEU returns the head | EXECUTED (r2-f12 D1) |
| C53 | reversion to the challenger-env comparison flips #24's world to the head (the pin row's red) | EXECUTED (r2-f12 D2) |
| C54 | third shape == policyPick on 14/14 cells, widths 3–16, guarded and unguarded | EXECUTED (r2-f12 D3; w=32 policyPick SKIPPED, printed) |
| C55 | tie convention identical across all three routes | EXECUTED (r2-f12 D4) |
| C56 | third shape == policyPick UNIVERSALLY (beyond the 14 cells) | ARGUED — falsifier named: same fold convention (first-listed incumbent, strict Gt displacement) as chooseKS's own foldl; any world where they disagree convicts one implementation. The (3) increment's pin suite is where this becomes a frozen row. |
| C57 | every posted body byte-matches its draft | EXECUTED (sha256 comparison, trailing-blank-normalized, II.6) |

## II.9 What r2 leaves for the author

1. **The shape ruling.** The evidence (F10 + F12) says the third shape:
   O(width), substituting, one entry point, the frozen `menu` bullet true
   as written, no cost row owed, no cap. The ruling is the author's; the
   (3) increment's oracle freeze follows it.
2. **The (3) increment itself** — oracle-first: the pin row per the
   kill-law correction (D2 is its red, demonstrated), OB-33's kill matrix,
   the six mandates at close, the FL-1 history bracket, the L5 rev-2
   install with its four-red demo, the OBLIGATIONS rows, the drift-a
   ratio re-mint, the manifest re-sign, the tag by -F file.
3. **The band** — now gated by C51: not to be filled against the measured
   alpha; what replaces that reading is the owner's question, informed by
   the r02 section where they read.

---

# THE r3 ROUND — the ruling round received, its order executed, the draft at rev 2

## III.1 — the ruling round's text, verbatim

Relayed in-session, 2026-09-02.  Its closing line reserves the signature,
the clause-5 word, and the demand registration — so NOTHING IN THIS ROUND
BINDS YET; what this round did is bring the draft to the form the
signature covers and execute the one demonstration the round ordered.
The text, in full:

> Read in full — the r2 round, both probes, F12, the delegated record,
> and the shape-ruling draft. Spot-checks first: F10's tree counts are
> internally consistent with the fit (3,628 × 2⁸ ≈ 950,124 × 2¹⁶ ≈
> 6.2e10 × 2³² ≈ 2.7e20 — each doubling of width multiplies by 2^Δw, as
> duplication predicts), and the fold source quoted at `Syntax.hs:252`
> is the mechanism exactly. F11's 1.999x qbits ratio at the doubling is
> as clean a linearity witness as one cell can give. Both probes did
> what they were asked and the pack read them without overreach.
>
> **Verdict: adopt R-SHAPE, with three amendments and a decision on
> clause 5.**
>
> **Clause 5 — INCLUDE the clock path.** Four reasons, one of them not
> in the draft. The draft's own: same fold, same pin pattern, no
> scheduled later carrier. The missing one: striking it inverts the
> price structure. `pickWire` carrying the exponential expansion means a
> consumer who *pays* for deliberation buys a hidden 2^w term the free
> path no longer has — the declared clock price stops being the price.
> That is the availability-from-pricing law bent out of shape on the
> primary route while the secondary one is repaired. The counter-case
> ("no live consumer pays it at width 4") is the same argument that kept
> `chooseEU` shipped for five weeks, and the sitting has already
> declined it once. Include.
>
> One correction to clause 5's pin language, though: "its frozen
> trampoline rows staying green byte-stable is itself the pin" is the
> green-that-cannot-fail shape — those rows all agree between old and
> new by construction. The clock path's pin is clause 4b's family
> (which contains the distinguishing widths), with `pickWire` routed
> through it; the trampoline rows staying green is a regression check,
> not the pin. Say so in the clause or the kill matrix will one day
> certify the wrong thing.
>
> **Amendment 1 — clause 4b's seeded defects: add the env-wiring
> class.** Reversion and the tie flip are two members of a four-member
> class: both-envs-challenger (the shipped defect), both-incumbent,
> swapped, correct. F12's D2 kills the full reversion; the
> half-reversions produce a tie on #24's world (incumbent's EU evaluated
> under the challenger's assignment equals the challenger's — head
> survives), so #24's world likely kills them too, but *demonstrate* it
> rather than argue it — three mutants, one world, minutes. A pin suite
> that enumerates its mutant class at birth is what OB-33's matrix then
> grows.
>
> **Amendment 2 — clause 2's open detail: the reference stays in the
> library.** `chooseKS` already lives in `Syntax.hs`; the sayable route
> is part of the language's semantics, not test furniture, and the
> disposition has a precedent one clause away — exported, zero host
> consumers, pinned: exactly what clause 3 gives `chooseEU`. Moving it
> test-side would make the normative definition a resident of the
> oracle, which is backwards. One rider: the reference is unevaluable
> past the old cliff (6e10 nodes at w=32 — D3 rightly skipped it), so
> the extensional pin's width ceiling is the reference's own cost, in
> practice w=16. Record that bound in the pin row's prose, or the matrix
> will eventually stall trying to grow past it and someone will read the
> stall as a defect.
>
> **Amendment 3 — clause 4b's family form: minimal separating family at
> freeze, grown by the matrix.** The freeze-time family must separate
> every drafted seeded defect (now six across the two classes) and
> include one width past the old cliff; nothing more. A family that
> cannot kill its own drafted mutants at freeze is a non-functional
> alarm at birth; breadth is the matrix's job, per the dyadic precedent.
> This resolves the honest list's third item in the direction the
> builder already leant.
>
> On C56: under the third shape each candidate's EU is a function of
> that candidate alone (D5's env-independence), and both routes fold the
> same strict-Gt first-listed convention (D4), so fold == sentence is a
> theorem, not a 14-cell coincidence. Worth one sentence in the pin
> row's rationale — it explains why the extensional row is expected
> green rather than hoped green — but the frozen row is still owed;
> theorems about implementations are ARGUED until pinned.
>
> **The band, and the brain seam.** C51 stands: do not fill. But the
> pack's disposition — bank the sufficient-statistics fold post-terminus
> behind the demand gate, "the demand half is not the builder's to
> invent" — is correct discipline with one thing it cannot see: the
> demand half already exists, and it is yours. The Credence brain-seam
> cutover is gated on this measurement; F11 says the gate as posed reads
> an artefact; therefore the gate's owner has measured demand against
> the representation, in precisely #24's shape — demand registered
> against a deferral, measurement attached. Whether you register it is
> your act, not the builder's, and registering it does not un-terminate
> the roadmap: it enters through the two-sided gate post-terminus like
> anything else. But leave it unregistered and the cutover stalls
> silently rather than honestly — the gate becomes a band nobody may
> fill on a quantity nobody may read, which is a deferral without even a
> name. Register it, date it, and let it queue.
>
> Two small notes on the record. The dyadic lever does not touch this:
> P1 is already dyadic and still grows ~19.8 bits/tick — the lever
> shrinks the coefficient, the linearity survives, so no
> declaration-side change rescues the operating point; the r02 section
> should say that plainly where the owner reads, since GD-15 is
> scheduled for their r46 and they might otherwise expect the grid to
> buy what only the fold representation can. And the delegated record is
> clean as executed — byte-verified postings, the three commits on
> confirmed word, #14's re-open condition in the comment where its
> consumer reads.
>
> What remains yours, then: sign R-SHAPE as amended, or strike the
> amendments on the record; the clause-5 word; and the demand
> registration at the brain seam. The increment opens oracle-first after
> the first of those, and D2's red is already waiting to be promoted
> from prototype to pin.

## III.2 — the order executed: F13, the env-wiring class on #24's world

Transcript: `chooseeu-sitting/r3-f13-env-wiring.txt`.  The r2 prototype
was RECONSTRUCTED FROM THE SESSION RECORD'S OWN WRITE COMMAND (the
heredoc plus the one recorded import repair — the same generator that
produced the r2 file, never a from-memory rewrite; base sha256 prefix
d2b965b21ab32527, now on the record — r2-f12 had recorded none), extended
by exactly the class the round named, compiled under the frozen flag set,
run once, deleted (R-D21).

Result — one world, three reds, all killed by the 4a row:

    pin row expects the declared argmax  [("act",2)]   (act=2 worth 100)
    BOTH-CHALLENGER (the shipped defect) [("act",1)]   RED — tie, head survives
    BOTH-INCUMBENT                       [("act",1)]   RED — tie, head survives
    SWAPPED                              [("act",1)]   RED — inversion, nothing promotes

The round's prediction confirmed verbatim on both half-reversions (both
Expect terms read the same assignment; #24's utility is belief-blind, so
strict Gt never fires).  SWAPPED kills by a DIFFERENT mechanism — the
comparison computes u(incumbent) > u(challenger), promotion requires the
incumbent to be strictly better, and #24's head is the minimum.  The
widened env-independence assertion stayed silent on every cell, and the
r2 results (D1, D4, the 14/14 agreement sweep) are unchanged under the
extended prototype.

## III.3 — the draft at rev 2 (`chooseeu-sitting/drafts/shape-ruling.md`)

Four edits, all in place, the round's words carried in:
1. Clause 5 rewritten: INCLUDE with the four reasons (the price-structure
   inversion doing the deciding), and the pin-language correction — the
   rev 1 sentence quoted inside its replacement, the clock path's pin
   named as clause 4b's family with pickWire routed through it, the
   trampoline rows demoted to regression check.
2. Clause 4b rewritten: the env-wiring class enumerated at birth (four
   members, three defective, F13's demonstration cited), the
   minimal-separating family form, and the two prose lines the row
   carries — C56's theorem rationale (row still owed) and the w=16
   reference-cost ceiling printed as the row's residual.
3. Clause 2 extended: the reference stays in Syntax.hs — exported,
   pinned, zero host consumers, the chooseEU-disposition symmetry.
4. The honest list reworked: what the round resolved, the one COUNT to
   settle at signature (below), and the two acts that remain the
   author's.

## III.4 — the bench act

r02.4 amended in place with the dyadic-lever paragraph ("the lever
shrinks the coefficient, the linearity survives... only a change in how
the folded state is represented changes the class"), dated to this
round.  Commit `5008fb6`, pushed to origin/master, the round's directive
quoted in the commit message.  Builder commit, unsigned by design.

## III.5 — claims register, continued

| # | claim | status |
|---|-------|--------|
| C58 | All three defective env-wirings are killed by the 4a row on #24's world (each returns the head where the row expects the declared argmax) | EXECUTED (r3-f13) |
| C59 | The half-reversions kill by TIE — both Expect terms read one assignment, #24's utility is belief-blind, strict Gt never fires (the round's prediction) | EXECUTED (r3-f13) |
| C60 | On a world whose head is neither argmax nor argmin, the SWAPPED wiring lands on a third answer distinct from both | ARGUED — falsifier named: one cell, values 50/100/10 through the swapped wiring; expected [("act",3)] |
| C61 | The reconstruction is byte-identical to the r2 prototype | EXECUTED by derivation — same generator (the session record's write command + the recorded repair); base hash now recorded for any future reconstruction |

## III.6 — what remains, and one count to settle

THE AUTHOR'S THREE ACTS (the round's own closing list): (1) sign
R-SHAPE as amended — rev 2 is the text the signature covers — or strike
amendments on the record; (2) the clause-5 word (rev 2 drafts INCLUDE
per the round; the signature closes it); (3) the demand registration at
the Credence brain seam — the gate-owner's act, dated, queued through
the two-sided gate post-terminus.

ONE COUNT TO SETTLE AT SIGNATURE: the round counts "now six" drafted
seeded defects across the two classes; the builder's enumeration
reaches FOUR extensional defects (env-wiring x3, tie-flip) — FIVE
patches if the identifier reversion is seated separately from the
fold-internal both-challenger (extensionally equal, different diffs).
If the sixth is the operator class filled out symmetrically
(Gt/Ge/Lt/Le: three defects), say so at signature — amendment 3's
"separate every drafted seeded defect" quantifies over exactly this
enumeration.

After the signature the increment opens ORACLE-FIRST, unchanged from
II.9: the pin-suite oracle runtime-red with R-D21 transcripts (D2's red
promoted to the 4a row; F13's two riding beside it), the freeze, the
one-identifier routing change plus the fold body, gates 1-7, OB-33's
matrix, the six mandates, the FL repairs, L5 rev 2, the OBLIGATIONS
rows, the drift-a ratio re-mint, the manifest re-sign, the tag by -F
file under `selection-freeze-r*`.

## III.7 — the close kit (assembled at the author's "help me close", 2026-09-02)

Three files, one commit, one act left:

1. `chooseeu-sitting/r0-tag-msg.txt` — the signature's register as a
   FILE (the tag-message-is-a-file law): R-SHAPE rev 2 adopted; the
   clause-5 word INCLUDE; the seeded-defect enumeration SETTLED AT SIX
   (two four-member classes — env-wiring and comparison-operator —
   three defects each; the identifier reversion seated as 4a's patch
   form of both-challenger, no seventh), with an explicit AUTHOR-AMEND
   bracket should the round's "six" have meant otherwise; the clause-6
   riders; what the tag opens.  The comparison-class reds are named as
   the oracle phase's to CONSTRUCT (R-RED — the tie world for Ge/Le).
2. `chooseeu-sitting/close.sh` — the author's script, never run by the
   builder: OB-29's live signature probe, existence/tree/cleanliness
   checks, `git tag -s chooseeu-sitting-r0 -F <the file>`, the
   readout-r1 byte-identity record, push instructions (fast-forward
   only).  This sitting touches no manifest-covered file, so the
   message's bytes are fixed by the sitting commit the tag covers —
   the deviation from the doctrine-close's manifest-row check, stated
   in the script's own comment.
3. `chooseeu-sitting/drafts/brain-seam-demand.md` — the gate owner's
   registration, DRAFTED ONLY (the round: "your act, not the
   builder's"); rides no part of the tag.

THE SITTING COMMIT (this commit) carries the pack (parts I–III), every
transcript (f1–f7, r2-f10–f12, r3-f13), every draft at its current
rev, the conferral (glob-derived, regenerated last), make-conferral.sh,
verify.sh, and the close kit.  Builder commit, unsigned by design.

WHAT CLOSES WHEN THE AUTHOR RUNS close.sh: the ruling is adopted and
the (3) increment opens oracle-first.  What stays open BY DESIGN:
issue #24 (closes at the increment's freeze, citing it), the brain-seam
registration (the owner's separate act), and every clause-6 rider
(discharged at the increment's close under the selection-freeze tag).

## III.8 — the close kit's own incident: a gate that could not pass (repaired, two-sided)

The author's first run of close.sh ABORTED false: "r0-tag-msg.txt is
not in HEAD's tree" — with the file demonstrably in HEAD.  The
mechanism: the check piped `git ls-tree -r` into `grep -qx` under the
script's own `set -o pipefail`; grep exits at the match, ls-tree takes
SIGPIPE mid-write, and pipefail converts the successful match into a
pipeline failure.  A GATE THAT CANNOT PASS — the mirror image the
two-run triptych's harness amendment names ("a kit or gate check that
cannot fail ... is the same defect wearing the harness's coat", and so
is one that cannot succeed).  The builder's pre-flight had run the
same pipeline in a PLAIN shell — outside the script's own options — a
rehearsal that was not flag-faithful to the thing it rehearsed, the
SAT-overlay lesson recurring in a kit driver.

THE REPAIR (both pipes in the act path removed, not patched around):
the tree check is now pipe-free (`[ -n "$(git ls-tree -r --name-only
HEAD -- "$MSG")" ]`), and the minted-message extraction is a single
awk over a temp file (no head-truncated pipe, which carried the same
latent SIGPIPE shape).  The repair comment rides in the script at the
repaired line.

THE TWO-SIDED DEMONSTRATION, executed under `set -euo pipefail`
(what the first cut skipped): gate 1 GREEN on the real file, RED on a
ghost path; gate 2 (extraction) GREEN by reproducing the
doctrine-sitting-r1 message byte-identically from its real signed tag
(941 bytes), RED against the wrong drafted file.  ALL-DEMOS-PASS.

Sibling sweep: verify.sh's two pipes are `grep -c` (reads all input,
no early exit, `|| true` besides) and a `grep -v | head` inside an
already-failing diagnostic branch — recorded, left as is.
make-conferral.sh has none.

The sitting commit is AMENDED in place (it had not been pushed;
nothing outward existed to orphan), so one sitting commit still
carries the whole record, this row included.

---

# APPENDICES — the executed transcripts, inlined

*Every transcript the pack cites, in full, so this file is
self-contained. All are re-runnable at HEAD 94fd4eb.*

## f1-issue24-transcript.txt

```
=== F1: issue #24's repro, RE-EXECUTED at HEAD ===
Run 2026-09-01 against the shipped host built from src at HEAD 94fd4eb.

The world is issue #24's, verbatim from the issue body.  Its utility is
constant in y (every arm multiplies ["var",1] by 0.0), so the beliefs are
IDENTICAL across options BY CONSTRUCTION and nothing below depends on
learning, evidence, or a prior:
    act=1 (the menu head)      worth  10
    act=2 (the declared argmax) worth 100
    act=3                       worth  50

--- ARM 1: NO clock row ---
{"ok": true, "proto": 1, "models": 25, "namespace_bits": 1.0}
{"act": {"act": 1}, "p1": 0.5, "entropy_bits": 2.5361356166885067, "p0": 0.5, "argmax_code": 0, "p_argmax": 0.5, "p_codes": [0.5, 0.5]}

--- ARM 2: WITH a clock row priced 1000 -- far above every menu row, so the
    internal act provably cannot win.  The row is the ONLY difference. ---
{"ok": true, "proto": 1, "models": 25, "namespace_bits": 1.0}
{"act": {"act": 2}, "p1": 0.5, "entropy_bits": 2.5361356166885067, "p0": 0.5, "argmax_code": 0, "p_argmax": 0.5, "p_codes": [0.5, 0.5]}

REPRODUCED.  The head wins without the clock; the declared argmax wins with
it; models: 25 matches the issue's table exactly.

--- and the workaround is not opt-out-able: batch 0 is refused ---
{"error": "bad hello"}
    (correctly so per membrane-wire.md section 2's stated shape -- but it
     means a consumer wanting substitution MUST also buy the preposterior)

--- the mechanism, read at HEAD, not inferred ---

src/PropLang/Host.hs @ 94fd4eb, inside the binding "actOrThink" -- the fork:
                case swClock w of
                  Nothing -> do
                    picked <- chooseEU (swNs w) feats (swAtom w) u scored
                    Right (Left (maybe o0 fst picked))
                  Just (price, d) -> do
                    tv <- thinkValue d (swNs w) feats (swAtom w) u opts ag
                    r <- pickWire (swNs w) feats (swAtom w) u scored price tv
                    case r of

src/PropLang/Membrane.hs @ 94fd4eb, "chooseEU"'s "step" -- ONE env, and it is
built from the CHALLENGER:
      (c0 : rest) -> Just <$> foldl' step (Right c0) rest
      where
        uB :: Expr (Rational ': env) Rational
        uB = reindexUtility atomG u
        pick :: Expr '[B Int, B Int] Rational
        pick =
          let vC = Expect (Var Z) uB
              vI = Expect (Var (S Z)) uB
          in If (Gt vC vI) (reMint atomG 1) (reMint atomG 0)
        step acc chal@(cFeats, bC) = do
          inc@(_, bI) <- acc
          env <- mkEnvIn ns (feats' cFeats) (bC :. bI :. VNil)

Both Expect terms are evaluated in that single env, so a "get" on the menu
name inside the utility reads the CHALLENGER's assignment on BOTH sides of
the comparison.  Per-action LEVELS cancel; only beliefs can differ; a world
whose beliefs are act-blind ties every pair, the incumbent survives every
step, and the fold returns the option-space head.

This is OB-24's own sentence.  #24 adds no new mechanism to it -- it adds
measured demand, which is the one input the register cannot derive for itself.

--- AN INCIDENT, RECORDED (the first run of this very transcript) ---
The first attempt to generate this file wrote the internal act's name inside
BACKTICKS in a double-quoted shell string.  The shell EXECUTED it:

    /bin/bash: line 21: think: command not found

That is OB-30's disease exactly -- REVIEWED PROSE REACHING A COMMAND THROUGH
A SHELL-WORD PARSER -- and it is the same shape that hung the readout r0
sitting for hours, where "git apply --check" cited as prose in a tag register
ran as a command substitution and read the terminal for a patch.  It cost
nothing here because the prose was a comment and the failure was loud.  It is
recorded because OB-30 is STANDING-CONDITIONAL on "a lintable form exists",
and this is a second live instance in a second consumer (a transcript
generator, not a tag kit).  See the register, question R6.
```

## f2-l5-transcript.txt

```
=== F2: the L5 self-falsification, EXECUTED ===
Run 2026-09-01 at HEAD 94fd4eb.  Every line below is a command and its
output, re-runnable at these bytes.

--- (a) the tree has NOT moved since the sitting recorded its result ---
$ git diff HEAD --stat -- tools/prefreeze-lint.sh doctrine-author-pack.md
(empty: both files are byte-identical to the commit that recorded 0 FAIL 1 WARN)

--- (b) L5's pack selection and its trigger, quoted from the row itself ---
# -- L5: SAT flag-faithfulness in the current author pack --------------------
# every overlay/satisfiability transcript must record the stanza's
# exact flag set, -Werror included (the step-5 flag-faithful amendment).
# Pack selection HARDENED at the heir oracle freeze (OB-28 iii): the
# old `ls -t` selected by mtime, which in a fresh clone is checkout
# order (the r1 rehearsal's L5 line read unify-author-pack.md) — the
# current pack now derives from HISTORY: the last commit that touched
# an author pack names it.
pack=$(git log -1 --pretty= --name-only -- '*author-pack.md' 2>/dev/null | head -1)
if [ -n "${pack:-}" ] && grep -qi "satisfiability\|overlay" "$pack"; then
  l5=0
  for flag in -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns; do
    grep -qF -- "$flag" "$pack" || { bad "L5 $pack SAT section lacks $flag"; l5=1; }
  done
  [ "$l5" -eq 0 ] && ok "L5 $pack records the four stanza flags (incl. -Werror)"
else
  warn "L5 no author pack with a SAT/overlay section found (nothing to check)"
fi

--- (c) which pack L5 selects at HEAD ---
$ git log -1 --pretty= --name-only -- '*author-pack.md' | head -1
doctrine-author-pack.md

--- (d) THE CHRONOLOGY, proven by git, not inferred ---
  8096c4b (2026-08-08)  trigger-word hits = 0  -> WARN branch (nothing to check) = the RECORDED result
  f79d7a4 (2026-08-08)  trigger-word hits = 0  -> WARN branch (nothing to check) = the RECORDED result
  94fd4eb (2026-08-08)  trigger-word hits = 1  -> CHECK branch -> 4 FAIL

--- (e) the single hit, and it is the sitting describing its own WARN ---
473:   nothing-to-check branch — this pack carries no SAT/overlay

  in context:
    8. Verification at the final bytes: prefreeze-lint 0 FAIL 1 WARN
       with L10 live (196 manifest rows verified, all 68 tags verify,
       L7 full-corpus build green, L10 "universe = Host.hs only; 6
       frontier symbols absent from Host code"; the WARN is L5's
       nothing-to-check branch — this pack carries no SAT/overlay
       section because no oracle was cut, correct for a rulings
       sitting); gate 5 = cabal test all -j1 EXIT=0, ALL 13 SUITES PASS
       (battery, breadth, dyadic, exact-acceptance, exact-properties,

--- (f) the pack carries NO actual SAT section: zero -W flags anywhere ---
  grep -c -- -Wall                        0
  grep -c -- -Werror                      0
  grep -c -- -Wincomplete-patterns        0
  grep -c -- -Wincomplete-uni-patterns    0

  So all four FAILs are FALSE POSITIVES: the row entered its check branch
  on a sentence ABOUT the lint, then failed a pack that correctly has no
  SAT section to check (a rulings sitting cuts no oracle).
```

## f4-standing-issues-transcript.txt

```
=== F4: the five standing open issues, RE-EXECUTED at HEAD ===
Run 2026-09-01 against the shipped host built from src at HEAD 94fd4eb.

WHY THIS ROW EXISTS.  All five were triaged at ONE sitting, 2026-07-22.  The
boundary audit's own banked-failure row reports the alphabet last moved at
c2ca82c, 2026-07-25 -- the exact re-founding, THREE DAYS AFTER every one of
those dispositions.  CLAUDE.md's canonized clause says a banked negative is a
HYPOTHESIS at any later boundary whose terms changed underneath it, and must
be RE-EXECUTED before it is relied upon.  No pack since -- x5, exact, dyadic,
trampoline, f5, jp, battery, readout, breadth, doctrine -- mentions #15, #16
or #17 at all.  This is that re-execution.

================================================================
#16 -- the said@1 form sweep.  THE AUTHOR'S OWN POSTED COMMENT IS NOW FALSE.
================================================================
The comment posted to #16 on 2026-07-22 told the filer:

  "the wire now speaks THIRTEEN forms (/, log, exp, neg landed at W4,
   w4-freeze-r1; your sweep predates it; all four now ACCEPT)"

Executed at HEAD, one hello per form, everything else held identical:
    ["/",["c",1.0],["c",2.0]]              -> {"error": "bad hello"}
    ["log",["c",2.0]]                      -> {"error": "bad hello"}
    ["exp",["c",1.0]]                      -> {"error": "bad hello"}
    ["neg",["c",1.0]]                      -> {"error": "bad hello"}
    ["*",["get","act"],["var",1]]          -> {"ok": true, "proto": 1, "models": 9, "namespace_bits": 1.0}
    ["+",["var",1],["c",1.0]]              -> {"ok": true, "proto": 1, "models": 9, "namespace_bits": 1.0}
    ["expect",["var",0],["c",1.0]]         -> {"error": "bad hello"}
    ["cond",["var",0],["c",1.0]]           -> {"error": "bad hello"}
    ["push",["var",0]]                     -> {"error": "bad hello"}
    ["argmax",["var",0]]                   -> {"error": "bad hello"}
    ["var",2]                              -> {"error": "bad hello"}
    ["var",-1]                             -> {"error": "bad hello"}

  The four W4 forms REFUSE at HEAD.  They left the alphabet at the exact
  re-founding, three days after that comment was posted -- membrane-wire.md
  records it: "NINE forms (var c + - * get if > =) ... / log exp neg FAIL
  CLOSED (they left the alphabet at the exact boundary)".

  A consumer who adopted those four on the strength of the comment is broken
  at HEAD, and the issue thread still tells them to use them.

  #16's LITERAL claim SURVIVES: no belief-scoped head parses, and ["var",N]
  is still closed to N in {0,1} (all six candidates refuse above).
  #16's OPERATIVE conclusion DOES NOT.  Its body enumerates three routes and
  closes "None of these exist today"; route (c) was "some other wire-level
  hook that changes how much computation the engine spends per decision based
  on a declared value".  That is EXACTLY the trampoline clock row, shipped
  2026-07-27 -- five days after the ruling.  Demonstrated:
  ATTEMPT 1 -- utility act*y, prices 0.0 and 5.0.  The contrast did NOT
  fire; both prices act:
      price 0.0   -> {"act": {"act": 2}, "p1": 0.5,
      price 5.0   -> {"act": {"act": 2}, "p1": 0.5,

  WHY: under act*y the acts are NOT tied (EU = act * p1, so act=2 wins by
  0.5 outright).  Information that cannot change the choice has no
  decision value, so no price makes deliberation worth buying.  A generic
  world jumps over the margin -- which is R-RED's whole point.

  ATTEMPT 2 -- the margin COMPUTED and the crossing CONSTRUCTED.  Under
  act*(2y-1) the two acts tie exactly at p1=0.5, so learning y strictly
  changes the choice and deliberation has value.  Sweeping the price:
      price 0.0   -> {"internal": "think"}
      price 0.1   -> {"internal": "think"}
      price 0.2   -> {"internal": "think"}
      price 0.21  -> {"internal": "think"}
      price 0.22  -> {"act": {"act": 2}, "p1": 0.5,
      price 0.25  -> {"act": {"act": 2}, "p1": 0.5,
      price 1.0   -> {"act": {"act": 2}, "p1": 0.5,

  THE CROSSING IS BETWEEN 0.21 AND 0.22, measured by bisection.  Below it
  the engine spends a preposterior; above it, it does not.  A DECLARED
  VALUE changes how much computation the engine spends per decision --
  #16's route (c), verbatim, shipped.

  (The trade-off is declared as WORLD DATA -- price, batch -- rather than
  uttered inside said@1, which is a real distinction and the reason #16's
  LITERAL claim survives.  But "the reflexive-freeze capability ... is
  unreachable from a wire client" is no longer true as written.)

================================================================
#17 -- observe_batch / observe_counts.  STILL TRUE AT HEAD, verbatim.
================================================================
    {"ok": true, "proto": 1, "models": 9, "namespace_bits": 1.0}
    {"error": "expected tick"}
    {"error": "expected tick"}

  Both verbs refused, exactly as #17 reports and exactly as issue #24 asserts
  in passing.  Unshipped BY DECISION, not oversight: the transport half was
  affirmatively declined ("bundling an unruled wire form would be scope
  creep"), and membrane-wire.md section 6.3 carries an honest UNSHIPPED
  bracket naming this issue.  Nothing to repair; the row is a re-confirmation.

  ONE THING DID MOVE UNDER IT: the cost model #17 argues from.  observe_counts
  was justified by engine-dominant per-tick cost measured on the PRE-exact
  engine; the re-founding changed the enumeration wholesale.  The figure #17
  cites predates 2026-07-25.

================================================================
#15 / #14 / #11 -- no new execution needed; the record decides them.
================================================================
#15: its own filer withdrew the engine-side ask on 2026-07-22 ("we're treating
     #15's engine-side ask as closed by this comment"), the repo records it
     closed ("#15 closed the sitting's loop"), and it is absent from the
     transport pack's open-registers list -- yet it is still OPEN on GitHub.
     A bookkeeping divergence, not a technical one.  Separately, every repro
     recipe in its thread is now REFUSED by the door: evidence-only ticks
     ("the 0.0-dormancy default is dead") no longer serve.

#11: the 2026-07-22 ruling rested on a stated premise -- "the gate conditions
     on A's differential corpus ... and that measurement does not exist".
     THE MEASUREMENT WAS EXECUTED FOUR DAYS LATER: 95k live events, both
     engines recorded, read at the X.5 sitting as "A STAYS CLOSED (demand not
     measured); B STAYS OUT (underpowered by measurement, n_inv = 0)".  OB-12
     is DISCHARGED@dispositions-sitting.  The X.5 sitting further established
     that B cannot be powered by running the shadow longer -- verdicts exist
     only via explicit /feedback calls, so a second verdict SOURCE must be
     deployed first.  None of this was ever posted to #11; its newest comment
     still says the precondition does not exist.

#14: the ruling was SOLICIT -- a re-statement in behavioural terms.  It never
     arrived (40+ days) and nobody re-asked.  Meanwhile the engine it was to
     be re-stated against moved three times, hardest at the re-founding.  The
     issue's own concession ("the shape may dissolve on translation") applies
     more strongly now than when it was written, and the roadmap has since
     demoted the target to post-terminal demand-gated residue.
```

## f5-ab-result.txt

```
=== F5c: THE A/B RESULT -- what the dyadic lever is worth ===
Executed 2026-09-01, HEAD 94fd4eb, two cells run SERIALIZED, one process
at a time, on the same box under the same recorded load.

CONTROLLED: identical population (960, both asserted against the engine's
own hello reply), identical namespace, guards, menu, clock, utility, seed
and stream.  The ONLY difference is theta's binary representation --
  P2real   : the consumer's declared decimals   [0.02, ... 0.9977777777777779]
  P2realDy : the same grid snapped to n/2^10    [1.953125e-2, ... 0.998046875]

  fold depth    P2real ms    dyadic ms   speedup
        50.5        765.1        395.3     1.94x
        51.5        782.4        396.3     1.97x
        52.5        798.7        397.5     2.01x
        54.5        827.4        402.1     2.06x
        56.5        904.7        403.2     2.24x
        59.5        998.1        403.7     2.47x
        69.5       1242.7        406.1     3.06x
        79.5       1476.8        410.7     3.60x
        99.5       1958.7        449.7     4.36x
       119.5       2689.8        513.7     5.24x
       149.5       4264.1        724.8     5.88x
       249.5      14953.9       1560.3     9.58x
       250.5      14979.5       1560.3     9.60x

  two-point growth exponent   P2real  alpha = 1.857
                              dyadic  alpha = 0.857
                              difference    = 1.000

  whole-session wall   P2real 2078.1 s   dyadic 274.7 s   (7.6x)
  peak RSS             P2real 58.1 MB    dyadic 26.3 MB   (2.2x)

THE READING.  The speedup is not a constant: it GROWS with fold depth, from
1.9x at depth 50 to 9.6x at depth 250.  That ratio is a direct measurement.

ON THE MECHANISM, CORRECTED AFTER RUNNING bench/analyze.py (r01's own
estimators, rather than the hand fit these two-point figures came from):
under alpha_raw the dyadic grid does look like it removes a full power of t
(1.840 -> 0.861).  Under alpha_3p it does NOT -- it reads slightly steeper
(2.790 vs 2.440).  Both fit the same curve: alpha_3p separates a constant,
and the dyadic world's cost is MOSTLY constant (c0 = 378 ms) with a growth
coefficient 81x smaller (2.44e-4 vs 1.98e-2).  THE DEFENSIBLE STATEMENT IS
THAT THE GROWTH COEFFICIENT COLLAPSES, NOT THAT THE EXPONENT DROPS BY ONE.
The consequence is unchanged and measured either way: the gap widens with
depth, which is the regime the consumer operates in.

WHAT IT COSTS THEM: nothing in the engine, nothing on the wire, no ruling.
It is a DECLARATION change, and the r01 report already classified this
lever as 'a decision input, not a language change'.  The two safety checks
are in f5-dyadic-lever.txt: every rung moves less than their own declared
_GRID_COLLISION of 5e-4, and the two rungs that carry #19's placement risk
(0.857 the operating rate, 0.864 the shadow p95) stay DISTINCT at 2^-10.

SCOPE, stated rather than assumed:
  - Both cells carry the same box load, and this is a RATIO at identical
    depths on the same hardware, so the load largely cancels here in a way
    it does not for the absolute ms/tick figures.
  - alpha is a TWO-POINT estimate over depths 50-250, one seed, one
    profile.  The difference of 1.00 is clean but it is not claimed as an
    exact law; the falsifier is a second seed and a deeper cell, neither
    run (see the coverage residual).
  - Nothing here reads an acceptance band.  It says what the lever is
    worth, not whether the result is good enough.
```

## f5-dyadic-lever.txt

```
=== F5b: the ONE declaration-side lever the consumer has left ===
Computed 2026-09-01 from the consumer's real theta grid (life-agent
@ ebc5941, world.py theta_grid), embedded exactly as the door embeds it.

The r01 report names two host-side levers that 'change the constant by an
order of magnitude and are decision inputs, not language changes':
  (a) binary-exact grid values (n/2^k) instead of decimals -- worth 100x
      in bits per fold per weight;
  (b) the walk family (rho) -- 78% of the reconstruction's tick at t=1000.

THE CONSUMER HAS ALREADY TAKEN (b): they declare NO walk family at all.
So (a) is the only declaration-side lever they have left -- and nothing in
the corpus measures it on their world.

--- their eight rungs, as the door embeds them ---
    0.02                 num  53b  den  59b  = 112b
    0.05                 num  52b  den  57b  = 109b
    0.18                 num  52b  den  55b  = 107b
    0.339                num  53b  den  55b  = 108b
    0.857                num  52b  den  53b  = 105b
    0.864                num  53b  den  54b  = 107b
    0.95                 num  52b  den  53b  = 105b
    0.9977777777777779   num  51b  den  52b  = 103b
    SUM                  856 bits over the 8 rungs

--- the same grid snapped to the nearest n/2^k ---
    2^-8     122 bits  (7.0x fewer)   worst rung shift 0.00168
    2^-10    142 bits  (6.0x fewer)   worst rung shift 0.00047
    2^-12    184 bits  (4.7x fewer)   worst rung shift 0.00011

--- does it move the rungs past their OWN tolerance? ---
Their frozen rule declares _GRID_COLLISION = 5e-4: two rungs closer than
this are one.  At 2^-10 the worst shift is 0.00047 -- INSIDE that.

--- does it break #19's placement finding? ---
#19's witness: the posterior concentrates on the declared rung KL-nearest
the true rate, which can FALSE-CLEAR a consumer threshold, and evidence
SHARPENS the error rather than repairing it.  The two rungs that carry
that risk here sit 0.007 apart -- 0.857 (the measured operating rate) and
0.864 (the shadow p95).  A dyadic grid must keep them DISTINCT:
    2^-8  : 0.857 -> 0.855469   0.864 -> 0.863281   distinct
    2^-10 : 0.857 -> 0.857422   0.864 -> 0.864258   distinct
    2^-12 : 0.857 -> 0.856934   0.864 -> 0.864014   distinct

READING (the builder's, for the sitting and for the consumer):
a 2^-10 grid costs 6.0x fewer bits per rung, shifts no rung further than
the consumer's own declared collision tolerance, and keeps the two
placement-critical rungs distinct.  It is a DECLARATION change: no engine
work, no wire change, no ruling needed.

STATUS: the bits arithmetic above is EXECUTED.  Its COST consequence is
ARGUED -- rung denominator bits are not the same quantity as the folded
belief state's bits, though the r01 report's model makes the growth
constant a function of exactly these denominators.  Falsifier, and it is
queued: the P2realDy cell (profileP2realDyadic -- the real declaration
with theta snapped to 2^-10 and NOTHING else changed) against the P2real
cell at the same tick count.
```

## f5-provenance-incident.txt

```
=== F5d: AN INCIDENT THE IDENTITY ROW CAUGHT, RECORDED ===
Found 2026-09-01 by the closing verification, not by inspection.

WHAT HAPPENED.  bench/P2Real.hs was generated from life-agent @ ebc5941 at the
start of this round.  The closing run of

    python3 bench/gen-p2real.py --check

came back RED:

    IDENTITY FAIL P2Real.hs differs from its generator's output
    -- own code (@ ebc5941d0ce963a781f85f8b7094e2118da1c5b7, ...
    ++ own code (@ 6f28bf259f0ade7996cdb36bd97a1166c7661213, ...
    -p2realProvenance = "ebc5941d0ce963a781f85f8b7094e2118da1c5b7"
    +p2realProvenance = "6f28bf259f0ade7996cdb36bd97a1166c7661213"

life-agent's HEAD MOVED WHILE THIS ROUND WAS RUNNING (a merge of
r04-q3-correction, landing GD-15 and doc changes).

WHY IT DOES NOT INVALIDATE THE MEASUREMENT, verified rather than assumed:

    $ git -C ~/git/life-agent diff --stat ebc5941 HEAD -- src/life_agent/membrane/world.py
    (empty)
    $ git -C ~/git/life-agent diff --name-only ebc5941 HEAD -- '*.py'
    (empty)

NO PYTHON CHANGED AT ALL between the two commits -- the merge touched only
CLAUDE.md, DECISIONS.md, RULINGS.md and r04-stocktake.md.  And the generated
module is byte-identical apart from the two provenance lines:

    $ diff <(grep -v '<either hash>' P2Real.ebc5941.hs) \
           <(grep -v '<either hash>' P2Real.hs)
    (empty)  -- IDENTICAL apart from the two provenance lines

So the DECLARATION the cells were run against is unchanged, every measured
figure stands, and the only thing that moved is the commit the generator
stamps.  P2Real.hs has been regenerated to the current hash and the identity
row is green.

WHY THIS IS WORTH A TRANSCRIPT.  The identity row did exactly the job the
GENERATOR EXEMPTION gives it: a derived artifact silently drifted from its
source and a mechanical check caught it at the close, where a human reading
the file would have seen nothing wrong -- the declaration LOOKED right, and
was right.  Had world.py actually moved, the same red would have fired for a
reason that DID invalidate the cells, and the two cases are indistinguishable
without running the diff.  That is the argument for the row, made by a live
instance rather than by assertion.

A NOTE ON THE STAMP THAT REMAINS TRUE EITHER WAY: the cells' own build stamps
record proplang's HEAD and src-tree, not life-agent's.  A consumer-side
declaration change is therefore NOT visible in a cell's stamp, and this
identity row is the only thing standing between a moved declaration and a
measurement quietly attributed to the wrong world.  If the bench series lands,
that is an argument for running --check as part of the cell runner, not only
at a close.  Recorded as an observation; not proposed as a row.
```

## f7-gate5-prototype.txt

```
=== F7b: GATE 5 AGAINST THE PROTOTYPE -- the falsifier, EXECUTED ===
Run 2026-09-01 in a throwaway worktree at HEAD 94fd4eb (R-D21: executed once
against a throwaway prototype realization, prototype discarded).

THE PROTOTYPE DIFF -- two lines, exactly as F7 predicted:

    -import PropLang.Membrane (chooseEU, menuAssignments, predictiveBelief,
    +import PropLang.Membrane (menuAssignments, predictiveBelief,
    -                picked <- chooseEU (swNs w) feats (swAtom w) u scored
    +                picked <- policyPick (swNs w) feats (swAtom w) u scored

THE RESULT: cabal test all -j1  ->  EXIT=1.

  12 of 13 suites PASS: pins, lawful-independence, lawful, jointprep, f5,
  exact-properties, exact-acceptance, dyadic, battery, transport, trampoline,
  readout.
  breadth: 19 of 20 rows pass.  ONE FAILURE.

THE BUILDER'S STATED EXPECTATION WAS FALSIFIED, AND IS RECORDED AS SUCH.
Claim C24 predicted no frozen row could change under the re-route.  A row did
go red.  Whether it went red BECAUSE of the change is the attribution question
below, and it is not answered by wanting the answer.

THE FAILING ROW -- drift-a, an ABSOLUTE timing band:

    drift-a the base route's five windowed means and deep/shallow mean ratio
            sit inside the minted bands
    REPORT window [6..30] mean 1532.5 ms
    FAIL: drift window [6..30]: 1532.5 within +/-15% of frozen 431.1

WHAT POINTS AT THE BOX RATHER THAN THE CHANGE (internal to the same run):

  1. b6b PASSED.  It is the RATIO row -- base vs heir measured on the same box
     in the same run -- and it read 1.366 against a bar of 2.0.  A ratio is
     load-invariant in a way an absolute band is not.

  2. b6b's own composition REPORT shows UNIFORM inflation across every column:

         ev      247.6 ms   (frozen  66.2)   = 3.74x
         walks    90.1 ms   (frozen  23.8)   = 3.79x
         ev+ro  1554.2 ms   (frozen 434.5)   = 3.58x
         wire   3266.1 ms   (frozen 832.7)   = 3.92x

     THE DECISIVE ONE IS `ev`.  That column is EVIDENCE FOLDING.  It does not
     touch selection at all, so the prototype's change cannot reach it -- and
     it is inflated 3.74x, the same factor as every other column.  A selection
     change does not uniformly inflate a column it cannot execute.

  3. The box was carrying three processes near 100% CPU during the run (julia
     plus two dbt) on a 4-core/8-thread machine.

  4. This exact class has bitten this repo twice already and is recorded both
     times: the a2d35d9 loud-box incident (parallel suites, drift 1.9060 vs
     1.9960 quiet) and the #19 sitting's contended probe run.

WHAT IS NOT YET ESTABLISHED, AND THE CONTROL THAT SETTLES IT:
The reasoning above is an argument, and an argument is not a measurement.  The
control is running as this is written: the SAME drift row, on the UNMODIFIED
tree, on the SAME box under the SAME load.

    if the control ALSO fails near ~1500 ms  -> load; the change is exonerated
    if the control PASSES near ~431 ms       -> the change is implicated and
                                                F7's reading is WRONG

Result appended below.  Until it is appended, the honest statement is:
GATE 5 DID NOT PASS ON THE PROTOTYPE, one timing row, attribution pending.

=== THE CONTROL, EXECUTED -- attribution SETTLED ===
Same drift row, UNMODIFIED tree (main worktree, HEAD 94fd4eb, clean), same box,
same load, run immediately after the prototype run.

    CONTROL (unmodified): FAIL -- drift window [6..30]: 1562.8 vs frozen 431.1
    PROTOTYPE (2-line):   FAIL -- drift window [6..30]: 1532.5 vs frozen 431.1

THE UNMODIFIED TREE FAILS THE SAME ROW, BY MORE.  Window by window:

    window        prototype    control(unmod)   frozen band centre
    [6..30]        1532.5        1562.8              431.1
    [50..80]       1952.5        2074.1
    [100..130]     2346.4        2458.3
    [150..180]     3432.8        2759.1
    [250..280]     5073.9        5000.9
    deep/shallow    2.1113        1.9110              2.0092

The control is SLOWER in three of five windows and faster in two -- mixed,
i.e. noise-dominated.  And the frozen deep/shallow ratio 2.0092 sits BETWEEN
the two runs (2.1113 prototype, 1.9110 control), which is what two draws from
the same distribution look like.

CONCLUSION: THE RED IS ENVIRONMENTAL.  It reproduces with NO change at all.
The prototype is EXONERATED: the two-line re-route did not cause it, and gate
5's only failure is the box, not the diff.

WHAT THIS DOES **NOT** PROVE -- stated because the temptation is to overread a
clean exoneration:

  It does NOT show that policyPick costs the same as chooseEU on the clockless
  path.  It shows only that THIS red is not attributable to the change.  Under
  a load that inflates every column ~3.6x, the drift row has no power to detect
  a modest cost difference in either direction.  The COST QUESTION F7's
  falsifier opened remains OPEN and UNMEASURED, and the measurement that would
  close it is a quiet-box A/B of the two routes at matched depth -- not run.

A STANDING OBSERVATION FOR THE SITTING (not a finding of this increment):
gate 5 currently CANNOT PASS on this machine under its owner's ordinary
workload, and that is a property of the row's form, not of the tree.  drift-a
is an ABSOLUTE band minted on a quiet box; b6b is a RATIO with a bar, and b6b
passed in BOTH runs (1.366 prototype, bar 2.0).  A ratio cancels a uniform load
factor; an absolute band cannot.  The repo has now paid for this three times --
the a2d35d9 loud-box incident, the #19 sitting's contended probe, and today --
and each time the diagnosis was correct and the row stayed absolute.
```

## f7-pin-scope-transcript.txt

```
=== F7: is the frozen chooseEU pin what makes un-deferring boundary-sized? ===
The filer's sharpened question, #24 verbatim: "If the frozen chooseEU pin
is what makes that a boundary-sized change rather than a routing change,
that is exactly the information we are missing."
Executed 2026-09-01 at HEAD 94fd4eb.

--- (1) The two functions have IDENTICAL type signatures ---
chooseEU :: Namespace -> Features -> Grid
         -> Expr '[Rational, Rational] Rational
         -> [(Features, Belief Int)]
         -> Either String (Maybe (Features, Belief Int))

policyPick :: Namespace -> Features -> Grid
           -> Expr '[Rational, Rational] Rational
           -> [(Features, Belief Int)]
           -> Either String (Maybe (Features, Belief Int))

  Byte-identical apart from the name.  So at the call site the migration
  is ONE IDENTIFIER:
            case swClock w of
              Nothing -> do
                picked <- chooseEU (swNs w) feats (swAtom w) u scored
                Right (Left (maybe o0 fst picked))

--- (2) What g2 actually pins, quoted from the frozen oracle ---

-- The pin's SCOPE is the wire's utility convention (the narrowed
-- degenerate latent: option code bound to 0; utilities read the
-- outcome and non-writable world features). A utility reading a
-- WRITABLE name is a fold artifact under the shipped chooseEU (both
-- sides of every comparison are served the CHALLENGER's assignment,
-- so action-dependent utilities degenerate to ties) — the finding,
-- its demonstration, and the one-sentence route's repair are the
-- boundary pack's register item, not an oracle row.
g2 :: TestTree
g2 = testGroup "g2 policyPick == chooseEU (extensional on the wire convention)"

  g2 pins the TWO FUNCTIONS AGAINST EACH OTHER, directly, by import.
  It says NOTHING about which one Host.hs calls.  A routing change
  leaves every g2 row passing unchanged, because g2 never routes.
  And the pin's own scope note already excludes the case at issue:
  a utility reading a WRITABLE name is outside it, and is 'the boundary
  pack's register item, NOT an oracle row'.

--- (3) Does ANY frozen oracle pin the routing fork itself? ---
$ grep -rn 'swClock' test*/ --include='*.hs'
  (nothing)
  No frozen row references the clockless fork.  The three suites that
  mention chooseEU do so by direct import (Pins, Trampoline) or in a
  comment (Readout).

--- (4) THE DECISIVE SWEEP: could any frozen WIRE row change? ---
Universe DERIVED, not enumerated: every test .hs declaring both a menu
and a utility (only such a world can distinguish the two routes).
    test-breadth/Breadth.hs
    test-readout/Readout.hs
    test-trampoline/Trampoline.hs
    test-transport/Transport.hs

Every said@1 sentence in that universe:
    Breadth.hs:501:    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"*\", [\"get\", \"skill\"], "
    Readout.hs:595:    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"var\", 1]}, "
    Trampoline.hs:468:    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"*\", [\"get\", \"move\"], "
    Trampoline.hs:509:            ++ "\"said\": [\"*\", [\"c\", 0.5], [\"var\", 1]], "
    Transport.hs:74:    ++ "\"utility\": {\"form\": \"said@1\", \"said\": [\"neg\", [\"var\", 1]]}}}"

Only TWO read a writable name via get, and BOTH are immune:

  (a) test-trampoline Trampoline.hs helloClock -- reads writable "move",
      but DECLARES A CLOCK, so it ALREADY routes through policyPick.
      Re-routing the CLOCKLESS arm cannot reach it.  Its own comment
      already carries the mandate-2 sitting flag:
        -- SITTING FLAG (mandate 2): the utility reads the writable "move" —
        -- the R4-pending semantics — but every assertion below is
        -- INSENSITIVE to that ruling (at the uniform first tick both
        -- readings give the externals EU 0, and think wins strictly).
        helloClock :: String

  (b) test-breadth Breadth.hs helloB -- reads writable "skill", and IS
      clockless, but its menu is a SINGLE POINT:
        498:    ++ "\"menu\": [{\"name\": \"skill\", \"grid\": [1]}], "
      chooseEU on a singleton never compares anything --
        chooseEU ns feats atomG u cands = case cands of
          [] -> Right Nothing
          (c0 : rest) -> Just <$> foldl' step (Right c0) rest
      the fold's rest is empty, so no env is built and no comparison
      happens.  Substitution and non-substitution are indistinguishable
      on one option.

  Every OTHER clockless wire row's utility reads only the outcome or a
  NON-writable feature -- exactly g2's pinned scope, where policyPick
  and chooseEU are EXTENSIONALLY EQUAL by the frozen pin itself.

--- CONCLUSION (the builder's reading, stated as a claim to be ruled) ---
The frozen chooseEU pin is NOT what makes un-deferring boundary-sized.
g2 pins the functions, not the routing; nothing frozen pins the fork;
and no frozen wire row can change outcome under the re-route, because
each is either inside the pinned scope (equal by the pin) or has a
one-point menu (no comparison), and the single writable-utility
multi-option world already declares a clock.

WHAT THIS DOES NOT ESTABLISH: that gate 5 passes after the change (not
made -- the builder does not implement ahead of an oracle); that the
kill matrix is unaffected (OB-33 fires if this lands -- register R3);
or that the change SHOULD be made.  It removes ONE uncertainty, the one
the filer named, and it is the author's to rule.

--- (5) ADDENDUM: the sweep tightens by one ---
test-transport/Transport.hs is in the universe (it declares a menu and a
utility) but its frozen helloLine is REFUSED by the shipped engine:

    $ <Transport.hs helloLine> | proplang-host
    {"error": "bad hello"}

Two reasons, both post-dating the suite: the utility uses ["neg", ...], one of
the four forms that left the alphabet at the exact re-founding; and the world
declares no codebooks.theta, which the door has required since the same
boundary.

The suite is nonetheless GREEN, correctly, and for a reason worth recording:
its expectation is DERIVED, not hand-copied --

    expectedReplies = snd (mapAccumL serveLine hostStart requests)
    -- THE EXPECTATION: the frozen pure core itself, folded over the same
    -- lines (R-D20 -- never a hand-copied literal)

-- so it asserts that the SUBPROCESS says whatever the LIBRARY says, per line,
over pipes.  Both refuse identically, the row passes, and the suite goes on
measuring the thing it exists to measure (per-line request-reply delivery,
issue #18's fix).  This is the one-generator law paying for itself: a
hand-copied expected reply would have gone red at the re-founding and sent
someone hunting a transport bug that did not exist.

CONSEQUENCE FOR THE SWEEP: Transport's world never reaches selection at all,
so it cannot distinguish the two routes.  The universe of frozen worlds that
could is THREE, not four -- Readout (utility ["var",1], no writable name, and
so inside g2's pinned scope), Trampoline (writable, but clocked), Breadth
(writable, but a one-point menu).  The conclusion is unchanged and its support
is one world narrower.

NOT A DEFECT, recorded as an observation: the transport suite's world is a
fossil of the pre-exact wire.  It is harmless because of what the suite
asserts, and repairing it would change nothing it measures.

--- (6) THE EXACT SIZE OF THE CHANGE IN src/ ---
policyPick is ALREADY imported by Host.hs -- no import is added:

    import PropLang.Membrane (chooseEU, menuAssignments, predictiveBelief,
                              mintQ, policyPick, reindexUtility, substW,
                              weakenE, withRows)

chooseEU occurs FOUR times in Host.hs and only ONE is code:

    26:  --   * selection runs through Membrane.chooseEU -- the SENTENCE route   [comment]
    58:  import PropLang.Membrane (chooseEU, ...)                                [import]
    377: -- the SENTENCES (chooseEU when no clock is declared -- byte-identical   [comment]
    426:                picked <- chooseEU (swNs w) feats (swAtom w) u scored     [THE CALL]

So the migration is:
    (a) line 426: chooseEU -> policyPick                     [one identifier]
    (b) line 58: drop chooseEU from the import list          [else -Werror
                                                              unused-import]
    (c) lines 26 and 377: two comments go stale              [not compile-
                                                              blocking, but
                                                              this repo does
                                                              not leave those]

AND THEN chooseEU HAS ZERO src CONSUMERS.  It stays exported from Membrane and
stays pinned -- test-pin's SELECTION row calls it directly by import, and
test-trampoline's g2 pins it against policyPick.  So it is NOT deleted; it
becomes an in-library function the frozen oracle pins and the host no longer
routes through.

THAT DISPOSITION ALREADY HAS A PRECEDENT IN THIS REPO, one boundary old: the
#19 sitting's D3 ruled pwLadderCap/Purchase.hs FROZEN-IN-PLACE with its pins
dispositioned at the pin site, deletion DECLINED because its proof was not run
and not claimed.  The same shape, the same reasoning, and the sitting that set
it is the one immediately preceding this.
```

## opening-boundary-audit.txt

```
=== boundary-audit at the #24 sitting's OPENING ===
Run 2026-09-01 at HEAD 94fd4eb, clean tree.

=== boundary-audit (screening; first firing = the step-6 boundary) ===
--- M5-row: ruling citations vs definition sites ---
M5-row: 0 flagged (IDs cited >=4 with no definition-shaped line)
--- H-row: wire/membrane doc symbols resolve outside those docs ---
H-row: 0 flagged (of 68 symbols scanned)
--- OB-row: obligations ledger vs closed boundaries ---
OB-row: 0 flagged (open obligations against closed boundaries)
banked-failure row: alphabet last moved at c2ca82c (2026-07-25T18:44:21+03:00)
banked-failure row: 0 flagged
--- standing observations ---
note: test-writeup/check.sh carries its own G2 RECORD row (run it for the state); cabal test-suite stanzas now: 13
prose-claim triage: 43 quantifier-bearing line(s) in doctrine-author-pack.md - sweep against its claims register (triage input, not a verdict)
=== boundary-audit done: M5=0 H=0 OB=0 BF=0 ===

CLEAN at the opening.  Note the banked-failure row's date: the alphabet last
moved at c2ca82c (2026-07-25, the exact re-founding).  That date is load-bearing
for F4 -- every disposition on the five standing open issues PREDATES it.
```

## opening-lint.txt

```
=== prefreeze-lint at the #24 sitting's OPENING ===
Run 2026-09-01 at HEAD 94fd4eb, clean tree (git status: only untracked bench/).
Recorded BEFORE any r1 work, so this is the state the sitting inherits.

=== prefreeze-lint (tools/, unfrozen; first ordered at the step-6 sitting) ===
PASS  L1 forbidden-tokens-by-glob: 9 src files clean (frozen gate 4 names 5)
PASS  L2 ASCII test names across test*/
PASS  L3 MANIFEST.sha256: 196 rows verified
PASS  L4 all 70 tags verify
FAIL  L5 doctrine-author-pack.md SAT section lacks -Wall
FAIL  L5 doctrine-author-pack.md SAT section lacks -Werror
FAIL  L5 doctrine-author-pack.md SAT section lacks -Wincomplete-patterns
FAIL  L5 doctrine-author-pack.md SAT section lacks -Wincomplete-uni-patterns
PASS  L6 no grid re-declaration flags (advisory heuristic)
PASS  L7 full-corpus overlay build: every test .hs builds against new src
PASS  L8 recorded repairs: 0 hash(es), 0 (hash,file) pair(s) verified in doctrine-author-pack.md
PASS  L9 tag-message-is-a-file: every -m/--message tag command sits in an executed kit
PASS  L10 door deferral: universe = Host.hs only; 6 frontier symbols absent from Host code
=== prefreeze-lint: 4 FAIL, 0 WARN ===

NOTE: the #19 sitting's own pack records "prefreeze-lint 0 FAIL 1 WARN" AT THESE
EXACT BYTES (doctrine-author-pack.md, verification item 8).  The tree has not
moved -- `git diff HEAD` is empty for both tools/prefreeze-lint.sh and
doctrine-author-pack.md.  See F2.

L4 reads 70 tags here against the 68 recorded at the sitting: doctrine-sitting-r0
and -r1 are the two new ones, minted at and after that commit.  Expected.
```

## r0-tag-msg.txt

```
chooseeu-sitting-r0 -- the #24 sitting's ruling: R-SHAPE ADOPTED (rev 2)

This signed tag is the author's adoption of the shape ruling at
chooseeu-sitting/drafts/shape-ruling.md, REV 2, as committed at the
commit this tag covers -- the ruling round of 2026-09-02 applied in
full.  The register:

1. R1 = (3) IN THE THIRD SHAPE: the pairwise-substituting fold.  The
   normative definition stays the one-sentence chooseKS selection
   (Syntax.hs -- in the library, exported, pinned; the agent
   criterion).  policyPick keeps its name and signature; its body
   becomes the fold, pinned extensionally to the sentence route in
   the same increment (the optimisation law; g2's successor one
   level up).  Host's clockless arm routes through policyPick;
   chooseEU goes frozen-in-place, exported, zero src consumers.

2. THE CLAUSE-5 WORD: INCLUDE -- the clock path rides.  pickWire
   routes through the same fold.  Its pin is clause 4b's family with
   pickWire routed through it; the trampoline rows staying green is
   a REGRESSION CHECK, never the pin (the ruling round's correction,
   installed in the clause).

3. THE SEEDED-DEFECT ENUMERATION SETTLED AT SIX -- two four-member
   classes, one correct member each, three defects each:
     env-wiring:  both-challenger / both-incumbent / swapped
                  (+ correct)
     comparison:  Ge (tie-flip) / Lt (inversion) / Le
                  (+ Gt, the shipped strict form)
   The identifier reversion is clause 4a's PATCH FORM of
   both-challenger (extensionally equal on every world, a different
   diff) and seats no seventh.  Amendment 3's minimal separating
   family quantifies over these six plus one width past the old
   cliff.  The env-wiring defects are demonstrated red on #24's
   world (r3-f13); the comparison-class reds are the oracle phase's
   to construct (R-RED: a red is constructed, never owed -- the tie
   world for Ge/Le, any distinguishing world for Lt).
   [AUTHOR: if the round's "six" meant a different enumeration,
   amend this block before signing -- the signature adopts the
   enumeration as printed.]

4. RIDERS, AS DRAFTED IN CLAUSE 6: OB-24 discharged at the
   increment's close; OB-33's kill matrix fires; the six red-team
   mandates; FL-1 installed as a dated HISTORY bracket, FL-2, FL-3;
   L5 rev 2 with the four-red demo; OB-30's second and third
   instances recorded, not discharged; R5's two-arrow
   published-record row; drift-a re-minted to RATIO form; MANIFEST
   re-signed by the author; the increment's tag by -F file under
   the selection-freeze-r* family.

EVIDENCE OF RECORD: probes A1/A2 (r2-f10, r2-f11), the third-shape
demonstration with the reversion red firing (r2-f12), the env-wiring
class demonstration (r3-f13: three mutants, one world, all red).
Pack: chooseeu-author-pack.md parts I-III; the ruling round of
2026-09-02 quoted verbatim at III.1.

WHAT THIS TAG OPENS: the (3) increment, ORACLE-FIRST, per
shape-ruling.md's closing section.  Issue #24 stays open until the
increment's close ships the routing; it closes citing that freeze,
not this tag.  The brain-seam demand registration is the gate
owner's separate act (drafted at
chooseeu-sitting/drafts/brain-seam-demand.md) and rides no part of
this tag.

CUSTODY: sitting record and this message drafted by the builder at
the author's "help me close" (2026-09-02); the tag minted by the
author's own key from the author's shell via
chooseeu-sitting/close.sh.  The tag message is a FILE, never a
shell string; its bytes are fixed by the commit this tag covers.
```

## r2-f10-term-size.txt

```
r2 probe A1 — term size (STATIC), executed 2026-09-02 at HEAD 94fd4eb
build: ghc -O1 -Wall -Werror -isrc -ibench bench/ProbeTermSize.hs (clean)
box: thinkpad (static counts are box-independent by construction)

ProbeTermSize (the #24 sitting r2, A1) — STATIC term counts at 94fd4eb
tree = nodes evalx walks; dag = distinct heap nodes; pick/pairSub rows
are PER-COMPARISON constants of the two O(width) routes, x(w-1) total.

w=4   tournament tree=180                    dag=50       pick/cmp=22 (x3 cmps=66)  pairSub/cmp=22 (x3 cmps=66)
w=8   tournament tree=3628                   dag=106      pick/cmp=22 (x7 cmps=154)  pairSub/cmp=22 (x7 cmps=154)
w=16  tournament tree=950124                 dag=218      pick/cmp=22 (x15 cmps=330)  pairSub/cmp=22 (x15 cmps=330)
w=32  tournament tree=62277025516            dag=442      pick/cmp=22 (x31 cmps=682)  pairSub/cmp=22 (x31 cmps=682)
w=64  tournament tree=267477789068788497900  dag=890      pick/cmp=22 (x63 cmps=1386)  pairSub/cmp=22 (x63 cmps=1386)

growth per doubling (tree, then dag):
  w=4 -> w=8 : tree x20.16, dag x2.12
  w=8 -> w=16 : tree x261.89, dag x2.06
  w=16 -> w=32 : tree x65546.21, dag x2.03
  w=32 -> w=64 : tree x4294967315.03, dag x2.01

reading: tree ~2^w with dag staying polynomial = the cliff is
EXPRESSION DUPLICATION (an implementation artefact of the chooseKS
expansion under a tree-walking evalx), not intrinsic to substitution;
the pairSub row shows the substituting per-comparison term is a
width-independent constant.

fit: tree(w) = ~14.5 * 2^w exactly (65536*14.5 = 950k at w=16,
4.29e9*14.5 = 6.2e10 at w=32); dag(w) = ~28*w.

note on F9's measured 6.27x (not ~2900x, the node ratio at w=16):
evalx's If evaluates ONE branch, so the WALKED subtree is the
win/loss-pattern-dependent realization of the static tree — the
static count is the structure, the timing is one path through it.
Both say the same thing: the growth is the expansion's, not
substitution's.
```

## r2-f11-state-bits.txt

```
r2 probe A2 — qbits of the folded state vs t, executed 2026-09-02 at HEAD 94fd4eb
build: ghc -O1 -Wall -Werror -isrc -ibench bench/ProbeStateBits.hs (clean)
box: thinkpad.  The fold is BenchTest t5's own (mirror == engine
metaPosterior, Rational ==, by the frozen t5c row), seed 7.

ProbeStateBits (the #24 sitting r2, A2) — qbits of the folded state vs t
(the mirror's weights == the engine's metaPosterior, Rational ==, by t5c)

P1        t=100   raw: max=319      total=2015        normalized: max=226      total=1789        ss-control=19
P1        t=200   raw: max=641      total=3990        normalized: max=470      total=3663        ss-control=22
P1        t=400   raw: max=1281     total=7944        normalized: max=948      total=7364        ss-control=25
P1        t=800   raw: max=2544     total=15845       normalized: max=1874     total=14633       ss-control=28
P1        t=1600  raw: max=5088     total=31648       normalized: max=3764     total=29343       ss-control=31

P2realNC  t=100   raw: max=11222    total=10142238    normalized: max=11438    total=10858575    ss-control=20
P2realNC  t=200   raw: max=22431    total=20268405    normalized: max=22860    total=21713662    ss-control=22

P2realNC t=400: STOPPED, NOT MEASURED — the builder's choice, printed
per the no-silent-caps law (the F9 w32 precedent).  The classification
was decided at the doubling: 20268405/10142238 = 1.999, and P1's five
checkpoints run the same line through t=1600 with no flattening.  The
stopped cell had run ~15 min at 97% CPU for its third point — the
growing per-tick cost of the O(t) state is itself the finding's
operational face.  (A first run of this probe was killed at 10 min for
SILENT BUFFERING — no output row had flushed — and repaired to
line-buffered before this run; recorded as an instrument incident.)

READING: LINEAR on both profiles.  P1 (dyadic 16ths): total qbits
2015 -> 31648 across t=100 -> 1600, ~19.8 bits/tick, vs the
sufficient-statistic control 19 -> 31 (O(log t)).  P2realNC (the
owner's real declaration, decimal grids): 10.1M bits at t=100, 20.3M
at t=200 — ~101k bits/tick of pure representation growth, control
20 -> 22.  The folded posterior carries O(t) bits where the decision
problem needs O(log t); alpha_3p measured the arithmetic
representation.  The verdict's conditional is now a measurement.
```

## r2-f12-pairsub-proto.txt

```
r2 Phase B — the third shape (pairwise AND substituting), PROTOTYPE RUN
Executed 2026-09-02 at HEAD 94fd4eb; R-D21 throwaway (ProtoPairSub.hs,
compiled ghc -O1 -Wall -Werror -isrc -ibench, clean; DELETED after this
transcript).  Total wall for everything below: 2.9 s, thinkpad.

ProtoPairSub (the #24 sitting r2, Phase B) — the third shape, executed

D1 — #24's world (act=1 worth 10, act=2 worth 100, act=3 worth 50):
  chooseEU   (shipped)   -> [("act",1 % 1)]
  chooseEUsub (3rd shape)-> [("act",2 % 1)]
  policyPick (tournament)-> [("act",2 % 1)]
D2 — the kill-law red (reversion to the challenger-env comparison):
  REVERTED               -> [("act",1 % 1)]
D4 — tie convention (all arms worth 10):
  chooseEU               -> [("act",1 % 1)]
  chooseEUsub            -> [("act",1 % 1)]
  policyPick             -> [("act",1 % 1)]

D3 — agreement chooseEUsub == policyPick (per tick-features):
  P2 (act guarded): sub=[("act",0 % 1)] policyPick=[("act",0 % 1)] [AGREE]  (chooseEU=[("act",0 % 1)])
  P2 (act guarded): sub=[("act",0 % 1)] policyPick=[("act",0 % 1)] [AGREE]  (chooseEU=[("act",0 % 1)])
  P2 (act guarded): sub=[("act",0 % 1)] policyPick=[("act",0 % 1)] [AGREE]  (chooseEU=[("act",0 % 1)])
  P2 (act guarded): sub=[("act",0 % 1)] policyPick=[("act",0 % 1)] [AGREE]  (chooseEU=[("act",0 % 1)])
  P2 (act guarded): sub=[("act",0 % 1)] policyPick=[("act",0 % 1)] [AGREE]  (chooseEU=[("act",0 % 1)])
  P2realNC: sub=[("act",4 % 1)] policyPick=[("act",4 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC: sub=[("act",4 % 1)] policyPick=[("act",4 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC: sub=[("act",4 % 1)] policyPick=[("act",4 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC8: sub=[("act",8 % 1)] policyPick=[("act",8 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC8: sub=[("act",8 % 1)] policyPick=[("act",8 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC8: sub=[("act",8 % 1)] policyPick=[("act",8 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC16: sub=[("act",16 % 1)] policyPick=[("act",16 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC16: sub=[("act",16 % 1)] policyPick=[("act",16 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC16: sub=[("act",16 % 1)] policyPick=[("act",16 % 1)] [AGREE]  (chooseEU=[("act",1 % 1)])
  P2realNC32: policyPick SKIPPED (walked term ~14.5*2^32 nodes
  worst-case, probe A1); chooseEUsub alone:
  P2realNC32: chooseEUsub=[("act",32 % 1)]
  P2realNC32: chooseEUsub=[("act",32 % 1)]

READINGS:
  D1 reproduces F1's wire results at the library route: the shipped
  chooseEU returns the head against a declared 10x argmax; the third
  shape and policyPick both return the argmax.
  D2 is the future pin row's seeded defect, demonstrated red: reverting
  the comparison to the challenger-env form flips #24's world back to
  the head.  (The kill-law correction: the pin row pins the NEW
  behaviour on #24's world, never equality on the agreeing corpus.)
  D3: 14/14 AGREE with policyPick, widths 3/4/8/16, act-guarded and
  act-unguarded worlds; w=32 policyPick SKIPPED (printed, with reason);
  chooseEUsub at w=32 is instant.  On the real declaration the two
  substituting routes pick the top-value act while chooseEU picks the
  head -- the #24 mechanism live on the consumer's own world shape.
  D4: tie convention identical (first-listed incumbent, strict Gt).
  D5: env-independence after substW asserted on EVERY substituting
  comparison (challenger's vs incumbent's cover) -- no violation fired.

NOTE (agreement is also arguable, and the argument matches): chooseKS
folds first-listed-incumbent with strict-Gt displacement -- the SAME
fold convention as pairFold; the demonstrations above are the executed
witness, the shared convention the reason.
```

## r3-f13-env-wiring.txt

```
F13 — THE ENV-WIRING CLASS ON #24's WORLD ("three mutants, one world")
======================================================================
Date: 2026-09-02, the r3 round (the ruling round's order: "the
half-reversions produce a tie on #24's world ... so #24's world likely
kills them too, but demonstrate it rather than argue it -- three
mutants, one world, minutes").
HEAD: 8d7e1c0.  Nothing frozen touched.  ghc 9.10.3.

PROTOTYPE PROVENANCE (R-D21).  The r2 prototype (ProtoPairSub.hs,
transcript r2-f12) was deleted per R-D21.  For this run it was
RECONSTRUCTED FROM THE SESSION RECORD'S OWN WRITE COMMAND -- the
heredoc that created it plus the one recorded repair (the redundant
foldl' import drop) -- i.e. derived from the same generator that
produced the r2 file, not re-written from memory.  Reconstructed base
sha256 (first 16): d2b965b21ab32527.  (r2-f12 recorded no hash; this
line is the base's hash going forward.)  The r3 extension patch, in
full:
  - CmpMode grows two constructors beside the r2 pair, completing the
    ruling round's four-member env-wiring class:
      Substituting          -- correct: each side its OWN assignment
      RevertedChallengerEnv -- both sides under the CHALLENGER's (shipped)
      BothIncumbentSub      -- both sides under the INCUMBENT's
      SwappedSub            -- each side under the OTHER's
  - their picks, same 22-node shape, wiring only:
      BothIncumbentSub: If (Gt (Expect (Var Z) (substW iFeats uB))
                               (Expect (Var (S Z)) (substW iFeats uB))) ...
      SwappedSub:       If (Gt (Expect (Var Z) (substW iFeats uB))
                               (Expect (Var (S Z)) (substW cFeats uB))) ...
  - the env-independence assertion widened from Substituting-only to
    every substW-based mode (RevertedChallengerEnv alone exempt -- it
    is env-DEPENDENT by construction, that is the defect)
  - main: the F13 block (below).
Patched sha256 (first 16): cc043d89e7d8fd7e.  Compiled under the frozen flag set
(ghc -O1 -Wall -Werror -isrc -ibench).  DELETED after this transcript.

RESULT (verbatim, the #24 block):
ProtoPairSub (the #24 sitting r2, Phase B) — the third shape, executed

D1 — #24's world (act=1 worth 10, act=2 worth 100, act=3 worth 50):
  chooseEU   (shipped)   -> [("act",1 % 1)]
  chooseEUsub (3rd shape)-> [("act",2 % 1)]
  policyPick (tournament)-> [("act",2 % 1)]
D2 — the kill-law red (reversion to the challenger-env comparison):
  REVERTED               -> [("act",1 % 1)]
F13 — the full env-wiring class on #24's world (r3; "three mutants, one world"):
  BOTH-CHALLENGER (=D2)  -> [("act",1 % 1)]
  BOTH-INCUMBENT         -> [("act",1 % 1)]
  SWAPPED                -> [("act",1 % 1)]
  (pin row expects the declared argmax [("act",2)]; anything else is the red)
D4 — tie convention (all arms worth 10):
  chooseEU               -> [("act",1 % 1)]
  chooseEUsub            -> [("act",1 % 1)]
  policyPick             -> [("act",1 % 1)]

READING.
1. ALL THREE DEFECTIVE WIRINGS ARE KILLED BY THE 4a ROW.  The pin row
   expects the declared argmax [("act",2)] (act=2 worth 100); every
   defective wiring returns the head [("act",1)].  One world, three
   reds.
2. TWO MECHANISMS, DISTINGUISHED.  BOTH-CHALLENGER and BOTH-INCUMBENT
   kill by TIE: both Expect terms read the SAME assignment, and #24's
   utility is belief-blind (the Mul-by-0 belief term), so the terms
   are exactly equal, strict Gt never fires, and the incumbent
   survives every step -- the ruling round's prediction ("incumbent's
   EU evaluated under the challenger's assignment equals the
   challenger's -- head survives") confirmed on both half-reversions.
   SWAPPED kills by INVERSION: the comparison computes
   u(incumbent's act) > u(challenger's act), so a challenger is
   promoted only when the incumbent is strictly BETTER; on values
   10/100/50 the head is the minimum, nothing promotes, head wins.
   (On a world whose head is neither argmax nor argmin the swapped
   wiring can land on a third answer -- mechanically distinct -- but
   the pin row needs no such world: one world kills all three.)
3. THE ASSERTION STAYED SILENT.  The widened env-independence check
   (evaluate each pick under both covers, require equality) fired on
   no cell -- the substW-based wirings, defective or not, are fully
   substituted, so their defects are WIRING defects, not
   env-dependence defects; only the identifier reversion is
   env-dependent.
4. REGRESSION: the r2 results are unchanged under the extended
   prototype -- D1 (chooseEU head / third-shape argmax / policyPick
   argmax), D4 tie convention identical across all three routes, and
   the D3 agreement sweep 14/14 AGREE, zero refusals, the w=32
   policyPick cells SKIPPED as at r2 (probe A1's ~14.5*2^32 walked
   worst case; printed, per no-silent-caps).

CONSEQUENCE FOR THE PIN SUITE (shape-ruling.md clause 4b as amended):
the env-wiring class is enumerated at birth with its three defective
members demonstrated red on #24's world -- the amendment-1 obligation
("demonstrate it rather than argue it") is EXECUTED, and the claim
"#24's world likely kills them too" is promoted from ARGUED to
EXECUTED with this transcript as its witness.
```

---

# DRAFTS — nothing here is applied; all await the author's key

## brain-seam-demand.md

DRAFT -- the brain-seam demand registration.  THE GATE OWNER'S ACT,
never the builder's (the ruling round of 2026-09-02: "Whether you
register it is your act, not the builder's ... Register it, date it,
and let it queue").  NOT FILED.  Suggested venue: a new proplang
issue filed under the owner hat, so the demand enters the same
two-sided gate every deferred demand uses (#24's shape: demand +
measurement, both attached).

----------------------------------------------------------------
Title: demand: a bounded representation of the folded state (the
Credence brain-seam cutover's real gate)
----------------------------------------------------------------

**Demand, registered and dated (2026-09-02).**

The Credence brain-seam cutover gate was posed against the
fold-depth acceptance band (`bench/bench-fold-depth-r01.md`).  The
r02.4 falsifier (`chooseeu-sitting/r2-f11-state-bits.txt`,
re-runnable) shows the quantity that band would measure is an
ARTEFACT: the folded posterior's qbits grow LINEARLY in t (~19.8
bits/tick on the already-dyadic profile; ~101k bits/tick on the real
declaration, ratio 1.999 at the doubling) because the exact fold
carries the full likelihood product in its rationals.  `alpha_3p`
measured the arithmetic representation, not the decision problem.
The dyadic lever does not rescue the operating point -- it shrinks
the coefficient, the linearity survives (r02.4 as amended at
`5008fb6`).

**What is demanded:** a representation of the folded state whose
size does not grow with t on a const-family exchangeable stream --
the bounded-sufficient-statistics observation banked at r02.4 -- so
the cutover gate can be read against the decision problem instead of
the representation.

**Measurement attached:** the F11 transcript above; bench r02.4.

**Gate discipline:** this demand queues POST-TERMINUS through the
two-sided gate (measurement + registered demand, both present
above), exactly as #24 did.  It does not re-open the roadmap; any
boundary that serves it is a new roadmap boundary under P5's
single-site clause.  Left unregistered, the cutover would stall
silently -- a band nobody may fill on a quantity nobody may read;
this registration is the honest queue entry.

## FL-repairs.txt

```
DRAFTS — the three frozen-layer repairs.  NOT APPLIED.
FL-1 and FL-2 are manifest-covered (membrane-wire.md, CLAUDE.md), so the edit
and the MANIFEST re-sign are the author's key.  FL-3 is outside the manifest.

================================================================
FL-1 — membrane-wire.md section 2, the `menu` bullet
FORM: in-place, the falsified reading quoted inside its own repair
      (the normative-prose form the FROZEN-LAYER INVENTORY clause names)
INSERT: immediately after the bullet's closing sentence, which currently ends
        "...trampoline g2 pins the composition on the wire's utility
        convention."
================================================================

  > [REPAIRED at the #24 sitting, 2026-09-01.  The paragraph above described
  > `Membrane.policyPick`'s substitution semantics -- "each option's utility
  > reading the option's OWN assignment by expansion" -- as THE selection
  > route, unconditionally, and demoted `chooseEU` to "the binary special
  > case".  That is the reading a consumer plans against, and it is wrong for
  > a world that declares no clock: life-agent lost a migration checkpoint to
  > exactly this (issue #24).  The correction did exist, but 27 lines
  > below -- the bullet ends at line 95, the correction sits at line 122 --
  > inside the OPTIONAL `clock` bullet, as "ABSENT means the shipped
  > selection, byte-identically" -- decodable only by a reader who already
  > knows that "the shipped selection" is the NON-substituting one.  Stated
  > here, where menus are read:]
  >
  > A CLOCKLESS WORLD SELECTS THROUGH `Membrane.chooseEU`, AND ITS COMPARISON
  > DOES NOT SUBSTITUTE.  `chooseEU` builds ONE environment, from the
  > CHALLENGER, and evaluates both candidates' utilities in it -- so a `get`
  > on a menu name reads the challenger's assignment on both sides,
  > per-action LEVELS cancel, and only BELIEFS differentiate the options.  A
  > world whose beliefs are act-blind therefore ties every pair and returns
  > the option space's head.  `policyPick`'s substitution semantics are
  > reached ONLY when the world declares a `clock` row.
  > (`src/PropLang/Host.hs` at 94fd4eb, the binding `actOrThink`:
  > `case swClock w of Nothing -> chooseEU ...; Just (price, d) -> ...
  > pickWire ...`.)

NOTE: if the sitting rules R1 option (3) -- un-defer and route clockless
worlds through policyPick -- this repair inverts: the original sentence
becomes TRUE and this bracket becomes the historical record of when it was
not.  Draft accordingly at the close; do not install both readings.

[AMENDED 2026-09-02, after the verdict.  R1 IS (3), in the THIRD SHAPE
(pairwise AND substituting -- the r2 pack).  Under that shape the frozen
`menu` bullet's original sentence is SIMPLY TRUE as written -- `chooseEU`
becomes the binary special case of the substituting selection -- so FL-1
installs as a dated HISTORY bracket recording the period during which the
sentence was false (2026-07-27 trampoline-freeze to the (3) increment's
close) and the consumer checkpoint lost to it (#24), NOT as a correction
of the standing text.  The drafted correction text above becomes the
BODY of that historical bracket.  Install at the (3) increment's close,
one reading only.]

================================================================
FL-2 — CLAUDE.md, the Porting order's last paragraph
FORM: in-place, falsified sentence quoted inside the repair
REPLACES: "The roadmap re-opens at the hosts boundary (HOSTS_PLAN, c65a386):
          ... each gated as HOSTS_PLAN section 9 records."
================================================================

     [REPAIRED at the #24 sitting, 2026-09-01.  This paragraph read "The
     roadmap re-opens at the hosts boundary (HOSTS_PLAN, c65a386) ... each
     gated as HOSTS_PLAN section 9 records", and routed the live roadmap
     through a document that has since been moved to archive/ and that opens
     by declaring itself HISTORICAL and binding "on nothing current" -- the
     engine it describes was demolished at the step-3 sentence freeze.  H and
     D shipped (govhost-freeze, d-freeze/d-close); A's gate was read and did
     NOT fire (OB-12's differential run, 95k live events, X.5 ruling 7:
     A STAYS CLOSED, B STAYS OUT at n_inv = 0); A's substance landed anyway
     under the later architecture (w3-freeze-r1's K-ary arity, the OB-19
     heir's enumeration breadth).  The falsified pointer is quoted here and
     replaced:]
     THE LIVE ROADMAP IS EXACT_PLAN.md section 13.0, THE DESTINATION MAP,
     installed verbatim from the author's directive of 2026-07-26 "so the
     roadmap lives in the tree, never in a transcript".  Its steps 1-4 are
     closed (the X.5 sitting; OB-12's run; the trampoline boundary, the last
     language increment; the completeness suite).  ONE ITEM REMAINS: step 5,
     the demonstration tier -- the A-gate reading with OB-12's result in
     hand, the benchmark, and the paper.  AFTER 5 THE ROADMAP TERMINATES, and
     everything else is named demand-gated residue re-entering only through
     the two-sided gate with a measurement.  archive/HOSTS_PLAN.md is
     retained as historical record only.

================================================================
FL-3 — EXACT_PLAN.md, the status header
FORM: a dated supersession note; the superseded words KEPT
      (the close-date-document form)
INSERT: immediately after the existing italic status block
================================================================

  > **[SUPERSEDED 2026-09-01, at the #24 sitting.**  The status line above
  > reads "Status: PROPOSAL.  It opens nothing by itself", and that was true
  > when written.  It is not true now: this document was EXECUTED --
  > exact-freeze-r0 / r0a / r1 -- and grew into the live boundary record.
  > Section 12 is the Phase-2 work order, section 13 the trampoline boundary
  > and THE DESTINATION MAP (the live roadmap, installed verbatim from the
  > author's directive of 2026-07-26), section 14 the completeness suite,
  > section 15 the wire docket.  The original words are kept above as the
  > record of what this file was at its writing.**]**
```

## issue-postings.md

DRAFTS — issue postings.  NOT POSTED.  Posting is the author's act (these are
outward-facing statements to consumers, under the author's account).

================================================================
#11 — post OB-12's executed reading and dispose
Priority: HIGHEST value per unit cost on the docket.  Zero engine work; the
record already decided it; only the posting is missing.
================================================================

> **The premise this issue's ruling rested on no longer holds — and the
> measurement that replaced it has been read.**
>
> The 2026-07-22 ruling deferred increment B because *"the gate conditions on
> A's differential corpus ... and that measurement does not exist."* It was
> executed four days later: 95k live events, both engines recorded, 94%
> grounded. The reading, ruled at the X.5 sitting (ruling 7):
>
> - **A stays closed** — the demand was NOT measured on 95k live events.
> - **B stays out** — underpowered *by measurement*, not by argument: the
>   two-stream subcorpus is empty, `n_inv = 0`. The evidence file holds 8
>   human verdicts against 143k decisions.
>
> `OB-12` is `DISCHARGED`. Your own figure from the demand side — *"14
> verdicts total in five weeks"* — is the same fact.
>
> **The part worth your planning time:** the sitting also established that B
> **cannot be powered by running the shadow longer**. User-responded records
> exist only via explicit `/feedback` calls — there is no passive verdict
> stream — so powering B requires first deploying a second verdict source (an
> LLM-judge or reviewer channel), *which is exactly the evidence shape B
> itself would model.* More traffic will not move this gate; a second stream
> is the only thing that will.
>
> The polarity-inversion demand itself is registered and unchanged. It
> re-enters through the two-sided gate with that measurement, not before.
>
> Apologies that this sat unposted for five weeks — the reading existed from
> 2026-07-26 and the issue was never updated.

================================================================
#16 — a correction to a correction, and a route that has since shipped
Priority: HIGH.  A posted comment on this thread is FALSE at HEAD and is
actively instructing a consumer to use four forms the wire refuses.
================================================================

> **Correction — my own comment on this thread is now wrong, and in a way
> that will break your client.**
>
> On 2026-07-22 I told you the wire "now speaks **thirteen** forms (`/`,
> `log`, `exp`, `neg` landed at W4 ... all four now ACCEPT)". That was true
> when written and is **false at HEAD**. Those four left the alphabet at the
> exact re-founding on 2026-07-25 — three days after I posted it. Re-executed
> just now against the shipped host, one hello per form:
>
> ```
> ["/",["c",1.0],["c",2.0]]  ->  {"error": "bad hello"}
> ["log",["c",2.0]]          ->  {"error": "bad hello"}
> ["exp",["c",1.0]]          ->  {"error": "bad hello"}
> ["neg",["c",1.0]]          ->  {"error": "bad hello"}
> ```
>
> The wire speaks **nine** forms: `var c + - * get if > =`. If you adopted any
> of the four on the strength of my comment, that code is broken today.
>
> **Your core claim still holds.** No belief-scoped head parses — `expect`,
> `cond`, `push`, `argmax` all refuse — and `["var", N]` is still closed to
> `N ∈ {0,1}`; `["var",2]` and `["var",-1]` both refuse. Verified at HEAD.
>
> **But the issue's operative conclusion is superseded.** Your body enumerates
> three routes and closes "None of these exist today". Route (c) was *"some
> other wire-level hook that changes how much computation the engine spends
> per decision based on a declared value."* That shipped on 2026-07-27 as the
> trampoline `clock` row:
>
> ```json
> "clock": [{"name": "think", "price": P, "batch": B}]
> ```
>
> The world prices the agent's internal acts; the engine's preposterior at
> batch depth B, minus P, enters the same one policy sentence as an ordinary
> option. Demonstrated on a world where the two acts tie exactly (so
> information strictly changes the choice):
>
> ```
> price 0.0, 0.1, 0.2, 0.21  ->  {"internal": "think"}
> price 0.22, 0.25, 1.0      ->  {"act": {"act": 2}, ...}
> ```
>
> The crossing is between 0.21 and 0.22. A declared value changes how much
> computation the engine spends per decision — route (c), verbatim.
>
> The distinction that keeps your literal claim alive: the trade-off is
> declared as **world data** (`price`, `batch`), not uttered inside `said@1`.
> That is real. But "the reflexive-freeze capability ... is unreachable from a
> wire client" is no longer true as written.
>
> Also: the residue this was parked in ("host-wire integration: `choose` still
> serves the wire") has dissolved — the host fold is dead.

================================================================
#15 — KEEP OPEN, record the supersession  [REVERSED 2026-09-01, see below]
================================================================

  SUPERSEDES the earlier draft in this file, which said "close (bookkeeping)".
  That draft rested on the filer's 2026-07-22 withdrawal. While this sitting
  was open the filer pushed `r45-evidence-path` (99fa6c7, 2026-09-01), whose
  frozen consequence branch 2 reads: "Cite upstream #15, which is the
  engine-side twin and is already OPEN -- file nothing new (M-23)."
  Closing this issue would delete the record their branch points at and
  would invite the duplicate M-23 exists to prevent. DO NOT CLOSE.

> Keeping this open, and correcting the record rather than closing it.
>
> This issue was headed for a bookkeeping close on the strength of the
> 2026-07-22 withdrawal. That withdrawal is **superseded**: `r45`'s
> pre-registration (2026-09-01) names this issue as the engine-side twin of
> its item-3 blocker and explicitly declines to file a replacement because
> this one is open. Closing it would have been the wrong act.
>
> **The limitation is confirmed live at HEAD** (`94fd4eb`), so the issue is
> accurate as filed, not stale:
>
> ```
> src/PropLang/Host.hs, binding `tick`:
>       if any ((`elem` writable) . fst) feats
>         then Left "feature/assignment collision"
> ```
>
> A writable (menu) name may never appear in a tick's features. A replay
> therefore cannot supply a **recorded** act as a feature: the act must come
> through the menu, and the engine then picks the act the fold conditions on.
> That is this issue's subject, unchanged.
>
> Two notes for the r45 reading, offered as measurement rather than advice:
>
> 1. Your option 2 ("the fold conditions on what the engine picks, not on
>    what happened") is correctly characterised. Nothing in the engine pins
>    the fold to an externally recorded act; the one-point-menu route is the
>    only way to pin it, with the per-session cost you already name.
> 2. Every repro recipe in the older comments of this thread is now **refused**
>    at HEAD — the door landed at the exact re-founding and a tick must cover
>    the declared namespace exactly. The recipes are stale even though the
>    issue is not; re-derive them before re-running.

================================================================
#17 — confirm, keep open
================================================================

> Re-confirmed at HEAD: both verbs still refuse.
>
> ```
> {"observe_batch": [...]}   ->  {"error": "expected tick"}
> {"observe_counts": {...}}  ->  {"error": "expected tick"}
> ```
>
> Unshipped by decision, not oversight — the transport half was declined
> explicitly, and `membrane-wire.md` section 6.3 carries an UNSHIPPED bracket
> naming this issue. Keeping this open as the standing entry to the
> `observe_counts` demand gate.
>
> One thing has moved underneath it: **the cost model this argues from.**
> `observe_counts` was justified by engine-dominant per-tick cost measured on
> the pre-exact engine, and the re-founding changed the enumeration wholesale
> — the decomposition cited here predates 2026-07-25. A fold-depth measurement
> against the current engine now exists and is the thing to re-read that
> argument against.

================================================================
#14 — dispose into post-terminal residue, with the re-open condition named
[RULED at the sitting, 2026-09-02: "dispose into post-terminal residue with
an explicit re-open condition (a re-statement against the current engine).
Re-soliciting an input nobody has requested for forty days is R1's option
(1) in miniature, and the form of your rulings should not differ across rows
of the same shape."  The earlier NO-DRAFT note stands as the record of why
this sat until a ruling.]
================================================================

> Closing this as **post-terminal residue**, with an explicit re-open
> condition rather than an open-ended wait.
>
> The 2026-07-22 request solicited a re-statement of this demand against the
> engine as it then stood. In the forty days since, no re-statement arrived —
> and the engine it would have been stated against no longer exists: the
> exact re-founding (2026-07-25) replaced the enumeration wholesale, took the
> wire from twenty forms to nine, and the boundaries after it moved the
> alphabet three more times. A re-statement against the old engine would
> answer a question nothing can act on now.
>
> **The re-open condition, stated exactly:** this demand re-enters the
> register the day it arrives as a re-statement against the *current* engine
> — a declaration (world JSON) plus the decision it wants and the measurement
> that shows the shipped surface refusing it. That is the same two-sided gate
> every deferred demand in this repo re-enters through: a measurement, not an
> argument. Nothing about the demand's substance is judged here; what is
> disposed is the open-ended solicitation.
>
> Filed as residue at the #24 sitting (2026-09-02), which disposed every
> standing issue row in the same pass.

## L5-repair-demo.txt

```
=== L5 repair (option b): the TWO-SIDED DEMO, executed 2026-09-01 ===
Run against the draft in L5-repair-option-b.txt, in isolation, without
modifying tools/prefreeze-lint.sh.  Every mutation restored and the restore
verified (git diff empty) after each.

--- GREEN 1: THE REGRESSION THAT BOUGHT THE REPAIR ---
The current pack still contains the exact sentence that broke the old row
(doctrine-author-pack.md:473, "this pack carries no SAT/overlay").  Under the
repair it is green:

    PASS  L5 doctrine-author-pack.md: no SAT section (derived from the tree;
          its commit cut no oracle)

The old row returns 4 FAIL on these same bytes.  This is the defect's own
regression test and it passes.

--- RED 2: an unreadable declaration does not fall through to a green ---
    $ printf 'SAT-SECTION: maybe\n' >> doctrine-author-pack.md
    FAIL  L5 doctrine-author-pack.md: unreadable SAT-SECTION declaration
          'maybe' (want none|present)

--- RED 1: a pack that SHOULD check, and fails ---
    $ printf 'SAT-SECTION: present\n' >> doctrine-author-pack.md
    FAIL  L5 doctrine-author-pack.md SAT section lacks -Wall
    FAIL  L5 doctrine-author-pack.md SAT section lacks -Werror
    FAIL  L5 doctrine-author-pack.md SAT section lacks -Wincomplete-patterns
    FAIL  L5 doctrine-author-pack.md SAT section lacks -Wincomplete-uni-patterns
Both branches fire.  The declaration override works in both directions.

--- THE TREE DERIVATION, checked on three real boundary commits ---
    a371e17  pack=breadth-author-pack.md   -> present   (cut test-breadth/)
    0766ebe  pack=readout-author-pack.md   -> present   (cut test-readout/)
    94fd4eb  pack=doctrine-author-pack.md  -> none      (a rulings sitting)
Correct on all three, and prose cannot move any of them.

--- THE FLAG LIST, DERIVED rather than hand-listed ---
    $ sed -n 's/.*ghc-options:[[:space:]]*//p' proplang.cabal \
        | tr ' ' '\n' | grep '^-W' | sort -u
    -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns

EXACTLY the four the lint currently hand-lists.  So the repair is
behaviour-preserving where it should be, and the hand-list -- which would have
gone stale silently the day a stanza's flags changed -- is retired without any
change in what is enforced today.

--- RESTORE ---
    $ git diff --stat -- doctrine-author-pack.md
    (empty)
```

## L5-repair-option-b.txt

```
DRAFT — L5 repair, option (b), the one-generator form.  REV 2, per the
sitting's verdict of 2026-09-02 (two modifications: "exactly one
occurrence" on the marker, and flags derived from every TEST STANZA with
no hand fallback).
NOT APPLIED.  tools/prefreeze-lint.sh is manifest-covered (row 180), so this
edit and the MANIFEST re-sign are the author's key.

WHAT IT REPLACES: tools/prefreeze-lint.sh lines 68-85 at 94fd4eb.

WHY: the row decided whether a pack has a satisfiability/overlay section by a
bare case-insensitive word grep over the WHOLE pack, so prose ABOUT the lint
was indistinguishable from prose CONSTITUTING a SAT section.  The #19 sitting
wrote its own WARN into the pack -- "this pack carries no SAT/overlay section"
-- and those very words flipped the row into its check branch, turning a
verified "0 FAIL 1 WARN" into 4 FAIL at bytes that had not moved.

Two halves, both DERIVED instead of inferred:
  (a) SAT-bearing-ness comes from THE TREE -- did the pack's own commit touch
      test*/ or proplang.cabal?  An increment that cut an oracle did; a rulings
      sitting did not.  Prose cannot move this.
  (b) the flag list comes from proplang.cabal's TEST-SUITE STANZAS, read at
      lint time, NOT from the four flags currently hand-listed inside the
      lint.  That hand-list is a second latent bug of the same family: it goes
      stale silently the day a stanza's flags change, and nothing notices.
      REV 2: the derivation carries NO fallback default -- an empty parse
      FAILS loudly instead of silently substituting a hand list (a fallback
      default is the hand-list disease one level down, and a row that can
      quietly switch to it is a green that cannot fail its own derivation).
A pack may OVERRIDE (a) with an explicit line-anchored declaration, the
declared-structure half:  ^SAT-SECTION: none|present
REV 2: the declaration binds only when it occurs EXACTLY ONCE.  Zero
occurrences = derive from the tree; more than one (e.g. the real marker plus
a copy quoted in a code fence, which also matches column 0) = FAIL as
ambiguous.  This removes option (a)'s recorded weakness -- "the marker's own
mention in prose re-creates the class" -- structurally and for free.

--------------------------------------------------------------------
# -- L5: SAT flag-faithfulness in the current author pack --------------------
# every overlay/satisfiability transcript must record the stanza's exact flag
# set, -Werror included (the step-5 flag-faithful amendment).
#
# Pack selection HARDENED at the heir oracle freeze (OB-28 iii): the old `ls -t`
# selected by mtime, which in a fresh clone is checkout order -- the current
# pack now derives from HISTORY.
#
# Pack DETECTION repaired at the #24 sitting: the old test was
# `grep -qi "satisfiability\|overlay" "$pack"`, a bare word grep over the whole
# file, so PROSE ABOUT THIS LINT entered the check branch.  The #19 sitting's
# own verification sentence did exactly that and turned a verified
# "0 FAIL 1 WARN" into 4 FAIL with the tree unmoved.  Both halves now derive:
# (a) SAT-bearing-ness from the TREE (did the pack's commit touch an oracle?),
#     overridable by a SAT-SECTION declaration occurring EXACTLY ONCE (two
#     matches -- e.g. the marker plus a fenced quotation of it -- FAIL as
#     ambiguous rather than silently picking one);
# (b) the flag list from proplang.cabal's test-suite stanzas, with NO
#     hand-coded fallback -- an empty derivation FAILS, never defaults.
pack=$(git log -1 --pretty= --name-only -- '*author-pack.md' 2>/dev/null | head -1)
if [ -n "${pack:-}" ] && [ -f "$pack" ]; then
  packcommit=$(git log -1 --format=%H -- "$pack")
  decls=$(sed -n 's/^SAT-SECTION:[[:space:]]*\([a-z]*\).*/\1/p' "$pack")
  ndecl=$(printf '%s' "$decls" | grep -c . || true)
  if [ "$ndecl" -gt 1 ]; then
    bad "L5 $pack: SAT-SECTION declared $ndecl times (want exactly one; a fenced copy is ambiguous)"
  else
    if [ "$ndecl" -eq 1 ]; then
      decl=$decls
      src="declared in the pack"
    else
      if git show --pretty= --name-only "$packcommit" \
           | grep -qE '^test[^/]*/|^proplang\.cabal$'; then
        decl=present
      else
        decl=none
      fi
      src="derived from the tree"
    fi
    case "$decl" in
      none)
        ok "L5 $pack: no SAT section ($src; its commit cut no oracle)"
        ;;
      present)
        # every -W flag any TEST-SUITE stanza declares (awk scopes the
        # union to test-suite blocks; no fallback -- empty = FAIL)
        flags=$(awk '/^test-suite /{t=1} /^library|^executable /{t=0}
                     t && /ghc-options:/ {for(i=1;i<=NF;i++) if($i ~ /^-W/) print $i}' \
                    proplang.cabal | sort -u)
        if [ -z "$flags" ]; then
          bad "L5 could not derive any -W flag from proplang.cabal test-suite stanzas (refusing a hand default)"
        else
          l5=0
          for flag in $flags; do
            grep -qF -- "$flag" "$pack" || { bad "L5 $pack SAT section lacks $flag"; l5=1; }
          done
          [ "$l5" -eq 0 ] && ok "L5 $pack records every test-stanza flag ($src): $(echo $flags | tr '\n' ' ')"
        fi
        ;;
      *)
        bad "L5 $pack: unreadable SAT-SECTION declaration '$decl' (want none|present)"
        ;;
    esac
  fi
else
  warn "L5 no author pack found in history (nothing to check)"
fi
--------------------------------------------------------------------

THE TWO-SIDED DEMO OWED AT INSTALL (the kit law: a gate arrives with its red
demonstrated, and the triptych binds harness gates as much as oracle rows):

  RED 1  -- a pack that SHOULD check and fails.  Take any oracle-cutting
            increment's commit, strip one -W flag from its pack, re-run: the
            row must FAIL naming that flag.
  RED 2  -- an unreadable declaration.  Write `SAT-SECTION: maybe` into the
            current pack: the row must FAIL on the declaration, not fall
            through to a green.
  RED 3  -- (REV 2, the verdict's addition) the AMBIGUOUS marker: the real
            `SAT-SECTION: none` plus the same line quoted inside a code
            fence.  The row must FAIL naming the count, not silently bind
            the first match.
  RED 4  -- (REV 2) the empty derivation: run against a cabal file whose
            test-suite stanzas carry no -W flags (a scratch copy): the row
            must FAIL refusing the hand default, not default to one.
  GREEN 1 -- the CLASS THAT BOUGHT THE REPAIR.  Write the #19 sitting's exact
            sentence ("this pack carries no SAT/overlay section") into a
            rulings pack: the row must stay GREEN.  This is the regression
            test for the defect itself and must be in the demo.
  GREEN 2 -- an oracle-cutting pack that records every test-stanza flag:
            GREEN.
  Restores verified after each.

NOTE ON SCOPE: this repairs the L5 class.  It does NOT discharge OB-30, whose
principle (reviewed prose never reaches a command through a shell-word parser)
is broader than one lint row.  See register R6 (the verdict: record the
second and third instances, do not discharge).
```

## post-ruling-plan.md

DRAFT — the post-ruling execution plan, and the roadmap as it stands after
each answer.  NOT A RULING.  Written by the builder (2026-09-01, after the
r1a addendum); AMENDED 2026-09-02 after the sitting's verdict (R1 = (3) in
direction, shape pending probe A1 -- since EXECUTED, see the r2 pack: the
cliff is expression duplication, the third shape removes it).  Where the
verdict superseded a line below, the line is repaired in place with the old
words quoted.  Every act below is tagged with whose key it needs.  Nothing
here is applied; nothing here binds.

================================================================
1. The roadmap after this sitting — the terminal sequence
================================================================

The live roadmap (EXACT_PLAN.md 13.0, per pack I.9; the FL-2 draft repairs
CLAUDE.md's stale pointer to it) has ONE open step, the demonstration tier,
with three parts.  This round moved two of them.  What remains, in order:

  T1. POST #11 (author's account; draft final in issue-postings.md).
      The A-gate reading exists and was ruled; only its recording where the
      consumer reads is missing.  This COMPLETES step 5's first part.
  T2. THE BENCHMARK (R8): the prepared 3-commit series + the r02 additions
      land as record (committer: the owner — builder commits from this box
      are unsigned by design and the series is the owner's to land); the
      acceptance band is filled BY THE OWNER; alpha and the operating point
      are then read against it.  F5/F9 leave this one blank-band away from
      complete.
  T3. THE PAPER.  Untouched, and nothing in this sitting touches it.

  AFTER 5 THE ROADMAP TERMINATES.  #24's residue then re-enters only
  through the two-sided gate with a measurement — which this sitting now
  HAS (F9), so the gate's evidence half is pre-paid whichever way R1 goes.

Where R1 slots in:
  - option (1) names a boundary: the ONLY boundary that will demonstrably
    exist is the step-5 close itself.  Naming it costs one OBLIGATIONS row
    (author key) and makes the terminus the migration point.
  - option (3) un-defers: one full increment inserts BEFORE the step-5
    close (section 4 below).  The roadmap grows by exactly one boundary
    and still terminates.
  - option (2) / decline: the roadmap is unchanged; FL-1's repair plus a
    cost note is the whole residue.

================================================================
2. The common close sequence (whatever R1 rules)
================================================================

  a. POSTINGS — author's GitHub account, no key act, no manifest.
     #11 (dispose), #16 (correction-of-the-correction), #15 (KEEP OPEN —
     the reversed draft; the r45 pre-registration depends on it), #17
     (confirm).  #14 needs a demand judgement first (register R7; builder
     declined a default).  These can go TODAY, before any other act.
  b. THE FROZEN-LAYER ACT — one sitting, one re-sign, author key:
     - L5 repair, shape per R4 (drafts: L5-repair-option-b.txt).
       CLOSE-BLOCKING: this pack trips L5 by existing; the sitting cannot
       end green without it.  Two-sided demo owed at install (kit law).
     - FL-1 / FL-2 / FL-3 per drafts/FL-repairs.txt.  MIND THE INVERSION
       TRAP: under R1 option (3), FL-1's drafted text becomes false and
       the original sentence true — draft accordingly at the close, do
       not install both readings.
     - OBLIGATIONS rows: OB-24's disposition (per R1 = (3)), OB-30's
       second and third instances recorded (per R6, without discharging),
       the published-record row per R5 (RULED standing, ONE row, BOTH
       arrows: our published record re-read against HEAD at every
       boundary, AND the filer's repo fetched before any disposition --
       triage-only, never a verdict), OB-33/OB-16 notes per R3.
     - the drift-a licensed re-mint (per R8's verdict): an absolute band
       that has produced three environmental reds while the ratio row
       passed every time teaches people to read red as weather -- re-mint
       to RATIO form at the next boundary that touches the oracle (which
       the (3) increment is).
     - MANIFEST re-hash + re-sign; the sitting tag by -F <file> (the
       tag-message-is-a-file law), message file itself a manifest row.
  c. VERIFICATION at the close bytes: prefreeze-lint 0 FAIL (L5 now
     green against this very pack — that is the repair's live two-sided
     demo), boundary audit M5=0 H=0 OB=0 BF=0, gate 5 = cabal test all
     -j1 (serialized; the drift row is timing-gated).
  d. If any freeze-edit was delegated to the builder, the author re-tags
     within the increment (R-D22); the countersign is a close condition.

================================================================
3. R1 branch costs, side by side
================================================================

  (1) NAME THE BOUNDARY.  Engine work: zero.  Acts: one OBLIGATIONS row +
      the common close.  F9's width table installs as a standing cost note
      beside the deferral (the record already priced the migration).  The
      pack's caveat stands: a boundary the terminus clause may never open
      is a deferral wearing a name — if (1), name the STEP-5 CLOSE, not an
      abstraction.
  (2) DOCUMENT ONLY.  FL-1 repair + a membrane-wire cost note.  The
      workaround (declare a clock, price it prohibitively) stays the
      consumer's route; #24 is answered by documentation.
  (3) UN-DEFER — one full increment, oracle-first, and R9 flips YES:
      - the routing pin row lands WITH the re-route.  [REPAIRED per the
        verdict's kill-law point, 2026-09-02.  This bullet read "the new
        route pinned extensionally to the old on the clockless corpus" --
        WRONG: F7 established that corpus contains three worlds able to
        distinguish the routes, two immune, so equality-pinning where old
        and new agree is a green that cannot fail.]  The pin row pins the
        NEW behaviour on #24's world -- head loses, the declared argmax
        wins -- and its seeded defect is REVERSION of the comparison to
        the challenger-env form; the r2 prototype demonstrated that red
        (r2-f12, D2).  If the reversion mutant does not go red, the row
        is not installed.
      - OB-33 FIRES (this is the next kill-matrix increment): the four
        missing mutant classes plus re-triage of the seven unreached
        breadth rows ride the same boundary.
      - the six red-team mandates fire at the close (R9).
      - F9's cliff: RESOLVED BY MEASUREMENT at r2.  [This bullet read
        "the increment owes either a declared width cap or a documented
        cost row"; the verdict struck the cap half -- a width cap is a
        hardcoded threshold, which the constitution forbids, and NO WIDTH
        CAP will be declared.]  Probe A1: the cliff is EXPRESSION
        DUPLICATION in the chooseKS expansion (tree ~14.5*2^w, dag ~28*w,
        evalx tree-walking), not intrinsic to substitution -- the third
        shape's per-comparison term is 22 nodes at every width, equal to
        chooseEU's own pick constant.  Under the third shape the width
        caveat evaporates; the w32 arm-B residual becomes moot on the
        route that ships (and stays recorded as policyPick's).
      - the drift row's band: at the consumer's width the re-route is
        +0.19% and no re-mint is owed; the licensed-re-mint question is
        live only if wider profiles enter the timed corpus.
      - FL-1 installs INVERTED (the trap in 2b).

================================================================
4. Builder-runnable BEFORE any ruling (optional; no key, no frozen file)
================================================================

Each closes a residual the pack names.  None blocks the ruling; F9 already
gives R1 both halves of its answer.

  - the width-32 arm-B cell, run to completion on steel (~30-60 min; turns
    UNREACHED into a number).
  - the knee: one A/B at width 12 (the cliff is bracketed 8..16 and its
    location is unmeasured).
  - a second seed over the width sweep (the stated single-seed residual).
  - the P2real+rho cell (lever (b), named in F5 and unmeasured).
  - route-2 (bits-mirror) cells at the real declaration.

================================================================
5. What the builder will NOT do without word
================================================================

Rule anything; post anything; edit any frozen or manifest-covered file;
re-sign the manifest; mint or sign any tag; land the bench series; fill
the acceptance band.  The #15 close in particular is now COUNTERMANDED by
the r45 pre-registration — if any older draft of it survives anywhere,
this file supersedes it.

## shape-ruling.md

DRAFT — the shape ruling on R1 = (3).  For the author to adopt, amend, or
reject; nothing here binds until signed.  Drafted by the builder
2026-09-02 after the r2 evidence (A1, A2, F12), at the author's request
("help me rule").

REV 2, 2026-09-02: amended per the ruling round ("Verdict: adopt
R-SHAPE, with three amendments and a decision on clause 5"), quoted in
full in the pack's r3 section.  The three amendments are applied below
in place; clause 5 carries the round's INCLUDE with its pin-language
correction; amendment 1's demonstration obligation is EXECUTED
(transcript r3-f13).  What the signature now covers is THIS text.

================================================================
The ruling, drafted
================================================================

R-SHAPE.  The (3) increment lands the THIRD SHAPE — the pairwise AND
substituting fold — under the following seven clauses.

1. THE NORMATIVE DEFINITION DOES NOT MOVE.  The selection remains the
   one-sentence chooseKS form: the whole menu compared inside a single
   standing sentence, every candidate's utility expanded under its OWN
   assignment (the substitution semantics policyPick has carried since
   the trampoline).  This is what the agent criterion requires — "the
   executable route runs through the sentence; a host fold is legal
   only as a fast path pinned to the sayable route by the optimisation
   law" — and it is what makes FL-1 install as HISTORY: the frozen
   `menu` bullet's sentence becomes true as written.

2. THE FOLD IS THE EXECUTABLE, PINNED.  policyPick keeps its name and
   signature — one entry point, per the verdict — and its body becomes
   the pairwise-substituting fold: iterated CL-3 binary choice
   sentences (chooseEU's already-shipped executable form) with substW
   applied per side, O(width), 22 nodes per comparison (probe A1).
   The one-sentence chooseKS route is retained as the REFERENCE
   IMPLEMENTATION, and the fold is pinned to it extensionally in the
   same increment — the optimisation law's exact form ("enforced,
   never trusted"; the fast path buys speed, never semantics, never
   enters the alphabet, never touches the prior).

   THE PRECEDENT IS g2 ITSELF: g2 already pins the iterated-binary
   form (chooseEU) against the one-sentence form (policyPick) on
   their agreeing scope.  The new pin is the same bridge one level
   up — the substituting fold against the substituting sentence —
   g2's successor, not a new kind of row.

   WHERE THE REFERENCE LIVES (amendment 2, resolving rev 1's open
   detail): IN THE LIBRARY.  chooseKS already lives in Syntax.hs;
   the sayable route is part of the language's semantics, not test
   furniture, and moving it test-side would make the normative
   definition a resident of the oracle — backwards.  Its disposition
   is the one clause 3 gives chooseEU: exported, zero host
   consumers, pinned.  (Its evaluability bound rides the pin row's
   prose — clause 4b(ii).)

3. THE ROUTING.  Host's clockless arm calls policyPick — the one-
   identifier migration F7 measured (one call site, one import-list
   entry, two stale comments).  chooseEU: FROZEN-IN-PLACE, exported,
   zero src consumers, its standing pins undisturbed (test-pin's
   SELECTION row, g2) — the Purchase.hs/pwLadderCap disposition,
   set by the sitting immediately preceding this one.

4. THE PIN SUITE (the kill-law correction, verbatim):
   a. the #24-world row pins the NEW behaviour — head loses, the
      declared argmax wins — seeded defect: REVERSION of the
      comparison to the challenger-env form.  Red already
      demonstrated on the prototype (r2-f12 D2).  If the reversion
      mutant does not go red, the row is not installed.
   b. the extensional row: fold == sentence route, across a world
      family that INCLUDES the distinguishing cells (writable-name
      utilities, guarded-act worlds, ties, widths past the old
      cliff).  SEEDED DEFECTS (amendment 1): the pin suite
      enumerates its mutant class AT BIRTH -- the ENV-WIRING CLASS,
      four members, three defective:
        both-challenger  (the shipped defect; = the identifier
                          reversion, extensionally)
        both-incumbent   (the mirror half-reversion)
        swapped          (each side under the OTHER's assignment)
        correct          (each side its own; the row's green)
      plus the comparison class's tie-convention flip (Gt -> Ge,
      separable only on a tie world).  All three defective wirings
      DEMONSTRATED red on #24's world (transcript r3-f13: every one
      returns the head where the row expects the declared argmax;
      the half-reversions kill by tie, swapped by inversion) -- the
      round's order "demonstrate it rather than argue it" executed.
      FAMILY FORM (amendment 3): a MINIMAL SEPARATING FAMILY at the
      freeze -- it must separate every drafted seeded defect and
      include one width past the old cliff, nothing more; breadth is
      OB-33's matrix's job (pools are GROWN, the dyadic precedent).
      A family that cannot kill its own drafted mutants at freeze is
      a non-functional alarm at birth.
      TWO PROSE LINES THE ROW CARRIES: (i) the C56 rationale -- under
      the third shape each candidate's EU is a function of that
      candidate alone (env-independence, r2-f12 D5) and both routes
      fold the same strict-Gt first-listed convention (D4), so
      fold == sentence is a THEOREM about the implementation; the
      row is expected green, not hoped green -- and still owed as a
      frozen row, because theorems about implementations are ARGUED
      until pinned.  (ii) the WIDTH CEILING (amendment 2's rider):
      the chooseKS reference is unevaluable past the old cliff
      (~6e10 walked nodes at w=32, probe A1; D3 rightly skipped it),
      so the extensional pin's width bound is the REFERENCE'S OWN
      COST -- in practice w=16.  Recorded so a future matrix stall
      at larger widths reads as the reference's price, not a defect.
      This bound is the row's residual and is PRINTED (no-silent-
      caps); it is not a cap on the fold, which clause 4d forbids.
   c. every standing frozen row stays green — F7's outcome sweep
      re-executed at the oracle phase against the real surface.
   d. NO WIDTH CAP, and no cost row: probe A1 dissolved the cliff
      (expression duplication, not substitution).  The w32 UNREACHED
      residual is recorded as the OLD expansion's and dies with it.

5. SCOPE — THE CLOCK PATH RIDES TOO.  INCLUDE, per the ruling round
   (the author's signature is the word that closes it).  pickWire's
   comparison evaluates the same chooseKS expansion over the menu
   rows plus the think row, so the clock path carries the identical
   exponential artefact.  Four reasons, the round's fourth doing the
   deciding: (i) same fold, same pin pattern, one increment; (ii)
   the roadmap terminates after step 5, so "later" has no scheduled
   carrier; (iii) striking it ships a measured artefact on the
   primary route while repairing the secondary one; (iv) THE PRICE
   STRUCTURE INVERTS — with the clockless path repaired and the
   clock path not, a consumer who PAYS for deliberation buys a
   hidden 2^w term the free path no longer has, so the declared
   clock price stops being the price: the availability-from-pricing
   discipline bent on the primary route.  The counter-case ("no
   live consumer pays it at width 4") is the argument that kept
   chooseEU shipped for five weeks; the sitting has declined it
   once already.

   THE CLOCK PATH'S PIN (the round's correction, replacing rev 1's
   sentence "its frozen trampoline rows staying green byte-stable
   is itself the pin", which is the green-that-cannot-fail shape —
   those rows agree between old and new BY CONSTRUCTION): the clock
   path's pin is CLAUSE 4b's FAMILY — which contains the
   distinguishing widths — WITH pickWire ROUTED THROUGH IT.  The
   trampoline rows staying green is a REGRESSION CHECK, never the
   pin; said here so the kill matrix cannot one day certify the
   wrong thing.
6. THE BOUNDARY'S RIDERS (all previously ruled; listed so the tag
   closes them together): OB-24 DISCHARGED — this increment is the
   named boundary; OB-33's kill matrix (the four missing mutant
   classes + re-triage of the seven unreached breadth rows); R9 YES —
   the six red-team mandates at close; FL-1 as a dated HISTORY
   bracket, FL-2, FL-3; L5 rev 2 with the four-red demo; OB-30's
   second and third instances recorded, not discharged; R5's
   two-arrow published-record row; drift-a re-minted to RATIO form;
   MANIFEST re-sign; the tag by -F file.

7. ROADMAP PLACEMENT AND NAME.  One boundary inserted before the
   step-5 close; the roadmap still terminates after 5.  Not a
   language increment (no alphabet motion — R3): the alphabet is
   untouched, the prior untouched, prodTable unmoved.  Suggested
   tag family: `selection-freeze-r*` (the increment re-homes THE
   SELECTION; the name follows the exact/breadth/doctrine pattern).

================================================================
The honest list, rev 2 — what the ruling round resolved, and what
remains the author's
================================================================

RESOLVED BY THE ROUND (applied above, signature adopts them):
- Clause 5: INCLUDE, with the pin-language correction.
- Clause 2's detail: the reference stays in the library (Syntax.hs),
  exported, pinned, zero host consumers; w=16 practical ceiling in
  the pin row's prose.
- Clause 4b's family form: minimal separating family at freeze,
  grown by OB-33's matrix.

ONE COUNT TO SETTLE AT SIGNATURE: the round counts the drafted
seeded defects as "now six across the two classes".  The builder's
enumeration reaches FOUR extensional defects (env-wiring:
both-challenger, both-incumbent, swapped; comparison: Gt -> Ge) —
FIVE patches if the identifier reversion (the call-site revert,
clause 4a's mutant) is seated separately from the fold-internal
both-challenger rewiring, which are extensionally equal on every
world but are different diffs.  If the sixth is a further
comparison-class member (the operator class Gt/Ge/Lt/Le would give
three defects there, symmetric with the wiring class), name it at
signature; the freeze-time enumeration is what amendment 3's
"separate every drafted seeded defect" quantifies over.

STILL THE AUTHOR'S, OUTSIDE THIS DRAFT:
- The signature itself (adopt as amended, or strike amendments on
  the record).
- The demand registration at the Credence brain seam — the round's
  reading of F11: the cutover gate as posed reads an artefact (qbits
  of the exact-Rational representation, linear in t), so the gate's
  owner holds a measured demand against the REPRESENTATION in
  exactly #24's shape.  Registering it is the gate-owner's act, not
  the builder's; it enters post-terminus through the two-sided gate,
  dated, and does not un-terminate the roadmap.  Unregistered, the
  cutover stalls silently — a deferral without a name.

================================================================
What signature opens
================================================================

The increment opens ORACLE-FIRST: type-surface stubs if any surface
moves (none should — policyPick's signature is fixed), the pin-suite
oracle cut runtime-red with R-D21 transcripts, the author freeze over
it, then the one-identifier routing change plus the fold body, gates
1-7, the kill matrix, the mandates, the close.
