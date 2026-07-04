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
module Main (main) where

import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import Data.Maybe (isJust)
import System.Exit (ExitCode (..))
import System.Process (readProcessWithExitCode)
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
  , groupFn
  , groupAblation
  ]

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
      let ms = enumerateModels allTerminals
          n = length ms
          z = sum [ 2 ** negate (dlOf i) | i <- [0 .. n - 1] ]
          expected i = 2 ** negate (dlOf i) / z
      n @?= 1169
      mapM_ (\(i, p) ->
               assertBool ("prior mass of model " ++ show i
                           ++ ": expected " ++ show (expected i)
                           ++ ", got " ++ show p)
                          (abs (p - expected i) <= 1e-12 * expected i))
            (top (agentMeta (mkAgent ms)) n)
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

groupBits :: TestTree
groupBits = testGroup "policy prices (amended spec S3; plan R5 as corrected)"
  [ testCase "Get pays its node cost (one feature name: names free)" $
      assertBits "Get" (lg 10) (bits (Get "t" :: Expr '[] Double))
  , testCase "a constant pays node + grid index" $
      case mkC g4 0 :: Maybe (Expr '[] Double) of
        Just e  -> assertBits "mkC-sentence" (lg 10 + lg 4) (bits e)
        Nothing -> assertFailure "mkC rejected an in-range index"
  , testCase "argmax over a variable menu: three nodes, scope-1 name free" $
      assertBits "Argmax(Var,Get)" (3 * lg 10)
        (bits (Argmax (Var Z) (Get "t") :: Expr '[NonEmpty Double] Double))
  , testCase "the inner variable pays its scope" $
      assertBits "Argmax(Var,Var)" (3 * lg 10 + 1)
        (bits (Argmax (Var Z) (Var Z) :: Expr '[NonEmpty Double] Double))
  , testCase "Expect pays node + child + FN choice bit (FnInd)" $
      assertBits "Expect/FnInd" (2 * lg 10 + 1)
        (bits (Expect (Var Z) (FnInd (is obsSpace 1))
               :: Expr '[B Obs] Double))
  , testCase "Expect pays node + child + FN choice bit (FnUtil)" $
      assertBits "Expect/FnUtil" (2 * lg 10 + 1)
        (bits (Expect (Var Z) (FnUtil constStake ())
               :: Expr '[B Obs] Double))
  ]
  where
    constStake = mkUtil (\() y -> fromIntegral (y :: Obs))

-- ---------------------------------------------------------------------
-- group 4: Fn semantics — the two published expansions, extensionally
-- (both sides are the identical arithmetic path, so equality is exact)
-- ---------------------------------------------------------------------

groupFn :: TestTree
groupFn = testGroup "Fn semantics (the reported alphabet, plan Q1)"
  [ testProperty "Expect b (FnInd e) is prob b e" propFnInd
  , testProperty "Expect b (FnUtil u o) is expect b (applyUtil u o)"
      propFnUtil
  ]

propFnInd :: Property
propFnInd =
  forAll (chooseInt (2, 6)) $ \n ->
  forAll (vectorOf n (choose (0, 8))) $ \pb ->
  forAll (sublistOf [0 .. n - 1]) $ \sub ->
    let sp = mkSpace (NE.fromList [0 .. n - 1])
        b = fromBits sp (\x -> Bits (pb !! x))
        e = event sp (`elem` sub)
    in evalx (Expect (Var Z) (FnInd e)) (mkEnv [] (b :. VNil))
         == prob b e

propFnUtil :: Property
propFnUtil =
  forAll (chooseInt (2, 6)) $ \n ->
  forAll (vectorOf n (choose (0, 8))) $ \pb ->
  forAll (vectorOf n (choose (-10, 10))) $ \uv ->
    let sp = mkSpace (NE.fromList [0 .. n - 1])
        b = fromBits sp (\x -> Bits (pb !! x))
        u = mkUtil (\() y -> uv !! y)
    in evalx (Expect (Var Z) (FnUtil u ())) (mkEnv [] (b :. VNil))
         == expect b (applyUtil u ())

-- ---------------------------------------------------------------------
-- group 5: Fn deletion is raises-by-type (plan R6): audit/ablation.sh
-- is frozen and cannot gain rows, so the increment carries its own
-- runner, invoked here exactly as frozen test 4 invokes the frozen one
-- ---------------------------------------------------------------------

groupAblation :: TestTree
groupAblation = testGroup "Fn deletion rows (raises-by-type, plan R6)"
  [ ablationRow "fnind"
  , ablationRow "fnutil"
  ]

ablationRow :: String -> TestTree
ablationRow row = testCase ("deletion row '" ++ row ++ "'") $ do
  (rc, out, err) <- readProcessWithExitCode
                      "sh" ["test-hygiene/ablation.sh", row] ""
  assertEqual ("deletion row '" ++ row ++ "':\n" ++ out ++ err)
              ExitSuccess rc
