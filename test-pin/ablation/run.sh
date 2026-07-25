#!/usr/bin/env bash
# The exact boundary's ablation runner (two-sided entry gate, clause
# (b)). Usage: run.sh <src-path>   (the exact surface: Phase-D overlay
# for the SAT transcript; src/ once Phase 2 lands).
# Protocol: each fixture COMPILES against the surface (red-reachable)
# and FAILS under its -DDROP_<verb> (the ablation fires).
set -u
SRC="${1:?usage: run.sh <path-to-exact-surface>}"
FLAGS="-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns"
here="$(cd "$(dirname "$0")" && pwd)"
fail=0
for v in GET IF GT VAR SUB MUL C; do
  f="$here/Use$(echo "$v" | sed 's/.*/\L&/; s/^./\U&/').hs"
  case "$v" in
    GET) f="$here/UseGet.hs" ;;
    IF) f="$here/UseIf.hs" ;;
    GT) f="$here/UseGt.hs" ;;
    VAR) f="$here/UseVar.hs" ;;
    SUB) f="$here/UseSub.hs" ;;
    MUL) f="$here/UseMul.hs" ;;
    C) f="$here/UseC.hs" ;;
  esac
  if ghc $FLAGS --make -fforce-recomp -outputdir "/tmp/ablate-$$-a" -i"$SRC" "$f" >/dev/null 2>&1; then
    echo "PASS  Use$v compiles against the surface"
  else
    echo "FAIL  Use$v does not compile against the surface"; fail=1
  fi
  if ghc $FLAGS -DDROP_$v --make -fforce-recomp -outputdir "/tmp/ablate-$$-b" -i"$SRC" "$f" >/dev/null 2>&1; then
    echo "FAIL  Use$v STILL compiles under -DDROP_$v (ablation did not fire)"; fail=1
  else
    echo "PASS  Use$v fails under -DDROP_$v (ablation fires)"
  fi
done
rm -rf "/tmp/ablate-$$-a" "/tmp/ablate-$$-b"
exit $fail
