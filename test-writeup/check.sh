#!/bin/sh
# test-writeup/check.sh — the write-up boundary's machine check
# (WRITEUP_PLAN W4/W6 as ruled: the reduced form — the write-up
# computes nothing, so the check is textual and git-level only).
#
# Base mode  (sh test-writeup/check.sh):        content checks — quote
#   fidelity against brief.md, the closed status set, pointer
#   resolution, pin agreement between WRITEUP.md and its frozen
#   sources, the textual gates, the four increment tags.
# Close mode (sh test-writeup/check.sh --close): adds the freeze-state
#   checks — the five close files in MANIFEST.sha256, the manifest
#   verifying, and the brief-freeze / writeup-freeze tags. Run by the
#   closing reviewer block; red until the close is complete.
#
# RED BY DESIGN until Task 3 fills the audit (statuses empty and the
# §4 pin quotes absent flip their checks) — the oracle-first analog
# for a document boundary.
#
# usage: sh test-writeup/check.sh [--close]   (from the repo root)

set -u
LC_ALL=C.UTF-8; export LC_ALL
cd "$(dirname "$0")/.." || exit 2

MODE="${1:-}"
pass=0; fail=0
ok()  { pass=$((pass+1)); echo "[writeup] $1: PASS"; }
bad() { fail=$((fail+1)); echo "[writeup] $1: FAIL${2:+ — $2}"; }

out="${TMPDIR:-/tmp}/proplang-writeup.$$"
mkdir -p "$out"
trap 'rm -rf "$out"' EXIT INT TERM

# ---- W0: the artifacts exist ----------------------------------------
[ -f WRITEUP.md ] && ok "W0a WRITEUP.md exists" \
                  || bad "W0a WRITEUP.md exists"
[ -f brief.md ]   && ok "W0b brief.md exists" \
                  || bad "W0b brief.md exists"
[ -f WRITEUP.md ] && [ -f brief.md ] || { echo "[writeup] aborting: missing artifact"; exit 1; }

# ---- audit section extraction ---------------------------------------
awk '/<!-- S12-audit-begin -->/,/<!-- S12-audit-end -->/' WRITEUP.md \
    > "$out/audit"
[ -s "$out/audit" ] && ok "W1 audit section delimited" \
                    || bad "W1 audit section delimited" "markers missing"

# ---- Q: quote fidelity (W4 — byte-for-byte against brief.md) --------
grep '^> ' "$out/audit" | sed 's/^> //' > "$out/quotes"
qn=$(wc -l < "$out/quotes")
[ "$qn" -eq 10 ] && ok "Q0 exactly 10 quoted lines ($qn)" \
                 || bad "Q0 exactly 10 quoted lines" "got $qn"
i=0
while IFS= read -r q; do
    i=$((i+1))
    if grep -qxF -- "$q" brief.md; then
        ok "Q$i quote is a byte-exact brief.md line"
    else
        bad "Q$i quote is a byte-exact brief.md line" "${q%%:*}"
    fi
done < "$out/quotes"

# ---- S: the closed status set ---------------------------------------
grep '^\*\*Status: ' "$out/audit" > "$out/statuses" || true
sn=$(wc -l < "$out/statuses")
[ "$sn" -eq 10 ] && ok "S0 exactly 10 status lines ($sn)" \
                 || bad "S0 exactly 10 status lines" "got $sn"
if grep -qEv '^\*\*Status: (DONE|RECORDED DEBT|NAMED OPEN)\*\*( — .*)?$' \
        "$out/statuses"; then
    bad "S1 every status in the closed set" \
        "$(grep -cEv '^\*\*Status: (DONE|RECORDED DEBT|NAMED OPEN)\*\*( — .*)?$' "$out/statuses") outside {DONE, RECORDED DEBT, NAMED OPEN}"
else
    ok "S1 every status in the closed set"
fi

# ---- P: pointer resolution (cited paths exist) ----------------------
grep -oE '`[A-Za-z0-9_./-]+`' "$out/audit" | tr -d '`' | sort -u \
    | grep -E '/|\.' > "$out/paths" || true
pmiss=0
while IFS= read -r p; do
    [ -e "$p" ] || { pmiss=$((pmiss+1)); echo "[writeup]   missing: $p"; }
done < "$out/paths"
[ "$pmiss" -eq 0 ] && ok "P0 all $(wc -l < "$out/paths") cited paths exist" \
                   || bad "P0 all cited paths exist" "$pmiss missing"

# ---- N: pin agreement (quoted in WRITEUP.md AND in the frozen source)
pin() {
    name="$1"; lit="$2"; src="$3"
    if ! grep -qF -- "$lit" "$src"; then
        bad "$name" "literal not in $src"
    elif ! grep -qF -- "$lit" WRITEUP.md; then
        bad "$name" "literal not quoted in WRITEUP.md"
    else
        ok "$name"
    fi
}
pin "N1 t1 MAP posterior"  '0.6383157408996493' test/Anchors.hs
pin "N2 t1 MAP sentence"   "('bern', ('if', ('>', ('get', 't'), ('c', 'tau', 11)), ('c', 'theta', 0), ('c', 'theta', 8)))" test/Anchors.hs
pin "N3 t2 row price 0.3"  '(0.3, 1, "L")'   test/Anchors.hs
pin "N4 t2 row price 0.05" '(0.05, 3, "L")'  test/Anchors.hs
pin "N5 t2 row price .005" '(0.005, 12, "L")' test/Anchors.hs
pin "N6 t2 row price 0"    '(0.0, 12, "L")'  test/Anchors.hs
pin "N7 t3 forgetter row"  '(0.8, 369.7929712967316, 396.60210068705993)' test/Anchors.hs
pin "N8 STDNAME row"       '| STDNAME | EU, IsEq, VAct, VThink, Bern, VThinkK, VPre | log2 7 |' typed-port-spec.md
pin "N9 UTIL row"          '| UTIL | USay | 0 bits |' typed-port-spec.md

# ---- G: textual gates ------------------------------------------------
nf=$(grep -rhoE 'DROP_[A-Z_]+' src | sort -u | wc -l)
[ "$nf" -eq 14 ] && ok "G1 fourteen ablation flags in src/ ($nf)" \
                 || bad "G1 fourteen ablation flags in src/" "got $nf"
ns=$(grep -c '^test-suite ' proplang.cabal)
[ "$ns" -eq 8 ] && ok "G2 eight test-suite stanzas ($ns)" \
                || bad "G2 eight test-suite stanzas" "got $ns"
grep -qx 'forget' audit/forbidden.txt \
    && ok "G3 the forgetting family is gate-4 forbidden" \
    || bad "G3 the forgetting family is gate-4 forbidden"

# ---- T: the increment tags verify ------------------------------------
for t in membrane-freeze ladder-freeze prepost-freeze cirl-freeze; do
    if git tag -v "$t" >/dev/null 2>&1; then
        ok "T tag $t verifies"
    else
        bad "T tag $t verifies"
    fi
done

# ---- close mode: the freeze state ------------------------------------
if [ "$MODE" = "--close" ]; then
    for f in brief.md WRITEUP.md test-writeup/check.sh ROADMAP.md \
             boundary-queue.md; do
        grep -qF "  $f" MANIFEST.sha256 \
            && ok "C manifest covers $f" \
            || bad "C manifest covers $f"
    done
    if sha256sum -c --quiet MANIFEST.sha256 >/dev/null 2>&1; then
        ok "C manifest verifies"
    else
        bad "C manifest verifies"
    fi
    for t in brief-freeze writeup-freeze; do
        if git tag -v "$t" >/dev/null 2>&1; then
            ok "C tag $t verifies"
        else
            bad "C tag $t verifies"
        fi
    done
fi

# ---- verdict ----------------------------------------------------------
echo "[writeup] $pass passed, $fail failed"
[ "$fail" -eq 0 ] || exit 1
exit 0
