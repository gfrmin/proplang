#!/usr/bin/env bash
# breadth oracle freeze, script 2/4 — the KEYLESS freeze mechanics:
# the stanza splice, the [RULING] patches (breadth-sitting-r0's routed
# installs), gate 5 on the spliced tree (standing suites GREEN, the
# breadth oracle RED BY DESIGN with its exact frozen red set), the
# lint two-sided demonstrations, the manifest extension + re-sign
# (ORDERED AFTER the lint rows exist — OB-26's recorded constraint),
# the pre-freeze lint. No signature here; stops on the first failure
# and refuses to run twice.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# 0. OB-29: a LIVE throwaway signature BEFORE ANY TREE MUTATION —
#    execution, never inspection. The nonce rides a FILE (-F, the
#    OB-30-compatible form; lint L9 sees no -m here). A dead or locked
#    key aborts with the tree untouched.
probe_tmp=$(mktemp -d)
trap 'rm -rf "$probe_tmp"' EXIT
printf 'sig-probe nonce over %s\n' "$(git rev-parse HEAD)" > "$probe_tmp/nonce"
git tag -s sig-probe-breadth-freeze -F "$probe_tmp/nonce" HEAD >/dev/null 2>&1 \
  || { echo "ABORT: signature probe FAILED - key absent or locked; nothing was touched" >&2; exit 1; }
git tag -v sig-probe-breadth-freeze >/dev/null 2>&1 \
  || { git tag -d sig-probe-breadth-freeze >/dev/null; echo "ABORT: probe tag did not verify" >&2; exit 1; }
git tag -d sig-probe-breadth-freeze >/dev/null
echo "step 0: live signature probe OK (key live, verifies; tree untouched so far)"

if grep -q "test-suite breadth" proplang.cabal; then
  echo "GUARD: breadth stanza already spliced - refusing to run twice" >&2
  exit 1
fi

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# no [MINT] marker may survive into the freeze: every frozen literal
# derives from the mint transcript, and an unminted literal is a slot
if grep -q '\[MINT\]' test-breadth/Breadth.hs; then
  echo "ABORT: [MINT] marker still present in test-breadth/Breadth.hs" >&2
  exit 1
fi

# 1. the stanza splice (proplang.cabal is frozen; this is the
#    freeze-boundary cabal edit, the draft-stanza precedent)
git apply test-breadth/freeze/stanza.patch

# 2. [RULING, breadth-sitting-r0: THE ONE CLAUDE.md TOUCH — OB-27's
#    harness-gate scope line inside the triptych clause, and the
#    prose-claim gate (pack XV.2 as widened at r7) canonized beside
#    it, the clause text copied from the pack]
git apply test-breadth/freeze/claude-prose-gate.patch

# 3. [OB-26 + OB-28: lint L8 (recorded repairs verified against the
#    tree) and the L9/L5 hardenings — landed BEFORE the manifest step
#    below, per OB-26's recorded kit-order constraint]
git apply test-breadth/freeze/lint-l8-hardening.patch

# 4. [the ledger: OB-25 advance, OB-26/27/28/29 discharges, OB-31
#    LANDED, OB-19 LANDED + its row-text amendment (pack VIII.2's
#    drafted bracket, the falsified words quoted), OB-32 minted (the
#    build-stamp obligation)]
git apply test-breadth/freeze/obligations-heir.patch

# 5. [FL repairs routed by the sitting: tools/boundary-audit.sh:136's
#    stale note now DERIVES what it prints (pack XVII) + the XV.3
#    prose-claim triage row; src/PropLang/Host.hs:387's wait comment
#    repaired to the legend; dispositions-pack VIII.3's "shipped 219"
#    gains its dated bracket (close-date document: annotated, never
#    rewritten)]
git apply test-breadth/freeze/fl-repairs.patch

# 6. gate 5 on the spliced tree. The breadth oracle is RED BY DESIGN
#    until implementation — the gate asserts the EXACT frozen red set
#    (the two-run triptych at the kit level: the reds are the recorded
#    reds, the greens the recorded greens), and every standing suite
#    stays green. Transcript rides un-hashed (the readout precedent:
#    its sibling lint transcript postdates the manifest re-sign).
cabal test all 2>&1 | tee test-breadth/freeze/gate5-run.txt || true
for s in transport exact-acceptance exact-properties lawful \
         lawful-independence pins dyadic trampoline f5 jointprep \
         battery readout; do
  grep -q "Test suite $s: PASS" test-breadth/freeze/gate5-run.txt \
    || { echo "ABORT: standing suite $s not green" >&2; exit 1; }
done
grep -q "Test suite breadth: FAIL" test-breadth/freeze/gate5-run.txt \
  || { echo "ABORT: breadth suite unexpectedly green pre-implementation" >&2; exit 1; }
grep -q "12 out of 20 tests failed" test-breadth/freeze/gate5-run.txt \
  || { echo "ABORT: breadth red set is not the frozen 12-of-20" >&2; exit 1; }
for r in b1b b2a b2b b2c b2d b3a b3b b4a b4c b5a b5c b6d; do
  grep -qE "$r .*FAIL" test-breadth/freeze/gate5-run.txt \
    || grep -A3 " $r " test-breadth/freeze/gate5-run.txt | grep -q "^FAIL" \
    || { echo "ABORT: expected red row $r did not fire in gate5" >&2; exit 1; }
done
echo "gate 5: standing suites green; breadth red set == the frozen 12"

# 7. the manifest extension (oracle + stanza draft + opening
#    transcripts + the kit itself, the kit-freezes-itself form) and
#    the re-sign of the five mutated frozen rows. RUNS AFTER STEP 3
#    BY CONSTRUCTION (OB-26's constraint: a lint row landing between
#    the manifest rewrite and its verification would seed the exact
#    defect class it closes).
{
  sha256sum test-breadth/Breadth.hs test-breadth/stanza.cabal.draft \
            test-breadth/opening/*.txt \
            test-breadth/freeze/SITTING.md test-breadth/freeze/tag-msg.txt \
            test-breadth/freeze/*.sh test-breadth/freeze/*.patch
} >> MANIFEST.sha256
python3 - <<'PY'
import hashlib, re
rows = {}
for ln in open("MANIFEST.sha256"):
    m = re.match(r"^(\S+)\s+(.*)$", ln.rstrip("\n"))
    if m: rows[m.group(2)] = m.group(1)
for f in ("proplang.cabal", "CLAUDE.md", "OBLIGATIONS.md",
          "tools/prefreeze-lint.sh", "tools/boundary-audit.sh"):
    rows[f] = hashlib.sha256(open(f, "rb").read()).hexdigest()
with open("MANIFEST.sha256", "w") as fh:
    for k in sorted(rows): fh.write(f"{rows[k]}  {k}\n")
print("manifest re-signed over", len(rows), "rows")
PY
sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK post-extension"

# 8. the L8/L9/L5 two-sided demonstrations (OB-26/28's discharge
#    events), executed against seeded cases in a WHOLE-TREE COPY so
#    the real tree never carries a seeded defect. Runs after the
#    manifest step so the copy's L3 row is green in the true-side run
#    (OB-26's order constraint bound step 3 before step 7, and holds).
#    The transcript rides un-hashed beside gate5-run.txt (the readout
#    precedent's reason: it postdates the manifest re-sign).
bash test-breadth/freeze/lint-demo.sh 2>&1 | tee test-breadth/freeze/lint-demo.txt
grep -q "LINT-DEMO: ALL SIX SIDES DEMONSTRATED" test-breadth/freeze/lint-demo.txt

# 9. the pre-freeze lint, L8 and the hardened L9/L5 LIVE (the rows'
#    first standing run is on the very freeze that installs them).
git config --local gpg.ssh.allowedSignersFile allowed_signers
bash tools/prefreeze-lint.sh 2>&1 | tee test-breadth/freeze/lint-transcript.txt
grep -q " 0 FAIL" test-breadth/freeze/lint-transcript.txt

echo
echo "FREEZE MECHANICS DONE - nothing signed. 3-sign.sh is the key act's."
