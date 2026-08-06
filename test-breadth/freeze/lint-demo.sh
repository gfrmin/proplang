#!/usr/bin/env bash
# breadth oracle freeze — the L8/L9/L5 TWO-SIDED DEMONSTRATIONS
# (OB-26 + OB-28's discharge events). Both sides of every new/hardened
# lint row are EXECUTED (the two-run triptych applied to the lint
# itself: a row must be able to pass AND able to fire). All seeding
# happens in a WHOLE-TREE COPY (working tree + .git, so L8's hash
# resolution and L5's history selection see the real history); the
# real tree is never touched.
#
# The six sides:
#   A1 L8 true side  — a repair row citing a real hash beside the file
#                      it touches: L8 PASSES with the pair counted
#   A2 L5 true side  — an older pack file touched to NEWEST mtime; the
#                      history-derived selection still names the
#                      current pack (the old `ls -t` would not)
#   B1 L8 stale hash — a repair row citing an unresolvable hash: FAIL
#   B2 L8 wrong file — a real hash beside a file it never touched: FAIL
#   B3 L9 --message= — an unexecuted kit tagging via --message=: FAIL
#                      (the old -m-only pattern was blind to it)
#   B4 L9 lightweight— an unexecuted kit's -m line whose tag exists
#                      only as a LIGHTWEIGHT ref: FAIL (the old
#                      exemption, bare ref existence, would have
#                      silently exempted it; cat-file -t must say tag)
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

demo=$(mktemp -d /tmp/breadth-lint-demo.XXXXXX)
trap 'rm -rf "$demo"' EXIT
cp -a . "$demo/repo"
cd "$demo/repo"
pack="breadth-author-pack.md"

fail() { echo "LINT-DEMO ABORT: $1" >&2; exit 1; }

# ---- run A: the TRUE sides --------------------------------------------------
# A1: a demo repair row citing a real commit beside a file it touches
truehash=$(git log --format=%h -1 -- test-breadth/Breadth.hs)
printf '\n[demo] repair row: REPAIRED at %s - test-breadth/Breadth.hs re-verified.\n' \
       "$truehash" >> "$pack"
# A2: an older pack made mtime-newest; history must still win
touch dispositions-pack.md
echo "== run A (true sides; expecting 0 FAIL, L8 counts the pair, L5/L8 name $pack) =="
bash tools/prefreeze-lint.sh 2>&1 | tee "$demo/runA.txt" || fail "run A exited nonzero"
grep -q " 0 FAIL" "$demo/runA.txt" || fail "run A not 0 FAIL"
grep -qE "L8 recorded repairs: [1-9][0-9]* hash" "$demo/runA.txt" \
  || fail "A1: L8 did not count the true citation"
grep -q "verified in $pack" "$demo/runA.txt" \
  || fail "A2: L8/L5 selection did not name $pack (history selection broken)"
echo "run A OK: true sides pass; ls -t would have selected $(ls -t *author-pack.md | head -1)"

# ---- run B: the RED sides ---------------------------------------------------
# B1 + B2 seeded into the pack copy
printf '[demo] repair row: REPAIRED at deadbee99 - CLAUDE.md re-checked.\n' >> "$pack"
printf '[demo] repair row: REPAIRED at %s - design.md re-checked.\n' "$truehash" >> "$pack"
# B3: a --message= kit whose tag does not exist. The flag strings ride
# VARIABLES so this script's own raw text never matches L9's scan (this
# file lives under test*/freeze/ and is scanned like any kit).
mkdir -p test-demolint/freeze
flagLong='--message='
flagShort='-m'
printf 'git tag -a demo-tag-x %s"not a file"\n' "$flagLong" \
  > test-demolint/freeze/demo-kit.sh
# B4: an -m kit whose tag exists only as a LIGHTWEIGHT ref
git tag demo-lw-tag HEAD
printf 'git tag demo-lw-tag %s "minted by string"\n' "$flagShort" \
  >> test-demolint/freeze/demo-kit.sh
echo "== run B (red sides; expecting L8 FAIL x2, L9 FAIL x2) =="
bash tools/prefreeze-lint.sh 2>&1 | tee "$demo/runB.txt" && fail "run B exited ZERO"
grep -q "L8 .*unresolvable hash deadbee99" "$demo/runB.txt" \
  || fail "B1: stale-hash red did not fire"
grep -q "L8 .*does not touch design.md" "$demo/runB.txt" \
  || fail "B2: wrong-file red did not fire"
grep -c "L9 tag message" "$demo/runB.txt" | grep -q "^2$" \
  || fail "B3/B4: expected exactly two L9 reds (--message= and lightweight)"
grep -q "demo-kit.sh:1" "$demo/runB.txt" || fail "B3: the --message= line not named"
grep -q "demo-kit.sh:2" "$demo/runB.txt" || fail "B4: the lightweight-tag line not named"
echo "run B OK: all four reds fired, each naming its line"

echo "LINT-DEMO: ALL SIX SIDES DEMONSTRATED"
