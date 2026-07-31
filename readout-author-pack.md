# readout-author-pack.md — increment #20, the K-ary readout

The wire docket's first sitting. Charter: `EXACT_PLAN.md` section 15.
Opened by the author's election of 2026-07-31 ("Open #20"), on the
authorization `battery-freeze-r0` already carries: "the 14.9 wire
scheduling (#20 first, the OB-19 heir second, #19 1a-or-doctrine
third)".

---

## Part I — the opening

### I.1 State of the tree at the opening

| check | result |
|---|---|
| HEAD | `bd0d70c` — **is** `battery-freeze-r0`, tagged under the author's key |
| `sha256sum -c MANIFEST.sha256` | PASS, 109 rows |
| working tree | clean at the opening |
| `tools/boundary-audit.sh` | M5=0 H=0 OB=1 BF=0 — transcript at `test-readout/opening/boundary-audit.txt` |

The battery closed as a single-tag pin-freeze with no implementation
owed, so nothing is carried forward from it except its routed
findings channel (Part I.4) and its scheduling ruling.

### I.2 The object, and why it is first

`p1` is P(atom 1) at ANY arity (membrane-wire.md:356). At K-ary arity
that under-reads the predictive: when the engine chooses `respond_j`
with j /= 1, `p1` reports a different candidate's mass. Issue #20 asks
for `p0` / `argmax_code` / `p_argmax`, or the full O(K) vector, as
observability only — the `residual_mean`/`sensitivity` class
(membrane-wire.md section 6.4).

Two facts decide the increment's shape, both measured before the
boundary opened:

1. **Host-layer arithmetic over already-exported verbs.**
   `predictMassS` is already called at the reply builder
   (`src/PropLang/Host.hs:425`); `agentObsPoints` already enumerates
   the declared observation space at `:516`. The vector is a map of
   the first over the second. No new export, no constructor, no
   engine change — the alphabet does not move, `prodTable` stays
   20/1, and the primitivity gate is not engaged (nothing here is a
   candidate production, so clause (a) is not owed).
2. **The R-D23 cap binds at the operating point.**
   dispositions-pack.md VIII.1 finding 2, K=6, 5845 models, 400
   interleaved ticks: `p0` = 0.17998972 against the cap
   0.9/(K-1) = 0.18, while the empirical null rate is 0.735. The
   engine under-reads the null four-fold, and no evidence can fix it
   — `Enumerate.hs:467` makes atom 0 structurally undistinguished.

Fact 2 is the scheduling argument. OB-19's null-rate parameter is
UNOBSERVABLE today; `p0` is the number that observes it. #20 is the
instrument that lets item two be ruled on evidence rather than on
argument.

### I.3 Anchor safety — the claim this increment must execute against

An additive reply field is expected to move no pinned anchor. The
inspection behind that expectation:

| would-be pin | what it actually does | verdict |
|---|---|---|
| `test-transport/Transport.hs:95` | `expectedReplies = snd (mapAccumL serveLine hostStart requests)` — the R-D20 form, the frozen core folded over the same lines | both sides move together; no literal to break |
| `test-trampoline/Trampoline.hs:500-502`, `:520-522` (g6.1, g6.2) | `isInfixOf` against the reply | additive-safe |
| `test/Acceptance.hs:211` "probe rows: p1 exact" | reads `predictMassS` directly against `Anchors.t1ProbeRowsX` | never touches the reply builder |

Grep for a literal `"p1"` or `entropy_bits` anywhere under `test/`
or `test-*/` returns nothing. **This is a claim, not a result**: it is
confirmed by the full-corpus run on the implemented surface, and any
pinned-anchor movement under an additive change is stop-and-report.

### I.4 The frozen-layer inventory — FL-1

The battery tag routed its post-tag findings to this sitting. The
first row did not wait for a reviewer; the boundary audit's OB-row
produced it mechanically.

**FL-1 — OB-20 and OB-21 carry `SCHEDULED@x5-sitting-r0` against a
closed boundary and against their own executed discharge.**

- `battery-freeze-r0` register CR5: "OB-20/21 are DISCHARGED at this
  boundary: M56-M61 committed with reach demonstrated".
- The substance is in the tree: `audit/mutants/M56..M61`, and
  `test-battery/opening/pool-reach.txt`, whose own header reads "the
  discharge evidence" (M57 the independence suite's sole killer, M60
  the count stanza's, M61's predicted generator-blindness cured
  in-increment by g-b4.1).
- `OBLIGATIONS.md` was last written at `trampoline-freeze-r0`
  (e4f41f3). The battery's freeze kit spliced the stanza and extended
  the manifest but never patched the ledger.

So the work happened and the record does not say so. This is the
exact shape the OB-row was installed to catch (the VoI obligation
that evaporated inside a composite: a discharge that happened and was
never written down). `OBLIGATIONS.md` is manifest-frozen, so the
repair rides THIS freeze under the author's key — register item CW7,
both rows to `DISCHARGED@battery-freeze-r0` with provenance and named
discharge events.

**FL-2 — open, empty.** Whatever the mandate round or the oracle
phase surfaces against frozen prose lands here before the freeze, in
the form its text class demands.

### I.5 The opening checklist

| row | state at the opening |
|---|---|
| OB-19 | RULING-PENDING, wire docket item TWO. Not ruled here; #20 is its instrument. Recorded so the sitting cannot drift into ruling it on argument |
| JP2-d6 / pwLadderCap | RETIRE-UNTIL-N whose N is the **#19** sitting (item three), NOT this one. Stated rather than left silent |
| OB-20 / OB-21 | substance discharged at battery-freeze-r0; ledger stale — FL-1 |
| boundary audit | run, transcript committed; M5=0 H=0 OB=1 BF=0 |
| red-team mandates | to run, six fresh-context reviewers, one mandate each |
| pre-freeze lint | due at the freeze, with the full-corpus overlay build |

Mandate 6 has a live question here — what is the readout a function
of? Answer as designed: the predictive at `feats ++ act` and the
DECLARED observation space, and nothing else; not the menu, not the
decision path. Mandate 5 has a standing candidate in `p1`'s meaning,
which oracle row r7 pins two-sided.

### I.6 The toolchain, stated plainly

The build environment at the opening has **no Haskell toolchain**, and
GHC 9.10.3 — the compiler the frozen `cabal.project.freeze` implies
(`base 4.20.2.0`, `containers 0.7`) — cannot be fetched:
`downloads.haskell.org`, `deb.debian.org` and the ghcup mirrors are
all 403 at the agent proxy; Ubuntu's archive offers only GHC 9.4.7.
The ghcup binary itself is reachable from GitHub.

GHC 9.4.7 is NOT a substitute and was not used: `base 4.17` fails the
frozen freeze file, and a mismatched warning set or package closure is
precisely the defect class the flag-faithfulness and
package-faithfulness clauses were purchased to prevent (the step-5
reorder incident; the jp `Data.Map` prophecy that reached the
implementation phase unseen).

Consequence for this pack: everything in Part I is shell-and-grep work
and is EXECUTED. Every execution-bearing clause of the oracle phase —
the two-run triptych, the overlay SAT under the stanza's dependency
closure, the R-D21 satisfiability transcripts, the kill matrix, gate 5,
lint row v — is OWED and is not claimed. The oracle phase does not
close, and nothing freezes, until the toolchain exists and the
step-0 baseline (the sealed tree, green, before any edit) has run.
No row in this pack is reported green that was not run.
