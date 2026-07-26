# x5-author-pack.md — the X.5 sitting pack (builder-authored, unfrozen)

Prepared 2026-07-26 against HEAD = `0460b9a` (exact-freeze-r1, author
tag VERIFIED). Session-opening verification, all four checks clean:
the three-tag chain r0/r0a/r1 each `git tag -v` GOOD under the author
key (SHA256:Sfh8OBG9...); MANIFEST 56/56 OK; gate 5 `cabal test all`
exit 0, six suites PASS; prefreeze-lint 0 FAIL / 0 WARN (L7 green).
Nothing frozen touched this session; every commit builder-key.

Contents: Track 1 = the five X.5 residue items (item 3 leads) + two
tidy items; Track 2 = OB-12's differential corpus run; Track 3 =
EXACT_PLAN §13 drafted (the trampoline charter — opens NOTHING until
your ruling). The decision sheet closes the pack.

---

## Track 2 — OB-12: the differential corpus run

### T2.1 The protocol (PRE-STATED; committed before any outcome was computed)

The evidence-program clause binds: success criteria stated numerically
BEFORE outcomes are read. This section was committed builder-key ahead
of the execution transcript (T2.2, a later commit — the git order is
the proof of pre-statement).

**The measurement named by the ledger.** OB-12 (OBLIGATIONS.md row,
frozen): increment B's gate "conditions on A's differential corpus
(life-agent vs the credence brain) and that measurement does not
exist"; the run is "cited by TWO pending readings (this gate's
re-entry and the A-gate exit-from-shadow, R-D14) — the single
highest-leverage unexecuted measurement in the programme."
The A-gate (archive/HOSTS_PLAN.md §9, frozen): "gate: life-agent
differential vs the credence brain." The roadmap's operational face
(credence-governor docs/governance-roadmap.md Phase 2/3): "a shadow
window long enough to compare engines on the registered metric, plus
the ask-rate reading"; A opens iff the differential surfaces "menus
beyond {ask, block, proceed} ... or K-ary evidence the binary verdict
carrier cannot express ... measured."

**The corpus (definition, not outcome).** `~/.credence-governor/
observations.jsonl` (indefinite retention, R-D16) — the evidence of
record. Record types present (schema recon, field names and counts
only): tool-proposed 143,036 / decision 143,035 / membrane-shadow
190,106 / outcome 171,261 / user-responded 8. A corpus event = one
event_id having (a) a tool-proposed record, (b) a decision record
(the credence brain's fired answer), and (c) >= 1 membrane-shadow
record (the life-agent's recorded answer; forms table@1 and latent@1
read separately). Grounding joins outcome records by event id. The
window is the dual shadow's own lifetime (deployed 2026-07-10, daemon
0.11.0; RETIRED 2026-07-22 by the author's ruling — no membrane-shadow
record since). The records carry no timestamps; the shadow linkage IS
the window. Both engines' answers were RECORDED LIVE against the same
traffic, so the run is pure log analysis — no engine is re-run, no
answer reconstructed.

**Reading R1 — the registered exit-from-shadow metric (R-D14; the
A-gate citation).** Per engine (julia, table@1, latent@1):
FBR_waste = falsified blocks / grounded blocks, where a block is
falsified when its grounded outcome completed with reverted = false
(shadow mode: every call proceeded, so every block decision is
outcome-checkable). Criteria (the REGISTERED bars, not new ones):
pass iff FBR_waste <= 0.05% AND grounded-block n >= 1000. The
30d-rolling clause is STRUCTURALLY unmeetable (the shadow lived 12
days and is retired) — reported as such; a bar the corpus cannot
reach is a finding about the corpus, never rounded to a pass.
Secondary: ask-rate per membrane form (the Phase-2 exit criterion's
other half), against the recorded priors (table@1 over-asks ~100% on
the early cells; latent@1 constant-block, ask-rate 0).

**Reading R2 — the A-gate demand shapes (HOSTS_PLAN §9).**
(a) Menu demand: census of decision-action values (both engines) —
demand MEASURED iff any value outside {proceed, block, ask} occurs
(count > 0), enumerated. (b) K-ary evidence demand: the grounded
outcome record is multi-level (completed x reverted x retries>0 x
error) while the wire's evidence carrier is binary; census the
distinct outcome shapes — K-ary demand MEASURED iff > 2 shapes each
occur with >= 1% corpus frequency (builder-proposed threshold, marked
as such). (c) Routing/options: any decision record whose action names
a route/candidate selection — count > 0 measures it.

**Reading R3 — the B-gate shape (OB-12's own citation:
correlated-evidence / two-stream inverted polarity).** The corpus's
two verdict streams per event: the human stream (user-responded) and
the structural stream (grounded outcome). (i) Inverted-polarity
subcorpus: events with both streams present and opposed (human
approves / outcome reverted, or human rejects / outcome clean).
POWERED iff n_inv >= 30 (builder-proposed floor, marked as such);
B's shortfall FIRED iff on a powered subcorpus one engine's grounded
error rate >= 2x the other's with each losing case enumerated and
attributable to reliability-blindness. Schema recon already shows
user-responded = 8 total, so n_inv <= 8: if that holds through
execution, the honest verdict is UNDERPOWERED — B stays un-fired by
measured insufficiency (not by adjacent evidence), and the thinness
of the second stream (8 human verdicts in 143k decisions) is itself
the recorded demand shape. (ii) Engine-disagreement adjudication:
on corpus events where julia and a membrane form disagree and
grounding adjudicates, report each engine's adjudicated error rate
and whether the loser's errors cluster on a common evidence shape
(enumerated, no threshold — a triage input).

**Execution plan.** One Python reader over observations.jsonl
computing exactly the tables above; transcript lands in T2.2
verbatim; whichever way the numbers fall, they are the pack's record
(OB-12's ruling refused adjacent evidence — this run is the direct
kind).

### T2.2 The execution transcript

(appended after the protocol commit; see the commit order)

---

*(Track 1 and Track 3 sections, and the decision sheet, follow in
this file — assembled in this session's later commits.)*
