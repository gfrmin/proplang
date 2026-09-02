#!/usr/bin/env bash
# Assemble the #24 sitting's conferral bundle: ONE self-contained markdown
# file (pack + every transcript + every draft, inlined), so it can be read and
# ruled on a phone with no repo access.
#
# Per the standing conferral pattern: the sitting goes to pixel-9a by taildrop
# as markdown, to be ruled with a second agent that did not build it.
set -euo pipefail
cd "$(dirname "$0")/.."
OUT=chooseeu-sitting/CONFERRAL.md

{
  cat chooseeu-author-pack.md
  echo
  echo '---'
  echo
  echo '# APPENDICES — the executed transcripts, inlined'
  echo
  echo '*Every transcript the pack cites, in full, so this file is'
  echo 'self-contained. All are re-runnable at HEAD 94fd4eb.*'
  # The universe DERIVES by glob, it is never hand-enumerated (the
  # sweep-universe law).  The first cut of this script carried a hand list and
  # had already gone stale by three transcripts before it was first run --
  # which is the disease the law exists to prevent, committed inside the kit
  # that reports on it.
  for f in $(ls chooseeu-sitting/*.txt | sort); do
    [ -f "$f" ] || continue
    echo; echo "## $(basename "$f")"; echo; echo '```'
    cat "$f"; echo '```'
  done
  echo
  echo '---'
  echo
  echo '# DRAFTS — nothing here is applied; all await the author'"'"'s key'
  for f in chooseeu-sitting/drafts/*; do
    [ -f "$f" ] || continue
    echo; echo "## $(basename "$f")"; echo
    case "$f" in
      *.md) cat "$f" ;;
      *)    echo '```'; cat "$f"; echo '```' ;;
    esac
  done
} > "$OUT"

echo "wrote $OUT  ($(wc -l < "$OUT") lines, $(du -h "$OUT" | cut -f1))"
