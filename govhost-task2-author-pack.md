# govhost Task-2 author pack (boundary H; HOSTS_PLAN as approved at c65a386)

Builder → author, at the Task-1 STOP. The oracle phase is complete
and runtime-red is proven; nothing frozen has been touched (manifest
68/68 throughout). This pack is the input to H's freeze: every edit
below lands only by the author, in the freeze commit, countersigned
by the author's signed tag. Per R3: drafted author texts are
conveniences, not acts.

## 1. Oracle-phase evidence (Task 1, complete)

New, untracked: `test-govhost/` (GovHost.hs, stanza.cabal.draft,
red-run.sh, ablation.sh, ablation/UseDriver.hs), `host-governor/`
(Wire.hs, Main.hs — type-surface stubs), `membrane-wire.md`,
this pack.

**Red/green, enumerated (40 tests).** GREEN from day zero, 22 — all
on frozen surfaces only: g0 the two MANDATORY opening fixtures
(WRITEUP post-close review; hand-derived pins, arithmetic in the
oracle's comments: pair 0.90, singleton faces 0.90/0.45, exact-max
identity, order-flip scan, W2 = 0.95, depth-2 =/= depth-1), gP5 six
identity pins covering every constant the P5 re-base touches, g3
seven namespace pins (count 3977; dl pins at models 0/9/17/1169;
restricted-enumeration row: 17 without TGet), g4 three analytic
cross-checks (grid-Bayes identity 1e-12; sound oscillation-bound
property x100; documented spot margin). RED, 18 — ALL by runtime
"unimplemented" under the stanza's exact flags (`-Wall -Werror
-Wincomplete-patterns -Wincomplete-uni-patterns`, GHC2021, compile
clean first run): g1 codec goldens (9), g2 step semantics (8), g5
process smoke (1). The red is the missing implementation, proven by
compiling — the flag-fidelity clause satisfied by construction
(red-run.sh carries the stanza's flags verbatim).

**Ablation** (test-govhost/ablation.sh, the canonized 4-check shape;
no new DROP flag — H adds no grammar surface; consumer-coupling rows
under EXISTING flags):

    PASS [argmax] deleted; error names argmaxEU
    PASS [affordance] deleted; error names menuOptions
    PASS [echo] deleted; error names runMembrane

**Incident, recorded (not hidden):** the argmax row's first token
list ("PilotEU") failed attribution — under -DDROP_ARGMAX the errors
name the DYING LAYER (Pilot(..), runMembrane), not the pilot
constructor. Fixed by making the fixture demand the argmax-named
symbol itself (a `policy = argmaxEU` binding); the row now attributes
to "argmaxEU". One more instance of the standing lesson: attribution
is what the compiler says, not what the author of the row expects.

**Frozen suites:** all eight PASS (acceptance, properties, hygiene,
expfam, membrane, ladder, prepost, cirl), anchors byte-stable.
**Manifest:** 68/68 OK. **Tree:** only the new untracked paths.

## 2. The freeze commit's edit list (exact, complete; author-applied)

1. **src/PropLang/Syntax.hs — the P5 single-site constant** (the
   ONLY src edit; diff drafted in section 5). Two drafting
   corrections against HOSTS_PLAN 0.3, flagged for ruling:
   - (H-9) the plan said FIVE literals; authoring found the SIXTH —
     `fnB _ = 1` is the FN sort's price literal (1 bit = lg 2). The
     draft re-bases all six onto the one table.
   - (H-10) the sketched `[(String, Int)]` association list would
     add an error site at the lookup (a forbidden-moves smell); the
     draft uses a total six-field record instead — one value, no
     partiality, base only.
2. **proplang.cabal** — append the two stanzas
   (test-govhost/stanza.cabal.draft, verbatim); extend
   extra-doc-files with HOSTS_PLAN.md and membrane-wire.md.
3. **CLAUDE.md** — the author's porting-order/re-opening sentence
   (draft in section 4; R3: enters by the author's hand, in the
   author's words if changed).
4. **MANIFEST.sha256** — author extends and re-signs over:
   test-govhost/GovHost.hs, test-govhost/stanza.cabal.draft,
   test-govhost/red-run.sh, test-govhost/ablation.sh,
   test-govhost/ablation/UseDriver.hs, membrane-wire.md,
   HOSTS_PLAN.md; re-hash amended proplang.cabal and CLAUDE.md.
   - (H-7, proposed ruling) **host-governor/ does NOT enter the
     manifest**: it is implementation surface, src/'s analogue —
     governed by gates 1–4 and by the frozen oracle compiling
     against it (any surface drift fails gate 5), never by hash.
     Freezing it would forbid the implementation phase.
5. **Tag** — `govhost-freeze` on the freeze commit, signed by the
   author from their own shell. From that signature test-govhost/ is
   as frozen as test/.

Census: **EMPTY** — no frozen assertion literal moves. Claimed with
instruments, not asserted: gP5's six identity pins green before and
after the re-base; the full battery green; the stdB/nodeB grep
censuses unchanged (`grep -rn "lg 7" test*/`, `grep -rn "lg 10"
test*/` — counts 4-in-4 and 17-in-7 as recorded in HOSTS_PLAN 3.2).

## 3. Proposed rulings (the under-determination register, as-authored)

- **R1 — menu-order polarity (THE HEADLINE; falls due here).**
  Precedent: CIRL C1's rider — "Off first-listed ... the tie-break
  CARRIES SAFETY CONTENT: proceeding must strictly earn it." A
  waste-gating governor is that precedent's paradigm case;
  `proceed`-first would quietly adopt the opposite polarity, and
  fail-open must not enter the record as a tie-break default.
  **Recommended: `ask, block, proceed`** — at exact indifference the
  agent buys information (the deference doctrine; increment 6's
  asking behavior at the driver layer); `block`-first is the C1
  fallback; `proceed`-first argued against. Transport-level
  fail-open on daemon absence is the governor's own deployment
  posture — severed from this ruling, so the first cannot launder
  the second.
  **RULED (author, 2026-07-08, at this pack): `ask, block, proceed`.**
  At exact indifference the agent buys information — the deference
  doctrine at the driver layer. Recorded verbatim from the author's
  answer; membrane-wire.md and the governor adapter carry the ruled
  order as normative; CIRL C1's polarity (block first) is the
  recorded fallback.
- **H-1 arrival order**: evidence conditions in arrival order (=
  log order = replay order; live == replay). Stated facts: hmm
  latents step per EVIDENCE tick; the judged event's original `t`
  is re-sent.
- **H-2 warm counts**: replayed as pseudo-evidence ticks — exact for
  exchangeable families, a DECLARED approximation for hmm families.
  Replay caps are adapter knobs, never proplang constants.
- **H-3 the ask row**: u(ask,.) = -q is myopic perfect-information
  VOI with "a resolved ask makes the correct act free" baked; the
  gap to the engine's cold-start heuristic is what the differential
  gate measures. The think row is a dominated sentinel; if it ever
  wins, the driver answers honestly. The non-myopic route is
  HOSTS_PLAN register item 12 (D0), gated on outcome-scored regret.
- **H-4 namespace contents**: the 39 waste indicators + `t`; harm
  names excluded (H's scope cut).
- **H-5 parity + gate**: decision-level only (Beta(2,2)/p_edge
  parity impossible by doctrine); differential gate proposed at 95%
  agreement, every disagreement enumerated and author-reviewed.
- **H-6 echo**: all-false in epoch 1, VALIDATED at the handshake
  (the n=1 driver's counters reset per call); lifting it = the
  exported one-tick step, a later class-(b) boundary on demand.
- **H-7 / H-8**: host-governor/ manifest status (section 2.4); the
  g5 binary arrives via GOVHOST_EXE in the oracle-phase runner and
  via build-tool-depends after the freeze.
- **H-9 / H-10 / H-11**: the sixth literal; the total-record
  refinement; the attribution incident (section 1) — all three are
  this pack's own drafting corrections, recorded.

## 4. Author text draft — CLAUDE.md porting-order sentence (R3 applies)

> The roadmap re-opens at the hosts boundary (HOSTS_PLAN, c65a386):
> increment H (the host driver and the single-site alphabet
> constant), then A (options-as-data observations), then demand-gated
> B (the reliability channel), D (the latent-utility pilot), and C
> (arithmetic, the census-bearing change) — each its own oracle-first
> freeze, each gated as HOSTS_PLAN section 9 records.

## 5. The P5 diff draft (src/PropLang/Syntax.hs, freeze commit)

Export list: add `ProdTable (..), prodTable` (additive; gate 2
constrains Belief only). Before `bits`:

```haskell
-- | The normative production table's written alternative counts
-- (spec section 3; HOSTS_PLAN 0.3 — P5's single-site constant): ONE
-- value, six fields, total by construction. A count change edits
-- exactly this value plus the enumerated frozen pins of the changed
-- sort; the govhost oracle's gP5 group pins the identity.
data ProdTable = ProdTable
  { prodExpr, prodFn, prodStats, prodKer, prodStdName, prodUtil :: Int }

prodTable :: ProdTable
prodTable = ProdTable 10 2 1 1 7 1
```

Inside `bitsAt`'s where-clause, the six price literals re-based (the
comment block above them survives; counting stays by written
alternatives):

```haskell
    nodeB, stdB, kerB, statsB, utilB, lgOf1 :: Double
    nodeB  = lgOf (prodExpr prodTable)
    stdB   = lgOf (prodStdName prodTable)
    kerB   = lgOf (prodKer prodTable)
    statsB = lgOf (prodStats prodTable)
    utilB  = lgOf (prodUtil prodTable)
    lgOf n = logBase 2 (fromIntegral n)
```

and `fnB _ = 1` becomes `fnB _ = lgOf (prodFn prodTable)`. (Exact
identifier plumbing at the author's discretion; the gP5 pins are the
arbiter — `bits` must move nowhere.)

## 6. Reviewer verification block (run by the author, repo root)

```
export PATH="$HOME/.ghcup/bin:$PATH"
sh test-govhost/red-run.sh        # expect: compiles clean; 22 OK / 18 FAIL,
                                  # every FAIL a runtime "unimplemented"
sh test-govhost/ablation.sh all   # expect: 3 PASS with named attributions
cabal test all                    # expect: all eight frozen suites PASS
sha256sum -c MANIFEST.sha256      # expect: 68/68 OK
```

Then the freeze, in the author's shell: apply section 2's edits; rule
R1 (and any register item the author re-rules); extend + re-sign the
manifest; `git commit -S`; `git tag -s govhost-freeze <commit>`.

## 7. After the freeze (implementation phase, builder)

Fill host-governor/Wire.hs and Main.hs until all 40 oracle tests are
green under `cabal test all`; no edit under test-govhost/ or any
frozen path, ever; anchors byte-stable; then the governor-side
adapter (MembraneClient/MembraneSession, CREDENCE_MEMBRANE_COMMAND,
shadow mode) as ordinary PRs in the living repo, and the differential
gate (posterior_eval, both engines, waste-only) whose enumerated
disagreements come back to the author with the increment report.
