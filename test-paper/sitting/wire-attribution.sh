#!/usr/bin/env bash
# wire-attribution.sh -- IS THE drift-a SHIFT ATTRIBUTABLE TO THE WIRE INCREMENT?
#
# THE QUESTION.  The quiet-box run measured drift-a at mean 1.9474 (n=3, stdev
# 0.0087), 95% CI [1.9258, 1.9691], which EXCLUDES the frozen 1.9078 minted on
# THIS box two days earlier (selection-freeze-r1, 83e29ec, 2026-09-04).  Gate 5
# will therefore red, legitimately, and the close cannot proceed on either
# branch the runbook prepared.
#
# WHY IT MATTERS WHICH CAUSE IT IS.  test-breadth/Breadth.hs pre-declares the
# remedy for exactly one cause: "Should a future module addition reintroduce a
# cross-build divergence, the remedy is the PRE-DECLARED LICENSED RE-MINT at the
# implementation's close (XIII.5's pattern, stated in the freeze tag) -- never a
# silent widening."  So:
#   * if the shift IS the wire increment's, the licensed re-mint is ON POINT and
#     the close has a legitimate path;
#   * if it is NOT, re-minting would bake two days of box drift into the frozen
#     layer under a terminus signature -- the exact act the sitting forbade.
# The difference is a measurement, not an argument, so it is measured.
#
# THE DESIGN.  Exactly one commit touched src/ since the mint: 54e7884 (the wire
# repair; +33 Enumerate.hs, +17 Host.hs, +11 proplang.cabal).  Its parent is the
# control.  The two arms are INTERLEAVED (pre, head, pre, head, pre) so a trend
# in box state over the run cannot masquerade as the effect -- a straight A-then-B
# would confound them exactly as the quiet-vs-loaded contrast already does.
#
# POWER.  Breadth.hs's own comment records the post-climb cross-build classes at
# 0.0009 to 0.0057 -- so a fresh worktree build contributes at most ~0.006 of
# noise, against a 0.0396 shift.  The experiment can see the effect it is after.
#
# WHY IT MUTES THE WATCHDOG (added 2026-09-06).  Same reason and same shape as
# quiet-box.sh, whose header carries the measurement: the units it stops are
# the two the box's watchdog expects to be active, and this morning's stops
# paged a deliberate act as an outage.  This script's own run (07:24:49 ->
# 08:05:59) went unpaged only because it fell inside the 1h quiet window the
# 07:11 page had opened.  So before the first stop it mutes the watchdog's
# MAIL for 90m -- a control build plus five arm runs measured 41 min today, so
# that is a 2.2x margin, and the tool caps at 4h regardless -- BOUNDED and
# SELF-EXPIRING, mail only: the checks still run and are still logged.
# restore() clears it UNCONDITIONALLY, whether or not every unit came back: a
# unit that did not is a genuine outage and the next tick must page.
# --summarise stops nothing and mutes nothing.
#
# It touches no frozen file, re-mints nothing, and decides nothing: it produces
# the measurement the author's ruling needs.
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2

OUT=test-paper/sitting/wire-attribution.txt

# --summarise recomputes the reading from the rows ALREADY recorded, without
# re-measuring.  It exists for the same reason drift-distribution.sh's does:
# the first cut of THIS file's verdict printed a bare "NOT ATTRIBUTABLE", which
# a reader takes as "the wire increment had no effect" -- while the run's own
# arm difference was 4.5x the pooled within-arm scatter.  A verdict that
# understates its own data is the defect this repo exists to catch, and fixing
# the prose must not cost another twenty minutes of measurement.
if [ "${1:-}" = "--summarise" ]; then
  [ -f "$OUT" ] || { echo "ABORT: --summarise needs an existing $OUT" >&2; exit 1; }
  sed -i '/^=== the arms ===$/,$d' "$OUT"
  grep -q '^PRE ' "$OUT" || { echo "ABORT: no arm rows survive in $OUT" >&2; exit 1; }
  FROZEN=$(sed -n 's/^driftFrozenMeanRatio = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
  BAND=$(sed -n 's/^driftRatioBand = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
  ANALYSE=1
else
  ANALYSE=0
fi
WT=/home/g/git/worktrees/proplang/pre-wire
PRE=$(git rev-parse --short 54e7884^)

if [ "$ANALYSE" = 0 ]; then
mapfile -t UNITS < <(
  for p in $(pgrep -x julia 2>/dev/null); do
    sed -n 's#.*/\([a-z0-9-]*\.service\)$#\1#p' "/proc/$p/cgroup" 2>/dev/null
  done | sort -u)

restore() {
  echo; echo "== restoring co-residents =="
  for u in "${UNITS[@]:-}"; do
    [ -n "$u" ] || continue
    systemctl --user start "$u" 2>/dev/null
    echo "  $u: $(systemctl --user is-active "$u" 2>/dev/null)"
  done
  # Un-mute UNCONDITIONALLY -- restarted or not, and that is deliberate: a
  # unit that did not come back is a GENUINE outage and the next tick MUST
  # page; a mute that outlived a failed restore would hide exactly that.
  # Gated only the way the set is (something was stopped; the tool exists).
  if [ "${#UNITS[@]}" -gt 0 ] && command -v watchdog-silence >/dev/null 2>&1; then
    echo "  $(watchdog-silence off)"
  fi
}
trap restore EXIT INT TERM

# ---- mute the watchdog's MAIL before the first stop (see the header). -------
# The tool's own report is captured here and written into the transcript by
# the header block below, which truncates $OUT -- recorded, not assumed.
if [ "${#UNITS[@]}" -eq 0 ]; then
  WD_MUTE="nothing to stop, so nothing muted"
elif command -v watchdog-silence >/dev/null 2>&1; then
  WD_MUTE=$(watchdog-silence 90m 2>&1 | tr '\n' ' ')
else
  WD_MUTE="no watchdog-silence on PATH -- a tick during the run WILL page"
fi

for u in "${UNITS[@]:-}"; do
  [ -n "$u" ] || continue
  systemctl --user stop "$u" 2>/dev/null
  [ "$(systemctl --user is-active "$u" 2>/dev/null)" = active ] && \
    { echo "ABORT: $u would not stop" | tee -a "$OUT"; exit 1; }
done

{
  echo "=== drift-a: IS THE SHIFT THE WIRE INCREMENT'S? ==="
  echo "generated $(date -u +%Y-%m-%dT%H:%MZ)"
  echo "  arm HEAD = $(git rev-parse --short HEAD)   (wire repair present)"
  echo "  arm PRE  = $PRE   (54e7884^, the parent of the ONLY commit"
  echo "             touching src/ since the 1.9078 mint at 83e29ec)"
  echo "  frozen   = 1.9078, band +/-0.03  [read from test-breadth/Breadth.hs below]"
  echo "  co-residents stopped: ${UNITS[*]:-none}"
  echo "  watchdog: $WD_MUTE"
  echo "  load at start: $(uptime | sed 's/.*load average: //')"
  echo
} > "$OUT"

# the frozen numbers are READ, never typed (one-generator law)
FROZEN=$(sed -n 's/^driftFrozenMeanRatio = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
BAND=$(sed -n 's/^driftRatioBand = \([0-9.]*\).*/\1/p' test-breadth/Breadth.hs)
echo "  READ from the frozen file: frozen=$FROZEN band=$BAND" >> "$OUT"

git worktree add -f "$WT" "$PRE" >/dev/null 2>&1 || { echo "ABORT: worktree" | tee -a "$OUT"; exit 1; }
# the control MUST differ from HEAD only in src/ -- verify, never assume
if ! diff -q "$WT/test-breadth/Breadth.hs" test-breadth/Breadth.hs >/dev/null; then
  echo "ABORT: Breadth.hs DIFFERS between arms -- the comparison is not the one intended" | tee -a "$OUT"
  exit 1
fi
echo "  verified: test-breadth/Breadth.hs is byte-identical in both arms" >> "$OUT"
echo >> "$OUT"

run_arm() {  # $1 = dir, $2 = label
  ( cd "$1" && cabal test breadth --test-show-details=streaming \
      --test-options="-p /drift-a/" 2>&1 ) \
    | sed -n 's/.*deep\/shallow mean ratio \([0-9.]*\) .*/\1/p' | tail -1
}

echo "-- building the control arm --" >> "$OUT"
( cd "$WT" && cabal build breadth ) >/dev/null 2>&1 || { echo "ABORT: control build failed" | tee -a "$OUT"; exit 1; }
echo "   built" >> "$OUT"
echo >> "$OUT"

fi   # end of the measuring body

if [ "$ANALYSE" = 0 ]; then
for i in 1 2 3; do
  r=$(run_arm "$WT" PRE);  printf 'PRE   run %d  ratio %-9s load %s\n' "$i" "${r:-PARSE-FAIL}" "$(uptime | sed 's/.*load average: //')" >> "$OUT"
  [ "$i" -le 2 ] && { r=$(run_arm . HEAD); printf 'HEAD  run %d  ratio %-9s load %s\n' "$i" "${r:-PARSE-FAIL}" "$(uptime | sed 's/.*load average: //')" >> "$OUT"; }
done
git worktree remove --force "$WT" >/dev/null 2>&1
fi

python3 - "$OUT" "$FROZEN" "$BAND" <<'PY' >> "$OUT"
import sys, re, statistics as st
out, frozen, band = sys.argv[1], float(sys.argv[2]), float(sys.argv[3])
arms={}
for l in open(out):
    m=re.match(r'(PRE|HEAD)\s+run \d+\s+ratio ([0-9.]+)', l)
    if m: arms.setdefault(m.group(1),[]).append(float(m.group(2)))
print(); print("=== the arms ===")
for k in ("PRE","HEAD"):
    xs=arms.get(k,[])
    if not xs: print("%-5s no samples" % k); continue
    print("%-5s n=%d  mean %.4f  %s  (frozen %.4f, delta %+.4f)"
          % (k, len(xs), st.fmean(xs),
             ("stdev %.4f"%st.stdev(xs)) if len(xs)>1 else "stdev n/a",
             frozen, st.fmean(xs)-frozen))
print()
print("=== the reading ===")
if len(arms.get("PRE",[]))<2 or len(arms.get("HEAD",[]))<2:
    print("INCONCLUSIVE: too few samples in an arm."); raise SystemExit
pre, head = arms["PRE"], arms["HEAD"]
dm = st.fmean(head)-st.fmean(pre)
pooled = ((st.stdev(pre)**2+st.stdev(head)**2)/2)**0.5 if len(pre)>1 and len(head)>1 else float('nan')
print("arm difference HEAD-PRE = %+.4f   pooled within-arm stdev = %.4f" % (dm, pooled))
pre_in  = abs(st.fmean(pre)-frozen)  <= band
head_in = abs(st.fmean(head)-frozen) <= band
# THE DECOMPOSITION.  A bare band verdict hides the arm effect: "NOT
# ATTRIBUTABLE" reads as "the increment did nothing", which these numbers do
# not say.  Two quantities are separated and BOTH are reported, always.
sig = abs(dm)/pooled if pooled and pooled == pooled and pooled > 0 else float('nan')
print("DECOMPOSITION -- two separate quantities, both reported:")
print("  (A) the increment's own shift : %+.4f  (%.1fx the pooled within-arm"
      % (dm, sig))
print("      scatter of %.4f, so it is a REAL cross-build shift, not noise;" % pooled)
print("      it is %.0f%% of the %.4f band width)" % (100*abs(dm)/band, band))
print("  (B) the baseline gap, WITHOUT the increment : %+.4f"
      % (st.fmean(pre)-frozen))
print("      (the control arm against frozen -- what the increment cannot explain)")
print()
# The branches are INDEPENDENT and each is stated in full: no branch's prose
# presupposes that another one fired.
if pre_in and not head_in:
    print("* ATTRIBUTABLE TO THE WIRE INCREMENT.  The control arm sits INSIDE the")
    print("  band and HEAD sits OUTSIDE it, so the shift arrived with the only")
    print("  commit that touched src/.  This is precisely the case Breadth.hs")
    print("  pre-declares: a module addition reintroducing a cross-build")
    print("  divergence, whose remedy is the LICENSED RE-MINT at the")
    print("  implementation's close, stated in the freeze tag -- never a silent")
    print("  widening.  The author rules; the builder does not re-mint.")
elif not pre_in and not head_in:
    print("* NOT ATTRIBUTABLE -- but read (A) above before reading that as 'the")
    print("  increment did nothing'.  It did: %+.4f, well clear of the scatter." % dm)
    print("  The verdict is that (A) CANNOT EXPLAIN THE GAP, because BOTH arms")
    print("  sit outside the band: the frozen %.4f fails to describe this box" % frozen)
    print("  REGARDLESS of the increment, by %+.4f even without it." % (st.fmean(pre)-frozen))
    print("  The licensed-re-mint clause is therefore NOT on point: re-minting")
    print("  here would bake two days of box drift into the frozen layer under a")
    print("  terminus signature, which is the act the sitting forbade.  The")
    print("  clause licenses absorbing (A); a re-mint here would silently absorb")
    print("  (B) as well, and (B) is the larger term and the unexplained one.")
    print("  What moved between the 2026-09-04 mint and now is the open")
    print("  question, and these data do NOT answer it.")
elif pre_in and head_in:
    print("* NO EFFECT AND NO PROBLEM IN THIS RUN.  Both arms sit inside the band,")
    print("  which CONTRADICTS the quiet-box run's centre.  Something differs")
    print("  between that run and this one; neither is dismissed on the other's")
    print("  authority, and the disagreement itself is the finding.")
else:
    print("* INVERTED: the control sits OUTSIDE and HEAD INSIDE.  That is not a")
    print("  shape the wire hypothesis predicts; treat it as evidence the")
    print("  measurement is dominated by something neither arm controls.")
PY
echo "wrote $OUT"
