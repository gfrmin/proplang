# chooseeu-author-pack — the #24 sitting (OB-24's unnamed boundary), round r1

*Builder-authored opening round, 2026-09-01, at HEAD `94fd4eb`
(`doctrine-sitting-r0` + `doctrine-sitting-r1`). **Nothing frozen is touched
by this round.** No ruling is taken, no obligation minted, no frozen or
manifest-covered file edited, no tag minted. Every repair below rides as a
DRAFT for the author's key. The sitting is the author's.*

SAT-SECTION: none

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

# PART IV — THE (3) INCREMENT'S ORACLE PHASE (opened at chooseeu-sitting-r0, executed 2026-09-02)

The signature landed (chooseeu-sitting-r0 over 99f6b2a, minted via
close.sh, published with --follow-tags on the author's "go") and the
increment opened ORACLE-FIRST the same day.  Everything below is
builder work on the unfrozen surface; the freeze that makes it binding
is the author's, per the kit.

## IV.1 — what was built

- **The type surface** (src, unfrozen): `Membrane.policyPickKS` —
  policyPick's exact signature under the reference's future name,
  exported, stubbed to a total refusal; the derivation line and the
  stub's role are in its doc comment.  Nothing else in src moved.
- **The oracle** (`test-selection/Selection.hs`, 10 rows, plain
  exitcode main, base+proplang only so the L7 corpus row's standalone
  `ghc -isrc` build reaches it): s1 the 4a wire row on #24's world;
  s2-s6 the extensional family (fold vs policyPickKS vs constructed
  answers — #24's values, the tie world, w8/w16, the guarded
  belief-differentiating world); s7/s10 the w32 fold-only capability
  cells; s8/s9 the clock path (prohibitive price; the price-0
  think-tie).  ONE GENERATOR: each cell's value list generates both
  its library utility and its wire hello.  Residuals printed by the
  suite itself (the w16 equality ceiling; minimal-family scope).
- **The stanza draft** (`test-selection/stanza.cabal.draft`) — the
  author splices it (proplang.cabal is manifest-covered).
- **The prophecy** (`test-selection/freeze/prophecy.diff`, 7 hunks,
  applies clean by dry-run): policyPickKS gets the sentence body,
  policyPick the pairwise-substituting fold (22-node pick per
  comparison, challenger-cover env, CL-3 strict), Host's clockless
  arm routes policyPick, pickWire folds externals then the think row
  as final challenger; Host's import list cleaned (chooseEU loses its
  last src consumer — clause 3 realized).

## IV.2 — the four runs (transcripts in test-selection/freeze/)

1. **red-run.txt** — at HEAD + stub, --skip-heavy: s1 red NATURALLY
   (reply act 1 vs demanded act 2 — the #24 defect verbatim); s2-s6
   red through the stub with the live side forced and PRINTED in each
   FAIL line (act 2 / tie-head act 1 / act 5 / act 9 / the guarded
   pick — attribution by inspection); s7/s10 skipped loudly with the
   A1/F9 measurement cited; s8/s9 GREEN (capability pins — the clock
   path already substitutes; their reds are d-sweep rows).
2. **sat-run.txt** — the overlay through CABAL under the stanza's
   exact flag set `-Wall -Werror -Wincomplete-patterns
   -Wincomplete-uni-patterns` (flag- and
   package-faithful): all ten green, w32 cells instant under the
   fold; trampoline 17/17, pins, f5 green against the same overlay;
   the full gate-5 rehearsal beside it.
3. **defect-sweep.txt** — d1-d7, every defect killed, every row
   fires somewhere, two unique seats at birth (s3 alone kills d4; s9
   alone kills d7).  The s1 kill-law condition: s1 fires under d1,
   and the standing corpus's green at HEAD is the zero-cost proof
   the reversion's kill is s1's alone.
4. **register.md** — eight under-determination rows for the freeze
   (the policyPickKS name; the --skip-heavy form; the s6 theta
   departure; the d1 _iFeats rider; sibling shadowing recorded; the
   think-side scope reading; generated-not-quoted hellos; the
   rehearsal concurrency note).

## IV.3 — two incidents, recorded

- **The d1 compile red**: the both-challenger rewiring orphans the
  iFeats binder under -Werror; the first d1 run failed to build and
  the sweep driver printed NOTHING for it — the assert-loud patch
  step refused to record a false kill.  The minimal mutant now
  carries the _iFeats rename; audit/mutants inherits the rider.
- **The s6 tie-in-disguise**: profileP2's theta grid is symmetric
  around 1/2, so the copied guarded world's EUs were all exactly 0 —
  d5 could not fire and d4/d6 fired through the hidden tie.  Found
  BY the sweep at the oracle phase (exactly what the birth pool is
  for); the frozen s6 carries an asymmetric grid with the departure
  documented at the copy site.  After the repair d3/d5/d6 fire s6
  through live belief differences and d4 correctly does not.

- **The invalid first gate-5 rehearsal**: the background `cabal test
  all -j1` shared its dist-newstyle with the defect sweep's cabal
  runs — mid-run library rebuilds under a walking suite's feet.  It
  reported breadth 19/20; the failing row's identity was lost to a
  tail-truncated capture whose EXIT line read the pipe's tail status
  (the close.sh SIGPIPE class, recommitted same-day in a new coat).
  Ruled EVIDENCE OF NOTHING; the second rehearsal ran solo on the
  restored overlay with a pipefail-honest capture and is the one the
  freeze directory carries.  The serialization law generalizes: a
  shared dist-newstyle is a shared instrument (register row 8).

- **The gate-5 rehearsal's one red, disposed** (gate5-rehearsal.txt):
  cabal test all -j1 against the overlay came back 19/20 on breadth
  with the ONE red being drift-a, the frozen timing instrument
  (window [6..30] 998.7 ms vs frozen 431.1).  The harness-gate law's
  demonstration: the SAME suite on the CLEAN-HEAD oracle tree (the
  overlay's selection change absent) reds drift-a HIGHER (1144.7 ms)
  on this same loaded box, every correctness row OK in both — so the
  red is BOX LOAD, exonerating the prophecy.  drift-a's ratio-form
  re-mint (r1 register R8, clause 6) is the already-scheduled repair
  and rides this increment's close; the real gate 5 runs quiet,
  serialized, after it.  NONE of this blocks the oracle-phase commit
  (correctness proven).  The FIRST rehearsal (shared dist-newstyle,
  tail-pipe exit) is struck above as evidence of nothing.

## IV.4 — what waits on the author (the freeze)

Per test-selection/freeze/freeze-kit.md: review (register strikeable
row by row), the stanza splice, the MANIFEST extension + re-sign, the
selection-freeze-r0 tag by -F over the freeze commit (message drafted
at freeze/r0-tag-msg-draft.txt).  Then implementation: prophecy.diff
byte-for-byte, gates 1-7, and the close's riders (clause 6, all
previously ruled).
