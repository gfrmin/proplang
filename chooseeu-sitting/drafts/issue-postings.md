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
