#!/usr/bin/env bash
# drift-distribution.sh -- measure the DISTRIBUTION of breadth's drift-a ratio
# on this box, instead of arguing about a single sample of it.
#
# WHY.  The paper-freeze-r0 sitting ruled (Q3) that a terminus tag must not rest
# on "we believe it was noise": no claim without a transcript.  The box cannot be
# quieted (a long-running job owns a core, by the author's decision), so the
# quiet-box branch is unavailable.  This probe takes the remaining honest route:
# characterise the statistic's DISTRIBUTION on this box, so whatever is said
# about the red rests on a transcript rather than on a belief about noise.  It
# does not presuppose which way that comes out -- the summary branches on the
# data, and two of the branches are unwelcome.
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
#          sh test-paper/sitting/drift-distribution.sh --summarise
#
# --summarise recomputes the summary from the run lines ALREADY in the
# transcript, without re-measuring.  It exists because the first cut of this
# script's interpretation PRESUPPOSED ITS OUTCOME ("if the median sits inside
# the band...") -- a green that cannot fail, wearing an interpretation's coat --
# and fixing that prose must not cost another 80 minutes of measurement.  The
# summary now BRANCHES on the data and states the reading the numbers support.
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2
K="${1:-7}"
OUT=test-paper/sitting/drift-distribution.txt
SUMMARISE_ONLY=0
[ "$K" = "--summarise" ] && { SUMMARISE_ONLY=1; K=0; }

FROZEN=$(sed -n 's/^driftFrozenMeanRatio = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
BAND=$(sed -n 's/^driftRatioBand = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
[ -n "$FROZEN" ] && [ -n "$BAND" ] || { echo "ABORT: could not read the frozen ratio/band from test-breadth/Breadth.hs" >&2; exit 1; }

if [ "$SUMMARISE_ONLY" = 0 ]; then
{
  echo "=== breadth drift-a: the ratio's DISTRIBUTION on this box ==="
  echo "generated $(date -u +%Y-%m-%dT%H:%MZ) at HEAD $(git rev-parse --short HEAD)"
  echo "frozen ratio $FROZEN, gate band +/-$BAND (both READ from the frozen"
  echo "file, never re-typed here -- the one-generator law)"
  echo "load at start: $(uptime | sed 's/.*load average/load average/')"
  echo "cores: $(nproc)"
  echo
} > "$OUT"
else
  [ -f "$OUT" ] || { echo "ABORT: --summarise needs an existing $OUT" >&2; exit 1; }
  # keep the header and the run rows; drop any previous summary
  sed -n '1,/^run /p' "$OUT" > "$OUT.hdr" 2>/dev/null || true
  grep '^run ' "$OUT" > "$OUT.runs"
  sed -n '/^=== breadth/,/^$/p' "$OUT" > "$OUT.new"
  cat "$OUT.runs" >> "$OUT.new"
  mv "$OUT.new" "$OUT"; rm -f "$OUT.hdr" "$OUT.runs"
fi

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
below = sum(1 for r in rs if r < frozen-band)
above = sum(1 for r in rs if r > frozen+band)
print("per-run rows inside the band: %d of %d  (%d below, %d above)"
      % (inband, len(rs), below, above))
print("MEDIAN inside the band     : %s" % ("YES" if abs(med-frozen) <= band else "NO"))
print("MEAN   inside the band     : %s" % ("YES" if abs(mean-frozen) <= band else "NO"))
sd = st.stdev(rs); sem = sd/len(rs)**0.5
# Student t, two-tailed 95%, small-n table (df = n-1); conservative fallback.
TCRIT = {1:12.706, 2:4.303, 3:3.182, 4:2.776, 5:2.571, 6:2.447, 7:2.365,
         8:2.306, 9:2.262, 10:2.228, 11:2.201, 12:2.179, 15:2.131, 20:2.086}
t = TCRIT.get(len(rs)-1, 2.0)
lo, hi = mean - t*sem, mean + t*sem
print("resolution   : stdev/half-band = %.1fx  (the gate asks for +/-%.4f)"
      % (sd/band, band))
print("95%% CI (mean): [%.4f, %.4f]   contains frozen %.4f? %s"
      % (lo, hi, frozen, "YES" if lo <= frozen <= hi else "NO"))
print()
# THE READING BRANCHES ON THE DATA.  An interpretation that presupposes its
# own outcome is a green that cannot fail wearing an interpretation's coat.
print("=== the reading these numbers support ===")
unresolvable = sd > band
centre_moved = not (lo <= frozen <= hi)
if unresolvable:
    print("* THE GATE CANNOT RESOLVE ITS OWN BAND ON THIS BOX.  Run-to-run")
    print("  scatter is %.1fx the band's half-width and %d of %d runs fall"
          % (sd/band, inband, len(rs)))
    print("  inside it.  A single sample of this cell is not a measurement of")
    print("  the quantity the gate names, whatever that quantity's true value.")
    print("  This is the decisive finding and it is independent of the next one.")
if centre_moved:
    print("* AND THE CENTRE HAS MOVED: the 95% CI excludes the frozen value, so")
    print("  the mint is stale for this box's current state, not merely noisy.")
else:
    print("* THE CENTRE HAS *NOT* BEEN SHOWN TO MOVE: the 95% CI contains the")
    print("  frozen value, so these data do NOT establish a stale mint -- the")
    print("  mean sits %+.4f from frozen with SEM %.4f." % (mean-frozen, sem))
    print("  So: NO REGRESSION IS INDICATED, AND NO CLEAN BILL OF HEALTH IS")
    print("  CLAIMED.  Both readings remain open; what is closed is that this")
    print("  gate cannot tell them apart here.")
print()
print("Neither branch is a licence to re-mint anything: a value re-minted from")
print("a box that cannot resolve it would bake today's contention into the")
print("frozen layer.  This is evidence for FL-P5's named residual -- a cell")
print("that cannot be measured should DECLINE TO REPORT, or should gate on a")
print("statistic the box can actually resolve (a median of k runs has SEM")
print("%.4f here, still %s the band)."
      % (sem, "outside" if sem > band else "within"))
PY

echo "wrote $OUT"
tail -20 "$OUT"
