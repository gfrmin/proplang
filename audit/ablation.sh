#!/bin/sh
# audit/ablation.sh — gate 7: the deletion audit against the real
# grammar (code-level CPP ablation, never a mock). SINCE the exact
# boundary's R11 retirement: the fixture sets are the verb ablations
# (audit/ablation-exact: Cond the entrant, Expect, Code) and the
# structural-atom ablations (test-pin/ablation: Get, If, Gt, Var,
# Sub, Mul, C). Each fixture compiles against src and FAILS under
# its -DDROP_<seat> flag.
set -u
cd "$(dirname "$0")/.." || exit 2
fail=0
sh audit/ablation-exact/run.sh src || fail=1
sh test-pin/ablation/run.sh src || fail=1
exit $fail
