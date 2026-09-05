#!/usr/bin/env bash
# drift-distribution.sh -- measure the DISTRIBUTION of breadth's drift-a ratio
# on this box, instead of arguing about a single sample of it.
#
# WHY.  The paper-freeze-r0 sitting ruled (Q3) that a terminus tag must not rest
# on "we believe it was noise": no claim without a transcript.  The box cannot be
# quieted (a long-running job owns a core, by the author's decision), so the
# quiet-box branch is unavailable.  This probe takes the remaining honest route:
# if the per-run statistic is too noisy on this box but its CENTRAL TENDENCY sits
# in band, that is a MEASUREMENT and not a belief, and it can be transcribed.
#
# WHAT IT DOES NOT DO.  It does not re-mint anything, does not touch
# test-breadth/Breadth.hs (frozen, manifest-covered), and does not decide
# whether the close proceeds.  It produces evidence for the author's ruling.
#
# It runs ONLY the drift-a cell (tasty -p), k times, and records each ratio the
# cell prints.  The cell measures CPU time (getCPUTime), so what inflates it
# under load is cache/memory contention rather than scheduling wait -- which is
# also why the effect is depth-dependent and does not divide out of a ratio.
#
#   usage: sh test-paper/sitting/drift-distribution.sh [k]     (default 7)
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
K="${1:-7}"
OUT=test-paper/sitting/drift-distribution.txt

FROZEN=$(sed -n 's/^driftFrozenMeanRatio = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
BAND=$(sed -n 's/^driftRatioBand = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
[ -n "$FROZEN" ] && [ -n "$BAND" ] || { echo "ABORT: could not read the frozen ratio/band from test-breadth/Breadth.hs" >&2; exit 1; }

{
  echo "=== breadth drift-a: the ratio's DISTRIBUTION on this box ==="
  echo "generated $(date -u +%Y-%m-%dT%H:%MZ) at HEAD $(git rev-parse --short HEAD)"
  echo "frozen ratio $FROZEN, gate band +/-$BAND (both READ from the frozen"
  echo "file, never re-typed here -- the one-generator law)"
  echo "load at start: $(uptime | sed 's/.*load average/load average/')"
  echo "cores: $(nproc)"
  echo
} > "$OUT"

i=1
while [ "$i" -le "$K" ]; do
  r=$(cabal test breadth --test-show-details=streaming \
        --test-options="-p /drift-a/" 2>&1 \
      | sed -n 's/.*deep\/shallow mean ratio \([0-9.]*\) .*/\1/p' | tail -1)
  [ -n "$r" ] || r="(no ratio parsed)"
  printf 'run %-3s ratio %s   load %s\n' "$i" "$r" \
    "$(uptime | sed 's/.*load average: //')" >> "$OUT"
  i=$((i + 1))
done

python3 - "$OUT" "$FROZEN" "$BAND" <<'PY' >> "$OUT"
import sys, re, statistics as st
out, frozen, band = sys.argv[1], float(sys.argv[2]), float(sys.argv[3])
rs = [float(m.group(1)) for m in
      (re.match(r'run \S+\s+ratio ([0-9.]+)', l) for l in open(out)) if m]
print()
print("=== the distribution ===")
if len(rs) < 2:
    print("too few samples to summarise (%d)" % len(rs)); raise SystemExit
rs_s = sorted(rs)
med, mean = st.median(rs), st.fmean(rs)
print("n         = %d" % len(rs))
print("samples   = %s" % ", ".join("%.4f" % r for r in rs_s))
print("min/max   = %.4f / %.4f   (spread %.4f)" % (rs_s[0], rs_s[-1], rs_s[-1]-rs_s[0]))
print("median    = %.4f   (frozen %.4f, delta %+.4f)" % (med, frozen, med-frozen))
print("mean      = %.4f   (frozen %.4f, delta %+.4f)" % (mean, frozen, mean-frozen))
print("stdev     = %.4f" % st.stdev(rs))
print("band      = +/-%.4f" % band)
print()
inband = sum(1 for r in rs if abs(r-frozen) <= band)
print("per-run rows inside the band: %d of %d" % (inband, len(rs)))
print("MEDIAN inside the band     : %s" % ("YES" if abs(med-frozen) <= band else "NO"))
print("MEAN   inside the band     : %s" % ("YES" if abs(mean-frozen) <= band else "NO"))
print()
print("READ IT.  If the per-run rows scatter far outside the band while the")
print("median/mean sit inside it, the cell's UNDERLYING quantity is in band on")
print("this box and the SINGLE-SAMPLE GATE is the thing that cannot measure it.")
print("That is a measurement, not a belief -- and it is evidence for FL-P5's")
print("named residual (a cell that cannot be measured should decline to report,")
print("or the statistic should be one the box can actually resolve), NOT a")
print("licence to re-mint anything here.")
PY

echo "wrote $OUT"
tail -20 "$OUT"
