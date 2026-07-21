# membrane-wire — the host contract (boundary H; HOSTS_PLAN section 1-2)

Drafted in H's oracle phase; enters the manifest at H's freeze, by the
author. The wire is the membrane's three flows plus a world
declaration, all data: features in, evidence in, one choice out.
Replies carry one choice and read-only scalars; no belief object, no
handle, no prior, no formula ever crosses.

## 1. Transport

JSON-lines over stdio: one request line, exactly one reply line,
synchronous, in order. Protocol major version 1 (`"membrane": 1` in
the handshake; `"proto": 1` in its reply). Unknown object keys are
IGNORED — they parse and drop, never error (new-key negotiation:
optional keys degrade by scalar fallback, never by capability probe).

Canonical rendering (what the driver emits): no whitespace outside
strings; object keys in insertion order; a numerically integral value
renders without a decimal point (`1`, not `1.0`); any other value
renders as Haskell `show` (shortest round-trip; values below 0.1 use
e-notation, which is legal JSON); strings escape `"` `\` and newline.
The parser additionally tolerates whitespace between tokens.

## 2. Handshake — the world declaration (first line)

```json
{"membrane": 1, "world": {
  "namespace": ["t", "<feature>=<value>", "..."],
  "guards":    [{"name": "<feature>=<value>", "grid": [0.5]}, "..."],
  "menu":      [{"name": "<writable-name>", "grid": [0.5, 1.5]}, "..."],
  "utility":   {"form": "said@1",
                "said": ["-", ["var", 1],
                         ["*", ["c", 0.2], ["get", "a"]]]}}}
```

*(This block is repaired in place at each freeze that falsifies it,
under the frozen-layer inventory: at the step-7 unify freeze the
example still carried the id/slots menu shape, the table@1 fire-row
utility and the echo block — all dead since step 5; at the step-8
outcome freeze the `assign@1` rows died on their printed date and
`said@1` — the utility AS A SENTENCE — took their place. The example
always shows the current contract; the historical shapes live in this
file's git history and its dated notes.)*

Reply: `{"ok": true, "proto": 1, "models": N, "namespace_bits": B}`.

- `namespace` is the world's declared name set under ONE law: every
  name mention prices log2 |namespace|. It must be nonempty, cover
  every guard name, and (RIDER 2, bound at step 6; the step-7
  conformance sentence) include EVERY writable name, including names
  not yet in any published menu — a world may not conjure a name
  mid-episode. Membership is declared here and is IMMUTABLE:
  publication toggles availability, not membership, so owned
  posterior odds are invariant under mid-episode publication (pinned
  bit-exact by test-unify).
- `guards` extend the model fragment's guard families
  (`enumerateSentencesIn`), one `(name, threshold grid)` pair each;
  grids nonempty.
- `menu` declares the writable names with their grids (the step-5
  shape: names and grids, nothing else). The agent's choice is a
  full ASSIGNMENT of values to the published names; `wait` is every
  name at the FIRST point of its grid (structural), and argmaxEU
  ties resolve first-listed (CL-3) — so wait, the option space's
  head by construction, keeps ties.
- `obs_arity` (OPTIONAL; W3, the arity freeze, 2026-07-21;
  delegated edit, wire-author-pack.md Part VII): the world MAY
  declare the observation channel's arity — `"obs_arity": K`, flat
  in `world`, K integral and >= 2. ABSENT means the shipped binary
  channel, bit-identically (the shipped call path untouched). The
  key declares the CODOMAIN, under R-W1's ruled line: "the wire may
  declare the codomain of observation — what the channel can emit —
  never the support of belief about the channel's law." The
  codomain is atoms 0..K-1 with atom 0 the NULL emission (forced by
  the K=2 anchor: the arity-2 family must be `bernBody` bit-exactly
  and bernBody's background is 0 — the freeze sitting's ruling 1).
  The channel's LAW stays in-language: per-atom concentration
  sentences distinguishing one positive atom j in {1..K-1} at rate
  theta, the remaining mass spread uniformly, the atom mention
  priced log2(K-1) by the namespace law (zero at the default — the
  M1 singleton shape, so shipped prices cannot move). Malformed
  declarations (non-integral, K < 2, non-finite) are validation
  failures — FAIL-CLOSED. A declared K=2 coincides with the absent
  key EXTENSIONALLY (pinned byte-equal/bit-equal by test-arity g1b/
  g2, never a branch). Declared limitation (R-D23): the null atom's
  predictive mass is capped at 1/(K-1) by the family's shape, so a
  null-dominant sparse channel at K >= 3 has no good hypothesis
  here; the richer two-parameter family is its demand-gated heir
  (wire-author-pack.md VII.2(e)).
- DISJOINTNESS (ruling D-b2, the step-7 conformance sentence): the
  names a world publishes as tick features and its writable names
  are DISJOINT sets — the stream is the world's document, one
  authority, no merge semantics. A tick that publishes a writable
  name as a feature is a validation failure.
- `utility` (form `said@1` — the step-8 replacement; `assign@1` died
  on its printed date, at the outcome freeze): THE PRINCIPAL'S
  DECLARATION, a SENTENCE — `"said"` carries the utility program as
  an S-expression, parsed against the priced grammar and priced like
  any sentence (`{"form": "said@1", "said": ["-", ["var", 1],
  ["*", ["c", 0.2], ["get", "a"]]]}`). Its scope is the residue pair:
  `["var", 0]` the option code, `["var", 1]` the outcome; `["get",
  "<name>"]` reads the tick's features — UTILITY READS FEATURES,
  because features are the consequences (the step-8 repeal). The
  declaration is a POINT-MASS PRIOR over the program shape with the
  parameter on its declared grid — the GRID-PRICED DEGENERATE LATENT
  (the declared-table-as-point-mass-latent doctrine made wire-real;
  the OB-8 narrowing, ruled 2026-07-21): a table is the degenerate
  case of the latent machinery, never a parallel mechanism. The
  utility block MAY carry an optional `"cgrid"` key — a nonempty
  array of finite JSON numbers, the world's declared constant grid.
  When present, every `["c", v]` in the program must sit ON the grid
  by PARSED-VALUE IDENTITY: the constant and the grid pass through
  the same JSON-number door, one parse site, exact equality of the
  parsed doubles — spelling-invariant, epsilon-free, fail-closed
  off-grid (the D-f8 door discipline; a tolerance would be the cl4
  disease at the declaration surface). The hello reply then carries
  `"utility_bits"`: the declared program's price under the one
  arithmetic (`bitsIn` against the declared namespace and grids) —
  the `namespace_bits` reporting law applied to the next declared
  surface. When `cgrid` is ABSENT, each constant is its own
  singleton grid (0 content bits) and the reply is byte-identical to
  the pre-W4 wire. The full priced grammar parses: thirteen forms
  (`if > + - * / log exp neg c var get`); `<` has NO codeword — `Lt
  x y` IS `Gt y x` by argument swap, bit-identical, so a codeword
  would be pure prior distortion. Unparseable or unpriceable
  declarations are validation failures — FAIL-CLOSED. A hello with
  no utility block is lawful; decision ticks then choose `wait`. No
  formula language exists on this wire: a program is DATA, priced
  through the one mechanism.

  > **[Dated repair — the W4 freeze, 2026-07-21; supersedes the
  > 2026-07-20 bracket, whose falsified promises land here as
  > shipped truth; author's rulings quoted.]** Why `cgrid` is
  > lawful where the emission grid was refused (recorded against
  > the next boundary audit, per ruling 1): *"a grid for belief
  > about the world's law is the agent's representational choice
  > and never crosses the wire; a grid for the world's own declared
  > preferences is the declaration itself — the principal is the
  > authority on what it values and at what resolution it cares to
  > say so. Economics, not epistemics; the same statement, fourth
  > application."* And why the parameter latent ships DEGENERATE
  > and no further (the OB-8 narrowing, ruling 2): the open
  > parameter latent's wire form *"requires the world to declare
  > P(evidence | utility parameter) — how its own feedback must be
  > interpreted — and that is not merely epistemics over the wire;
  > it is the door to authored deference: a principal that declares
  > 'read my silence as approval' has written the agent's inference
  > about the principal, which is the manipulation shape the CIRL
  > structure exists to keep out of the world's hands. The world
  > declares WHAT it values, at its chosen resolution; it never
  > declares HOW evidence about its values must be read."* That
  > interpretation lives in-language — priced, enumerable,
  > revisable under the posterior — the test-outcome g5
  > composition, registered as future demand under its own gate.
  > This section's promise of a parameter latent is NARROWED to the
  > degenerate form accordingly.
- The host sets NO priors: the terminal set is not on the wire; the
  prior over explanations is 2^(-dl) through the one prior source.
- Value pricing (step 7, M5 repealed): an action value prices at
  log2 |its grid| through the one constant door wherever a sentence
  utters it — the same arithmetic as every constant since the
  pricing freeze; nothing re-prices at publication, because
  DECLARING costs (at handshake) and publishing never did.

Validation failures answer `{"error": "<reason>"}` and the process
stays on the handshake state.

## 3. Ticks

> **[Stated at the wire boundary opening, 2026-07-20; issue #8's doc
> half.]** THE SHIPPED DECISION RULE IS MYOPIC: `choose`
> (`Host.hs`) is a single-shot one-step-EU argmax over the tick's
> menu — candidate EU at the predictive under each option's
> assignment, strict improvement displaces, first-listed wins ties.
> The deliberation ladder (depth as `Push`-iterated sentences,
> priced per rung, argmax across rungs — step 10's composition,
> pinned at `test-reflexive/`) is a demonstrated CAPABILITY of the
> grammar, NOT shipped behind this wire — myopia was ruled
> deliberately in the H era (HOSTS_PLAN register 12; stated at
> :214-224 of this document's HISTORICAL sections, which is why the
> live sections read silent until this bracket). Hosts pricing
> information-gathering against terminal actions must not plan
> against a preposterior here unless ruling R-W2 (WIRE_PLAN.md §5)
> opens W4c and its freeze replaces this bracket.
> *[Conditional RESOLVED at the rulings sitting, 2026-07-20: R-W2
> ruled — W4c does NOT open; depth is delivered at boundary R as an
> in-language purchase (the agent buys deliberation depth under
> clock-endogenous prices; WIRE_PLAN.md §5, R_SCOPE.md). The wire
> stays myopic until R; hosts must not plan against a preposterior
> here until R's freeze re-states this section.]*

Decision tick — features + menu, no evidence; THE AGENT DOES NOT
MOVE:

```json
{"tick": {"features": {"t": 417, "tool-name=bash": 1}, "menu": ["a"]}}
{"act": {"a": 0.5}, "p1": 0.81, "entropy_bits": 3.2}
```

*(Examples repaired in place at the step-7 unify freeze: a tick's
`menu` lists the names available this tick; the reply's `act` is the
chosen assignment — the fire/slots encoding died at step 5.)*

Evidence tick — the JUDGED EVENT'S ORIGINAL features re-sent, with
the verdict (waste polarity: 1 = approve):

```json
{"tick": {"features": {"t": 402, "tool-name=bash": 1}, "evidence": 1}}
{"observed": 1, "loss_bits": 0.31}
```

- A tick MAY carry both menu and evidence; semantics are the frozen
  loop's order — the choice is computed from the predictive BEFORE
  the observation moves the agent. The reply is the union of the two
  shapes.
- A tick with neither is the silent tick: `{"ok": true}`, agent
  unmoved.
- `"utility"` on a tick is the per-request profile: a FULL
  replacement `said@1` declaration for this tick only (the internal
  row died with the sentinel at step 5).
  > **[Dated repair — the W4 freeze, 2026-07-21; the frozen-layer
  > inventory's find, falsified sentence above.]** UNSHIPPED: the
  > shipped `tick` handler reads no utility key — this sentence
  > describes a capability no code implements and no oracle pins.
  > It is not deleted, because the demand has a home (ruling 5): a
  > per-tick utility revision is the principal changing its
  > declaration mid-episode, the SAME CLASS as mid-episode K growth
  > — OB-11's ruling-pending family (issue #10). The demand
  > registers beside OB-11; one doctrine for one class of
  > mid-episode declaration change, and when that ruling comes it
  > answers both faces at once. Until then hosts must not send
  > per-tick utility and must treat this bullet as future surface.
- Ordering ruling (register 8.2): evidence conditions in ARRIVAL
  order — live equals replay. Stated facts, not bugs: hmm-family
  latents advance one step per EVIDENCE tick (their clock is the
  evidence-stream index), and the t-guard family reads the re-sent
  original `t`.
- Impossible evidence (zero marginal likelihood — includes any
  verdict outside the observation space): `{"error":
  "impossible-evidence"}`, agent UNCHANGED. The host decides what
  fail-open means at transport level; the wire never defaults it.
- `p1` in a decision reply is P(atom 1) at ANY arity (W3, the arity
  freeze, 2026-07-21). This is the null-atom convention's own
  corollary, not a separate choice: atom 0 is the null emission
  (section 2's `obs_arity` bullet), so atom 1 is the distinguished
  positive event the diagnostic always read — the diagnostic's
  meaning and the codomain's background are ONE recorded fact.
  Pinned against the predictive by test-arity g7d.
- Choice encoding: `"act"` is the full assignment object,
  `{<writable-name>: <value>, ...}` — one value per name published
  this tick (the empty object when no menu is published: the empty
  product's one element IS wait). The fire/slots and internal-think
  encodings died at step 5 (repaired in place at step 7).

> **Step-5 amendment (the actions freeze, 2026-07-16; delegated edit,
> actions-author-pack.md §14):** ACTIONS BECOME FEATURES. The wire's
> action rows are now NAMES AND GRIDS: a world declares its writable
> names with their grids (the menu), and the agent's choice is a full
> ASSIGNMENT of values to those names — the `slots` object was always
> a written feature vector, and it is now labeled as one. `wait` is
> every action name at the FIRST point of its grid (structural; the
> world's declaration says what inaction looks like). **The internal
> think row is RETIRED — the sentinel's step-5 date arrived**: a
> menuless world's option space is the empty assignment (the empty
> product's one element), so totality needs no fabricated row. The
> tick/think echo counters are retired with the echo path — what died
> is the agent echoing ITSELF; a world remains free, under
> CL-1-at-the-echo, to measure the agent's latency from OUTSIDE the
> membrane and publish it as an ordinary feature (that capability was
> always world-side and survives untouched). Value pricing of
> assignments binds at step 7 with M5's repeal; nothing on this wire
> prices an action until then.

> **Step-7 amendment (the unify freeze, 2026-07-17; delegated edit,
> unify-author-pack.md Part V): ONE PRICED SURFACE, and the wire's
> incorrect residue repaired.** M5 is repealed: the namespace law's
> own rationale covers the action vocabulary; there is no second
> priced surface. The three conformance sentences (completed
> namespace, D-b2 disjointness, value pricing) are folded into
> section 2's bullets above, and sections 2-3's examples are repaired
> in place to the current contract (the sitting's directive: nothing
> incorrect stays frozen). The `assign@1` utility form enters as
> INTERIM with its death date printed — step 8 replaces it when
> utility moves to world states. SCOPE BRACKET for sections 4-6
> below: they are the OLD roadmap's record (increments H and D — the
> governor's encoding, the table@1 derivation, the latent@1 v2
> surface, with goldens pinned by the RETIRED test-d suite). The
> re-derived engine's conformance surface is sections 1-3 as amended;
> the utility surface is re-derived at step 8, with section 6's
> latent@1 record as its informing precedent. Sections 4-6 are
> historical from this freeze — kept for the record, binding on
> nothing current.**

> **Step-8 amendment (the outcome freeze, 2026-07-17; delegated edit,
> outcome-author-pack.md Part VIII): UTILITY IS A SENTENCE.**
> `Util a y` — the host-function wrapper that let utility sit on
> (act, outcome) pairs — is deleted from the language; utility is a
> priced program evaluated at the tick's features, latent in its
> parameter (CIRL). On this wire that is `said@1`, replacing
> `assign@1` on the date §2 printed for it. The arithmetic-free
> boundary is UNMOVED and now better founded: what crosses is a
> sentence of the one grammar, priced by the one mechanism, not a
> formula hatch — and the host cannot smuggle arithmetic through it,
> because everything it can say, the language could already say.

## 4. Features (the governor's encoding, HOSTS_PLAN 2.4)

Categorical features are one-hot indicators, one name per value —
`"tool-name=bash": 1` — absent names read 0.0 (dormancy is free; a
schema-grown value degrades gracefully). Integer codes are rejected:
thresholds over an enumeration order carve meaningless ranges. The
governor's waste surface is 39 indicators (six features, value counts
11/4/12/4/4/4) plus `t`: 40 names, namespace_bits = log2 40, and
3,977 enumerated hypotheses under singleton [0.5] indicator grids.

## 5. The utility table (the governor's derivation, HOSTS_PLAN 2.6)

From the declared constants (c = cost, lambda = false-block aversion,
q = interrupt cost):

| row | u(y=0, refuse) | u(y=1, approve) |
|---|---|---|
| ask     | -q | -q |
| block   | 0  | -lambda * c |
| proceed | -c | 0 |
| think   | -(c + lambda*c + H + 1) | same |

Checks carried by the oracle: block beats proceed iff
p < 1/(1+lambda) — the engine's declared threshold verbatim; ask wins
iff q < min(c(1-p), lambda*c*p) — the myopic perfect-information VOI,
whose baked assumption (a resolved ask makes the correct act free) is
register item 8.4: measured by the differential gate, never tuned
away. Why the ask is myopic at H, and the D0 route past it, is
HOSTS_PLAN register item 12.

## 6. Utility form latent@1 (v2 — increment D; table@1 remains valid)

The `utility.form` string is the dispatch seam: `table@1` worlds are
byte-identical to section 5; `latent@1` declares utility as LATENT —
a priced sentence over (action, outcome-vector) whose residual
exchange rates are grid-priced hypotheses learned through declared
channels, never a table of constants. The normative examples in this
section are test-d's gWire goldens (whitespace added for reading —
section 1's parser tolerance; the two reply lines are exact canonical
renders, pinned byte-for-byte by the oracle).

### 6.1 The latent utility block (handshake)

```json
{"form": "latent@1",
 "said": ["var", 1],
 "residuals": [{"name": "theta_ask", "grid": [0.05, 0.1, 0.2, 0.4]},
               {"name": "theta_bad", "grid": [0.1, 0.5, 1]}],
 "tau":   {"points": [0.5, 1, 2], "weights": [0.5, 0.3, 0.2]},
 "price": "tick-price",
 "gauge": {"zero": "status-quo", "scale": "usd"}}
```

- `said` is the USay payload as an S-expression, parsed against the
  priced grammar — a sentence, not a formula hatch: only the frozen
  alphabet is utterable, and the payload prices like any sentence.
- `residuals` name the latent exchange-rate components, one priced
  grid each. Grids are POSITIVE by rule — the charity restriction
  (admit negative scaling and the sign-flip twin re-enters as an
  utterable sentence) AND a content commitment (a floor on theta_ask
  is a substantive prior claim about the owner's annoyance): R-D8,
  both faces on the record.
- `tau` is the declared owner-response spec: finite tau points with
  DECLARED prior weights, marginalised, never updated (R-D9;
  the tau-u entanglement honored by construction).
- `price` names the tick-price FEATURE — measured cost as world
  data, never a declared constant (rider 1; the stratification rule:
  no channel's operating cost may depend on a latent that channel is
  a route to).
- `gauge` is the declared affine gauge, R-D7 as amended: `zero`
  names the status-quo anchor (u = 0); `scale` names the measured
  unit whose slope is declared 1 — the accounting layer's dollar
  term spends the scale. There is NO second anchor: affine freedom
  is two degrees and both are spent before one could enter.

Reply — v1's shape plus the latent census:

```
{"ok":true,"proto":1,"models":1241,"namespace_bits":1,"ulatents":3}
```

`ulatents` counts the per-latent agents: the pointer plus one per
residual component (here 1 + 2). Product form is architecture, not
estimation (rider 2, R-D13) — and it is what keeps the model count
ADDITIVE rather than multiplicative (R-D19).

### 6.2 Streams

Evidence ticks carry an optional `stream` tag —
`report | verdict | outcome | comparison`; absent means untagged,
the v1 reading. World hypotheses explain report ticks; utility
hypotheses explain the other three, each through its declared
channel — outcomes are the responder-free evidence, verdicts the
noisy myopic proxy. "Explained" stays a role, not a type: one
evidence flow.

```json
{"tick": {"stream": "verdict", "features": {"t": 1, "x": 1}, "evidence": 1}}
```

Menu items MAY carry a `comparison` payload (the lottery: two acts
over measured outcomes, one at a declared probability) — elicitation
as an ordinary priced affordance, bought by argmax exactly when VoI
justifies it. Its cost is measured units through the accounting
layer, never theta_ask-denominated (rider 1).

### 6.3 observe_batch and observe_counts (the warm channel)

`observe_batch` — an array of evidence ticks, one reply each. Fixes
ROUND-TRIPS (H's 39k-tick cost finding), not engine work:

```json
{"observe_batch": [
  {"stream": "verdict", "features": {"t": 1}, "evidence": 1},
  {"stream": "outcome", "features": {"t": 2}, "evidence": 0}]}
```

`observe_counts` — the count-collapsed warm row. D's budget
decomposition measured the per-tick cost as ENGINE, not transport
(6.5 of 8.6 ms/tick on the reference world), so batching alone
leaves minutes of cold-start replay; counts remove the ticks
themselves:

```json
{"observe_counts": {"stream": "verdict",
                    "features": {"t": 1, "x": 1},
                    "counts": {"1": 30000, "0": 9314}}}
```

One reply for the whole collapse. Semantics: per-hypothesis
likelihood exponentiation — EXACT for exchangeable (iid-emission)
families; for state-carrying families (hmm / UWalk) it IS the
declared warm-flattening approximation, printed rather than
smuggled. O(contexts x grid), not O(ticks): count-collapse the
exchangeable, replay only the drift-carrying. (The observed-reply
render for batch rows and the counts reply land with D's
implementation; they are not golden-pinned.)

### 6.4 The v2 decision reply

```
{"choice":{"fire":3,"slots":{}},"p1":0.5,"entropy_bits":3.25,"residual_mean":0.42,"sensitivity":true}
```

Two readouts join v1's: `residual_mean` (the pointer marginal's
mean through the wire) and `sensitivity` (does the argmax flip
across the residual's support?). Both are OBSERVABILITY-ONLY —
consumer discipline, binding: routing to the elicitation affordance
happens ENGINE-SIDE, by argmax over the declared menu; an adapter
that branches on these scalars has re-created host-side decision
forking (HOSTS_PLAN 8.12(b)), and the governor-side tests pin the
adapter's decide path as a pure choice-relay.

### 6.5 Errors (R-D12)

An unknown stream tag, a gauge violation, or a comparison answer on
a non-comparison menu item each answer `{"error": "<reason>"}` with
the agent UNCHANGED — section 3's impossible-evidence discipline,
unchanged. Unknown object KEYS still parse and drop (section 1);
an unknown enumerated VALUE in a known key is an error, never a
silent default.
