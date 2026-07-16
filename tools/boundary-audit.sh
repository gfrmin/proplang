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

echo "--- standing observations ---"
echo "note: test-writeup/check.sh G2 asserts 8 cabal stanzas; the cabal now has $(grep -c '^test-suite' proplang.cabal) (dated red-by-design instrument, recorded)"
echo "=== boundary-audit done: M5=$m5flags H=$hflags ==="
