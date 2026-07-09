# increment D Task-3 report — utility as latent, outcome-grounded: BUILT

Builder → author, 2026-07-10. The increment that began at HOSTS_D_PACK
and froze at d-freeze (0b7b188) is implemented: **the D oracle 48/48;
all seven audit gates PASS; ten suites green under cabal; govhost v1
40/40 byte-compatible; ablation rows attribute; manifest 81/81;
anchors byte-stable throughout** (no frozen assertion literal moved in
any of the nine pre-D suites).

## 1. The commit history of Task 3 (custody-annotated)

| commit / tag | act |
|---|---|
| a05d77d + d-freeze-r1 | oracle repair, DELEGATED ("adopt both rules; apply the §5 fixes as recommended"): obeysB restored to Cirl's formula; gHeadline re-scoped to the measured drift edge |
| f0310d7 + d-freeze-r2 | oracle repair, DELEGATED ("adopt the transcript gate; apply the gDriver repair as drafte"): the stake payload; the prepped pointer; askSharp {0.01}; R-D21's transcript gate |
| 81d9f51 | the implementation (builder's ordinary work): six stub bodies to 48/48 |
| 677c8ef + d-freeze-r3 | build repair, DELEGATED ("add the line"): WireU joins the exe stanza's other-modules |

Every delegated act carries the instruction verbatim in commit and
tag; every signature is the builder key attesting builder action
under recorded instruction (the membrane precedent). Your own
signature in this increment is d-freeze itself.

## 2. As-built decisions (the report's register)

1. **The driver rule** (Membrane.uChoose, the r2 satisfiability
   transcript's rule verbatim): pair belief = pointer × first
   residual by public verbs; every menu option valued as a vPre face
   at the declared depth, n=1, measured tick price outside the max;
   menu-order argmax (CL-3). Bindings NAME-KEYED (rider 1's upPrice
   mechanism): "ask" opens upVerdict at its code and is charged the
   residual named theta_ask as object-level uD; "compare" opens the
   residual's declared channel; everything else opens upVerdict at
   its code. Recorded as a name-keyed simplification of the wire's
   comparison-payload mechanism; multi-residual pairing folds on the
   FIRST residual (successor scope, HOSTS_PLAN 6.2's coupled-folds
   line).
2. **Model grew internally** (uconst/uwalk sorts carrying their
   declared channel, value space, points, and grid name); the
   reflected walk generalized onto the value grid as `walkOn` — the
   frozen `walkKernel` untouched, one mass arithmetic, two
   instantiations.
3. **observeCounts** (wire v2's count-collapse): per-hypothesis
   likelihood exponentiation folded through a SYNTHETIC one-shot
   evidence kernel whose emission probability at the observed token
   is the max-scaled collapsed likelihood — exact exponentiation,
   O(hypotheses), public verbs only, the frozen Belief export list
   untouched (gate 2 forced this design and it turned out cleaner
   than a new Belief verb). Flattening = the latent is not advanced
   per collapsed tick — printed in the haddock, the declared
   approximation for drift-carrying families.
4. **The wire driver's declared defaults** (buildWorldU): the
   pointer's value grid is the model fragment's own theta geometry
   spoken as ubar, rates the fragment's rho points — the alphabet's
   grids, not new constants; each residual's channel is the SAME
   declared tau-owner over its own grid (the comparison answer
   arrives through the responder applied to the question, pack §4).
   The `said` S-expr subset implemented covers the frozen goldens
   (["var", i]); richer payload forms are ordinary growth under the
   frozen wire section — unknown forms error, never default.
5. **The v2 entry point**: Main tries v1 first and the v2 parse only
   where v1 already errored — v1 lines byte-identical (govhost 40/40
   is the witness).

## 3. The §5b items (queued by your verdict round, delivered here)

- **KSV caveat**: components with neither measured units nor a
  comparison route sit under Karni–Schmeidler–Vind
  non-identifiability; the ledger's empty-row pins (gLedger, green)
  are what keep such a component from silently pretending otherwise.
- **WireU sealing, forward-looking**: record construction sealing the
  write side means every wire version forks a module — v2 forked
  WireU, and v3 will fork again unless the next wire boundary adopts
  additive-field extensibility; a named candidate, not a
  per-increment surprise. (Task 3 adds a data point: the fork also
  leaks into BUILD declarations — r3's one line — so the candidate's
  scope includes the cabal surface.)

## 4. The oracle-defect post-mortem, closed

Six defects total this increment: five oracle rows (three at r1, two
at r2) + one build line (r3). All five oracle rows shared one root —
an expected side that never executed before the freeze — and the two
rules now on the register close that class: **copy-not-reconstruct**
(R-D20) and **the satisfiability transcript gate** (R-D21: every red
row executed against a prototype before any future freeze; D's own
audit table in stop report #2 §0 is the first transcript). The r3
line is the stanza-fidelity lesson extended to the EXE path: the
oracle-phase runner must be bit-faithful to the future gate's build
declarations too, not only its flags — one sentence for the next
oracle's red-run author.

## 5. Reviewer verification block (run by the author)

    export PATH="$HOME/.ghcup/bin:$PATH"
    cabal test all                  # ten suites PASS (test-d 48/48)
    sh audit/run-gates.sh           # gates 1-7 all PASS
    sh test-d/red-run.sh            # 48/48 out-of-cabal, exact flags
    sh test-d/ablation.sh all       # 2 rows PASS, attribution named
    sh test-govhost/red-run.sh      # v1: 40/40 byte-compatible
    sha256sum -c MANIFEST.sha256    # 81/81
    git log --oneline -5            # the custody trail of section 1
    git verify-tag d-freeze         # your signature (the binding one)

## 6. What remains (all yours, none building)

1. Review this report; if you want your own countersignature over the
   completed increment (the r-tags are delegated builder
   attestations), a signed tag from your shell over 677c8ef closes
   the custody loop in your hand.
2. Push master + tags to the public repo when you choose.
3. credence-governor: feat/membrane-adapter push/PR (unchanged,
   non-gating). R-D16 retention policy (standing).
4. The next boundary, if any, opens under R-D20/R-D21's rules — and
   per the roadmap as amended at d-freeze, that is A
   (options-as-data), demand-gated.
