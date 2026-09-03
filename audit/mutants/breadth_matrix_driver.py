#!/usr/bin/env python3
# OB-33 BREADTH kill-matrix driver.  ONE GENERATOR: each mutant spec
# produces BOTH the audit/mutants/*.patch file AND the applied mutation
# run against the frozen breadth suite (cabal, the heir close-out's v2
# per-suite method).  Run from the repo root.
#
# The pool is DERIVED from a declared operator x site grid (the sweep-
# universe law; hand-enumeration is the disease), targeting the four
# breadth mutant classes named in OB-33: pricing/Kraft, tie-break,
# null-cap, door-refusal.  Representatives instantiated below; the
# residual (grid cells not instantiated, and WHY) is PRINTED, never
# absorbed (the no-silent-caps law).
#
# SAFETY: src is mutated in place, run, then RESTORED from a saved copy
# in a finally.  The tree must be clean before and after.  --validate-only
# writes nothing and runs nothing.
import os, subprocess, sys, tempfile, re, shutil

REPO = os.getcwd()
ENUM = "src/PropLang/Enumerate.hs"

# ---- exact mutation-site strings (verified unique; multi-line where a
# ---- bare line is a dedup hazard: arityMass is byte-identical at the
# ---- arity route (227) and the breadth route (352), so the breadth one
# ---- is anchored by the declMass line that follows it) ---------------
ARITY_BREADTH_OLD = (
"    arityMass = CMass (1 / fromIntegral (max 1 (kAr - 1)))\n"
"    declMass = CMass (1 / fromIntegral (max 1 (length (breadthPairs br))))\n")
DECLMASS_OLD = "    declMass = CMass (1 / fromIntegral (max 1 (length (breadthPairs br))))\n"

DPAIR_BODY_OLD = (
"               (If (Gt (Get nm) (cAt tg kt))\n"
"                   (catB jHi (cAt eg a))\n"
"                   (catB jLo (cAt eg b))))\n")
DPAIR_BODY_SWAP = (
"               (If (Gt (Get nm) (cAt tg kt))\n"
"                   (catB jLo (cAt eg b))\n"
"                   (catB jHi (cAt eg a))))\n")

NULLS_GUARD_OLD = (
"    nulls\n"
"      | breadthNull br = nullConsts ++ nullGuards\n"
"      | otherwise = []\n")
NULLS_GUARD_OFF = (
"    nulls\n"
"      | breadthNull br && False = nullConsts ++ nullGuards\n"
"      | otherwise = []\n")

NULLCONST_BODY_OLD = "            (Code unitLatent obsSp (catB 0 (cAt eg k)))\n"
NULLCONST_BODY_MIS = "            (Code unitLatent obsSp (catB 1 (cAt eg k)))\n"

COMPOSE_OLD = "    ++ dpairs ++ nulls\n"
COMPOSE_NONE = "    ++ ([] `asTypeOf` (dpairs ++ nulls))\n"

OKPAIR_OLD = "    okPair (a, b) = a /= b && a >= 1 && a <= kAr - 1 && b >= 1 && b <= kAr - 1\n"
OKPAIR_NOEQ = "    okPair (a, b) = a >= 1 && a <= kAr - 1 && b >= 1 && b <= kAr - 1\n"

NULLK_OLD  = "  | all okPair ps && length ps == length (nub ps) && (not nl || kAr >= 3) =\n"
NULLK_OFF  = "  | all okPair ps && length ps == length (nub ps) =\n"

# (mid, slug, cls, op, provenance, file, old, new)
MUTANTS = [
 ("M90","declmass-unpriced","pricing/Kraft","drop-divisor",
  "the declared-pair mention mass loses its 1/|S| divisor (declMass=CMass 1): a pair declared among two weighs as much as declared alone. Targets b2b's halving law (mentionMass g = CMass(1/gridSize g), Enumerate.hs at HEAD, binding declMass).",
  ENUM, DECLMASS_OLD, "    declMass = CMass 1\n"),
 ("M91","aritymass-couples-pairs","pricing/Kraft","couple-independent",
  "the null face's arity mass COUPLES to the pair count (arityMass divided by |pairs| too): the null charge is no longer invariant to the pair declaration. Targets b2c's independence law (binding arityMass, breadth route).",
  ENUM, ARITY_BREADTH_OLD,
  "    arityMass = CMass (1 / fromIntegral (max 1 (kAr - 1) * max 1 (length (breadthPairs br))))\n"
  "    declMass = CMass (1 / fromIntegral (max 1 (length (breadthPairs br))))\n"),
 ("M92","declmass-zeroed","pricing/Kraft","zero-term",
  "the declared-pair family carries ZERO added mass (declMass=CMass 0): the declaration is priced out of existence though the sentences remain enumerated. Targets b2d positivity and b3a/b3b concentration (binding declMass).",
  ENUM, DECLMASS_OLD, "    declMass = CMass 0\n"),
 ("M93","dpair-branches-swapped","tie-break","flip-guard",
  "the declared-pair guard body SWAPS its high/low branches (catB jHi/jLo traded across the Gt): the minority tie breaks the wrong way. Targets b3a's minority argmax and b3b's MAP (dpairs body, binding dpairs).",
  ENUM, DPAIR_BODY_OLD, DPAIR_BODY_SWAP),
 ("M94","breadth-adds-no-family","null-cap","zero-term",
  "the breadth route appends NO family (dpairs++nulls suppressed via asTypeOf, both still referenced for -Werror): the heir declaration collapses to the arity route. The BROAD suppression - included to answer whether every library breadth row is reachable (a green-that-cannot-fail check), not as a unique killer (composition site, `++ dpairs ++ nulls`).",
  ENUM, COMPOSE_OLD, COMPOSE_NONE),
 ("M95","null-face-dropped","null-cap","drop-null",
  "the declared null face is silently dropped (the breadthNull guard forced False; nullConsts/nullGuards stay referenced in the dead guard). Targets b4a's extended-p0 cap break and the null-weight rows (nulls guard, binding nulls).",
  ENUM, NULLS_GUARD_OLD, NULLS_GUARD_OFF),
 ("M96","nullconst-mispredicts","null-cap","mis-predict",
  "the null-const face predicts atom 1 not the null atom 0 (catB 0 -> catB 1): a WEIGHT-invariant emission defect - the null face still exists and prices identically, but no longer raises p0. Targets b4a alone among the null rows (nullConsts body, binding nullConsts).",
  ENUM, NULLCONST_BODY_OLD, NULLCONST_BODY_MIS),
 ("M97","okpair-allows-equal","door-refusal","weaken-validator",
  "the door validator drops the a/=b guard (okPair admits a==b): the ONE validator accepts a degenerate pair the exact-duplication law forbids. Targets b4c's a==b refuse case (mkBreadth okPair, binding okPair).",
  ENUM, OKPAIR_OLD, OKPAIR_NOEQ),
 ("M98","null-k-guard-dropped","door-refusal","weaken-validator",
  "the door validator drops the null-at-K=2 guard (not nl || kAr >= 3): a null face is admitted at K=2 where no distinct positive pair exists. Targets b4c's null-at-K=2 refuse case (mkBreadth guard).",
  ENUM, NULLK_OLD, NULLK_OFF),
]

# rows to score (LIBRARY + in-process door + wire).  The FULL suite runs
# each time (no tasty -p filter: a pattern that silently matches nothing
# would read every mutant as killing nothing - a green-that-cannot-fail
# in the instrument itself, the triptych's harness-gate defect).  Kill is
# computed as a DIFF against the baseline fail-set, which also neutralises
# the drift-a absolute-ms false-red under build load.
# The rows that RUN under the exclusion filter below.  The three slow
# cells are excluded (none is targeted by any breadth mutant): the drift
# cell (deep timing walks to 280 ticks, ~10 min, false-reds under load),
# b6b (the ratio gate's matched-depth walks), b5c (the spawned host).
# Their exclusion is the run residual, PRINTED in the matrix header, not
# absorbed (the no-silent-caps law).  A malformed filter that ran zero
# rows is caught by the strict printed-count guard.
BROWS = ["b1a","b1b","b1c","b2a","b2b","b2c","b2d","b3a","b3b",
         "b4a","b4c","b4d","b5a","b6a","b6d","b7a","b8a"]
# tasty awk-pattern: run everything EXCEPT the three timing/spawn cells.
# Match the UNIQUE LEAF substrings (drift-a / b6b / b5c) - a bare /drift/
# matches EVERY path because the root group name carries "drift".  Uses
# $0!~ (field !~ regex); a plain !(...) or a bare /re/ selects nothing.
# SPACE-FREE so cabal's --test-options word-split keeps it one token.
EXCL = "$0!~/drift-a/&&$0!~/b6b/&&$0!~/b5c/"

def sh(cmd, **kw):
    return subprocess.run(cmd, shell=True, capture_output=True, text=True,
                          timeout=1200, **kw)

def run_breadth():
    """cabal test breadth (timing cells excluded), return
    (compiled?, set-of-failing-brows, raw, printed-count).  argv list +
    shell=False: no shell expands the $0 or && in the tasty pattern."""
    r = subprocess.run(
        ["cabal", "test", "breadth", "--test-show-details=streaming",
         "--test-options", f"-p {EXCL}"],
        capture_output=True, text=True, timeout=1200)
    out = r.stdout + r.stderr
    if re.search(r'^\s*(error:|.*annot |Compilation had errors)', out, re.M) \
       and not re.search(r'\bb1a\b', out):
        return (False, set(), out)
    fails = set()
    lines = out.splitlines()
    for b in BROWS:
        # PRIMARY signal: tasty prints one "Use -p '...<name>...' to rerun
        # this test only." line per FAILING test - robust even when the
        # test printf's a REPORT line between its name and the FAIL marker
        # (that interleaving broke the naive "<name>: FAIL" regex and
        # silently dropped every REPORT row - b2c/b3a/b4a - from the kill
        # set; the impossible "M94 kills b2b not its twin b2c" caught it).
        hint = any("rerun this test only" in ln and re.search(rf'\b{b}\b', ln)
                   for ln in lines)
        inline = bool(re.search(rf'\b{b}\b[^\n]*:\s*FAIL', out))
        if hint or inline:
            fails.add(b)
    # sanity: the run must have PRINTED at least the cheap library rows;
    # if not, the parse or the run is broken (never silently score zero)
    printed = sum(1 for b in BROWS if re.search(rf'\b{b}\b', out))
    return (True, fails, out, printed)

def readf(rel):
    with open(os.path.join(REPO, rel)) as fh: return fh.read()

# ---- phase A: validate every old-string is unique + old!=new ---------
bad = False
for mid,slug,cls,op,prov,rel,old,new in MUTANTS:
    s = readf(rel); n = s.count(old)
    if n != 1:
        print(f"VALIDATE FAIL {mid}: old count={n} in {rel} (want 1)"); bad = True
    if old == new:
        print(f"VALIDATE FAIL {mid}: old==new"); bad = True
if bad:
    print("VALIDATION FAILED - nothing written, nothing run"); sys.exit(1)
print(f"VALIDATE OK: all {len(MUTANTS)} mutation strings unique in the shipped src")
if len(sys.argv) > 1 and sys.argv[1] == "--validate-only":
    sys.exit(0)

# ---- phase B: write patch + run the matrix ---------------------------
matrix = {}
orig = {rel: readf(rel) for rel in {m[5] for m in MUTANTS}}
def restore():
    for rel, txt in orig.items():
        with open(os.path.join(REPO, rel), "w") as fh: fh.write(txt)

# (0) the BASELINE fail-set (clean tree) - kills are diffed against it
base = run_breadth()
if not base[0]:
    print("ABORT: baseline breadth did not COMPILE clean - nothing to diff against")
    print("\n".join(base[2].splitlines()[-20:])); sys.exit(1)
base_fail, base_raw, base_printed = base[1], base[2], base[3]
if base_printed < len(BROWS):
    missing = [b for b in BROWS if not re.search(rf'\b{b}\b', base_raw)]
    print(f"ABORT: baseline printed only {base_printed}/{len(BROWS)} rows "
          f"(missing {missing}) - filter/parse/run broken; NOT trusting a zero-kill read")
    sys.exit(1)
print(f"BASELINE: all {base_printed}/{len(BROWS)} target rows printed; "
      f"failing at baseline = {sorted(base_fail)} "
      f"(expected [] - the timing false-reds are filtered out)")

try:
    for mid,slug,cls,op,prov,rel,old,new in MUTANTS:
        # (1) the patch file.  Build the git-format headers OURSELVES and
        # borrow only the @@ hunk body from git diff --no-index - the
        # earlier bug prepended a b/ prefix onto an ABSOLUTE tempfile path
        # and .replace(tf,rel) ate the slash (b/ + /tmp/... -> bsrc/...),
        # which -p1 then read as a FILE RENAME that moved Enumerate.hs away.
        tmpd = tempfile.mkdtemp(); tf = os.path.join(tmpd, os.path.basename(rel))
        with open(tf, "w") as fh: fh.write(orig[rel].replace(old, new, 1))
        d = sh(f"git diff --no-index --unified=3 {rel} {tf}")
        shutil.rmtree(tmpd)
        at = d.stdout.find("@@")
        if at < 0:
            print(f"ABORT: {mid} produced no hunk"); sys.exit(1)
        hunks = d.stdout[at:]                       # @@ lines carry no path
        body = (f"diff --git a/{rel} b/{rel}\n"
                f"--- a/{rel}\n+++ b/{rel}\n" + hunks)
        patch = os.path.join(REPO, "audit", "mutants", f"{mid}-{slug}.patch")
        with open(patch, "w") as fh:
            fh.write(f"# MUTANT {mid}-{slug} [{cls} / {op}] - provenance: {prov} "
                     f"Cut against the committed r0a baseline (36ca59f); OB-33 breadth half.\n")
            fh.write(body)
        # the patch is a committed artifact - it MUST apply to HEAD's src
        # AND it must NOT be a rename (the bsrc/ bug moved the file); verify
        # the patch touches exactly the one file in place
        chk = sh(f"git apply --check -p1 {patch}")
        if chk.returncode != 0:
            print(f"ABORT: {mid} patch does not apply: {chk.stderr.strip()[:200]}")
            sys.exit(1)
        stat = sh(f"git apply --numstat -p1 {patch}").stdout.strip()
        if not stat.endswith(rel) or "\n" in stat:
            print(f"ABORT: {mid} patch does not target {rel} in place: {stat!r}")
            sys.exit(1)
        # (2) apply to the real src, run FULL breadth, restore, diff vs baseline
        with open(os.path.join(REPO, rel), "w") as fh:
            fh.write(orig[rel].replace(old, new, 1))
        res = run_breadth()
        restore()
        if not res[0]:
            matrix[mid] = ("COMPILE-RED",
                           [ln for ln in res[2].splitlines() if 'error' in ln.lower()][:2])
            print(f"{mid}: COMPILE-RED"); continue
        kills = sorted((res[1] - base_fail), key=BROWS.index)
        rescued = sorted((base_fail - res[1]))   # rows that went green under the mutant (should be none)
        part = "" if res[3] == len(BROWS) else f"  PARTIAL:printed {res[3]}/{len(BROWS)}"
        matrix[mid] = ("OK", kills, rescued, res[3])
        print(f"{mid}: kills {kills}" + (f"  (rescued {rescued}!)" if rescued else "") + part)
finally:
    restore()

# ---- phase C: emit the matrix ----------------------------------------
out = os.path.join(REPO, "test-breadth", "close-kill-matrix.txt")
with open(out, "w") as fh:
    fh.write(f"Baseline fail-set (clean tree, subtracted from every column): "
             f"{sorted(base_fail)}\n")
    fh.write("OB-33 BREADTH KILL MATRIX - the four breadth mutant classes\n")
    fh.write("(pricing/Kraft, tie-break, null-cap, door-refusal), run against\n")
    fh.write("the committed r0a baseline (36ca59f) breadth suite.\n")
    fh.write("Generated by the one-generator driver (scratchpad/breadth_matrix_driver.py).\n")
    fh.write("Scored rows: the library + in-process-door rows; b5c (spawned host)\n")
    fh.write("and the drift/means timing rows are baseline-only (no mutant targets\n")
    fh.write("process or timing) - the run residual, printed not absorbed.\n\n")
    hdr = "row".ljust(8) + "".join(m[0].rjust(6) for m in MUTANTS)
    fh.write(hdr + "\n")
    for b in BROWS:
        line = b.ljust(8)
        for mid,*_ in MUTANTS:
            rec = matrix[mid]
            if rec[0] != "OK": line += "  cmp"
            else: line += ("   X  " if b in rec[1] else "   .  ")
        fh.write(line + "\n")
    fh.write("\n(cmp = the mutant did not compile - a kill of the WHOLE column,\n")
    fh.write(" i.e. -Werror/type refuses the defect; recorded as such.)\n\n")
    for mid,slug,cls,op,prov,rel,old,new in MUTANTS:
        rec = matrix[mid]
        if rec[0] == "OK":
            extra = f"  RESCUED(!){rec[2]}" if rec[2] else ""
            fh.write(f"{mid}-{slug} [{cls}/{op}]: kills {rec[1]}{extra}\n")
        else:
            fh.write(f"{mid}-{slug} [{cls}/{op}]: COMPILE-RED {rec[1]}\n")
print("MATRIX written:", out)
