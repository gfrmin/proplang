#!/usr/bin/env bash
# The exact boundary's gates (EXACT_PLAN section 7), scriptable halves.
# RED BY DESIGN until Phase 2 lands the exact src; green is Phase 2's
# definition of done alongside gates 1-7.
#   E1  exactness: no Double / logBase / exp / log / lse / NaN token in
#       the core belief-construction modules
#   E2  reporting confinement: fromRational appears only in Report/Host
#       (the display edge) — the core never renders
#   E3  core/world firewall: no concrete point-set literal in src/
#       (grids arrive in a World; the retired thetaPoints et al. gone)
set -u
fail=0
core="src/PropLang/Belief.hs src/PropLang/Syntax.hs src/PropLang/Eval.hs src/PropLang/Enumerate.hs"
# [REPAIRED at the exact close (the freeze-day incident): the old
# filter grep -v '^\s*--' never matched grep's file:line-prefixed
# output, so comment prose counted as code tokens. The repair strips
# each line's comment tail BEFORE matching; the two-sided seeded
# demonstration rides the close pack.]
e1=$(for f in $core; do sed 's/--.*$//' "$f" 2>/dev/null; done | grep -cE '\bDouble\b|\blogBase\b|\bexp\b|\blog\b|\blse\b|isNaN|isInfinite')
echo "E1 forbidden-inexactness tokens in core: $e1 (must be 0)"
[ "$e1" -eq 0 ] || fail=1
e2=$(for f in $core; do sed 's/--.*$//' "$f" 2>/dev/null; done | grep -cE 'fromRational')
echo "E2 fromRational renders in core: $e2 (must be 0; display lives at the edge)"
[ "$e2" -eq 0 ] || fail=1
e3=$(for f in src/PropLang/*.hs; do sed 's/--.*$//' "$f" 2>/dev/null; done | grep -cE 'thetaPoints|tauPoints|rhoPoints|0\.1 :\||\(0 :\| \[1, 2, 8\]\)|0\.5 :\|')
echo "E3 concrete point-sets in src: $e3 (must be 0; worlds declare)"
[ "$e3" -eq 0 ] || fail=1
exit $fail
