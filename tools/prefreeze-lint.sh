#!/usr/bin/env bash
# THE PRE-FREEZE LINT (the author's order, 2026-07-16, step-6 sitting;
# stream-author-pack.md section 25): remembered law converted into
# enforced law — "enforced, never trusted" applied to the process
# itself. Run from repo root BEFORE every freeze tag. Frozen artifacts
# are read, never edited; this tool runs BESIDE the frozen gates.
#
# Rows L1-L5 FAIL the lint; L6 is ADVISORY (WARN) — its clause keeps
# the non-scriptable half. Exit nonzero iff any FAIL.
set -u
cd "$(dirname "$0")/.."

fails=0; warns=0
ok()   { printf 'PASS  %s\n' "$1"; }
bad()  { printf 'FAIL  %s\n' "$1"; fails=$((fails+1)); }
warn() { printf 'WARN  %s\n' "$1"; warns=$((warns+1)); }

echo "=== prefreeze-lint (tools/, unfrozen; first ordered at the step-6 sitting) ==="

# -- L1: forbidden tokens BY GLOB over src/ ---------------------------------
# gate 4's frozen scan names five files; a module landing after that
# freeze escapes it (Membrane.hs did — the test-membrane gate-4 mirror
# row is the workaround, THIS is the fix). Same frozen list, same
# frozen stripper, read-only, every src file.
l1=0
for f in src/PropLang/*.hs; do
  if ! python3 audit/strip_comments.py --forbidden audit/forbidden.txt "$f" \
       >/dev/null 2>&1; then
    bad "L1 forbidden token in $f (audit/forbidden.txt, comments stripped)"
    l1=1
  fi
done
[ "$l1" -eq 0 ] && ok "L1 forbidden-tokens-by-glob: $(ls src/PropLang/*.hs | wc -l) src files clean (frozen gate 4 names 5)"

# -- L2: ASCII-only test names (the membrane locale incident) ---------------
# scans string literals on testCase/testGroup/testProperty lines only
# (comments legitimately carry non-ASCII).
l2=0
while IFS=: read -r file line rest; do
  bad "L2 non-ASCII test name at $file:$line"
  l2=1
done < <(grep -rn 'testCase\|testGroup\|testProperty' test*/*.hs 2>/dev/null \
         | grep -oP '^[^:]+:[0-9]+:.*"(.*)"' \
         | awk -F'"' '{ for (i=2; i<=NF; i+=2) if ($i ~ /[^\x00-\x7F]/) print $0 }' \
         | cut -d: -f1,2 | sort -u)
[ "$l2" -eq 0 ] && ok "L2 ASCII test names across test*/"

# -- L3: manifest ------------------------------------------------------------
if sha256sum -c MANIFEST.sha256 >/dev/null 2>&1; then
  ok "L3 MANIFEST.sha256: $(wc -l < MANIFEST.sha256) rows verified"
else
  bad "L3 MANIFEST.sha256 verification"
fi

# -- L4: freeze-tag signatures -----------------------------------------------
l4=0; ntags=0
for t in $(git tag); do
  ntags=$((ntags+1))
  if ! git tag -v "$t" >/dev/null 2>&1; then
    bad "L4 tag signature: $t"
    l4=1
  fi
done
[ "$l4" -eq 0 ] && ok "L4 all $ntags tags verify"

# -- L5: SAT flag-faithfulness in the current author pack --------------------
# every overlay/satisfiability transcript must record the stanza's
# exact flag set, -Werror included (the step-5 flag-faithful amendment).
pack=$(ls -t *author-pack.md 2>/dev/null | head -1)
if [ -n "${pack:-}" ] && grep -qi "satisfiability\|overlay" "$pack"; then
  l5=0
  for flag in -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns; do
    grep -qF -- "$flag" "$pack" || { bad "L5 $pack SAT section lacks $flag"; l5=1; }
  done
  [ "$l5" -eq 0 ] && ok "L5 $pack records the four stanza flags (incl. -Werror)"
else
  warn "L5 no author pack with a SAT/overlay section found (nothing to check)"
fi

# -- L6 (ADVISORY): probe re-declaration of importable grid values -----------
# the tauPoints incident's scriptable half: an oracle/probe file that
# re-declares a full exported grid list instead of importing it. The
# clause ("a probe reads declared data") keeps the judgment half.
for grid in thetaPoints tauPoints rhoPoints; do
  lits=$(sed -n "/^$grid ::/,/]/p" src/PropLang/Enumerate.hs \
         | grep -oP '[0-9]+(\.[0-9]+)?([eE]-?[0-9]+)?' | head -4 | paste -sd, -)
  [ -z "$lits" ] && continue
  hits=$(grep -rln -- "${lits%%,*}" test*/ 2>/dev/null \
         | xargs -r grep -l "$(echo "$lits" | tr ',' '\n' | sed -n 2p)" 2>/dev/null || true)
  for h in $hits; do
    grep -q "import.*Enumerate" "$h" && continue
    warn "L6 $h carries $grid-like leading literals without importing Enumerate (advisory)"
  done
done
[ "$warns" -eq 0 ] && ok "L6 no grid re-declaration flags (advisory heuristic)"

echo "=== prefreeze-lint: $fails FAIL, $warns WARN ==="
exit "$( [ "$fails" -eq 0 ] && echo 0 || echo 1 )"
