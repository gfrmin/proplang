# proplang — a minimal language in which a Bayesian agent is a program

proplang (Proposition Language) is a small language built on one claim: an
adaptive Bayesian decision-theoretic agent needs no adaptation machinery. If
hypotheses are programs and the prior is `2^(-|program|)` under a grammar,
then adaptation, bounded rationality, and inductive bias are posterior
dynamics rather than control flow — so the alphabet of the language *is* the
prior, and the design method is to corner the grammar by deleting every
terminal whose removal costs no capability.

This repository is a **closed, frozen artifact**: a Python reference
implementation and a Haskell port built under an adversarial, two-phase
frozen-oracle protocol — the acceptance tests were frozen, and a manifest
signed over them, before any implementation existed. The process, the
incidents, and the signed custody chain are all part of the record.

## Where to start

- **`brief.md`** — the research brief: the problem, the thesis, and the
  acceptance tests. **Start here.**
- **`design.md`** + **`interface.md`** — the language and its membrane, derived.
- **`typed-port-spec.md`** — the type-level spec the Haskell port was built to.
- **`WRITEUP.md`** — the face of the record; every claim is a pointer into the
  repo, and **§10 is the reader's end-to-end verification path.**

Orientation: `proplang.py` + `tests_acceptance.py` are the executable
specification; `src/` is the Haskell port; the eight `test*/` suites are its
frozen oracle; `CLAUDE.md` is the build protocol; the `*_PLAN.md` /
`*_REPORT.md` files are the process record.

## Verifying the record

Run `WRITEUP.md` §10 from a clean shell — it re-checks the manifest, the
seven build gates, the machine-checked §12 audit, and the signed tags. (The
Haskell gates need the pinned GHC on `PATH`; see `cabal.project.freeze`.)

Commits and freeze tags are SSH-signed by two keys, both under the identity
`guy@publicdatamarket.com`; `git` tells them apart by fingerprint:

| role | fingerprint |
|------|-------------|
| author | `SHA256:Sfh8OBG9CtkTF/y8rch4Cf6wv1rCpJ8ymEtKilUucsY` |
| builder | `SHA256:fPqrWnQhp0Ds+8MkMIDMUZzdRGviyfwt2BjsSaXAmgc` |

The builder is the Claude Code agent that wrote the port; the `membrane-freeze`
and `ladder-freeze` tags are builder-signed under an explicit author delegation
recorded verbatim in each tag message, and every other freeze tag is
author-signed. To verify:

```sh
git config gpg.ssh.allowedSignersFile allowed_signers
git tag -v writeup-freeze     # the close
git tag -v brief-freeze       # the brief, entered by the author's own hand
```

## License

The prose and the code carry different licenses:

- **Documentation — every `*.md` file — is under [CC BY-SA 4.0](LICENSE-docs.txt):**
  share and adapt with attribution, under the same license.
- **Everything else** — source code (`*.hs`, `*.py`), scripts, build and
  configuration files, `MANIFEST.sha256`, `audit/*.txt` — **is under [MIT](LICENSE).**

The `LICENSE*` files and `allowed_signers` are not themselves licensed works.
