# Membrane Task 2 — author pack (freeze worksheet)

Everything the freeze needs, in application order. Frozen texts change
only here, only by your authority; under the two-key scheme the
mechanics may be delegated, and YOUR act is §8's signed tag. Oracle
commit under review: `a6682a7` (30 tests, 18 runtime-red / 12 green;
runner carried the stanza's exact ghc-options and the suite compiled
warning-clean on the first attempt).

## §0. Review guide (before any edit)

- The oracle's header records three SCOPE LIMITS for your ruling eye:
  evidence-name declaration/pricing deferred (M5's wording scopes the
  priced namespace to Get-mentionable names); a world's namespace is
  DECLARED for the episode (a dormant sensor is a declared name not yet
  speaking; mid-episode namespace growth is future scope — M1 is pinned
  ACROSS worlds in group 6); menu order = publication order then
  internal (tie-break precedence belongs to the world).
- Group 4 carries your required competitor BOTH ways (C0 control hands
  MAP to the changepoint); gen_fixtures.py is the pre-freeze sanity
  simulation and prints the margins (C 0.947 vs C0 0.635; A lands MAP
  0.433 from a 2.5e-4 prior after riding at 1.5e-15).
- Group 8's sixth row closes a hole this increment OPENED: frozen
  gate 4 scans five named files, so a new src module escapes the
  forbidden-token list; the row applies audit/forbidden.txt to
  Membrane.hs read-only.
- Group 1 reuses test/Anchors.hs constants and tolerances verbatim,
  plus one Double-== fold identity against a replica of the frozen
  accumulation.

## §1. typed-port-spec.md §3 — the normative pricing law (ruling M1)

Append AFTER the production-system blockquote (after "...requiring this
table's amendment at a freeze boundary."):

> **The namespace law (normative; membrane freeze).** Description
> length is namespace-relative: a name mention costs
> log2 |visible namespace| against the WORLD's declared namespace, at
> both priced sorts (the policy pricer's `Get` term and the model
> fragment's guard derivations), and 2^(-|program|) normalizes per
> world. Publishing a name therefore raises every name-mention's cost
> and re-weights the prior — a richer world makes every sentence about
> it more surprising. This is a semantic commitment, not an
> implementation detail. The namespace covers Get-mentionable feature
> names ONLY (ruling M5, load-bearing): the action vocabulary prices
> through slot grids and argmax, and keeping the two priced surfaces
> separate is what stops a fourth flow entering through the pricing
> door; no later increment may unify them. The frozen worlds are the
> singleton case (`featureNames = ["t"]`, 0 bits), whose prices this
> law leaves untouched.

## §2. typed-port-spec.md §5 — layer absence becomes the ablation
## standard (boundary-queue item 2)

In the honesty table, REPLACE the deletion-audit row's mechanism cell:

OLD (one cell, the row beginning `| deletion audit |`):
  [FROZEN] per-terminal capability loss, measured; ablation standard
  (Phase 2, decision 4): a CPP flag removes the constructor AND its
  evalx/bits/render cases, so all of src compiles ablated and only the
  frozen fixtures fail — deleting a terminal deletes its semantics,
  not just its name

NEW:
  [FROZEN] per-terminal capability loss, measured; ablation standard
  (Phase 2, decision 4; STRENGTHENED at the membrane freeze to the
  ExpFam E9 as-built): a CPP flag removes the constructor AND
  everything from its first consumer down — the dependent layer's
  EXISTENCE, not just its cases — so all of src compiles ablated,
  only the frozen fixtures fail, and claims like "nothing can assign
  likelihood, no agent can be built" are literal absences rather than
  behavioral promises

## §3. CLAUDE.md — red-runner flag fidelity (boundary-queue item 1)

In the increment protocol, item 2, append after "(type surface is
oracle-phase work; a compile-failing oracle proves nothing)":

  The oracle-phase runner must be bit-faithful to the future gate
  conditions — the stanza's exact compiler flags and warning set; a
  red run under weaker flags proves nothing (the ExpFam re-open,
  4c7b49d).

## §4. typed-port-spec.md — the T1 cross-reference relocation
## (boundary-queue item 3, yours)

The ExpFam pack addressed the T1 record to "§4" and it sits at the end
of §4. If you intended §3 or §5, move the blockquote now — one cut and
paste, your hands. If §4 was fine, strike this item.

## §5. CLAUDE.md — the two-key custody statement (boundary-queue
## item 4, YOUR CALL whether it lands)

Candidate text, as a new paragraph at the end of the increment
protocol section:

  Custody: the builder signs its own commits with the builder key and
  never touches the author's; a freeze becomes binding when the author
  countersigns the freeze commit with a signed tag from their own
  shell. The tag, not any commit signature, is the attestation of
  author review and approval.

## §6. proplang.cabal — the two frozen-build edits (drafted at Task 1
## in test-membrane/stanza.cabal.draft)

1. Library stanza, exposed-modules: insert `PropLang.Membrane` between
   `PropLang.Enumerate` and `PropLang.Host`.
2. Append the `test-suite membrane` stanza verbatim from the draft
   (import: warnings; main-is Membrane.hs; other-modules Streams,
   Anchors; hs-source-dirs test-membrane, test; deps base, proplang,
   tasty, tasty-hunit, tasty-quickcheck, QuickCheck, process).

## §7. Manifest re-sign (strict-superset extension)

    { find test test-hygiene test-expfam test-membrane audit -type f; \
      echo CLAUDE.md; echo proplang.py; echo tests_acceptance.py; \
      echo test_output.txt; echo typed-port-spec.md; echo interface.md; \
      echo design.md; echo proplang.cabal; echo cabal.project.freeze; } \
      | sort | xargs sha256sum > MANIFEST.sha256

Expected: 43 entries. Delta vs the 33-entry manifest: exactly the 10
test-membrane/ additions plus re-hashes of the pack-edited files
(CLAUDE.md, typed-port-spec.md, proplang.cabal), all other 30 entries
byte-unchanged. Verify the delta before committing.

## §8. The freeze sequence (two-key scheme, first tag)

1. You review §0's items in the oracle (`git show a6682a7 --stat`,
   then the files) and rule on §4/§5.
2. Edits §1–§3 (+§5 if ruled in) and §6 applied — your session or
   delegated mechanics, either is truthful now.
3. §7 re-sign; delta verified as stated.
4. Commit. If the builder commits, it signs with the builder key as
   always; no custody note is needed anymore — the commit signature
   only ever claims builder action.
5. YOUR ACT, own shell:

       git tag -s membrane-freeze -m "Membrane oracle frozen: reviewed groups 1-8, scope limits accepted, pack applied" <freeze-commit>
       git tag -v membrane-freeze   # verify it shows YOUR key

   From this tag the oracle is as frozen as test/; gates absorb the
   suite when the stanza lands (same commit), and implementation
   (Tasks 3–6) begins on your go.
