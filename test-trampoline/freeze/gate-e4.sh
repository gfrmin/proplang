#!/usr/bin/env bash
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
set -u
fail=0
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
  | grep -c .)
echo "E4 engine-derived comparisons outside evalx: $e4 (must be 0; allowlist: draw walk, rNum display, arity validation, tick bound)"
[ "$e4" -eq 0 ] || fail=1
exit $fail
