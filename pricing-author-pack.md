# Step-4 author pack, Part I — one pricing mechanism, two declared tables

Builder draft, oracle phase, PRE-ORACLE. Opened 2026-07-15 under the
author's standing pacing order at the step-3 close ("dont wait for my
word, unless you need my key"): the builder carries scoping, evidence
programs, and the oracle draft to the freeze gate; nothing binds
before the tag, and the register below still goes to the author with
its evidence executed — the order changes pacing, never custody.

Controlling texts: `AGENT_PLAN.md` §7 step 4; `GRAMMAR_HYGIENE_PLAN.md`
R4 (:168 — "two pricers coexist, as in the reference … arithmetic kept
term-for-term identical"; AGENT_PLAN: "R4 stands and is correct");
the P5 single-site alphabet-constant clause (prodTable, `Syntax.hs`);
the membrane's shared-pricing-worker precedent (`bits`/`bitsIn` — "one
arithmetic, one tree, no drift"); E-s1's fold doctrine ("the tree's
shape IS the float order", test-code:193-195); CLAUDE.md as canonized
through the step-3 boundary.

Repo state at opening: HEAD `9d348eb`, tags `sentence-freeze-r0`
(f0e1a7a) + `sentence-freeze-r1` (9d348eb) both verified; manifest
78/78; ten suites green; gates 1–7 PASS.

## 1. The step as written, and what step 3 already discharged

The step text: "R4's derivation-relative dl stands and is correct —
but its literals (`dlConst = 1 + mention eg`, …) are `bitsAt` **with a
hand-rolled table**. One mechanism, two **declared** production tables
(policy fragment, model fragment). **No hand-counted bits.**"

Decision 8 (the design-review gate) pre-empted half of it at step 3:
the model fragment's charges are ALREADY table-driven — the
`1 + mention eg` hand literals are gone; `enumerateSentencesGrid`
composes every charge from `lg (fragWidth sort)` reads of the declared
{MODEL 2, THETA 2, HEAD 2, RATE 1} table, and E-s1 measured the
declared-table folds bit-identical to the frozen literals. **What
remains is exactly the "one mechanism" half**: the model fragment's
charge arithmetic lives as ad-hoc `where`-bindings inside the
enumerator (dlConst/dlWalk/dlGuard) — a second pricing ARITHMETIC
beside `bitsAt`, even though both now read declared tables. And the
fragment table lacks the policy table's citizenship: `prodTable` is
P5's single site with a normative row in typed-port-spec §3; the
fragment table is a src definition with a pack citation.

## 2. THE STRUCTURAL FACT the design must respect (the scoping crux)

**The two fragments' frozen float trees have DIFFERENT association
shapes, so "one mechanism" cannot mean one shared float-fold.**
Written out (the parentheses are the frozen float order — E-s1 pinned
the model side bit-exactly at these shapes; the policy side's shapes
are frozen by every `bits` pin since the hygiene increment):

- policy (`bitsAt`, e.g. If): `((nodeB + go c) + go t) + go f` —
  node-cost first, children folded LEFT onto it;
- model guard (`dlGuard`): `wM + (((wT + ((wH + nsB) + (wT + lg|g|)))
  + (wT + lg|eg|)) + (wT + lg|eg|))` — the head subtree is
  RIGHT-leaning at `wT + (…)`, the outer family left-leaning, the
  model bit OUTSIDE the fold.

Float addition is not associative; a single generic fold reproduces
one family and perturbs the other. **The only float-preserving
unification is the doctrine the corpus already states: THE TREE IS THE
FLOAT ORDER — make the tree itself the declared data.** One mechanism
= one evaluator of declared charge trees; the association ships as
data, exactly as the tables do.

## 3. The design (builder's recommendation; register D-p1)

Land in `Syntax.hs` (the pricing home), beside `ProdTable`:

    -- the charge tree: a derivation's price as DECLARED DATA — the
    -- tree's shape IS the float order (the E-s1/test-code doctrine)
    data Charge s
      = CW s                     -- a sort-choice: lg (width s)
      | CBits Double             -- content (a grid/namespace mention)
      | CSum (Charge s) (Charge s)

    chargeBits :: (s -> Int) -> Charge s -> Double
    chargeBits w (CW s)     = logBase 2 (fromIntegral (w s))
    chargeBits _ (CBits d)  = d
    chargeBits w (CSum a b) = chargeBits w a + chargeBits w b

THE MECHANISM is `chargeBits`; the two declared tables are `prodTable`
(policy) and the fragment table (model), each a P5-style single site;
the two fragments' tree SHAPES are declared `Charge` values. The model
fragment's enumerator builds its three charge trees as `Charge
FragSort` data and prices them through the mechanism — bit-identity is
by construction (the trees mirror the shipped parentheses; E-p1
measures it anyway, ==, all three populations).

**The fork the author owns (D-p1): does `bitsAt` route through the
mechanism too?**

- **(A) bitsAt stays as-is**, documented as the policy instance whose
  fold shape is its own frozen association; the mechanism serves the
  model fragment. Cheapest; "one mechanism" is true for derivation
  charges and documented for policy prices.
- **(B, recommended) bitsAt BUILDS mirrored `Charge` trees and prices
  them through `chargeBits`** — the same worker, the same table read,
  the association mirrored to today's shape node for node. "One
  mechanism" becomes literally, enforceably true: grep finds ONE
  arithmetic that turns tables into bits. Cost: a rewrite of a
  heavily-pinned function — mitigated by the frozen pins themselves
  (every suite green = the extensional gate) plus E-p1's dedicated
  == measurement over a constructor-covering corpus BEFORE the oracle
  freezes. If E-p1 shows ANY policy-side residue, the recommendation
  falls back to (A) with the measurement recorded.

Alphabet delta: NONE. No production, sort, width, or price moves; the
step is structural. P5 is not touched (no constant changes value);
the fragment table's normative row joins typed-port-spec §3 at the
freeze (a delegated spec amendment, the step-3 STDNAME-note
precedent).

## 4. The under-determination register (with recommendations; evidence
   per item rides Part II)

| item | question | recommendation | evidence owed |
|---|---|---|---|
| D-p1 | the unification form: (A) model-side only vs (B) bitsAt through the mechanism too | **B**, falling back to A on any measured policy residue | E-p1 parts (a)+(b) |
| D-p2 | where the fragment table lives: stays `fragWidth :: FragSort -> Int` in Enumerate (the sentence fragment's home) vs moves beside `prodTable` in Syntax | **stays in Enumerate** — the table belongs to the fragment that declares it; the MECHANISM is what belongs to the pricing home; P5's discipline is single-SITE, not single-FILE | inspection (no floats) |
| D-p3 | does the Charge type admit the policy fragment's content charges (Var scope, name mentions, carrier mentions) as CBits leaves — i.e. is the mechanism total over both fragments' needs | yes by construction (every content term is a Double) | E-p1 part (b) covers every priced constructor |
| D-p4 | the normative-table amendment: typed-port-spec §3 gains the fragment table as a second normative table (the step-3 repair note's form) | do it at this freeze, delegated | prose only |

## 5. Obligation rows bound to this step

1. "No hand-counted bits" — CLOSED at step 3 (decision 8) for values;
   this step closes it for ARITHMETIC: after the freeze, exactly one
   definition in src turns declared widths into bits (grep-checkable).
2. Existing frozen pins are the extensional gate and stay green
   through the refactor: test-sentence g1 (dl multiset, family hexes,
   sum hex 40d27582567af28a, 1241/1529, M1), test-hygiene groupDlPins
   + groupBits, the three sayable price pins, test-expfam's lg 2 row.
3. The step's own oracle owes: the mechanism-identity pin (charges
   through `chargeBits` == the enumerator's `hypBits`, all three
   populations, ==), the policy-mirror pin under D-p1(B), the
   one-arithmetic audit row, and the declared-table citizenship rows.

---

# PART II — the evidence executed; the oracle drafted (2026-07-15)

## 6. E-p1, EXECUTED — the mechanism reproduces both fragments at ==

`ep1-transcript.txt`: **15,790 charges, ZERO bit-mismatches.**
Part A — the model fragment: mirrored `Charge` trees priced by
`chargeBits fragWidth` against `hypBits`, all three populations
(1169 + 1241 + 1529 = 3,939). Part B — the policy fragment (the
D-p1(B) arm): `bitsAt`'s fold shapes mirrored node for node, priced by
`chargeBits` reading `prodTable`, against `bits` over every emission
and move code (3,963), the same codes under `bitsIn` at 2- and 3-name
namespaces (7,878 more), and a hand corpus covering every priced
constructor (Push, CondE, Expect/FnInd, Expect/FnUtil, Argmax x2,
ExpFam, USay, Call, nested arithmetic) — all ==. **D-p1(B) is
float-clean; == is the gate; no tolerance is owed anywhere in this
step.**

## 7. The association fact, CORRECTED against Part I's own overclaim

Part I §2 argued a single shared fold "reproduces one family and
perturbs the other." Measured (`assoc-transcript.txt`): **at today's
leaf values the shipped guard tree and its full left-refold COINCIDE
bit-for-bit (6/6 rows)** — every sort width is exactly one bit and
lg 16 = 4, so the prefixes are dyadic and the re-association is
lossless BY COINCIDENCE. Meanwhile **204 of 1331 triples of
corpus-typical values DO move a bit under re-association** (the
doctrine example: 1 + lg 3 + lg 7, hexes ...f170 vs ...f171). The
design conclusion is unchanged but its ground is now honest: the
tree-as-data mechanism is chosen for ROBUSTNESS — a single-fold
mechanism would be correct today only by the dyadic accident of the
current widths, and a future declared table or grid would break it
silently at a distance. Register D-p1 presents both arms with this
measurement; the recommendation stays (B) with tree-as-data.

> **SUPERSEDED IN PART (the r1 review, 2026-07-15; appended, never
> rewritten — the S5 form):** this section's mechanism sentence
> ("every sort width is exactly one bit and lg 16 = 4, so the
> prefixes are dyadic") is wrong as stated — §13's root cause reveals
> the probe's tau leaf was lg 15, NON-dyadic, throughout the 6/6
> rows. The correct reading of the coincidence: ONE-BIT SORT WIDTHS
> plus a single content leaf re-associating losslessly at these
> magnitudes. The design conclusion (tree-as-data for robustness) is
> thereby STRENGTHENED — the coincidence is even narrower than this
> section claimed — but the mechanism a future reader should
> reconstruct from the doctrine row's provenance is the corrected
> one, not this section's.

## 8. The pin captures (R-D20-i)

The ns0 dl hexes are COPIES of the frozen `test-sentence/Sentence.hs:
250-253` pins. The namespace-variant guard hexes were captured from
the shipped enumerator at `9d348eb` (`capture-transcript.txt`) — the
populations whose counts and re-pricing differences the frozen g1/M1
rows pin: nsA t-guard `4031570068e7ef5a`, nsA s2-guard
`402aae00d1cfdeb4`, nsC t-guard `4031ecc08321eb30`, nsC z-guard
`402f05013ab7ce0e`, nsC la-guard `402dd9810643d661`. The assoc probe
independently reproduced the s2/z/la values from the tree arithmetic —
capture and construction agree.

## 9. The type surface and the oracle

Surface (stubs, additive; ten suites green + manifest 78/78 with them
in place): `Charge (..)` + `chargeBits` in Syntax.hs beside
`prodTable` (the pricing home); `constCharge`/`walkCharge`/
`guardCharge` + the `tauPoints` export in Enumerate.hs (exporting
beats copying — the step-1 note's own ground).

**test-pricing/ — 8 rows; red 7/8, every red a named step-4 stub
(`pricing-red.txt`); proto overlay SAT 8/8
(`rd21-proto-transcript.txt`, the preferred overlay form — the
prototype wears the real modules' names, Syntax + Enumerate copied
with the mechanism and trees filled in).** Groups: g1 the mechanism's
contract (CW reads the table, CBits is content, CSum at the tree's
shape, THE DOCTRINE ROW pinning the measured one-ulp association
example); g2 the declared trees == the frozen charges (the three ns0
hexes as copies; the five namespace-variant hexes as captures); g3 the
wiring pin (hypBits IS chargeBits of the declared tree, sentence by
sentence, all three populations, ==); g4 the tables as declared data
(prodTable's six fields — re-homing the P5 pin that retired with
gP5/govhost; the fragment table stays pinned where it was declared,
test-sentence g4). Green at birth: g4 only.

## 10. Freeze items (Phase B, on the author's key)

1. Oracle freeze: `test-pricing/{Pricing.hs, stanza.cabal.draft}` →
   manifest APPEND (rider-2 form); stanza merged into proplang.cabal.
2. Register rulings ride the tag (the pacing order): D-p1 (A vs B —
   recommendation B, the E-p1 measurement behind it), D-p2 (table
   homes — recommendation: stay), D-p3 (evidence: E-p1 part b), D-p4
   (typed-port-spec §3 gains the fragment table as a second normative
   table — delegated prose, the step-3 note form).
3. Implementation (post-tag): chargeBits + the three tree builders
   land as prototyped; enumerateSentencesGrid's where-block charges
   route through them; under D-p1(B) bitsAt builds mirrored trees and
   prices through chargeBits. All suites green (they are the
   extensional gate); gates 1-7; as-built report.

## 11. Reviewer verification block

```sh
export PATH="$HOME/.ghcup/bin:$PATH"; export LANG=C.UTF-8
# red: 7/8, every exception a named step-4 stub
cabal exec -- ghc -Wall -Werror -Wincomplete-patterns \
  -Wincomplete-uni-patterns -isrc -itest-pricing \
  -outputdir /tmp/s4red -o /tmp/s4red/pricing test-pricing/Pricing.hs
/tmp/s4red/pricing 2>&1 | grep -c "step-4 stub"    # 7
# SAT: 8/8 against the overlay prototype (ask the builder for the path)
# suites + custody unchanged by the surface stubs:
cabal test all           # ten suites green
sha256sum -c MANIFEST.sha256   # 78/78
```

**The step stops here for the author's key: the freeze tag over the
items of §10, with the D-p1/D-p2/D-p4 rulings (or amendments) recorded
in its message. Suggested, once reviewed:**
`git tag -s pricing-freeze-r0 <HEAD> -m "step-4 freeze: the pricing
oracle frozen; D-p1 ruled (B unless amended); implementation
authorized"`

---

# PART III — the rulings enacted; Phase B executed (2026-07-15)

The author's verification passed end to end (his reading: E-p1's
grand total reconciles, the red run's every exception is the named
Syntax.hs stub with g4 lawfully green as declared data, the overlay
SAT is 8/8, the doctrine pair is in the transcript as quoted). The
rulings, enacted under the recorded delegation:

## 12. The rulings

**D-p1 = B.** The pre-stated fallback condition (any measured policy
residue → A) came back empty: 0 in 11,851. B is what makes obligation
row 1 true rather than aspirational — after the freeze, grep finds
exactly one definition that turns widths into bits — and the
one-arithmetic audit row is the standing tripwire. **Two cautions
recorded for the increment report (the author's, verbatim keys):**
(1) under the §1b law, `chargeBits` is now the GENERAL pricing route,
so any future profiling-driven shortcut that skips tree-building is a
fast path and arrives with its pin; (2) §7's "future non-dyadic
width" is PRESENT TENSE on the policy side — `lg 6` and `lg 19` are
already in `prodTable` — so the dyadic accident that spares a single
shared fold is a fragment-side accident only; B-with-trees guards
against the shipped table, not a hypothetical.

**D-p2 = stays.** P5's discipline is single-SITE, not single-file;
the table belongs to the fragment that declares it, the mechanism to
the pricing home. **Forward ground recorded (the author's):** step 6
brings writable-name tables — tables will multiply, each at its
declaring site; the thing that must stay singular is the arithmetic,
which D-p1(B) just made grep-enforceable.

**D-p3 = yes** on E-p1(b3)'s coverage. **D-p4 = yes, delegated** —
executed below — and the same delegated edit carries the author's new
clause for the canonization queue: **A RETIREMENT LISTS ITS PINS.**
The g4 row quietly re-homed the P5 pin that vanished when govhost
retired — correct, but noticed one step late because the retirement
disposition never enumerated what the file carried. Step 3's lineage
headers did this for Acceptance's deliverables; the clause
generalises it to every retirement and closes the gP5 class.

## 13. The rider, EXECUTED — all five goldens now two-route

The author's catch: the two t-guard hexes (the ix-17 rows) were
CAPTURE-ONLY — the assoc probe's nearby "tau" rows are structurally
different values, so nothing independent touched them. **Root cause,
owned:** the assoc probe hand-wrote `lg 15` for the tau grid's
mention — the grid has SIXTEEN points (5,10,…,80) — a hand-enumeration
slip of exactly the class the sweep-universe line exists for; the
author decoded the difference as a grid-width leaf from the hexes
alone. (The probe's refold-coincidence conclusion survives: it
compares shapes at equal leaves, and 6/6 held even at the wrong —
non-dyadic! — leaf value, which if anything strengthens the
one-bit-widths reading.)

**The second route, run pre-tag** (`TwoRoute.hs`, appended to
`capture-transcript.txt`): E-p1 Part A's own declared-tree arithmetic
(guardT byte-copied; independent of the proto's `guardCharge`),
evaluated at ix 17's parameters:

    nsA t-guard: tree 4031570068e7ef5a  capture 4031570068e7ef5a  AGREE
    nsC t-guard: tree 4031ecc08321eb30  capture 4031ecc08321eb30  AGREE

All five namespace-variant goldens freeze two-route like their
siblings.

## 14. Phase B, executed (delegated freeze edits, R-D22)

Delegation recorded verbatim in the commit: *"With that appended,
sign `pricing-freeze-r0` over §10 with D-p1(B), D-p2(stays),
D-p3(yes), D-p4(delegated) in the message."* The edits:

1. **Stanza merged** into proplang.cabal (test-pricing, from the
   draft; eleven suites under gate 5's `cabal test all`).
2. **D-p4**: typed-port-spec §3 gains the sentence fragment's
   production table as a SECOND NORMATIVE TABLE (widths, charge-tree
   form, the mechanism, the D-p2 home note, the HEAD DEBT printed on
   its normative face).
3. **CLAUDE.md** gains the step-4 line: A RETIREMENT LISTS ITS PINS,
   with the gP5 incident as its provenance.
4. **Manifest**: rider-2 — 78 survivors re-hashed (CLAUDE.md,
   typed-port-spec.md, proplang.cabal rows moved) + the two
   test-pricing rows appended = **80 rows, `sha256sum -c` 80/80 OK.**

Gate state: ten suites green + pricing red 7/8 at named stubs (the
eleventh suite enters gate 5 red until implementation — the increment
discipline); gate-1 compile clean.

**The step stops for the key. Then implementation: `chargeBits` + the
three tree builders land as prototyped; `enumerateSentencesGrid`'s
where-block charges route through the declared trees; `bitsAt` builds
mirrored trees and prices through the mechanism (D-p1(B)); all eleven
suites green; as-built report.**

---

# PART IV — the implementation: as-built (2026-07-15)

Authorized by `pricing-freeze-r0` on `9296d24` (signature verified).
Builder commit: `8a6d00f`. **All eleven suites green on the FIRST full
run (pricing 8/8); gates 1–7 PASS; manifest 80/80.**

## 15. As-built answers

**The mechanism.** `chargeBits` landed in Syntax.hs as prototyped;
**grep now finds exactly ONE width-to-bits site in src** — its CW arm
(the verified obligation row: `logBase 2 (fromIntegral (w s))`,
Syntax.hs:467). The fragment's three charge trees landed in
Enumerate.hs as declared data with the frozen tree shapes;
`enumerateSentencesGrid`'s hand fold bindings (wOf/nsB/lgSize and the
dl* arithmetic) are DELETED — the enumerator's charges are
chargeBits-of-declared-tree reads and nothing else.

**D-p1(B), as built.** `bitsAt` builds mirrored `Charge PolSort`
trees — `PolSort` internal (the public single site stays `prodTable`,
whose fields its constructors name one-for-one), every CPP guard
preserved, the shapes node-for-node the E-p1-measured mirror — and
prices through the mechanism. Its old fold bindings
(nodeB/stdB/kerB/statsB/utilB/fnB/lgOf) died with the rewrite. The
§1b caution is printed on the worker's face: any future shortcut
that skips tree-building is a fast path and arrives with its pin.

**First-run green, again**: E-p1's 15,790/0 predicted bit-stability
through the mechanism, and the run cashed it — every frozen price
anchor (test-sentence g1's dl multiset and sum hex, test-hygiene's
groupDlPins and groupBits, the three sayable pins at lg 6, membrane's
namespace-pricing rows, expfam's lg 2 row) byte-stable; the pricing
suite's wiring pin held per-sentence over all three populations; the
doctrine row's one-ulp pair stands as the permanent tripwire.

**Debts standing, unchanged**: the HEAD width-2 DEBT (printed at the
declaration, on g4's row, and now on the spec's normative face); the
host-less window until step 5/7.

## 16. Reviewer verification block (Phase C)

```sh
export PATH="$HOME/.ghcup/bin:$PATH"; export LANG=C.UTF-8
git tag -v pricing-freeze-r0        # the freeze this executes
cabal test all                      # eleven suites, all green
sh audit/run-gates.sh               # 7/7 PASS
sha256sum -c MANIFEST.sha256        # 80/80
# the obligation row, literal:
grep -rn 'logBase 2 (fromIntegral (w s))' src/   # exactly one site
grep -rn 'wOf\|lgOf' src/                        # empty
```

**Step 4 is implemented and green under the signed freeze. The
increment closes on the author's review of this report — the two-tag
shape offers `pricing-freeze-r1` on the as-built.**

---

# PART V — the r1 review, enacted (2026-07-15)

The author's verification passed (the cabal transcript's eleven PASS
against the post-retirement census; the §16 greps in the right
obligation-row form). His three record items and two confirmations,
enacted before the tag:

## 17. The record items

1. **§13's root cause, given its full name (the author's, verbatim
   key):** the *capture* was right all along — it was the *checker*
   that lied; "a disagreement between routes is information, not
   embarrassment." The sharp part: the remedy already existed in the
   same increment's own surface — `tauPoints` was exported at the
   type-surface phase precisely on the ground that "exporting beats
   copying," and the assoc probe hand-wrote the leaf anyway. So the
   lesson is not just "hand-enumeration again"; it is that **probes
   are subject to the same discipline as sweeps: a probe reads
   declared data — exports, tables — and never re-declares a value it
   could import.** QUEUED for the canonization queue as the
   sweep-universe line's sibling, this incident its provenance; lands
   at the next CLAUDE.md touch (step 5's freeze).
2. **§7 superseded in part** — the S5-form supersession block now
   appended to §7 itself: the coincidence's mechanism is one-bit sort
   widths plus a single content leaf re-associating losslessly at
   these magnitudes, NOT "all prefixes dyadic" (one leaf was lg 15,
   non-dyadic, throughout). The design conclusion strengthens.
3. **First-run green is a measured pattern, recorded in the increment
   report in the author's terms:** step 3's overlay prototype went
   26/26 and Phase C landed green; E-p1's 15,790/0 predicted
   bit-stability through a rewrite of the two most heavily pinned
   arithmetic sites in the repo, and eleven suites cashed it first
   run. Two consecutive increments where the falsifier-before-freeze
   protocol converted implementation from adventure into
   transcription — that is the economic argument for the discipline,
   and the day someone proposes skipping the evidence program "just
   this once" is the day this paragraph earns its keep.

## 18. The confirmations, executed

1. **g2's provenance comment now names both routes for all five
   namespace-variant goldens** (delegated comment-only edit to the
   frozen oracle under the author's pre-tag instruction; the r1 tag
   covers it, R-D22): route 1 = the 9d348eb capture; route 2 = the
   declared-tree arithmetic independent of guardCharge (assoc-probe
   shipped-shape rows for s2/z/la; TwoRoute.hs for the two t-guards).
   Manifest re-hashed, 80/80.
2. **PolSort's derivation, for the typing-audit rule's letter
   (internal type, as-built record):** `PolSort` is the policy
   table's six fields as a sort enumeration — PolExpr/PolFn/PolStats/
   PolKer/PolStdName/PolUtil name `prodTable`'s fields one-for-one —
   so `CW` reads `prodTable` through the one mechanism exactly as
   `CW MODEL` reads the fragment table through `fragWidth`. It
   carries no width of its own (zero literals), is not exported (the
   public single site stays `prodTable`), and dies with `bitsAt` if
   the policy pricer ever leaves.

**With these, the increment closes on `pricing-freeze-r1`. The step
closed as the author put it: no capability, no alphabet motion, one
arithmetic where there were two, and the enforcement now lives in
grep rather than goodwill.**
