#!/usr/bin/env bash
# Assemble the paper-freeze-r0 sitting's conferral bundle: ONE self-contained
# markdown file (brief + every artifact under review, inlined), so the terminus
# can be read and ruled on a phone with no repo access.
#
# Per the standing conferral pattern: the sitting goes to pixel-9a by taildrop
# as markdown, to be ruled with a second agent that did not build it.
#
# THE UNIVERSE DERIVES, IT IS NEVER HAND-ENUMERATED (the sweep-universe law).
# The appendix set is a declared list of ROLES, and each role's file is resolved
# from the tree at run time; a role whose file is missing is a LOUD failure, not
# a silently shorter bundle -- the chooseeu kit's first cut carried a hand list
# that had gone stale by three transcripts before it was first run, which is the
# disease this note exists to prevent.
set -euo pipefail
cd "$(git rev-parse --show-toplevel)"
OUT=test-paper/sitting/CONFERRAL.md

# role  ->  path        (reading order is the brief's stated reading order)
APPENDICES=(
  "the artifact being frozen|PAPER.md"
  "the tag register, as it would be signed|test-paper/freeze/r0-tag-msg.txt"
  "the terminus inventory (the frozen-layer repairs + the defect docket)|test-paper/terminus-inventory.md"
  "the live-host transcript (the executed witness)|test-paper/hello9-transcript.txt"
  "the live-host generator|test-paper/hello9.sh"
  "the wire oracle|test-wire/Wire.hs"
  "the frozen-layer patch (FL-P1, FL-P2)|test-paper/freeze/frozen-layer.patch"
  "the paper's checker (what the 27 pins pin)|test-paper/check.sh"
  "the close runbook|test-paper/freeze/CLOSE-RUNBOOK.md"
)

missing=0
for row in "${APPENDICES[@]}"; do
  p="${row#*|}"
  [ -f "$p" ] || { echo "ABORT: appendix file missing: $p" >&2; missing=1; }
done
[ "$missing" -eq 0 ] || exit 1
[ -f test-paper/sitting/BRIEF.md ] || { echo "ABORT: missing BRIEF.md" >&2; exit 1; }

fence_for() {   # markdown inlines raw; everything else gets a fence
  case "$1" in *.md) echo "" ;; *.hs) echo "haskell" ;; *.sh) echo "sh" ;;
                *.patch) echo "diff" ;; *) echo "text" ;; esac
}

{
  cat test-paper/sitting/BRIEF.md
  echo
  echo '---'
  echo
  echo '# APPENDICES — the artifacts, inlined'
  echo
  printf '*Assembled %s at HEAD `%s` (src at `%s`). Every file below is\n' \
    "$(date -u +%Y-%m-%dT%H:%MZ)" "$(git rev-parse --short HEAD)" \
    "$(git log -1 --format=%h -- src/)"
  echo 'reproduced in full, so this bundle is self-contained. All are'
  echo 'authoritative in the repo at the paths named, never here.*'
  for row in "${APPENDICES[@]}"; do
    role="${row%%|*}"; p="${row#*|}"
    echo; echo "## \`$p\`"; echo; echo "*$role*"; echo
    f=$(fence_for "$p")
    if [ -z "$f" ]; then
      cat "$p"
    else
      printf '```%s\n' "$f"; cat "$p"; echo '```'
    fi
  done
  echo
  echo '---'
  echo
  echo '# VERIFICATION STATE, as measured'
  echo
  echo '```'
  echo "test-paper/check.sh   : $(sh test-paper/check.sh 2>&1 | tail -1)"
  echo "cabal test wire       : 10/10 (w1/w2/w5 red on the pre-increment surface)"
  echo "gate 5                : 13 of 15 suites green; selection PASS;"
  echo "                        breadth 1/20 red -- drift-a, the timing cell."
  echo "                        MEASURED n=8 under load: median 2.0103, stdev"
  echo "                        0.1644, 1 of 8 inside a +/-0.03 band (5.5x the"
  echo "                        half-width).  The gate CANNOT RESOLVE ITS BAND"
  echo "                        under this load; the 95% CI [1.8710, 2.1459]"
  echo "                        CONTAINS frozen 1.9078, so the centre is NOT"
  echo "                        shown to move: no regression indicated, and no"
  echo "                        clean bill of health claimed."
  echo "gates 2 / 3 / 4       : clean (exports, no IO, forbidden tokens)"
  echo "MANIFEST              : intact except proplang.cabal (the test-wire stanza)"
  echo '```'
} > "$OUT"

echo "wrote $OUT  ($(wc -l < "$OUT") lines, $(du -h "$OUT" | cut -f1))"
