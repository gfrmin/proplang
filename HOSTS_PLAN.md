# HOSTS_PLAN — the re-opening: proplang as a host-drivable agent

Unfrozen working document, UNTRACKED in the frozen repository. It
proposes the lawful re-opening of the roadmap (P5's route) and the
increments under it. Nothing in this document changes anything: it
becomes real only through the author's own acts — the commit that
admits it, the re-opening sentence in CLAUDE.md, the freeze tags. Per
the increment protocol, every load-bearing assertion below is either
(a) re-verified against the frozen sources with its verification
command stated inline, or (b) marked as the author's ruling to make.

Drafted by the builder 2026-07-08 under four author rulings and three
review riders (R1 polarity-as-open-ruling, R2 proof-sketch standard,
R3 the-sentence-binds-by-commit), all recorded where they bind.

---

## 0. The re-opening

### 0.1 Why

The demand is external now: hosts that want a Bayesian decision core
whose every prior is the alphabet, whose every constant is priced, and
whose reasoner cannot be steered — credence-governor's tool-call
gate today, life-agent's lookup and learned-utility families next.
The frozen record closed with (WRITEUP.md:497-500):

> The roadmap terminates here. Any further scope binds P5's
> single-site alphabet-constant clause and requires a new roadmap
> boundary, by the author, at a freeze — the lawful re-opening
> route, kept narrow on purpose.

This document is that route being exercised. The P5 forward ruling it
binds (PREPOSTERIOR_PLAN.md:35-40):

> **P5 APPROVED with a forward ruling recorded:** the amendment set
> grows by one frozen price-pin literal per alphabet change
> (increment 6 will carry three). Accepted as BOUNDED — the roadmap
> terminates at increment 6 — and recorded so it cannot silently
> become unbounded: any scope extension beyond the roadmap makes a
> single-site frozen alphabet constant a MANDATORY boundary item.

### 0.2 The re-opening sentence (drafted; binds only by the author's commit)

Proposed CLAUDE.md porting-order text, to follow the existing
"Completed through increment 6 (the pointer)..." paragraph:

> The roadmap re-opens at the hosts boundary (HOSTS_PLAN, this
> freeze): increment H (the host driver and the single-site
> alphabet constant), then A (options-as-data observations), then
> demand-gated B (the reliability channel), D (the latent-utility
> pilot), and C (arithmetic, the census-bearing change) — each its
> own oracle-first freeze, each gated as HOSTS_PLAN §9 records.

**Rider R3, stated in full:** this sentence binds only by the
author's own commit. It enters by the author's hand, in the author's
words if the author changes them; the draft above is a convenience,
not the act. The boundary opens by that commit or not at all (the W1
brief precedent: the brief entered the repository verbatim, by the
author's hand).

### 0.3 The P5 mandatory item (lands at H, the first boundary — author-ruled)

The single-site alphabet constant. As-built, the five sort constants
live inside `bitsAt` (src/PropLang/Syntax.hs:384-389, verified):

```haskell
    nodeB, stdB, kerB, statsB, utilB :: Double
    nodeB  = logBase 2 10
    stdB   = logBase 2 7
    kerB   = logBase 2 1
    statsB = logBase 2 1
    utilB  = logBase 2 1
```

H exports the production table as one value (the single site) and
re-bases these five literals onto it:

```haskell
-- | The normative production table's written alternative counts
-- (typed-port-spec §3): THE single site (P5). A count change edits
-- exactly this value plus the enumerated frozen pins of that sort.
prodAlternatives :: [(String, Int)]
prodAlternatives =
  [("EXPR", 10), ("FN", 2), ("STATS", 1), ("KER", 1),
   ("STDNAME", 7), ("UTIL", 1)]
```

with `nodeB = lgOf "EXPR"` etc. — definitional, empty census, pinned
`==` by H's oracle on every frozen price pin (the identity-as-
definition form, required since the prepost freeze). ~20 lines, the
only `src/` edit H makes.

### 0.4 Protocol overheads (stated once, bind every boundary below)

Per increment: its own `test-<name>/` oracle directory + a
`stanza.cabal.draft` (flags `-Wall -Werror -Wincomplete-patterns
-Wincomplete-uni-patterns`, `GHC2021`, `import: warnings`; the
library stays base-only); oracle first, runtime-red bit-faithful to
the stanza's exact flags; compile-red fixtures proven type-correct
against the drafted surface; per-increment 4-check `ablation.sh`
(layer absence / positive / ablation-fails / attribution); any new
grammar surface triple-guarded (constructor + `bits` case + `evalx`
case behind ONE `DROP_*` flag); the author pack; the author's signed
freeze tag; manifest extension + re-sign. Every new oracle OPENS with
the two mandatory fixtures the post-close review named
(WRITEUP.md:459-477): the interior-menu max above the singleton, and
`vPreAt` recursion above depth 1 — "Any future increment under P5's
route opens its oracle with these as its first fixtures." All
increments below fit the six frozen src modules (the frozen oracle
row `test-cirl/Cirl.hs:293` — `ls src/PropLang/*.hs | wc -l` = 6 —
is never amended).

Custody per the two-key scheme (boundary-queue.md, adopted
2026-07-05): the builder signs its commits with the builder key; a
freeze binds when the author countersigns with a signed tag from
their own shell.

---

## 1. The membrane wire — the generic host contract

One process, one agent, one world. JSON-lines over stdio; one request
line, exactly one reply line, synchronous; protocol-versioned;
unknown keys ignored (the governor's own new-key negotiation
doctrine). The wire is the membrane's three flows plus a world
declaration, all data — no belief object, no handle, no prior, no
formula ever crosses. Replies carry one choice and read-only scalars
(`prob`/`entropyBits` are CL-2's public diagnostics; the governor's
Invariant 1 — "a scalar or an action across the wire, never a belief
object" — is satisfied by construction).

**Handshake** (first line, host → driver): the world declaration.

```json
{"membrane": 1, "world": {
  "namespace": ["t", "tool-name=read", "...", "time-since-last-user-message=gt-10m"],
  "guards":    [{"name": "tool-name=read", "grid": [0.5]}, "..."],
  "menu":      [{"id": 3, "name": "ask",     "slots": []},
                {"id": 2, "name": "block",   "slots": []},
                {"id": 1, "name": "proceed", "slots": []}],
  "utility":   {"form": "table@1",
                "rows": [{"fire": 3, "u": [-0.02, -0.02]},
                         {"fire": 2, "u": [ 0.0,  -0.5 ]},
                         {"fire": 1, "u": [-0.5,   0.0 ]},
                         {"internal": "think", "u": [-3.0, -3.0]}]},
  "echo":      {"last_action": false, "tick": false,
                "ticks_spent_thinking": false}}}
```

Reply: `{"ok": true, "proto": 1, "models": 3977,
"namespace_bits": 5.3219}`.

- `namespace` → `mkNamespace` (Syntax.hs:465); `guards` → the
  `[(Name, Grid)]` extras of `enumerateModelsIn` (Enumerate.hs:194);
  `menu` → `[Affordance]` via `mkAffId` (`Affordance AffId Name
  [Slot]`, Membrane.hs:127; slot grids via `mkGrid`, so an
  unpriceable point is unofferable — `menuOptions`' own law);
  `utility` → `mkUtil` over the finite table (§2.6); `echo` →
  `mkEchoSpec`. Menu listing order is normative: `argmaxEU` ties
  resolve first-listed (CL-3). The example's ask, block, proceed
  order is §8.1's RECOMMENDED ruling, shown for concreteness only —
  author to confirm at H's pack; an example cannot quietly settle an
  open ruling.
- **Epoch-1 restriction, stated:** `echo` must be all-false. The H
  driver calls the frozen `runMembrane` once per wire tick (§2.3),
  which resets the internal tick/think counters per call — inert
  under `noEcho`, wrong under echo. Echo-carrying hosts need a
  later exported one-tick step (register item, §8.9).

**Decision tick** (host → driver):

```json
{"tick": {"features": {"t": 417, "tool-name=bash": 1}, "menu": [3, 2, 1]}}
```

Reply: `{"choice": {"fire": 1, "slots": {}}, "p1": 0.8132,
"entropy_bits": 3.21}`. The agent does not move (no evidence).

**Evidence tick** (host → driver) — the original event's features,
re-sent, with the verdict:

```json
{"tick": {"features": {"t": 402, "tool-name=bash": 1}, "evidence": 1}}
```

Reply: `{"observed": 1, "loss_bits": 0.31}`. A tick MAY carry both
menu and evidence; the semantics are then the frozen loop's order —
choice from the predictive BEFORE the observation moves the agent
(Membrane.hs:308-322). Impossible evidence: `{"error":
"impossible-evidence"}`, agent unchanged, host decides (the governor
fails open at transport level — its own documented posture, distinct
from the tie-break ruling; see §8.1). Per-tick `"utility"` override =
per-request profiles (still world-supplied data).

Doctrine check: features in, evidence in, one choice out; actions
have no return values (`wStep :: s -> Choice -> s`,
Membrane.hs:272-279 — consequences arrive only as later features/
evidence, which is exactly the governor's deferred `user-responded`
shape); prices/hazards arrive as features; the host sets no priors —
`namespace`, `guards`, `menu` declare the WORLD, and the prior over
explanations stays `2^(-dl)` through `fromBits`, the only prior
source (Belief.hs:134-139).

---

## 2. Boundary H — the governor host

### 2.1 Scope

Serve credence-governor's WASTE decision (P(approve|X); binary
verdicts are `Obs = Int` over {0,1} natively, Enumerate.hs:247-250).
The harm overlay is a second explained stream with inverted polarity
(session.py:258-277) — exactly the later two-stream/K-ary territory
(§4, §6) — and routing is future demand (§8.10): both stay on the
Julia engine. Deployment is shadow/differential; Julia stays primary
until the gate (§2.8) passes and the author says otherwise.

### 2.2 The wire ruling: membrane wire + thin adapter, NOT a six-verb shim

Rejected: implementing the credence-skin JSON-RPC surface so the
governor needs zero changes. Three grounds, first two fatal:
(a) the governor asserts `routing_init/routing_decide/
routing_outcome` at boot or refuses to start (session.py:34-37,
verified) — a shim must fake or proxy a second engine; (b)
`structure_bma` carries `alpha0/beta0/p_edge` (session.py:118-128) —
the wire would smuggle host priors the doctrine forbids, and
silently ignoring declared priors is a lie on the wire; (c) handles
(`model_id`/`state_id`) are meaningless when one process is one
agent. The governor already treats the engine as swappable argv
(`CREDENCE_SKIN_COMMAND`); the adapter (§2.7) is the honest seam.

### 2.3 The driver: the frozen loop, one tick at a time

Verified: no one-tick step is exported (Membrane.hs:32-59;
`interpretPilot` is private, :337-343). The driver therefore calls
the frozen `runMembrane` with `n = 1` per wire tick over a constant
world:

```haskell
oneTick :: Features -> Maybe Obs -> [Affordance] -> Util Choice Obs
        -> Agent -> Maybe (Agent, TickTrace)
oneTick fs ev affs u =
  fmap (\(ag, ts) -> (ag, head' ts)) .
    runMembrane
      PureWorld { wFeats = const fs, wEvidence = const ev
                , wMenu = const affs, wStep = \s _ -> s }
      noEcho (PilotEU u) 1 ()
```

(Type-checked by inspection against `runMembrane :: PureWorld s ->
EchoSpec -> Pilot -> Int -> s -> Agent -> Maybe (Agent,
[TickTrace])`, Membrane.hs:300-301, and `PureWorld`'s verified
record, :272-279.) This reuses the frozen tick arithmetic verbatim:
features → predictive → choice → observe order, `negate lp / ln2`
loss bits, `TickTrace` scalars for the reply. A silent tick returns
the agent bit-identical (`Nothing -> Just (0, ag)`, :318-319). The
alternatives — recomposing `evalx argmaxEU ...` + `observe` from
exports (forks the arithmetic), or exporting `interpretPilot` (a
src edit bought for nothing) — are rejected.

New files, all class (a):

- `host-governor/Main.hs` — the IO loop: read line, pure step, write
  line, flush. Nothing else (the Host.hs discipline: IO only here).
- `host-governor/Wire.hs` — pure: a hand-rolled strict-subset JSON
  codec over `base` (the wire is ours; no aeson, so
  `cabal.project.freeze` is untouched — worth the codec), the
  world-declaration builders, and
  `step :: World -> Agent -> TickMsg -> (Agent, Reply)` — fully
  testable from the oracle without a process.

Cabal stanzas (drafted oracle-phase in
`test-govhost/stanza.cabal.draft`, applied by the author at the
freeze): `executable proplang-govhost` (base, proplang) and
`test-suite govhost` (base, proplang, tasty, tasty-hunit,
tasty-quickcheck, QuickCheck, process; `build-tool-depends:
proplang:proplang-govhost`; `hs-source-dirs: test-govhost,
host-governor`).

### 2.4 Features: one-hot indicators, the namespace declared

The six waste features are categorical with value counts
11/4/12/4/4/4 = 39 (config.py:13-31, verified by count). Encoding:
one indicator name per value — `"tool-name=bash" = 1.0`, absent
names read 0.0 (`Get`'s dormancy). Integer codes are rejected: `Gt`
thresholds over an arbitrary enumeration order carve meaningless
ranges of a categorical. Namespace = 39 indicators + `"t"` = 40
names; guard extras = one `(name, mkGrid name [0.5])` pair per
indicator (singleton grid: 1-bit mention).

Namespace price: `nsB = log2 40 ≈ 5.3219` enters every guard
derivation (Enumerate.hs:216-225). Guards get relatively dearer than
constants and walks — the namespace law working as written ("a
richer world makes every sentence about it more surprising",
typed-port-spec.md:188-202); the warm-count replay is what re-earns
the guards' posterior mass. This is scale exercise, not new
semantics: `enumerateModelsIn` under non-singleton namespaces with
extras is already frozen-exercised (test-membrane/Membrane.hs:236,
:365) and `bitsIn` is pinned at 2- and 3-name namespaces (:433-437).

Enumeration count: 1169 (frozen pins: test-hygiene/Hygiene.hs:98,
test/Anchors.hs:122, test/Acceptance.hs:344) + 39 × 72 = **3,977**.
Derivation, verified against Enumerate.hs:78-90 and :226-239:
1169 = 9 theta-constants + 8 walks + 16 tau-points × (9×8 ordered
theta pairs) built-in t-guards; each singleton-grid indicator family
is 1 × 72. Per-tick cost O(4×10³) hypothesis-steps — sub-millisecond.

### 2.5 Evidence: two tick kinds, arrival order

Decision ticks carry features + menu, no evidence; evidence ticks
re-send the judged event's original features (the governor already
recovers them: `daemon._features_for_event`) with the 0/1 verdict
(1 = approve, the waste polarity; harm inversion never reaches this
wire in H). No language change: `wEvidence` is already `Maybe Obs`.

Proposed ruling (register §8.2): evidence is conditioned in ARRIVAL
order (= governor log order = boot-replay order, so live == replay).
Stated facts, not bugs: `hmm` walks advance one latent step per
evidence tick — their effective clock is the evidence-stream index —
and the `t`-guard family reads the original event's re-sent `"t"`.

Boot: handshake, then warm counts flattened to pseudo-evidence ticks
(exact for exchangeable families; a declared approximation for the
hmm reading — register §8.3), then the live log's replay, then live.
Volume: ~39k warm ticks × 3,977 models ≈ 1.6×10⁸ hypothesis-steps —
tens of seconds, comparable to the Julia engine's boot; any replay
cap is a governor-side adapter knob, never a proplang constant.

### 2.6 Utility: a step table, derived and checked

`Util` is opaque world data (`mkUtil`, Syntax.hs:316-322) consumed by
`PilotEU` — the as-built rung, doctrinally the world-supplied
valuation (the latent-utility rung is increment D). The wire conveys
a finite table over (menu row × outcome): no formula language, so
nothing is smuggled past the recorded arithmetic-free boundary
(boundary-queue.md §5). Derivation from the governor's declared
constants (config.py:76-87; utility.bdsl, verified — c = cost 0.5,
λ = aversion 1.0, q = interrupt_cost 0.02):

| row | u(y=0, refuse) | u(y=1, approve) |
|---|---|---|
| ask     | −q | −q |
| block   | 0  | −λ·c |
| proceed | −c | 0 |
| think (internal) | −(c + λc + H + 1) | same |

Checks (against utility.bdsl's stated forms): EU(block) > EU(proceed)
iff −λcp > −c(1−p) iff **p < 1/(1+λ)** — the declared threshold
verbatim ("Block wins iff P(approve|X) < 1/(1+λ)"). Ask wins iff
q < min(c(1−p), λcp): the myopic perfect-information VOI, with the
baked assumption that a resolved ask makes the correct act free —
stated in the register (§8.4), where the gap to the engine's
cold-start `voi = 0.1·c` heuristic is also named as exactly what the
differential gate measures. The Think row is a dominated sentinel;
`menuOptions` always appends the internal menu, so the table must
cover it, and if Think somehow wins the driver answers honestly
(`{"choice": {"internal": "think"}}`) — the adapter maps it to its
transport posture with a warning.

### 2.7 The governor adapter (ordinary PRs in the living repo)

`MembraneClient` + `MembraneSession` presenting `BrainSession`'s
surface (`decide` / `observe`; `observe_harm` inert; `route` →
`None`), selected by `CREDENCE_MEMBRANE_COMMAND`; the daemon's
harm 7-tuple is projected out (H's scope cut, recorded). Shadow mode
first: both engines decide, Julia's answer fires, disagreements log.

### 2.8 The differential gate

The governor's existing engine-in-the-loop `posterior_eval` harness
(training/posterior_eval.py — decision-agnostic, verified) run
twice — Julia (waste-only) vs membrane — over RED_TEAM + BENIGN +
the captured-benign corpus. Gate: agreement ≥ 95% (proposed;
register §8.5) with EVERY disagreement enumerated in the increment
report and author-reviewed; where `structure_expect` is available,
also bound mean |P_julia(approve|X) − p1|.

### 2.9 The oracle: `test-govhost/`

ASCII names. Groups, in order:

- **g0 — the two mandatory opening fixtures** (§0.4): (1) `vPre`
  with a 2-element interior menu, distinct interior payoffs,
  per-decision channels, depth 1 — pinned against hand-derived
  arithmetic from the frozen definitions (pin provenance: derived
  from the frozen artifact, never a parallel simulation); (2)
  `vPreAt` at depth 2 with an action-dependent channel — the
  hand-computed W₂. Green from day zero; they open the suite.
- **g1 — wire codec goldens**: byte fixtures for handshake, both
  tick kinds, the error reply.
- **g2 — pure `step` semantics**: decision tick moves nothing;
  evidence tick's loss = the frozen `observe` arithmetic; combined
  tick order (choice before observe); impossible-evidence totality;
  per-tick utility override; menu-order tie-break behavior.
- **g3 — namespace-price pins**: `modelBits` of an indicator guard
  under the 40-name namespace equals the closed form with
  nsB = log2 40 (from Enumerate.hs's written derivation);
  enumeration count == 3,977.
- **g4 — analytic cross-checks (conjugacy as TEST ORACLE only)**:
  (i) restricted enumeration `enumerateModels [TBern, TC]` — the
  9-point grid posterior after (k, n−k) equals the closed-form
  grid Bayes computed in-test (machinery identity); (ii)
  |grid predictive − Beta(1,1) predictive (k+1)/(n+2)| bounded by
  an in-test quadrature bound, as a QuickCheck property over
  observation sequences.
- **g5 — process smoke**: spawn `proplang-govhost`, scripted stdin
  session, assert replies byte-wise.
- **P5 identity pins**: `bits` unchanged (==) on every §3-census
  pin after the single-site re-base.

Red-run: `test-govhost/red-run.sh` cloned from test-cirl's — the
stanza's exact flags, `-isrc -itest-govhost -ihost-governor`,
oracle-phase type-surface stubs (`step = error "unimplemented"`);
demonstrated red = g1/g2/g5 fail at RUNTIME under the full flag set
(the flag-fidelity clause, boundary-queue.md item 1).

Ablation (`test-govhost/ablation.sh`, the canonized 4-check rows; no
new DROP flag — H adds no grammar surface): consumer-coupling rows —
the driver fixture fails to compile under `-DDROP_ARGMAX`
(attribution: `argmaxEU`/`PilotEU`), `-DDROP_AFFORDANCE`
(`menuOptions`/`Fire`/`wMenu`), `-DDROP_ECHO` (`runMembrane` dies
with the echo layer) — plus the restricted-enumeration row:
`enumerateModelsIn ns extras (allTerminals minus TGet)` empties every
guard family at the governor namespace.

### 2.10 Files edited in the freeze commit (exact, complete)

(Syntax.hs is gated by gates 1–4, not the manifest — verified: zero
`src/` entries among the 68; "frozen" here would overclaim.)

| file | edit |
|---|---|
| src/PropLang/Syntax.hs | the P5 single-site constant (§0.3) — the ONLY src edit |
| proplang.cabal | append the two stanzas; add HOSTS docs to extra-doc-files |
| CLAUDE.md | the author's re-opening sentence (§0.2, by the author's hand) |
| MANIFEST.sha256 | author extends + re-signs |

`cabal.project.freeze`: untouched. Census target: EMPTY (no frozen
assertion literal moves), claimed with evidence under the CIRL
precedent's instruments, not asserted.

---

## 3. Sealing inventory and censuses

Re-verified against the frozen tree on 2026-07-08. Verification
commands stated so the claims stay checkable.

### 3.1 What is sealed, and how extension happens

- `Choice`, `InternalAct`: sealed by frozen exhaustive matches
  (test-membrane's `util1M`/`choiceName1` under `-Werror`). Extension
  is by NEW SORT — the Rung maneuver (Membrane.hs:157-188 precedent).
- `Pilot`: NOT sealed — every frozen occurrence is construction
  (verify: `grep -n "PilotIdle\|PilotThreshold\|PilotEU"
  test-membrane/Membrane.hs` — construction sites :184-374, plus the
  `Pilot (..)` import :60; no `case` match). Still not widened in
  any increment below: `interpretPilot`'s stateless per-tick shape
  cannot serve a latent-utility pilot, and a dormant slot violates
  the no-dormant-slot discipline (ruling M3/M9's form). D adds
  sibling faces instead.
- `PureWorld`: sealed by frozen record construction
  (test-membrane :134, :240, :308, :377). `runMembrane`,
  `enumerateModelsIn`: sealed by frozen call sites. Extension = new
  faces with the old face re-based as the degenerate case, identity
  pinned `==` (the `bitsAt`/`enumerateModels`/`vPreAt` pattern —
  three precedents).
- `Model`, `Agent`, `HypState`: constructors unexported
  (Enumerate.hs:20-47 export list) — internal additive extension
  legal, including new `Agent` fields.
- `allTerminals`/1169: pinned thrice (Hygiene.hs:98, Anchors.hs:122,
  Acceptance.hs:344). New hypothesis families NEVER enter
  `Terminal`; they get their own generator sort (§4).
- Gate 2 freezes only `Belief.hs`'s export list; additive exports
  from Syntax/Eval/Enumerate/Membrane are precedented every
  increment.

### 3.2 The frozen-literal censuses

Pins are written with per-file `lg = logBase 2` helpers — grep for
the applied form, not `logBase 2 7`:

```
grep -rn "lg 7"  --include="*.hs" test*/   # stdB census
grep -rn "lg 10" --include="*.hs" test*/   # nodeB census
```

- **stdB (lg 7): 4 assertion literals, 4 files** —
  test-expfam/ExpFam.hs:140, test-ladder/fixture/Sayable.hs:205,
  test-prepost/fixture/SayableP.hs:190,
  test-cirl/fixture/SayableC.hs:161 — plus comment/label lines
  (SayableC :16/:120/:159, SayableP :12/:188, Sayable :11/:203),
  the recorded stale-comment class.
- **nodeB (lg 10): 17 assertion literals, 7 files** — Hygiene.hs ×6
  (:122,:125,:128,:131,:134,:138), test-membrane/Membrane.hs ×4
  (:427,:434,:437,:520), Ladder.hs ×2 (:358,:362), ExpFam.hs ×1
  (:140), Sayable.hs ×1 (:205), SayableP.hs ×1 (:190),
  SayableC.hs ×2 (:158,:161-162).
- **carrierB**: 0 while the COMPILED registry `carrierNames =
  ["obs"]` (Syntax.hs:451-452) stays a singleton. World-PUBLISHED
  registries (§4) move nothing.

**Whole-ladder census: H = 0, A = 0, B = 0, D = 0, C = 4.** C is
the only census-bearing boundary and comes last (§9).

---

## 4. Increment A — K-ary observations (options-as-data)

### 4.1 The claim

K-ary observation is NOT a grammar change. It is (a) world data —
a declared K-ary carrier and an options grid, the evidence-side twin
of the affordance menu; (b) the namespace law's second application —
option and carrier mentions priced against WORLD-published data
(option mention = `log2 (K+1)` read from the published grid's
`gridSize`), with the compiled `carrierNames` left the frozen
worlds' singleton forever; (c) agent-layer generalization by new
faces. `type Obs = Int` already admits K-ary values; what binds
today is that `emit`/`mkAgent`/`observe`/`predictive` are hardwired
to `obsCarrier`/`obsSpace`.

### 4.2 Surface (additive; sketches, drafted fully in A's own pack)

```haskell
-- Syntax.hs: the world's full priced alphabet (namespace + declared
-- carrier registry; ruling M5's three-surface separation preserved)
data WorldAlphabet
mkWorldAlphabet :: Namespace -> NonEmpty Name -> WorldAlphabet
bitsInW :: KnownScope env => WorldAlphabet -> Expr env t -> Bits
-- bits / bitsIn re-based as singleton faces, == pinned

-- Enumerate.hs: the lookup generator's own sort (never Terminal)
data LookupFamily = LCat
enumerateLookup :: WorldAlphabet -> Grid -> Grid
                -> [LookupFamily] -> [Model]
-- Model grows internally: MCat Bits <option-code> <fidelity-const>
mkAgentIn :: Carrier Obs -> [Model] -> Agent
-- mkAgent = mkAgentIn obsCarrier, definitional, == pinned
```

Hypothesis family: bern's K-ary twin — "the answer is option j,
reported through a symmetric channel of grid-constant fidelity r"
(`P(y=j) = r + (1−r)/A`, else `(1−r)/A`; NONE = code 0 matches no
report). Fidelity is sentence CONTENT here, as θ is in `bern(θ)`;
the latent upgrade is B — the repo's own bern→hmm progression. The
host's `P_NONE = 0.5` prior is deliberately NOT reproduced: the
dl-prior prices NONE by its derivation, and the oracle's closed
form uses the dl-prior (host sets no priors).

### 4.3 Census, oracle, ablation

Empty census (no production-table count moves; family dl is
enumerator arithmetic). Oracle: the two mandatory fixtures; identity
pins (`bitsInW` singleton == `bitsIn` == `bits`; `mkAgentIn
obsCarrier` byte-stable on the frozen acceptance streams); exact
K=3+NONE categorical closed form at 1e-12 (conjugacy as oracle);
W1/W0 paired worlds (reports concentrate → MAP is the code-2
sentence, render string pinned; uniform reports → NONE wins by dl,
strict posterior ordering); the namespace-law twin pin (a (K+2)-point
options grid strictly reprices every option mention). Ablation:
`DROP_KOBS` triple-guard; restricted enumeration (no `LCat` → zero
lookup sentences); the data-deletion row (delete the published
options grid → the family empties).

### 4.4 Conventions (spec text at A's boundary, so hosts don't reinvent)

`reports` is THE Obs, one per tick — a document with m reports
occupies m ticks, its `group` feature constant across them; `group`
and the pre-multiplied `covariate` (life-agent computes
authority·subject·time host-side already — normalisation, not
inference) are FEATURES, context in interface.md §2's exact sense.
K is fixed per episode, published at tick 0. **Mid-episode K growth
is OUT OF SCOPE and named**: candidate discovery driven by evidence
is the moving Cromwell frontier — the ROADMAP cut list's declared
open research — and "just republish the options grid" would reprice
every option mention mid-flight against a law that prices per WORLD.
Flagged so it cannot silently regrow.

---

## 5. Conditional increment B — the reliability/noisy-channel family

**GATE (normative):** B is built only if A's differential gate —
life-agent's eval corpus, membrane agent vs the credence brain —
shows a correlated-evidence / reliability-learning shortfall. The
design is drafted now so the gate decision is cheap.

### 5.1 Semantics (the hmm move on evidence)

life-agent's channel (verified at credence/src/kernels.jl:111-141):
for a document d with m reports and covariate c ∈ [0,1],
`P(reports | V=v, ρ) = ρc·1{all m reports = v} + (1−ρc)/Aᵐ`, linear
in ρ, integrated analytically against Beta(4,4) today. This
factorizes EXACTLY as a per-document binary latent
z_d ~ Bernoulli(ρ·c) — "this document is reliable" — with reports
conditionally independent given (v, z): P(r|v,1) = 1{r=v},
P(r|v,0) = 1/A. That factorization is what makes the channel sayable
with machinery the repo already has: per-hypothesis filtered state,
the hmm mechanism verbatim.

```haskell
-- Enumerate.hs (additive): LookupFamily grows | LChan
-- Model:    MChan Bits <option-code>      -- rho is FILTERED, no dl
-- HypState: HChan Double (Belief (Double, Bool)) Double
--           -- code, joint (rho, z) over rhoGrid x Bool, last group
chanKernel :: Grid -> Double -> Kernel (Double, Bool) Obs
docKernel  :: Double -> Kernel (Double, Bool) (Double, Bool)
-- group boundary: rho persists, z' ~ Bernoulli(rho * c)
```

`stepHyp`'s `HChan` case: same group → condition the SAME joint it
predicted from (the HHmm line verbatim, Enumerate.hs:341-344); group
boundary → push through `docKernel c` first. Same-document
correlation is thereby inference, not host dedup. ρ contributes no
dl (filtered latent state — the walk precedent: "no
param-alternative bit"). The alternatives count A is a channel slot
from a declared world grid, mkC-priced — never a compiled constant.
Covariate: ONE pre-multiplied feature (recommended; a name-list
product inside the terminal is recorded and rejected — it duplicates
what the world can say in one name and smuggles a product into a
terminal that C's litigation would point at).

### 5.2 The non-expfam record (rider R2: the proof sketch, two legs at their true strengths)

B's channel joins `rw` as the alphabet's second recorded non-expfam
member. The claim arrives argued, and its two legs are NOT equally
strong — the asymmetry is part of the record:

- **Leg (i) — basis-relative.** The frozen statistic surface is
  scalar: `data Stats c` with sole member `SId` (Syntax.hs:133-136)
  and `statVal :: Stats c -> c -> Double` (Eval.hs:165) — a function
  of the OBSERVATION alone. The channel's per-report tilt has
  sufficient statistic `1{y=v}`, indexed by the hypothesis's latent
  v: inexpressible against the frozen signatures. Qualifier, stated:
  the per-report marginal (point mass mixed with uniform) is a
  categorical distribution, which IS an exponential family in the
  abstract given vector-valued statistics — leg (i) excludes it from
  the frozen scalar basis, not from exponential families as such.
- **Leg (ii) — absolute (the true T1 analogue).** The
  group-correlated joint over m same-group reports,
  ρc·1{all=v} + (1−ρc)/Aᵐ, is a MIXTURE, not a product of tilts: no
  base measure and statistic of any dimension recover it, because it
  does not factorize over reports at all.

One sentence for the spec text: *the per-report form is excluded by
the frozen scalar basis; the group joint is excluded absolutely* —
which pre-answers the vector-Stats objection (the gauss pair's named
debt): extending `Stats` to vectors would not help with the part
that matters.

### 5.3 Census, oracle, ablation

Empty census (KER stays 1, STATS stays 1; dl is enumerator
arithmetic). Oracle: mandatory fixtures; the z-factorization
identity — the agent's m-report group joint equals the kernels.jl
closed form at 1e-12 per ρ-grid point (the central pin);
grid→analytic Beta convergence — the exact Beta-moment V-marginal
(E[ρ^k] = ∏(α+i)/(α+β+i), a ten-line closed form in the oracle)
approached monotonically as the ρ-grid refines 8→32→128 (strict-
ordering pin, float-robust); the paired correlation discriminator
(3 reports in one group vs three groups: independent corroboration
strictly wins); fineness-charged-once extended to the ρ-grid; MChan
render strings pinned. Ablation: `DROP_CHAN` triple-guard with the
MEASURED loss claim — reliability unlearnable, correlated evidence
over-counts, a log-loss gap on the paired worlds, not mere
unutterability; restricted enumeration without `LChan`.

### 5.4 Unlocks

life-agent's `lookup_posterior` end-to-end without host priors or
trusted analytic integration: `reliability_categorical` ≡ the
meta-belief over (K+1) MChan hypotheses × per-hypothesis filtered ρ.
ρ persistence across questions = pre-episode history folded through
`cond`; extractor-reliability audits become ordinary verdict
evidence.

---

## 6. Increment D — the latent-utility pilot (before C; opens on step tables)

### 6.1 The load-bearing observation

The utility posterior IS an Agent. life-agent's learned utility
(latents narrowed by one-bit owner verdicts) has exactly the frozen
agent's shape: hypotheses = "ū is grid constant c_k" (the MBern
analogue, `UConst`) PLUS "ū drifts as a reflected walk at grid rate
ρ_u" (the MHmm analogue, `UWalk`) — **the hmm move applied to the
pointer, enumerated as CONTENT**, not a config knob. UWalk is the
principled answer to increment 6's measured corrigibility decay: a
posterior containing "the owner's preferences can change" never
fully concentrates, so deference retains value — and the drift rate
is inferred, Bayes doing the work (the forgetting-factor trap
argument, run on the pointer; "there is no forgetting; drift belongs
in the hypothesis space").

**[Amended at the R-D14 boundary, 2026-07-11: "deference retains value" holds at change points only — the VoI readout measurably dies in stationary stretches (voiB → 0 at k ≥ 4, Task 3); the never-zero floor is withdrawn; the strict drift edge at k ∈ {1,2,3} is the proven residue.]**

### 6.2 Surface (new sorts + sibling faces; Pilot and runMembrane untouched)

```haskell
-- Enumerate.hs: the utility fragment's generator + readout
data UFamily = UConst | UWalk
enumerateUModels :: Grid -> Grid -> [UFamily] -> [Model]
verdictKernel :: TauSpec -> Kernel Double Obs
-- tau-marginalised logistic owner: finite grid-tau mixture inside a
-- decision-free combinator; tau marginalised against its prior,
-- NEVER updated (Armstrong–Mindermann honored by construction)
latentMarginal :: Agent -> Belief Double
-- meta-mixture readout, built from public verbs only

-- Membrane.hs: the pilot sort and the driver face
data UPilot = UPilot
  { upSaid    :: Expr '[Double, Double] Double  -- the USay payload:
      -- the utility IS priced syntax (C4's discharge carried into
      -- the driver; step tables now, linear rows if/when C lands)
  , upVerdict :: Chan Double Double Obs  -- decision-indexed verdict
      -- channel (asking routes to verdictKernel, acting to noise);
      -- Chan stays the opaque world-data wrapper, its recorded debt
      -- not due (channels-as-hypotheses stay beyond scope, P5 armed)
  , upDepth   :: Rung                    -- depth through the ladder's sort
  , upPrice   :: Name                    -- tick price read as a feature (§1)
  }
runMembraneU :: PureWorld s -> EchoSpec -> UPilot
             -> Agent -> Agent -> Int -> s
             -> Maybe (Agent, Agent, [UTickTrace])  -- world, utility
```

`Pilot`/`runMembrane`/`TickTrace` untouched; `runMembraneU` and
`runMembrane` are SIBLINGS, not degenerate faces — recorded honestly
rather than forcing a fake identity (the one deviation from the
re-base pattern, stated). The pair belief (world latent × utility
parameter) is composed per tick from `latentMarginal` and the world
posterior by PUBLIC verbs only (`point`/`push`/`kernel` — no new
Belief export; I1 intact); `vPre` at `rungDepth upDepth` values the
interior menu {ask-owner, act-now, think-deeper} against coded
terminal menus (`affIdCode`; USay's `Var Z` convention — the coded-
menu discipline test-cirl already uses).

Stream convention (spec text at D; amended outcome-first at D's
freeze, 2026-07-09): a world-published `stream` feature tags each
tick — report | verdict | outcome | comparison. World hypotheses
explain report ticks; utility hypotheses explain verdict, outcome
and comparison ticks, each through its declared channel — outcomes
the primary, responder-free evidence, verdicts the noisy myopic
proxy (the D doctrine, O3). "Explained" is a role, not a type
(interface.md §2) — one evidence flow, no fifth flow.
Multi-latent utilities: per-latent agents under independence
(life-agent's own v0 exploits exactly this; only means matter for
one-shot optimise). Coupled folds (MarginReaction) are a NAMED
successor, not silent scope.

### 6.3 Census, oracle, ablation

Empty census (new sorts, new faces, new grids; nothing frozen
reprices). Oracle:

- Degeneracy pins: static-only utility enumeration (`UConst` alone)
  on the frozen CIRL worlds reproduces `bk`/`val`/`marginD` and the
  k=1 asking-death and k=4 listening-death digit-for-digit (1e-12).
- **THE HEADLINE PIN (author-ruled falsifiable, like increment 6's
  decay): with UWalk enumerated, VoI(k=12) ≥ floor > 0; in the
  paired static world, ≤ 1e-12 at the same k.** Corrigibility
  persists under sayable drift and dies without it. If the pin is
  wrong, the oracle catches it and that is a result too.
- The re-opened consult window: the verdict stream flips at t=60
  (the owner changes their mind — the shifted-world twin on the
  pointer). Pin: the drift-carrying agent resumes deference within a
  bounded window; the static agent never does; the MAP utility
  hypothesis becomes the walk, rate inferred as content, render
  string pinned.
- τ-marginalisation identity: verdict likelihoods equal the finite
  τ-mixture computed independently in the oracle (1e-12).
- The two mandatory fixtures, exercised NON-trivially here —
  multi-decision interiors and depth ≥ 2 are D's ordinary worlds —
  discharging the post-close review's named gap with real rows.

Ablation: `DROP_UPILOT` triple-guard (UPilot/runMembraneU/
latentMarginal/verdictKernel/UFamily die together; PilotEU's
world-supplied utility is all that remains — deference unbuyable,
measured); `DROP_UWALK` restricted enumeration (the floor collapses
to the frozen decay — drift is the floor's SOLE source). Where D's
text leans on B-style channel claims, §5.2's proof-sketch standard
applies.

### 6.4 Unlocks

life-agent's decide-with-learned-utility: `u_bar` (the collapse
theorem — posterior-mean utility for one-shot optimise) is
`latentMarginal` + `expect`; verdict conditioning replaces the
host-side fold; asking the owner is priced by real VoI with a
drift-borne floor. The governor gains its first sequential asset on
the same machinery.

---

## 7. Conditional increment C — arithmetic (the census-bearing boundary, last)

**GATE (normative):** C is built only if D's oracle demonstrates
step-table underfit — a measured, ablation-grade justification. The
terminal earns its keep BEFORE it exists; boundary-queue item 5's
debt comes due on evidence, not anticipation.

### 7.1 The adjudicated design: C-II

| route | grows | frozen literals moved | verdict |
|---|---|---|---|
| C-I: EXPR 10→10+N | nodeB | 17 in 7 files (§3.2) | rejected: maximally invasive |
| C-II: STDNAME 7→9 (`Add`, `Mul`) | stdB | **4 in 4 files** | RECOMMENDED |
| C-III: utility-only ARITH sort | payload only | 2 in 1 file | rejected on doctrine |

C-III is Kraft-honest (a re-declared hole with its own codeword set)
but doctrine-dishonest twice: design §2's premise is two fragments of
ONE program space, and a payload that can say `Mul` while the policy
fragment cannot creates a third sub-language; and item 5's recorded
wording — "arithmetic nodes are a future reported alphabet change,
**priced like everything else**" — is not utility-only scoping. It
also under-delivers (EU rows outside payloads want arithmetic too).

C-II: `Add, Mul :: StdName '[Double, Double] Double` behind
`DROP_ARITH` (one flag, both members, triple-guarded); `applyStd`
gains two definitional lines; `stdB` moves lg 7 → lg 9 at the single
site H landed. No `Neg` (spell it `Add x (Mul c₋₁ y)`; grids span
negatives) until a consumer proves the two-node spelling too dear —
the no-dormant-slot discipline applied to counts. Each use prices
`nodeB + stdB + args`: arithmetic is deliberately not cheap, and the
step tables that held the control identity at ≤1.1e-16 remain the
cheap spelling (the recorded accidental virtue preserved, not
repealed).

### 7.2 Census, oracle, pack

Census: the single-site bump + the FOUR enumerated stdB pins (§3.2)
amended by the author in the freeze commit + the stale comment/label
lines + the blind-spot re-runs (the prepost pack §2 procedure).
Oracle: price pins derived from `bits` against the drafted 9-member
surface (the b7f120e rule — never hand arithmetic against the old
count); the linear-form discharge pin — the CIRL worlds re-run with
the SAID `2u−1` (`Call Add (Call Mul (c₂ :* Var (S Z)) :* c₋₁)`),
decisions agreeing at every stage where |E[2u−1]| > 1e-12, the
control identity at RELATIVE 1e-12 (increment 6's one-ulp dust
becomes a pinned, tolerated fact); the frozen step-utility suites
stay green untouched. `stdB` stays lg 9 under `DROP_ARITH`
(written-alternatives convention — counting is by written
alternatives, not ablation-pruned availability). The author pack
amends the write-up's fourth honest sentence: "the policy fragment
has no arithmetic" was true through the write-up freeze and is
discharged here as item 5 promised — frozen text states no
falsehood.

---

## 8. The under-determination register (for the boundary packs)

Proposed rulings; each is the author's to make.

1. **Menu-order polarity (rider R1 — the headline item; H).** The
   precedent is CIRL C1's rider (CIRL_REPORT.md:114-119): "Off
   first-listed at the terminal menu is CL-3's deterministic
   tie-break — and here, for the first time, the tie-break CARRIES
   SAFETY CONTENT: proceeding must strictly earn it, so at exact
   indifference the agent shuts down. The same doctrine that made
   argmax deterministic makes the default safe." A waste-gating
   governor is the paradigm case of that precedent, and
   `proceed`-first would quietly adopt the OPPOSITE polarity —
   fail-open must not enter the record as a tie-break default.
   **Recommended: `ask, block, proceed`** — at exact indifference
   the agent buys information, which is the deference doctrine
   itself and increment 6's asking behavior at the driver layer;
   `block`-first is the fallback (C1's polarity verbatim);
   `proceed`-first is argued against. Distinct and unaffected:
   transport-level fail-open on daemon absence is the governor's own
   documented deployment posture, not a tie-break, and the spec
   keeps the two severed so the first cannot launder the second.
2. **Arrival-order conditioning (H)**: evidence folds in arrival
   order; hmm clocks tick per evidence event; the judged event's
   original `t` is re-sent. Live == replay.
3. **Warm counts as pseudo-evidence ticks (H)**: exact for
   exchangeable families; a declared approximation for hmm families.
4. **The ask row (H)**: u(ask,·) = −q bakes "a resolved ask makes
   the correct act free" (myopic perfect information); the gap to
   the engine's cold-start `voi = 0.1·c` heuristic is measured by
   the differential gate, never tuned away.
5. **Gate thresholds**: 95% decision agreement proposed (H's
   differential; A's life-agent differential analogously), every
   disagreement enumerated and author-reviewed.
6. **Namespace contents (H)**: 39 waste indicators + `t`; harm names
   excluded (scope cut, §2.1).
7. **Prior-mismatch note (H)**: Beta(2,2)/p_edge parity is
   impossible by doctrine (`fromBits` is the only prior source);
   parity is decision-level and measured.
8. **Per-episode K (A)**: fixed at tick 0; mid-episode growth is the
   moving-frontier cut, named in §4.4.
9. **Echo under the n=1 driver (H)**: all-false in epoch 1; lifting
   it needs an exported one-tick step (a class-(b) item for a later
   boundary, only on demand). The same exported step is the
   prerequisite for wiring D's pilot to any HOST (`runMembraneU`
   behind the wire); D's own oracle worlds run full episodes and are
   unaffected.
10. **Named successors**: the harm overlay (second explained stream —
    D's two-stream convention is its route); routing (the roster is
    affordance-shaped with priced slots, but Beta-emission and
    Poisson-Gamma families are future demand); coupled utility
    latents (§6.2); the depth-2 guard widening (§2.4, only if H's
    gate fails); vector Stats / the gauss pair (unchanged: B's leg
    (ii) shows it would not buy the channel).
11. **P5-constant identity pins (H)**: the re-based `bits` == every
    §3.2 pin, checked in g-P5.
12. **Why H's ask is myopic, and the D0 option (author to rule).**
    H's step-table ask is myopic on purpose: (a) the incumbent is
    myopic (`expected_repeats = 0.0` ⇒ myopic == today; the tail
    belief ships unused; the engine's ask is one-step VOI with the
    cold-start `0.1·c` heuristic), and the differential gate must
    measure the engine swap, not a policy upgrade; (b) a
    deliberative ask needs the ask's evidence channel declared (a
    decision-indexed `Chan`: ask → the verdict kernel, act →
    silence) and a pilot face that runs `vPre` over the menu — no
    frozen pilot does (PilotEU is one-shot argmax-EU), and
    computing vPre host-side in Wire.hs would fork decision
    arithmetic outside the membrane's path; (c) doctrine — the
    myopic case is the ladder's chosen rung, not a branch; depth is
    bought by measurement. OPTION on the record: D splits — **D0 =
    the preposterior pilot with a WORLD-SUPPLIED utility** (vPre +
    verdict Chan + Rung; new faces only, empty census; §6's pilot
    minus UConst/UWalk); D then adds utility-as-latent on D0's
    pilot. **D0's gate metric, named (it is NOT §2.8's agreement
    percentage, which is structurally blind to a defect both
    engines share — two myopic engines agree about their shared
    myopia):** outcome-scored myopia regret on the labeled eval
    corpora via `posterior_eval` — the count of outcome-labeled
    cases where the myopic decision erred (a wrong proceed or
    block) and a verdict-resolving ask at the declared q would have
    flipped it, plus asks fired where the posterior already
    sufficed. D0's ruling stays open until that evidence exists —
    the item's own discipline. The ladder's §9 gates are unchanged
    either way; the split only moves the deliberative ask one
    boundary earlier if the regret metric earns it.

    RESOLVED at D's freeze (2026-07-09, ruling R-D2): D0 is SKIPPED.
    The D boundary's ruling 2 retired the governor's declared
    utility constants, so the world-supplied utility a D0 pilot
    would run on no longer exists — the stepping stone dissolved
    under the doctrine, not under budget. The regret metric named
    above survives as the outcome-scoring discipline of the
    outcome-scored bench bed (HOSTS_D_PACK section 13 item 4). D
    proceeds directly to utility-as-latent, and the deliberative ask
    ships with it.

---

## 9. The gated roadmap

```
H (governor host; P5 constant; zero alphabet change)
└─ may ship and STOP — every later boundary is demand-driven
D (latent-utility pilot, outcome-grounded; empty census)
└─ gate: the governor's measured demand (H's grid-ceiling
   finding; credence and the declared constants retired) —
   D0 subsumed, R-D2
A (options-as-data; empty census)
└─ gate: life-agent differential vs the credence brain
   B? (reliability channel; empty census)
   C? (arithmetic; the ladder's ONLY census: 4 literals)
```

Reordered at D's freeze (2026-07-09, ruling R-D1): D's demand
materialized at H, measured; A's has not.

Each boundary is separable — its own oracle directory, red-run,
ablation, author pack, signed tag, manifest re-sign. Never merge C
with a large surface: the census-bearing change ships alone so the
moving literals stay attributable (the prepost lesson). The whole
ladder, fully built, moves four frozen assertion literals — all at
C, all precedented in form.

---

## References (verified 2026-07-08)

proplang (frozen): src/PropLang/Membrane.hs (:32-59 exports, :127
Affordance, :254-258 Pilot, :272-279 PureWorld, :300-329 runMembrane,
:337-343 interpretPilot private); Enumerate.hs (:67-71 Terminal,
:78-90 grids, :185-196 enumerate faces, :216-239 dl arithmetic,
:247-260 Obs/carrier, :306-311 HypState/Agent, :336-364
stepHyp/observe); Syntax.hs (:133-136 Stats, :172-187 USay, :241-242
mkC, :265-309 StdName, :311-340 Util/Chan, :363-436 bits/bitsAt +
the five constants :384-389, :443-452 the two compiled registries,
:463-483 Namespace/bitsIn); Eval.hs:165 statVal;
typed-port-spec.md:147-202 (production table + namespace law);
boundary-queue.md (item 5; custody record); WRITEUP.md:459-477
(post-close review), :497-500 (termination); PREPOSTERIOR_PLAN.md:
35-40 (P5); CIRL_REPORT.md:54-58, :114-126 (C1 + rider,
arithmetic-free record); test-membrane/Membrane.hs:236, :365, :433-437,
:468-469 (non-singleton precedents); proplang.cabal:14-15,
:143-155 (warnings, stanza pattern).

credence-governor: …/credence_governor_core/session.py:30-51
(required/optional verbs), :118-128 (structure_bma priors), :200-277
(decide/observe); config.py (GOVERNANCE 39 values, UTILITY);
data/bdsl/utility.bdsl (EU forms, thresholds); daemon.py
(:257-267 extraction, :291-312 decide_sync, :315-323 features-for-
event); training/posterior_eval.py (the differential harness).

life-agent: core/lookup.py:592-670 (the channel + tempering);
core/utility.py (the learned latents); bridge/observations.py:42-50
(the abstract observation).

credence: src/kernels.jl:111-141 (the channel identity B pins).
