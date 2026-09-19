#!/bin/bash
# #15 / #17 / #25 re-executed at HEAD before their close (OB-34: the record is re-read
# against HEAD before it is cited).  Transcript: reconfirm-15-17-25.txt.
set -euo pipefail
cd "$(dirname "$0")/.."
B=$(cabal list-bin proplang-host)
echo "=== re-confirmations, run $(date -u +%FT%TZ), proplang tree $(git rev-parse HEAD)"
echo "engine $B"
echo "engine sha256 $(sha256sum "$B" | cut -d' ' -f1)"
HELLO='{"membrane": 1, "world": {"namespace": ["x", "act"], "guards": [{"name": "x", "grid": [0.5]}], "menu": [{"name": "act", "grid": [1.0, 2.0]}], "codebooks": {"theta": [0.25, 0.75]}, "utility": {"form": "said@1", "said": ["*", ["get", "act"], ["var", 1]]}}}'
run() { echo; echo "-- $1"; shift; printf '%s\n' "$@" | "$B" | sed 's/^/   < /'; }
echo; echo "#17  observe_batch / observe_counts (the warm channel): still refused?"
run "hello, observe_batch, observe_counts" "$HELLO" \
  '{"observe_batch": [{"features": {"x": 1.0}, "evidence": 1}]}' \
  '{"observe_counts": {"features": {"x": 1.0}, "counts": [3, 5]}}'
echo; echo "#15  recorded act replayed AS A FEATURE (the engine-side ask): still refused?"
run "hello, evidence tick with act published as a feature + menu" "$HELLO" \
  '{"tick": {"features": {"x": 1.0, "act": 2.0}, "evidence": 1, "menu": ["act"]}}'
run "hello, evidence tick with act as a feature, no menu" "$HELLO" \
  '{"tick": {"features": {"x": 1.0, "act": 2.0}, "evidence": 1}}'
run "hello, evidence tick with no act and no menu" "$HELLO" \
  '{"tick": {"features": {"x": 1.0}, "evidence": 1}}'
run "hello, evidence tick with the menu (the one shape that folds)" "$HELLO" \
  '{"tick": {"features": {"x": 1.0}, "evidence": 1, "menu": ["act"]}}'
echo; echo "#25  bounded folded state: has the fold changed since F11 (r2-f11-state-bits.txt, @94fd4eb)?"
echo "   git diff --stat 94fd4eb HEAD -- src:"
git diff --stat 94fd4eb HEAD -- src | sed 's/^/   /'
echo "   lines of the observeS binding changed since 94fd4eb:"
git diff -U0 94fd4eb HEAD -- src/PropLang/Enumerate.hs \
  | grep -c -e '^[+-].*observeS' -e '^[+-].*tickPred' -e '^[+-].*HypLive' | sed 's/^/   /' || true
echo "   AgentS at HEAD (the state F11 measured):"
grep -n '^data AgentS' src/PropLang/Enumerate.hs | sed 's/^/   /'
