#!/usr/bin/env bash
# breadth oracle freeze, script 1/4 — READ-ONLY verification: see what
# you are signing. Mutates nothing (patch checks run --check; the
# sequential-pair check runs on a temp copy). Runnable from anywhere.
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# the commits under review (base = the sitting close 197269b)
git log --oneline 197269b..HEAD

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# THE PATCH LIST IS 2-freeze's OWN, NOT A SECOND COPY OF IT (the
# readout kit's law: two lists of the same thing is the drift shape;
# the list is extracted from 2-freeze's apply lines so divergence is
# unsayable). `|| true` is load-bearing: without it an apply-less
# 2-freeze kills the assignment under set -e before the guard speaks.
patches=$(grep -E '^git apply ' test-breadth/freeze/2-freeze.sh | awk '{print $NF}' || true)
[ -n "$patches" ] \
  || { echo "STOP: no 'git apply' lines in 2-freeze.sh - the apply sequence moved" >&2; exit 1; }
for p in $patches; do
  [ -f "$p" ] || { echo "STOP: 2-freeze applies $p, which does not exist" >&2; exit 1; }
done

# AND NO ORPHANS: a .patch present but never applied is a forgotten
# ruling or dead weight, frozen forever unapplied (the readout RED 6
# ordering: this row runs BEFORE any figure row so the precise
# diagnosis wins).
orphans=$(comm -23 <(ls -1 test-breadth/freeze/*.patch | sort) \
                   <(printf '%s\n' $patches | sort))
[ -z "$orphans" ] \
  || { echo "STOP: patch file(s) present but never applied by 2-freeze:" >&2
       printf '%s\n' "$orphans" >&2; exit 1; }

# SEQUENTIAL apply check on a temp copy — a per-patch check against
# the unpatched tree cannot see a conflict between two patches to the
# same file (the readout kit's 4/4b lesson).
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
git archive HEAD | tar -x -C "$tmp"
# the stanza splice is a bare append in 2-freeze only via git apply;
# replay exactly the applies, in order
for p in $patches; do
  cp "$p" "$tmp/_patch"
  (cd "$tmp" && git apply --check _patch && git apply _patch && rm _patch) \
    || { echo "STOP: sequential apply fails at $p" >&2; exit 1; }
done
echo "patch list applies sequentially: $(printf '%s ' $patches)"

# the oracle-phase artifacts all present, and no [MINT] slot survives
for f in test-breadth/Breadth.hs test-breadth/stanza.cabal.draft \
         test-breadth/opening/mint-run.txt test-breadth/opening/red-run.txt \
         test-breadth/opening/sat-run.txt \
         test-breadth/freeze/SITTING.md test-breadth/freeze/tag-msg.txt \
         test-breadth/freeze/lint-demo.sh; do
  [ -f "$f" ] || { echo "STOP: missing artifact $f" >&2; exit 1; }
done
if grep -q '\[MINT\]' test-breadth/Breadth.hs; then
  echo "STOP: unminted [MINT] literal in the oracle" >&2; exit 1
fi

# the drafted stanza and the stanza patch agree (one source: the
# patch is generated FROM the draft; divergence means regenerate)
if ! grep -qF "test-suite breadth" test-breadth/freeze/stanza.patch; then
  echo "STOP: stanza.patch does not carry the breadth stanza" >&2; exit 1
fi

# the frozen mint literals in the oracle derive from the mint
# transcript: every driftFrozen/compFrozen number must appear in
# mint-run.txt's REPORT lines (copy-not-reconstruct, mechanically)
python3 - <<'PY'
import re, sys
src = open("test-breadth/Breadth.hs").read()
mint = open("test-breadth/opening/mint-run.txt").read()
lits = []
m = re.search(r"driftFrozenMeans = \[([0-9., ]+)\]", src)
lits += [x.strip() for x in m.group(1).split(",")]
m = re.search(r"driftFrozenMeanRatio = ([0-9.]+)", src)
lits.append(m.group(1))
for nm in ("compFrozenEv", "compFrozenWalkShare", "compFrozenRo", "compFrozenWire"):
    m = re.search(nm + r"\s*=\s*([0-9.]+)", src)
    lits.append(m.group(1))
missing = [l for l in lits if l not in mint]
if missing:
    sys.exit("STOP: frozen literal(s) not found in mint-run.txt: %s" % missing)
print("all %d frozen mint literals trace to mint-run.txt" % len(lits))
PY

# tag message file: present, and its slotless (the -F mint law)
grep -q '\[ ' test-breadth/freeze/tag-msg.txt \
  && { echo "STOP: unfilled slot in tag-msg.txt" >&2; exit 1; }

echo
echo "ALL CHECKS PASSED - review SITTING.md, then run 2-freeze.sh"
