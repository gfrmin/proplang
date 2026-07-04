#!/usr/bin/env python3
"""check_exports.py — gate 2 (FROZEN): the sealed reasoner's export list.

Checks that src/PropLang/Belief.hs exports EXACTLY the frozen list in
audit/belief-exports.txt (the amended typed-port-spec §2 list), and in
particular that the `Belief` CONSTRUCTOR is never exported: `Belief`
must appear bare (abstract type), never as `Belief(..)` or with an
explicit constructor list, and no `MkBelief`-style name may appear.

usage: check_exports.py src/PropLang/Belief.hs audit/belief-exports.txt
Exit 0 = export list matches; 1 = violation (printed).
"""

import re
import sys


def strip_comments(text):
    text = re.sub(r"\{-.*?-\}", " ", text, flags=re.S)
    text = re.sub(r"--[^\n]*", " ", text)
    return text


def export_list(src):
    """The items between `module PropLang.Belief (` and `) where`."""
    m = re.search(r"module\s+PropLang\.Belief\s*\((.*?)\)\s*where",
                  strip_comments(src), flags=re.S)
    if not m:
        return None
    body = m.group(1)
    # normalize "Name (..)" -> "Name(..)" then split on commas that are
    # not inside parentheses
    body = re.sub(r"\s*\(\s*\.\.\s*\)", "(..)", body)
    items, buf, depth = [], "", 0
    for ch in body:
        if ch == "(":
            depth += 1
            buf += ch
        elif ch == ")":
            depth -= 1
            buf += ch
        elif ch == "," and depth == 0:
            items.append(buf.strip())
            buf = ""
        else:
            buf += ch
    if buf.strip():
        items.append(buf.strip())
    return [re.sub(r"\s+", "", it) for it in items if it.strip()]


def main(argv):
    if len(argv) != 3:
        print(__doc__, file=sys.stderr)
        return 2
    with open(argv[1]) as fh:
        src = fh.read()
    with open(argv[2]) as fh:
        expected = [line.strip() for line in fh if line.strip()]

    actual = export_list(src)
    if actual is None:
        print("FAIL: no parenthesized export list found on module "
              "PropLang.Belief (an open module exports everything, "
              "including the Belief constructor)")
        return 1

    ok = True
    for item in actual:
        if re.match(r"^Belief\(", item) or "MkBelief" in item:
            print("FAIL: the Belief constructor is exported: %r" % item)
            ok = False

    if sorted(actual) != sorted(expected):
        missing = sorted(set(expected) - set(actual))
        extra = sorted(set(actual) - set(expected))
        if missing:
            print("FAIL: missing from export list: %s" % ", ".join(missing))
        if extra:
            print("FAIL: extra in export list: %s" % ", ".join(extra))
        ok = False

    if ok:
        print("CLEAN: PropLang.Belief exports exactly the frozen list "
              "(%d items), Belief abstract" % len(expected))
        return 0
    return 1


if __name__ == "__main__":
    sys.exit(main(sys.argv))
