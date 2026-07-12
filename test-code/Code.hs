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
-- Test names are ASCII-only (the membrane's locale incident, 2026-07-05).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import Data.Word (Word64)
import GHC.Float (castDoubleToWord64)
import Test.Tasty
import Test.Tasty.HUnit

import PropLang.Belief (Bits (..), Kernel, Space, is, point, prob, push)
import PropLang.Enumerate
  (Obs, emit, obsCarrier, obsSpace, rhoPoints, thetaPoints, thetaSpace, walkOn)
import PropLang.Eval (Vals (..), evalx, mkEnv)
import PropLang.Syntax
  ( Args (..), Expr (..), Grid, Idx (..), K, Stats (..), StdName (..)
  , bits, carrierSpace, mkC, mkCarrier, mkGrid )

main :: IO ()
main = defaultMain $ testGroup "test-code (step 1: the likelihood is a code)"
  [ gWalk        -- THE FALSIFIER
  , gBern
  , gExpFam
  , gReaders     -- Pos vs ToR: the sec 5d defect, pinned as a regression
  , gArith
  , gPrices
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

evalObs :: Expr '[Obs] t -> Obs -> t
evalObs e o = evalx e (mkEnv [] (o :. VNil))

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

rhoGrid, thetaGrid, etaGrid :: Grid
rhoGrid   = mkGrid "rho" rhoPoints
thetaGrid = mkGrid "theta" thetaPoints
etaGrid   = mkGrid "eta" (NE.map logit thetaPoints)

logit :: Double -> Double
logit t = log (t / (1 - t))

-- equality in the grammar: IsEq is the option-dispatch StdName, and it is
-- what walkOn's `j == i` actually is
eqE :: Eq a => Expr env a -> Expr env a -> Expr env Bool
eqE a b = Call IsEq (a :* b :* ANil)

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

codeWalk :: Int -> Expr env (K Double Double)
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
              ++ " reproduces walkOn BIT-FOR-BIT (81 cells)") $
      assertKernelBitEq ("walk rho=" ++ show (NE.toList rhoPoints !! ix))
        thetaSpace (NE.toList thetaPoints)
        (walkOn thetaSpace thetaPoints (NE.toList rhoPoints !! ix))
        (eval0 (codeWalk ix))
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
          coded  = push (point thetaSpace th) (eval0 (codeBernV ix))
      mapM_ (\o -> assertBitEq ("P(" ++ show o ++ ") at theta=" ++ show th)
                     (prob frozen (is obsSpace o))
                     (prob coded (is obsSpace o)))
            [0, 1 :: Obs]
  | ix <- [0 .. length thetaPoints - 1] ]

-- bern's code, reading the carrier through ToR (its VALUE) -- the obs
-- carrier is {0,1}, so "y == 1" is "ToR y > 0"
codeBernV :: Int -> Expr env (K Double Obs)
codeBernV thIx = Code thetaSpace obsSpace body
  where
    th = cAt thetaGrid thIx
    y :: Expr (Obs ': Double ': env) Double
    y = ToR (Var Z)
    p = If (Gt y k0) th (Sub k1 th)
    body = Neg (Div (Log p) (Log k2))

-- ---------------------------------------------------------------------
-- GROUP 3 -- expfam as a code, against the FROZEN ExpFam node.
--
-- Eval.hs:116-119:
--     ExpFam sp car st -> kernel sp (carrierSpace car) $ \eta ->
--       fromBits (carrierSpace car)
--         (\y -> Bits (negate (eta * statVal st y) / ln2))
--   with statVal SId = realToFrac (Eval.hs:168) and ln2 = log 2.
--
-- THIS IS THE ROW THAT FORCES `ToR`.  eta * T(y) needs T(y) :: Double, and
-- `Pos` returns a POSITION.  AGENT_PLAN sec 5b claimed Pos subsumed
-- Stats/SId; sec 5d records that it does NOT, and this group is why.
-- ---------------------------------------------------------------------

codeExpFam :: Int -> Expr env (K Double Obs)
codeExpFam etaIx = Code thetaSpace obsSpace body
  where
    eta = cAt etaGrid etaIx
    y :: Expr (Obs ': Double ': env) Double
    y = ToR (Var Z)                        -- <-- the VALUE reader, forced
    body = Div (Neg (Mul eta y)) (Log k2)

frozenExpFam :: Expr env (K Double Obs)
frozenExpFam = ExpFam thetaSpace obsCarrier SId

gExpFam :: TestTree
gExpFam = testGroup "group 3: expfam IS a code (vs the frozen ExpFam node)"
  [ testCase ("expfam at eta index " ++ show ix ++ " matches ExpFam BIT-FOR-BIT") $ do
      let eta    = logit (NE.toList thetaPoints !! ix)
          frozen = push (point thetaSpace eta) (eval0 frozenExpFam)
          coded  = push (point thetaSpace eta) (eval0 (codeExpFam ix))
      mapM_ (\o -> assertBitEq ("P(" ++ show o ++ ") at eta=" ++ show eta)
                     (prob frozen (is obsSpace o))
                     (prob coded (is obsSpace o)))
            [0, 1 :: Obs]
  | ix <- [0 .. length thetaPoints - 1] ]

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
-- GROUP 6 -- the alphabet's new prices.
--
-- P5's single-site alphabet constant (Syntax.hs:355-361): a count change
-- edits exactly `prodTable` PLUS the enumerated frozen pins of the changed
-- sort -- "the P5 forward ruling's MANDATORY BOUNDARY ITEM".  This group is
-- that enumeration for step 1.
--
--   prodExpr 10 -> 19   (Pos, ToR, Add, Sub, Mul, Div, Log, Exp, Neg)
--   prodKer   1 ->  2   (Code, BESIDE ExpFam -- step 1 is ADDITIVE)
--
-- These are the ADDITIVE step-1 counts, NOT AGENT_PLAN sec 5b's end state
-- (EXPR 21 / KER 1), which is reached only after the deletions of steps 3
-- and 9.  Recording the difference here is deliberate: an intermediate
-- alphabet is still an alphabet, and it still IS the prior.
-- ---------------------------------------------------------------------

lg :: Int -> Double
lg n = logBase 2 (fromIntegral n)

unBits :: Bits -> Double
unBits (Bits b) = b

gPrices :: TestTree
gPrices = testGroup "group 6: the new prices (P5 mandatory boundary item)"
  [ testCase "nodeB moves lg 10 -> lg 19 (nine new EXPR productions)" $
      assertBitEq "Get" (lg 19) (unBits (bits (Get "t" :: Expr '[] Double)))
  , testCase "a binary arithmetic node costs nodeB + its two subterms" $
      assertBitEq "Add(Get,Get)" (3 * lg 19)
        (unBits (bits (Add (Get "t") (Get "x") :: Expr '[] Double)))
  , testCase "a unary arithmetic node costs nodeB + its subterm" $
      assertBitEq "Neg(Get)" (2 * lg 19)
        (unBits (bits (Neg (Get "t") :: Expr '[] Double)))
  , testCase "Pos costs nodeB + its subterm (the Space payload prices 0)" $
      assertBitEq "Pos(Get)" (2 * lg 19)
        (unBits (bits (Pos thetaSpace (Get "t") :: Expr '[] Double)))
  , testCase "ToR costs nodeB + its subterm" $
      assertBitEq "ToR(Get)" (2 * lg 19)
        (unBits (bits (ToR (Get "t") :: Expr '[] Double)))
  , testCase "kerB moves lg 1 -> lg 2 (Code joins ExpFam in the KER sort)" $
      -- Code prices as kerB + its body, in the body's OWN two-binder scope
      -- (Code binds y and x, so the body prices at scope + 2 -- the Argmax
      -- binder discipline, twice).  Body = Var Z at scope 2 => nodeB + lg 2.
      assertBitEq "Code(Var Z)" (lg 2 + (lg 19 + lg 2))
        (unBits (bits (Code thetaSpace thetaSpace (Var Z)
                         :: Expr '[] (K Double Double))))
  ]
