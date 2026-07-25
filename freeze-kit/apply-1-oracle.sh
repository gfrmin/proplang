#!/usr/bin/env bash
# FREEZE STEP 1 (the oracle commit) — run from the repo root, review
# the diff, then commit with YOUR key. Idempotent-hostile: run ONCE on
# a clean tree.
set -euo pipefail
[ -f proplang.cabal ] && [ -f MANIFEST.sha256 ] || { echo "run from repo root"; exit 1; }
grep -q 'test-suite exact-acceptance' proplang.cabal && { echo "already applied"; exit 1; }

# 1) stanzas (the four exact suites; red by design until Phase 2)
cat freeze-kit/stanzas.cabal.add >> proplang.cabal

# 2) CLAUDE.md: the ruled clauses (delete the R17 block from
#    freeze-kit/claude-additions.md BEFORE running if not adopting R17)
cat freeze-kit/claude-additions.md >> CLAUDE.md

# 3) interface.md gauss bracket (the section-6 falsified-prose form)
python3 - <<'PY'
import io
p = 'interface.md'
s = io.open(p, encoding='utf-8').read()
if 'gauss' in s and 'FALSIFIED at the exact boundary' not in s:
    i = s.find('gauss')
    j = s.rfind('\n', 0, i) + 1
    k = s.find('\n', i)
    line = s[j:k]
    s = s[:j] + ('> [FALSIFIED at the exact boundary (exact-freeze-r0, '
                 '2026-07-25): the line below promised a gauss/expfam '
                 'family; the exact re-founding forecloses expfam '
                 '(transcendental weights) — the promise is withdrawn, '
                 'not deferred.]\n') + s[j:]
    io.open(p, 'w', encoding='utf-8').write(s)
    print('interface.md: gauss bracket applied near: ' + line.strip()[:60])
else:
    print('interface.md: no gauss line or already bracketed')
PY

# 4) WRITEUP.md supersession note (dated, at top)
python3 - <<'PY'
import io
p = 'WRITEUP.md'
s = io.open(p, encoding='utf-8').read()
mark = 'SUPERSEDED IN PART at the exact boundary'
if mark not in s:
    note = ('> [' + mark + ' (exact-freeze-r0, 2026-07-25): the Double '
            'anchors and tolerance conventions this document quotes are '
            'superseded by the exact oracle (EXACT_PLAN, KERNEL.md, '
            'exact-author-pack Parts VII-IX); its narrative remains the '
            'close-date record of the Double era.]\n\n')
    io.open(p, 'w', encoding='utf-8').write(note + s)
    print('WRITEUP.md: supersession note applied')
else:
    print('WRITEUP.md: already noted')
PY

# 5) MANIFEST: recompute every existing row (CLAUDE.md, cabal, WRITEUP,
#    interface changed), append the exact oracle's rows + KERNEL.md
sed 's/^[0-9a-f]\{64\}  //' MANIFEST.sha256 > /tmp/manifest-paths.$$
{ cat /tmp/manifest-paths.$$
  ls test-exact/*.hs test-exact/ablation/*.hs test-exact/ablation/run.sh \
     test-exact/gates-exact.sh test-lawful/*.hs
  echo KERNEL.md
} | awk '!seen[$0]++' > /tmp/manifest-paths2.$$
xargs -d '\n' sha256sum < /tmp/manifest-paths2.$$ > MANIFEST.sha256
rm -f /tmp/manifest-paths.$$ /tmp/manifest-paths2.$$

# 6) verification
echo "--- manifest self-check ---"
sha256sum -c MANIFEST.sha256 | grep -cv ': OK$' | grep -q '^0$' && echo "manifest OK ($(wc -l < MANIFEST.sha256) rows)"
echo "--- the 19 pre-existing suites must STILL be green (the new four are red by design) ---"
echo "run: cabal test properties hygiene membrane code optlaw sentence pricing actions stream unify outcome elim reflexive measure law refine arity said transport"
