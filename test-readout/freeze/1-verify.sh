#!/usr/bin/env bash
# readout sitting, script 1/3 — READ-ONLY verification: see what you
# are signing. Mutates nothing in the tree (the live run compiles to a
# throwaway temp dir). Runnable from anywhere: cd's to the repo root
# and exports the ghcup PATH (the f5 lesson).
set -euo pipefail
cd "$(dirname "$0")/../.."
export PATH="$HOME/.ghcup/bin:$PATH"

# the commits under review (base = the battery seal bd0d70c)
git log --oneline bd0d70c..HEAD

sha256sum --quiet -c MANIFEST.sha256
echo "manifest OK pre-freeze"

# THE LIVE GREEN, executed here under the stanza's DEPENDENCY CLOSURE
# (-hide-all-packages plus the declared build-depends — the
# package-faithfulness law) and its exact flag set including -Werror.
# The library build is a cached no-op; it exists because `cabal exec`
# reads the project package db, which a fresh checkout lacks (the
# battery rehearsal's first red).
cabal build -v0 lib:proplang
tmp=$(mktemp -d)
cabal exec ghc -- -hide-all-packages -package base -package containers \
  -package directory -package process -package tasty -package tasty-hunit \
  -XGHC2021 -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns \
  -isrc -itest-readout -outputdir "$tmp" -o "$tmp/readout" \
  test-readout/Readout.hs > "$tmp/compile.log" 2>&1
# r6 spawns proplang-host over pipes, so it must be on PATH
cabal build -v0 exe:proplang-host
exedir=$(dirname "$(cabal list-bin exe:proplang-host)")
PATH="$exedir:$PATH" "$tmp/readout" > "$tmp/run.log" 2>&1
tail -2 "$tmp/run.log"                       # expect: All 19 tests passed
grep -q "All 19 tests passed" "$tmp/run.log"
echo "live green confirmed (19/19 on this tree, dependency-closed)"
rm -rf "$tmp"

# the prophecy was applied byte-for-byte: src == the sealed tree plus
# exactly the diff the oracle phase committed.
#
# THE `&& echo` FORM WAS A GATE THAT COULD NOT FAIL, and it is written
# out here rather than quietly corrected. Under `set -e` a command on
# the LEFT of `&&` does not abort the script — only the command after
# the final `&&` is checked — so a prophecy MISMATCH printed its diff,
# skipped the confirmation line, and fell through to "ALL CHECKS
# PASSED" with exit 0. The rehearsal could not see it: the diff
# matched, so the bug lived entirely on the red side of a check that
# had never been red. That is the mirror image of the green that
# cannot fail, in the one check this kit was assembled to add.
# Caught by the pre-tag adversarial read, 2026-08-01, and demonstrated
# before it was believed.
asbuilt=$(mktemp)
git diff bd0d70c..HEAD -- src/PropLang/Host.hs > "$asbuilt"
diff <(grep -E '^[+-]' test-readout/opening/prophecy.diff | grep -vE '^(\+\+\+|---)') \
     <(grep -E '^[+-]' "$asbuilt" | grep -vE '^(\+\+\+|---)')
rm -f "$asbuilt"
echo "as-built == the prophecy, line for line"

# the recorded evidence (frozen with the oracle)
echo "--- red run (the sealed pre-increment src) ---"
grep -E "out of|All 19" test-readout/opening/red-run.txt
echo "--- the implemented surface ---"
grep -E "out of|All 19" test-readout/opening/impl-run.txt
# The label read "every kill readout-unique" until the 3c disposition
# round of 2026-08-02, and the grep showed only the FIRED lines. Both
# were falsified by the declared import: M7-ties-to-challenger reaches
# r8a (the only thing that does) and DOES redden the standing corpus,
# which is the r8a finding rather than a defect. A summary that prints
# the kills but hides the standing verdict would have shown M7's cell
# as if it were like the other nine.
#    THE REGION IS BOUNDED, not just the pattern. Widening the grep to
#    show the standing verdict also matched the READING prose below the
#    cells, and printed "...standing corpus is GREEN..." directly under
#    M7's REDDENED line - a summary asserting the opposite of the cell
#    it sat beneath. Caught by running this script, 2026-08-02. Tuning
#    the pattern would have been the same bet again; the region is
#    delimited instead, so prose CANNOT leak in whatever it says.
echo "--- kill matrix (9 own + 1 declared import; the standing verdict is printed per cell) ---"
sed -n '/^each cell:/,/^=== matrix done/p' test-readout/opening/readout-kill-matrix.txt \
  | grep -E "row\(s\) fired|COMPILE DEATH|standing corpus|STANDING CORPUS|^      Test suite"
echo "--- boundary audit at the opening ---"
tail -1 test-readout/opening/boundary-audit.txt

# the FOUR frozen-layer patches this freeze applies (three until the
# sitting of 2026-08-02 added r-d20i-anchor, the ruling sought)
for p in test-readout/freeze/membrane-wire-readout.patch \
         test-readout/freeze/obligations-fl1.patch \
         test-readout/freeze/r-red-id.patch \
         test-readout/freeze/r-d20i-anchor.patch; do
  git apply --check -p1 "$p"
  echo "applies clean: $p"
done

# THE SEQUENTIAL CLAUDE.md PAIR, checked on a temp copy. Two patches
# in this kit touch CLAUDE.md (r-red-id at ~line 403, r-d20i-anchor at
# ~line 140), and the per-patch --check above tests each against the
# UNPATCHED tree - which is not the tree the second one meets. The
# battery kit hit this exact shape and checked its pair sequentially;
# so does this one. Order matters and is asserted here rather than
# assumed: the later-in-file patch goes FIRST, so the earlier one's
# context is still where its hunk header says it is.
command -v patch >/dev/null \
  || { echo "STOP: 'patch' is absent - the sequential CLAUDE.md check cannot run" >&2; exit 1; }
repo=$(pwd)
seqtmp=$(mktemp -d)
git show HEAD:CLAUDE.md > "$seqtmp/CLAUDE.md"
( cd "$seqtmp" \
  && patch -p1 -F0 --silent < "$repo/test-readout/freeze/r-red-id.patch" \
  && patch -p1 -F0 --silent < "$repo/test-readout/freeze/r-d20i-anchor.patch" ) \
  || { echo "STOP: the CLAUDE.md pair does not apply SEQUENTIALLY in 2-freeze's order" >&2
       rm -rf "$seqtmp"; exit 1; }
# and the result actually carries BOTH clauses - a pair that applies
# without carrying its own content is this kit's own finding (d)
# wearing a different hat.
grep -q "R-RED" "$seqtmp/CLAUDE.md" \
  && grep -q "ANCHOR IS THE COMMIT HASH" "$seqtmp/CLAUDE.md" \
  || { echo "STOP: the pair applied but both clauses are not present" >&2
       rm -rf "$seqtmp"; exit 1; }
rm -rf "$seqtmp"
echo "applies clean: the CLAUDE.md pair, sequentially, in 2-freeze's order, both clauses present"

# CAN THIS SHELL ACTUALLY SIGN? Asked HERE, in the read-only script,
# because 3-sign.sh is the last of the three: a shell that cannot sign
# discovers it only after 2-freeze.sh has spliced the stanza, applied
# three [RULING] patches and rewritten the manifest, with no undo
# script and the double-run guard refusing a retry. That is the same
# operational hazard the lint's L5 rows would have sprung (pack VII.2
# P5), and it belongs in front of the mutations, not behind them.
key=$(git config --get user.signingkey || true)
[ -n "$key" ] || { echo "STOP: user.signingkey is unset - 3-sign.sh cannot sign" >&2; exit 1; }
[ "$(git config --get gpg.format || true)" = "ssh" ] \
  || { echo "STOP: gpg.format is not ssh - -S would attempt OpenPGP" >&2; exit 1; }
sigtmp=$(mktemp -d)
echo probe > "$sigtmp/p"
ssh-keygen -Y sign -f "$key" -n git "$sigtmp/p" > "$sigtmp/log" 2>&1 \
  || { echo "STOP: the configured signing key cannot sign:" >&2; cat "$sigtmp/log" >&2; rm -rf "$sigtmp"; exit 1; }
fp=$(ssh-keygen -lf "$key.pub" 2>/dev/null | awk '{print $2}')
grep -q "$(awk '{print $2}' "$key.pub")" allowed_signers \
  || { echo "STOP: the signing key $fp is NOT in allowed_signers - the tag would verify for nobody" >&2; rm -rf "$sigtmp"; exit 1; }
rm -rf "$sigtmp"
echo "signing key OK: $fp, present in allowed_signers"

echo
echo "ALL CHECKS PASSED - nothing was mutated. 2-freeze.sh next."
