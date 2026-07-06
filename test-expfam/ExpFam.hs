{-# LANGUAGE DataKinds #-}

-- | The expfam increment oracle (EXPFAM_PLAN Task 1; the canonized
-- increment protocol, CLAUDE.md). Written RUNTIME-red against the
-- Task-1 type-surface stubs; FROZEN after author review under the
-- extended MANIFEST.sha256 (author pack §5); from that signing, any
-- diff under test-expfam/ is a protocol violation.
--
-- Red drivers and pins (plan red/green split): groups 1 (carrier
-- basics, red via the carrierSpace stub), 2 (prices), 3 (generic
-- semantics), 4 (name semantics and rendering), 5 (expansion
-- agreement — CL-4 for the basis), 6 (sufficiency) are red until
-- Tasks 3–5 land; group 7 (float guardians on today's emission path)
-- and group 8 (raises-by-type rows against the stub flags) are pins,
-- green from the start, protecting anchor byte-stability through the
-- re-derivation.
--
-- Tolerances (plan E12; part of the oracle, never widened in place):
-- cross-path extensional properties 1e-9 relative in the frozen CL-4
-- formula shape; closed-form float pins 1e-12 relative; price pins
-- 1e-12 absolute. One plan deviation, flagged for the Task 2 review:
-- the plan sketched the emit-vs-name pin as exact (==), but emit's
-- rows are only publicly readable through 'push', whose
-- renormalization adds ulps over the name's direct construction — the
-- pin is 1e-12 relative (the cross-path convention), not (==).
module Main (main) where

import Data.List (elemIndex)
import Data.List.NonEmpty (NonEmpty ((:|)))
import qualified Data.List.NonEmpty as NE
import Data.Maybe (fromMaybe)
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
main = defaultMain $ testGroup "proplang expfam basis (increment oracle)"
  [ groupCarrier
  , groupPrices
  , groupGeneric
  , groupName
  , groupExpansion
  , groupSufficiency
  , groupGuardian
  , groupAblation
  ]

lg :: Double -> Double
lg = logBase 2

-- the local fixture grid (the hygiene g4 precedent): four points, so a
-- constant mention costs 2 bits and index 1 evaluates to 0.4
g4 :: Grid
g4 = mkGrid "g4" (0.2 :| [0.4, 0.6, 0.8])

-- a local two-point carrier, independent of the domain declaration
c2 :: Carrier Int
c2 = mkCarrier "c2" (0 :| [1])

-- the sufficiency discriminator (Task-1 oracle review): a 3-point
-- carrier, where distinct multisets can share (n, sum T) — the
-- property that cannot be faked by mere order-invariance
c3 :: Carrier Int
c3 = mkCarrier "c3" (0 :| [1, 2])

assertBits :: String -> Double -> Bits -> Assertion
assertBits name expected (Bits actual) =
  assertBool (name ++ ": expected " ++ show expected ++ " bits, got "
              ++ show actual)
             (abs (actual - expected) <= 1e-12)

-- closed-form float pin at 1e-12 RELATIVE (plan E12)
assertRel :: String -> Double -> Double -> Assertion
assertRel name expected actual =
  assertBool (name ++ ": expected " ++ show expected ++ " (rel 1e-12), got "
              ++ show actual)
             (abs (actual - expected) <= 1e-12 * abs expected)

-- the frozen CL-4 tolerance shape, for cross-path properties
agrees :: Double -> Double -> Bool
agrees lhs rhs = abs (lhs - rhs) <= 1e-9 * (1 + abs rhs)

-- | The generic family belief at a natural parameter, read through the
-- public surface only: build the family kernel over a domain
-- containing eta, then apply it by pushing the point mass at eta.
genericAt :: Double -> Belief Obs
genericAt eta =
  let sp = mkSpace (eta :| [])
      k = evalx (ExpFam sp obsCarrier SId :: Expr '[] (K Double Obs))
                (mkEnv [] VNil)
  in push (point sp eta) k

-- | The derived name's belief at theta, through the real grammar: the
-- parameter enters as a priced constant of a one-point grid.
nameAt :: Double -> Belief Obs
nameAt th =
  let g = mkGrid "th" (th :| [])
  in case mkC g 0 :: Maybe (Expr '[] Double) of
       Just p  -> evalx (Call (Bern obsCarrier) (p :* ANil)) (mkEnv [] VNil)
       Nothing -> error "mkC rejected index 0 of a one-point grid"

-- ---------------------------------------------------------------------
-- group 1: Carrier — a declared finite output space (plan Q1/E4)
-- ---------------------------------------------------------------------

groupCarrier :: TestTree
groupCarrier = testGroup "Carrier (declared finite output space, plan Q1/E4)"
  [ testCase "mkCarrier carries its name" $
      carrierName c2 @?= "c2"
  , testCase "mkCarrier carries its size" $
      carrierSize c2 @?= 2
  , testCase "obsCarrier is the declared demonstration carrier" $ do
      carrierName obsCarrier @?= "obs"
      carrierSize obsCarrier @?= 2
  , testCase "carrierSpace round-trips through the public surface" $
      mapM_ (\(_, p) -> assertRel "uniform mass over a 2-point carrier" 0.5 p)
            (top (uniform (carrierSpace c2)) 2)
  ]

-- ---------------------------------------------------------------------
-- group 2: prices — sort-local coding (plan E2; author pack §1 table)
-- ---------------------------------------------------------------------

groupPrices :: TestTree
groupPrices = testGroup "prices (sort-local coding, plan E2)"
  [ testCase "the family node prices at 0 bits (every choice forced)" $
      let sp = mkSpace (0.5 :| []) :: Space Double
      in assertBits "ExpFam node"
           0 (bits (ExpFam sp obsCarrier SId :: Expr '[] (K Double Obs)))
  , testCase "Call (Bern _) prices node + stdname choice of 6 + param" $
      case mkC g4 1 :: Maybe (Expr '[] Double) of
        Just p  -> assertBits "call bern"
                     (lg 10 + lg 6 + (lg 10 + lg 4))
                     (bits (Call (Bern obsCarrier) (p :* ANil)))
        Nothing -> assertFailure "mkC rejected an in-range index"
  ]

-- ---------------------------------------------------------------------
-- group 3: generic semantics — normalized exp over the carrier (Q1)
-- ---------------------------------------------------------------------

groupGeneric :: TestTree
groupGeneric = testGroup "generic expfam semantics (normalized exp, plan Q1)"
  [ testCase "p(1) = e^eta / (1 + e^eta) at eta in {-2, 0, 3}" $
      mapM_ checkEta [-2, 0, 3]
  , testProperty "masses normalize to 1" propNorm
  , testProperty "p(1) is strictly monotone in eta" propMono
  ]
  where
    checkEta eta =
      assertRel ("p(1) at eta=" ++ show eta)
                (exp eta / (1 + exp eta))
                (prob (genericAt eta) (is obsSpace 1))

propNorm :: Property
propNorm =
  forAll (choose (-6, 6)) $ \eta ->
    let totalMass = sum (map snd (top (genericAt eta) 2))
    in counterexample ("total mass " ++ show totalMass)
         (abs (totalMass - 1) <= 1e-12)

propMono :: Property
propMono =
  forAll (choose (-6, 5)) $ \eta ->
  forAll (choose (0.1, 1)) $ \d ->
    let p1 = prob (genericAt eta) (is obsSpace 1)
        p2 = prob (genericAt (eta + d)) (is obsSpace 1)
    in counterexample (show p1 ++ " >= " ++ show p2) (p1 < p2)

-- ---------------------------------------------------------------------
-- group 4: the derived name — semantics and rendering (plan E6/E7)
-- ---------------------------------------------------------------------

groupName :: TestTree
groupName = testGroup "the derived name bern (plan E6/E7)"
  [ testCase "renderExpr pins the family node string" $
      let sp = mkSpace (0.5 :| []) :: Space Double
      in renderExpr (ExpFam sp obsCarrier SId :: Expr '[] (K Double Obs))
           @?= "('expfam', 'obs', 'id')"
  , testCase "renderExpr pins the called name" $
      case mkC g4 1 :: Maybe (Expr '[] Double) of
        Just p  -> renderExpr (Call (Bern obsCarrier) (p :* ANil))
                     @?= "('call', 'bern', ('c', 'g4', 1))"
        Nothing -> assertFailure "mkC rejected an in-range index"
  , testCase "the name's masses are (1-theta, theta) at theta = 0.4" $ do
      let b = nameAt 0.4
      assertRel "p(0)" 0.6 (prob b (is obsSpace 0))
      assertRel "p(1)" 0.4 (prob b (is obsSpace 1))
  , testCase "emit's rows equal the name's beliefs, theta point by point" $
      mapM_ (\th -> do
               let bE = push (point thetaSpace th) emit
                   bN = nameAt th
               assertRel ("p(1) emit-vs-name at theta=" ++ show th)
                         (prob bE (is obsSpace 1)) (prob bN (is obsSpace 1))
               assertRel ("p(0) emit-vs-name at theta=" ++ show th)
                         (prob bE (is obsSpace 0)) (prob bN (is obsSpace 0)))
            [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
  ]

-- ---------------------------------------------------------------------
-- group 5: expansion agreement — CL-4 for the basis (plan E7): the
-- executed fast form is legal iff extensionally equal to the generic
-- family at eta = logit theta, enforced here, not trusted
-- ---------------------------------------------------------------------

groupExpansion :: TestTree
groupExpansion = testGroup "expansion agreement (CL-4 for the basis, plan E7)"
  [ testProperty "fast form at theta == generic family at logit theta"
      propExpansion
  ]

propExpansion :: Property
propExpansion =
  forAll (choose (0.05, 0.95)) $ \th ->
    let eta = log (th / (1 - th))
        gen = genericAt eta
        fast = nameAt th
        check y = agrees (prob fast (is obsSpace y)) (prob gen (is obsSpace y))
    in counterexample
         ("theta=" ++ show th ++ ": fast (" ++ show (prob fast (is obsSpace 1))
          ++ ") vs generic (" ++ show (prob gen (is obsSpace 1)) ++ ")")
         (check 0 && check 1)

-- ---------------------------------------------------------------------
-- group 6: sufficiency — the posterior over an expfam family depends on
-- a batch only through (n, sum T(y)) (plan E8): the entire semantic
-- content of any future conjugate fast path, landed as oracle before
-- such a path exists.
--
-- As revised at the Task-1 oracle review: on a binary carrier, equal
-- (n, sum T) forces a permutation, and order-invariance of an iid cond
-- fold holds for EVERY kernel — vacuous as a license. The license
-- rests on the 3-point carrier, where distinct multisets share the
-- statistic ([0,2] vs [1,1]: equal n=2, sum T=2, different data) and
-- agreement holds BECAUSE the family is exponential. The binary
-- property is kept, labeled as the permutation case it is.
-- ---------------------------------------------------------------------

groupSufficiency :: TestTree
groupSufficiency = testGroup "sufficiency (the fast path's license, plan E8)"
  [ testCase "the minimal discriminating pair: [0,2] vs [1,1] on c3"
      minimalPair
  , testProperty
      "equal (n, sum T), distinct multisets on c3: equal posteriors"
      propSufficiency3
  , testProperty
      "equal (n, sum T) batches on the binary carrier (permutation case)"
      propSufficiency
  ]

-- the shared harness: prior over an eta grid, generic family kernel
-- over the given carrier, cond folded over each batch, posteriors
-- compared through expect at the cross-path tolerance
sufficiencyCase :: Carrier Int -> [Double] -> [Double] -> [Double]
                -> [Int] -> [Int] -> Property
sufficiencyCase car etas pb fv ys1 ys2 =
  let sp = mkSpace (NE.fromList etas)
      k = evalx (ExpFam sp car SId :: Expr '[] (K Double Int))
                (mkEnv [] VNil)
      idx x = fromMaybe 0 (elemIndex x etas)
      b0 = fromBits sp (\x -> Bits (pb !! idx x))
      condFold = foldl (\mb y -> mb >>= \b -> cond b (Saw k y)) . Just
      f x = fv !! idx x
  in case (condFold b0 ys1, condFold b0 ys2) of
       (Just b1, Just b2) ->
         let lhs = expect b1 f
             rhs = expect b2 f
         in counterexample ("posteriors: " ++ show lhs ++ " vs " ++ show rhs)
              (agrees lhs rhs)
       _ -> counterexample
              "cond returned Nothing on full-support expfam evidence" False

minimalPair :: Assertion
minimalPair = do
  let etas = [-1, 0.5, 2]
      sp = mkSpace (NE.fromList etas)
      k = evalx (ExpFam sp c3 SId :: Expr '[] (K Double Int))
                (mkEnv [] VNil)
      idx x = fromMaybe 0 (elemIndex x etas)
      b0 = fromBits sp (\x -> Bits (1 + fromIntegral (idx x)))
      condFold = foldl (\mb y -> mb >>= \b -> cond b (Saw k y)) . Just
  case (condFold b0 [0, 2 :: Int], condFold b0 [1, 1]) of
    (Just b1, Just b2) ->
      let lhs = expect b1 id
          rhs = expect b2 id
      in assertBool ("posterior means: " ++ show lhs ++ " vs " ++ show rhs)
           (agrees lhs rhs)
    _ -> assertFailure "cond returned Nothing on full-support expfam evidence"

propSufficiency3 :: Property
propSufficiency3 =
  forAll (chooseInt (2, 5)) $ \n ->
  forAll (choose (-3, 0)) $ \e0 ->
  forAll (vectorOf (n - 1) (choose (0.1, 2))) $ \ds ->
  forAll (vectorOf n (choose (0, 8))) $ \pb ->
  forAll (chooseInt (1, 3)) $ \n0 ->
  forAll (chooseInt (0, 3)) $ \n1 ->
  forAll (chooseInt (1, 3)) $ \n2 ->
  forAll (vectorOf n (choose (-10, 10))) $ \fv ->
    let etas = scanl (+) e0 ds        -- n distinct ascending parameters
        -- distinct multisets, equal (n, sum T): one {0,2} pair traded
        -- for {1,1} (n0, n2 >= 1 by construction)
        ys1 = replicate n0 0 ++ replicate n1 1 ++ replicate n2 (2 :: Int)
        ys2 = replicate (n0 - 1) 0 ++ replicate (n1 + 2) 1
                ++ replicate (n2 - 1) 2
    in sufficiencyCase c3 etas pb fv ys1 ys2

propSufficiency :: Property
propSufficiency =
  forAll (chooseInt (2, 5)) $ \n ->
  forAll (choose (-3, 0)) $ \e0 ->
  forAll (vectorOf (n - 1) (choose (0.1, 2))) $ \ds ->
  forAll (vectorOf n (choose (0, 8))) $ \pb ->
  forAll (chooseInt (2, 6)) $ \len ->
  forAll (chooseInt (0, 6)) $ \sRaw ->
  forAll (vectorOf n (choose (-10, 10))) $ \fv ->
    let etas = scanl (+) e0 ds
        s = sRaw `mod` (len + 1)
        ys1 = replicate s 1 ++ replicate (len - s) (0 :: Int)
        ys2 = reverse ys1             -- same length, same sum T
    in sufficiencyCase c2 etas pb fv ys1 ys2

-- ---------------------------------------------------------------------
-- group 7: float guardians (plan group 7; GREEN from the start): the
-- executed emission path's masses, pinned against today's code and
-- held through the Task 5 rewiring — any drift fails here before it
-- can reach a 1e-4 acceptance anchor
-- ---------------------------------------------------------------------

groupGuardian :: TestTree
groupGuardian = testGroup "float guardians (green from the start)"
  [ testCase "emit's masses are (1-theta, theta) at every theta point" $
      mapM_ checkTheta [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9]
  ]
  where
    checkTheta th = do
      let b = push (point thetaSpace th) emit
      assertRel ("p(1) at theta=" ++ show th) th (prob b (is obsSpace 1))
      assertRel ("p(0) at theta=" ++ show th) (1 - th) (prob b (is obsSpace 0))

-- ---------------------------------------------------------------------
-- group 8: deletion rows (plan E9; raises-by-type): audit/ablation.sh
-- is frozen and cannot gain rows, so the increment carries its own
-- runner, invoked here exactly as the frozen test 4 invokes the frozen
-- one
-- ---------------------------------------------------------------------

groupAblation :: TestTree
groupAblation = testGroup "expfam deletion rows (raises-by-type, plan E9)"
  [ ablationRow "expfam"
  , ablationRow "sid"
  , ablationRow "bern"
  , ablationRow "carrier-obs"
  ]

ablationRow :: String -> TestTree
ablationRow row = testCase ("deletion row '" ++ row ++ "'") $ do
  (rc, out, err) <- readProcessWithExitCode
                      "sh" ["test-expfam/ablation.sh", row] ""
  assertEqual ("deletion row '" ++ row ++ "':\n" ++ out ++ err)
              ExitSuccess rc
