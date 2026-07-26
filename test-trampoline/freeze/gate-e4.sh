#!/usr/bin/env bash
# Gate E4 — THE SINGLE CHOOSER (the trampoline boundary, EXACT_PLAN
# 13.2): no comparison on any engine-derived quantity outside evalx.
# Scriptable half: in the modules outside the evaluator (Host,
# Membrane), zero ordering/selection tokens after comment-strip,
# except the enumerated allowlist:
#   Host: draw's cumulative sampling walk (host randomness, CL-2's
#         side of the boundary), rNum's display-integrality check
#         (the render edge), the hello arity validation (parse
#         layer, before the engine exists);
#   Membrane: runEpisode's tick-count loop bound (the clock's
#         index, never an engine-derived value).
# The non-scriptable half (what "engine provenance" means) is law as
# prose with the E-gate register. NOTE (mandate 2): the charter
# licenses only (a) wire-input validation and (b) constructor-tag
# dispatch; the four occupants below span THREE further categories
# (host randomness after the belief, display render, the loop
# clock) — register R11 puts each to the author: license the
# category, or order the occupant's eviction from the E4 modules. AT THE FREEZE this block is
# spliced into audit/gates-exact.sh before its `exit $fail` (the
# charter: E4 lands beside E1-E3); this staged copy is the single
# source of the block's bytes.
set -u
fail=0
e4files="src/PropLang/Host.hs src/PropLang/Membrane.hs"
e4=$(for f in $e4files; do sed 's/--.*$//' "$f" 2>/dev/null; done \
  | grep -E ' > | < | >= | <= |\bmax |\bmin |maximumBy|minimumBy|\bcompare\b' \
  | grep -vE "if u <= acc' then x else walk" \
  | grep -vE 'abs d < 1e15' \
  | grep -vE '&& r >= 2' \
  | grep -vE '\| t >= nTicks' \
  | grep -c .)
echo "E4 engine-derived comparisons outside evalx: $e4 (must be 0; allowlist: draw walk, rNum display, arity validation, tick bound)"
[ "$e4" -eq 0 ] || fail=1
exit $fail
