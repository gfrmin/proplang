{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}

-- | The step-1 increment oracle (AGENT_PLAN, boundary agent-boundary-r1).
--
-- WHAT THIS INCREMENT CLAIMS
--
--   "A likelihood is a CODE.  P(y | x) is proportional to 2^(-L(x,y)), where
--    L is an ordinary priced expression: the code length of outcome y in
--    context x.  The same principle as the prior."
--
-- By Kraft nothing is more foundational: every distribution IS a code and
-- every code IS a distribution, bijectively.  So this is a
-- REPARAMETERIZATION, not a restriction, and no generality is ever lost.
--
-- THE FALSIFIER (AGENT_PLAN step 1, stated before the fact):
--
--   "rw is the falsifier -- if a code cannot express the reflected walk,
--    STOP AND REPORT."
--
-- T1 (EXPFAM_PLAN.md:68-80) proved the reflected walk is NOT an exponential
-- family: an expfam's support is the base measure's, FIXED for the family,
-- and the walk has source-dependent hard zeros.  That proof is TRUE, and it
-- is IRRELEVANT to this engine, which never used an exponential family:
-- `walkOn` (Enumerate.hs:342-358) already computes 2^(-L) through
-- `fromBits`, assigning INFINITE description length off-support -- its own
-- comment says so.  Group 1 settles it by execution, not by argument.
--
-- R-D20-i (copy-not-reconstruct).  Every row compares against THE FROZEN
-- ARTIFACT ITSELF -- `walkOn`, `emit`, `ExpFam` -- reached by export, never
-- against a transcription.  There is no parallel derivation in this file, so
-- there is nothing for a pin to drift away from.
--
-- RUNTIME-RED AT THE FREEZE.  Code/Pos/ToR and the arithmetic are
-- type-surface only (Eval.hs stubs); every group fails until they are
-- implemented.  A satisfiability transcript for every asserted quantity is
-- in the author pack (R-D21): each was executed once against a throwaway
-- prototype, all bit-exact, prototypes discarded.
--
-- THE RULED BOUNDARY (pack sec 6.10, author 2026-07-13).  A code DENOTES
-- through Maybe -- R-C1 ruling (iii): `Code`'s codomain is
-- `Expr env (Maybe (K a b))`, validated eagerly at eval, refused EXACTLY on
-- a NaN or -inf entry or a massless (all-+inf) column.  Every L in
-- [0, +inf] denotes -- hard zeros and negative-by-ulp L included, because
-- the frozen ExpFam node itself emits negative L (pack sec 6.5).  Group 7
-- pins the ruling from both sides.
--
-- Test names are ASCII-only (the membrane's locale incident, 2026-07-05).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import Data.Word (Word64)
import GHC.Float (castDoubleToWord64)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief
  ( Bits (..), Evidence (..), Kernel, Space
  , cond, fromBits, is, kernel, mkSpace, point, prob, push )
import PropLang.Enumerate
  (Obs, emit, obsSpace, rhoPoints, thetaPoints, thetaSpace, walkOn)
import PropLang.Eval (Vals (..), evalx, mkEnv)
import PropLang.Syntax
  ( Expr (..), Grid, Idx (..), K
  , bits, carrierSpace, mkC, mkCarrier, mkGrid )

main :: IO ()
main = defaultMain $ testGroup "test-code (step 1: the likelihood is a code)"
  [ gWalk        -- THE FALSIFIER
  , gBern
  -- gExpFam RETIRED at the step-9 elimination freeze (D-f13; D-f10):
  -- the ExpFam grammar node is DELETED. This group PROVED ExpFam == Code
  -- bit-for-bit (the demonstrated-composition half of the two-sided
  -- primitivity gate); with that proof frozen and the node now deleted,
  -- the deletion it licensed HAS HAPPENED -- an ablation fixture's
  -- terminal state (DISCHARGED-PERMANENT). "expfam is a code" is now
  -- trivially true: only the code remains. gReaders (Pos vs ToR)
  -- survives and still carries the ToR-subsumes-SId regression.
  , gReaders     -- Pos vs ToR: the sec 5d defect, pinned as a regression
  , gArith
  , gPrices
  , gBoundary    -- the R-C1/R-C2 rulings, pinned from both sides (sec 6.10)
  ]

-- ---------------------------------------------------------------------
-- evaluation and bit-level comparison
--
-- These rows assert BIT-EXACTNESS, not closeness.  Enumerate.hs's own
-- comment claims walkOn is "the same float sequence the parity phase
-- shipped": if the code form drifts by ONE ULP, every downstream frozen
-- anchor moves and this increment is a RE-DERIVATION, not the rename it
-- claims to be.  A tolerance here would hide precisely what must be proved.
--
-- (Contrast test/Properties.hs's CL-4, where the two sides are DELIBERATELY
-- different routes and a tolerance is correct -- AGENT_PLAN sec 2b.  The
-- difference is not taste: there, the residue is noise; here, it is signal.)
-- ---------------------------------------------------------------------

eval0 :: Expr '[] t -> t
eval0 e = evalx e (mkEnv [] VNil)

-- evaluation at a declared tick: group 7's per-tick rows.  Features arrive
-- at eval time (Eval.hs `Get`), which is WHY denotation is a per-tick fact.
evalAt :: [(String, Double)] -> Expr '[] t -> t
evalAt fs e = evalx e (mkEnv fs VNil)

evalObs :: Expr '[Obs] t -> Obs -> t
evalObs e o = evalx e (mkEnv [] (o :. VNil))

-- R-C1 ruling (iii): a lawful code that FAILS to denote is an
-- implementation defect; these rows say so by name instead of pattern-crash
orRefused :: String -> Maybe k -> IO k
orRefused what =
  maybe (assertFailure (what ++ ": lawful code REFUSED to denote"
                          ++ " (R-C1 boundary defect)")) pure

bitsOf :: Double -> Word64
bitsOf = castDoubleToWord64

assertBitEq :: String -> Double -> Double -> Assertion
assertBitEq what expected actual =
  assertBool
    (what ++ ": expected " ++ show expected ++ " (bits " ++ show (bitsOf expected)
       ++ "), got " ++ show actual ++ " (bits " ++ show (bitsOf actual) ++ ")")
    (bitsOf expected == bitsOf actual)

-- every cell of two kernels over one space, compared bit for bit
assertKernelBitEq :: String -> Space Double -> [Double]
                  -> Kernel Double Double -> Kernel Double Double -> Assertion
assertKernelBitEq what sp pts kExpected kActual =
  sequence_
    [ assertBitEq (what ++ " [" ++ show x ++ " -> " ++ show y ++ "]")
        (prob (push (point sp x) kExpected) (is sp y))
        (prob (push (point sp x) kActual) (is sp y))
    | x <- pts, y <- pts ]

-- ---------------------------------------------------------------------
-- the declared grids this oracle's codes draw their constants from.
--
-- A code's constants are DATA WITH PRICES, like every other grid point
-- (CLAUDE.md: "Grid definitions are data with prices; anything else is a
-- baked constant and fails review").  Nothing here steers deliberation:
-- these are a world's declarations, and 0 / 1 / 2 / (n-1) are the shape the
-- reflected walk itself declares.
-- ---------------------------------------------------------------------

-- 0, 1, 2, and 8 = |thetaPoints| - 1, the last position on the theta grid
kGrid :: Grid
kGrid = mkGrid "k" (0 :| [1, 2, 8])

k0, k1, k2, kLast :: Expr env Double
k0    = cAt kGrid 0
k1    = cAt kGrid 1
k2    = cAt kGrid 2
kLast = cAt kGrid 3

cAt :: Grid -> Int -> Expr env Double
cAt g i = case mkC g i of
  Just e  -> e
  Nothing -> error ("test-code fixture bug: index " ++ show i ++ " off grid")

-- etaGrid + logit RETIRED with group 3 (the ExpFam subsumption group):
-- they fed codeExpFam/frozenExpFam only, both gone at the step-9
-- elimination (ExpFam deleted, D-f13).
rhoGrid, thetaGrid :: Grid
rhoGrid   = mkGrid "rho" rhoPoints
thetaGrid = mkGrid "theta" thetaPoints

-- equality in the grammar: what walkOn's `j == i` actually is. IsEq is
-- DELETED (step 9, D-f8 = (A)); the equality of two reals is the If/Gt
-- composition (test-elim g4: 0 disagreements over 1225 reachable pairs;
-- NaN, the sole disagreement, is not a lawful grid point, and positions
-- are never NaN). a == b iff neither strictly exceeds the other --
-- value-identical to the deleted 'Call IsEq', so codeWalk stays
-- bit-for-bit with walkOn. This is EXACTLY the composition the shipped
-- walkCode now emits (test-sentence t3MoveGolden pins its render).
eqE :: Expr env Double -> Expr env Double -> Expr env Bool
eqE a b = If (Gt a b) falseE (If (Gt b a) falseE trueE)

trueE, falseE :: Expr env Bool
trueE  = Gt k1 k0
falseE = Gt k0 k1

-- ---------------------------------------------------------------------
-- GROUP 1 -- THE FALSIFIER.  rw as a code, against the FROZEN walkOn.
--
-- walkOn (Enumerate.hs:342-358), for grid POSITIONS i (source), j (target):
--
--     mass = (if j == i then 1 - rho else 0)
--          + (if j == lo then rho / 2 else 0)
--          + (if j == hi then rho / 2 else 0)
--       where lo = if i > 0     then i - 1 else i + 1
--             hi = if i < n - 1 then i + 1 else i - 1
--     L    = negate (logBase 2 mass)
--
-- Said as a code, and NOTHING is added to say it:
--   * `Pos` supplies i and j.  The shipped grids are FP-NONUNIFORM
--     (0.2 + 0.1 = 0.30000000000000004 /= 0.3), so adjacency is NOT a
--     function of the VALUES.  This is what forces a POSITION reader.
--   * the arithmetic supplies mass and the log.
--   * `logBase 2 y` IS `Div (Log y) (Log 2)` -- GHC.Float's own definition --
--     so no logBase production is needed (group 5 pins it).
--   * the hard zero needs NO special case: mass = 0 gives L = +Infinity, and
--     `fromBits` turns that into weight exactly 0.  THAT IS THE WHOLE OF
--     T1's case, and a code answers it BY DEFINITION -- there is no base
--     measure to fight, because there is no base measure.
--
-- Haskell's (+) is left-associative, so the three-term sum is
-- Add (Add a b) c.  The TREE'S SHAPE IS THE FLOAT ORDER, and the float order
-- is what decides bit-exactness.
-- ---------------------------------------------------------------------

codeWalk :: Int -> Expr env (Maybe (K Double Double))
codeWalk rhoIx = Code thetaSpace thetaSpace body
  where
    rho = cAt rhoGrid rhoIx
    i, j :: Expr (Double ': Double ': env) Double
    i = Pos thetaSpace (Var (S Z))     -- the source, x
    j = Pos thetaSpace (Var Z)         -- the target, y
    lo = If (Gt i k0)    (Sub i k1) (Add i k1)   -- i > 0     ? i-1 : i+1
    hi = If (Gt kLast i) (Add i k1) (Sub i k1)   -- i < n - 1 ? i+1 : i-1
    mass = Add (Add (If (eqE j i)  (Sub k1 rho) k0)
                    (If (eqE j lo) (Div rho k2) k0))
               (If (eqE j hi) (Div rho k2) k0)
    body = Neg (Div (Log mass) (Log k2))

gWalk :: TestTree
gWalk = testGroup "group 1: THE FALSIFIER -- rw IS a code (vs the frozen walkOn)"
  [ testCase ("the reflected walk at rho index " ++ show ix
              ++ " reproduces walkOn BIT-FOR-BIT (81 cells)") $ do
      coded <- orRefused ("codeWalk at rho index " ++ show ix)
                 (eval0 (codeWalk ix))
      assertKernelBitEq ("walk rho=" ++ show (NE.toList rhoPoints !! ix))
        thetaSpace (NE.toList thetaPoints)
        (walkOn thetaSpace thetaPoints (NE.toList rhoPoints !! ix))
        coded
  | ix <- [0 .. length rhoPoints - 1] ]

-- ---------------------------------------------------------------------
-- GROUP 2 -- bern as a code, against the FROZEN `emit` kernel.
--
-- Eval.hs:179-182:
--     bernFast car th = fromBits (carrierSpace car)
--       (\y -> Bits (negate (logBase 2 (if y == 1 then th else 1 - th))))
--
-- The obs carrier is Int-valued, so `y == 1` is a test AT THE CARRIER TYPE:
-- eqE works on Obs directly, with no coercion.  (Group 3 is where a
-- coercion becomes unavoidable.)
-- ---------------------------------------------------------------------

gBern :: TestTree
gBern = testGroup "group 2: bern IS a code (vs the frozen emit kernel)"
  [ testCase ("bern at theta index " ++ show ix ++ " matches emit BIT-FOR-BIT") $ do
      let th     = NE.toList thetaPoints !! ix
          frozen = push (point thetaSpace th) emit
      codedK <- orRefused ("codeBernV at theta index " ++ show ix)
                  (eval0 (codeBernV ix))
      let coded = push (point thetaSpace th) codedK
      mapM_ (\o -> assertBitEq ("P(" ++ show o ++ ") at theta=" ++ show th)
                     (prob frozen (is obsSpace o))
                     (prob coded (is obsSpace o)))
            [0, 1 :: Obs]
  | ix <- [0 .. length thetaPoints - 1] ]

-- bern's code, reading the carrier through ToR (its VALUE) -- the obs
-- carrier is {0,1}, so "y == 1" is "ToR y > 0"
codeBernV :: Int -> Expr env (Maybe (K Double Obs))
codeBernV thIx = Code thetaSpace obsSpace body
  where
    th = cAt thetaGrid thIx
    y :: Expr (Obs ': Double ': env) Double
    y = ToR (Var Z)
    p = If (Gt y k0) th (Sub k1 th)
    body = Neg (Div (Log p) (Log k2))

-- ---------------------------------------------------------------------
-- GROUP 3 -- RETIRED at the step-9 elimination freeze (D-f13; D-f10).
--
-- This group proved "expfam IS a code": codeExpFam (a Code) reproduced
-- the frozen ExpFam grammar node BIT-FOR-BIT. That was the
-- demonstrated-composition half of the two-sided primitivity gate for
-- ExpFam. The proof is frozen in the record; the ExpFam node is now
-- DELETED (WIDE: ExpFam == Code, so the codeword was redundant). The
-- deletion this group licensed HAS HAPPENED -- an ablation fixture's
-- terminal state (DISCHARGED-PERMANENT, the UseBern precedent).
-- codeExpFam itself was just a Code and needed no primitive; it leaves
-- with its comparand. The ToR-forces-SId lesson survives next door in
-- gReaders (group 4), which pins Pos vs ToR directly.
-- ---------------------------------------------------------------------

-- ---------------------------------------------------------------------
-- GROUP 4 -- Pos vs ToR.  THE SEC 5d DEFECT, PINNED AS A REGRESSION.
--
-- AGENT_PLAN sec 5b (first draft) claimed:
--     "Pos ... the carrier -> Double reader -- which SUBSUMES Stats/SId"
-- and that is FALSE.  Pos reads a POSITION; ToR reads a VALUE.  They agree
-- on every carrier shipped today for one reason only:
--     obsCarrier = mkCarrier "obs" (0 :| [1])      -- value == index
-- a coincidence of the declarations, NOT A THEOREM -- as this document's own
-- OPEN 6 said, two sections after sec 5b leaned on it anyway.
--
-- This group makes the coincidence impossible to lean on again: it declares
-- a carrier where value and index DISAGREE and pins both readers.  A future
-- builder who collapses them FAILS HERE, BY CONSTRUCTION.
-- ---------------------------------------------------------------------

gReaders :: TestTree
gReaders = testGroup "group 4: Pos reads a POSITION, ToR reads a VALUE (sec 5d)"
  [ testCase "on a carrier where value /= index, Pos and ToR DISAGREE" $ do
      -- positions 0,1 carry VALUES 2,5.
      let oddSp = carrierSpace (mkCarrier "odd" (2 :| [5 :: Obs]))
          posOf = evalObs (Pos oddSp (Var Z))
          valOf = evalObs (ToR (Var Z))
      assertBitEq "Pos of the point valued 2" 0 (posOf 2)
      assertBitEq "Pos of the point valued 5" 1 (posOf 5)
      assertBitEq "ToR of the point valued 2" 2 (valOf 2)
      assertBitEq "ToR of the point valued 5" 5 (valOf 5)
      assertBool "Pos /= ToR here -- sec 5b's claim is REFUTED by construction"
        (posOf 5 /= valOf 5)
  , testCase "on obsCarrier (0,1) they COINCIDE -- the coincidence, pinned" $
      mapM_ (\o -> assertBitEq ("obs " ++ show o)
                     (evalObs (Pos obsSpace (Var Z)) o)
                     (evalObs (ToR (Var Z)) o))
            [0, 1 :: Obs]
  ]

-- ---------------------------------------------------------------------
-- GROUP 5 -- the arithmetic evaluates as IEEE-754, not as the reals.
-- ---------------------------------------------------------------------

gArith :: TestTree
gArith = testGroup "group 5: the arithmetic is IEEE-754, not the reals"
  [ testCase "Add / Sub / Mul / Div" $ do
      assertBitEq "1 + 2" (1 + 2)   (eval0 (Add k1 k2))
      assertBitEq "1 - 2" (1 - 2)   (eval0 (Sub k1 k2))
      assertBitEq "2 * 8" (2 * 8)   (eval0 (Mul k2 kLast))
      assertBitEq "1 / 2" (1 / 2)   (eval0 (Div k1 k2))
  , testCase "Log / Exp" $ do
      assertBitEq "log 2" (log 2)   (eval0 (Log k2))
      assertBitEq "exp 1" (exp 1)   (eval0 (Exp k1))
  , testCase "logBase 2 y IS Div (Log y) (Log 2) -- so the alphabet needs no logBase" $
      -- GHC.Float: logBase x y = log y / log x.  Measured bit-exact 9/9 at
      -- the oracle phase.  This row is why `logBase` is NOT a production.
      assertBitEq "logBase 2 8" (logBase 2 8) (eval0 (Div (Log kLast) (Log k2)))
  , testCase "Neg is NOT Sub 0 -- the sign of zero (OPEN 5)" $ do
      -- 0 - 0 is +0.0; negate 0 is -0.0.  This is the ONLY reason Neg is its
      -- own production rather than sugar for Sub k0.  If the author rules the
      -- sign of zero irrelevant, THIS is the row that must be retired -- and
      -- retiring it is then a RECORDED alphabet change, not a quiet edit.
      assertBitEq "negate 0.0 is -0.0" (negate 0.0) (eval0 (Neg k0))
      assertBool "0 - 0 is +0.0 and differs from negate 0.0 IN BITS"
        (bitsOf (eval0 (Sub k0 k0)) /= bitsOf (eval0 (Neg k0)))
  ]

-- ---------------------------------------------------------------------
-- GROUP 6 -- the alphabet's prices, at the step-9 END STATE.
--
-- P5's single-site alphabet constant (Syntax.hs): a count change edits
-- exactly `prodTable` PLUS the enumerated frozen pins of the changed
-- sort -- "the P5 forward ruling's MANDATORY BOUNDARY ITEM".  This group
-- is that enumeration, RE-PRICED at the step-9 elimination boundary.
--
--   prodExpr 19 -> 20   (Expect + SawE + ElimJ landed; IsEq deleted --
--                        ruling A, EXPR settles at 20 not 21)
--   prodKer   2 ->  1   (ExpFam DELETED, subsumed by Code -- Code alone)
--
-- This IS AGENT_PLAN sec 5b's end state now reached (EXPR 20 / KER 1;
-- the WIDE ruling). Two waves ride this boundary: the EXPR reprice
-- (every node-choice leaf lg 19 -> lg 20, +0.074 bits/node) and THE KER
-- REPRICING (§18: the kernel sort-choice leaf lg 2 -> lg 1 = 0, a -1-bit
-- move -- WIDE's named consequence). The "Code joins ExpFam" row is
-- RETIRED (D-f10): its claim is now false, Code is the sole KER member.
-- ---------------------------------------------------------------------

lg :: Int -> Double
lg n = logBase 2 (fromIntegral n)

unBits :: Bits -> Double
unBits (Bits b) = b

gPrices :: TestTree
gPrices = testGroup "group 6: the prices at the step-9 end state (EXPR 20 / KER 1)"
  [ testCase "nodeB is lg 20 (EXPR at 20 after the step-9 elimination)" $
      assertBitEq "Get" (lg 20) (unBits (bits (Get "t" :: Expr '[] Double)))
  , testCase "a binary arithmetic node costs nodeB + its two subterms" $
      assertBitEq "Add(Get,Get)" (3 * lg 20)
        (unBits (bits (Add (Get "t") (Get "x") :: Expr '[] Double)))
  , testCase "a unary arithmetic node costs nodeB + its subterm" $
      assertBitEq "Neg(Get)" (2 * lg 20)
        (unBits (bits (Neg (Get "t") :: Expr '[] Double)))
  , testCase "Pos costs nodeB + its subterm (the Space payload prices 0)" $
      assertBitEq "Pos(Get)" (2 * lg 20)
        (unBits (bits (Pos thetaSpace (Get "t") :: Expr '[] Double)))
  , testCase "ToR costs nodeB + its subterm" $
      assertBitEq "ToR(Get)" (2 * lg 20)
        (unBits (bits (ToR (Get "t") :: Expr '[] Double)))
  , testCase "kerB is lg 1 = 0 (Code alone in KER; the §18 -1-bit reprice)" $
      -- RETIRE-AND-REPLACE (D-f10): the old "Code joins ExpFam" row is
      -- gone (ExpFam deleted). Code now prices as kerB + its body, with
      -- kerB = lg (prodKer) = lg 1 = 0 (the KER repricing). The body is
      -- in Code's OWN two-binder scope (y and x), so Var Z pays nodeB +
      -- lg 2 (|scope| = 2). Code(Var Z) = lg 1 + (lg 20 + lg 2).
      assertBitEq "Code(Var Z)" (lg 1 + (lg 20 + lg 2))
        (unBits (bits (Code thetaSpace thetaSpace (Var Z)
                         :: Expr '[] (Maybe (K Double Double)))))
  ]

-- ---------------------------------------------------------------------
-- GROUP 7 -- THE RULED BOUNDARY (pack sec 6.10, author 2026-07-13).
--
-- R-C1 (iii): a code denotes through Maybe, refused EXACTLY on a NaN or
-- -inf entry or a massless (all-+inf) column.  The three refusal witnesses
-- are the E1 sweep's CHEAPEST members of each hazard class, copied
-- byte-wise from the pack's table (code-task2-author-pack.md sec 6.1,
-- R-D20-i) -- they sit INSIDE the frozen fragment's own price range, which
-- is why the guard is load-bearing and not a pathology tax.
--
-- The lawful side is pinned too, because a boundary has two sides: the
-- ulp-cliff sentence (L = -2.2e-16 where mathematics says 0; sec 6.5 --
-- the frozen ExpFam node itself emits negative L, so strict L >= 0 is
-- INCOMPATIBLE with the shipped engine), and the walkOn-shaped hard zero
-- (L = +inf in one cell of a column with mass; T1's whole case).
--
-- PER-TICK DENOTATION (ruled, sec 6.10 item 4): features arrive at eval
-- time, so denotation is a fact ABOUT A TICK, not about a sentence -- the
-- E1 sweep measured 202 of 490 hazardous bodies changing class between
-- t=0 and t=5.  A hypothesis whose code fails to denote at an observed
-- tick asserted the impossible there and is refuted PERMANENTLY (an
-- evidence-shaped zero; dormancy is for absent NAMES, never for
-- likelihood failure).  The row here pins the eval-level half; the
-- permanence lands with step 3's integration and is BOUND by this ruling.
--
-- R-C2 (ruled: Neg STAYS): the lawful pair from sec 6.6 -- two validated
-- codes differing ONLY in Neg vs Sub-with-dormancy-zero, bit-different
-- rows, posterior [1, 0] after one observation.  Neg is measured content,
-- not sugar; this row is why prodExpr is 19 and not 18.
-- ---------------------------------------------------------------------

gBoundary :: TestTree
gBoundary = testGroup "group 7: the ruled boundary (R-C1 iii + NaN/-inf-only, R-C2)"
  [ testCase "a -inf entry REFUSES to denote: Log (Get t) at t=0 (2 nodes, 9.50 bits)" $
      case evalAt [("t", 0)] (Code thetaSpace thetaSpace (Log (Get "t"))
                                :: Expr '[] (Maybe (K Double Double))) of
        Nothing -> pure ()
        Just _  -> assertFailure
          "a -inf column denoted: the R-C1 (iii) boundary is not enforced"
  , testCase "a massless (all-+inf) column REFUSES: Neg (Log (Get t)) at t=0" $
      -- the hazard that previously ERRORED inside fromBits ("belief has no
      -- mass") -- under the ruling it is a typed Nothing, and
      -- Belief.hs:101-103 stays a THEOREM
      case evalAt [("t", 0)] (Code thetaSpace thetaSpace (Neg (Log (Get "t")))
                                :: Expr '[] (Maybe (K Double Double))) of
        Nothing -> pure ()
        Just _  -> assertFailure
          "a massless column denoted: the R-C1 (iii) boundary is not enforced"
  , testCase "a NaN entry REFUSES: Log (Log theta0) (the silent class, sec 6.2)" $
      case eval0 (Code thetaSpace thetaSpace (Log (Log (cAt thetaGrid 0)))
                    :: Expr '[] (Maybe (K Double Double))) of
        Nothing -> pure ()
        Just _  -> assertFailure
          "a NaN column denoted: the R-C1 (iii) boundary is not enforced"
  , testCase "the ulp-cliff DENOTES: L = -2.2e-16 is lawful (NaN/-inf-only, sec 6.5)" $ do
      -- exp (log x) / x > 1 at 4 of 17 grid points; a strict L >= 0
      -- boundary refuses this sentence and 4 of 9 frozen ExpFam rows with it
      _ <- orRefused "the ulp-cliff sentence"
             (eval0 (Code thetaSpace thetaSpace
                       (Neg (Log (Div (Exp (Log (cAt thetaGrid 0)))
                                      (cAt thetaGrid 0))))
                       :: Expr '[] (Maybe (K Double Double))))
      pure ()
  , testCase "a hard zero DENOTES and is preserved EXACTLY (the walkOn shape)" $ do
      -- one cell at L = +inf inside a column that has mass: T1's whole
      -- case, answered by definition -- weight exactly 0, no base measure
      k <- orRefused "the hard-zero code"
             (eval0 (Code thetaSpace obsSpace
                       (If (Gt (ToR (Var Z)) (cAt thetaGrid 0))
                           (Div (cAt rhoGrid 0) (Get "z"))
                           (cAt rhoGrid 0))
                       :: Expr '[] (Maybe (K Double Obs))))
      let row = push (point thetaSpace (NE.toList thetaPoints !! 4)) k
      assertBitEq "P(y=1) is EXACTLY zero" 0 (prob row (is obsSpace 1))
      assertBitEq "P(y=0) carries ALL the mass" 1 (prob row (is obsSpace 0))
  , testCase "denotation is a PER-TICK fact: one sentence, Nothing at t=0, Just at t=5" $ do
      let c = Code thetaSpace thetaSpace (Log (Get "t"))
                :: Expr '[] (Maybe (K Double Double))
      case evalAt [("t", 0)] c of
        Just _  -> assertFailure "denoted at t=0 -- it asserted the impossible there"
        Nothing -> pure ()
      case evalAt [("t", 5)] c of
        Nothing -> assertFailure
          "refused at t=5 -- log 5 bits per cell is a lawful constant column"
        Just _  -> pure ()
  , testCase "Neg is CONTENT: the lawful pair posterior is EXACTLY [1, 0] (sec 6.6)" $ do
      -- copied from the executed E5: c = theta grid point 4 (0.5); the only
      -- sayable +0.0 left argument today is Get-dormancy (no frozen grid
      -- declares 0), so the Sub side is Sub (Get "z") y
      kN <- orRefused "the Neg-version"
              (eval0 (Code thetaSpace obsSpace
                        (Exp (Div (cAt thetaGrid 4) (Neg (ToR (Var Z)))))
                        :: Expr '[] (Maybe (K Double Obs))))
      kS <- orRefused "the Sub-version"
              (eval0 (Code thetaSpace obsSpace
                        (Exp (Div (cAt thetaGrid 4)
                                  (Sub (Get "z") (ToR (Var Z)))))
                        :: Expr '[] (Maybe (K Double Obs))))
      let x0   = NE.toList thetaPoints !! 4
          rowN = push (point thetaSpace x0) kN
          rowS = push (point thetaSpace x0) kS
      -- at y=0: Neg gives c/(-0.0) = -inf, exp = 0, L = 0 -- FULL mass;
      -- Sub gives c/(+0.0) = +inf, exp = +inf, L = +inf -- a hard ZERO
      assertBitEq "Sub-version P(y=0) is EXACTLY zero" 0 (prob rowS (is obsSpace 0))
      assertBool "Neg-version P(y=0) is positive" (prob rowN (is obsSpace 0) > 0)
      let hSpace = mkSpace (0 :| [1 :: Int])
          meta0  = fromBits hSpace (const (Bits 1))
          ke     = kernel hSpace obsSpace ([rowN, rowS] !!)
      case cond meta0 (Saw ke 0) of
        Nothing -> assertFailure
          "conditioning on y=0 returned Nothing (h_neg holds positive mass there)"
        Just m  -> do
          assertBitEq "P(h_neg | y=0) is EXACTLY 1" 1 (prob m (is hSpace 0))
          assertBitEq "P(h_sub | y=0) is EXACTLY 0" 0 (prob m (is hSpace 1))
  ]
