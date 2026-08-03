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

# THE PATCH LIST IS 2-freeze's OWN, NOT A SECOND COPY OF IT.
#
# The check loop below used to hold its own hand-written list of four
# paths. Two lists of the same thing is the drift shape that just cost
# this increment a round: they agreed the day they were written and
# nothing made them keep agreeing. The hazard is specific and serious -
# a patch added to 2-freeze's apply sequence but forgotten in the loop
# would be applied at the IRREVERSIBLE step having never once been
# `--check`ed, which is the one thing this script exists to prevent.
#
# So it is not gated, it is made unsayable: the list is extracted from
# 2-freeze's own `git apply` lines, in 2-freeze's order, and divergence
# is no longer expressible. (Enforcement ladder: climb as high as it
# goes - one list beats two lists plus a check that they match.)
#
# `|| true` IS LOad-BEARING AND WAS BOUGHT BY A RED. Without it, a
# 2-freeze with no `git apply` lines makes grep exit 1, and under
# `set -euo pipefail` the ASSIGNMENT aborts the script before the
# emptiness guard below can speak - a silent death after the boundary
# audit, no STOP printed, no "ALL CHECKS PASSED" either. The guard was
# dead code until RED 8 demonstrated it could not fire. That is finding
# (d)'s shape - a check that cannot fail - committed inside the gate
# written to cure it, and caught only because every red was executed
# rather than assumed.
patches=$(grep -E '^git apply ' test-readout/freeze/2-freeze.sh | awk '{print $NF}' || true)
[ -n "$patches" ] \
  || { echo "STOP: no 'git apply' lines in 2-freeze.sh - the apply sequence moved" >&2; exit 1; }
for p in $patches; do
  [ -f "$p" ] || { echo "STOP: 2-freeze applies $p, which does not exist" >&2; exit 1; }
done

# AND NO ORPHANS: a .patch in the freeze dir that 2-freeze never applies
# is either a forgotten ruling or dead weight, and either way the
# freeze/*.patch glob hashes it into the manifest and freezes it forever
# without it ever being applied to anything.
#    THIS ROW RUNS BEFORE THE MANIFEST-FIGURE ROW ON PURPOSE. An orphan
#    also bumps the derived manifest count, so with the figure row first
#    the orphan was caught but MISDIAGNOSED as "139 vs 140" - the row
#    below fired and this one could never fire at all (RED 6). Rather
#    than record a structurally shadowed row, the order is changed so
#    the precise diagnosis wins and the figure row still catches
#    everything else.
orphans=$(comm -23 <(ls -1 test-readout/freeze/*.patch | sort) <(printf '%s\n' $patches | sort))
[ -z "$orphans" ] \
  || { echo "STOP: patch file(s) present but never applied by 2-freeze:" >&2
       printf '  %s\n' $orphans >&2; exit 1; }

# and the sheet's stated count derives from that same single list, for
# the same reason step C's manifest figure now does: it is a number a
# human reads and acts on at an irreversible step. "three patches" stood
# in step A, wrong, from the moment r-d20i-anchor landed.
npatch=$(printf '%s\n' $patches | wc -l)
sheetn=$(sed -n 's/.*\*\*\([a-z]*\)\*\* patches apply clean.*/\1/p' test-readout/freeze/SITTING.md)
case "$npatch:$sheetn" in
  3:three|4:four|5:five|6:six) ;;
  *) echo "STOP: 2-freeze applies $npatch patches; SITTING.md step A says '$sheetn'." >&2; exit 1 ;;
esac
echo "patch list agrees: $npatch applied by 2-freeze, none missing, no orphans, sheet says '$sheetn'"

# THE SHEET'S MANIFEST FIGURE IS DERIVED HERE, NOT READ.
#
# Until this check existed, NOTHING defended that number. 2-freeze
# PRINTS the post-extension count and greps nothing; lint L3 derives
# whatever it finds (`wc -l`) and asserts only that sha256sum -c
# passes; no gate in the kit or in tools/ holds a row count at all. So
# the sheet's figure sat two rows behind the kit for a full day - the
# 3c round added r-d20i-anchor.patch and M7-ties-to-challenger.patch
# and only SITTING.md was updated - the pack and the sheet disagreed in
# front of the author at the one step with no undo, and the conferring
# reviewer read the stale side and quoted it back in the run
# instruction. A second conferral recomputing by hand is what caught
# it. That is a figure a human READS AND ACTS ON at an irreversible
# step, so it must be derived rather than typed. This is the check that
# makes it so, and it is the narrow rule rather than "gate everything":
# gate every sentence and you mint greens nobody red-tested, which is
# this increment's own disease wearing a helpful face.
#
# THE ARGUMENT LIST IS EXTRACTED FROM 2-freeze.sh ITSELF, never
# re-declared here. A second copy of those globs living in this file
# would agree today and drift on the next round - exactly what the
# sheet just did, one file over. R-D20-i: copy, do not reconstruct. The
# union models 2-freeze's path-keyed python dict exactly, so a path
# that already carries a manifest row cannot inflate the count (the
# dict's four re-hashed files - proplang.cabal, membrane-wire.md,
# OBLIGATIONS.md, CLAUDE.md - are all already rows, so they move no
# count and are deliberately not re-listed here either).
#
# WHAT IT CANNOT DO, stated rather than implied: both sides are derived
# by this script, so it catches DRIFT between the sheet and the kit -
# the failure that actually happened - and cannot catch the sheet and
# the globs being wrong together.
addargs=$(sed -n '/sha256sum test-readout/,/^} >> MANIFEST\.sha256/p' \
            test-readout/freeze/2-freeze.sh \
          | sed -e 's/.*sha256sum //' -e 's/\\[[:space:]]*$//' -e '/^} >>/d')
[ -n "$addargs" ] \
  || { echo "STOP: could not extract 2-freeze's manifest argument list - the block moved" >&2; exit 1; }
# shellcheck disable=SC2086
derived=$( { awk '{print $2}' MANIFEST.sha256; ls -1 -d $addargs; } | sort -u | wc -l )
stated=$(sed -n 's/.*extends the manifest \*\*109 → \([0-9]*\)\*\*.*/\1/p' \
           test-readout/freeze/SITTING.md)
[ -n "$stated" ] \
  || { echo "STOP: SITTING.md states no manifest figure - step C's sentence moved" >&2; exit 1; }
[ "$derived" = "$stated" ] \
  || { echo "STOP: the sheet says the manifest lands on $stated; the kit's own argument list derives $derived." >&2
       echo "      Reconcile BEFORE 2-freeze - after the splice there is no undo." >&2; exit 1; }
echo "manifest figure agrees: SITTING.md says $stated, derived from 2-freeze's own list = $derived"

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

# the frozen-layer patches, --check'd against the tree. The list is
# 2-freeze's own, extracted at the top of this script; its membership,
# existence, orphan and count checks all ran there.
for p in $patches; do
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
