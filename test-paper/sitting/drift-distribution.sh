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
# The transcript path is overridable so a DIFFERENT run condition (the
# quiet-box attempt) reuses THIS generator rather than growing a second copy
# of the parse and the summary -- the one-generator law.  Default unchanged.
OUT="${DRIFT_OUT:-test-paper/sitting/drift-distribution.txt}"
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
  # Keep EVERYTHING before the summary marker and drop only the old summary.
  # The first cut kept just the "=== breadth" header block and the run rows,
  # which SILENTLY DESTROYED any other prose in the transcript -- fatal for
  # drift-quiet.txt, whose quieting record and pre-stated scope live above the
  # run rows.  A re-summarise must be able to run on any transcript this
  # generator wrote without eating part of it.
  if grep -q '^=== the distribution ===$' "$OUT"; then
    sed '/^=== the distribution ===$/,$d' "$OUT" > "$OUT.new"
    mv "$OUT.new" "$OUT"
  fi
  grep -q '^run ' "$OUT" || { echo "ABORT: no run rows survive in $OUT" >&2; exit 1; }
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
# RESOLUTION and CENTRE are independent questions and are reported as two
# separate rows, ALWAYS BOTH, each stating its own finding in full.  An earlier
# cut printed the centre row opening with "AND", which presupposed the
# resolution row had fired; on the quiet run it had not, and the transcript
# carried a dangling conjunction under a bold claim -- prose presupposing a
# branch, the very defect this file's --summarise mode exists to make cheap
# to fix.
if unresolvable:
    print("* RESOLUTION: THE GATE CANNOT RESOLVE ITS OWN BAND ON THIS BOX.")
    print("  Run-to-run scatter is %.1fx the band's half-width and %d of %d runs"
          % (sd/band, inband, len(rs)))
    print("  fall inside it.  A single sample of this cell is not a measurement")
    print("  of the quantity the gate names, whatever that quantity's true value.")
else:
    print("* RESOLUTION: THE GATE *CAN* RESOLVE ITS BAND ON THIS BOX.  Run-to-run")
    print("  scatter is %.2fx the band's half-width (stdev %.4f against a %.4f"
          % (sd/band, sd, band))
    print("  half-width), so a red from this cell here is INFORMATIVE and cannot")
    print("  be set aside as noise.  Any claim that this cell is unresolvable is")
    print("  falsified by these data for the conditions recorded above.")
if centre_moved:
    print("* CENTRE: THE CENTRE HAS MOVED.  The 95%% CI [%.4f, %.4f] EXCLUDES the"
          % (lo, hi))
    print("  frozen %.4f, so on these data the frozen value does not describe" % frozen)
    print("  this box in the state recorded above.  That is a statement about")
    print("  agreement, NOT about cause: what moved -- the code, the box, or the")
    print("  build -- is a separate question these data do not answer.")
else:
    print("* CENTRE: THE CENTRE HAS *NOT* BEEN SHOWN TO MOVE.  The 95%% CI")
    print("  [%.4f, %.4f] contains the frozen %.4f, so these data do NOT" % (lo, hi, frozen))
    print("  establish a stale mint -- the mean sits %+.4f from frozen with SEM"
          % (mean-frozen))
    print("  %.4f.  NO REGRESSION IS INDICATED, AND NO CLEAN BILL OF HEALTH IS"
          % sem)
    print("  CLAIMED.")
print()
# The closing paragraph must not assert a condition the rows above may have
# just denied.  An earlier cut said flatly "a box that cannot resolve it" and
# "a cell that cannot be measured", and then printed a SEM INSIDE the band in
# the same sentence -- self-contradicting on any quiet run.
print("NO BRANCH ABOVE IS A LICENCE TO RE-MINT.  A re-mint is legitimate only")
print("under the pre-declared clause in test-breadth/Breadth.hs -- a module")
print("addition reintroducing a cross-build divergence, remedied at the")
print("implementation's close and STATED IN THE FREEZE TAG, never a silent")
print("widening -- and whether that clause applies is a question of CAUSE,")
print("which this probe does not measure.  Absent that, re-minting from a box")
print("in an unexamined state would bake that state into the frozen layer.")
print()
if unresolvable:
    print("This run is evidence for FL-P5's named residual: a cell that cannot")
    print("resolve its band should DECLINE TO REPORT rather than emit a number")
    print("the box cannot support.  Here the median of k runs has SEM %.4f"
          % sem)
    print("against a %.4f half-band -- %s." % (band, "still outside it" if sem > band else "inside it, so a k-run median IS a route worth ruling on"))
else:
    print("FL-P5's residual is NOT exercised by this run: the cell resolved its")
    print("band here (SEM %.4f against a %.4f half-band).  The residual stands"
          % (sem, band))
    print("on the OTHER run's evidence, not on this one's, and the honest")
    print("summary of the pair is that this cell's resolution is a function of")
    print("box state -- which is FL-P5's finding stated exactly, no wider.")
PY

echo "wrote $OUT"
tail -20 "$OUT"
