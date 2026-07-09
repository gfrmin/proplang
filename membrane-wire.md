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
  "menu":      [{"id": 3, "name": "ask", "slots": []}, "..."],
  "utility":   {"form": "table@1",
                "rows": [{"fire": 3, "u": [-0.02, -0.02]}, "...",
                         {"internal": "think", "u": [-3, -3]}]},
  "echo":      {"last_action": false, "tick": false,
                "ticks_spent_thinking": false}}}
```

Reply: `{"ok": true, "proto": 1, "models": N, "namespace_bits": B}`.

- `namespace` is the world's declared Get-mentionable name set (the
  namespace law: every guard's name mention prices log2 |namespace|).
  It must be nonempty and cover every guard name.
- `guards` extend the model fragment's guard families
  (`enumerateModelsIn`), one `(name, threshold grid)` pair each;
  grids nonempty.
- `menu` declares affordances as data: world-owned stable positive
  ids, display names, typed slots (name, grid points). Listing order
  in a TICK's `menu` array is NORMATIVE: argmaxEU ties resolve
  first-listed (CL-3). The governor's normative order is
  **`ask, block, proceed`** — RULED by the author at H's pack (R1,
  HOSTS_PLAN 8.1): at exact indifference the agent buys information;
  CIRL C1's fail-safe polarity (`block` first) is the recorded
  fallback. Fail-open never enters this wire as a tie-break default.
- `utility` is a finite STEP TABLE: per affordance id,
  `[u(y=0), u(y=1)]`, plus exactly one `internal: "think"` row (the
  internal act is always in the option space; give it a dominated
  sentinel row). No formula language exists on this wire — the
  arithmetic-free boundary stays where the record put it.
- `echo`: epoch-1 RESTRICTION — all three must be false. The H
  driver re-enters the frozen `runMembrane` at n = 1, which resets
  the internal tick/think counters per call: inert under noEcho,
  silently wrong under echo. Echo-carrying hosts need the exported
  one-tick step (HOSTS_PLAN register 8.9), a later boundary.
- The host sets NO priors: the terminal set is not on the wire; the
  prior over explanations is 2^(-dl) through the one prior source.

Validation failures answer `{"error": "<reason>"}` and the process
stays on the handshake state.

## 3. Ticks

Decision tick — features + menu, no evidence; THE AGENT DOES NOT
MOVE:

```json
{"tick": {"features": {"t": 417, "tool-name=bash": 1}, "menu": [3, 2, 1]}}
{"choice": {"fire": 3, "slots": {}}, "p1": 0.81, "entropy_bits": 3.2}
```

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
  replacement table for this tick only (it must cover the offered
  menu and the internal row).
- Ordering ruling (register 8.2): evidence conditions in ARRIVAL
  order — live equals replay. Stated facts, not bugs: hmm-family
  latents advance one step per EVIDENCE tick (their clock is the
  evidence-stream index), and the t-guard family reads the re-sent
  original `t`.
- Impossible evidence (zero marginal likelihood — includes any
  verdict outside the observation space): `{"error":
  "impossible-evidence"}`, agent UNCHANGED. The host decides what
  fail-open means at transport level; the wire never defaults it.
- Choice encoding: `{"fire": <id>, "slots": {<name>: <value>}}` for
  a world affordance; `{"internal": "think"}` for the internal act
  (the driver reports it honestly if it wins; the adapter maps it to
  its own documented posture).

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
