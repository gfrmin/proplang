# ExpFam Task 2 — author amendment pack

Apply these inside the Task 2 freeze commit, alongside the stanza and
the re-signing. Frozen texts change only here, only by your hand.

## 1. typed-port-spec.md §3 — append after the pricing paragraph

> **The production system (normative; the priced object is this
> table, not the Haskell encoding).** Description lengths are charged
> per node against the node's generating sort:
>
> | sort | written alternatives | node cost |
> |---|---|---|
> | EXPR | C, Get, If, Gt, Var, Push, CondE, Expect, Argmax, Call | log2 10 |
> | FN | FnInd, FnUtil | 1 bit |
> | STATS | SId | 0 bits |
> | KER | ExpFam | 0 bits |
> | STDNAME | EU, IsEq, VAct, VThink, Bern | log2 5 |
>
> Hole sorts are declared by the grammar, not inferred from types:
> kernel-valued positions (e.g. `Push`'s second child) are KER holes;
> function-valued positions on `Expect` are FN holes; everything else
> is an EXPR hole. This is what keeps the code prefix-decodable
> (Kraft-tight per hole) while `ExpFam` pays 0 constructor bits — a
> 0-bit alternative alongside the ten EXPR codewords at the same hole
> would violate Kraft; at a declared KER hole it is the sole codeword.
> GADT terms outside this published fragment (the Haskell encoding
> admits, e.g., `Var` at a kernel-typed hole) remain per-node priced
> for totality of `bits`, but lie outside the generative prior: no
> enumerator generates them and 2^(-|program|) normalizes over the
> published fragment only. Growing any sort's alternative count is a
> reported alphabet change repricing that sort's every mention
> (written-alternatives convention, R2); adding a sort is a reported
> grammar change requiring this table's amendment at a freeze
> boundary.

## 2. typed-port-spec.md §3 — replace the ExpFam sketch line

Replace:
    ExpFam :: Carrier c -> Stats c -> Params env -> Expr env (K Double c)
with:
    ExpFam :: Space Double -> Carrier c -> Stats c -> Expr env (K Double c)
    -- E3 as ruled: no Params slot until its first consumer (a slot
    -- with no inhabitant forces the evaluator to invent semantics);
    -- the node declares its parameter space as an opaque payload
    -- (priced 0, recorded payload convention) because a kernel HAS a
    -- domain and declaring it is declared structure. The parameter
    -- itself arrives where the kernel is applied, as K Double c says.

## 3. typed-port-spec.md §4 (interface.md §4 cross-reference) — append one sentence

> The emission basis covers emissions fully and transitions partially:
> the reference `rw` (reflected walk, source-dependent support) is
> proven non-expfam (EXPFAM_PLAN T1) and remains a primitive
> combinator — the alphabet residue's one recorded non-expfam member.

## 4. CLAUDE.md porting order, step 6 — amend the sentence

Replace:
    `ExpFam` basis with `bern`/`rw` re-derived as stdlib names, the
    membrane (interface.md S1-S3), self-features, the full fidelity
    ladder with acceptance test F.
with:
    `ExpFam` basis with `bern` re-derived as a stdlib name and `rw`
    recorded as the alphabet's one non-expfam combinator (EXPFAM_PLAN
    T1; the original "bern/rw re-derived" promise was half-impossible
    without an anchor re-open and is amended here, at a freeze
    boundary, by the author), then the membrane (interface.md S1-S3),
    self-features, the full fidelity ladder with acceptance test F.

## 5. The re-signing command (E11 as exercised: interface.md and
##    design.md join the frozen set)

{ find test test-hygiene test-expfam audit -type f; echo CLAUDE.md;
  echo proplang.py; echo tests_acceptance.py; echo test_output.txt;
  echo typed-port-spec.md; echo interface.md; echo design.md;
  echo proplang.cabal; echo cabal.project.freeze; } | sort |
  xargs sha256sum > MANIFEST.sha256

Then: sha256sum -c MANIFEST.sha256; git add -A on the amended frozen
files + stanza + manifest; git commit -S — your shell, your key, your
hand (the standing rule's first exercise, as the plan says).
