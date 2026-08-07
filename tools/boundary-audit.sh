#!/usr/bin/env bash
# THE BOUNDARY AUDIT (the author's order, 2026-07-16, step-6 sitting;
# stream-author-pack.md section 23): brief-vs-as-built as a STANDING
# EVENT at every roadmap boundary, with greppable rows for the two
# worst known defect shapes. Run from repo root at every boundary; the
# output rides that boundary's author pack. This is a SCREENING
# instrument — its flags are triage inputs for the human sweep (the
# BRIEF_AUDIT row form), never verdicts.
#
#   M5-row: a ruling asserted N times and derived zero (AGENT_PLAN.md:49
#           — M5 was "asserted four times and derived zero times").
#           For each ruling ID, count citation sites vs. lines that
#           look like a definition/derivation site; flag cited >= 4
#           with no candidate definition.
#   H-row:  a load-bearing quantity defined nowhere (AGENT_PLAN.md:45 —
#           "`H` is defined nowhere in this repository"). Every
#           backticked symbol in the wire/membrane docs must resolve
#           somewhere outside those docs (src/, specs, tests) or be
#           marked world-declared.
set -u
cd "$(dirname "$0")/.."

DOCS=$(ls *.md)
echo "=== boundary-audit (screening; first firing = the step-6 boundary) ==="

echo "--- M5-row: ruling citations vs definition sites ---"
ids=$(grep -ohE '\b(M[0-9]{1,2}|R-[A-Z][0-9]{1,2}|D-[a-z]?[0-9]{1,2}|CL-[0-9])\b' \
        $DOCS | sort | uniq -c | awk '$1 >= 4 {print $2}')
m5flags=0
for id in $ids; do
  cites=$(grep -ohE "\b$id\b" $DOCS | wc -l)
  defs=$(grep -hE "\b$id\b" $DOCS \
         | grep -ciE "APPROVED|RULED|RULING|adopted|canoniz|DEFINITION|derivation|registered|recorded|because|the pin:|:=|^#{1,4} ")
  # mutant IDs: an audit/mutants/<ID>-*.patch file IS the definition
  # site (the trampoline Part II triage's named upgrade; the audit's
  # "definition-shaped line" heuristic never counted patch files). A
  # DELETED patch with its deletion in git history also counts —
  # deleted mutants keep their historical pack citations legal
  # (M19/M20/M22/M27, deleted at the trampoline r1 sitting).
  case $id in
    M*) if ls audit/mutants/"$id"-*.patch >/dev/null 2>&1 \
           || git log --diff-filter=D --format= --name-only -- "audit/mutants/${id}-*.patch" 2>/dev/null | grep -q .; then
          defs=$((defs+1))
        fi ;;
  esac
  if [ "$defs" -eq 0 ]; then
    printf 'FLAG  %-8s cited %3d times, candidate definition lines: 0\n' "$id" "$cites"
    m5flags=$((m5flags+1))
  fi
done
echo "M5-row: $m5flags flagged (IDs cited >=4 with no definition-shaped line)"

echo "--- H-row: wire/membrane doc symbols resolve outside those docs ---"
hflags=0
syms=$(grep -ohE '`[A-Za-z][A-Za-z0-9_]{1,30}`' membrane-wire.md interface.md \
       | tr -d '`' | sort -u)
for s in $syms; do
  # resolution sites: src, specs, tests, plans — anything but the two docs
  if ! grep -rqlF -- "$s" src/ typed-port-spec.md design.md test*/ 2>/dev/null; then
    # an IN-DOC definition sentence excuses it (the H defect is
    # "defined NOWHERE" — a wire-native field whose canonical
    # definition site is the wire doc itself is not H-shaped), as
    # does a world-declared marker
    if grep -hF -- "\`$s\`" membrane-wire.md interface.md \
         | grep -qiE "\`$s\` (is|are|counts|names|carries|holds|lists|=|:)" ; then
      :
    elif ! grep -hE "\b$s\b" membrane-wire.md interface.md \
         | grep -qiE "world-declared|the world declares|declared by the world|handshake"; then
      printf 'FLAG  symbol `%s` appears only in wire/membrane docs, no resolution site\n' "$s"
      hflags=$((hflags+1))
    fi
  fi
done
echo "H-row: $hflags flagged (of $(echo "$syms" | wc -l) symbols scanned)"

echo "--- OB-row: obligations ledger vs closed boundaries ---"
# THE OBLIGATIONS LEDGER ROW (the wire boundary opening, 2026-07-20;
# RC-2's remedy — the VoI-row shape mechanized: an atomic obligation
# SCHEDULED@ or RETIRE-UNTIL- a boundary whose freeze tag already
# exists must have been resolved; flag every one that wasn't. Run at
# step 9's close this fires instantly on "VoI non-negativity:
# SCHEDULED@elim, unresolved.")
obflags=0
if [ -f OBLIGATIONS.md ]; then
  targets=$(grep -ohE '(SCHEDULED@|RETIRE-UNTIL-)[a-z0-9-]+' OBLIGATIONS.md \
            | sed -E 's/(SCHEDULED@|RETIRE-UNTIL-)//' | sort -u)
  for t in $targets; do
    if git tag -l "${t}*" | grep -q .; then
      rows=$(grep -nE "(SCHEDULED@|RETIRE-UNTIL-)${t}\b" OBLIGATIONS.md | cut -d: -f1 | tr '\n' ',')
      printf 'FLAG  obligation(s) at OBLIGATIONS.md line(s) %s still open against CLOSED boundary %s\n' "${rows%,}" "$t"
      obflags=$((obflags+1))
    fi
  done
  echo "OB-row: $obflags flagged (open obligations against closed boundaries)"
else
  echo "OB-row: OBLIGATIONS.md missing — itself a flag (the ledger is a standing instrument)"
  obflags=1
fi

# --- the BANKED-FAILURE row (OB-16's mechanization, ruled at the
# 2026-07-22 disposition sitting; the step-10 clause's scriptable
# half): a composition-failure banked under the primitivity gate's
# clause (a) EXPIRES when the alphabet moves. Flag every banked
# clause-(a) failure whose reliance postdates an alphabet motion it
# assumed. The alphabet's motion is prodTable's value in Syntax.hs;
# its last change is the commit that last touched that line.
# [REPAIRED at the completeness opening, 2026-07-27: the original
# -S pickaxe fires only when the string's OCCURRENCE COUNT changes,
# so the in-place value edit 20->9 at the exact re-founding was
# invisible — the row reported the alphabet as last moving
# 2026-07-08 (f989c42) when the true last motion is c2ca82c,
# 2026-07-25, the 9+1 surface itself. -G fires on any diff line
# matching the regex. Two-sided: old output f989c42/2026-07-08,
# repaired output c2ca82c/2026-07-25.]
bfflags=0
alphacommit=$(git log -1 --format=%H -G'prodTable = ProdTable' -- src/PropLang/Syntax.hs 2>/dev/null)
if [ -n "$alphacommit" ]; then
  alphadate=$(git log -1 --format=%cI "$alphacommit")
  echo "banked-failure row: alphabet last moved at ${alphacommit%${alphacommit#???????}} ($alphadate)"
  banked=$(grep -rlnE 'BANK(ED)?|banked composition-failure' OBLIGATIONS.md *_PLAN.md *-pack.md 2>/dev/null | sort -u)
  for f in $banked; do
    # a banked row is stale if the file records reliance NEWER than the
    # alphabet motion without a re-execution note
    if grep -qiE 'banked|BANK' "$f" && ! grep -qiE 're-execut|reexecut|re-tested|RE-EXECUTE' "$f"; then
      printf 'FLAG  %s banks a composition-failure with no re-execution note after the alphabet moved\n' "$f"
      bfflags=$((bfflags+1))
    fi
  done
  echo "banked-failure row: $bfflags flagged"
else
  echo "banked-failure row: prodTable line not found in history — itself a flag"
  bfflags=1
fi

echo "--- standing observations ---"
# REPAIRED at the heir oracle freeze (breadth-freeze-r0, 2026-08-06;
# pack XVII, FL row): the old note hard-printed "test-writeup/check.sh
# G2 asserts 8 cabal stanzas ... (dated red-by-design instrument)" -
# FALSE OF THE TREE since the step-7 unify freeze retired G2 to a green
# RECORD form; a frozen tool never narrates a sibling instrument's
# state from memory. The line now derives everything it prints.
echo "note: test-writeup/check.sh carries its own G2 RECORD row (run it for the state); cabal test-suite stanzas now: $(grep -c '^test-suite' proplang.cabal)"

# --- prose-claim triage (the XV.3 audit row; canonized at the heir ---
# oracle freeze). Bare universal quantifiers in the CURRENT author
# pack outside register/quote context - a TRIAGE INPUT for the human
# sweep, never a verdict (the M5/H row pattern).
curpack=$(git log -1 --pretty= --name-only -- '*author-pack.md' 2>/dev/null | head -1)
if [ -n "$curpack" ] && [ -f "$curpack" ]; then
  pcq=$(grep -cinE '\b(every|no|any|cannot)\b' "$curpack" || true)
  echo "prose-claim triage: $pcq quantifier-bearing line(s) in $curpack - sweep against its claims register (triage input, not a verdict)"
fi
echo "=== boundary-audit done: M5=$m5flags H=$hflags OB=$obflags BF=$bfflags ==="
