#!/usr/bin/env bash
# readout sitting, script 2/3 — the KEYLESS freeze mechanics: the
# stanza splice, the [RULING] patches, gate 5 on the spliced tree, the
# manifest extension + re-sign, the pre-freeze lint. No signature
# here; stops on the first failure and refuses to run twice.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

if grep -q "test-suite readout" proplang.cabal; then
  echo "GUARD: readout stanza already spliced - refusing to run twice" >&2
  exit 1
fi

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# 1. the stanza splice (proplang.cabal is frozen; this is the
#    freeze-boundary cabal edit)
cat test-readout/stanza.cabal.draft >> proplang.cabal

# 2. [RULING CW6 + the mandate round's F4/F7/F13: membrane-wire.md
#    gains the readout's reply shape and its bullet in the LIVE
#    section-3 contract, six pin-table rows, the dead test-arity g7d
#    pin retired in place, and the consumer discipline quoted IN
#    (VIII.1's recommendation). The Enumerate citation is the repaired
#    one - the stale :467 was caught one step before it froze]
git apply test-readout/freeze/membrane-wire-readout.patch

# 3. [RULING CW7 + FL-1: OB-20/21 to DISCHARGED@battery-freeze-r0 with
#    their discharge events named (the battery's kit never patched the
#    ledger), plus OB-25, this increment's own row]
git apply test-readout/freeze/obligations-fl1.patch

# 4. [RULING FL-2 / mandate finding F11: R-RED is cited as law but the
#    canonized clause in CLAUDE.md carries no ID string, so a greppable
#    audit for the ID finds only the battery's freeze kit. One line.]
git apply test-readout/freeze/r-red-id.patch

# 5. gate 5 on the spliced tree - the readout's first stanza'd run
#    alongside every standing suite. The transcript rides the freeze
#    commit UN-HASHED, as the battery's did and for the same reason
#    (its sibling, the lint transcript, is written after the manifest
#    is re-signed and cannot be hashed at all); stated here rather
#    than left to be inferred from the globs in step 6.
cabal test all 2>&1 | tee test-readout/freeze/gate5-run.txt
grep -q "Test suite readout: PASS" test-readout/freeze/gate5-run.txt
echo "gate 5 green on the spliced tree"

# 6. the manifest extension (oracle + transcripts + the frozen-layer
#    patches + the kit itself - the kit-freezes-itself form) and the
#    re-sign of the three mutated frozen rows
#    The mutant globs are ANCHORED on the digit-then-dash shape:
#    the earlier `M7*.patch` also matched audit/mutants/
#    M7-ties-to-challenger.patch, a mutant from a previous increment
#    that this freeze has no business hashing. A glob that silently
#    captures a stranger is the hand-enumeration disease wearing a
#    sweep's clothes (pre-tag read, 2026-08-01).
{
  sha256sum test-readout/Readout.hs test-readout/stanza.cabal.draft \
            test-readout/kill-matrix.sh test-readout/freeze/SITTING.md \
            test-readout/opening/*.txt test-readout/opening/prophecy.diff \
            test-readout/freeze/*.sh test-readout/freeze/*.patch \
            audit/mutants/M6[4-9]-*.patch audit/mutants/M7[0-2]-*.patch
} >> MANIFEST.sha256
python3 - <<'PY'
import hashlib, re
rows = {}
for ln in open("MANIFEST.sha256"):
    m = re.match(r"^(\S+)\s+(.*)$", ln.rstrip("\n"))
    if m: rows[m.group(2)] = m.group(1)
for f in ("proplang.cabal", "membrane-wire.md", "OBLIGATIONS.md", "CLAUDE.md"):
    rows[f] = hashlib.sha256(open(f, "rb").read()).hexdigest()
with open("MANIFEST.sha256", "w") as fh:
    for k in sorted(rows): fh.write(f"{rows[k]}  {k}\n")
print("manifest re-signed over", len(rows), "rows")
PY
sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK post-extension"

# 7. the pre-freeze lint (row v builds the FULL corpus by glob).
#    L4 verifies every freeze tag's signature, which needs the
#    allowed-signers file configured — a FRESH CLONE has no local git
#    config, so the row fails for the environment rather than for the
#    tree. The rehearsal caught this; the line below is idempotent and
#    makes the kit true of any honest copy (the f5 runnable-from-
#    anywhere lesson, in its signature-verification form).
git config --local gpg.ssh.allowedSignersFile allowed_signers
bash tools/prefreeze-lint.sh 2>&1 | tee test-readout/freeze/lint-transcript.txt
grep -q "0 FAIL" test-readout/freeze/lint-transcript.txt

echo
echo "FREEZE MECHANICS DONE - nothing signed. 3-sign.sh is the author's."
