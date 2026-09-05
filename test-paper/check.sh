#!/bin/sh
# test-paper/check.sh — the demonstration-tier paper's machine check.
#
# The paper (PAPER.md) is a document boundary, the step-5 capstone: it
# computes nothing, so the check is textual and git-level only, exactly
# as test-writeup/check.sh is for WRITEUP.md.  Its job is the
# one-generator law: every number PAPER.md states is PINNED — the same
# literal must appear in PAPER.md AND in its frozen source (test/Anchors.hs,
# test_output.txt, the frozen docs), so the paper derives-and-asserts and
# can never drift stale against the oracle it reports.
#
# Base mode  (sh test-paper/check.sh):        content checks — the thesis
#   quote's fidelity against brief.md, pin agreement against the EXACT
#   sources, pointer resolution, the claims-register's completeness.
# Close mode (sh test-paper/check.sh --close): adds the freeze-state —
#   PAPER.md + this script in MANIFEST.sha256, the manifest verifying, and
#   the terminus tag.  Run by PAPER.md's closing reviewer block; red until
#   the close is complete.
#
# RED BY DESIGN until PAPER.md is filled (the pins absent flip their
# checks) — the oracle-first analog for a document boundary, the same
# discipline test-writeup/check.sh states in its own header.
#
# usage: sh test-paper/check.sh [--close]   (from the repo root)

set -u
LC_ALL=C.UTF-8; export LC_ALL
cd "$(dirname "$0")/.." || exit 2

MODE="${1:-}"
TERMINUS_TAG="paper-freeze-r0"   # the anticipated step-5 terminus tag
DOC=PAPER.md
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "[paper] $1: PASS"; }
bad() { fail=$((fail+1)); echo "[paper] $1: FAIL${2:+ — $2}"; }

out="${TMPDIR:-/tmp}/proplang-paper.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

# ---- P0: the artifacts exist ----------------------------------------
[ -f "$DOC" ] && ok "P0a $DOC exists" || bad "P0a $DOC exists"
[ -f brief.md ] && ok "P0b brief.md exists" || bad "P0b brief.md exists"
[ -f "$DOC" ] && [ -f brief.md ] || { echo "[paper] aborting: missing artifact"; exit 1; }

# ---- Q: thesis quote fidelity (byte-for-byte against brief.md) ------
# The paper's §0 quotes the brief's thesis; each substring must be a
# byte-exact fragment of brief.md AND appear in PAPER.md.
q() {
    name="$1"; lit="$2"
    if ! grep -qF -- "$lit" brief.md; then
        bad "$name" "not byte-exact in brief.md"
    elif ! grep -qF -- "$lit" "$DOC"; then
        bad "$name" "thesis fragment not quoted in $DOC"
    else
        ok "$name"
    fi
}
q "Q1 thesis (adaptivity is not built)" "adaptivity is not a thing you build"
q "Q2 thesis (one rule, for free)"      "a single learning rule handles it for free"

# ---- N: pin agreement (literal in the frozen source AND in PAPER.md) -
# The one-generator law: PAPER.md copies each anchor byte-wise from the
# artifact that generates it; the check is `grep -F` by construction.
pin() {
    name="$1"; lit="$2"; src="$3"
    if ! grep -qF -- "$lit" "$src"; then
        bad "$name" "literal not in $src (source moved — regenerate)"
    elif ! grep -qF -- "$lit" "$DOC"; then
        bad "$name" "literal not pinned in $DOC"
    else
        ok "$name"
    fi
}
# soundness — the four gates (test/Anchors.hs is the generated exact oracle;
# test_output.txt is the frozen readable transcript)
pin "N1 t1 MAP change-point sentence" \
    "('bern', ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)))" \
    test_output.txt
pin "N2 t1 MAP guard/theta indices"   "t1MapIndicesX = (11,0,8)"                       test/Anchors.hs
pin "N3 t1 consult ticks"             "t1ConsultTicksX = [0,1,3,4,65,66,67,68,69,70]"  test/Anchors.hs
pin "N4 t2 lazy-genius rows 1/3/12/12" \
    '[(3 % 10,1,"L"),(1 % 20,3,"L"),(1 % 200,12,"L"),(0 % 1,12,"L")]'                   test/Anchors.hs
pin "N5 t2 the priced deliberation loop" \
    "while argmax([act, think]) == think: condition on a batch"                        test_output.txt
pin "N6 t3 agent drift log-loss"      "339.78242360387446"                             test/Anchors.hs
pin "N7 t3 agent flat log-loss"       "351.1061771452692"                              test/Anchors.hs
pin "N8 t3 agent MAP is a latent drift-rate" "('hmm', ('c', 'rho', 3))"                test_output.txt
pin "N9 t3 forgetter g=0.8 row"       "(4 % 5,369.7929712967314,396.6021006870599)"    test/Anchors.hs
# necessity — the deletion audit
pin "N10 t4 deletion counts"          "t4CountsX = (1169,0,0)"                          test/Anchors.hs
pin "N11 t4 cond ablation cost"       "160 vs 97 bits"                                  test_output.txt
pin "N12 t4 rw/hmm ablation cost"     "211 vs 207 bits"                                 test_output.txt
# the language, exactness, and the measured cost
pin "N13 the nine wire forms"         "var c + - * get if > ="                          membrane-wire.md
pin "N14 exactness — no log-space"    "no log-space"                                    KERNEL.md
pin "N15 bench cost exponent band"    "1.43–1.60"                                       bench/bench-fold-depth-r01.md
pin "N16 bench real-declaration alpha" '`alpha_3p` = 2.44'                              bench/bench-fold-depth-r01.md
# the T1 bridge: the MAP sentence's indices are GRID POSITIONS, so the grids
# themselves are pinned -- otherwise "tau index 11 is 60" is exactly the kind
# of prose a regenerated grid would silently falsify.
pin "N17 t1 tau grid (index 11 = 60)" \
    "tauG = [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80]"            test/ExactReference.hs
pin "N18 t1 theta grid (0 = 0.1, 8 = 0.9)" \
    "thetaG = [1 % 10, 2 % 10, 3 % 10, 4 % 10, 5 % 10, 6 % 10, 7 % 10, 8 % 10, 9 % 10]" test/ExactReference.hs
pin "N19 t1 the world's true shift at 60" \
    "y_t = [rng.random() < (0.9 if t<60 else 0.1)]"                                      test/Streams.hs
# T3's two honesty rows: the drift-optimal forgetter the agent BEATS, and the
# stationary row where the agent LOSES.  The loss row is what makes the candour
# claim true, so it is pinned exactly as the winning row is.
pin "N20 t3 drift-optimal forgetter g=0.95" \
    "(19 % 20,340.88263044835253,359.3527535371698)"                                     test/Anchors.hs
pin "N21 t3 the row the agent LOSES (g=1.0 on flat)" \
    "(1 % 1,397.92621119190125,350.330276640413)"                                        test/Anchors.hs
# section 8: the DYADIC profile is representation-contaminated too, not just
# the real declaration -- the pin that keeps section 8 from over-exempting it.
pin "N22 bench dyadic state growth"   "19.8 bits/tick"                                   bench/bench-fold-depth-r01.md
pin "N23 bench dyadic snap coefficient" "81x collapse"                                   bench/bench-fold-depth-r01.md
# section 7: the live-host transcript is a generated artifact in-tree, so the
# paper's quotation of it is pinned to it exactly like any frozen anchor.
pin "N24 live wire: the act flips on evidence" \
    "0.36666666666666664"                                                                test-paper/hello9-transcript.txt
pin "N25 live wire: loss falls to 0.25" \
    "0.2546077860279184"                                                                 test-paper/hello9-transcript.txt
# section 7 leg 3: the door's refusal of an undeclared utility read, and the
# oracle row that pins the session surviving it.  Both quoted in the paper,
# so both pinned -- the defect this section reports is the one place the
# paper is most tempting to describe rather than witness.
pin "N26 live wire: the door's refusal message" \
    '{"error": "names outside namespace"}'                                               test-paper/hello9-transcript.txt
pin "N27 the wire oracle's session-survival row" \
    "a refused hello leaves a live session, not a dead host"                             test-wire/Wire.hs

# ---- G: the live-host transcript is the generator's current output ---
# The generator exemption's standing identity row: hello9.sh lands in-tree
# WITH the artifact it generates, and regenerating must reproduce it.  A
# transcript that has drifted from its generator is a hand-maintained copy
# wearing a generated file's name (the one-generator law).
if [ -x test-paper/hello9.sh ] && command -v cabal >/dev/null 2>&1 \
   && cabal list-bin proplang-host >/dev/null 2>&1; then
    if sh test-paper/hello9.sh 2>&1 | diff -q - test-paper/hello9-transcript.txt >/dev/null 2>&1; then
        ok "G1 hello9-transcript.txt reproduces from its generator"
    else
        bad "G1 hello9-transcript.txt reproduces from its generator" \
            "regenerate: sh test-paper/hello9.sh > test-paper/hello9-transcript.txt"
    fi
else
    echo "[paper] G1 SKIPPED (proplang-host not built; run: cabal build proplang-host)"
fi

# ---- P: pointer resolution (cited paths exist or resolve) -----------
grep -oE '`[A-Za-z0-9_./-]+`' "$DOC" | tr -d '`' | sort -u \
    | grep -E '/|\.' > "$out/paths" || true
pmiss=0
while IFS= read -r p; do
    [ -z "$p" ] && continue
    case "$p" in *.*) : ;; */*) : ;; *) continue ;; esac
    if [ -e "$p" ]; then continue; fi
    if [ -e "src/PropLang/$p" ]; then
        echo "[paper]   bare module citation resolves: src/PropLang/$p"; continue
    fi
    arch="archive/$(printf '%s' "$p" | sed 's|/|__|g')"
    if [ -e "$arch" ]; then
        echo "[paper]   archived (dated): $p"; continue
    fi
    pmiss=$((pmiss+1)); echo "[paper]   missing: $p"
done < "$out/paths"
[ "$pmiss" -eq 0 ] && ok "P1 all $(wc -l < "$out/paths") cited paths resolve" \
                   || bad "P1 all cited paths resolve" "$pmiss missing"

# ---- R: the claims register is complete -----------------------------
# Every headline claim carries a register row tagged EXECUTED / ARGUED /
# QUOTED (the unwitnessed-assertion law).  The register is delimited and
# every one of its table rows carries exactly one of the three tags.
awk '/<!-- claims-register-begin -->/,/<!-- claims-register-end -->/' "$DOC" \
    > "$out/register"
[ -s "$out/register" ] && ok "R0 claims register delimited" \
                       || bad "R0 claims register delimited" "markers missing"
# table rows: start with '|', not the header/separator
grep '^|' "$out/register" | grep -vE '^\|[ -]*(claim|:?-+:?)' > "$out/rrows" || true
rn=$(grep -c . "$out/rrows")
[ "$rn" -ge 6 ] && ok "R1 claims register has rows ($rn >= 6)" \
               || bad "R1 claims register has >= 6 rows" "got $rn"
runtag=$(grep -vE 'EXECUTED|ARGUED|QUOTED' "$out/rrows" | grep -c .)
[ "$runtag" -eq 0 ] && ok "R2 every register row is EXECUTED / ARGUED / QUOTED" \
                    || bad "R2 every register row tagged" "$runtag untagged rows"

# ---- close mode: the freeze state -----------------------------------
if [ "$MODE" = "--close" ]; then
    for f in "$DOC" test-paper/check.sh; do
        grep -qF "  $f" MANIFEST.sha256 \
            && ok "C manifest covers $f" \
            || bad "C manifest covers $f"
    done
    if sha256sum -c --quiet MANIFEST.sha256 >/dev/null 2>&1; then
        ok "C manifest verifies"
    else
        bad "C manifest verifies"
    fi
    if git tag -v "$TERMINUS_TAG" >/dev/null 2>&1; then
        ok "C terminus tag $TERMINUS_TAG verifies"
    else
        bad "C terminus tag $TERMINUS_TAG verifies"
    fi
fi

# ---- verdict --------------------------------------------------------
echo "[paper] $pass passed, $fail failed"
[ "$fail" -eq 0 ] || exit 1
exit 0
