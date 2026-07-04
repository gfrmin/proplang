#!/usr/bin/env python3
"""strip_comments.py — token-level source audit for Haskell (FROZEN).

The Haskell mirror of the Python tests' tokenize-based grep: strips
comments and string literals, then scans the remaining CODE for
forbidden tokens. Two modes:

    --forbidden LISTFILE FILE...
        case-insensitive substring scan (gate 4: the semantic list —
        detect/forget/window/... — plus the unsafe escape hatches),
        mirroring tests_acceptance.grep_language_module's
        `bad in token.lower()` check.

    --word TOKEN FILE...
        case-sensitive whole-word scan (gate 3: the token `IO` must not
        appear in the pure modules).

Exit 0 = clean; exit 1 = hits (printed as file:line: token).

Recorded limitation (crude-but-frozen): the stripper is a small state
machine, not a full Haskell lexer. It handles `--` line comments,
nested `{- -}` block comments, string literals, and simple character
literals; it treats any `--` outside a literal as a comment opener (an
operator like `-->` in src/ would be mis-stripped — none exists, and
the gate errs toward false positives never false negatives on the
tokens it scans, since stripping only ever REMOVES text from scrutiny
that a stricter lexer would also remove, except for that operator
corner).
"""

import re
import sys

CHAR_LIT = re.compile(r"'(\\[^']{1,10}|[^'\\])'")


def strip_haskell(src):
    """Replace comments and string/char literals with spaces, preserving
    newlines (so line numbers survive)."""
    out = []
    i, n = 0, len(src)
    state = "code"
    depth = 0
    while i < n:
        c = src[i]
        nxt = src[i + 1] if i + 1 < n else ""
        if state == "code":
            if c == "{" and nxt == "-":
                state, depth = "block", 1
                out.append("  ")
                i += 2
            elif c == "-" and nxt == "-":
                state = "line"
                out.append("  ")
                i += 2
            elif c == '"':
                state = "string"
                out.append(" ")
                i += 1
            elif c == "'":
                m = CHAR_LIT.match(src, i)
                if m:
                    out.append(" " * (m.end() - i))
                    i = m.end()
                else:
                    out.append(c)
                    i += 1
            else:
                out.append(c)
                i += 1
        elif state == "line":
            if c == "\n":
                state = "code"
                out.append(c)
            else:
                out.append(" ")
            i += 1
        elif state == "block":
            if c == "{" and nxt == "-":
                depth += 1
                out.append("  ")
                i += 2
            elif c == "-" and nxt == "}":
                depth -= 1
                out.append("  ")
                i += 2
                if depth == 0:
                    state = "code"
            else:
                out.append(c if c == "\n" else " ")
                i += 1
        elif state == "string":
            if c == "\\" and nxt:
                out.append("  ")
                i += 2
            elif c == '"':
                state = "code"
                out.append(" ")
                i += 1
            else:
                out.append(c if c == "\n" else " ")
                i += 1
    return "".join(out)


def scan(paths, match_line):
    hits = []
    for path in paths:
        with open(path, "r") as fh:
            code = strip_haskell(fh.read())
        for lineno, line in enumerate(code.splitlines(), 1):
            for tok in match_line(line):
                hits.append((path, lineno, tok))
    return hits


def main(argv):
    if len(argv) >= 3 and argv[1] == "--forbidden":
        with open(argv[2]) as fh:
            tokens = [t.strip().lower() for t in fh if t.strip()]
        files = argv[3:]

        def matcher(line):
            low = line.lower()
            return [t for t in tokens if t in low]

    elif len(argv) >= 3 and argv[1] == "--word":
        pat = re.compile(r"\b%s\b" % re.escape(argv[2]))
        files = argv[3:]

        def matcher(line):
            return [argv[2]] if pat.search(line) else []

    else:
        print("usage: strip_comments.py --forbidden LISTFILE FILE... | "
              "--word TOKEN FILE...", file=sys.stderr)
        return 2

    if not files:
        print("no files given", file=sys.stderr)
        return 2

    hits = scan(files, matcher)
    for path, lineno, tok in hits:
        print("%s:%d: %s" % (path, lineno, tok))
    if hits:
        return 1
    print("CLEAN (%d file(s) scanned)" % len(files))
    return 0


if __name__ == "__main__":
    sys.exit(main(sys.argv))
