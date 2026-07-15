#!/bin/sh
# audit/run-gates.sh — all seven gates from CLAUDE.md (FROZEN).
#
#   1  -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns
#      clean on all of src/ (the flags live in proplang.cabal and are
#      verified present).
#   2  export-list check: Belief(..) never exported; PropLang.Belief
#      exports exactly the frozen list (audit/belief-exports.txt).
#   3  effect check: no IO token in Belief/Syntax/Eval/Enumerate.
#   4  forbidden imports/tokens in src/ (audit/forbidden.txt), code
#      tokens only, comments and strings excluded.
#   5  the frozen suites, via `cabal test all` (originally
#      test/Acceptance.hs + test/Properties.hs; Acceptance retired at
#      the step-3 sentence freeze — its four deliverables live on in
#      test-sentence/ g1 — and every increment's suite is absorbed by
#      the same `cabal test all`, the canonized increment protocol).
#      In --phase 1 the expected state is: the suites COMPILE and RUN
#      and FAIL (src/ is stubs); the gate confirms exactly that. In
#      --phase 2 they must pass.
#   6  sha256sum -c MANIFEST.sha256. In --phase 1, PENDING until the
#      human signs; the exact command is printed.
#   7  the deletion audit runs against the real grammar:
#      audit/ablation.sh (code-level CPP ablation, not a mock).
#
# usage: audit/run-gates.sh [--phase 1|2]     (default: 2)
# Overrides: $GHC, $CABAL, $PYTHON.

set -u
PHASE=2
if [ "${1:-}" = "--phase" ]; then PHASE="${2:-2}"; fi
cd "$(dirname "$0")/.." || exit 2

CABAL="${CABAL:-cabal}"
PY="${PYTHON:-python3}"

overall=0
summary=""

note() {
    summary="${summary}gate $1  $2
"
    echo "==> gate $1: $2"
    if [ "$2" = "FAIL" ]; then overall=1; fi
}

echo "=== proplang gates (phase $PHASE) ==="

# -- gate 1: warnings-as-errors build of src/ --------------------------------
echo "--- gate 1: compiler flags + clean build of src/"
if grep -q -- '-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns' \
        proplang.cabal \
   && "$CABAL" build lib:proplang >/dev/null 2>&1; then
    note 1 PASS
else
    note 1 FAIL
fi

# -- gate 2: the sealed reasoner's export list -------------------------------
echo "--- gate 2: PropLang.Belief export list"
if "$PY" audit/check_exports.py src/PropLang/Belief.hs \
        audit/belief-exports.txt; then
    note 2 PASS
else
    note 2 FAIL
fi

# -- gate 3: no IO in the pure modules ---------------------------------------
echo "--- gate 3: no IO token in Belief/Syntax/Eval/Enumerate"
if "$PY" audit/strip_comments.py --word IO \
        src/PropLang/Belief.hs src/PropLang/Syntax.hs \
        src/PropLang/Eval.hs src/PropLang/Enumerate.hs; then
    note 3 PASS
else
    note 3 FAIL
fi

# -- gate 4: forbidden tokens in src/ ----------------------------------------
echo "--- gate 4: forbidden tokens (audit/forbidden.txt) in src/"
if "$PY" audit/strip_comments.py --forbidden audit/forbidden.txt \
        src/PropLang/Belief.hs src/PropLang/Syntax.hs \
        src/PropLang/Eval.hs src/PropLang/Enumerate.hs \
        src/PropLang/Host.hs; then
    note 4 PASS
else
    note 4 FAIL
fi

# -- gate 5: the frozen suites -----------------------------------------------
echo "--- gate 5: cabal test all (the frozen suites)"
if ! "$CABAL" build --enable-tests all >/dev/null 2>&1; then
    echo "test suites do not compile"
    note 5 FAIL
else
    if "$CABAL" test all >/dev/null 2>&1; then
        teststate=pass
    else
        teststate=fail
    fi
    if [ "$PHASE" = "1" ]; then
        # Phase 1: suites must compile and run but FAIL (src/ is stubs)
        if [ "$teststate" = "fail" ]; then
            echo "suites compile, run, and fail on stub src/ (expected in phase 1)"
            note 5 "EXPECTED-FAIL (phase 1: confirmed)"
        else
            echo "suites PASS against stub src/ — the oracle is vacuous"
            note 5 FAIL
        fi
    else
        if [ "$teststate" = "pass" ]; then
            note 5 PASS
        else
            note 5 FAIL
        fi
    fi
fi

# -- gate 6: the signed manifest ---------------------------------------------
echo "--- gate 6: MANIFEST.sha256"
if [ -f MANIFEST.sha256 ]; then
    if sha256sum -c MANIFEST.sha256 >/dev/null 2>&1; then
        note 6 PASS
    else
        sha256sum -c MANIFEST.sha256 2>&1 | grep -v ': OK$' || true
        note 6 FAIL
    fi
else
    if [ "$PHASE" = "1" ]; then
        echo "MANIFEST.sha256 absent — Phase 1 ends with the human running:"
        echo '  { find test audit -type f; echo CLAUDE.md; echo proplang.py; echo tests_acceptance.py; echo test_output.txt; } | sort | xargs sha256sum > MANIFEST.sha256'
        echo "and signing it (review first: PHASE1_REPORT.md)."
        note 6 "PENDING (human signature)"
    else
        note 6 FAIL
    fi
fi

# -- gate 7: the deletion audit against the real grammar ---------------------
echo "--- gate 7: code-level ablation (audit/ablation.sh)"
if sh audit/ablation.sh all; then
    note 7 PASS
else
    note 7 FAIL
fi

echo ""
echo "=== summary (phase $PHASE) ==="
printf '%s' "$summary"
exit $overall
