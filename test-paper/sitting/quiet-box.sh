#!/usr/bin/env bash
# quiet-box.sh -- the QUIET-BOX ATTEMPT for paper-freeze-r0's gate-5 fork.
#
# THE RULING IT SERVES.  The sitting held that "the box cannot be quieted" is a
# PREMISE TO BE DEMONSTRATED, NOT ASSERTED.  This script is that demonstration,
# either way it comes out.
#
# WHY IT IS NOT THE PREDECESSOR.  The first attempt's instrument WAS its defect:
# it took its target from `pgrep -x julia | head -1`, which returned an
# already-exited pid, sent SIGSTOP to nothing, and PRINTED "julia suspended
# (pid ..., state )" -- an empty state field it never read -- while the real
# co-residents ran on at 99%.  A harness gate that cannot fail is the mirror
# image of a red that cannot fire (OB-27).  So here EVERY quieting act is
# VERIFIED, and a target that does not reach the state it claims ABORTS the run
# before a single sample is taken.
#
# WHY IT STOPS UNITS AND NOT PIDS (changed 2026-09-06, for a measured reason).
# The v1 of this script SIGSTOPped the julia pids.  That was the ruling's own
# instrument, and it worked -- verified state T, trap-resumed cleanly -- but it
# bought nothing, and the measurement it protected then DIED MID-SAMPLE FOR LACK
# OF MEMORY.  The measurement: julia's two processes hold ~0% instantaneous CPU
# and 37 MB resident, so suspending them frees no CPU and no RAM; but their
# SYSTEMD UNITS' cgroups hold 533 MB (rssfeed-sidecar, whose tree is uv ->
# uvicorn -> julia) and 56 MB (answer-brain-daemon) on a box with under 800 MB
# free.  The binding constraint on this box is MEMORY, not cores.  Stopping the
# units reclaims that; SIGSTOP on a swapped-out child never could.  The author
# authorised stopping these services; nothing else on the box is touched.
#
# WHY IT MUTES THE WATCHDOG (added 2026-09-06).  The box runs an alert-only
# watchdog (ops/watchdog, every 10 min) that expects rssfeed-sidecar and
# answer-brain-daemon to be active and mails when they are not.  It cannot tell
# a stop a human chose from a stop nobody did, and this morning it did not: the
# stop this script made at 06:56 paged a deliberate, authorised act as an
# outage -- the 07:11 tick mailed "4 problems on thinkpad", both units and the
# two probes that front them -- and the 07:24 and 08:12 stops (its sibling
# wire-attribution.sh) escaped a second mail only because they happened to fall
# inside the watchdog's 1h quiet window and one-tick hold.  "Page genuine
# alerts, don't page false alarms."  So before the first stop the script sets
# `watchdog-silence` for a window DERIVED from K (below): BOUNDED and
# SELF-EXPIRING, capped at 4h by the tool, and it holds the MAIL ONLY -- the
# checks still run, the findings are still logged, the dead-man is still pinged
# clean.  restore() clears it UNCONDITIONALLY, whether or not every unit came
# back: a unit that did not is a genuine outage and the next tick must page.  A
# box without the tool runs unchanged, and the transcript says which case it
# was in.
#
# WHAT IT DOES NOT DO.  It does not re-mint, does not touch the frozen
# test-breadth/Breadth.hs, does not decide whether the close proceeds, and does
# not re-implement the sampler: measurement AND summary are delegated to
# drift-distribution.sh via DRIFT_OUT (the one-generator law).
set -u
cd "$(git rev-parse --show-toplevel)" || exit 2

OUT=test-paper/sitting/drift-quiet.txt
K="${1:-3}"

# ---- the targets: DERIVED from the running processes' own cgroups ----------
# Never hand-listed, and never `head -1`.  If no julia runs, the unit list is
# empty and the script says so rather than silently quieting nothing.
mapfile -t UNITS < <(
  for p in $(pgrep -x julia 2>/dev/null); do
    sed -n 's#.*/\([a-z0-9-]*\.service\)$#\1#p' "/proc/$p/cgroup" 2>/dev/null
  done | sort -u
)

mem_free_mb() { awk '/^MemAvailable:/{printf "%.0f", $2/1024}' /proc/meminfo; }

restore() {
  echo
  echo "== restoring the co-residents =="
  local u st
  for u in "${UNITS[@]:-}"; do
    [ -n "$u" ] || continue
    systemctl --user start "$u" 2>/dev/null
    st=$(systemctl --user is-active "$u" 2>/dev/null)
    if [ "$st" = active ]; then echo "  $u: RESTARTED (active)"
    else echo "  $u: *** NOT ACTIVE after start (state $st) -- INTERVENE ***"; fi
  done
  [ "${#UNITS[@]}" -eq 0 ] && echo "  (nothing was stopped)"
  # Un-mute UNCONDITIONALLY -- including when a unit did NOT come back, and
  # that is deliberate.  If the units are back there is nothing to page about;
  # if one is not, that is a GENUINE outage and the next tick MUST page.  A
  # mute that survived a failed restore would hide exactly the failure the
  # line above prints INTERVENE for.  Gated only the way the set is gated (this
  # run stopped something; the tool exists), so an empty run cannot clear a
  # mute it never set.
  if [ "${#UNITS[@]}" -gt 0 ] && command -v watchdog-silence >/dev/null 2>&1; then
    echo "  $(watchdog-silence off)"
  fi
}
trap restore EXIT INT TERM

{
  echo "=== drift-a: THE QUIET-BOX ATTEMPT ==="
  echo "generated $(date -u +%Y-%m-%dT%H:%MZ) at HEAD $(git rev-parse --short HEAD)"
  echo
  echo "-- the box BEFORE quieting --"
  echo "load: $(uptime | sed 's/.*load average: //')   MemAvailable: $(mem_free_mb) MB"
  free -h | sed 's/^/  /'
} > "$OUT"

# ---- stop the authorised units, and VERIFY.  Unverified is the whole defect. -
{
  echo
  echo "-- stopping the AUTHORISED co-resident units --"
  echo "   (units derived from the julia processes' own cgroups, not hand-listed)"
} >> "$OUT"

# ---- mute the watchdog's MAIL for the run, and RECORD which case we are in. -
# The window is DERIVED from K, not hand-picked.  A sample took ~8 min on this
# box quieted (3 in 24.7 min: journal 06:56:45 -> 07:21:28, 2026-09-06) and
# ~9.5 min loaded (8 in 76 min, 2026-09-05), so 15 min per sample is a
# 1.6-1.8x margin, plus 15 min flat for the stop, the residual check and the
# restore -- one and a half watchdog ticks.  K=3 gives 60m.  The tool caps at
# 4h and says so, and the transcript records what the tool REPORTED, not what
# this arithmetic asked for.  A run that outlives its window will page, which
# is right: a 1.6x overrun is worth a mail.
if [ "${#UNITS[@]}" -gt 0 ]; then
  if command -v watchdog-silence >/dev/null 2>&1; then
    { echo "  watchdog: mail muted for the run (bounded, self-expiring; cleared at restore):"
      watchdog-silence "$(( 15 * K + 15 ))m" 2>&1 | sed 's/^/    /'
    } >> "$OUT"
  else
    echo "  watchdog: no watchdog-silence on PATH -- a tick during the run WILL page" >> "$OUT"
  fi
fi

failed=0
for u in "${UNITS[@]:-}"; do
  [ -n "$u" ] || continue
  before=$(cat "/sys/fs/cgroup/user.slice/user-1000.slice/user@1000.service/app.slice/$u/memory.current" 2>/dev/null || echo 0)
  systemctl --user stop "$u" 2>/dev/null
  st=$(systemctl --user is-active "$u" 2>/dev/null)
  if [ "$st" != active ]; then
    printf '  %-28s VERIFIED STOPPED (state %s), reclaimed %s MB\n' \
      "$u" "$st" "$(( before / 1048576 ))" >> "$OUT"
  else
    printf '  %-28s *** STILL ACTIVE *** \n' "$u" >> "$OUT"
    failed=$((failed + 1))
  fi
done
[ "${#UNITS[@]}" -eq 0 ] && echo "  no julia process was running; no unit to stop" >> "$OUT"

if [ "$failed" -gt 0 ]; then
  { echo "ABORT: $failed unit(s) did not stop.  No samples taken."
    echo "       (The predecessor's defect was asserting exactly this unverified.)"
  } | tee -a "$OUT"
  exit 1
fi

# residual julia must be gone too -- the unit could stop while a child survives
sleep 2
if pgrep -x julia >/dev/null 2>&1; then
  { echo "ABORT: a julia process SURVIVED its unit's stop:"
    pgrep -alx julia | sed 's/^/         /'
  } | tee -a "$OUT"
  exit 1
fi
echo "  residual check: no julia process survives (verified, not assumed)" >> "$OUT"

{
  echo
  echo "-- the box AFTER quieting: what could NOT be quieted --"
  echo "load: $(uptime | sed 's/.*load average: //')   MemAvailable: $(mem_free_mb) MB"
  echo "  The builder may quiet ONLY what the author named.  Everything below is"
  echo "  the author's own working set -- browser, database, VM, media server,"
  echo "  and other Claude sessions -- and is left running.  So this quieting is"
  echo "  PARTIAL, and the residue is recorded rather than assumed:"
  ps -eo rss,pid,comm --sort=-rss | head -9 | sed 's/^/    /'
  echo
  echo "-- WHAT THIS RUN CAN AND CANNOT SETTLE (stated before the samples) --"
  echo "  CAN: whether the drift-a cell resolves +/-0.03 on the box AS IT NOW"
  echo "  STANDS.  That is the only question the gate asks, and the one the"
  echo "  close turns on."
  echo
  echo "  CANNOT: attribute any difference from the n=8 LOADED run.  TWO things"
  echo "  changed between them, not one.  The n=8 run records its own conditions"
  echo "  -- 'load average: 15.27, 14.48, 14.57' at start, per-run loads 12.33 to"
  echo "  20.31 on 8 cores -- and this box now sits near 1.5, which it reached BY"
  echo "  ITSELF when two unrelated 99% julia skin servers exited, BEFORE this"
  echo "  script ran.  The quieting done here is the SECOND change and, on the"
  echo "  measurement above, the smaller one.  A tight in-band result is"
  echo "  therefore NOT evidence that this script's quieting worked, and NOT"
  echo "  evidence against the contention diagnosis.  This design cannot"
  echo "  separate the two and does not claim to."
  echo
  echo "-- the samples (delegated to drift-distribution.sh; one generator) --"
} >> "$OUT"

DRIFT_OUT="$OUT.samples" sh test-paper/sitting/drift-distribution.sh "$K" > "$OUT.log" 2>&1
rc=$?
if [ ! -s "$OUT.samples" ]; then
  { echo "ABORT: the sampler produced no transcript (exit $rc).  Its output:"
    sed 's/^/         /' "$OUT.log"
  } >> "$OUT"
else
  cat "$OUT.samples" >> "$OUT"
fi
rm -f "$OUT.samples" "$OUT.log"
echo "wrote $OUT"
