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
# Gate E4 — THE SINGLE CHOOSER (the trampoline boundary, EXACT_PLAN
# 13.2): no comparison on any engine-derived quantity outside evalx.
# Scriptable half: in the modules outside the evaluator (Host,
# Membrane), zero ordering/selection tokens after comment-strip,
# except the enumerated allowlist:
#   Host: draw's cumulative sampling walk (host randomness, CL-2's
#         side of the boundary), rNum's display-integrality check
#         (the render edge), the hello arity validation (parse
#         layer, before the engine exists), the hello batch
#         validation (wire-input, category (a)), thinkValue's
#         d <= 0 recursion base (the loop clock);
#   Membrane: runEpisode's tick-count loop bound (the clock's
#         index, never an engine-derived value), preposteriorV's
#         d <= 0 recursion base and runTrampoline's batch-law
#         min (dwBatch w) (length buf) (the loop clock; the min
#         IS the frozen `min 3 bufLen` law g3.1 pins).
# The non-scriptable half (what "engine provenance" means) is law as
# prose with the E-gate register. CATEGORY LAW (register R11, RULED
# at the trampoline freeze: license-by-name — pack Part XI): beyond
# the charter's two licensed categories, (a) wire-input validation
# and (b) constructor-tag dispatch, THREE further categories are
# licensed by name at this freeze — host randomness AFTER the
# belief (draw's walk, CL-2's side), display render (rNum), and the
# loop clock (the tick bound, never an engine-derived value);
# eviction of the occupants to a sim/report module is REGISTERED as
# a demonstration-tier candidate, not ordered here. AT THE FREEZE
# this block is spliced into audit/gates-exact.sh before its
# `exit $fail` (the charter: E4 lands beside E1-E3); this staged
# copy is the single source of the block's bytes.
e4files="src/PropLang/Host.hs src/PropLang/Membrane.hs"
e4=$(for f in $e4files; do sed 's/--.*$//' "$f" 2>/dev/null; done \
  | grep -E ' > | < | >= | <= |\bmax |\bmin |maximumBy|minimumBy|\bcompare\b' \
  | grep -vE "if u <= acc' then x else walk" \
  | grep -vE 'abs d < 1e15' \
  | grep -vE '&& r >= 2' \
  | grep -vE '\| t >= nTicks' \
  | grep -vE '&& bI >= 1' \
  | grep -vE '\| d <= 0 =' \
  | grep -vE 'min \(dwBatch w\) \(length buf\)' \
  | grep -vE 'min \(jwBatch w\) \(length buf\)' \
  | grep -vE '\| t >= total = ' \
  | grep -vE '\| length path < depthCap, ' \
  | grep -c .)
echo "E4 engine-derived comparisons outside evalx: $e4 (must be 0; allowlist: draw walk, rNum display, arity validation, tick bound)"
[ "$e4" -eq 0 ] || fail=1
exit $fail
