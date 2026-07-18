{-# LANGUAGE DataKinds #-}

-- | The grammar-hygiene increment oracle (GRAMMAR_HYGIENE_PLAN Task 1;
-- new-test protocol per plan Q2, to be canonized in CLAUDE.md at the
-- Task 2 freeze). Written RUNTIME-red against the Task-1 type-surface
-- stubs, per the Task-0 amendment: a compile-failing oracle proves
-- nothing. FROZEN after author review under the extended
-- MANIFEST.sha256; from that signing, any diff under test-hygiene/ is
-- a protocol violation.
--
-- Red drivers and pins: groups 1 (mkC), 3 (prices), 4 (Fn semantics)
-- are red until Tasks 3–5 land; group 2 (model-dl pins through the
-- public prior) and group 5 (Fn raises-by-type rows) are pins, green
-- from the start, protecting anchor byte-stability (plan R4) and the
-- ablation standard (plan R6) through the refactor.
--
-- THE STEP-3 PORT (delegated freeze edit, sentence-author-pack.md
-- §20.3/§25; the delegation recorded in the freeze commit): group 2's
-- one enumeration call (r0 :94-95, enumerateModels allTerminals under
-- mkAgent) rides the SENTENCE ROUTE — enumerateSentences fragFull
-- under sentenceAgent. The closed-form masses, the population count
-- 1169, and the frozen enumeration order (9 constants, 8 walks, 1152
-- change-points) are UNCHANGED — E-s1 measured the declared table's
-- charges bit-identical to the frozen literals, and the step-3
-- prototype vindicated the full route (pack §§5, 18). The row is
-- runtime-red until the step-3 implementation lands, exactly the
-- increment discipline. STDNAME's 7 -> 6 re-pricing (Bern leaves the
-- stdlib at this boundary) touches NO pin in this file — the sweep
-- was manifest-derived at the freeze: this file's alphabet pins read
-- prodExpr (19, untouched); the three STDNAME-reading pins live in
-- the sayable fixtures (ladder/prepost/cirl), re-priced there under
-- the same delegation (D4: adjudication, never grep).
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import Data.Maybe (isJust)
import Test.Tasty
import Test.Tasty.HUnit
import Test.Tasty.QuickCheck

import PropLang.Belief
import PropLang.Enumerate
import PropLang.Eval
import PropLang.Syntax

main :: IO ()
main = defaultMain $ testGroup "proplang grammar hygiene (increment oracle)"
  [ groupMkC
  , groupDlPins
  , groupBits
  ]
  -- groupFn / groupAblation RETIRED at the step-9 elimination freeze
  -- (D-f10 retire-and-replace; D-f13/§17): the FN sort (FnInd/FnUtil) is
  -- DELETED -- subsumed by the Expect binder (prob b e == Expect b
  -- (indicator), utility-prevision == Expect b (priced body); E-e1b, 42
  -- rows bit-exact). No FN semantics remain to test and no FN choice bit
  -- remains to price. The UseFnInd/UseFnUtil ablation fixtures are
  -- DISCHARGED-PERMANENT (the deletion they proved possible happened).
  -- The census's highest-risk row was here: the FN price rows RE-PRICE
  -- rather than fail, so a mechanical port would silently pin a false
  -- price -- retired, never re-priced.

lg :: Double -> Double
lg = logBase 2

-- the local fixture grid: four points, so a mention costs 2 bits
g4 :: Grid
g4 = mkGrid "g4" (0.2 :| [0.4, 0.6, 0.8])

assertBits :: String -> Double -> Bits -> Assertion
assertBits name expected (Bits actual) =
  assertBool (name ++ ": expected " ++ show expected ++ " bits, got "
              ++ show actual)
             (abs (actual - expected) <= 1e-12)

-- ---------------------------------------------------------------------
-- group 1: mkC — off-grid unconstructible, everything sayable denotes
-- ---------------------------------------------------------------------

groupMkC :: TestTree
groupMkC = testGroup "mkC (amended spec S3: no denoting malformed constants)"
  [ testCase "in-range indices are constructible" $
      assertBool "mkC over [0..3]" (all constructible [0 .. 3])
  , testCase "off-grid indices are unconstructible" $
      assertBool "mkC over [-1, 4, 99]"
                 (all (not . constructible) [-1, 4, 99])
  , testCase "a sayable constant denotes its grid point" $
      fmap eval0 (mkC g4 2 :: Maybe (Expr '[] Double)) @?= Just 0.6
  , testProperty "sayable <=> denoting, over grid sizes and indices"
      propSayable
  ]
  where
    constructible k = isJust (mkC g4 k :: Maybe (Expr '[] Double))
    eval0 e = evalx e (mkEnv [] VNil)

propSayable :: Property
propSayable =
  forAll (chooseInt (1, 8)) $ \n ->
  forAll (chooseInt (-2, 9)) $ \k ->
    let pts = map fromIntegral [1 .. n] :: [Double]
        g = mkGrid "gn" (NE.fromList pts)
    in case mkC g k :: Maybe (Expr '[] Double) of
         Just e  -> k >= 0 && k < n
                      && evalx e (mkEnv [] VNil) == pts !! k
         Nothing -> k < 0 || k >= n

-- ---------------------------------------------------------------------
-- group 2: model-fragment dl PINS, through the public prior (the
-- anchors' guardian: derivation-relative coding, plan R4, must keep
-- these masses byte-stable at 1e-12 relative through Tasks 3-5)
-- ---------------------------------------------------------------------

groupDlPins :: TestTree
groupDlPins = testGroup "model dl pins (derivation-relative, plan R4)"
  [ testCase "the full prior takes exactly the three closed-form masses" $ do
      -- the step-3 port: the same 1169 hypotheses through the sentence
      -- route (enumeration order preserved by the route — the g1 port
      -- vindication); the closed forms below are the frozen quantities
      let ms = enumerateSentences fragFull
          n = length ms
          z = sum [ 2 ** negate (dlOf i) | i <- [0 .. n - 1] ]
          expected i = 2 ** negate (dlOf i) / z
      n @?= 1169
      mapM_ (\(i, p) ->
               assertBool ("prior mass of model " ++ show i
                           ++ ": expected " ++ show (expected i)
                           ++ ", got " ++ show p)
                          (abs (p - expected i) <= 1e-12 * expected i))
            (top (agentMeta (sentenceAgent ms)) n)
  ]
  where
    -- enumeration order is frozen by the reference: 9 bern-constants,
    -- 8 walks, 1152 change-points
    dlOf :: Int -> Double
    dlOf i | i < 9     = 2 + lg 9
           | i < 17    = 4
           | otherwise = 10 + 2 * lg 9

-- ---------------------------------------------------------------------
-- group 3: policy prices (amended spec S3, prefix-decodable: every
-- node pays log2 nExpr, Var included; content on top; nExpr = 10)
-- ---------------------------------------------------------------------

-- EXPR REPRICE (WIDE census, step 9): prodExpr 19 -> 20, so every EXPR
-- node-choice leaf moves lg 19 -> lg 20 (+lg(20/19) = 0.074 bits/node).
-- The FN rows RETIRED (D-f10): with the FN sort gone, Expect prices
-- node + belief-child + body-child (an ordinary EXPR in the extended
-- scope), no FN choice bit -- the row's asserted quantity no longer
-- exists to pin. The retained rows re-price at 20.
groupBits :: TestTree
groupBits = testGroup "policy prices (amended spec S3; plan R5 as corrected; EXPR at 20)"
  [ testCase "Get pays its node cost (one feature name: names free)" $
      assertBits "Get" (lg 20) (bits (Get "t" :: Expr '[] Double))
  , testCase "a constant pays node + grid index" $
      case mkC g4 0 :: Maybe (Expr '[] Double) of
        Just e  -> assertBits "mkC-sentence" (lg 20 + lg 4) (bits e)
        Nothing -> assertFailure "mkC rejected an in-range index"
  , testCase "argmax over a variable menu: three nodes, scope-1 name free" $
      assertBits "Argmax(Var,Get)" (3 * lg 20)
        (bits (Argmax (Var Z) (Get "t") :: Expr '[NonEmpty Double] Double))
  , testCase "the inner variable pays its scope" $
      assertBits "Argmax(Var,Var)" (3 * lg 20 + 1)
        (bits (Argmax (Var Z) (Var Z) :: Expr '[NonEmpty Double] Double))
  ]
