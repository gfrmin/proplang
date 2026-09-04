#!/usr/bin/env bash
# l5-demo.sh -- the two-sided install demo owed for L5 rev 2 (the harness-gate
# law: a gate arrives with its red demonstrated, and the triptych binds harness
# gates as much as oracle rows).  It extracts the EXACT installed L5 block from
# tools/prefreeze-lint.sh (between the # L5-BEGIN / # L5-END markers -- ONE
# generator, no separate copy) and runs it in throwaway git repos with crafted
# cabal + pack fixtures, asserting each RED fires and each GREEN passes.
# Read-only w.r.t. the real repo.  Usage: `bash l5-demo.sh` (or pass a block
# file as $1 to rehearse a candidate block before install).
#
# Amendment-1 seeded defects (the two live bugs found at the #24 sitting):
#   GREEN 2 -- import-only flags: the four flags DERIVED through import:.
#   RED 5   -- unresolvable import: FAIL, not a silent partial ("empty
#             derivation FAILS, never defaults" caught its own author's wrong
#             assumption about where the flags live -- the gate working).
set -u
cd "$(git rev-parse --show-toplevel)"
BLOCK="${1:-}"
if [ -z "$BLOCK" ]; then
  LINT="${LINT:-tools/prefreeze-lint.sh}"
  BLOCK=$(mktemp); trap 'rm -f "$BLOCK"' EXIT
  sed -n '/^# L5-BEGIN/,/^# L5-END/p' "$LINT" > "$BLOCK"
  [ -s "$BLOCK" ] || { echo "no # L5-BEGIN/# L5-END block in $LINT (install the L5 rev-2 patch first)" >&2; exit 2; }
fi
pass=0; failn=0
GIT_AUTHOR_NAME=d GIT_AUTHOR_EMAIL=d@d GIT_COMMITTER_NAME=d GIT_COMMITTER_EMAIL=d@d
export GIT_AUTHOR_NAME GIT_AUTHOR_EMAIL GIT_COMMITTER_NAME GIT_COMMITTER_EMAIL

run_case() {  # $1 name  $2 expect-regex  $3 cabal-fixture  $4 pack-body  $5 extra-file-in-pack-commit
  local name="$1" expect="$2" cabalf="$3" packf="$4" extra="$5"
  local d; d=$(mktemp -d)
  ( cd "$d" && git init -q
    $cabalf > proplang.cabal; git add proplang.cabal; git commit -q -m base
    $packf  > demo-author-pack.md; git add demo-author-pack.md
    if [ -n "$extra" ]; then mkdir -p "$(dirname "$extra")"; echo x > "$extra"; git add "$extra"; fi
    git commit -q -m pack   # the pack's OWN commit touches only the pack (+extra), never cabal
    LAST=""; fail=0; warns=0
    bad(){  LAST="FAIL: $*"; }
    ok(){   LAST="OK: $*"; }
    warn(){ LAST="WARN: $*"; }
    source "$BLOCK"
    if printf '%s' "$LAST" | grep -qE "$expect"; then
      printf '  [ pass ] %-9s -> %s\n' "$name" "$LAST"; exit 0
    else
      printf '  [ FAIL ] %-9s -> got: %s\n            want =~ /%s/\n' "$name" "$LAST" "$expect"; exit 1
    fi )
  if [ $? -eq 0 ]; then pass=$((pass+1)); else failn=$((failn+1)); fi
  rm -rf "$d"
}

cab_flags(){    printf 'common warnings\n    ghc-options: -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns\ntest-suite t\n    import: warnings\n    type: exitcode-stdio-1.0\n'; }
cab_flagless(){ printf 'common warnings\n    ghc-options: -O2\ntest-suite t\n    import: warnings\n    type: exitcode-stdio-1.0\n'; }
cab_unres(){    printf 'common warnings\n    ghc-options: -Wall\ntest-suite t\n    import: warnings, ghost-common\n    type: exitcode-stdio-1.0\n'; }

pk_19sentence(){    printf '# rulings pack\nVerification: this pack carries no SAT/overlay section (satisfiability n/a).\n'; }
pk_4flags(){        printf '# oracle pack\nSAT overlay compile: -Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns\n'; }
pk_missingWerror(){ printf 'SAT-SECTION: present\nSAT overlay: -Wall -Wincomplete-patterns -Wincomplete-uni-patterns\n'; }
pk_maybe(){         printf 'SAT-SECTION: maybe\n'; }
pk_ambiguous(){     printf 'SAT-SECTION: none\nthe fenced example we warn about (column 0):\nSAT-SECTION: none\n'; }
pk_present4(){      printf 'SAT-SECTION: present\n-Wall -Werror -Wincomplete-patterns -Wincomplete-uni-patterns\n'; }

echo "== L5 rev 2 two-sided demo (block extracted from ${LINT:-$1}) =="
#         name    expect(LAST)                                cabal        pack             extra-file
run_case  GREEN1  '^OK: L5 .*no SAT section.*cut no oracle'   cab_flags    pk_19sentence    test-x/freeze/close.sh
run_case  GREEN2  '^OK: L5 .*records every derived .*-Wall'   cab_flags    pk_4flags        test-x/Oracle.hs
run_case  RED1    '^FAIL: L5 .*lacks -Werror'                 cab_flags    pk_missingWerror ''
run_case  RED2    "^FAIL: L5 .*unreadable SAT-SECTION"        cab_flags    pk_maybe         ''
run_case  RED3    '^FAIL: L5 .*declared 2 times'              cab_flags    pk_ambiguous     ''
run_case  RED4    '^FAIL: L5 empty flag derivation'           cab_flagless pk_present4      ''
run_case  RED5    '^FAIL: L5 unresolvable cabal import'       cab_unres    pk_present4      ''
echo "== demo result: $pass passed, $failn failed =="
[ "$failn" -eq 0 ]
